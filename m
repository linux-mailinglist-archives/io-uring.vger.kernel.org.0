Return-Path: <io-uring+bounces-10223-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 95F07C0AF0B
	for <lists+io-uring@lfdr.de>; Sun, 26 Oct 2025 18:34:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 71B334E7F88
	for <lists+io-uring@lfdr.de>; Sun, 26 Oct 2025 17:34:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D727B26CE3A;
	Sun, 26 Oct 2025 17:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="kUGD415u"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f52.google.com (mail-oa1-f52.google.com [209.85.160.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FBCD24728E
	for <io-uring@vger.kernel.org>; Sun, 26 Oct 2025 17:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761500081; cv=none; b=Vifv6dmNhFZlDHJ8trqKG1Jair9S3ycP/SF+xNCI9tVgh4KfCnj306bf7kRGJ2U4y/1EURgR8+B2621Ev6UjQNMGNqjOWpAkCsxvkbxJBeuWF0X5R8Rqc0wLZRrJGx8nhoa5jc4I1YFUSw8DhdHhNpR7P2QnnTZJrZwghPkrnsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761500081; c=relaxed/simple;
	bh=ptG5+SHINYPHzYMQWRE05qadCLy7t9hxHMr2AoPLVBU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fx5dpaTpgOw3NXkMKEbthuFFQQiKt09pFg8ujXg8/Z8Bi3saAnbl+IrCm7kPz+OvkUIxJFcH5kAGXd50xnxVRHRwgiUuSftIaRYBe3+wrS4sURfn3wknSqR+sbqxpZMJyf7AxbRonTfl0WWQNnHVpi+ozrGxva4tgRGrIMKtbO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=kUGD415u; arc=none smtp.client-ip=209.85.160.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-oa1-f52.google.com with SMTP id 586e51a60fabf-3d2059871d0so792959fac.3
        for <io-uring@vger.kernel.org>; Sun, 26 Oct 2025 10:34:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1761500079; x=1762104879; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9wrMkWzoqje6s8rXMO2Ji8dE/ng2JvcyGTWZGSmHOPs=;
        b=kUGD415uAdTRYrWftb0tsp+blv54YLNyPgxpyPnnRarv3J3oEnGVDcdX7ryhxvhQbI
         lPacRXQSH4EpmNI7pgb1KIZL1q24GMD3wM7bCMSHEVIcpfzwO20s37grBPQJ1YkKLCC5
         esDl7ncc4VcjOWvPAWHrm9NFhC7uLPKkR2zAlzKUqQdzzcnMp+70x/kJsFowpsXc0p/X
         XW1vklUSKTT5emKTEUI4duuQNxGFVbnQ0uN0YLsqQR0S2KOS5wua0Y+OCtnnzUgwdrKY
         NlhGBhFgLAKapYbuxS4RonIQ5FTfR7hcHOYith7VEgNuA7D/Ru7zvkG3JcLze4uzDgww
         +pPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761500079; x=1762104879;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9wrMkWzoqje6s8rXMO2Ji8dE/ng2JvcyGTWZGSmHOPs=;
        b=vqyJQWln6V98sm5LPnppu+ZR4MCmnKGNYgsuYLvszK1Y16WDO6HEVqB1dxrdE0LfVb
         8YaP31TGNxQ6lFu29YgPfpsbJC5cD0PL3AtOLnjzeI6W49Cmjm1b9hMrG3MQtMwlXViF
         0UiGlQetLA3la+8k2QR+ydjjmhQeRMr7Do15jGnsCStdpZ57q2DtcWRXzfje3RC1OPwu
         QAmS5C+fdw9obY1wz7+DYc6zGwBJ7U/Wokcljddkv+aVFKq4mSf7jH/nM5aZvqmoDEkU
         XwBvIwB58Sbji+RU1w/LmkhYNJ7y7ZSKgbP7Jh2r8y42DI6epbtv6AUbdK6lAqQAmQ3e
         CfbQ==
X-Gm-Message-State: AOJu0YzYvElhyGZIMV39e8VHHN91D9YyDQVHJdkVnkXRTU/Mkf89Vyul
	T36jOgABEe/eafqBvbIbjHGB+9EGjzXdlq5i9IV9zBLwx35qrfgEWCR9iOyTSqeEzui6JYbSvVJ
	UtTOs
X-Gm-Gg: ASbGncvYfeneIs8rHb+6rvIXdAUcEAxglKVwT735mCFiDPFpjyar1xlVcfiIFbiGcNn
	xLAJahizqHIcvTpSyD4msppD0unHdVXBsJA9XkTnlIPt1DHP1/iDk5klQ+PeMzrPfoJhuL/jbmt
	6QCM0TjgNG/aHvRyCkkEta8Njiyc75aXl/Ze6x8KwlYxIp4EJyVHB/8h38Q3ntLhMobdc5wuoej
	/BfErOfhMV3iSUhHI6pmbxln+FI95UKSo3m7fh4fLDnx/8M2Rd6opucILvRvC0U9M3idl0oQszE
	q+i4lBxT3Tl5v8WY3aSnu09J4j+xDIxf3fpfX316INAGkLZoZdQJB1kDD4IToWy7ND+sOcBhHH5
	kS4JkyEnD5zhjVtrz8D4goKS7FH7UmXh1heJmcZcwvozO5AQ/Wfp+uDQYOAaAN4WNlQlbqvjJrE
	tvP2z/IL9CVfIy4V0O9t+vizX1wO6E5nUY8Amsv3W6
X-Google-Smtp-Source: AGHT+IETgiVRAvYzKc9+muMhxPRKQtXTMdXZxmGX5DWCFg9o6Ft2lMDorH+B92tbCy0AIO8oCI10JA==
X-Received: by 2002:a05:6870:a082:b0:315:b768:bd1d with SMTP id 586e51a60fabf-3c98cef6f18mr14871746fac.6.1761500079329;
        Sun, 26 Oct 2025 10:34:39 -0700 (PDT)
Received: from localhost ([2a03:2880:12ff:70::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7c5301188d1sm1551230a34.3.2025.10.26.10.34.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Oct 2025 10:34:38 -0700 (PDT)
From: David Wei <dw@davidwei.uk>
To: io-uring@vger.kernel.org,
	netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH v3 2/3] io_uring/zcrx: add refcount to struct io_zcrx_ifq
Date: Sun, 26 Oct 2025 10:34:33 -0700
Message-ID: <20251026173434.3669748-3-dw@davidwei.uk>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251026173434.3669748-1-dw@davidwei.uk>
References: <20251026173434.3669748-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a refcount to struct io_zcrx_ifq to track the number of rings that
share it. For now, this is only ever 1 i.e. not shared, but will be
larger once shared ifqs are added.

This ref is dec and tested in io_shutdown_zcrx_ifqs() to ensure that an
ifq is not cleaned up while there are still rings using it.

It's important to note that io_shutdown_zcrx_ifqs() may be called in a
loop in io_ring_exit_work() while waiting for ctx->refs to drop to 0.
Use XArray marks to ensure that the refcount dec only happens once.

The cleanup functions io_zcrx_scrub() and io_close_queue() only take ifq
locks and do not need anything from the ring ctx. Therefore it is safe
to call from any ring.

Opted for a bog standard refcount_t. The inc and dec ops are expected to
happen during the slow setup/teardown paths only, and a src ifq is only
expected to be shared a handful of times at most.

Signed-off-by: David Wei <dw@davidwei.uk>
---
 io_uring/zcrx.c | 18 ++++++++++++++++--
 io_uring/zcrx.h |  2 ++
 2 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index a816f5902091..569cc0338acb 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -587,6 +587,7 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 	if (!ifq)
 		return -ENOMEM;
 	ifq->rq_entries = reg.rq_entries;
+	refcount_set(&ifq->refs, 1);
 
 	scoped_guard(mutex, &ctx->mmap_lock) {
 		/* preallocate id */
@@ -730,8 +731,21 @@ void io_shutdown_zcrx_ifqs(struct io_ring_ctx *ctx)
 	lockdep_assert_held(&ctx->uring_lock);
 
 	xa_for_each(&ctx->zcrx_ctxs, index, ifq) {
-		io_zcrx_scrub(ifq);
-		io_close_queue(ifq);
+		if (xa_get_mark(&ctx->zcrx_ctxs, index, XA_MARK_0))
+			continue;
+
+		/* Safe to clean up from any ring. */
+		if (refcount_dec_and_test(&ifq->refs)) {
+			io_zcrx_scrub(ifq);
+			io_close_queue(ifq);
+		}
+
+		/*
+		 * This is called in a loop in io_ring_exit_work() until
+		 * ctx->refs drops to 0. Use marks to ensure refcounts are only
+		 * decremented once per ifq per ring.
+		 */
+		xa_set_mark(&ctx->zcrx_ctxs, index, XA_MARK_0);
 	}
 }
 
diff --git a/io_uring/zcrx.h b/io_uring/zcrx.h
index 33ef61503092..566d519cbaf6 100644
--- a/io_uring/zcrx.h
+++ b/io_uring/zcrx.h
@@ -60,6 +60,8 @@ struct io_zcrx_ifq {
 	 */
 	struct mutex			pp_lock;
 	struct io_mapped_region		region;
+
+	refcount_t			refs;
 };
 
 #if defined(CONFIG_IO_URING_ZCRX)
-- 
2.47.3


