Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC3E0358B9B
	for <lists+io-uring@lfdr.de>; Thu,  8 Apr 2021 19:44:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232543AbhDHRo2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Apr 2021 13:44:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231566AbhDHRo1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Apr 2021 13:44:27 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AA3FC061760
        for <io-uring@vger.kernel.org>; Thu,  8 Apr 2021 10:44:16 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id s7so2897988wru.6
        for <io-uring@vger.kernel.org>; Thu, 08 Apr 2021 10:44:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iBVX5guzp1NeERwHYDK2JX09tSlVmQK41EyooT6iW9o=;
        b=WWq9bb0Fi0o3t0MoIPh3BofCcmrqjYwsQM2zYCuvN5elvN8QOajwmwOK5iDapeGqxB
         2UOXY9XaGv1G1noANVBRg6LhUD2rccKtSJSG2nGqxezAt858oaD4HhY1dQgdSVHi6NUq
         ZYORIprYhJRetYUggI8MkZG3DawUtfHDbdPO/8gqxIDZn006GlVvt1PtafK7F++bAzsr
         g2Ufgxg7rZ0wv8cFFntbaFXEZJ5AOAIXRwtke6u+vMJsygpo3q+Cknz1rshcwzXlDs2p
         kfn2gMQ9vypjcYhkRG2D+dkBz9TIp/PUU18Pr17Xh5jqKlRhD0QUSq7mDVTzbWh1DveN
         GGgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iBVX5guzp1NeERwHYDK2JX09tSlVmQK41EyooT6iW9o=;
        b=QKjzRvogSmBqZp2X1EWzx3c8qWKf5qJB2sI1aLOor860UJExtt713Oe0qQrOYeSx5X
         BK7ZdXUQUgbnhzWMgI05MoOSEJnePzM+/B53dwlTGD59amgGKU887smifuOe6mAdz36o
         j04Xtx4nFZ6yFol+2AdGHz48pF7x0exmCNKDAKszSXJWlVkiul9k+NcW7pHq7Npi1vpw
         eHIIEqlW+5Ypyawy5/LC9lHBFcxgzrTeERPcv5yuRmg5skOb3krRQwRZogXiyugy45pi
         K3Z7tLC5/1X1oDg5wq1neia8zIAsZsPxuKMwxVkM7moT0XgmMSl+3AAydwNpKPU9Ww3V
         sQiA==
X-Gm-Message-State: AOAM531ymHkU8wSUT7p8GOrG8Qd1cre2QZNY4ufJrvOtyMYzv4JdgUHT
        XNLpEMM/s4qoxfSxYVov0YjuoC2tqNvWAA==
X-Google-Smtp-Source: ABdhPJyhG/ZqT9mFi/D3UE8gG2I5RGJqlo8TfWDUjt0cnGrx+QUbMBjAD4l0g/nePa7fewG96bfsKg==
X-Received: by 2002:adf:cd0a:: with SMTP id w10mr13174652wrm.39.1617903855107;
        Thu, 08 Apr 2021 10:44:15 -0700 (PDT)
Received: from localhost.localdomain ([148.252.128.224])
        by smtp.gmail.com with ESMTPSA id m14sm4169794wrh.28.2021.04.08.10.44.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Apr 2021 10:44:14 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 5.12 v2] io_uring: fix rw req completion
Date:   Thu,  8 Apr 2021 18:40:02 +0100
Message-Id: <a1db1d9603cf6abb6de51a58fe6e966c7ea1e5d3.1617903478.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

WARNING: at fs/io_uring.c:8578 io_ring_exit_work.cold+0x0/0x18

As reissuing is now passed back by REQ_F_REISSUE, kiocb_done() may just
set the flag and do nothing leaving dangling requests. The handling is a
bit fragile, e.g. can't just complete them because the case of reading
beyond file boundary needs blocking context to return 0, otherwise it
may be -EAGAIN.

Go the easy way for now, just emulate how it was by io_rw_reissue() in
kiocb_done()

Fixes: 230d50d448ac ("io_uring: move reissue into regular IO path")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/f602250d292f8a84cca9a01d747744d1e797be26.1617842918.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---

v2: io_rw_reissue() may fail, check return code

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

