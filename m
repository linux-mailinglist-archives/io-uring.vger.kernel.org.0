Return-Path: <io-uring+bounces-11171-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C6859CCA1A0
	for <lists+io-uring@lfdr.de>; Thu, 18 Dec 2025 03:45:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 832CE302F699
	for <lists+io-uring@lfdr.de>; Thu, 18 Dec 2025 02:45:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44809223DFB;
	Thu, 18 Dec 2025 02:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="KcQclCoL"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f97.google.com (mail-oa1-f97.google.com [209.85.160.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29EB62FDC2C
	for <io-uring@vger.kernel.org>; Thu, 18 Dec 2025 02:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766025908; cv=none; b=dMeXmffaa9dDYKnibSVJxVI2fpqj4M2zYwaYuP2qRLGPhHQtEnxcHMIW39d2f3mk9Qmh5oZ+IBAreCYO0wNg1QuoMhPIQnzI/hDg0lQ1pS8UBez3hLdSBGFAY2q2JhKeqD2tQUselHcQO0Xfp5lcy7ZPJOpQACAIoyVtfeUt+OE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766025908; c=relaxed/simple;
	bh=LbZ3r1FO6blMuhfRxt6WhD9bltWwdniPdYHLHEt70jo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GpcE23MrpTrhStYamQIe9txvdQ8gVY38ueKTmDoF9SgF0yGCx74SSgTFWJN+bqA4ZszBzRMCNQChCufwiJ65WLG/61+dRC6y9xybw00IOtztkemmRaFs5ARVK4xHaZ+9sBfF/HcY13FM+dFT/l/W2KFpS2NiIRB8VP5ENCH1N5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=KcQclCoL; arc=none smtp.client-ip=209.85.160.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-oa1-f97.google.com with SMTP id 586e51a60fabf-3ead10133b1so21970fac.0
        for <io-uring@vger.kernel.org>; Wed, 17 Dec 2025 18:45:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1766025904; x=1766630704; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mD3XkocdNT/jKO6xXmN59qwRMEBa7RKDVtIkI8u+RTk=;
        b=KcQclCoL/mBdYeDppoQlpVkSxtg1rLz/YhOgv2DRj6nV+PeauSDRmoBtUGbJGI0/+S
         uG9AVh+FX0nKpeKRBagKJ9l/wKvsA5VG9kohY0ew2zVFUT4f2b6vcXFm9DyXgAEFvHbt
         G13ty3EvDTonEGkZTSu5zf7z9mshroSsiMM33CdpFxDXOh61dJb5h0yOLgZZLCXctoRe
         HDnDLftKjKOIUcakO3D1Sl+iz4T0HcZb3c2zZPWEYAb/CwY9rxqKG3MH0vdGrgUTb6W7
         jI9yLbUqUpBQPuyf1y0ZMINmlnSo+IKA/9Jd9G0Kxdhpg4iqehJE95BXF6AMhQBxbyDk
         a3tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766025904; x=1766630704;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mD3XkocdNT/jKO6xXmN59qwRMEBa7RKDVtIkI8u+RTk=;
        b=CoFolrAxznqMCYr7Rh+EGPhLCfjFe8iTHlh2L60i+LvgF9Nc0n8sY+d4ok+DO0iVDM
         73awO4/eC/JUv7c/3vFHfCSEoonXm5OPqsryE902ACGC8gyJ3mDaDMKkF0xnxKJufW1X
         ChR3ta3iEF8azjodSqm8QYqTRCUuz1bObaaDKW7bIyV0vg+w9amY3C3ul7+eNIls9qel
         ITSiHNwEJhyyV0mBILuEsBN8OP06ipATyiQVBpOLtxobePKPmnPw1TBl0rePj8BC3LbH
         A3sc2A+ltlrzXVCvPb0KfDBgQpFFH8UGzoD+TeBmuU5xPsgUKkZ52wixVEd4k+ndEwBS
         c/NQ==
X-Forwarded-Encrypted: i=1; AJvYcCV3VO8gYm4Z6jB5wn2vxyfysNvSzW5Hn4Mzcaqnl+y7iYcy6LXX+3hOUz3lhUjZyVCjgU3Im3Ebrg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxWa1BSTng4Yy1oK+HQ5NmwFPBhpLImvHKYAOhU18KGb5VOOnDe
	k8714lsnxIoHjRzk11yH3YK08d+jiLSMNqzV5iMUun9M1YEBTwIrl3tm7dr1dp5RAtdMOIPykun
	8i8Z4xZscJTbe6bVh7kpWsZ0tdNGunWXf4RGW
X-Gm-Gg: AY/fxX5fs5k1fZsFcGI9o5JDyzUlvGSE3cgpGivTTcMrozZkP85BaYj00Ff07DH3/Kr
	qTcs6KRugymtMpAh+mYQ4D/RWZzk9MFvSoYw7po399SeYXeQ7m8juUSrsYr2NxAy0G2fprHoQMl
	zVLSqyhwG60DgwAoYXjA8Kkh4WuA2ajjd2Hov/gyX1K1/7D1InvnFIg85MSOrznVj5to7Px+bFZ
	i5MSpm4fxlYtLZNKOiVr2CekajYSs8+5jDgr3HJjuTrqhBxr0/ZvNzxSwnY8Tu+/hMCWxqriQbF
	EMqefuikFiO3oRaYlyTfO3Pcgl0fqPQJe1VLq9eatdHK6UEFPLXI5wIi4gsENfR6vdJa7qjfw1L
	byVoEb9iXxKvExQrh2wwNMCbNdNZmn9KGIjjZhcPmGA==
X-Google-Smtp-Source: AGHT+IErBFE11CWWforXCJrGX0oeKrN73fwb+L8zmbmh8PgxroZZBWNbtPisq6LiY5/QqEzyWv1mCKknEhT9
X-Received: by 2002:a05:6870:8327:b0:3ea:d0e3:9696 with SMTP id 586e51a60fabf-3fa1b14b6bbmr311098fac.9.1766025903797;
        Wed, 17 Dec 2025 18:45:03 -0800 (PST)
Received: from c7-smtp-2023.dev.purestorage.com ([208.88.159.129])
        by smtp-relay.gmail.com with ESMTPS id 586e51a60fabf-3fa18031fe5sm124135fac.15.2025.12.17.18.45.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Dec 2025 18:45:03 -0800 (PST)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (unknown [IPv6:2620:125:9007:640:ffff::1199])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id C824E340891;
	Wed, 17 Dec 2025 19:45:02 -0700 (MST)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id C68CDE41A49; Wed, 17 Dec 2025 19:45:02 -0700 (MST)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Joanne Koong <joannelkoong@gmail.com>,
	Caleb Sander Mateos <csander@purestorage.com>
Subject: [PATCH v6 4/6] io_uring: use io_ring_submit_lock() in io_iopoll_req_issued()
Date: Wed, 17 Dec 2025 19:44:57 -0700
Message-ID: <20251218024459.1083572-5-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20251218024459.1083572-1-csander@purestorage.com>
References: <20251218024459.1083572-1-csander@purestorage.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use the io_ring_submit_lock() helper in io_iopoll_req_issued() instead
of open-coding the logic. io_ring_submit_unlock() can't be used for the
unlock, though, due to the extra logic before releasing the mutex.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
Reviewed-by: Joanne Koong <joannelkoong@gmail.com>
---
 io_uring/io_uring.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 22086ac84278..ab0af4a38714 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1670,15 +1670,13 @@ void io_req_task_complete(struct io_tw_req tw_req, io_tw_token_t tw)
  * accessing the kiocb cookie.
  */
 static void io_iopoll_req_issued(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
-	const bool needs_lock = issue_flags & IO_URING_F_UNLOCKED;
 
 	/* workqueue context doesn't hold uring_lock, grab it now */
-	if (unlikely(needs_lock))
-		mutex_lock(&ctx->uring_lock);
+	io_ring_submit_lock(ctx, issue_flags);
 
 	/*
 	 * Track whether we have multiple files in our lists. This will impact
 	 * how we do polling eventually, not spinning if we're on potentially
 	 * different devices.
@@ -1701,11 +1699,11 @@ static void io_iopoll_req_issued(struct io_kiocb *req, unsigned int issue_flags)
 	if (READ_ONCE(req->iopoll_completed))
 		wq_list_add_head(&req->comp_list, &ctx->iopoll_list);
 	else
 		wq_list_add_tail(&req->comp_list, &ctx->iopoll_list);
 
-	if (unlikely(needs_lock)) {
+	if (unlikely(issue_flags & IO_URING_F_UNLOCKED)) {
 		/*
 		 * If IORING_SETUP_SQPOLL is enabled, sqes are either handle
 		 * in sq thread task context or in io worker task context. If
 		 * current task context is sq thread, we don't need to check
 		 * whether should wake up sq thread.
-- 
2.45.2


