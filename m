Return-Path: <io-uring+bounces-10037-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DE03BE3AB7
	for <lists+io-uring@lfdr.de>; Thu, 16 Oct 2025 15:22:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D9AB5189F9ED
	for <lists+io-uring@lfdr.de>; Thu, 16 Oct 2025 13:22:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F01CB202F7B;
	Thu, 16 Oct 2025 13:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d19hV+s+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 333441E5B73
	for <io-uring@vger.kernel.org>; Thu, 16 Oct 2025 13:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760620935; cv=none; b=L4y5NFU7+1l5P6Oq5Q+W8jPo8XaXK92SiIaCwKDhxlqVrB4EoNiS2DRkpnv+1RlCuW80MH7AGiT8IN8qEdd+SIcvVE0PQhhB+qYyUjd5dpCHlhwIa3xotJ5keAdVFM+kwOfCxbcLwY170nAOoNW8Y01HYYPkYghhawKJWSYl7kA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760620935; c=relaxed/simple;
	bh=sKWV1ECZgJELF/u0i9KGPhLwwuf38eHVlQieOZzTGHI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B9xhLxY2S146SAy86rU4H8E5Giru1QpxSRmF7sFp1NQxUfyjBZsfyKif81m8lHc0HfzCqYboR8qe0mhqL/YUylu9gFGW0IK2/ZCA+TgkgT+pP7giwmrNdz0XQ1ai+Xny9gON6Y9XQkxmCdUjfNtHziFe+HSwNy4DCmeR5EgTEts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=d19hV+s+; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-47109187c32so3929975e9.2
        for <io-uring@vger.kernel.org>; Thu, 16 Oct 2025 06:22:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760620931; x=1761225731; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HMCohbiXCxMlK4ebnge+qb7Ukb11Dlm9Nu51R7b0GGw=;
        b=d19hV+s+aPuYbCD7U2SyZXYJQDZHfjlNBoVgYqJ/LDLyuV9gfwhyE/kVTLdpX+ZcHC
         ollOfYH5c0UNl4tc+xdUzMK0vyRRxpJ9sQKvwfY6CrEsZvE8uzeKYavFKB+nw2StNN3Y
         9Pv5mWvdRWrdT03ZL+OEsijUG0+0IJz42EnKsb6jxRixRc2UYvQHb/5otC8I+P4h40x2
         VyCIpCJsVygTHrRusk7oHpiTwcW08dMDJC3vWI/tkhm5sxDiEniN/YRH+yCqL9KdRhpL
         DLB7Zm5kEZCmEHcDXIhEaGFM0AzYCziPHw2rejA7ikgY575k8VQU8nxQP3WYqpuFPIB9
         6tRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760620931; x=1761225731;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HMCohbiXCxMlK4ebnge+qb7Ukb11Dlm9Nu51R7b0GGw=;
        b=SMAtbU+oZFrZPZQUmokY3/e9x9UDIF9EfVpLAjd5uFDBVLxLxUpQ/QJfkrnjtOpslv
         xnnx3iZv9GiL2/qSsf2p+Gd0uQLsznleW9w8kBz4/msjJQeK+Iu4cqiyKssmByg0qoBo
         fI0kLP4n8ANxU/Q2Pfw1RrarN6Hxoc1MzCbFL20Y5rKDVKirsSMl0ctdC9sGReUECxSs
         tbdA61V2dehm9yKQh6QtD2NzSqVenFw5DLsaBvNCKXGGKEClxt1DFmoPSh7CyqGOLw1R
         m2cfBd3muMYQSkJEPxRL6yGw1nqZpG+NwlqosFgyoER6JDgRhxBW2A7+IDdLhOVMC/Ap
         a79Q==
X-Gm-Message-State: AOJu0YzvWb+lYt8jrM7alCqeESQkYO2OH1vwIy690Qnzl4eJIlbDgwtW
	TcTcBpg4PlmT+HMCRmoBWKyhfwCxqTB68cMYb+UeNS4iG+a+DU89ajgy5xT6PA==
X-Gm-Gg: ASbGncu6mFJArVee/Svz0Tpfj6zX5RHZHsx48CkHgIKR1Ks//Df8JpD1nC2eUWUwcH4
	TZh6VU7IZa/dQpc+YUrmZgeeXEY4dFAMCQ2hc2O3EK+byDjDmIuV+vw4ZoRrsYJ7maN0JUzMZKH
	ETAa4OvKTULPqLG9tc/NkePMDXY35wq2TfTiKbVIx334plSfARNY5U1ZjQ/0X1ZjU6LsUxi8yum
	AGJq0BrxCs4lyDNUmkY0ydw943qbYzEBKryD84ZE3vcLQRbaDbso2sQyY/EOHgwHt1eEYf5Bt9l
	6wQNRZMDRufRBRFquu4M2GwjYqW3yNwDRBPbK1gNlLvNa7yVF9GX9CAse0ZzbhgAo1IOwaPpCm/
	ZRtTUxIkw7jOvK456Dc5V71GvpJRnutYaA9mfRb19zBlpd2GAAX+S51sXWzx89pk7U6B4dQ==
X-Google-Smtp-Source: AGHT+IFqUabuo7wEO8KYQW5CEgyh7NJpkoQ1YWff9vjs09TkYlGGp9PdmLaDTWT+6Ox/lxvBciWrEA==
X-Received: by 2002:a05:600c:628e:b0:46d:996b:826f with SMTP id 5b1f17b1804b1-46fa9afbb26mr223705685e9.25.1760620930960;
        Thu, 16 Oct 2025 06:22:10 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:2b54])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-471144239bdsm41834385e9.3.2025.10.16.06.22.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Oct 2025 06:22:10 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 5/7] io_uring: don't free never created regions
Date: Thu, 16 Oct 2025 14:23:21 +0100
Message-ID: <a0af76f781736bf6ea07f6eeaf637b9913727482.1760620698.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1760620698.git.asml.silence@gmail.com>
References: <cover.1760620698.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

io_free_region() tolerates empty regions but there is no reason to that
either. If the first io_create_region() in io_register_resize_rings()
fails, just return the error without attempting to clean it up.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/register.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/io_uring/register.c b/io_uring/register.c
index f7f71f035b0d..b11550ed940c 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -432,10 +432,9 @@ static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
 		rd.flags |= IORING_MEM_REGION_TYPE_USER;
 	}
 	ret = io_create_region(ctx, &n.ring_region, &rd, IORING_OFF_CQ_RING);
-	if (ret) {
-		io_register_free_rings(ctx, &n);
+	if (ret)
 		return ret;
-	}
+
 	n.rings = io_region_get_ptr(&n.ring_region);
 
 	/*
-- 
2.49.0


