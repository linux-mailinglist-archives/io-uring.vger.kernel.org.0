Return-Path: <io-uring+bounces-6927-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 69719A4DDAA
	for <lists+io-uring@lfdr.de>; Tue,  4 Mar 2025 13:17:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8A6F317839C
	for <lists+io-uring@lfdr.de>; Tue,  4 Mar 2025 12:17:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D8D720102F;
	Tue,  4 Mar 2025 12:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E7v92B6H"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B183C201023;
	Tue,  4 Mar 2025 12:17:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741090656; cv=none; b=kig0kcUygp4nYvP0QsdVO4MkHeugfe++81SIoQbDu3+R7fslcfiFRM0vmQW2twV2mllThJVcKna2tipm5HRtvDZvYS3X//VUshiSDPn+Asn6FI5l+e8YSK1KY940hCzkZugYHsXU9uT9zTCa5iLvRnA1BM23Q40d25EbGdtnnBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741090656; c=relaxed/simple;
	bh=H0viHNn2Noiu2ehJa4wGSKvvmC0Ntvd05iDJ90zjNZI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DHI5eu/ludksim1wMervyDT1fwDKIKBsQn52Y+zrrWYhDL9ppsNnifGbw9Y7P/RFHCxE3LaWxqgJxkx3brzm2nAGWa3Uc8JBKEMmJNt4HC3zj4hrUb1lmvHg4IHgsd1TcP9ThVfN/dDqjupj0tmMcdVxfGAdxT92Ar8/OuGtREk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=E7v92B6H; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-ac1f5157c90so114436066b.0;
        Tue, 04 Mar 2025 04:17:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741090653; x=1741695453; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=599/Tw3ToamJqGW2mw+qAC6V0VOUfxPlSz0DmmrvZM4=;
        b=E7v92B6HrvL2AwWqlwKLp04wSWaJZDivAu/LEsPJXbxj5PuDVK+xEjzqSia0WBbYV5
         +kt4y5XOJC0Bscd7mqwqrduyTfsffYtBJYQ8WoPUYQu8BYj2nbRjvRZmGnHFVQH7TJpR
         adzVILL0DBaWHtCI4+p3TRX1Uf4LolHiMEb6vwQl1RbICtlzWN9eDZiB2loEM74xiyi+
         u4dSf3N59TZnHIEJfPm+7fwjAn8VPU/Wc9enq+1g1q9WLWIwg0sXnyL10rs8vUWtM1Pe
         q23w6BsE6g1fAESs6rp+RGQFmBwkMk7zmOYurYasanZtopPtD8PhbNkw9qXzEaADlSC6
         G2Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741090653; x=1741695453;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=599/Tw3ToamJqGW2mw+qAC6V0VOUfxPlSz0DmmrvZM4=;
        b=usgJw8uwHy825WJJ0OOCK3Tn+JuzZJlQw0w0GA0X19loUJBNv6r0mUf2u9LDYnk7g5
         94FVMNTZcqg8N5xKXiRwxzg4nxELKBu4eR6KIAYJo5qTrHaPECK1/Qd/qZwJNZludJ2S
         8fdyGXprVc7vQKhldxsWvmMzoifXzRVLLGZS9zcixCJ9eUtzv45+S/tVummtraNeQbQE
         zrkoZWbuQB1kvCq5zMo/03Os3TDLEZ4gXlVL2lph3Q0JJcf2p/14Laos5/52ogSrVMyq
         9s8CiCE2KtGXIMLMF1SwDKS9vrhyTqKlBczyu/4VTGQkeMVgVDqSBWN1bEuFzsgfOgNh
         LedA==
X-Forwarded-Encrypted: i=1; AJvYcCU0BXaXs7zUIQcFiIKGhJWidLx7Jpw2VDK8kL1Z8Cd70lbV85reaqMjzWwbhle7R2rsiIKIJIFagbVxtDdK@vger.kernel.org, AJvYcCX++5HWkwxOaZpuYzZ+UvLQ8GZh0TDIJyCMwTXtFMZQp76hiwnRQaFwQb3kzIG4XdAYUuoR+gcJ6eY4@vger.kernel.org
X-Gm-Message-State: AOJu0Yz7fERY7ocMPB6U3Q8dvfftD+yYLquGs96+jIdM49CPb+11T+Kf
	XUK6iVtll9CAZ8nAYjANudwh/+rlqXYgM8gfVX2EPo7FxLAcflw4TZVZzA==
X-Gm-Gg: ASbGncuQmWpj8+79GSTDZQxwZVCQiKODHTn2vFQlrdQn2qGlCxlZoiEH3Dgef3BGydO
	DgWuzWcm9H8SkiRsFwQEPbhzoANgYyJiqufUTxuMdxQG6M7AQ8B65YJoMGFlq9c+gSsTBKwC9F3
	He/ASc+vLR4DxQDbfyQvhPnwuqEPRJ6bMZ11kFnA2/PK1oVsjKJMRrqfkAfTEKX3tmCqLJUjA7N
	SZ1efK23T4GP1XKUV+AY9cGJWKj7umDLlWqvT2DWIdcozQ6nXBjCNl7aZXfz1vtmcMQgfYLtN5m
	aL4nb18WGUEcWf4cZb0lWi+s3KTQ
X-Google-Smtp-Source: AGHT+IGVQQNuddYw7b42dJlGMu9B3NVjyQv5HN54W9B+OxF/axiTscYQHYLUfl8wsoBiGgabTKVArg==
X-Received: by 2002:a17:906:eeca:b0:abb:e965:1264 with SMTP id a640c23a62f3a-abf261fba4fmr1893189866b.4.1741090652348;
        Tue, 04 Mar 2025 04:17:32 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:87eb])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac1e61f5325sm190206466b.28.2025.03.04.04.17.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Mar 2025 04:17:31 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: Christian Brauner <brauner@kernel.org>,
	linux-fsdevel@vger.kernel.org,
	Dave Chinner <david@fromorbit.com>
Cc: io-uring@vger.kernel.org,
	"Darrick J . Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org,
	wu lei <uwydoc@gmail.com>,
	asml.silence@gmail.com
Subject: [PATCH v2 1/1] iomap: propagate nowait to block layer
Date: Tue,  4 Mar 2025 12:18:07 +0000
Message-ID: <f287a7882a4c4576e90e55ecc5ab8bf634579afd.1741090631.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There are reports of high io_uring submission latency for ext4 and xfs,
which is due to iomap not propagating nowait flag to the block layer
resulting in waiting for IO during tag allocation.

Because of how errors are propagated back, we can't set REQ_NOWAIT
for multi bio IO, in this case return -EAGAIN and let the caller to
handle it, for example, it can reissue it from a blocking context.
It's aligned with how raw bdev direct IO handles it.

Cc: stable@vger.kernel.org
Link: https://github.com/axboe/liburing/issues/826#issuecomment-2674131870
Reported-by: wu lei <uwydoc@gmail.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---

v2:
	Fail multi-bio nowait submissions

 fs/iomap/direct-io.c | 26 +++++++++++++++++++++++---
 1 file changed, 23 insertions(+), 3 deletions(-)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index b521eb15759e..07c336fdf4f0 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -363,9 +363,14 @@ static loff_t iomap_dio_bio_iter(const struct iomap_iter *iter,
 	 */
 	if (need_zeroout ||
 	    ((dio->flags & IOMAP_DIO_NEED_SYNC) && !use_fua) ||
-	    ((dio->flags & IOMAP_DIO_WRITE) && pos >= i_size_read(inode)))
+	    ((dio->flags & IOMAP_DIO_WRITE) && pos >= i_size_read(inode))) {
 		dio->flags &= ~IOMAP_DIO_CALLER_COMP;
 
+		if (!is_sync_kiocb(dio->iocb) &&
+		    (dio->iocb->ki_flags & IOCB_NOWAIT))
+			return -EAGAIN;
+	}
+
 	/*
 	 * The rules for polled IO completions follow the guidelines as the
 	 * ones we set for inline and deferred completions. If none of those
@@ -374,6 +379,23 @@ static loff_t iomap_dio_bio_iter(const struct iomap_iter *iter,
 	if (!(dio->flags & (IOMAP_DIO_INLINE_COMP|IOMAP_DIO_CALLER_COMP)))
 		dio->iocb->ki_flags &= ~IOCB_HIPRI;
 
+	bio_opf = iomap_dio_bio_opflags(dio, iomap, use_fua, atomic);
+
+	if (!is_sync_kiocb(dio->iocb) && (dio->iocb->ki_flags & IOCB_NOWAIT)) {
+		/*
+		 * This is nonblocking IO, and we might need to allocate
+		 * multiple bios. In this case, as we cannot guarantee that
+		 * one of the sub bios will not fail getting issued FOR NOWAIT
+		 * and as error results are coalesced across all of them, ask
+		 * for a retry of this from blocking context.
+		 */
+		if (bio_iov_vecs_to_alloc(dio->submit.iter, BIO_MAX_VECS + 1) >
+					  BIO_MAX_VECS)
+			return -EAGAIN;
+
+		bio_opf |= REQ_NOWAIT;
+	}
+
 	if (need_zeroout) {
 		/* zero out from the start of the block to the write offset */
 		pad = pos & (fs_block_size - 1);
@@ -383,8 +405,6 @@ static loff_t iomap_dio_bio_iter(const struct iomap_iter *iter,
 			goto out;
 	}
 
-	bio_opf = iomap_dio_bio_opflags(dio, iomap, use_fua, atomic);
-
 	nr_pages = bio_iov_vecs_to_alloc(dio->submit.iter, BIO_MAX_VECS);
 	do {
 		size_t n;
-- 
2.48.1


