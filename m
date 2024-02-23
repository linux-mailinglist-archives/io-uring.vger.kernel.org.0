Return-Path: <io-uring+bounces-674-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 31CC5860A55
	for <lists+io-uring@lfdr.de>; Fri, 23 Feb 2024 06:40:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 54C871C225B8
	for <lists+io-uring@lfdr.de>; Fri, 23 Feb 2024 05:40:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 681BD11197;
	Fri, 23 Feb 2024 05:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="OZo9vYjS"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2476F9EB
	for <io-uring@vger.kernel.org>; Fri, 23 Feb 2024 05:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708666824; cv=none; b=ap2H7Ea+19nlVDl9y/kWvVSyZNQOH+OTLHuJTy6G0RCnP0narFcXijySbIIA0m2+GvhNxAISz9lFXh+m8Mi6hZVOblZD4T3VO0Sjybl2pca0bTMJsDEMHsriPD4Ust98gIz1zGlxbpJDf63F3exvYpZjpXAEyvOQT+f4PvqYUUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708666824; c=relaxed/simple;
	bh=VlWIrU1EzXJop+eVF3E7gei2iW3/ujEZ2NEk6f3yWD8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=sR6CtxkPPvTgerTBLh4OuTa7EY22S/0OxcJWRuUpstjGI1PVwdHppsQ2dWE8ZCuWCWDEp9L1zqOpq3S8JoprKreQyXMup2X2bxK5B7zL+nT26VIpPgVDtJi5wGBnjFxpI1JJpeIMET0mNg507sIf0hv6CYwlpF0NmBGjkorlv+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=OZo9vYjS; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-5dbd519bde6so2937a12.1
        for <io-uring@vger.kernel.org>; Thu, 22 Feb 2024 21:40:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1708666822; x=1709271622; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ZT/3e7nVYk/9oLBn+P5fE6PuRKdC7ZmYDLdixWS5CtQ=;
        b=OZo9vYjSqV/Mh0F6BZV/594lJJgR5B9XJTnbW+7fRfY1XiPz1KaA0HJjQ9jxhSNF4F
         0/rGVlP/sPGwBUeQb9nx/EGzZ77boj8+7Etcv0SR1NZ916XXiNPenFydxfzLqZ7bB0QN
         plUrjny8QvX0ZEsB173ps4iWT0/Gz5KEJVT6DDQN36LVP0sOjc6eIKJciAijCbFeKNxU
         H5cyTsE4piQSgiLbOFbRXQi4HULL9j0VgZVd/Y/8h+9195CWjwEbhBpxSUMhUuhxTOLQ
         swmX/PL04LNuNqxXBGVlPkCELqhoTRs/WAG40uRc5DAWtehD92l2T3WD2xFlZAH0Zde9
         DayQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708666822; x=1709271622;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZT/3e7nVYk/9oLBn+P5fE6PuRKdC7ZmYDLdixWS5CtQ=;
        b=CCvtwhHa4zdUTqSA3WM9pTzY2fwiVO830Hgxu6+8l+hGTVs4VwPb1tbYTFPKXV+NOO
         MOlkdL+4maQRxMqplC99prcTZDdc/5/ku4FhsGErhGUysOsRIbjn6tbY+NaHIukvWmd2
         FsHpAikN4U9qc4dAL6zVUj0ABXf0HyUQ2lijj/W1j1CRpCbJIa2PGkzflfrmOOks/cqn
         Wl6Za/K0z6ftBtjE0dz2T+kBC/oblWPcF8DhyqPVoC7hHegyRdV3wSlAQ/c2YkhQhUud
         +9rVLTfi8LAZ24QInbXdpyf8Sfo1/HfqziLqvVi1gkY+nd0eNHj+JIrpNbnGyYAPE6Uw
         KQMQ==
X-Gm-Message-State: AOJu0YwrWZkWTkcGZJwaDenKKcF/fUksPq4zJ3u4ObJH+wP0aVCxqe8K
	CVLvBD9Je/6osez+ZG3034zyV3FjiNNaLyBGjl1o0uvCLw8caemf3Jx4tKwZc6x+8jPvCkC71AQ
	F
X-Google-Smtp-Source: AGHT+IEtzGQegjlT/N42BINWO/fjVsesBd8D+HX/g9vbeNjFKHraFfr/HB/j5pECmDWfB+xFnFSLrQ==
X-Received: by 2002:a05:6a20:7828:b0:1a0:785c:58c2 with SMTP id a40-20020a056a20782800b001a0785c58c2mr700718pzg.61.1708666821708;
        Thu, 22 Feb 2024 21:40:21 -0800 (PST)
Received: from localhost (fwdproxy-prn-001.fbsv.net. [2a03:2880:ff:1::face:b00c])
        by smtp.gmail.com with ESMTPSA id 4-20020a170902c14400b001dc3c4e7a12sm3298274plj.14.2024.02.22.21.40.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Feb 2024 21:40:21 -0800 (PST)
From: David Wei <dw@davidwei.uk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Subject: [RFC PATCH v1] io_uring: only account cqring wait time as iowait if enabled for a ring
Date: Thu, 22 Feb 2024 21:40:12 -0800
Message-Id: <20240223054012.3386196-1-dw@davidwei.uk>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently we unconditionally account time spent waiting for events in CQ
ring as iowait time.

Some userspace tools consider iowait time to be CPU util/load which can
be misleading as the process is sleeping. High iowait time might be
indicative of issues for storage IO, but for network IO e.g. socket
recv() we do not control when the completions happen.

This patch gates the previously unconditional iowait accounting behind a
new IORING_REGISTER opcode. By default time is not accounted as iowait,
unless this is explicitly enabled for a ring. Thus userspace can decide,
depending on the type of work it expects to do, whether it wants to
consider cqring wait time as iowait or not.

I've marked the patch as RFC because it is lacking tests. I will add
them in the final patch, but for now I'd like to get some thoughts on
the approach. For example, does the API need an unregister, or take a
bool?

Signed-off-by: David Wei <dw@davidwei.uk>
---
 include/linux/io_uring_types.h |  3 +++
 include/uapi/linux/io_uring.h  |  3 +++
 io_uring/io_uring.c            |  9 +++++----
 io_uring/register.c            | 12 ++++++++++++
 4 files changed, 23 insertions(+), 4 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index bd7071aeec5d..57318fc01379 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -425,6 +425,9 @@ struct io_ring_ctx {
 	DECLARE_HASHTABLE(napi_ht, 4);
 #endif
 
+	/* iowait accounting */
+	bool				iowait_enabled;
+
 	/* protected by ->completion_lock */
 	unsigned			evfd_last_cq_tail;
 
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 7bd10201a02b..b068898c2283 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -575,6 +575,9 @@ enum {
 	IORING_REGISTER_NAPI			= 27,
 	IORING_UNREGISTER_NAPI			= 28,
 
+	/* account time spent in cqring wait as iowait */
+	IORING_REGISTER_IOWAIT			= 29,
+
 	/* this goes last */
 	IORING_REGISTER_LAST,
 
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index cf2f514b7cc0..7f8d2a03cce6 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2533,12 +2533,13 @@ static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
 		return 0;
 
 	/*
-	 * Mark us as being in io_wait if we have pending requests, so cpufreq
-	 * can take into account that the task is waiting for IO - turns out
-	 * to be important for low QD IO.
+	 * Mark us as being in io_wait if we have pending requests if enabled
+	 * via IORING_REGISTER_IOWAIT, so cpufreq can take into account that
+	 * the task is waiting for IO - turns out to be important for low QD
+	 * IO.
 	 */
 	io_wait = current->in_iowait;
-	if (current_pending_io())
+	if (ctx->iowait_enabled && current_pending_io())
 		current->in_iowait = 1;
 	ret = 0;
 	if (iowq->timeout == KTIME_MAX)
diff --git a/io_uring/register.c b/io_uring/register.c
index 99c37775f974..7cbc08544c4c 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -387,6 +387,12 @@ static __cold int io_register_iowq_max_workers(struct io_ring_ctx *ctx,
 	return ret;
 }
 
+static int io_register_iowait(struct io_ring_ctx *ctx)
+{
+	ctx->iowait_enabled = true;
+	return 0;
+}
+
 static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 			       void __user *arg, unsigned nr_args)
 	__releases(ctx->uring_lock)
@@ -563,6 +569,12 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 			break;
 		ret = io_unregister_napi(ctx, arg);
 		break;
+	case IORING_REGISTER_IOWAIT:
+		ret = -EINVAL;
+		if (arg || nr_args)
+			break;
+		ret = io_register_iowait(ctx);
+		break;
 	default:
 		ret = -EINVAL;
 		break;
-- 
2.39.3


