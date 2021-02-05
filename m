Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB1143118F6
	for <lists+io-uring@lfdr.de>; Sat,  6 Feb 2021 03:52:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230419AbhBFCvo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 5 Feb 2021 21:51:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231744AbhBFCn2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 5 Feb 2021 21:43:28 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A53BC08ED2F
        for <io-uring@vger.kernel.org>; Fri,  5 Feb 2021 15:16:47 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id 8so4316125plc.10
        for <io-uring@vger.kernel.org>; Fri, 05 Feb 2021 15:16:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=Ne3HxOiN//GmSfVBJ6qVjYA8ZJO+PXCr/s95Zv+R6Nw=;
        b=1RXXkjrfl1b1hg0gY22zIkqTQneMU8Z67VOesLqgoog33HCs+FjtJYPSnpLbRNEzYo
         zvEd00fvm6qpC2l+uZZTkfL/g6xEnBZUeGjGimKIRxrn9SjHnSYtEfzcJdKHR2XGGri9
         9z9PzlD2RoIco34zHYG08dvMu41aVEFA1trF2yfPT0D6243jx7rHNp50EObZpM/BdUOZ
         tqVXWla0wademLZs3A2wZwLOJFtITlDHXiI4VFKNwvsDeDhwgwYPUsTXJv1QZ++R0GAO
         zDIDzdQWTfVZuqS5+j6tzMbl6z1Y9ZDJSljohOMePvRb1cDWAz4+8KdNWdBitWkGddjV
         fpoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=Ne3HxOiN//GmSfVBJ6qVjYA8ZJO+PXCr/s95Zv+R6Nw=;
        b=CwisZP24lsz0ubULEAZtcjwm4GrZ4D0lSK2MZT6Pohkt/UzHUj789uCTGG8+S0hH9B
         3887kLQPG1tegDILKzjYgsz2ymJmCDVqBwQ6Fs+0bxmvnsM8mHT4tBxhVAt+93JAmSsD
         zvXf6H1yiZuR1N8034WC4MpojjJ67Avo6W6yKRlsGO6M/OkjwUxO0fZlbTko5XDMRljy
         TDZlmYLFKgy0HCoDdxvz4whSZN75F8qqMCYe9duqW8Ao/N1cy/YdQGIZgvTaU8eTaLfT
         xGyH5wb6yvsYazJT1HPdxC4pVCtw4Lx59L+YOhlJFDMxYuTnvD5hfoA44BSmh/5uOASt
         Krng==
X-Gm-Message-State: AOAM532FNvSG5570p0WpCTIkK/FbGKglcTBApywPsFKSd4RrYwgo4oyY
        zvAKpWUrYI2VQdqs50zP+jtEQSJWHL5U7w==
X-Google-Smtp-Source: ABdhPJzySOf/PhwtGgW3g3jIDJWtJird4J6u/3uYyxXLbfUx/YF4D4uQ3ej3WzuoCate1W5hpzXBkw==
X-Received: by 2002:a17:90a:ad81:: with SMTP id s1mr6144855pjq.9.1612567006640;
        Fri, 05 Feb 2021 15:16:46 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id z15sm11000068pfr.89.2021.02.05.15.16.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Feb 2021 15:16:46 -0800 (PST)
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 5.11-rc7
Message-ID: <9f56e349-4207-4668-05aa-9cabe9caa37d@kernel.dk>
Date:   Fri, 5 Feb 2021 16:16:45 -0700
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

Two small fixes that should go into 5.11:

- task_work resource drop fix (Pavel)

- identity COW fix (Xiaoguang)

Please pull!


The following changes since commit 3a7efd1ad269ccaf9c1423364d97c9661ba6dafa:

  io_uring: reinforce cancel on flush during exit (2021-01-28 17:04:24 -0700)

are available in the Git repository at:

  git://git.kernel.dk/linux-block.git tags/io_uring-5.11-2021-02-05

for you to fetch changes up to aec18a57edad562d620f7d19016de1fc0cc2208c:

  io_uring: drop mm/files between task_work_submit (2021-02-04 12:42:58 -0700)

----------------------------------------------------------------
io_uring-5.11-2021-02-05

----------------------------------------------------------------
Pavel Begunkov (1):
      io_uring: drop mm/files between task_work_submit

Xiaoguang Wang (1):
      io_uring: don't modify identity's files uncess identity is cowed

 fs/io_uring.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

-- 
Jens Axboe

