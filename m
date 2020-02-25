Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4112B16EB28
	for <lists+io-uring@lfdr.de>; Tue, 25 Feb 2020 17:19:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728367AbgBYQTl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 25 Feb 2020 11:19:41 -0500
Received: from mail-io1-f50.google.com ([209.85.166.50]:41698 "EHLO
        mail-io1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728051AbgBYQTl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 25 Feb 2020 11:19:41 -0500
Received: by mail-io1-f50.google.com with SMTP id m25so2432863ioo.8
        for <io-uring@vger.kernel.org>; Tue, 25 Feb 2020 08:19:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Caji5YTxOgnbPSqZrj8z1cApQfcaGFZJrBeZgVjpkkc=;
        b=sWAdpBQdjUVf2I3C+xsNbtpKi4hWJW2wse1UXqq6UmRwowZ9NMfaxU1LB2h0e1eGIw
         U/i2eQkbGXCkFHTWFklo8U3MYnXNwKZ2gRy2UXUdiHA2dMnDrwtfeCxPjr8M7Hw16kIc
         PmulpMXXNyMLLJ7DAUN7k8O0xArbkXcrmlmlzM3lWyN88DVwBayqqEhcua478Alr4BOZ
         tzkBfrpOoGyZaiWaglJvHfPHh6WAY77VjQA2WkZs1T4RLSifnKnSCQuywYJWXtutfg47
         dpSmrLvzseNzqb8rGZs4AoEXwNIvMrLmbVX8HXenWcr+Y1a0L/5VwzLtkLdH0rw9hnOh
         NZzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Caji5YTxOgnbPSqZrj8z1cApQfcaGFZJrBeZgVjpkkc=;
        b=Mt4D4ZPhXQDSw8Rc9HuaZuF+LKgf+508hkeL2LBWZScO4loTiV3d0A+jmUgOLRQgXJ
         KH4Ejcsbg4zuvuloTpFqqb1c5XAbQzlE4DpxSpii0tuTdcvGZRCKh6P2C2V2wH0qlG92
         BKYGxZ9ItVWhh2l00al0rWc16yvoKUiYE6xQRjRFS/75XD0lVA3ILt8oWHdHZTENLZqw
         EwaNnpR6KdjhHE2oudVmBN2D/1ut1+oex87A09gN4uywKU3hpFmM6wWuk9wny+nIjvq8
         B4evRpMfW3xMH0ndls0mIlZjKcUURWav7KFXcxM8dUG8Bt+XNyVeO4pSkH3QuIBQVtaj
         v0oA==
X-Gm-Message-State: APjAAAVpXh1RRFQJhnVHCX0izxUNCbywkU8vLLFsybYi1CWdu0Tq56/d
        zopLkF26hcyfxpcTGk0XjmUUCiRwKbg=
X-Google-Smtp-Source: APXvYqypwFSx2E9xsWbb0dNRtxLKZNr9NpKFhGnjGdGBwyS3PXutvTVg9PwxjJrNNTSbuozB84SjhQ==
X-Received: by 2002:a6b:7e42:: with SMTP id k2mr58272949ioq.52.1582647580670;
        Tue, 25 Feb 2020 08:19:40 -0800 (PST)
Received: from x1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id y11sm5652204ilp.46.2020.02.25.08.19.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2020 08:19:40 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     andres@anarazel.de
Subject: [PATCHSET v2 0/3] io_uring support for automatic buffers
Date:   Tue, 25 Feb 2020 09:19:33 -0700
Message-Id: <20200225161938.11649-1-axboe@kernel.dk>
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


