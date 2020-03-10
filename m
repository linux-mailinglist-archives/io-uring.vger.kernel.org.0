Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98EE318010E
	for <lists+io-uring@lfdr.de>; Tue, 10 Mar 2020 16:04:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727837AbgCJPEe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 10 Mar 2020 11:04:34 -0400
Received: from mail-il1-f176.google.com ([209.85.166.176]:37764 "EHLO
        mail-il1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727795AbgCJPEe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 10 Mar 2020 11:04:34 -0400
Received: by mail-il1-f176.google.com with SMTP id a6so12294981ilc.4
        for <io-uring@vger.kernel.org>; Tue, 10 Mar 2020 08:04:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zROZmDA7IXql3hwCfBOpijdNclCXfrOWKVxduTRpcVo=;
        b=gSiJJlteYxPvKZ0/CefvLlqkJ9beXPj75gSZKV9yqryMuB2ue8qFVEV2dXcgEPDxI8
         06SrejOUc4dkUAxDUrZryjCGvtcTvVmuaGICxnUoIXBncnmhHOpoyvhnW60kqyhCe+vD
         1vth9zGFFhm7ifKLTtBNs9v49sTr3cWMlUsl5rGxJ+cST5JWcEexHssJctBaAEJM3x6h
         4t1n2P8mfsX3plu2JKm6iZ3mFSp1X5lrHjoe+NdRwIwhqERO71pYwCphw5Q+9/cpZuyN
         XUF3m8cUZu1ahUJHocWCB+jkOS/M77LRmZdbY6hoQHRBC+YdP3UK4OHhdp4mXJUOqM+6
         c/Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zROZmDA7IXql3hwCfBOpijdNclCXfrOWKVxduTRpcVo=;
        b=lK4B8oFaZY5rWrZjTtXfZcYrayPm2e+IVW2QeiPmP0yV2t0oeIMBMCo7U8rriwy+9E
         rAliI+Eg4hWRDDvfhjfmjtKQVK5mopmWpCHNG1t4viSQv7YE521t51qrA51gBbdsrZT0
         atlD1nXLrNt9aqK0i6AsgugzRPgcKYlmavi97qVWU7DjLDQUQsxQ2revcsNqklclHuZL
         gR3ER6onhJhxjVVC4SyRHruM9CHU8nOVvRHykRK+rvP0qSVlqi5fmziqfNIyAHsXkYlp
         8fA1Flggumck5yUH87krjHu/IOHpSwb91G02/wsxvq81h9Q21SIc+Q9q0FL/51kObsxW
         MkcA==
X-Gm-Message-State: ANhLgQ3bNvn2TF0ApIz4yT7nychId9UiYqBy+NqodIgRba9FUC4cQu0K
        VqfbEv62A3EdHiDtREffvWmysinKUoHnMw==
X-Google-Smtp-Source: ADFU+vsgkgartF6lOi6uXC735a6cWAHtSobKewE3BUqMvXGUhqz6VpzHW9jBm0/xWHGlpgWFGTYijg==
X-Received: by 2002:a92:d2c5:: with SMTP id w5mr20933363ilg.196.1583852672123;
        Tue, 10 Mar 2020 08:04:32 -0700 (PDT)
Received: from x1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id e16sm4684750ioh.7.2020.03.10.08.04.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2020 08:04:31 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     andres@anarazel.de
Subject: [PATCHSET v4] Support for automatic buffer selection
Date:   Tue, 10 Mar 2020 09:04:17 -0600
Message-Id: <20200310150427.28489-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

With the poll retry based async IO patchset I posted last week, the one
big missing thing for me was the ability to have automatic buffer
selection. Generally applications that handle tons of sockets like to
poll for activity on them, then issue IO when they become ready. This is
of course at least two system calls, but it also means that it provides
an application a chance to manage how many IO buffers it needs. With the
io_uring based polled IO, the application need only issue an
IORING_OP_RECV (for example, to receive socket data), it doesn't need to
poll at all. However, this means that the application no longer has an
opportune moment to select how many IO buffers to keep in flight, it has
to be equal to what it currently has pending.

I had originally intended to use BPF to provide some means of buffer
selection, but I had a hard time imagining how life times of the buffer
could be managed through that. I had a false start today, but Andres
suggested a nifty approach that also solves the life time issue.

Basically the application registers buffers with the kernel. Each buffer
is registered with a given group ID, and buffer ID. The buffers are
organized by group ID, and the application selects a buffer pool based
on this group ID. One use case might be to group by size. There's an
opcode for this, IORING_OP_PROVIDE_BUFFERS.

IORING_OP_PROVIDE_BUFFERS takes a start address, length of a buffer, and
number of buffers. It also provides a group ID with which these buffers
should be associated, and a starting buffer ID. The buffers are then
added, and the buffer ID is incremented by 1 for each buffer.

With that, when doing the same IORING_OP_RECV, no buffer is passed in
with the request. Instead, it's flagged with IOSQE_BUFFER_SELECT, and
sqe->buf_group is filled in with a valid group ID. When the kernel can
satisfy the receive, a buffer is selected from the specified group ID
pool. If none are available, the IO is terminated with -ENOBUFS. On
success, the buffer ID is passed back through the (CQE) completion
event. This tells the application what specific buffer was used.

A buffer can be used only once. On completion, the application may
choose to free it, or register it again with IORING_OP_PROVIDE_BUFFERS.

Patches can also be found in the below repo:

https://git.kernel.dk/cgit/linux-block/log/?h=io_uring-buf-select

which is sitting on top of for-5.7/io_uring.

v4:
- Address various review comments
- Fixes
- Fold in 32-bit warning fixes

v3:
- Add support for IORING_OP_READV and IORING_OP_RECVMSG
- Drop write side
- More cleanups on address space, retained state
- Add a few helpers
- Rebase on new for-5.7/io_uring

v2:
- Cleanup address space
- Fix locking for async offload issue
- Add lockdep annotation for uring_lock
- Verify sqe fields on PROVIDE_BUFFERS prep
- Fix send/recv kbuf leak on import failure
- Fix send/recv error handling on -ENOBUFS
- Change IORING_OP_PROVIDE_BUFFER to PROVIDE_BUFFERS, and allow multiple
  contig buffers in one call


