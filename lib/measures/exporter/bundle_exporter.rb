module Measures
  module Exporter
    class BundleExporter

      attr_accessor :measures
      attr_accessor :config
      attr_accessor :records
      
      DEFAULTS = {"library_path" => "library_functions",
                  "measures_path" => "measures",
                  "sources_path" => "sources",
                  "records_path" => "patients",
                  "results_path" => "results",
                  "valuesets_path" => "value_sets",
                  "base_dir" => "./bundle",
                  "hqmf_path" => "db/measures",
                  "enable_logging" => false,
                  "enable_rationale" =>false,
                  "short_circuit"=>false,
                  "effective_date" => Measure::DEFAULT_EFFECTIVE_DATE,
                  "name" =>"bundle-#{Time.now.to_i}",
                  "check_crosswalk" => false,
                  "use_cms" => false,
                  "export_filter" => ["measures", "sources","records", "valuesets", "results"]}
      BAD_MEASURE_IDS = {'b8970bee-a917-416c-beba-e38a178703bb' => 'DENEXCEP',
                          '43b89365-3cb9-4fad-bab3-5cda934807cc' => 'DENEXCEP',
                          '36f76ed8-36f1-4439-a473-966e8d2b87b3' => 'DENEXCEP',
                          'df5f959c-f5ec-4bf2-aaed-de8dfa7777bd' => 'DENEXCEP',
                          'C9C879B5-35DD-4AF6-992D-87227E8637F1' => 'DENEXCEP',
                          '4e02a62b-e868-4dc9-a8ca-fec2ba3bb84e' => 'DENEXCEP',
                          'b51ad4f1-7c57-401a-b83e-c64ae943df22' => 'DENEXCEP',
                          '70fe32a2-18ca-4243-87f5-bf966c1bd572' => 'DENEXCEP',
                          'd282fb4e-17b8-4cbe-91df-2ef45cde5b3c' => 'DENEXCEP',
                          '5802042b-6e55-41b8-9989-9dc11ff0a255' => 'DENEXCEP',
                          '0E8C682C-C709-45A5-9CFE-6785238AEA78' => 'DENEXCEP',
                          '7220889d-3cfd-4511-a025-656148f619bf' => 'DENEXCEP',
                          'c1376459-3018-423f-971e-fe64b7be6a8f' => 'DENEXCEP',
                          '73522cdb-63f0-4e16-858a-1585dcfea520' => 'DENEXCEP',
                          'af7bdd1e-115c-4e19-a0dc-145ed7089d60' => 'DENEXCEP',
                          'f4e25720-c7b9-46f1-a47c-ef462008796e' => 'DENEXCEP',
                          '0dd7df4c-6476-47f0-8364-987d9fdbe131' => 'DENEXCEP',
                          '051fcdba-62d0-42dc-8702-fce27d114a73' => 'DENEXCEP',
                          '28ed6419-03a7-40e4-ae3a-9bfffef9b548' => 'DENEXCEP',
                          '6036fb7a-9efc-4538-832d-28e106f40560' => 'DENEXCEP',
                          'ae2b8c5e-874d-412b-a5dc-235ed3ca3d8e' => 'DENEXCEP',
                          '093d3d98-ded5-4130-bf02-9badc6b79fa5' => 'DENEXCEP',
                          '15631cf4-0214-4062-bb1c-be7dee147c12' => 'DENEXCEP',
                          'fafbd227-2afa-4676-9398-676bc6b07b47' => 'DENEXCEP',
                          '9a9c0df8-ff14-4dc0-9fb8-6431c143116a' => 'DENEXCEP',
                          'B3308D93-7393-496B-BFDC-5C63FC3D583A' => 'DENEXCEP',
                          'ee16144e-9cb6-4d27-8a30-83772778ff60' => 'DENEXCEP',
                          '7fcc5c24-f717-46e3-a17f-95e5f09d52d1' => 'DENEXCEP',
                          '08818a91-3144-4710-b19c-5065e06de8a0' => 'DENEXCEP',
                          '66a4d2f7-f704-45e4-9b4b-005811f056a6' => 'DENEXCEP',
                          '50c2b271-6191-4490-9e00-3f088dd608af' => 'DENEXCEP',
                          '32a1df69-28af-40c2-996c-8208812f75c1' => 'DENEXCEP',
                          'b960a964-af49-49e1-bf0c-78519f5587e1' => 'DENEXCEP',
                          'da168413-c535-4d7c-83bd-0d7c43a9450a' => 'DENEXCEP',
                          '1bf4ba1e-9897-45c1-8d64-bdfa6dc86174' => 'DENEXCEP',
                          '2c808b42-bf8a-4f4e-8343-fa687a197b77' => 'DENEXCEP',
                          'bcf0315c-b4e6-4180-8718-fb41a7222a92' => 'DENEXCEP',
                          'ae174b6b-66cb-4793-b4e4-3ad201aebfed' => 'DENEXCEP',
                          'D3A511A5-5592-44CE-BD5E-3DA8987016AA' => 'DENEXCEP',
                          '5bf054c2-c4cd-4a5e-8a00-affe5513dd67' => 'DENEXCEP',
                          '5b9d5fe5-ceb0-4e2c-b6fa-3e6ab414c120' => 'DENEXCEP',
                          'c270786e-b14b-46ec-b4b1-61bc1d6f7012' => 'DENEXCEP',
                          '9080bc43-c1b4-4447-8a13-ac454944b0ff' => 'DENEXCEP',
                          '168ece47-2c6e-4baa-91e1-a1d7b5b7968a' => 'DENEXCEP',
                          '0665905f-2e51-4343-aac2-c1c16be5ddea' => 'DENEXCEP',
                          'aa64a3e3-da99-45ba-8d31-03fd5679a66c' => 'DENEXCEP',
                          '3983c340-27ab-43cd-b705-78df5b37f6f5' => 'DENEXCEP',
                          'd49bac30-7b89-427b-845f-de224744e082' => 'DENEXCEP',
                          'a96b24b9-272a-4e6f-9ba3-0cd16dd75549' => 'DENEXCEP',
                          '440a1b63-6e67-46b3-a856-7b9403a68ed5' => 'DENEXCEP',
                          'd26060dd-caf6-4ff9-882a-4f53d6ee6ef8' => 'DENEXCEP',
                          'e5e93614-82fa-4529-9ea9-8a21a346a222' => 'DENEXCEP',
                          'f280d8a1-3983-4e95-8a4b-46e40cd1af36' => 'DENEXCEP',
                          '2dfecfec-a09f-4240-8e6c-352f47947b5b' => 'DENEXCEP',
                          '172d5fe2-4403-44c4-9bc5-537b3614ea09' => 'DENEXCEP',
                          '9fd52e59-68e3-43cb-b983-2339a1419414' => 'DENEXCEP',
                          '2859d097-691a-46ac-a490-16fa0c2cd269' => 'DENEXCEP',
                          'b6d2eca0-b127-4e01-9bd2-40c30568df13' => 'DENEXCEP',
                          '43141df9-7f4d-454b-9303-065239f2b034' => 'DENEXCEP',
                          'abb0dcab-3343-4a0f-8313-daa247db93ae' => 'DENEXCEP_1',
                          '28371d41-4793-4048-8a62-978a92db2d92' => 'DENEXCEP_1',
                          'a68d436c-6cfd-4816-8ca5-cd29cd2ac26e' => 'DENEXCEP_1',
                          'a6045b0e-ad25-478c-8a3a-480a6fc3abdb' => 'DENEXCEP_1',
                          'a752f79d-62bc-4f1f-85aa-a09e7c9bcb3c' => 'DENEXCEP_1',
                          'e38b9db8-d04a-4733-aedb-f726b5a966ea' => 'DENEXCEP_1',
                          '45ee0e6c-c473-4d7f-9c94-9b2a44a196a2' => 'DENEXCEP_1',
                          'ebdcd25c-8315-43d2-a0c4-bfea4def31f2' => 'DENEXCEP_1',
                          '7ec4b396-178a-47c8-a95b-0fb7a4966a84' => 'DENEXCEP_1',
                          'b6acb7ba-f362-442c-882f-a17e20a8fbd9' => 'DENEXCEP_1',
                          '767f96a9-b6bf-455a-b702-edffba05b2ee' => 'DENEXCEP_1',
                          '208b4952-0bb9-4f0f-835a-36d602431884' => 'DENEXCEP_1',
                          '82ffaff4-6c4a-46dd-bc9a-e40f3294f77b' => 'DENEXCEP_2',
                          '14a1bfcf-8e86-450f-aa3b-e1401223dddd' => 'DENEXCEP_2',
                          '09d969d7-75ad-41e2-8fc0-5e382c80c510' => 'DENEXCEP_2',
                          'b55300e6-3b67-4b75-aeac-5aa0c7519859' => 'DENEXCEP_2',
                          'c43402ec-a3b7-4512-bed0-fae657b74812' => 'DENEXCEP_2',
                          '9447654c-da7a-4644-87a4-a72683ac9bf8' => 'DENEXCEP_2',
                          'ef5371c1-bea5-4b6c-83a9-6a5ee522878c' => 'DENEXCEP_3',
                          '3fc19538-0a3e-4455-8191-8d4fcfb1cc99' => 'DENEXCEP_3',
                          '401cedf5-a65d-4837-a3c4-776af1dea3d5' => 'DENEXCEP_4',
                          '7379b91a-ad8a-4645-822a-60d1c6ba0813' => 'DENEXCEP_4',
                          '1cc3f818-928d-4c32-8a5b-2c77bc39577e' => 'DENEXCEP_5',
                          'ebf7e9d5-09a4-4922-acaa-8f38727a44c1' => 'DENEXCEP_5',
                          '7ab2f4e4-2758-41d4-aa16-2db3007dafa5' => 'DENEXCEP_6',
                          '9d6c2d57-4f76-4764-93ff-fdd31455b8a2' => 'DENEXCEP_6',
                          '0d24c611-cdc8-4705-8dbf-3cd2fa5687a2' => 'DENEXCEP_7',
                          '445eb90f-fb8a-4cef-8c0d-91b2ec5ed8a8' => 'DENEXCEP_7',
                          '2a184a5f-46eb-4c00-a221-933d5b35ad88' => 'DENEX',
                          '545394c2-6763-42a4-b0e7-9de6faecaa88' => 'DENEX',
                          'ee57c5e9-3cfb-4664-ab4c-ec251578f715' => 'DENEX',
                          'bcf51a74-ecff-477d-a6f8-998ba306436e' => 'DENEX',
                          'e79c3765-1aa8-4ec9-a105-957b036dbc2a' => 'DENEX',
                          '47c728a1-247f-43db-b188-115f736db26a' => 'DENEX',
                          '6b9373bb-13da-48d2-bac8-dd64e9fbd9f5' => 'DENEX',
                          '4a395b1a-5ffa-421f-bfa3-250e0ce7d5b4' => 'DENEX',
                          '0430103e-ce23-4b20-841f-295a5a96c947' => 'DENEX',
                          '86061DE7-0EE3-42C7-B6D1-6CE319D23ED6' => 'DENEX',
                          'ffd001c6-d309-4869-8e43-0195fe2454d4' => 'DENEX',
                          'c68e8a39-c052-454e-a3e2-3c8acf1a9bed' => 'DENEX',
                          'fc49536d-33c5-4856-8719-166419d26637' => 'DENEX',
                          'daae1d5b-05a7-4d98-8065-806b4b8d5c4e' => 'DENEX',
                          '68fe9c21-0bb3-4249-941a-8f140266d5f2' => 'DENEX',
                          '430a9f24-1156-4ee9-b910-d00ff64b3ad2' => 'DENEX',
                          'f8533dd1-a2e2-4329-ab2f-968c387b7695' => 'DENEX',
                          'EECCBAC3-6F9C-496A-8305-BF8861A1BAC8' => 'DENEX',
                          'F3EA47DD-70D7-4F9B-A994-6A2098D9EAB9' => 'DENEX',
                          '1581950d-4ba8-4274-9906-7363148e7c72' => 'DENEX',
                          '8762ae97-a108-4678-a324-c3098b070fb8' => 'DENEX',
                          '60f909da-0f19-47ae-b473-26815fb6163f' => 'DENEX',
                          'e45633c5-6cf2-47a4-b0d1-de97eaa9d122' => 'DENEX',
                          'd4784212-0424-4d56-9b24-8cb5cc45904a' => 'DENEX',
                          '3464f47c-2e93-49e5-9e93-a726eac09a68' => 'DENEX',
                          'dfbcbb99-258e-4c6e-a202-21efd223112d' => 'DENEX',
                          '8f75782f-99f2-40c1-b90b-0c5d537340e7' => 'DENEX',
                          '1fb30d11-3988-452d-aeee-477292fdfbb2' => 'DENEX',
                          'c21baba7-bd27-4959-8359-a958420a551a' => 'DENEX',
                          'ce573d20-917a-4363-acb7-d9723432322c' => 'DENEX',
                          '7a604dc7-79c4-4140-b0c2-1c94dbeb2b7f' => 'DENEX',
                          'b71f28bb-e6e4-4275-a66a-931108d61814' => 'DENEX',
                          'fa62336d-abfc-48a2-8bf6-ce67a762ade6' => 'DENEX',
                          'c2ef62f8-6568-4a2d-946f-607766a39f77' => 'DENEX',
                          '580316d2-d84e-46eb-b852-974dd5e3189f' => 'DENEX',
                          '0a3ac741-4ff5-444a-939b-c61d840b8549' => 'DENEX',
                          '3c74aa4a-6b2b-4cd7-9364-79f0dde7e1ce' => 'DENEX',
                          '1ac71239-c679-427e-8500-6ffb73403726' => 'DENEX',
                          '31e1e47f-21f0-412d-a7b0-ef352ac7c838' => 'DENEX',
                          '1a10cf45-8ad3-47ea-a532-b3b0c5ad4b02' => 'DENEX_1',
                          'a69f8d61-80d8-41e8-8462-5654fffb90b8' => 'DENEX_1',
                          'dd7b74a5-a5fe-48f1-a23d-826505f96e7b' => 'DENEX_1',
                          '8b83ab0d-b1bc-4a62-bf60-c0365bb030f2' => 'DENEX_1',
                          'bcbe1454-1f1e-4d99-bf39-91630a9ad7dc' => 'DENEX_2'}
      
      DEFAULTS.keys.each do |k|
        attr_accessor k.to_sym
      end

      def initialize(user, config={})
        @user = user
        # convert symbol keys to strings
        config = config.inject({}) { |memo,(key,value)| memo[key.to_s] = value; memo}
        @config = DEFAULTS.merge(config)
        @measures = user.measures
        @records = user.records
        DEFAULTS.keys.each do |name|
          instance_variable_set("@#{name}", @config[name])
        end
      end

      def rebuild_measures
        BonnieBundler.logger.info("rebuilding measures")
        HealthDataStandards::CQM::QueryCache.where({}).destroy
        HealthDataStandards::CQM::PatientCache.where({}).destroy
        #clear bundles
        #clear results
        QME::QualityMeasure.where({}).destroy
        dummy_bundle = HealthDataStandards::CQM::Bundle.new(name: "dummy",version: "1", extensions: BundleExporter.refresh_js_libraries(check_crosswalk).keys)
        dummy_bundle.save!
        @measures.each do |mes|
           BonnieBundler.logger.debug("Rebuilding measure #{mes["cms_id"]} -  #{mes["title"]}")
            mes.populations.each_with_index do |population, index|
              measure_json = mes.measure_json(index, check_crosswalk)
              Mongoid.default_session["measures"].insert(measure_json)
            end
           # dummy_bundle.measure_ids << mes.hqmf_id
        end
        dummy_bundle.save!
        #insert all measures
      end

      def calculate  
        BonnieBundler.logger.info("Calculating measures")   
         HealthDataStandards::CQM::Measure.where({:hqmf_id => {"$in" => measures.pluck(:hqmf_id).uniq}}).each do |measure|  
          draft_measure = Measure.where({:hqmf_id => measure.hqmf_id}).first
          oid_dictionary = HQMF2JS::Generator::CodesToJson.from_value_sets(draft_measure.value_sets)
          report = QME::QualityReport.find_or_create(measure.hqmf_id, measure.sub_id, {'effective_date' => effective_date, 'filters' =>nil})
          BonnieBundler.logger.debug("Calculating measure #{measure.cms_id} - #{measure.sub_id}")
          report.calculate({"oid_dictionary" =>oid_dictionary.to_json,
                          'enable_logging' => enable_logging,
                          "enable_rationale" =>enable_rationale,
                          "short_circuit" => short_circuit,
                          "test_id" => nil}, false) unless report.calculated?
        end
      end

      def export
        clear_directories if @config["clear_directories"]

        export_measures if export_filter.index("measures")
        export_sources if export_filter.index("sources")
        export_patients if export_filter.index("records")
        export_results if export_filter.index("results")
        export_valuesets if export_filter.index("valuesets")
        
        if export_filter.index("measures")
          BundleExporter.library_functions.each_pair do |name,data|
            export_file File.join(library_path,"#{name}.js"), data
          end
        end
        export_file "bundle.json", bundle_json.to_json
      end

      # Export an in-memory zip file
      def export_zip
        stringio = Zip::ZipOutputStream::write_buffer do |zip|
          @zip = zip
          export
        end
        @zip = nil
        stringio.rewind
        stringio.sysread
      end

      def export_patients
        BonnieBundler.logger.info("Exporting patients")
        records.each do |patient|

          patient.insurance_providers = [create_default_insurance_provider] if patient.insurance_providers.empty?
          safe_first_name = patient.first.gsub("'", "")
          safe_last_name = patient.last.gsub("'", "")
          filename =  "#{safe_first_name}_#{safe_last_name}"
          BonnieBundler.logger.info("Exporting patient #{filename}")

          validate_expected_values(patient)

          entries = Record::Sections.reduce([]) {|entries, section| entries.concat(patient[section.to_s] || []); entries }

          patient.medical_record_assigner = "2.16.840.1.113883.3.1257"
          
          patient_hash = patient.as_json(except: [ '_id', 'measure_id', 'user_id' ], methods: ['_type'])
          patient_hash['measure_ids'] = patient_hash['measure_ids'].uniq if patient_hash['measure_ids']
          json = JSON.pretty_generate(JSON.parse(patient_hash.remove_nils.to_json))
          patient_type = patient.type || Measure.for_patient(patient).first.try(:type)
          path = File.join(records_path, patient_type.to_s)
          export_file File.join(path, "json", "#{filename}.json"), json
        end
      end
      def create_default_insurance_provider
        ip = InsuranceProvider.new
        ip.codes = {}
        ip.codes['SOP'] = []
        ip.codes['SOP'] << '349'
        ip.name = 'Other'
        ip.type = 'OT'
        ip.payer = Organization.new(name: 'Other')
        ip.financial_responsibility_type = { 'code' => 'SELF', 'codeSystem' => 'HL7 Relationship Code' }
        ip
      end

      def self.randomize_payer(insurance_provider)
        
      end

      def export_results
        BonnieBundler.logger.info("Exporting results")
        results_by_patient = Mongoid.default_session['patient_cache'].find({}).to_a
        results_by_patient = JSON.pretty_generate(JSON.parse(results_by_patient.as_json(:except => [ '_id', 'user_id' ]).to_json))
        results_by_measure = Mongoid.default_session['query_cache'].find({}).to_a
        results_by_measure = JSON.pretty_generate(JSON.parse(results_by_measure.as_json(:except => [ '_id', 'user_id' ]).to_json))
        
        export_file File.join(results_path,"by_patient.json"), results_by_patient
        export_file File.join(results_path,"by_measure.json") ,results_by_measure
      end

      def export_valuesets
        BonnieBundler.logger.info("Exporting valuesets")
        value_sets = measures.map(&:value_set_oids).flatten.uniq
        if config["valueset_sources"]  
          value_sets.each do |oid|
            code_set_file = File.expand_path(File.join(config["valueset_sources"],"#{oid}.xml"))
            if File.exist? code_set_file
              export_file  File.join(valuesets_path, "xml", "#{oid}.xml"), File.read(code_set_file)
            else
              # puts("\tError generating code set for #{oid}")
            end
          end
        end
        HealthDataStandards::SVS::ValueSet.where(oid: {'$in'=>value_sets}, user_id: @user.id).to_a.each do |vs|
          export_file File.join(valuesets_path,"json", "#{vs.oid}.json"), JSON.pretty_generate(vs.as_json(:except => [ '_id', 'user_id' ]), max_nesting: 250)
        end
      end

      def export_measures
        BonnieBundler.logger.info("Exporting measures")
        measures.each do |measure|
          sub_ids = ('a'..'az').to_a
          if @config[measure.hqmf_set_id]
            measure.category = @config[measure.hqmf_set_id]['category']
            measure.measure_id = @config[measure.hqmf_set_id]['nqf_id']
            measure.population_criteria.each do |key, value|
              if BAD_MEASURE_IDS.has_key? value['hqmf_id']
                delete_pop = BAD_MEASURE_IDS[value['hqmf_id']]
                measure.population_criteria.delete(delete_pop)
                measure.populations.each do |measure_population|
                  measure_population.delete_if {|key, value| value == delete_pop } 
                end
              end
            end
          end
          measure.populations.each_with_index do |population, population_index|
            sub_id = sub_ids[population_index] if measure.populations.length > 1
            BonnieBundler.logger.info("Exporting measure #{measure.cms_id} - #{sub_id}")
            measure_json = JSON.pretty_generate(measure.measure_json(population_index), max_nesting: 250)
            filename = "#{(config['use_cms'] ? measure.cms_id : measure.hqmf_id)}#{sub_id}.json"
            export_file File.join(measures_path, measure.type, filename), measure_json
          end

        end
      end

      def export_sources
        source_path = config["hqmf_path"]
        BonnieBundler.logger.info("Exporting sources")
        measures.each do |measure|
          html = File.read(File.expand_path(File.join(source_path, "html", "#{measure.hqmf_id}.html"))) rescue begin BonnieBundler.logger.warn("\tNo source HTML for #{measure.cms_id || measure.measure_id}"); nil end
          hqmf1 = File.read(File.expand_path(File.join(source_path, "hqmf", "#{measure.hqmf_id}.xml"))) rescue begin BonnieBundler.logger.warn("\tNo source HQMFv1 for #{measure.cms_id || measure.measure_id}"); nil end
          hqmf2 = HQMF2::Generator::ModelProcessor.to_hqmf(measure.as_hqmf_model) rescue BonnieBundler.logger.warn("\tError generating HQMFv2 for #{measure.cms_id || measure.measure_id}")
          hqmf_model = JSON.pretty_generate(measure.as_hqmf_model.to_json, max_nesting: 250)
          metadata = JSON.pretty_generate(measure_metadata(measure))

          sources = {}
          path = File.join(sources_path, measure.type, ((config['use_cms'] ? measure.cms_id : measure.hqmf_id)))
          export_file File.join(path, "#{measure.cms_id || measure.measure_id}.html"),html if html
          export_file File.join(path, "hqmf1.xml"), hqmf1 if hqmf1
          export_file File.join(path, "hqmf2.xml"), hqmf2 if hqmf2
          export_file File.join(path, "hqmf_model.json"), hqmf_model
          export_file File.join(path, "measure.metadata"), metadata
        end
      end

      def validate_expected_values(patient)
        sub_ids = ('a'..'az').to_a
        if patient.expected_values
          patient.expected_values.each do |val|
            measure = HealthDataStandards::CQM::Measure.where({hqmf_set_id: val['measure_id']}).first
            unless measure
              BonnieBundler.logger.error("\tMeasure with HQMF Set ID #{val['measure_id']} not found")
              next
            end
            if val['population_index'] > 0
              sub_id = sub_ids[val['population_index']]
            else
              sub_id = nil
            end

            cache = Mongoid.default_session['patient_cache'].where({"value.patient_id" => patient.id, "value.measure_id" => measure.hqmf_id, "value.sub_id" => sub_id}).first
            if !cache && !sub_id
              cache = Mongoid.default_session['patient_cache'].where({"value.patient_id" => patient.id, "value.measure_id" => measure.hqmf_id, "value.sub_id" => 'a'}).first
            end

            if cache
              cache = cache['value']
              val.except('measure_id', 'population_index', 'OBSERV_UNIT').each do |k, v|
                k = 'values' if k == 'OBSERV'
                if cache[k] != v
                  BonnieBundler.logger.error("\tExpected value #{v} for key #{k} for measure #{measure.cms_id}-#{sub_id} does not match calculated value #{cache[k]}")
                end
              end
            else
              val.except('measure_id', 'population_index', 'OBSERV_UNIT', 'STRAT').each do |k, v|
                if v != 0
                  BonnieBundler.logger.error("\tExpected value #{v} for key #{k} for measure #{measure.cms_id}-#{sub_id} does not have a calculated value")
                end
              end
            end
          end
        end
      end

      def self.library_functions(check_crosswalk=false)
        library_functions = {}
        library_functions['map_reduce_utils'] = HQMF2JS::Generator::JS.map_reduce_utils
        library_functions['hqmf_utils'] = HQMF2JS::Generator::JS.library_functions(check_crosswalk)
        library_functions
      end   
      
      def self.refresh_js_libraries(check_crosswalk=false)
        Mongoid.default_session['system.js'].find({}).remove_all
        libs = library_functions(check_crosswalk)
        libs.each do |name, contents|
          HealthDataStandards::Import::Bundle::Importer.save_system_js_fn(name, contents)
        end
        libs
      end

      def clear_directories
        BonnieBundler.logger.info("Clearing direcoties")
        FileUtils.rm_rf(base_dir)
      end

      def export_file(file_name, data)
        if @zip
          @zip.put_next_entry file_name
          @zip.puts data
        else
          write_to_file(file_name, data)
        end
      end

      def write_to_file(file_name, data)
        FileUtils.mkdir_p base_dir
        w_file_name = File.join(base_dir,file_name)
        FileUtils.mkdir_p File.dirname(w_file_name)
        FileUtils.remove_file(w_file_name,true)
        File.open(w_file_name,"w") do |f|
          f.puts data
        end
      end

      def compress_artifacts
        BonnieBundler.logger.info("compressing artifacts")
        zipfile_name = config["name"] 
         Zip::ZipFile.open("#{zipfile_name}.zip",  Zip::ZipFile::CREATE) do |zipfile|
          Dir[File.join(base_dir, '**', '**')].each do |file|
             fname = file.sub(base_dir, '')
             if fname[0] == '/'
                fname = fname.slice(1,fname.length)
              end
             zipfile.add(fname, file)
           end
        end
        zipfile_name
      end

      def measure_metadata(measure)
        metadata = {}
        metadata["nqf_id"] = measure.measure_id
        metadata["type"] = measure.type
        metadata["category"] = measure.category
        metadata["episode_of_care"] = measure.episode_of_care
        metadata["continuous_variable"] = measure.continuous_variable
        metadata["episode_ids"] = measure.episode_ids
        if (measure.populations.count > 1)
          sub_ids = ('a'..'az').to_a
          measure.populations.each_with_index do |population, population_index|
            sub_id = sub_ids[population_index]
            metadata['subtitles'] ||= {}
            metadata['subtitles'][sub_id] = measure.populations[population_index]['title']
          end
        end
        metadata["custom_functions"] = measure.custom_functions
        metadata["force_sources"] = measure.force_sources
        metadata
      end


      def bundle_json
        json = {
          title: config['title'],
          measure_period_start: config['measure_period_start'],
          effective_date: config['effective_date'],
          active: true,
          bundle_format: '3.0.0',
          smoking_gun_capable: true,
          version: config['version'],
          hqmfjs_libraries_version: config['hqmfjs_libraries_version'] || '1.0.0',
          license: config['license'],
          measures: measures.pluck(:hqmf_id).uniq,
          patients: records.pluck(:medical_record_number).uniq,
          exported: Time.now.strftime("%Y-%m-%d"),
          extensions: BundleExporter.refresh_js_libraries.keys
        }
      end
    end   
  end
end
