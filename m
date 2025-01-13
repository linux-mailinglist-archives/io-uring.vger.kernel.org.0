Return-Path: <io-uring+bounces-5845-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A87E9A0BCD6
	for <lists+io-uring@lfdr.de>; Mon, 13 Jan 2025 17:03:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 792DD3A6F0C
	for <lists+io-uring@lfdr.de>; Mon, 13 Jan 2025 16:03:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F12981C5D7F;
	Mon, 13 Jan 2025 16:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lvEPO4Yh"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6578F240222;
	Mon, 13 Jan 2025 16:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736784221; cv=none; b=rppwlcnh8KJ6PbVlaXjStWc/fpWamTUVi59lnmKf/0IpBl6iC2qgT6BAarCM/9F/G/h7g4BSHIO8GPDiHmfeZaw8vlwSgZkOY89n14PrWSYR4yRvMxsW4AvaH3LcjbFqcY25W/BTvXR2sudiAxmCTkF7kOJNgG9C26l1v4ZWW9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736784221; c=relaxed/simple;
	bh=DIA3f01PRm+9cG+7OO0HWpQflWb522k/RZkWi0R2kfY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bIg/O0rmHlYI+LxFSnYu+RdNV2AFOInZ6lj4T5WgdW4jmDi9BI98VW1VGax1T52fuiuchOFdANL6A4AHkbPjMcDORhzrOAGLJLs/ORbrHKGdufot/kkZnv2CrcSaLhuT9T0as/oeZYgWv67S8APHEXUQW7K2UOp5At6qobrM5bk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lvEPO4Yh; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-2ef28f07dbaso6010260a91.2;
        Mon, 13 Jan 2025 08:03:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736784219; x=1737389019; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=d3IquNHAW1qHgGiVDv2yAa0lk1cZ/kp3rCUXm/k12NA=;
        b=lvEPO4YhaKey5zQrXdC2Uur+mp3jCi6moKrQJXrNHQdX0knz6c8dJNLO8NEuMu7A5N
         +XUFOKIyBQXaSfN2H37oQfwew3psdfmA+HtCaqjP+i+Ow35Bcz7h2b7ebt4oAVoi0dtP
         mUDwpXC/UaoJuLtS06pxyb8gECfWcMC2JE4wlSZUG8Le8A3p6KD6nbCUduXDwab+sfMf
         oFQ4RDeTWl+NsR+52luKQlqfA+5fGH263UC+iqCWPSJLzJf1rVuV/0AQjpTFVsGlJP03
         dtZr5K7JUHdY+KQU50xKpKT8skkJ8EpdZepE2EQJq9iPiN29JiH0/p6YWzSspY48cqxT
         l5RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736784219; x=1737389019;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=d3IquNHAW1qHgGiVDv2yAa0lk1cZ/kp3rCUXm/k12NA=;
        b=CPxc2IMW77f0pNo+FdPWXJvSQfE6BVU/FwtzbTEgeuXYU6jCev1ACPcd02YKOhL1NV
         Dc1fthAJ6aCK4DYjWMpCfKlEEAd3qKW0YQymR7cYYt9B7oTMRUZfx37WWy6kPreTFygi
         OObA6xFDcaiTcTMwjIEg/0N2T0dlfq/XjeOGYf66xlxAWz0PalGioQjKT/W9X4C7OxSH
         rfsxYGfddchXzLX6FmXzB/lqQAR0vQqwLmHw6/yDvYe0NIvm6JOQAkCBvemEI1OyUyy1
         wKUXbwHE3GkV60KpHwgFTbxjvmMsT+BQ6Bi8AN91fgc1whQYULYlBprCQJmmzLz5+eMo
         OI6g==
X-Forwarded-Encrypted: i=1; AJvYcCWek7sp7XnZHXeBHHOkBPo7CIhChUg6/gYPJNUDvQKySjfebMkIjczWj6GpdoaMWHitlQBCz4Jw9w==@vger.kernel.org
X-Gm-Message-State: AOJu0YxeFa4IjoO0fStACNu14e0s2yR0x90Dbo+aGk8/600MrJJ7bNRk
	m7oUIGjOZdTnP9SU909LvqGpNB6yIisTpDYAlnsNbqPM4IjmJ+pDoUUUvQ==
X-Gm-Gg: ASbGncsJ70IctnfPIscc/RmyaJbQtJPGLNX8WhIoQ5XNp+xhEzKY6rpG1CXisQFqH8w
	IMZqkwq1Nb125CL1yxmCt8beYCgr68TLFqEWLuglDOktIEAX2lKwtBlhZTX6J0Vw+WA2Wr6ZApJ
	zZEpz6Ts4G1G+A67QhHxVLIHcnhzzj25p0zHmGXQUp/gFUmnaKjPQlcIFIBzleTVQ3BPuQkjPX9
	x+28eZG/QvRb+W8jzURAktceCJaDJJYH+mxDcPAH/rUqV6c0rM8NSYLLp6M
X-Google-Smtp-Source: AGHT+IFIoRFBe4SSxBmtKBF+iLSZUDsY8RxHAR9d/Qn0yGrxfYAq70YRAhe+fvP58gf8fXd33pbAfA==
X-Received: by 2002:a17:90b:5146:b0:2ee:bbe0:98cd with SMTP id 98e67ed59e1d1-2f548e9a547mr31964190a91.7.1736784219151;
        Mon, 13 Jan 2025 08:03:39 -0800 (PST)
Received: from local.. ([2001:ee0:4f4c:d5a0:7984:f0b3:c5d7:378f])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-2f54a34e456sm11268806a91.35.2025.01.13.08.03.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jan 2025 08:03:38 -0800 (PST)
From: Bui Quang Minh <minhquangbui99@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Bui Quang Minh <minhquangbui99@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	io-uring@vger.kernel.org,
	syzbot+3c750be01dab672c513d@syzkaller.appspotmail.com,
	Li Zetao <lizetao1@huawei.com>
Subject: [PATCH v2] io_uring: simplify the SQPOLL thread check when cancelling requests
Date: Mon, 13 Jan 2025 23:03:31 +0700
Message-ID: <20250113160331.44057-1-minhquangbui99@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In io_uring_try_cancel_requests, we check whether sq_data->thread ==
current to determine if the function is called by the SQPOLL thread to do
iopoll when IORING_SETUP_SQPOLL is set. This check can race with the SQPOLL
thread termination.

io_uring_cancel_generic is used in 2 places: io_uring_cancel_generic and
io_ring_exit_work. In io_uring_cancel_generic, we have the information
whether the current is SQPOLL thread already. And the SQPOLL thread never
reaches io_ring_exit_work.

So to avoid the racy check, this commit adds a boolean flag to
io_uring_try_cancel_requests to determine if the caller is SQPOLL thread.

Reported-by: syzbot+3c750be01dab672c513d@syzkaller.appspotmail.com
Reported-by: Li Zetao <lizetao1@huawei.com>
Reviewed-by: Li Zetao <lizetao1@huawei.com>
Signed-off-by: Bui Quang Minh <minhquangbui99@gmail.com>
---

Changes in v2
- Update the comment, commit message, change the name of new flag

 io_uring/io_uring.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index ff691f37462c..b529d6c8d781 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -143,7 +143,8 @@ struct io_defer_entry {
 
 static bool io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 					 struct io_uring_task *tctx,
-					 bool cancel_all);
+					 bool cancel_all,
+					 bool is_sqpoll_thread);
 
 static void io_queue_sqe(struct io_kiocb *req);
 
@@ -2898,7 +2899,8 @@ static __cold void io_ring_exit_work(struct work_struct *work)
 		if (ctx->flags & IORING_SETUP_DEFER_TASKRUN)
 			io_move_task_work_from_local(ctx);
 
-		while (io_uring_try_cancel_requests(ctx, NULL, true))
+		/* The SQPOLL thread never reaches this path */
+		while (io_uring_try_cancel_requests(ctx, NULL, true, false))
 			cond_resched();
 
 		if (ctx->sq_data) {
@@ -3066,7 +3068,8 @@ static __cold bool io_uring_try_cancel_iowq(struct io_ring_ctx *ctx)
 
 static __cold bool io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 						struct io_uring_task *tctx,
-						bool cancel_all)
+						bool cancel_all,
+						bool is_sqpoll_thread)
 {
 	struct io_task_cancel cancel = { .tctx = tctx, .all = cancel_all, };
 	enum io_wq_cancel cret;
@@ -3096,7 +3099,7 @@ static __cold bool io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 
 	/* SQPOLL thread does its own polling */
 	if ((!(ctx->flags & IORING_SETUP_SQPOLL) && cancel_all) ||
-	    (ctx->sq_data && ctx->sq_data->thread == current)) {
+	    is_sqpoll_thread) {
 		while (!wq_list_empty(&ctx->iopoll_list)) {
 			io_iopoll_try_reap_events(ctx);
 			ret = true;
@@ -3169,13 +3172,15 @@ __cold void io_uring_cancel_generic(bool cancel_all, struct io_sq_data *sqd)
 					continue;
 				loop |= io_uring_try_cancel_requests(node->ctx,
 							current->io_uring,
-							cancel_all);
+							cancel_all,
+							false);
 			}
 		} else {
 			list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
 				loop |= io_uring_try_cancel_requests(ctx,
 								     current->io_uring,
-								     cancel_all);
+								     cancel_all,
+								     true);
 		}
 
 		if (loop) {
-- 
2.43.0


