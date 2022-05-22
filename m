Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A7CD530623
	for <lists+io-uring@lfdr.de>; Sun, 22 May 2022 23:26:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242120AbiEVV03 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 22 May 2022 17:26:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351676AbiEVV0M (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 22 May 2022 17:26:12 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63CA9B497
        for <io-uring@vger.kernel.org>; Sun, 22 May 2022 14:26:11 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id o13-20020a17090a9f8d00b001df3fc52ea7so15799193pjp.3
        for <io-uring@vger.kernel.org>; Sun, 22 May 2022 14:26:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to:cc
         :content-language:content-transfer-encoding;
        bh=klPtpfVebj7qpp/HWa+7GmUKNI89zXY7lQgHDVc8P54=;
        b=nGROBti2c3acqWuQ4Ke024irl5LO5tU6x7GvvqUNXx+91xtZ1IkQnglmSLbroZfs51
         j511TWCciTgzFDjla/1KPIB2z07g1oFNLlbEEz3MjtdSCELLmVOi7+FqPhhcWgZkGwR9
         tJxOLJfzcRLxpWnVScTkKjzfzEvnrss2H0C5/kZ9/uyeeThhoxN+9DA3iEXImNFU4Km0
         qjSbwK771/4c1/UT4Tyr4qUiED5ayZR7QwWDsQNCTpfCri4ez6EalAVIDuDAQ/0gzx9x
         T9QHTzTavu9UYpeGLm3ujqvq+c9IMw4hMQeBmNzjLxYyGh0r6bx2SQ24fCrvgOClK6+d
         TLyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from
         :subject:to:cc:content-language:content-transfer-encoding;
        bh=klPtpfVebj7qpp/HWa+7GmUKNI89zXY7lQgHDVc8P54=;
        b=URDVa8i03/Lh/iP3ClzGyuAi0RDEvwaRP0NWfnqUCrChsEhRu8+AuJLw4GjOzsoClx
         Pd1l+pu3aQs2ZUh7zO3Lh3ymDBBvL6ytCMOOlvnpGLiu5sSFz1CuDzglsXEE4aYzSzaa
         Zg/5bw6vvCe1bILSVGhJSnfNfKmCbHcim1OarhO9aYHKsrOOd+BxB+DjET9eK5EZ8AcH
         EMzLup9Xb2XgNCmnZO8GVh0O+rFvKUHpqM0YWqB7PjizFuANcvwZRyuqk35lNHeErRN8
         lTFZ295zImG/YeP0CaX/eCmvTeBfGf1oPqqcsbpZFaNCv4KGnJ/oRBGw9mHHxG3ak+TD
         T6cQ==
X-Gm-Message-State: AOAM531ORKoFydB4s0e3t4I2gmUcI9jfFWyNtTvtrKQUJ760jb4r4USr
        xL0a53jQyeAHEqLiuF67evKuWQ==
X-Google-Smtp-Source: ABdhPJwp12w9ELo/9xhzfw/yw1xp4+8Efhj/rRUW5aO2tBkfVkbUXKT/RCQr9qWorgv3mp3spzAbYA==
X-Received: by 2002:a17:90a:ca97:b0:1df:9b8e:c6f0 with SMTP id y23-20020a17090aca9700b001df9b8ec6f0mr23238805pjt.12.1653254770783;
        Sun, 22 May 2022 14:26:10 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id o62-20020a62cd41000000b0051850716942sm5767667pfg.140.2022.05.22.14.26.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 May 2022 14:26:10 -0700 (PDT)
Message-ID: <9a8aa863-58a8-c8cd-7d05-80f095cf217e@kernel.dk>
Date:   Sun, 22 May 2022 15:26:09 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring socket(2) support
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
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

On top of the core and xattr branches, this pull request adds support
for socket(2) for io_uring. This is handy when using direct / registered
file descriptors with io_uring.

Outside of those two patches, a small series from Dylan on top that
improves the tracing by providing a text representation of the opcode
rather than needing to decode this by reading the header file every
time. Sits in this branch as it was the last opcode added (until it
wasn't...).

Please pull!


The following changes since commit 0200ce6a57c5de802f4e438485c14cc9d63d5f4b:

  io_uring: fix trace for reduced sqe padding (2022-04-24 18:18:46 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux-block.git tags/for-5.19/io_uring-socket-2022-05-22

for you to fetch changes up to 033b87d24f7257c45506bd043ad85ed24a9925e2:

  io_uring: use the text representation of ops in trace (2022-04-28 17:06:03 -0600)

----------------------------------------------------------------
for-5.19/io_uring-socket-2022-05-22

----------------------------------------------------------------
Dylan Yudaken (4):
      io_uring: add type to op enum
      io_uring: add io_uring_get_opcode
      io_uring: rename op -> opcode
      io_uring: use the text representation of ops in trace

Jens Axboe (2):
      net: add __sys_socket_file()
      io_uring: add socket(2) support

 fs/io_uring.c                   | 177 ++++++++++++++++++++++++++++++++++++++++
 include/linux/io_uring.h        |   5 ++
 include/linux/socket.h          |   1 +
 include/trace/events/io_uring.h |  36 ++++----
 include/uapi/linux/io_uring.h   |   3 +-
 net/socket.c                    |  52 +++++++++---
 6 files changed, 248 insertions(+), 26 deletions(-)

-- 
Jens Axboe

