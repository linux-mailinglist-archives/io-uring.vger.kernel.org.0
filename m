Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FE6F779193
	for <lists+io-uring@lfdr.de>; Fri, 11 Aug 2023 16:16:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235293AbjHKOQa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 11 Aug 2023 10:16:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233485AbjHKOQ3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 11 Aug 2023 10:16:29 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7207BFC
        for <io-uring@vger.kernel.org>; Fri, 11 Aug 2023 07:16:29 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id d2e1a72fcca58-68781a69befso348185b3a.0
        for <io-uring@vger.kernel.org>; Fri, 11 Aug 2023 07:16:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1691763388; x=1692368188;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=JfMLgTShUSv1TlLgjUBNX5q2wHntjjltNqKMlW1h7RQ=;
        b=hrVzUCCsH+uAnErBgiunYK/+X5Y5Ua2wVZMVmjqIyfEo3SF/ie8pBpcZVA0hfhzdrQ
         /yaWM+tRd2bTUfNs4B9pz4wMGQ082DyuIcGeOLAAM52QWUGmMH2dik5E9L1mCKx85vaU
         5HbNo/iYNnj8Mzbn9uhuqAD0mvKUOLrkDAL3tXcQHufy1Q1qTI8BcVcSxvT0QJMX7MNW
         huixyhrOlk2o1VP0yWqWsnMv3e7uzSywaMTWsjYudrszuUzyvP2urETVAuqLM6M6STrK
         0vVC4x6yGap89NbbukLcALHfJItxy8uyFwY8gLQVB3ljr6c3wo0b8tMoLfgm01OdZiko
         kflQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691763388; x=1692368188;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JfMLgTShUSv1TlLgjUBNX5q2wHntjjltNqKMlW1h7RQ=;
        b=Jd0hta15z8FuX3/xatj7ssCLYTTW6TdaAI0H8K+L4RTognCM9bPY2Sq2JCMdrpFqZ+
         2B499KpDrb8ccmwedSrswHOJPAP1XHl17fYxEqR/u+dMPV9Z4sbsD3xSWcgttxbggROA
         XFoZmYkImt2+k53/LBI3PZrJf85HaQFlfrYZjiQ+VHJRM2tCottOFIb1yTxmJakpngHZ
         zgfRV/WxtatMLs2HvMuQqiogv46xzp1tzL9XzkCV+ddx2ucWUSJrfl7T2YRWJ7SohVxh
         BoLcPag8DOpL+Zg08kfIIzu/Y1keYXyrFTyC2yRaGnBYgJwZ8R5Gjq+w4e5blaDwZMol
         4k4g==
X-Gm-Message-State: AOJu0YyityfF27D1taJ+DanyZtLqvYPjPC0B7Ch28pqc1oRwIvLmOhnt
        wfFTj44qPWa45cpeRy6SeGQwHlDonOa9OdCpLaM=
X-Google-Smtp-Source: AGHT+IGDFQiYppCiqYwWHzy8b+/mIwtVNehSWmSJt2DwuZbuZoybQdTy1lT1JOiINl13SfA1TB0enA==
X-Received: by 2002:a05:6a20:7f8b:b0:111:a0e5:d2b7 with SMTP id d11-20020a056a207f8b00b00111a0e5d2b7mr3085327pzj.4.1691763388551;
        Fri, 11 Aug 2023 07:16:28 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id s21-20020a639255000000b00564ca424f79sm3422311pgn.48.2023.08.11.07.16.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Aug 2023 07:16:28 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     brauner@kernel.org, arnd@arndb.de
Subject: [PATCHSET v3 0/5] Add io_uring support for waitid
Date:   Fri, 11 Aug 2023 08:16:21 -0600
Message-Id: <20230811141626.161210-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

This adds support for IORING_OP_WAITID, which is an async variant of
the waitid(2) syscall. Rather than have a parent need to block waiting
on a child task state change, it can now simply get an async notication
when the requested state change has occured.

Patches 1..4 are purely prep patches, and should not have functional
changes. They split out parts of do_wait() into __do_wait(), so that
the prepare-to-wait and sleep parts are contained within do_wait().

Patch 5 adds io_uring support.

I wrote a few basic tests for this, which can be found in the
'waitid' branch of liburing:

https://git.kernel.dk/cgit/liburing/log/?h=waitid

Also spun a custom kernel for someone to test it, and no issues reported
so far.

 include/linux/io_uring_types.h |   2 +
 include/uapi/linux/io_uring.h  |   2 +
 io_uring/Makefile              |   2 +-
 io_uring/cancel.c              |   5 +
 io_uring/io_uring.c            |   3 +
 io_uring/opdef.c               |   9 +
 io_uring/waitid.c              | 312 +++++++++++++++++++++++++++++++++
 io_uring/waitid.h              |  15 ++
 kernel/exit.c                  | 129 ++++++++------
 kernel/exit.h                  |  30 ++++
 10 files changed, 450 insertions(+), 59 deletions(-)

The code can also be found here:

https://git.kernel.dk/cgit/linux/log/?h=io_uring-waitid

Changes since v2:
- Get rid of 'f_flags' in kernel_waitid_prepare() (Christian)

-- 
Jens Axboe


