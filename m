Return-Path: <io-uring+bounces-4068-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 880D39B344D
	for <lists+io-uring@lfdr.de>; Mon, 28 Oct 2024 16:04:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EEC6DB208F5
	for <lists+io-uring@lfdr.de>; Mon, 28 Oct 2024 15:04:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9F341DE2C3;
	Mon, 28 Oct 2024 15:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="3YwhUdTQ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 697841DD0DB
	for <io-uring@vger.kernel.org>; Mon, 28 Oct 2024 15:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730127887; cv=none; b=KlHCUcOHuWDKC40qij7XGSersRD4NN4zeklUlHkZnVnOd+itjRiS4F13o4Do7S82JO2SruxOq7jonC4kFM4Y0L7Z36cKNGuWiG1XGBtPipZRChHceNwb+Bz5C6dDMhuURTORw4+mYR1iKbDSunZ4xzbTkFpmbgdQB5Y2NA0KNHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730127887; c=relaxed/simple;
	bh=13iUZ5saD8xGXqiXFX8KXImZNFsKss81GKbP8VCoeIc=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=VBYEPSXx1bvq6uw0mChqO/NqXfp1K3PC8+gDHqdjObL1tDiXs/m8+eCCqfYIpD2dRv2/txRNmBv4QGE9T2arc2BmsxXUXjTh0t+qKdyf0AEFZbzyQbYv0V6m+qrmsz4+9MHxy8XNeiKuBx3W388SxcMiOTsA9sJyuGi+fsdn3ZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=3YwhUdTQ; arc=none smtp.client-ip=209.85.166.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-83ac4dacaf9so157799839f.2
        for <io-uring@vger.kernel.org>; Mon, 28 Oct 2024 08:04:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1730127882; x=1730732682; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=V5RCkkO5ESwCLvlnoP7QlLIuL/efaIbcQrZmSMv5Y3c=;
        b=3YwhUdTQBkA9MPzNssO1JUfigRf6NUna5xbwJXNzc3wWzP/3OeCPxpWd/slnCCrRpY
         CUond4Bw6k1LkZSmw6FJf4kYjnZL3T9nQVt4joXb7+m9nlA4Ldb1MrTkFnAplh8HUBZX
         LQte8gsMN3p8LsB5vK9IxO+4Pz9Cxh3sYaw9Gh2Sj3hWFhsbcA3RltM+dfwr4pgPL4J6
         edN77jrZJJbxMJmn4LCQj3kfiedRxzrTS3YS1bLHyCbIM69e73E170JwlIQyhHRL1iRt
         nbF7yxuB+dbydC6MRVMmctobkyg4uTXqyq4qzgdcKwepW5ag6Ymgj9LaCKBOjl/m/0F9
         iOHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730127882; x=1730732682;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=V5RCkkO5ESwCLvlnoP7QlLIuL/efaIbcQrZmSMv5Y3c=;
        b=mOJYk1kJobqiXpgCngxYYSNQ2WxyVcGjD0VIpPh12xdrTxlx5YAI/VF6Kl4gjtsIZl
         E+Wx94JzpPZynbzoJSTAEbtocGXYtvNR7tQKEyBfmcjQCfh3KAMbN+qpUx4ZH8XwS966
         VHC5WAa0YzjGg6Mss9vatqktmYTAIXHoMp9fOAMWTirimjOvWbkLDjWv1nzkbnVB/URx
         oYIAv2CzuBx/Gcm8Dm5j9BLROhhCdOrNd5iCBM0WuDafasWeXmQXJ8pUZJBeLhnlYVrO
         e9rJUSoPNVrax4H7akGSeNFcncs62Bvi3VW6vZvRYNu9XFIOiAzxfgJn8oduz4vTLfOX
         EGFQ==
X-Gm-Message-State: AOJu0Yy44sJHGHIxtJ8yYPVwP/FqFjnG8Jv3IkqNPMHV6Hzm8xBg35J0
	PaWJdgOf7wXEmhV4t1jKj8MW/RLVW3C1e4Eb3OtZZDjgumh79529EcDku7m4DX9j1DTZzq+iBby
	Z
X-Google-Smtp-Source: AGHT+IHwRhsCZd/6wkXJ4BAst6/ksihHJjV/Y6IWqfhl4KczuXTUzOSt1fI6xjfA17F24V6rYsxeLw==
X-Received: by 2002:a05:6e02:1a86:b0:3a3:dadc:12d9 with SMTP id e9e14a558f8ab-3a4ed32b398mr71802585ab.25.1730127881667;
        Mon, 28 Oct 2024 08:04:41 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4dc7261c7e3sm1721616173.72.2024.10.28.08.04.41
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Oct 2024 08:04:41 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Subject: [PATCHSET v2 RFC 0/13] Rewrite rsrc node handling
Date: Mon, 28 Oct 2024 08:52:30 -0600
Message-ID: <20241028150437.387667-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

v2 of this RFC, now a bit more polished and split up.

For a full explanation of the goal of the series, see patch #6 and #10.
tldr is that our currently rsrc node handling can block freeing of
resources for an indeterminite amount of time, which is very unfortunate
for potentially long lived request. For example, networked workloads and
using fixed files, where a previously long lived socket has the full
resource tables of the entire ring pinned. That can lead to files being
held open for a very long time, where they should be freed+closed
instead.

This series handles the resource nodes separately, so a request pins
just the resources it needs, and only for the duration of that request.
In doing so, it also unifies how these resources are tracked. As it
stands, the current kernel duplicates state across user_bufs and
buf_data, and ditto for the file_table and file_data. Not only is some
of it duplicated (like the node arrays), it also needs to alloc and
copy the tags that are potentially associated with the resource. With
the unification, state is only in one spot for each type of resource,
and tags are handled at registration time rather than needing to be
retained for the duration of the resource. As with cleaning up of
structures, it also shrinks io_ring_ctx by 64b (should be more, it
adds holes too in spots), and the actual resource node goes from
needing 48b and 16b of put info, to 32b.

Tests out well here, both liburing test suite but also application
testing. Most notably, the infamous test case that held all 10k
sockets open during new opens and updates now only has the few open
you'd expect. And it removes a net of about 280 lines of core io_uring
code. In my opinion, it's also easier to follow.

Can also be found here:

https://git.kernel.dk/cgit/linux/log/?h=io_uring-rsrc

Changes since v1:
- Rebase on -rc5 + pending io_uring work. Each step now works, as it
  should, and passes testing.
- Add and use node lookup helper consistently
- Add a few patches killing mostly useless helpers
- Split out patches from the main bigger patches
- Fix an assumption in test/rsrc_tags.c that prevented it from working
  with the per-node refs
- Add NOP patch that enables testing of both registered files and
  buffers
- Remove 'index' struct io_rsrc_node, it was unused now. That shrinks
  the node size fo 32b, fitting two in a cacheline.

 include/linux/io_uring_types.h |  25 +-
 include/uapi/linux/io_uring.h  |   3 +
 io_uring/cancel.c              |   8 +-
 io_uring/fdinfo.c              |  14 +-
 io_uring/filetable.c           |  79 ++---
 io_uring/filetable.h           |  37 +--
 io_uring/io_uring.c            |  51 +--
 io_uring/msg_ring.c            |  33 +-
 io_uring/net.c                 |  16 +-
 io_uring/nop.c                 |  47 ++-
 io_uring/notif.c               |   3 +-
 io_uring/opdef.c               |   2 +
 io_uring/register.c            |   3 +-
 io_uring/rsrc.c                | 587 +++++++++++----------------------
 io_uring/rsrc.h                |  96 +++---
 io_uring/rw.c                  |  15 +-
 io_uring/splice.c              |  42 ++-
 io_uring/splice.h              |   1 +
 io_uring/uring_cmd.c           |  20 +-
 19 files changed, 437 insertions(+), 645 deletions(-)

-- 
Jens Axboe


