Return-Path: <io-uring+bounces-13865-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id heLWHl7MRGpe1AoAu9opvQ
	(envelope-from <io-uring+bounces-13865-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 01 Jul 2026 10:14:22 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id E6AD66EAFF9
	for <lists+io-uring@lfdr.de>; Wed, 01 Jul 2026 10:14:21 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ToWtwRqb;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13865-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.105.105.114 as permitted sender) smtp.mailfrom="io-uring+bounces-13865-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 79D34306411A
	for <lists+io-uring@lfdr.de>; Wed,  1 Jul 2026 08:12:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9551C3DF01F;
	Wed,  1 Jul 2026 08:11:58 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B583F3E1696
	for <io-uring@vger.kernel.org>; Wed,  1 Jul 2026 08:11:50 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782893518; cv=none; b=FbeWpIC/Us+ncFDFEQKTWyH4ORhNRaxQs+y+lT6EY1lXtI9Blvc01FM4NleL8ADufg7wJVPwqP7XNrXKMFVyBe2bKk/64lTIteGsaz4v0QR1sisEHMpvf+gb7GGrXJAJW3IYw3KPFPhTIspa1QGAFEWgkBXvMvGLEH+c1W3l394=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782893518; c=relaxed/simple;
	bh=8D3HGjKY4B2nWaRqyqClM3G4Q/AKoHTj919BBG9gMug=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=DKgg4DHkAYblCMvtb82Hq+F6Icp0yxu2SJ3PvzQuX+zQb1aXTFHUdwTRB3ddVqyc6zOaqWiNJLyXSSi7AbF1LO3NvqPnMZfzwCyo5Fb4/3RrrcVMJHwCnfnSwTLJgn1NwTFLk/Xcfn5Z7l2B20UY3bhQKR5j64kj4xXlflnsdDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ToWtwRqb; arc=none smtp.client-ip=209.85.208.172
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-39b349ae174so822161fa.1
        for <io-uring@vger.kernel.org>; Wed, 01 Jul 2026 01:11:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782893509; x=1783498309; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=2JRU5KzlpmqExlTSewb94kl93z3gGd+KqfKhU1JZClg=;
        b=ToWtwRqbeNSjD/wnHJsZoLnWX7QjgzlE/0j2VD+/CaXm62MMM3Si1QDSfYj7TF3kbV
         LNvohrVpJ3PjcIjzzxbj0nku6wlxr3vh3cbILZ63NSp40y9azmdDX3ScN+0lgTKgZ7YA
         3gw/IhHDLQ26IFiP4mVkeembAmXgh+hjzjCd6jh9xrfqr8w/ngBcji/kk2Yo7j3VTwMK
         2GxL41c5SpRxy46P1xB9k2GXvoWeOQYu9W2guboAy0HxFwpZFG6HoRlSvBlhClDZgqtF
         h8veoYozhXjtfF+aY80spvTnghXFmOzhxbtRsIZNLC5syKOT6hQ8MINAXctbnZ5u2I4r
         rRZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782893509; x=1783498309;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2JRU5KzlpmqExlTSewb94kl93z3gGd+KqfKhU1JZClg=;
        b=cT083yt0XwzQWDcsux3NZPkmH2SGPBRhhyuK0hoNfWOSaYOqCUw9OAej+YalqiV00J
         Y0ogRUT9M4zqfUzKwdc29XsWnzlSh/ETHti1j3+xWNyMog8HfPUGHTSK8bTwpBwdsaPA
         mwH00qWJQBrQQyGxYE3D4+oV54RrQ+MZ7DAstGaI25IJy4/7zG0xcd1jbVzvzs5ZFa5J
         latilLJc5JVrD1pVnf/yZ7tRAMnGLjyc4aj5nSZHtYT5BiIK7WKXNROV8Ta5YgcGrbQ1
         0urlONll59KcXBoNv1fC39DuVxnLwV2QieVRXw/YpP6tCRMwUeLq1A5YfuaEVg7oLF07
         ntRg==
X-Gm-Message-State: AOJu0YzjvIr4SgAy+tvvfq/8fyTE6CLBfIu5z18GgE/A+4WsY63kY69o
	LWqBKiykjlVBiAksKS/Ir+xrKQ4Dups3Hpa3NdkE2XPKnUOpjfZv+OK2
X-Gm-Gg: AfdE7clrxCqDH0S0TVWnWh5FWYqZqnBF3d/gPZ1kIKLIZGQMh47dg6D4ZsGhszM0jX0
	LrjdacEMIbmWybnyQ2XtV4tVms5tarp6MqKU0Qd2QqFO/PfriSSiwgad3xGetMyB13Exu8nEjzg
	RXGYSMeTR7g+HRq5eBKNHorClfOsau6MvwP9yxWPHpD9VXyTL3ISGUYfDrthF8h1duxJ+PigBYf
	9/OfHehGRV1q/QCZtSKp2Llar4ksY1hfPT0FfjvCMhlbz3qjDAkEq58oJ/xde+KAJ4D11gT2Bwu
	rkWKj7TCnRDMEBHfTH7Sl+3XmJuJvV29hCK0ua5Ac+/f1tOPDp8kxZ7LnIINO70nct44fhtJO1G
	3EiV2iLxsZ70Aui5088ugsJCeVm10/rvAJ4KNIUjQZlbQ60f6WBbowPegzVudq/d41OXfTwtBtv
	5WD/TVQTdH7QFCLgLH9g1yNC0er1PYnzs=
X-Received: by 2002:a2e:9296:0:b0:396:9630:5ed with SMTP id 38308e7fff4ca-39b340101afmr980441fa.15.1782893508329;
        Wed, 01 Jul 2026 01:11:48 -0700 (PDT)
Received: from localhost.localdomain ([2a01:4f9:2a:1c13::2])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-39b2f6f9e63sm2727001fa.11.2026.07.01.01.11.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2026 01:11:47 -0700 (PDT)
From: Melbin K Mathew <mlbnkm1@gmail.com>
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Melbin K Mathew <mlbnkm1@gmail.com>
Subject: [PATCH io_uring] io_uring/msg_ring: reject CQE32 flag pass-through to normal rings
Date: Wed,  1 Jul 2026 10:11:45 +0200
Message-Id: <20260701081145.196730-1-mlbnkm1@gmail.com>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,gmail.com];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-13865-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER(0.00)[mlbnkm1@gmail.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS(0.00)[m:axboe@kernel.dk,m:io-uring@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:mlbnkm1@gmail.com,s:lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	FREEMAIL_FROM(0.00)[gmail.com];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mlbnkm1@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	RCVD_COUNT_FIVE(0.00)[5];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	ALIAS_RESOLVED(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: E6AD66EAFF9

IORING_OP_MSG_RING with IORING_MSG_RING_FLAGS_PASS allows a sender to
pass completion flags through sqe->file_index. If the sender sets
IORING_CQE_F_32 in file_index, the target-side completion path treats
it as a 32-byte CQE and writes big_cqe[0] and big_cqe[1] into the CQ
ring regardless of whether the target ring was created with
IORING_SETUP_CQE32 or IORING_SETUP_CQE_MIXED.

On a normal 16-byte CQE ring, this writes 16 extra bytes (two u64
big_cqe fields) into the next CQE slot in the ring buffer. This was
confirmed by poisoning the adjacent slot with known values and observing
them being overwritten after the pass-through, while the CQ tail
advanced by only one slot.

Add a helper io_msg_ring_cqe_flags() that validates the flags before
they are forwarded, and use it in both the local and remote data paths.
Reject with -EINVAL when IORING_CQE_F_32 is passed to a ring that does
not support CQE32 or mixed CQE modes. In the remote path, this guard
runs before the target request allocation to avoid a leak on error.

Fixes: cbeb47a7b5f0 ("io_uring/msg_ring: Pass custom flags to the cqe")
Signed-off-by: Melbin K Mathew <mlbnkm1@gmail.com>
---
Notes:
    Testing on Linux 7.2-rc1 with KASAN and UBSAN enabled:

    Unpatched kernel: MSG_RING with IORING_MSG_RING_FLAGS_PASS and
    IORING_CQE_F_32 posts CQE_F_32 to a normal target ring. Target CQ
    tail advances by one while the adjacent unpublished CQ slot is
    overwritten (confirmed by poisoning the adjacent slot with known
    values and observing them zeroed after the pass-through).

    Patched kernel: sender receives -EINVAL. Target CQ tail does not
    advance. Adjacent poisoned slot remains intact.

    git apply --check: OK
    checkpatch --strict: 0 errors, 0 warnings, 0 checks
    make W=1 io_uring/msg_ring.o: clean

 io_uring/msg_ring.c | 34 +++++++++++++++++++++++++++-------
 1 file changed, 27 insertions(+), 7 deletions(-)

diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
index 3ff9098573..3067c93439 100644
--- a/io_uring/msg_ring.c
+++ b/io_uring/msg_ring.c
@@ -93,19 +93,38 @@ static void io_msg_remote_post(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	io_req_task_work_add_remote(req, IOU_F_TWQ_LAZY_WAKE);
 }
 
+static int io_msg_ring_cqe_flags(struct io_ring_ctx *target_ctx,
+				 const struct io_msg *msg, u32 *flags)
+{
+	*flags = 0;
+
+	if (!(msg->flags & IORING_MSG_RING_FLAGS_PASS))
+		return 0;
+
+	*flags = msg->cqe_flags;
+	if ((*flags & IORING_CQE_F_32) &&
+	    !(target_ctx->flags & (IORING_SETUP_CQE32 |
+				   IORING_SETUP_CQE_MIXED)))
+		return -EINVAL;
+
+	return 0;
+}
+
 static int io_msg_data_remote(struct io_ring_ctx *target_ctx,
 			      struct io_msg *msg)
 {
 	struct io_kiocb *target;
-	u32 flags = 0;
+	u32 flags;
+	int ret;
 
-	target = kmem_cache_alloc(req_cachep, GFP_KERNEL | __GFP_NOWARN | __GFP_ZERO)  ;
+	ret = io_msg_ring_cqe_flags(target_ctx, msg, &flags);
+	if (ret)
+		return ret;
+
+	target = kmem_cache_alloc(req_cachep, GFP_KERNEL | __GFP_NOWARN | __GFP_ZERO);
 	if (unlikely(!target))
 		return -ENOMEM;
 
-	if (msg->flags & IORING_MSG_RING_FLAGS_PASS)
-		flags = msg->cqe_flags;
-
 	io_msg_remote_post(target_ctx, target, msg->len, flags, msg->user_data);
 	return 0;
 }
@@ -130,8 +149,9 @@ static int __io_msg_ring_data(struct io_ring_ctx *target_ctx,
 	if (io_msg_need_remote(target_ctx))
 		return io_msg_data_remote(target_ctx, msg);
 
-	if (msg->flags & IORING_MSG_RING_FLAGS_PASS)
-		flags = msg->cqe_flags;
+	ret = io_msg_ring_cqe_flags(target_ctx, msg, &flags);
+	if (ret)
+		return ret;
 
 	ret = -EOVERFLOW;
 	if (target_ctx->flags & IORING_SETUP_IOPOLL) {
-- 
2.39.5


