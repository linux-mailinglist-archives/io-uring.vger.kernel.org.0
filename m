Return-Path: <io-uring+bounces-2867-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0852E959F8B
	for <lists+io-uring@lfdr.de>; Wed, 21 Aug 2024 16:19:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B53C1283233
	for <lists+io-uring@lfdr.de>; Wed, 21 Aug 2024 14:19:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADAE41B1D58;
	Wed, 21 Aug 2024 14:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="n5ZB8Q+q"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f180.google.com (mail-il1-f180.google.com [209.85.166.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7126118C348
	for <io-uring@vger.kernel.org>; Wed, 21 Aug 2024 14:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724249957; cv=none; b=NcVBMVwmbihSvYr2FoTG0olQOt08jfvDWC10SZ6+FsF4tHUjMzFDHBCZu67FLh084uy9G5mXuB3qlE5301RYFtc0UtS/T4gDcSTuu1NUB3+F/FtMdc5scBsduLRKr49TbYcbw+sWHOvkreDuSkes1uNlf2Gz8cB4/6U/nwpuhuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724249957; c=relaxed/simple;
	bh=SaFJU8VADDZoXJ2uHpWJtqUZ7Ey014do592P0QJXuHk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZgIGnOG9d2m4TYZaRFtIzYbWk/prOF8Fa/gTXUEGmwZnZxF89Nfk75u0pFHllwpbDmlJgIv7IvgLJCdZ1HwQkTxlVDVrgYo4nZhYeu4jAxhO8+koCDKA7RtjaCdZ2at1He/Zwo3qRtxv7HAIq5PGpgn4wmHCAYAa8tcYexY/DMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=n5ZB8Q+q; arc=none smtp.client-ip=209.85.166.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f180.google.com with SMTP id e9e14a558f8ab-39d31d16d39so16172535ab.0
        for <io-uring@vger.kernel.org>; Wed, 21 Aug 2024 07:19:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1724249953; x=1724854753; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=34pN4P3pOPmGwZgsQCNbVUNjaon27ZTQZNWrGQrp5zM=;
        b=n5ZB8Q+q+rT1i4EjIXAXiehd9X9Y8/n4gSL3QWr2jxOx3BLPAXZz3Dl9XNG27MoSwL
         tiI/Y3fVz48bgzISwtPh/R9Wn66CYcGe6QRu0TmFWiEp4osRJQV/PDwc9n8sD0Ww7eJL
         g97w7UlNMN8sAD7r5k5ONQGr3DUOlSz50SOb3LbdzGk5P/9TksFHEwEftdJdimN+D3kh
         WoyX1CdBoYh7Sq2NzQhmaZ4/7eWM8mEusdK7NsR5vUzbp4C9R8+NmPIWKHzcmkv+9Ib5
         E518d0JLku3tDWDL/zm9Z+hqZgRKFiLtZHtd55aijHdG3dFKdLbhQp/GkxQY67w+4h0E
         nEZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724249953; x=1724854753;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=34pN4P3pOPmGwZgsQCNbVUNjaon27ZTQZNWrGQrp5zM=;
        b=UCRwQ/r5gGaGkCukd+J4hKPw4YQFop0ZhuV9/hO/KvSac29Pg6OMKSal16BjL6BUgt
         4Vt+1oQ0AMna776w7OTJyCVOL9SuJvalhzu5F69BrMM2G3d3Lfo/bU1lw3NbzKz1WYpt
         ZSt8wGxiJfjiW2QHmc7dOE5nftk5VKiCm1bx8hVqrX08nHPoJb2CSJX9jjAgUayKtX8I
         ta2Ig9um2olB1rd9nusskeTvh3b3kFr6OsV8uLNOXTsSkyc43NDpQqW+9rr0t3RLYCKz
         UPuzKTWJoNCOuK79dzZqkRE94XQHPFFGjhXKr9Pr/w4O/Jl6kS/hgLBmYcdnzHnAVdXD
         ui2Q==
X-Gm-Message-State: AOJu0YwbIofWlUyDbvY1Bn28s6WRTvQo3SulTAc/ilIzkgXXVu365XNj
	3XcBj4C6Ptgspo/gifO1Ggs9HvpgVYoAoe3wfjpVLpww4GP3MCPRKmr4p1cgfFDVYJOLyWAIvAg
	i
X-Google-Smtp-Source: AGHT+IHTtjBNWrDxyKlbj4h56zwlWf1zfVbuuXYOWwOC+yeOpGgPLjZFbxWpjBxKi6ZN3HxyZ1keAw==
X-Received: by 2002:a05:6e02:198b:b0:39b:28d1:169b with SMTP id e9e14a558f8ab-39d6c390340mr28664215ab.15.1724249952735;
        Wed, 21 Aug 2024 07:19:12 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-39d1eb0bc93sm50967285ab.19.2024.08.21.07.19.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Aug 2024 07:19:12 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: dw@davidwei.uk
Subject: [PATCHSET v5 0/5] Add support for batched min timeout
Date: Wed, 21 Aug 2024 08:16:21 -0600
Message-ID: <20240821141910.204660-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

Here's v5 of the min-wait patchset. For a full description, see the v2
posting:

https://lore.kernel.org/io-uring/20240215161002.3044270-1-axboe@kernel.dk/

As before, there's a liburing branch with added test cases, it can be
found here:

https://git.kernel.dk/cgit/liburing/log/?h=min-wait

The patches are on top of master with for-6.12/io_uring pulled in.

Changes since v4:
- Use READ/WRITE_ONCE consistently with iowq->hit_timeout
- Unify how io_cqring_timer_wakeup() handles ring types by always using
  wake_up_process().
- Fix race in min timer wakeup with DEFER_TASKRUN
- Don't reset ctx->cq_wait_nr if timeout has been hit

 include/uapi/linux/io_uring.h |   3 +-
 io_uring/io_uring.c           | 191 +++++++++++++++++++++++++---------
 io_uring/io_uring.h           |   4 +
 3 files changed, 150 insertions(+), 48 deletions(-)

-- 
Jens Axboe


