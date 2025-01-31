Return-Path: <io-uring+bounces-6199-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DB238A2403C
	for <lists+io-uring@lfdr.de>; Fri, 31 Jan 2025 17:24:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5E9EA164106
	for <lists+io-uring@lfdr.de>; Fri, 31 Jan 2025 16:24:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37BA11E47A6;
	Fri, 31 Jan 2025 16:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aIxWJgHe"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85EE71E3DD6
	for <io-uring@vger.kernel.org>; Fri, 31 Jan 2025 16:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738340669; cv=none; b=m3xdw98xC/FIkRekmMS3dqDpukZcGxvm1DJBigni/3z6l/scKntOh4pU7C/F/J1oFw81l60u3pkDEM9zQBrrz0GDFqQ+tspPNushFQdHtXjhlvBWL/GD2Ugwt5m/mWmKdCjjTYfRmZI5nm6tG/356jAgzUBczxy0PaJkRKZ5xAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738340669; c=relaxed/simple;
	bh=RojzI89zRcBAtwxUQpYd7AyKCGEom1915DBoAKmnGNA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bB5cs382YuHaHYem8M1nV8gyvgkXcsZqYOJa15lx+RNQXV603qZPnw+3ZD1TjwflE0PyzPyQ3nQ6+cXtujg9iyk2BPAQvUduCBefmG2uV6F/Ul4/ltVJABaEagGvTsjxPgOb49yhNaG/yi98G/SJGi4H8dwlbtkelcuFCGTDjas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aIxWJgHe; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-ab698eae2d9so432019066b.0
        for <io-uring@vger.kernel.org>; Fri, 31 Jan 2025 08:24:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738340665; x=1738945465; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/MG5ukT4UriAnTWgSKLhedlVT0jI9uEOg2wz5KlXJbI=;
        b=aIxWJgHeCP+G1wTMKMBPTtp0OHvzW+elhrhMeDd8nsm3as2/s9CEkgWdHQbQT+2MGT
         Sd/laPL/7TqKiV8UwqpcJFI4Pwq/2wm4EoSspMDk40rFQzu/PRFouB42w62NF6v77fQg
         fzeWe+JggQLGTBK6WnSTvlitsj9MzunI4Vi3bo8+6CU32gJBlgU5d6S9Lw/QbnlXRMpJ
         pEhQS+XZCXasdC2+AgZPuIfz7DqGx9Q4Wlia7/92DfPJxqHrxiOPR6mcaMCyhvEkzwQb
         0q6MMCZGVeIR9A/H4MU05Krh5MLSZWhEfis/bmcYWw3rdKHqYePnrA0o/Hsc9TpLsxca
         6VHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738340665; x=1738945465;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/MG5ukT4UriAnTWgSKLhedlVT0jI9uEOg2wz5KlXJbI=;
        b=bXc6wSzZhtFGfJzFFBKXVHsgPuc6jNzq3XW6XEC7ZUL/0X8YORN3BAx4gfeTzSzt4W
         rLaODWWCuIlB/5m9OeAP5OB9JrOSV4mhJNIRIVpHhoe/XeAEuCkwDQgJtIbbAzVCWU8j
         Q4HtY08nZwPRCxKX7SOtTNcMHA9mX6CUvqTUkSY7CLNsvRoCynIov2EtNH+S3/CpCkun
         sIAI/K0r1o6jlj8auGBGI9FJKqvr2bs8O+53c0NTTKf04KKawEAIeOnHajFDz4bB61ue
         lNr2YIIAK/kfAzFq58G7p0ydNYQe6kXDotyjdj0Kw9+cqlW6in3JhT+vNGVMsyhqBa0C
         C/jQ==
X-Gm-Message-State: AOJu0Yyc07Cd8FYE4qBDwhWc8o3GMjmHJSQTFBRxy10Xop6+Ju/U0VBG
	cq9DyswVBoprXYQQhMRu5/2fbVMgDM/MQN/Xf2kpKz6BozpdT4DW5xj5xg==
X-Gm-Gg: ASbGncumkrBSvjvg6/bGbyqJVXGdt8sIO3t8ZmIx3Gs0m7vF8KvAiCl1EMWnk/AzAKv
	1Gyrni0/FvZml6X1/oLmo5P/kPEJjsdOG30v2/N9DhzKeIVX82Ngc/GHHR54UsW2Fxm26U0f96E
	vQbS0iIAdu7EpCIiNWJwh7S9jFybdriLoai/PhiHxvBC95lSZHrzUqIEtr/DZnmrmn6xfjwIJhw
	3MKGl6LL3yJMKNasptxVbZy3AXDYiSo9v9XhWh5X23GkChMbSKl9dF8BCITS8izQJiuuvEkjlw=
X-Google-Smtp-Source: AGHT+IGXFJqwAbcNvGJRJENIllDZTb8AHcShP2Gs5TGbxbCYfVvNbwo2K5iM7BrE56klKcQ0OHE0ow==
X-Received: by 2002:a17:907:961a:b0:aac:619:7ed8 with SMTP id a640c23a62f3a-ab6cfc86accmr1427177066b.7.1738340665083;
        Fri, 31 Jan 2025 08:24:25 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:7071])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab6e4a56587sm323292266b.175.2025.01.31.08.24.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jan 2025 08:24:24 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 3/3] io_uring: check for iowq alloc_workqueue errors
Date: Fri, 31 Jan 2025 16:24:23 +0000
Message-ID: <f9d61c1f8dc391f4935fcd00bf67b14345a68c72.1738339723.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1738339723.git.asml.silence@gmail.com>
References: <cover.1738339723.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

alloc_workqueue() can fail, check the result and return an error back
from io_uring_init() if needed.

Fixes: 73eaa2b583493 ("io_uring: use private workqueue for exit work")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index b05580c1a6424..78a6cc84304f2 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3925,6 +3925,8 @@ static int __init io_uring_init(void)
 		return -ENOMEM;
 
 	iou_wq = alloc_workqueue("iou_exit", WQ_UNBOUND, 64);
+	if (!iou_wq)
+		return -ENOMEM;
 
 #ifdef CONFIG_SYSCTL
 	register_sysctl_init("kernel", kernel_io_uring_disabled_table);
-- 
2.47.1


