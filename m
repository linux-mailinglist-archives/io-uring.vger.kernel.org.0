Return-Path: <io-uring+bounces-10148-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 33DE6BFE7E0
	for <lists+io-uring@lfdr.de>; Thu, 23 Oct 2025 01:14:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DA0773A59D1
	for <lists+io-uring@lfdr.de>; Wed, 22 Oct 2025 23:14:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F087F3081DA;
	Wed, 22 Oct 2025 23:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="BZWmGKO9"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lf1-f98.google.com (mail-lf1-f98.google.com [209.85.167.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BFA3307AF7
	for <io-uring@vger.kernel.org>; Wed, 22 Oct 2025 23:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761174824; cv=none; b=YeACm2M/6AMzxBHe6OLRlZJpCTRhY/U6S6WEPFiPut1X6zyBW5qSbV5LS1h12i2ajtZkfne/6vSS/wvULfjpNDiRrDUaV1e5mqcAg8CD6AXraLbrl92sTDKAynNEwm9Ahg8yeuLRgADxVoXEaQEKwCnD8tbrALYNejepwZtkbkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761174824; c=relaxed/simple;
	bh=+8TQGyg0ZV97+kPFYJBnRauC5Q+QxqG5BEUv/mu4y9A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HhytjKNYw1FfTaD4deERxHe8Gi6rGHuFgC81rMZMgCLi7j7lCuFjm0kv+wVKTgNL0gw8nS6oh7FEyHwEaXMDE+NJ/NWwwS30D0jh0F+Eqs3IomaQJGK7yLaYWHv/5mOZ51TjmPUFmyya4pjgC1n8g4zmlbb4uUdKh0+FYpac5OY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=BZWmGKO9; arc=none smtp.client-ip=209.85.167.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-lf1-f98.google.com with SMTP id 2adb3069b0e04-591b99cb0c4so18943e87.2
        for <io-uring@vger.kernel.org>; Wed, 22 Oct 2025 16:13:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1761174821; x=1761779621; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=NEb7Tz++jPbBE/mHfoATYrwfDk87qKz0eD7ACfLRyGs=;
        b=BZWmGKO95mD2clfYM/PYqVpX7rGOPzXaBNdIxo6ldORmYIU9uBypqtCxh4clf8sg7p
         bbPfaMsN7iLQ3zmHfVqgp0KZOJTmocZJh605cfVR6RZ4eyuZEiryrUz3UjN6sJcbRuLw
         8B+Fd7EYoRGQnTx1q4yLgQoa/iMRapBsKvpc+cu8J5u96XjxcKdReTAR0i3usD+gUIre
         5xBkmT5LrdNzzrK7Ea0M1dpI+W25Hwuhn1oeXWrTL6cRWN18YvIfFRWWY2/QkX2n22G1
         iAWc4OQMve7TJLXWQbXzftDQIj1GtrxTS5Zw+8nVeEACw2dcTAO60Gd6UwnK9A8E7KtU
         3Kyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761174821; x=1761779621;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NEb7Tz++jPbBE/mHfoATYrwfDk87qKz0eD7ACfLRyGs=;
        b=uVERqpw/vNy3d23wz88czakJrYSVBgLeNORmMVqSNsm3NEgIlUBIlWFO8TS1Dzoy1a
         jLRy/oODcTg06vVPGNJ80lVU6yrziMMITWCLwtFldBnBPthxkkWDS5HIsRpmOfR2g0K1
         ILQpvmj7gZltY9ccWxlO6RsmGDajNhvvk/3jwx5Ba53e+zvn8BR71xxXxI5mhYE9eBEB
         BEtuYhc3MCUxwOkMePv9c2rQegizPvn8FHsrFfDc+w2f5WPrYwEGlXR/J3tvysCcWtG8
         YS9cMl/pq8tiixC2JMQ7unaDN4RtsYmdk+2O9wJ6ip1t33NIRsBoDM/1eJrtPmB+ZVl9
         +94A==
X-Gm-Message-State: AOJu0Yy9IebnMdjYJlm/QxEFAe7TQswb47JAcp4pp/l+ZVk9veALyokQ
	KlSmLBKD72d24ifpf2pDrve+VZh/MJfpfOAHT8Vaewnf8k1Ekcpn+bxgtJ4rTtiucZbe0l8HCUJ
	qgr2gI5unZeoBaYMJPDem3KvvuUaseM83fv6Yiy03fvSc9Hh9nmPX
X-Gm-Gg: ASbGnctlIPzDSNug+iEZMacEMzZtM2QfhtAskPGBZzmMwSkY6wvG0kJhJAEhsCUhrzu
	jewHWSN4lkehqmgtDkKWORdhNUHWEpakmeYrSXQf817oBgfP0ng5HhRUnyL29cjs1xJrQsFd01R
	doV44UTLzmeJ1uHcMYbv9QtXkmKXM4ukLDGQ7zoyNs4Jmcc+nc+uoOY0jzBaF+l7WFyasJyQc6P
	tALPapDj8FjR2Paa8gs99X/OCcLxx4fPf4mFZ9472QZrvrpnl6SfZYSuLZNztfmZaJMY3cTCtBD
	fDFcS4ssCBMyoWpgm+ouyD+ce3otAG+6kN+Ky/fhpT5ItEe3gm4G8hbS6RNwTiA6o/UidwXWTRt
	gF3d+O/QwZprYp9Xd
X-Google-Smtp-Source: AGHT+IE8YXW1bqh82Pv83CqBL++4EorD9wKI8kSNSxyaHaZobY7QUQj2BR1bXjAEiGky/6dYa+2+odrIWp7W
X-Received: by 2002:a05:6512:131a:b0:57e:ed2d:190f with SMTP id 2adb3069b0e04-591d8598d06mr3612400e87.7.1761174820409;
        Wed, 22 Oct 2025 16:13:40 -0700 (PDT)
Received: from c7-smtp-2023.dev.purestorage.com ([2620:125:9017:12:36:3:5:0])
        by smtp-relay.gmail.com with ESMTPS id 2adb3069b0e04-592f4aa2259sm40463e87.0.2025.10.22.16.13.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Oct 2025 16:13:40 -0700 (PDT)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (unknown [IPv6:2620:125:9007:640:ffff::1199])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id 86E1B340283;
	Wed, 22 Oct 2025 17:13:37 -0600 (MDT)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id 7A5DAE4181C; Wed, 22 Oct 2025 17:13:37 -0600 (MDT)
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
Subject: [PATCH 0/3] io_uring/uring_cmd: avoid double indirect call in task work dispatch
Date: Wed, 22 Oct 2025 17:13:23 -0600
Message-ID: <20251022231326.2527838-1-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Define a io_req_tw_func_t wrapper function around each io_uring_cmd_tw_t
function to avoid the additional indirect call and save 8 bytes in
struct io_uring_cmd. Additionally avoid the io_should_terminate_tw()
computation in uring_cmd task work callbacks that don't need it.

Caleb Sander Mateos (3):
  io_uring: expose io_should_terminate_tw()
  io_uring/uring_cmd: call io_should_terminate_tw() when needed
  io_uring/uring_cmd: avoid double indirect call in task work dispatch

 block/ioctl.c                  |  1 +
 drivers/block/ublk_drv.c       |  3 +++
 drivers/nvme/host/ioctl.c      |  1 +
 fs/btrfs/ioctl.c               |  1 +
 fs/fuse/dev_uring.c            |  3 ++-
 include/linux/io_uring.h       | 14 +++++++++++
 include/linux/io_uring/cmd.h   | 46 ++++++++++++++++++++++------------
 include/linux/io_uring_types.h |  1 -
 io_uring/io_uring.h            | 13 ----------
 io_uring/uring_cmd.c           | 17 ++-----------
 10 files changed, 54 insertions(+), 46 deletions(-)

-- 
2.45.2


