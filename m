Return-Path: <io-uring+bounces-9820-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E4E33B59A50
	for <lists+io-uring@lfdr.de>; Tue, 16 Sep 2025 16:35:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 87CEA1C0658E
	for <lists+io-uring@lfdr.de>; Tue, 16 Sep 2025 14:29:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A34CD34A338;
	Tue, 16 Sep 2025 14:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mG6dJTe+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F22AF34A33B
	for <io-uring@vger.kernel.org>; Tue, 16 Sep 2025 14:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758032837; cv=none; b=OLfauNVGjBYOw/F+JEdWh7/rCmvh9OPZdjOIMJqau069o96MXwNeVwJxbBNP274ywVtDM0jZq/oTmfAUY5okwmiH/Nmt/dBbDFitF409WOVGzDwCvX5D7sCuFdOJs1gumW4J8UnaIq2FuM10VUJzHtx8IUGtfY2z3buC8ssEGg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758032837; c=relaxed/simple;
	bh=MJcEIUnPs9ak4+d5IkHtv3yqfevdFjfAWkSWHoi/y5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HPAE8xpb8NolCeAJWdUwovGJySv2QoEJ4y0UZMy+Tyv8BWB30YzjAidc1gEpH40IMsU8tcnJePS4nJyqAayD6rc0brc8ubayYgFfxin0lZZ/fB60yhnNGfRsgcdyxn6VF88ycnz0LDc/kurhWQC+IKizuFfoLjw5w/Z7ukUUb2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mG6dJTe+; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-45e03730f83so26265505e9.0
        for <io-uring@vger.kernel.org>; Tue, 16 Sep 2025 07:27:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758032834; x=1758637634; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OZnPDU01+keBE0tfX+r4Yhal5q4qGyGJ9h5yCH/G+vk=;
        b=mG6dJTe+byK55gIrX96quXZvu5pmuaFpo44VwWWjDU+E88XGvJgadpoA0RcyvNkNUY
         XVrk4PKuF5H17i7kDGWIHFy7/0I2cM2e4rL9a9odimBCgWOXavW5xArsMU/sHx4q0sjU
         zI3/xWCVJZmJn+W1ZhszdLL+/J9fsdGzjf4QtwUfx4ZstRL09rCqyvTN4P8AiSBrVKjC
         WLAp7d0vPe3L5t9WgChAMEUb1lYw9RZq/KOTt66145YMWW6nIt2a6BnmnQtqTAykF7A3
         3lKQnWBDCG+YIp3OIxeaYXvuWbKmFAPwPvqaknOT52g6ThQCW1WYnye5fgjgrSt66DLl
         5SwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758032834; x=1758637634;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OZnPDU01+keBE0tfX+r4Yhal5q4qGyGJ9h5yCH/G+vk=;
        b=O5e2y4QfmerAHjOnHXeBqmb1qwquIUGamkKWx/kJ5H2qYj4ysj0wyW8UUrgFRsf0DG
         GO2agoam3Ij3jjx1hiqs8LsJLFplbxV3RJresIC75NuGsUOAjpYylbrTh2gZwLFlEUOF
         g0o0W59wUzlPqFZl3MlVPAH7qJjS2nPzvPGo+T7V+uAEGmRsj7aypA9KUBe4AxwAf12C
         VqWRkQ44KymcTLLCHsnno8W64WDMUduezp2SVW4hjQjFPb2b0mYmzEkchwz+ZQLz74SD
         WnFppvBrB8fJV0UNiET6l4lT5pjf9o07BTgtJEYCCKcSnFFAh+KZsTdNurCbr8969qDU
         1sww==
X-Gm-Message-State: AOJu0YyhgU2/4fvhtqpgJlKcejJ3xeoS9nqisxHZ0ltxNouU2yzd3FOD
	Eb1W5SNM4biB2Kz3/ZRGm/Xqz8qubFNlf49T8xQjcLvgG1ivGN3uAd/XM3IZNA==
X-Gm-Gg: ASbGncu3TWltHX5GhdtR1R+5sJv9b88ZQ5P4Fx7eV4jMWcbPXZQS33ar9wzUQGza+9R
	3y1OW3PPgkSM3zda9yZTuazKsvzMNBpsbKImBB/+I+3AB5ZkOeXaiJVynkRELcRWGXaf9AYMFm1
	qrxzqvzQuAMVNuJeXiV+TNpuOYWjY1KiaU+zYvU0KQjwd/qczjcOepiJt+EAnUAeZuGXWXVathm
	CTpRcvFSeiaJIJXdPMNtdTKlcvjKHVO8JyIK1pRgvfv/Rr5ja/xVMkgdH+i+6FMhwdC7++Gjp4V
	t3FpixOe6xP79GhFaGg8Q7EazFvp+7687UPXBlQ09AsYLM5Q1x/3KpfKgn59kLYwXab9zLQHv8B
	px8U0Qw==
X-Google-Smtp-Source: AGHT+IEdVetd6MgumZM83BkZoyY9AAXzGENXYZmE4O7L+kfZRJgRnRIuft8ymbTIHuCrd8GAxIA6cA==
X-Received: by 2002:a05:600c:3b08:b0:45f:2c39:51af with SMTP id 5b1f17b1804b1-45f2c395323mr88594515e9.0.1758032833713;
        Tue, 16 Sep 2025 07:27:13 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:8149])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3ecdc967411sm327971f8f.46.2025.09.16.07.27.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Sep 2025 07:27:12 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk,
	netdev@vger.kernel.org
Subject: [PATCH io_uring for-6.18 20/20] io_uring/zcrx: account niov arrays to cgroup
Date: Tue, 16 Sep 2025 15:28:03 +0100
Message-ID: <fbe8e974f87e182ae751e04ee9c83b658b8b3058.1758030357.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1758030357.git.asml.silence@gmail.com>
References: <cover.1758030357.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

net_iov / freelist / etc. arrays can be quite long, make sure they're
accounted.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 07a114f9a542..6799b5f33c96 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -428,17 +428,17 @@ static int io_zcrx_create_area(struct io_zcrx_ifq *ifq,
 
 	ret = -ENOMEM;
 	area->nia.niovs = kvmalloc_array(nr_iovs, sizeof(area->nia.niovs[0]),
-					 GFP_KERNEL | __GFP_ZERO);
+					 GFP_KERNEL_ACCOUNT | __GFP_ZERO);
 	if (!area->nia.niovs)
 		goto err;
 
 	area->freelist = kvmalloc_array(nr_iovs, sizeof(area->freelist[0]),
-					GFP_KERNEL | __GFP_ZERO);
+					GFP_KERNEL_ACCOUNT | __GFP_ZERO);
 	if (!area->freelist)
 		goto err;
 
 	area->user_refs = kvmalloc_array(nr_iovs, sizeof(area->user_refs[0]),
-					GFP_KERNEL | __GFP_ZERO);
+					GFP_KERNEL_ACCOUNT | __GFP_ZERO);
 	if (!area->user_refs)
 		goto err;
 
-- 
2.49.0


