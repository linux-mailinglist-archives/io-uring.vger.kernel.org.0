Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3049F5F0C9D
	for <lists+io-uring@lfdr.de>; Fri, 30 Sep 2022 15:43:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231268AbiI3NnI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 30 Sep 2022 09:43:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231532AbiI3NnH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 30 Sep 2022 09:43:07 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC804177788
        for <io-uring@vger.kernel.org>; Fri, 30 Sep 2022 06:43:05 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id u10so368510ilm.5
        for <io-uring@vger.kernel.org>; Fri, 30 Sep 2022 06:43:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date;
        bh=NQjKgC/UdZmJCeMSRjBvRPDzgaGLtNVKWNgpvd7u/ww=;
        b=Xhab3tYVATBZjfZhxZpgjup+JN5YgCo0lJfdn0DMWOQuv4xJuk7VlJPs/1VLo/orfT
         RIC64ve8gBeY4vDHUQYD0o+G62cFqlh/AeTaKC1RO9H6sigBZzkRU2/za80Vi/vxIOkq
         Cedarxfew5uwXT5Wx4Tf2SUL5wZpu1kWvTzBIHLolMamcJWIbtjDTjBYmotFUu69Gk3Z
         Ivcm9hiGrWUC45STSobicO8trAw2XxHaGrzmAMZXNEOXGfWcIv2/+kx8a259LiMR7p1G
         VfcXryiiW2CH+iUJZmq1ljpi8zJVd/amKDuQquw/hdEspbBdQgOuYfv67XXanhpl2Sjs
         Wu8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date;
        bh=NQjKgC/UdZmJCeMSRjBvRPDzgaGLtNVKWNgpvd7u/ww=;
        b=W7TBIELzkfRzndKu7K+8gakrNUByXw1mqjd1KAspWXKx0YLNn67a+zi93J8t8W6apV
         W9/XQ1hM9lIkNiIGYEuc4uYT4P3QwoF/DZdAqqO5SqxNS/JXRv8BgF46F/7gFljoOvZy
         qVoB7m+7kQye/hXAPjuRrZENmJKjYVzsC3YXhej6l3jCC2CeON+OLZQo01rTUKRP5MzH
         qLs+1IE7tOfkmNxq2VqhZKKYrqLk+Z2kmoWMBy/LHrWIxSXX4y7ZDNLD8/UbDJUk+PnA
         8fkRY/+nGtoxxVXPDzL/ZmrhsF0j9xNfYzXsh8os9oEORD8dTWvzsszfHmIwxub/V91x
         OrNA==
X-Gm-Message-State: ACrzQf3XjFDQAwhoq6VDXeqQUaVlhqT5Azj8k2KRp8xC3rfYTYk6khYO
        2LybYFrvJM7dVKooVaJz5fFlPKBNE46XGg==
X-Google-Smtp-Source: AMsMyM6ynqdWcLulUinx6jTaurH605/2o1VAofpPKQVI4p/amaLU8eETuBd7hVC1WRybLSV5kjeCfQ==
X-Received: by 2002:a05:6e02:1c27:b0:2f9:1d1a:9619 with SMTP id m7-20020a056e021c2700b002f91d1a9619mr4537031ilh.209.1664545385098;
        Fri, 30 Sep 2022 06:43:05 -0700 (PDT)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id q22-20020a05663810d600b0035a0d844e43sm919512jad.159.2022.09.30.06.43.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Sep 2022 06:43:04 -0700 (PDT)
Message-ID: <5c6d5c40-8ec8-a54e-97f8-d2377515656b@kernel.dk>
Date:   Fri, 30 Sep 2022 07:43:00 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 6.0-final
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

Two fixes that should go into 6.0:

- Tweak the single issuer logic to register the task at creation, rather
  than at first submit. SINGLE_ISSUER was added for 6.0, and after some
  discussion on this, we decided to make it a bit stricter while it's
  still possible to do so (Dylan).

- Stefan from Samba had some doubts on the level triggered poll that was
  added for this release. Rather than attempt to mess around with it
  now, just do the quick one-liner to disable it for release and we have
  time to discuss and change it for 6.1 instead (me).

Please pull!


The following changes since commit e775f93f2ab976a2cdb4a7b53063cbe890904f73:

  io_uring: ensure that cached task references are always put on exit (2022-09-23 18:51:08 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/io_uring-6.0-2022-09-29

for you to fetch changes up to d59bd748db0a97a5d6a33b284b6c58b7f6f4f768:

  io_uring/poll: disable level triggered poll (2022-09-28 19:27:11 -0600)

----------------------------------------------------------------
io_uring-6.0-2022-09-29

----------------------------------------------------------------
Dylan Yudaken (1):
      io_uring: register single issuer task at creation

Jens Axboe (1):
      io_uring/poll: disable level triggered poll

 io_uring/io_uring.c | 7 +++++++
 io_uring/poll.c     | 2 +-
 2 files changed, 8 insertions(+), 1 deletion(-)

-- 
Jens Axboe
