Return-Path: <io-uring+bounces-7264-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B069A73526
	for <lists+io-uring@lfdr.de>; Thu, 27 Mar 2025 15:58:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 337FD7A666C
	for <lists+io-uring@lfdr.de>; Thu, 27 Mar 2025 14:57:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E38A2185AB;
	Thu, 27 Mar 2025 14:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="clfX/82J"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48186217F36
	for <io-uring@vger.kernel.org>; Thu, 27 Mar 2025 14:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743087498; cv=none; b=oGlRsd5HCHOL2KjEQIPnfDkseBxJZD0Jp3foMLganHKkmvchgLbb2uZgdRKUSBlfH1ohkMPbP297hD9zA3te1N3hU6V1SsQZVhu5q2w2rHPpN3TdPJiQ3L0A7t95qZCfS7YITaDXg6M6qEGeC+JJKsKm7RsLdbP6ZyyJ2Lf5gjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743087498; c=relaxed/simple;
	bh=zUrgzpSQNOfRE1BK5AviML6Lbr8ZIc65GthosVQBKAQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=F9D8DMca3d09ssYrkef+N1hzakHJS/9dj+2wzQiqbsW56msxiNZstkIWVKM9KMorNbBtEYbeXjVMPAF9vHMcBb008RxF72Mf2xMbMJ8f7L0k4RXX0Q5YWt3chV2jfQstMcRejzr+QC5qIJeZ358IZ9KkFqHxWL2SnV+lhd/8tvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=clfX/82J; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-aaee2c5ee6eso166512966b.1
        for <io-uring@vger.kernel.org>; Thu, 27 Mar 2025 07:58:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743087495; x=1743692295; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ePdlLrLJccLiAmHsJHAYKVqR1WObFD7ueRFukEzcaKY=;
        b=clfX/82JfVXvI/+p9C7fiIyn36LuFOj4DA+rDlkZ5Nfxn7aa2zxfieUOhF+LHGD8zu
         Vm4BCRd70wDlGG0arkAoPgxzZ9dYeOgG9hho+wOeiW1AyO/S3qHzoXoaqga5l6nQ1R5Q
         q+Xi1oO/37dc2bkykkTqW0MyKuTwsW0o417pzmXKdSaDGNfj1D2X8LCLpaZp6/RPyZxn
         fFoZ4edu2jOdIalipnXXQ8c+d2dCH80Ii5Brw5z1Orc3UjvdIcbRIcS9oKCy9mIrM+G8
         715vgGGsYIAkzFfLBPOGjuOrn0+oxvSCPpRYnjCKHsgNJeupnYnvT8LaQK4n1N1gKc3Q
         gcqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743087495; x=1743692295;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ePdlLrLJccLiAmHsJHAYKVqR1WObFD7ueRFukEzcaKY=;
        b=kLIpIGn1NfdY8zJQK8hDqVrvOiVjLbzahii2XnvS37i8fledP3+GxCtJR9CecXpQZ8
         Q4kWr35z64NEtdMWyjFGr4/wIBJszKyiaSDO7iRl5bSJSrXkJ2ymTa4Xi3SzMPbKLhCn
         A1rA9tmt5RXosuYCmxZq8Y/uWhvxwisIU6BHsXcmA9FB7MD+Z8Ti8+oGqLNHixQopgnn
         I0PDLQE0imt91onVTSDn4Iol2ZWKr37CzRFm9h1STWyW0TToRZqmuFQ2ixCB4OVr41p/
         yx6BgL/fsq2SlL8T5d9FwgXQVppzDXKWL4QUejmfJ+ETVTE+H9gmv63aAFQtF/o8D88l
         5Ynw==
X-Gm-Message-State: AOJu0Yzu/bmuRUy+nRUfnjpBJ91HtQqGYj8PPAbtj1BJN20L5qxzr1ng
	mRP1pwnDfEeJYxqsQdMP95HBh3MChq9kneZEYrKNI+L541DnOt7sxLSneQ==
X-Gm-Gg: ASbGnctYWMhECXTDgWXTAJone/2pn4tMmDxfhkb7zTi50c88qcsYXsiTtv1JlISVcEm
	WTQKagTIUHeI8OZ3Ni3AjPy93JyanIREnfAZkxSjHFLGoygypD89rkzanSut+IA/zj5jbeo5nOc
	4rNYklXn+Xpb2P2Um2qOVBMG+ZykSzK6q3TZhnovPxKNaG2MF5VZapO5E8F9uANd0UwMs4ObYo1
	VcPSPAfUXXFOGosHxwemHXq4bcxq54OQHoFN7XheSD4ipgj3nvBp4Dybnw2DH2bbEgHwV8DcAZ1
	IRKCuCDPTnOWlWeMIOzVMNv5Y3eY
X-Google-Smtp-Source: AGHT+IFySbWVllr9D4thF/mVL7F9zwYtC1wrjVKwlpCB3FgpsTbomoVHsPyCjiOglt1scQH+EIf6hA==
X-Received: by 2002:a17:906:dc94:b0:ac2:a4c2:604f with SMTP id a640c23a62f3a-ac6fb100ec0mr345805466b.46.1743087494980;
        Thu, 27 Mar 2025 07:58:14 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:8902])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac71922c0c5sm5255266b.9.2025.03.27.07.58.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Mar 2025 07:58:14 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v2 1/1] io_uring/net: fix io_req_post_cqe abuse by send bundle
Date: Thu, 27 Mar 2025 14:58:56 +0000
Message-ID: <8b611dbb54d1cd47a88681f5d38c84d0c02bc563.1743067183.git.asml.silence@gmail.com>
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

v2: Dropped the assert for now because of mshot timeouts and polls
    ignore the semantics (but don't have the problem).

 include/linux/io_uring_types.h | 3 +++
 io_uring/io_uring.c            | 4 ++--
 io_uring/net.c                 | 1 +
 3 files changed, 6 insertions(+), 2 deletions(-)

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
index 4ea684a17d01..4e362c8542a7 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1840,7 +1840,7 @@ void io_wq_submit_work(struct io_wq_work *work)
 	 * Don't allow any multishot execution from io-wq. It's more restrictive
 	 * than necessary and also cleaner.
 	 */
-	if (req->flags & REQ_F_APOLL_MULTISHOT) {
+	if (req->flags & (REQ_F_MULTISHOT|REQ_F_APOLL_MULTISHOT)) {
 		err = -EBADFD;
 		if (!io_file_can_poll(req))
 			goto fail;
@@ -1851,7 +1851,7 @@ void io_wq_submit_work(struct io_wq_work *work)
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


