Return-Path: <io-uring+bounces-9166-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id ABEF8B2FC85
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 16:28:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A8BDA1D218E9
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 14:21:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B04B214A97;
	Thu, 21 Aug 2025 14:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="kNtXqonV"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f181.google.com (mail-il1-f181.google.com [209.85.166.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC411279DB6
	for <io-uring@vger.kernel.org>; Thu, 21 Aug 2025 14:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755786017; cv=none; b=d6wyTcXk2yvxqPLSy8bBE/33a9wd7pA8mOjBcpX9osoG/G5kRclmH6HzZutFV89viIzZlLK3k/RQHN9XLwKOjgrhKK76rzkDCPZiVGxvxPFLpB5rwdJGcWol8sUy+PFYaiDPSrPViXZ0s5rq62XgGk6CMD32S4PgycSgArvKf+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755786017; c=relaxed/simple;
	bh=fWKgL6VoaSyFUMidal+T+j/25nnV3b7zKYZx2WTuao8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N9/llw228ngVih7cI8z+oXeiyWRyFWumTqIsdHTB5E1To4yQ6QDoqM/f5+O8IgdF2tr7lpyIhW+loQ6/FPnk+xB29uIEQcztK/jSA7412C8DY31xYucHE6NWemKItbx5AihDg/3250o66qX0a8I+z/FHi8aVqBZHKCHyJqrQypU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=kNtXqonV; arc=none smtp.client-ip=209.85.166.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f181.google.com with SMTP id e9e14a558f8ab-3e721083e99so2755725ab.3
        for <io-uring@vger.kernel.org>; Thu, 21 Aug 2025 07:20:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1755786014; x=1756390814; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KFPWpzG1AUv8OCk64kABjKhF1scMWkPhH3E9mkWcvq4=;
        b=kNtXqonVI2CueCiQNGXcXg7MY1DbfVGOmj1mRUHMpHYXmVVYBxFTij+VXErlbNAcT/
         8eXrX0vhHen4IP5jIj3yrjruLUbi4UMlQiMOQwF/sMlQNGksQbfeFscEcMoUhuZ1bRLd
         46D17eJcxjbD73mtO5/VCub4McZT9I2F40c5iO3z/cBUdxetmf5MtU5FWfD1X5/ZJI3f
         GLirTV3Izq2iiTnLF/GB3YkFuMn9Tduegrq/+s/dBgGzFINJ6F4Q/AoDCYtcR8MnYm29
         TfNg3DQ/mPYlUmBMNnjkTwyRLZk3BtK52h1/iLwgbZFwyFv1Ztg5PupfqEcXwEFYjDNr
         ZGZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755786014; x=1756390814;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KFPWpzG1AUv8OCk64kABjKhF1scMWkPhH3E9mkWcvq4=;
        b=KBfu6KkgGte0PWKgJmJUAGulEME/wuPoQR+q712z5bmQ3Pg0ssNc3BEM8dReJ5uCK2
         K89elKU2yHQzqq5nfIMxJ3+Qbdn24ZnzLC+GUHIPa2OFF9Orf2Q2XIpZ1RUWhKpPL0GI
         b/CHs/srUiTPIL1kBKdcm5cIJLxxUu7DIuOu48Wv/nI25Kj7dHVp+9IDLjcOrFUpZU9y
         RRMkKbFgHI5TBYxu3loYPAduDz2LYQ01gx/9lAisgUNfkoWoc/obAdo1u3bPdqgWe64O
         84PUtFrmvk7fRTCObnupleRxCMBa7+236748AIfjYr6M0E15f2opU2qQWWONzlc0uGFx
         CypQ==
X-Gm-Message-State: AOJu0YzUG63zpUASMeLj2dGEcXNlMDQImmgWkAx4cTRG2D8WrJ5PNR8Q
	Ji2EypkkCC+MjzpoESckof0Y3SemrWjZFo4G+OkDdmin5SOKulGstRZsq4lyxnGUWMMgH/9PCKn
	YAmmV
X-Gm-Gg: ASbGncsdw8b/LpLBL9qhtCXeKj+karqlr2orUqCIDUumsvB342wad5B+vK7fY02jV+F
	sIQ6gmRXc5mH8brHa5umvLnVnLSORbJR/L0XSmm1rplGyiltvF6VWtxiTy/grnNMAaACKsuaAmg
	afdJLXjT/QxxaI6KpMlLpP3tOvvxwBe3OS6wkt2I37eQGWICfVLcugl+tJODWMzgujxWEbgY93Z
	8rDW3gq+0xkkrzh9QNnJg/5UWP832694b8l+FRU1/64xCv7hu6WBKBEsaLw+X791Rspdz8RFWnJ
	zqUM0sDJgugKRWq9+zEBFQ48cGaYa+D1njXmK+goAhdJam2Lrgl27bBsLULkwvQbWUNHhvl9XLR
	qCI5o/m1JpKNw8VHn
X-Google-Smtp-Source: AGHT+IF/Tn7qsT/1Jxe49adJo96DalDTdOWc8B3fEyNHpfqKbFemI5JWXWrrjJ0t7rZTxka02zfetg==
X-Received: by 2002:a05:6e02:1aa9:b0:3e5:66a6:a46a with SMTP id e9e14a558f8ab-3e6d7571f81mr36270865ab.17.1755786014322;
        Thu, 21 Aug 2025 07:20:14 -0700 (PDT)
Received: from m2max ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3e57e58c1basm73196595ab.5.2025.08.21.07.20.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Aug 2025 07:20:11 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 8/8] io_uring/zcrx: add support for IORING_SETUP_CQE_MIXED
Date: Thu, 21 Aug 2025 08:18:08 -0600
Message-ID: <20250821141957.680570-9-axboe@kernel.dk>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250821141957.680570-1-axboe@kernel.dk>
References: <20250821141957.680570-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

zcrx currently requires the ring to be set up with fixed 32b CQEs,
allow it to use IORING_SETUP_CQE_MIXED as well.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 Documentation/networking/iou-zcrx.rst | 2 +-
 io_uring/zcrx.c                       | 5 +++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/Documentation/networking/iou-zcrx.rst b/Documentation/networking/iou-zcrx.rst
index 0127319b30bb..54a72e172bdc 100644
--- a/Documentation/networking/iou-zcrx.rst
+++ b/Documentation/networking/iou-zcrx.rst
@@ -75,7 +75,7 @@ Create an io_uring instance with the following required setup flags::
 
   IORING_SETUP_SINGLE_ISSUER
   IORING_SETUP_DEFER_TASKRUN
-  IORING_SETUP_CQE32
+  IORING_SETUP_CQE32 or IORING_SETUP_CQE_MIXED
 
 Create memory area
 ------------------
diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index e5ff49f3425e..f1da852c496b 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -554,8 +554,9 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 		return -EPERM;
 
 	/* mandatory io_uring features for zc rx */
-	if (!(ctx->flags & IORING_SETUP_DEFER_TASKRUN &&
-	      ctx->flags & IORING_SETUP_CQE32))
+	if (!(ctx->flags & IORING_SETUP_DEFER_TASKRUN))
+		return -EINVAL;
+	if (!(ctx->flags & (IORING_SETUP_CQE32|IORING_SETUP_CQE_MIXED)))
 		return -EINVAL;
 	if (copy_from_user(&reg, arg, sizeof(reg)))
 		return -EFAULT;
-- 
2.50.1


