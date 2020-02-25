Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E48D116EB36
	for <lists+io-uring@lfdr.de>; Tue, 25 Feb 2020 17:21:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729206AbgBYQVA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 25 Feb 2020 11:21:00 -0500
Received: from mail-io1-f49.google.com ([209.85.166.49]:40186 "EHLO
        mail-io1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728051AbgBYQVA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 25 Feb 2020 11:21:00 -0500
Received: by mail-io1-f49.google.com with SMTP id x1so1895936iop.7
        for <io-uring@vger.kernel.org>; Tue, 25 Feb 2020 08:21:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Caji5YTxOgnbPSqZrj8z1cApQfcaGFZJrBeZgVjpkkc=;
        b=uWtwOmXR6CMfi4nytugLYWU4tzFZ49t3LvsfDcLgnzH+iMJh2yxQHuxXn/ZQxKvIG+
         pL+G1Kjoj3qhY09sisBAbSjVcHnww/GzriQFTgqkb4efBS71eLRG4PKXk7UcnLhVE5rg
         jHJLPOtnn1O5hosZ63CUbDzI6muk9jSKSadWXgClc5eEV/pitdK62Q4ysneRDXlwjgG4
         OxvtIIswTt3ylLw+lU8tqZNT4EUxiQS3doFd6WZ9EwjcyRBNr8FncuwH8UqhNidLeJKo
         5OBJZNVPrtBFZvTqk+4k4wztL8EJNvrk/CnPGxQIkzA8nqz+pOx2W9JAX+PMq/5RE++k
         2MGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Caji5YTxOgnbPSqZrj8z1cApQfcaGFZJrBeZgVjpkkc=;
        b=r8DPd2Ts859qs2aYUVzdtDsk2guCMvTmYJzQ20TpyMMYnbK7FE0vau/X6y4vBLZna3
         hopOg9STlaZ3r9gN3vasyJqR93SvbLahgmW5GMvU1Xcr0UIHYxwlohTctxb4+FZBqixJ
         uLNL/hKYx+Ldt3W+QB1zgjrVFez5VI659lz4TsSh0bOoyJWsuWplNYLbtV15jN3VyYh1
         g0MVcWkMM5bl9yJY4n5GRi2P0Y4c6drTCLZHl3pSEASQJ9HBfSWGyoYsOkROOtPDAePn
         KZQvttHK7NweXf1/BYZRnmqJ99C06+2WJQ8NtiC3HlhfQmRIQ8/ax8KowqnBaCIb4FTv
         pHmw==
X-Gm-Message-State: APjAAAV2vH2hNq8nPK06b8ySEE+yJQbigO2NWQK5Nzol1n8tcJ3d5HcH
        65PgH0ALx6/6hRgMYM/8/zOmykKKJDc=
X-Google-Smtp-Source: APXvYqyrnHjjaOkfW2XuVxZBYBZCYQSAMz8Z0V9pcBmbOraQbkxQy29p+4JbiVeca8BGipuYNcPdYw==
X-Received: by 2002:a02:5b8a:: with SMTP id g132mr7188277jab.78.1582647659367;
        Tue, 25 Feb 2020 08:20:59 -0800 (PST)
Received: from x1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id y19sm3842417ioc.78.2020.02.25.08.20.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2020 08:20:58 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     andres@anarazel.de
Subject: [PATCHSET v2b 0/3] io_uring support for automatic buffers
Date:   Tue, 25 Feb 2020 09:20:54 -0700
Message-Id: <20200225162057.11800-1-axboe@kernel.dk>
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
choose to free it, or register it again with IORING_OP_PROVIDE_BUFFER.

Patches can also be found in the below repo:

https://git.kernel.dk/cgit/linux-block/log/?h=io_uring-buf-select

and they are obviously layered on top of the poll retry rework.

Changes since v1:
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


