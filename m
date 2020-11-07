Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F3F62AA7DA
	for <lists+io-uring@lfdr.de>; Sat,  7 Nov 2020 21:14:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728631AbgKGUOC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 7 Nov 2020 15:14:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725836AbgKGUOC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 7 Nov 2020 15:14:02 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8452C0613CF
        for <io-uring@vger.kernel.org>; Sat,  7 Nov 2020 12:14:00 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id m17so1129533pjz.3
        for <io-uring@vger.kernel.org>; Sat, 07 Nov 2020 12:14:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=4wyecbVF2pa13FIUlcfG85ZA4c+nRhh836nKpeRzuO8=;
        b=tw1ZFWpqiQGFv2HqMVnkP0KAC0WP9ElFcNjZPVMwSERtDEAUND1Dfoqc8MijZnzv+M
         1MAgSXPVZ0QKEVZ/0zOzGjMXAq89ccVVRc5NJtfwhTY9cBevLgD0fEZ0sbxgJn9hEzqv
         WLHGzWDNxn4rlenG+fyDHOLo5b26RYN/pDF0YYMqkuEbD7l9bZ2O8Lla2jO4qXOYAJay
         FpQRGo7UdjT5yJidlicaZXEAiv14cSdAwtkpOr9H86KMp3OpbC1Xb2fsA07LOLkAe6xy
         k1UNLHb2/dBUebVytujjxVvTmxOUMefcMYWGKjPRjPEj8P/r2ytLsga9FkUxTP8sKk71
         0rIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=4wyecbVF2pa13FIUlcfG85ZA4c+nRhh836nKpeRzuO8=;
        b=rtEG7Ki+Alx/6uM1hA0rII+jX4G5FjNva01nushVUdUuhN3puw3OFq+d9p3r/Q/6vi
         +u4YJKeZr1IabwvygRw1Upx0Gs6oSEhZI5RzG5TYe4dCQeyNbMwrCFR1ZZ2BPd9KX2hn
         LYvY0qsrQY/oMYUElW4wb1wCgq4Pcx4grRCA9M5Nfg8fUHHHd6BlhKHGWzxcYG9+6XyZ
         Ff3N7B0ScBUhbWQylq2oYqlnDKuty3gg6Die5jFQelmKoqleAiiM/czP25GRyZkQJOBI
         JpTvS0ClBGZXE24WYyFjVFkokgST+2Bm11SklNjkN2OnaS47WES9hlF4aX4Id73tRrSn
         XipQ==
X-Gm-Message-State: AOAM533iff4GNGxTLC9cCzacZTs2i76dUENQxB2uKrn807fjkL8mu9NL
        3o77Rq3kgmvhxLp9R0I0puIEcQ==
X-Google-Smtp-Source: ABdhPJxyb0PGTiw4FXFppV6OpTw0mdRr0GT7lMRkOKzc/Oz5N2dF1OlAfD9UJttBPxr7zuL3sjSoBg==
X-Received: by 2002:a17:902:728f:b029:d6:fcbe:99c5 with SMTP id d15-20020a170902728fb02900d6fcbe99c5mr6587248pll.20.1604780039846;
        Sat, 07 Nov 2020 12:13:59 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id a123sm6501390pfd.218.2020.11.07.12.13.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 07 Nov 2020 12:13:59 -0800 (PST)
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 5.10-rc
Message-ID: <adf29460-8af3-b326-a372-2627a9097929@kernel.dk>
Date:   Sat, 7 Nov 2020 13:13:57 -0700
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

A set of fixes for io_uring that should go into this release:

- SQPOLL cancelation fixes

- Two fixes for the io_identity COW

- Cancelation overflow fix (Pavel)

- Drain request cancelation fix (Pavel)

- Link timeout race fix (Pavel)

Please pull!


The following changes since commit 3cea11cd5e3b00d91caf0b4730194039b45c5891:

  Linux 5.10-rc2 (2020-11-01 14:43:51 -0800)

are available in the Git repository at:

  git://git.kernel.dk/linux-block.git tags/io_uring-5.10-2020-11-07

for you to fetch changes up to 9a472ef7a3690ac0b77ebfb04c88fa795de2adea:

  io_uring: fix link lookup racing with link timeout (2020-11-05 15:36:40 -0700)

----------------------------------------------------------------
io_uring-5.10-2020-11-07

----------------------------------------------------------------
Jens Axboe (5):
      io-wq: cancel request if it's asking for files and we don't have them
      io_uring: properly handle SQPOLL request cancelations
      io_uring: ensure consistent view of original task ->mm from SQPOLL
      io_uring: drop req/tctx io_identity separately
      io_uring: use correct pointer for io_uring_show_cred()

Pavel Begunkov (3):
      io_uring: fix overflowed cancel w/ linked ->files
      io_uring: don't forget to task-cancel drained reqs
      io_uring: fix link lookup racing with link timeout

 fs/io-wq.c               |   4 ++
 fs/io_uring.c            | 183 +++++++++++++++++++++++++++++++++++------------
 include/linux/io_uring.h |   3 +-
 3 files changed, 142 insertions(+), 48 deletions(-)

-- 
Jens Axboe

