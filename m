Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91E473DE3D0
	for <lists+io-uring@lfdr.de>; Tue,  3 Aug 2021 03:05:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233344AbhHCBFZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 2 Aug 2021 21:05:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232891AbhHCBFY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 2 Aug 2021 21:05:24 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9F6CC06175F
        for <io-uring@vger.kernel.org>; Mon,  2 Aug 2021 18:05:13 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id u9-20020a17090a1f09b029017554809f35so1525898pja.5
        for <io-uring@vger.kernel.org>; Mon, 02 Aug 2021 18:05:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:content-transfer-encoding:mime-version:subject:message-id:date
         :cc:to;
        bh=u4t2cFBPxFa3wTtpysQS0a7+iXra1ByH+uAyVuGJpC4=;
        b=qmHlHBUlMcWgtV6FxnthE7AuY3B18oLSL3SQrhRxdwhGirRcSMRwVQ1KpcxnVIBB78
         dU5Vt69uqw7AUtABx4GhntibOuxoM1OWyiuFWOOAnqy6PGGOvkN8MKUfxP8zBHJX1jwZ
         emkIOG4NUvaLo3v0EsC/sjVreZwFP4RR3TghwCAE2oOdlJcDtngnDLoFgnceSqL4MOQX
         mKVgmnEXZ+Ne/4RwnZtt4S6sgTfaxyUnUi+8xCdjjMyPp6XvHhghtcUGypC7NMPS4AXT
         1PAnQ319PKXaGaeMUpjmvBsjjpaW4XU6MvcaNc8uqz6gTyQOtI9qwVoXZ+zyV2SEeNSQ
         9qbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:content-transfer-encoding:mime-version
         :subject:message-id:date:cc:to;
        bh=u4t2cFBPxFa3wTtpysQS0a7+iXra1ByH+uAyVuGJpC4=;
        b=AcxgVCG4TVvpAmK0YI3rwiB91dn6rEJ/XTeg0OrLALzTVb7y5ExztOnSnfuUlukjzn
         xRfdWC0zlq3W4hRMKhQY4ssspEfXfdmNqpc7S/+m6zkY3FH23Vxli1tAufvsyPtUfYII
         Itc3vw4jiKpnBHfm9rOodkRdnw+adpRwxNFjuYuJ+skH0lNxF5icntme3BYTeUM7pujG
         JAUWCOVD6oT8wOyRPO4pbrzx2rS1XW53V9KvvI2xF385QCcLcjuizZ2CAsH13vEFD8jC
         N33NS3wX0ccFdGUlI0AkIEypyHq/cR4ruSof6hZ6+lawHtffExgwwdFq+AqPO1JSMSQa
         lqIA==
X-Gm-Message-State: AOAM532tDErlV/KfpEMSEolpvU6sSgk9IRIQ5QALnjvQVjd4Q0Tu7daB
        oNfAQBNyhYIBHl4XWJSLt+A=
X-Google-Smtp-Source: ABdhPJzx+6Vgy+WsVNNrF5hfDUEbJPB9S+9UTeup3MUHCsRrh4rFLYTLH7p2QF67PiFSiQ0r1f/NxQ==
X-Received: by 2002:a63:db4b:: with SMTP id x11mr757551pgi.396.1627952712654;
        Mon, 02 Aug 2021 18:05:12 -0700 (PDT)
Received: from smtpclient.apple (c-24-6-216-183.hsd1.ca.comcast.net. [24.6.216.183])
        by smtp.gmail.com with ESMTPSA id w11sm6733686pgk.34.2021.08.02.18.05.11
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 02 Aug 2021 18:05:12 -0700 (PDT)
From:   Nadav Amit <nadav.amit@gmail.com>
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.120.0.1.13\))
Subject: Race between io_wqe_worker() and io_wqe_wake_worker()
Message-Id: <BFF746C0-FEDE-4646-A253-3021C57C26C9@gmail.com>
Date:   Mon, 2 Aug 2021 18:05:09 -0700
Cc:     io-uring@vger.kernel.org
To:     Jens Axboe <axboe@kernel.dk>
X-Mailer: Apple Mail (2.3654.120.0.1.13)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello Jens,

I encountered an issue, which appears to be a race between =
io_wqe_worker() and io_wqe_wake_worker(). I am not sure how to address =
this issue and whether I am missing something, since this seems to occur =
in a common scenario. Your feedback (or fix ;-)) would be appreciated.

I run on 5.13 a workload that issues multiple async read operations that =
should run concurrently. Some read operations can not complete for =
unbounded time (e.g., read from a pipe that is never written to). The =
problem is that occasionally another read operation that should complete =
gets stuck. My understanding, based on debugging and the code is that =
the following race (or similar) occurs:


  cpu0					cpu1
  ----					----
					io_wqe_worker()
					 schedule_timeout()
					 // timed out
  io_wqe_enqueue()
   io_wqe_wake_worker()
    // work_flags & IO_WQ_WORK_CONCURRENT
    io_wqe_activate_free_worker()
					 io_worker_exit()


Basically, io_wqe_wake_worker() can find a worker, but this worker is =
about to exit and is not going to process further work. Once the worker =
exits, the concurrency level decreases and async work might be blocked =
by another work. I had a look at 5.14, but did not see anything that =
might address this issue.

Am I missing something?

If not, all my ideas for a solution are either complicated (track =
required concurrency-level) or relaxed (span another worker on =
io_worker_exit if work_list of unbounded work is not empty).

As said, feedback would be appreciated.

Thanks,
Nadav


