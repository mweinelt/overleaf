define [
	"base"
], (App) ->

	App.factory 'labels', ($http, ide) ->

		state = {documents: {}}

		labels = {
			state: state
		}

		labels.onDocLabelsUpdated = (e, data) ->
			if data.docId and data.labels
				state.documents[data.docId] = data.labels

		labels.onEntityDeleted = (e, entity) ->
			if entity.type == 'doc'
				delete state.documents[entity.id]

		labels.onFileUploadComplete = (e, upload) ->
			if upload.entity_type == 'doc'
				labels.loadDocLabelsFromServer(upload.entity_id)

		labels.getAllLabels = () ->
			_.flatten(labels for docId, labels of state.documents)

		labels.loadProjectLabelsFromServer = () ->
			$http
				.get("/project/#{window.project_id}/labels")
				.success (data) ->
					if data.projectLabels
						for docId, docLabels of data.projectLabels
							state.documents[docId] = docLabels

		labels.loadDocLabelsFromServer = (docId) ->
			$http
				.get("/project/#{window.project_id}/#{docId}/labels")
				.success (data) ->
					if data.docId and data.labels
						state.documents[data.docId] = data.labels

		return labels
