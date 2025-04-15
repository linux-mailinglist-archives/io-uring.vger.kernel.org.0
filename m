Return-Path: <io-uring+bounces-7460-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E804A89EFA
	for <lists+io-uring@lfdr.de>; Tue, 15 Apr 2025 15:08:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5CEC1161DFE
	for <lists+io-uring@lfdr.de>; Tue, 15 Apr 2025 13:08:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FA41296D3D;
	Tue, 15 Apr 2025 13:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MHnRc6YN"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 948DC2957AB
	for <io-uring@vger.kernel.org>; Tue, 15 Apr 2025 13:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744722523; cv=none; b=gqwD2OlGfL/FD2pNlBb7aLrBoqtVl2zk0XVM1QTe0Q9sZoAXZwDv3f3yMqlj7207ee1i2eJ1EiK8db3IK8Lxy4mf7TmxtHLqDtw6GyDQK4B0y6eOmEPzMLhvniD3skgdqbwKkDKm3ApwuYT+Ij9D+FmB8spToX2z/TX/UgVAY60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744722523; c=relaxed/simple;
	bh=z/TwN/ai/7v+E0B/nNAKsZ3a0K4NKx1TowBjKYQvkOE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XnzsdpbP0ZN1uQfyhIHeFnVp7PiwlTL4YPToxiUIoKhRQOkQ25vHJX+hekpsEP4Z1AjlJb4YqXdZIXC8+MuYTsKmnnGHlf9y39oEKgb3YPFPBv8PHHfSCx+U5yaj6mzqeQghwnDPXN6CNKNq3wplU4KdUBnTMZeqzxT0MwcZxyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MHnRc6YN; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-ac6ed4ab410so903088466b.1
        for <io-uring@vger.kernel.org>; Tue, 15 Apr 2025 06:08:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744722518; x=1745327318; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=iPT2GBGRZS79eEIclYQh95KKYsjo2P+GFDqPMMndKmc=;
        b=MHnRc6YNkhSEWW8Vk4s6e34+EsB82l7GoTl4GASM3h3VB5TSsbEBxLP2cY/0arJc19
         tn6/e7YRC6gxct/ac9KtrySJ1ejMiX6DmRknN5smZvC7X6ii7sYl7e0SsR/ifVatjNU/
         HDKVRZzIIPFI9xn1r3iPBHAF0Pyk9F2zMxEne2JlzlNXpTKJMC1B7VoQfPyynux/UKlM
         HUwv16cylYe8fDDSKOqDbgu6lkYCVpBlybbmRH5bvMjG97tCd9Qmv98ZRVZKZc99RqD1
         wvoi4rHmS2keld060i25gvDKDNU1/hOxhOvzdk98ORHbqe+nf85fnHBChWh8HwUCF6OA
         m6bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744722518; x=1745327318;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iPT2GBGRZS79eEIclYQh95KKYsjo2P+GFDqPMMndKmc=;
        b=Gy7o4X9tgy/8jBVmjJ9jup69J86SG0r5D1MFjPsjE8gcYGZg9VMUR9Jiek5rjc9Jrx
         dsWlOmTqVesirPrP8GzEFMBLvhQ94Sa8LHs/dN7z/d/PBSSvFPYot4R1vseucb4r0ECP
         7uTkf4g+DAExH6zrsovkfOZZCzHQSrg3L4ZtPNOx+M8Mt7/Oc5DJYIVQmHich9uedh4w
         qLZqjYMc6eCRjet4rLP6fqep29KtwRY4Octr3q6WQStNnmFcqyAIB04Weaa5L4f3jImu
         Q5SV/bIgWYH4muaAOZpOY6Aa6Ai3Cx1VeZ2Vz+j0dNDlYTsUSUMTLU7T5iqdxnR4mlVE
         WoXQ==
X-Gm-Message-State: AOJu0Yxfvv2RHxX5joK/VqWR8eaif332sl5DCtN4xGK5LqvqgB8gw+A6
	CLVQyMaiRP/zcL+qKEGDX7fPrYvhD7x0Y6ONiKjPwR8mW8cBNcsbJdQpDw==
X-Gm-Gg: ASbGncts9xoh+4OLTOzmzVJfuIfyj/MYky3n7n17pZkmTWO8jVC+2VQ3dT3Ky3kDWOn
	wlijEOZAO10gBffUvB3P6gDn9eTI9+XWfvRxH0RHovAebuQoEBS34afQ2cObNEW/ArgURuJ+YIb
	r8a0nWoAjwfBq+1v/1xpSfPPbfRp6K6TNlgydCf2NhrZiREqKgtmdG92NwTECdyyHvhlYrL9tDW
	fDQLPCv4a+ttVcp3d58Ksn+NaIfjuAQd5EHL9jjyaflO/xYuBAk/eb4To5tnwgBevfoMuj9daft
	KxiVSo2Pkwf/dOmw0n/7Di74
X-Google-Smtp-Source: AGHT+IF/83/OhtZmR+mm96qDsB+DYM7y8Yalh23CUK4VNBrGrsjt57WN4VaPJ2DDRvWGJTQ7LEQbYQ==
X-Received: by 2002:a17:907:d92:b0:abf:3cb2:1c04 with SMTP id a640c23a62f3a-acad3456ba4mr1297172966b.9.1744722515114;
        Tue, 15 Apr 2025 06:08:35 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:9066])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-acaa1ccc157sm1109284266b.142.2025.04.15.06.08.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Apr 2025 06:08:34 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	David Wei <dw@davidwei.uk>
Subject: [PATCH 1/1] io_uring/zcrx: return ifq id to the user
Date: Tue, 15 Apr 2025 14:09:45 +0100
Message-ID: <8714667d370651962f7d1a169032e5f02682a73e.1744722517.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

IORING_OP_RECV_ZC requests take a zcrx object id via sqe::zcrx_ifq_idx,
which binds it to the corresponding if / queue. However, we don't return
that id back to the user. It's fine as currently there can be only one
zcrx and the user assumes that its id should be 0, but as we'll need
multiple zcrx objects in the future let's explicitly pass it back on
registration.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/uapi/linux/io_uring.h | 4 +++-
 io_uring/zcrx.c               | 3 ++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index ed2beb4def3f..8f1fc12bac46 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -1010,7 +1010,9 @@ struct io_uring_zcrx_ifq_reg {
 	__u64	region_ptr; /* struct io_uring_region_desc * */
 
 	struct io_uring_zcrx_offsets offsets;
-	__u64	__resv[4];
+	__u32	zcrx_id;
+	__u32	__resv2;
+	__u64	__resv[3];
 };
 
 #ifdef __cplusplus
diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 0f46e0404c04..d0eccf277a20 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -354,7 +354,8 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 		return -EFAULT;
 	if (copy_from_user(&rd, u64_to_user_ptr(reg.region_ptr), sizeof(rd)))
 		return -EFAULT;
-	if (memchr_inv(&reg.__resv, 0, sizeof(reg.__resv)))
+	if (memchr_inv(&reg.__resv, 0, sizeof(reg.__resv)) ||
+	    reg.__resv2 || reg.zcrx_id)
 		return -EINVAL;
 	if (reg.if_rxq == -1 || !reg.rq_entries || reg.flags)
 		return -EINVAL;
-- 
2.48.1


