Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E03A7395AB5
	for <lists+io-uring@lfdr.de>; Mon, 31 May 2021 14:38:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231370AbhEaMkD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 31 May 2021 08:40:03 -0400
Received: from mout.gmx.net ([212.227.15.18]:53905 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231330AbhEaMkB (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Mon, 31 May 2021 08:40:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1622464700;
        bh=Xm3jPNsNa1TIQ+g4V5PewR8TGOObkInNicvwgZSzatM=;
        h=X-UI-Sender-Class:From:To:Subject:Date;
        b=hAYbT5BllMYOnyQb1X7lSOkZjyWp08YxpBwiO64gR5l26AI1PkZEugxc8x9+sQtmf
         SgAZO0ufgXPa0SAXrCRQsw76Lgh+cMIb/ay8IVuKlFRGdoTsWAZpybuT3An6PqCNJ7
         nD1jGiEz4hYYutxZwKkOMFiaV3GLEPIq53HoRgCA=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from genesis.localnet ([80.143.54.83]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1Mi2Nv-1lADd71bCT-00e6c4 for
 <io-uring@vger.kernel.org>; Mon, 31 May 2021 14:38:20 +0200
From:   Alois Wohlschlager <alois1@gmx-topmail.de>
To:     io-uring@vger.kernel.org
Subject: [PATCH] io_uring_enter(2): Clarify how to read from and write to  non-seekable files
Date:   Mon, 31 May 2021 14:38:15 +0200
Message-ID: <2191760.Ec4jsOL7QN@genesis>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
X-Provags-ID: V03:K1:YE7/+QFMH2IdEqG022V835+rSMuNIDZz2gr/P0VUzkKb/BpMeRF
 Fa+p8lnwpNmDczmGhMKblATc4LAA2u91CqfKb5e2q1cYqqU3VhAnVVcUjURlvpK0rapxbbG
 Ozy4D6J/YGLVrP2kPZ9UBPaOvsp19yzgR8OerxLaLi3XwcI4y/i+NMsQOmsZPyzsuMBptQ8
 CuQKy3IgUfJqSJOIWs/gg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:/p+yl401m5U=:x3hzKqRNuNrABEtOA0AgZH
 NJhPC9tcMgE9ZvayFbekF6Y7A3nT/S8WElzHFn5RETBIA5peEB/T4omqx22nruSyANiyJz/+G
 i/5AGlZCEz1xBFGXM6nfdfOBaHojOP2XwAg7yBqST1Wlne6GX48OT1ZgRSuEO6duV/8p/sg4s
 ISjTeYOMPWguSLuziLS4FUDETdjZK0cJPGBfkRkOQc/1gWEEA2Qe3DL/wIPPC20CLrH8aMUqy
 SxnRM7zCtp2uQEdSnUCU3QOc1fiGlH4L1EG/BxPSMlDko2IwRhwjFK3YoffBZ66yNhjwGdb07
 sASQZLFdi6ZxaO2gxaIMw3DRRSJjWUUqSNrWt92mKNB8tPRPD3bY1A5AZbBJgo6z/jYbJN1Yc
 X6EEum8e50XRUTq5ieGZmtkW0vwM+JjBwXehCSGfnrIRLWGmZxRzzoBH1q+2lwPfcFvgQSjxI
 25dGBZ9ijF2K7F03TIgauOR40cKrX3gy+ukhcx27+jQ/ged1m6eTjF43kyqZpT7byKhRd86oq
 U5XZMkGLhj9+jT2ClnA0c9FLQIR+Y/iFQQuhBuPsgN7K+1l+i4bZPHz0giXD+WBwhH9u+6mpi
 0RX/lFKxkZXq+VT4vOb5ZEbzc5xALldZT2Yup6fATSI7SvpA+K2Ff6qcVz3wqUWlWT/kDw2/u
 NU7/gTOhZgkNrI5UVKK6+s6pJcQXhpnLcJWxmOVZw/Egw7vH9VgF3yEgnVgSD6Di3VrunNBr2
 bKwLS/CvmFGhZ/nQLPa29Yw3sja3Xf09qaxUNdMgTJQazSZit/EsKlaUoNn67fYvy6x2GC4DM
 sxsoUYo7FCtTLufjo7NZIc1mDEHnXdp19tpUdFLzjkPtZekJwP7Ki5Hhg7IH7eeowlD25p2Jr
 EOOXUnkPGtl2Nv0ZnTAOK+jzIZsCpAfv1gyO+6nutQMJ7ur4Mo9SbOGOxiuZWpby00RkFRUkL
 lJjw2c8U1FkpNI79iWxxWrvT1yMp2FLdrWCuXxyYNTg+7TYnhAB4U9X2wkB8u0wDl5lbxpBsh
 mkh8WuuAeZOp+CwTZiunOVNuRACo44ccfl31DiHlgdsCuOhg8FcKegytmU9Lwu1drp4fC7J66
 7Vwy9KyjHTRSThqRwG0dt1ULNyFzC0h3bvDWnTHYgtjyilbTgyhTWSu5Q==
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

IORING_OP_READ* and IORING_OP_WRITE* all take a file offset. These
operations can still be used with non-seekable files, as long as the
offset is set to zero.

Signed-off-by: Alois Wohlschlager <alois1@gmx-topmail.de>
---
 man/io_uring_enter.2 | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/man/io_uring_enter.2 b/man/io_uring_enter.2
index 5b498e5..dd3c962 100644
--- a/man/io_uring_enter.2
+++ b/man/io_uring_enter.2
@@ -195,6 +195,9 @@ Vectored read and write operations, similar to
 .BR preadv2 (2)
 and
 .BR pwritev2 (2).
+If the file is not seekable,
+.I off
+must be set to zero.

 .TP
 .B IORING_OP_READ_FIXED
@@ -588,6 +591,10 @@ contains the buffer in question,
 contains the length of the IO operation, and
 .I offs
 contains the read or write offset. If
+.I fd
+does not refer to a seekable file,
+.I off
+must be set to zero. If
 .I offs
 is set to -1, the offset will use (and advance) the file position, like the
 .BR read(2)
--
2.31.1


