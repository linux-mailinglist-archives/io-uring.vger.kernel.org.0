Return-Path: <io-uring+bounces-12859-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KJyxL0vhw2kgugQAu9opvQ
	(envelope-from <io-uring+bounces-12859-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 25 Mar 2026 14:21:15 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E6523259D8
	for <lists+io-uring@lfdr.de>; Wed, 25 Mar 2026 14:21:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 698D030A164B
	for <lists+io-uring@lfdr.de>; Wed, 25 Mar 2026 13:10:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1AC123DA5DD;
	Wed, 25 Mar 2026 13:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RcwWwE64"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9EE73D6467
	for <io-uring@vger.kernel.org>; Wed, 25 Mar 2026 13:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774444166; cv=none; b=ZkdRYM1JWgulokkkNeOHw5gc+ztgaXGyGIfDBHAM89ULaTthkVCs98C8j5xRWijGAFY6HTrf7BNvjUoQ35zLY4MDdkVfpX1B4miz6/Qr8HQ7Iejw+dyGi0cxlxu/VcvICLlKLGzJY5J2YOPfW22L4Wikr/nNk4iIHC6Pn1WArJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774444166; c=relaxed/simple;
	bh=9pVS1tph9jbVSLdoQwmJN+/bmkwxN4ab7cvUzQYqS3o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TVnmpgFrg8w9PlG3dXiHEA5RNTuNpypj/KQxWZjPVIhmJkLXKeMv3o/VGwsA+5R+DIAhL7FxvyuxkGoYBVIfdTKgP78/ydn5oa6UojDoGAyaphVNJXFccHaNozxwW/L2/TsK1vOTiSeEa+DR3SzKWy5rpnzHogPMgop2S+AbD+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RcwWwE64; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-439cd6b0aedso4295374f8f.1
        for <io-uring@vger.kernel.org>; Wed, 25 Mar 2026 06:09:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774444163; x=1775048963; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5uqkekRSIh11YxOvK1NGZWJnPZup9GIGf6LTY+NlKwY=;
        b=RcwWwE64KO2HxvYqlHJuwpu3p4IY4iG1MzYAU9w9l8k4mMb5qySFpHbkRXNNL47H8L
         6LKDLzdLVqZg7KrDnxK3hFVxrmuwBQ9FhM7ZsJz7cZh9/FGLNClnVwoP+D2yDsQh5XQS
         tGf7/vwS8n5blE0MsNKHxoFFjFPDQHWYo/BADFDrPA6VunEjEcZHUOpq7rz5ZZkL8FIz
         p56GVk8sO66GwODEU5CR92C/Sjr+m7LrlzGhmDYBqYq6CD1k6emimiKDzr7bru8BNhkc
         kqGooTJk+sUlYo1jxpBrJh8ezxXNyvCSOma4WW9FzG6ANGX6CqLGoVcPpKwas/p3gD0I
         8DsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774444163; x=1775048963;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5uqkekRSIh11YxOvK1NGZWJnPZup9GIGf6LTY+NlKwY=;
        b=EijYAzk3kmhTeMpr4R1ufkwQtEXrillNTG4UKdm+6qfI4FEMQA6S+hSm4MBLmY4NFt
         5JGKR+umOpYtgYchBkHmR7X/3QNNZUTEPG1Z2ZyE+JSJFQgurenuXG2+gOMmvq38ZflA
         b/ifEIiJ0quBzeGtPzTuzu4wwU8/flo4v4iZvYx+b/JZupLL3hmWxr2i6zD0mln0gLod
         +hsZqNJGA9orJsue1tmjeBeVuu3Ojj6/aTNHUdZc2eSPcu2QGYZF3+h5kFFWZN4skyfP
         TJDSYpLsKo1t+qi3RL9Oxz48VD2HJYemUjMIZ2pf5jvITusMAQP/4Yp7L00cIlFT9Dv9
         H6aA==
X-Gm-Message-State: AOJu0YzwcZQfQhdt8fI+uuiG6kRIZPbeLPjsojzdPjqTjHbU5K5/dvT6
	5BpLQi4/j90DVEe4CuVoMHva1eA6fBItb4TbGZFMRtuHRrunulacbUNWxw322Q==
X-Gm-Gg: ATEYQzxfVSdvn+v6Jx+5vryPFeP4nQRasWRLVSwfTIMucH4our0Uk73QafFn98Rp5Db
	5/jbLr25GGYwvDM41ZOVcUAJSBjIfYRbGYMiyufP9vKttZnLztpowvjodRuezW5uKMSeiInLZb6
	JBrWMd5eDHgwU/SWMo1eITFJjxgdghqt5vdPvRwCJGOWuvwmecX2zku3AOPdSeAOgJ2/OF5TPPx
	EyN1mv6dxkq86B3n21ul0AU1+Mu1rdBO5lX3LR7rSAP15HzSbnwObQ/Zx9Zl3vMGCQZ8bfT5XXf
	VlnOkmVN4A3UNjeXfqtu8DpboFO46u/fLjGEoCt5EybXIEN3OCd7TVwdbESZHezDSrT+JimQlAK
	i/IQlavSM1iUM7FYhxnXGmrqRIQHEjh+KbEmK7G9Cw3MAriOcf2cUeOcojC04LTSGdwnYdv59ZV
	rrw599GfSFhOWaQV3bpWSUk+qltldD8XYnFCjZYvvRR5LoBI+RU7FWh+93w68ec0e3QyBJIVPXe
	90uidUeyGkvloF08t3z
X-Received: by 2002:a05:6000:2007:b0:439:c550:d920 with SMTP id ffacd0b85a97d-43b88a250e5mr5533066f8f.47.1774444162694;
        Wed, 25 Mar 2026 06:09:22 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:8126])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43b644bd923sm54062611f8f.12.2026.03.25.06.09.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2026 06:09:22 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk,
	netdev@vger.kernel.org
Subject: [PATCH io_uring-7.1 v2 5/5] io_uring/zcrx: use correct mmap off constants
Date: Wed, 25 Mar 2026 13:09:22 +0000
Message-ID: <31f58c90bd1222b420f24a71f2b9eea4cccefe45.1774444007.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1774444007.git.asml.silence@gmail.com>
References: <cover.1774444007.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_FROM(0.00)[bounces-12859-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,kernel.dk,vger.kernel.org];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 7E6523259D8
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

zcrx was using IORING_OFF_PBUF_SHIFT during first iterations, but there
is now a separate constant it should use. Both are 16 so it doesn't
change anything, but improve it for the future.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index e1d2e1f1b766..df8dae724be4 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -386,7 +386,7 @@ static int io_allocate_rbuf_ring(struct io_ring_ctx *ctx,
 		return -EINVAL;
 
 	mmap_offset = IORING_MAP_OFF_ZCRX_REGION;
-	mmap_offset += id << IORING_OFF_PBUF_SHIFT;
+	mmap_offset += id << IORING_OFF_ZCRX_SHIFT;
 
 	ret = io_create_region(ctx, &ifq->rq_region, rd, mmap_offset);
 	if (ret < 0)
-- 
2.53.0


