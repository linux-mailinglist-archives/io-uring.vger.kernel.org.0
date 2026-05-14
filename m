Return-Path: <io-uring+bounces-13320-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CFDnHykyBWonTQIAu9opvQ
	(envelope-from <io-uring+bounces-13320-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 14 May 2026 04:23:37 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B43853D004
	for <lists+io-uring@lfdr.de>; Thu, 14 May 2026 04:23:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id DA9AB3008D31
	for <lists+io-uring@lfdr.de>; Thu, 14 May 2026 02:23:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84C8723909C;
	Thu, 14 May 2026 02:23:30 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AEE9301465;
	Thu, 14 May 2026 02:23:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778725410; cv=none; b=YhWscl45gZ2S2xAfjy2P00KoHsix6KUPluXqDWYyeYUb16ogwMarPwmxF+EWT/1P+/OJvbIT2bvUpLjT6olNNU3fXjhu7Qt8QE6mkjKbGRsufGeecdFtU7x/rK5KcfBenydH8IzNVn/nUpiJDnGK/KrhLgkvuz3yigzNmhG5nLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778725410; c=relaxed/simple;
	bh=/TiMFHPsCvDmxQZ3ePA7DgzU3oRpeZPGiAsNLCdvnw0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=g0uDBiflu6SSWeh/64mq+nU760EjxqF8qHrqjL/A4e6P0LUiLz1fLY6RNJCg1v7avwQVzIW2ACSobHXxo7f6uuLDkZHKIx+D+RiwwTCpM3Pq8eUF80OK8R+jn3d33JZ03vrEcfLus4gMqnVAlzaftJ+IvoYQU/iTNyfANnbr4qc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4gGDch3T16zKHMh6;
	Thu, 14 May 2026 10:22:28 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 6E10040592;
	Thu, 14 May 2026 10:23:23 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP4 (Coremail) with SMTP id gCh0CgD3v1sbMgVqcFDiCA--.36578S4;
	Thu, 14 May 2026 10:23:23 +0800 (CST)
From: Zizhi Wo <wozizhi@huaweicloud.com>
To: axboe@kernel.dk,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	yangerkun@huawei.com,
	chengzhihao1@huawei.com,
	wozizhi@huaweicloud.com
Subject: [PATCH V2] io_uring: validate user-controlled cq.head in io_cqe_cache_refill()
Date: Thu, 14 May 2026 10:18:47 +0800
Message-ID: <20260514021847.4062782-1-wozizhi@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgD3v1sbMgVqcFDiCA--.36578S4
X-Coremail-Antispam: 1UD129KBjvJXoWxZr1DGFW7GrWxKF1fCryfZwb_yoWrCrWfpF
	WYkw15Xry0vryUGa9Ivw4xJrWfKws3JrsrGrWxG34jyr4Y9FnIgF1DKrW5CFy2vrWkZr12
	qFsavrWqkF45ZaDanT9S1TB71UUUUUDqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkC14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7CjxVAaw2AFwI0_
	JF0_Jw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67
	AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIY
	rxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14
	v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8
	JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUr2-eDU
	UUU
X-CM-SenderInfo: pzr2x6tkl6x35dzhxuhorxvhhfrp/
X-Rspamd-Queue-Id: 7B43853D004
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.54 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_TO(0.00)[kernel.dk,gmail.com,vger.kernel.org];
	TAGGED_FROM(0.00)[bounces-13320-lists,io-uring=lfdr.de];
	DMARC_NA(0.00)[huaweicloud.com];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_SEVEN(0.00)[7];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[wozizhi@huaweicloud.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_FIVE(0.00)[6];
	NEURAL_HAM(-0.00)[-0.998];
	TO_DN_NONE(0.00)[];
	R_DKIM_NA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,fedora:email,huawei.com:email]
X-Rspamd-Action: no action

From: Zizhi Wo <wozizhi@huawei.com>

[BUG]
A fuzzing run reproduced an unkillable io_uring task stuck at ~100% CPU:

    [root@fedora io_uring_stress]# ps -ef | grep io_uring
    root  1240  1  99 13:36 ?  00:01:35 [io_uring_stress] <defunct>

The task loops inside io_cqring_wait() and never returns to userspace, and
SIGKILL has no effect.

[CAUSE]
The CQ ring exposes rings->cq.head to userspace as writable, while the
authoritative tail lives in kernel-private ctx->cached_cq_tail.
io_cqe_cache_refill() computes free space as an unsigned subtraction:

    free = ctx->cq_entries - min(tail - head, ctx->cq_entries);

If userspace keeps head within [0, tail], the subtraction is well defined
and min() just acts as a defensive clamp. But if userspace advances head
past tail, (tail - head) wraps to a huge value, free becomes 0, and
io_cqe_cache_refill() fails. The CQE is pushed onto the overflow list and
IO_CHECK_CQ_OVERFLOW_BIT is set.

The wait loop in io_cqring_wait() relies on an invariant: refill() only
fails when the CQ is *physically* full, in which case rings->cq.tail has
been advanced to iowq->cq_tail and io_should_wake() returns true. The
tampered head breaks this: refill() fails while the ring is not full, no
OCQE is copied in, rings->cq.tail never catches up, io_should_wake() stays
false, and io_cqring_wait_schedule() keeps returning early because
IO_CHECK_CQ_OVERFLOW_BIT is still set. The result is a tight retry loop
that never returns to userspace.

[FIX]
Introduce io_cqring_queued() as the single point that converts the
(tail, head) pair into a trustworthy queued count. Since the real
head/tail distance is bounded by cq_entries (far below 2^31),
a signed comparison reliably detects userspace moving head past tail;
in that case treat the queue as empty so callers see the full cache as
free and forward progress is preserved.

CQEs that would otherwise be delivered may be lost when the application
corrupts its own head pointer, but that is an application-visible
consequence of its own action; the kernel's responsibility here is limited
to keeping the task killable and making forward progress.

Suggested-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
---
 io_uring/io_uring.c |  5 ++---
 io_uring/wait.h     | 19 +++++++++++++++++++
 2 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 4ed998d60c09..458f4a53179f 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -692,7 +692,7 @@ static struct io_overflow_cqe *io_alloc_ocqe(struct io_ring_ctx *ctx,
  */
 static bool io_fill_nop_cqe(struct io_ring_ctx *ctx, unsigned int off)
 {
-	if (__io_cqring_events(ctx) < ctx->cq_entries) {
+	if (io_cqring_queued(ctx) < ctx->cq_entries) {
 		struct io_uring_cqe *cqe = &ctx->rings->cqes[off];
 
 		cqe->user_data = 0;
@@ -733,8 +733,7 @@ bool io_cqe_cache_refill(struct io_ring_ctx *ctx, bool overflow, bool cqe32)
 		off = 0;
 	}
 
-	/* userspace may cheat modifying the tail, be safe and do min */
-	queued = min(__io_cqring_events(ctx), ctx->cq_entries);
+	queued = io_cqring_queued(ctx);
 	free = ctx->cq_entries - queued;
 	/* we need a contiguous range, limit based on the current array offset */
 	len = min(free, ctx->cq_entries - off);
diff --git a/io_uring/wait.h b/io_uring/wait.h
index a4274b137f81..b987837b9051 100644
--- a/io_uring/wait.h
+++ b/io_uring/wait.h
@@ -50,4 +50,23 @@ static inline unsigned io_cqring_events(struct io_ring_ctx *ctx)
 	return __io_cqring_events(ctx);
 }
 
+/*
+ * Compute queued CQEs for free-space calculation, clamped to cq_entries.
+ *
+ * rings->cq.head is user-writable. If userspace advances it past
+ * cached_cq_tail, an unsigned (tail - head) underflows to a huge
+ * value, which traps io_cqring_wait() in an unkillable loop via the
+ * overflow path. Use a signed comparison to handle it.
+ */
+static inline unsigned int io_cqring_queued(struct io_ring_ctx *ctx)
+{
+	struct io_rings *rings = io_get_rings(ctx);
+	int diff;
+
+	diff = (int)(ctx->cached_cq_tail - READ_ONCE(rings->cq.head));
+	if (diff >= 0)
+		return min((unsigned int)diff, ctx->cq_entries);
+	return 0;
+}
+
 #endif
-- 
2.52.0


