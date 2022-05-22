Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6FE2530621
	for <lists+io-uring@lfdr.de>; Sun, 22 May 2022 23:26:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232512AbiEVV02 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 22 May 2022 17:26:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351614AbiEVV0G (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 22 May 2022 17:26:06 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 568569584
        for <io-uring@vger.kernel.org>; Sun, 22 May 2022 14:26:04 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id h186so12106147pgc.3
        for <io-uring@vger.kernel.org>; Sun, 22 May 2022 14:26:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to:cc
         :content-language:content-transfer-encoding;
        bh=t27NbU/sEvE5Ri3vCjzv2EKdw2O05IpZ7eJRF2bYoK4=;
        b=RkEA05HftNb+833WE+hkgAgBfYDRUxUfmQevrXLQAVTwdyx099x+9eo6GxUIjiGZS7
         /mCGbxxosldwH/QywT3xBj12LCaPxcFrb1mukFqd2iJNsSOKOg3WCq6BRCEHz1D2T6dY
         edJmz0uPynehCT+Kn6WXisEcT9pzHn5xDGCHlCNx1zv9cx2gUfbO9lCKeBWsjbDShCiD
         QrHBVP0dfQQWw4bw9q3u+yOymWVf/NdiccFJw7kgvkouYQ1jDFaUSgca33KpZzaqc+lN
         Km9mJGecJr0TFtOqPN7rKzrB+tMRXzu1avMLPKkgzOkHS7Gn8Re7kbYntxO/PrVx3hIi
         0AyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from
         :subject:to:cc:content-language:content-transfer-encoding;
        bh=t27NbU/sEvE5Ri3vCjzv2EKdw2O05IpZ7eJRF2bYoK4=;
        b=I4qDHJWfc8ah2SGnCZ+UK13NfqZrb4rgDhrzheUXiEHWvvwVpFuQEi3sGwCQr39UVv
         hgYoAtXs4n/bVfynkxWb3gpUqTStrRXQL+RkBR8F9hXpv4R85l7HyUi6zpwm0+5lUizY
         jrz63TlBv+mH3GXzhiylROfPVINAlpBkI7OURZZLjd9qiv4sRiZvpQFlcwqpg7f7ZiVK
         8opoR3ghURi7ByuZI9cW4Mx5eonKcw2kYba0ljcE2M4WOtFdhTQzD0abgTRPDyNjGegy
         fkI+sAcIbcULnVts+znr5Fwz2gMUUyP2DxIFbXH9xap+4VK8SBUNeFv6R+NSWTdOrgyw
         B76g==
X-Gm-Message-State: AOAM530BTJRzaTA4IYlf03l8BWM+csDUFap6etv+bQbYYT6DamYI3UmU
        fTNFY4HeECAfO1lGRGOS/ZG0WoYcRldoiw==
X-Google-Smtp-Source: ABdhPJzQFCH+sLZxxfeHLmxK2BD6Qv+DIbuzmqy2Hfd8NvSxtQHTLt2PtzL71WQP/jFJCUfzXbJ66A==
X-Received: by 2002:a05:6a00:1a53:b0:510:a045:b92e with SMTP id h19-20020a056a001a5300b00510a045b92emr20451649pfv.64.1653254763797;
        Sun, 22 May 2022 14:26:03 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d10-20020a170902f14a00b00161955fe0d5sm2794219plb.274.2022.05.22.14.26.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 May 2022 14:26:03 -0700 (PDT)
Message-ID: <d94a4e55-c4f2-73d8-9e2c-e55ae8436622@kernel.dk>
Date:   Sun, 22 May 2022 15:26:02 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring xattr support
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Linus,

On top of the core io_uring changes, this pull request includes support
for the xattr variants.

Please pull!


The following changes since commit 155bc9505dbd6613585abbf0be6466f1c21536c4:

  io_uring: return an error when cqe is dropped (2022-04-24 18:18:18 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux-block.git tags/for-5.19/io_uring-xattr-2022-05-22

for you to fetch changes up to 4ffaa94b9c047fe0e82b1f271554f31f0e2e2867:

  io_uring: cleanup error-handling around io_req_complete (2022-04-24 18:29:33 -0600)

----------------------------------------------------------------
for-5.19/io_uring-xattr-2022-05-22

----------------------------------------------------------------
Jens Axboe (1):
      io_uring: fix trace for reduced sqe padding

Kanchan Joshi (1):
      io_uring: cleanup error-handling around io_req_complete

Stefan Roesch (4):
      fs: split off setxattr_copy and do_setxattr function from setxattr
      fs: split off do_getxattr from getxattr
      io_uring: add fsetxattr and setxattr support
      io_uring: add fgetxattr and getxattr support

 fs/internal.h                   |  29 ++++
 fs/io_uring.c                   | 322 ++++++++++++++++++++++++++++++++++++----
 fs/xattr.c                      | 143 ++++++++++++------
 include/trace/events/io_uring.h |   9 +-
 include/uapi/linux/io_uring.h   |   8 +-
 5 files changed, 434 insertions(+), 77 deletions(-)

-- 
Jens Axboe

