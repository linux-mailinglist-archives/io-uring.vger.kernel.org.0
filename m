Return-Path: <io-uring+bounces-13262-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id nY9aCWpq/2kR6QAAu9opvQ
	(envelope-from <io-uring+bounces-13262-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 09 May 2026 19:10:02 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id B34DA500A5A
	for <lists+io-uring@lfdr.de>; Sat, 09 May 2026 19:10:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 76A57300230D
	for <lists+io-uring@lfdr.de>; Sat,  9 May 2026 17:10:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 574A23BC687;
	Sat,  9 May 2026 17:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lTPCa9Ar"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7970D2E7657
	for <io-uring@vger.kernel.org>; Sat,  9 May 2026 17:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778346596; cv=none; b=o5Q0/FOz3/SBvFdPKIwyV4wENOP6kSYJY3yyAwK6Z/N7eFdw9AYLQQARv0NT374WcWbzWRknt3yTmfQXJ1qoQBQCoBZyWA3LpLRfAh+iIfcuHfF84+ibnj/ANHEjemXgvTAi6ZU/XBZpTvMsj0dqgCev7VKX6Bj04WYXEpI4poM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778346596; c=relaxed/simple;
	bh=fnDKEKS9wIq6DO+hnNto15osf7JSWAjy9uW8JEw9daw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=F3pXNlwlzE6LbR5wYc0V8fXrYGtttScuL49q5w3/y+GO+vNYbeVE6BJL1/6ty5IkeR6vy5DQIGDGWoZhQuUIL2BPlN1DVEzgEmnbpJi+CPDWhbp61lNGTtpGnVhM/ZO6SqD6yjO+3eSO88hEIbo/Y6wQCw69SRbs/8aWKR16dWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lTPCa9Ar; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-367cbac9c37so423772a91.2
        for <io-uring@vger.kernel.org>; Sat, 09 May 2026 10:09:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778346593; x=1778951393; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=5eadlv0eY5jIsVBiHcN5NHAIei7t5Q9Lv0Go4u8YirA=;
        b=lTPCa9AroP3NJX6LGjr8cWl4IycemIf7RzmrZ5No17RPZTD+6BHNETfTBLJPvwFwj0
         g3bxIjq2uOxxm3GbuIs8J2zXUxPhaK4Pg2M3aJUE055nIhwb/Y9gLKIy93lDicaVz/RR
         JUuZFNzPW6hP5a+IkVhYVIm0WsqTvhktp0xdCRVf0L/uW+1QlZXVufm5SPYzyHVCQP2r
         6UAcXTHy+dROfonEQXMRoBWwWiJRgZ8N7tB5DwvAO20lujX5+jDYPlcBlHO0zRWJ+9SR
         Jx0suURERHoVEQsJSi4tdhbN0bdlFYfCix5HnK/hX7HIRGHgSzSzAX81jHVOmqD71dlS
         mOWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778346593; x=1778951393;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5eadlv0eY5jIsVBiHcN5NHAIei7t5Q9Lv0Go4u8YirA=;
        b=rHkCFXBN5fA/Ux1D40l3vUdhRYSf7WMOi/T7Yfqk6VCnkznmpXcd3cEy5vHmdbBMX6
         pF1UxDCTNsbCMQRtnDCoZcCXeeeEKAMPWqrQa15qIamWo+y0YDjqP4NGubiyWCqVWBRK
         v+H5Re9iGb38lqI+O6FFAdNVM95ty38PFmTd/RBQAU6w26mVt5ppo15R8EbLt0dMNQO8
         HnbByE7qCWHTCgDbHVIXsufHIFPiq8PW65Kru6OA5+i5oHnQIGTvVGV/u4a2Ep87hsV3
         C13ysy9t/TFu6L4+/lLQZL+EGQIcjZ0L7ylv9nyq1/8P0hltIKtUeiJT4lJEFvDAnxxO
         rXJw==
X-Gm-Message-State: AOJu0Yyzs0teaJDxMvun/wLySf+Q4/LWVQlhgejCauC6mq1Gg5IU8gP/
	pP0DI0Jy9vcEdlrIPbESCl9mcA8jpzqPCtfKHNz+51WHnMwI9n1j3A+gygEqCmXS
X-Gm-Gg: Acq92OHhQmAlM/L8rNaYFGhp1ACj7f6yCv9k2P/SQ8leCAEtyku0LEz8+TWxA2F6ua4
	bh47U9F3jfyGuw42RtIATj6cA+/zCXPl6NRcOwzqyXdd4xHsZ5dtW2w2uIuJjfAdxFBNkd8xCCi
	F1tbCKwuipjz543ar2bsrSavTyPZIrikSKYc7uDY0jGvVApOWviwlTvcp9A49NVsemDq9INJwbz
	iPIf2/D3hNIxQO+RaJL/jyoZrE11+eJIYQVtoOl1A1d28UrhLeIct/bjSgcCKIhRqkS6BO5Zbf6
	l0V/LMT8hXOu0IemIPG+GICnMDUetprvEISoNUtbMvWhyMz1N6NOzeFHGxUIXrrhUt3utI88zfe
	R8V9xkp8UOXYctHR3RDUeEyNUlxY+5CqE26lPTR2vy4Yvm1ZZCQPtlFoh5BydxAZAd+eaatbaxT
	ziHuFGW1fe9i9cS0EqkDIA3nlLAQmrQPTaCP5fIykw1+8VfTOV+v3O/+djA5eFScg8SqRwGu3IL
	4e5OcmyBMTa6EnU
X-Received: by 2002:a17:90a:10c8:b0:366:aba:4c86 with SMTP id 98e67ed59e1d1-3660aba4d83mr8087679a91.27.1778346592675;
        Sat, 09 May 2026 10:09:52 -0700 (PDT)
Received: from localhost.localdomain ([110.44.115.135])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-367d629f40bsm2575610a91.7.2026.05.09.10.09.50
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 09 May 2026 10:09:52 -0700 (PDT)
From: Shuvam Pandey <shuvampandey1@gmail.com>
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] io_uring/kbuf: retain pbuf ring list for deferred rw commits
Date: Sat,  9 May 2026 22:54:47 +0545
Message-ID: <20260509170947.67188-1-shuvampandey1@gmail.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B34DA500A5A
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13262-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_NEQ_ENVFROM(0.00)[shuvampandey1@gmail.com,io-uring@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[3];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	TO_DN_NONE(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_RCPT(0.00)[io-uring];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Action: no action

io_uring can defer committing a provided buffer ring selection until
request completion, since incremental buffer rings need the final
completion length.

For rw requests that complete asynchronously, deferred completion paths
can later call io_put_kbuf(..., NULL). If the selected io_buffer_list is
not retained across that point, io_kbuf_commit() is skipped and the
provided buffer ring head is not advanced.

Retain a reference to the selected io_buffer_list while commit is
deferred, and use it from the deferred put/recycle paths.

Signed-off-by: Shuvam Pandey <shuvampandey1@gmail.com>
---
 include/linux/io_uring_types.h | 10 +++++++++-
 io_uring/io_uring.c            |  1 +
 io_uring/kbuf.c                | 28 +++++++++++++++++++++++++++-
 io_uring/kbuf.h                | 20 +++++++++++++++++++-
 4 files changed, 56 insertions(+), 3 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 244392026c6d5e430bbac97b0328aba37a0c2770..8a477736595197ac833ae283b0446533e2353ccf 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -8,6 +8,7 @@
 #include <linux/llist.h>
 #include <uapi/linux/io_uring.h>
 
+struct io_buffer_list;
 struct iou_loop_params;
 struct io_uring_bpf_ops;
 
@@ -94,7 +95,8 @@ struct io_mapped_region {
  * struct io_kiocb. For legacy/classic provided buffers, keeping a reference
  * across execution contexts are fine. But for ring provided buffers, the
  * list may go away as soon as ->uring_lock is dropped. As the io_kiocb
- * persists, it's better to just keep the buffer local for those cases.
+ * persists, it's better to just keep the buffer local for those cases,
+ * unless the request has taken its own explicit lifetime reference.
  */
 struct io_br_sel {
 	struct io_buffer_list *buf_list;
@@ -738,6 +740,12 @@ struct io_kiocb {
 	union {
 		/* stores selected buf, valid IFF REQ_F_BUFFER_SELECTED is set */
 		struct io_buffer	*kbuf;
+		/*
+		 * Stores selected provided buffer ring list for deferred
+		 * commit, valid for REQ_F_BUFFER_RING requests with
+		 * REQ_F_BUFFERS_COMMIT set.
+		 */
+		struct io_buffer_list	*buf_list;
 
 		struct io_rsrc_node	*buf_node;
 	};
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 4ed998d60c09cb0706d23ce5e9a5c9da5e282607..c251d43d061c166cc040d4be379a41fe718f53cd 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1733,6 +1733,7 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	req->tctx = current->io_uring;
 	req->cancel_seq_set = false;
 	req->async_data = NULL;
+	req->buf_list = NULL;
 
 	if (unlikely(opcode >= IORING_OP_LAST)) {
 		req->opcode = 0;
diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 63061aa1cab945c2b8be220760e69d0426ebf104..84d4f892a5f33d90406dc26db5f73c269a51510d 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -220,6 +220,14 @@ static struct io_br_sel io_ring_buffer_select(struct io_kiocb *req, size_t *len,
 			req->flags |= REQ_F_BUF_MORE;
 		sel.buf_list = NULL;
 	}
+	if ((req->flags & REQ_F_BUFFERS_COMMIT) && sel.buf_list) {
+		if (WARN_ON_ONCE(req->buf_list && req->buf_list != bl))
+			return sel;
+		if (!req->buf_list) {
+			io_get_bl(bl);
+			req->buf_list = bl;
+		}
+	}
 	return sel;
 }
 
@@ -407,6 +415,7 @@ static inline bool __io_put_kbuf_ring(struct io_kiocb *req,
 unsigned int __io_put_kbufs(struct io_kiocb *req, struct io_buffer_list *bl,
 			    int len, int nbufs)
 {
+	struct io_buffer_list *stored_bl;
 	unsigned int ret;
 
 	ret = IORING_CQE_F_BUFFER | (req->buf_index << IORING_CQE_BUFFER_SHIFT);
@@ -416,8 +425,17 @@ unsigned int __io_put_kbufs(struct io_kiocb *req, struct io_buffer_list *bl,
 		return ret;
 	}
 
+	stored_bl = req->buf_list;
+	if (!bl)
+		bl = stored_bl;
+	else if (stored_bl && WARN_ON_ONCE(stored_bl != bl))
+		bl = stored_bl;
 	if (!__io_put_kbuf_ring(req, bl, len, nbufs))
 		ret |= IORING_CQE_F_BUF_MORE;
+	if (stored_bl) {
+		req->buf_list = NULL;
+		io_put_bl(req->ctx, stored_bl);
+	}
 	return ret;
 }
 
@@ -442,7 +460,7 @@ static int io_remove_buffers_legacy(struct io_ring_ctx *ctx,
 	return i;
 }
 
-static void io_put_bl(struct io_ring_ctx *ctx, struct io_buffer_list *bl)
+static void __io_put_bl(struct io_ring_ctx *ctx, struct io_buffer_list *bl)
 {
 	if (bl->flags & IOBL_BUF_RING)
 		io_free_region(ctx->user, &bl->region);
@@ -452,6 +470,12 @@ static void io_put_bl(struct io_ring_ctx *ctx, struct io_buffer_list *bl)
 	kfree(bl);
 }
 
+void io_put_bl(struct io_ring_ctx *ctx, struct io_buffer_list *bl)
+{
+	if (refcount_dec_and_test(&bl->refs))
+		__io_put_bl(ctx, bl);
+}
+
 void io_destroy_buffers(struct io_ring_ctx *ctx)
 {
 	struct io_buffer_list *bl;
@@ -579,6 +603,7 @@ static int __io_manage_buffers_legacy(struct io_kiocb *req,
 		bl = kzalloc_obj(*bl, GFP_KERNEL_ACCOUNT);
 		if (!bl)
 			return -ENOMEM;
+		refcount_set(&bl->refs, 1);
 
 		INIT_LIST_HEAD(&bl->buf_list);
 		ret = io_buffer_add_list(req->ctx, bl, p->bgid);
@@ -652,6 +677,7 @@ int io_register_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg)
 	bl = kzalloc_obj(*bl, GFP_KERNEL_ACCOUNT);
 	if (!bl)
 		return -ENOMEM;
+	refcount_set(&bl->refs, 1);
 
 	mmap_offset = (unsigned long)reg.bgid << IORING_OFF_PBUF_SHIFT;
 	ring_size = flex_array_size(br, bufs, reg.ring_entries);
diff --git a/io_uring/kbuf.h b/io_uring/kbuf.h
index 401773e1ef805eb46054a60ce226a3dcf41cf504..933eb2f16a820724c96104c59f26188971a85b13 100644
--- a/io_uring/kbuf.h
+++ b/io_uring/kbuf.h
@@ -3,6 +3,7 @@
 #define IOU_KBUF_H
 
 #include <uapi/linux/io_uring.h>
+#include <linux/refcount.h>
 #include <linux/io_uring_types.h>
 
 enum {
@@ -23,6 +24,7 @@ struct io_buffer_list {
 	};
 	/* count of classic/legacy buffers in buffer list */
 	int nbufs;
+	refcount_t refs;
 
 	__u16 bgid;
 
@@ -81,6 +83,13 @@ int io_manage_buffers_legacy(struct io_kiocb *req, unsigned int issue_flags);
 
 int io_register_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg);
 int io_unregister_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg);
+void io_put_bl(struct io_ring_ctx *ctx, struct io_buffer_list *bl);
+
+static inline void io_get_bl(struct io_buffer_list *bl)
+{
+	refcount_inc(&bl->refs);
+}
+
 int io_register_pbuf_status(struct io_ring_ctx *ctx, void __user *arg);
 
 bool io_kbuf_recycle_legacy(struct io_kiocb *req, unsigned issue_flags);
@@ -97,8 +106,17 @@ struct io_mapped_region *io_pbuf_get_region(struct io_ring_ctx *ctx,
 static inline bool io_kbuf_recycle_ring(struct io_kiocb *req,
 					struct io_buffer_list *bl)
 {
+	struct io_buffer_list *stored_bl = req->buf_list;
+
+	if (stored_bl) {
+		WARN_ON_ONCE(bl && bl != stored_bl);
+		req->buf_list = NULL;
+		req->flags &= ~(REQ_F_BUFFER_RING | REQ_F_BUFFERS_COMMIT);
+		io_put_bl(req->ctx, stored_bl);
+		return true;
+	}
 	if (bl) {
-		req->flags &= ~(REQ_F_BUFFER_RING|REQ_F_BUFFERS_COMMIT);
+		req->flags &= ~(REQ_F_BUFFER_RING | REQ_F_BUFFERS_COMMIT);
 		return true;
 	}
 	return false;

