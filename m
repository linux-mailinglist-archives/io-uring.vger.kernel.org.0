Return-Path: <io-uring+bounces-9564-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E256B443EE
	for <lists+io-uring@lfdr.de>; Thu,  4 Sep 2025 19:09:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1DF05A43951
	for <lists+io-uring@lfdr.de>; Thu,  4 Sep 2025 17:09:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D92021B905;
	Thu,  4 Sep 2025 17:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="EfM0zz2h"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f228.google.com (mail-il1-f228.google.com [209.85.166.228])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5DCB2D47EB
	for <io-uring@vger.kernel.org>; Thu,  4 Sep 2025 17:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.228
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757005752; cv=none; b=qhhZ/r4QLi9UxwskGoYi5ZCvij9xV6Uw+R+bmbY/UkO4QPYENrm6P73s1DaA1i97JtejJ7fgsUaGXrjciFbI0WC1QiujZ2eoGYtf8TWrbWo9WYyKT12LyFc2kaveO7gWd6QZ7GVDdyws9i/Ho0SbcNGVAbO/93ldtNg4dxlsOPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757005752; c=relaxed/simple;
	bh=Sm4iGO2AOiv94eWN0APz1i3s0pb/OrQQWRML6s9S3oY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gxwaHxTI/HvPUHMH6HAlxaDHCQQbrWqNkWdTgNzRePBIrOeEj0+E3PrwIdUWtR7l5xlG+hTrsZTyjjYATGzb6WTiW//Hq16uGkvvFhVztZ8YpnIwjSCG85KppANNx9OSdhPPrp2wggUgMboz3gWCYVji+MiJVrE19SyOC67ZBuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=EfM0zz2h; arc=none smtp.client-ip=209.85.166.228
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-il1-f228.google.com with SMTP id e9e14a558f8ab-3f45b5bcaadso1372165ab.3
        for <io-uring@vger.kernel.org>; Thu, 04 Sep 2025 10:09:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1757005750; x=1757610550; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=2obhidJDmTCm2pc8aTk+fIidK1fBd1xryBTgjQFvBEc=;
        b=EfM0zz2hdTOt9agW0WoSaRad9LLONeKbNOGmJ1Zh3LPqAUV2pPa5YTZyxWni9oevBr
         IPahAIBaSX7x3zxD5Hg410lHzyzwFzOoQf/m8CdWZigncY0UY4n51toeMAD7k2mE9QaX
         I0UgoC7lfEpwM8FkeHL/2FHs1GYOKwaXur8svmBsuH2JxgdvmWZjVEO+ZC1C8zYKcL/7
         yy59NhonFtUO+hIGHeY/Z4O132cVG4hv0JSX98zKFGj7iyflGph7C20DJ7DFZ07vZ5Zj
         azsOFAEVLMSVqGBeTCo5bbqB30Lx0XglGtkVKk/h3mrKaD69OoRI1q5g61f3EQEQpYNB
         3CxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757005750; x=1757610550;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2obhidJDmTCm2pc8aTk+fIidK1fBd1xryBTgjQFvBEc=;
        b=TLgCLYW8sb6kd9xcEdpzIwd3eCkGnE5FLujwBI/TioLbYeOl6NFMoJlULKHWv+Wi3J
         B3R1AiUEoDBA3sf0iSiV5PuHvgItIykr3LbLktie2/iZ2lmEn/sZHt1qXbjh/0+lSrzI
         u5/o/EKJv4pSqf7LPo4p/kj27NGmhrgiapbDioD8dI1HhAQq++PEBnXoP/T//hCpHviV
         2hA5KiC2whyIVz2xe9pb+dbJoa/X4YJbkJ+xaJeMQuhCt0K+yQq8Yl0PsrmY7iyqPYZ2
         MjLuRXGZgYkvb1KvJhjBeUszsY1PLKab4dqiC8Pw8g5ldVkcrA0QLchfIsqiy7TsKPhO
         pnXg==
X-Gm-Message-State: AOJu0Yz+HL/gRIgVch87CGI1z4u4+5q6b8K2gbEVpkhyW+Lh8rt/xn6c
	f/+SAGCvwvE+gtjxG8dWeEvKuWmm8jdvnaHq4B3OoiKVsOaedtc71vWtuESBHuy2WeMa1QgIWVI
	SdV0q1jMqdcPtoiFfiJSV4i0JCBFSk1ZAx3OZDBlWmzIf1Qj7qhtm
X-Gm-Gg: ASbGncsitV5LzsvVoBNKxLOWViCQQa80kj3PehYDlQZkR2IHpZfIf3MkmC/Fje1YjCr
	IaOfIQMLU60l8+nxSGg79LInvMGFXc3RX2fmcj664Hnwdwd9uXUdRdhZHX6B3p3V5WHL7eo/7yt
	PdvsCo0qYCgFGhIAXPUkSF9G/ij8QNPX4Ui7Y/tFO91PB5xi5XDgW7bMkzYmGQHjTtqhBsCbTfK
	+pX7UgDa6upUlijrCRafZ0aZa5SDGjiWZeQtyki984FlaALPh24jnr1Iz0BB1V4SQJYiYM7LNMk
	2NnkOfoNkxkjJGNpYh7mRj//3S1iqKvzAKQh9PYevPf2JrRZ9bskwWPhJw==
X-Google-Smtp-Source: AGHT+IFoTqTS1ZboFKXcVYtB5+x3SrxGIkhmkoTAlvV3QxYCwz0SQrJRChn1KUSgfw6thNxn40yfJxfX0irT
X-Received: by 2002:a05:6e02:2506:b0:3f6:b36e:328b with SMTP id e9e14a558f8ab-3f6b36e3369mr9025025ab.3.1757005749896;
        Thu, 04 Sep 2025 10:09:09 -0700 (PDT)
Received: from c7-smtp-2023.dev.purestorage.com ([2620:125:9017:12:36:3:5:0])
        by smtp-relay.gmail.com with ESMTPS id e9e14a558f8ab-3f3df873e56sm12055885ab.45.2025.09.04.10.09.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Sep 2025 10:09:09 -0700 (PDT)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.7.70.37])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id 97106340647;
	Thu,  4 Sep 2025 11:09:09 -0600 (MDT)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id 81139E41979; Thu,  4 Sep 2025 11:09:09 -0600 (MDT)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Caleb Sander Mateos <csander@purestorage.com>
Subject: [PATCH v2 0/5] io_uring: avoid uring_lock for IORING_SETUP_SINGLE_ISSUER
Date: Thu,  4 Sep 2025 11:08:57 -0600
Message-ID: <20250904170902.2624135-1-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

As far as I can tell, setting IORING_SETUP_SINGLE_ISSUER when creating
an io_uring doesn't actually enable any additional optimizations (aside
from being a requirement for IORING_SETUP_DEFER_TASKRUN). This series
leverages IORING_SETUP_SINGLE_ISSUER's guarantee that only one task
submits SQEs to skip taking the uring_lock mutex in the submission and
task work paths.

First, we need to close a hole in the IORING_SETUP_SINGLE_ISSUER checks
where IORING_REGISTER_CLONE_BUFFERS only checks whether the thread is
allowed to access one of the two io_urings. It assumes the uring_lock
will prevent concurrent access to the other io_uring, but this will no
longer be the case after the optimization to skip taking uring_lock.

We also need to remove the unused filetable.h #include from io_uring.h
to avoid an #include cycle.

v2:
- Don't enable these optimizations for IORING_SETUP_SQPOLL, as we still
  need to synchronize SQ thread submission with io_uring_register()

Caleb Sander Mateos (5):
  io_uring: don't include filetable.h in io_uring.h
  io_uring/rsrc: respect submitter_task in io_register_clone_buffers()
  io_uring: clear IORING_SETUP_SINGLE_ISSUER for IORING_SETUP_SQPOLL
  io_uring: factor out uring_lock helpers
  io_uring: avoid uring_lock for IORING_SETUP_SINGLE_ISSUER

 io_uring/cancel.c    |  1 +
 io_uring/fdinfo.c    |  2 +-
 io_uring/filetable.c |  3 +-
 io_uring/io_uring.c  | 67 +++++++++++++++++++++++++++++---------------
 io_uring/io_uring.h  | 43 ++++++++++++++++++++++------
 io_uring/kbuf.c      |  6 ++--
 io_uring/net.c       |  1 +
 io_uring/notif.c     |  5 ++--
 io_uring/notif.h     |  3 +-
 io_uring/openclose.c |  1 +
 io_uring/poll.c      |  2 +-
 io_uring/register.c  |  1 +
 io_uring/rsrc.c      | 10 ++++++-
 io_uring/rsrc.h      |  3 +-
 io_uring/rw.c        |  3 +-
 io_uring/splice.c    |  1 +
 io_uring/waitid.c    |  2 +-
 17 files changed, 111 insertions(+), 43 deletions(-)

-- 
2.45.2


