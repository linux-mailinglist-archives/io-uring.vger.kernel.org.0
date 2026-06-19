Return-Path: <io-uring+bounces-13792-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id DAIfL9MNNWrKmQYAu9opvQ
	(envelope-from <io-uring+bounces-13792-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 19 Jun 2026 11:37:23 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 1828F6A4FC4
	for <lists+io-uring@lfdr.de>; Fri, 19 Jun 2026 11:37:23 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="E/dBmjEY";
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13792-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.234.253.10 as permitted sender) smtp.mailfrom="io-uring+bounces-13792-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 57A9E303EC09
	for <lists+io-uring@lfdr.de>; Fri, 19 Jun 2026 09:37:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5A1D366816;
	Fri, 19 Jun 2026 09:37:11 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAFAE3624D7
	for <io-uring@vger.kernel.org>; Fri, 19 Jun 2026 09:37:06 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781861831; cv=none; b=EZGWRn2Sljm1ml/MOU8UjTomOvOB3nbh5NhEoz2OnQwA/2LvROzUDvdptwevf6H1zj7IByZViLp9U3Q/yi4zi1QwNR3FPkk/eZxf6eziS1uVBZrWWsT5gsnGqmmrKtm47LrC6cxbyEB448rT2L9y3HKW79U62pmcqaH9iZ6bZ+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781861831; c=relaxed/simple;
	bh=Z8TkROFLM0xkFwPYNXiMm7jXh9wbNRuFi5+CXq37OlI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XYaxiPPY9OQ1sPJZjaGTuPmLXF5FyehIOaSOzQTmBZY6Z4ywS9ur/Kb6hVsPafqgZu8ac5XHNPqHcGCkMSPj23Jm3Omgwij3V9MAI/wCuGg0cuk2k7G0VoArizFrgewwHrzIAp826YqFVxthlR7Nr0kkCt8z0FOJnCd2s6Ehxio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=E/dBmjEY; arc=none smtp.client-ip=209.85.214.179
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2c6ab886da6so11920405ad.0
        for <io-uring@vger.kernel.org>; Fri, 19 Jun 2026 02:37:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781861826; x=1782466626; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Mt66HBgSzj4nAKrKflgHaRn6sKn42QXfIFAEBho8e/o=;
        b=E/dBmjEYIAp87bdUUAPPVgtlqevp3fYvcmVEnLaEvtaBCMzYDFg4srg9GLACisSzaa
         fl08Sf9kSoAe9I90WiceVaGBkgitZD/KS39cbo5qmL3oCv8LqqwhalR5+rS60/V3Yfx4
         jqYCrITmIENSkcBWmD69LVrIQT/7EGsB2crfytKHIhcFJH5Sk/qYB8jS70jYetvpq0dn
         DzNEZJthmx3Uavgj2v9lK6bTCbR/RAqhVkuoUvdF5fxct9eIOJCJLk6j/ncEbeYhkche
         ddY4BokOmzmcotle2zTMvdJn+ycEdcTquuDsrnrL1U9Wd4suZqcnpZMCuL2PRICMxLox
         d4nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781861826; x=1782466626;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Mt66HBgSzj4nAKrKflgHaRn6sKn42QXfIFAEBho8e/o=;
        b=rISLjpHjkDO/eHIYOalMwuodvFOF8JS6gAgEyjG6fvJ8eziSItrVWXrXKpLKlN3HqV
         OegpHTQVV4/idgJwPxfkTEBeDEngzzkGrmtyFLQCNwXiFyGQD75A1KVYRophTTbUtTjm
         ZEUt8xQ9dpGu+m5Czjg5L0GKqzfzhCKNRb98hxdEp3rUMJ/iPpsdZIXx77Ec1WwOscVG
         2fmkUHI6Qs8UMWinuCcUyTM4B4JdX9+0BPx9WiQWvmFKiXKh90ouelYta2XBQX3UwHRl
         VcWn69tUQ9lw0BuOdAgzh11wc0ocNpegvPC/CY9ImJsapoq5h9LNdLlcV08WSyR5ht0F
         uI0g==
X-Gm-Message-State: AOJu0Yy0cJH/urFFOuqu0jhwZWTvzVrXyZ7PwkTwxitZ9cfs3oEa9VPw
	R960G1EMe4ijQ1bDBqNZcLtGmbFGXkeeOYA64PDBuSzldF0O6yT7WkkWdYRveZEs
X-Gm-Gg: AfdE7cmNvZ0P2QyVL8EGgO7vtgEJQlwOOLjum31nF2SLnk3ZhqCWqnTRxgkNiGjeB3m
	FwS4pWw41nTAfeJHEVO6uaJe3aQVbvo4gYbe9xzD77XssJuuUnCRq7kqSY9hnzn5+1PWJGdHUBa
	gWGM3vjrk+ySz+Kv65VDIe4qsQzE82zjwvN5ud3/YV2JoyLaQBQq8zua47fO9w4AABzWjMbP4NF
	UMvuiSL2Din2rYnUM7/daXWEGh/T7j4UR/An8TxXfQE2yiDub3ba9KS6vYU4Ucc8GSL7BfyxpTv
	3vw/1oS6NDY7e7o4gTbYdpSwNyduLifQDsUOpbaMni5taIpKe8yUkuDurm3wcMngtWAIUNEs7/y
	CPK+aLjgK6fACw99UC6B3GbO1aSavr0/IUML7KFOsW5fjzaBdXzHteDgrLs8wgmiEv9Ao8tPb9R
	rh1Mf5lurqnnA54xjYGNTsKDS236JuFrxKsI5c+gRYgDJuig==
X-Received: by 2002:a17:902:f68d:b0:2bc:b80f:677e with SMTP id d9443c01a7336-2c718f4a742mr31309725ad.25.1781861825668;
        Fri, 19 Jun 2026 02:37:05 -0700 (PDT)
Received: from Athena ([58.146.97.175])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c7208c44c7sm18224015ad.18.2026.06.19.02.37.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Jun 2026 02:37:05 -0700 (PDT)
From: Harshal Chavan <harshal24.chavan@gmail.com>
To: io-uring@vger.kernel.org,
	axboe@kernel.dk
Cc: krisman@kernel.org,
	gregkh@linuxfoundation.org,
	kees@kernel.org,
	gustavoars@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org,
	Harshal Chavan <harshal24.chavan@gmail.com>
Subject: [PATCH v4] io_uring/register: add IORING_REGISTER_CLONE_FILES opcode
Date: Fri, 19 Jun 2026 15:06:41 +0530
Message-ID: <20260619093641.25339-1-harshal24.chavan@gmail.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORWARDED(0.00)[lists@lfdr.de];
	FREEMAIL_CC(0.00)[kernel.org,linuxfoundation.org,vger.kernel.org,gmail.com];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-13792-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:io-uring@vger.kernel.org,m:axboe@kernel.dk,m:krisman@kernel.org,m:gregkh@linuxfoundation.org,m:kees@kernel.org,m:gustavoars@kernel.org,m:linux-kernel@vger.kernel.org,m:linux-hardening@vger.kernel.org,m:harshal24.chavan@gmail.com,m:harshal24chavan@gmail.com,s:lists@lfdr.de];
	FORGED_SENDER(0.00)[harshal24chavan@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[harshal24chavan@gmail.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCPT_COUNT_SEVEN(0.00)[9];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,vger.kernel.org:from_smtp]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 1828F6A4FC4

Currently, if an application wants to duplicate registered file
descriptors from one io_uring instance to another, it must manually
unregister and re-register them, incurring unnecessary overhead.

Add IORING_REGISTER_CLONE_FILES to allow direct cloning of the file
table from a source ring to a destination ring. This implementation
strictly mirrors the io_clone_buffers UAPI, supporting partial offsets
and the IORING_REGISTER_DST_REPLACE flag.

To ensure lock synchronization safety, destination nodes are strictly
allocated as new, private io_rsrc_nodes rather than sharing references
across rings.

Signed-off-by: Harshal Chavan <harshal24.chavan@gmail.com>

---
v4:
  - Updated Signed-off-by to use real name and moved above the scissors line (Greg KH).
v3:
  - Rewrote the cloning loop to allocate private destination nodes via io_rsrc_node_alloc to fix non-atomic ref lock synchronization (Jens).
  - Maintained partial offset/copy support to mirror io_clone_buffers UAPI (Jens).
  - Gated the replacement free check on ctx->file_table.data.nr (Gabriel).
  - Prevented self-cloning by checking ctx == src_ctx (Gabriel).
  - Removed submitter_task check to allow cross-thread pooling setups (Gabriel).
v2:
  - Dropped unrelated whitespace formatting changes from v1
---
 include/uapi/linux/io_uring.h |  12 +++
 io_uring/register.c           |   6 ++
 io_uring/rsrc.c               | 149 ++++++++++++++++++++++++++++++++++
 io_uring/rsrc.h               |   1 +
 4 files changed, 168 insertions(+)

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
index 650303626be6..a598e5af4c0a 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1303,6 +1303,155 @@ int io_register_clone_buffers(struct io_ring_ctx *ctx, void __user *arg)
 	return ret;
 }
 
+static int io_clone_file_node(struct io_ring_ctx *ctx,
+			      struct io_rsrc_node *src_node,
+			      int dst_index,
+			      struct io_file_table *new_table)
+{
+	struct io_rsrc_node *dst_node;
+	struct file *file;
+
+	dst_node = io_rsrc_node_alloc(ctx, IORING_RSRC_FILE);
+	if (!dst_node)
+		return -ENOMEM;
+
+	file = io_slot_file(src_node);
+	get_file(file);
+	io_fixed_file_set(dst_node, file);
+
+	new_table->data.nodes[dst_index] = dst_node;
+	io_file_bitmap_set(new_table, dst_index);
+
+	return 0;
+}
+
+static int io_clone_files(struct io_ring_ctx *ctx, struct io_ring_ctx *src_ctx,
+			  struct io_uring_clone_files *arg)
+{
+	struct io_file_table new_file_table;
+	unsigned int dst_nr = ctx->file_table.data.nr;
+	unsigned int src_nr = src_ctx->file_table.data.nr;
+	unsigned int new_nr, i;
+
+	lockdep_assert_held(&ctx->uring_lock);
+	lockdep_assert_held(&src_ctx->uring_lock);
+
+	if (ctx->user != src_ctx->user || ctx->mm_account != src_ctx->mm_account)
+		return -EINVAL;
+
+	if (dst_nr && !(arg->flags & IORING_REGISTER_DST_REPLACE))
+		return -EBUSY;
+
+	if (!src_nr)
+		return -ENXIO;
+
+	if (!arg->nr)
+		arg->nr = src_nr;
+	else if (arg->nr > src_nr)
+		return -EINVAL;
+
+	if (check_add_overflow(arg->src_off, arg->nr, &i) || i > src_nr)
+		return -EINVAL;
+	if (check_add_overflow(arg->dst_off, arg->nr, &i))
+		return -EINVAL;
+
+	new_nr = max(dst_nr, arg->dst_off + arg->nr);
+	if (new_nr > IORING_MAX_FIXED_FILES)
+		return -EINVAL;
+
+	memset(&new_file_table, 0, sizeof(new_file_table));
+	if (!io_alloc_file_tables(ctx, &new_file_table, new_nr))
+		return -ENOMEM;
+
+	/* Copy original nodes from before the cloned range */
+	for (i = 0; i < min(arg->dst_off, dst_nr); i++) {
+		struct io_rsrc_node *src_node = io_rsrc_node_lookup(&ctx->file_table.data, i);
+
+		if (!src_node)
+			continue;
+		if (io_clone_file_node(ctx, src_node, i, &new_file_table))
+			goto out;
+	}
+
+	/* Copy the actual cloned range from the source ring */
+	for (i = 0; i < arg->nr; i++) {
+		struct io_rsrc_node *src_node = io_rsrc_node_lookup(&src_ctx->file_table.data,
+				arg->src_off + i);
+
+		if (!src_node)
+			continue;
+		if (io_clone_file_node(ctx, src_node, arg->dst_off + i, &new_file_table))
+			goto out;
+	}
+
+	/* Copy original nodes from after the cloned range */
+	for (i = arg->dst_off + arg->nr; i < dst_nr; i++) {
+		struct io_rsrc_node *src_node = io_rsrc_node_lookup(&ctx->file_table.data, i);
+
+		if (!src_node)
+			continue;
+		if (io_clone_file_node(ctx, src_node, i, &new_file_table))
+			goto out;
+	}
+
+	/* free the old file table if there is any data present */
+	if (dst_nr)
+		io_free_file_tables(ctx, &ctx->file_table);
+
+	WARN_ON_ONCE(ctx->file_table.data.nr);
+	ctx->file_table = new_file_table;
+	io_file_table_set_alloc_range(ctx, 0, ctx->file_table.data.nr);
+	return 0;
+
+out:
+	/* Error Path: Safely destroy whatever we partially built */
+	io_free_file_tables(ctx, &new_file_table);
+	return -ENOMEM;
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
+
+	if (memchr_inv(clone_arg.pad, 0, sizeof(clone_arg.pad)))
+		return -EINVAL;
+
+	registered_src = (clone_arg.flags & IORING_REGISTER_SRC_REGISTERED) != 0;
+	file = io_uring_ctx_get_file(clone_arg.src_fd, registered_src);
+	if (IS_ERR(file))
+		return PTR_ERR(file);
+
+	src_ctx = file->private_data;
+	/* Same ring clone is not allowed */
+	if (src_ctx == ctx) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	mutex_unlock(&ctx->uring_lock);
+	lock_two_rings(ctx, src_ctx);
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


