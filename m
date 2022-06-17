Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78CE354FBEB
	for <lists+io-uring@lfdr.de>; Fri, 17 Jun 2022 19:08:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383228AbiFQRIb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 17 Jun 2022 13:08:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383162AbiFQRI3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 17 Jun 2022 13:08:29 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D26333A5EE
        for <io-uring@vger.kernel.org>; Fri, 17 Jun 2022 10:08:26 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id gd1so4425993pjb.2
        for <io-uring@vger.kernel.org>; Fri, 17 Jun 2022 10:08:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc:from
         :subject:content-transfer-encoding;
        bh=1eTSDVZgL7tW374kIEEbRGFCSjJwowNqEh8hidHrPQU=;
        b=Q4jucF8BRnzpn0so79/n4PpEplCI8zSNB8i2NtQp7lj0r5zWA4hB453ocz5cGz50RP
         snyQ4tFSRRT1/rVPqxfT784Lr2xkhtmUo3chENJKDMS3Q+obZkQng+Pji5/GWrSvNdrC
         LJyyx1oLBVevJuJqBstc19fvTYUKwax31iJsYXagnhJDwljSv8G/XNJRs0n21dPodyUS
         lXd8YLWT8U18J6Vadp7Yh7pKpbHXIHVevwMZ25M+ziIAZ6N3U77ru0+bqQ6casXJQ/H0
         1bHcZJL7XIJlGn2mEFzkh0FbnJtWP+CqJONUfF5JnreBNnMdW8wD1kp/rDx+NlcE+TIq
         I+ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:from:subject:content-transfer-encoding;
        bh=1eTSDVZgL7tW374kIEEbRGFCSjJwowNqEh8hidHrPQU=;
        b=V7UR8OnnnGDincO5Xrmd+lmiZVDJ9jF6I3TkX0R6ta86+doxoS2jsc2ufkHTjNsYSM
         ZoKid7wFIA9tMLBkXUyekN2Do0859njj4zXD9QucDzRI9z+bS4BXInI5VW9d0JQ/hbHj
         pK9146fuQAKNJAZoaiUrLwir/0bVWZNpA1tMZk5TmMRLQP0qCkCqAf2q6fxr0e0qXnaS
         i9WIqIDkZyMlTIXQaL/falrz5CwmFwb4yXTArNYlnysTPRaxw5ULp5/WKPzJOOMMdSG3
         IavbWyNDY1RXIFQzekSDhJSjaCuJV3KhqautXhRbC6GeetMYWVxHnrWrOypTcn3cRsM8
         fdBg==
X-Gm-Message-State: AJIora9AhBb4pYPLeDRLaScveL/5Xh6cGTV1ejHL21UDhcWyMa1uIbrN
        vfabu3WJi7B3iPc+qF0BhCflPcQw0VNwKQ==
X-Google-Smtp-Source: AGRyM1vhOaZ74cela5rcMKNZGJzy8QcV+PTKe3bkK58ERxLwOMzohy4AwPcamt/TXzmLdiR0NCxE2w==
X-Received: by 2002:a17:903:2592:b0:168:9708:ad73 with SMTP id jb18-20020a170903259200b001689708ad73mr10878925plb.59.1655485705951;
        Fri, 17 Jun 2022 10:08:25 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id g7-20020a1709026b4700b0015f2b3bc97asm3859359plt.13.2022.06.17.10.08.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jun 2022 10:08:25 -0700 (PDT)
Message-ID: <c8201cac-5f91-27ca-a530-f9356a520c28@kernel.dk>
Date:   Fri, 17 Jun 2022 11:08:24 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Content-Language: en-US
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 5.19-rc3
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

Bigger than usual at this time, both because we missed -rc2, but also
because of some reverts that we chose to do. In detail:

- Adjust mapped buffer API while we still can (Dylan)

- Mapped buffer fixes (Dylan, Hao, Pavel, me)

- Fix for uring_cmd wrong API usage for task_work (Dylan)

- Fix for bug introduced in fixed file closing (Hao)

- Fix race in buffer/file resource handling (Pavel)

- Revert the NOP support for CQE32 and buffer selection that was brought
  up during the merge window (Pavel)

- Remove IORING_CLOSE_FD_AND_FILE_SLOT introduced in this merge window.
  The API needs further refining, so just yank it for now and we'll
  revisit for a later kernel.

- Series cleaning up the CQE32 support added in this merge window,
  making it more integrated rather than sitting on the side (Pavel)

Please pull!


The following changes since commit b13baccc3850ca8b8cccbf8ed9912dbaa0fdf7f3:

  Linux 5.19-rc2 (2022-06-12 16:11:37 -0700)

are available in the Git repository at:

  git://git.kernel.dk/linux-block.git tags/io_uring-5.19-2022-06-16

for you to fetch changes up to 6436c770f120a9ffeb4e791650467f30f1d062d1:

  io_uring: recycle provided buffer if we punt to io-wq (2022-06-17 06:24:26 -0600)

----------------------------------------------------------------
io_uring-5.19-2022-06-16

----------------------------------------------------------------
Dylan Yudaken (4):
      io_uring: fix index calculation
      io_uring: fix types in provided buffer ring
      io_uring: limit size of provided buffer ring
      io_uring: do not use prio task_work_add in uring_cmd

Hao Xu (2):
      io_uring: openclose: fix bug of closing wrong fixed file
      io_uring: kbuf: fix bug of not consuming ring buffer in partial io case

Jens Axboe (3):
      Merge branch 'io_uring/io_uring-5.19' of https://github.com/isilence/linux into io_uring-5.19
      io_uring: commit non-pollable provided mapped buffers upfront
      io_uring: recycle provided buffer if we punt to io-wq

Pavel Begunkov (13):
      io_uring: fix races with file table unregister
      io_uring: fix races with buffer table unregister
      io_uring: fix not locked access to fixed buf table
      io_uring: fix double unlock for pbuf select
      Revert "io_uring: support CQE32 for nop operation"
      Revert "io_uring: add buffer selection support to IORING_OP_NOP"
      io_uring: remove IORING_CLOSE_FD_AND_FILE_SLOT
      io_uring: get rid of __io_fill_cqe{32}_req()
      io_uring: unite fill_cqe and the 32B version
      io_uring: fill extra big cqe fields from req
      io_uring: fix ->extra{1,2} misuse
      io_uring: remove __io_fill_cqe() helper
      io_uring: make io_fill_cqe_aux honour CQE32

 fs/io_uring.c                 | 367 +++++++++++++++++-------------------------
 include/uapi/linux/io_uring.h |   6 -
 2 files changed, 152 insertions(+), 221 deletions(-)

-- 
Jens Axboe

