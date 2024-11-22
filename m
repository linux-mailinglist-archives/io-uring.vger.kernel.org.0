Return-Path: <io-uring+bounces-4975-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C3589D61DE
	for <lists+io-uring@lfdr.de>; Fri, 22 Nov 2024 17:17:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1C56C2833D8
	for <lists+io-uring@lfdr.de>; Fri, 22 Nov 2024 16:17:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E7251DF24A;
	Fri, 22 Nov 2024 16:16:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="anrHbmVJ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f175.google.com (mail-oi1-f175.google.com [209.85.167.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15ED529A5
	for <io-uring@vger.kernel.org>; Fri, 22 Nov 2024 16:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732292215; cv=none; b=oL1Q62V+ipMz4GGT2DPROwV4LpP81g0kaxj1BalvySwwMAs6oxau8Zr7ycRkAo41VK8Z6x7no813d8VnbcoK9wodFERdNVivTUvt5c0Bw6DqFDJAubNr0oSv8RwwI2Y6Nfx9aKJG056XlwmKlQtxrzxUlqKOdYUI2Su6wI5MwVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732292215; c=relaxed/simple;
	bh=psVgLV/iMyBJbyTbV9sBpK2oIJ0WJHPn6uFNTqDydWU=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=i5mUSSIJIcvKJ9hcg0gA8Ks9bl7bkXNRAP+SLW4ksVKHeycI4Vl75S8TbGjlbNTrdYIHdNPoDCmQv+hhCN15W/caVrr6fuUvt8/1SH4IiALEHjixMtPet6ZsLHjqEd2wV3+vFcgSONxGryfNYzdqu9iGkrVGVmpdojVP0vBGs7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=anrHbmVJ; arc=none smtp.client-ip=209.85.167.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f175.google.com with SMTP id 5614622812f47-3e5f968230bso1134262b6e.3
        for <io-uring@vger.kernel.org>; Fri, 22 Nov 2024 08:16:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1732292209; x=1732897009; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=zqntn0ii0idoUTtjIYOK5+4diPmA6pG7k2CKzGdDZQA=;
        b=anrHbmVJdMSzV3arBSX+kVGz9YKycMgLP99/RGHse8tkVIk7okkXpXSqaj+uLBtTrO
         XieX6R90EQqw46/4dF4BpNs+KMM+DgH25M4tg6aBWHJcgh83jgQ/VY1F0gxboCNCKNqA
         2/t6QhGDLqXzGo0xYjlrfTX0osllwHFoMpGEFCQM43VWlR1eZbvnHOYNg5wghzIItHVe
         X+ne35EJ8+I9T9cW664b17BXB72L4NkrzkUb4m61mGXqUt3jr9eeBQ434BFXvyUZ7gWw
         Gcrvs67Yn4J2FEJZHk80QPbNW0YlLcgNa3DUx4pm8iIAcvzogu6C/AUVrjAcYiofoYvY
         jm2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732292209; x=1732897009;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zqntn0ii0idoUTtjIYOK5+4diPmA6pG7k2CKzGdDZQA=;
        b=K+jmC+DoBu/fh4izKtcdtLuNVx2ywZ8MlaLoGxenjaQgU9H8oYMLAXY6WJNqvp4/LM
         PD1lZ29DNY1GCJU1ezAdIDsXICfEsZmV6culMpNNuSZJHpsJFHNYkBCNinEkPLAv7gjL
         uAW4jdR51y32RD9wq9jw2cgKu4BZRbQ4MgxbckYXE7XXEq5u2eZILQoUc7z6sRR4LjI/
         fCJ7eNc5fmg8/vwh8lHj+e5Nyk6EuV56DL/tRmxcx6nNdpe9aoqyopwxyYuxdNhy1IPN
         7QrOIo0BHYPGYDNNY6mg1m+Wx4XVqD8mJ8RW9yOZm8oMGyv9P4Zir8pRDb6zSHKgyX07
         +Vuw==
X-Gm-Message-State: AOJu0YzxOw70DkNitBRTgv8OhGVKMwQdDQz5lMYi7sgXLdCRG9VndYb3
	qQZbxseCyIW4v5Fj0ItzWetHHVHvAo6gSKgGY8yxwjAi6gltiHhi8UO1OQoHjoJzzr3HPXjzeVe
	8ii0=
X-Gm-Gg: ASbGncsIqZ++00yl3RyVa86PKAgrKSgl5cAExuDhsMbSY22VW42rRaLmbfgGDb9kJqj
	yUAIUim/OxebnHMU+NhYMU7c1++bKxF3VpjzYgm1mp5PQ/+XFQb7vmpTvmo57TdfvEoZuU4dv8u
	cYkr3eRcKJzGKIi85s3b4vFdfDTHRCyU8CCmySfJSSy/zyXvac6FwyYBITEupElzm6RF3cIBVRL
	l8bgiX9MpEeS87ud5fo0Xpcy1GZpGl5YYHYS6+MnCBm801747Odng==
X-Google-Smtp-Source: AGHT+IG+gg2u1j5k8frxlou22pT11tFicfTDGms5g8U2BqxktZWRhDMGh4QOSZSpOeL2A1UGnLW1YQ==
X-Received: by 2002:a05:6808:250d:b0:3e6:951:8b3b with SMTP id 5614622812f47-3e915a1b3d1mr4044093b6e.30.1732292209222;
        Fri, 22 Nov 2024 08:16:49 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-5f06976585esm436958eaf.18.2024.11.22.08.16.47
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Nov 2024 08:16:48 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Subject: [PATCHSET for-next 0/6] task work cleanups
Date: Fri, 22 Nov 2024 09:12:38 -0700
Message-ID: <20241122161645.494868-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

This patchset gets rid of using llist for handling task_work, for both
local and normal task_work. Instead of a lockless list, a normal
io_wq_work_list is used and protected by a spinlock. I've done some
benchmarking with this, and I only see wins with this - the act of
adding or iterating task_work is the same cost, but we get rid of the
need to reverse the task_work list, which can be substantial for bursty
applications or just generally busy task_work usages.

Patch 2 implements io_wq_work_list handling for deferred task_work, and
patch 4 does the same for normal task_work. Patch 6 then also switches
SQPOLL to use this scheme, which eliminates the passing around of
io_wq_work_node for its retry logic.

Outside of cleaning up this code, it also enables us to potentially
implement task_work run capping for normal task_work in the future.

Git tree can be found here:

https://git.kernel.dk/cgit/linux/log/?h=io_uring-defer-tw

 include/linux/io_uring_types.h |  17 +-
 io_uring/io_uring.c            | 293 ++++++++++++++++++---------------
 io_uring/io_uring.h            |  20 ++-
 io_uring/slist.h               |  16 ++
 io_uring/sqpoll.c              |  20 ++-
 io_uring/tctx.c                |   3 +-
 6 files changed, 211 insertions(+), 158 deletions(-)

-- 
Jens Axboe


