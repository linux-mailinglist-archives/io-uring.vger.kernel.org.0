Return-Path: <io-uring+bounces-11170-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 10396CCA197
	for <lists+io-uring@lfdr.de>; Thu, 18 Dec 2025 03:45:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 8C1AD300D02F
	for <lists+io-uring@lfdr.de>; Thu, 18 Dec 2025 02:45:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B02CD2FE584;
	Thu, 18 Dec 2025 02:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="Z9mNFGsM"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yx1-f97.google.com (mail-yx1-f97.google.com [74.125.224.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EB982FBE03
	for <io-uring@vger.kernel.org>; Thu, 18 Dec 2025 02:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766025907; cv=none; b=htHp2E4n9A2yR7vfK0nAh1UGa8XOOiaa8X1F7dMOcgh4bf/ziOcCZOTKFv9f05N461AD3t0uJy8hRVCo1dxJVyHi557D4CcPEqzwMeBNGn1e4/HLlpXPCHRMt7AwnkiDId4PMj+rcKcYuYesk97Ea/1x0txabS4QVdFI/qm2OsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766025907; c=relaxed/simple;
	bh=aw8TkwSuEq6GliZr+5FPJ1JFCl20mpvk1u8mxOiswh0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Oq7HQmZYryPXLCRcmIq1Io6txuzsZx7pyLabCagTXWsgSfGLToq5ikQoyDYdnW6Lq4CoIbDIxKz7cmxxjuIheiHsRxoZJYLem0J9zI73GgSNC6qrXWv0nRME6ZT6MxHZ2hV0UmRpAiNFTal7UE6UiRYrMY8I+eZ2LZj/a/KlK+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=Z9mNFGsM; arc=none smtp.client-ip=74.125.224.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-yx1-f97.google.com with SMTP id 956f58d0204a3-6447b403647so22191d50.0
        for <io-uring@vger.kernel.org>; Wed, 17 Dec 2025 18:45:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1766025903; x=1766630703; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/4WqxX2C2PdcjwiPFH0GMXdb0hJI2RS81lgoZ0hAJzA=;
        b=Z9mNFGsMLSNmvKI63o1krPh9k6/Nn+vvWhCeKs3jxtBlntwiXSrqF2WSdLOU4UISqM
         r6kHYP9lF1H13jfVNqQUdwfGeaw3cqhLQKGkmaiOuVIZUMpLzFstaCJJmqhWyFDa32iO
         3PukwCxZjcWcxfY4SctUgUxks+fE6Luo8CDfemD7SB0U8I6pgyKQnmLchHGUfvi+30zu
         NwC6+Zi+S63KQPe09u1W2qOht1bjPlQZXen1CNMgzuwo+JPWTRdR+fyJFv7rQf0v6opR
         9RZ5qTzNuU/GCmp4EXBsroXLHv+VXXuXsXiUpuVbYjFCZibUkVd5EqFnavgddptu7ZsP
         DULw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766025903; x=1766630703;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/4WqxX2C2PdcjwiPFH0GMXdb0hJI2RS81lgoZ0hAJzA=;
        b=HMXdqVrXZWVkP3xzQaQRweMhevdxn1+x78Vnd64evBH7wLqmhld3j1xGZmVKEHILQv
         znvN3xx86H70QcYpETd77FHoQLbSIt3EkOpu2EP8HrB1swNr+moaVv11VEnOhQDW+aDu
         Zqu8lWMCiBoq3Z3YlVaglrzNBYke2pRAgnWjbnh3Tl3cRwSf4EkE6L6M+WFaKuT27Ese
         3LhK4O/+fVXTIOCgKiz38/4RWdQL0GQqRC3DBfS+lFRUzPRseXEOuALEMsLDgyCb2rRS
         Wg+mL6vUAh8z9EolTbBKj/oRvMJnw8E2+8qiS+eCQBoHQ79JGcUyVBKTRq9CnhRMm9Zk
         fwHg==
X-Forwarded-Encrypted: i=1; AJvYcCXO0swu5Ew1WbvIhX/mfIqfZLCCuTFkDdNwCPiYQbMEn4A+V/aZ5duVB3ahoZm39tr4AyXughF/kw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwxRpISvCGBmaAD4q69jhXW6ClzlTqABUbN9SQs0MGTvxaE8SKF
	0eO4cvy0CSLlwFXBmYhpqfzzLJ2LU98nZAUzvH/gh4UsTUBMphHzOkFxaTFKPsaRi+RxQu1FFMj
	4gv6M2VzD4nvfHFqoNX1KwqyJh5DbE5cX/Xl/UXKn+ZBeB8wY3vyW
X-Gm-Gg: AY/fxX7yR9V9PEzhpK5p7ZV/IQnLl/M+T22eifSAbkzeYMBW15+og5WPTySqEp3KwsD
	M/s++oa58+N1uXx41o8f/bf/NGP0e/aM6eCQwKPO2hbQ+xO/vzKZp9YKTColqkvfCyq8viipYlv
	PdLKhMtSlnCu+y6ysZmGL08wJ0C/+rrGeI3U+VChDJcMD6HCIdU67PVAkO3+0w5/2eNU++6jyVq
	0ToUnxN1Fq7JKFI3MxAHOFQrMMIvsmNkUifk1NCqfGhuFY6EUA8Gb9S3BcfhzYVijb4AMUPvfaQ
	Vg8KGeNxpdOruWJfveqpuJ16eGoaoB42AFawVru69MjMrXQjQUtgmDgy+N5BNcScE0JgHxGWGoP
	0uZsM/k9PmUIDjpLV6Uk3iiyvpR8=
X-Google-Smtp-Source: AGHT+IGdRRKMbFB2NJTvFJ8umTezv14TsE8PBfTe6dIFNYVA2ku9Kdlm3dMUfX27EK0D2SBxPvxlKSqiSxcp
X-Received: by 2002:a05:690e:4008:b0:63f:abbe:398e with SMTP id 956f58d0204a3-646644a3a1cmr504362d50.5.1766025903600;
        Wed, 17 Dec 2025 18:45:03 -0800 (PST)
Received: from c7-smtp-2023.dev.purestorage.com ([2620:125:9017:12:36:3:5:0])
        by smtp-relay.gmail.com with ESMTPS id 00721157ae682-78fa6ef4dcesm900367b3.12.2025.12.17.18.45.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Dec 2025 18:45:03 -0800 (PST)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (unknown [IPv6:2620:125:9007:640:ffff::1199])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id 9C354340752;
	Wed, 17 Dec 2025 19:45:02 -0700 (MST)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id 97B54E41A49; Wed, 17 Dec 2025 19:45:02 -0700 (MST)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Joanne Koong <joannelkoong@gmail.com>,
	Caleb Sander Mateos <csander@purestorage.com>,
	kernel test robot <oliver.sang@intel.com>,
	syzbot@syzkaller.appspotmail.com
Subject: [PATCH v6 3/6] io_uring: ensure submitter_task is valid for io_ring_ctx's lifetime
Date: Wed, 17 Dec 2025 19:44:56 -0700
Message-ID: <20251218024459.1083572-4-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20251218024459.1083572-1-csander@purestorage.com>
References: <20251218024459.1083572-1-csander@purestorage.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If io_uring_create() fails after allocating the struct io_ring_ctx, it
may call io_ring_ctx_wait_and_kill() before submitter_task has been
assigned. This is currently harmless, as the submit and register paths
that check submitter_task aren't reachable until the io_ring_ctx has
been successfully created. However, a subsequent commit will expect
submitter_task to be set for every IORING_SETUP_SINGLE_ISSUER &&
!IORING_SETUP_R_DISABLED ctx. So assign ctx->submitter_task immediately
after allocating the ctx in io_uring_create().
Similarly, the reference on submitter_task is currently released early
in io_ring_ctx_free(). But it will soon be needed to acquire the uring
lock during the later call to io_req_caches_free(). So release the
submitter_task reference as the last thing before freeing the ctx.

Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202512101405.a7a2bdb2-lkp@intel.com
Tested-by: syzbot@syzkaller.appspotmail.com
Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
---
 io_uring/io_uring.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 44ff5756b328..22086ac84278 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2852,12 +2852,10 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	io_destroy_buffers(ctx);
 	io_free_region(ctx->user, &ctx->param_region);
 	mutex_unlock(&ctx->uring_lock);
 	if (ctx->sq_creds)
 		put_cred(ctx->sq_creds);
-	if (ctx->submitter_task)
-		put_task_struct(ctx->submitter_task);
 
 	WARN_ON_ONCE(!list_empty(&ctx->ltimeout_list));
 
 	if (ctx->mm_account) {
 		mmdrop(ctx->mm_account);
@@ -2877,10 +2875,13 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	if (ctx->hash_map)
 		io_wq_put_hash(ctx->hash_map);
 	io_napi_free(ctx);
 	kvfree(ctx->cancel_table.hbs);
 	xa_destroy(&ctx->io_bl_xa);
+	/* Release submitter_task last, as any io_ring_ctx_lock() may use it */
+	if (ctx->submitter_task)
+		put_task_struct(ctx->submitter_task);
 	kfree(ctx);
 }
 
 static __cold void io_activate_pollwq_cb(struct callback_head *cb)
 {
@@ -3594,10 +3595,20 @@ static __cold int io_uring_create(struct io_ctx_config *config)
 
 	ctx = io_ring_ctx_alloc(p);
 	if (!ctx)
 		return -ENOMEM;
 
+	/* Assign submitter_task first, as any io_ring_ctx_lock() may use it */
+	if (ctx->flags & IORING_SETUP_SINGLE_ISSUER
+	    && !(ctx->flags & IORING_SETUP_R_DISABLED)) {
+		/*
+		 * Unlike io_register_enable_rings(), don't need WRITE_ONCE()
+		 * since ctx isn't yet accessible from other tasks
+		 */
+		ctx->submitter_task = get_task_struct(current);
+	}
+
 	ctx->clockid = CLOCK_MONOTONIC;
 	ctx->clock_offset = 0;
 
 	if (!(ctx->flags & IORING_SETUP_NO_SQARRAY))
 		static_branch_inc(&io_key_has_sqarray);
@@ -3662,19 +3673,10 @@ static __cold int io_uring_create(struct io_ctx_config *config)
 	if (copy_to_user(config->uptr, p, sizeof(*p))) {
 		ret = -EFAULT;
 		goto err;
 	}
 
-	if (ctx->flags & IORING_SETUP_SINGLE_ISSUER
-	    && !(ctx->flags & IORING_SETUP_R_DISABLED)) {
-		/*
-		 * Unlike io_register_enable_rings(), don't need WRITE_ONCE()
-		 * since ctx isn't yet accessible from other tasks
-		 */
-		ctx->submitter_task = get_task_struct(current);
-	}
-
 	file = io_uring_get_file(ctx);
 	if (IS_ERR(file)) {
 		ret = PTR_ERR(file);
 		goto err;
 	}
-- 
2.45.2


