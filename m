Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3466D1C20EA
	for <lists+io-uring@lfdr.de>; Sat,  2 May 2020 00:52:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726045AbgEAWwn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 1 May 2020 18:52:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726892AbgEAWwm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 1 May 2020 18:52:42 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E31CC061A0C
        for <io-uring@vger.kernel.org>; Fri,  1 May 2020 15:52:41 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id hi11so487242pjb.3
        for <io-uring@vger.kernel.org>; Fri, 01 May 2020 15:52:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=Oo7oEIWf5cHJGiBhP9YTwfodKyiEwR4VKWpfXgwUrfg=;
        b=q2RfUtcNyhnp0bhQcbep8DDU/VIxp+z1RpB0ypZK2ytXGwqogalcYe2khi0yRJSbTW
         4ru7cB/Drjufc4s9cqYxr7dtUE7dryQ6mwGBbIRE/xE48t1xWNjMZ5ZIjkWImLotctOO
         xa8WmimoVGAHwNFgcjXP1Rms5GQBoLarwE3+WOxJsGl7upZJvWI5Lwm22y0WW4yadcwo
         MUJOI/c861eRmkvQR7spmx+bvllpntM00oZCjCDEWYCKMf8rhSz0BtvE0gaMa1hW4jol
         StZq4IElQi2GFR0/ed+Xjaj4v0V0iIteGRxnAa+Vw7cdDIIenswrGi9k+IadnVZssoiE
         MuoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=Oo7oEIWf5cHJGiBhP9YTwfodKyiEwR4VKWpfXgwUrfg=;
        b=S1CxI4RdszT07FLleXX6rAzwwH/TknFACn6V5kknesD0zHJQV9/sSwIMIl+2GlaF9N
         mpSwMbVd0gTijITdQhJgkHjZIp/m3ij3eV8h4/z6TKgrsj+Xrn7QTFlPiCI2UAUIc0/Q
         LIeXs4iEjWSVrP5kpunql6GUKBQd3sXgi7FJViXm+K+aqzPaM6UFRzO/3wtLTTOvkgPP
         zjR2WMopTb4TELEiNiRKngjeh7TNn6Vshp7ncYgHHHTwYpmm6dJso7F7I/Ou+pYs/K5y
         0UyqOWbPIPugvL7OVaOLXsk1PKjBkoNSC3zRG6LZFcUCCQvmiR0/i7d/cdBU/N2byshr
         3QvA==
X-Gm-Message-State: AGi0PubUZLeaN3knDlDlV6mdiiIl9NByv3YpGgzDVKRRgUdkRW1AFJ7k
        oCil4caHm+MQGUAerzItTbh44Q==
X-Google-Smtp-Source: APiQypJTM83VrO1CkIeKN1Oi0MuOOSDbESYTO1RFRcvPs46iPUp33BuCer2qzmD5aHP+mOOLPx3+5A==
X-Received: by 2002:a17:90a:1983:: with SMTP id 3mr2238833pji.48.1588373560506;
        Fri, 01 May 2020 15:52:40 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id o68sm3065890pfb.206.2020.05.01.15.52.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 May 2020 15:52:39 -0700 (PDT)
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 5.7-rc4
Message-ID: <8bd7dea4-76f7-cb50-7658-3a3d50539edf@kernel.dk>
Date:   Fri, 1 May 2020 16:52:38 -0600
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

- Fix for statx not grabbing the file table, making AT_EMPTY_PATH fail

- Cover a few cases where async poll can handle retry, eliminating the
  need for an async thread

- fallback request busy/free fix (Bijan)

- syzbot reported SQPOLL thread exit fix for non-preempt (Xiaoguang)

- Fix extra put of req for sync_file_range (Pavel)

- Always punt splice async. We'll improve this for 5.8, but wanted to
  eliminate the inode mutex lock from the non-blocking path for 5.7
  (Pavel)

Please pull!


  git://git.kernel.dk/linux-block.git tags/io_uring-5.7-2020-05-01


----------------------------------------------------------------
Bijan Mottahedeh (1):
      io_uring: use proper references for fallback_req locking

Jens Axboe (3):
      io_uring: statx must grab the file table for valid fd
      io_uring: enable poll retry for any file with ->read_iter / ->write_iter
      io_uring: only force async punt if poll based retry can't handle it

Pavel Begunkov (3):
      io_uring: fix extra put in sync_file_range()
      io_uring: check non-sync defer_list carefully
      io_uring: punt splice async because of inode mutex

Xiaoguang Wang (1):
      io_uring: use cond_resched() in io_ring_ctx_wait_and_kill()

 fs/io_uring.c | 58 +++++++++++++++++++++++++++++++---------------------------
 1 file changed, 31 insertions(+), 27 deletions(-)

-- 
Jens Axboe

