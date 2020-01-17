Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9301714140A
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2020 23:23:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726970AbgAQWXU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 17 Jan 2020 17:23:20 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:46126 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726857AbgAQWXU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 17 Jan 2020 17:23:20 -0500
Received: by mail-lf1-f67.google.com with SMTP id f15so19485506lfl.13;
        Fri, 17 Jan 2020 14:23:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=p2xXI+QNTz0AKjkdWdU1X4ziSg6uHXNK+wBuvo1i6TA=;
        b=mVFptWidqnRMsrhmXy8DRIMcxoiXa0QqTCUNWfdwCV1CI97v9BQk317V4/yW16cW2M
         106+dlDuDsqM7e1duh056rkEInSZFSbx0rbWTBKC+SooiuHQWEsicRpb1AVUq5wjqg+5
         M8kZfLH3989z7WnZKI9RQMvA7KrkZcu2gmF+4E9m1F5sd6kom6BEPloT65Li0oguCgKH
         3I6m1eavB2uYAhEot47eYSMS1aYq009l2LoN81c1iQQ8np0NwZj9kHgc7y4ZZiXC0Y/Z
         2tXZwArTi7ge2Nz6MGQkGfFjzoVIyDnRUUGyEm8AH7d7w9lVqbaWPH6byCY0A5am1+rh
         lXZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=p2xXI+QNTz0AKjkdWdU1X4ziSg6uHXNK+wBuvo1i6TA=;
        b=SAJty9FYcB2f8Znb8ymTJuB51Frkck2N3tbUleONylE5xplpd5n3rBt/zEA+2cpPCY
         ElTYYy6m79KJGumIR0I7xTevOYKOLj3rAMS8yZG/5mO29Ts6VXC1nE4fgDLLXGADt6B5
         mlLHPwUixQmqoqiZEuxKfI1V26C+eSGgeQNTU6ZgV6t3XvNei1KHyRAlNXEMmjXLPG4s
         Vhhfmz1fjsGTIIIVFCkCPdzCLO2CemVlqS+Oth8vMXe0SLOrdGE9LNyhTbf4VVVnqAUu
         7ALSIQ/m9IBidsm4KjZfp/nNFJ57LLOxvVcu5FDKSSza72/j9J+depxBL+mQDwYHcL7a
         9mIQ==
X-Gm-Message-State: APjAAAWNOOndSiUFz/+qNSy8yyZ1eJMhAwt0DdZs2T1D6pub+l7VPU58
        lvj8vMTn39veQSnYOIwsuiTwlTSU
X-Google-Smtp-Source: APXvYqwazlPrUB9RACu0NFOu/OdmSnVzxa5qa4jO3S8hWcl5fAqF2eTBe8PaiJxidFVm8/CplsqiUg==
X-Received: by 2002:ac2:58ea:: with SMTP id v10mr6677983lfo.202.1579299798079;
        Fri, 17 Jan 2020 14:23:18 -0800 (PST)
Received: from localhost.localdomain ([109.126.145.157])
        by smtp.gmail.com with ESMTPSA id r9sm14719708lfc.72.2020.01.17.14.23.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jan 2020 14:23:17 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] io_uring: remove REQ_F_IO_DRAINED
Date:   Sat, 18 Jan 2020 01:22:30 +0300
Message-Id: <37a04c11e980f49cb17a4fd071d2d71a291a8fd5.1579299684.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

A request can get into the defer list only once, there is no need for
marking it as drained, so remove it. This probably was left after
extracting __need_defer() for use in timeouts.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 9ee01c7422cb..163707ac9e76 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -499,7 +499,6 @@ struct io_kiocb {
 #define REQ_F_FIXED_FILE	4	/* ctx owns file */
 #define REQ_F_LINK_NEXT		8	/* already grabbed next link */
 #define REQ_F_IO_DRAIN		16	/* drain existing IO first */
-#define REQ_F_IO_DRAINED	32	/* drain done */
 #define REQ_F_LINK		64	/* linked sqes */
 #define REQ_F_LINK_TIMEOUT	128	/* has linked timeout */
 #define REQ_F_FAIL_LINK		256	/* fail rest of links */
@@ -815,7 +814,7 @@ static inline bool __req_need_defer(struct io_kiocb *req)
 
 static inline bool req_need_defer(struct io_kiocb *req)
 {
-	if ((req->flags & (REQ_F_IO_DRAIN|REQ_F_IO_DRAINED)) == REQ_F_IO_DRAIN)
+	if (unlikely(req->flags & REQ_F_IO_DRAIN))
 		return __req_need_defer(req);
 
 	return false;
@@ -937,10 +936,8 @@ static void io_commit_cqring(struct io_ring_ctx *ctx)
 
 	__io_commit_cqring(ctx);
 
-	while ((req = io_get_deferred_req(ctx)) != NULL) {
-		req->flags |= REQ_F_IO_DRAINED;
+	while ((req = io_get_deferred_req(ctx)) != NULL)
 		io_queue_async_work(req);
-	}
 }
 
 static struct io_uring_cqe *io_get_cqring(struct io_ring_ctx *ctx)
-- 
2.24.0

