Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FE78639294
	for <lists+io-uring@lfdr.de>; Sat, 26 Nov 2022 01:19:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbiKZATF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 25 Nov 2022 19:19:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229806AbiKZATE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 25 Nov 2022 19:19:04 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9797050D68
        for <io-uring@vger.kernel.org>; Fri, 25 Nov 2022 16:19:03 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id q1so5075697pgl.11
        for <io-uring@vger.kernel.org>; Fri, 25 Nov 2022 16:19:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N1eQSYVNV3pfRcEbf8eH4ijRHpRw/mATkRe2Z24wQcA=;
        b=V2oC6za6UJibrIl58Bx8lb87tTVDC0V7WctE8Je1Z9ImkM7rNN6PUh+ZMuFn7GRzTC
         8xkuzuyQ+TYwM9l3Do7pHi6stcU1mfg70GaUKEfmdkUd2k9dAx5x/v7N8uKayTtuu4XJ
         NRc8QkTwvPlOIr9soEj2nE88YNW6BI59TgfH53JUSKw7NGsSW0laUt05I1lGIe1XW41j
         Q2So/Mj2IvHYyLOrPq0XqmKYQvQkwerwhAesVMuj7UsXYYuj0fGRnn4DMcBfvjWFtmrk
         TtLXvRdUvYS0qS/AKhMA/IZ/e22PmjVVg1sC0Gnc4wNWrBtg7dF3DJNH8Njcvqy+DmSt
         aIaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=N1eQSYVNV3pfRcEbf8eH4ijRHpRw/mATkRe2Z24wQcA=;
        b=yXbMncpo38c/1SmeKUK2cHHaTbQNA6ALgyEE5Qld8UHMXQmbNZTHMMJzbFZM8UPeJS
         6J6UAKvI9yJOkpLBmWt3BBvVD0lcytAI3TpVSf5DPKO5dnU8mTwo55HQ8opW9K9BJcpd
         c3KVFNFUeSKRZhh2p9i6CNFq2ZzjL5C7YRR84vlXDMt08+Te2hSLtOtx/A7phBrFP1Zp
         hStXQp1V1H9diBsQ1mInBeMsF0kRDkVgxefMDB/ZshfAdMc6Sg3uOUDWXyDlc/mDdf2Y
         1VCXTwLXNPnF3VvFfcWMSIK22IlZegOLf1Zcv6U8QoTU0h4fRmAFJGb3zPsmOuHPHSWM
         SXkg==
X-Gm-Message-State: ANoB5pneqJ9W9MXxf21iJu4nxmKuBWBvNgpnqjW0Hpw6C/VwmM8jV+Vz
        2XMsReHo4QJffOMclHCzq5dqbRaULlf5OB59
X-Google-Smtp-Source: AA0mqf4SIuleYPTnp6dY/d7obgT4jg7WzYkSvWIAcCV19qE5Dkg3YX+h6xiQcJQ1IbVDnz9sx+fBPw==
X-Received: by 2002:aa7:860f:0:b0:574:a8a7:22d with SMTP id p15-20020aa7860f000000b00574a8a7022dmr7463907pfn.78.1669421942678;
        Fri, 25 Nov 2022 16:19:02 -0800 (PST)
Received: from [192.168.4.201] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id b14-20020a170902650e00b0016d773aae60sm4012572plk.19.2022.11.25.16.19.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Nov 2022 16:19:02 -0800 (PST)
Message-ID: <63d6db5e-208a-6437-3b4a-b3637f84bfc8@kernel.dk>
Date:   Fri, 25 Nov 2022 17:19:01 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 6.1-rc6
To:     io-uring <io-uring@vger.kernel.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Linus,

A few fixes that should go into this release:

- A few poll related fixes. One fixing a race condition between poll
  cancelation and trigger, and one making the overflow handling a bit
  more robust (Lin, Pavel)

- Fix an fput() for error handling in the direct file table (Lin)

- Fix for a regression introduced in this cycle, where we don't always
  get TIF_NOTIFY_SIGNAL cleared appropriately (me)

Please pull!


The following changes since commit 7fdbc5f014c3f71bc44673a2d6c5bb2d12d45f25:

  io_uring: disallow self-propelled ring polling (2022-11-18 09:29:31 -0700)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/io_uring-6.1-2022-11-25

for you to fetch changes up to 7cfe7a09489c1cefee7181e07b5f2bcbaebd9f41:

  io_uring: clear TIF_NOTIFY_SIGNAL if set and task_work not available (2022-11-25 10:55:08 -0700)

----------------------------------------------------------------
io_uring-6.1-2022-11-25

----------------------------------------------------------------
Jens Axboe (1):
      io_uring: clear TIF_NOTIFY_SIGNAL if set and task_work not available

Lin Ma (2):
      io_uring/filetable: fix file reference underflow
      io_uring/poll: fix poll_refs race with cancelation

Pavel Begunkov (2):
      io_uring: cmpxchg for poll arm refs release
      io_uring: make poll refs more robust

 io_uring/filetable.c |  2 --
 io_uring/io_uring.h  |  9 +++++++--
 io_uring/poll.c      | 47 ++++++++++++++++++++++++++++++++++++++++-------
 3 files changed, 47 insertions(+), 11 deletions(-)

-- 
Jens Axboe
