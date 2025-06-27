Return-Path: <io-uring+bounces-8499-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DC6DDAEBB19
	for <lists+io-uring@lfdr.de>; Fri, 27 Jun 2025 17:09:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 837303ACF06
	for <lists+io-uring@lfdr.de>; Fri, 27 Jun 2025 15:09:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 252A62E8E01;
	Fri, 27 Jun 2025 15:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jiOG5irf"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 330ED2E92D5;
	Fri, 27 Jun 2025 15:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751036962; cv=none; b=qJdvdzek/N8SBVXxGQ2TnGkvEFY2MWgvtYbcRQbsrTHCPA4gHpR5UjzKBXqsIOIx8gq5wTdVe8CFy9vZABwAxOQQ+YW6XYW2TS9zPO7rDXh4q98RVWa09KoMkFxioj9upFErcFWfRRvGDmucRI1aFefTE0hmjOv3oXQGUK1WP1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751036962; c=relaxed/simple;
	bh=9JzwW3ptl69sT0tSXPYVpaHvb7h2Lc+pp8IUI3kUFpI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aAKQ0xS6BUdXD1td9XYVKjkoUP2Tf2OeV7P9Fc9JVmUVeBXHXx3Jb1Yl9F9+CMh4YeLL+XJ0BTffOGjFIqhvhaDRcdDCK/0RT8R2wnMEPi+Yx6p21KxebHeJ++NK7hiUEt2zVlUjXeg95+u+w/1ZpveVPhHEb9XDqn6LlUOw0AM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jiOG5irf; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-60c63a9bbabso3926182a12.0;
        Fri, 27 Jun 2025 08:09:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751036958; x=1751641758; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=buVTdRxQKVlm30639PRVwQxRD/mm++iXvgZHcq077TM=;
        b=jiOG5irfcKyCh0jy7uP1efUMECUEi/lsr8LUlRIXGJddZcdmJy6nbiPVVeS/nTl6LY
         eoXMN32O7XtpmKdDq8fo+tdOjV+nkBYjhwDMc0o/qB7l2Pd6xcS7Fk2vHC5jhWaD7KP8
         +zISW6fD52NXRYnvXGm/EDIypIrBM802QgPmCuDy/h9SODhVpBT+nwqJEAm7BHC/r720
         bWf0IhTas4r+/xiRFSUl/qEyOPBWtF3J4QTRbI/D2ImHuEo21jWFNXqVkSMteluYjLkN
         xOeUGe9SgHsq+ptaibfZBH/5Ggiwg9ZWn7uckziwIkp0fiquli9c+gaUt+R/xvKoMOYl
         NCfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751036958; x=1751641758;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=buVTdRxQKVlm30639PRVwQxRD/mm++iXvgZHcq077TM=;
        b=avr0V2Cm0sSpRgEZIScCEyLFfp2E41B0Yp6Dayoh6jVWO0uO54ZeYCNlg2tv7dn4yq
         1YEgVZV0kbBCXKMNimxkdua0imQDqvupZUHW/6jCvfibkL8QvnJWh4CJBLKb1sMclOPU
         OfDR7JcyiK8clssvCj2UrLDL7fe2LI6g+QGuHScph3cOy75y16+FFXcYuI/2eMDRP2yF
         Fjla59fLVveMh+Z6L01ovoifh6oTCksYDsM7tm505awa6LbgfouDtRr/sX6ejDcjkHnd
         f9UGOoATYpZSKrM0TTUwO3Hc4paEBqnTbd4fCsqhV2tCRpfHOoTHcCn9haaKl3Bd/5ym
         KO/w==
X-Forwarded-Encrypted: i=1; AJvYcCWek5im/d7oryqZ11MR8TaRxRpTvUagtnU25UckOEQEAMknApvF5yb44+My8LiY76if6koHoAYtwZpUNA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzkR/gy/nC/nD1W/UhbWX78d9eGVnYvpXo3ZPCPB0+jGMCT4WVy
	TrawKBHiLEpGDfVaZ+jW9nDEDrNtRNqiZkglmoI2RwM1M8+lRwn5gERqL3W3vw==
X-Gm-Gg: ASbGncuxr3KQeguCjCgpcG849j+XbIjcEfxyHGB8xfTHZBxijxrVKITUQnrpCh8v9PE
	EbSQvOHRaAwKf1Igb2oGmET/OSpOsXgzExD8J24D0a/cGMPYBr9Czh97wmfubnlurS0bmA7sMPF
	UNCwvm83dJLbOMcnOseUqvbYKqVzIOWRva0PV39wusl5p4ScjuH2Ud1TD7MeNLj7cWtkfczYTxl
	PCd/HfWF4LtwVdNYBal54A1yU2M2EUwe4z7r8XVlS1KwCqMFyGMR77gK0V7MvE80VI84HIE0RyC
	I+tYiF7wb+tsMg872kDsJskron11oHNYz2+RxeGpGWLUYI12ekOensiVaufQFuKmU1ovWLhBKXZ
	+
X-Google-Smtp-Source: AGHT+IGGVGhe3vS2MX4Bny8mW3sSHejhy+WJ+hlE6Qb2Yw/TDLjhQuciR1Hl9hydhejbDjoGD4VBxg==
X-Received: by 2002:a17:906:794e:b0:acb:37ae:619c with SMTP id a640c23a62f3a-ae350363ad6mr366449166b.15.1751036957556;
        Fri, 27 Jun 2025 08:09:17 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.147.145])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ae353c014fbsm135802866b.86.2025.06.27.08.09.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jun 2025 08:09:16 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org
Cc: linux-fsdevel@vger.kernel.org,
	Keith Busch <kbusch@kernel.org>,
	David Wei <dw@davidwei.uk>,
	Vishal Verma <vishal1.verma@intel.com>,
	asml.silence@gmail.com
Subject: [RFC 00/12] io_uring dmabuf read/write support
Date: Fri, 27 Jun 2025 16:10:27 +0100
Message-ID: <cover.1751035820.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Disclaimer: haven't been tested well enough yet and needs more beating

For past couple of months David Wei, Vishal Verma and other folks
have been mentioning that it'd be great to have dmabuf support for
read/write and other operations in io_uring. The topic is not new,
it has been discussed many times in different contexts including
networking. The last relevant attempt was premapped dma tags by
Keith [1], and this patch set took a lot from it.

This series implements it for read/write io_uring requests. The uAPI
looks similar to normal registered buffers, the user will need to
register a dmabuf in io_uring first and then use it as any other
registered buffer. On registration the user also specifies a file
to map the dmabuf for.

// register
io_uring_update_buffers(ring, { dma_buf_fd, target_file_fd });
// use
reg_buf_idx = 0;
io_uring_prep_read_fixed(sqe, target_file_fd, buffer_offset,
                         buffer_size, file_offset, reg_buf_idx);

It's an RFC to discuss the overall direction. The series misses
parts like bio splitting and nvme sgl support, and otherwise
there are some rough edges and probably problems, which will
need more testing and attention.

[1] https://lore.kernel.org/io-uring/20220805162444.3985535-1-kbusch@fb.com/

simple liburing based example:
git: https://github.com/isilence/liburing.git dmabuf-rw
link: https://github.com/isilence/liburing/tree/dmabuf-rw

kernel branch:
git: https://github.com/isilence/linux.git dmabuf-rw-v1

Pavel Begunkov (12):
  file: add callback returning dev for dma operations
  iov_iter: introduce iter type for pre-registered dma
  block: move around bio flagging helpers
  block: introduce dmavec bio type
  block: implement ->get_dma_device callback
  nvme-pci: add support for user passed dma vectors
  io_uring/rsrc: extended reg buffer registration
  io_uring: add basic dmabuf helpers
  io_uring/rsrc: add imu flags
  io_uring/rsrc: add dmabuf-backed buffer registeration
  io_uring/rsrc: implement dmabuf regbuf import
  io_uring/rw: enable dma registered buffers

 block/bdev.c                  |  11 ++
 block/bio.c                   |  21 ++++
 block/blk-merge.c             |  32 +++++
 block/blk.h                   |   2 +-
 block/fops.c                  |   3 +
 drivers/nvme/host/pci.c       | 158 +++++++++++++++++++++++
 include/linux/bio.h           |  59 ++++++---
 include/linux/blk-mq.h        |   2 +
 include/linux/blk_types.h     |   6 +-
 include/linux/blkdev.h        |   2 +
 include/linux/fs.h            |   2 +
 include/linux/uio.h           |  14 +++
 include/uapi/linux/io_uring.h |  13 +-
 io_uring/Makefile             |   1 +
 io_uring/dmabuf.c             |  60 +++++++++
 io_uring/dmabuf.h             |  34 +++++
 io_uring/rsrc.c               | 230 ++++++++++++++++++++++++++++++----
 io_uring/rsrc.h               |  23 +++-
 io_uring/rw.c                 |   7 +-
 lib/iov_iter.c                |  70 ++++++++++-
 20 files changed, 701 insertions(+), 49 deletions(-)
 create mode 100644 io_uring/dmabuf.c
 create mode 100644 io_uring/dmabuf.h

-- 
2.49.0


