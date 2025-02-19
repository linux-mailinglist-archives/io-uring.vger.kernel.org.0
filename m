Return-Path: <io-uring+bounces-6549-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D20E0A3B00D
	for <lists+io-uring@lfdr.de>; Wed, 19 Feb 2025 04:34:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A9387168F65
	for <lists+io-uring@lfdr.de>; Wed, 19 Feb 2025 03:34:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E337C8F7D;
	Wed, 19 Feb 2025 03:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="RLn71sKu"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f228.google.com (mail-pl1-f228.google.com [209.85.214.228])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ED7317A31A
	for <io-uring@vger.kernel.org>; Wed, 19 Feb 2025 03:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.228
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739936092; cv=none; b=RK2CP4o8TEHvpMUT/+QCxQeZybU3nHnFeiP8Tw+Hocqs1m70XYsuuwdkGo5+d7DDiE9yxxr8Z94Q7/I5BiMgbBp/8kwYp+SxwHBsdUeQ+B/UfCSCEgayHixtfh9wjjHsvvg0F/nAvScBHDMv4Q9tSz8swmRx86NMUP+aFsFw11k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739936092; c=relaxed/simple;
	bh=nps8bhqqW9C31UMiIA1K5irHfRijgaCUHJE1SPI3/+c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OeRJ+RaScVQ0q+dfrZYWfSfzx+7mgkD43o6KtWwJ8zbvdNO6gJclF4UidamLFVeq5buqhRD5o20Iur8Vhp/kAJFuj2UWrFPhvEuAMaUYY3jzVgxKT8Ap7CshfawAUShlAkZMK0Xk8ksqkUB68u3HFzxnMI5pdBYcKHWp2QVdFck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=RLn71sKu; arc=none smtp.client-ip=209.85.214.228
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pl1-f228.google.com with SMTP id d9443c01a7336-220c895af63so15604835ad.0
        for <io-uring@vger.kernel.org>; Tue, 18 Feb 2025 19:34:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1739936090; x=1740540890; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=oWmLSi2mB7M9yGiVBZcQbkxr3CzoST/Pj74hRTCGb30=;
        b=RLn71sKu3iTdBbM0nEP92OSgoR2tQ7Fa1alGlaAB9sS3Mw+agmv39e8w6mLL3HTvxP
         EojBv5C2t6yTofKhXJZipxiCmOqo1CYaPIdm8vw2WaZzYzIUjTfjbz71o4EpjM1cgFKy
         rdMoJktL5qWvDrnY25tUCKDQXweGjvPgGLFa96Z1rqw6pkBQjQ8J4TEYHdB+ylKu03Wh
         reNEEDyACUNgOaOYEcjr1NKMMIe9xy/n1gyEalj/pxCDVinge/y3M/4NlqFhCQvcQxAS
         jlwCbSZRhFXZtaWt7fuczXtOAYyV81z+SsoLe0rZgbfe/hBmFvfdvUdq7W+dgM1tuRnT
         sYaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739936090; x=1740540890;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oWmLSi2mB7M9yGiVBZcQbkxr3CzoST/Pj74hRTCGb30=;
        b=GfVj3WFLF6GItOocNBrru0r2fOyiN384mLzxZ/41PE9lZSqqOqFLe1OQqpOau7DkOo
         8edJ4JtUlqd5u1PInrEbTocNG30RdhuEElO5luGpPZbZvYYl9a4wOF+eR4s3ehogZn64
         H2WSbeTpvj7/bJQ2iG/MU0xg6+INbf7zwrBjqEXXBq1SdeT/qhtmvezEPm2MjdnpOY5r
         0fbPxzP6HVqaxmta71aXyUCufKoY95J8YYC1vwU/JcpPHEvPsm0i1ak42oZRNYEYAj1p
         MLNDdPHtAEbtUxh6qOlCN82gdweaZ8NxTjEey9kYSbylf6ot/a2amGAZI/7U4t7nFeIS
         55QQ==
X-Forwarded-Encrypted: i=1; AJvYcCXFG/CScd94zHQq/ifMQ6cioxhr5DGQ4cIiXZX5UkL0huaDa3G26cF6iI3kSUFL7EffAlcbvUJ1FQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxTggbQv8bxIE7Beyq5gmgDMdBCHkdtlkss8pypZdX1hNFWFE9G
	byDffx43gBsZlnoPMwy9i6rdcvp3lbsH4p5ZPMm2H0vTqanNytSKMfdR8Iwu07IBbWNO6SDZAgj
	K3HXzLpG6MjZe6ymo7sM1SZmrTBHciPutgA4fwZ1U19OQkO+4
X-Gm-Gg: ASbGnctig5iHy4JiFVNSHt0xvhpE9LhvneZD3X/Fh6gsaBg6gmnoxsQl3n2dTYljXVH
	tN6lCVhNN9yo7I7+r+qvcd1d2Kf/0k3gL5fLgv38aP9mT0I7MGgXbw4Nfjo3J2hQRczwl6V8TCT
	2PE4h1eeunaXKD7pH+5WnJ3zNu/lmYODd//m9rh3FNBtlZO7indnP43ywmPGGx7VK1uELgHLuIK
	RkMvymO7m/0Lx6HQU6+Ek3qXzgE1sjeoijpfjmygb3SsdBxtYGbS0dG0+SGpbYaQg/tZS8Tai0Z
	9HvwWBo8wiXp6hlfQbeH8E4=
X-Google-Smtp-Source: AGHT+IGSnWI6/oo0pSCxMy/XF1XplpCCogXqJteEhB5BWQPqOLmP54GMkGp0qkgHp8tJhMhpxzRxr1dnG5jd
X-Received: by 2002:a05:6a21:6da6:b0:1ee:d621:3c3f with SMTP id adf61e73a8af0-1eed6213ceamr1083705637.0.1739936090265;
        Tue, 18 Feb 2025 19:34:50 -0800 (PST)
Received: from c7-smtp-2023.dev.purestorage.com ([2620:125:9017:12:36:3:5:0])
        by smtp-relay.gmail.com with ESMTPS id d2e1a72fcca58-7325b336950sm708046b3a.7.2025.02.18.19.34.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Feb 2025 19:34:50 -0800 (PST)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.7.70.37])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id A6765340643;
	Tue, 18 Feb 2025 20:34:49 -0700 (MST)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id 9FD0EE410B7; Tue, 18 Feb 2025 20:34:49 -0700 (MST)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Cc: Caleb Sander Mateos <csander@purestorage.com>,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] io_uring/rsrc: remove unused constants
Date: Tue, 18 Feb 2025 20:34:43 -0700
Message-ID: <20250219033444.2020136-1-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

IO_NODE_ALLOC_CACHE_MAX has been unused since commit fbbb8e991d86
("io_uring/rsrc: get rid of io_rsrc_node allocation cache") removed the
rsrc_node_cache.

IO_RSRC_TAG_TABLE_SHIFT and IO_RSRC_TAG_TABLE_MASK have been unused
since commit 7029acd8a950 ("io_uring/rsrc: get rid of per-ring
io_rsrc_node list") removed the separate tag table for registered nodes.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
---
 io_uring/rsrc.h | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index a6d883c62b22..0297daf02ac7 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -2,16 +2,10 @@
 #ifndef IOU_RSRC_H
 #define IOU_RSRC_H
 
 #include <linux/lockdep.h>
 
-#define IO_NODE_ALLOC_CACHE_MAX 32
-
-#define IO_RSRC_TAG_TABLE_SHIFT	(PAGE_SHIFT - 3)
-#define IO_RSRC_TAG_TABLE_MAX	(1U << IO_RSRC_TAG_TABLE_SHIFT)
-#define IO_RSRC_TAG_TABLE_MASK	(IO_RSRC_TAG_TABLE_MAX - 1)
-
 enum {
 	IORING_RSRC_FILE		= 0,
 	IORING_RSRC_BUFFER		= 1,
 };
 
-- 
2.45.2


