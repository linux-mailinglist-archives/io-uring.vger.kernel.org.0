Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B11AE5BA905
	for <lists+io-uring@lfdr.de>; Fri, 16 Sep 2022 11:09:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230245AbiIPJG6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 16 Sep 2022 05:06:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230059AbiIPJG4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 16 Sep 2022 05:06:56 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BF5741D05
        for <io-uring@vger.kernel.org>; Fri, 16 Sep 2022 02:06:55 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id b5so34935491wrr.5
        for <io-uring@vger.kernel.org>; Fri, 16 Sep 2022 02:06:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date;
        bh=LuHki7u4WofRJ1pZrU3kZnmRuOA7zvUsbeOtmfG68C4=;
        b=voBdo1LYuPqMJCgPaKQf2j0Hq2vs95dy1VAsFSQXkh9XZGhfxhX4j0wDBSnoU/BX1q
         NAjybK6vBQHKoCNEG8zz1mZ44+feInjVFBM7MOj7x7KhLhfvoyuR+hiHDSEf+/SuXeBK
         hkgFffbnvFHNoepR9ewzc74nmI1SGQjFWzm5casCP7O47mBeNiqxmHmgR6fBqUr1X5f4
         1Mg0TfygyRhOSrqMi8F1laAWC7xOPM0xIGXNu70ZUIFiLBP8OPuZ5ACN+a03KMpeVrYu
         1wOIrnh1pliwqmLDMWhNmZK05R9CwHLmRhxZuxVNokF086euPOE2RpCx+QfxnDDBaMV6
         R8Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date;
        bh=LuHki7u4WofRJ1pZrU3kZnmRuOA7zvUsbeOtmfG68C4=;
        b=NHXIHwdp9+zQXshLfZalx4mRpMeuygaMVvreO3zLwxUmP/9hMytn4RgmmcIpNczNGb
         zamtrxxwRgVvNjbdv+BI1xN3diu1xhQ+JTfqS2ZLJzNgKg5Ung286jOTmUB8RS4PjjHm
         8WJE5uS702WK343R43HC4rDRy0jP2ak7LGCSSq4vv0bPX/UL3fGgN6dX5TU2KshePCDV
         DPTGP36EahoLYXGOTsB/1q6XhVSIfFMKxxLL/jl3n4zwKKOOBP5Eh/QRlbABqXW5IyVn
         kf7Ctnw4MENWOFIbiM7Q5JO76inlUqICzyQuu7thcaq5LTXReBSH2QDW1Hm3Ypvcsx9/
         s8AQ==
X-Gm-Message-State: ACrzQf3/qj7cRmcqrguIEKqWHjYmB97gnebOT0WIr1YAnXTXiKfdz4Wf
        fqmHDrYYJVS+LgnLrU0WdrweG104wWVYcv5V
X-Google-Smtp-Source: AMsMyM7wOv2M/cAR3+ZambTEPl5/CSvhmBRr+GSAlxe8UJ7EN27jif3tY+d4ZCUBqn04jf26hwWZew==
X-Received: by 2002:adf:db03:0:b0:22a:dd80:4b45 with SMTP id s3-20020adfdb03000000b0022add804b45mr1299898wri.111.1663319213498;
        Fri, 16 Sep 2022 02:06:53 -0700 (PDT)
Received: from [10.200.94.69] ([82.141.251.28])
        by smtp.gmail.com with ESMTPSA id u11-20020adfdb8b000000b0022add371ed2sm1151072wri.55.2022.09.16.02.06.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Sep 2022 02:06:52 -0700 (PDT)
Message-ID: <370dbf8d-3966-3626-20aa-1d70521fa9b7@kernel.dk>
Date:   Fri, 16 Sep 2022 03:06:51 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Content-Language: en-US
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 6.0-rc6
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

Two small patches:

- Fix using an unsigned tupe for the return value, introduced in this
  release (Pavel)

- Stable fix for a missing check for a fixed file on put (me)

Please pull!


The following changes since commit 4d9cb92ca41dd8e905a4569ceba4716c2f39c75a:

  io_uring/rw: fix short rw error handling (2022-09-09 08:57:57 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux-block.git tags/io_uring-6.0-2022-09-16

for you to fetch changes up to fc7222c3a9f56271fba02aabbfbae999042f1679:

  io_uring/msg_ring: check file type before putting (2022-09-15 11:44:35 -0600)

----------------------------------------------------------------
io_uring-6.0-2022-09-16

----------------------------------------------------------------
Jens Axboe (1):
      io_uring/msg_ring: check file type before putting

Pavel Begunkov (1):
      io_uring/rw: fix error'ed retry return values

 io_uring/msg_ring.c | 3 ++-
 io_uring/rw.c       | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

-- 
Jens Axboe
