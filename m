Return-Path: <io-uring+bounces-6902-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1838DA4AD64
	for <lists+io-uring@lfdr.de>; Sat,  1 Mar 2025 19:39:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A391A1701E4
	for <lists+io-uring@lfdr.de>; Sat,  1 Mar 2025 18:39:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFC771E5B7B;
	Sat,  1 Mar 2025 18:39:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="f+o30AO0"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f228.google.com (mail-pl1-f228.google.com [209.85.214.228])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D73C642A87
	for <io-uring@vger.kernel.org>; Sat,  1 Mar 2025 18:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.228
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740854347; cv=none; b=QLEvmQtb6dPdRtBFwTKrIS1VGhz3IrmBWffVd/aWM8rjpjANaDBHA4Av+uGY6ubbKPFyvmmkIsKb29I2G3ogE7uns+fXM4+HFeMer2PZWIms0BhqhZ/oTIvZkD+ZwSXn5V6LTEiLZv5MJn33UKnrmQqyTGXivrZ8tKNL2MrwqmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740854347; c=relaxed/simple;
	bh=stkOczj9wsk0yC8FVzBVC0ck+FsRwlXVEQXdC7KVrtY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=o/sAV+Ei4LCZBJ1y9bf0PimrvabwY5l+v8nOxsf1z+RHuLJxooSkXUiYl3Uq9VcBfGMJMNFKQNIvNeDtfw32EM0H+6HLdocWoXS7JLUe33Sy488yBbg62RrwcdyBbiemXBia7+3fm/6dKkKT/F3gIMB24eKp7yUyAhiPpGkcyeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=f+o30AO0; arc=none smtp.client-ip=209.85.214.228
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pl1-f228.google.com with SMTP id d9443c01a7336-2234338f2bbso8059865ad.3
        for <io-uring@vger.kernel.org>; Sat, 01 Mar 2025 10:39:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1740854344; x=1741459144; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=c6GWDVHZ7DE4o6lUs4iU3R7AoMZoHDxMO0VSLoOpHdM=;
        b=f+o30AO0LDxeh4kqTc4fN99LzrIH+BLPDBPpK65MGi0oYIKHdTQGAyLusotrDYvh1p
         MyqbYFSomg/1uu0fjHvsl2XhScBoiv+s3FufWQBKEdZBupvh2d52kEZFiVd1EiWXotdP
         nqh8FbExAv3RBylDaHdxGzQI/BhD6xmhkBLppbRptDZ7EolP7Vrx45mtua5SYqTThFpu
         JGSyxrETa8Ve8hMykWCoPqvVwsXuU1VkMCaRswXbj77XwhpjhkulMCKjlVDc7f2U1rIQ
         4eZvAbXZYRAEO1iYO6qineWTVGcE20eyQMyT+ja0U0Ny/j4YFPY1FE//s4gFLRwIxbB3
         dmZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740854344; x=1741459144;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=c6GWDVHZ7DE4o6lUs4iU3R7AoMZoHDxMO0VSLoOpHdM=;
        b=svIuO3GcAWR+WY/LJAXUygBjwuiBBjaGJ+fvW2b4UjvhfXeL33uMjTl7iLxs6drLoO
         w5HK/zK/+yty3OvXrzxWSMVoaRXUCx8uUBDCKWDaJzCbzu3vaBigY3KYb+aWbJrR7Gd8
         iFswwHTDhbQBjht5zrA1adrFQn8P8IOztov/TsZeaRmr2pCxg4uW0/ba7g52BK7pgqdO
         dQ20itFXpKOpQVXWkiXi6Y+gPJKME/00r4pTgFbKt+ItfEeGBEhTqv7LsWAPIUt1uSIu
         v9ChGs7hmI7XRHNlQsVgdfD0vq5bWE33cYmN7X9zLbx2NpjFLK/z9Gs2hLny/2nvQ2eB
         /jLw==
X-Forwarded-Encrypted: i=1; AJvYcCW22jGGnOBNT/Hd31ON/aZ5g6sASRO2MX4On6nz/NuBLYNRIu2ERj3t2PXeAAV6gykCShHxTGRrkA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzD22zldQ8ix6MirRv2rnStoLMTG6sMQSXuhkKGv0WtErgkuxe5
	DF7/qjolstW9OTqyYD00+mO8Z7CdMjhWqk4bfFeN082DqRf7Z62vybL/Qw1m5bk2AGRGHTNFFkr
	NPEc0KRCf0OQ8n6yO3TdrKyS/2k2kZIzX
X-Gm-Gg: ASbGncv1zDI8/W7TbS09sCWdghBie4zbB3GZoY5404kdNo/6qfL29B3U/osYgqhMmnn
	0qV8/SVxkLs8TWC/3tauqzKQchHM1T1h6bBCrowG2qDsW4Tw/kSBWbNYQMbuqlr1RcJ3wQxd3tj
	CuDFM+PezQzg3a28KMagwPaDp0K7i1JU+FsIrJfAGCMjYW/nqPcaoTbfkifVKwDlt/fqINwOQs8
	X6DKUuws1gTyisMo/D32rnSObBSURYr4pr7sBqZGL7Ppm1R4OUudfQiTfE+I6qLm74UgE1CK8UL
	iiplPMoBhjAtSg/ephBPKrurxF+5z9oFuzMbd5ExV5xBrcBh
X-Google-Smtp-Source: AGHT+IFQXb1LamgOtsmsL5y5qtuMCmuSy0BmT7WOm4l455JDk/1ik0dpiEWhsFU6IHMLgADhF9R4SZeJQb5q
X-Received: by 2002:aa7:9903:0:b0:736:3326:2bc with SMTP id d2e1a72fcca58-736332606aemr1850758b3a.5.1740854344073;
        Sat, 01 Mar 2025 10:39:04 -0800 (PST)
Received: from c7-smtp-2023.dev.purestorage.com ([208.88.159.129])
        by smtp-relay.gmail.com with ESMTPS id d2e1a72fcca58-7349feb4080sm361682b3a.17.2025.03.01.10.39.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Mar 2025 10:39:04 -0800 (PST)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.7.70.37])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id 694F6340314;
	Sat,  1 Mar 2025 11:39:03 -0700 (MST)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id 63CF2E4112E; Sat,  1 Mar 2025 11:39:03 -0700 (MST)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Cc: Caleb Sander Mateos <csander@purestorage.com>,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] io_uring/rsrc: include io_uring_types.h in rsrc.h
Date: Sat,  1 Mar 2025 11:36:11 -0700
Message-ID: <20250301183612.937529-1-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

io_uring/rsrc.h uses several types from include/linux/io_uring_types.h.
Include io_uring_types.h explicitly in rsrc.h to avoid depending on
users of rsrc.h including io_uring_types.h first.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
---
 io_uring/rsrc.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index 8f912aa6bcc9..f10a1252b3e9 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -1,9 +1,10 @@
 // SPDX-License-Identifier: GPL-2.0
 #ifndef IOU_RSRC_H
 #define IOU_RSRC_H
 
+#include <linux/io_uring_types.h>
 #include <linux/lockdep.h>
 
 enum {
 	IORING_RSRC_FILE		= 0,
 	IORING_RSRC_BUFFER		= 1,
-- 
2.45.2


