Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E91AA1740F2
	for <lists+io-uring@lfdr.de>; Fri, 28 Feb 2020 21:31:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725886AbgB1UbA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 28 Feb 2020 15:31:00 -0500
Received: from mail-io1-f47.google.com ([209.85.166.47]:38608 "EHLO
        mail-io1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbgB1UbA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 28 Feb 2020 15:31:00 -0500
Received: by mail-io1-f47.google.com with SMTP id s24so4922676iog.5
        for <io-uring@vger.kernel.org>; Fri, 28 Feb 2020 12:30:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=csLArfZi+BcXrsJWpPCnZeTaX5FHVE1SA8Qoyq9PzZg=;
        b=aM7P+8QL2WPiTpqBA6OaSgYTDGPudTlcYIZfrS6MmIJvncUxyPao6V9H12wE2wWOOK
         6Jmepw2g8czwcphIZX/ojuaCFpebGJzyDDNWuFbl1MfXBIoKVfmrVzxsq06+AMFNxEO0
         OkQ1AbNRcLi170dPKidMAS+sIWHLzXv6NR+LA8j0zM4Uzq7AotZwvVpiLV8OcNcg50Lw
         Jm58xBPXlwjNwMghZPVOvZ6G7JCRC0/I1BpdqY7HdVSAH5v/UKe0X2mSZL8vykgVT8Fk
         Lbemy6VFtQnd59rc5bqqYu56iD0L2lbkqwHxBntYDVdIPj9o94EqPO0uNf7y2hTkWPng
         T/Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=csLArfZi+BcXrsJWpPCnZeTaX5FHVE1SA8Qoyq9PzZg=;
        b=o58VCspwvzu8hGGq6K1lmggilnaDa0ibFicL9KYkvj3raFN2fonF6xk2DO+p0URljA
         Biry9HqvdqXnjrUfhkyFVH13YRFnWy35eu82IZWwBj/4+vIDgbhnFrfKoZhqaXOdRx/S
         HJYAxlp0QGaO+jP5aQxxsXyQ3j6E98vOxSburHHF4T8sTAMpFSlc/iUNlLj4GMajIzak
         OzS16Pw2QZH6znAjk+vLoA46IUIevSkaWZLXyEtzLUQ2c/KCrTtYRAP+VSsloR+J0wCY
         fM4wRNu30iiexmpEoj9rrejbVEWxTRktchU7dFxrRVL9rGj/U3gN1SG8s+pQ6AAnNAmR
         z4Jw==
X-Gm-Message-State: APjAAAX55ZVXIITGKz29/r2QqgNirCUuuV31Nvw3RvRPviO9TQ5CGLVU
        jeQlA49EamzSp+4FvItkRvcuE20WQxc=
X-Google-Smtp-Source: APXvYqzPBDRAVztMwGMTV02+aJwhmU6wOxD7bwNateXAqNwfrBqwePa9uxVlSM8AhY3ve2fFgRScpQ==
X-Received: by 2002:a02:6d13:: with SMTP id m19mr4946536jac.90.1582921856584;
        Fri, 28 Feb 2020 12:30:56 -0800 (PST)
Received: from x1.thefacebook.com ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id t15sm3397611ili.50.2020.02.28.12.30.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2020 12:30:55 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     andres@anarazel.de
Subject: [PATCHSET v3] io_uring support for automatic buffers
Date:   Fri, 28 Feb 2020 13:30:47 -0700
Message-Id: <20200228203053.25023-1-axboe@kernel.dk>
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

-- 
Jens Axboe


