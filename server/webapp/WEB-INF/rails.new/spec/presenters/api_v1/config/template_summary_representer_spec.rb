##########################################################################
# Copyright 2016 ThoughtWorks, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
##########################################################################

require 'spec_helper'

describe ApiV1::Config::TemplateSummaryRepresenter do

  it 'should render a template name and its associated pipelines in hal representation' do
    template_with_pipelines = ['template-name', ['pipeline1', 'pipeline2']]
    actual_json = ApiV1::Config::TemplateSummaryRepresenter.new(template_with_pipelines).to_hash(url_builder: UrlBuilder.new)

    expect(actual_json).to have_links(:self, :doc, :find)
    expect(actual_json).to have_link(:self).with_url('http://test.host/api/admin/templates/template-name')
    expect(actual_json).to have_link(:doc).with_url('https://api.go.cd/#template-config')
    expect(actual_json).to have_link(:find).with_url('http://test.host/api/admin/templates/:template_name')
    actual_json.delete(:_links)
    expect(actual_json).to eq(index_hash)
  end

  private
  def index_hash
    {
        name: 'template-name',
        pipelines: [
            {
                _links: {
                    self: {
                        :href => "http://test.host/api/admin/pipelines/pipeline1"
                    },
                    doc: {
                        :href => "https://api.go.cd/#pipeline-config"
                    },
                    find: {
                        :href => "http://test.host/api/admin/pipelines/:pipeline_name"
                    }
                },
                name: "pipeline1"
            },
            {
                _links: {
                    self: {
                        href: "http://test.host/api/admin/pipelines/pipeline2"
                    },
                    doc: {
                        href: "https://api.go.cd/#pipeline-config"
                    },
                    find: {
                        href: "http://test.host/api/admin/pipelines/:pipeline_name"
                    }
                },
                :name => 'pipeline2'
            }
        ]
    }
  end
end
