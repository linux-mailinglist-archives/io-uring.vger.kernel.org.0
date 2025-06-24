Return-Path: <io-uring+bounces-8463-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F131DAE628C
	for <lists+io-uring@lfdr.de>; Tue, 24 Jun 2025 12:34:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2C0731885D84
	for <lists+io-uring@lfdr.de>; Tue, 24 Jun 2025 10:34:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA901253355;
	Tue, 24 Jun 2025 10:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LYHamoFP"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF74E283FC2
	for <io-uring@vger.kernel.org>; Tue, 24 Jun 2025 10:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750761252; cv=none; b=h6rWq3jUH0z+GRYJsM7SW9Nfq6NbzMo4hwHX08qxHh7Zdlflo7h4JLMbz4tRabHN/PMDoNTWF3uoWDotyxb4cobkxvYtXn4SzCwHB8oiXQYwyQ0jTlQ/AvJ+HlCe2ezn4x0DmmjrphGUniEwHEaAsP2NMHndw3U9G40zXdgspfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750761252; c=relaxed/simple;
	bh=Ubrd1Og0CqwWl6caZyok5R/T8zCXakaz7gRq/qTuPbM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HsMonTM/mBOZMfdrbwlUKDZqLmm7yYkDmUxvCSDox/8M4oy/vTHcTFhTN/SzJb0OOW//mgHInKu/XIYjaCG0dNxVMaxcv5l7BIsQtHrlqNVksIHRzH7jreWLyZG3QDOMWQ68U16mSsC8G+IvKtZb9NWVi7UC55Qyfda1ud2eGkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LYHamoFP; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-604bff84741so546636a12.2
        for <io-uring@vger.kernel.org>; Tue, 24 Jun 2025 03:34:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750761249; x=1751366049; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9XxbkU32CFzE3bFLTXkEqwaMB68gUbp6d/qp3EKMwIw=;
        b=LYHamoFPocnSMECHW8KVYQ2UAQLGV0n+RdmVPLBIs1z10SBCCb6f3Zy/RtYe/Y6h7J
         A2tcqthIKe13FpFVP9AaxtlfC0flrJYFMx8RYay5CIG1ltDm/kc+8KrUCj77bYk/7Z5x
         O0+ldolD8DrCGSj3K/z+at4Zyl4DZ6rUcrnRTPnRpzizHE6Ubm3CzZh1VSRE2xJn7wgd
         YKM/sVYvQcJLIsDjJiM18xzp4uUM1fMzVWHxNXM2A6G0v+Ol3HAcDOKvbG/yeJxrRE/4
         utvvMcrwPHwVlViuGPVPQdzSGWm/zqAnf8OZ3hrwvhUChybdcrqQMHAKBHVcuFMbDmdx
         ZpyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750761249; x=1751366049;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9XxbkU32CFzE3bFLTXkEqwaMB68gUbp6d/qp3EKMwIw=;
        b=dphGicSD94SUWZQuM9CKZ1lRo3hXUikxP14Rx2bO5wBWiF2IHlCdTZpxUng6XhdtnA
         mOqa4D7sVfF62O9iKuM+9YK/IDo7I/HiX0BPHGhtdQ95WnxbY4rGp43byw8CnT1VJ+Rz
         hPJ3e0Wurtm9Uf2bZBsi02WbP4tR4uDUFULhufmKSweZTFsveYL0qiNu8rFQYnhzrgTr
         R0eBiIZMAo/3ax7Nmt6ZQUo0Tuym3ALo1Y2q0cb/q574mbojf07JuMrDao9B45+8OwWR
         DcUeAG6ejxxuOJN9X32MyJyA4sxhcAJwiBIjJeZRp9FeSWvQBYTo/lyclcsu8dlLaqa5
         D+pA==
X-Gm-Message-State: AOJu0Yzr4/hiWjZsLZQEkq1UfKilllJL/XqBmZ85EQMYAl0dlaRA8hh3
	q/4y8/1PVs2N8ozkUra7HV55ValDEb6dpgF8+hqEKSXANjsgtGBGaulTy9EUuw==
X-Gm-Gg: ASbGncsgeB/lDRZglTLp611/kGhhujbUBbMLYpHj34OGIeZ0E1/Hby8HIlgOaEL52yq
	CWlpvsp6A+HSXyb4dA1F3CLcyvrgjtcUO5hEycqUZLcNWwOxJdz5+G/F6A+47PgfFKyXiu7dLvp
	YYB0U2EElTFp+Jm7qtv/EUSfIaotiLEpaLuai8RHLqrD1Q5SXiq/4hZnKBeiadA2zlfTguDvWWV
	EaWBNqryMibl+IIZKleekHc4H7Jhhvi0jwNWUbbGuydhiVL+NrD1KEnS/QIlXhDM0TGgDftudx/
	E+29x5LsmzXOkX2dwWfs1i1u/PFRGSYKPMYvKQi6hUzv3g/CuCJCatJo
X-Google-Smtp-Source: AGHT+IHzGr6YKldABzRi2K0F7GgkCxmKaW62zcePQ24s6a5tXKVroB8pY9wmCZxmOEsTQsyEPMDCwQ==
X-Received: by 2002:a17:906:6a19:b0:ad8:9466:3344 with SMTP id a640c23a62f3a-ae057b98feamr1550517566b.43.1750761248579;
        Tue, 24 Jun 2025 03:34:08 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:112b])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-60c3c213b1dsm320999a12.54.2025.06.24.03.34.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jun 2025 03:34:07 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	David Hildenbrand <david@redhat.com>
Subject: [PATCH v1 3/3] io_uring: don't assume uaddr alignment in io_vec_fill_bvec
Date: Tue, 24 Jun 2025 11:35:21 +0100
Message-ID: <d068c934f4e338c95558bbf85163cb811c114421.1750760501.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1750760501.git.asml.silence@gmail.com>
References: <cover.1750760501.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There is no guaranteed alignment for user pointers. Don't use mask
trickery and adjust the offset by bv_offset.

Cc: stable@vger.kernel.org
Reported-by: David Hildenbrand <david@redhat.com>
Fixes: 9ef4cbbcb4ac3 ("io_uring: add infra for importing vectored reg buffers")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/rsrc.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 5132f8df600f..4c972cac6cdf 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1337,7 +1337,6 @@ static int io_vec_fill_bvec(int ddir, struct iov_iter *iter,
 {
 	unsigned long folio_size = 1 << imu->folio_shift;
 	unsigned long folio_mask = folio_size - 1;
-	u64 folio_addr = imu->ubuf & ~folio_mask;
 	struct bio_vec *res_bvec = vec->bvec;
 	size_t total_len = 0;
 	unsigned bvec_idx = 0;
@@ -1359,8 +1358,13 @@ static int io_vec_fill_bvec(int ddir, struct iov_iter *iter,
 		if (unlikely(check_add_overflow(total_len, iov_len, &total_len)))
 			return -EOVERFLOW;
 
-		/* by using folio address it also accounts for bvec offset */
-		offset = buf_addr - folio_addr;
+		offset = buf_addr - imu->ubuf;
+		/*
+		 * Only first bvec can have non-0 bv_offset, account it here
+		 * and work with full folios below.
+		 */
+		offset += imu->bvec[0].bv_offset;
+
 		src_bvec = imu->bvec + (offset >> imu->folio_shift);
 		offset &= folio_mask;
 
-- 
2.49.0


