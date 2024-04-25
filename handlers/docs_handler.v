module handlers

import os
import models

pub fn get_docs() []models.Chapter {
  docs_path := "/backup/dev/v/v/doc/docs.md"
  docs_raw := os.read_file(docs_path) or { panic("could not read the file ${err}")}
  docs_splitted := docs_raw.split('\n## ')
  mut chapters := []models.Chapter{}
  for idx, s in docs_splitted {
    data := s.split("\n\n")
    chapters << models.Chapter{id: idx. str(), header:data[0], content: data[1..].join(' ')}
  }
    return chapters
}
