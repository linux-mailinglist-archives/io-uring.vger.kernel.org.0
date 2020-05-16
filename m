Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0F581D5ECF
	for <lists+io-uring@lfdr.de>; Sat, 16 May 2020 06:48:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725885AbgEPEsv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 16 May 2020 00:48:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725803AbgEPEsu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 16 May 2020 00:48:50 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FD3AC05BD09
        for <io-uring@vger.kernel.org>; Fri, 15 May 2020 21:48:50 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id u5so2000260pgn.5
        for <io-uring@vger.kernel.org>; Fri, 15 May 2020 21:48:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=guKS4svsfOSzH3GIgrQQGTmdt6cJna8n+F/7p89vkqo=;
        b=A/I2/DYW5hFAEcjSWR7cIaR28I6oMZGI3H9YdK1D9bwujvkU3QHqrQ9nP7HsEcLXHD
         /Dp5w+ocz253iQQBPZm9g4db/MnF8rkO1fWW2+1KxPcXHjrHGJUWpUbRwPUZiDYp+mqg
         wDBAh8C761OITQGGFWQR7L2TbK7ji1WrmlzihKYMyyt3YW65uHQykv5GIAmZ5wavxFA/
         Nv6NVavm4CuZba7oVUXNRJS14KoScKnPLxEJUhc0zKvR7pGJM7PVBisLfDSME+z3UPJ4
         DjInHymfuH87Gkt+nRKsjpTgAb+vYn8mtdTDMmDBFPXscK3Up7aj54FJLTHeQ9VJfz3U
         2DnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=guKS4svsfOSzH3GIgrQQGTmdt6cJna8n+F/7p89vkqo=;
        b=PwfPrvmZ8cvPgVbC4hWEQ3Xlsbu7yqDZtbFOL1O/2bjxKv6mx8xvSt6hgfQYkb0SYl
         y7ygZvS3tVdmSRA8jDb71RCMpkR7bQ5npksVUmZpRZbJXGzC09rKngybFej+JHY8mnOw
         fWliZa05ltGWJhHGzDd/kgW+pSTmazEa+QDtzyilWsFwrJPzYbJpq3rX+BY5KNo+S0Hv
         2CF2UHKnUnhLw6zpKm8uJmd5zTTG/bM019ErE+kdj59FTjHM7rXpktQsLTS4UqDTFs2i
         8+31ozi8+khJa71oW7xq4L5l7yrLM39EZvcK3Y9z+VSZoZvuVINSs6PVDn1DoQdAUeTz
         BL/w==
X-Gm-Message-State: AOAM5300+I3qobVvB96nCHr+TKCHbZt2SSlTwFFRhSIQVVzk2zHz831e
        skAPq2k2EzPPU/sOH9pmkuooWQ==
X-Google-Smtp-Source: ABdhPJzVs7mPufisWaF6ZkAfm30do+cBbq2NDDIcYml+2V/qpPw+6T8fw+WjFekCn1/E4JzsBcwXZw==
X-Received: by 2002:a63:b604:: with SMTP id j4mr6186694pgf.124.1589604529284;
        Fri, 15 May 2020 21:48:49 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:7441:cda2:9ab4:7ee0? ([2605:e000:100e:8c61:7441:cda2:9ab4:7ee0])
        by smtp.gmail.com with ESMTPSA id j5sm3246387pfh.58.2020.05.15.21.48.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 May 2020 21:48:48 -0700 (PDT)
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 5.7-rc6
Message-ID: <670c6caa-5c66-a172-f61c-b5398f4e1d4c@kernel.dk>
Date:   Fri, 15 May 2020 22:48:47 -0600
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

Two small fixes that should go into this release:

- Check and handle zero length splice (Pavel)

- Fix a regression in this merge window for fixed files used with polled
  block IO.

Please pull!


  git://git.kernel.dk/linux-block.git tags/io_uring-5.7-2020-05-15


----------------------------------------------------------------
Jens Axboe (1):
      io_uring: polled fixed file must go through free iteration

Pavel Begunkov (1):
      io_uring: fix zero len do_splice()

 fs/io_uring.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

-- 
Jens Axboe

