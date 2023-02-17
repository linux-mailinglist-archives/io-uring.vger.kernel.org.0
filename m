Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9112A69A40D
	for <lists+io-uring@lfdr.de>; Fri, 17 Feb 2023 03:54:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230012AbjBQCyY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Feb 2023 21:54:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbjBQCyY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Feb 2023 21:54:24 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57B7154D15
        for <io-uring@vger.kernel.org>; Thu, 16 Feb 2023 18:54:23 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id n20-20020a17090aab9400b00229ca6a4636so8017976pjq.0
        for <io-uring@vger.kernel.org>; Thu, 16 Feb 2023 18:54:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p/eD/e2890oQTwSvfiNnlciNPr4Q3TgDQ3OhK76F9cc=;
        b=HMUkYWofpvLKM/TCKZHcdxO/HHMtFDTXcxSl+Cc/X3xKOvlR8hwFMzFHOy2v4YLY98
         Juxj3YqjDMqf5u6yA7gKGYMNjfhCdNvlMeINpLHXHS5M38v4GPeE7ogYOGP2ndetPKMi
         RWroA4I2AmXfC95PwO6UiHZ+KcqXouysH8hyHsRhTHJlHAnkrUHqqdA8EXFYVl7Nj0Eo
         y1OrjcrVl9snT8CECP8cbuzoFzZuK+t8SDpreswWbhbUPzm+vq0lXx9k5rnaSbosX9ZG
         IjvMupgCDN4y4dtl6m7f6oNSvYPDXtzNQDy/HYjBPh0/DU3c+8olkuUlQGqeV2E/OYM5
         DIAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=p/eD/e2890oQTwSvfiNnlciNPr4Q3TgDQ3OhK76F9cc=;
        b=CqPhoPOJtvYNWe+mCAHMskLWbfxwRiC1SYHU72c5IJ16c4lU/7nyTLhtSnuQF3WCkR
         bO7crYegsPG8etuGimP7dAu4OO0S1aK1FhO6W1Zfzo1AToBWHrDAVin8dUMhDqClWPBK
         Fb2CzFIy8wo7Qfp79wGj1ZsZQyF0k075Lp7H9ESmqylAQPE6IGSPzfaYZACNa7+8hIaD
         f/jfiH5gas0fauD1o2V5lEpMwUWKZbD4E38b/gMsAWpIZjJd4v03YI0PNhY+lG/dWNQQ
         FX0L0WChkLrmEPrmhwpkoPF0QKa9W1ThIlTzX2kmQO6bmUQblXbbH6B9ROrOmQe0gatZ
         OUGw==
X-Gm-Message-State: AO0yUKXHgMCR5K5dHfOWW7NTPCLq6H5E62TkHWGxIo/gpidtlCkPh3G8
        Kz4p+huUu8GXLYJUObyXKhQI07F73V0EU7hy
X-Google-Smtp-Source: AK7set9EyMmpLVD6S2uGYXqsr9OjLIosqZuf6m38fb+s0Wzv2y8Iqa5gRONqmZD8OzOpwDmrtudeug==
X-Received: by 2002:a05:6a20:5496:b0:c6:858d:81c8 with SMTP id i22-20020a056a20549600b000c6858d81c8mr8329929pzk.5.1676602462691;
        Thu, 16 Feb 2023 18:54:22 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id n127-20020a632785000000b004fb95c8f63esm1859184pgn.44.2023.02.16.18.54.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Feb 2023 18:54:22 -0800 (PST)
Message-ID: <7ec9c3d0-1028-4d58-8ef1-0cce3083696c@kernel.dk>
Date:   Thu, 16 Feb 2023 19:54:20 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL for-6.3] Switch io_uring to ITER_UBUF
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

Since we now have ITER_UBUF available, switch to using it for single
ranges as it's more efficient than ITER_IOVEC for that.

Please pull!


The following changes since commit b7bfaa761d760e72a969d116517eaa12e404c262:

  Linux 6.2-rc3 (2023-01-08 11:49:43 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/for-6.3/iter-ubuf-2023-02-16

for you to fetch changes up to d46aa786fa53cbc92593089374e49c94fd9063ae:

  block: use iter_ubuf for single range (2023-01-11 10:31:49 -0700)

----------------------------------------------------------------
for-6.3/iter-ubuf-2023-02-16

----------------------------------------------------------------
Jens Axboe (3):
      iov: add import_ubuf()
      io_uring: switch network send/recv to ITER_UBUF
      io_uring: use iter_ubuf for single range imports

Keith Busch (2):
      iov_iter: move iter_ubuf check inside restore WARN
      block: use iter_ubuf for single range

 block/blk-map.c     |  8 ++++----
 include/linux/uio.h |  1 +
 io_uring/net.c      | 17 +++++------------
 io_uring/rw.c       |  9 ++++++---
 lib/iov_iter.c      | 15 +++++++++++++--
 5 files changed, 29 insertions(+), 21 deletions(-)

-- 
Jens Axboe

