Return-Path: <io-uring+bounces-3209-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F32797A7B1
	for <lists+io-uring@lfdr.de>; Mon, 16 Sep 2024 21:18:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3BE4D286CE2
	for <lists+io-uring@lfdr.de>; Mon, 16 Sep 2024 19:18:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6782A15921D;
	Mon, 16 Sep 2024 19:18:01 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from cloud48395.mywhc.ca (cloud48395.mywhc.ca [173.209.37.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0102813210D
	for <io-uring@vger.kernel.org>; Mon, 16 Sep 2024 19:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.209.37.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726514281; cv=none; b=mI64iodlZ7Kcv71j4c8fCn6EJeyhG04Uqe/V3BQFm3+4mV4+Y3rI34nXIKjbyB1QRYwsqYppB1wY1893GasvZGzTQooiLsJ0BGZkmzBoye5OpwL2ZWCRlKyVp5LOay8HkRA29FJyNdD56gK8SVwi+WijXyfRVb0bYlDXw/O/lVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726514281; c=relaxed/simple;
	bh=Pif03uLebz7j2yD6gu8mJsBQsgzSqXEf3VbKCMCfvqA=;
	h=From:Date:Message-ID:To:Subject; b=AgPZ1v9MmN5U/giTaoNi8nmgVSdtUep01x+Ba6yCdMIyasIeURqvJZALik1kDTH+jOcgIDiPcYCZSYoe48a8rt1Q+U/k75OvVb9Kp8E/MXUgIfNzru/UJbxmXY2hKB085y5J6f2mzczBmIrCzNOcfUoVU++0Ts1Hns+GoNvFGX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=trillion01.com; spf=pass smtp.mailfrom=trillion01.com; arc=none smtp.client-ip=173.209.37.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=trillion01.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trillion01.com
Received: from [45.44.224.220] (port=53342 helo=localhost)
	by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96.2)
	(envelope-from <olivier@trillion01.com>)
	id 1sqHES-0005xL-2a;
	Mon, 16 Sep 2024 15:17:56 -0400
From: Olivier Langlois <olivier@trillion01.com>
Date: Mon, 16 Sep 2024 15:17:56 -0400
Message-ID: <de7679adf1249446bd47426db01d82b9603b7224.1726161831.git.olivier@trillion01.com>
To: Jens Axboe <axboe@kernel.dk>,Pavel Begunkov <asml.silence@gmail.com>,io-uring@vger.kernel.org
Subject: [PATCH v3 RESEND] io_uring: do the sqpoll napi busy poll outside the
 submission block
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cloud48395.mywhc.ca
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - trillion01.com
X-Get-Message-Sender-Via: cloud48395.mywhc.ca: authenticated_id: olivier@trillion01.com
X-Authenticated-Sender: cloud48395.mywhc.ca: olivier@trillion01.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>

there are many small reasons justifying this change.

1. busy poll must be performed even on rings that have no iopoll and no
   new sqe. It is quite possible that a ring configured for inbound
   traffic with multishot be several hours without receiving new request
   submissions
2. NAPI busy poll does not perform any credential validation
3. If the thread is awaken by task work, processing the task work is
   prioritary over NAPI busy loop. This is why a second loop has been
   created after the io_sq_tw() call instead of doing the busy loop in
   __io_sq_thread() outside its credential acquisition block.

Signed-off-by: Olivier Langlois <olivier@trillion01.com>
---
 io_uring/sqpoll.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
index 3b50dc9586d1..f9964eb03803 100644
--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -195,9 +195,6 @@ static int __io_sq_thread(struct io_ring_ctx *ctx, bool cap_entries)
 			ret = io_submit_sqes(ctx, to_submit);
 		mutex_unlock(&ctx->uring_lock);
 
-		if (io_napi(ctx))
-			ret += io_napi_sqpoll_busy_poll(ctx);
-
 		if (to_submit && wq_has_sleeper(&ctx->sqo_sq_wait))
 			wake_up(&ctx->sqo_sq_wait);
 		if (creds)
@@ -322,6 +319,10 @@ static int io_sq_thread(void *data)
 		if (io_sq_tw(&retry_list, IORING_TW_CAP_ENTRIES_VALUE))
 			sqt_spin = true;
 
+		list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
+			if (io_napi(ctx))
+				io_napi_sqpoll_busy_poll(ctx);
+
 		if (sqt_spin || !time_after(jiffies, timeout)) {
 			if (sqt_spin) {
 				io_sq_update_worktime(sqd, &start);
-- 
2.46.0


