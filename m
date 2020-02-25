Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49C2A16EAC9
	for <lists+io-uring@lfdr.de>; Tue, 25 Feb 2020 17:04:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728065AbgBYQEy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 25 Feb 2020 11:04:54 -0500
Received: from mail-io1-f45.google.com ([209.85.166.45]:33121 "EHLO
        mail-io1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728051AbgBYQEy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 25 Feb 2020 11:04:54 -0500
Received: by mail-io1-f45.google.com with SMTP id z8so2817709ioh.0
        for <io-uring@vger.kernel.org>; Tue, 25 Feb 2020 08:04:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Caji5YTxOgnbPSqZrj8z1cApQfcaGFZJrBeZgVjpkkc=;
        b=0AVP48gzAoyhAoENVv9a25DW5nYx23n8iFwB3/n5zJNCz4Z/juWJcUpgGWhP6ZSn6J
         vmlxmz9S/xuL1vgtKi2Cr1bB96aqh4t5tG+C3YIoLd8w9kRSO2XN5omocPuCAZGlHZuo
         u7XmQwc/nQEWsB+PSOEkMpjIhTbWYaUu74qvQwIER86Zke2hYpO3I4MPG5bIUqCZ0XgI
         6+GbVeFW8CqOjQeYf51uHMWDf2HIummAxrvOF2yknbAsQcrUxU+4wbRArJQ9KoU6FGPt
         xtHFdz+kFX90nh5BAfZBPNvAcReOo1nmmAsE9kVbnwdmNi61ci/qNZn91kMQgU2CIyMU
         px+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Caji5YTxOgnbPSqZrj8z1cApQfcaGFZJrBeZgVjpkkc=;
        b=PSx1PuCmxEAPPZ3buGPCtdEF9QIorvkSQwubF1GHv/wiqbyRtAsr2DeQR85YZ0im5Y
         DQ47z71cvZkTWdxLsalkk8rEYZ7gIxD+6jx7uUvwLthNN7HvJ6XqWsf1L9Kv8IgTesDh
         G8x0XNSg1nacrlnd06XRAovP6vnv/PtUMfOTBH574OQnaPL15I8Era/mPGhJ0TgJFLq2
         /AyReC6c33m61GQuUf/dHQdwsFbISOu7naWBK4+Rd/KGDUXafnQ+YcWjiSuz3VQQJKhU
         8yHJ4PIaH2prLqKh2XUFDNaF66dDpzwT4L83dDbW87veIlS3irsEze1gr65ZMBdTGNX7
         cfyw==
X-Gm-Message-State: APjAAAVFfAWr0gOshBcCMIytrow5WJ07A83LoE1q+uovRhOLT2x8EWKc
        VpvEW/IXWzQoLV07MFT+WCMppxsnX7k=
X-Google-Smtp-Source: APXvYqxHV7ajesHsnhcYlbAYs26Uk1Hdbx6ksOSDotzYUPLpwFTFpvmnZuisgNB7YuYuy8uWuBIpuw==
X-Received: by 2002:a05:6638:72c:: with SMTP id j12mr61572580jad.136.1582646693553;
        Tue, 25 Feb 2020 08:04:53 -0800 (PST)
Received: from x1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id k23sm5628100ilg.83.2020.02.25.08.04.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2020 08:04:53 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     andres@anarazel.de
Subject: [PATCHSET v2 0/3] io_uring support for automatic buffers
Date:   Tue, 25 Feb 2020 09:04:48 -0700
Message-Id: <20200225160451.7198-1-axboe@kernel.dk>
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


