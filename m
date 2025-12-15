Return-Path: <io-uring+bounces-11046-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DB673CBFB3C
	for <lists+io-uring@lfdr.de>; Mon, 15 Dec 2025 21:14:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A9E0730038E4
	for <lists+io-uring@lfdr.de>; Mon, 15 Dec 2025 20:10:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 282D630BF5C;
	Mon, 15 Dec 2025 20:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="T0HdSJ0H"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f225.google.com (mail-pg1-f225.google.com [209.85.215.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E68D2E92B3
	for <io-uring@vger.kernel.org>; Mon, 15 Dec 2025 20:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765829430; cv=none; b=cU0MfaeQts+xOoh4hMBx/VoMJ6j6FfwFvRaU1Cw2V1Gj2d/dYhP0MBFZwW0sepOuxjCSsJh4BDl76q13QFm5xf02Ab52rrdYWzqNBnkW6nIsvixnddjy8qKszVQrSrTaN6XoATS/V2qR+qdnaVOxYrvZQtLzUXZ24huxhqJwKCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765829430; c=relaxed/simple;
	bh=o5lGEBDV5UAe201SZiJ5LVTaZ61EzzdPrWLpVnIezHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L8/t/i9r3Ief0hoGcy1yXVNIQJJpovmw+DrnF4571arquuKioKOLGwQS9lBG4ZsinhhUENxYDpQL+of5uTUH4Ew6mkCT4zXseN0d6fr7I/qh5/B/foRv8anQKgpy7HgwP6vrIcTXtGTu6/BgwZNqOCRGzyQyK8vYlygzli44c0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=T0HdSJ0H; arc=none smtp.client-ip=209.85.215.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pg1-f225.google.com with SMTP id 41be03b00d2f7-bd2decde440so177098a12.0
        for <io-uring@vger.kernel.org>; Mon, 15 Dec 2025 12:10:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1765829428; x=1766434228; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0e/XFewNZHIQT+u9pv570Jztv9BwIrFZDFKmU9UVav0=;
        b=T0HdSJ0HoELXf1gIFv/QkxtaPA3vejxY+X+pLLDKoBnwDAOkGYhM4g2Zgn6+kbqI23
         kdNf/DF5vQpLM7BEtN7T6SNBphnmzwwKevwYOVns3QDoS/KUQWckeTO+C8oaVCp7Tiub
         c4UjgPX1ajLVB7c6FTS/nJvBb9NiBwR72zMMoUzanOfzOrBebLVB0q2CfF4F3sOj7Awl
         0NUK87g5COpmBboKnSd838vfWJwuOTjjdGgz/75IAhI/fBPVmTvtAVfXVcAoVvEIP6qE
         n8dVdOS8OoPnQBs9x+cT7LPvu0na0LbC+pahqvkz/mW7K95FM+7/ufndLyc85Fh4TOMi
         G6hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765829428; x=1766434228;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0e/XFewNZHIQT+u9pv570Jztv9BwIrFZDFKmU9UVav0=;
        b=uRuo4hIOQSSbJ5VlyMQyhZJG+DrePF9yn0lILovaILUnvzyDjU5uEGd8Ctgw/cE0Wm
         FHRa4uAB1qah+PT5Mi49qRKyiyCPEj9xW76MmkbuTLCTdzwbPXcVdiTn2Av/GTesu5C8
         PCvOIZdNypKf7Vez9tYuSGYGk9dYJfRrmkWSwBWgQbYi7N5LNgEx0+hu1o14ADdWtk2l
         xhjOyEGICp/aQFLqvWyAgELCm5iIy7RbnotmAJOCTztd/Wwaz+prorS8bsX/hBw1zs0m
         ccWx0078JSwOXEnmVMLgnr2L3avxJq1rO91neOiZZeSJUEdnPb/cbcjQO0Xpm5/8ra4e
         +K/A==
X-Forwarded-Encrypted: i=1; AJvYcCWUM/iHevtz6qMoh1uUvi8BjNTVTumxSIPk7S/VK1WNYUiRkfq8CdmyKdBMD4N2aVHbxcl7JRVOfQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwIoPEEjNC4A9AY2gZKMxrabuznSZIM0fghIFHN97P0o0WjLb9T
	XQm3xlkpor8b1blu4dZqHi+/ileL5TcbEBZF+Mrrw4c3jg8W/A9wp9uJLsSUqVXf4aRW3dKAAgH
	qO5GTBvk3hi03vZXQn9kC1qE62yU/LkXv94HoGECdf2uWbehzpSga
X-Gm-Gg: AY/fxX4bT5rQIV2WX0zyB/qLl9oFFcV2d4SLQIQg+Fi/Mu/ZcsJ0LpVpPwftw4edlyS
	KzQdvISA76ST3txChvSpLaLIGXCwlluTUFCRNz8zcmypCLVDZMFB9tWvh1qOvELJxP/XEY2qo97
	kt9S+p+XWzz3W2g8a2BhztAESroCgLYL94GzKDGaZLKv+pbCfL0eDhn4J8NWiUDCtFiAcP/R4wl
	SQWw1azwBhXGJh+CqOf0D0fBrKMPa6SU/78KfWSD64pf/Tro3XoB4XqW1tboniQtsMAHPqAiAml
	y6pbk95z3Z/6vNrOfEH8Ij6a6sO6Fi7SYQuXxTii7SM+g1K8m9GaoDGnGcEwy49cAdKOdbRMMJT
	LTLJSnpe04BGngV55Bekb1Y7srEQ=
X-Google-Smtp-Source: AGHT+IFXM8p3TwJdJCvpPaO3rA9ZkB9JG6xOKudOAnxLn3WwIdq94virxVk4I+/m85vem/IuaYkd6Xnpobb3
X-Received: by 2002:a05:6a00:2e15:b0:7b2:b20:e8d9 with SMTP id d2e1a72fcca58-7f6693a5b3cmr7963554b3a.6.1765829427516;
        Mon, 15 Dec 2025 12:10:27 -0800 (PST)
Received: from c7-smtp-2023.dev.purestorage.com ([2620:125:9017:12:36:3:5:0])
        by smtp-relay.gmail.com with ESMTPS id d2e1a72fcca58-7f4c3ff229csm1929188b3a.6.2025.12.15.12.10.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Dec 2025 12:10:27 -0800 (PST)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (unknown [IPv6:2620:125:9007:640:ffff::1199])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id EB30F340BC4;
	Mon, 15 Dec 2025 13:10:26 -0700 (MST)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id E89D7E41D23; Mon, 15 Dec 2025 13:10:26 -0700 (MST)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Joanne Koong <joannelkoong@gmail.com>,
	Caleb Sander Mateos <csander@purestorage.com>,
	kernel test robot <oliver.sang@intel.com>
Subject: [PATCH v5 3/6] io_uring: ensure io_uring_create() initializes submitter_task
Date: Mon, 15 Dec 2025 13:09:06 -0700
Message-ID: <20251215200909.3505001-4-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20251215200909.3505001-1-csander@purestorage.com>
References: <20251215200909.3505001-1-csander@purestorage.com>
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
!IORING_SETUP_R_DISABLED ctx. So assign ctx->submitter_task prior to any
call to io_ring_ctx_wait_and_kill() in io_uring_create().

Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202512101405.a7a2bdb2-lkp@intel.com
Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
---
 io_uring/io_uring.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 44ff5756b328..6d6fe5bdebda 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3647,10 +3647,19 @@ static __cold int io_uring_create(struct io_ctx_config *config)
 	 * memory (locked/pinned vm). It's not used for anything else.
 	 */
 	mmgrab(current->mm);
 	ctx->mm_account = current->mm;
 
+	if (ctx->flags & IORING_SETUP_SINGLE_ISSUER
+	    && !(ctx->flags & IORING_SETUP_R_DISABLED)) {
+		/*
+		 * Unlike io_register_enable_rings(), don't need WRITE_ONCE()
+		 * since ctx isn't yet accessible from other tasks
+		 */
+		ctx->submitter_task = get_task_struct(current);
+	}
+
 	ret = io_allocate_scq_urings(ctx, config);
 	if (ret)
 		goto err;
 
 	ret = io_sq_offload_create(ctx, p);
@@ -3662,19 +3671,10 @@ static __cold int io_uring_create(struct io_ctx_config *config)
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


