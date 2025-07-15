Return-Path: <io-uring+bounces-8680-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 145FDB05AB6
	for <lists+io-uring@lfdr.de>; Tue, 15 Jul 2025 15:00:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 34C9C3B3BDD
	for <lists+io-uring@lfdr.de>; Tue, 15 Jul 2025 13:00:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E50211A2387;
	Tue, 15 Jul 2025 13:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="N9ThGKsZ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E138145355
	for <io-uring@vger.kernel.org>; Tue, 15 Jul 2025 13:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752584441; cv=none; b=Y0NsV6jRvSsaa5jkvVDj23NWFu2LoMwcTleGOa8SlD/k0Oy1LOqwJamoUyDb8un6EkZqKZhOFWyRZaIYyT9kVXcA9rHIo7D6cz9rZ6T5hXqPQRt72kCMPt5Jt9PcCHou5vFPxz6JZctmjJxeiBE36XB/Ku/ahWl7XCmmvCVk/no=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752584441; c=relaxed/simple;
	bh=s5cIcUPhwIp39aooWZIMdN9swiEqkCv/a4Z71bXWh8w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tA018HTs+dmaPEE90qeP0DpzzmP/9cgAiCwpElOke1y64luspy0KGv4g3YNRPNr3TgU+9YUSCUvZQhdweZyUEJSC2Ev6XREZWmLv56J2L9Hx/IyhedeXr5sdQQJeHxWkXI7STG0PcAknFmOpnRatSbCFknI1uTAlat2QFt2G3LY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=N9ThGKsZ; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-ae3a604b43bso903726166b.0
        for <io-uring@vger.kernel.org>; Tue, 15 Jul 2025 06:00:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1752584437; x=1753189237; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=IMaErcKY87+oe7IIj+5FeEg2QxypZsBQ6R3Z2+F9oFQ=;
        b=N9ThGKsZ1pAIgexv/9/y14VjMMfMGpKJBgE7FEHbu0EBl1m0/lUAi2VSG7NP6eZZ3L
         /jP5vKxkv8ElVaPGgZjU4RbD6QKmCOjY8nsyG41JHOTaM+2T02o3+taL6/HZ669AYgn9
         n0aHHrcSuYrIJKoSYIAPdIRzX45ISRDoQA70O0Gt2Bqt2CfNCeDPH6lG3nloj9MHBWwG
         1MJ92Grzc5UENXFxRpGyiGiYliHL+kK8SgiZlZoPVLTGmFKbHTEtA4+FIw59FtPzvqPX
         c0Mm30S/eiAKsv4KRv6/pCzs+/DNwMxf4/e42cfoigvnVSZYfr7YebRuvOJWLvcTjcVm
         BdHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752584437; x=1753189237;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IMaErcKY87+oe7IIj+5FeEg2QxypZsBQ6R3Z2+F9oFQ=;
        b=P1k/mKoz83mvjGCfTcue2iWfsZIkhlCrlN/rqsDe60tH0wqetIev5QleDYOVaX9duV
         MyLkr4U4RTxcq3cSTgT4TdDEpUbSCH1ZJZhrfBt0ViQN4MKmwqyYwRkj5V8XLrPWeV0x
         mUMbdIZn+B/b9ErMBzDJxtoYtLMbuE0buizOd89v92Axt8sKpKIkC308mW3YgITtw301
         rV5VXOeAmiob+JqMa/IUHHQAi1FFOzvrKJlaIUPWpWURb7VIk7KCXIPH7/LWS03S3wfI
         gSWnt9sKtVn9RUfOjNfen1aUx7FY+kuapuUrMyckrJ7r+TmzYDuaNnNjyycT2WbVnMH1
         Sdrg==
X-Gm-Message-State: AOJu0YxzYjK4qgcW870VfphiDrAnivqRf6KMtstfqVMaOQPAI9ueOpc9
	Wto4sbc2wjNRvIdm/8upX8uQxH3dcYDmTCVYvyN1C/gFuWHV/swX7AYyQZ4t7yTW
X-Gm-Gg: ASbGnctXluruRa7S9InJSfWAYFH+PUlGcsBuvBMyWwUlcdaiqLZlJnSmbdX149E+80y
	oeXVDEs2AYc0YmRNyYbo80yGETzH9bfStDCq58Z/ZPffZuf+A2Z9PWQ2Tro0WCSWzzo1/B459bn
	Mtd+QfFZYqYY4Cnfw3j8Ed5cZ+vTm2Xf8joIYmg19s48wFZ18lD0j38sdSbZk0xthBPQ94FKNrC
	flbMTV0PKRv/EMb/hfi4YK+oHMrpQ9coCNV1Z9NW5FtgqI6ka68+Ei5/pBIxuz+xIHACg4Sl4k/
	AA6DCVpvx3GmshCOjdFvx0ondpybWyXX7k/N+QTMGc55zX0Jh+iOt9ChnkhdLNjkrG01xi4/K5P
	eX3hUFitynI/apAhxvAxDel1e4ehc3XYsYQx2iezHIyQ9ZSZ964T1
X-Google-Smtp-Source: AGHT+IFfSardFp/EWazNipUsHgh0+uxIkPppzlkDDf5fdDwf0ulKwv3HIqJibQ/EbeOyW+XigMJpBA==
X-Received: by 2002:a17:907:9727:b0:ae3:cb50:2c6b with SMTP id a640c23a62f3a-ae6fbf61ab7mr1715424966b.38.1752584436865;
        Tue, 15 Jul 2025 06:00:36 -0700 (PDT)
Received: from asahi-studio.maurer.localnet ([2a02:908:2615:1680:3b5b:893:9595:77c2])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ae6e7ee471asm1016043466b.54.2025.07.15.06.00.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Jul 2025 06:00:36 -0700 (PDT)
From: Norman Maurer <norman.maurer@googlemail.com>
X-Google-Original-From: Norman Maurer <norman_maurer@apple.com>
To: io-uring@vger.kernel.org
Cc: axboe@kernel.dk,
	Norman Maurer <norman_maurer@apple.com>
Subject: [PATCH] io_uring/net: Support multishot receive len cap
Date: Tue, 15 Jul 2025 15:00:26 +0200
Message-ID: <20250715130026.48204-1-norman_maurer@apple.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

At the moment its very hard to do fine grained backpressure when using
multishot as the kernel might produce a lot of completions before the
user has a chance to cancel a previous submitted multishot recv.

This change adds support to issue a multishot recv that is capped by a
len, which means the kernel will only rearm until X amount of data is
received. When the limit is reached the completion will signal to the
user that a re-arm needs to happen manually by not setting the IORING_CQE_F_MORE
flag.
---
 io_uring/net.c | 38 +++++++++++++++++++++++++++++++++++---
 1 file changed, 35 insertions(+), 3 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 639f111408a1..9965976c9a98 100644
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
@@ -89,10 +92,14 @@ enum sr_retry_flags {
 	IORING_RECV_RETRY	= (1U << 15),
 	IORING_RECV_PARTIAL_MAP	= (1U << 14),
 	IORING_RECV_MSHOT_CAP	= (1U << 13),
+	IORING_RECV_MSHOT_LIM	= (1U << 12),
+	IORING_RECV_MSHOT_DONE	= (1U << 11),
 
 	IORING_RECV_RETRY_CLEAR	= IORING_RECV_RETRY | IORING_RECV_PARTIAL_MAP,
 	IORING_RECV_NO_RETRY	= IORING_RECV_RETRY | IORING_RECV_PARTIAL_MAP |
 				  IORING_RECV_MSHOT_CAP,
+	IORING_RECV_INTERNAL	= IORING_RECV_RETRY | IORING_RECV_PARTIAL_MAP |
+				  IORING_RECV_MSHOT_CAP | IORING_RECV_MSHOT_DONE,
 };
 
 /*
@@ -765,7 +772,7 @@ int io_recvmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 	sr->done_io = 0;
 
-	if (unlikely(sqe->file_index || sqe->addr2))
+	if (unlikely(sqe->addr2))
 		return -EINVAL;
 
 	sr->umsg = u64_to_user_ptr(READ_ONCE(sqe->addr));
@@ -790,16 +797,25 @@ int io_recvmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
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
@@ -831,6 +847,19 @@ static inline bool io_recv_finish(struct io_kiocb *req, int *ret,
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
 
@@ -1094,6 +1123,9 @@ static int io_recv_buf_select(struct io_kiocb *req, struct io_async_msghdr *kmsg
 		else if (kmsg->msg.msg_inq > 1)
 			arg.max_len = min_not_zero(*len, (size_t) kmsg->msg.msg_inq);
 
+		/* if mshot limited, ensure we don't go over */
+		if (sr->flags & IORING_RECV_MSHOT_LIM)
+			arg.max_len = min_not_zero(arg.max_len, sr->mshot_total_len);
 		ret = io_buffers_peek(req, &arg);
 		if (unlikely(ret < 0))
 			return ret;
-- 
2.50.1


