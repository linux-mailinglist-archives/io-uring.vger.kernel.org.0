Return-Path: <io-uring+bounces-10311-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 241A4C26E6F
	for <lists+io-uring@lfdr.de>; Fri, 31 Oct 2025 21:34:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 426EE4E1D01
	for <lists+io-uring@lfdr.de>; Fri, 31 Oct 2025 20:34:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 301C1329376;
	Fri, 31 Oct 2025 20:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="dvQYnWoz"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lf1-f97.google.com (mail-lf1-f97.google.com [209.85.167.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22C013254A7
	for <io-uring@vger.kernel.org>; Fri, 31 Oct 2025 20:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761942882; cv=none; b=aNF8LbQ8j3ecXpwiczHax1/t5BZlnpi0BomwTYMNhS/iekFAcaY748xES17F9oIyGZ3nd1nb45bZ8A6Lf/YLYhcS1d54IVkTQudWLpbwoTVyndfIEdn1SGlhXm3SSRnsyTyHyUXJou/QwlkjmQIni3mjp7Kw3TBGpRPs7hiVBCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761942882; c=relaxed/simple;
	bh=jvDE7lWJxH3JAXZ63PoEX/oK9PZRTBG5vt6245JF66Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=b7smxhYdpPsTkdbH9KJFVhiXVFpUwpESbc/se2XzXpP9Mn23dMpC7w+0FMS1+FJlQVis3+c9KD/ZVigKlx6WWfhrOu3oPksA/aee6Him6b0oN+jLRtSRP4IQupO5BP57VMyYbURGLd6wk5iMH4+81ujg83tPPuK5PYVYre8SpXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=dvQYnWoz; arc=none smtp.client-ip=209.85.167.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-lf1-f97.google.com with SMTP id 2adb3069b0e04-592f2f08168so251798e87.0
        for <io-uring@vger.kernel.org>; Fri, 31 Oct 2025 13:34:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1761942877; x=1762547677; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=6JMKDvp/MIeXNCA/ceerlUqX0sUk5SPPyvwa4mIoYyc=;
        b=dvQYnWozKugEUNvqdhCr6mOWn03B72UNbtIqWXxtzXbQZh2FwocLAAA2fo4AQBP8nD
         gjuJ7hbba2arrHmEhlTtgj3pQKsPpu3BSnPyWnsK/iJ120VJETkxreb4co7cGyDFjZ1Q
         Romr/u0AGF19Syc7K43JIlSdWKtdIt1Ct4P5iyInbmy9uAp6cN0Z1/cei717ORVB3nVw
         DDaUMhf0SYo8HVPxmDmJPPtLOHXG4V63nGyRAWOsWj3w42NKDkkdBx63fvfLk7zXY9gU
         qtPQJcYjFgzu17DHVa4v45yxtBaGrPHVrXeKNpXiD88/aZ8e+7f8iLJHjYqmKVvQCbdk
         8keQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761942877; x=1762547677;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6JMKDvp/MIeXNCA/ceerlUqX0sUk5SPPyvwa4mIoYyc=;
        b=QBL7awEOiE/XriJblFUwKvI2+z22+fi74meS9tgdrRlppAJyTlht9sStFeR3lN4FBX
         bwUBjbWcZWRI8xlp7A82ICES+kwOY1LvuAo0Rp5Ad5P48ckC4GVn9exGPb+qT6tmyDv+
         LbfTOU8aPA6v1c2MQ5a6lkVylWV0JPz1VDngyPbLv1U2rw5WoEVYmyGH3inIhoSYEM3s
         UvnY5JLKCGzYn9rmjfB+HI77mUNXWfD4oDyd4TvXvcdTHyWx7okid3MVPL6Guaf/Z0A/
         m3LXJjkpOJwcTkSIsz+zCSJNwskjNmdFRz0/+WYJAcnIyyCnKMPiKEkHRkd5GgYauYiG
         S+4A==
X-Gm-Message-State: AOJu0Yx8S5grLpBLF5dDy9oHU3LOH/Zhg2ukUtAbRrZRULMBPYSp7D63
	q77gzsQ3nZ5g30hKi079RRZiGXNBxQZZs222QjfUc5aKujeswRfx0pChUsZA02iJa21Ng/AFYiC
	MMD5eWU9XSGtutRWMErhsYtCXv1QQzTgJayJd
X-Gm-Gg: ASbGncsxkBy13fg3Pbvzwl3fllPD4Hx2Rs2SDt7j41eSku1KiEYwbte8CvEKQPEM4+7
	YrAl6qV1AbGuWtZB4H84w0NZg0h3gsW4aeR40T+nK8D7ToFmn9nfTVYNZ/tdi4ZQHiVds5Kfm12
	4iZA5CYn0E8cFMThj8GEslbu2eWwLHjiDRNSYhlpne81EKIiHy1stXsLvCbCWwa9hA0i8gTVDiJ
	OQxtOYwX5fxB404OT/ndiEw0mFbGqGFiesAOh9lxyWSaNYkTzY7hqXSZMx22RncHFj17QHqmEuk
	XjA2PP+5e0b6wqxMg7vgJnlKErkfpxf7B4SSGaxgpxBNEXZHGo9POydQho6OozdLbW9OGnZ2rUo
	x1WCPtCuEjg2Vam8qwb/VQrVU8Sf5eVE=
X-Google-Smtp-Source: AGHT+IHYGUnO7bV47O6a0JaarTqAfmI/2Y9l++bnlFY3ld+pOZSgy8vCnY+sYVKLt/9KYUiwgYpMC6aTC4ND
X-Received: by 2002:ac2:4c4f:0:b0:592:f7b4:e5fb with SMTP id 2adb3069b0e04-5941d4ff894mr969734e87.3.1761942876878;
        Fri, 31 Oct 2025 13:34:36 -0700 (PDT)
Received: from c7-smtp-2023.dev.purestorage.com ([208.88.159.129])
        by smtp-relay.gmail.com with ESMTPS id 2adb3069b0e04-5941f3a30cbsm287556e87.27.2025.10.31.13.34.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Oct 2025 13:34:36 -0700 (PDT)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.7.70.37])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id 4EBCF3400FE;
	Fri, 31 Oct 2025 14:34:35 -0600 (MDT)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id 465FEE41255; Fri, 31 Oct 2025 14:34:35 -0600 (MDT)
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
Subject: [PATCH v4 0/3] io_uring/uring_cmd: avoid double indirect call in task work dispatch
Date: Fri, 31 Oct 2025 14:34:27 -0600
Message-ID: <20251031203430.3886957-1-csander@purestorage.com>
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
save 8 bytes in struct io_uring_cmd.

v4:
- Rebase on "io_uring: unify task_work cancelation checks"
- Small cleanup in io_fallback_req_func()
- Avoid intermediate variables where IO_URING_CMD_TASK_WORK_ISSUE_FLAG
  is only used once (Christoph)

v3:
- Hide io_kiocb from uring_cmd implementations
- Label the 8 reserved bytes in struct io_uring_cmd (Ming)

v2:
- Define the uring_cmd callbacks with the io_req_tw_func_t signature
  to avoid the macro defining a hidden wrapper function (Christoph)

Caleb Sander Mateos (3):
  io_uring: only call io_should_terminate_tw() once for ctx
  io_uring: add wrapper type for io_req_tw_func_t arg
  io_uring/uring_cmd: avoid double indirect call in task work dispatch

 block/ioctl.c                  |  6 ++++--
 drivers/block/ublk_drv.c       | 18 ++++++++++--------
 drivers/nvme/host/ioctl.c      |  7 ++++---
 fs/btrfs/ioctl.c               |  5 +++--
 fs/fuse/dev_uring.c            |  7 ++++---
 include/linux/io_uring/cmd.h   | 22 +++++++++++++---------
 include/linux/io_uring_types.h |  7 +++++--
 io_uring/futex.c               | 16 +++++++++-------
 io_uring/io_uring.c            | 26 ++++++++++++++------------
 io_uring/io_uring.h            |  4 ++--
 io_uring/msg_ring.c            |  3 ++-
 io_uring/notif.c               |  5 +++--
 io_uring/poll.c                | 11 ++++++-----
 io_uring/poll.h                |  2 +-
 io_uring/rw.c                  |  5 +++--
 io_uring/rw.h                  |  2 +-
 io_uring/timeout.c             | 18 +++++++++++-------
 io_uring/uring_cmd.c           | 17 ++---------------
 io_uring/waitid.c              |  7 ++++---
 19 files changed, 101 insertions(+), 87 deletions(-)

-- 
2.45.2


