# RenderingGeometry.jl
 A touched-up, immutable port of PBRT's Geometry Section.

Current progress:

###### Implementation

  - [x] Vectors
  - [x] Points
  - [x] Normals
  - [ ] Rays (in progress)
  - [ ] AABBs (in progress)
  - [ ] Transforms
  - [ ] Surface Interactions

###### Testing

  - [x] Vectors
  - [x] Points
  - [x] Normals
  - [ ] Rays (in progress)
  - [ ] AABBs (in progress)
  - [ ] Transforms
  - [ ] Surface Interactions

### What is this?
Physically Based Rendering Techniques (shortened by everyone
and their mother to [PBRT](https://www.pbrt.org/)) is a
ray tracing omnibus that exhaustively examines a large portion
of the physically based rendering knowledge space. It's written
in C++, and you can find the source [here.](https://github.com/mmp/pbrt-v3)
What makes it so fun to read through, in my view, is the direct pairing of
theory with immediate implementation: after seeing a concept presented
abstractly, PBRT happily lifts the hood and shows you how they made it.

I love this book, and when I decided to learn a new programming language,
I was looking for something fast, terse, and clear to map some parts of PBRT
onto. Enter Julia, a language I learned a couple weeks ago and wanted to build
something in.

### PBRT's geometric structure
PBRT's second chapter is devoted to geometry definitions. This means defining
the building blocks that the rest of the renderer runs on. These are the
following structures:

##### With 2D and 3D representations:
  - Vectors
  - Points
  - Normals
  - Axis-aligned bounding boxes

##### With 3D representations:
  - Rays
  - Transformations
  - Surface Interactions



### PBRT, the Julian way

There's a lot of directions you could take this! In my case, I was looking
to rebuild the definitions in idiomatic Julia, so I made the following design
decisions:

#### Look, but don't touch
Every structure in `RenderingGeometry` (so far) is immutable. Once you create a Vector,
it will keep those values forever. This is at odds with many of the design
choices made in PBRT. For example: `Rays` contain a mutable variable (`tMax`)
that is updated during acceleration structure traversals. Instead, when
traversing, we will choose to modify the value of `tMax` independent of the
ray, whose origin and direction do not change. This is less about making the
code idiomatically Julian as it is making everything simple to track.

#### Make it tiny
Again, PBRT is massive, and realistically, it's not likely that I'd be able to
reduce its size by magnitudes. The goal here is to make the various sections in
PBRT, to the extent that it is possible to do so, operate as separate packages,
which I can bring together when I make the final ray tracer. Julia is also
extremely well-suited to the task of making fast, terse code.

#### Generalize where possible
This happens in more places than you might think, and taking advantage of Julia's
powerful type system lets us build things with blazing fast structures with very
flexible code. Usually, you can avoid repeating yourself by establishing a useful
type hierarchy and dictating behavior through those types. Lots of this was also made
possible thanks to `StaticArrays.jl`, which creates a neat interface for my use cases.
