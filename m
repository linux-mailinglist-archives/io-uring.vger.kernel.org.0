Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 811753530A0
	for <lists+io-uring@lfdr.de>; Fri,  2 Apr 2021 23:15:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235140AbhDBVP6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 2 Apr 2021 17:15:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234856AbhDBVP6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 2 Apr 2021 17:15:58 -0400
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B619C0613E6
        for <io-uring@vger.kernel.org>; Fri,  2 Apr 2021 14:15:56 -0700 (PDT)
Received: by mail-oi1-x234.google.com with SMTP id v25so6029778oic.5
        for <io-uring@vger.kernel.org>; Fri, 02 Apr 2021 14:15:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=HVKn9F/OrP058d5IcK8zEvAc6q4DWNXl5hnKmLzdMZw=;
        b=q4FqHmNU4hDzyGl6oVamowcbVKk5ekf85HVlFpB0+cz6tZxWcpU2IcDdhclYu3BmLA
         JtMcolTtWhSA2RUpGUPIy+PG+K5pNPUmm5nattW57kmDx/9pA04WKuRa1wH4W5KM3ILG
         RrxHFvl+Y/Y0szN9LOGyEOIzeI6Y5F1uEu967eVJ1PSBHUheegMNrpL0kViebmhFUp5J
         zwdv77QHt7oEz9xkE18NgwKfX9WYCoe1GNvS59J0I3Aq+UtFlWrhuP6CO3n/Fw3p6CJD
         EDhlduVSDMVf833FeZTqNTI8TDFMIwekqsz+KWVpJSn7LxcgEnHgnfrQWxB4b22QnilH
         AlOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=HVKn9F/OrP058d5IcK8zEvAc6q4DWNXl5hnKmLzdMZw=;
        b=Gm9lXLVK7meLBmsyAAXuYQupoxboJPuNmGZpsRgsYpG7Y3RY5csIuhL4f9VDC5Mx6L
         eCyAPUQw0oCVo01j5AgjCNzfqPlqS4xVA6E7i+iA8/dyriaYTOUwlojwrQGIkh4U1k2O
         H2Rk5+fLym3InSVsYzWZJ0RXvsn/kn3JWLaW/IhzUP4cpWwTr6ss/ovS53NoLCRrdmOq
         gU4jX1leZvplcNZWjfs8/Zxsb95VJf3LZb1Z6M7q2liJpgQ4zi9SWTqfiF1eKn83eCCe
         JFxiRiGkdyjq9W/pd4/+Qz4ylBcZCsnta53c/oPoxcjKSmXJSzEUi8qR6FHPap4u2xQC
         nQ3A==
X-Gm-Message-State: AOAM5319VBT6wXkcsWCejA3pGbXmT6OmTJk1h5GcFJfTCXcLNjxVjxIu
        56B0MsxNnpXOgfbKoKRKiVarGajvOedNSw==
X-Google-Smtp-Source: ABdhPJwTJkuTzVrT5DnSlIGJ5SfYCqS9VRqUBEsTss5e3ns5OYLFqe4wU02YM5llylSsaqgPq2Hwrw==
X-Received: by 2002:a54:4184:: with SMTP id 4mr10994672oiy.72.1617398155696;
        Fri, 02 Apr 2021 14:15:55 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.233.147])
        by smtp.gmail.com with ESMTPSA id e15sm2023702otk.64.2021.04.02.14.15.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Apr 2021 14:15:55 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 5.12-rc6
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
Message-ID: <3c05aa2a-3f31-4039-caac-b6c07ddd290a@kernel.dk>
Date:   Fri, 2 Apr 2021 15:15:54 -0600
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

Nothing really major in here, and finally nothing really related to
signals. A few minor fixups related to the threading changes, and some
general fixes, that's it.

There's the pending gdb-get-confused-about-arch, but that's more of a
cosmetic issue, nothing that hinder use of it. And given that other
archs will likely be affected by that oddity too, better to postpone any
changes there until 5.13 imho.

This pull request contains:

- Combine signal checking for SQPOLL with parking, as we need to have
  the sqd lock dropped for both cases.

- S_ISBLK read/writes are bounded work, they were mistakenly bundled as
  unbounded.

- Move IO reissue for reg/blk into the read/write part itself, making it
  just be like -EAGAIN retries.

- Cancelation tightening

- Fix for a silly issue introduced with a prior fix this merge window,
  where a failed ring setup could lead to a crash.

- Ensure that we don't overflow ->comm with 10 billion PIDs

- Fix for an iov_iter revert issue earlier in this release.

Please pull!


The following changes since commit 2b8ed1c94182dbbd0163d0eb443a934cbf6b0d85:

  io_uring: remove unsued assignment to pointer io (2021-03-27 14:09:11 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux-block.git tags/io_uring-5.12-2021-04-02

for you to fetch changes up to 230d50d448acb6639991440913299e50cacf1daf:

  io_uring: move reissue into regular IO path (2021-04-02 09:24:20 -0600)

----------------------------------------------------------------
io_uring-5.12-2021-04-02

----------------------------------------------------------------
Jens Axboe (3):
      io_uring: drop sqd lock before handling signals for SQPOLL
      io_uring: don't mark S_ISBLK async work as unbounded
      io_uring: move reissue into regular IO path

Pavel Begunkov (4):
      io_uring: always go for cancellation spin on exec
      io_uring: handle setup-failed ctx in kill_timeouts
      io_uring/io-wq: protect against sprintf overflow
      io_uring: fix EIOCBQUEUED iter revert

 fs/io-wq.c    |  4 ++--
 fs/io_uring.c | 50 ++++++++++++++++++++++++++++++--------------------
 2 files changed, 32 insertions(+), 22 deletions(-)

-- 
Jens Axboe

