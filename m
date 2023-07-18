Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BE1B7585C0
	for <lists+io-uring@lfdr.de>; Tue, 18 Jul 2023 21:49:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230017AbjGRTt0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 18 Jul 2023 15:49:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjGRTt0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 18 Jul 2023 15:49:26 -0400
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13712198E
        for <io-uring@vger.kernel.org>; Tue, 18 Jul 2023 12:49:25 -0700 (PDT)
Received: by mail-il1-x133.google.com with SMTP id e9e14a558f8ab-345d2b936c2so5294215ab.0
        for <io-uring@vger.kernel.org>; Tue, 18 Jul 2023 12:49:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689709764; x=1690314564;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=TCluVD14LcdKKQ0S/mQnMo1rq4wRSzAnLZOVOcyS9i4=;
        b=H3RX9PSotNQjhcLzOxCLjhjoJLTbqCr3+d9uDxO6B8vPXHCKaYccg47cnJxFiMVpqp
         rIsODMqD85G2WqcmfogcNrGxHFb9+yS+wAHG8XHIRT8euNCz4AexIwA/b2wBhYOAYL0V
         DWG3PQZv6VRfpZXe2nJBHxUtpdCDeiFENki82jynONtL1I3Q/hxzxlrOO44YNRJJigdu
         9U2W3aRLU//3UA2uWwikHLbqr0nMnkXBJetW6m/RxDOneTIlwj2Wo4pijcBygiVuE7Qy
         GA1LmSBnjRwIyPCZ7YtGkU3AYsWFT6SaZTyRiV4E8EdJ6CFse6cVUP1lXjxzC0vqEi5P
         W7Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689709764; x=1690314564;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TCluVD14LcdKKQ0S/mQnMo1rq4wRSzAnLZOVOcyS9i4=;
        b=KwfBxJJ9k8/yL0WEh2h/8mCK4/7omWB0KSCajS6ZOAeVg89OJgVkb6rdxkd1vQUHyk
         WUbUcpVL7h6IB1dPZEp7HpM49X54JH6anStFeJdWyR2ZMFAN9q0ojr6xQNNixD8b+VkP
         HQdBSsWoOKfEuG97biqZtHYEGd1R4CYvTKSD3pnWQ1cUbCNCJFYSXDL8g0Cmm3lLFk9Z
         srSDeae1fDgnrPa+5JwG1wTqQfEerofuNVeKIvfcbJle7bNjyRJEqFXnYpGzVYXfCjGE
         hNyIEYUzNm3cZla0/75XTc77Rm1SdW8kuyQnWaf5yZJ0okYpnpKexms0WLybfkfxVIDp
         jb+A==
X-Gm-Message-State: ABy/qLZ2Oj2GtCHfcUoPxijwOrJ4cLnrJTKy02sB0ZjCwVGWuN3ptLKv
        Kx/SQ925/5bH1SEgfelbViLbFluneEZrjYbvpPI=
X-Google-Smtp-Source: APBJJlF9laWC6p2BMCWMuaPf6kUdGIA2pm2eISS4VPQlbXAl1m7VMtjYAjN/zpfns84mLJQCy5gRHw==
X-Received: by 2002:a05:6e02:17c8:b0:346:4eb9:9081 with SMTP id z8-20020a056e0217c800b003464eb99081mr7449789ilu.3.1689709764046;
        Tue, 18 Jul 2023 12:49:24 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id v18-20020a92d252000000b00345e3a04f2dsm897463ilg.62.2023.07.18.12.49.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jul 2023 12:49:23 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-xfs@vger.kernel.org
Cc:     hch@lst.de, andres@anarazel.de, david@fromorbit.com
Subject: [PATCHSET v2 0/5] Improve async iomap DIO performance
Date:   Tue, 18 Jul 2023 13:49:14 -0600
Message-Id: <20230718194920.1472184-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

iomap always punts async dio write completions to a workqueue, which has
a cost in terms of efficiency (now you need an unrelated worker to
process it) and latency (now you're bouncing a completion through an
async worker, which is a classic slowdown scenario).

This patchset intends to improve that situation. For polled IO, we
always have a task reaping completions. Those do, by definition, not
need to be punted through a workqueue. This is patch 1, and it adds an
IOMAP_DIO_INLINE_COMP flag that tells the completion side that we can
handle this dio completion without punting to a workqueue, if we're
called from the appropriate (task) context. This is good for up to an
11% improvement in my testing. Details in that patch commit message.

For IRQ driven IO, it's a bit more tricky. The iomap dio completion
will happen in hard/soft irq context, and we need a saner context to
process these completions. IOCB_DIO_DEFER is added, which can be set
in a struct kiocb->ki_flags by the issuer. If the completion side of
the iocb handling understands this flag, it can choose to set a
kiocb->dio_complete() handler and just call ki_complete from IRQ
context. The issuer must then ensure that this callback is processed
from a task. io_uring punts IRQ completions to task_work already, so
it's trivial wire it up to run more of the completion before posting
a CQE. Patches 2 and 3 add the necessary flag and io_uring support,
and patches 4 and 5 add iomap support for it. This is good for up
to a 37% improvement in throughput/latency for low queue depth IO,
patch 5 has the details.

This work came about when Andres tested low queue depth dio writes
for postgres and compared it to doing sync dio writes, showing that the
async processing slows us down a lot.

 fs/iomap/direct-io.c | 44 +++++++++++++++++++++++++++++++++++++-------
 include/linux/fs.h   | 30 ++++++++++++++++++++++++++++--
 io_uring/rw.c        | 24 ++++++++++++++++++++----
 3 files changed, 85 insertions(+), 13 deletions(-)

Can also be found in a git branch here:

https://git.kernel.dk/cgit/linux/log/?h=xfs-async-dio.2

Changelog:
- Rewrite patch 1 to add an explicit flag to manage when dio completions
  can be done inline. This drops any write related checks. We set this
  flag by default for both reads and writes, and clear it for the latter
  if we need zero out or O_DSYNC handling.

-- 
Jens Axboe


