Return-Path: <io-uring+bounces-8251-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 75E88AD03A1
	for <lists+io-uring@lfdr.de>; Fri,  6 Jun 2025 15:57:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C71811894EB3
	for <lists+io-uring@lfdr.de>; Fri,  6 Jun 2025 13:58:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFBC4289E38;
	Fri,  6 Jun 2025 13:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B7pSYukq"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF6EB28982F;
	Fri,  6 Jun 2025 13:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749218211; cv=none; b=s1/ctQrInS2/oPXUZWH9fdPC2WkEca0p49kwcCORYwLmmf30EhPPnzdX+aR9saC2ZuCdE9GozREtoUcY1GE9OWzDdJ6FJWCBTDgBBQLTxnJ4w4Q2O0xAy12yfrcXjGz4ajbjGiwEbtWN7WavZz6YQzEPXqhGjW3dYsf1ZtYbCBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749218211; c=relaxed/simple;
	bh=vyzsuUe/QoAXkeVTMOIyADJGcnKpwPxlUrNT3H0G/r4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IENpXJ8DQHVRmUTM7ts18oQcMSTNwaifQuE/55rX7sI8VMHoJZK7Lkyq230srCiPZQl/72odFjD4+2nAhdg+AyAMij684VKDCZEl9gqypn5kjGJw0H+tTlcOIF+nOJLIdvyhRJsuxw/VOavW55kmhzNfr/G4nqUV0sD/OBveXNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=B7pSYukq; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-ad574992fcaso345701866b.1;
        Fri, 06 Jun 2025 06:56:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749218208; x=1749823008; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ITjrjjEaCa6jkl2+7O9bYXssPOa5x6lyf9m6vXE7lKo=;
        b=B7pSYukqGpPluOq0PQ5dnlDqae7bql+vv1OOoXfXN+2k81qDgVQYdVE9L4AcINhQkS
         cspNpdnLiHa7MLIY4olsVKqWCDBk10/VTmK1Vq+wgOrLJnLHcjgK04QlgH3ru4VOieXy
         kHftr/oeFZeRdSETsGTlplWgT47TC5EL7+9NJApkRUDEyknGc/k43brFUUjei9UqePkk
         SAfgNplQtjtOrwC6YDEQ/UsFXA28V8ygWFvG+P790dKxERcbxTyWSBQsOqfLfquWA2d2
         fNn3qMLefUhMHIlzXE7qvDc0NXBawLdkPYV1FqIjj7X8UaH2G57emQgu5ALCHlIe/dfE
         IoQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749218208; x=1749823008;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ITjrjjEaCa6jkl2+7O9bYXssPOa5x6lyf9m6vXE7lKo=;
        b=Q7vOsKvxDwAiznNxzssR+ny/kYP354oWYTfNs0AcqFtqvvvovfSLUqC1ljvT/sDF+L
         AYxb+nHwJ+TQS4t8x7dQ/SNwYbC3GFP6wYlHRqEEU/axsr/tBOnORnnrDQJhuzugsMCH
         rbq7LJAKk5LKT4swmxIE9mkAz4yln2zv2vM90WXB2oPYA+m8sxShWmoIprIgY13p0BCX
         eUGK12hS+83BM5quTNUZ/bdxYXYf8gJGCOgEL7sHicCZPGEVrAhGWXlqCPTpOFZeBS/O
         0JlFIDK95ThrQNMEHNqnvdGewpJfC09vs9xCYtbisQvF3FBJYzjjt8F13UE6HhRI/7O3
         nNcQ==
X-Forwarded-Encrypted: i=1; AJvYcCU/8Ym6YjxvtKAHBjX8zTeW5yroHnfAxdbXrFSBjQOEsS84guRTeYsXHaSH7HdViB0m/ykjF6EPkHOQRZUp@vger.kernel.org, AJvYcCX2EWo2xQQCXQcNORL/d+GILxzEhJctQzAPsbRmS0CDAzmcwXf48DauAPG2I1Bi+NxFMYI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwTx1jaLth27yH/pbiClktTpbi9XvrpgO7MMCOK8l9jafP5c8cl
	IShGjYm7FojYyaQakDCxGyRaGyicRVVssJl8fNtxFpM0kKM7xbhDSzZHu8zQuA==
X-Gm-Gg: ASbGnctj6VCFcSyBRbrsni1fIQnyG5Wv7ficrErA+nHM5AV/yeT4CVU1caW6iSMsknT
	YLSG7n92MxvTfowYXEUU7IAdHi3A9z2CHxk7AN1SB/onuCSGBOuksIDMpVXGy6Txs59XPmsWGrx
	VUt95bhWZ+B8c60Ek7J2RFfM99v0HrcNFnTLU5vwqaQ3JjPunNWrvz3akZDasy3czPfX8DvX9J8
	0lQcfvDOr4cHUEL/j+lD5pokGEaIjaIVe+FypIQWnGA6P3m2j6d6HD2MBsE36omSdO8x2gPQSHP
	g44S4yezafMZaO8WChF8Pu0+1ZrkpRyYSqKE4XahDcvTlA==
X-Google-Smtp-Source: AGHT+IGsUtjamJY1/YfeofcK8ePS5kIlouljaSgzZkJheAWEKgdEXxo+ryEhnG2pmsRJYFP2dr341g==
X-Received: by 2002:a17:907:9813:b0:adb:2bb2:ee2 with SMTP id a640c23a62f3a-ade1aa0c2bfmr326963666b.41.1749218207331;
        Fri, 06 Jun 2025 06:56:47 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:a199])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ade1dc379f6sm118026766b.110.2025.06.06.06.56.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Jun 2025 06:56:46 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	Martin KaFai Lau <martin.lau@linux.dev>,
	bpf@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RFC v2 4/5] io_uring/bpf: add handle events callback
Date: Fri,  6 Jun 2025 14:58:01 +0100
Message-ID: <1c8fcadfb605269011618e285a4d9e066542dba2.1749214572.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1749214572.git.asml.silence@gmail.com>
References: <cover.1749214572.git.asml.silence@gmail.com>
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
 io_uring/bpf.c      | 33 +++++++++++++++++++++++++++++++++
 io_uring/bpf.h      | 16 ++++++++++++++++
 io_uring/io_uring.c | 22 +++++++++++++++++++++-
 3 files changed, 70 insertions(+), 1 deletion(-)

diff --git a/io_uring/bpf.c b/io_uring/bpf.c
index 0f82acf09959..f86b12f280e8 100644
--- a/io_uring/bpf.c
+++ b/io_uring/bpf.c
@@ -1,11 +1,20 @@
 #include <linux/mutex.h>
+#include <linux/bpf_verifier.h>
 
 #include "bpf.h"
 #include "register.h"
 
+static const struct btf_type *loop_state_type;
 DEFINE_MUTEX(io_bpf_ctrl_mutex);
 
+static int io_bpf_ops__handle_events(struct io_ring_ctx *ctx,
+				     struct iou_loop_state *state)
+{
+	return IOU_EVENTS_STOP;
+}
+
 static struct io_uring_ops io_bpf_ops_stubs = {
+	.handle_events = io_bpf_ops__handle_events,
 };
 
 static bool bpf_io_is_valid_access(int off, int size,
@@ -27,6 +36,16 @@ static int bpf_io_btf_struct_access(struct bpf_verifier_log *log,
 				    const struct bpf_reg_state *reg, int off,
 				    int size)
 {
+	const struct btf_type *t = btf_type_by_id(reg->btf, reg->btf_id);
+
+	if (t == loop_state_type) {
+		if (off >= offsetof(struct iou_loop_state, target_cq_tail) &&
+		    off + size <= offsetofend(struct iou_loop_state, target_cq_tail))
+			return SCALAR_VALUE;
+		if (off >= offsetof(struct iou_loop_state, timeout) &&
+		    off + size <= offsetofend(struct iou_loop_state, timeout))
+			return SCALAR_VALUE;
+	}
 	return -EACCES;
 }
 
@@ -36,8 +55,22 @@ static const struct bpf_verifier_ops bpf_io_verifier_ops = {
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
+	if (!loop_state_type)
+		return -EINVAL;
 	return 0;
 }
 
diff --git a/io_uring/bpf.h b/io_uring/bpf.h
index 4b147540d006..ac4a9361f9c7 100644
--- a/io_uring/bpf.h
+++ b/io_uring/bpf.h
@@ -7,12 +7,28 @@
 
 #include "io_uring.h"
 
+enum {
+	IOU_EVENTS_WAIT,
+	IOU_EVENTS_STOP,
+};
+
 struct io_uring_ops {
 	__u32 ring_fd;
 
+	int (*handle_events)(struct io_ring_ctx *ctx, struct iou_loop_state *state);
+
 	struct io_ring_ctx *ctx;
 };
 
+static inline int io_run_bpf(struct io_ring_ctx *ctx, struct iou_loop_state *state)
+{
+	scoped_guard(mutex, &ctx->uring_lock) {
+		if (!ctx->bpf_ops)
+			return IOU_EVENTS_STOP;
+		return ctx->bpf_ops->handle_events(ctx, state);
+	}
+}
+
 static inline bool io_bpf_attached(struct io_ring_ctx *ctx)
 {
 	return IS_ENABLED(CONFIG_BPF) && ctx->bpf_ops != NULL;
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 8f68e898d60c..bf245be0844b 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2540,8 +2540,13 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events, u32 flags,
 
 	if (unlikely(test_bit(IO_CHECK_CQ_OVERFLOW_BIT, &ctx->check_cq)))
 		io_cqring_do_overflow_flush(ctx);
-	if (__io_cqring_events_user(ctx) >= min_events)
+
+	if (io_bpf_attached(ctx)) {
+		if (ext_arg->min_time)
+			return -EINVAL;
+	} else if (__io_cqring_events_user(ctx) >= min_events) {
 		return 0;
+	}
 
 	init_waitqueue_func_entry(&iowq.wq, io_wake_function);
 	iowq.wq.private = current;
@@ -2621,6 +2626,21 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events, u32 flags,
 		if (ret < 0)
 			break;
 
+		if (io_bpf_attached(ctx)) {
+			ret = io_run_bpf(ctx, &iowq.state);
+			if (ret != IOU_EVENTS_WAIT)
+				break;
+
+			if (unlikely(read_thread_flags())) {
+				if (task_sigpending(current)) {
+					ret = -EINTR;
+					break;
+				}
+				cond_resched();
+			}
+			continue;
+		}
+
 		check_cq = READ_ONCE(ctx->check_cq);
 		if (unlikely(check_cq)) {
 			/* let the caller flush overflows, retry */
-- 
2.49.0


