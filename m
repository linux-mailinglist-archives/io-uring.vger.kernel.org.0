Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 290382701BC
	for <lists+io-uring@lfdr.de>; Fri, 18 Sep 2020 18:14:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726533AbgIRQOS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 18 Sep 2020 12:14:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:53651 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726406AbgIRQOK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 18 Sep 2020 12:14:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600445648;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=YBlNDz2AaKvPCkZHviKUhdoaygknolkKsfidycmiL/I=;
        b=F2mRTxgdBL8glj6Pj3eH0OsfK2jA+cy1jXHV3mPKDqGcdYOlBbluntnVANQUNDZzwXL6dy
        HVbr/m8aq5MGxqKWbSGixW80jqBGQL5SneqLhjLN2GbemDDSZdAy8v8thREF+uihjJ4hvj
        WS4egJmhIzBbsYJgBeCVb0VglgC5AgE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-376-tGUwyReEMW29Z5uDwU0N-g-1; Fri, 18 Sep 2020 12:14:06 -0400
X-MC-Unique: tGUwyReEMW29Z5uDwU0N-g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CB43E1017DD6;
        Fri, 18 Sep 2020 16:14:04 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-113-92.ams2.redhat.com [10.36.113.92])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1F83E100164C;
        Fri, 18 Sep 2020 16:14:03 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
Subject: [PATCH liburing] man/io_uring_enter.2: split ERRORS section in two sections
Date:   Fri, 18 Sep 2020 18:14:02 +0200
Message-Id: <20200918161402.87962-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This patch creates a new 'CQE ERRORS' section to better divide the
errors returned by the io_uring_enter() system call from those
returned by the CQE.

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
Hi Jens,
I gave a first pass. I'm sharing it with you for a first comment. :-)

The ERRORS section should now contain all the errors returned from the
system call.
In CQE ERRORS I've added something new, but I need to better check all
the possibilities. which are not few :-(

Thanks,
Stefano
---
 man/io_uring_enter.2 | 85 ++++++++++++++++++++++++++++++++------------
 1 file changed, 63 insertions(+), 22 deletions(-)

diff --git a/man/io_uring_enter.2 b/man/io_uring_enter.2
index 6f580a3..8b87e23 100644
--- a/man/io_uring_enter.2
+++ b/man/io_uring_enter.2
@@ -824,7 +824,10 @@ will need to access upon completion of this particular I/O.  The
 .I flags
 is reserved for future use.
 .I res
-is the operation-specific result.
+is the operation-specific result, but io_uring-specific errors
+(e.g. flags or opcode invalid) are returned through this field.
+They are described in section
+.B CQE ERRORS.
 .PP
 For read and write opcodes, the
 return values match those documented in the
@@ -840,9 +843,12 @@ description of the opcodes above.
 returns the number of I/Os successfully consumed.  This can be zero
 if
 .I to_submit
-was zero or if the submission queue was empty. The errors below that refer to
-an error in a submission queue entry will be returned though a completion queue
-entry, rather than through the system call itself.
+was zero or if the submission queue was empty.
+
+The errors related to a submission queue entry will be returned through a
+completion queue entry (see section
+.B CQE ERRORS),
+rather than through the system call itself.
 
 Errors that occur not on behalf of a submission queue entry are returned via the
 system call directly. On such an error, -1 is returned and
@@ -850,18 +856,54 @@ system call directly. On such an error, -1 is returned and
 is set appropriately.
 .PP
 .SH ERRORS
+These are the errors returned by
+.BR io_uring_enter ()
+system call.
 .TP
 .B EAGAIN
 The kernel was unable to allocate memory for the request, or otherwise ran out
 of resources to handle it. The application should wait for some completions and
 try again.
 .TP
+.B EBADF
+.I fd
+is not a valid file descriptor.
+.TP
 .B EBUSY
 The application is attempting to overcommit the number of requests it can have
 pending. The application should wait for some completions and try again. May
 occur if the application tries to queue more requests than we have room for in
 the CQ ring.
 .TP
+.B EINVAL
+Some bits in the
+.I flags
+argument are invalid.
+.TP
+.B EFAULT
+An invalid user space address was specified for the
+.I sig
+argument.
+.TP
+.B ENXIO
+The io_uring instance is in the process of being torn down.
+.TP
+.B EOPNOTSUPP
+.I fd
+does not refer to an io_uring instance.
+.TP
+.B EINTR
+The operation was interrupted by a delivery of a signal before it could
+complete; see
+.BR signal(7).
+Can happen while waiting for events with
+.B IORING_ENTER_GETEVENTS.
+
+.SH CQE ERRORS
+These io_uring-specific errors are returned as a negative value in the
+.I res
+field of the completion queue entry.
+.TP
 .B EBADF
 The
 .I fd
@@ -890,17 +932,22 @@ does not fit within the buffer registered at
 .TP
 .B EINVAL
 The
-.I index
-member of the submission queue entry is invalid.
-.TP
-.B EINVAL
-The
 .I flags
 field or
 .I opcode
 in a submission queue entry is invalid.
 .TP
 .B EINVAL
+The
+.I buf_index
+member of the submission queue entry is invalid.
+.TP
+.B EINVAL
+The
+.I personality
+field in a submission queue entry is invalid.
+.TP
+.B EINVAL
 .B IORING_OP_NOP
 was specified in the submission queue entry, but the io_uring context
 was setup for polling
@@ -964,20 +1011,14 @@ field of the submission queue entry, and the
 .I addr
 field was non-zero.
 .TP
-.B ENXIO
-The io_uring instance is in the process of being torn down.
-.TP
-.B EOPNOTSUPP
-.I fd
-does not refer to an io_uring instance.
-.TP
 .B EOPNOTSUPP
 .I opcode
 is valid, but not supported by this kernel.
 .TP
-.B EINTR
-The operation was interrupted by a delivery of a signal before it could
-complete; see
-.BR signal(7).
-Can happen while waiting for events with
-.B IORING_ENTER_GETEVENTS.
+.B EOPNOTSUPP
+.B IOSQE_BUFFER_SELECT
+was set in the
+.I flags
+field of the submission queue entry, but the
+.I opcode
+doesn't support buffer selection.
-- 
2.26.2

