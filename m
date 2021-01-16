Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD19A2F8E85
	for <lists+io-uring@lfdr.de>; Sat, 16 Jan 2021 19:04:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726788AbhAPSDm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 16 Jan 2021 13:03:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726114AbhAPSDl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 16 Jan 2021 13:03:41 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C995C061573
        for <io-uring@vger.kernel.org>; Sat, 16 Jan 2021 10:03:01 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id m5so7081219pjv.5
        for <io-uring@vger.kernel.org>; Sat, 16 Jan 2021 10:03:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=kYrbwibpVBt+E5frdD1+JweQ3spXzhY2ox1YuOkwhNs=;
        b=tKeRH0qQOXpSC0HEAZnpd8wJGsB37CN7dj2ot+StUmw89V1o8+nAJ6Fy+O/tMTrkPF
         uUzuRKlfxavAJRQk+F8fF8xvMk/rd59oBNT5rJKdv/V+EttbupHnr/XQe8auB/Hettl0
         RUOZ4bdMhU2rcYTQhEJkuGShE46xiKDScHq8XhfB+ZktoUZfC6Uk7gIgfs0Kb/i700pj
         fHU0rfgQVwa6eLKYEyh6CxQoNV46jEbYAWX7fp9ScE3OR6+G7n2I7u6HW1PDzVDWcs7x
         WLoG4FHhIYanaNfN+K7prOxL8WaNNhyDHq+jOJ2KlBO7JXlmk19TvQsyIsdMQEgrzXh1
         sseQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=kYrbwibpVBt+E5frdD1+JweQ3spXzhY2ox1YuOkwhNs=;
        b=ir4MxVYubmeL3pXb1xCn64e6OzeGMlNTk0LjF+CDSP0SrV85jdPRkV+4I4SkH7bmWE
         z4MoQHY7YduzBAwCL0RH0S+dqiJkbZANL3yxsYep/SlZMPfShxSCR7aMGl4rfuB8yMTK
         d+osDU95zpz7vLUB8SAIvsCePt+yUwGypCxoZypnE62nfSckiGXWzyTQGeanvhBE0q4q
         yG1WYrYyahAvTlF2GO2rGPHHIAgxHOptAywxcCxssG69Qn4LrM/7EtgFc/uQet3J3HbB
         kfJEDK5eYQT+bc0XCZL/InQQjFkf2C97hVHzIlojZnMo38qI2rtyuOLxzH3mb3p0vvUW
         oy/Q==
X-Gm-Message-State: AOAM530qDIECByemvhVEgi8u6G4J11TC+lizUbsU5tzXPByq78i4/mG/
        pBLiU84PhZPhPaTXN75aChT18JnFGmIpww==
X-Google-Smtp-Source: ABdhPJz/SGHA7mpXmP7WICiHKwIA5p79EfFfa3Mh7+vwOsEhILWwWVp2gnLE1Ef+YsvysKaDClXM8A==
X-Received: by 2002:a17:90b:4c8c:: with SMTP id my12mr1377483pjb.29.1610820180265;
        Sat, 16 Jan 2021 10:03:00 -0800 (PST)
Received: from [192.168.4.41] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id 14sm11532397pfy.55.2021.01.16.10.02.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Jan 2021 10:02:59 -0800 (PST)
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 5.11-rc4
Message-ID: <bbee0141-5923-161f-d8ca-92f5b5da99f5@kernel.dk>
Date:   Sat, 16 Jan 2021 11:02:58 -0700
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

We still have a pending fix for a cancelation issue, but it's still
being investigated and the plan is for that to hit 5.11-rc5. Changes in
this pull request:

- Dead mm handling fix (Pavel)

- SQPOLL setup error handling (Pavel)

- Flush timeout sequence fix (Marcelo)

- Missing finish_wait() for one exit case

Please pull!


The following changes since commit d9d05217cb6990b9a56e13b56e7a1b71e2551f6c:

  io_uring: stop SQPOLL submit on creator's death (2021-01-09 09:21:43 -0700)

are available in the Git repository at:

  git://git.kernel.dk/linux-block.git tags/io_uring-5.11-2021-01-16

for you to fetch changes up to a8d13dbccb137c46fead2ec1a4f1fbc8cfc9ea91:

  io_uring: ensure finish_wait() is always called in __io_uring_task_cancel() (2021-01-15 16:04:23 -0700)

----------------------------------------------------------------
io_uring-5.11-2021-01-16

----------------------------------------------------------------
Jens Axboe (1):
      io_uring: ensure finish_wait() is always called in __io_uring_task_cancel()

Marcelo Diop-Gonzalez (1):
      io_uring: flush timeouts that should already have expired

Pavel Begunkov (4):
      io_uring: drop mm and files after task_work_run
      io_uring: don't take files/mm for a dead task
      io_uring: fix null-deref in io_disable_sqo_submit
      io_uring: do sqo disable on install_fd error

 fs/io_uring.c | 46 +++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 41 insertions(+), 5 deletions(-)

-- 
Jens Axboe

