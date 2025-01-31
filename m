Return-Path: <io-uring+bounces-6197-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C3CC0A24039
	for <lists+io-uring@lfdr.de>; Fri, 31 Jan 2025 17:24:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 46E2B167C8D
	for <lists+io-uring@lfdr.de>; Fri, 31 Jan 2025 16:24:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B52B1E3784;
	Fri, 31 Jan 2025 16:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RJVz1rQd"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 789B11E3DD6
	for <io-uring@vger.kernel.org>; Fri, 31 Jan 2025 16:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738340666; cv=none; b=CojjeLhIUgwGMijROoL7mhdPYsXytQ/JB7eLlx10ws4e42QqrGVd4r8ciqt3XTGeRQVE+8JSC7alapJpYePwmqhmbkgCii75tsh5rQOznQb2xPIJWiF0EYv85hWSTVr8n0voKWqRg+cLuBjN7jmFT47cdEkJQ/MzWQ4K3cbFmmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738340666; c=relaxed/simple;
	bh=bkd+Zf2XzomXl3doWyxMmc8SnDDmoa1SNJsmxFvJB7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fQ95hKs0R/NyPjObOfjm4iNYev6Q7uQyiyHE2Xjll77U17oT43tW1B5i2yF9gISxmy+QfkAW/C5m/QmLTmPIJ/+cG5HSy+F7Ihew1aotmO5ahDhnP9ciEdppNxgO2it77/G133v5/AImtWlqqJeldYf7+g6xUX3fOlYvn2D/N5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RJVz1rQd; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-38a88ba968aso1999534f8f.3
        for <io-uring@vger.kernel.org>; Fri, 31 Jan 2025 08:24:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738340662; x=1738945462; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LiWN85FsAMDKk9w97cQXnBLc5+Zh9mJsqs589omCjK8=;
        b=RJVz1rQdGISQ9tlIxWn77MD2p55GQpuaTmOvdI7q0zobqPjUZbOmv5nG9mNv39CbfQ
         R4MTd8RRsrDJLTmd8y7tOldXgpmOi366OLnrhPoe/SH36z5hkIENAYmgiYqbmw/AGxam
         ar4GRs/jhBaOizND/JRYvkyaxKJMi+qNidQO4Qu0BumNqb8PvH7fpIEY7OB7yDWU0MbD
         xMLQSytXrnUmym3eJlWmKZHRGKd5ajIbjqV2WovNAew+UEEfaX1x/MRAbw/DN9oKGgQE
         j5XK2WFDExfP/0L49MNUJBbGEvcnRewljrckh0ZKTMcB+Qgkw5T3d81OxCWzJ/2X45q0
         5Mbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738340662; x=1738945462;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LiWN85FsAMDKk9w97cQXnBLc5+Zh9mJsqs589omCjK8=;
        b=eoL6hnhTc5DU4+aRfmy1o93lQN3tHMbsF7y694CH2bcgRkXj1Y5M0akFUw19y1g+W8
         NVZUfsGJ578ISedZbik1AKoXqsH35LhSDPS/y0masrHDVsh9QKbp1dT0nHU/T7y2NjxQ
         xC3h56txa3L+py0U3BaH6k2SOF+5nyeTLgMC1l2R7tg8Qs5slPjp+s0IiJF5vxo4q8Ui
         2CgdY2TD8IKHF7mAaXe58fANXlFozV61I1MKnYkeGKq2lGNgmuKDRksS9+0wIBsBRZhU
         5LfLf8sxq5zADk1rsU098eZ1gZLDL//SWTDmRQDzhqUzBDt9SepfbPdlC7Do3uBVUTA1
         TGaQ==
X-Gm-Message-State: AOJu0YxurL6L3DOgNHoGayNvxorJOc+JB7eFcRi3QqzWutwPShdEMZK7
	d7WPjxCAhc/c2sAI7I4LFk7lkpZFq1wa7FGvwG9XKwtBD5ZS21G5yEaayA==
X-Gm-Gg: ASbGncuadZJZs2TlC4+/b2cdgZ+smA0Wne0qL2GTalH5ILp1Sf6CdaazHG0I5e26R76
	O/QsOPaLHivTR7SqA4liZWCD7TaAB5iP2NwgiM1MsXfYZFQjck4RvbnWgZZShm6FWNRuR1YANoa
	LEazyhDAPpPF3nNlGB7jxT5wwseKvFYRURWkrAvBK3uaeI0o7PBO+xGL9Y4soLdG99KH/rdb+Ym
	CDbe1f2bMtoG0qLULCfyUHS4O14q7VcbX2UNbm8XO2gueiImPxBipC+Ii3IH3ik2ueaSmUthFo=
X-Google-Smtp-Source: AGHT+IGCnJySH51qew/XvxoE8kPpkEau1ASuRvxQ2BX4auUYkm+eg+1n9cP5k+U2dR6yLVOaI/goJQ==
X-Received: by 2002:a5d:56d0:0:b0:38b:5e14:23e7 with SMTP id ffacd0b85a97d-38c519698a1mr9736245f8f.23.1738340662260;
        Fri, 31 Jan 2025 08:24:22 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:7071])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab6e4a56587sm323292266b.175.2025.01.31.08.24.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jan 2025 08:24:21 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 1/3] io_uring: propagate req cache creation errors
Date: Fri, 31 Jan 2025 16:24:21 +0000
Message-ID: <8adc7ffcac05a8f1ae2c309ea1d0806b5b0c48b4.1738339723.git.asml.silence@gmail.com>
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

It's very unlikely, but in theory cache creation can fail during
initcall, so don't forget to return errors back if something goes wrong.

Fixes: 2b188cc1bb857 ("Add io_uring IO interface")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 263e504be4a8b..9335144495299 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3916,6 +3916,9 @@ static int __init io_uring_init(void)
 	req_cachep = kmem_cache_create("io_kiocb", sizeof(struct io_kiocb), &kmem_args,
 				SLAB_HWCACHE_ALIGN | SLAB_PANIC | SLAB_ACCOUNT |
 				SLAB_TYPESAFE_BY_RCU);
+	if (!req_cachep)
+		return -ENOMEM;
+
 	io_buf_cachep = KMEM_CACHE(io_buffer,
 					  SLAB_HWCACHE_ALIGN | SLAB_PANIC | SLAB_ACCOUNT);
 
-- 
2.47.1


