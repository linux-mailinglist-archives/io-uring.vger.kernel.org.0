Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A11218E3B4
	for <lists+io-uring@lfdr.de>; Sat, 21 Mar 2020 19:38:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727573AbgCUSik (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 21 Mar 2020 14:38:40 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:46480 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727015AbgCUSik (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 21 Mar 2020 14:38:40 -0400
Received: by mail-pl1-f194.google.com with SMTP id r3so3955657pls.13
        for <io-uring@vger.kernel.org>; Sat, 21 Mar 2020 11:38:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=yJsfugZDU7DZQtM62SLLjOYi0hS3mhuiYGirhWMRsNI=;
        b=Z+UtOWrb663FAQnoPIp6OLW9eYD8xWzoFnGvXcjjz4+Bqbe4qEgzBzbZLh7s4nudvh
         GjyRXr5NrmrDBhcVBoPxbTUEeb5ECrCq3mdSJARLTyQTyCyIL9sTpw59aUQMPBx/abyS
         gjvVxnXlekNAL7OJwSjBClx9IDJ+CRnRG7XGhgvs7atR590Ylv6AEgaf2WPRWKA9gErp
         m+ea3e36drQECgquMdkLkSOIn99l8JAIyy/R9DZMhjsxAhM8wyE5pBzbvTQBQ8+jdSGg
         ZDgofTQVYoOAo51b755WMD7xdUYd7mUTSCj0Csy1Sjmj7CR14uhlbqYk9njFwRRskeYg
         p0Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=yJsfugZDU7DZQtM62SLLjOYi0hS3mhuiYGirhWMRsNI=;
        b=aRtX8ox439ypRNWBoxGvBOZABSXQTF8xB9ZdbjBF0SYbb68Jv4MAXECgiv6LvGO9qi
         lBVV7uB/Tv1mUwYkPtezU5/+/dRCWHTySERxAffDyfTM0xBN9KWBo7JUV09eBVyrguJ6
         gnaAx4QZOXloD3DC+nAC/lHhs82kLgWUBnYEO8EoR05otw434aVH8/RUvaMn9gzHZSaV
         DgzVxAuti7m9i7k2LN6PbYKW53ptfHWOevXebFZcZH/ae1AJQjWNIE4wygpLirf+U9HO
         wmv/TgdRENHShrMyg2h2gNxb5PbB3VzDtohvoAOXeLZ5lc5mq6EBGjf5bd04xszBPmFC
         jybA==
X-Gm-Message-State: ANhLgQ32D4Z/VRmYm07Qo3mmxewRmY+/jb0h0lazik4qwCcIZdVLR39J
        Lid5qUZ17MfxDOjWa6pynnjGGA==
X-Google-Smtp-Source: ADFU+vvUbCZBa8Rx1oLK+kKmZFdJsFZ8EopLyP3vCsfUEw5+NCF01U4glXJk/QYG7FASQW2jyfQQ4w==
X-Received: by 2002:a17:902:bd92:: with SMTP id q18mr1696500pls.282.1584815917630;
        Sat, 21 Mar 2020 11:38:37 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id e38sm8208653pgb.32.2020.03.21.11.38.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 21 Mar 2020 11:38:36 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 5.6-rc
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <51feabdd-c2e2-e24f-92af-edf4b2b0f54d@kernel.dk>
Date:   Sat, 21 Mar 2020 12:38:34 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Linus,

Two different fixes in here:

- Fix for a potential NULL pointer deref for links with async or drain
  marked (Pavel)

- Fix for not properly checking RLIMIT_NOFILE for async punted
  operations. This affects openat/openat2, which were added this cycle,
  and accept4. I did a full audit of other cases where we might check
  current->signal->rlim[] and found only RLIMIT_FSIZE for buffered
  writes and fallocate. That one is fixed and queued for 5.7 and marked
  stable.

Please pull!


  git://git.kernel.dk/linux-block.git tags/io_uring-5.6-20200320


----------------------------------------------------------------
Jens Axboe (2):
      io_uring: make sure openat/openat2 honor rlimit nofile
      io_uring: make sure accept honor rlimit nofile

Pavel Begunkov (1):
      io_uring: NULL-deref for IOSQE_{ASYNC,DRAIN}

 fs/file.c              |  7 ++++++-
 fs/io_uring.c          | 18 ++++++++++++++++--
 include/linux/file.h   |  1 +
 include/linux/socket.h |  3 ++-
 net/socket.c           |  8 +++++---
 5 files changed, 30 insertions(+), 7 deletions(-)

-- 
Jens Axboe

