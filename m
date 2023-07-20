Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0625275B639
	for <lists+io-uring@lfdr.de>; Thu, 20 Jul 2023 20:13:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229457AbjGTSNS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Jul 2023 14:13:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbjGTSNR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Jul 2023 14:13:17 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C98D270B
        for <io-uring@vger.kernel.org>; Thu, 20 Jul 2023 11:13:15 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id e9e14a558f8ab-346434c7793so1615435ab.0
        for <io-uring@vger.kernel.org>; Thu, 20 Jul 2023 11:13:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689876794; x=1690481594;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=wDnuldrPQY1sBo1NQ+JA5EJ1TsjdpKNztmHiGvW2IJ0=;
        b=nqsWGuYOvEleFPb9LfMYLqcsfmSsYDEycZrspwlsOLwhLysC3smM/dQX3dBJzDKGDP
         Nc73q2QcIcRpcUBlC6QLEh1eVjLTfr8TsPNkDfT4GCyvH2dSEpR3ApF9SvDRiiwFEWTx
         VhRadKrGcLyYkn3FFyYZqbX9Wu2EbGCbkceGmuYPUuykNf0R5JoXoiy/QafqRZkaJQUl
         VgdEd/9eE4PshM6tx1E8OxhiAMLVW2bYjiMCHNswaSfGYxLW4qYureVFjJXzRgbUxRnt
         cj6yoyA0gXVq9HUBwxraY/h+FYJZTx0p532AxPzRR9o+7eJiS0HcTwq6r4trQildRGdd
         aiDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689876794; x=1690481594;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wDnuldrPQY1sBo1NQ+JA5EJ1TsjdpKNztmHiGvW2IJ0=;
        b=VsLq0AM+CUDaR0o6O2MEVjfqHhl/vubUndUTc/J6pPPavvnw9Q7O8H/Q8FDv1pVomu
         K/aOXtbxTfRDdWPH3wVXKfToWsoryisC+K31r8u4bsVsBuvVpuRVM1wX1RLd3Y2MGsfp
         mpjHy5vuv0c0ZvZeV9Sbvv4IuwoyCkr2T8oA0Vjq5L9TR25sg5LIILoMHHsBh7CNU6jh
         PwTPa5OfpzaW86V3Yp9GNOMVRkWDEWH5pH+a/8Hl6apom03uOqD21k5apQZb52G1Ctk6
         Wxp/KVbpP3TUj2I9WWMPyMSvm6OWTGqbauChGdKYhtrqS7dNDaaNaJKGc3Bb3L5te3Ea
         tCBg==
X-Gm-Message-State: ABy/qLa31aMOuAadn0yNUfV0uGvEOgCGvFeRtyZKw8ApafrHcDaSc+lD
        K4F26PUtroEmjmhOx0jnro8Re1HWp0uOogqN6CY=
X-Google-Smtp-Source: APBJJlGXGIaYG1XmNDAHF5zrdyJUzVPvSP9fE2oGyc3i33eCC6JQJOfO5kkuRmBuSH74Q4cxbRzLNA==
X-Received: by 2002:a92:d985:0:b0:345:ad39:ff3 with SMTP id r5-20020a92d985000000b00345ad390ff3mr3407484iln.3.1689876794452;
        Thu, 20 Jul 2023 11:13:14 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id v6-20020a92c6c6000000b003457e1daba8sm419171ilm.8.2023.07.20.11.13.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jul 2023 11:13:13 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-xfs@vger.kernel.org
Cc:     hch@lst.de, andres@anarazel.de, david@fromorbit.com
Subject: [PATCHSET v4 0/8] Improve async iomap DIO performance
Date:   Thu, 20 Jul 2023 12:13:02 -0600
Message-Id: <20230720181310.71589-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
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

Even for writes that should, in theory, be able to complete inline,
if we race with truncate or need to invalidate pages post completion,
we cannot sanely be in IRQ context as the locking types don't allow
for that.

io_uring handles IRQ completions via task_work, and for writes that
don't need to do extra IO at completion time, we can safely complete
them inline from that. This patchset adds IOCB_DEFER, which an IO
issuer can set to inform the completion side that any extra work that
needs doing for that completion can be punted to a safe task context.

The iomap dio completion will happen in hard/soft irq context, and we
need a saner context to process these completions. IOCB_DIO_DEFER is
added, which can be set in a struct kiocb->ki_flags by the issuer. If
the completion side of the iocb handling understands this flag, it can
choose to set a kiocb->dio_complete() handler and just call ki_complete
from IRQ context. The issuer must then ensure that this callback is
processed from a task. io_uring punts IRQ completions to task_work
already, so it's trivial wire it up to run more of the completion before
posting a CQE. This is good for up to a 37% improvement in
throughput/latency for low queue depth IO, patch 5 has the details.

If we need to do real work at completion time, iomap will clear the
IOMAP_DIO_DEFER_COMP flag.

This work came about when Andres tested low queue depth dio writes
for postgres and compared it to doing sync dio writes, showing that the
async processing slows us down a lot.

Dave, would appreciate your input on if the logic is right now in
terms of when we can inline complete when DEFER is set!

 fs/iomap/direct-io.c | 154 +++++++++++++++++++++++++++++++++----------
 include/linux/fs.h   |  34 +++++++++-
 io_uring/rw.c        |  27 +++++++-
 3 files changed, 176 insertions(+), 39 deletions(-)

Can also be found in a git branch here:

https://git.kernel.dk/cgit/linux/log/?h=xfs-async-dio.4

Since v3:
- Add two patches for polled IO. One that completes inline if it's set
  at completion time, and one that cleans up the iocb->private handling
  and adds comments as to why they are only relevant on polled IO.
- Rename IOMAP_DIO_WRITE_FUA to IOMAP_DIO_STABLE_WRITE in conjunction
  with treating fua && vwc the same as !vwc.
- Address review comments from Christoph
- Add comments and expand commit messages, where appropriate.

-- 
Jens Axboe


