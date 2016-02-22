class NotesController < ApplicationController
  def index
    @notes = Note.all
  end

  def new
    @note = Note.new
  end

  def create
    note = Note.create(note_params)
    redirect_to "/notes/#{note.id}"
  end

  def show
    @note = Note.find(params[:id])
  end

  def edit
    @note = Note.find(params[:id])
  end

  def update
    @note = Note.find(params[:id])
    @note.update(note_params)
    redirect_to "/notes/#{@note.id}"
  end

  def destroy
    Note.destroy(params[:id])
    redirect_to "/notes"
  end

  def note_params
    parameters = {
      title: params[:title],
      category: params[:category],
      content: params[:content],
      updated_at: Time.now.to_s
    }
    parameters[:created_at] = Time.now.to_s if params[:id].nil?
    parameters
  end
end
