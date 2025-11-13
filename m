Return-Path: <io-uring+bounces-10598-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 115DCC57501
	for <lists+io-uring@lfdr.de>; Thu, 13 Nov 2025 13:01:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id D814E4E51B0
	for <lists+io-uring@lfdr.de>; Thu, 13 Nov 2025 12:00:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6CA534F486;
	Thu, 13 Nov 2025 12:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X4EPI2xP"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D657834E772
	for <io-uring@vger.kernel.org>; Thu, 13 Nov 2025 12:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763035214; cv=none; b=TfiWWf6WtEqNSdR+SH3EaZbDm2l7LBV2muADTyYCoPlJ4ZS94sZJT/ROaZksAhR3XhM71E0fwZo6Rvz6szerhFwjy+P5a3yEoIx9thvc2CttAKqmRN8EOrrrA8zoZWp+RzamzCdE5O9F1Fh7K3PUrM/PVlDgehWdVSWSmbOlyaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763035214; c=relaxed/simple;
	bh=JiFLmNqmjd/vjx2C0qtPvEbTcg8VXAhM7dTOW+8F6pQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mgqq/3AzfZcr4n+rpxTJ8UrAXeW/SZLbAHEXd+2HCu/pQOgr67IwdYUELNnI6HksTZ6sona+yUxK/2tHBhuY/J6BHXBcjGkOrvG874izZyIppubzj55aSYtLBIb6B/zCGCUltkRIAJSMNPAk4ILfOeba/6p/DSmIGssBz6TxVOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=X4EPI2xP; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-47774d3536dso6294125e9.0
        for <io-uring@vger.kernel.org>; Thu, 13 Nov 2025 04:00:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763035210; x=1763640010; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rhjbIB7wkst0NSV7bgVK7c08B5hwQyZn5Dtcm/QFuRo=;
        b=X4EPI2xPZFXYYo3SlLHq0pOmGJioP8ZeEpENXTT23mqR+wAtIk4xkzD6AB7FIx7YuH
         4FWGs5bvXnqz3o2RhsWohlsdSl70hAFzVJI1EvvEebcPkT9GsBtVha5w24G5Oq5DcKX8
         kmtkr98y+wVwL2RET7EWm6aUkOXI/r5NM0fIOLMZeAVU7puGPJDkjdWhdci73MQ/Q/Ta
         ldY/uzS/9fa9q+AJFU69Hv/5UdX7v6U4cUQ+/Egg1CmfGQ171ERKr3tX/062f8GfXapu
         sJVNmMJX27FWox+Dajebna6FlKQw7a4juQT+8i1BriBwhoMuKOYKgORC4OmBGc8hiPk3
         WSew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763035210; x=1763640010;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rhjbIB7wkst0NSV7bgVK7c08B5hwQyZn5Dtcm/QFuRo=;
        b=anncTYmvnrEr6oxgmK/SHyJWs051Dg0IzDt26uRkSqkV5iUvb4EPVwC6SOaQkaLg82
         Fs7472N+ADvGrTckaG3s3na/+xxS9Fw8KFZ6kBAObpOw98WUMxQ9VeJfSKFKmAnhaLcz
         Wkq/9L3gtFdg4ztF71UcoUb2EsaG/6x35+iSDFskd2nO54RlsTmvPq+dPr8u6OSSJ3w1
         BXk2iLI1wOoNXwh437ukXzErwepRvs9eHsXQ6PwRk+gF8fXCGa1MWv6cxFLlJF+RT2l2
         vUAxdEt2arULO+1zhDfpgGg0r6osZnB0GxRA9+bEtpf/eLkDl4rmpx4bX9GQ8Jkd2Mxs
         v2mg==
X-Gm-Message-State: AOJu0Yw44GGILP0AQEwiMMtZ95GWXRSSF62J9S/1wkX0a/ou4FSP9nAW
	NWVP9Egz6yavqSbN1LX5bMvMD4lTjqjE9Zy9Spq8KPjxluH00wyDYZiOhL1+Ig==
X-Gm-Gg: ASbGnctEMeXOu8Ddoe61JzMrdO2QXBP9DsnwdCtQ4Vr9lMb6BdkmLFL0K29Nb3RYUbO
	FJqfFoehKSl071VBpGeuS/9WgdXfPixhiAdOxEJCS/ksFJBQquTYtScBHnRb8k/XSGBX/R5dJaJ
	qbh7Q1RDpcQeJsGdXgFeGLkvYjuXnqy77QduK/p5z0jDDGctF743GSRuQsxZ52DN0LKTBi6Y9Pm
	1r2pdar+UAPOsVy7OXJ2Lu7rFVrj9kaUOE7QmQjNPG5ShUutu+HUd16rx5oXCuMWFrHQOK8d1hr
	qu7pF5QVer/EZ7y+yypUWNpZuUMRBEcHg1DMDxz/h/7jdR7OKfKdjGZYrsp+cjtsSu7KKi8TzOx
	cyIJoLuMgL9+0AU1TjKOE1NHSoH/3bjeDveA1bJIC3CjgFw6eErRsUfKGO5/Ix7Dlj0wMlw==
X-Google-Smtp-Source: AGHT+IFK3iiXM5qCCXBqD8NMgoGFdsSmnfI1rFnUAqA36dKLvrQFKZgIivV1Ps3+S+9eCW5FDOXzDg==
X-Received: by 2002:a05:600c:310b:b0:477:7ae1:f254 with SMTP id 5b1f17b1804b1-4778bd70fdfmr24321375e9.14.1763035209741;
        Thu, 13 Nov 2025 04:00:09 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:6794])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42b53e85e6fsm3686816f8f.18.2025.11.13.04.00.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Nov 2025 04:00:09 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk,
	Martin KaFai Lau <martin.lau@linux.dev>,
	bpf@vger.kernel.org,
	Alexei Starovoitov <alexei.starovoitov@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	ming.lei@redhat.com
Subject: [PATCH v3 08/10] io_uring/bpf: add basic kfunc helpers
Date: Thu, 13 Nov 2025 11:59:45 +0000
Message-ID: <882545e8fec2dd36d9fc52aacb7387c80ebf8394.1763031077.git.asml.silence@gmail.com>
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

A handle_events program should be able to parse the CQ and submit new
requests, add kfuncs to cover that. The only essential kfunc here is
bpf_io_uring_submit_sqes, and the rest are likely be removed in a
non-RFC version in favour of a more general approach.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/bpf.c | 53 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/io_uring/bpf.c b/io_uring/bpf.c
index 683e87f1a58b..006cea78cc10 100644
--- a/io_uring/bpf.c
+++ b/io_uring/bpf.c
@@ -3,10 +3,55 @@
 
 #include "bpf.h"
 #include "register.h"
+#include "memmap.h"
 
 static DEFINE_MUTEX(io_bpf_ctrl_mutex);
 static const struct btf_type *loop_state_type;
 
+__bpf_kfunc_start_defs();
+
+__bpf_kfunc int bpf_io_uring_submit_sqes(struct io_ring_ctx *ctx, u32 nr)
+{
+	return io_submit_sqes(ctx, nr);
+}
+
+__bpf_kfunc
+__u8 *bpf_io_uring_get_region(struct io_ring_ctx *ctx, __u32 region_id,
+			      const size_t rdwr_buf_size)
+{
+	struct io_mapped_region *r;
+
+	switch (region_id) {
+	case 0:
+		r = &ctx->ring_region;
+		break;
+	case 1:
+		r = &ctx->sq_region;
+		break;
+	case 2:
+		r = &ctx->param_region;
+		break;
+	default:
+		return NULL;
+	}
+
+	if (unlikely(rdwr_buf_size > io_region_size(r)))
+		return NULL;
+	return io_region_get_ptr(r);
+}
+
+__bpf_kfunc_end_defs();
+
+BTF_KFUNCS_START(io_uring_kfunc_set)
+BTF_ID_FLAGS(func, bpf_io_uring_submit_sqes, KF_SLEEPABLE | KF_TRUSTED_ARGS);
+BTF_ID_FLAGS(func, bpf_io_uring_get_region, KF_RET_NULL | KF_TRUSTED_ARGS);
+BTF_KFUNCS_END(io_uring_kfunc_set)
+
+static const struct btf_kfunc_id_set bpf_io_uring_kfunc_set = {
+	.owner = THIS_MODULE,
+	.set = &io_uring_kfunc_set,
+};
+
 static int io_bpf_ops__loop(struct io_ring_ctx *ctx, struct iou_loop_state *ls)
 {
 	return IOU_RES_STOP;
@@ -68,12 +113,20 @@ io_lookup_struct_type(struct btf *btf, const char *name)
 
 static int bpf_io_init(struct btf *btf)
 {
+	int ret;
+
 	loop_state_type = io_lookup_struct_type(btf, "iou_loop_state");
 	if (!loop_state_type) {
 		pr_err("io_uring: Failed to locate iou_loop_state\n");
 		return -EINVAL;
 	}
 
+	ret = register_btf_kfunc_id_set(BPF_PROG_TYPE_STRUCT_OPS,
+					&bpf_io_uring_kfunc_set);
+	if (ret) {
+		pr_err("io_uring: Failed to register kfuncs (%d)\n", ret);
+		return ret;
+	}
 	return 0;
 }
 
-- 
2.49.0


