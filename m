Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 878B447E8EB
	for <lists+io-uring@lfdr.de>; Thu, 23 Dec 2021 22:11:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245103AbhLWVL3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 23 Dec 2021 16:11:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240686AbhLWVL3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 23 Dec 2021 16:11:29 -0500
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E173C061401
        for <io-uring@vger.kernel.org>; Thu, 23 Dec 2021 13:11:29 -0800 (PST)
Received: by mail-il1-x130.google.com with SMTP id w1so5167397ilh.9
        for <io-uring@vger.kernel.org>; Thu, 23 Dec 2021 13:11:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=ZTyw5Oz/wOUUV8ZnwqpcAeWmU1Q7SPzuGN13QbLBdss=;
        b=VWUV9LMRdsJTP0M8Kme3GQRroNwCmiOFZuGJy9bRTrgWbL09NN5CcfV08Z0MQMUlKO
         f+j+ArIB7ngqnK+GUUW9Uu4lici7RNDmhIx3whS02MjGUsntjFfW9JWqk6PlEJWm/TzO
         EV+g9CcgMOmdeOfHJtJKTeHvT9NJdE79WUFsSOZx0S3sda50puk2YyVuZWEwwcIrPdRJ
         +XVe9TAquLGgU17Tn7eBUh/R6NAyS/mHIROuhUNUPh/A4XS9I3G0WMC6Jg+qcBRgJA3f
         qAYoQu374yZZvst58afiBCP7UR4fVKmBbKB6Kj9HWd1BAQh97ycCa6FW2+61+aqhZBEu
         n2rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=ZTyw5Oz/wOUUV8ZnwqpcAeWmU1Q7SPzuGN13QbLBdss=;
        b=yiWmRGkgw/UEs+qDLQZAVsSzVMMfEeKDAwTDYWwElhW66ibZCClux/dxkyMwnflbaB
         gHVnJqMZZ4RNXyrVe6dDTq1H0siAtIeryfWtZrXJ1BnfTAsGx1mYvApMYqFAwwU7invy
         tuoHAWLxWus8aY5iVLQ27AFHX793PLXvzRwslzK8SDxv9Iy/M6o/GqBzXxK5y2Sd5qLs
         BKZwc2Eye+dBsLCq8YWSaa7j7/WlZ/LBt5H7tir6f5mx8ll9O5/XeOvVBw3F2XFBXQrA
         vxQAzFTBUnJXlHNWu4BKwZNMz4FTNE+jGMgSqMN9gV1/tsSsPMiCX6qDQRtz9911yimb
         Jogw==
X-Gm-Message-State: AOAM531Xh5ahFghMPrkINxVt0E1xuNPjYiu2FtSW3nrwxRO8Ep5b3mHr
        TRS3sPBM3nujGguy1rErZHchrijYItpNaA==
X-Google-Smtp-Source: ABdhPJzHGoCg6kJXspppBIMSR7eYI3wbw1xI/WAS7TFlKQJ2qroZhkDancca3zbV3i720lUTwW5Ekw==
X-Received: by 2002:a05:6e02:170a:: with SMTP id u10mr2027673ill.261.1640293887911;
        Thu, 23 Dec 2021 13:11:27 -0800 (PST)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id h1sm4803304iow.31.2021.12.23.13.11.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Dec 2021 13:11:27 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fix for 5.16-rc7
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
Message-ID: <b004710b-1c16-3d90-b990-7a1faf1e5fd0@kernel.dk>
Date:   Thu, 23 Dec 2021 14:11:26 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Linus,

Single fix for not clearing kiocb->ki_pos back to 0 for a stream,
destined for stable as well.

Please pull!


The following changes since commit d800c65c2d4eccebb27ffb7808e842d5b533823c:

  io-wq: drop wqe lock before creating new worker (2021-12-13 09:04:01 -0700)

are available in the Git repository at:

  git://git.kernel.dk/linux-block.git tags/io_uring-5.16-2021-12-23

for you to fetch changes up to 7b9762a5e8837b92a027d58d396a9d27f6440c36:

  io_uring: zero iocb->ki_pos for stream file types (2021-12-22 20:34:32 -0700)

----------------------------------------------------------------
io_uring-5.16-2021-12-23

----------------------------------------------------------------
Jens Axboe (1):
      io_uring: zero iocb->ki_pos for stream file types

 fs/io_uring.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

-- 
Jens Axboe

