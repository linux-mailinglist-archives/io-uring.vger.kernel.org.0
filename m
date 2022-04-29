Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4741F5153E3
	for <lists+io-uring@lfdr.de>; Fri, 29 Apr 2022 20:41:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359165AbiD2SoV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 29 Apr 2022 14:44:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380182AbiD2SoA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 29 Apr 2022 14:44:00 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6924D116E
        for <io-uring@vger.kernel.org>; Fri, 29 Apr 2022 11:40:40 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id i20so8996245ion.0
        for <io-uring@vger.kernel.org>; Fri, 29 Apr 2022 11:40:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to:cc
         :content-language:content-transfer-encoding;
        bh=2X5ouyCAFBkj8WcDY3cZjsGmSHJxyflynhWLefMBPlg=;
        b=OcBDzzIKX2pdJcHy5EQUWIydYMOp1/F0BivtbsB7G9l9ZO7lOs6Pd2uB7ZoCIe4j/C
         URJ3OOOLXVoN1S/ujwqgrhvME+4rop0Lg5+d7s1VGhBwzaS/nM8q29LxendFLWpO6/mu
         RgKpfW6QcIlOSUFFt8PVUhGSe8ZgCgILW3ICnyBfa/G39NaEGZn8gVdypGDwJzp56icA
         2fGdiP3Iv2EAZSReIleJ7w4to5RGv+c1wG5cI1ZpuzKPzwyN4VOrN1n5gtwohldF976F
         BnesLldwC5x97WvFKVSlGrkgffH9EDqnCutG+p65Tt3OK3tIq5rUC5M/S2bayp1ur5JS
         iz3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from
         :subject:to:cc:content-language:content-transfer-encoding;
        bh=2X5ouyCAFBkj8WcDY3cZjsGmSHJxyflynhWLefMBPlg=;
        b=1yX5n4W052HN0gRDASw1DxbakmYJsY96N29x/wPASaG39B6ViDgONHBVFiRvqMEsMc
         zCNf5+NOgMNqTuL0TXxjUXjSnEP7kQoVxDq5RrnHSv9NKGHLfKv/xTCMNF+C/epvqIjf
         5BDY7oM+LHHgRzL5udKRA/3SHrj3gVZduE8z0bwJhh61060Rqf5pv+Ngybon7y/W0N7B
         LyXSIvN+V0WyujnxskQ0w3CUnr4ffr8Or4VeehPdYtrvGTBggxFNBuGUiZfDXL20f5XF
         gCuLhh16nFjNRUhXePQOpVM49oF0wSayzJIHK2y9/COCn60pmxXAJwO3YIe+Xiw1k5fb
         8QEQ==
X-Gm-Message-State: AOAM532ERDmaBKISVMeqSWncWfnUkZ/Q1wKCPjI4+bjA03bd3MJI49qJ
        hJwrAGanj3AjsxKhDvub01OiLF4URKD2Ag==
X-Google-Smtp-Source: ABdhPJwQk7dCnPlUlbw5YuKxb51RGtWQoAD50ytJr/nBm/sCNZ48gQm0srhypMfXLvS5mesNF6Fjwg==
X-Received: by 2002:a05:6638:3183:b0:32a:7cb1:a13 with SMTP id z3-20020a056638318300b0032a7cb10a13mr276061jak.89.1651257640134;
        Fri, 29 Apr 2022 11:40:40 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id j18-20020a023212000000b0032b3a7817e1sm762319jaa.165.2022.04.29.11.40.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Apr 2022 11:40:39 -0700 (PDT)
Message-ID: <af70231e-157b-1a74-f6e8-81282c5fce28@kernel.dk>
Date:   Fri, 29 Apr 2022 12:40:37 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 5.18-rc5
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
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

Pretty boring:

- 3 patches just adding reserved field checks (me, Eugene)

- Fixing a potential regression with IOPOLL caused by a block change
  (Joseph)

Please pull!


The following changes since commit c0713540f6d55c53dca65baaead55a5a8b20552d:

  io_uring: fix leaks on IOPOLL and CQE_SKIP (2022-04-17 06:54:11 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux-block.git tags/io_uring-5.18-2022-04-29

for you to fetch changes up to 303cc749c8659d5f1ccf97973591313ec0bdacd3:

  io_uring: check that data field is 0 in ringfd unregister (2022-04-29 08:39:43 -0600)

----------------------------------------------------------------
io_uring-5.18-2022-04-29

----------------------------------------------------------------
Eugene Syromiatnikov (1):
      io_uring: check that data field is 0 in ringfd unregister

Jens Axboe (2):
      io_uring: check reserved fields for send/sendmsg
      io_uring: check reserved fields for recv/recvmsg

Joseph Ravichandran (1):
      io_uring: fix uninitialized field in rw io_kiocb

 fs/io_uring.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

-- 
Jens Axboe

