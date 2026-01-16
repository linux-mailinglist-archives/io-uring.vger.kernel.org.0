Return-Path: <io-uring+bounces-11765-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A111CD3896B
	for <lists+io-uring@lfdr.de>; Fri, 16 Jan 2026 23:44:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7BAD030486BD
	for <lists+io-uring@lfdr.de>; Fri, 16 Jan 2026 22:44:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A2292F0C7A;
	Fri, 16 Jan 2026 22:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="fHe2XCXp"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com [209.85.167.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAB3A30EF7B
	for <io-uring@vger.kernel.org>; Fri, 16 Jan 2026 22:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768603444; cv=none; b=uyZZftJ4TkshzfYR6lM/XR37npznOHd97GdgeIJNNLMT+bO8QlkhiQ3/I4dGLZ9ZSuFs5gPyA5D82L8TsnqXRX87W4/jKePmfcn0KYyqP0lZQxgJ+1+4o018GwEYFLrNGFgtMHqMxMhDllBb8F844ZCFSzu7Xqx0Y999DpnCV0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768603444; c=relaxed/simple;
	bh=KU28ETSjbr6uaw81Vt0DsT84c/hjzVJq9+Rd9rdm+PM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k9xOLOT/R/+O8Zffz9F9I82cD3LGcc5a8AkG35A5tnNTAsGcZuM1phLLmuMOoB+bjXZ0IBYK2MWI0yTfVhT+mREkg7vyayq2btORVmX/SRXl/nKKCrFIkul+0ga42KWQ1JcqAQve8PGGWhPuEEi+Ug3/WsMLHAVxFtYDCSv4U4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=fHe2XCXp; arc=none smtp.client-ip=209.85.167.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f181.google.com with SMTP id 5614622812f47-45c87d82bd2so1776432b6e.1
        for <io-uring@vger.kernel.org>; Fri, 16 Jan 2026 14:44:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1768603441; x=1769208241; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TEV7PKZVRgq3XwtH61jV5BU+kKWf7dOxJYoHVkYhNy8=;
        b=fHe2XCXpCwq7sYoByzx1paNZ6vxf54sdKsytxvtQl0T8rirjO4dZFT7qa9/SajOeV3
         bwtJ/+VXFhlhth3jbIRJBrmUnZoDH0w5Or4SrmAE3lsi1g+01XuXleC0C4pV1un7N+/P
         Y+ll7p5mz+Nt3NVZA2lrRDIIO/ZN0AjSgFLBz7+79j+mLt4iv9nRvbi9Z0CcWua3itaW
         1l50Vly82YXH6Ftv6uWFAGE7tCppbOkPsMvdnhtmgSZuXMyBMK4QO3hVXghAktfilp+a
         ffyTLm2aFzuhHoVRtZ90kDkzKDgu+EEKtNvBf7V1Hd5moET8VgdsoTXWvGh8OZXKpzme
         0PGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768603441; x=1769208241;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=TEV7PKZVRgq3XwtH61jV5BU+kKWf7dOxJYoHVkYhNy8=;
        b=wPGPsYqjd3G1ZFuUpMcPZGTC3ENU9ixO88/uehsuQWOG8idg8xcPMX5yFtFx0JY1bQ
         18jnZzoCC/W2jz5yHMGYw2CIT/luHbbTE4OOir0cu1SrVd8iwQAv9uwwl1fx27dNFneW
         +jBNLn/y33IXLCVaRYEwMVi7S1Ow1aYUVSxlAbQ0FklvCRbCxlxDmOOjO9CAuPgNaOkB
         yAPUv2pPt3NFO3GQmExZthim7TD2NNEroJ+PdHtIjPrlZvJM8U+N4W2Eidq1NPfsz9zZ
         XCb8btuSMMFcjtI2o+XLdVjofqmzxSgU7Agka49RlsxN6zgXiPIVRnwQYhomI+kKKsh7
         zA9g==
X-Gm-Message-State: AOJu0YxMXHjSOJ+51WRKe5JzxId6uOzx0DjHkfnjTuAM0hduUzi7DL6D
	HqADTgkXmt+GDT6DU9onVXNy6Agdz7bNUXAsABQy+nB8IVxzgOvbi62dkzYwMVKKyMXKV7WGn8t
	LSmHL
X-Gm-Gg: AY/fxX5GsE/N+EOGOEolh16nk+7QdaGqsVe2ef6tN46vXZrubNPdq7wQ0q1wmz8FSon
	mngcW6Lq4cnmdXPIQTSGtpSqJH9y56q3HJt6UE87/OIxoEqiXi0muJcWcIfauHcdsdr5BosRK6j
	FkqvMx8N8KHHxVC5txgWaxu3aUruyu3A/YlFLAfTtSklq3yunecoQ7EK+6Hl7AtHzGgJ3JwZizP
	v1zfVIAvuHEymyBuhs9bhUC3SP9tVX2rSWoDn4bRO46qyWL9s26uKga2PeWt/ZQMGZa7OxEqldn
	a9Tz4oX1O7x5uLyEDeLUslmODzyL2isumUsKTp/P5Dws72WJ0hBH7vIxb7hOeSOONCUShZO8G+z
	mk7uTACbR546XsWAJw+B4ixouD1f4FuUV6GSevMSeKuIme0Cxb1mlHAXeV20eVjcqKvPbMthiJk
	9PhOVFsqpfpKPL6f4HSXmWeNFKIKamiKaG6uPr9QmcJAxum9E+ur7UF3vP
X-Received: by 2002:a05:6808:6eca:b0:450:5ca:5170 with SMTP id 5614622812f47-45c9c0f5922mr1875864b6e.33.1768603441443;
        Fri, 16 Jan 2026 14:44:01 -0800 (PST)
Received: from m2max ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-45c9dec9ebcsm1945098b6e.2.2026.01.16.14.44.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jan 2026 14:44:00 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/5] io_uring/bpf_filter: add ref counts to struct io_bpf_filter
Date: Fri, 16 Jan 2026 15:38:40 -0700
Message-ID: <20260116224356.399361-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260116224356.399361-1-axboe@kernel.dk>
References: <20260116224356.399361-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In preparation for allowing inheritance of BPF filters and filter
tables, add a reference count to the filter. This allows multiple tables
to safely include the same filter.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/bpf_filter.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/io_uring/bpf_filter.c b/io_uring/bpf_filter.c
index 74969e9bc3b4..8ed5b913005a 100644
--- a/io_uring/bpf_filter.c
+++ b/io_uring/bpf_filter.c
@@ -14,6 +14,7 @@
 #include "net.h"
 
 struct io_bpf_filter {
+	refcount_t		refs;
 	struct bpf_prog		*prog;
 	struct io_bpf_filter	*next;
 };
@@ -165,6 +166,11 @@ static void io_free_bpf_filters(struct rcu_head *head)
 			 */
 			if (f == &dummy_filter)
 				break;
+
+			/* Someone still holds a ref, stop iterating. */
+			if (!refcount_dec_and_test(&f->refs))
+				break;
+
 			if (f->prog)
 				bpf_prog_put(f->prog);
 			kfree(f);
@@ -254,6 +260,7 @@ int io_register_bpf_filter(struct io_restriction *res,
 		ret = -ENOMEM;
 		goto err;
 	}
+	refcount_set(&filter->refs, 1);
 	filter->prog = prog;
 	res->bpf_filters = filters;
 
-- 
2.51.0


