Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6379765932F
	for <lists+io-uring@lfdr.de>; Fri, 30 Dec 2022 00:33:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234068AbiL2XdC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 29 Dec 2022 18:33:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbiL2XdB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 29 Dec 2022 18:33:01 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E35F16585
        for <io-uring@vger.kernel.org>; Thu, 29 Dec 2022 15:33:00 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id d9so3561626pll.9
        for <io-uring@vger.kernel.org>; Thu, 29 Dec 2022 15:33:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0Zn7KEuWn+MhTT9pyB0PWpde9uaUpIeJ00WXXNv00Ug=;
        b=yESxo+fP47oIhUVH5Wn4XLlVCbCgteTmcVWRQ4FYT3nxnZj9JDbOsuwkaeTK6wEQnO
         0IzbjjGIQIKlZvCbNzo4Ss8RHQhxsR8HBH3qBAWgforfKiXVdy+BUXOb7P7Pin0iyRJY
         EZmguQsR5rWZQL9d7wyqQAGVLjsTrvUbBppY7G3nx4OXRTqIi9nfQVgJE2AnLbJzS7K3
         eczDlNWzNxq1VMYcuEqjukBu8fl+e6SAZkab47bjAba58ZUCQwQ/mpeWEJi4q4Pk0lJK
         rJQ9aHlID9BOncG7QklJJXDAhgJs2DXDbRW7ibqqAhds9Ep2YlBrI3z7h4BxJQ7o5gMf
         bNZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=0Zn7KEuWn+MhTT9pyB0PWpde9uaUpIeJ00WXXNv00Ug=;
        b=mER/fd68n99g8ryVdmfVcFz858g+lwVG1Mi+cuMybd6SWBcE8fIePRBRI379VGC9UA
         D6XqHsUZjPSDXjaOQxpV2F8nilSWobnViE0yPKsNODjiNJf7inhd2Ki4Ex8Cm2qaOo9x
         4IIYZrqB4w9smN7UwK9AM9K7JD1PkUME0J62tyg7RhNYdu0yv2o1Oqa/7F9PiE8+R6qn
         drJqsn4rCIcptjy+OHKmO03rwnyPhpR3LZW2UTlNgjNnfDc44nr7EmAk1iXRSHMqCxij
         WDckpLrnz3KG1nF4iGKYhkF4+y96CjZ54doUydg4EU2Uz6NBk3p/yrrP+K1gzSKOMQBP
         C5kA==
X-Gm-Message-State: AFqh2krukwCRNGk3vv7utvvoH+gKL/RKmnrX8dgtma/Sy49kRpR9onbz
        nAIGunxXvHd5VCKZiNqspBkdw+p0RLb/s2d4
X-Google-Smtp-Source: AMrXdXu2EiMBXs9Vh17SPE5sgDrq7n7s1g4ZcHxOYXp/n13HyPrKimFju4NQrRU7rbB4hOJZFC+cxw==
X-Received: by 2002:a05:6a20:3a9e:b0:9d:efc1:116c with SMTP id d30-20020a056a203a9e00b0009defc1116cmr7342662pzh.6.1672356779821;
        Thu, 29 Dec 2022 15:32:59 -0800 (PST)
Received: from [192.168.4.201] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id q24-20020a631f58000000b0043c732e1536sm11544275pgm.45.2022.12.29.15.32.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Dec 2022 15:32:58 -0800 (PST)
Message-ID: <89c38b66-a3eb-1674-a135-d905de0264c6@kernel.dk>
Date:   Thu, 29 Dec 2022 16:32:57 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Content-Language: en-US
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 6.2-rc2
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

Set of fixes for io_uring that should go into the 6.2 release:

- Two fixes for mutex grabbing when the task state is != TASK_RUNNING
  (me)

- Check for invalid opcode in io_uring_register() a bit earlier, to
  avoid going through the quiesce machinery just to return -EINVAL later
  in the process (me)

- Fix for the uapi io_uring header, skipping including time_types.h when
  necessary (Stefan)

Please pull!


The following changes since commit 5ad70eb27d2b87ec722fedd23638354be37ea0b0:

  MAINTAINERS: io_uring: Add include/trace/events/io_uring.h (2022-12-19 09:56:09 -0700)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/io_uring-6.2-2022-12-29

for you to fetch changes up to 9eb803402a2a83400c6c6afd900e3b7c87c06816:

  uapi:io_uring.h: allow linux/time_types.h to be skipped (2022-12-27 07:32:51 -0700)

----------------------------------------------------------------
io_uring-6.2-2022-12-29

----------------------------------------------------------------
Jens Axboe (3):
      io_uring: finish waiting before flushing overflow entries
      io_uring/cancel: re-grab ctx mutex after finishing wait
      io_uring: check for valid register opcode earlier

Stefan Metzmacher (1):
      uapi:io_uring.h: allow linux/time_types.h to be skipped

 include/uapi/linux/io_uring.h |  8 ++++++++
 io_uring/cancel.c             |  9 ++++-----
 io_uring/io_uring.c           | 30 +++++++++++++++++++-----------
 3 files changed, 31 insertions(+), 16 deletions(-)

-- 
Jens Axboe

