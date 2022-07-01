Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06EF35636F3
	for <lists+io-uring@lfdr.de>; Fri,  1 Jul 2022 17:32:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231639AbiGAPcC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 1 Jul 2022 11:32:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231676AbiGAPcA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 1 Jul 2022 11:32:00 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D9273337B
        for <io-uring@vger.kernel.org>; Fri,  1 Jul 2022 08:31:58 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id w1-20020a17090a6b8100b001ef26ab992bso3075546pjj.0
        for <io-uring@vger.kernel.org>; Fri, 01 Jul 2022 08:31:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc:from
         :subject:content-transfer-encoding;
        bh=7DyKYSc3qR+nt+TD1q78AJjyzgAFHcJ9b6JCSi17SEI=;
        b=PkPjlrjDsmbjyZgL3P4W4+1LlLHkOS4RfNLUyYftFTgyB8k1afwKVlxsoNxW3cKfL5
         w+WDOEgmRWhtOKzjs15WcKC2iNOIaVRYjoaef8A/dk1evrfC8rnax6OALTBU1Ee1FZZO
         mjSB9DXyCnihPNh5vDpMA14xJomzwtMKMdSbt4TE0SVTS+3lYF9QeAzykVHMaM0R2iw2
         Km5Wvx9ImguhoLnFzVXIYDVsOK9Yj+G3BIaZ5uAVoASnNkQVX1yIC5+4uVLid2gDHx/9
         3h4aHSQkxIwsY2WIovuRi5CxRUmqF6xFwEWfQHxa0RFEf2wUEKQ0/i0dQM99X+d32+kU
         tIKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:from:subject:content-transfer-encoding;
        bh=7DyKYSc3qR+nt+TD1q78AJjyzgAFHcJ9b6JCSi17SEI=;
        b=hq1SLanrrBJzxy5KgdO6tajWoFDQnVK7iO1x2w2bRuo+a8Uods78OcQgACLykOrh0K
         YkHwmrn8rxIVUQDK8oiZAHiuGtMmOKKCgo9GZPlTCQKE7uX6n/KD5SBEnbEqAZWWQVqF
         MIlS+z9IUW6eFlCJPHwggNDSjDy7n5HinJ8EQJJSiaeY5gEdIagoptZcix3vYFQajAXz
         YdUr9FCFtBDb7f+U953KNbkcbf1/K+AQkNbtG9cTInRi4tk38DVP7DSKp3z6EhK2XLU7
         IaZBBZAZ3QhHiSAI96ADNwxnv6brV11BC0VgQ6VG0W1usUufx5J0e0rdUS2S+HYWPgsK
         ZjxQ==
X-Gm-Message-State: AJIora9mHw5/OvRncK+e1y1nTq/2OIIbn/fCiq76vSIA3rtdH0/HXQ/4
        rZ98UvLBpif4P/hNVcjAJPKxbvYHuvLm7Q==
X-Google-Smtp-Source: AGRyM1vto1Zdqj1O0d5jt63mNd1iNA0GMjqV0faVG3mXR7a8re4preoqiH4Kx+l4+ouSYqaSau0CoA==
X-Received: by 2002:a17:90b:4d07:b0:1ef:521c:f051 with SMTP id mw7-20020a17090b4d0700b001ef521cf051mr5708039pjb.164.1656689517931;
        Fri, 01 Jul 2022 08:31:57 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id r11-20020a17090aa08b00b001e33e264fd6sm6688439pjp.40.2022.07.01.08.31.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Jul 2022 08:31:57 -0700 (PDT)
Message-ID: <4cfbd928-95d2-f183-5d6e-2e514d85d0f0@kernel.dk>
Date:   Fri, 1 Jul 2022 09:31:56 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Content-Language: en-US
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 5.19-rc5
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

Two minor tweaks:

- While we still can, adjust the send/recv based flags to be in ->ioprio
  rather than in ->addr2. This is consistent with eg accept, and also
  doesn't waste a full 64-bit field for flags (Pavel).

- 5.18-stable fix for re-importing provided buffers. Not much real world
  relevance here as it'll only impact non-pollable files gone async,
  which is more of a practical test case rather than something that is
  used in the wild (Dylan).

Please pull!


The following changes since commit 386e4fb6962b9f248a80f8870aea0870ca603e89:

  io_uring: use original request task for inflight tracking (2022-06-23 11:06:43 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux-block.git tags/io_uring-5.19-2022-07-01

for you to fetch changes up to 09007af2b627f0f195c6c53c4829b285cc3990ec:

  io_uring: fix provided buffer import (2022-06-30 11:34:41 -0600)

----------------------------------------------------------------
io_uring-5.19-2022-07-01

----------------------------------------------------------------
Dylan Yudaken (1):
      io_uring: fix provided buffer import

Pavel Begunkov (1):
      io_uring: keep sendrecv flags in ioprio

 fs/io_uring.c                 | 19 ++++++++++++-------
 include/uapi/linux/io_uring.h |  2 +-
 2 files changed, 13 insertions(+), 8 deletions(-)

-- 
Jens Axboe

