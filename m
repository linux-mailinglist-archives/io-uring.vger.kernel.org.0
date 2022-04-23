Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 550FB50C67F
	for <lists+io-uring@lfdr.de>; Sat, 23 Apr 2022 04:19:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231166AbiDWCVF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 22 Apr 2022 22:21:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbiDWCVE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 22 Apr 2022 22:21:04 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 005E9B85F
        for <io-uring@vger.kernel.org>; Fri, 22 Apr 2022 19:18:06 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id b15so9615765pfm.5
        for <io-uring@vger.kernel.org>; Fri, 22 Apr 2022 19:18:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to:cc
         :content-language:content-transfer-encoding;
        bh=Qgc0Br8s2UytXCOJ9SexOSyakzqoJLMHQHCZqaN8sl8=;
        b=ORk6NDM3e1lblFz5O5EPd87WpnKA7OllfNURJTJ9X6Bv3zMTx9qg3ZtMvJwMfvrLG3
         7Qg8AFJVsR/Z4698ulj6fR4iTzgSuHA0RdohllYnwNFJ2BreXb/m116nIGcbsGbC9mkd
         lsitN5es1McAQNLlJRW7Tbd+wS4rS016XfyhulzFw0kn6VBaV8CRTgV+b9Wf5vbI+Xrb
         Ng/cbc03q+28qTf2t3ky0P97YtWuimFoKYMiZOaLcUCf4o/hXL10ntmXIMN/ld+WU/ui
         wxQ1dtlqt5X/RXsp7AcXnTgGVBUWefX8cKZK7M3OGEGAdLwBl0s3D6ihRA2JqSltLo4g
         q05Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from
         :subject:to:cc:content-language:content-transfer-encoding;
        bh=Qgc0Br8s2UytXCOJ9SexOSyakzqoJLMHQHCZqaN8sl8=;
        b=fg+FlM5MATZb+gNTJ5Vzg5EkS2SNRcYS4ZJQJYkMrnNNSeCLoRsSDvlKse85M4QKy+
         RfYy++sRKpauNoTV/6V9AK9QU5XS9PU7Ygy3ZvRZAUua6qsijT6b0m/M9/3ZxtbWvgaM
         eFdG2201saY8LeOxlNtZzwPWn0ZMePfEHAn0dTPsLVVLG6iR8Ta+ANIz4iPJFF3S9mp7
         VzJWe1LnBLXxvu7rMZAMHnMFJA6NIDkcEzvy3ZMYsUw+KViV8wjDE3KGETQmnmr6EAzK
         W5Kqda+3F0IZYWRd9QmxuoUWsF/APBn5Zlb8ggyFPG5Pju679Lx61eNwXHncAeyFaXJN
         Py9w==
X-Gm-Message-State: AOAM532Pte+HW+RNku8oKRpYfO+4IqDsgFSzNvqK/onjjVzHZ4zAUYQV
        ygTCge6c+mm0mQKrZdDXH5ZlbePXcFQUWtoS
X-Google-Smtp-Source: ABdhPJx9uANsT47/PoH9doFWjfaUSzni1gA9eJYljOdPYx5auxai/ylKHTiQGMxap6yHYeum9k7Yiw==
X-Received: by 2002:a63:2cc3:0:b0:39d:a9af:bc5b with SMTP id s186-20020a632cc3000000b0039da9afbc5bmr6423992pgs.3.1650680286262;
        Fri, 22 Apr 2022 19:18:06 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id a38-20020a056a001d2600b004f72acd4dadsm3899371pfx.81.2022.04.22.19.18.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Apr 2022 19:18:05 -0700 (PDT)
Message-ID: <db81323e-38e2-e0a9-08a5-6fb8f429e071@kernel.dk>
Date:   Fri, 22 Apr 2022 20:18:04 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 5.18-rc4
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Linus,

Just two small fixes - one fixing a potential leak for the iovec for
larger requests added in this cycle, and one fixing a theoretical leak
with CQE_SKIP and IOPOLL.

Please pull!


The following changes since commit 701521403cfb228536b3947035c8a6eca40d8e58:

  io_uring: abort file assignment prior to assigning creds (2022-04-14 20:23:40 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux-block.git tags/io_uring-5.18-2022-04-22

for you to fetch changes up to c0713540f6d55c53dca65baaead55a5a8b20552d:

  io_uring: fix leaks on IOPOLL and CQE_SKIP (2022-04-17 06:54:11 -0600)

----------------------------------------------------------------
io_uring-5.18-2022-04-22

----------------------------------------------------------------
Jens Axboe (1):
      io_uring: free iovec if file assignment fails

Pavel Begunkov (1):
      io_uring: fix leaks on IOPOLL and CQE_SKIP

 fs/io_uring.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

-- 
Jens Axboe

