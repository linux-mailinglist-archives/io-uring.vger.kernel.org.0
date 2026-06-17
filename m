Return-Path: <io-uring+bounces-13762-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id LoS6KPhXMmpuywUAu9opvQ
	(envelope-from <io-uring+bounces-13762-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 17 Jun 2026 10:16:56 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 1746269779E
	for <lists+io-uring@lfdr.de>; Wed, 17 Jun 2026 10:16:56 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RbaweCBp;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13762-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.234.253.10 as permitted sender) smtp.mailfrom="io-uring+bounces-13762-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B859C301829E
	for <lists+io-uring@lfdr.de>; Wed, 17 Jun 2026 08:16:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57EC5380FCD;
	Wed, 17 Jun 2026 08:16:46 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0498380FDD
	for <io-uring@vger.kernel.org>; Wed, 17 Jun 2026 08:16:43 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781684206; cv=none; b=Z+gWksZvvBV9wbcaMM7IP5gGgulCMgspem2dRXE2IerUmwlCHf5G6i7a9bwF04ELSufMN6wX07zuM1xjVz9mmAKSqypjac7ip85K8PUC5NhhTurqAvEUdpi+O1OaZ8HpC9KMdfINuJP1MVa33aAurLna5JSI+bUbFpc9Rdt77GE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781684206; c=relaxed/simple;
	bh=NxfN0BeqjIgbnZzNarIB+GRHEGcvbsfsp/n8se4UHS4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Mq3aiMB0sLv/Ktm7oJYwxJC8WQ4TIRDa9mqh6coKipW5Iwd41yZIyzMRFtIcIkwTplZMiiys/ZGgVYWHnicKT7Qakt8V5HmdZCOhQNyJ8y+tr7LXt4meFmMTfOpz8+j2SU79pySxDoRUhIbSu8zHVhiwNWaxtIHh1ivwdtERMj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RbaweCBp; arc=none smtp.client-ip=209.85.210.179
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-84232e83ca9so2634618b3a.2
        for <io-uring@vger.kernel.org>; Wed, 17 Jun 2026 01:16:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781684203; x=1782289003; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=gpWZctadBdFWdWdnkC3DyONakKfZEcIkoriDBiHeb+Q=;
        b=RbaweCBpCVkqQv7j0gDQ+X20F9mceiWrxG0YoSLxeDAIthRdiVJV5SY0xybZsiAgUk
         a/p6/A5VB4UTPCPg0um2+dJhjmpjlmKcVp91nhn0vYT5kHkftmidIAlHumuD1HWgxRMw
         dzYCvaqnuoYEijyvdugYbd0cMQpnUQ8wIrfFydgwCnxRQYkeKvLjJohLB7R6GazBv0w4
         699nLLZyzNusnwnDgo00d/eCEVyPamHnxbB1K3RHyy+lRF5JQ7PQAtA69X0JkK4qWPeC
         kROKfB1MlL9bB1AE2pi0p92Uj4CASqb1k3m/GE707giQAm81mpvgv8oYEOzNRgJu2isL
         CUUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781684203; x=1782289003;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gpWZctadBdFWdWdnkC3DyONakKfZEcIkoriDBiHeb+Q=;
        b=dyQ9RZ/J+8z1wLBweF2mFcZKST8JazW040bgPDvoLuQfGph/6gzjdR9LH95cNBdwCf
         Hea4Xlx2y3K56qvxZPayDAr2GPkq2QQnwudgSx2P/e9BlOAAEKVAzWtQ+xmTcqlY+QVB
         YDwPUK5CVi21R+FoVW508HYqXFImBpFlyTh5TEVOpGpiy8rbqTAKHMsB89XhKc71mCUk
         cuNg0/0trMFkkMN8tW4JnhFG+WZGw4He2mmMO/wApsbn1JozCIc4hPRyHvrrnZYUgEul
         P3l8Y+3hmjxHHNXen7kAVbx8tjGN98/aBXSSQkvfou34mRC96Otrv6rbODFWzjCTW9Nb
         xcMA==
X-Forwarded-Encrypted: i=1; AFNElJ9IGRGfsibJA1ksJ8X5iagE8D8428qoCuGrNL+iTtHD4NHuseEejKOLQo5DcBtvq9xIxejT1+O6CA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxLPcGJFZWvQOiX55+bYvRN9PpQeNvB/74HghqeYbexr310zsyA
	TZVwhFpOfLkunLSws7NgcDEXuf33PL9jqbpG6GYObrMYuIGXcbPt9rYN
X-Gm-Gg: Acq92OGwQSG/m+R4lqVEkbVeO8zD3C/cq9DOVHzn/T13Pyx5Kev8Sv4g7qjAjuycTul
	HbWjaktAdjuFAzREohdqk3uPhstkF6v9sy7qDnFx8rfyRAdEmjQLeoFnoVgotRvERQ2g0dRv3O/
	P9ek8EUGs6aIdRFxZ8yMs6vN2YTXCkSXyI367rLZJaNxDuo7ivf0rKRfHmU2p3khiGR/kcx41ar
	Ulr+vEqXw/fvU3PVImmVJhXRkwpgfOWJTKLURzm0RihVEX8qyVNXu4E7LjX6dQxxUm2ZsFuFnXA
	GEuhZUWkBV80qa1f5/LHaQ5kzdKPGlGBbPkLY481fthi7hHhFp7UAoH6UstxTlJ8ITv1JkPsKkG
	pN5GRVGPtlvf3maQZZaZCGKosFo7X4k0e6vF90S8jlIL0SmLyeKCkSgR+3CK2u6z8mfsL0btEar
	kuCs30vua+rGitZa/0t34rQJCbp+n7WjHAnrbhYp3PQWv0ago=
X-Received: by 2002:a05:6a00:2342:b0:842:5a8d:3035 with SMTP id d2e1a72fcca58-84524561d33mr2788663b3a.22.1781684203093;
        Wed, 17 Jun 2026 01:16:43 -0700 (PDT)
Received: from Athena ([58.146.127.224])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8434acf039fsm14874478b3a.20.2026.06.17.01.16.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Jun 2026 01:16:42 -0700 (PDT)
From: harshal24-chavan <harshal24.chavan@gmail.com>
To: axboe@kernel.dk,
	kees@kernel.org
Cc: gustavoars@kernel.org,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org,
	harshal24-chavan <harshal24.chavan@gmail.com>
Subject: [PATCH v2] [PATCH v2] io_uring/register: add IORING_REGISTER_CLONE_FILES opcode
Date: Wed, 17 Jun 2026 13:46:22 +0530
Message-ID: <20260617081622.32823-1-harshal24.chavan@gmail.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[kernel.org,vger.kernel.org,gmail.com];
	FORWARDED(0.00)[lists@lfdr.de];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER(0.00)[harshal24chavan@gmail.com,io-uring@vger.kernel.org];
	TAGGED_FROM(0.00)[bounces-13762-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:axboe@kernel.dk,m:kees@kernel.org,m:gustavoars@kernel.org,m:io-uring@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:linux-hardening@vger.kernel.org,m:harshal24.chavan@gmail.com,m:harshal24chavan@gmail.com,s:lists@lfdr.de];
	DKIM_TRACE(0.00)[gmail.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FREEMAIL_FROM(0.00)[gmail.com];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[harshal24chavan@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 1746269779E

Currently, if an application wants to duplicate registered file descriptors
from one io_uring instance to another, it must manually unregister and
re-register them, incurring unnecessary overhead.

Add IORING_REGISTER_CLONE_FILES to allow direct cloning of the file table
from a source ring to a destination ring. This includes support for
partial offsets and the IORING_REGISTER_DST_REPLACE flag.

Signed-off-by: harshal24-chavan <harshal24.chavan@gmail.com>

---
v2: Dropped unrelated whitespace formatting changes from v1
---
 include/uapi/linux/io_uring.h |  12 +++
 io_uring/register.c           |   6 ++
 io_uring/rsrc.c               | 160 ++++++++++++++++++++++++++++++++++
 io_uring/rsrc.h               |   1 +
 4 files changed, 179 insertions(+)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 909fb7aea638..0727602ce12f 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -723,6 +723,9 @@ enum io_uring_register_op {
 	/* register bpf filtering programs */
 	IORING_REGISTER_BPF_FILTER		= 37,
 
+	/* clone file descriptors from another ring*/
+	IORING_REGISTER_CLONE_FILES		= 38,
+
 	/* this goes last */
 	IORING_REGISTER_LAST,
 
@@ -854,6 +857,15 @@ struct io_uring_clone_buffers {
 	__u32	pad[3];
 };
 
+struct io_uring_clone_files {
+	__u32 src_fd;
+	__u32 flags;
+	__u32 src_off;
+	__u32 dst_off;
+	__u32 nr;
+	__u32 pad[3];
+};
+
 struct io_uring_buf {
 	__u64	addr;
 	__u32	len;
diff --git a/io_uring/register.c b/io_uring/register.c
index dce5e2f9cf77..bbc8c506ea2d 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -924,6 +924,12 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 			break;
 		ret = io_register_clone_buffers(ctx, arg);
 		break;
+	case IORING_REGISTER_CLONE_FILES:
+		ret = -EINVAL;
+		if (!arg || nr_args != 1)
+			break;
+		ret = io_register_clone_files(ctx, arg);
+		break;
 	case IORING_REGISTER_ZCRX_IFQ:
 		ret = -EINVAL;
 		if (!arg || nr_args != 1)
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 650303626be6..1e4e114ca5a5 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1303,6 +1303,166 @@ int io_register_clone_buffers(struct io_ring_ctx *ctx, void __user *arg)
 	return ret;
 }
 
+
+static int io_clone_files(struct io_ring_ctx *ctx, struct io_ring_ctx *src_ctx,
+			  struct io_uring_clone_files *arg)
+{
+	struct io_file_table new_file_table;
+	int i, off, nr;
+	unsigned int src_nr;
+
+	lockdep_assert_held(&ctx->uring_lock);
+	lockdep_assert_held(&src_ctx->uring_lock);
+
+	/* if offsets are given, must have nr specified too */
+	if (!arg->nr && (arg->dst_off || arg->src_off))
+		return -EINVAL;
+	/* not allowed unless REPLACE is set */
+	if (ctx->file_table.data.nr &&
+	    !(arg->flags & IORING_REGISTER_DST_REPLACE))
+		return -EBUSY;
+
+	src_nr = src_ctx->file_table.data.nr;
+	if (!src_nr)
+		return -ENXIO;
+	if (!arg->nr)
+		arg->nr = src_nr;
+	else if (arg->nr > src_nr)
+		return -EINVAL;
+	else if (arg->nr > IORING_MAX_FIXED_FILES)
+		return -EINVAL;
+	if (check_add_overflow(arg->nr, arg->src_off, &off) || off > src_nr)
+		return -EOVERFLOW;
+	if (check_add_overflow(arg->nr, arg->dst_off, &src_nr))
+		return -EOVERFLOW;
+	if (src_nr > IORING_MAX_FIXED_FILES)
+		return -EINVAL;
+	/* Allocate file tables memory {data + bitmap} into new_file_table */
+	memset(&new_file_table, 0, sizeof(new_file_table));
+	if (!io_alloc_file_tables(ctx, &new_file_table,
+				  max(src_nr, ctx->file_table.data.nr)))
+		return -ENOMEM;
+
+	/* Copy original dst nodes from before the cloned range */
+	for (i = 0; i < min(arg->dst_off, ctx->file_table.data.nr); i++) {
+		struct io_rsrc_node *node = ctx->file_table.data.nodes[i];
+
+		if (node) {
+			new_file_table.data.nodes[i] = node;
+			node->refs++;
+			io_file_bitmap_set(&new_file_table, i);
+		}
+	}
+
+	off = arg->dst_off;
+	i = arg->src_off;
+	nr = arg->nr;
+	while (nr--) {
+		struct io_rsrc_node *dst_node, *src_node;
+
+		src_node = io_rsrc_node_lookup(&src_ctx->file_table.data, i);
+		if (!src_node) {
+			dst_node = NULL;
+		} else {
+			dst_node = io_rsrc_node_alloc(ctx, IORING_RSRC_FILE);
+			if (!dst_node) {
+				io_free_file_tables(ctx, &new_file_table);
+				return -ENOMEM;
+			}
+
+			struct file *file = io_slot_file(src_node);
+
+			get_file(file);
+			io_fixed_file_set(dst_node, file);
+		}
+		new_file_table.data.nodes[off] = dst_node;
+		if (dst_node)
+			io_file_bitmap_set(&new_file_table, off);
+
+		i++;
+		off++;
+	}
+
+	/* Copy original dst nodes from after the cloned range */
+	for (i = src_nr; i < ctx->file_table.data.nr; i++) {
+		struct io_rsrc_node *node = ctx->file_table.data.nodes[i];
+
+		if (node) {
+			new_file_table.data.nodes[i] = node;
+			node->refs++;
+			io_file_bitmap_set(&new_file_table, i);
+		}
+	}
+
+	/*
+	 * If asked for replace, put the old table. new_file_table.data->nodes[] holds both
+	 * old and new nodes at this point.
+	 */
+	if (arg->flags & IORING_REGISTER_DST_REPLACE)
+		io_free_file_tables(ctx, &ctx->file_table);
+
+	/*
+	 * ctx->file_table must be empty now - either the contents are being
+	 * replaced and we just freed the table, or the contents are being
+	 * copied to a ring that does not have buffers yet (checked at function
+	 * entry).
+	 */
+	WARN_ON_ONCE(ctx->file_table.data.nr);
+	ctx->file_table = new_file_table;
+	io_file_table_set_alloc_range(ctx, 0, ctx->file_table.data.nr);
+	return 0;
+}
+
+int io_register_clone_files(struct io_ring_ctx *ctx, void __user *arg)
+{
+	struct io_uring_clone_files clone_arg;
+	struct io_ring_ctx *src_ctx;
+	bool registered_src;
+	struct file *file;
+	int ret;
+
+	if (copy_from_user(&clone_arg, arg, sizeof(clone_arg)))
+		return -EFAULT;
+	if (clone_arg.flags &
+	    ~(IORING_REGISTER_SRC_REGISTERED | IORING_REGISTER_DST_REPLACE))
+		return -EINVAL;
+	/* not allowed unless REPLACE is set */
+	if (!(clone_arg.flags & IORING_REGISTER_DST_REPLACE) &&
+	    ctx->file_table.data.nr)
+		return -EBUSY;
+	if (memchr_inv(clone_arg.pad, 0, sizeof(clone_arg.pad)))
+		return -EINVAL;
+
+	registered_src = (clone_arg.flags & IORING_REGISTER_SRC_REGISTERED) !=
+			 0;
+	file = io_uring_ctx_get_file(clone_arg.src_fd, registered_src);
+	if (IS_ERR(file))
+		return PTR_ERR(file);
+
+	src_ctx = file->private_data;
+	if (src_ctx != ctx) {
+		mutex_unlock(&ctx->uring_lock);
+		lock_two_rings(ctx, src_ctx);
+
+		/* Prevent cross-process hijacking */
+		if (src_ctx->submitter_task &&
+		    src_ctx->submitter_task != current) {
+			ret = -EEXIST;
+			goto out;
+		}
+	}
+
+	ret = io_clone_files(ctx, src_ctx, &clone_arg);
+
+out:
+	if (src_ctx != ctx)
+		mutex_unlock(&src_ctx->uring_lock);
+
+	if (!registered_src)
+		fput(file);
+	return ret;
+}
+
 void io_vec_free(struct iou_vec *iv)
 {
 	if (!iv->iovec)
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index 44e3386f7c1c..32f5c47c46af 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -75,6 +75,7 @@ int io_prep_reg_iovec(struct io_kiocb *req, struct iou_vec *iv,
 			const struct iovec __user *uvec, size_t uvec_segs);
 
 int io_register_clone_buffers(struct io_ring_ctx *ctx, void __user *arg);
+int io_register_clone_files(struct io_ring_ctx *ctx, void __user *arg);
 int io_sqe_buffers_unregister(struct io_ring_ctx *ctx);
 int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
 			    unsigned int nr_args, u64 __user *tags);
-- 
2.54.0


