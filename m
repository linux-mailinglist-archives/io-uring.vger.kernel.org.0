Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 715AF74F91C
	for <lists+io-uring@lfdr.de>; Tue, 11 Jul 2023 22:33:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230148AbjGKUde (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 11 Jul 2023 16:33:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbjGKUdd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 11 Jul 2023 16:33:33 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A987910E3
        for <io-uring@vger.kernel.org>; Tue, 11 Jul 2023 13:33:31 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id d2e1a72fcca58-6831a5caf75so125389b3a.0
        for <io-uring@vger.kernel.org>; Tue, 11 Jul 2023 13:33:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689107610; x=1689712410;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=fB1PyYCxgU5LJD718Rda1NmZRnJIbaAlvaPfM1WjEFU=;
        b=2W+4k/Mbz+/Ejli+Sh2T8GoOlhS8dBQUz+RHgtmGTQbho6bnbjLYPtxHh9A04HEM64
         151wLDTklrE8zIC5U1R7P5FJRYaCGbaUHwpkpueZHDbz3KNUIWTVfuD4uB7TPOF/q57p
         OYfNqBo1/DO+2A3HsKsHEMNdpgbtjuC6Bm2qFNwsjpGDSWDMIeQSA09ANhwqhxiXgs0g
         sI1qGSkqxKSMaX/NdTnKsI6rYrmF9TkrJmjNLHkXtX0hz1BbnIk1BTMUaCXZLR7ppmgD
         44NFdknLm41AodSkZlSfkvxCE4gKlFKgvxXyF1IlHiU+bvmfoaOSMB3IZWF0ORn1gzY6
         gmxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689107610; x=1689712410;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fB1PyYCxgU5LJD718Rda1NmZRnJIbaAlvaPfM1WjEFU=;
        b=W7H44YAtIsFj++CrXixiKMV2ZoQ+BEwrsUihqgSUsw3/5BiQMoudvDtN2mo6MdNt32
         XAhQR+h4kdyHke2/dOUXf69rGTyKEzyvmbkwxv5ZmPFpWF0ZPuuOoSTq4ouwuFR1lBfQ
         7/dOwT2Rb6u3aSek78uhmlRztJjQ3v3hw9QLqhn2pMMAgRBD7/FYp/3BUsCIFslxhF1o
         PlKgYkVLyTyZJSznjlR9zHcOjwQ1L9+d71TcboNJjYgqOvjs41wrS46mWmTyEgMEmQZz
         CmXeOTbxTGFFWxPOrVfSiqGMfGuxvBDN+PMSXTFNF/Z6W3QHaXGhCON39NgSQSCroBoo
         fuCw==
X-Gm-Message-State: ABy/qLYTvQMnV7QxD3bO93xLvbKI+D2ZeTH/LIuW/Bh0ECoTEud+Ym23
        liO8GakL+/QHyIHPxKO8771VijwIN+waB6LOE94=
X-Google-Smtp-Source: APBJJlGYJHT1bV9rcREpfHmzdKKia792LdurTQPJZfomC7WrG2OLVvmGmz/KByIj+IZeHildskNm2Q==
X-Received: by 2002:a05:6a00:1ca0:b0:681:9fe0:b543 with SMTP id y32-20020a056a001ca000b006819fe0b543mr17672996pfw.2.1689107610440;
        Tue, 11 Jul 2023 13:33:30 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id fk13-20020a056a003a8d00b0067903510abbsm2108081pfb.163.2023.07.11.13.33.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jul 2023 13:33:29 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-xfs@vger.kernel.org
Cc:     hch@lst.de, andres@anarazel.de
Subject: [PATCHSET 0/5] Improve async iomap DIO performance
Date:   Tue, 11 Jul 2023 14:33:20 -0600
Message-Id: <20230711203325.208957-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

iomap always punts async dio completions to a workqueue, which has a
cost in terms of efficiency (now you need an unrelated worker to process
it) and latency (now you're bouncing a completion through an async
worker, which is a classic slowdown scenario).

This patchset intends to improve that situation. For polled IO, we
always have a task reaping completions. Those do, by definition, not
need to be punted through a workqueue. This is patch 1, and is good
for up to an 11% improvement in my testing. Details in that patch
commit message.

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

 fs/iomap/direct-io.c | 39 +++++++++++++++++++++++++++++++++------
 include/linux/fs.h   | 30 ++++++++++++++++++++++++++++--
 io_uring/rw.c        | 24 ++++++++++++++++++++----
 3 files changed, 81 insertions(+), 12 deletions(-)

Can also be found in a git branch here:

https://git.kernel.dk/cgit/linux/log/?h=xfs-async-dio

-- 
Jens Axboe



