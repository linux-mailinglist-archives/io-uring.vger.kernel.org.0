Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0EA275D01A
	for <lists+io-uring@lfdr.de>; Fri, 21 Jul 2023 18:54:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229835AbjGUQyp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Jul 2023 12:54:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229749AbjGUQyo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 Jul 2023 12:54:44 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9202BED
        for <io-uring@vger.kernel.org>; Fri, 21 Jul 2023 09:54:43 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id ca18e2360f4ac-77dcff76e35so31110039f.1
        for <io-uring@vger.kernel.org>; Fri, 21 Jul 2023 09:54:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689958483; x=1690563283;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zZRDJp/FqJfE7QxBtHaBeVAisNMjil7W3oTwvF2Ndrk=;
        b=eKOgEl/YKTKtko827TPuaGg22R+XL3D6i3u9uC9GQnZ4EFA56XkO/SHNNgDCvV+Nky
         CNjs5pDu2+f6IftJVpQen/s/kcElpbf0wEtxMwKce+wm8OATxRAEKXd7dyzmEJHqchUZ
         qkZXNqPMfW4rgt01oxHz1ThpEOAS3PknYTr9qs4Ltjy9N29t//EO/9/bNiUfIDy8YTj0
         lF8YyIAt8HFZZ43eNgCGi/4eCcVudWOjXjzAA9oot3a94U/LTp65MrsM3/kyffNb2SyL
         myelOcDnDmSP0ZbdG2xbek3rhlbCxyBHci2CzQzhqBCJmpR/vsh8LLF7ZSELwUi7MNe+
         Rjnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689958483; x=1690563283;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=zZRDJp/FqJfE7QxBtHaBeVAisNMjil7W3oTwvF2Ndrk=;
        b=RcIZxaWVCfGxLe2h00xTWf+TgLEdHMZG9x0ttpoW8SqKPnneFKFvppB/8BDvYgJvzw
         ErDdh8WbMnSiFiHLtAJsUl950PloWuFVaAsxyw+5tvuyxXqeKzGzZt6Xtz4XUvZ5uO3N
         OPouM47HpwV1rgQhnzT8Qh2iFdjz5vb8JeF/ESpjoeOgfXaADJddbOPFwSDtL1oSEODh
         r8PdMwO+2hvzyHWKu9HZ1vunVeyuTsETr4ymz6f3ULO4e8k9Lj5AHRxGTbLqz/HfhUe4
         p2lV5/YjZS3GWgfCr7b8bQYxGyifbqfBnw9dKzLXVU6X4YlEHEvz0iPoZ41clW5Jd3t5
         J5lA==
X-Gm-Message-State: ABy/qLaoL8kiIi9hJAkhyBJMuCm7qN3uMlN9GW4lLZQT84hu6G3xvwOE
        457C+WewOgfCs6MOdHVig4LlqQ==
X-Google-Smtp-Source: APBJJlHZ81m/+czPlp3zDVMX65ne5tg/gfgcLpv182ICVqbVBaujGAqCt8HiaN+nvRn5KrXl/Ed4hw==
X-Received: by 2002:a92:908:0:b0:345:e438:7381 with SMTP id y8-20020a920908000000b00345e4387381mr1916433ilg.2.1689958482957;
        Fri, 21 Jul 2023 09:54:42 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id v5-20020a92ab05000000b00348a5e95d47sm1084632ilh.14.2023.07.21.09.54.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Jul 2023 09:54:42 -0700 (PDT)
Message-ID: <647e79f4-ddaa-7003-6e00-f31e11535082@kernel.dk>
Date:   Fri, 21 Jul 2023 10:54:41 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Content-Language: en-US
To:     "Darrick J . Wong" <djwong@kernel.org>
Cc:     io-uring <io-uring@vger.kernel.org>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] Improve iomap async dio performance
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
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

Here's the pull request for improving async dio performance with
iomap. Contains a few generic cleanups as well, but the meat of it
is described in the tagged commit message below.

Please pull for 6.6!


The following changes since commit ccff6d117d8dc8d8d86e8695a75e5f8b01e573bf:

  Merge tag 'perf-tools-fixes-for-v6.5-1-2023-07-18' of git://git.kernel.org/pub/scm/linux/kernel/git/perf/perf-tools (2023-07-18 14:51:29 -0700)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/xfs-async-dio

for you to fetch changes up to 901a0c0e4248aa7e3ab4dce9a8c67c47215e6ccc:

  iomap: use an unsigned type for IOMAP_DIO_* defines (2023-07-21 10:34:42 -0600)

----------------------------------------------------------------
iomap always punts async dio write completions to a workqueue, which has
a cost in terms of efficiency (now you need an unrelated worker to
process it) and latency (now you're bouncing a completion through an
async worker, which is a classic slowdown scenario).

Even for writes that should, in theory, be able to complete inline, if
we race with truncate or need to invalidate pages post completion, we
cannot sanely be in IRQ context as the locking types don't allow for
that.

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
Jens Axboe (9):
      iomap: cleanup up iomap_dio_bio_end_io()
      iomap: add IOMAP_DIO_INLINE_COMP
      iomap: treat a write through cache the same as FUA
      iomap: completed polled IO inline
      iomap: only set iocb->private for polled bio
      fs: add IOCB flags related to passing back dio completions
      io_uring/rw: add write support for IOCB_DIO_CALLER_COMP
      iomap: support IOCB_DIO_CALLER_COMP
      iomap: use an unsigned type for IOMAP_DIO_* defines

 fs/iomap/direct-io.c | 166 +++++++++++++++++++++++++++++++++++++++------------
 include/linux/fs.h   |  35 ++++++++++-
 io_uring/rw.c        |  26 +++++++-
 3 files changed, 183 insertions(+), 44 deletions(-)

-- 
Jens Axboe

