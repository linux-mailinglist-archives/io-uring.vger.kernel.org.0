Return-Path: <io-uring+bounces-6129-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BC5FA1C4A8
	for <lists+io-uring@lfdr.de>; Sat, 25 Jan 2025 18:38:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3CED1188419D
	for <lists+io-uring@lfdr.de>; Sat, 25 Jan 2025 17:38:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3585143172;
	Sat, 25 Jan 2025 17:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=furiosa-ai.20230601.gappssmtp.com header.i=@furiosa-ai.20230601.gappssmtp.com header.b="owKr4QKa"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80D35C148
	for <io-uring@vger.kernel.org>; Sat, 25 Jan 2025 17:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737826701; cv=none; b=BRGkF4CQCUhBBxvnfLjiw5IzA2ydSLgKT85MbI+fHjLNmA/M173QuEC2mXSjIhqAaVw0vLbdpS9eirIjFI5PO6rv8ma9q6fEtdGUi48jTm1casz6OxyrEX/KeVOiAfXdgDGENfgMhtIwgfLG9GXZ7gZ/6Q5CJ7XBlrdnmHrf0xI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737826701; c=relaxed/simple;
	bh=6b7ssZKKJ6hYhoPw146ZvayMv6hwrJddYsaH8IowWuA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=exR/J24a7xANPSCt4SXkpkUNr51sfkQJ/IR5Oz0iDO6zgh23BVaEJCFmT51L7eicev18d2ffJ95xI5CoSY6s6UZdOJLsPw5GNRKeE6zWbouKdg3fsbf+I0Apycxe2LDMSDDDYDcRJWGCCzmsPZefr88zxxbxZbzukUleCRez6xg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=furiosa.ai; spf=none smtp.mailfrom=furiosa.ai; dkim=pass (2048-bit key) header.d=furiosa-ai.20230601.gappssmtp.com header.i=@furiosa-ai.20230601.gappssmtp.com header.b=owKr4QKa; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=furiosa.ai
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=furiosa.ai
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-216395e151bso40844765ad.0
        for <io-uring@vger.kernel.org>; Sat, 25 Jan 2025 09:38:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=furiosa-ai.20230601.gappssmtp.com; s=20230601; t=1737826698; x=1738431498; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=6F/gTHh55Ys38/sqUvZJMWi081Q0jJW/jiwzM4qVST4=;
        b=owKr4QKax5/3OfdiDbFdf5SAmxQQpQ2o5Kni4XV3SSJIiWTMxWIspPWHl+K3lQb0Qs
         hdRksP3lsyCrLOM8HEhjzS/BvmiRgbRo/pMopK+9yfF90yUHSW4iHyOXNHdSvdZwZL3t
         TAf0NrlRfiHZnjx3Yfvv5oY4UyAKbCbC/eIWisLR7GtCkpBC9q+/I88vfTJ8eXQ+vseq
         +4BWGmsI895p9HjWjg+4XzHRhgizRAjZ5Vep820q03tC9QYsVy+8z4F/0I79IhGuIYSK
         ni5AF0hmZN3fbAxlDFcDzinvd+zJtUsZCS6y3Ozg88WqzV5zX+o7RidJT2Eg1GcuzawU
         IFBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737826698; x=1738431498;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6F/gTHh55Ys38/sqUvZJMWi081Q0jJW/jiwzM4qVST4=;
        b=Y8yuRy25UbNzA6egTXysd7nuj+y9k6FjyW2SEWpiCL7S26Zxw4B0Jhnqg57aoUULLV
         i5qNPYsCiwAUnvA3yLrK0Gp0ezv37dOw8vpOsLq1GlcRbb8kG2JdCkjQknn7/1wpY5PP
         GicL6rV4ab4zx+dJTmz5Hc2ABVljyVqqljE4NwuX3Ci7E1Y8ctbp0SyDbm2ldmSRli9P
         l16WTB2IPunNRJxVdbJ73A4ujA9cX6/9W/1bzDnkCDjxXoZu7yb/RPHPtg2SWgCmlHUr
         gMx5tXtOI1dy3i41EwcYPUKVizgnYOA8R+mUOO+ono+EvQZL8MdkMriQQhW684FRyyRI
         9EkQ==
X-Gm-Message-State: AOJu0YzyyWGC/pbgNGes6S3c0+TVeXPJ2kPUPz1R0svnUDOl1sbm54sG
	SEYQmop/YZhHLQxLFDHeBMpC2CExvuAJX9tAt5vOr/lqM9blADsd/VCT7sGab4w+4+h1N8BH1Qs
	uv28=
X-Gm-Gg: ASbGnctFk81vKAJ/xaqmntVu5gCQReMyS3rxTG60xY3lio8B5eKUfzAYXcbbKDVbnyW
	gWhbq968no+prx65A7xyh+U8uanAcpukuaqcuWcWoEraR2ActxLYjwd/l0OM0s4ozdkfy+T2QMH
	lbIXTOz+E9lJGQEsaQYHmI2q8iEVL7Jmqz6U4YRtpxQv3FR75quQv8Ylp88wWkAeQJ0Iu8HY1FD
	MnIG88sdpkr0Q4IvMyBw4al822gFKdLi5345oSBhDv2ArPA/GX3O+HjWtHDiSODSSE66PITbEMB
	96iTMwAPYylxCHTVXmQgKwZ7Quza/eUHcDwIV8hItAc=
X-Google-Smtp-Source: AGHT+IFJ+YgziyJ8+hNLPo2JiFOKMpe6nj9ncEWZVcza1d+KKoa7ZQdlt9YXKt4pFyGcoSYh6Mnrqg==
X-Received: by 2002:a05:6a21:9210:b0:1e1:a7a1:22a9 with SMTP id adf61e73a8af0-1eb76cf0566mr11305864637.16.1737826698452;
        Sat, 25 Jan 2025 09:38:18 -0800 (PST)
Received: from sidong.sidong.yang.office.furiosa.vpn ([175.195.128.78])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-ac48ff4998dsm3481880a12.32.2025.01.25.09.38.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Jan 2025 09:38:17 -0800 (PST)
From: Sidong Yang <sidong.yang@furiosa.ai>
To: io-uring <io-uring@vger.kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	lizetao <lizetao1@huawei.com>
Cc: Sidong Yang <sidong.yang@furiosa.ai>
Subject: [PATCH v3] io_uring/futex: Factor out common free logic into io_free_ifd()
Date: Sat, 25 Jan 2025 15:56:07 +0000
Message-ID: <20250125155608.9784-1-sidong.yang@furiosa.ai>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch introduces io_free_ifd() that try to cache or free
io_futex_data. It could be used for completion. It also could be used
for error path in io_futex_wait(). Old code just release the ifd but it
could be cached.

Signed-off-by: Sidong Yang <sidong.yang@furiosa.ai>
---
v2: use io_free_ifd() for completion
v3: format, inline, remove reduntant init.
---
 io_uring/futex.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/io_uring/futex.c b/io_uring/futex.c
index e29662f039e1..dcf57c7f2c68 100644
--- a/io_uring/futex.c
+++ b/io_uring/futex.c
@@ -44,6 +44,12 @@ void io_futex_cache_free(struct io_ring_ctx *ctx)
 	io_alloc_cache_free(&ctx->futex_cache, kfree);
 }
 
+inline static void io_free_ifd(struct io_ring_ctx *ctx, struct io_futex_data *ifd)
+{
+	if (!io_alloc_cache_put(&ctx->futex_cache, ifd))
+		kfree(ifd);
+}
+
 static void __io_futex_complete(struct io_kiocb *req, struct io_tw_state *ts)
 {
 	req->async_data = NULL;
@@ -57,8 +63,7 @@ static void io_futex_complete(struct io_kiocb *req, struct io_tw_state *ts)
 	struct io_ring_ctx *ctx = req->ctx;
 
 	io_tw_lock(ctx, ts);
-	if (!io_alloc_cache_put(&ctx->futex_cache, ifd))
-		kfree(ifd);
+	io_free_ifd(ctx, ifd);
 	__io_futex_complete(req, ts);
 }
 
@@ -321,7 +326,7 @@ int io_futex_wait(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_futex *iof = io_kiocb_to_cmd(req, struct io_futex);
 	struct io_ring_ctx *ctx = req->ctx;
-	struct io_futex_data *ifd = NULL;
+	struct io_futex_data *ifd;
 	struct futex_hash_bucket *hb;
 	int ret;
 
@@ -353,13 +358,13 @@ int io_futex_wait(struct io_kiocb *req, unsigned int issue_flags)
 		return IOU_ISSUE_SKIP_COMPLETE;
 	}
 
+	io_free_ifd(ctx, ifd);
 done_unlock:
 	io_ring_submit_unlock(ctx, issue_flags);
 done:
 	if (ret < 0)
 		req_set_fail(req);
 	io_req_set_res(req, ret, 0);
-	kfree(ifd);
 	return IOU_OK;
 }
 
-- 
2.43.0


