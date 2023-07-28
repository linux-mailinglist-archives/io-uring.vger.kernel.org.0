Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9577766EAF
	for <lists+io-uring@lfdr.de>; Fri, 28 Jul 2023 15:47:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236859AbjG1Nra (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 28 Jul 2023 09:47:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236695AbjG1Nr3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 28 Jul 2023 09:47:29 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4AE63C12
        for <io-uring@vger.kernel.org>; Fri, 28 Jul 2023 06:47:24 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id d9443c01a7336-1b89b0c73d7so3424675ad.1
        for <io-uring@vger.kernel.org>; Fri, 28 Jul 2023 06:47:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1690552044; x=1691156844;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cgNcbR6T8NX3tcjJ6jjDsLbCYa3dYfm0zSO+VVkmswU=;
        b=rb2BxvngG+N4IbRqIHHgdAnSDH+Oh9P6eWN6L9Tyor+5ZclI+8k2txGRN2AJ881y1z
         nLe8h79iaAq5wfEM0VoA3U9HY2g3olKeTDUt+g8qc3LyspvXuPA3J8AU3MZ5N3z19zmw
         h94DRaYVdciq908Da50GU6TnkMBIE+QjPACD1ih+OX8OwgKu6unzeG5XeTz1rYadJ+xk
         ue4xAvFXX5OrYib3F5y6lCqO61bB43zOzgPhl0tkOVqTPJO/0EN4FBtRuLWTzB5fQV0Y
         2j+Xgfw7q05p6gjXW5J06LEGcdI3s+ICjM0DzSo/aA2b501iXJXiG+DHt/QLTn2wH/6e
         V2Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690552044; x=1691156844;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=cgNcbR6T8NX3tcjJ6jjDsLbCYa3dYfm0zSO+VVkmswU=;
        b=dYAznbQBiFYyEyEKpcjCmEz2IOskTfRTWISnJGANiNWNDSiQCXovECDVoDZiV7rTix
         G1t4R2bbA8fVaDi2YBKacUet1wXFkfds/51dVQ6NU6L1iSz5LpjNCP0OZ2zn5DYCupTo
         0TCN1fLMlABRKRLMKniB6iQgRMFpK5cVe9ZqFrlE0koEjSEpO7spIs+bXdpYpLyZyjH4
         VTEkXNHTtnrxL1giFPnBGWa2YeZ7UFU7leTkKhPJX4V8ppHXwWt4n0rgYj7IKJuarwot
         kSYppDLNs5L30pzW1UaiRrutDsOXaQEd49DtYzno3x2jY+9Ay6hAmSr9n0AnYjYSe3pW
         9tiw==
X-Gm-Message-State: ABy/qLZnf0sOJx42SuHwYC91Obkmmydlpmmm1pi048j/X4klIwzfXYj6
        8x1iwlODDrxlPu7AiH5vr4doXw==
X-Google-Smtp-Source: APBJJlFoNYOvunV1aK3RAFBUCp/nQA6ny5N2wuMRo9T50aEntwHuWsTiIf8QRJQhfeeMoW+FcykGfA==
X-Received: by 2002:a17:903:1c7:b0:1bb:9e6e:a9f3 with SMTP id e7-20020a17090301c700b001bb9e6ea9f3mr2918236plh.4.1690552044169;
        Fri, 28 Jul 2023 06:47:24 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id c6-20020a170902c1c600b001bb24cb9a61sm3590828plc.265.2023.07.28.06.47.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Jul 2023 06:47:23 -0700 (PDT)
Message-ID: <98cbe74e-91d8-9611-5ac0-b344b4365e79@kernel.dk>
Date:   Fri, 28 Jul 2023 07:47:22 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Content-Language: en-US
To:     "Darrick J . Wong" <djwong@kernel.org>
Cc:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL v2] Improve iomap async dio performance
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

Here's the pull request for improving async dio performance with
iomap. Contains a few generic cleanups as well, but the meat of it
is described in the tagged commit message below.

Please pull for 6.6!


The following changes since commit ccff6d117d8dc8d8d86e8695a75e5f8b01e573bf:

  Merge tag 'perf-tools-fixes-for-v6.5-1-2023-07-18' of git://git.kernel.org/pub/scm/linux/kernel/git/perf/perf-tools (2023-07-18 14:51:29 -0700)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/xfs-async-dio.6-2023-07-28

for you to fetch changes up to 634aae6c33338308f92eb137b0ea4833457c2ce7:

  iomap: support IOCB_DIO_CALLER_COMP (2023-07-25 07:47:20 -0600)

----------------------------------------------------------------
Improve iomap/xfs async dio write performance

iomap always punts async dio write completions to a workqueue, which has
a cost in terms of efficiency (now you need an unrelated worker to
process it) and latency (now you're bouncing a completion through an
async worker, which is a classic slowdown scenario).

io_uring handles IRQ completions via task_work, and for writes that
don't need to do extra IO at completion time, we can safely complete
them inline from that. This patchset adds IOCB_DIO_CALLER_COMP, which an
IO issuer can set to inform the completion side that any extra work that
needs doing for that completion can be punted to a safe task context.

The iomap dio completion will happen in hard/soft irq context, and we
need a saner context to process these completions. IOCB_DIO_CALLER_COMP
is added, which can be set in a struct kiocb->ki_flags by the issuer. If
the completion side of the iocb handling understands this flag, it can
choose to set a kiocb->dio_complete() handler and just call ki_complete
from IRQ context. The issuer must then ensure that this callback is
processed from a task. io_uring punts IRQ completions to task_work
already, so it's trivial wire it up to run more of the completion before
posting a CQE. This is good for up to a 37% improvement in
throughput/latency for low queue depth IO, patch 5 has the details.

If we need to do real work at completion time, iomap will clear the
IOMAP_DIO_CALLER_COMP flag.

This work came about when Andres tested low queue depth dio writes for
postgres and compared it to doing sync dio writes, showing that the
async processing slows us down a lot.

----------------------------------------------------------------
Jens Axboe (8):
      iomap: cleanup up iomap_dio_bio_end_io()
      iomap: use an unsigned type for IOMAP_DIO_* defines
      iomap: treat a write through cache the same as FUA
      iomap: only set iocb->private for polled bio
      iomap: add IOMAP_DIO_INLINE_COMP
      fs: add IOCB flags related to passing back dio completions
      io_uring/rw: add write support for IOCB_DIO_CALLER_COMP
      iomap: support IOCB_DIO_CALLER_COMP

 fs/iomap/direct-io.c | 163 ++++++++++++++++++++++++++++++++++++++-------------
 include/linux/fs.h   |  35 ++++++++++-
 io_uring/rw.c        |  27 ++++++++-
 3 files changed, 180 insertions(+), 45 deletions(-)

-- 
Jens Axboe

