Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1321E60337B
	for <lists+io-uring@lfdr.de>; Tue, 18 Oct 2022 21:52:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbiJRTwk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 18 Oct 2022 15:52:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229569AbiJRTwj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 18 Oct 2022 15:52:39 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 016C58708D;
        Tue, 18 Oct 2022 12:52:29 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id w18so34892789ejq.11;
        Tue, 18 Oct 2022 12:52:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=hesUVV8oLfqzPuwApMzbxfjgf/NGsaqcxurto5C/xyU=;
        b=oM8BEinm+7PCkXNou9ynjD3DYOjnpAZWd+QtEjiMIqOdlLzTTjSroUSFEkrnooNnXh
         yqjfn7/KUT/pZtJMR8+L1ufMHm9DU1Sz+UqSkzUFc7rHOUniprjb1wnuyX2ETTaJk4WZ
         JehnGyA30CL+/NV0eXv/5cgm/p3dMhi3Kysan5z+MSOcIC72W+a6Vo8g1o9nN58o+9gT
         BWLofMj6t1nrd9SeN4cGw3FEcAkZggENHBsOC21hXear5uVQiSKuu5CMy6lMJvALS+NJ
         keGsRkUy4/TLueAoqywZiV2CnUGgEtXMzOY91Zqnsgkq/YsS87uzkA+GqokWeQ0KJ/3a
         EeSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hesUVV8oLfqzPuwApMzbxfjgf/NGsaqcxurto5C/xyU=;
        b=PUk6dGZ2YDRCWmEvRNouCKcpBYS0GFeC510cyXdutBE/G9XH52TwC2CYdZMKr49kM/
         hP49YuuXmpHOO0zYYO4HIzd2HRUrQK7E3R5d2125rSs/qBqvHHxrS5IhCg0pH5JXj7hq
         JK5QPM/HbpOHzYcvX25Wph4WFc+s39suVOBW6288oqxoth0dgR6GpetB9x5VaKa0gKHI
         DWyXcdRJHryJTJq3eZ3nZDaJOOIiJ9a6b4kitIdVqcu01sKmbeOWLPwZUxoGWbdhDYkf
         PP7S+v/UtZ2OXLZGUQyJRk7t+p/xDkFN+jpcbjuOr/VbYDXHmZamcT7ekJ5SZaCiQeUk
         4oNw==
X-Gm-Message-State: ACrzQf0v8F73TE/1joIed7tjFVA1HJJaKOO3BxnU8Oo2UGUhxNWzzJmc
        VkzF0VcTTXlgHWGts48kt086bRyCKuM=
X-Google-Smtp-Source: AMsMyM5nab1s6kIkntr5BPRagGigN3Ty650kK/BaOevBAGj04Qt9pnYNWFwwo9AvQmql0n2WFbncxQ==
X-Received: by 2002:a17:907:7287:b0:78d:8f26:5911 with SMTP id dt7-20020a170907728700b0078d8f265911mr3584838ejc.463.1666122723980;
        Tue, 18 Oct 2022 12:52:03 -0700 (PDT)
Received: from 127.0.0.1localhost (94.197.72.2.threembb.co.uk. [94.197.72.2])
        by smtp.gmail.com with ESMTPSA id r1-20020a1709061ba100b0072a881b21d8sm7945858ejg.119.2022.10.18.12.52.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Oct 2022 12:52:03 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [RFC for-next v2 0/4] enable pcpu bio caching for IRQ I/O
Date:   Tue, 18 Oct 2022 20:50:54 +0100
Message-Id: <cover.1666122465.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This series implements bio pcpu caching for normal / IRQ-driven I/O
extending REQ_ALLOC_CACHE currently limited to iopoll. The allocation side
still only works from non-irq context, which is the reason it's not enabled
by default, but turning it on for other users (e.g. filesystems) is
as a matter of passing a flag.

t/io_uring with an Optane SSD setup showed +7% for batches of 32 requests
and +4.3% for batches of 8.

IRQ, 128/32/32, cache off
IOPS=59.08M, BW=28.84GiB/s, IOS/call=31/31
IOPS=59.30M, BW=28.96GiB/s, IOS/call=32/32
IOPS=59.97M, BW=29.28GiB/s, IOS/call=31/31
IOPS=59.92M, BW=29.26GiB/s, IOS/call=32/32
IOPS=59.81M, BW=29.20GiB/s, IOS/call=32/31

IRQ, 128/32/32, cache on
IOPS=64.05M, BW=31.27GiB/s, IOS/call=32/31
IOPS=64.22M, BW=31.36GiB/s, IOS/call=32/32
IOPS=64.04M, BW=31.27GiB/s, IOS/call=31/31
IOPS=63.16M, BW=30.84GiB/s, IOS/call=32/32

IRQ, 32/8/8, cache off
IOPS=50.60M, BW=24.71GiB/s, IOS/call=7/8
IOPS=50.22M, BW=24.52GiB/s, IOS/call=8/7
IOPS=49.54M, BW=24.19GiB/s, IOS/call=8/8
IOPS=50.07M, BW=24.45GiB/s, IOS/call=7/7
IOPS=50.46M, BW=24.64GiB/s, IOS/call=8/8

IRQ, 32/8/8, cache on
IOPS=51.39M, BW=25.09GiB/s, IOS/call=8/7
IOPS=52.52M, BW=25.64GiB/s, IOS/call=7/8
IOPS=52.57M, BW=25.67GiB/s, IOS/call=8/8
IOPS=52.58M, BW=25.67GiB/s, IOS/call=8/7
IOPS=52.61M, BW=25.69GiB/s, IOS/call=8/8

The main part is in patch 3. Would be great to take patch 1 separately
for 6.1 for extra safety.

v2: fix botched splicing threshold checks

Pavel Begunkov (4):
  bio: safeguard REQ_ALLOC_CACHE bio put
  bio: split pcpu cache part of bio_put into a helper
  block/bio: add pcpu caching for non-polling bio_put
  io_uring/rw: enable bio caches for IRQ rw

 block/bio.c   | 94 ++++++++++++++++++++++++++++++++++++++++-----------
 io_uring/rw.c |  3 +-
 2 files changed, 76 insertions(+), 21 deletions(-)

-- 
2.38.0

