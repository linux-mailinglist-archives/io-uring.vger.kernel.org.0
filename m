Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A42C2F0862
	for <lists+io-uring@lfdr.de>; Sun, 10 Jan 2021 17:24:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726394AbhAJQY3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 10 Jan 2021 11:24:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726265AbhAJQY3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 10 Jan 2021 11:24:29 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87ADBC061786
        for <io-uring@vger.kernel.org>; Sun, 10 Jan 2021 08:23:48 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id a188so9475723pfa.11
        for <io-uring@vger.kernel.org>; Sun, 10 Jan 2021 08:23:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=TkT4EuSVg1LuipmzFJKdajnCY0J5Q7NtDi5IzjyWdJk=;
        b=gKSKhcBvQTqfvqv71eJqoNWe81WP1qN3fO30kzpS24X08PGy0VE8UX8fnIiAh8SIMP
         Xcp8d48W5Y3LYpkyML62yiWF2HSTbiil79zk8/MFSycwC1OFEvU3wZnXkf7Py119J40i
         K00pyb8xPloCPBzh1xvL2yEY8ZVj7E3C6egsrFB8wXGOw/KCgT1RinI3USYItHYG9zLt
         LRxlL9fOGjUsfZaA7+q1FasemQGbzq8USDYMcGNvOQgItxsrt3eQ0jZqLPeDUTdcQM+r
         JgdFyZ0HH61qZNzQ/+isrpiD9ny8qfNlGYUPduZm4zd8tWBl9qMoxc3AVHWvpFY+YGfs
         hL8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=TkT4EuSVg1LuipmzFJKdajnCY0J5Q7NtDi5IzjyWdJk=;
        b=UTEv6NGTFVchzHWhpOI4E8GbOLPiuPNaHJFAqW5675xzbCevHLJbq8KIDiMYf6jGkH
         ZpD4WjTd8I5P8uBnZOWIfW06RnUkdduyUWEX6DXMTvSd8OC2JdHZH8ZvPJmgkSBfs2zs
         g/cWUnE8mxrZrODkHg+YW30omRafS9eqOhAf3DO8LaSvbHlOMs70rrvWKIOONC80NKIa
         0IGsaVijSE+zuODrI+McZvTfw340ZWldIVvuttePOItfkbRBJE//uiKWd9sne1vpMnPH
         WRZpzGuGk4phYOEmX8boL5GUEqbslvNp+JVbhFhGmRL29r9b2aB9oP6nowwSmXNq3HoP
         pNNA==
X-Gm-Message-State: AOAM530pV3OCe/SJ9RI5OxvrDJuSz3oVyOgpPW007S+a2LQU0oHJrahW
        B3gumnyXLTKTgljc1TgBj3KqJwyc44uYbQ==
X-Google-Smtp-Source: ABdhPJyGmfLtxx8rXSSZ1gFDx28EO/tWLWP/p2PfWAczl0Nvbgtpv6fQKj9OCtFmlUyJC+BU790/kQ==
X-Received: by 2002:aa7:96d8:0:b029:19e:bc79:cf7 with SMTP id h24-20020aa796d80000b029019ebc790cf7mr16071571pfq.22.1610295827623;
        Sun, 10 Jan 2021 08:23:47 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id r185sm16164561pfc.53.2021.01.10.08.23.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 10 Jan 2021 08:23:47 -0800 (PST)
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 5.11-rc3
Message-ID: <c394c8fa-f1e2-38a6-4227-4336273cf80d@kernel.dk>
Date:   Sun, 10 Jan 2021 09:23:46 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Linus,

A bit larger than I had hoped at this point, but it's all changes that
will be directed towards stable anyway. In detail:

- Fix a merge window regression on error return (Matthew)

- Remove useless variable declaration/assignment (Ye Bin)

- IOPOLL fixes (Pavel)

- Exit and cancelation fixes (Pavel)

- fasync lockdep complaint fix (Pavel)

- Ensure SQPOLL is synchronized with creator life time (Pavel)

Please pull!


The following changes since commit b1b6b5a30dce872f500dc43f067cba8e7f86fc7d:

  kernel/io_uring: cancel io_uring before task works (2020-12-30 19:36:54 -0700)

are available in the Git repository at:

  git://git.kernel.dk/linux-block.git tags/io_uring-5.11-2021-01-10

for you to fetch changes up to d9d05217cb6990b9a56e13b56e7a1b71e2551f6c:

  io_uring: stop SQPOLL submit on creator's death (2021-01-09 09:21:43 -0700)

----------------------------------------------------------------
io_uring-5.11-2021-01-10

----------------------------------------------------------------
Matthew Wilcox (Oracle) (1):
      io_uring: Fix return value from alloc_fixed_file_ref_node

Pavel Begunkov (11):
      io_uring: synchronise IOPOLL on task_submit fail
      io_uring: patch up IOPOLL overflow_flush sync
      io_uring: drop file refs after task cancel
      io_uring: cancel more aggressively in exit_work
      io_uring: trigger eventfd for IOPOLL
      io_uring: dont kill fasync under completion_lock
      io_uring: synchronise ev_posted() with waitqueues
      io_uring: io_rw_reissue lockdep annotations
      io_uring: inline io_uring_attempt_task_drop()
      io_uring: add warn_once for io_uring_flush()
      io_uring: stop SQPOLL submit on creator's death

Ye Bin (1):
      io_uring: Delete useless variable ‘id’ in io_prep_async_work

 fs/io_uring.c | 256 ++++++++++++++++++++++++++++++++++++++--------------------
 1 file changed, 167 insertions(+), 89 deletions(-)

-- 
Jens Axboe

