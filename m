Return-Path: <io-uring+bounces-1114-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9EEAD87F2C7
	for <lists+io-uring@lfdr.de>; Mon, 18 Mar 2024 23:02:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5BB3C281CBB
	for <lists+io-uring@lfdr.de>; Mon, 18 Mar 2024 22:02:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0922659B5E;
	Mon, 18 Mar 2024 22:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g8HI9xjU"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F92D5A780;
	Mon, 18 Mar 2024 22:02:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710799333; cv=none; b=KGPWPevpdgovsJDvkgsHtnISyQYJARlvYj0RIeV+zuCigXUCKxhiZm2qNPEZBdkLOww4UTNjwG99XYA1ZCOtkteIwd3mvl89qKTqK6HDz2wJfM1txHzLYp8O/t7WZ53Jry0DY5YjYaL65SYQcJNwx4IYhN3w+U/PTo7BuUVc2Us=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710799333; c=relaxed/simple;
	bh=K9uPPrizuoXMPxGQ9QHOweUbGagb9MxJN/2z01Evh7s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=W/m7bLmTdDt/Cq+GmSD2nLy85tHw73AgrDHp8ShPmiXVEe9I0W2zUGExn34wHiHd8yKV+Ywh4DuolLfH7uB68giHX0pY2spS75UrorNWhqKviFpsbiV7YJtNPUIo01F0HfhF78q6gYFxclLxCJr9SdPLi6PKFOWCkCfBCxEqPFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=g8HI9xjU; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-33d90dfe73cso2756542f8f.0;
        Mon, 18 Mar 2024 15:02:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710799330; x=1711404130; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=1YLYJuZzXFCsH5eRkHGfTtbVhkaUWk/1syKgLwvu/7o=;
        b=g8HI9xjULSxZirLCU3CFeVC6rODSLIfQrIaOLiUKCtXy5mOKfiNmatEtNvBkzKmjM1
         0+7egr4F22aJ04Ri4sCY0pK9LuHTzMAgTlyd1IxEON56K6MUEt1KKfmsiZSrlyuusQRB
         Ps3VYsdF8jGpMPkPOcBA5rYsLaqZGbOo4yysl/FzF6uAvYromTgjH1BJP47luQdU7zZN
         VuJzcVik96CLWSlV5QgY93R7muR3Ixfhyb27h9A3WDKMbue4oj/PKKfybbOYuFgCe7Dq
         oP4hoHGcsKrP9KNj0DCBTfWgrxjPtcPEKIH14meo779uA1P0c0zFIzuGIp+CqXXPfi/p
         cQ1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710799330; x=1711404130;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1YLYJuZzXFCsH5eRkHGfTtbVhkaUWk/1syKgLwvu/7o=;
        b=D018jjL2SOwu0GO/Y5Hm/KYmIkWuexMOBNxgecnliI2/Rk6ZCyIczLx1gWIa6zZPnm
         6yqAHZautg+Dyf8U4EOwWlpQHD7H0cq1k9bQNjTwITV9iMW1rUbsCF/X6DyFuZw41cq+
         R8lMJdhgzXYGoy6m388ws6k8xxkyGFv5U1l8OoX4+uCBKa4P9hLRhDN+o3dzTk6aDWsr
         xLVzItTGgilPge3PdY4SRB25urSKMOmkFRZheOhQZle++yuki/oOHpi9wlxkNb44AEbw
         8og+d4x0c9CWt07gQxs8Urr4bQ0CC+XD/xhKNfM+Y1b6fvrlFxP5/3/ABZggxocUPMin
         Frug==
X-Gm-Message-State: AOJu0Yy2+o0vLbgeBAGq8yjP7hfHD5zQrpGg6Chf/LZbJ1J+QK2CheVP
	Nkvlf2MciZXVcJHMIdvc3NhtGK6wZBKeTs5ew91MwhUl6ShFHLGeF5P169RU
X-Google-Smtp-Source: AGHT+IFvo3r+D4gxx3y7WFB7X6UeoQPPGlv+aylxNsgVZzfuxbRCm+6fiFe9UXfnlxVmVt1PkhnOHA==
X-Received: by 2002:adf:f545:0:b0:33e:9f16:33c with SMTP id j5-20020adff545000000b0033e9f16033cmr699168wrp.18.1710799330012;
        Mon, 18 Mar 2024 15:02:10 -0700 (PDT)
Received: from 127.0.0.1localhost ([85.255.232.181])
        by smtp.gmail.com with ESMTPSA id bj25-20020a0560001e1900b0033e68338fbasm2771038wrb.81.2024.03.18.15.02.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Mar 2024 15:02:09 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	Kanchan Joshi <joshi.k@samsung.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH v3 00/13] Remove aux CQE caches
Date: Mon, 18 Mar 2024 22:00:22 +0000
Message-ID: <cover.1710799188.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Mandate ctx locking for task_work. Then, remove aux CQE caches mostly
used by multishot requests and post them directly into the CQ.

It's leaving some of the pre existing issue_flags and state conversion
non conformant chunks, which will need to clean up later.

v3: pass IO_URING_F_COMPLETE_DEFER to the cmd cancellation path
    drop patch moving request cancellation list removal to tw 
    drop all other ublk changes

v2: Add Patch 3, which fixes deadlock due to nested locking
    introduced in v1
    Remove a fix, which was taken separately
    Pile up more cleanups (Patches 12-14)

Pavel Begunkov (13):
  io_uring/cmd: move io_uring_try_cancel_uring_cmd()
  io_uring/cmd: kill one issue_flags to tw conversion
  io_uring/cmd: fix tw <-> issue_flags conversion
  io_uring/cmd: introduce io_uring_cmd_complete
  nvme/io_uring: don't hard code IO_URING_F_UNLOCKED
  io_uring/rw: avoid punting to io-wq directly
  io_uring: force tw ctx locking
  io_uring: remove struct io_tw_state::locked
  io_uring: refactor io_fill_cqe_req_aux
  io_uring: get rid of intermediate aux cqe caches
  io_uring: remove current check from complete_post
  io_uring: refactor io_req_complete_post()
  io_uring: clean up io_lockdep_assert_cq_locked

 drivers/nvme/host/ioctl.c      |   9 +-
 include/linux/io_uring/cmd.h   |  28 +++++
 include/linux/io_uring_types.h |   5 +-
 io_uring/io_uring.c            | 198 ++++++++-------------------------
 io_uring/io_uring.h            |  24 ++--
 io_uring/net.c                 |   6 +-
 io_uring/poll.c                |   3 +-
 io_uring/rw.c                  |  18 +--
 io_uring/timeout.c             |   8 +-
 io_uring/uring_cmd.c           |  45 +++++++-
 io_uring/uring_cmd.h           |   3 +
 io_uring/waitid.c              |   2 +-
 12 files changed, 143 insertions(+), 206 deletions(-)

-- 
2.44.0


