Return-Path: <io-uring+bounces-6592-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 20BAEA3EF4B
	for <lists+io-uring@lfdr.de>; Fri, 21 Feb 2025 10:00:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DA1F219C358B
	for <lists+io-uring@lfdr.de>; Fri, 21 Feb 2025 09:00:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC606202C20;
	Fri, 21 Feb 2025 08:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DgoWne0q"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76899201269;
	Fri, 21 Feb 2025 08:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740128396; cv=none; b=CDYBt9Hb8w5VCSW6SOWHssD2Ur//KPdOqFnRdWNLLFS2Mgud7o7dLG+HG09DsOiZMfOCa6gSxGbfbnCnHCUWd0x0/pkAwBqGumvhTmPEcEekQC9NHOk0n79e9S7o4Ny6kCOAloFn0bGlwL4sTfr0y52UC+BK7nkx62RmBhPOyn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740128396; c=relaxed/simple;
	bh=NZp+XjR0ame4V+mUbuMHEjBbHcBR3FtqQG6PXjLxhR0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sqXnXKpOEYPGv99XP1LVPoHh2gaM3FYbseK9kdMC+nlfKnYEkRJui37Ou64sUmJpA9Db9jbPuv//YFrQEWpOMQrbeFbilIGgDqGtVJOC+sd8dxmuqKAWKhYJQ/fctOzY0pJC4IPcfnxFXi4M4P5RgirhCAGlSrjAGSEeYU1iTZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DgoWne0q; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-22101839807so38327395ad.3;
        Fri, 21 Feb 2025 00:59:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740128394; x=1740733194; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=B+iQiaV0ZR0u2JkskpgLjGu+mpM0X+BFfY+TKRC5eH8=;
        b=DgoWne0q/9YUi9+udUvUPaUhdPB1ZCY7nmr8MuMa3KtJpNEHMbl3/nmccQuaA3W2HZ
         6B8gbmUMv+43ngScUs366fHriDxB16tSWrZTXNle3YXhJt8gOovMfs7k6sxSypp/Y9sg
         c5xTyLndk/htOYa/h0l90cPzm3Hhrhw7++iAmNwfB1tGX8QJqTFsvIT1Y+VTc1ab89wa
         ORbYrwbOlH2YAWE4LUv3rlGmGXeydBm+YnHCmYKcD5pCHrDEk8XGuvubMDnVaO7BYqmd
         JUOb5yn2U3uAZo1xfVm+FAzZZVCPSLVYuzc+/84jklVzwXnXGDFMTsrWPNwNxv2j0dSb
         AHaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740128394; x=1740733194;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=B+iQiaV0ZR0u2JkskpgLjGu+mpM0X+BFfY+TKRC5eH8=;
        b=PKdJ4eJql05qgIzhLssvdSJL2Qg9BJJ1V5VZ864Th8tLswQwEQfB7qOxZL7THCx9F5
         WTuFjt0r7xs/VaN4Y68HJ7fl2qHfPcR/UQbUHId+tO7QKT7b698HkLlKiKHUQjn7nNEM
         Dvs+A+5uqw/+IB5xJpBp1Cp5pfOi81PPYWRrYs4F5jFsaiFvy84FEvqLMsjQJDYrjegT
         7Nl6KmnpBZeZbJbUbGf54iYD4cTKz7HrQJ1MJZVa5yFHMVvBf9ads+OrjGONqc69d1Xx
         Ny+I+6lnsu1xadEJR6vpCW0v7GzL9ZIVl3+l7X9F/NM/N8FKeNLzg2ChX4G3hVxwooX4
         +HBA==
X-Forwarded-Encrypted: i=1; AJvYcCVJ5eBW/zAg6c4cn1e//TiSIB8e2UzXMedLDQpOORf1tJFivK8673aSBSupCzdiDJ5UZKjuXrnPFmIcEbU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwcDQ9zaTX/t8UYi2dnvcxhFHEeVsv0tDA4Hd1vbAby0EIylb9z
	mEXbftpMVzM+F5WMg+zER7azwMsjc/IosSkw70vzJHDInNVTh3OBmQV3Dw==
X-Gm-Gg: ASbGnct+phkOvaY5/22XFbTpGCKUbF9SP1aKWPtrwPT1ZtA9pbLkq1FSYpqpnc8O0AN
	Cw48ILEYwE7musi8wYkcKjIjMyKtl/A/2H94MApvQx2jFIuTadaVq2s4C5OFd9Ch4R5rbgUv22D
	LzCqDMwQVZcDosVlwR3vfU1EeyZp0SbR6+UaLw0FVD8SIlZ8yh0Pr2EnP44iIzeq4ssHHJvgJqh
	ye+OGMdwHSrGPjEKi56U1TqLJG4sLTRI7q46qsOwk/QnutNUZfjzXz0Y9RJ3wQgeVwxJcMtOY3L
	iCbU+FUtUYP1XEa5egcmtq0YdAE=
X-Google-Smtp-Source: AGHT+IGPdUp1Ztu0WZieCKW7u0C6kO7a1hGB/VdXRDdcnazlaCozpYrRDAbERy2HRdRdEviecYe7mQ==
X-Received: by 2002:a17:902:d4c1:b0:220:e5be:29c8 with SMTP id d9443c01a7336-2219ffd11eamr44172575ad.32.1740128394252;
        Fri, 21 Feb 2025 00:59:54 -0800 (PST)
Received: from minh.. ([2001:ee0:4f4d:ece0:3744:320e:7a6:5279])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-220d545c791sm130881125ad.117.2025.02.21.00.59.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Feb 2025 00:59:53 -0800 (PST)
From: Bui Quang Minh <minhquangbui99@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	David Wei <dw@davidwei.uk>,
	linux-kernel@vger.kernel.org,
	Bui Quang Minh <minhquangbui99@gmail.com>
Subject: [PATCH] io_uring: add missing IORING_MAP_OFF_ZCRX_REGION in io_uring_mmap
Date: Fri, 21 Feb 2025 15:59:33 +0700
Message-ID: <20250221085933.26034-1-minhquangbui99@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Allow user to mmap the kernel allocated zerocopy-rx refill queue.

Signed-off-by: Bui Quang Minh <minhquangbui99@gmail.com>
---
 io_uring/memmap.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/io_uring/memmap.c b/io_uring/memmap.c
index 361134544427..76fcc79656b0 100644
--- a/io_uring/memmap.c
+++ b/io_uring/memmap.c
@@ -271,6 +271,8 @@ static struct io_mapped_region *io_mmap_get_region(struct io_ring_ctx *ctx,
 		return io_pbuf_get_region(ctx, bgid);
 	case IORING_MAP_OFF_PARAM_REGION:
 		return &ctx->param_region;
+	case IORING_MAP_OFF_ZCRX_REGION:
+		return &ctx->zcrx_region;
 	}
 	return NULL;
 }
-- 
2.43.0


