Return-Path: <io-uring+bounces-2807-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DF0E3955363
	for <lists+io-uring@lfdr.de>; Sat, 17 Aug 2024 00:36:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 615741F2157C
	for <lists+io-uring@lfdr.de>; Fri, 16 Aug 2024 22:36:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9593412C478;
	Fri, 16 Aug 2024 22:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="oZuJXUxm"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CF6EBA33
	for <io-uring@vger.kernel.org>; Fri, 16 Aug 2024 22:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723847811; cv=none; b=gKJ7pU8bOGpK6x/FryYk9BSUV+vL5I20FRbDqcNXnAQHda3c9miF21GilkLOrKOGOvCNl/XKcVqw4luTlEA/OBUUEaCt6zYgTkXW6MLm4HYRBicqyk0CCNvoUuseJBRzz49/iZNfoREWFlVjWIY0LmTW4AZ7YcrMIOYdU06VVcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723847811; c=relaxed/simple;
	bh=qaG4LOJUFQM3iT+Acy9aJMN96rM0IOVUFjfAxr9Ykkg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=t4hxZdMtFi0ireunmAE73Lpz/ob1jL7YI+hqbAsbra35cN4+hVJcQeCMS7hppWcSkXnX3T55kQvplnnHgf7ew+BAyNBjJjqlVBh7FI6/5Nm4q3M3DtTI6qMdbLwNrpWdr7IWSmVpcQVqEVSNi5ypBI7kbuK75+e1Yl3yifzmy3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=oZuJXUxm; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-1fc60c3ead4so22716525ad.0
        for <io-uring@vger.kernel.org>; Fri, 16 Aug 2024 15:36:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1723847809; x=1724452609; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=pkKeuLzAkqJ8qev1JBVwzklKihO1Qg5YsJ9t7EcmvW0=;
        b=oZuJXUxmp/GlwVWXuM6tjCp+DlOw5b3r4+bepMm1QCtFs6dOp+2XDO2Xi0h83uD41v
         tsi1HLKV6+xjxhY5+D9C+NEmdQ1V5JzHmzFdTYLCRHGOai39r5nMTXrD7Ftgf1CQL8/h
         gbUuVBbFPe0gP6RlkDPlK2s96kfCclQzVYNaRQ1kKoBkVSHjKfCAXe4LupWuJcIzzDQX
         kx2A1pLRFGyPdhtQ5k7sO47/9ecyrsTPnRBUMhfrS4hzLrxSR6yQD4az2XZH+c5n7Vg1
         vZ2I75VctxMq0Ontq5UQa97km9v/5f9evR7KuixvYY6O9rNR8N8+aPjquliMvwWeRdfq
         XiLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723847809; x=1724452609;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pkKeuLzAkqJ8qev1JBVwzklKihO1Qg5YsJ9t7EcmvW0=;
        b=w43+1ooggXyMwyNq37NoVgqx6lI02sp2W7YuQhCs0Cbsl0p6DEsxBy0naMwNRWAOJh
         sYuMMlOSwq4JJ/F9IJ4esYmroVFbSBWysYRSPnd/u2nc2UwWKOHNGF9oA/5cIXwbRwvz
         liNB9DPJ+sExDgjT1H8A50EmYHXO2TlWxGAasvBYrxkHBnyqih+fxRZXwduYbYyBTp0e
         b/ORRNnLiWCPR5FEcAdnYaEoVRDB7vJbeDqoiTZQFzt5q85MH3nBrSsX58FQzme4XB/9
         Fbqm2NwjuS75E2vqgXsGufF7V3tN3EJzBVtdCR4QwXuA9q5EJ8g/krTtW4iWTJpFySVU
         h/OQ==
X-Gm-Message-State: AOJu0YyhTBWBzJ6UqEquT7xnR2T0LrJbsaz48DMSF6l6FilRx94NH5pp
	EtHglAopSN9UY8dC+uZTjy43Q3pNCs4ELmvbic2kcfiX8fgiC5VmC4MWYFgDjWjOJMzBkiecnFR
	F
X-Google-Smtp-Source: AGHT+IG0BbIOLTO34n3jaP2xAJ26WiZqkma6LFXW2rgT/Ge3+IXJ/WV6lm0FZHEnOdAntKXPB1KbBA==
X-Received: by 2002:a17:902:d4c9:b0:1fb:9b91:d7c1 with SMTP id d9443c01a7336-2020404ee4cmr47132465ad.55.1723847809190;
        Fri, 16 Aug 2024 15:36:49 -0700 (PDT)
Received: from localhost (fwdproxy-prn-016.fbsv.net. [2a03:2880:ff:10::face:b00c])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-201f031bc27sm29862575ad.71.2024.08.16.15.36.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Aug 2024 15:36:48 -0700 (PDT)
From: David Wei <dw@davidwei.uk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	David Wei <dw@davidwei.uk>
Subject: [PATCH v2] io_uring: add IORING_ENTER_NO_IOWAIT to not set in_iowait
Date: Fri, 16 Aug 2024 15:36:40 -0700
Message-ID: <20240816223640.1140763-1-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.5
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

io_uring sets current->in_iowait when waiting for completions, which
achieves two things:

1. Proper accounting of the time as iowait time
2. Enable cpufreq optimisations, setting SCHED_CPUFREQ_IOWAIT on the rq

For block IO this makes sense as high iowait can be indicative of
issues. But for network IO especially recv, the recv side does not
control when the completions happen.

Some user tooling attributes iowait time as CPU utilisation i.e. not
idle, so high iowait time looks like high CPU util even though the task
is not scheduled and the CPU is free to run other tasks. When doing
network IO with e.g. the batch completion feature, the CPU may appear to
have high utilisation.

This patchset adds a IOURING_ENTER_NO_IOWAIT flag that can be set on
enter. If set, then current->in_iowait is not set. By default this flag
is not set to maintain existing behaviour i.e. in_iowait is always set.
This is to prevent waiting for completions being accounted as CPU
utilisation.

Not setting in_iowait does mean that we also lose cpufreq optimisations
above because in_iowait semantics couples 1 and 2 together. Eventually
we will untangle the two so the optimisations can be enabled
independently of the accounting.

IORING_FEAT_IOWAIT_TOGGLE is returned in io_uring_create() to indicate
support. This will be used by liburing to check for this feature.

Signed-off-by: David Wei <dw@davidwei.uk>
---
v2:
 - squash patches into one
 - move no_iowait in struct io_wait_queue to the end
 - always set iowq.no_iowait

---
 include/uapi/linux/io_uring.h | 2 ++
 io_uring/io_uring.c           | 7 ++++---
 io_uring/io_uring.h           | 1 +
 3 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 48c440edf674..3a94afa8665e 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -508,6 +508,7 @@ struct io_cqring_offsets {
 #define IORING_ENTER_EXT_ARG		(1U << 3)
 #define IORING_ENTER_REGISTERED_RING	(1U << 4)
 #define IORING_ENTER_ABS_TIMER		(1U << 5)
+#define IORING_ENTER_NO_IOWAIT		(1U << 6)
 
 /*
  * Passed in for io_uring_setup(2). Copied back with updated info on success
@@ -543,6 +544,7 @@ struct io_uring_params {
 #define IORING_FEAT_LINKED_FILE		(1U << 12)
 #define IORING_FEAT_REG_REG_RING	(1U << 13)
 #define IORING_FEAT_RECVSEND_BUNDLE	(1U << 14)
+#define IORING_FEAT_IOWAIT_TOGGLE	(1U << 15)
 
 /*
  * io_uring_register(2) opcodes and arguments
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 20229e72b65c..5e75672525df 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2372,7 +2372,7 @@ static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
 	 * can take into account that the task is waiting for IO - turns out
 	 * to be important for low QD IO.
 	 */
-	if (current_pending_io())
+	if (!iowq->no_iowait && current_pending_io())
 		current->in_iowait = 1;
 	ret = 0;
 	if (iowq->timeout == KTIME_MAX)
@@ -2414,6 +2414,7 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events, u32 flags,
 	iowq.nr_timeouts = atomic_read(&ctx->cq_timeouts);
 	iowq.cq_tail = READ_ONCE(ctx->rings->cq.head) + min_events;
 	iowq.timeout = KTIME_MAX;
+	iowq.no_iowait = flags & IORING_ENTER_NO_IOWAIT;
 
 	if (uts) {
 		struct timespec64 ts;
@@ -3155,7 +3156,7 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 	if (unlikely(flags & ~(IORING_ENTER_GETEVENTS | IORING_ENTER_SQ_WAKEUP |
 			       IORING_ENTER_SQ_WAIT | IORING_ENTER_EXT_ARG |
 			       IORING_ENTER_REGISTERED_RING |
-			       IORING_ENTER_ABS_TIMER)))
+			       IORING_ENTER_ABS_TIMER | IORING_ENTER_NO_IOWAIT)))
 		return -EINVAL;
 
 	/*
@@ -3539,7 +3540,7 @@ static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
 			IORING_FEAT_EXT_ARG | IORING_FEAT_NATIVE_WORKERS |
 			IORING_FEAT_RSRC_TAGS | IORING_FEAT_CQE_SKIP |
 			IORING_FEAT_LINKED_FILE | IORING_FEAT_REG_REG_RING |
-			IORING_FEAT_RECVSEND_BUNDLE;
+			IORING_FEAT_RECVSEND_BUNDLE | IORING_FEAT_IOWAIT_TOGGLE;
 
 	if (copy_to_user(params, p, sizeof(*p))) {
 		ret = -EFAULT;
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 9935819f12b7..426079a966ac 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -46,6 +46,7 @@ struct io_wait_queue {
 	ktime_t napi_busy_poll_dt;
 	bool napi_prefer_busy_poll;
 #endif
+	bool no_iowait;
 };
 
 static inline bool io_should_wake(struct io_wait_queue *iowq)
-- 
2.43.5


