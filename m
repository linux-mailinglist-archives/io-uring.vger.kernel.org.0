Return-Path: <io-uring+bounces-10166-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id C7EEFC03593
	for <lists+io-uring@lfdr.de>; Thu, 23 Oct 2025 22:18:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id B61C94E1C71
	for <lists+io-uring@lfdr.de>; Thu, 23 Oct 2025 20:18:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28079264A8D;
	Thu, 23 Oct 2025 20:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="c6LhWJ8Q"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f100.google.com (mail-ej1-f100.google.com [209.85.218.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCF362459F7
	for <io-uring@vger.kernel.org>; Thu, 23 Oct 2025 20:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761250720; cv=none; b=Uyx7YTNtf3sjzC7HaKiPkI4dcTK+687JKz3kHXRKkZTDnPHvdKNwL5EbMGOncMtDyvx9oBiuL51H0bJ43O1fB8FtiUfam8/0U2f2O4BTdUHcWiU5FlJRzGpIsR7JV8GHB9Ls8k5rd12yEVJF56zDBxh9rGehxe6K+QJxsawC/hI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761250720; c=relaxed/simple;
	bh=MNaW/Qmo6FwgmkLQqa0PKYjlcqHuOYgu3MksfCpQ4MQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MArT4SjSEOU7Ys3bLBGpTM91pOVtg35l0fUfsmAP7O0kT145dgMH/CX2BbxEBnWz8nXBuVVLjhpH7twBILl4FjKcYdRXwvyZcseDzuTwYzwbIkHsjvX25KllRl8ydTnQqC7a0FazLrv37t1tOfKvTh+LiCNKR/hIxrXC58z2LnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=c6LhWJ8Q; arc=none smtp.client-ip=209.85.218.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-ej1-f100.google.com with SMTP id a640c23a62f3a-b43a3b1ae1fso26700666b.3
        for <io-uring@vger.kernel.org>; Thu, 23 Oct 2025 13:18:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1761250715; x=1761855515; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=cz0mQMPnFRMldaxGN9MCesCYr4t4w4JLIICl6X3LGRg=;
        b=c6LhWJ8Qe9UcznFArqbRWsOQ9aHKKotymYnnEk+I6HYUpGXcm+p2Q2vFNGTC1ha5UQ
         fupBDOD2xiTRww3vIabFbLCqqbt4v5O1tIiXzBjoHxwH78uwRoe922w5TxFsmPy7hvhw
         dKZay05aUFU5O2LOS6SGthy/B8PVTPXCuNAmQFHrtEFPFHYA60KQ1x+jwTvg4erbQdmC
         hA6MNEQj7V2yDyDxNMCIZtUn7mSKYaJxRLtWVeHEP2b+aneeOx3KSRXu02fIQrsGe3py
         sNoCzGq2AQxv6+xL6Z9qNoS/fNiHmu8VP2agrf3Ty5hvJah7d+C0zZas1Yjd1cNdjCSN
         qgqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761250715; x=1761855515;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cz0mQMPnFRMldaxGN9MCesCYr4t4w4JLIICl6X3LGRg=;
        b=pXMVVOVNIJh9lXfvIY4Ejx9ts0eTRjYa7L4RGB7JvGpMaPxWReHd0NA9TYLGL+Qd8o
         9hRM1Ou/1F6R+p/LHcBRJ8SalpoydOSBoaxjpSfr4fTg3pnZTJ2uIEPdLuXc+faT7Lmj
         pBsgMzyifqRRMSIovfO9bDIfayQgRczhZez6qoItk9SDdeU96R1RgKLnuu41spL+FRRW
         PpMJz4GETW6VXp39R8UsEcS3tRmf7L354T4QttiGlVRwkNjgCI8Aa4q9dpf3CcG94CpK
         wrNY2/khTDENciZm6SYnJkYljyYJ6kUyjkiXGuNA99nrng9wsHXGdi5g4vSFD0fyRIjt
         8JXA==
X-Gm-Message-State: AOJu0YypTAwttsZMuu8UTvosQbK3rTczxo4Gv5of40E0G4VWT5AhsF7w
	38CG/QIT4Qu6TOziLSX0sRju++Dfnzo2VIvQYfNasULWOJGHmlaXWH3VuZnE+oVyeU9HJT0oEK8
	1aEt38q58Z3guBXKsacKl7KK8I9omX9KnKKjWc0ZyXaYfU3PyeOb8
X-Gm-Gg: ASbGnct3/brGGLgVRwehBhQZYAcBoBn5OGowHDmknBgVniuCx9RAszz3lv2CJ36vXXf
	DHox19+d2RFCsETtOH4+K8pjm3d0pSl1niX0QVWuCSm3cddCCqFEQu5RZk24AB8WCR1cr8ZtK56
	lUOIJVfF+CWgFAmLg4q8XvlhXZcSolJMmB8iW6xadzqx/2hgxcbGG7Ya5DDrcosts2K4Emu6YNy
	Mv5PtPtzvlXHDbY/kOXEQsKwUeKY2kQQpnxOUVLiPsnSFTVll4gwrEZsIHOsbyMEwwfwuiKwgYE
	d6lMqK6wz7IgPGWkCxpocD2dSUEzx9nKD4siDhqTxAYFFUxGwGpzhwgpU6rGjgBtyGwCE+Zxthz
	6m5deHp0I6vv6Ugfl
X-Google-Smtp-Source: AGHT+IHXhL/uv6eUeaN2ZVLtqNjngQKnmQcL5o8MgXl81NLPuCh85qOP68iyVWTyOMVTjHd4V9x4RLM8fwMs
X-Received: by 2002:a17:907:9803:b0:b2d:a873:37d with SMTP id a640c23a62f3a-b6c722312e2mr832720966b.0.1761250715011;
        Thu, 23 Oct 2025 13:18:35 -0700 (PDT)
Received: from c7-smtp-2023.dev.purestorage.com ([2620:125:9017:12:36:3:5:0])
        by smtp-relay.gmail.com with ESMTPS id a640c23a62f3a-b6d5141d9dcsm15476066b.54.2025.10.23.13.18.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Oct 2025 13:18:35 -0700 (PDT)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.7.70.37])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id 9317F340384;
	Thu, 23 Oct 2025 14:18:33 -0600 (MDT)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id 8CBBFE41B1D; Thu, 23 Oct 2025 14:18:33 -0600 (MDT)
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
Subject: [PATCH v2 0/3] io_uring/uring_cmd: avoid double indirect call in task work dispatch
Date: Thu, 23 Oct 2025 14:18:27 -0600
Message-ID: <20251023201830.3109805-1-csander@purestorage.com>
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

v2:
- Define the uring_cmd callbacks with the io_req_tw_func_t signature
  to avoid the macro defining a hidden wrapper function (Christoph)

Caleb Sander Mateos (3):
  io_uring: expose io_should_terminate_tw()
  io_uring/uring_cmd: call io_should_terminate_tw() when needed
  io_uring/uring_cmd: avoid double indirect call in task work dispatch

 block/ioctl.c                  |  4 +++-
 drivers/block/ublk_drv.c       | 15 +++++++++------
 drivers/nvme/host/ioctl.c      |  5 +++--
 fs/btrfs/ioctl.c               |  4 +++-
 fs/fuse/dev_uring.c            |  7 ++++---
 include/linux/io_uring.h       | 14 ++++++++++++++
 include/linux/io_uring/cmd.h   | 23 +++++++++++++----------
 include/linux/io_uring_types.h |  1 -
 io_uring/io_uring.h            | 13 -------------
 io_uring/uring_cmd.c           | 17 ++---------------
 10 files changed, 51 insertions(+), 52 deletions(-)

-- 
2.45.2


