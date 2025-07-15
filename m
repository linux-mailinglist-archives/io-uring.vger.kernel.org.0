Return-Path: <io-uring+bounces-8682-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BEFB2B060D6
	for <lists+io-uring@lfdr.de>; Tue, 15 Jul 2025 16:24:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 13B03179A07
	for <lists+io-uring@lfdr.de>; Tue, 15 Jul 2025 14:14:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC6CD2036E9;
	Tue, 15 Jul 2025 14:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="kUJvksnU"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC5F2221F34
	for <io-uring@vger.kernel.org>; Tue, 15 Jul 2025 14:03:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752588196; cv=none; b=sVbHawbJjcNOED6bytdNuBsQyC1nYsKZsi+cMMWPHScYOz+pw3aY7CM47iFixV7TCcagwZtY34GRaMlFWLrUjkRAG05BkYmtBkCATyc1vtb6sqsUWb//HTE7Fqakmtq9G3JDNr4qAH8SYfbxoVKz7x8y2t5LqImp4MI65v4ZsBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752588196; c=relaxed/simple;
	bh=bkpHsQj2Re0W8JP0xIcyarAFyEUo78J0kVGwUIcNPm4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=t3+GNsmlD4oj3WJEidCwTz5AlKiRf8rriKxca1LaFaeOAkzfVfG3ViVEGMXruIavge6yOSW/cbtC9jIxI5E7uhkTaRt+IvB4xswiBWm/9JJYpujUJSPdM/98JVRaVSXz8vFKH6hD3XHaRUg0lMrmrC2VRtP1jESMWbliCYvIAmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=kUJvksnU; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-3a52874d593so4375084f8f.0
        for <io-uring@vger.kernel.org>; Tue, 15 Jul 2025 07:03:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1752588193; x=1753192993; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=sQ+gouQzbsEUYLKnzU6K51ZK0jYkFQgWJBKdo/TQqbQ=;
        b=kUJvksnUQhtoSiHMxtEX/T4yMH5sJD0FX3Ors458IBt1PZdiaOwMOFPkhBF4AvN7pi
         ABJt0CILwI+pOkztkJkLYJzL9SN1d52/SIwHQFqi0Aq0b/lsS76kzGoJco+iYsYq+vZt
         H+NGeAWmtJFFFitUP6KZLO4DZSAc30DmvHSEBth49jePshIdlmGJoCo2U10jPoWRgB0k
         nPiKBw8ziauZhr7/PGp8IYlgMUJ6PX2ljAZTCX+nCtYlYCcqTiXda9c4u/ENyl9w8hph
         NhIcmtdq8c3xJr9dm2Ao/OVQM9f7k1g0qYAUObJD2/Mafu23w2ehHZJFqpX69zBMg9ah
         1+/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752588193; x=1753192993;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sQ+gouQzbsEUYLKnzU6K51ZK0jYkFQgWJBKdo/TQqbQ=;
        b=TF1adINRDSYdiRWh273Az4lLnOTLALyV3OcL13VvWlH5d16BQJpsyH8RxQxuSY2zmD
         MxD+c92IxAyXUVOE91IAN8Cj/u++JBVQnd2I3IqaozOJLpGVs/mSPQl+W3oh20ht8k7o
         t5oFeQuiMoXR55juKF6ArzKXN8TRyVReyLTR96AYyn2cr5RXUNJxcW3xRa0Sd2Q+ihcm
         umj9yypbP74zVY6iEIEQhHw6lIjuvtNot//wYmFBgN82+HpDOYu5tTFRE1eg5O2AV2Wq
         2ekM9KvxB+NvfoAibSBnhc2HmO8vCzjQmNFkrn4/87Xcj0B/+RpXrC4w1ebONEYujLOH
         hRsQ==
X-Gm-Message-State: AOJu0Yyus+GiSfnCnlmiQPW2WfHAjm4YzI9VSDEfdD+MTYmfTcxcfBsg
	pbJqdxbbLD1MoYgxTiKaRC7iLSjmmWvC0Gws5zsObqHVwKOruJMs/+Fu+RfPZgFV
X-Gm-Gg: ASbGncta2QdivuF2UmDoIBX1ggu9wfwXtfqU2ETOUxKGW/wHK/9YnZXfnmZjsz/53L+
	jUYXBvFMcoZQyWsoga9QlS3KNx3L4E06o5wzKBBnBV6WT1922BPA3V798bF6dyks+vZ5vfcLlRo
	F1KVP/EV6VJuPHtszoIF0HnQ2sx8fvX/qAgAIWqtzWqz4ILZvoPbl5ms1uKGy9wiqTJ2zpghQc1
	d9YpG3uUJBJIv0BuOLEQXm7BsH+fZMkI94K7aYhqqXOwELYiiVb+gzym16IbrzbJLAhld+mWUyL
	dYbAi2N1hlm8NYJK70qazJ067pr8W8lB1zZSZo2FVplIGy9GMMyn4KG110su/svnaMFV+BBkQJL
	E0WetxchfFs8FI5giHMTufV5VXe5F304r9+sa83vcx9i61NE20aDyUmxwThkiqyI61Ag6NPYI7A
	IogaAcgH5owOLDgWWw6xYQNIoS2D8H6eFasFU=
X-Google-Smtp-Source: AGHT+IF/sbmFGbbDv8ry4DUO6W7qIN/bqd5R1iTAfjIjcdkjgUn0UBcl7AYE7phX5hlBOtBZ4Ahn+Q==
X-Received: by 2002:a05:6000:2507:b0:3a4:e1e1:7779 with SMTP id ffacd0b85a97d-3b5f18d98abmr15213732f8f.32.1752588192504;
        Tue, 15 Jul 2025 07:03:12 -0700 (PDT)
Received: from am11p01nt-relayp04.apple.com (ip-088-152-091-198.um26.pools.vodafone-ip.de. [88.152.91.198])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b5e8bd1a2bsm15492857f8f.14.2025.07.15.07.03.11
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 15 Jul 2025 07:03:12 -0700 (PDT)
From: norman.maurer@googlemail.com
X-Google-Original-From: norman_maurer@apple.com
To: io-uring@vger.kernel.org
Cc: axboe@kernel.dk,
	Norman Maurer <norman_maurer@apple.com>
Subject: [PATCH v2] io_uring/net: Support multishot receive len cap
Date: Tue, 15 Jul 2025 16:02:50 +0200
Message-Id: <20250715140249.31186-1-norman_maurer@apple.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Norman Maurer <norman_maurer@apple.com>

At the moment its very hard to do fine grained backpressure when using
multishot as the kernel might produce a lot of completions before the
user has a chance to cancel a previous submitted multishot recv.

This change adds support to issue a multishot recv that is capped by a
len, which means the kernel will only rearm until X amount of data is
received. When the limit is reached the completion will signal to the
user that a re-arm needs to happen manually by not setting the IORING_CQE_F_MORE
flag.

Signed-off-by: Norman Maurer <norman_maurer@apple.com>
---
Changes since v1: Correct author, include Signed-off-by, fix merge resolution
---

 io_uring/net.c | 38 ++++++++++++++++++++++++++++++++++----
 1 file changed, 34 insertions(+), 4 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 639f111408a1..ba2d0abea349 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -75,7 +75,10 @@ struct io_sr_msg {
 	u16				flags;
 	/* initialised and used only by !msg send variants */
 	u16				buf_group;
+	/* per-invocation mshot limit */
 	unsigned			mshot_len;
+	/* overall mshot byte limit */
+	unsigned			mshot_total_len;
 	void __user			*msg_control;
 	/* used only for send zerocopy */
 	struct io_kiocb 		*notif;
@@ -89,10 +92,12 @@ enum sr_retry_flags {
 	IORING_RECV_RETRY	= (1U << 15),
 	IORING_RECV_PARTIAL_MAP	= (1U << 14),
 	IORING_RECV_MSHOT_CAP	= (1U << 13),
+	IORING_RECV_MSHOT_LIM	= (1U << 12),
+	IORING_RECV_MSHOT_DONE	= (1U << 11),
 
 	IORING_RECV_RETRY_CLEAR	= IORING_RECV_RETRY | IORING_RECV_PARTIAL_MAP,
 	IORING_RECV_NO_RETRY	= IORING_RECV_RETRY | IORING_RECV_PARTIAL_MAP |
-				  IORING_RECV_MSHOT_CAP,
+				  IORING_RECV_MSHOT_CAP | IORING_RECV_MSHOT_DONE,
 };
 
 /*
@@ -765,7 +770,7 @@ int io_recvmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 	sr->done_io = 0;
 
-	if (unlikely(sqe->file_index || sqe->addr2))
+	if (unlikely(sqe->addr2))
 		return -EINVAL;
 
 	sr->umsg = u64_to_user_ptr(READ_ONCE(sqe->addr));
@@ -790,16 +795,25 @@ int io_recvmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		sr->buf_group = req->buf_index;
 		req->buf_list = NULL;
 	}
-	sr->mshot_len = 0;
+	sr->mshot_total_len = sr->mshot_len = 0;
 	if (sr->flags & IORING_RECV_MULTISHOT) {
 		if (!(req->flags & REQ_F_BUFFER_SELECT))
 			return -EINVAL;
 		if (sr->msg_flags & MSG_WAITALL)
 			return -EINVAL;
-		if (req->opcode == IORING_OP_RECV)
+		if (req->opcode == IORING_OP_RECV) {
 			sr->mshot_len = sr->len;
+			sr->mshot_total_len = READ_ONCE(sqe->optlen);
+			if (sr->mshot_total_len)
+				sr->flags |= IORING_RECV_MSHOT_LIM;
+		} else if (sqe->optlen) {
+			return -EINVAL;
+		}
 		req->flags |= REQ_F_APOLL_MULTISHOT;
+	} else if (sqe->optlen) {
+		return -EINVAL;
 	}
+
 	if (sr->flags & IORING_RECVSEND_BUNDLE) {
 		if (req->opcode == IORING_OP_RECVMSG)
 			return -EINVAL;
@@ -831,6 +845,19 @@ static inline bool io_recv_finish(struct io_kiocb *req, int *ret,
 	if (kmsg->msg.msg_inq > 0)
 		cflags |= IORING_CQE_F_SOCK_NONEMPTY;
 
+	if (*ret > 0 && sr->flags & IORING_RECV_MSHOT_LIM) {
+		/*
+		 * If sr->len hits zero, the limit has been reached. Mark
+		 * mshot as finished, and flag MSHOT_DONE as well to prevent
+		 * a potential bundle from being retried.
+		 */
+		sr->mshot_total_len -= min_t(int, *ret, sr->mshot_total_len);
+		if (!sr->mshot_total_len) {
+			sr->flags |= IORING_RECV_MSHOT_DONE;
+			mshot_finished = true;
+		}
+	}
+
 	if (sr->flags & IORING_RECVSEND_BUNDLE) {
 		size_t this_ret = *ret - sr->done_io;
 
@@ -1094,6 +1121,9 @@ static int io_recv_buf_select(struct io_kiocb *req, struct io_async_msghdr *kmsg
 		else if (kmsg->msg.msg_inq > 1)
 			arg.max_len = min_not_zero(*len, (size_t) kmsg->msg.msg_inq);
 
+		/* if mshot limited, ensure we don't go over */
+		if (sr->flags & IORING_RECV_MSHOT_LIM)
+			arg.max_len = min_not_zero(arg.max_len, sr->mshot_total_len);
 		ret = io_buffers_peek(req, &arg);
 		if (unlikely(ret < 0))
 			return ret;
-- 
2.39.5 (Apple Git-154)


