Return-Path: <io-uring+bounces-7514-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 51D9FA91C33
	for <lists+io-uring@lfdr.de>; Thu, 17 Apr 2025 14:31:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B06DC3B903A
	for <lists+io-uring@lfdr.de>; Thu, 17 Apr 2025 12:30:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DDBA12417F0;
	Thu, 17 Apr 2025 12:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="FfciR4Pv"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A3F2245007
	for <io-uring@vger.kernel.org>; Thu, 17 Apr 2025 12:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744892949; cv=none; b=ZtEq12MbEW5nbILN1Iqv3IoteBZiXQR6vpAPrW5oTVJDhC/geFuT55ER+RFdubZKIA1ImDt2mqt9F0t+ItCqRmqqV0DAqur8FJUUMCBjbwSsZyFc4HpZ6oNFIrNPQzNVk/m+6hyM9U0OupWmNFUiMyxGzDzWN2ksamliQh1HjKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744892949; c=relaxed/simple;
	bh=9tN1vYbaB7fASiPzLOgP8r0aiZDvefENHpdU1liyys8=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Cc:Content-Type; b=XAWO7VwPCcgQVnf/D/nYSDzxg1RWyt8fgWE4uhN1/uvXOGuz5knyp35FT6JShxBQnSEDYMMlo7vXAU9h97PgDMTN9UrU04XXit/GRaIrwMKR86Co2aMti3qr4Pqt/OIPYnjKvhfIVMYHAMt7LzVBx/CbsrA1u+Yp+ROVcg/jBDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=FfciR4Pv; arc=none smtp.client-ip=209.85.166.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f179.google.com with SMTP id e9e14a558f8ab-3cda56e1dffso3000625ab.1
        for <io-uring@vger.kernel.org>; Thu, 17 Apr 2025 05:29:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1744892945; x=1745497745; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gstty6uiv8V52+U4oFg1laBsa0dh1V5FdpOlSDxRmv4=;
        b=FfciR4PvHGCaS7hWyZxhADxp/Lk+zr3G2C2Y21piqX0uf2HBRnbAvqq6jw3UkuRrjC
         LuaPOaOdwGY7TNf/YSriAg5ba2uQxcwCqzdzABLzjlx0Np5BakBe46HP6FyEMg6hbNUs
         DdMrq7jHTfejowsu4EJUgL2q/eOKLtzI9zf0Rnr8zAkZpaub0UNq8lUH4LoAhG6osb2X
         a+wlW+7FJ+8tag8t0SesgC7Y8BMP6LheJ9sRzz/AtFP4MsWtmWcu4b3w0IhfbFd/IKBG
         hJ/W4PzbIyLWWZ4p/kXUAklXMJiN++deYsFWf6vuA+NxzOEoBW2XMmo54/gcs5uH76G3
         6ilg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744892945; x=1745497745;
        h=content-transfer-encoding:cc:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=gstty6uiv8V52+U4oFg1laBsa0dh1V5FdpOlSDxRmv4=;
        b=nifD74XgzAktT0ZDpQ7RlAZQjK4R4Ng+GtJd5Ky2Lgm/FosaeQkDyPt05jJLHr29u/
         XEwaukosLi2yoqEYbOAYMcjpEWyl0YdVKUZ4cnlKC4DTq0wM1qlpFJqSRQNtPcyveUot
         6YckmRg+pxE732SkHiAtHg9N4jrveV6FwuZP/HOBGkxgaVdHLZP8RumPk2rjTfTd42bq
         BBe5tLGetwEL/tETee3cvYfoImu3Rr5qUjpCVePCKNtaqmbLJ/953v5EEYlkZt7FIxPZ
         CDyvvPKlEDi0i6fsncx5fbTStT7kjhGlH2ubOz3KZ9sAkGWApY7+RiAtW+aFgZux0KGI
         ALEA==
X-Gm-Message-State: AOJu0YwLdzRlPKupslWbUpoaHYMaJh706vM1Ix37gpDSJdBm7BJRupLP
	odsGZEB2w6jjm65Bft9Me0+2yF7Cvv8lkyOEst/4IXkoW4va6qi5qJYm1Gubrtxg+4fX6orNXiB
	i
X-Gm-Gg: ASbGncsRYpxATKcrK8iIbD0Nnlk1B08o1099OPmE2DNHfks39cdnMR7A1nDIxPAJzW0
	MxcM0bS1wTXrv99QTRDvuZ+ktVdAui6foZ4CLseXbfODixWjb0hjP2rtPaTtj/D1i+fWbn1bsCG
	wMIlL6fkcbiScnV44bt6CwiS28G997R6CUeiNL9HK+kgyD1YTfGL0M7Jmj9C4HkBsrh2Buih8Ad
	/zq27UORjnjQCyUB4XVv8u/2NGDwFclVUIOy2DxzkkPffE2We6fyuiTCHnzDHWXfxQfFjgYr80a
	vyB4wmpeqfCbibZTVYBc4go/dK/dWgSrbFf2Cg==
X-Google-Smtp-Source: AGHT+IFKG9ev1w5c16K9Ne3asz7TyWPW5AzNR8t/rHOqwLUWce/C9IYtELevGoBcDmHZc5kOTL2ACg==
X-Received: by 2002:a05:6e02:160f:b0:3d3:fcff:edae with SMTP id e9e14a558f8ab-3d815afbdadmr55522885ab.3.1744892945678;
        Thu, 17 Apr 2025 05:29:05 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d7dba958d2sm41906095ab.31.2025.04.17.05.29.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Apr 2025 05:29:05 -0700 (PDT)
Message-ID: <9c129aed-6e07-4f23-934b-951d3585cd5a@kernel.dk>
Date: Thu, 17 Apr 2025 06:29:04 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: io-uring <io-uring@vger.kernel.org>
From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring/rsrc: ensure segments counts are correct on kbuf
 buffers
Cc: Pavel Begunkov <asml.silence@gmail.com>,
 Nitesh Shetty <nj.shetty@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

kbuf imports have the front offset adjusted and segments removed, but
the tail segments are still included in the segment count that gets
passed in the iov_iter. As the segments aren't necessarily all the
same size, move importing to a separate helper and iterate the
mapped length to get an exact count.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

Same as the one I sent out yesterday, but just for the kbuf part.

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 4099b8225670..04e19689d2f3 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1032,6 +1032,26 @@ static int validate_fixed_range(u64 buf_addr, size_t len,
 	return 0;
 }
 
+static int io_import_kbuf(int ddir, struct iov_iter *iter,
+			  struct io_mapped_ubuf *imu, size_t len, size_t offset)
+{
+	size_t count = len + offset;
+
+	iov_iter_bvec(iter, ddir, imu->bvec, imu->nr_bvecs, count);
+	iov_iter_advance(iter, offset);
+
+	if (count < imu->len) {
+		const struct bio_vec *bvec = iter->bvec;
+
+		while (len > bvec->bv_len) {
+			len -= bvec->bv_len;
+			bvec++;
+		}
+		iter->nr_segs = 1 + bvec - iter->bvec;
+	}
+	return 0;
+}
+
 static int io_import_fixed(int ddir, struct iov_iter *iter,
 			   struct io_mapped_ubuf *imu,
 			   u64 buf_addr, size_t len)
@@ -1052,11 +1072,8 @@ static int io_import_fixed(int ddir, struct iov_iter *iter,
 
 	offset = buf_addr - imu->ubuf;
 
-	if (imu->is_kbuf) {
-		iov_iter_bvec(iter, ddir, imu->bvec, imu->nr_bvecs, offset + len);
-		iov_iter_advance(iter, offset);
-		return 0;
-	}
+	if (imu->is_kbuf)
+		return io_import_kbuf(ddir, iter, imu, len, offset);
 
 	/*
 	 * Don't use iov_iter_advance() here, as it's really slow for

-- 
Jens Axboe


