Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D3755B3DE0
	for <lists+io-uring@lfdr.de>; Fri,  9 Sep 2022 19:24:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230324AbiIIRYc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 9 Sep 2022 13:24:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbiIIRYb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 9 Sep 2022 13:24:31 -0400
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6021295
        for <io-uring@vger.kernel.org>; Fri,  9 Sep 2022 10:24:22 -0700 (PDT)
Received: by mail-il1-x133.google.com with SMTP id l16so1163063ilj.2
        for <io-uring@vger.kernel.org>; Fri, 09 Sep 2022 10:24:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date;
        bh=QPl2gznPow37Cr4NNQSMzlrGiSf35LGDmI0/fT/qB/Q=;
        b=UOMXHEAo1NEZksZqWa09VzD6Hn3uEF7yag50j7vroqKhJG4lxgdhKCdwiQy/N8KHR9
         bDwJIPHPocap4NZygecrRatCIqGIW6OlJEvM2Hy3Dhygg0kezO0b2PP+92k3d0hBNges
         S2IdqW5kbdEvvfhTOzgSTODjj521Io8wwY34nKHqO5QxNdkfMANErC2iHd2/bcJuZjOb
         FsH45VtpfFQmmKCp1Jsd5EB2WnYgj3zKgdxVqZcRtafHPWuEudw1Burr8WomaZ8idVBg
         9737MyfRYm6OfbDVwpLA+c9Ft6ECfaLEozXpwYQ8MxdGfcEu3D/SjonBS5yvf8MJCMMy
         S+Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date;
        bh=QPl2gznPow37Cr4NNQSMzlrGiSf35LGDmI0/fT/qB/Q=;
        b=5eljFFb7Sojg3FhVXpDJFFl64PTKozTtEwP1UIHSOx7IN5vt/d7Nl2v4+I136V9hQn
         1W1s20lx7XzGL4pDT72uWnWd+lK5mbwLWxu+Jep0qb2YuZ5EuMTP0E9eGa4L1E0sFrND
         r7qpi6YGrVClO0N9teqSRa3Z9QhcsSLsSXPtFh7ci1yitxR4ofjHcK7+4/tB9H6qvmiS
         oieEmFvHdl2yBLofECq6W+g3LXTvtDSK0F5kIs+DOztgyUDOtbBJ2iqmf4teQlQRBCi8
         tx5Q+QG7hnBZ+SR5N/LDakVHP3xLeP7JRE4l8bqdaz6k6Xc1T9z19LArv6M4FWERj2YF
         YdcQ==
X-Gm-Message-State: ACgBeo1D11h/Pk1VkUNuFcmLzd90AfvHkp/UgN81B76VdoLzWHFmVaSn
        h30g2taN1MmNU0FqfweHaS2RnghRLrFOSw==
X-Google-Smtp-Source: AA6agR4w1unFV0LdSrAeQbfyz5x92jKzt8Jm5yAynJIZGU7jG9RtMv53sJJhMG+T/l9NCsoAUghVug==
X-Received: by 2002:a05:6e02:1c83:b0:2f1:2bd7:302d with SMTP id w3-20020a056e021c8300b002f12bd7302dmr5046269ill.190.1662744261707;
        Fri, 09 Sep 2022 10:24:21 -0700 (PDT)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id l13-20020a056e021c0d00b002dd0bfd2467sm359600ilh.11.2022.09.09.10.24.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Sep 2022 10:24:20 -0700 (PDT)
Message-ID: <9f7bc0ca-70c5-b4c1-5f70-f64de412e496@kernel.dk>
Date:   Fri, 9 Sep 2022 11:24:19 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Content-Language: en-US
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 6.0-rc5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Linus,

A set of fixes that should go into the 6.0 release:

- Removed function that became unused after last weeks merge (Jiapeng)

- Two small fixes for kbuf recycling (Pavel)

- Include address copy for zc send for POLLFIRST (Pavel)

- Fix for short IO handling in the normal read/write path (Pavel)

Please pull!


The following changes since commit 916d72c10a4ca80ea51f1421e774cb765b53f28f:

  selftests/net: return back io_uring zc send tests (2022-09-01 09:13:33 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux-block.git tags/io_uring-6.0-2022-09-09

for you to fetch changes up to 4d9cb92ca41dd8e905a4569ceba4716c2f39c75a:

  io_uring/rw: fix short rw error handling (2022-09-09 08:57:57 -0600)

----------------------------------------------------------------
io_uring-6.0-2022-09-09

----------------------------------------------------------------
Jiapeng Chong (1):
      io_uring/notif: Remove the unused function io_notif_complete()

Pavel Begunkov (4):
      io_uring/kbuf: fix not advancing READV kbuf ring
      io_uring: recycle kbuf recycle on tw requeue
      io_uring/net: copy addr for zc on POLL_FIRST
      io_uring/rw: fix short rw error handling

 io_uring/io_uring.c |  1 +
 io_uring/kbuf.h     |  8 ++++++--
 io_uring/net.c      |  7 ++++---
 io_uring/notif.c    |  8 --------
 io_uring/rw.c       | 30 ++++++++++++++++++------------
 5 files changed, 29 insertions(+), 25 deletions(-)

-- 
Jens Axboe
