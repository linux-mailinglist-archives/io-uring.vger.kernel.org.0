Return-Path: <io-uring+bounces-1307-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 98CAB890E86
	for <lists+io-uring@lfdr.de>; Fri, 29 Mar 2024 00:34:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 57043296758
	for <lists+io-uring@lfdr.de>; Thu, 28 Mar 2024 23:34:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8289080BE0;
	Thu, 28 Mar 2024 23:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="02I/p4tL"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF51C225A8
	for <io-uring@vger.kernel.org>; Thu, 28 Mar 2024 23:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711668889; cv=none; b=ADiSR9spgz755DOpeYqcP4yBZTZBHSg4AEn/XH9Y6z1u2tjSOBu6ulInegnTgE3jsER6ezNjitCQIjgxa4wen7EUdR7rA9kd549/Ban3OtkdLGQdllk/8JtZ1CR7CKmDz7BEmXapmmEooAC5VBVyxtzz1kwWCQRiZ4K+tK2oLXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711668889; c=relaxed/simple;
	bh=xjvyxtZ+j4cPbvv+hKOL5jE3H/iCtfhUd9DsFgDbvVA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=b1dmdQr7Af0Dfax/xD+RPphRs87WhtySc8Vz9hFh/QxoQ3ATuBpCsq6NXNDFAL9m1izmnmilFeAhQni1Btfxg8VvLCKhOfvIoiq9t7DrInN1eJgYqToM5G7Pf6Zm4OV4Mm8V8rFDasktjKXtJ/8Nq4X6Dqp9T1NVrhGa9DF2Zt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=02I/p4tL; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-1def81ee762so3337515ad.0
        for <io-uring@vger.kernel.org>; Thu, 28 Mar 2024 16:34:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1711668887; x=1712273687; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=0oJgXvEuwvRnZZikuFCff+M/MPajPVlsVl5ZSdawolo=;
        b=02I/p4tLdn8ED8YLqRiWdfC3AKR6whKp8GtJFG5lU6SGN53YY2GelB8GM0xWOoByNM
         U330o3saO2H8Un8jFVwVKY+X9861s62xzsrpXne1LTGdZOSsYk/wz8ZVRyA3g5xielVt
         5/cQ3XbMvO35GfJXJNxWOJbFUcV5uQoW4TMxTTiNId0oZDt4G8QC4U6lajfjZ4BRoSC4
         vr3WNyguWzFYv0/l/lpFlrrvV+eu1J0GHFCYH7hGQF+zqtOzcke8wH8gHMpFi6GBUWpM
         EAmNa9KqovJgFChQpC4qnJ8Pvc9zFtLOJQkDE3R5fiAKWvy8YOI2x64ikjZIkAM11F1I
         2aHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711668887; x=1712273687;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0oJgXvEuwvRnZZikuFCff+M/MPajPVlsVl5ZSdawolo=;
        b=uGFwvB96siHJStWhWBC6BPUOjzspNc7gaRo8YXKXvnpdt3vtRwP+5n/8V8Xi4kM7jQ
         96kDVr7TTWjHgf+IyF1mlWIDf9V+Yoo8WusNVsvyyzRfR8paxF7zjEaIumEm6UFkqM81
         TM7mrLGbb0o3wMzN7VmCblZzD5BogTt9UXeKveKfleGQfiGkrKTuHdhT8MutFWDV//vF
         LYzGeg9DtY01HSqDPQ6njuwgAyr15SSPJ0JC9gkWSh0aUNpxNtgME0q31WpKL3BPbyZJ
         cB7bKhUjCOZ8WLBxKE5pOR7Gvhfi82w5wOfJbICA2bpggAurH4s8fopnXaRNuVLc0nXQ
         U9iQ==
X-Gm-Message-State: AOJu0Yy/QY8dPc3o6RE0VzJMLTW0s8Z/yuDekLS1w2dEK2ot1vdNvInx
	4G6wzFwVs9GdMVK4tMgRBcmxbvYVDUNTvTNdB435LBfLeDfPAqVEPiRW+/qovjUdTKzhYuE/Lzs
	d
X-Google-Smtp-Source: AGHT+IHK8JxFi0VDT6pK3hMLieTrgE0yZTd3bgFh6m4Riav3CMt+1mc7AsG81NefeJjCRXPf52FG5w==
X-Received: by 2002:a17:902:aa85:b0:1e0:b5f2:3284 with SMTP id d5-20020a170902aa8500b001e0b5f23284mr1034693plr.0.1711668886672;
        Thu, 28 Mar 2024 16:34:46 -0700 (PDT)
Received: from localhost.localdomain ([50.234.116.5])
        by smtp.gmail.com with ESMTPSA id i6-20020a170902c94600b001e0b3c9fe60sm2216981pla.46.2024.03.28.16.34.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Mar 2024 16:34:46 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: hannes@cmpxchg.org
Subject: [PATCHSET v3 0/11] Move away from remap_pfn_range()
Date: Thu, 28 Mar 2024 17:31:27 -0600
Message-ID: <20240328233443.797828-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

This series switches both the ring, sqes, and kbuf side away from
using remap_pfn_range().


Patch 1 is just a prep patch, and patches 2-3 add ring support, and
patch 4 just unifies some identical code.

Patches 5-7 cleanup some kbuf side code, and patch 8 prepares buffer
lists to be reference counted, and then patch 9 can finally switch
kbuf to also use the nicer vm_insert_pages(). Patch 10 is a cleanup,
and patch 11 moves the alloc/pin/map etc code into a separate file.

With this, no more remap_pfn_range(), and no more manual cleanup of
having used it.

Changes since v2:
- Simplify references on compound pages (Johannes)
- Fix hunk of one patch being wrong (Jeff)
- Fix typo for !CONFIG_MMU (me)

 include/linux/io_uring_types.h |   4 -
 io_uring/Makefile              |   3 +-
 io_uring/io_uring.c            | 246 +-----------------------
 io_uring/io_uring.h            |   5 -
 io_uring/kbuf.c                | 291 ++++++++--------------------
 io_uring/kbuf.h                |  11 +-
 io_uring/memmap.c              | 333 +++++++++++++++++++++++++++++++++
 io_uring/memmap.h              |  25 +++
 io_uring/rsrc.c                |  37 +---
 mm/nommu.c                     |   7 +
 10 files changed, 467 insertions(+), 495 deletions(-)

-- 
Jens Axboe


