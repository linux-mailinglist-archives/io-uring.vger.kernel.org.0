Return-Path: <io-uring+bounces-1062-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5254F87E146
	for <lists+io-uring@lfdr.de>; Mon, 18 Mar 2024 01:43:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DA280282B70
	for <lists+io-uring@lfdr.de>; Mon, 18 Mar 2024 00:43:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A220182B5;
	Mon, 18 Mar 2024 00:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mf6eeq3V"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com [209.85.208.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9A8817BD2;
	Mon, 18 Mar 2024 00:43:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710722620; cv=none; b=H94wrZkG/E5+bxbxd9ydrEN8tQ4LcAZ0lYDlPwefXaUs4q5yCxtkrI/AXUCAihzvgGw87pTOA6vONfjdrHkFXNSsK0qnGolw6wlADWD2MBNoXNP3QPIS6Mr4ZWqN2DjzARSf1MtT3LawFDE27qTAw6LQIEOk0if5B/f3lpBJ3IY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710722620; c=relaxed/simple;
	bh=AblGI6/zCz8zl2lUSU5q67virkiimwPszs+OtU6tLCc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DutywjW1WLr40WQYlt8XEdqvxb9GXdV0rQZTnPsc2Pk1Nh/4oO91DwP7z8zjdrSCOL+Bs7Pnk6Bo8ZlV8q160oFgLPpcLzvJhD8yB4auOY3pze6H5OLwJLFCjUZkQCPegs0Ws/wpowiKdm6Y5Qcbn2mQARE1dnIWcIE4Day1WV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mf6eeq3V; arc=none smtp.client-ip=209.85.208.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-2d46dd8b0b8so50589871fa.2;
        Sun, 17 Mar 2024 17:43:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710722616; x=1711327416; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=sHNPPKcgXe0sGyDQcPenZ6cORzEgiy7uPTy28LJGL48=;
        b=mf6eeq3VW/3fsXyQRGe/FoK7Ayt5ZtO2lzFMvoDVwb4rhBbay6ExKDuSAqHapbocdt
         vZAdDQ2nwqRNjSX+8S6fpU+izXOr5oJZJRBusqE5TJmddUuVCgmqaJCPAzjBWxdwAHyh
         /4zYZ6nEYSR3ynW6wSZoYE8FsPgcHmIDCMVt8J7kfMz3rftHlHR2ghoCSiDJmO1bVQL0
         kv7DbDRGNhoc7pTUzroYFi07Da5GXWq5X2XLiC6I96Tp3v1sb+MppRVDjoe1bu98ijHK
         RAi4aGuBaZHtuo5BuknUWuu6yU4uYxt8p0I//aSM7efK7SjvoGvCzS6O1nxVJKKLglUV
         dBlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710722616; x=1711327416;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sHNPPKcgXe0sGyDQcPenZ6cORzEgiy7uPTy28LJGL48=;
        b=ZXJoO/JBuKRIuPTUikSTz7tLFPMiW2KyBYnQWWNHNlCF+PtE7kZ6s1ghBRyNUjx457
         2RuPnjvj/YKfai//BD/zFduapPFBHZMVzQvDAHSDOvPbubeAe43BUoxK9qgqScivIeTg
         zC0XFVUcMbc+MqrbCVKzfG0gw9Jv6ZL6XNJE/l9DMyW3oMKcI67mF1BDvC1JLLDrh3YN
         01QwIBXwV0BOC+8+MnScKFzQ5EDMz3vzfafZeXd+ZfRdN1rYYexhFFEXK4jqS7Z+EvIP
         MV0o9fglk2m3M2Us93K4PnncnXZ7tKXfOZXwLSap5KOrB5CfQ0AoeAmDkm+H3iUWXGjo
         FI7Q==
X-Gm-Message-State: AOJu0Yx6EnY6QhgG25qUfEiAKC4AgYrN4AM6CE0cBWzJr1epw4BylYxT
	IumEBriP5S28Y3tpFTsOhz3Wg57xdStboi87iMP6MlnF8WZA9oROh6sq+CTd
X-Google-Smtp-Source: AGHT+IFbwcOpRrp4oflPhSYSk0wqgOz8zcTYDh03B916uiPiowMDJk2W3iwr6ad4gWWqoluKdNHoSA==
X-Received: by 2002:a05:651c:10c9:b0:2d2:2ce1:1196 with SMTP id l9-20020a05651c10c900b002d22ce11196mr6493132ljn.53.1710722615885;
        Sun, 17 Mar 2024 17:43:35 -0700 (PDT)
Received: from 127.0.0.1localhost ([85.255.232.181])
        by smtp.gmail.com with ESMTPSA id p13-20020a05640243cd00b00568d55c1bbasm888465edc.73.2024.03.17.17.43.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Mar 2024 17:43:35 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	Kanchan Joshi <joshi.k@samsung.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH v2 00/14] remove aux CQE caches
Date: Mon, 18 Mar 2024 00:41:45 +0000
Message-ID: <cover.1710720150.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Patches 1-7 are cleanups mainly dealing with issue_flags conversions,
misundertsandings of the flags and of the tw state. It'd be great to have
even without even w/o the rest.

8-11 mandate ctx locking for task_work and finally removes the CQE
caches, instead we post directly into the CQ. Note that the cache is
used by multishot auxiliary completions.

Patches 12-14 are additional cleanups that were sent out in a separate
patchset before.

Beware, there are problems reported coming from ublk testing, which
may or may not be due to unrelated problems with for-next.


v2: Add Patch 3, which fixes deadlock due to nested locking
    introduced in v1

    Remove a fix, which was taken separately

    Pile up more cleanups (Patches 12-14)


Pavel Begunkov (14):
  io_uring/cmd: kill one issue_flags to tw conversion
  io_uring/cmd: fix tw <-> issue_flags conversion
  io_uring/cmd: make io_uring_cmd_done irq safe
  io_uring/cmd: introduce io_uring_cmd_complete
  ublk: don't hard code IO_URING_F_UNLOCKED
  nvme/io_uring: don't hard code IO_URING_F_UNLOCKED
  io_uring/rw: avoid punting to io-wq directly
  io_uring: force tw ctx locking
  io_uring: remove struct io_tw_state::locked
  io_uring: refactor io_fill_cqe_req_aux
  io_uring: get rid of intermediate aux cqe caches
  io_uring: remove current check from complete_post
  io_uring: refactor io_req_complete_post()
  io_uring: clean up io_lockdep_assert_cq_locked

 drivers/block/ublk_drv.c       |  18 ++--
 drivers/nvme/host/ioctl.c      |   9 +-
 include/linux/io_uring/cmd.h   |  24 +++++
 include/linux/io_uring_types.h |   5 +-
 io_uring/io_uring.c            | 161 +++++++++------------------------
 io_uring/io_uring.h            |  17 +---
 io_uring/net.c                 |   6 +-
 io_uring/poll.c                |   3 +-
 io_uring/rw.c                  |  18 +---
 io_uring/timeout.c             |   8 +-
 io_uring/uring_cmd.c           |  36 +++++---
 io_uring/waitid.c              |   2 +-
 12 files changed, 122 insertions(+), 185 deletions(-)

-- 
2.44.0


