Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C06775D516
	for <lists+io-uring@lfdr.de>; Fri, 21 Jul 2023 21:34:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229846AbjGUTec (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Jul 2023 15:34:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbjGUTeb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 Jul 2023 15:34:31 -0400
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4305230F1
        for <io-uring@vger.kernel.org>; Fri, 21 Jul 2023 12:34:13 -0700 (PDT)
Received: by mail-il1-x133.google.com with SMTP id e9e14a558f8ab-345d2b936c2so2412015ab.0
        for <io-uring@vger.kernel.org>; Fri, 21 Jul 2023 12:34:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689968052; x=1690572852;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MTxRNPRlwZ/dHKtx8WnZO5Sd9os+Pyp/fKyWNTeHNbg=;
        b=Szx2hmNjP1N04VQGxo+Xc7EQtwtmbMurqXhF2bLKendmK9EZ8CI1l9Cn39ICjLOnbi
         EPHnKU++XJoIxFo8MEnDL9VUO36EzuuNhCiCmDRviqtmIddXdcOmEiMdWjAwHHLH1ryO
         OZwZAsVvp9NmxyX/F6Cpi3Rv/5B76cz81cAN2jy/aeYLlyYg8kFcV9bSB6W0vWMu4lHJ
         ZSAsDcpAA/E5yHOtDGVnXtEjXKTsfKvsPjPeG0Z5J1jgtauR8O3VETLbovzEbteifzE+
         qsFgRrERdWFlXKNMbAM7rPODJz0PXK3WmLBuz7pKdLrsqUrXAc3qHc/ifWUAQfKH73HR
         C2Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689968052; x=1690572852;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=MTxRNPRlwZ/dHKtx8WnZO5Sd9os+Pyp/fKyWNTeHNbg=;
        b=fcJBMaFZ7jvUOJpCs9Z0pJaHvVKqLIKKbqSq4kXnVjG0FNQQK/3n9iYCXXuZGC4So5
         PPBtzcilshhqIVgRt93e0oNHTF0tZ/mo+72hrxbLkbkUJ5CzlPn0QVteYk+/lr663BBg
         oPAJeg4+igRubK/CYtG6G0GVXOihQ4vFyQyHaI26JDc8ywonV/8Aqya75rdkVCtqjVh+
         xi8Z4mn92KZW/GAVOvd05wVUNOIOwtuQQVaWu8EqKp/ZcbcqSSiAxKgI8F8G5HHOAvO6
         XEhD+aXn8gQDYsT7MNGqUVxgl3MrM0QDnyRVJQWEB3uUTqGZk3xQfCY2LeibOH6a/I3K
         K5WA==
X-Gm-Message-State: ABy/qLZpXqer1F31zNESyZBRc+w4gnYMZE0t3o47stv7CSuQySYM7d8N
        rOAlHPyt6JXRmUh5nMG0MO2lI6r+cJM6nSwxyHs=
X-Google-Smtp-Source: APBJJlFQhjf5xxV7YaMn4o/tR4wHXJx7yHF+XyPQtbCN6BZNipiyuT9Js8bn+gLA25/1uHLExlyXoA==
X-Received: by 2002:a05:6602:381a:b0:783:6e76:6bc7 with SMTP id bb26-20020a056602381a00b007836e766bc7mr2790568iob.2.1689968052608;
        Fri, 21 Jul 2023 12:34:12 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id p22-20020a02b396000000b0042b068d921esm1229522jan.16.2023.07.21.12.34.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Jul 2023 12:34:12 -0700 (PDT)
Message-ID: <c8a325c8-d8af-4592-5a17-7f7c17ca6d57@kernel.dk>
Date:   Fri, 21 Jul 2023 13:34:11 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 6.5-rc3
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Linus,

This pull request contains a few fixes:

- Fix for io-wq not always honoring REQ_F_NOWAIT, if it was set and
  punted directly (eg via DRAIN) (me)

- Capability check fix (Ondrej)

- Regression fix for the mmap changes that went into 6.4, which
  apparently broke IA64. (Helge)

Please pull!


The following changes since commit 8a796565cec3601071cbbd27d6304e202019d014:

  io_uring: Use io_schedule* in cqring wait (2023-07-07 11:24:29 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/io_uring-6.5-2023-07-21

for you to fetch changes up to 07e981137f17e5275b6fa5fd0c28b0ddb4519702:

  ia64: mmap: Consider pgoff when searching for free mapping (2023-07-21 09:41:35 -0600)

----------------------------------------------------------------
io_uring-6.5-2023-07-21

----------------------------------------------------------------
Helge Deller (2):
      io_uring: Fix io_uring mmap() by using architecture-provided get_unmapped_area()
      ia64: mmap: Consider pgoff when searching for free mapping

Jens Axboe (1):
      io_uring: treat -EAGAIN for REQ_F_NOWAIT as final for io-wq

Ondrej Mosnacek (1):
      io_uring: don't audit the capability check in io_uring_create()

 arch/ia64/kernel/sys_ia64.c     |  2 +-
 arch/parisc/kernel/sys_parisc.c | 15 ++++++++----
 io_uring/io_uring.c             | 52 ++++++++++++++++++++---------------------
 3 files changed, 37 insertions(+), 32 deletions(-)

-- 
Jens Axboe

