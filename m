Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29AFE1CBCDD
	for <lists+io-uring@lfdr.de>; Sat,  9 May 2020 05:13:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728353AbgEIDMy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 8 May 2020 23:12:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728625AbgEIDMx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 8 May 2020 23:12:53 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F648C061A0C
        for <io-uring@vger.kernel.org>; Fri,  8 May 2020 20:12:52 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id r14so1999078pfg.2
        for <io-uring@vger.kernel.org>; Fri, 08 May 2020 20:12:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=0fAk7ZpAqjDTTUlJrY2gO1N8l4nPyAVEQOajMC1v0Ws=;
        b=yhCzWpzAOK6rF6jP4117QQ//DqCZA+d21wEIOej+xBnNcoy3pulqS74cfXMeWQXCC5
         +J9j/sPQOu3T0fN3dEpJ7vv2WSWPNPVpcakAbs6ME+L09R6p59765Q4wkxU0oVM1JC5A
         gad8G2c9y/OhOLLZdollok503Uzlj6AW7TbA3pkjz5ian+ZaVidUit3DX/rmv9MEFR9I
         x8Qkd/1pITRDe2OYiwlHBUAOpk1LEy3cAJ+aZGEg74dWDS5KWQtXVhPxkndtBuGWVDQM
         D3CEYRVHWwWfm62MO9ryebEqm1uWkSiDe/kkdN9vKcnhdKnY7pdmK+VTtQ3DCvT8Cm5B
         GIwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=0fAk7ZpAqjDTTUlJrY2gO1N8l4nPyAVEQOajMC1v0Ws=;
        b=RTKRmo3vwAOe76R2XEHbL2xCJOKMxelp+itSpnP1EC1uuG5p76DkP7R4tWgUjjTHIS
         h6/8jjm8ZdjIJVoNL75OE3nrbb4ostxX+DDE7rsjx7EyRRD5h7xFiqLOoXLHtNwM2nqN
         NmxPju7VGYnJGvfLg/7KCjWcM85Tix5wmYU+6HJmZVgP7Z+UdwPggmndYhqUHYUgJ86x
         4hJdCzoElJLIEOiOSUIo2gD51+IpYpf6z2WRpBRN4XDU/G+lWrGMzMiTL34/23HD6MHh
         ZuUrTo4K/ri938OeNg+8i1b4wTeikwEjOo99Kn8GQLDDgvkA20n8a9kXAYdwDhaz1OmQ
         wIaw==
X-Gm-Message-State: AGi0PuYRD3IXd0keGsdDQAwJWK4mn9EUOHDjPcK5+PxdJzgxBe8bWcUd
        ZhRgqYPVdvRxReAsce1KJq7aBQ==
X-Google-Smtp-Source: APiQypIUJYqTDsXo4WyM4KVfIveyEQ+rOw67qbSgJeXo9F/vwm66qKT3TA00Xg81HLWhTosUDTOLJA==
X-Received: by 2002:a63:4c1d:: with SMTP id z29mr4625642pga.243.1588993971602;
        Fri, 08 May 2020 20:12:51 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id b8sm3490300pjz.51.2020.05.08.20.12.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 May 2020 20:12:50 -0700 (PDT)
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 5.7-rc5
Message-ID: <cf931801-dc26-e86b-57aa-d7730baccdc1@kernel.dk>
Date:   Fri, 8 May 2020 21:12:49 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Linus,

A few fixes that should go into this series:

- Fix finish_wait() balancing in file cancelation (Xiaoguang)

- Ensure early cleanup of resources in ring map failure (Xiaoguang)

- Ensure IORING_OP_SLICE does the right file mode checks (Pavel)

- Remove file opening from openat/openat2/statx, it's not needed and
  messes with O_PATH

Please pull!


  git://git.kernel.dk/linux-block.git tags/io_uring-5.7-2020-05-08


----------------------------------------------------------------
Jens Axboe (1):
      io_uring: don't use 'fd' for openat/openat2/statx

Pavel Begunkov (1):
      splice: move f_mode checks to do_{splice,tee}()

Xiaoguang Wang (2):
      io_uring: fix mismatched finish_wait() calls in io_uring_cancel_files()
      io_uring: handle -EFAULT properly in io_uring_setup()

 fs/io_uring.c | 65 ++++++++++++++++++++---------------------------------------
 fs/splice.c   | 45 +++++++++++++++++------------------------
 2 files changed, 40 insertions(+), 70 deletions(-)

-- 
Jens Axboe

