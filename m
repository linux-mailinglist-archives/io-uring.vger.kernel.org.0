Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93721739578
	for <lists+io-uring@lfdr.de>; Thu, 22 Jun 2023 04:19:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbjFVCTJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 21 Jun 2023 22:19:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbjFVCTH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 21 Jun 2023 22:19:07 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8567B1735
        for <io-uring@vger.kernel.org>; Wed, 21 Jun 2023 19:19:06 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id d2e1a72fcca58-668842bc50dso805332b3a.1
        for <io-uring@vger.kernel.org>; Wed, 21 Jun 2023 19:19:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1687400346; x=1689992346;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Dw67SaPJk7/K3UbRBaJHbS6iExg2Y4CjbJmG1SMEh7o=;
        b=u0Mgwuh3ohYEuFXi0310rYrEH+rMlSs9tpiZUMnQiW9S+TmlqPLbrnoNmkM2fmemhH
         fDOKIXNITHU3rzAkHMYR/Se5DqAgVmzM21fjS48vYuKyF1l4/Pb7ouDm1B01MaSJSMdP
         gNvhce0SXacJqIv+2S3Dxk6U6PV/p+QUkiY+sqHD952yTcU9Q57OJfqsMKgmUqQhh73h
         fuypxzQqx0mtvEiBE1XlqjdkvoKF/jYuMxn6PQ0dK6Xj7YjhGE4AASMsGzlzBkA2p4LU
         alAH8OlKi2B5TwFZ60TIh6izlEGd5/1AZDAJbLrvkYhLh1Ife9o2IT5Q6QkiHiltP+BP
         o+KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687400346; x=1689992346;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Dw67SaPJk7/K3UbRBaJHbS6iExg2Y4CjbJmG1SMEh7o=;
        b=HAZKRZmSXY/I6quvNRbkOelQfwrH6y6SLOczQzOC4VFU0h0ocHAo8BYmqTzrGCACfJ
         drY7FVWUMdcUPZqcaHdWn7ytZkt2OtArSj+UQXkBuL3fhrvA2XU0wNFbxxyXvNjF5OGd
         hui8Qc9ReDq8yOsDuCDX2badTGu6tPARs7jFP4A0mSwEJcdwrUjRl3Nq9fZZ1szJ2eWq
         fyOaOpa1JeOidrtEVh462ne1nhH0j4ZA6UOt53WpvJZpESbYJ+/q4g1+aHRgEkwDChnb
         QuS+MpSSEBP3PqWNgXr7fMMZOpoKP13ZmYEUocHdhjfnb1R2yaBGrFaVr74LYiwSAH8h
         En8w==
X-Gm-Message-State: AC+VfDyxKIHInTuVdNos9UNU7zUAinnpcseu8YeZyKswEmH7wAEYxI4w
        p5CUz0ajJFgGqOxQPtA9TFCXZCY4Y8s0vOEa3NE=
X-Google-Smtp-Source: ACHHUZ4Mj0OBPcZOQvpMv96J4QGjsKEyM5UPQCrIu7Eordu+3g8oWKjHP6YZem73jvkhniw9L71Y6g==
X-Received: by 2002:a05:6a20:244c:b0:11b:3e33:d2f3 with SMTP id t12-20020a056a20244c00b0011b3e33d2f3mr20796764pzc.0.1687400345904;
        Wed, 21 Jun 2023 19:19:05 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id g8-20020aa78188000000b0065016fffc81sm3447735pfi.216.2023.06.21.19.19.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Jun 2023 19:19:05 -0700 (PDT)
Message-ID: <5076b757-3858-ed2d-4855-f2d59e4fc76a@kernel.dk>
Date:   Wed, 21 Jun 2023 20:19:04 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Content-Language: en-US
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 6.4-final
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Linus,

A fix for a race condition with poll removal and linked timeouts, and
then a few followup fixes/tweaks for the msg_control patch from last
week. Not super important, particularly the sparse fixup, as it was
broken before that recent commit. But let's get it sorted for real for
this release, rather than just have it broken a bit differently.

Please pull!


The following changes since commit adeaa3f290ecf7f6a6a5c53219a4686cbdff5fbd:

  io_uring/io-wq: clear current->worker_private on exit (2023-06-14 12:54:55 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/io_uring-6.4-2023-06-21

for you to fetch changes up to 26fed83653d0154704cadb7afc418f315c7ac1f0:

  io_uring/net: use the correct msghdr union member in io_sendmsg_copy_hdr (2023-06-21 07:34:17 -0600)

----------------------------------------------------------------
io_uring-6.4-2023-06-21

----------------------------------------------------------------
Jens Axboe (4):
      io_uring/poll: serialize poll linked timer start with poll removal
      io_uring/net: clear msg_controllen on partial sendmsg retry
      io_uring/net: disable partial retries for recvmsg with cmsg
      io_uring/net: use the correct msghdr union member in io_sendmsg_copy_hdr

 io_uring/net.c  | 17 +++++++++++------
 io_uring/poll.c |  9 ++++-----
 2 files changed, 15 insertions(+), 11 deletions(-)

-- 
Jens Axboe

