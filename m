Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91D0946000E
	for <lists+io-uring@lfdr.de>; Sat, 27 Nov 2021 17:06:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349351AbhK0QJz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 27 Nov 2021 11:09:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355406AbhK0QHy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 27 Nov 2021 11:07:54 -0500
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38C66C06174A
        for <io-uring@vger.kernel.org>; Sat, 27 Nov 2021 08:04:40 -0800 (PST)
Received: by mail-io1-xd2c.google.com with SMTP id m9so15420305iop.0
        for <io-uring@vger.kernel.org>; Sat, 27 Nov 2021 08:04:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=uORRXo3QDjnE640eufO8aomunRys8JwIfvGEaYgUI7A=;
        b=cXKKGW6Myj34mFiw/KbMHyzT+mwuH+G/9aXkv34nkAdP5HyDypFCpWxyh2yw4VkkoC
         +pu7kgeoSRR66sEAgvDpa90e8nI1eDepH+bkAXLTaXrWYyaUAdptaNm/0w8pl/ZWjGPy
         nu0gApdXDGBQh7R/LY4pf3F7ggw221hKUDUQH0kVaVSXpfvYXbmr4c9SPR6zd6oQhiPr
         n3wwqqlyHUTPLkpByoGtDwj0XkpFbBK5YJGEIBHGCYa5h8h1n5WhZueOeOXsCzyNHIOx
         ksN54bxnQtmhj+lT4dyheMGFZu1uExMYstxWvXAPaOuHPi87mRSEaFcwAFn8kVhiF+Ed
         sU1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=uORRXo3QDjnE640eufO8aomunRys8JwIfvGEaYgUI7A=;
        b=AV6cZ8bQe11AMAw/oQ4DHVG8uJD07RboTL3WvYVZ9GM9cYcHosmquPu55bOotmJWi4
         7aySpLp9qOQtwESzvPXl4uDCI9N8aEzrNcoGOLvtfM36ROFDwvntil1Z2sOv6dT4gLN0
         JlfbODiaXTo3FPeGQTS821EMLqswIw3plvfDgpi5tKetT91kzTBaydGoZ/hB8sxQGD6u
         S7mltx6Gp4zQO1/w0tSqs5rlRyp7iIVqSCdl72zzQjl6mTVRvS0/kabwpec4lFSHWWIZ
         CXy0LJAooGNw3Dt8EYeyUrDqI3B6MXVkrC5dkloQOyKiMR03dOX6i6JnscrT1JkWIVGX
         4R8A==
X-Gm-Message-State: AOAM533Nyv8p42GzIJ/MnxUo/DVCPqLEB39AygbeD7DrpnCF8e2UIZfl
        fn/bxVZTknk7xdAobVnYwnYq2fVVxfVNYMXn
X-Google-Smtp-Source: ABdhPJy/M+YAgapm6xePMUEsV53tHI/7iTWANU3mRxD8WTEl9ZQYQnWwxGwWBgoAAvR9Lcucurj6Ow==
X-Received: by 2002:a05:6602:1686:: with SMTP id s6mr48163253iow.186.1638029078869;
        Sat, 27 Nov 2021 08:04:38 -0800 (PST)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id z12sm2718835ilu.27.2021.11.27.08.04.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 27 Nov 2021 08:04:37 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] Followup io_uring fixes for 5.16-rc3
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
Message-ID: <45a2054b-0b02-c0c8-1c62-89e204144701@kernel.dk>
Date:   Sat, 27 Nov 2021 09:04:37 -0700
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

The locking fixup that was applied earlier this rc has both a deadlock
and IRQ safety issue, let's get that ironed out before -rc3. This pull
request contains:

- Link traversal locking fix (Pavel)

- Cancelation fix (Pavel)

- Relocate cond_resched() for huge buffer chain freeing, avoiding a
  softlockup warning (Ye)

- Fix timespec validation (Ye)

Please pull!


The following changes since commit 674ee8e1b4a41d2fdffc885c55350c3fbb38c22a:

  io_uring: correct link-list traversal locking (2021-11-22 19:31:54 -0700)

are available in the Git repository at:

  git://git.kernel.dk/linux-block.git tags/io_uring-5.16-2021-11-27

for you to fetch changes up to f6223ff799666235a80d05f8137b73e5580077b9:

  io_uring: Fix undefined-behaviour in io_issue_sqe (2021-11-27 06:41:38 -0700)

----------------------------------------------------------------
io_uring-5.16-2021-11-27

----------------------------------------------------------------
Pavel Begunkov (2):
      io_uring: fail cancellation for EXITING tasks
      io_uring: fix link traversal locking

Ye Bin (2):
      io_uring: fix soft lockup when call __io_remove_buffers
      io_uring: Fix undefined-behaviour in io_issue_sqe

 fs/io_uring.c | 73 ++++++++++++++++++++++++++++++++++++++++-------------------
 1 file changed, 50 insertions(+), 23 deletions(-)

-- 
Jens Axboe

