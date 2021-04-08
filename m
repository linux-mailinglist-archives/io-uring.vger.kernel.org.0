Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4D24358CAF
	for <lists+io-uring@lfdr.de>; Thu,  8 Apr 2021 20:32:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232405AbhDHScb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Apr 2021 14:32:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231676AbhDHSca (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Apr 2021 14:32:30 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26F41C061760
        for <io-uring@vger.kernel.org>; Thu,  8 Apr 2021 11:32:17 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id q26so3153173wrz.9
        for <io-uring@vger.kernel.org>; Thu, 08 Apr 2021 11:32:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+gmCTGB3kzPtrgMp482ibNI0hjrE1tFZQV2mNkji4lw=;
        b=kcMygSru3cJLOx7TPxENIa970pHYLImpfcARJ9bJ6WWVgn4MlBdvBu0pCaHU2D4ddR
         dRO7UK6wN+CnO8UXmh1jhn3oKLaPIltz89Pe+LZBLkSIxLs21YjZzsT6OYirxMp8KnLW
         V644MqRQCBhXXa/nJusqWHA36cAmYWXjSqsG7UkDcEEr/hjsC4EVfiRD70fx3cAVOnCC
         PUK1+ByGvQoP/otENSCdirrYEqVysELIGf6sXYcblndw5R0juBfw9z3h/CJUqqDbD4sw
         bgj91tM3yoaZIvObIexomx1R6vdgqJpGI/b24uG4rKpHMHxGyEZRcTWJWgUg87mmf98G
         nhxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+gmCTGB3kzPtrgMp482ibNI0hjrE1tFZQV2mNkji4lw=;
        b=tLgoKjRTrUeMrup5Ai0llRMhHF7ivv1Vp2lI67cWt9Ue1x6qVtRMlqqXCRRBRueu+5
         bMqUos/IJf+gEm8WNto8qzYjDlWVH69dNGB3p7B47Dnt5ebW3szNY4Vj74576PfbZsfr
         Of2fPXkODD/ViG6a6DQQDXZZtyGJjKeGCOeCR7cx08Qsq5mQoFcSskzguub28C29i/zV
         2K/zlNCmms1E0JIJef1RMavojhJuERSOHuRlTo26qYt4+YHy4YlIXB7+6oWsz6X9gApw
         Kz7dvdX5oNFjE4YuPou3AQglezbCP0MkKTLE3arYidjFgowT1rZ5mt1W+IMIuAn30o15
         aSCA==
X-Gm-Message-State: AOAM531FQ/R5jHA3033P38ZVmWlYgPEUrXlIbcoH7FrYqQRRo1wSd59U
        AdaRxM9zf1cv9k7kuH0v9u8=
X-Google-Smtp-Source: ABdhPJywdbTF/gdtxkDEBehWKMyxXSCmKtVxoqOJ9OwjCTp/BscQ1fnxgsilLlemiG1yj6iiEOJaxA==
X-Received: by 2002:adf:f692:: with SMTP id v18mr4067503wrp.206.1617906735670;
        Thu, 08 Apr 2021 11:32:15 -0700 (PDT)
Received: from localhost.localdomain ([148.252.128.224])
        by smtp.gmail.com with ESMTPSA id o15sm96448wra.93.2021.04.08.11.32.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Apr 2021 11:32:15 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 5.12 v3] io_uring: fix rw req completion
Date:   Thu,  8 Apr 2021 19:28:03 +0100
Message-Id: <01f81563aacb51972dacff4f2080087c321e424a.1617906241.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

WARNING: at fs/io_uring.c:8578 io_ring_exit_work.cold+0x0/0x18

As reissuing is now passed back by REQ_F_REISSUE and kiocb_done()
internally uses __io_complete_rw(), it may stop after setting the flag
so leaving a dangling request.

There are tricky edge cases, e.g. reading beyound file, boundary, so
the easiest way is to hand code reissue in kiocb_done() as
__io_complete_rw() was doing for us before.

Fixes: 230d50d448ac ("io_uring: move reissue into regular IO path")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/f602250d292f8a84cca9a01d747744d1e797be26.1617842918.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---


v2: io_rw_reissue() may fail, check return code
v3: adjust commit message

 fs/io_uring.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index f1881ac0744b..f2df0569a60a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2762,6 +2762,7 @@ static void kiocb_done(struct kiocb *kiocb, ssize_t ret,
 {
 	struct io_kiocb *req = container_of(kiocb, struct io_kiocb, rw.kiocb);
 	struct io_async_rw *io = req->async_data;
+	bool check_reissue = (kiocb->ki_complete == io_complete_rw);
 
 	/* add previously done IO, if any */
 	if (io && io->bytes_done > 0) {
@@ -2777,6 +2778,18 @@ static void kiocb_done(struct kiocb *kiocb, ssize_t ret,
 		__io_complete_rw(req, ret, 0, issue_flags);
 	else
 		io_rw_done(kiocb, ret);
+
+	if (check_reissue && req->flags & REQ_F_REISSUE) {
+		req->flags &= ~REQ_F_REISSUE;
+		if (!io_rw_reissue(req)) {
+			int cflags = 0;
+
+			req_set_fail_links(req);
+			if (req->flags & REQ_F_BUFFER_SELECTED)
+				cflags = io_put_rw_kbuf(req);
+			__io_req_complete(req, issue_flags, ret, cflags);
+		}
+	}
 }
 
 static int io_import_fixed(struct io_kiocb *req, int rw, struct iov_iter *iter)
-- 
2.24.0

