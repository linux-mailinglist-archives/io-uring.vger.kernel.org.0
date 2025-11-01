Return-Path: <io-uring+bounces-10315-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5DDC7C275F2
	for <lists+io-uring@lfdr.de>; Sat, 01 Nov 2025 03:24:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ABB001A27F7A
	for <lists+io-uring@lfdr.de>; Sat,  1 Nov 2025 02:25:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 984BD2566FC;
	Sat,  1 Nov 2025 02:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="vFfB196g"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f48.google.com (mail-oo1-f48.google.com [209.85.161.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 380C917A309
	for <io-uring@vger.kernel.org>; Sat,  1 Nov 2025 02:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761963894; cv=none; b=caSakcP2QyLgs89HFdSlNhN3P2PPQw/SUbB7I1hikt++mjlvXdgSq6L8psVswb4CksfG6AsmcgzM+LvdqbPgeazfb/zx3C/VIwawO1eNxjENN3E409FV/rCQkyqjd7O70Il6lGvamu6e8Hde0oL3n0Xu858nI12HRdAMAmGey1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761963894; c=relaxed/simple;
	bh=NBZnhJ2GP7HkNNHFloMfetk5aQHVsDkeThTdbTWtzaU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Dhh4PfXRN7sVF55/vBHbkmEuEismYPpi2rLZtE2LJN9+MzH1QSo1dvcF82vv0LEe1BdFck0kaXH/HbCm+L7j27FN7BQ9lFEJhf+ekwIv5Rvkbxo2pt4tdMCz9wRsSb9hr70iOBMa3SSdG/G4B3nUvAtaGE79hNQ6lFnQ29/Hzqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=vFfB196g; arc=none smtp.client-ip=209.85.161.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-oo1-f48.google.com with SMTP id 006d021491bc7-65682fd39d3so719889eaf.3
        for <io-uring@vger.kernel.org>; Fri, 31 Oct 2025 19:24:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1761963891; x=1762568691; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=b0WZ0HvdkIjF9lJGgLW+KMUx5KiccKl90tsHcxRJ6Bo=;
        b=vFfB196g1xmA9wbR/Qw4T9FC7j/vFatsWjwPUNoiwWJY0FOq72d+XodT4pLKJSD8LT
         1QwXFgSSNxSGX3/YUqtW85zo0nn0oWBYB6XLvfgJlyC8kVMbYlahHYorey5UN0fEuFLq
         tqnZMb6ovapcxAMM/grDnTHzEkV2Ftvjk0oJdP67yq2X1uenDxgf+2jB2SOSXVsO9isB
         Xs7oPFWbqstAPixsS/BQKYauDp0V1vXvUd9xJUQFSBmEiREviikX8v4WsncXE4pK1ZXR
         ImoV0QGbs0rfzmEuR1Gop4lj95UM1khq0iSfnNRx4uINGijDh7KBygogUZGPEL+UlGv0
         FD1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761963891; x=1762568691;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=b0WZ0HvdkIjF9lJGgLW+KMUx5KiccKl90tsHcxRJ6Bo=;
        b=L2r/Po2c2VlWWBs6B9a9A4QorSg2u8eYtdjnm7oeY7H7+aQWWvIrdTxWbQImhKL75e
         PKH+Gpfi0sAcAVJOb1uDoJQaw5vp/lfyDDAW+A/CXcyNw8KYdyRuvzh9p7eZOSYNbe2E
         7fThc/Hih7tTHHLe0ohEs4maCI9p4BDkIDf1ddKJu92dxF712c2xic+H1lobAm8hQije
         9Om9upyNc6JC1M9Q9HIK/qlr52uXTx1V3zELzg3gNLWQBF4pGuNotUFK3d1vQTYXPqAq
         gK3hhVa6skHhqF5WWR5JOA+Kz/SvXEiAoBfmDSCEQWoJcQq8Qkqnd5QJz17aS6r4mu1g
         gNLg==
X-Gm-Message-State: AOJu0Yy0TOkjqLxX7hGteIGNvG7D+CE9aU/JrrHT1cRKHPCOGLYVP8Z+
	rc9dXFJbrYYvhoMhoon0s7NxqqR/ZbA41l2gGWQ9QrFbi/zhs12pSNtIW6cDMzz2kjtsAaR5pyR
	n2Y11
X-Gm-Gg: ASbGncs0m6ueb/C5CNECGE1K9SstffdUo2gwhXmPa8GQ2LQEhI9I3sdkchK7QBWDAPR
	/xVaL3C+WDrWIUHajWc9xFc4+HHWLWoUSDgoxzX5V6kXuQ4ZWa43SJaGjvqfQQtW+Ldk2AhlaTj
	QAYKsd1P8JiGb7pWfzmdqCrZQfpxXi8UUo5nQApl5R5IyRM8muDqqpJ6rjasejfK5OHHnRhoF2a
	UKJhQ04opF52wh7BVtwrQJ3GUEJkupml1v7J9Kg5qInNj/Ofllfu9Q64YQPPfP1yUJS5S+Qml4p
	btiQ5DuUeMy2z2AJ43Yb+SHL1H9B+vEGmLpoGPz1E0tdWgsTaUfqeMzkqskd9QI/rJMg1IeZi30
	YViOanvP2VrNg9K9/3wIyoRVM/WXjDYsz7C8tz40Lqqk/VmsyXA9PCw4tId9bU/IZcfXfduI2sW
	pMuOwBOhir/SjvjzhS4u/j3hst5ZB2v3YhqvD8fuk=
X-Google-Smtp-Source: AGHT+IGKuQs91jURGBXCKfpgU7GTzcduqh/upM1JP9+LrD4jKnsiLOQi1ib+newWIzWGAfcSlv+TNg==
X-Received: by 2002:a4a:ee1a:0:b0:653:6c32:6fe9 with SMTP id 006d021491bc7-6568a6cf232mr2505988eaf.2.1761963891311;
        Fri, 31 Oct 2025 19:24:51 -0700 (PDT)
Received: from localhost ([2a03:2880:12ff:5::])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6568cf1fba9sm868232eaf.7.2025.10.31.19.24.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Oct 2025 19:24:50 -0700 (PDT)
From: David Wei <dw@davidwei.uk>
To: io-uring@vger.kernel.org,
	netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>
Subject: [PATCH v3 0/2] net: io_uring/zcrx: call netdev_queue_get_dma_dev() under instance lock
Date: Fri, 31 Oct 2025 19:24:47 -0700
Message-ID: <20251101022449.1112313-1-dw@davidwei.uk>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

netdev ops must be called under instance lock or rtnl_lock, but
io_register_zcrx_ifq() isn't doing this for netdev_queue_get_dma_dev().
Fix this by taking the instance lock using netdev_get_by_index_lock().

netdev_get_by_index_lock() isn't available outside net/ by default, so
the first patch is a prep patch to export this under linux/netdevice.h.

Extended the instance lock section to include attaching a memory
provider. Could not move io_zcrx_create_area() outside, since the dmabuf
codepath IORING_ZCRX_AREA_DMABUF requires ifq->dev.

The netdev instance lock is taken first, followed by holding a ref. On
err, this is freed in LIFO order: put ref then unlock. After
successfully opening the mp on an rxq, the instance lock is unlocked and
ifq->if_rxq is set to a valid value. If there are future errs,
io_zcrx_ifq_free() will put the ref.

v3:
 - do not export netdev_get_by_index_lock()
 - fix netdev lock/ref cleanup

v2:
 - add Fixes tag
 - export netdev_get_by_index_lock()
 - use netdev_get_by_index_lock() + netdev_hold()
 - extend lock section to include net_mp_open_rxq()

David Wei (2):
  net: export netdev_get_by_index_lock()
  net: io_uring/zcrx: call netdev_queue_get_dma_dev() under instance
    lock

 include/linux/netdevice.h |  1 +
 io_uring/zcrx.c           | 16 ++++++++++------
 net/core/dev.h            |  1 -
 3 files changed, 11 insertions(+), 7 deletions(-)

-- 
2.47.3


