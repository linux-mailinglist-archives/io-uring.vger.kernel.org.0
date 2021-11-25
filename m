Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B487E45DECB
	for <lists+io-uring@lfdr.de>; Thu, 25 Nov 2021 17:51:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242334AbhKYQyJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Nov 2021 11:54:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237330AbhKYQwJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Nov 2021 11:52:09 -0500
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38618C0613DD
        for <io-uring@vger.kernel.org>; Thu, 25 Nov 2021 08:42:36 -0800 (PST)
Received: by mail-il1-x134.google.com with SMTP id k1so6401179ilo.7
        for <io-uring@vger.kernel.org>; Thu, 25 Nov 2021 08:42:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=setNTYMIuzrDEp2or8mwKSFAAw0+fV8cLApv3wLAiok=;
        b=sumCBU3f04vXlLdBHoZlY1xDOXdgNuMnwkskG+0suLnJxKH4DwTaew94l+vz4a8zB3
         /CqOuwfb3MuQ+591mar238id+xKR78jQpKEiT+AO3OGNjkjwXKLdsC3PDyZdBw3n7fXR
         WaENa/8iOPsMr7jBvE3t85xK9c2UjmczGiveXnxN8sCYF3iBRhL/4RtJ3vlEr/62j7k3
         LioWfIw+yln5ByMS+m4jfF1LDFit+Jh/19eKwUss8+vkcnzd3DW1BNqk/YcCBmkOD1tq
         EC1wRoF62iB8pRtaDMShdCg6ZGXZDSfiGSkdmvYGT1IZwi37/p7qGT0471k6tLT4249a
         FNAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=setNTYMIuzrDEp2or8mwKSFAAw0+fV8cLApv3wLAiok=;
        b=INF8tvmz9rLOYYoRQ02EiEBHEVoV4Fh12FNoynaWeQfE2m4rSdNmRPTQtODb7sayvA
         bYBYh23NIwbE8QeYVrMr19gIJ95vON6swUVTywjUnOJQ82MGZJz03jN3dadawIPlOYep
         pNkzLHiB1xA2t0e/hRYgOXo+Iq+imOBw1MPmi+BBEHVBnd+5B5nE7ae+9TPUt3ifzFmK
         WYgp2+rl390xd8hdti3/EUFF1pggrpMfQGCgeUxuKAf+olXR9+WGRh0gIWbSfTGa5UrU
         smvlV1BloHo//rHj0mC7ubuhqwIu5ONSquA63RK5t9eSOUkbtNhKtaMRxej1qMALz5Wu
         8C4g==
X-Gm-Message-State: AOAM531n3RGXy4pGJJ7Iubwgo1KeKdiwE2ViGtRzbPoENSFSEKOXM3/8
        kA8Ks94o0FTzHPnt1nmfGfwPt7wXgrvpc3+l
X-Google-Smtp-Source: ABdhPJznpkWgWSWfkzMwv0VpzZgWSJBgRHWFEHdxmSLkghenNxBpL5IOYwSWkReKju++KdAS8Xp98A==
X-Received: by 2002:a92:cd86:: with SMTP id r6mr22814123ilb.149.1637858550271;
        Thu, 25 Nov 2021 08:42:30 -0800 (PST)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id b8sm1956625iow.2.2021.11.25.08.42.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Nov 2021 08:42:29 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 5.16-rc3
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
Message-ID: <e3595b67-d7f5-895f-4cbf-0a6b1456e39d@kernel.dk>
Date:   Thu, 25 Nov 2021 09:42:29 -0700
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

A locking fix for link traversal, and fixing up an outdated function
name in a comment.

Please pull!


The following changes since commit fa55b7dcdc43c1aa1ba12bca9d2dd4318c2a0dbf:

  Linux 5.16-rc1 (2021-11-14 13:56:52 -0800)

are available in the Git repository at:

  git://git.kernel.dk/linux-block.git tags/io_uring-5.16-2021-11-25

for you to fetch changes up to 674ee8e1b4a41d2fdffc885c55350c3fbb38c22a:

  io_uring: correct link-list traversal locking (2021-11-22 19:31:54 -0700)

----------------------------------------------------------------
io_uring-5.16-2021-11-25

----------------------------------------------------------------
Kamal Mostafa (1):
      io_uring: fix missed comment from *task_file rename

Pavel Begunkov (1):
      io_uring: correct link-list traversal locking

 fs/io_uring.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

-- 
Jens Axboe

