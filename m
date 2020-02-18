Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABF361634AE
	for <lists+io-uring@lfdr.de>; Tue, 18 Feb 2020 22:20:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726339AbgBRVT7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 18 Feb 2020 16:19:59 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:35334 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726595AbgBRVT6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 18 Feb 2020 16:19:58 -0500
Received: by mail-wr1-f65.google.com with SMTP id w12so25724813wrt.2
        for <io-uring@vger.kernel.org>; Tue, 18 Feb 2020 13:19:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TSDeT6iffuXDKgqfhspDuVmolbN7V3GNYO1AvIEIXPc=;
        b=U0yK9pY2Ls8obRWmXtcr+Tu+vsv5aBPCWPYM81AKPEmBJCFwdnPzSMwRJ/I+7zd9Uv
         0+oK+jO+Vsjc0vzZFOn2r3TQDqO+dFZNAHgW3BzsK4eSxOgTpo/N1OxXWDHN3tubMgvX
         Jbm5OCtSDB/ijJRpLNTHcY6V8/g92Tc9uBQG8vuXiFqjoptkEc/kwQ62lrw74ZPfVWs6
         4pa8j1WxDSdFkzOfzgmTxKt+3p4vsdFqogOkw7NGrTH9UL/ZvGGDacCPYxuEyX0+KKdH
         g6ifX2wsLUVmwgAdD+MBe/Pdmak4Z8UlyqEvjVqTjhFxS6g1Okvr66KoUxu+ol1w37wZ
         yLaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TSDeT6iffuXDKgqfhspDuVmolbN7V3GNYO1AvIEIXPc=;
        b=uPdXSbuTSSMlv/3BV+jBO6d5cGhk/daD/5B8IwN2PkBNcVV9hAEueMEdOLlFViGT7c
         Dhfrw4Nw1CPQ+oSXnqSwxwl6seenbjmactFF90v0L/EgWX8m2TyCf4+f1ftRryv0lzuS
         bEqt0riU8rH2qf/cLz7yCRCwi/YDncZFen8uLsRwmd1tCWHqczstrLBRKfqN1jJxwbLQ
         G6pLeGSnQEYswPKcFwWGNUypLCWuPJleL4iMYvkGd+CUmOke+IHt3SQVFEjAzx8Xet5+
         39zhrqIR1QLJ9E/r+69s6s190v14lMY04IvpdDcVkwoE3+w8XV15vcfW6SKGB9oBTsDs
         p4tA==
X-Gm-Message-State: APjAAAXzlB04NNAdRNZbbmdgRm00P3ZbaXeOMm5Dx5uPJwEo0vJZSQeu
        VmbTivwcjvchpRTXBjwIWh8=
X-Google-Smtp-Source: APXvYqytFcPdjpR2AhFysx7EZJFSt9uQq+Z/lmF73yp0dVaf5MbJPKETy/SeTuJ0CP8g0j0S8QEA/w==
X-Received: by 2002:adf:ef92:: with SMTP id d18mr29848558wro.234.1582060796928;
        Tue, 18 Feb 2020 13:19:56 -0800 (PST)
Received: from localhost.localdomain ([109.126.149.56])
        by smtp.gmail.com with ESMTPSA id m9sm7711217wrx.55.2020.02.18.13.19.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Feb 2020 13:19:56 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH for-5.6] io_uring: fix use-after-free by io_cleanup_req()
Date:   Wed, 19 Feb 2020 00:19:09 +0300
Message-Id: <a0ee1817fd82ae102607714825ed35833a7d6a3d.1582060617.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_cleanup_req() should be called before req->io is freed, and so
shouldn't be after __io_free_req() -> __io_req_aux_free(). Also,
it will be ignored for in io_free_req_many(), which use
__io_req_aux_free().

Place cleanup_req() into __io_req_aux_free().

Fixes: 99bc4c38537d774 ("io_uring: fix iovec leaks")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 11627818104e..c39a81f8f83d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1296,6 +1296,9 @@ static void __io_req_aux_free(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 
+	if (req->flags & REQ_F_NEED_CLEANUP)
+		io_cleanup_req(req);
+
 	kfree(req->io);
 	if (req->file)
 		io_put_file(ctx, req->file, (req->flags & REQ_F_FIXED_FILE));
@@ -1307,9 +1310,6 @@ static void __io_free_req(struct io_kiocb *req)
 {
 	__io_req_aux_free(req);
 
-	if (req->flags & REQ_F_NEED_CLEANUP)
-		io_cleanup_req(req);
-
 	if (req->flags & REQ_F_INFLIGHT) {
 		struct io_ring_ctx *ctx = req->ctx;
 		unsigned long flags;
-- 
2.24.0

