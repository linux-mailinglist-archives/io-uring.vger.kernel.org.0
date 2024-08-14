Return-Path: <io-uring+bounces-2762-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B4BA3951947
	for <lists+io-uring@lfdr.de>; Wed, 14 Aug 2024 12:45:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5091CB223DC
	for <lists+io-uring@lfdr.de>; Wed, 14 Aug 2024 10:45:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD6D31AE03E;
	Wed, 14 Aug 2024 10:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PTgIS5Kd"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E7941448D4;
	Wed, 14 Aug 2024 10:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723632324; cv=none; b=ESeSkRqqKMEzRlYGsr8MdWcpkeYkPIIO+SXi+zDRyu1MHIMuF5lG8BeVX77k8QJ+RWryTK7mEM4lVjHqZqkWx9R/K/ETBb5llgGLXkD/Egx8H/bHZSgX2PMlN+xtgbVJCHU35SiL5a+cdXLtHcL4m8n06ipPQmTVNd0gJSybjIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723632324; c=relaxed/simple;
	bh=amKBBMp4xnYToJbWRRBiegoHTTx4884X3E3KKI2L3U0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dZaGfetvKG4o9JkCiHJWgA8k4JyTS1q0ROv6Cm1hRdKZSJe7tLl1uX58fo05+0+I7dXzowErWjywNtE4RTlZmCgSqe+JbTxmAoGmaJnu/PUIdqJaerfb9jowH3gZG8FNKB9L3t0KuWpYiMrnYfPnd5gg4o9vNnk8XWWBbIiRTks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PTgIS5Kd; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-a7a8e73b29cso608392166b.3;
        Wed, 14 Aug 2024 03:45:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723632321; x=1724237121; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=qM/+H+q/dNtHslpBIUYQjOqvFIMBvCtYMIlLtex0MfE=;
        b=PTgIS5KdCQn03owMb5Przr7r+b41KsENJbZNx3IsK8krmUhKgzKwLOo/DpAQTgbaYm
         XyJabAVq6UGk5Fypeq/Fwlgulj+a616ZFXtM+wQi3smERe4r59j0nxc1AdeHVMFN+/XW
         jpbtDbjqe51TNx6JoGKd1D5pXlfNaUmGfZXxR0GQfpGJG+gnXrdzYFjiRFrQIWRt1Cga
         VGGTN6OYn9N0ZhzjsQIkEXl7WJlrlO0fShAHWxdHVeuq5B/w24sGYigOGdY/45aHpiuk
         7EuHj3VQjFl/DjRHfJqiPlg5cQT0MyKtTqUDmdioGzV+4OsDMGF+inx4FUb27OTZmq44
         AYaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723632321; x=1724237121;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qM/+H+q/dNtHslpBIUYQjOqvFIMBvCtYMIlLtex0MfE=;
        b=aSIakwBpk9WTqgR+cuG7C2FPDTFUBxcXJYHtALS+vXoXwEcAn7HBpaDuUquKLTpy1a
         wb0r7xR92E0DNBwB+o1vO5c01cYwrRa/Sk2xW/rLWVcq2myT0J765MkixRvjBYKi69WJ
         nxTbS85K/vTvpEJXqy7KPbvxIgMXTkPCuOfrqVQRwn2iYN1dbetP75rVOLH1ONXVb/qM
         FpzkbYGssvxjxFssCpckYuj7rDHh5X4ufAblRKAVJSKcjZk5Iu0iT1GNqd6L1/C0ALM9
         kXZW52WLUXudF8LoGaiOKT/zPjOz5RCtrf6PGast/ss9UBzJGqw2nIbvva9A8A0r4Yj5
         moYg==
X-Forwarded-Encrypted: i=1; AJvYcCV4gDCQHg1ISCd9gsauVINVS75JZv54/d3K++Eej4jMBWncomLT/+IPTsRr63vHmNXvJQYjkgTJTSxAtDtHRvYbwxdzxvicSlqRIj4=
X-Gm-Message-State: AOJu0YyaYpInmz1QfSGhsFyWZQfSFadkhRISR9jVAEv304upGKL3QdD+
	AW51FElUQf4YkpmiD7Nz5EGgUk8xngrvZ5HtDJVnLMoIlI0r3qhy0MsXOLC5
X-Google-Smtp-Source: AGHT+IHdFQH/XhI3MmWWusGKBBhP3P128eD6d5du59qhURe8iVDeuvNJeHFRQkMLrrS+UEfann4zlA==
X-Received: by 2002:a17:907:e6cb:b0:a7a:83f8:cfd5 with SMTP id a640c23a62f3a-a8366c31b00mr153852066b.18.1723632321090;
        Wed, 14 Aug 2024 03:45:21 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.132.251])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a80f418692asm157212766b.224.2024.08.14.03.45.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Aug 2024 03:45:20 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	Conrad Meyer <conradmeyer@meta.com>,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC 0/5] implement asynchronous BLKDISCARD via io_uring
Date: Wed, 14 Aug 2024 11:45:49 +0100
Message-ID: <cover.1723601133.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There is an interest in having asynchronous block operations like
discard. The patch set implements that as io_uring commands, which is
an io_uring request type allowing to implement custom file specific
operations.

First 4 patches are simple preps, and the main part is in Patch 5.
Not tested with a real drive yet, hence sending as an RFC.

I'm also going to add BLKDISCARDZEROES and BLKSECDISCARD, which should
reuse structures and helpers from Patch 5.

liburing tests for reference:

https://github.com/isilence/liburing.git discard-cmd-test

Pavel Begunkov (5):
  io_uring/cmd: expose iowq to cmds
  io_uring/cmd: give inline space in request to cmds
  filemap: introduce filemap_invalidate_pages
  block: introduce blk_validate_discard()
  block: implement io_uring discard cmd

 block/blk.h                  |   1 +
 block/fops.c                 |   2 +
 block/ioctl.c                | 139 ++++++++++++++++++++++++++++++-----
 include/linux/io_uring/cmd.h |  15 ++++
 include/linux/pagemap.h      |   2 +
 include/uapi/linux/fs.h      |   2 +
 io_uring/io_uring.c          |  11 +++
 io_uring/io_uring.h          |   1 +
 io_uring/uring_cmd.c         |   7 ++
 mm/filemap.c                 |  18 +++--
 10 files changed, 176 insertions(+), 22 deletions(-)

-- 
2.45.2


