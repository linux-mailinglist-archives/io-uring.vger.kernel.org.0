Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 756D24FA16C
	for <lists+io-uring@lfdr.de>; Sat,  9 Apr 2022 03:53:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240376AbiDIBzT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 8 Apr 2022 21:55:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbiDIBzS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 8 Apr 2022 21:55:18 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43EC81E5326
        for <io-uring@vger.kernel.org>; Fri,  8 Apr 2022 18:53:12 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id be5so3423256plb.13
        for <io-uring@vger.kernel.org>; Fri, 08 Apr 2022 18:53:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to:cc
         :content-language:content-transfer-encoding;
        bh=Vf7PjGHcyYfW81kevmcwUcaoeA6yoDMSyC/b73s+nCk=;
        b=Li+vHHAI/V0K5ikrwJ2w3epQaD2gCC3dqro3umX11tdrqOwwOgtH3iRFYpMfn9hCOW
         Mow4/uo9BsPgWuDaZQ8YcrPP8LNX/wSzTPoRniXEdc68pg/UZAy4snyKo8UCqaxl7zCv
         7161ZrBZFDpPnmkFqZPAnbWwLhQpkckiuUqjuPrrZJTMLffW53saX60kxqns9sl+p1H5
         PrGEDVeU9al7+N0VcaiL1kAgzwiUtEVm3x62carwJuGp2gEmy8KkrHdvik8RtCJOdzOR
         3YG21skLS9CC1exZX7bfFrknbDSDH2/vnzRzroCe60u2hy4Es9RwgSN7ZBXak0Thza6L
         fgVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from
         :subject:to:cc:content-language:content-transfer-encoding;
        bh=Vf7PjGHcyYfW81kevmcwUcaoeA6yoDMSyC/b73s+nCk=;
        b=01+dO9Fb5zpJE/ta9Wrkoi5nzTqf/uqvSIqyd52UOiIHnTVs1iNoKoATmtXuTqMRqu
         W3CB8v9e5OC6aXaJXR2cqdMlPeRPpKWsO17NgEAGgAj1eciMdSgrvm+wJnjH3oRH7eaZ
         DEeBQzcjajGE0zkU+Oeeez7nkjtXJ8mpagd+6WtZEaffyeF/noWlfFNzatKZjyoU0SdT
         I4B7GSbl1TieBZSP2ikknfXK3nQ/kkZlAagyOrbutOjE5WyTNVKQO6AvQ2n3ExV5gv+6
         KF/DOZxj8km1WIUSUbFAtbI0qtYZHa4SauGuhPj+gLFCe1qasi3pXEIzcP/dkPUtbvuU
         Xzaw==
X-Gm-Message-State: AOAM533cgAOacyab/nDRVJMxYPS09TC3NcrfOzoVgPiyCGWNtJLPIZvQ
        8ZpXmGV6ergOIDEVvCs2CAcxBspHuIYc5Q==
X-Google-Smtp-Source: ABdhPJwuEO+I1RytaYLTDTyImTAQVe7WjGblKD8KWCTOQqAC2jOlEtfn1aDfkr/TRmJeB4WvFM+gOA==
X-Received: by 2002:a17:90b:4f86:b0:1c9:b52d:9713 with SMTP id qe6-20020a17090b4f8600b001c9b52d9713mr24737629pjb.98.1649469191480;
        Fri, 08 Apr 2022 18:53:11 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id k11-20020a056a00168b00b004f7e1555538sm27203145pfc.190.2022.04.08.18.53.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Apr 2022 18:53:10 -0700 (PDT)
Message-ID: <3576e052-e303-1659-ceaa-91252cf667d4@kernel.dk>
Date:   Fri, 8 Apr 2022 19:53:09 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 5.18-rc2
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

A bit bigger than usual post merge window, largely due to a revert and a
fix of at what point files are assigned for requests. The latter fixing
a linked request use case where a dependent link can rely on what file
is assigned consistently. In detail:

- 32-bit compat fix for IORING_REGISTER_IOWQ_AFF (Eugene)

- File assignment fixes (me)

- Revert of the NAPI poll addition from this merge window. The author
  isn't available right now to engage on this, so let's revert it and we
  can retry for the 5.19 release (me, Jakub)

- Fix a timeout removal race (me)

- File update and SCM fixes (Pavel)

Please pull!


The following changes since commit 3123109284176b1532874591f7c81f3837bbdc17:

  Linux 5.18-rc1 (2022-04-03 14:08:21 -0700)

are available in the Git repository at:

  git://git.kernel.dk/linux-block.git tags/io_uring-5.18-2022-04-08

for you to fetch changes up to e677edbcabee849bfdd43f1602bccbecf736a646:

  io_uring: fix race between timeout flush and removal (2022-04-08 14:50:05 -0600)

----------------------------------------------------------------
io_uring-5.18-2022-04-08

----------------------------------------------------------------
Eugene Syromiatnikov (1):
      io_uring: implement compat handling for IORING_REGISTER_IOWQ_AFF

Jens Axboe (8):
      io_uring: don't check req->file in io_fsync_prep()
      io_uring: defer splice/tee file validity check until command issue
      io_uring: move read/write file prep state into actual opcode handler
      io_uring: propagate issue_flags state down to file assignment
      io_uring: defer file assignment
      io_uring: drop the old style inflight file tracking
      Revert "io_uring: Add support for napi_busy_poll"
      io_uring: fix race between timeout flush and removal

Pavel Begunkov (4):
      io_uring: nospec index for tags on files update
      io_uring: don't touch scm_fp_list after queueing skb
      io_uring: zero tag on rsrc removal
      io_uring: use nospec annotation for more indexes

 fs/io-wq.h    |   1 +
 fs/io_uring.c | 617 +++++++++++++++++++---------------------------------------
 2 files changed, 198 insertions(+), 420 deletions(-)

-- 
Jens Axboe

