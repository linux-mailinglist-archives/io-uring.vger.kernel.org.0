Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0AE065238E
	for <lists+io-uring@lfdr.de>; Tue, 20 Dec 2022 16:17:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232021AbiLTPRc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 20 Dec 2022 10:17:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229684AbiLTPRb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 20 Dec 2022 10:17:31 -0500
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1D1B1B1E2
        for <io-uring@vger.kernel.org>; Tue, 20 Dec 2022 07:17:28 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id g20so6511011iob.2
        for <io-uring@vger.kernel.org>; Tue, 20 Dec 2022 07:17:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v7elrfLpCWCF4ewuKOvdbeK60rEKoyLxiXaItCnV1jw=;
        b=aqBp6NH6J6e6eAO3A5ZT4mkK1aQKYdKxzzlRErOlTPRDImpUY0NuZN8K9Rou1SJMiQ
         JYrvMaThN9KaLczIwS9z+h+Z4mZG1KOE4zj2ALc48G9e88rU9C56VZGWHRVmwoX1xF6o
         msF/pIIDlEVF71mlz4zsQFvUkQ0TUXw00RMiHM2nVVeczK9EbLQvHknVuOe0loNMvl1T
         GBQYwyzXG4xcbZdmOPTdM77sAzMaM2Jn0RSPHYKMk21vUoHgNsK7cOxbbM2pGjZy/Il9
         rB2pFA5I0WCVi34q2586BebXhDc5L8Hph1n2CpyapR5bBxiWOT/uCpGNBsfb+1Pxrj4O
         Kj2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=v7elrfLpCWCF4ewuKOvdbeK60rEKoyLxiXaItCnV1jw=;
        b=CLv5IhYJvXaMT1mnYmxhl7ynWEtsMWccZhfKhA6yrmk/nT8ZZvO9I7wejiU4z3MFaY
         DdDXJE/x331uLJcUtxuosgX6xJTY7rj/eAY7F6XW+pRtsgkjScf+OEZ4Qm3259l1Fzzu
         Q+598lWRPx9oO1viWAaY5cgxIwqZIIyZVKPKAy/sxXOSlftE8YCz/ZKTihqvgHZ94eOx
         VqePxivj4OhqKTvjNB7izeGZqDXvTgRCgtls2GEhNG9E3Pam4AuduXuSFFby8PTyXEVI
         pG3+IL7Lp0ILozSGW0qAW5NybvmE1CnEdIdzvZdReIQcBXDhH09/R/HSDVgF5QcTWEa/
         5E2Q==
X-Gm-Message-State: ANoB5pmJ3/9b2o9yJbtb8bKWuTXWMemHlMXkXTAXt7qRtXzM8LukCa/e
        A/Tm/Uj9DsrYEtEw0Wx8BurG0qUruwT97XyjihI=
X-Google-Smtp-Source: AA0mqf6TeoC0ibgGjKR2PDbSr8GLO2+L8ErFWcJlVc4TTjn1CWF4n9TT2QpRUUyc+zaoGIRjvyeIOA==
X-Received: by 2002:a6b:7411:0:b0:6e2:d6ec:21f8 with SMTP id s17-20020a6b7411000000b006e2d6ec21f8mr4990506iog.2.1671549447915;
        Tue, 20 Dec 2022 07:17:27 -0800 (PST)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id w15-20020a5d844f000000b006eacd57d40csm3259052ior.28.2022.12.20.07.17.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Dec 2022 07:17:27 -0800 (PST)
Message-ID: <859cfac9-d8e1-23cb-0ca7-d43964ca2f75@kernel.dk>
Date:   Tue, 20 Dec 2022 08:17:26 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] Followup io_uring fixes for 6.2-rc1
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

Sending this out early as I'll generally be unavailable from today and
until the end of the holiday break. Nothing else is known or pending at
this time, so should work out fine (knock wood).

In this pull request:

- A series of 4 patches improving the locking for timeouts. This was
  originally queued up for the initial pull, but I messed up and it got
  missed. (Pavel)

- Small 2 part series fixing an issue with running task_work from the
  wait path, causing some inefficiencies (me)

- Add a clear of ->free_iov upfront in the 32-bit compat data importing,
  so we ensure that it's always sane at completion time (me)

- Use call_rcu_hurry() for the eventfd signaling (Dylan)

- Ordering fix for multishot recv completions (Pavel)

- Add the io_uring trace header to the MAINTAINERS entry (Ammar)

Please pull!


The following changes since commit e2ca6ba6ba0152361aa4fcbf6067db71b2c7a770:

  Merge tag 'mm-stable-2022-12-13' of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm (2022-12-13 19:29:45 -0800)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/io_uring-6.2-2022-12-19

for you to fetch changes up to 5ad70eb27d2b87ec722fedd23638354be37ea0b0:

  MAINTAINERS: io_uring: Add include/trace/events/io_uring.h (2022-12-19 09:56:09 -0700)

----------------------------------------------------------------
io_uring-6.2-2022-12-19

----------------------------------------------------------------
Ammar Faizi (1):
      MAINTAINERS: io_uring: Add include/trace/events/io_uring.h

Dylan Yudaken (1):
      io_uring: use call_rcu_hurry if signaling an eventfd

Jens Axboe (3):
      io_uring: don't use TIF_NOTIFY_SIGNAL to test for availability of task_work
      io_uring: include task_work run after scheduling in wait for events
      io_uring/net: ensure compat import handlers clear free_iov

Pavel Begunkov (5):
      io_uring: protect cq_timeouts with timeout_lock
      io_uring: revise completion_lock locking
      io_uring: ease timeout flush locking requirements
      io_uring: fix overflow handling regression
      io_uring/net: fix cleanup after recycle

 MAINTAINERS         |  1 +
 io_uring/io_uring.c | 40 ++++++++++++++++++++++++++++++----------
 io_uring/io_uring.h | 14 +-------------
 io_uring/net.c      |  3 ++-
 io_uring/rw.c       |  2 +-
 io_uring/timeout.c  | 14 +++++++++-----
 6 files changed, 44 insertions(+), 30 deletions(-)

-- 
Jens Axboe

