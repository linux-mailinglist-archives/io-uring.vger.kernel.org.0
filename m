Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9ECB866A36D
	for <lists+io-uring@lfdr.de>; Fri, 13 Jan 2023 20:35:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230201AbjAMTfC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 13 Jan 2023 14:35:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231158AbjAMTej (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 13 Jan 2023 14:34:39 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D09288D3A3
        for <io-uring@vger.kernel.org>; Fri, 13 Jan 2023 11:32:32 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id jl4so24413160plb.8
        for <io-uring@vger.kernel.org>; Fri, 13 Jan 2023 11:32:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OGK+Hd59trFRtH/j9qtLhlXmYO4qHE0tR5ilIISQNbs=;
        b=XOPJZjKlbxgFLjaKoXS3aVfLF/+NqQld2Q3iMFlioQwdNEe7OpBh2wy6SmwiPQFMjq
         Kq3XRifqK+SbEWkbWBGEmmS1ZMVhxipmlMgglVmB2daAlVWE9ZbtLe6Fw17gwAuXdQIj
         mYau7+lCQYSIhW6jJu6r2CGcZJ0z7nnJVszNcXzcoYfbPEAfrcAPKGugczrJXiSy/N5r
         bZrn9ItQIrUtQR3WThqv8q+IS2ssmCiSbBg3l0shfagROoSujLlkoVdsuZVFix9D2x9K
         DayiUNlXP2k5INxf0kMToOsnClBf7tBPQKF/CDn+30XQcg3e2R+VovHvESCqHipbnCu8
         g25Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=OGK+Hd59trFRtH/j9qtLhlXmYO4qHE0tR5ilIISQNbs=;
        b=yyp5k/I6vZ1fzx4viazyyddABrlTKRT0ugupevDlo51I2FcdoAl5l4LqNO6Q2KmnOM
         znJCGDY2XEY561GxHslW2nhOQMPE4jV24zt7rwtx2S2D8n2B5Nc4DNwWut8z11VZoaH5
         56g/PMnghC8UaweuS7Tl+Apyf+3u5F4OGHdPaZ6oTF+ifwp/Murm1u4EqMEQg7kiKQvx
         hZ4a3QG2gNACvSOQmVq8glarnxY5P/FntVfX2MyBpq3IctvLDwOGDvebMeRaoANOprnf
         K+kc/TlLWfjmHAl9bfAPQQKIvc0rSlh2XhA4LYntRau1KPA7KXjpobXzMqMuggAMh4FQ
         vmzw==
X-Gm-Message-State: AFqh2kqz//Ch2RxyI0LMAkJxPEsFuz/NX+uZV3qyy1rDDE4Ff6oTS8+f
        knrPUIfI0P4EJVVh/i5ausi0n6dF7vJmn6pA
X-Google-Smtp-Source: AMrXdXuev+iUNWVrz+2EuJDWgK6Wx/+VIPYsWyrE11zmjKNLPzVIAVn+7p56rChHGs/JRhPFl5ywig==
X-Received: by 2002:a05:6a20:1586:b0:ab:e177:111e with SMTP id h6-20020a056a20158600b000abe177111emr28812770pzj.5.1673638352196;
        Fri, 13 Jan 2023 11:32:32 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id k11-20020aa79d0b000000b00588fb6fafe0sm9596537pfp.188.2023.01.13.11.32.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Jan 2023 11:32:31 -0800 (PST)
Message-ID: <a9270ed5-05f5-2353-d5f6-f877b5ca7d60@kernel.dk>
Date:   Fri, 13 Jan 2023 12:32:30 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Content-Language: en-US
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 6.2-rc4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Linus,

A fix for a regression that happened last week, rest is fixes that will
be headed to stable as well. In detail:

- Fix for a regression added with the leak fix from last week (me)

- In writing a test case for that leak, inadvertently discovered a case
  where we a poll request can race. So fix that up and mark it for
  stable, and also ensure that fdinfo covers both the poll tables that
  we have. The latter was an oversight when the split poll table were
  added (me)

- Fix for a lockdep reported issue with IOPOLL (Pavel)

Please pull!


The following changes since commit 12521a5d5cb7ff0ad43eadfc9c135d86e1131fa8:

  io_uring: fix CQ waiting timeout handling (2023-01-05 08:04:47 -0700)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/io_uring-6.2-2023-01-13

for you to fetch changes up to 544d163d659d45a206d8929370d5a2984e546cb7:

  io_uring: lock overflowing for IOPOLL (2023-01-13 07:32:46 -0700)

----------------------------------------------------------------
io_uring-6.2-2023-01-13

----------------------------------------------------------------
Jens Axboe (4):
      io_uring/io-wq: only free worker if it was allocated for creation
      io_uring/poll: add hash if ready poll request can't complete inline
      io_uring/fdinfo: include locked hash table in fdinfo output
      io_uring/poll: attempt request issue after racy poll wakeup

Pavel Begunkov (1):
      io_uring: lock overflowing for IOPOLL

 io_uring/fdinfo.c | 12 ++++++++++--
 io_uring/io-wq.c  |  7 ++++++-
 io_uring/poll.c   | 48 ++++++++++++++++++++++++++++++++----------------
 io_uring/rw.c     |  6 +++++-
 4 files changed, 53 insertions(+), 20 deletions(-)

-- 
Jens Axboe

