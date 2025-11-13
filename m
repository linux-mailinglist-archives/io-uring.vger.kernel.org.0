Return-Path: <io-uring+bounces-10596-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 90A87C574F5
	for <lists+io-uring@lfdr.de>; Thu, 13 Nov 2025 13:01:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 168FF4E4B18
	for <lists+io-uring@lfdr.de>; Thu, 13 Nov 2025 12:00:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E3A234D397;
	Thu, 13 Nov 2025 12:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dbjR4kbD"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A373B34E74C
	for <io-uring@vger.kernel.org>; Thu, 13 Nov 2025 12:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763035211; cv=none; b=eUzZUiNyq9d7u4BvXn5+XZTKgSTT9eXimQ3Cd76oBe/9y16QZAUm0ceMuiDqItDz14ZgWgvI7F3CuXdUbJ52UNX7KIKM0lBNq8dy817Zi0WqSqjY3AB/1xk8W/8uEg7ngPyh3ANoy/QuTg4GOorMIQIhGRmcPl8wF8X75jVXW5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763035211; c=relaxed/simple;
	bh=+XiR+t8/McoWRAigLnMdhtU4ZH1KlIZvPKawNG59PE8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NbnkjQGaVhAAEuglzKTg6WQwluA9LFg+19IruGQOd28iPYB13RezZu1OirdmgQuMtH79qfMq26gP0y1Fe2ehbpiPU7CdoSiJ6FnmpoP+H+z0z8VSns5JqClL/L1wPiJcLOQePwq6yQqbcs01LFAUfnE8hSOBa7f78jooACKXjMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dbjR4kbD; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-42b38de7940so423685f8f.3
        for <io-uring@vger.kernel.org>; Thu, 13 Nov 2025 04:00:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763035207; x=1763640007; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zTcMbE9RLu0cQirrPeJ8V568kcCAJKkj4qsqfeBvygU=;
        b=dbjR4kbDYBmXOSUAtqh5+0TxX9Yaa0xwJgB0fmUpW0RwZNL0PzLzWZhH57O0TM51ty
         5rtGkn7UihckEwPDfQgfqXbuH0KrgEHOr519LPiOcr75xAPAqE7mlOM+zNVSjRzQBgq3
         Fdx/5vmDRZ0Vc8dWF1tOtSKSiEMfi2WWZZzPuaqKoJAQfCoBsecEDt5id/rlo3WsYqBP
         2eLtYEhzhMWgGDzFHe1Ixo6TJZCqseOlay1NY5RxvJniFXq653fUlWB8aOVaIRPHpGyX
         +IU7VEv+8MoLxLlWB3cCHXNuB2ev1JsiKDNH8FVZ2AtgW8a0zVXZEkBMRHJGEtru8fru
         JXww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763035207; x=1763640007;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zTcMbE9RLu0cQirrPeJ8V568kcCAJKkj4qsqfeBvygU=;
        b=aRT7CetAbP3OczVzCEp1qmDcNtCnmz+dBnMYPEHddd2BIESrClvvn7TUlWT0XzMBt+
         IQjbTVj5GhVbeRddZeNf+DzGwOg4QmRda86qTLAWZ2OVZNpMM6gfyJfVuQE71OkTSBTz
         lJNYW7ZIkahbUNKUqgqu22gw/wwlHQorGzD+frtM0r7ggYVvZX3kG/MxpL8wtUedWCYN
         UMY8LzTt+9Y12QKD78gXPWui59SbqxaFikIsE+xJUXC5PCPP6IwzErhTAf/1SFGCZ2g0
         feqab67KuKNInhSDAigX5WBQwNreFtn99ZvcwBXTAeZQwLfu2KxgLQkGE4jZcjK8Z7BC
         Oakw==
X-Gm-Message-State: AOJu0Yz269xds58l3t1bp9kMkudGIkuVDiwjOPC0DJSRHXGmjAVctGgV
	9XUvkrQvt6kmqNdLSddw9dOOdX6mj7v8uv2STRAs5ZX3yML5JtBogFqboyDU5w==
X-Gm-Gg: ASbGnct8JGungZ22C6finRP9luHfdDjTqjpQl3zafzAdpi7JBLsNsON9ij9IckNwTGn
	3RrJANQ/wnLEh07cOHrcziHXRI3pltDcsdTrv81WfbajhPUVsldCBj/OzZl+LEC3MSi4x0+c5W/
	Th5prGgjz4IHmAjabuW3EiKo3Ipd6k1+rmkcaQ5Ig9rVib0tWkXrAYwZ65JIcoKJqzr5J1W6lW1
	0H/uFBT8XhlCl8vYG+S8q/pNWELE6ZEJxrGDhlvu9usw6F/0vXXpb3pG3U2gJ8Me9A6MeWtUIMA
	W3Na5n114qIQVp0dxCMvxpLwu+Rr5wluhhI4f+zuobAJBv1ozKykrR++bPfnlC5WIL/613IPNd9
	tUPgPMgQDhhNTq9G8grzX77orGmNAZk1zeb4gDTrCzs1bpmlqfDqYMmZM3UM=
X-Google-Smtp-Source: AGHT+IE+lLDXEifm1V0OoVe1QJ+eFOpQB5Dk3fAqz0CTn2GPKO1F8D46i1plsxbN9t+z1AvFxWdTEg==
X-Received: by 2002:a05:6000:25c1:b0:42b:41dc:1b5e with SMTP id ffacd0b85a97d-42b4bdaac86mr6063883f8f.30.1763035207411;
        Thu, 13 Nov 2025 04:00:07 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:6794])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42b53e85e6fsm3686816f8f.18.2025.11.13.04.00.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Nov 2025 04:00:06 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk,
	Martin KaFai Lau <martin.lau@linux.dev>,
	bpf@vger.kernel.org,
	Alexei Starovoitov <alexei.starovoitov@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	ming.lei@redhat.com
Subject: [PATCH v3 06/10] io_uring/bpf: add handle events callback
Date: Thu, 13 Nov 2025 11:59:43 +0000
Message-ID: <5bcb51a2d391e7dfb732c5cdbd152dfbd021b51b.1763031077.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1763031077.git.asml.silence@gmail.com>
References: <cover.1763031077.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a struct_ops callback called handle_events, which will be called
off the CQ waiting loop every time there is an event that might be
interesting to the program. The program takes the io_uring ctx and also
a loop state, which it can use to set the number of events it wants to
wait for as well as the timeout value.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/bpf.c      | 64 +++++++++++++++++++++++++++++++++++++++++++++
 io_uring/bpf.h      | 26 ++++++++++++++++++
 io_uring/io_uring.c | 15 ++++++++++-
 3 files changed, 104 insertions(+), 1 deletion(-)

diff --git a/io_uring/bpf.c b/io_uring/bpf.c
index 4cb5d25c9247..24dd2fe9134f 100644
--- a/io_uring/bpf.c
+++ b/io_uring/bpf.c
@@ -1,9 +1,18 @@
 #include <linux/mutex.h>
+#include <linux/bpf_verifier.h>
 
 #include "bpf.h"
 #include "register.h"
 
+static const struct btf_type *loop_state_type;
+
+static int io_bpf_ops__loop(struct io_ring_ctx *ctx, struct iou_loop_state *ls)
+{
+	return IOU_RES_STOP;
+}
+
 static struct io_uring_ops io_bpf_ops_stubs = {
+	.loop = io_bpf_ops__loop,
 };
 
 static bool bpf_io_is_valid_access(int off, int size,
@@ -25,6 +34,17 @@ static int bpf_io_btf_struct_access(struct bpf_verifier_log *log,
 				    const struct bpf_reg_state *reg, int off,
 				    int size)
 {
+	const struct btf_type *t = btf_type_by_id(reg->btf, reg->btf_id);
+
+	if (t == loop_state_type) {
+		if (off >= offsetof(struct iou_loop_state, cq_tail) &&
+		    off + size <= offsetofend(struct iou_loop_state, cq_tail))
+			return SCALAR_VALUE;
+		if (off >= offsetof(struct iou_loop_state, timeout) &&
+		    off + size <= offsetofend(struct iou_loop_state, timeout))
+			return SCALAR_VALUE;
+	}
+
 	return -EACCES;
 }
 
@@ -34,8 +54,25 @@ static const struct bpf_verifier_ops bpf_io_verifier_ops = {
 	.btf_struct_access = bpf_io_btf_struct_access,
 };
 
+static const struct btf_type *
+io_lookup_struct_type(struct btf *btf, const char *name)
+{
+	s32 type_id;
+
+	type_id = btf_find_by_name_kind(btf, name, BTF_KIND_STRUCT);
+	if (type_id < 0)
+		return NULL;
+	return btf_type_by_id(btf, type_id);
+}
+
 static int bpf_io_init(struct btf *btf)
 {
+	loop_state_type = io_lookup_struct_type(btf, "iou_loop_state");
+	if (!loop_state_type) {
+		pr_err("io_uring: Failed to locate iou_loop_state\n");
+		return -EINVAL;
+	}
+
 	return 0;
 }
 
@@ -91,3 +128,30 @@ static int __init io_uring_bpf_init(void)
 	return 0;
 }
 __initcall(io_uring_bpf_init);
+
+int io_run_cqwait_ops(struct io_ring_ctx *ctx, struct iou_loop_state *ls)
+{
+	int ret;
+
+	io_run_task_work();
+
+	guard(mutex)(&ctx->uring_lock);
+	if (unlikely(!ctx->bpf_ops))
+		return 1;
+
+	if (unlikely(task_sigpending(current)))
+		return -EINTR;
+
+	ret = ctx->bpf_ops->loop(ctx, ls);
+	if (ret == IOU_RES_STOP)
+		return 0;
+
+
+	if (io_local_work_pending(ctx)) {
+		unsigned nr_wait = ls->cq_tail - READ_ONCE(ctx->rings->cq.tail);
+		struct io_tw_state ts = {};
+
+		__io_run_local_work(ctx, ts, nr_wait, nr_wait);
+	}
+	return 1;
+}
diff --git a/io_uring/bpf.h b/io_uring/bpf.h
index 34a51a57103d..0b7246c4f05b 100644
--- a/io_uring/bpf.h
+++ b/io_uring/bpf.h
@@ -7,15 +7,41 @@
 
 #include "io_uring.h"
 
+enum {
+	IOU_RES_WAIT,
+	IOU_RES_STOP,
+};
+
 struct io_uring_ops {
+	int (*loop)(struct io_ring_ctx *ctx, struct iou_loop_state *ls);
+
+	__u32 ring_fd;
+	void *priv;
 };
 
+static inline bool io_bpf_attached(struct io_ring_ctx *ctx)
+{
+	return IS_ENABLED(CONFIG_IO_URING_BPF) && ctx->bpf_ops != NULL;
+}
+
+static inline bool io_has_cqwait_ops(struct io_ring_ctx *ctx)
+{
+	return io_bpf_attached(ctx);
+}
+
+
 #ifdef CONFIG_IO_URING_BPF
 void io_unregister_bpf(struct io_ring_ctx *ctx);
+int io_run_cqwait_ops(struct io_ring_ctx *ctx, struct iou_loop_state *ls);
 #else
 static inline void io_unregister_bpf(struct io_ring_ctx *ctx)
 {
 }
+static inline int io_run_cqwait_ops(struct io_ring_ctx *ctx,
+				    struct iou_loop_state *ls)
+{
+	return IOU_RES_STOP;
+}
 #endif
 
 #endif
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 5b80987ebb2c..1d5e3dd6c608 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2633,6 +2633,7 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events, u32 flags,
 	ktime_t start_time;
 	int ret;
 
+
 	min_events = min_t(int, min_events, ctx->cq_entries);
 
 	if (!io_allowed_run_tw(ctx))
@@ -2644,8 +2645,13 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events, u32 flags,
 
 	if (unlikely(test_bit(IO_CHECK_CQ_OVERFLOW_BIT, &ctx->check_cq)))
 		io_cqring_do_overflow_flush(ctx);
-	if (__io_cqring_events_user(ctx) >= min_events)
+
+	if (io_has_cqwait_ops(ctx)) {
+		if (ext_arg->min_time)
+			return -EINVAL;
+	} else if (__io_cqring_events_user(ctx) >= min_events) {
 		return 0;
+	}
 
 	init_waitqueue_func_entry(&iowq.wqe, io_wake_function);
 	iowq.wqe.private = current;
@@ -2706,6 +2712,13 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events, u32 flags,
 		__set_current_state(TASK_RUNNING);
 		atomic_set(&ctx->cq_wait_nr, IO_CQ_WAKE_INIT);
 
+		if (io_has_cqwait_ops(ctx)) {
+			ret = io_run_cqwait_ops(ctx, &iowq.ls);
+			if (ret <= 0)
+				break;
+			continue;
+		}
+
 		/*
 		 * Run task_work after scheduling and before io_should_wake().
 		 * If we got woken because of task_work being processed, run it
-- 
2.49.0


