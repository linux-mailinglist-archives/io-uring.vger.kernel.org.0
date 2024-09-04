Return-Path: <io-uring+bounces-3018-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B5FE996C000
	for <lists+io-uring@lfdr.de>; Wed,  4 Sep 2024 16:20:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E92581C25070
	for <lists+io-uring@lfdr.de>; Wed,  4 Sep 2024 14:20:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BF391DB957;
	Wed,  4 Sep 2024 14:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ajBq1VeF"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F66F1DC048;
	Wed,  4 Sep 2024 14:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725459466; cv=none; b=UmAOFLqO+d2TILjlb6y2Z7X/nnqINvc2XYGjMiBYTNBiIXzDdeFGosrJa85J7Z8if3qN2O7xSdsN/yk9QbNp0AMj1jGddPi594ufYEY2hCrPZaSgnz0HhTF8HvvTR0g1lThZzg6zVspA9y3k1yzUQioFpwVOVGlM22ilCfmW92E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725459466; c=relaxed/simple;
	bh=4Yxe+N/S1XVopK+KXa2fAy17xdpFXOaI0/Gs2uA7tVw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dP3qdzfBs5OXGqvGgcg8sbTPS0Mm0rTrr5iF8O18vau9QOHNJR4uiCdVw1Hv+dgBgJ/aCBEWdo38QQOcnbPGdkxultXd5j7oCR9FVsRd2oZ28gF0J27fZMXDDXROKjKLXuz7rlWqUdkmZIgJjUs1vUjx1DkYRuk5YFLgaeFAt6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ajBq1VeF; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-42bb7298bdeso74335555e9.1;
        Wed, 04 Sep 2024 07:17:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725459463; x=1726064263; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=HY15Bjqq4aKur+xvKj1EtQb6SIbOC5ont+cHg4lEL9w=;
        b=ajBq1VeFqY3GwXm30/JJ0zeIQwQfYuOSyT+zUGoyaqzeTtfOWvkw4jHwJerx4de0AM
         dDdwX+f6nnECtyn0NnZwBT3Psqd7kQyu0S9dLJmrb6RqOG3cYAlxcFxNNgzZAnB35Fvn
         IJMux6twBGh9cGkxM8QlHWJjylgrkACW3LIUWxz/1oj6OSrtgWAAiTZKZLLAlXagX4Y1
         wh8BMto0NKQk6fvXOEoyStw+viJ6/G0IKBipN3QXw19CcDCVon/wdUmCxwxruqgoKP5r
         fQD0XwrfGXcohraBcnuqd6Lk7DM/8oIEAHrmBrQHteZkrpK0i9UrOFClaDAyf8TK+w5m
         7PEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725459463; x=1726064263;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HY15Bjqq4aKur+xvKj1EtQb6SIbOC5ont+cHg4lEL9w=;
        b=J2wz4CblufIU8CLDi5vPxcl8oy/V36a7OrUv7B6Ys+7mExS9T7xNHEN3TK8QGX7vGg
         0tjkiTnbfwfFet9/H2f7GwG9ABxZk1XiocBax/f70O6x1vmtK4TJGG1876Q1m2SDo9GH
         fi2ZC2YZux5LV5pvO3BVmWXCk+lDMQG9p/Z0/VfrtOPo3YNPW3S/tT2FliPHzzQYQei0
         YRRzrcLeiK0XucrG9ly7ppCflKFy5pLVqyHxrU6641qTxVzFklqz4NCNF7J/Z1Tk1Ga8
         Ma6v5FUAYVGVgWdCJ1/nSEPehHuZLNY1aHBCK98c0u5zbqP/Jq0016na65eupktGL0Ch
         SoGQ==
X-Forwarded-Encrypted: i=1; AJvYcCU/y1rFAoAEpP8Ww3KRarbEXG4yhmP0tP5fWtJ1ykFelKRnPhr7ZNHJIAVpX2DjHuWy3qZGHS6EcO8EGw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwfCMPeQIOgybXm0Doc+MnYa0aGwe8KPsgcKcjFFKVNLyop/slx
	VL1PQ36GDVTofj8qjTk6CLFMZmvusMz5Zuh1ilC0+PlZahqbQvbzLzEilw==
X-Google-Smtp-Source: AGHT+IEwWK5Yj7vtJLC5Y418j0w9AbR/IgvD3JjLJ/GmnxmpSoNSgA7dlM+QCEdgLBruNVWlP7g0kA==
X-Received: by 2002:adf:f608:0:b0:374:c05f:2313 with SMTP id ffacd0b85a97d-374c05f2775mr10514389f8f.45.1725459461605;
        Wed, 04 Sep 2024 07:17:41 -0700 (PDT)
Received: from 127.0.0.1localhost ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a8989196c88sm811160766b.102.2024.09.04.07.17.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Sep 2024 07:17:40 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	Conrad Meyer <conradmeyer@meta.com>,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Christoph Hellwig <hch@infradead.org>
Subject: [PATCH v3 0/8] implement async block discards and other ops via io_uring
Date: Wed,  4 Sep 2024 15:17:59 +0100
Message-ID: <cover.1725459175.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There is an interest in having asynchronous block operations like
discard and write zeroes. The series implements that as io_uring commands,
which is an io_uring request type allowing to implement custom file
specific operations.

First 4 are preparation patches. Patch 5 introduces the main chunk of
cmd infrastructure and discard commands. Patches 6-8 implement
write zeroes variants.

Branch with tests and docs:
https://github.com/isilence/liburing.git discard-cmd

The man page specifically (need to shuffle it to some cmd section):
https://github.com/isilence/liburing/commit/a6fa2bc2400bf7fcb80496e322b5db4c8b3191f0

v3: use GFP_NOWAIT for non-blocking allocation
    fail oversized nowait discards in advance
    drop secure erase and add zero page writes
    renamed function name + other cosmetic changes
    use IOC / ioctl encoding for cmd opcodes

v2: move out of CONFIG_COMPAT
    add write zeroes & secure erase
    drop a note about interaction with page cache

Pavel Begunkov (8):
  io_uring/cmd: expose iowq to cmds
  io_uring/cmd: give inline space in request to cmds
  filemap: introduce filemap_invalidate_pages
  block: introduce blk_validate_byte_range()
  block: implement async discard as io_uring cmd
  block: implement async write zeroes command
  block: add nowait flag for __blkdev_issue_zero_pages
  block: implement async write zero pages command

 block/blk-lib.c              |  25 +++-
 block/blk.h                  |   1 +
 block/fops.c                 |   2 +
 block/ioctl.c                | 228 ++++++++++++++++++++++++++++++++---
 include/linux/bio.h          |   6 +
 include/linux/blkdev.h       |   1 +
 include/linux/io_uring/cmd.h |  15 +++
 include/linux/pagemap.h      |   2 +
 include/uapi/linux/fs.h      |   4 +
 io_uring/io_uring.c          |  11 ++
 io_uring/io_uring.h          |   1 +
 io_uring/uring_cmd.c         |   7 ++
 mm/filemap.c                 |  17 ++-
 13 files changed, 292 insertions(+), 28 deletions(-)

-- 
2.45.2


