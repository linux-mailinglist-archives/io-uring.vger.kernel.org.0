Return-Path: <io-uring+bounces-7799-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D1669AA5E33
	for <lists+io-uring@lfdr.de>; Thu,  1 May 2025 14:17:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 835A04C380D
	for <lists+io-uring@lfdr.de>; Thu,  1 May 2025 12:17:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B26522CBF8;
	Thu,  1 May 2025 12:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YxwfOHaq"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A52B229B17;
	Thu,  1 May 2025 12:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746101800; cv=none; b=L0khSGHuBGHJ0i0PyBC6KkrG24hpUp5pAFjKM5NNy3lqUaHOk/jTAoHCdFiJHrp4dUmjDByJdrzN6b8vFy9Qkf5KdpuaNaplhbDWqOJ6MQW91urfh8GI+RqysaB35u0LhX1/bB+qb16SFuMdiiFQoDT2nv4UdopKy4DNqbJT2Xs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746101800; c=relaxed/simple;
	bh=XETRCyGjVwldo0JcdWwb33vQD6L+7zUlVC1b74b8yyE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gFIBy8t/mz+2v9kW502b206VyTjUm7G/93ifzJiy+tL7j6LBmLJWjxT0AZeHqy0w4Nya5Pgc++RhY/Pw1NUQL+wgz4J0YMArtsnlQxGhs2uKy/i56gZ+XdOUnUH2p0fGfSeCiE7HLXkR+tQcEW50deTI7y7ljivAoPT1VAaD+wA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YxwfOHaq; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-5e8be1c6ff8so1379042a12.1;
        Thu, 01 May 2025 05:16:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746101796; x=1746706596; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5bEmCDwp8NKaGJSanlLrqTeYFh0vjfNxG1dgRZZIaZc=;
        b=YxwfOHaqmJVdP1cHREg17y1S/v9meMwqHQEzx1rgyFLeMM9hy9zUj7PEXqWbCoHCr9
         NFdTGwJUBHZcLIFlBybYkn1yjn4CECSAX0B3WdhtlVxsCz0Rh086ssfhIfsVgUiMIRLA
         6Y02HMp01sb795w/BeZiNLazKjXb+u/ZpBgsLJAH4hoTXz/zyTT2/aaE2tFvW3nNyWES
         UqKDeDAQQS+IEI+HDrFF5jAcIjQEzFqh+iSD/dpmFoHq4HEAtORGtelDW7UUL8svjC48
         7K7aCTtzQxPWXSfTG2HI6iIqZ4Iz5iWTAjCeTa9XyzoK00rvZ051qNPmadFYSZkZRhpd
         kSUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746101796; x=1746706596;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5bEmCDwp8NKaGJSanlLrqTeYFh0vjfNxG1dgRZZIaZc=;
        b=S61ZP3XKzCai3ctbeV0qc//GtpYwA1p06U55UN78HELIDrgUn3kFzizBOxQsYUBOFM
         Zc5c79EQe8LP4LhXjJ6FvB4ZXqXHiZtIPl0/Og1rDipsd2V6ab7KKalTugImenxA+eUz
         gCGg1MGz6PbTpAyl964JaowpWfmKX/NEIP5knU6VcMyNO8ZG7TFvGX1rrQ3/Uqk7DetA
         Uiw2rjm3CrD3UH+5yk4J2q3tf3FgWAVfZpian3KaVz86odGYdTuYIJr289IOSPhzNjK1
         XG8pL/+SAE6nrTz1+4BsvkNUwta+bQfYHhTcRkNVsdrR2SFXk3wFaaAHIwMe2+Y1nR4D
         g4oQ==
X-Forwarded-Encrypted: i=1; AJvYcCWp2lrsAIh82XdP854Paoi1O3XHc8CePOxXYN/5VsE+Rx4k7Pe1L2NdFpPpuvWvHqGXnZFLj5s=@vger.kernel.org
X-Gm-Message-State: AOJu0YwdqqxbZalvhdNUP5TOIYUb34y6i9+KCBIMyEUHlGBoYCRYmD6V
	QKVHcjSLRSSFYrT1u3WEIEqu9BbEX+WVQGvLW9k1md5BPa3AlMaaTAWHcQ==
X-Gm-Gg: ASbGncuaeVW5ik+AS2VgYMBj4poHzluUYzVW0XDcK1QEsz4lIyRIN/tOMmHoHeV+IPn
	DHNbU2KI2NlUumY7ZS9wyc3ncQOTmG9YXrDtbKq8ZrRJh8vy9bZHE7/o26gYVHJ9DP7An0n3hbJ
	FlACDfbM9WNrEceLJnyi3D1nceJtxgR2EIYi/U1LFdveyc49WQqrh0nfhuOJD15uoV+TIg+Dhvp
	+SmTqaqTR7CQkDWI834JrtHV+S3ftYNplCE4UFIF3hfa1BL+xA6Fuw8Joa6PmV246C5/alU2yo7
	tLviFwplGS+dxWqpNOy2vvPP2dUr23Wirvg=
X-Google-Smtp-Source: AGHT+IHGNA1C0YX6ade8/n1LvsIxnh/N0nHXuCcs0IliZO7yCFk/zmmcYyEJnhr56ojsskYpiLCpNA==
X-Received: by 2002:a05:6402:518d:b0:5f7:f55a:e5c8 with SMTP id 4fb4d7f45d1cf-5f91942992amr1713536a12.21.1746101796119;
        Thu, 01 May 2025 05:16:36 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:9c32])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5f930010655sm346146a12.73.2025.05.01.05.16.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 May 2025 05:16:35 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	David Wei <dw@davidwei.uk>,
	netdev@vger.kernel.org,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Pedro Tammela <pctammela@mojatatu.com>,
	Victor Nogueira <victor@mojatatu.com>
Subject: [PATCH io_uring 1/5] io_uring/zcrx: improve area validation
Date: Thu,  1 May 2025 13:17:14 +0100
Message-ID: <0b3b735391a0a8f8971bf0121c19765131fddd3b.1746097431.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1746097431.git.asml.silence@gmail.com>
References: <cover.1746097431.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

dmabuf backed area will be taking an offset instead of addresses, and
io_buffer_validate() is not flexible enough to facilitate it. It also
takes an iovec, which may truncate the u64 length zcrx takes. Add a new
helper function for validation.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/rsrc.c | 27 +++++++++++++++------------
 io_uring/rsrc.h |  2 +-
 io_uring/zcrx.c |  7 +++----
 3 files changed, 19 insertions(+), 17 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index b4c5f3ee8855..1657d775c8ba 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -80,10 +80,21 @@ static int io_account_mem(struct io_ring_ctx *ctx, unsigned long nr_pages)
 	return 0;
 }
 
-int io_buffer_validate(struct iovec *iov)
+int io_validate_user_buf_range(u64 uaddr, u64 ulen)
 {
-	unsigned long tmp, acct_len = iov->iov_len + (PAGE_SIZE - 1);
+	unsigned long tmp, base = (unsigned long)uaddr;
+	unsigned long acct_len = (unsigned long)PAGE_ALIGN(ulen);
 
+	/* arbitrary limit, but we need something */
+	if (ulen > SZ_1G || !ulen)
+		return -EFAULT;
+	if (check_add_overflow(base, acct_len, &tmp))
+		return -EOVERFLOW;
+	return 0;
+}
+
+static int io_buffer_validate(struct iovec *iov)
+{
 	/*
 	 * Don't impose further limits on the size and buffer
 	 * constraints here, we'll -EINVAL later when IO is
@@ -91,17 +102,9 @@ int io_buffer_validate(struct iovec *iov)
 	 */
 	if (!iov->iov_base)
 		return iov->iov_len ? -EFAULT : 0;
-	if (!iov->iov_len)
-		return -EFAULT;
-
-	/* arbitrary limit, but we need something */
-	if (iov->iov_len > SZ_1G)
-		return -EFAULT;
 
-	if (check_add_overflow((unsigned long)iov->iov_base, acct_len, &tmp))
-		return -EOVERFLOW;
-
-	return 0;
+	return io_validate_user_buf_range((unsigned long)iov->iov_base,
+					  iov->iov_len);
 }
 
 static void io_release_ubuf(void *priv)
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index 6008ad2e6d9e..2818aa0d0472 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -83,7 +83,7 @@ int io_register_rsrc_update(struct io_ring_ctx *ctx, void __user *arg,
 			    unsigned size, unsigned type);
 int io_register_rsrc(struct io_ring_ctx *ctx, void __user *arg,
 			unsigned int size, unsigned int type);
-int io_buffer_validate(struct iovec *iov);
+int io_validate_user_buf_range(u64 uaddr, u64 ulen);
 
 bool io_check_coalesce_buffer(struct page **page_array, int nr_pages,
 			      struct io_imu_folio_data *data);
diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 22f420d6fbb9..5e918587fdc5 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -209,7 +209,6 @@ static int io_zcrx_create_area(struct io_zcrx_ifq *ifq,
 {
 	struct io_zcrx_area *area;
 	int i, ret, nr_pages, nr_iovs;
-	struct iovec iov;
 
 	if (area_reg->flags || area_reg->rq_area_token)
 		return -EINVAL;
@@ -218,11 +217,11 @@ static int io_zcrx_create_area(struct io_zcrx_ifq *ifq,
 	if (area_reg->addr & ~PAGE_MASK || area_reg->len & ~PAGE_MASK)
 		return -EINVAL;
 
-	iov.iov_base = u64_to_user_ptr(area_reg->addr);
-	iov.iov_len = area_reg->len;
-	ret = io_buffer_validate(&iov);
+	ret = io_validate_user_buf_range(area_reg->addr, area_reg->len);
 	if (ret)
 		return ret;
+	if (!area_reg->addr)
+		return -EFAULT;
 
 	ret = -ENOMEM;
 	area = kzalloc(sizeof(*area), GFP_KERNEL);
-- 
2.48.1


