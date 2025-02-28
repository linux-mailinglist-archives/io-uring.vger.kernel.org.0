Return-Path: <io-uring+bounces-6864-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7AFF5A4A5EF
	for <lists+io-uring@lfdr.de>; Fri, 28 Feb 2025 23:31:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7BB381773E4
	for <lists+io-uring@lfdr.de>; Fri, 28 Feb 2025 22:31:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3FFB1DE8AB;
	Fri, 28 Feb 2025 22:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="ZqvA/69B"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f100.google.com (mail-io1-f100.google.com [209.85.166.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B51431BC9EE
	for <io-uring@vger.kernel.org>; Fri, 28 Feb 2025 22:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740781894; cv=none; b=a76kKr8i9ftNc3TKjmMzHYOEtt0hwRRDTuEkV1TYyBBlT+tNacSRYh+KwSUfUSDXmdZE4T+p+MNAzTq1O0RYzRLSnA+aWRhxx7cj1K21PWkNvxGkTgmKqDHWPEq1j44VhDcTW22400Qn0v8Zs6cB/ZJU34AROSInG8xMV4aW5bQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740781894; c=relaxed/simple;
	bh=doQuaoN9u7OELR40CVjM5Wacan+eeA7kQjC+1Mvrbao=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=u+40YUgobvrdJtrHYQS6WsVfueNrYi49l6NpofEG4vqGa8BFVi96+Ubv65xhHWCTxN4CSuah15935W5TMT5IgqIKFUr0Dhi1PvVRk32Mfrz9eqgDIUGbBwS65X7M5FKAbwaT4cIxG2f+66hc2ZBFwyl4zRmZKmPAt0jr9BmQb/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=ZqvA/69B; arc=none smtp.client-ip=209.85.166.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-io1-f100.google.com with SMTP id ca18e2360f4ac-855a8275737so8815439f.2
        for <io-uring@vger.kernel.org>; Fri, 28 Feb 2025 14:31:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1740781890; x=1741386690; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+2T1gHynTazYnP2hzcbY2sNMNgTOV0NNTMpa17eKN4U=;
        b=ZqvA/69BIeuGmkQ2dhlqb5mb0DpkRhOvF40MHhBd/xFHRLoKsJar6wuYLdKjhlr/be
         /fUc96MHmEmvUTnFy5yhGv9StY2PaNrQ23P0/5FM/M6uprBBSBfgI8wk1YtVC+/IEMWL
         tvwEj65CKNaYgVoc/i/uj3DxLrFt60iIZLl6DDmwFjBlhRa1wGPbJcEjJSLHh1x1VGzE
         HBtSdvEFuzEsG1uo4GcvDPt3mS3Vm1njBRnzV6iaj23/7ekvl9qUeSTShe0X6lfbVfLO
         HPwlsiLVLjaM9tXcd3wdBJX5JHpwh1FMVusrJ7/sQ+6+kim4/VVnjyFA0Ql9HZz8Qjd7
         wuMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740781890; x=1741386690;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+2T1gHynTazYnP2hzcbY2sNMNgTOV0NNTMpa17eKN4U=;
        b=E2IgIiRt8CT/x6D8dsD3tn4Ut5/vxiUwmAokM8vs5MfrRGa9ZxCxQBIVHe2NXzT7LZ
         qsOq95rHJWJPqwe5DYR691wSRdwEIC2k0q0Xf0IiOiymfIMgZA+n9VMJFdNebolu5n26
         ZljenfXtCzM6V1jYzXVIhSOHG5BQetwsBy1u/J8CSE+Yth6Oakr14Z6Y9F4Dq+etJ7hR
         C69hHLkUANWbSjPEbpdP+FOBoFTy9KD6IolFKw+Yah6WKuS72asxnx/xG8rXf4z6Oz2W
         2vSvQp5Chsej/Gn0kW3Z2b8No+WK1dSzz4Lp+naUK0aotLNWWRsHkKrnmaY9oa3Qhgpy
         5irw==
X-Forwarded-Encrypted: i=1; AJvYcCXbwnfbQ7ATtJ+AivShsMru08W0yQu8kpXxCkR/umvWhxleAHqkCfdFJfiQ8tZ4WNy3B43TcGVemg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxqG91JiBVamLKbaTbGBYwing6deB4bZl+5xVyHEp9RaKcTpcr9
	+LHUCpPIEIM7d7A4gKMeVLZ5YSgXC5wTei9rKGIYMeFsobywU3a61R4R7kh9mu8yHCYpmqCroFk
	EY74pHDXI0gwp+rN4DaTDs9ww0+XirxMW
X-Gm-Gg: ASbGncsYvz0fY/xhiWR/DLtWstvZDOwecw2uuzI3Soe7EyWVWKiFAVVjTTAsRKTzNMa
	LH1aZvYvmF5YNYppD6T42M2EsizNnge1z75fu6b4t20KfqGJQSHl2sQKND0Wq5cxcCSVF4QtGX6
	iiw07saqLYOTz57A8wJF4SNdLi+xAjz5x1qKp7vt7SFaXAjgsifRsEo7sLkZLwwqtktmNC/lTQL
	+jLOF7W8icSN+oSyWex4MzFQIdL0aRcEy0O4AnmSK/L+euFDP5NDEcIPaMcwHzs20m6CJcyd4tG
	QOH5oNA2upcFXYNvV5++BKuduwsG/rlLtDD+iM7zCnpVZqXp
X-Google-Smtp-Source: AGHT+IGlrTCdO8WZvksVSjTwN72/t2bqEU9x93lBJ54pXZl2ReyCbDq7nfRgjsOsu7MOcrYaXpdeJCTb1pEd
X-Received: by 2002:a05:6602:1490:b0:855:c259:70e1 with SMTP id ca18e2360f4ac-85881df0152mr149012839f.0.1740781890680;
        Fri, 28 Feb 2025 14:31:30 -0800 (PST)
Received: from c7-smtp-2023.dev.purestorage.com ([208.88.159.129])
        by smtp-relay.gmail.com with ESMTPS id ca18e2360f4ac-85875116281sm25664539f.7.2025.02.28.14.31.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2025 14:31:30 -0800 (PST)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.7.70.37])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id CEAC934028F;
	Fri, 28 Feb 2025 15:31:29 -0700 (MST)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id BA052E419FF; Fri, 28 Feb 2025 15:30:59 -0700 (MST)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Cc: Caleb Sander Mateos <csander@purestorage.com>,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] io_uring/rsrc: use rq_data_dir() to compute bvec dir
Date: Fri, 28 Feb 2025 15:30:56 -0700
Message-ID: <20250228223057.615284-1-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The macro rq_data_dir() already computes a request's data direction.
Use it in place of the if-else to set imu->dir.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
---
 io_uring/rsrc.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 45bfb37bca1e..3107a03d56b8 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -957,15 +957,11 @@ int io_buffer_register_bvec(struct io_uring_cmd *cmd, struct request *rq,
 	imu->nr_bvecs = nr_bvecs;
 	refcount_set(&imu->refs, 1);
 	imu->release = release;
 	imu->priv = rq;
 	imu->is_kbuf = true;
-
-	if (op_is_write(req_op(rq)))
-		imu->dir = IO_IMU_SOURCE;
-	else
-		imu->dir = IO_IMU_DEST;
+	imu->dir = 1 << rq_data_dir(rq);
 
 	bvec = imu->bvec;
 	rq_for_each_bvec(bv, rq, rq_iter)
 		*bvec++ = bv;
 
-- 
2.45.2


