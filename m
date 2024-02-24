Return-Path: <io-uring+bounces-687-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 25C898622AE
	for <lists+io-uring@lfdr.de>; Sat, 24 Feb 2024 06:07:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 12299B2294C
	for <lists+io-uring@lfdr.de>; Sat, 24 Feb 2024 05:07:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 172F314006;
	Sat, 24 Feb 2024 05:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="j/Mlo/jW"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f169.google.com (mail-il1-f169.google.com [209.85.166.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6285B12B66
	for <io-uring@vger.kernel.org>; Sat, 24 Feb 2024 05:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708751269; cv=none; b=hV1jOS0Tdv6DUy/tATltpgrVqXdcLoWooYVYIpwCgq2uOTKugL5vasSXkxPvSZcz5maO+ogvE/9ASvCc/ejuTt9Vv7iKsZ8yHY30Bvv9gnI27x/9ybsVI7P+NyFQIt6SeuSTcmWPUe5b+au2pdYOF+J4eb/+IUzaK+M/jJ8trsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708751269; c=relaxed/simple;
	bh=F91BiQ6O1mlQE+A4+9Lsnj2wEnbcDpwImoZ96TkvNac=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MMBhj8wzMHu7d2mhVoTzaBNsZaozAG2b890nlEqfVTxNf+rUoE1pKsWudKqmNpB52gUWHt9v1iEpR+rxmWn34OwqHfcUxEwgcL4xzuJdU3cMIWwLpAIRQAF0SlnaXTilWXLJHrrDRCEG590lF2yWtNuljpPe9n8OuyYKBjh7csI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=j/Mlo/jW; arc=none smtp.client-ip=209.85.166.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-il1-f169.google.com with SMTP id e9e14a558f8ab-36523b9fa11so5337695ab.3
        for <io-uring@vger.kernel.org>; Fri, 23 Feb 2024 21:07:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1708751266; x=1709356066; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+wPGmxuJ4SPc/NqTmX1iLEmNyhHARVyyFYwhGzxPm8Q=;
        b=j/Mlo/jWhOD9B/aa6NV/Me4aFwbQ5qjc/CuHEKX2Ytn3uYOgxKbx/lU0ymnHP+j4Ca
         p/BmUxJhoLknB45f2/1ozAikrwa6E5Qxasmly7Mr5nuIWis17Q6ljbZrIYGh4D9xHY86
         wzc2C1DNgAcvapnuqrE6TcCdoVPwKZ71y06t10zHnSgFumhX55yJt+vhzmeSpq4lqx0W
         V6uqMD1c4Ejm4qrpgqQC5TJPMTxII37WO4tVYvzgs/wZSyu+4WyAcMKE3jEKcT2wJETc
         YRm55EnRfD4/Onst913BYpwAEuKs9U//UcJZQSlNq8kI1tLdhKHt84QIeMe7IFUfnoGj
         2hjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708751266; x=1709356066;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+wPGmxuJ4SPc/NqTmX1iLEmNyhHARVyyFYwhGzxPm8Q=;
        b=jBgp6cCcCKbBGrU5jnmkLjLEIDNtzD1p7TBZnSLRgOFbXM3QlLtHDz5d6147WxYNPC
         LytS8loI/iGNvISiUmw15dMrM0KMgJthntFBeuXugF/4CfNC/b1pcr/rrazIHpEIFASl
         fs4qd5hd5X3XWnNx/afcu6ILt9iWCcf/FgSoxJyhU6Q/nxqhxlkW+kF6/hFDlHPe9dun
         hECy2a+IqMWRNIyJXBN/lre3NxmjJ4rQ3Z3ALfJJGIBk40gkgGOuMTcXpRF8Gs584YZT
         guaAlAfBUCeEu5peebexeCkqXNX9DfspSIz32uaezJleEpiadfeHwbIGd7ety4j0jstA
         hP8A==
X-Gm-Message-State: AOJu0YyCJfmIfADzNjn6VqP4Xa9jGRAdq4Mpa3EV53SEqwh+qka/t0Co
	Rm7vGTbSAM6ZUo5SgNlWVz2Kl717pqJEDGOiRxTk7ui3oJQoudTuefS6jBk45+G1n2ARfgX2ZSw
	b
X-Google-Smtp-Source: AGHT+IERtmZZ01Y3GzhsN8YgL9ej2ni+/o635QQTjhnWvO8KJ0XfS13yH1Ta+CzraD+xvyg6XmB5qQ==
X-Received: by 2002:a92:4a03:0:b0:363:b95a:b55a with SMTP id m3-20020a924a03000000b00363b95ab55amr2031354ilf.16.1708751266168;
        Fri, 23 Feb 2024 21:07:46 -0800 (PST)
Received: from localhost (fwdproxy-prn-020.fbsv.net. [2a03:2880:ff:14::face:b00c])
        by smtp.gmail.com with ESMTPSA id w191-20020a6382c8000000b005c6617b52e6sm344538pgd.5.2024.02.23.21.07.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Feb 2024 21:07:45 -0800 (PST)
From: David Wei <dw@davidwei.uk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH v1 1/4] io_uring: only account cqring wait time as iowait if enabled for a ring
Date: Fri, 23 Feb 2024 21:07:32 -0800
Message-ID: <20240224050735.1759733-1-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.0
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
recv() we do not control when the completions happen so its value
misleads userspace tooling.

This patch gates the previously unconditional iowait accounting behind a
new IORING_REGISTER opcode. By default time is not accounted as iowait,
unless this is explicitly enabled for a ring. Thus userspace can decide,
depending on the type of work it expects to do, whether it wants to
consider cqring wait time as iowait or not.

Signed-off-by: David Wei <dw@davidwei.uk>
---
 include/linux/io_uring_types.h |  1 +
 include/uapi/linux/io_uring.h  |  3 +++
 io_uring/io_uring.c            |  9 +++++----
 io_uring/register.c            | 17 +++++++++++++++++
 4 files changed, 26 insertions(+), 4 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index bd7071aeec5d..c568e6b8c9f9 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -242,6 +242,7 @@ struct io_ring_ctx {
 		unsigned int		drain_disabled: 1;
 		unsigned int		compat: 1;
 		unsigned int		iowq_limits_set : 1;
+		unsigned int		iowait_enabled: 1;
 
 		struct task_struct	*submitter_task;
 		struct io_rings		*rings;
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
index 99c37775f974..fbdf3d3461d8 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -387,6 +387,17 @@ static __cold int io_register_iowq_max_workers(struct io_ring_ctx *ctx,
 	return ret;
 }
 
+static int io_register_iowait(struct io_ring_ctx *ctx, int val)
+{
+	int was_enabled = ctx->iowait_enabled;
+
+	if (val)
+		ctx->iowait_enabled = 1;
+	else
+		ctx->iowait_enabled = 0;
+	return was_enabled;
+}
+
 static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 			       void __user *arg, unsigned nr_args)
 	__releases(ctx->uring_lock)
@@ -563,6 +574,12 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 			break;
 		ret = io_unregister_napi(ctx, arg);
 		break;
+	case IORING_REGISTER_IOWAIT:
+		ret = -EINVAL;
+		if (arg)
+			break;
+		ret = io_register_iowait(ctx, nr_args);
+		break;
 	default:
 		ret = -EINVAL;
 		break;
-- 
2.43.0


