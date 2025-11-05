Return-Path: <io-uring+bounces-10381-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EB6AAC3688B
	for <lists+io-uring@lfdr.de>; Wed, 05 Nov 2025 17:00:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9A8371A27238
	for <lists+io-uring@lfdr.de>; Wed,  5 Nov 2025 15:53:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A35A33B6ED;
	Wed,  5 Nov 2025 15:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Yx70Yfx/"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D609533B6D6
	for <io-uring@vger.kernel.org>; Wed,  5 Nov 2025 15:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762357634; cv=none; b=Q9SPeTJ8kZswtyK1bmCyTUf5YSHq4mo9y0K1SoW2TBHc7CBgVHOHP+eil9iM1HpmWhZuTjrfd7449+bQwnPcWR5eYHPhwaRBFBRDiOUR9n37riRI5yV27n1xBy/jA916aoJ8IDxyYeaF0OBbtAN7uDWxXthCJJXcOipl/5DWh7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762357634; c=relaxed/simple;
	bh=GPt32GI8mNRMc9jfigegryUwC5Qt3p4fOL62AdYyaGo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Nx8RetP0p269i0KmY5Poi3mscmw8/whNqDQaYE8P9WxqcaUSmx/1/1pgJp2PPVrBtggqJckA/3yhc5zthhE58yKizOT9aY3W48hNHf0oqCet+2mU4dhnMK94bGtrD95TNGjzV6SANTaHY0r5kSaOisAGxzY3R2eMs0zjTT8rMdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Yx70Yfx/; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-429c4c65485so5523053f8f.0
        for <io-uring@vger.kernel.org>; Wed, 05 Nov 2025 07:47:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762357629; x=1762962429; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=eHpSaNKeWzfxE7MXB+hzl3rXaEMpclifomHLiL1sx88=;
        b=Yx70Yfx/Cg0GuMF57DxSIl/csthxZvAmIFgaqlWkt1NKDamW2vVcVrPRHB+Gig/CYK
         rehqMYWtQVhuD/BC5Q5zKTigG8X9dn/YukmEqlgMTmFBykYTIff2wjUni6M7Ro+byOBp
         NF7102E6wHLh0RMMehgj64qIOmxXFrvImSmae0jl8sZovV8rftT0R4GBWgQU6BFnUIcE
         tBZ/FGVkQh+wQp5eDPqD4xLGMXvoiOFQlIOqjgg0EAGjyaOAWix3YeYISqpdXJE85tc7
         BEWl6WpRIZJwbiKe1DQBXi3tReakV4/c1voqLH1ZDhmult3PAqmM/ZQ9/WJ3izPGp5Vt
         v3sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762357629; x=1762962429;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eHpSaNKeWzfxE7MXB+hzl3rXaEMpclifomHLiL1sx88=;
        b=IKjBcaJGzrKWZmP2wUlIisdNEAIPIbyy5o0l0f0vO1qGLeb6e9qP1Wkw3IbHucXC2R
         kaH7kwmcxX9zFnBC7qXFEOUzqc3weEc1g8hGOfkAFNh3B2zQ6mSgIDeqhIOVcSi2mkAb
         rYysNVQwumLxTtKBcAQOO4PVlxOeyH0ZuhMBJniL/F4lvMalUD+qYZiwCZfqvTsocnqn
         GFMcMgCKwf8lLfHAYpZkKy98kDh2Ux0121NS6PKsh+kTkN5ZDBf2bOPI0C/Fv8hw13yi
         NivhdOBnyYFQsePlLjoiyfYRYsKiLnqr6Pi3AKFhn40ACOc2a8tiRhWKkTt39NXVTV9K
         OqoQ==
X-Gm-Message-State: AOJu0Yze3uxFaM5hu5k6V3hGoN9GLew6QdXgTV7QFrVxs8flAt++JcT0
	Td/P8lCmxupwSYqa8/BfTUq6RRMWODukfpu0O05Ewjj8Q6VrdwiTwicANFPHJg==
X-Gm-Gg: ASbGncvh9yjPQi+w7gsRNhDBQwN9ihji2NKafturpmuFuNBmo2FLLHdl7EK3Rmgk2ip
	RCWbQsPT+R+1E25gvBg4DpnC+s21EtCgeZgzzTvtgnO9wX+9CU7vD7Y3Ixe9PriI4gBOnHJjlME
	8jno8cGpc/E40QpYUj/+mr5NPFbiI5qF4feiT/KTpXFqEzkltE6ea6NZEKSlU6GaXvn3WvbmEJM
	zrkGkVI56AqjWZ53pKSILJnHJMBsturE1ZaAHQuajJQBAQtkjoFfxygFLuMd/Zky2EuU27UdrRR
	21n2/92QPRTjKxtN0lB582jVlSJlHN32vJ23Dw7d+ca5SiRpNCIFB2ghwMp1yWQUhWbNEY4BhdF
	CZNUUNsz1EXRYhKQB/s++q60W83vVegYUMEKz/YKvHucr1LAA9+OT6wCqvv7ilD8iO+m4YzxzTy
	rzZQo=
X-Google-Smtp-Source: AGHT+IHBn10KrWnKkxa1vgM03d0OyQb7Z83w6kJWkTLFnEYSmicUPz1lG/+JIpuiYb2zJlsW+o/Rug==
X-Received: by 2002:a05:6000:310a:b0:429:c8f6:5873 with SMTP id ffacd0b85a97d-429e32edf7bmr3629398f8f.22.1762357628630;
        Wed, 05 Nov 2025 07:47:08 -0800 (PST)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429dc1fd2a7sm10842039f8f.39.2025.11.05.07.47.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Nov 2025 07:47:07 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH io_uring-6.18 1/1] io_uring: fix types for region size calulation
Date: Wed,  5 Nov 2025 15:47:01 +0000
Message-ID: <f883c8cca557438e70423b4831d2e8d17a4eeaf4.1762357551.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

->nr_pages is int, it needs type extension before calculating the region
size.

Fixes: a90558b36ccee ("io_uring/memmap: helper for pinning region pages")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/memmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/memmap.c b/io_uring/memmap.c
index 2e99dffddfc5..fab79c7b3157 100644
--- a/io_uring/memmap.c
+++ b/io_uring/memmap.c
@@ -135,7 +135,7 @@ static int io_region_pin_pages(struct io_ring_ctx *ctx,
 				struct io_mapped_region *mr,
 				struct io_uring_region_desc *reg)
 {
-	unsigned long size = mr->nr_pages << PAGE_SHIFT;
+	unsigned long size = (size_t)mr->nr_pages << PAGE_SHIFT;
 	struct page **pages;
 	int nr_pages;
 
-- 
2.49.0


