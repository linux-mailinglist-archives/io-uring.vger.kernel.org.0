Return-Path: <io-uring+bounces-137-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 116A27F4BD5
	for <lists+io-uring@lfdr.de>; Wed, 22 Nov 2023 17:02:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2AAF21C20A71
	for <lists+io-uring@lfdr.de>; Wed, 22 Nov 2023 16:02:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70B6957871;
	Wed, 22 Nov 2023 16:02:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ilSqag2I"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B14BC92;
	Wed, 22 Nov 2023 08:02:48 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id 4fb4d7f45d1cf-5440f25dcc7so9833480a12.0;
        Wed, 22 Nov 2023 08:02:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700668967; x=1701273767; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=UB34EB9M6UMsx2R8XCgx/zxjlGb/btxWH/jNh3ZU3M4=;
        b=ilSqag2I5kjPaXMJ518XGqrOU7COvc5r14vi5hyUhiNYaI+0ZsMHRAE/nmI3TYDz3Z
         Zu5bllogKpujgl2zfdJzjjN4JfkXO03RPPjkg0zfv0ZTdE5Ti9M+aXSY7AV3y6xU8wpk
         tiOFPjuSyG1FLfx7mgHC+jf1M1xh4+RksAXv/PdMY3ZVsGJ0dGB/1t28t08iwEMaBMd5
         atmQTJyFVdgPOO4ieteEIZ2II/JUXjr8MveesyIq8sO9JbHIZ/v3joHJpvV1zcwgzmtL
         lZa+nmO1YmCQUisGwG19wxoJyeneKKsrCB9DQx/B6idOA7cNJgiP43+QmnW0cCfKIgJw
         DHQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700668967; x=1701273767;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UB34EB9M6UMsx2R8XCgx/zxjlGb/btxWH/jNh3ZU3M4=;
        b=LQ3B8ZVUq5UxyincqlLUlglnn8qN2px9c8aFOWElSQT59Z2j0ioPnCfVsxFYgrYL0U
         Dzz+vSPWAEc2kyGwcV5L5d3X0cOOEfYGNO2Me7LgJC7YORkcw+m/u04+xc5eCwIYgGFr
         2AKRY8o/dJxqD4TNCxBZv6ZljRZ+OWcjktA8XLIk65rhQPK7ql8CqT9gzPgEtIZAFXci
         Nkzrrwk1fXPD8I1wDPGOZucZVis/kNP0GsCF9Hc6bmec5YDYjQa5RsIQbwGnewpgVTZG
         shxk4xF681BlNIB9IycwaBvJP1s7JkzZN8blu/BcHg0N4KAuROWonAhXZyWzCd6KJtKY
         9tkw==
X-Gm-Message-State: AOJu0Ywtq9W8u451CKUzgbVABpTIjmij8Om/1GsUfdmfhGNuD5/4EQNi
	6tuOj0jAdhjRRj402LmiJfU6CqaqMxI=
X-Google-Smtp-Source: AGHT+IFh1lljozdV8hU3OSeKjudz8yozp6RaWTGBP1F22lsuIyPoqEjYNJGXZbKNLdZhd5ZDI2eVEA==
X-Received: by 2002:a17:906:1094:b0:9e6:18fe:7447 with SMTP id u20-20020a170906109400b009e618fe7447mr1760757eju.9.1700668966712;
        Wed, 22 Nov 2023 08:02:46 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::2:fba6])
        by smtp.gmail.com with ESMTPSA id x26-20020a1709065ada00b009fd04a1a1dfsm4541805ejs.40.2023.11.22.08.02.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Nov 2023 08:02:46 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	linux-block@vger.kernel.org,
	ming.lei@redhat.com,
	joshi.k@samsung.com
Subject: [PATCH 0/3] clean up io_uring cmd header structure
Date: Wed, 22 Nov 2023 16:01:08 +0000
Message-ID: <cover.1700668641.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.42.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Looking at the zc rfc, and how we tend to stuff everything into
linux/io_uring, start splitting the file before it becomes even more
monstrous.

Pavel Begunkov (3):
  io_uring: split out cmd api into a separate header
  io_uring/cmd: inline io_uring_cmd_do_in_task_lazy
  io_uring/cmd: inline io_uring_cmd_get_task

 drivers/block/ublk_drv.c       |  2 +-
 drivers/nvme/host/ioctl.c      |  2 +-
 include/linux/io_uring.h       | 89 +---------------------------------
 include/linux/io_uring/cmd.h   | 82 +++++++++++++++++++++++++++++++
 include/linux/io_uring_types.h | 31 ++++++++++++
 io_uring/io_uring.c            |  1 +
 io_uring/io_uring.h            | 10 ----
 io_uring/rw.c                  |  2 +-
 io_uring/uring_cmd.c           | 15 +-----
 9 files changed, 119 insertions(+), 115 deletions(-)
 create mode 100644 include/linux/io_uring/cmd.h

-- 
2.42.1


