Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63A195FA8D8
	for <lists+io-uring@lfdr.de>; Tue, 11 Oct 2022 02:00:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229624AbiJKAAx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 10 Oct 2022 20:00:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229827AbiJKAAr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 10 Oct 2022 20:00:47 -0400
X-Greylist: delayed 1020 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 10 Oct 2022 17:00:45 PDT
Received: from 66-220-144-178.mail-mxout.facebook.com (66-220-144-178.mail-mxout.facebook.com [66.220.144.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39980804AA
        for <io-uring@vger.kernel.org>; Mon, 10 Oct 2022 17:00:44 -0700 (PDT)
Received: by dev1180.prn1.facebook.com (Postfix, from userid 425415)
        id AE96134B23D5; Mon, 10 Oct 2022 16:43:32 -0700 (PDT)
From:   Stefan Roesch <shr@devkernel.io>
To:     kernel-team@fb.com, io-uring@vger.kernel.org
Cc:     shr@devkernel.io, axboe@kernel.dk,
        kernel test robot <lkp@intel.com>
Subject: [PATCH v1] io_uring: local variable rw shadows outer variable in io_write
Date:   Mon, 10 Oct 2022 16:43:30 -0700
Message-Id: <20221010234330.244244-1-shr@devkernel.io>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.1 required=5.0 tests=BAYES_00,RDNS_DYNAMIC,
        SPF_HELO_PASS,SPF_NEUTRAL,TVD_RCVD_IP autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This fixes the shadowing of the outer variable rw in the function
io_write().

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Stefan Roesch <shr@devkernel.io>
---
 io_uring/rw.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/io_uring/rw.c b/io_uring/rw.c
index a25cd44cd415..453e0ae92160 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -916,7 +916,7 @@ int io_write(struct io_kiocb *req, unsigned int issue=
_flags)
 			goto copy_iov;
=20
 		if (ret2 !=3D req->cqe.res && ret2 >=3D 0 && need_complete_io(req)) {
-			struct io_async_rw *rw;
+			struct io_async_rw *io;
=20
 			trace_io_uring_short_write(req->ctx, kiocb->ki_pos - ret2,
 						req->cqe.res, ret2);
@@ -929,9 +929,9 @@ int io_write(struct io_kiocb *req, unsigned int issue=
_flags)
 			iov_iter_save_state(&s->iter, &s->iter_state);
 			ret =3D io_setup_async_rw(req, iovec, s, true);
=20
-			rw =3D req->async_data;
-			if (rw)
-				rw->bytes_done +=3D ret2;
+			io =3D req->async_data;
+			if (io)
+				io->bytes_done +=3D ret2;
=20
 			if (kiocb->ki_flags & IOCB_WRITE)
 				kiocb_end_write(req);

base-commit: e2302539dd4f1c62d96651c07ddb05aa2461d29c
--=20
2.30.2

