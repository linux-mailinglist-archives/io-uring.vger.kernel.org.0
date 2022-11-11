Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6164A62633B
	for <lists+io-uring@lfdr.de>; Fri, 11 Nov 2022 21:53:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234555AbiKKUxL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 11 Nov 2022 15:53:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233015AbiKKUxJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 11 Nov 2022 15:53:09 -0500
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29F99862DF
        for <io-uring@vger.kernel.org>; Fri, 11 Nov 2022 12:53:06 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id y6so4389881iof.9
        for <io-uring@vger.kernel.org>; Fri, 11 Nov 2022 12:53:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X4yMjLHL+FUL+kv/q9WP+j/IGwM2j+PyZR2y9mq3rp4=;
        b=EkonaF7428bkd26ipII0iu9+hh5nCG5DMDUW7RCmsVFEA1J3dL86epy8YGd73Y2JQr
         O2/ZzKs0BkAETSyaTpLrgTWBe9mvgDVhASe9uUrET0RroD1BZWLj/whQjLXgDmQtai3K
         R8G+EoHXi5jZ8A5VuknwAoaJgiXfpQtAZt/KAI0H44NloXEWBs1WijSE5E42WbnUbBtd
         6UCAg1y92QLXDEdgYqXVxA+Juc1VqEFk7+XrypsXBAcUJauWr9n+hqfMGr2kGLlweqqR
         ZQrhADvG341cfzToGik/x3oqOosWBFFnWZ6YoT0bRZlSBqqZtc54k5W3dEJrS6IYKXZH
         d4zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=X4yMjLHL+FUL+kv/q9WP+j/IGwM2j+PyZR2y9mq3rp4=;
        b=QTiNENvS3KPDLdPibxbU8uTiZJ0YkD+Nstiwy8R3yX47gRn1udBAUwI+px8msCyc+e
         MCcaD8l+N1r2PII/03jB5VKUIz0X1thhtQB45tUqNEIigAVrar9tvKwaB5tRp+wwq87Y
         x81LgXBQpUKgI3+QysXZm5qJGxM7Susu11x5sZKSiJbznMuBhNntG0qlslqP8yQPTVrT
         DFy6ZIop5fzqutookRTT4Fx/41lzKgOHuOhFsax3M6WFK9sNsTqg4gsxSFrj6kuHvRW4
         i7m6OTu1Gh1Hd+FUamra+EwpikbT+P8ZzA8Wx+8TH0jq7+Q5941e3RIrNIM8BQnmG0qb
         ly+Q==
X-Gm-Message-State: ANoB5pm2cXpJs+OHCDF8ROk5I541hvOgQ6rb4kMfAf+maO3/8M916LfX
        3x/TLbfx9HvIIf3SI49xa2S7//VCb9pRxw==
X-Google-Smtp-Source: AA0mqf7S5yG6W3Wmfi+GyGF7kD2ub8GkrHAh8jkV7/KzXbniaSMfZvLBY44Kaqo0felFGS3oSKzJeA==
X-Received: by 2002:a02:a004:0:b0:374:646a:f97c with SMTP id a4-20020a02a004000000b00374646af97cmr1456129jah.55.1668199985400;
        Fri, 11 Nov 2022 12:53:05 -0800 (PST)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id m6-20020a6bf306000000b006bcd45fe42bsm1147904ioh.29.2022.11.11.12.53.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Nov 2022 12:53:04 -0800 (PST)
Message-ID: <ac813279-8e83-deba-4f26-99523dd71fc2@kernel.dk>
Date:   Fri, 11 Nov 2022 13:53:04 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 6.1-rc5
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

Nothing major, just a few minor tweaks:

- Teak for the TCP zero-copy io_uring self test (Pavel)

- Rather than use our internal cached value of number of CQ events
   available, use what the user can see (Dylan)

- Fix a typo in a comment, added in this release (me)

- Don't allow wrapping while adding provided buffers (me)

- Fix a double poll race, and add a lockdep assertion for it too (Pavel)

Please pull!


The following changes since commit b3026767e15b488860d4bbf1649d69612bab2c25:

  io_uring: unlock if __io_run_local_work locked inside (2022-10-27 09:52:12 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/io_uring-6.1-2022-11-11

for you to fetch changes up to 5576035f15dfcc6cb1cec236db40c2c0733b0ba4:

  io_uring/poll: lockdep annote io_poll_req_insert_locked (2022-11-11 09:59:27 -0700)

----------------------------------------------------------------
io_uring-6.1-2022-11-11

----------------------------------------------------------------
Dylan Yudaken (1):
      io_uring: calculate CQEs from the user visible value

Jens Axboe (2):
      io_uring: fix typo in io_uring.h comment
      io_uring: check for rollover of buffer ID when providing buffers

Pavel Begunkov (3):
      selftests/net: don't tests batched TCP io_uring zc
      io_uring/poll: fix double poll req->flags races
      io_uring/poll: lockdep annote io_poll_req_insert_locked

 include/uapi/linux/io_uring.h                      |  2 +-
 io_uring/io_uring.c                                | 10 +++++--
 io_uring/kbuf.c                                    |  2 ++
 io_uring/poll.c                                    | 31 +++++++++++++---------
 .../testing/selftests/net/io_uring_zerocopy_tx.sh  |  2 +-
 5 files changed, 31 insertions(+), 16 deletions(-)

-- 
Jens Axboe
