Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 020A0211B23
	for <lists+io-uring@lfdr.de>; Thu,  2 Jul 2020 06:30:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726147AbgGBEa1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 2 Jul 2020 00:30:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726072AbgGBEa0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 2 Jul 2020 00:30:26 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDA6EC08C5DB
        for <io-uring@vger.kernel.org>; Wed,  1 Jul 2020 21:30:26 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id o13so9869257pgf.0
        for <io-uring@vger.kernel.org>; Wed, 01 Jul 2020 21:30:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=YuWU5A2IqitBQEhu7RzxvcgZH9jiOWunaMDOKPdr4C8=;
        b=fIjN/ltnJT3kkTEpSLCLZGcyZLszso4xAq4nzS1PXln00egC0Zx+DhGISzCBzt8jhH
         uzNjiFb0lxo0vYW7XCBfDEAuqNW0TakRC+UMnzAhllrhEh5W+ZkUNFAK9kYLCby+wJ8i
         Ck5tWUEWPrf5nxCWu0sFFFgXtLdLOGlTbGobmQsl2xPVi7OmH2Jhh5cj2KUt3TUqrG34
         W6FcbVfC3BfnGf3CMximDi5FXEK5WvYtBANAIMB7ZfFanloz/mWGKrzlQWUQ9PUBBItf
         0P88Dxe5yNqsyhprd/Acn5zh5cajuDXA/ZnWOVqukhJfm/MTJppCPSHoAw5ljA2a4lZw
         RD5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=YuWU5A2IqitBQEhu7RzxvcgZH9jiOWunaMDOKPdr4C8=;
        b=omMnv0ylX2CStRSsrutJi7bF8eHO7IM6Y6T5rRJNwVdRkk9DppcIV+VsGGeAfLRG0i
         a/DlCfUGiRCJgjLPImAbqVmpzcz/awQoIAaBKTPXvWXBVpS+7e9SCyBsGfL5Gl4CjYHm
         C3aVY3pGihJCcTJo7PGxw4EnsAjJsut5Fj/LF7HXBzpfDZw+JuAvNZQOqhxkVi4RTuYX
         CzBVcHEmtw+QT3f4p80VMmXGudqxeUcNDIH61hwAB3lZjNksvH7eCbboAgl8PQbOXBCb
         mGRS54ZHZR1y80z/urVJVVUW2wJjYwnEVLoCDwuD3OmfCXJk90C51BQ+ELnO7IqJ8pWC
         HUiw==
X-Gm-Message-State: AOAM533M0hNOY4WnnsrnTClkEFAisNC6UV2NHTI8mCpJ8+6WNv2XyCvM
        l6/MWAFyrlPDIMe8bm7/QtjUUV8kEVarbg==
X-Google-Smtp-Source: ABdhPJy1W84Qjro6DWnqEx+YwTfLXIsNs9vkrWH8iX+a/w+C7F9p21L++ZCYkSNRgG5ej9JgiANy9g==
X-Received: by 2002:a65:6089:: with SMTP id t9mr23264258pgu.236.1593664225960;
        Wed, 01 Jul 2020 21:30:25 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:b0a2:2229:1cbe:53d2? ([2605:e000:100e:8c61:b0a2:2229:1cbe:53d2])
        by smtp.gmail.com with ESMTPSA id u25sm7221103pfm.115.2020.07.01.21.30.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Jul 2020 21:30:25 -0700 (PDT)
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 5.8-rc4
Message-ID: <ac36babd-3eb7-8f91-7ba1-e722def24b67@kernel.dk>
Date:   Wed, 1 Jul 2020 22:30:24 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Linus,

One fix in here, for a regression in 5.7 where a task is waiting in the
kernel for a condition, but that condition won't become true until
task_work is run. The task_work can't be run exactly because the task is
waiting in the kernel, so we'll never make any progress. One example of
that is registering an eventfd and queueing io_uring work, and then the
task goes and waits in eventfd read with the expectation that it'll get
woken (and read an event) when the io_uring request completes. The
io_uring request is finished through task_work, which won't get run
while the task is looping in eventfd read.

Please pull!

The following changes since commit d60b5fbc1ce8210759b568da49d149b868e7c6d3:

  io_uring: fix current->mm NULL dereference on exit (2020-06-25 07:20:43 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux-block.git tags/io_uring-5.8-2020-07-01

for you to fetch changes up to ce593a6c480a22acba08795be313c0c6d49dd35d:

  io_uring: use signal based task_work running (2020-06-30 12:39:05 -0600)

----------------------------------------------------------------
io_uring-5.8-2020-07-01

----------------------------------------------------------------
Jens Axboe (1):
      io_uring: use signal based task_work running

Oleg Nesterov (1):
      task_work: teach task_work_add() to do signal_wake_up()

 fs/io_uring.c                | 32 ++++++++++++++++++++++++--------
 include/linux/sched/jobctl.h |  4 +++-
 include/linux/task_work.h    |  5 ++++-
 kernel/signal.c              | 10 +++++++---
 kernel/task_work.c           | 16 ++++++++++++++--
 5 files changed, 52 insertions(+), 15 deletions(-)

-- 
Jens Axboe

