Return-Path: <io-uring+bounces-4887-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 16BCB9D4481
	for <lists+io-uring@lfdr.de>; Thu, 21 Nov 2024 00:33:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B79271F22183
	for <lists+io-uring@lfdr.de>; Wed, 20 Nov 2024 23:33:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28FE01BDA84;
	Wed, 20 Nov 2024 23:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ID+DPYr/"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61AB419D078
	for <io-uring@vger.kernel.org>; Wed, 20 Nov 2024 23:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732145588; cv=none; b=Amj0O5i2oMxmX83PmiCiC0f29sAMHtyCvMI9uzEWaC52NBavh92e6siFFshfJ2BG5nNLJ2ihYM9T9p7MV1aPi6jTTnppO4KR+eBEhmL25kOYxAu9W8BnG2v33EefRVGoI5dg89uPeaQysE8Syc+rUCxWyzKdH44PAJ49AhRF2JU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732145588; c=relaxed/simple;
	bh=K3TtKA6g3XkDDBbKMp7MoDAhNT+YQxjo04InIRDdJRk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=D4QZpk2iPMmqZ2zFY3iypBYBuSLScZh9CfaP0CO4v/3dm67GqeX5ITrhGkQLYqJ5S/nX2B7ngTkcyzfb15OLjZKwvMyiXoREjYyrZEG1x55PkomvGP23CYkCMlVnoGjmoim3Of03NZs5I5UWLHnHFVGs7YULE2IZW9GIUR12Ja8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ID+DPYr/; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-5cf9ef18ae9so2696090a12.1
        for <io-uring@vger.kernel.org>; Wed, 20 Nov 2024 15:33:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732145584; x=1732750384; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=eC0QBa29p4gW7OtPVG2SnOozp2CTEyRbTSyWv17F1qQ=;
        b=ID+DPYr/7eACCTDNI5dMe+WVRiwQixdW/MUT1gQIWgppFWzsMLUymwJS6UREqSTQHi
         w3nI5ZkUnBMhFVEkRpSyJBIrMlYC1SRPwEq6o3Z04CzjeDyRngVTbbLz0TJf4hREy477
         +k0xUSJgjIuxFAlJHQETyKw9ze3nd08yEFRgyyXyR+FLKsrzpsu3UOYs7UeJjcnd0hIl
         lUODURjlsPPEeWZwbZqOl9qRjyFTXdn9UNR04UL4ZBQ7UPOQDqokaXKBpv3edrJAp3ZY
         KKwaG5iN26PTv4pgK819cMs/BL6v1dL7RkF9wiVxfe+OXwsOluqlzo7ThILmYxiJmJM5
         WBxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732145584; x=1732750384;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eC0QBa29p4gW7OtPVG2SnOozp2CTEyRbTSyWv17F1qQ=;
        b=k/V8OjG3607LadmRXfEQ2VIPBvxm9cZjlq2bIUw0DerQ6eZByQ5GHjlVxa9Kr7eTow
         NxWBtzhfUByoW5jFwrZzLZloTOIKsrTsP4vYyx01WvmUnBJcnJqfwSPKBzRE67AnOQjq
         cSIO94p8/NJ4UhgeyZeIdnq/NDvjnnDslvRI0AkmqW9DdtxZOLp+rbjM9P1+sNIEsMjg
         CkyZfayGFyqLsZlEEXNgl9g1wJ6sIXmzpxV4YIplfQ4slq8qVTqryLQBUnQ45Bv8OjzJ
         0kO+Fjxbeagk/KHrtyvjUNUkjF3KhgWHDgPkEek4Q8kqyO0F3EaSsOKZMC+6+KPAjy3r
         s0lg==
X-Gm-Message-State: AOJu0Yw5MpEIUUsRpOC9woY2VDvtfJ1PRYl9j67cwNhdH2bcOPtEwksU
	FHnbqTcBwK6gAQRuV/9t4p8OugFZ6ey7rIqYDrYM1Um/RvcCPBWBOG8z1g==
X-Google-Smtp-Source: AGHT+IEBQedLZeUOD2zFSIpQX9GYm4kEy1oFrJL4pka5XBxSlfll2o4P/eCIHp7rE12HW8EyzeaKTw==
X-Received: by 2002:a17:907:3f1c:b0:aa4:e53f:5fbe with SMTP id a640c23a62f3a-aa4efd9cf33mr133358866b.19.1732145584348;
        Wed, 20 Nov 2024 15:33:04 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.141.165])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa4f415372bsm12166066b.13.2024.11.20.15.33.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Nov 2024 15:33:03 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 00/11] support kernel allocated regions
Date: Wed, 20 Nov 2024 23:33:23 +0000
Message-ID: <cover.1732144783.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The classical way SQ/CQ work is kernel doing the allocation
and the user mmap'ing it into the userspace. Regions need to
support it as well.

The patchset should be straightforward with simple preparations
patches and cleanups. The main part is Patch 10, which internally
implements kernel allocations, and Patch 11 that implementing the
mmap part and exposes it to reg-wait / parameter region users.

I'll be sending liburing tests in a separate set. Additionally
tested converting CQ/SQ to internal region api, but this change
is left for later.

Pavel Begunkov (11):
  io_uring: rename ->resize_lock
  io_uring/rsrc: export io_check_coalesce_buffer
  io_uring/memmap: add internal region flags
  io_uring/memmap: flag regions with user pages
  io_uring/memmap: account memory before pinning
  io_uring/memmap: reuse io_free_region for failure path
  io_uring/memmap: optimise single folio regions
  io_uring/memmap: helper for pinning region pages
  io_uring/memmap: add IO_REGION_F_SINGLE_REF
  io_uring/memmap: implement kernel allocated regions
  io_uring/memmap: implement mmap for regions

 include/linux/io_uring_types.h |   7 +-
 io_uring/io_uring.c            |   2 +-
 io_uring/memmap.c              | 190 ++++++++++++++++++++++++++++-----
 io_uring/memmap.h              |  12 ++-
 io_uring/register.c            |  12 +--
 io_uring/rsrc.c                |  22 ++--
 io_uring/rsrc.h                |   4 +
 7 files changed, 198 insertions(+), 51 deletions(-)

-- 
2.46.0


