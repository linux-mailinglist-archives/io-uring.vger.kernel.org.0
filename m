Return-Path: <io-uring+bounces-7253-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 232F7A723D9
	for <lists+io-uring@lfdr.de>; Wed, 26 Mar 2025 23:21:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5B51E7A1571
	for <lists+io-uring@lfdr.de>; Wed, 26 Mar 2025 22:20:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10B8B5028C;
	Wed, 26 Mar 2025 22:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ShmwR7iO"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 395AF2627E3
	for <io-uring@vger.kernel.org>; Wed, 26 Mar 2025 22:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743027679; cv=none; b=VKmIuQYW3OqGbEHO5G738wE31GAL9TdZ/ZbWQi7R+ipI2Vq4Tt7kjmQwawTkptOT08ihI+yDYnedZRoJ2iFxm0DEgmHc7+pmCvVBr7pthqrFhMzk48WMchhEY/dBrkdHVRt5qQpFA4BQr/MKm/UFmvd1apM0kHA+orNcUUVcyWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743027679; c=relaxed/simple;
	bh=03q/e0Qb4aoB5gnVNHec6jspYJGG4WyFSr0OfuO0nE4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lFZYFT11Uc7nzISBeskiat3nIHP65VDclo03aZIgj9yNZRbe/93+SzFVMTqI+mirzwXTQGoIKJCFpcTSnPTyB7kDR6Ry0tXs1uHBB9g/Bzz7djdlqfrsiiP0vJFtnCSkCuJ5JRPJ4/2OAehC88QbHibiIogeOSuQs2BJ/rEocEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ShmwR7iO; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-5e5deb6482cso2829327a12.1
        for <io-uring@vger.kernel.org>; Wed, 26 Mar 2025 15:21:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743027675; x=1743632475; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/2wj7fdbS7idDyUws0SpJO6yHqHnH9p/aLCXh+VlGvk=;
        b=ShmwR7iOmvBVq5vatiamyevbLVVW8WLz5f2x06vmKAiSQiubGH72J/e8kS8llC5sZh
         BUwnu3B03ifrF2GFD2v1OC2mdU7y0wJhxIop4LSpOCfc+S/C7dUPfOnyhwkkUfJFPeIP
         iKqeE9ov6Upb6ns2fcz1hnfjdnocfWlxt8FdiCEVZBD/IOi6SKoCfwn45B7LZGOr0LOQ
         E4HI0fcFSlzRSRWMYFbOMgIkf9cu3u2jmVZwSr/Kb9h6a9IRd2u3onp1yq61EcF+hgNG
         jMI/p/pIb4mt+kvuiPjJoieR5+w3XzayOm7OBRV1lSR407vel3XqIwTVeAS3FL8df1Wa
         XbbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743027675; x=1743632475;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/2wj7fdbS7idDyUws0SpJO6yHqHnH9p/aLCXh+VlGvk=;
        b=iA04KT4fDxxAmqJKAu4FNQ62qWV1rjieqWEtGHrBkekXoEME/+QbhmZ0FRKz6BcKVD
         Y5UiSJpD3eKDExsuXaxTs6Gf+NtkIvsIgNidc+Uwe7AYH+/WzOSs5gWBv+53Wc3XQFHP
         emyvDO+xqvdPtvA/HiydWYFNT8CsuQVfwJyY4sx/qSnvxm+OYzJLXr4Cuusu5J4zW/QE
         kwDHBHYleJEi1Y7ABTBrfmxjYyTP+IrsG+BirS2/Wqnpdg/jvH75sZUPUsXrFVg9cNB+
         D37duGXZCOa9hWziB5L7LAc9yaQ/FYQMmbHXWPzYgX2+Fj7OSaQZDRmZbC8O7vPwovdX
         Ssxw==
X-Gm-Message-State: AOJu0Yxpf0f2KESPwfgBk0yVpWdbC2OfWE23Fq1eC2ikH0V+qHiPnUKA
	E01kfSAMvgoFWOy68e6STzXELZDN0OKza3bx49iLufeXOdqo+1SsncMEhw==
X-Gm-Gg: ASbGncsq8/0MDZY9zwUwZdF6I8OfYdN2lNSwu/0fhJtJrjmT+IKMXUv/N1PZE13vnJt
	rQwITJXjN5v8Y4CvtDCRX29QjfhkdcSIpNXmZWqFTW5RPtry7LnX5R+W7RZeDl/jqTuXhSwN+yG
	a2v0PAZJzV5Hq0HIkLfyvlFxvV479Sblqg9+/9KumWBnixQXurNlVMTAy9mAW46WjBKfw2LrNzY
	EIIDgtHp4ma8FpXq67w89zdjCz5vuMhOd5IiKMLCgj2Hca1xH7R6KILKynZWijN9aptycoNQ6x1
	06QsOdodp4gBHAhabCn43BfmLM6UyEELr/gdRlKbpGxxVmM93pTxyaIATA==
X-Google-Smtp-Source: AGHT+IG7qCgfI2mypr7jLT2SHnwUK84hrylwnZtWamLHS5x28f5FuIqU9hovKPCG37LZx2MPbWjV7Q==
X-Received: by 2002:a17:907:7ba8:b0:abf:6f25:9881 with SMTP id a640c23a62f3a-ac6e0da074emr490774966b.25.1743027674220;
        Wed, 26 Mar 2025 15:21:14 -0700 (PDT)
Received: from 127.0.0.1localhost ([85.255.233.207])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac3efbd4672sm1092834366b.127.2025.03.26.15.21.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Mar 2025 15:21:13 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 1/1] io_uring/net: fix io_req_post_cqe abuse by send bundle
Date: Wed, 26 Mar 2025 22:21:47 +0000
Message-ID: <3a6638b0f3567a00cfaabd80821fab3b60d49b36.1743027688.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

[  114.987980][ T5313] WARNING: CPU: 6 PID: 5313 at io_uring/io_uring.c:872 io_req_post_cqe+0x12e/0x4f0
[  114.991597][ T5313] RIP: 0010:io_req_post_cqe+0x12e/0x4f0
[  115.001880][ T5313] Call Trace:
[  115.002222][ T5313]  <TASK>
[  115.007813][ T5313]  io_send+0x4fe/0x10f0
[  115.009317][ T5313]  io_issue_sqe+0x1a6/0x1740
[  115.012094][ T5313]  io_wq_submit_work+0x38b/0xed0
[  115.013223][ T5313]  io_worker_handle_work+0x62a/0x1600
[  115.013876][ T5313]  io_wq_worker+0x34f/0xdf0

As the comment states, io_req_post_cqe() should only be used by
multishot requests, i.e. REQ_F_APOLL_MULTISHOT, which bundled sends are
not. Add a flag signifying whether a request wants to post multiple
CQEs. Eventually REQ_F_APOLL_MULTISHOT should imply the new flag, but
that's left out for simplicity.

Cc: stable@vger.kernel.org
Fixes: a05d1f625c7aa ("io_uring/net: support bundles for send")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/io_uring_types.h | 3 +++
 io_uring/io_uring.c            | 5 +++--
 io_uring/net.c                 | 1 +
 3 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 699e2c0895ae..b44d201520d8 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -490,6 +490,7 @@ enum {
 	REQ_F_SKIP_LINK_CQES_BIT,
 	REQ_F_SINGLE_POLL_BIT,
 	REQ_F_DOUBLE_POLL_BIT,
+	REQ_F_MULTISHOT_BIT,
 	REQ_F_APOLL_MULTISHOT_BIT,
 	REQ_F_CLEAR_POLLIN_BIT,
 	/* keep async read/write and isreg together and in order */
@@ -567,6 +568,8 @@ enum {
 	REQ_F_SINGLE_POLL	= IO_REQ_FLAG(REQ_F_SINGLE_POLL_BIT),
 	/* double poll may active */
 	REQ_F_DOUBLE_POLL	= IO_REQ_FLAG(REQ_F_DOUBLE_POLL_BIT),
+	/* request posts multiple completions, should be set at prep time */
+	REQ_F_MULTISHOT		= IO_REQ_FLAG(REQ_F_MULTISHOT_BIT),
 	/* fast poll multishot mode */
 	REQ_F_APOLL_MULTISHOT	= IO_REQ_FLAG(REQ_F_APOLL_MULTISHOT_BIT),
 	/* recvmsg special flag, clear EPOLLIN */
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 4ea684a17d01..c859630474fb 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -870,6 +870,7 @@ bool io_req_post_cqe(struct io_kiocb *req, s32 res, u32 cflags)
 	bool posted;
 
 	lockdep_assert(!io_wq_current_is_worker());
+	lockdep_assert(req->flags & (REQ_F_MULTISHOT|REQ_F_APOLL_MULTISHOT));
 	lockdep_assert_held(&ctx->uring_lock);
 
 	__io_cq_lock(ctx);
@@ -1840,7 +1841,7 @@ void io_wq_submit_work(struct io_wq_work *work)
 	 * Don't allow any multishot execution from io-wq. It's more restrictive
 	 * than necessary and also cleaner.
 	 */
-	if (req->flags & REQ_F_APOLL_MULTISHOT) {
+	if (req->flags & (REQ_F_MULTISHOT|REQ_F_APOLL_MULTISHOT)) {
 		err = -EBADFD;
 		if (!io_file_can_poll(req))
 			goto fail;
@@ -1851,7 +1852,7 @@ void io_wq_submit_work(struct io_wq_work *work)
 				goto fail;
 			return;
 		} else {
-			req->flags &= ~REQ_F_APOLL_MULTISHOT;
+			req->flags &= ~(REQ_F_APOLL_MULTISHOT|REQ_F_MULTISHOT);
 		}
 	}
 
diff --git a/io_uring/net.c b/io_uring/net.c
index c0275e7f034a..616e953ef0ae 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -448,6 +448,7 @@ int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		sr->msg_flags |= MSG_WAITALL;
 		sr->buf_group = req->buf_index;
 		req->buf_list = NULL;
+		req->flags |= REQ_F_MULTISHOT;
 	}
 
 	if (io_is_compat(req->ctx))
-- 
2.48.1


