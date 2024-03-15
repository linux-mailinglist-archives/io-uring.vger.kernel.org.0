Return-Path: <io-uring+bounces-952-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BE0D487D046
	for <lists+io-uring@lfdr.de>; Fri, 15 Mar 2024 16:31:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EFCF91C20E9C
	for <lists+io-uring@lfdr.de>; Fri, 15 Mar 2024 15:31:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E95B13D571;
	Fri, 15 Mar 2024 15:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mQhcePDa"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B3131946C;
	Fri, 15 Mar 2024 15:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710516672; cv=none; b=uEy5ZQ7fWvo7CtFOqCJ228G0LK272uGTXvwxzn2569cheaLB0yHt8rfrGrMaXqCrE7teVd7PLymJLvZiCH1Tz7qjOiMS2U1yRzpULWAI+TcrP2IdRLKWNOLb75kEyJJeg75nRcsQUvKX/B5CkFp6/+VmIC7j/1Kca/dU5jLqcI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710516672; c=relaxed/simple;
	bh=diKG6r3O9WBx7lMbtvpAtOLLJip108jNe8HgkcBM/6E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uUy0uTtcoykxokXWRXq/XEtFOMzvT9fkpaINYmzEb1+f2FXFPojZBPywA5U4WzVhGeBIv/GGrX8VpJsOeh6DGDDf9yN0MQWQRv2LJOfyUAeijP22ENCDC+6KyRlnSZBxW37Sf/Ty8zIhQ+WAA+ZypFH6anJu81tE7rugZpzOVv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mQhcePDa; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-33ececeb19eso646624f8f.3;
        Fri, 15 Mar 2024 08:31:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710516669; x=1711121469; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=cz+l6PNLT3cYvsUKyFGngxeM8Fm/GaSPA36vHKtylKI=;
        b=mQhcePDa531IDiZJ/VVt5RplDKHyH2OWScRQhM1JmnUvNmKM/cYcO3DhpmNvxpRvrh
         gucYm7dkv1SeAFChMOtv+XPGTAUu+lEKi1Jos4MxDhdj97fJGrcu9wXoVP0wVzN4vstI
         fMlmgeq/tz3KEkxPKXZdwpUSfJYyZ/WjFlO6ixdrrziD8bpHSd/O6kz0jW81i1KbwP1X
         nqXeo2Xdq+Hwwo/tCDjc18zaGqWf/0BsLvh7K6+fNg7Oj2HQJyo4h99DCv5+kKW3qWhH
         ghzEa6GVCS4iMeEdHstLgkXlBgQsoTiTHHhH1vWUoRxissSspUMuaietQ5rxO6HqHRrH
         S7GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710516669; x=1711121469;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cz+l6PNLT3cYvsUKyFGngxeM8Fm/GaSPA36vHKtylKI=;
        b=RoynNSv53OD3BwHULREt1GBCOiWQrWjW7UjMt6jKLoay+TT8V7IN//l7oSq5X1pDgo
         J0SQCbnsycBftgugseyJZuVSsxSwKqVMH3U6srIgEvlL4w0Aq3WFbpTlNsdIt+F13XHx
         ekSgqneJ48fgADL1rrRKsq/J8YGBX8/QJK8LFFtkOAcMeHDjuW904SDRpOqso9DokIfn
         mVQT9I1zrg/EZGqN91TnPsIdYx081K77DLDBM+Od6d5kxPmM9MCTq+s77LuhKTRDVEF5
         LVqAJvkk5gwd2Q+DySv1OV0v+413ie6tPs9mIWCyBDYd8pcxXJ3y/lc3cq4i7ddQ526Z
         mH6Q==
X-Gm-Message-State: AOJu0YzC/GZ0TrDMf+A+EKET+RXxLBxjEP0Fvhvxu1oh9vShW3Q1NMxA
	/5raHZGiqV9yJ+t0f751+sI7NTOGrjWRkxdszhWjgnIR1jgx7BM1kW57lETy
X-Google-Smtp-Source: AGHT+IHLSJyNCKrdusZ0DHts5FFm+jSBxo5z6I5cBNhRFpPl5OWXmvK+SIOW296cNcxJ7GUzq1ec2w==
X-Received: by 2002:a5d:6388:0:b0:33e:77e6:40bf with SMTP id p8-20020a5d6388000000b0033e77e640bfmr2420941wru.37.1710516668973;
        Fri, 15 Mar 2024 08:31:08 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.141.58])
        by smtp.gmail.com with ESMTPSA id u3-20020a5d6ac3000000b0033dd2c3131fsm3415671wrw.65.2024.03.15.08.31.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Mar 2024 08:31:08 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	Kanchan Joshi <joshi.k@samsung.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 00/11] remove aux CQE caches
Date: Fri, 15 Mar 2024 15:29:50 +0000
Message-ID: <cover.1710514702.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Patch 1 is a fix.

Patches 2-7 are cleanups mainly dealing with issue_flags conversions,
misundertsandings of the flags and of the tw state. It'd be great to have
even without even w/o the rest.

8-11 mandate ctx locking for task_work and finally removes the CQE
caches, instead we post directly into the CQ. Note that the cache is
used by multishot auxiliary completions.

The nvme cmd change is tested with io_uring_passthrough.c, however
it doesn't seem there is anything in liburing exercising ublk paths.
How do we test it? It'd be great to have at least some basic tests
for it.

Pavel Begunkov (11):
  io_uring: fix poll_remove stalled req completion
  io_uring/cmd: kill one issue_flags to tw conversion
  io_uring/cmd: fix tw <-> issue_flags conversion
  io_uring/cmd: introduce io_uring_cmd_complete
  ublk: don't hard code IO_URING_F_UNLOCKED
  nvme/io_uring: don't hard code IO_URING_F_UNLOCKED
  io_uring/rw: avoid punting to io-wq directly
  io_uring: force tw ctx locking
  io_uring: remove struct io_tw_state::locked
  io_uring: refactor io_fill_cqe_req_aux
  io_uring: get rid of intermediate aux cqe caches

 drivers/block/ublk_drv.c       |  18 ++---
 drivers/nvme/host/ioctl.c      |   9 ++-
 include/linux/io_uring/cmd.h   |  24 ++++++
 include/linux/io_uring_types.h |   5 +-
 io_uring/io_uring.c            | 132 +++++++++------------------------
 io_uring/io_uring.h            |   8 +-
 io_uring/net.c                 |   6 +-
 io_uring/poll.c                |   7 +-
 io_uring/rw.c                  |  18 +----
 io_uring/timeout.c             |   8 +-
 io_uring/uring_cmd.c           |  14 ++--
 io_uring/waitid.c              |   2 +-
 12 files changed, 95 insertions(+), 156 deletions(-)

-- 
2.43.0


