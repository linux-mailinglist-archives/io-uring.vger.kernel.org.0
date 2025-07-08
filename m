Return-Path: <io-uring+bounces-8626-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 71FBFAFD844
	for <lists+io-uring@lfdr.de>; Tue,  8 Jul 2025 22:22:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3D7A07B31D6
	for <lists+io-uring@lfdr.de>; Tue,  8 Jul 2025 20:21:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A84B623D2B6;
	Tue,  8 Jul 2025 20:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="cNWoQwlk"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f99.google.com (mail-pj1-f99.google.com [209.85.216.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 198A123A9B4
	for <io-uring@vger.kernel.org>; Tue,  8 Jul 2025 20:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752006143; cv=none; b=EDwem6Ay9U5RsR2eZf1r1rokkZyhPkrqDqcTVEDeSZcNig5RoBZOpYTOurvYCHj7Kb7wbzGTQX0Df+8qtW6huLkprdQIb8cHT4//v02wVZ1QMaoqF9NV01nC8zPL2ID4e/BtuUjiNHefweue4PPKYVhj3KFUGLIPYehkux1NExk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752006143; c=relaxed/simple;
	bh=fWIq9sK3skUEnIpI3xUtvubPOb/rfii7f039ze1TT+8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=j8jc3J+g+elru2OuVZ5GoXPdo5UKQb7Td8Xw/gF0zbW59YVEPERkU9lYiUjb9+i0NcD+YW3Ig1vj71f6Jy542el8mvEh6Z1NtO5/TAHi/wXcRrO+bgE55FZ5z44w/cyNxL2Ov7CRkhnuhD/6UKp4EIsg9BFE0Qt/YUvsYN2zKlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=cNWoQwlk; arc=none smtp.client-ip=209.85.216.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pj1-f99.google.com with SMTP id 98e67ed59e1d1-312f53d0609so890543a91.1
        for <io-uring@vger.kernel.org>; Tue, 08 Jul 2025 13:22:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1752006141; x=1752610941; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=SDF1rgr2LDiDKwzsYT4YdK9nApNfsPyUtMofnYvDcuw=;
        b=cNWoQwlkEhfyeMkPter0Hcdv6sdy7jeu2zpwfe8wKrgB0fCF5XOU56B7XUJXTWGNIr
         03ffD8/IXXuKve+hWrCXuNzLQNJfD668/Nn3Siak0g5JQnsjFHDWybE9V4nQzEetXiKZ
         uEUgFT6fZYzuoiJ2jZ0M1fVBoTI03fIm6rtIWn/4TxjOF2Xx3I7IkoiCZ5wccfftwqYH
         xYEr1Fej8toRhsMphi04XWGxWrDpM5yj85LJfkvZoeHjWttQrC85K6VMuevlfQ95lytb
         o9Nf718veuavtf3EgYOQnv5KfyS21PBi09BdIJPtjhR6Aih0gxX4Qq1wo9yjdt/xRNeb
         Rmkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752006141; x=1752610941;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SDF1rgr2LDiDKwzsYT4YdK9nApNfsPyUtMofnYvDcuw=;
        b=vm0mRg1+aJISqvJXuhxOT7RdPYE4UR5Lj+h3wQUVI8fDuBvoFBBeEdkiidtYL8wbJJ
         XWtRjUY0YP0U9kxs+dRhnREx/7kRHd+2/Lkvm4FMjudmjA3tFEdJN9YnRF1WZ5m7EGLq
         MeDDUYkRXBMspW1KZ4byv3q/Gy8Q23ByopRlO+yNJqkavBiQsoigEhI4YV98Nw5izRm+
         IixnGxDTS+aJpKQk1dtws4ThI2s6WQeWBc0481gv8Vn9Obx4gUsucl+aaIzg2tVtulne
         tRwiGDUhF2+JfZgvo5Dz4cPHfKJRgoW15NaHgcJhfgJhKLMNammYqMnzsMJboC6azNou
         8m8w==
X-Forwarded-Encrypted: i=1; AJvYcCUHN8LXBGrEQegWwoVUiirTonkYK4hQHdj82CLzIiG+YjE7V1JMgX+j2CtcMp20lN9gU/+yLdtFYw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzsPxJCR6PKKCK78lhPjltFmEflo9U/nzFiclQWj1IYgzaFqezL
	zSkXPxZAgp+IuvQmAFjOH5G2dRxZ+ERY/wnt0WLfWohXjEQzyHQyXHC16gzPf+ZT3O4AW8fb6FB
	u9ht+gXpzesLpDn5Tg2MPnlSVvCeTXt193uI1eQrm/ZafmXEwNjN7
X-Gm-Gg: ASbGnctPUG+yIYRCaS+cvrP9sI4li0acpW3fWvhwfcLCuH4TFW+ktPSfXGc8KeCfkbH
	MJaDWqbo7xs26UNuKqIfJ43t9RWiat01i9x/S0AnM+oVIfXh9wGAas/qUdPXYbxM1cFdFI+HZlg
	v6RF5P/q86pZjfMfxgh8oIc4pbfMbhpbeZxardwSjW3GXHz+wb576ipDmOGKM+NWfn9cQq8ICV+
	V+WI7onO6AetZZbJTAKYO0VNf7mFfmCH+3aW5Cut3EwYFDiCTKAHjcEay1FU2zsvNQHFgj0MYX/
	nIhRhtEu8bx1VM6Xm5ACWwHE4Lvmfj0UxUUskHft
X-Google-Smtp-Source: AGHT+IHoIJWpWHBT9JBZ2YbKvDMX+Q5iSjfAfFY2liLspOsVKHb7+A7m5UOGr8XZRKQrP1u4boAOJURprZp7
X-Received: by 2002:a17:90b:3e44:b0:311:c939:c842 with SMTP id 98e67ed59e1d1-31aaccd7e36mr9233424a91.7.1752006141252;
        Tue, 08 Jul 2025 13:22:21 -0700 (PDT)
Received: from c7-smtp-2023.dev.purestorage.com ([2620:125:9017:12:36:3:5:0])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-31c22f8be37sm50744a91.1.2025.07.08.13.22.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jul 2025 13:22:21 -0700 (PDT)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.7.70.37])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id 8B9623402B1;
	Tue,  8 Jul 2025 14:22:20 -0600 (MDT)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id 8545BE41CDE; Tue,  8 Jul 2025 14:22:20 -0600 (MDT)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Chris Mason <clm@fb.com>,
	Josef Bacik <josef@toxicpanda.com>,
	David Sterba <dsterba@suse.com>,
	Jens Axboe <axboe@kernel.dk>
Cc: Mark Harmstone <maharmstone@fb.com>,
	linux-btrfs@vger.kernel.org,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Caleb Sander Mateos <csander@purestorage.com>
Subject: [PATCH v2 0/4] io_uring/btrfs: remove struct io_uring_cmd_data
Date: Tue,  8 Jul 2025 14:22:08 -0600
Message-ID: <20250708202212.2851548-1-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

btrfs's ->uring_cmd() implementations are the only ones using io_uring_cmd_data
to store data that lasts for the lifetime of the uring_cmd. But all uring_cmds
have to pay the memory and CPU cost of initializing this field and freeing the
pointer if necessary when the uring_cmd ends. There is already a pdu field in
struct io_uring_cmd that ->uring_cmd() implementations can use for storage. The
only benefit of op_data seems to be that io_uring initializes it, so
->uring_cmd() can read it to tell if there was a previous call to ->uring_cmd().

Introduce a flag IORING_URING_CMD_REISSUE that ->uring_cmd() implementations can
use to tell if this is the first call to ->uring_cmd() or a reissue of the
uring_cmd. Switch btrfs to use the pdu storage for its btrfs_uring_encoded_data.
If IORING_URING_CMD_REISSUE is unset, allocate a new btrfs_uring_encoded_data.
If it's set, use the existing one in op_data. Free the btrfs_uring_encoded_data
in the btrfs layer instead of relying on io_uring to free op_data. Finally,
remove io_uring_cmd_data since it's now unused.

Caleb Sander Mateos (4):
  btrfs/ioctl: don't skip accounting in early ENOTTY return
  io_uring/cmd: introduce IORING_URING_CMD_REISSUE flag
  btrfs/ioctl: store btrfs_uring_encoded_data in io_btrfs_cmd
  io_uring/cmd: remove struct io_uring_cmd_data

 fs/btrfs/ioctl.c             | 41 +++++++++++++++++++++++++-----------
 include/linux/io_uring/cmd.h | 11 ++--------
 io_uring/uring_cmd.c         | 18 ++++++----------
 io_uring/uring_cmd.h         |  1 -
 4 files changed, 37 insertions(+), 34 deletions(-)

v2:
- Don't branch twice on -EAGAIN in io_uring_cmd() (Jens)
- Rebase on for-6.17/io_uring

-- 
2.45.2


