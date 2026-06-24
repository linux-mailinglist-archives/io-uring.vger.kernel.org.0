Return-Path: <io-uring+bounces-13823-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id G32AO92JO2rHZQgAu9opvQ
	(envelope-from <io-uring+bounces-13823-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 24 Jun 2026 09:40:14 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 85BC86BC406
	for <lists+io-uring@lfdr.de>; Wed, 24 Jun 2026 09:40:13 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nBpcratL;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13823-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c09:e001:a7::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13823-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id CB120301F885
	for <lists+io-uring@lfdr.de>; Wed, 24 Jun 2026 07:39:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F2AE388E5A;
	Wed, 24 Jun 2026 07:39:48 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF8F72EEE9E
	for <io-uring@vger.kernel.org>; Wed, 24 Jun 2026 07:39:46 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782286788; cv=none; b=PQkZAeKtousqkI0+QwPfNHe/9DVFcYnofyluviyRw92kc3knk8TQsmG+pLFrQyvoPm77VWJUYgVZz5VNmc0F577phdutfpPBqKD1YtM9TVXiHMce/TeH761zg2Qk2sxivzOhvCNjsjQun+QzwF0fVLleAAxls6kh0m/jXI8hIbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782286788; c=relaxed/simple;
	bh=K9hXOjJNrOUVW4ZYqXx7EpTqNs3yz4MSR382ybbfthk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OdFgTGd/Gthj3/kcENT987aIeTswNNKLnXUaCOqaZMprd/nSV1X1bEWWFuHEZH53WXO6c8YjoCfI7FK/5aSL+mq1tiFHzNVroXukoF//cFaUERBp0hPc8PjBobuSMLZpJc2vgK5WulpUHX1h33L7VXaHy+TUd0DFx7hkH9shJWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nBpcratL; arc=none smtp.client-ip=209.85.210.180
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-84347ad88edso847617b3a.1
        for <io-uring@vger.kernel.org>; Wed, 24 Jun 2026 00:39:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782286786; x=1782891586; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=NG4dKTDv8JZYL7kS7cRIE6tHZ+j36hHvO+etffou0zY=;
        b=nBpcratL8BpqYna82iQSngCsqcqqV+jZrrfkZSZGv3hA99jDGOpf2NtGoufUL1PQAS
         uEr4mmfNsG5geOKoRETbUeU/m/kF8sMeeeZCuoWWEJoR8JeyEgHjcgh4w0x5sJo2SOYy
         ofEjzYei5W1loN+zuhmIOyOp7V/jV2lNuPYRStswjrLUdMe9se7gWXpUvyj63dLOjury
         1CrNj6PGvkkfRols1T+3ZxRv6L3gYiupkm84Hhq49rfeBlvhQ4G/3ayteatXxQZNwVW+
         qtwEdI2RHXiSRH9rD7zwghcxfdE8gHIKSjmshGiPiKNyiD49BA/RTxpo91tCeDCVzhXF
         jtXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782286786; x=1782891586;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NG4dKTDv8JZYL7kS7cRIE6tHZ+j36hHvO+etffou0zY=;
        b=KUK2PuqdiMN+4mBZWiS/pWewM3mXzby1YKK5ihAAUs/nrapv8FKVbbXWRegARRiF/R
         +mGwrDjywO72HNLfg6O/vPIIr5hNaniUvFsMFJSvHls1MaiSRnIrW89/QigyCZPdxnF5
         or5ygiWMjIQqehxNao/aw9Fk1JxSKOl7+lLi/xsV6msUVPcT35lw4uAIDnUhzhnuSnK8
         fCV6Gnr08rt8mei51EQI6+MHL5QoPbgIdBKPGFVFJb/YCrtcdNWqyt7VagQH6wdXaSvW
         crwzw7N8CeRxNFnIpjffIg432eK1IExT9b6LQTG2Zfea9TH/0zfF6lhcWSn9Mm5TGc1o
         L38g==
X-Gm-Message-State: AOJu0YzJM404EYbP5P9wWYYKSHeQ2GHQxWzKd1wTpDvhaF6tg6O6Nvc+
	+6rtWaiTvJw9GKSTmR7uThrjAWEh9FqPtHG68ctd0lvRrL3V0eMAkWJQTkWK1uBe
X-Gm-Gg: AfdE7cntxIWKRYwH/wWMzsFmOf6/UEEH0bBAbR1MsRrTxfWcoVCwLcUv7s5Bn9/N4F7
	Uz1J8bp2yNMeqIEyNO9eizJaYQUl68QKZleYImiJX84KvJAUX+L0r5RDt1UEHJh4+GQ4zgZBgkL
	MIOynQfBDRRceUmlmEvTMDJtxdNghfDaphZCpI/Kja4erxvATaPK5/m+9axpn8qUzfSTM4WTDuL
	ig5Ry2DPFDkYiK5hCH0RTnflY4aoi8psxFVxSsGd7xz/3guMfmIbSZ+u34p1YY+z2AMpt/yYY4c
	+/tVzD5GDbm+/qP/fZjVSpJNnc/ouqTolLurp5y9PolFGhIJruamtnZ24Tqzo9fOZGFNmR4PU3f
	yQA+IdkvT8EzcktAyJnW8w7ktR7aI7INO8u3UWGQbNXqMlVmjnYGcVOOpYCNcF3hVq/Ltsve0Gz
	kwIF+GqeVkDsMyzZ2q+w9QVsy09hAVfeWIXXRq6E5LHlcCgg==
X-Received: by 2002:a05:6a00:1ac6:b0:82f:6e9:d1c3 with SMTP id d2e1a72fcca58-845a2c82cc3mr3048248b3a.29.1782286786086;
        Wed, 24 Jun 2026 00:39:46 -0700 (PDT)
Received: from Athena ([58.146.97.171])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-845a3fecc06sm1370420b3a.21.2026.06.24.00.39.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2026 00:39:45 -0700 (PDT)
From: Harshal Chavan <harshal24.chavan@gmail.com>
To: io-uring@vger.kernel.org
Cc: axboe@kernel.dk,
	krisman@suse.de,
	gregkh@linuxfoundation.org,
	gustavoars@kernel.org,
	harshal24.chavan@gmail.com,
	kees@kernel.org,
	linux-hardening@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v5] io_uring/register: add IORING_REGISTER_CLONE_FILES opcode
Date: Wed, 24 Jun 2026 13:09:21 +0530
Message-ID: <20260624073921.11037-1-harshal24.chavan@gmail.com>
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
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[kernel.dk,suse.de,linuxfoundation.org,kernel.org,gmail.com,vger.kernel.org];
	TAGGED_FROM(0.00)[bounces-13823-lists,io-uring=lfdr.de];
	FORGED_SENDER_FORWARDING(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:io-uring@vger.kernel.org,m:axboe@kernel.dk,m:krisman@suse.de,m:gregkh@linuxfoundation.org,m:gustavoars@kernel.org,m:harshal24.chavan@gmail.com,m:kees@kernel.org,m:linux-hardening@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:harshal24chavan@gmail.com,s:lists@lfdr.de];
	FORGED_SENDER(0.00)[harshal24chavan@gmail.com,io-uring@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FROM_NEQ_ENVFROM(0.00)[harshal24chavan@gmail.com,io-uring@vger.kernel.org];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	FREEMAIL_FROM(0.00)[gmail.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 85BC86BC406

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
v5:
  - Added missing spacing in comment (Gabriel).
  - Removed ctx->user and mm_account checks (Gabriel).
  - Used !! for boolean conversion (Gabriel).
  - Moved mutex_unlock unconditionally above the out label (Gabriel).
  - liburing implementation and tests: https://github.com/axboe/liburing/pull/1606
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
 io_uring/rsrc.c               | 145 ++++++++++++++++++++++++++++++++++
 io_uring/rsrc.h               |   1 +
 4 files changed, 164 insertions(+)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 909fb7aea638..67fcc40f8dfc 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -723,6 +723,9 @@ enum io_uring_register_op {
 	/* register bpf filtering programs */
 	IORING_REGISTER_BPF_FILTER		= 37,
 
+	/* clone file descriptors from another ring */
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
index 650303626be6..5ddd715e2a63 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1303,6 +1303,151 @@ int io_register_clone_buffers(struct io_ring_ctx *ctx, void __user *arg)
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
+	registered_src = !!(clone_arg.flags & IORING_REGISTER_SRC_REGISTERED); 
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
+	mutex_unlock(&src_ctx->uring_lock);
+
+out:
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


