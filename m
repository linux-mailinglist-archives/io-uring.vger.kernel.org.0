Return-Path: <io-uring+bounces-12506-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cLLPMKyMpWmoDgYAu9opvQ
	(envelope-from <io-uring+bounces-12506-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 02 Mar 2026 14:12:12 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 84B961D98B8
	for <lists+io-uring@lfdr.de>; Mon, 02 Mar 2026 14:12:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id A927B3042FE0
	for <lists+io-uring@lfdr.de>; Mon,  2 Mar 2026 13:10:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34683373BFB;
	Mon,  2 Mar 2026 13:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cPpUwj9q"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB39B35AC2A
	for <io-uring@vger.kernel.org>; Mon,  2 Mar 2026 13:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772457050; cv=none; b=pAnouW6ZH8U7/BR/zjfcY8GOjDXBle1BLcQ1ToAdjKJjezT+mhL6MjIkTWpY6/v6GDkT8zonD8ioQoWUn6AEMqgGh2JSC7y3rmLPEDc2EvopdqQkWvVg0Qi6mLtOHTuZECZcn86Yijo9AoQSthuR+rwbZ8QUwLbwO2JN75iC0jE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772457050; c=relaxed/simple;
	bh=m1K+KF601ojT9bpYKxMCLIrzUJ3+z38/Ym1cUSqNV6s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BfKqnqwlXakrr29+GtC6MxH1bqsPi7k6r7TrzFPMydBwE2XzRYXrtzvwOfhEIKZgWv44eeOvwNdt+Q2CnnJsISa13DceWBMTY43hB5U74MCUsVmmyPmvk7KNQMfXg5Li9B5ZYWdxeS6DkpEKTsDUL/9P5dSJIHZrD2zRRn4wnro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cPpUwj9q; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4836f363d0dso38905005e9.3
        for <io-uring@vger.kernel.org>; Mon, 02 Mar 2026 05:10:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772457047; x=1773061847; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V3uuhGS10lCaUmcySz+E0OEOl9K5mIfj64mobdqdIX4=;
        b=cPpUwj9qPoefQFSq64HhmZv/C7xOar0WQa17/RHL1VXqQt3WQgDgb59tSvVUVLsGQz
         V31a09c4LdI4zENSyYqYXAgt4p2jAZwSHedRk3kdMepvChqPkpfDuuJL2w+cMkQ+WkKv
         NVp3n1a/1I3FZ9VqbTB6LorWb6ahM0kbg73SdMvze6364O9/ZzVC4CAvzgEaj+EWo1Rt
         Jss7y0UV85IHGNU3QqDo48uWh+AuGDNTkKKd3kOK7EZXu/i5jKt+Pz/pK1mp78hT8LhA
         h47AaPucOlSdzlgDdn9z0pQL6Kidxmi9R+18V9KexAI303w2EQuGpYHpgTxgNUwjSxqc
         gd/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772457047; x=1773061847;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=V3uuhGS10lCaUmcySz+E0OEOl9K5mIfj64mobdqdIX4=;
        b=pK4wJyXHvqueW6ulQWTWCYWAMA3JFMvV7JwkXaffTY31FjrXlMWH6j2iY/6Juf3vdp
         fZJ8QPMqWLRiiEFDUd6zLaoLrpV2as/VSu0vEr54UEc+au8Q4G4zHBJzvZocs/FEm195
         Z8lq1NYKSshoFKtm7kVTiej5mPPDy/xGpPXQQXL3AAhRKdUqw3pt6YKaN69yPGzUceIK
         3sAaXiLRrkFSbf2X/fMQ+s9Ejvc4UyERzZzs5i0jnMIuy3uSQsMgLbkNDHtIrmEzIYzs
         ehwem1ei0JLUEA1pGqwbl4YrzAYRpTXOWCKY1W3f/KNiqZcpt2LulN1ooVG+GnLJO4h7
         OkXg==
X-Gm-Message-State: AOJu0Yz5BHa7gVyXFejzaL8NxPXGGLWoPuOSPyf5dxtVrPjPEq3fg9S/
	Zp1Mi7WN+qzYXw8zKyM4Tf4kHURRGN9wK5fR4Ae1qXZby0OcRINSx4N4zKj6iw==
X-Gm-Gg: ATEYQzyBpsQ2AGMIjSxaOOUnevK8k3ApIRyyeKDR/U1GayEOHteY7fGMs8A4UmRmxIy
	1XeIpSSRWKxZrBlOX6PrtVHF65m8pXYbeo6b4e0p/NwIhNsDU2+92+my/I6RoxuNBXnMGJo8nwh
	UzXpu1Dbo37CGR5rv2CrJhq+YXimBz4x9uSyyu11qmCyP+KKB/OOsyYGnqbXWwXaIyQr6Hc+/Oh
	CrQ7BtB3kpnV6vkBAEcCSWrx2dJr+fa1T12yZJIBiMGYMk8/V8ImgxwKMWOxtcKEhxu5ya/xJiB
	L7foquY4j2/nlQO//PVXY5uD7904adBsZxtXlGFbc6A+yHE9NLXMpGTPjbhEqFmqxH9LLWns4Vk
	+uMe8LZCJVeGGTfJLYrXrnSpB+gYP/3oXAb2h3j+FM/lxLjZlgFcO5aiKbHJoDuGlvYjBopqxyh
	cE0vSbufjlANTD3xbtoahNuUoRTYS512rWvxCTjLqUdyhjyXemHnzh/Wbq/tmP0/DVZQY2rb6Qz
	1bathSZCg==
X-Received: by 2002:a05:600c:4f07:b0:477:63a4:88fe with SMTP id 5b1f17b1804b1-483c9bb1c13mr252516465e9.2.1772457046521;
        Mon, 02 Mar 2026 05:10:46 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:cad2])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483c3b346ccsm259935925e9.2.2026.03.02.05.10.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2026 05:10:46 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk
Subject: [PATCH v3 3/4] io_uring/timeout: migrate reqs from ts64 to ktime
Date: Mon,  2 Mar 2026 13:10:36 +0000
Message-ID: <f96c65deb1a1e21ca1b2ec58ee2e8bc57ba10327.1772456786.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1772456786.git.asml.silence@gmail.com>
References: <cover.1772456786.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_FROM(0.00)[bounces-12506-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,kernel.dk];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	NEURAL_HAM(-0.00)[-0.999];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 84B961D98B8
X-Rspamd-Action: no action

It'll be more convenient for next patches to keep ktime in requests
instead of timespec64. Convert everything to ktime right after user
argument parsing at request prep time.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/timeout.c | 31 +++++++++++++++----------------
 io_uring/timeout.h |  2 +-
 2 files changed, 16 insertions(+), 17 deletions(-)

diff --git a/io_uring/timeout.c b/io_uring/timeout.c
index f6520599e3e8..4b67746ea3ca 100644
--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -30,12 +30,12 @@ struct io_timeout_rem {
 	u64				addr;
 
 	/* timeout update */
-	struct timespec64		ts;
+	ktime_t				time;
 	u32				flags;
 	bool				ltimeout;
 };
 
-static int io_parse_user_time(struct timespec64 *ts_out, u64 arg)
+static int io_parse_user_time(ktime_t *time, u64 arg)
 {
 	struct timespec64 ts;
 
@@ -43,7 +43,7 @@ static int io_parse_user_time(struct timespec64 *ts_out, u64 arg)
 		return -EFAULT;
 	if (ts.tv_sec < 0 || ts.tv_nsec < 0)
 		return -EINVAL;
-	*ts_out = ts;
+	*time = timespec64_to_ktime(ts);
 	return 0;
 }
 
@@ -92,7 +92,7 @@ static void io_timeout_complete(struct io_tw_req tw_req, io_tw_token_t tw)
 			/* re-arm timer */
 			raw_spin_lock_irq(&ctx->timeout_lock);
 			list_add(&timeout->list, ctx->timeout_list.prev);
-			hrtimer_start(&data->timer, timespec64_to_ktime(data->ts), data->mode);
+			hrtimer_start(&data->timer, data->time, data->mode);
 			raw_spin_unlock_irq(&ctx->timeout_lock);
 			return;
 		}
@@ -407,7 +407,7 @@ static clockid_t io_timeout_get_clock(struct io_timeout_data *data)
 }
 
 static int io_linked_timeout_update(struct io_ring_ctx *ctx, __u64 user_data,
-				    struct timespec64 *ts, enum hrtimer_mode mode)
+				    ktime_t ts, enum hrtimer_mode mode)
 	__must_hold(&ctx->timeout_lock)
 {
 	struct io_timeout_data *io;
@@ -429,12 +429,12 @@ static int io_linked_timeout_update(struct io_ring_ctx *ctx, __u64 user_data,
 	if (hrtimer_try_to_cancel(&io->timer) == -1)
 		return -EALREADY;
 	hrtimer_setup(&io->timer, io_link_timeout_fn, io_timeout_get_clock(io), mode);
-	hrtimer_start(&io->timer, timespec64_to_ktime(*ts), mode);
+	hrtimer_start(&io->timer, ts, mode);
 	return 0;
 }
 
 static int io_timeout_update(struct io_ring_ctx *ctx, __u64 user_data,
-			     struct timespec64 *ts, enum hrtimer_mode mode)
+			     ktime_t time, enum hrtimer_mode mode)
 	__must_hold(&ctx->timeout_lock)
 {
 	struct io_cancel_data cd = { .ctx = ctx, .data = user_data, };
@@ -447,11 +447,11 @@ static int io_timeout_update(struct io_ring_ctx *ctx, __u64 user_data,
 
 	timeout->off = 0; /* noseq */
 	data = req->async_data;
-	data->ts = *ts;
+	data->time = time;
 
 	list_add_tail(&timeout->list, &ctx->timeout_list);
 	hrtimer_setup(&data->timer, io_timeout_fn, io_timeout_get_clock(data), mode);
-	hrtimer_start(&data->timer, timespec64_to_ktime(data->ts), mode);
+	hrtimer_start(&data->timer, data->time, mode);
 	return 0;
 }
 
@@ -477,7 +477,7 @@ int io_timeout_remove_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 			tr->ltimeout = true;
 		if (tr->flags & ~(IORING_TIMEOUT_UPDATE_MASK|IORING_TIMEOUT_ABS))
 			return -EINVAL;
-		ret = io_parse_user_time(&tr->ts, READ_ONCE(sqe->addr2));
+		ret = io_parse_user_time(&tr->time, READ_ONCE(sqe->addr2));
 		if (ret)
 			return ret;
 	} else if (tr->flags) {
@@ -514,9 +514,9 @@ int io_timeout_remove(struct io_kiocb *req, unsigned int issue_flags)
 
 		raw_spin_lock_irq(&ctx->timeout_lock);
 		if (tr->ltimeout)
-			ret = io_linked_timeout_update(ctx, tr->addr, &tr->ts, mode);
+			ret = io_linked_timeout_update(ctx, tr->addr, tr->time, mode);
 		else
-			ret = io_timeout_update(ctx, tr->addr, &tr->ts, mode);
+			ret = io_timeout_update(ctx, tr->addr, tr->time, mode);
 		raw_spin_unlock_irq(&ctx->timeout_lock);
 	}
 
@@ -574,7 +574,7 @@ static int __io_timeout_prep(struct io_kiocb *req,
 	data->req = req;
 	data->flags = flags;
 
-	ret = io_parse_user_time(&data->ts, READ_ONCE(sqe->addr));
+	ret = io_parse_user_time(&data->time, READ_ONCE(sqe->addr));
 	if (ret)
 		return ret;
 
@@ -652,7 +652,7 @@ int io_timeout(struct io_kiocb *req, unsigned int issue_flags)
 	}
 add:
 	list_add(&timeout->list, entry);
-	hrtimer_start(&data->timer, timespec64_to_ktime(data->ts), data->mode);
+	hrtimer_start(&data->timer, data->time, data->mode);
 	raw_spin_unlock_irq(&ctx->timeout_lock);
 	return IOU_ISSUE_SKIP_COMPLETE;
 }
@@ -670,8 +670,7 @@ void io_queue_linked_timeout(struct io_kiocb *req)
 	if (timeout->head) {
 		struct io_timeout_data *data = req->async_data;
 
-		hrtimer_start(&data->timer, timespec64_to_ktime(data->ts),
-				data->mode);
+		hrtimer_start(&data->timer, data->time, data->mode);
 		list_add_tail(&timeout->list, &ctx->ltimeout_list);
 	}
 	raw_spin_unlock_irq(&ctx->timeout_lock);
diff --git a/io_uring/timeout.h b/io_uring/timeout.h
index 2b7c9ad72992..1620f94dd45a 100644
--- a/io_uring/timeout.h
+++ b/io_uring/timeout.h
@@ -3,7 +3,7 @@
 struct io_timeout_data {
 	struct io_kiocb			*req;
 	struct hrtimer			timer;
-	struct timespec64		ts;
+	ktime_t				time;
 	enum hrtimer_mode		mode;
 	u32				flags;
 };
-- 
2.53.0


