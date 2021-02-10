Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F345315AE5
	for <lists+io-uring@lfdr.de>; Wed, 10 Feb 2021 01:20:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233900AbhBJASh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 9 Feb 2021 19:18:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234990AbhBJAH4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 9 Feb 2021 19:07:56 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63A08C061756
        for <io-uring@vger.kernel.org>; Tue,  9 Feb 2021 16:07:16 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id l12so442285wry.2
        for <io-uring@vger.kernel.org>; Tue, 09 Feb 2021 16:07:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qyM8AMaEFwVJm1Jq9SBQXfcs+TLkbpB/yJocXueR7Xk=;
        b=PqM9h0VcjGtR4kpGOxc7aOQCJ7ANulcmbJk/9ZPHGkBvHNpE3x35+YoXx0p2KhjIjo
         t2IsoL3iitPQEAjEdhEslDz1XkLqd6qH0e+4X5THxQwt/fHAf7CnDYS+msekbIeRFfVh
         HnRqsCtMSQm0x8O/drADgPw+fjgRzNsU7prCjmlR7zO22xCy1qRtzLpet+FaXFndhpq7
         tj2q3UWQTdvXb0c/eyHHY3tYOuroQ7DCpKH3ak8OML6a197JmI+S5TQ/p5d4LuVNHgZE
         VWNWRQ61RO9GEctuH0jrNWReOSbhcuKnr9LZPLyu8NOHWX/X1VTV2ZlERUeNnHRomG2e
         I6Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qyM8AMaEFwVJm1Jq9SBQXfcs+TLkbpB/yJocXueR7Xk=;
        b=BC6SrA92Vue0NfklZ8uh9IvoKTN3/Gws1H2fW9m2UpPSFOyzQCd1p4vKJqO26E/Hqi
         RoWLeb79/qct4GO9Q8WUX71yfFZz8dBeOnJJTyLhqbPLlDoXrRS2dTf9bGSF1y5bq2bn
         LxPAr5dRTq4Ciar6fWFDbSKNHrXvI8SoKaqV03Mz2nxqQqOzbBVcTBeqem/9z1YPEPoz
         SlJF0qIh7uCcTtwVQmh8o0UO7utycx3UOQb1a34AWJ/cJQ0oxLxfhBvtWEmB8cT+LnwC
         ZJjWYqIfRTMByQkIJa/UxYoS9m+Hol6I60MnyEJ5IuxROi2iQDTFdbyt+6ACnJ/vckwc
         6Nyw==
X-Gm-Message-State: AOAM533F/xAdQTcWEGoTix5LMSjMLkYrK9VsLV9sKHay3aI+N6wens97
        8Phb2rM8S39xnZf4d7wn+/lGk4l+hlmkLg==
X-Google-Smtp-Source: ABdhPJz6PeIOJA6gq2ftKVWmH8rdO/ZsaVhlp9c0qmWGZ/j5NSwvdI8A8vLipSdXBDZdzmg7WGtDJw==
X-Received: by 2002:a5d:570b:: with SMTP id a11mr577421wrv.242.1612915635162;
        Tue, 09 Feb 2021 16:07:15 -0800 (PST)
Received: from localhost.localdomain ([148.252.132.126])
        by smtp.gmail.com with ESMTPSA id n15sm391082wrx.2.2021.02.09.16.07.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Feb 2021 16:07:14 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH RFC 00/17] playing around req alloc
Date:   Wed, 10 Feb 2021 00:03:06 +0000
Message-Id: <cover.1612915326.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Unfolding previous ideas on persistent req caches. 4-7 including
slashed ~20% of overhead for nops benchmark, haven't done benchmarking
personally for this yet, but according to perf should be ~30-40% in
total. That's for IOPOLL + inline completion cases, obviously w/o
async/IRQ completions.

Jens,
1. 11/17 removes deallocations on end of submit_sqes. Looks you
forgot or just didn't do that.

2. lists are slow and not great cache-wise, that why at I want at least
a combined approach from 12/17.

3. Instead of lists in "use persistent request cache" I had in mind a
slightly different way: to grow the req alloc cache to 32-128 (or hint
from the userspace), batch-alloc by 8 as before, and recycle _all_ reqs
right into it. If  overflows, do kfree().
It should give probabilistically high hit rate, amortising out most of
allocations. Pros: it doesn't grow ~infinitely as lists can. Cons: there
are always counter examples. But as I don't have numbers to back it, I
took your implementation. Maybe, we'll reconsider later.

I'll revise tomorrow on a fresh head + do some performance testing,
and is leaving it RFC until then.

Jens Axboe (3):
  io_uring: use persistent request cache
  io_uring: provide FIFO ordering for task_work
  io_uring: enable req cache for task_work items

Pavel Begunkov (14):
  io_uring: replace force_nonblock with flags
  io_uring: make op handlers always take issue flags
  io_uring: don't propagate io_comp_state
  io_uring: don't keep submit_state on stack
  io_uring: remove ctx from comp_state
  io_uring: don't reinit submit state every time
  io_uring: replace list with array for compl batch
  io_uring: submit-completion free batching
  io_uring: remove fallback_req
  io_uring: count ctx refs separately from reqs
  io_uring: persistent req cache
  io_uring: feed reqs back into alloc cache
  io_uring: take comp_state from ctx
  io_uring: defer flushing cached reqs

 fs/io-wq.h               |   9 -
 fs/io_uring.c            | 716 ++++++++++++++++++++++-----------------
 include/linux/io_uring.h |  14 +
 3 files changed, 425 insertions(+), 314 deletions(-)

-- 
2.24.0

