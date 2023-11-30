Return-Path: <io-uring+bounces-177-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A5347FFBC0
	for <lists+io-uring@lfdr.de>; Thu, 30 Nov 2023 20:46:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CB16828282A
	for <lists+io-uring@lfdr.de>; Thu, 30 Nov 2023 19:46:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BB0F52F93;
	Thu, 30 Nov 2023 19:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="KN3L5ncl"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EDCDD5C
	for <io-uring@vger.kernel.org>; Thu, 30 Nov 2023 11:46:49 -0800 (PST)
Received: by mail-io1-xd35.google.com with SMTP id ca18e2360f4ac-7b393fd9419so6310539f.0
        for <io-uring@vger.kernel.org>; Thu, 30 Nov 2023 11:46:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1701373608; x=1701978408; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/3P7Om/JPlWfZ4/jS1Ma8gFMYggIm+5/nIXeclWkiYw=;
        b=KN3L5nclLvp6Afv5zNa3Ou2h7F3msVEGKghm+vwSp04bChflyf3QYthQo1b8nsCPNq
         FiroSX1qYdVW2W+6FdJihjOO83J/OmylsqhWwmNrO7iUcjlR8A8CztpmrZ5pA2SeJkex
         m5GpVZhW0ZC+WhsgHswOoQcV7ugfw3Qz7K+zioyp5QEUzmPO+BvKOO5EqELkpKh7NdU8
         TgfN4gizlQVTOejANMDhY1xz4OqkPheU7iv9EAm7VG+ZbcXV1Vjtlb2LRiSPEWkDtSr9
         +0//47vsBG6k2OHn5mJq7O2eOXG4xknSn9wyTXFSf30lS2x6hLPObArBryjDcL5BTSrN
         XVeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701373608; x=1701978408;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/3P7Om/JPlWfZ4/jS1Ma8gFMYggIm+5/nIXeclWkiYw=;
        b=WBylJ9FeKFNLPb+toORFdldz9XLkeISA2a1Xh4EX1nNSMtZHfy7QIRBJ6tXmwIROvv
         mliZbBaEs3y0pSdudcE3Qy9c5XeP94fjv7l3tnEH60ACYq6tpbbqGMFFNqxDl8qiq07Y
         eUIxF97zZg8m1Ek8CCVTXu1+MIufExf5HxVIK1HG0eZxmQLCzegi+IJlUV2ss5bOQ8xn
         r782NI6JSzmDV2rcD8cAbU6y3KJ5svmE5xiN6nOhjEM8grR96wM0pPQHo7hae/L8eC8U
         zeU+TEyduzUo6MeAp+QmkhbhdFQMkUjASSn7JeumYMCYZvRgADb+nRrVuTNk04CgMuQN
         /KjQ==
X-Gm-Message-State: AOJu0Yz61WhcMo6g59VlWNGBE8XAygBr2f7CkgY7dcbr4cOaSiL8WHru
	bGtZJKiDwIvrRrcnJlW/hK1eBo7FuG4LJyQN6raTiQ==
X-Google-Smtp-Source: AGHT+IHWzQOvQpyQ7TCT6v52vO5dssdzUUTAwx2UcoTTJJy3RZFtI/HEyPApbSls/VdTZRmFGoohOA==
X-Received: by 2002:a05:6602:2245:b0:7b3:5be5:fa55 with SMTP id o5-20020a056602224500b007b35be5fa55mr22989581ioo.2.1701373608102;
        Thu, 30 Nov 2023 11:46:48 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id a18-20020a029f92000000b004667167d8cdsm461179jam.116.2023.11.30.11.46.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Nov 2023 11:46:46 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6/8] io_uring/kbuf: prune deferred locked cache when tearing down
Date: Thu, 30 Nov 2023 12:45:52 -0700
Message-ID: <20231130194633.649319-7-axboe@kernel.dk>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231130194633.649319-1-axboe@kernel.dk>
References: <20231130194633.649319-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We used to just use our page list for final teardown, which would ensure
that we got all the buffers, even the ones that were not on the normal
cached list. But while moving to slab for the io_buffers, we know only
prune this list, not the deferred locked list that we have. This can
cause a leak of memory, if the workload ends up using the intermediate
locked list.

Fix this by always pruning both lists when tearing down.

Fixes: b3a4dbc89d40 ("io_uring/kbuf: Use slab for struct io_buffer objects")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/kbuf.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 325ca7f8b0a0..39d15a27eb92 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -306,6 +306,14 @@ void io_destroy_buffers(struct io_ring_ctx *ctx)
 		kfree(bl);
 	}
 
+	/*
+	 * Move deferred locked entries to cache before pruning
+	 */
+	spin_lock(&ctx->completion_lock);
+	if (!list_empty(&ctx->io_buffers_comp))
+		list_splice_init(&ctx->io_buffers_comp, &ctx->io_buffers_cache);
+	spin_unlock(&ctx->completion_lock);
+
 	list_for_each_safe(item, tmp, &ctx->io_buffers_cache) {
 		buf = list_entry(item, struct io_buffer, list);
 		kmem_cache_free(io_buf_cachep, buf);
-- 
2.42.0


