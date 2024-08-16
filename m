Return-Path: <io-uring+bounces-2792-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F868955075
	for <lists+io-uring@lfdr.de>; Fri, 16 Aug 2024 20:01:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B23671C2215E
	for <lists+io-uring@lfdr.de>; Fri, 16 Aug 2024 18:01:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D46F817;
	Fri, 16 Aug 2024 18:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="m8oXL+bl"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B6FA1C2309
	for <io-uring@vger.kernel.org>; Fri, 16 Aug 2024 18:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723831312; cv=none; b=nS+4XKqOqke1pTKSoOhgorCyR5ntQ1buXIVe0JKBakvtNK6b0d4OtT/4VdPYLIsyYjbysOJilbwvUwVjPp+uZxhxhq3uBySSdGbnuQy98El0JGMTnxpiGEEnceDWEYNFvNTlOV4NUoQz0Qy9xLyZGte6y9qxEEtoG6Ie0W/U/JU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723831312; c=relaxed/simple;
	bh=EYKC43c5kzp1VyPdjoRUOK76uMP/FapHfpSEmr/KslA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oH+CKhHoyTtZr0W/eFBZL1FSiadKRPF3j1I966rKC2GfGicyIQkAprJPtgVj9DkFmjBdTrYqGHj3marsgNQGVt3ZX22awoI+RnSZDpRDr9B8lqCoxOwZOzJEJBPL1d7aUs0Wq64qvBhQ6AS0xr/BRC4Dwy6aP4OVs1dqaFQrXa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=m8oXL+bl; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-7105043330aso2050996b3a.0
        for <io-uring@vger.kernel.org>; Fri, 16 Aug 2024 11:01:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1723831310; x=1724436110; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FIwcB7az5fnFRKyT3m48GY3wRI7BR9/OZ/wY5w1Yjm8=;
        b=m8oXL+bl9BGvjOzYDHPnv8ZJ0u5L7z6pmE8l/xyR14bqcNabQ+bXks1p30lMGakhfZ
         BQHUZzZv1EqxSJZbTHlCXeCqA3e71qE0/u6QqFjlNt+53ov7HtDdBK5SLng/Bw4IHswT
         Ctk36knr78K7fZXyV02fhubkpdLHBgO3KvvPU7msBXQ1IrCV8dBYi1NSQCPeWp9jpi2c
         GqbrRM8NX4qOl6UhUFwqSHF1lm/46RdXnAemFxniSl/7D3GZPFcrsVD81KPqGUthgCPG
         cU8dVjvOe31iZXjM8P78+PNStTm8ugMT7NFLBd4F4I2n9pkmf6XuvAEhLOeL8i8Bdqqx
         p2rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723831310; x=1724436110;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FIwcB7az5fnFRKyT3m48GY3wRI7BR9/OZ/wY5w1Yjm8=;
        b=Na4U58+AgcMrGDdHqnnpQJDIApmlSFh2jY1O1/G/oDmIswVHk+LQzcPXviO/uYy8KU
         hu7KlYstaRFqBIkHDPnoUHDP+4r1HhtpKIY/T9Sgx327iDMOWBnVM3X98FoOulhx3pyA
         211qHmdWK4gjIvrj8jboDnTnaTcDArX1jDo3RnACsNgK29/9eIWRvSrjAubALC/86+qz
         bggJQV1KxE/VcIUsf/6zC2GOzRCV+gsFew0esktxefiTiwN90r8fl27fHh1ZxX0xC+zH
         Nq7shGAWQzDNhjB/XWZv2Upj9pglSUUDW1GQaMJ2HQYxNrX0tiTtuANJUeQL+3R7MR47
         Cb2A==
X-Gm-Message-State: AOJu0YxLZsp7mTk/vwchlZIGrxJY6mCCwS7bUlAv4hGYF7lha2LSCv8z
	ucNUgG3n+aqhN7rEoj5VQr1efXKTGZlFu9uvCCq5IOWPG4Q4m+OtI55DPY5445ker68NsrCQsqv
	d
X-Google-Smtp-Source: AGHT+IFbTi4XLrwVukMTdSWWkQ2Bo0Dh/NoNrp0RusPDPVVhtXi9x+pA+Tqq/Q61tCCDVCoIFO0uOw==
X-Received: by 2002:a05:6a21:3a96:b0:1c8:b10d:eaf4 with SMTP id adf61e73a8af0-1c90502ae4dmr4575402637.41.1723831310548;
        Fri, 16 Aug 2024 11:01:50 -0700 (PDT)
Received: from localhost (fwdproxy-prn-042.fbsv.net. [2a03:2880:ff:2a::face:b00c])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7127af3d11esm2869607b3a.217.2024.08.16.11.01.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Aug 2024 11:01:50 -0700 (PDT)
From: David Wei <dw@davidwei.uk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH v1 3/3] io_uring: add IORING_FEAT_IOWAIT_TOGGLE feature flag
Date: Fri, 16 Aug 2024 11:01:45 -0700
Message-ID: <20240816180145.14561-4-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20240816180145.14561-1-dw@davidwei.uk>
References: <20240816180145.14561-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add IORING_FEAT_IOWAIT_TOGGLE and return it in io_uring_create(). This
will be used by liburing to check for this feature.

Signed-off-by: David Wei <dw@davidwei.uk>
---
 include/uapi/linux/io_uring.h | 1 +
 io_uring/io_uring.c           | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 2552d4927511..3a94afa8665e 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -544,6 +544,7 @@ struct io_uring_params {
 #define IORING_FEAT_LINKED_FILE		(1U << 12)
 #define IORING_FEAT_REG_REG_RING	(1U << 13)
 #define IORING_FEAT_RECVSEND_BUNDLE	(1U << 14)
+#define IORING_FEAT_IOWAIT_TOGGLE	(1U << 15)
 
 /*
  * io_uring_register(2) opcodes and arguments
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 9438875e43ea..006bccd55984 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3541,7 +3541,7 @@ static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
 			IORING_FEAT_EXT_ARG | IORING_FEAT_NATIVE_WORKERS |
 			IORING_FEAT_RSRC_TAGS | IORING_FEAT_CQE_SKIP |
 			IORING_FEAT_LINKED_FILE | IORING_FEAT_REG_REG_RING |
-			IORING_FEAT_RECVSEND_BUNDLE;
+			IORING_FEAT_RECVSEND_BUNDLE | IORING_FEAT_IOWAIT_TOGGLE;
 
 	if (copy_to_user(params, p, sizeof(*p))) {
 		ret = -EFAULT;
-- 
2.43.5


