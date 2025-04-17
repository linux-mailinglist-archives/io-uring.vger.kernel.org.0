Return-Path: <io-uring+bounces-7510-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 56743A917E9
	for <lists+io-uring@lfdr.de>; Thu, 17 Apr 2025 11:31:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8556E19E07E7
	for <lists+io-uring@lfdr.de>; Thu, 17 Apr 2025 09:32:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E0B0226165;
	Thu, 17 Apr 2025 09:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iJYiD636"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87F30224AFA
	for <io-uring@vger.kernel.org>; Thu, 17 Apr 2025 09:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744882309; cv=none; b=EJ88IZpJmscdieb65F3m/c6u5Wgn8wKkDeCfXtQI1rcVO4I5DTZW1tRqxTt88LWImze3x2bJU0I9K+JO4S4r1TqFfjt313cOyWpyl6wBHfDgMg6bELogjzPbG1OOvkc91hB19E0so/ZANf3El0PwNBKOGvwMuSqoSojn42egC7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744882309; c=relaxed/simple;
	bh=KZgdQYsbY3uTT6cDFGDvH5DjP9XJ75uZpnWToKkA8zg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cR1x7oYEP90b0kDrqdX85piE4Va6TYhi6E6G9KiHhQrG8mgV9lxgcMsGAXZDmn29iCPfqQYFdVNVCOK7U6aI5EKdyRJ4EXtcJf2oLwUCZGmfHwsO9svkfZ3BotFbgKgZuFWaMdJssTw82ZTeXN9PSrmcLEM2rFnYSHq8EgaMCkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iJYiD636; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-ac345bd8e13so86592966b.0
        for <io-uring@vger.kernel.org>; Thu, 17 Apr 2025 02:31:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744882305; x=1745487105; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hcELwBZzKAeI45et2H3t5od7iEGdrRW0aLMdZfSaEHQ=;
        b=iJYiD636e8TXIJcHFu58QXmN62czUzx7Fx7Xuu4Bz7dMKquyylZA2DPv0Yo9vqJko0
         Z139I4C6pXH6BZUK4Uy2ieNXOHfFtPREKVKjV5K2JsJU157VxoiRwqFHm2ZbhyI43WJI
         Tx4akqfjvKkLLrY+Pguox78MCPvkCZXmBqvTaA8LR0ijCwBTo+k4bB46WT+eZ9Jfxq79
         tHg0dIhOhN04jmiQaRs/Aw4NL22cD7QbnUPUS1KLSEBx6A7g8cLbqPpazze3Bnbbv9bl
         1SvOztCeYkH34p1vw489CMBClZQdspybWvb80I5DR20bTiw4c+Ypw0KzmAYT7bDPFl4n
         oRVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744882305; x=1745487105;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hcELwBZzKAeI45et2H3t5od7iEGdrRW0aLMdZfSaEHQ=;
        b=WK1NA3Hi5SEGggdoxyWLbMxvBAsh4MjpHlQGb7zmTKsRlKOmAYuatCTw0jYP5nA/2N
         O/Ta7a1aQzQ7SaSCyaWwulV8oSnyjwwXXpEG4x9s82vMrLyxBIZed0XZYO0QFu0aEP+b
         JqCyBRNw+cfYPbrtMEk8Qlb3kB5EbMf4hrNJ4eC/C3hqop+gal/hmzV3RWoAQd0nFjZ6
         QJRKu1AJegLVdWI7kQ45/NkUQi4uACbleH84k9Kozc8KvXlG1GTfQ8ZYIQx/+i2yCqJC
         8tARFWTbVIaMXpkwmQV4SE7i4Q6JkkQVZCqPi4bEKjwSRPNmMUT35pOxzgw/9/I+j48D
         o5HQ==
X-Gm-Message-State: AOJu0YwYx9gosNTE3I5GN+JqvslRrU2AN0VAJ2aF1ngIqBpn49Yvm6pD
	xp7od/2evyyuPVVLEKdWxZ8nt9W7JR/7osvzadPDqJCkCANqzRDtABHgR2C/
X-Gm-Gg: ASbGnctiSfpGf5QbN6UlwLRYG/O+ZXmTUhlMCqqwSUrI9YFiexNbGoSvwP0BpZaf+2k
	O2cwBQFtIYD94jcGv6ivU7Dv11afVtWPuVbWUnf8QTXeN/Us9yHYBooE03/ilLS1FBEKe3e41FU
	DtM+H76Yp39o1oAlDKaE/zw76yh2/vpL2mfefV2T+gu0LrEgmNUit76sDR/esjlVL8zVp0Zb5cx
	ArIeH9gmPgzSiyCsWJ/LxgZegwMjafylFk0g6NSd2UtsWzscMD6KgCNljx4j0G1+tqwJuWHCDbw
	EKmQGGBRPcFzhYS6Ar8CL1FT
X-Google-Smtp-Source: AGHT+IFNeTkgGJfUgnqW+YwNg8DglFPiuYaeIEri9d/kALpqyzF7474qkfugfoieJYnHlI0ASDvLug==
X-Received: by 2002:a17:907:7203:b0:ac6:fec7:34dd with SMTP id a640c23a62f3a-acb42bacdf4mr413612566b.52.1744882304848;
        Thu, 17 Apr 2025 02:31:44 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:c8e6])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-acb62b93234sm51717966b.86.2025.04.17.02.31.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Apr 2025 02:31:44 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	Nitesh Shetty <nj.shetty@samsung.com>
Subject: [PATCH 3/4] io_uring/rsrc: refactor io_import_fixed
Date: Thu, 17 Apr 2025 10:32:33 +0100
Message-ID: <2d5107fed24f8b23245ef2ede9a5a7f7c426df61.1744882081.git.asml.silence@gmail.com>
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

io_import_fixed is a mess. Even though we know the final len of the
iterator, we still assign offset + len and do some magic after to
correct for that.

Do offset calculation first and finalise it with iov_iter_bvec at the
end.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/rsrc.c | 24 +++++++-----------------
 1 file changed, 7 insertions(+), 17 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index fddde8ffe81e..5cf854318b1d 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1037,6 +1037,7 @@ static int io_import_fixed(int ddir, struct iov_iter *iter,
 			   u64 buf_addr, size_t len)
 {
 	const struct bio_vec *bvec;
+	unsigned nr_segs;
 	size_t offset;
 	int ret;
 
@@ -1056,8 +1057,6 @@ static int io_import_fixed(int ddir, struct iov_iter *iter,
 		return 0;
 	}
 
-	iov_iter_bvec(iter, ddir, imu->bvec, imu->nr_bvecs, offset + len);
-
 	/*
 	 * Don't use iov_iter_advance() here, as it's really slow for
 	 * using the latter parts of a big fixed buffer - it iterates
@@ -1067,30 +1066,21 @@ static int io_import_fixed(int ddir, struct iov_iter *iter,
 	 * 1) it's a BVEC iter, we set it up
 	 * 2) all bvecs are the same in size, except potentially the
 	 *    first and last bvec
-	 *
-	 * So just find our index, and adjust the iterator afterwards.
-	 * If the offset is within the first bvec (or the whole first
-	 * bvec, just use iov_iter_advance(). This makes it easier
-	 * since we can just skip the first segment, which may not
-	 * be folio_size aligned.
 	 */
 	bvec = imu->bvec;
-	if (offset < bvec->bv_len) {
-		iter->count -= offset;
-		iter->iov_offset = offset;
-	} else {
+	if (offset >= bvec->bv_len) {
 		unsigned long seg_skip;
 
 		/* skip first vec */
 		offset -= bvec->bv_len;
 		seg_skip = 1 + (offset >> imu->folio_shift);
-
-		iter->bvec += seg_skip;
-		iter->nr_segs -= seg_skip;
-		iter->count -= bvec->bv_len + offset;
-		iter->iov_offset = offset & ((1UL << imu->folio_shift) - 1);
+		bvec += seg_skip;
+		offset &= (1UL << imu->folio_shift) - 1;
 	}
 
+	nr_segs = imu->nr_bvecs - (bvec - imu->bvec);
+	iov_iter_bvec(iter, ddir, bvec, nr_segs, len);
+	iter->iov_offset = offset;
 	return 0;
 }
 
-- 
2.48.1


