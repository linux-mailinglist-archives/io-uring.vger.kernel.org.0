Return-Path: <io-uring+bounces-12883-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OETXBmi+xmnoNwUAu9opvQ
	(envelope-from <io-uring+bounces-12883-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 27 Mar 2026 18:29:12 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id EB5F73485A7
	for <lists+io-uring@lfdr.de>; Fri, 27 Mar 2026 18:29:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 6E6EE305C33B
	for <lists+io-uring@lfdr.de>; Fri, 27 Mar 2026 17:27:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A64D3EE1F1;
	Fri, 27 Mar 2026 17:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Vl9g8a4v"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF2AC3E4C7B
	for <io-uring@vger.kernel.org>; Fri, 27 Mar 2026 17:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774632436; cv=none; b=oG6Bvf4Bb9byX79JKu2kRBc6hvpVkBG4qWC6FA8qYGczK1gZRRIu/XZwMW09HFBpcv/j+J1S08Imk/6ITAe8zRi+XofxheVH3UZ75N3pWTitJc13Faih+zyD23Glv3qLhoodRYuplhyiz6ridQinU1Wn62txZge6Tg1FaL8u/TY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774632436; c=relaxed/simple;
	bh=NT8doIcSjw9BDKNaF3EO2hjooe6B2/lV5YMi1sXmELA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m8Zp+uZxkISFGf5xUD1rQ+xzMGc8A/JZCTmxPVDmdMwjXZmW/Pjq9HZqaJck1qHcgh/pBP6m14FJJQiIjgy6s8N4ir72hayAFhw8DqTUKwwB6O7UeUHQvFiujWF2BOuy30tF2L8bqs1jSwQ6mHa83k8DBGjyWlbwckQW+g+IGk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Vl9g8a4v; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-c741db5d610so1198851a12.3
        for <io-uring@vger.kernel.org>; Fri, 27 Mar 2026 10:27:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774632434; x=1775237234; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JB4a24PQbQIC+mlLf3GLHthF6MP9J/n0KKAz7KS1R8A=;
        b=Vl9g8a4vyeqF7bgtUOHD9aScysTWMZp1lJLD4l5b1LlXAVoq9niMzCXwtzxMRLfZ/3
         q5qtDDmScsMVSssXlVgBRXjJk7IIhO/TYCeSnHu7JqU9qzM7FX5av0Vd3vZFGgUoMFGX
         iCunUVMHIdi+LJyMfZaKqCVNWsZuWLmWFZ0ZnavVzkUGj5NOJId5y2hV8H4FXI/b8XGY
         raH0a2XxYjunpduMGP7lgQ0vqoQ7jRmt8uwbjOwPetq3aqdTfRIkDADs1yo2vZ0sHKPI
         ExAEjmFOBjDUW5xVAWHoUy4SAHID2sY9w0LeJH/6txKSucRS9Pv68Yt/Gm4wHl0lMxho
         IbnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774632434; x=1775237234;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=JB4a24PQbQIC+mlLf3GLHthF6MP9J/n0KKAz7KS1R8A=;
        b=L801akloK+Vv/riS53WWkLtgEHJq7yJ5kjxhMYasvl3HvbQ63GsCTd9jcR2cb2Bdfs
         4yr2DOu8Vi1YrMub2vZSLkO3bsyi0+hwDOq1qXRarUjtzZpYmvE/aSe6+5gDsk6I864n
         EL+T+K+PBS1Sisy1vAGjS9vA0250XAQuqq22l0rYTbsg9D5P9BbJzD+KnacK0B1Ib+vk
         Z3vp5Mx9SDxjc5VWqrTAU54Lb/5nUTV9AuQ5yleuEnpu1HXXzO1vvJIriknSyVEvJdwC
         +pNZRi/+durEifVL30IhYs2NkOHCfPMi0n9/PpSDO3k5Xrk8gq3dmjS2ZiaCRY3Nhlsn
         jK3Q==
X-Forwarded-Encrypted: i=1; AJvYcCUs6nkRBkeBc4g6r1HP9AvfejgiFlKxzbVmDAFhS2zmZbHXqDcLZCjdRLaSgF68cvpV+OnsQxCp7A==@vger.kernel.org
X-Gm-Message-State: AOJu0YxedGZ9ihEUDPXwPInfF4826WPNVR2rHFWHAkksipVYNxmUVvC0
	u9/gG1HLsZzFob/XzJ4HvouGvYiffEbTM7YUIwBJbzJBYyObNiFehw3W
X-Gm-Gg: ATEYQzxb6onUIpMNEy4fV/PKWVpxmYWl9SfLsg9kAcWUw3YRQuL5dTjoAcHTu8dPYBW
	2a3szZXM9K3UU3yB/DEQWf8/blnkLXKtu2FCZDjDBff5Ds74wdue3AvKEp1/XmaaMT2sR5Vz7Tt
	Eu8Zlkjn5MFG5Y7ANL5+I81wSqmU+0NrJW9WTNLYyFxrx1920UGjOB3s/Yp8o61skWLjvn0pUrX
	94a1EyNBJHG9L3AN6tuiqcBSxeb6hcyVg59N30ANf6mnu0B8EVYpEeMgsGeT+yLwjEX2PRn1IW2
	0MoQAxX0WU7ry91lZNTp43OOnabA0jW8eelzcf1ZEmZiUEYiQYpz67tz0uyfMjwjcx9ot6vy/T2
	G3bdTJNoAX/bsd6CLLgGXTYV78+65B0nLDIz3Njhs2c+M160j8lCzuPKlWwMqp0etCfe4avzPYX
	GEZxZjPpb7U5FCcBbc1w==
X-Received: by 2002:a17:902:ec91:b0:2b0:52f7:faa1 with SMTP id d9443c01a7336-2b0cdd1d21bmr38272755ad.48.1774632434053;
        Fri, 27 Mar 2026 10:27:14 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:4a::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b0bc8c1c6fsm65724335ad.62.2026.03.27.10.27.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Mar 2026 10:27:13 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: axboe@kernel.dk
Cc: csander@purestorage.com,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org
Subject: [PATCH v4 5/5] io_uring/rsrc: add io_uring_registered_mem_region_get()
Date: Fri, 27 Mar 2026 10:26:31 -0700
Message-ID: <20260327172631.3380702-6-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260327172631.3380702-1-joannelkoong@gmail.com>
References: <20260327172631.3380702-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[purestorage.com,gmail.com,vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12883-lists,io-uring=lfdr.de];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	RCPT_COUNT_THREE(0.00)[4];
	PRECEDENCE_BULK(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	FROM_NEQ_ENVFROM(0.00)[joannelkoong@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	NEURAL_HAM(-0.00)[-1.000];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: EB5F73485A7
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Add io_uring_registered_mem_region_get() helper to allow io_uring
command handlers to retrieve the ring's registered memory region info
(the vmapped pointer to the region's pages and the size of the region).
The info is returned in a struct io_uring_mem_region_info. If no region
was registered, a zeroed struct is returned. This provides a way for
uring cmd implementations to directly access pre-registered memory for
passing data.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 include/linux/io_uring/cmd.h | 14 ++++++++++++++
 io_uring/rsrc.c              | 25 +++++++++++++++++++++++++
 2 files changed, 39 insertions(+)

diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
index b4d1d5e8e851..f1027f357ad1 100644
--- a/include/linux/io_uring/cmd.h
+++ b/include/linux/io_uring/cmd.h
@@ -20,6 +20,11 @@ struct io_uring_cmd {
 	u8		unused[8];
 };
 
+struct io_uring_mem_region_info {
+	void		*ptr;
+	unsigned	nr_pages;
+};
+
 #define io_uring_sqe128_cmd(sqe, type)	({					\
 	BUILD_BUG_ON(sizeof(type) > ((2 * sizeof(struct io_uring_sqe)) -	\
 				     offsetof(struct io_uring_sqe, cmd)));	\
@@ -51,6 +56,9 @@ int io_uring_cmd_import_fixed_vec(struct io_uring_cmd *ioucmd,
 				  size_t uvec_segs,
 				  int ddir, struct iov_iter *iter,
 				  unsigned issue_flags);
+struct io_uring_mem_region_info
+io_uring_registered_mem_region_get(struct io_uring_cmd *cmd,
+				   unsigned issue_flags);
 
 /*
  * Completes the request, i.e. posts an io_uring CQE and deallocates @ioucmd
@@ -132,6 +140,12 @@ static inline int io_uring_cmd_import_fixed_vec(struct io_uring_cmd *ioucmd,
 {
 	return -EOPNOTSUPP;
 }
+static inline struct io_uring_mem_region_info
+io_uring_registered_mem_region_get(struct io_uring_cmd *cmd,
+				   unsigned issue_flags)
+{
+	return (struct io_uring_mem_region_info) {};
+}
 static inline void __io_uring_cmd_done(struct io_uring_cmd *cmd, s32 ret,
 		u64 ret2, unsigned issue_flags, bool is_cqe32)
 {
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index cf5638406a0c..7b084823ef68 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1182,6 +1182,31 @@ int io_import_reg_buf(struct io_kiocb *req, struct iov_iter *iter,
 	return io_import_fixed(ddir, iter, node->buf, buf_addr, len);
 }
 
+struct io_uring_mem_region_info
+io_uring_registered_mem_region_get(struct io_uring_cmd *cmd,
+				   unsigned issue_flags)
+{
+	struct io_ring_ctx *ctx = cmd_to_io_kiocb(cmd)->ctx;
+	struct io_uring_mem_region_info info = {};
+
+	/*
+	 * The submit lock ensures we don't see partially initialized state if
+	 * another thread is currently registering the region. Once registered,
+	 * the region is stable for the ring's lifetime (no unregister API
+	 * exists), so it's safe to access the returned pointer outside the
+	 * lock.
+	 */
+	io_ring_submit_lock(ctx, issue_flags);
+
+	info.ptr = ctx->param_region.ptr;
+	info.nr_pages = ctx->param_region.nr_pages;
+
+	io_ring_submit_unlock(ctx, issue_flags);
+
+	return info;
+}
+EXPORT_SYMBOL_GPL(io_uring_registered_mem_region_get);
+
 /* Lock two rings at once. The rings must be different! */
 static void lock_two_rings(struct io_ring_ctx *ctx1, struct io_ring_ctx *ctx2)
 {
-- 
2.52.0


