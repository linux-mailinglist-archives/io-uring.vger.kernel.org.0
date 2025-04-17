Return-Path: <io-uring+bounces-7509-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BEB8A917E6
	for <lists+io-uring@lfdr.de>; Thu, 17 Apr 2025 11:31:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 38E71189D75C
	for <lists+io-uring@lfdr.de>; Thu, 17 Apr 2025 09:32:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9B7A2253E1;
	Thu, 17 Apr 2025 09:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="evHHukfM"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E10CF1898FB
	for <io-uring@vger.kernel.org>; Thu, 17 Apr 2025 09:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744882307; cv=none; b=iQfx0tBISw2fUwsLSTMvh+RWrnkR4ugM48nUhLBPZfstd6o9D0NepoT95Y7nw3IHDdvHMPD/4eaBqqtqjYjpCo6Nsqtbgh/MNz/rWLDSjHLQbaAr0rBgTi3V+K/Y4OO5ZerIWVQ9DvHEln10XlBtyTxP4WMPdPI4PJN+7ELjpTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744882307; c=relaxed/simple;
	bh=8HLGWGJiqXgNNsigXpjdVc4Scs8ivCHM0e8R5zDdzdo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z9/4hMi+DnmusVu1D6hI21WDAmDk/LvH+BCIeauRSof9kFpv5gdz1gqjo6WPDyIdYqv/LaGc+g4pnKXdEWaGMGiI07l6/C1oKbTiZ3rSkqKAui+1aXaZTR4RFODg5/Jz3mNLrsTyhYaEalwpfqY6N8QRhkz0Tqs45USIr0pcRbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=evHHukfM; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-ac2bb7ca40bso107673266b.3
        for <io-uring@vger.kernel.org>; Thu, 17 Apr 2025 02:31:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744882304; x=1745487104; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZLxMaEsDEEd30KccamXmu/sFkEm9mpR6aMO6lOwp/Lk=;
        b=evHHukfMuZM0ykZ0qoi3VFT0qdHvn6X9xaZu2NYT/lj1MpQeIIuidG786StxjpSoHn
         kgXp4KXW9g8iRWnmQqDE2XC4QxDBzRpvujl5I8qR5IftHdy4ea7owIdXdAodd7/2Hsol
         RKQDp7WP7xJx+UWC3TX7KVIZDMiiW+vvWix5K07CDvE/1wV6NB1ZcMUCaWW8c5IN9WTb
         WtQXxP3qt+q8CL0E5rP/TGrfJtVRxaPJSAMQ7Zi3bo7Kw7H9r5zbn1cw4LF7Hwc0ZfpM
         ISgggFz5gemalg6Guu771eVupVJhrXzBikHLb5AWfOJ4bQ27vKj/rKrbrHxoRM1BcXY9
         cslw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744882304; x=1745487104;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZLxMaEsDEEd30KccamXmu/sFkEm9mpR6aMO6lOwp/Lk=;
        b=U8SO582llT1FMHhCg0cdv24Wx0Wq4k9fGVV9IMrFdXxVKkavTD7BI/R568vStiUKic
         SeoGLO8fq3Sys13tX1YZNSkCbuKbxY7fouepae9x+3CI11+MsAMAtNU2EjlZBheh7ahj
         AbbsOOsZHIIVyI1MkoenjWJFXfb49yWHgteQWvhiDSde+PzRdVvPvGcIky0qFoHr8oe0
         ceL0QlOSVYqyxQ0qv9Jc1joiea1pyJ4zWmgXBeoN7ehvr1+0KR75SQIxA0B8Vw8jY0qa
         ngAYlPPYDvkhy5GvkBZhBC3FfK4hRlvSMqIHwVXAgL4XL7+nw+x810WsZ5tX0Bm+BBPg
         /O4A==
X-Gm-Message-State: AOJu0YzUfIX+0k8GZUDp870ujxiDN8kEljzhFylGmeEoJNdbW//l9E7E
	EbTC4JUL0kro8ZziunTzRVhV0m1nU6vUVSK2kuAZGqETe2X7VCJDOdekeEOV
X-Gm-Gg: ASbGncu9fhWI0H3BQQNi+dT7MhMDc3s8MYB6SIPfpCGbXkaYSTDjpx/FRbxGS1krwhM
	q19W+nNMviqDFOSioNOqTRYpDb38tsRmgm4o+hozsI5NvNpDvxDiZKMerGz86LNzY6Ubh9PkPn2
	RV3xxXh+JOjsXL3nWBqOOLg1ERXpR078NusVNwQjwaYUnhrFaV0/CRVhoxUKK5s1DlW7D7iXwhU
	zBdE/OZI7M7oWdjCmYdpHF03ow3bzcfco0TRchDXTaj+ziFU/mXQHaNk7iyxm+Prn7rjN1LQ1Z5
	TVLrjHoytNQVDsCxxC8+4hII
X-Google-Smtp-Source: AGHT+IFC3lfd2BLJAkVP7288tj90epylKcafHvCsL7GPD3+Xv/CI1uwNBjt5r8cVDt2Yu+AFLScZrQ==
X-Received: by 2002:a17:907:f496:b0:ac2:9ac:a062 with SMTP id a640c23a62f3a-acb429e6a44mr492931866b.23.1744882303669;
        Thu, 17 Apr 2025 02:31:43 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:c8e6])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-acb62b93234sm51717966b.86.2025.04.17.02.31.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Apr 2025 02:31:42 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	Nitesh Shetty <nj.shetty@samsung.com>
Subject: [PATCH 2/4] io_uring/rsrc: separate kbuf offset adjustments
Date: Thu, 17 Apr 2025 10:32:32 +0100
Message-ID: <4e9e5990b0ab5aee723c0be5cd9b5bcf810375f9.1744882081.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1744882081.git.asml.silence@gmail.com>
References: <cover.1744882081.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Kernel registered buffers are special because segments are not uniform
in size, and we have a bunch of optimisations based on that uniformity
for normal buffers. Handle kbuf separately, it'll be cleaner this way.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/rsrc.c | 19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 4d62897d1c89..fddde8ffe81e 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1048,11 +1048,14 @@ static int io_import_fixed(int ddir, struct iov_iter *iter,
 	if (!(imu->dir & (1 << ddir)))
 		return -EFAULT;
 
-	/*
-	 * Might not be a start of buffer, set size appropriately
-	 * and advance us to the beginning.
-	 */
 	offset = buf_addr - imu->ubuf;
+
+	if (imu->is_kbuf) {
+		iov_iter_bvec(iter, ddir, imu->bvec, imu->nr_bvecs, offset + len);
+		iov_iter_advance(iter, offset);
+		return 0;
+	}
+
 	iov_iter_bvec(iter, ddir, imu->bvec, imu->nr_bvecs, offset + len);
 
 	/*
@@ -1072,17 +1075,9 @@ static int io_import_fixed(int ddir, struct iov_iter *iter,
 	 * be folio_size aligned.
 	 */
 	bvec = imu->bvec;
-
-	/*
-	 * Kernel buffer bvecs, on the other hand, don't necessarily
-	 * have the size property of user registered ones, so we have
-	 * to use the slow iter advance.
-	 */
 	if (offset < bvec->bv_len) {
 		iter->count -= offset;
 		iter->iov_offset = offset;
-	} else if (imu->is_kbuf) {
-		iov_iter_advance(iter, offset);
 	} else {
 		unsigned long seg_skip;
 
-- 
2.48.1


