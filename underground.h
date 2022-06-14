
//{{BLOCK(underground)

//======================================================================
//
//	underground, 256x768@4, 
//	+ palette 256 entries, not compressed
//	+ 1314 tiles (t|f|p reduced) not compressed
//	+ regular map (in SBBs), not compressed, 32x96 
//	Total size: 512 + 42048 + 6144 = 48704
//
//	Time-stamp: 2022-04-18, 12:59:35
//	Exported by Cearn's GBA Image Transmogrifier, v0.8.3
//	( http://www.coranac.com/projects/#grit )
//
//======================================================================

#ifndef GRIT_UNDERGROUND_H
#define GRIT_UNDERGROUND_H

#define undergroundTilesLen 42048
extern const unsigned short undergroundTiles[21024];

#define undergroundMapLen 6144
extern const unsigned short undergroundMap[3072];

#define undergroundPalLen 512
extern const unsigned short undergroundPal[256];

#endif // GRIT_UNDERGROUND_H

//}}BLOCK(underground)
