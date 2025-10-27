Return-Path: <io-uring+bounces-10226-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E3DBC0BA66
	for <lists+io-uring@lfdr.de>; Mon, 27 Oct 2025 03:04:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ADB7718A1B46
	for <lists+io-uring@lfdr.de>; Mon, 27 Oct 2025 02:04:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 566162C235A;
	Mon, 27 Oct 2025 02:03:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="M5rop7MM"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f98.google.com (mail-ej1-f98.google.com [209.85.218.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87075279DCC
	for <io-uring@vger.kernel.org>; Mon, 27 Oct 2025 02:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761530593; cv=none; b=LiUtq66WmcppRyWwUdSiG/5TgpFIvlqJnaCCM3mqXTX8wmyvgc6KBFhR73z//WQQOVnQ6Vz+KrxX+K2yd0l1N00MmOZu9OrCOV10lR/MLQ/WE0xBtHdV9illGoYxR6S3nk/4auiJM40LSnYg6/Qceysk0dFALJh/H+Nr/IIIJ3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761530593; c=relaxed/simple;
	bh=8EGXy5b1kSFodiuuzawK6wvaYbLLM08GPPPMMQ8zI7c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lBuEwgw258suLDpJ2IDFBH4KAzEVpBjhtwSHM/vgYFSyD35lpYnMEGQZ+WvUt0U8rUHbRnQ+64/dD6WhrI2KBInQGC6DbsbIqUAWSRZBjDtVCinYe/CYbylzTcL9ww/zlxxzAbplgiY59w3Ht7xgZWNfFfuoouoy3pfFoMkegxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=M5rop7MM; arc=none smtp.client-ip=209.85.218.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-ej1-f98.google.com with SMTP id a640c23a62f3a-b6d5f323fbcso71897266b.1
        for <io-uring@vger.kernel.org>; Sun, 26 Oct 2025 19:03:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1761530587; x=1762135387; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=jCh4WemE9mdSnciEK2Wq3FeBaRoVhjwvxKmTI6eKr9I=;
        b=M5rop7MMq5hk2TzNK10RdeSGsBICc4P8G5UR62QY+Go8EUicxYUbV7yKF0Ewknd+3C
         VMkIwFI1srO6yQ4Ecb1XkU2abPONncSeLRtmJT8NcicRp0s6TAqVFGOmmjiI80dxMLvx
         ypX5+L0JchNz6mqkvEnQFM3y7iFrzfC6kLU8lHWge50XHc/Cx/DyHlrT0SYKY/92Crtk
         vNMwJsdtLabuDa29cKqFsQ3e7mWCg9OiYqVG9SbRUMKUp0C1qda9+m1hHKoVy+v1tJmn
         qDkL3sZXTEpf+AM9krAsrF/gZSQplLkX+52qJDh/hHFmMWJrolJMYt+tgOIqGoYwJ/Wy
         n21w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761530587; x=1762135387;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jCh4WemE9mdSnciEK2Wq3FeBaRoVhjwvxKmTI6eKr9I=;
        b=Qp5KSoCGil4xzlLzQjgOIOR3c16xe01Oh+tRZUWx+f5vCNm6bXJjuIc1VEEm+mLhBx
         sJ+IbHKuIe40R6aVe+ZzO8xTrAF5ZDtcSCbndvpyOmPZQ8rtPfFVPgxdjXAg+uuOvQfi
         v0f0ie34QHaW/FcTCCc05l+SPk71Fk5v5o1xIPpfz0B3VXMJBp4o+ZWEuaWJhQaOO6La
         6sJL+otQrV6jdw5htoL5ijJBh/keFVKeIanqTaGlCCO2+aKr8Kum/BI34yLf2fTK1NEx
         l+cMsdO++b81UCKMGTB1tAYizL9qG+MfCIuYGN7SKyo8ChnsrGhFP9aar8RsHlbeonKI
         y3DA==
X-Gm-Message-State: AOJu0YwvOK9FYuVAmEFbxVFCU23c97zLEHjPLH/OO3vurz52vFwTT9Vw
	DfzfRcOFkn8GBM1m6KYKeP5usm6VfNn/aTcKr/k4ZNOlEZU1s/qOmLmsXTkKf7Qhy5qu1sSMWq2
	OoPXy/4TjrKGgXs9RkbaV1Dsb5UYQflyZmluB
X-Gm-Gg: ASbGncs3h72rarABtuox9pFQnevDAM9V/zAJM5eAVqEoL1G3W9A1NcSLITQgQKAFx2N
	FJmADhmvyE+dqKBw9wymrvN630JmL76JQK3YmxcuV05yEHwZZCe68u0aV4282kx73Rm0HVNOiQx
	WocgrbdkgFzK3rQVQMJqztiW0LyHVSPTy7C6mGHuUyqSU6NDSRgZ4kSa0DhcxwHV9KbrvbNxFrm
	GoOZ0q4drvuVppfPt97HSSyRkJWDMLBS0qGnLu4wdS02IYU7TWwAS7/YTg49W/jmRAykrtMZFhQ
	q+LoIguzv83ZyiaSbdfXmFb0OYJlSDlsm1Unt+JurQq0+6XjcqbpYiKYM5SjhU3+CpgIMAQtG+e
	/csFm9R4G9e8I2tLgIGOcNBVH7bBtrH8=
X-Google-Smtp-Source: AGHT+IE4hiP03f6lofOOS2+HxUXFo5vKINW/jUKRpaO25HyrXJmcC0Z82zfs5/zGzfiuKTm+aQhmKlmbZdW6
X-Received: by 2002:a17:907:c24:b0:b38:7f08:8478 with SMTP id a640c23a62f3a-b6c72716445mr1473292866b.0.1761530586723;
        Sun, 26 Oct 2025 19:03:06 -0700 (PDT)
Received: from c7-smtp-2023.dev.purestorage.com ([208.88.159.128])
        by smtp-relay.gmail.com with ESMTPS id a640c23a62f3a-b6d85418ef1sm55541366b.47.2025.10.26.19.03.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Oct 2025 19:03:06 -0700 (PDT)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (unknown [IPv6:2620:125:9007:640:ffff::1199])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id 46DBB3402DD;
	Sun, 26 Oct 2025 20:03:05 -0600 (MDT)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id 3C232E46586; Sun, 26 Oct 2025 20:03:05 -0600 (MDT)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Jens Axboe <axboe@kernel.dk>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Ming Lei <ming.lei@redhat.com>,
	Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>
Cc: io-uring@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Caleb Sander Mateos <csander@purestorage.com>
Subject: [PATCH v3 0/4] io_uring/uring_cmd: avoid double indirect call in task work dispatch
Date: Sun, 26 Oct 2025 20:02:58 -0600
Message-ID: <20251027020302.822544-1-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Define uring_cmd implementation callback functions to have the
io_req_tw_func_t signature to avoid the additional indirect call and
save 8 bytes in struct io_uring_cmd. Additionally avoid the
io_should_terminate_tw() computation in callbacks that don't need it.

v3:
- Hide io_kiocb from uring_cmd implementations
- Label the 8 reserved bytes in struct io_uring_cmd (Ming)

v2:
- Define the uring_cmd callbacks with the io_req_tw_func_t signature
  to avoid the macro defining a hidden wrapper function (Christoph)

Caleb Sander Mateos (4):
  io_uring: expose io_should_terminate_tw()
  io_uring/uring_cmd: call io_should_terminate_tw() when needed
  io_uring: add wrapper type for io_req_tw_func_t arg
  io_uring/uring_cmd: avoid double indirect call in task work dispatch

 block/ioctl.c                  |  4 +++-
 drivers/block/ublk_drv.c       | 15 +++++++++------
 drivers/nvme/host/ioctl.c      |  5 +++--
 fs/btrfs/ioctl.c               |  4 +++-
 fs/fuse/dev_uring.c            |  7 ++++---
 include/linux/io_uring.h       | 14 ++++++++++++++
 include/linux/io_uring/cmd.h   | 29 +++++++++++++++++++----------
 include/linux/io_uring_types.h |  7 +++++--
 io_uring/futex.c               | 16 +++++++++-------
 io_uring/io_uring.c            | 21 ++++++++++++---------
 io_uring/io_uring.h            | 17 ++---------------
 io_uring/msg_ring.c            |  3 ++-
 io_uring/notif.c               |  5 +++--
 io_uring/poll.c                | 11 ++++++-----
 io_uring/poll.h                |  2 +-
 io_uring/rw.c                  |  5 +++--
 io_uring/rw.h                  |  2 +-
 io_uring/timeout.c             | 18 +++++++++++-------
 io_uring/uring_cmd.c           | 17 ++---------------
 io_uring/waitid.c              |  7 ++++---
 20 files changed, 116 insertions(+), 93 deletions(-)

-- 
2.45.2


