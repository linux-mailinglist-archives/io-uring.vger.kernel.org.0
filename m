Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9BE76A976D
	for <lists+io-uring@lfdr.de>; Fri,  3 Mar 2023 13:45:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbjCCMp0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 3 Mar 2023 07:45:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbjCCMp0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 3 Mar 2023 07:45:26 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FE14199CD
        for <io-uring@vger.kernel.org>; Fri,  3 Mar 2023 04:45:24 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id qa18-20020a17090b4fd200b0023750b675f5so5997382pjb.3
        for <io-uring@vger.kernel.org>; Fri, 03 Mar 2023 04:45:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1677847523;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0lLrk7adDwvnYuhyl+KwSXKzVcZaJp8VKSna+jCygnU=;
        b=nWg69VK2/5Y8bK2Cez+b/J5m7yRhQb5j/YRiOomLT0rN4hZcPneCInUe50zzqMtbw5
         h5fCdMyOKfGgw/Go6DW3eIBGZJxWlFlIMk/eUB3xqikKQNduy492myJOKMdQ0Cyi2Zjq
         97UpkmGg8DkMmlmQrqDbeK5AM9d/uMi49iEJF1L71ywz00crXPSD/s9R9hoL9dU2E4v9
         2UizxlULHxhBbk76b8MberZVAFcVIb+MkcRcMgYwCiuTlykKokzKzpV89T1dbXtioDGa
         FxzNJYoY2l54eH2XR7NigWsvENlS7yHNWuNUR5IJKQ+bgLOV9wEykISkuwwRhqf5m3O1
         VMPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677847523;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=0lLrk7adDwvnYuhyl+KwSXKzVcZaJp8VKSna+jCygnU=;
        b=zsqVJFtzXDG8i/22OZfxfVit/cKWqZRPo5fvQ7yMSNouWypQwT9/LvV99Iw+FJ935z
         mJuvhQRCbcx7xbvhTleFpxXgfKtEKIXQOzLic/8WIOntCv52PgXUJzeRcyTvy5/xtxVX
         olqyAtYt15m0eVqdDIVnusinVG8zZS4if8J4u4q8QqGNG8QX4Xif5OaM6VfmsmRJbyEb
         8BVRy4UgoHNjtdVhTg2F1Xg+68t/X3J6vY1y1qlCYms+jFWpHjLGX/e8yEK+X3EODSIz
         VEFzvxqK2ie7z63RowS3w9F5UhmgKKKes3qxyI+QMWKRXi1OKuUpVl0MshNwymEtGfux
         JBgw==
X-Gm-Message-State: AO0yUKX3HfkVsziZVFMCMyZdbJ6d/QarqpmGjmwNDfKxTGuWmR9CLNLd
        kUi9N4F6/DutC2gNXUJ7NW6RwrvPPAvZv3ph
X-Google-Smtp-Source: AK7set/C2jHwvIxwxAHwPqLHpXYRFKgEg9wp0Qc+/DYnCMwKfUr2uD48wRErEsmcPB6itrk1nJwzjA==
X-Received: by 2002:a17:902:dad0:b0:19a:af51:c27b with SMTP id q16-20020a170902dad000b0019aaf51c27bmr1944529plx.2.1677847523417;
        Fri, 03 Mar 2023 04:45:23 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id lg3-20020a170902fb8300b0019e8f5acadasm1217684plb.306.2023.03.03.04.45.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Mar 2023 04:45:23 -0800 (PST)
Message-ID: <f3997846-ea56-917c-b8b0-fd8db730f20c@kernel.dk>
Date:   Fri, 3 Mar 2023 05:45:22 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] Followup io_uring fixes for 6.3-rc1
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

Here's a set of fixes/changes that didn't make the first cut, either
because they got queued before I sent the early merge request, or fixes
that came in afterwards. In detail:

- Don't set MSG_NOSIGNAL on recv/recvmsg opcodes, as AF_PACKET will
  error out (David)

- Fix for spurious poll wakeups (me)

- Fix for a file leak for buffered reads in certain conditions (Joseph)

- Don't allow registered buffers of mixed types (Pavel)

- Improve handling of huge pages for registered buffers (Pavel)

- Provided buffer ring size calculation fix (Wojciech)

- Minor cleanups (me)

Please pull!


The following changes since commit 5b7c4cabbb65f5c469464da6c5f614cbd7f730f2:

  Merge tag 'net-next-6.3' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next (2023-02-21 18:24:12 -0800)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/io_uring-6.3-2023-03-03

for you to fetch changes up to 1947ddf9b3d5b886ba227bbfd3d6f501af08b5b0:

  io_uring/poll: don't pass in wake func to io_init_poll_iocb() (2023-03-01 10:06:53 -0700)

----------------------------------------------------------------
io_uring-6.3-2023-03-03

----------------------------------------------------------------
David Lamparter (1):
      io_uring: remove MSG_NOSIGNAL from recvmsg

Jens Axboe (5):
      io_uring: consolidate the put_ref-and-return section of adding work
      io_uring: rename 'in_idle' to 'in_cancel'
      io_uring/rsrc: always initialize 'folio' to NULL
      io_uring/poll: allow some retries for poll triggering spuriously
      io_uring/poll: don't pass in wake func to io_init_poll_iocb()

Joseph Qi (1):
      io_uring: fix fget leak when fs don't support nowait buffered read

Pavel Begunkov (5):
      io_uring/rsrc: fix a comment in io_import_fixed()
      io_uring: remove unused wq_list_merge
      io_uring/rsrc: disallow multi-source reg buffers
      io_uring/rsrc: optimise single entry advance
      io_uring/rsrc: optimise registered huge pages

Wojciech Lukowicz (1):
      io_uring: fix size calculation when registering buf ring

 include/linux/io_uring_types.h |  2 +-
 io_uring/io_uring.c            | 32 +++++++++++------------
 io_uring/kbuf.c                |  2 +-
 io_uring/net.c                 |  2 +-
 io_uring/poll.c                | 26 ++++++++++++++-----
 io_uring/poll.h                |  1 +
 io_uring/rsrc.c                | 58 ++++++++++++++++++++++++++++++++----------
 io_uring/slist.h               | 22 ----------------
 io_uring/tctx.c                |  2 +-
 9 files changed, 85 insertions(+), 62 deletions(-)

-- 
Jens Axboe

