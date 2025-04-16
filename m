Return-Path: <io-uring+bounces-7486-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 22288A9078A
	for <lists+io-uring@lfdr.de>; Wed, 16 Apr 2025 17:20:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 39B1844113E
	for <lists+io-uring@lfdr.de>; Wed, 16 Apr 2025 15:20:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 118D0207E0C;
	Wed, 16 Apr 2025 15:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OOshpxd8"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A042207662
	for <io-uring@vger.kernel.org>; Wed, 16 Apr 2025 15:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744816813; cv=none; b=NH6NP2jVYRTMbPSLMx7doh+bwXSWFH1w+zt92nII/nvlNl5WesF4V0KEZaxctsE/pkjx8E4HR+PfZqV/aVIHh0qV/yEJbsZSVATkSHkNuHjmkzLinAZibds4j9e9r+qKzKk/YV/33omT+3qTSUugslvSCfv417ww4iq1WIemoQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744816813; c=relaxed/simple;
	bh=L3c9j0lMclPxbENMQ5Jw4Q4sHhlKtyIvnp3aPFlrKTw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WhpUFkRMXigoVg6ScRxtS4MfVDWuelNfN8gk7Wwp0+eCrGNhs43Df5qvBySGB4tAQj8Zdfm/Aga2d8jyz9zLSWAgpdawomLvm6zlm8Vl8ftd7v0QRQtx22FGtvp66Bai8CYRODSzjsFVyC/vVGycGrofp2kyNNli+Y8GvGQmIyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OOshpxd8; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-ac7bd86f637so169422166b.1
        for <io-uring@vger.kernel.org>; Wed, 16 Apr 2025 08:20:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744816808; x=1745421608; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SCZ2kegBjGGiAF2holyBW9TGmsBq8CAnBm7l7OUoIlA=;
        b=OOshpxd8H58jL+zHhfrNG/cnEoyx6nbsdfJyin4v0ul1UFBENYwkQCkBCD+ysLgqnG
         QDfJItgJfawbHn5mlQWIBizXv51oxY+XtBF2uwUce1+t02iUWukBDtK337n7/1ZASUU3
         Inaqpr1PjA+eX/xnzEefArGahSb23BDObLHb2HYiuZOltNgAw9A4m9WgVbLhCDUjQhgj
         swHn6d3V3kWKpTE23iRiwwpv6ONdApXfoB//4RBWjFtmEQuVlB5O5QnGz+IEWt05l00R
         HPPyTIGywjseaE3biZkwfjf+B/r9JT5t9b7iqhtcNQU9xxuqH/1uXMpus5PVl1v/6gQg
         DTeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744816808; x=1745421608;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SCZ2kegBjGGiAF2holyBW9TGmsBq8CAnBm7l7OUoIlA=;
        b=E45q73JIMi5MuaBI18zbfdx8Bl+hAlQ0uRO5IpWAwDY4qFUElmzlQZ6o7fnWOyf7/b
         oXpuAdix9FRePs1OxPj4dDb2x2iyjkLDWwZd4ikucEZ+d080tDazLLCeVxXOKF87wwQW
         nHRhhUoD5lVtrqzOxPFVtBBwBoQvtRDiT3xgyWYWhjJBWP5mB1UPeEuBzw8cibdpVhFA
         iNUU2aSZjRBZ2n1RS6/ehytA09PvxA/scoopS7WACmkrbqu9jyUzBvUHhw+HLzDoF03V
         pzzVkphfny9opPry/wFhXthdtPnI2dVXV+tbQWJlgEyQJ4QjrN9Nr9o0XPM6bF191lkK
         nT0g==
X-Gm-Message-State: AOJu0Yy4LNJDU+WdBDu2G/DiigFTQzcBSta5t3xI5KZboJT3Iw4oeziv
	gHGIU8zJDyEpqu+3k5R7SbEWAmKBSokaIzmVIbSKJGAv/TS3tgCkRKmAc39a
X-Gm-Gg: ASbGnctUS0PFmxDDfqS0lmIuAkLXSjS3UfJr3d1QyAbVCBMYk0eFvcKu1ETpOxZo4vQ
	RurHKO0CGfzHAE5NHBhZVouhc3cMcMtsCA01ZMscCnpz7UaDHXe2eSSdxFU4rdRbqaN0HlByRrE
	HVDzzjWjAio4MNf9gZYvoqShIB8qR1RABiSQkxc4dP3ghwWXxajmk6V65rVlkEOFH1msLT4iuMJ
	yS95ciyNhgMcPkIJT0bkOyEqLYETXYgGyOtrZb/G8m2eOewXQjzQAhrEa5rlWEU+Fg0TzXlTH0v
	f57JiBcrZGwUC8ZVKBGVHki/Frrq8MIDraY=
X-Google-Smtp-Source: AGHT+IFhU9qSsmZ2ZFzYlDUt6fn/DR/p/gZMiiQAiwT8VguWxgoGUN24QQOWAwLO/IXTwYnV8yPh2w==
X-Received: by 2002:a17:907:6d04:b0:ac7:7d3e:7336 with SMTP id a640c23a62f3a-acb4290db5emr176539566b.22.1744816807807;
        Wed, 16 Apr 2025 08:20:07 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:1ccb])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-acb3cd61f75sm144579566b.35.2025.04.16.08.20.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Apr 2025 08:20:07 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	David Wei <dw@davidwei.uk>
Subject: [PATCH 1/5] io_uring/zcrx: remove duplicated freelist init
Date: Wed, 16 Apr 2025 16:21:16 +0100
Message-ID: <27d0a2165f1890c039e873563c19c7959c1982d9.1744815316.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1744815316.git.asml.silence@gmail.com>
References: <cover.1744815316.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Several lines below we already initialise the freelist, don't do it
twice.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 5defbe8f95f9..659438f4cfcf 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -238,9 +238,6 @@ static int io_zcrx_create_area(struct io_zcrx_ifq *ifq,
 	if (!area->freelist)
 		goto err;
 
-	for (i = 0; i < nr_iovs; i++)
-		area->freelist[i] = i;
-
 	area->user_refs = kvmalloc_array(nr_iovs, sizeof(area->user_refs[0]),
 					GFP_KERNEL | __GFP_ZERO);
 	if (!area->user_refs)
-- 
2.48.1


