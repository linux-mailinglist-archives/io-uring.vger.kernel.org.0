Return-Path: <io-uring+bounces-7621-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A0D88A96F29
	for <lists+io-uring@lfdr.de>; Tue, 22 Apr 2025 16:43:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C83CD3BB428
	for <lists+io-uring@lfdr.de>; Tue, 22 Apr 2025 14:43:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CBC128C5B9;
	Tue, 22 Apr 2025 14:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y1xalN+K"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44B385FB95
	for <io-uring@vger.kernel.org>; Tue, 22 Apr 2025 14:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745333017; cv=none; b=rhUVwrUMwfpLMTjPUvjdHKA1Qi7D0hX1sL1eoxyaCv0jFbx8qhuSXbPIEMwvQpObxvETzlPwXpO5kwJNPALuF/WKptqFZBks0hs6gFLEz/63FcxtTPmRShFpTmsRtgjeR4f2J7upq58NpuSwhb2I7aJwDbv7r5GNe5LN1NF6ArA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745333017; c=relaxed/simple;
	bh=j4a4HHYzjnIstqMifCvV8xMbKJ9xFom3nxK3uoUCCJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cGj42cHO0UShc+Ub3jnTSYEzlnF78OTF33DjKVMNo8/YC+OS4O11axavQk4PeearPWffqPmAfKRq7BIcCujs38IzBnS78c7A9tR6VKPUcs/k29MjAYc0L0NdfF7B+yAnlt+DXGWZuf12n/ZTV8X+kiLvVvHTrdDpJX3XqKtUS8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Y1xalN+K; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-ac6e8cf9132so900090766b.2
        for <io-uring@vger.kernel.org>; Tue, 22 Apr 2025 07:43:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745333012; x=1745937812; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MqCtXXn3zagj0eFAZamOZt4xeMbDsiqZk2xgDldYd6E=;
        b=Y1xalN+KwrzgVhNH5Fz39vNPb8NKcLa+H7QJG3Smth9ZuyeimJRfW23uuyfXNgkSpf
         MaO1xUZj0tP6oGlVFrBSagEAeWBKxCoSo8L3rMbWjV8j+nin8T+XpSgRnaz9SLLqBKfA
         1tWhCczF0rxGzyWPku0Go9d7B6ty7A0HhMafTtd0kYbezN0mHarYZEpkpV4RMxUISUAH
         Q2puOSSZ7X1Ilmpes7S6l9Cb8Icf90rsfhiZIXCnGqIsA/Ys4Asr3T2edCiz/UWKfxHe
         SYtQmizSTThVE4vu1mbdguw+eRPiFYSedCuzG3mxJIPaZZ/yg6rQ27TXKNZsrmHKS/lB
         JT5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745333012; x=1745937812;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MqCtXXn3zagj0eFAZamOZt4xeMbDsiqZk2xgDldYd6E=;
        b=iAfa5jfdcMu+ib1W8bco/m78KP/gvhmx6bmjQNmPlcnyXYYS04E4eFklhrerd9OR+K
         AHdwrSE+NxTNJ2R9pl9RE2jBHQ9str/7lRGK8wYyimhaPjo9coWNDztP6gBdD5hJY0ah
         GSTjSMrKclVtk595481FLoJDvXHwtlDTb/3W06CfFZDKtFZtN9ZkPyXpwXKtbdJmhIEi
         3AYPknNEJLReIbdcHpXCnAPlgNSfrekUIu+keh3FPbYuf7VDxP0EZS4Z4hik+xsPklhH
         +03lU5EDOxijTX/FXgV2Ae1LwwfPyYp2EErM6xHAut9Un76a3+y3XW3tnprB2yu4yoiN
         HXcw==
X-Gm-Message-State: AOJu0Yxu9X+ZbklL0LjsEFfLNx54JEoO4Fs+R+fEB436xEsw949P2n/G
	1XaDfS0/6mzHqzDIBsTh/lzcHeXM9Wj81leDvzsUr4VrpsnncmfNJm+lRg==
X-Gm-Gg: ASbGncsSe1jAnZ8M1Poz540uoExqoel68RVqb9w9+SDC62b5jyZmU3EWduZ7F2mgnFp
	YK2GJp0t7SRoUkvGmOBHiIVVuaG0rGV66YabHAAqLE3IkfbedANweDACbEQhmybh1wMihqbevNM
	gKPuiz3dew8nRT6F0n9sbaG3k4d6Z5Ra5Es36y5uGgmv9omNSiB8BGX4r+iIwKVIGbIx0ykUpQN
	CVVF2Z3MwCWOZdDpA6MG8PAhKntdbfzH8ovkomS4DW6vamMNW7g6XeMpARnKAOcR/3Zr9fnBP9c
	HNAIxltTMYO6DAmDGRTcUv/eulfCyI/1Jxs=
X-Google-Smtp-Source: AGHT+IGfx3LjhsDdxig+uj04j3LVsg70wy0QTvfC32Lm1ePTTFALZB0H2zZcW3MjHcFV/n3f5JSvsg==
X-Received: by 2002:a17:906:6a1e:b0:aca:c924:c14 with SMTP id a640c23a62f3a-acb74b34dbemr1381112466b.17.1745333011934;
        Tue, 22 Apr 2025 07:43:31 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:be5e])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-acb6ef475c1sm655374966b.126.2025.04.22.07.43.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Apr 2025 07:43:31 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	David Wei <dw@davidwei.uk>
Subject: [PATCH 1/4] io_uring/zcrx: add helper for importing user memory
Date: Tue, 22 Apr 2025 15:44:41 +0100
Message-ID: <5e65726b486cad8fef0b6650997d69f3eb585e4a.1745328503.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1745328503.git.asml.silence@gmail.com>
References: <cover.1745328503.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There are two distinct steps for creating an area. First, we import
user memory, and then populate net_iov. In preparation to changes for
the first step, extract a helper function for it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 47 +++++++++++++++++++++++++++++++----------------
 1 file changed, 31 insertions(+), 16 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index a8a9b79d3c23..0f9375e889c3 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -203,13 +203,38 @@ static void io_zcrx_free_area(struct io_zcrx_area *area)
 	kfree(area);
 }
 
+static int io_import_area_memory(struct io_zcrx_ifq *ifq,
+				 struct io_zcrx_area *area,
+				 struct io_uring_zcrx_area_reg *area_reg)
+{
+	struct iovec iov;
+	int nr_pages;
+	int ret;
+
+	iov.iov_base = u64_to_user_ptr(area_reg->addr);
+	iov.iov_len = area_reg->len;
+	ret = io_buffer_validate(&iov);
+	if (ret)
+		return ret;
+
+	area->pages = io_pin_pages((unsigned long)area_reg->addr, area_reg->len,
+				   &nr_pages);
+	if (IS_ERR(area->pages)) {
+		ret = PTR_ERR(area->pages);
+		area->pages = NULL;
+		return ret;
+	}
+	area->nr_folios = nr_pages;
+	return 0;
+}
+
 static int io_zcrx_create_area(struct io_zcrx_ifq *ifq,
 			       struct io_zcrx_area **res,
 			       struct io_uring_zcrx_area_reg *area_reg)
 {
+	unsigned nr_iovs = area_reg->len >> PAGE_SHIFT;
 	struct io_zcrx_area *area;
-	int i, ret, nr_pages, nr_iovs;
-	struct iovec iov;
+	int i, ret;
 
 	if (area_reg->flags || area_reg->rq_area_token)
 		return -EINVAL;
@@ -218,27 +243,17 @@ static int io_zcrx_create_area(struct io_zcrx_ifq *ifq,
 	if (area_reg->addr & ~PAGE_MASK || area_reg->len & ~PAGE_MASK)
 		return -EINVAL;
 
-	iov.iov_base = u64_to_user_ptr(area_reg->addr);
-	iov.iov_len = area_reg->len;
-	ret = io_buffer_validate(&iov);
-	if (ret)
-		return ret;
-
 	ret = -ENOMEM;
 	area = kzalloc(sizeof(*area), GFP_KERNEL);
 	if (!area)
 		goto err;
+	area->nia.num_niovs = nr_iovs;
 
-	area->pages = io_pin_pages((unsigned long)area_reg->addr, area_reg->len,
-				   &nr_pages);
-	if (IS_ERR(area->pages)) {
-		ret = PTR_ERR(area->pages);
-		area->pages = NULL;
+	ret = io_import_area_memory(ifq, area, area_reg);
+	if (ret)
 		goto err;
-	}
-	area->nr_folios = nr_iovs = nr_pages;
-	area->nia.num_niovs = nr_iovs;
 
+	ret = -ENOMEM;
 	area->nia.niovs = kvmalloc_array(nr_iovs, sizeof(area->nia.niovs[0]),
 					 GFP_KERNEL | __GFP_ZERO);
 	if (!area->nia.niovs)
-- 
2.48.1


