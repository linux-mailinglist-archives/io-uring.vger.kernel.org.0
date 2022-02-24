Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFD164C33C2
	for <lists+io-uring@lfdr.de>; Thu, 24 Feb 2022 18:31:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231855AbiBXRa4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Feb 2022 12:30:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231804AbiBXRaz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Feb 2022 12:30:55 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05C94186B98
        for <io-uring@vger.kernel.org>; Thu, 24 Feb 2022 09:30:22 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id ay3so2382940plb.1
        for <io-uring@vger.kernel.org>; Thu, 24 Feb 2022 09:30:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to:cc
         :content-language:content-transfer-encoding;
        bh=mYPybRp4YGta2PfW8c39qnoYlnREeLBQEuizvhZzqM0=;
        b=fH1Ft6hP/dIsUtGvwNfbUEmYzuLMkRZdeGlyH+TTg5GiJi+3Sqtq5Ox24M2y9KL9Du
         r8otxNFpINGIXMrYHziGIUjzsFuYcPNG2UtTpW971gAL4Ieeq3qLa3kwgxHB73sWk4V/
         yT1aHCsQ4UT5aYUWv1o4YkeKSxW8nCoEW7vfuB6zgEDE4e58RrwEC2VgBzOwku/le3CL
         uvf5u9SKdESJ4KkL7BiOBQ0pEc0c0AkSsmKhEfo+MpDX0BBD02oljPSNfcka4G6Xt/WU
         eld0wRBWb4xFT0UC4vDiayatnosatGSGfnI+LLNct63eQwK/nd3KF/IoYN0ZkVK/V5kS
         Vgug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from
         :subject:to:cc:content-language:content-transfer-encoding;
        bh=mYPybRp4YGta2PfW8c39qnoYlnREeLBQEuizvhZzqM0=;
        b=rlLYA3oguhWJqHzrU91w3yCtuHAjum0zNyBB+X+ooUfEdpbrOIb5upNAxjMRWT2453
         hW7WVX1JUokV9m8n/mPXfq3DANqufIyOpj/d8xYXZKQjugIHO+B+O4eldwSecqncKMHZ
         19QukgKFQo0fUPdJGJi2hlLPYH5eupv4PnCjSTfLcxb2bCOXwCklEdEEUknmnfjD8UYn
         iKttWStA1/cOQMsHS3u5lfmf7Y5Kn3HYRaB67hHw9/2RDySeS4vMtjw02p1nfd22sWUE
         FqijJ3Fe6LsA9LZaJgB7+1dbCdp3/nxIuyKIc87y+TlFFrCB6CF/vmCxQRA8lR8MSb8C
         Wc8A==
X-Gm-Message-State: AOAM532kmlD5yuJs9eg5P/1HOHqkTU8WBx1JAuKs0bWl/XgcMCVCG7w8
        7GQX/cyXpzXumzQgWfU3ZHvBOEit/32wvg==
X-Google-Smtp-Source: ABdhPJw+wGnacS31uJIs8wpZuBJJ2v4swLBBZIwPIDFdpq0IJ112BOAgQQPHZybebWB8mhUdxfnF6Q==
X-Received: by 2002:a17:90a:2848:b0:1bc:2e67:7a2 with SMTP id p8-20020a17090a284800b001bc2e6707a2mr15444921pjf.188.1645723821404;
        Thu, 24 Feb 2022 09:30:21 -0800 (PST)
Received: from [192.168.4.157] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id u37-20020a056a0009a500b004e1414d69besm53113pfg.151.2022.02.24.09.30.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Feb 2022 09:30:20 -0800 (PST)
Message-ID: <16541e0b-e3ce-9e7f-4baa-20cd6e37db1b@kernel.dk>
Date:   Thu, 24 Feb 2022 10:30:19 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 5.17-rc6
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
Content-Language: en-US
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

A few minor fixes for 5.17-rc6:

- Add a conditional schedule point in io_add_buffers() (Eric)

- Fix for a quiesce speedup merged in this release (Dylan)

- Don't convert to jiffies for event timeout waiting, it's way too
  coarse when we accept a timespec as input (me)

Please pull!


The following changes since commit 0a3f1e0beacf6cc8ae5f846b0641c1df476e83d6:

  mm: io_uring: allow oom-killer from io_uring_setup (2022-02-07 08:44:01 -0700)

are available in the Git repository at:

  git://git.kernel.dk/linux-block.git tags/io_uring-5.17-2022-02-23

for you to fetch changes up to 80912cef18f16f8fe59d1fb9548d4364342be360:

  io_uring: disallow modification of rsrc_data during quiesce (2022-02-22 09:57:32 -0700)

----------------------------------------------------------------
io_uring-5.17-2022-02-23

----------------------------------------------------------------
Dylan Yudaken (1):
      io_uring: disallow modification of rsrc_data during quiesce

Eric Dumazet (1):
      io_uring: add a schedule point in io_add_buffers()

Jens Axboe (1):
      io_uring: don't convert to jiffies for waiting on timeouts

 fs/io_uring.c | 24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

-- 
Jens Axboe

