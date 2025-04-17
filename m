Return-Path: <io-uring+bounces-7508-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id AABF0A917E8
	for <lists+io-uring@lfdr.de>; Thu, 17 Apr 2025 11:31:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 580F57A22FA
	for <lists+io-uring@lfdr.de>; Thu, 17 Apr 2025 09:30:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FBC6221D85;
	Thu, 17 Apr 2025 09:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HcuCtBP3"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7B971CB9E2
	for <io-uring@vger.kernel.org>; Thu, 17 Apr 2025 09:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744882306; cv=none; b=CoOIezqs4dykEDo8XVRv9D7UaPJx02k3unGdEZHhryN5580iKSeJDySFG7RYQpzsrU7ajNdKAUTnPZPj5ORNpv28NdchlwCXVwYeAHQk1DxZ3HEx4LJlq6yfxrWvjgMxSIIEzzcnDDVi4oIKheCPJ32D3C4lF8/trHM4WQeosiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744882306; c=relaxed/simple;
	bh=geL4sBTku0Cj9x+h2OXPph8dSbQ7eVgmip2+ObLan1g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aZpXti7NLxVwF3ah01HkKnTAVKV0s3MMpBWJ1advRcAM2z3kdbvI03zp0xVGxe8UlouPq/Yptr6m6Q3tZDUWuGaTwyrX5BbwFoK5lYVvCSE7IAvrby94KjfmRs+PvQoRwbbgEHrKHnT/4JwVvCA5xySpEKRKPrOjPlgETmU9vJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HcuCtBP3; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-5f4b7211badso946719a12.2
        for <io-uring@vger.kernel.org>; Thu, 17 Apr 2025 02:31:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744882303; x=1745487103; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5pF087HclG7wJWl6q/YftzPKmorzEsPMx+UexYOz8mg=;
        b=HcuCtBP3mQM8u1Zs4BX3oF9dJgaqh7wkvKXJPNMdGZsOcCB7Ok30MZn8IFEOfUN06X
         o13av+tOKDEM1z1DOA0U9qxy+/CNpizKorX4CjaLDL1iP4njITFXDzbiTXNSzxT6eLMG
         js8VY6ZwUav3A5gRwcnYOiaU59D+b91YVSXTxw6wgnF3MYXwVTurGHRGQadHqJwcSq37
         1t3rLc4gZOBwrkpT0iUPzq7Yl3RxqK7I+J23J0Pq1/n93hha9PmhWhjomi+C11OsY2Xf
         iSjkuJuUBVi+j4CjrOIIexWMKk0F5dhoMIPI+1We0+fv2GaHeucWL17y/GVZxcV3VjJT
         g/ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744882303; x=1745487103;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5pF087HclG7wJWl6q/YftzPKmorzEsPMx+UexYOz8mg=;
        b=rN+cruB4yph6PGqY09RKfjSz753uweQVKdt1CrmLwVbhs/YjvblENoLLWlLjMXlcrB
         CYQYogYLg4yqLnRW5T30D0Jg1cdUSS8z4lL9NrMIcy7XUy+uVK5s7MIJC4oIGG2hHeGm
         6dl20x6tj1FZCh7XpyJGZa+OSvH0K27Ol4oJHQCeND+SmG+LB66NJH+IV2e7GxOodVH+
         PFd1mnqU0+mv2xrAFY0zvQm43ARSX4VqnxUL4mpVVwYVxDZNxESHU4iiajB5IeeLC1L2
         eQScQFQ48BYm2ksiTFE21JnjaBsP9UwuY/8sCUouW3Gb7e9uylv4U601+uAZOplMJhr7
         7slg==
X-Gm-Message-State: AOJu0YyPy6pBbi6Vdg0q3ClFAPUl7i+cFpt2Ah9eEjcwS5GW8sLRz0K4
	pUDbF0oNtqT35dd1Kg3gfVOCHEbXhj9Uowxshr5V6p+3YAR/CJdYkS2H4r37
X-Gm-Gg: ASbGncuKNXtlSfK/ChxbUojEurmdezIcNei+36InPKAprFgzQWQUCOJXSZcu/yjQxw1
	+nB80p2y3mrCASgIRjJDptMFKiLxqjmZ4oZcehLX/5mVVAZkZ3oJc1GGZUQCJkF4XdXwYo0cyH4
	yB2QIvYvGA8UrAwQt/YWOuOuJb5d1hqtqsQE/KQ8arVqetx5IAn+YBnnT96OwHBKkvi/ZxtojdN
	SEtoXCVTOUW/fTMys3SXCqmeB56IlvPTWFj+GeSPOmZGbSJzb0F6iaOIIIkKgD3rYu8RG1I4+QJ
	+RJIrT81A490TESNwii9oWx8
X-Google-Smtp-Source: AGHT+IHWkUJU0Ff+n7wRW4QPPah6EGKrWQu36MBACH0Ef+l7SEWylpzccUsQUR5rcFSzwNIRXBJYXg==
X-Received: by 2002:a17:907:968f:b0:ac8:1798:f57 with SMTP id a640c23a62f3a-acb42ad581emr480557566b.38.1744882302395;
        Thu, 17 Apr 2025 02:31:42 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:c8e6])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-acb62b93234sm51717966b.86.2025.04.17.02.31.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Apr 2025 02:31:41 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	Nitesh Shetty <nj.shetty@samsung.com>
Subject: [PATCH 1/4] io_uring/rsrc: don't skip offset calculation
Date: Thu, 17 Apr 2025 10:32:31 +0100
Message-ID: <1c2beb20470ee3c886a363d4d8340d3790db19f3.1744882081.git.asml.silence@gmail.com>
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

Don't optimise for requests with offset=0. Large registered buffers are
the preference and hence the user is likely to pass an offset, and the
adjustments are not expensive and will be made even cheaper in following
patches.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/rsrc.c | 75 ++++++++++++++++++++++++-------------------------
 1 file changed, 37 insertions(+), 38 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index b36c8825550e..4d62897d1c89 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1036,6 +1036,7 @@ static int io_import_fixed(int ddir, struct iov_iter *iter,
 			   struct io_mapped_ubuf *imu,
 			   u64 buf_addr, size_t len)
 {
+	const struct bio_vec *bvec;
 	size_t offset;
 	int ret;
 
@@ -1054,47 +1055,45 @@ static int io_import_fixed(int ddir, struct iov_iter *iter,
 	offset = buf_addr - imu->ubuf;
 	iov_iter_bvec(iter, ddir, imu->bvec, imu->nr_bvecs, offset + len);
 
-	if (offset) {
-		/*
-		 * Don't use iov_iter_advance() here, as it's really slow for
-		 * using the latter parts of a big fixed buffer - it iterates
-		 * over each segment manually. We can cheat a bit here for user
-		 * registered nodes, because we know that:
-		 *
-		 * 1) it's a BVEC iter, we set it up
-		 * 2) all bvecs are the same in size, except potentially the
-		 *    first and last bvec
-		 *
-		 * So just find our index, and adjust the iterator afterwards.
-		 * If the offset is within the first bvec (or the whole first
-		 * bvec, just use iov_iter_advance(). This makes it easier
-		 * since we can just skip the first segment, which may not
-		 * be folio_size aligned.
-		 */
-		const struct bio_vec *bvec = imu->bvec;
+	/*
+	 * Don't use iov_iter_advance() here, as it's really slow for
+	 * using the latter parts of a big fixed buffer - it iterates
+	 * over each segment manually. We can cheat a bit here for user
+	 * registered nodes, because we know that:
+	 *
+	 * 1) it's a BVEC iter, we set it up
+	 * 2) all bvecs are the same in size, except potentially the
+	 *    first and last bvec
+	 *
+	 * So just find our index, and adjust the iterator afterwards.
+	 * If the offset is within the first bvec (or the whole first
+	 * bvec, just use iov_iter_advance(). This makes it easier
+	 * since we can just skip the first segment, which may not
+	 * be folio_size aligned.
+	 */
+	bvec = imu->bvec;
 
-		/*
-		 * Kernel buffer bvecs, on the other hand, don't necessarily
-		 * have the size property of user registered ones, so we have
-		 * to use the slow iter advance.
-		 */
-		if (offset < bvec->bv_len) {
-			iter->count -= offset;
-			iter->iov_offset = offset;
-		} else if (imu->is_kbuf) {
-			iov_iter_advance(iter, offset);
-		} else {
-			unsigned long seg_skip;
+	/*
+	 * Kernel buffer bvecs, on the other hand, don't necessarily
+	 * have the size property of user registered ones, so we have
+	 * to use the slow iter advance.
+	 */
+	if (offset < bvec->bv_len) {
+		iter->count -= offset;
+		iter->iov_offset = offset;
+	} else if (imu->is_kbuf) {
+		iov_iter_advance(iter, offset);
+	} else {
+		unsigned long seg_skip;
 
-			/* skip first vec */
-			offset -= bvec->bv_len;
-			seg_skip = 1 + (offset >> imu->folio_shift);
+		/* skip first vec */
+		offset -= bvec->bv_len;
+		seg_skip = 1 + (offset >> imu->folio_shift);
 
-			iter->bvec += seg_skip;
-			iter->nr_segs -= seg_skip;
-			iter->count -= bvec->bv_len + offset;
-			iter->iov_offset = offset & ((1UL << imu->folio_shift) - 1);
-		}
+		iter->bvec += seg_skip;
+		iter->nr_segs -= seg_skip;
+		iter->count -= bvec->bv_len + offset;
+		iter->iov_offset = offset & ((1UL << imu->folio_shift) - 1);
 	}
 
 	return 0;
-- 
2.48.1


