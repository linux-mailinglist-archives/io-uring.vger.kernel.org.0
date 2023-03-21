Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84E136C3B0A
	for <lists+io-uring@lfdr.de>; Tue, 21 Mar 2023 20:54:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229525AbjCUTyO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 21 Mar 2023 15:54:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229878AbjCUTyM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 21 Mar 2023 15:54:12 -0400
X-Greylist: delayed 436 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 21 Mar 2023 12:53:49 PDT
Received: from mail-41103.protonmail.ch (mail-41103.protonmail.ch [185.70.41.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 782BD4683
        for <io-uring@vger.kernel.org>; Tue, 21 Mar 2023 12:53:48 -0700 (PDT)
Date:   Tue, 21 Mar 2023 19:44:02 +0000
Authentication-Results: mail-41103.protonmail.ch;
        dkim=pass (2048-bit key) header.d=pm.me header.i=@pm.me header.b="qEFxm0yL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
        s=protonmail3; t=1679427850; x=1679687050;
        bh=9XCj/KtxzhhrPWv01nH8ZgulSY3DXVDkToSVvVC4Bcg=;
        h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
         Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
        b=qEFxm0yLWJpcBha0iqwhijkiQY0uy9FabNsQ5SRig640QvMdP6lk1Q3VXUVkrOOn5
         ppbdy0wB1iX/L2WqBa2fYxMCg1Bz60HtqZXPtCdUhXCvGOHgO9IugFeSvPw8freuq0
         2/GEHsczED3DYDxR90xhyyK+Ib4FfVP6MllJDAYrCIqMaPzw2l1zg1FAhJM0OuLrY/
         He7fWlrrdjmL2LbE2kokyAmpoqwnb3Dk+05vPLNoyBO5+Qiay10BWbuysGabBBsKI+
         lChjtN3jCz93VLf9136xcz2pu5fNy7cfChMsEv7w0aIhYQ8KqoY76YNZP0DypJfcFo
         NPP99c9heC0mQ==
To:     io-uring@vger.kernel.org
From:   Savino Dicanosa <sd7.dev@pm.me>
Cc:     axboe@kernel.dk, asml.silence@gmail.com,
        Savino Dicanosa <sd7.dev@pm.me>
Subject: [PATCH] io_uring/rsrc: fix null-ptr-deref in io_file_bitmap_get()
Message-ID: <20230321194300.405130-1-sd7.dev@pm.me>
Feedback-ID: 69702485:user:proton
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

When fixed files are unregistered, file_alloc_end and alloc_hint
are not cleared. This can later cause a NULL pointer dereference in
io_file_bitmap_get() if auto index selection is enabled via
IORING_FILE_INDEX_ALLOC:

[    6.519129] BUG: kernel NULL pointer dereference, address: 0000000000000=
000
[...]
[    6.541468] RIP: 0010:_find_next_zero_bit+0x1a/0x70
[...]
[    6.560906] Call Trace:
[    6.561322]  <TASK>
[    6.561672]  io_file_bitmap_get+0x38/0x60
[    6.562281]  io_fixed_fd_install+0x63/0xb0
[    6.562851]  ? __pfx_io_socket+0x10/0x10
[    6.563396]  io_socket+0x93/0xf0
[    6.563855]  ? __pfx_io_socket+0x10/0x10
[    6.564411]  io_issue_sqe+0x5b/0x3d0
[    6.564914]  io_submit_sqes+0x1de/0x650
[    6.565452]  __do_sys_io_uring_enter+0x4fc/0xb20
[    6.566083]  ? __do_sys_io_uring_register+0x11e/0xd80
[    6.566779]  do_syscall_64+0x3c/0x90
[    6.567247]  entry_SYSCALL_64_after_hwframe+0x72/0xdc
[...]

To fix the issue, set file alloc range and alloc_hint to zero after
file tables are freed.

Fixes: 4278a0deb1f6 ("io_uring: defer alloc_hint update to io_file_bitmap_s=
et()")
Signed-off-by: Savino Dicanosa <sd7.dev@pm.me>
---
 io_uring/rsrc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index e2bac9f89902..7a43aed8e395 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -794,6 +794,7 @@ void __io_sqe_files_unregister(struct io_ring_ctx *ctx)
 =09}
 #endif
 =09io_free_file_tables(&ctx->file_table);
+=09io_file_table_set_alloc_range(ctx, 0, 0);
 =09io_rsrc_data_free(ctx->file_data);
 =09ctx->file_data =3D NULL;
 =09ctx->nr_user_files =3D 0;
--
2.30.2


