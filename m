Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78B8D27CF09
	for <lists+io-uring@lfdr.de>; Tue, 29 Sep 2020 15:23:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729907AbgI2NXs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 29 Sep 2020 09:23:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58509 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727495AbgI2NXs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 29 Sep 2020 09:23:48 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601385826;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IFtmwKGDVPKfLGHcnuzj91ZFf5aiB4crrQTwfjIu3OA=;
        b=NUc0lP70LSWFejEE22z0wzD1UHudO8pneqX00tUcTpdS1esYjTbdOO/jQfNoXmsJXKGWHG
        ODNpQ6xBYBr3EduMIO3u68tKZbA15VBC+SP6TO2rWDdSuXL+V6MKU3GqirlidlGTPm1ABx
        WgLJXmDJ4RcrfHPlMaXPqyVmuPi5kXQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-193-wT3HEl0JOMOrCXH2WrBPQw-1; Tue, 29 Sep 2020 09:23:44 -0400
X-MC-Unique: wT3HEl0JOMOrCXH2WrBPQw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BE509186841D;
        Tue, 29 Sep 2020 13:23:43 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-114-58.ams2.redhat.com [10.36.114.58])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 03AE860BF1;
        Tue, 29 Sep 2020 13:23:42 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
Subject: [PATCH liburing v2 2/3] man/io_uring_register.2: add description of restrictions
Date:   Tue, 29 Sep 2020 15:23:38 +0200
Message-Id: <20200929132339.45710-3-sgarzare@redhat.com>
In-Reply-To: <20200929132339.45710-1-sgarzare@redhat.com>
References: <20200929132339.45710-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Starting from Linux 5.10 io_uring supports restrictions.
This patch describes how to register restriction, enable io_uring
ring, and potential errors returned by io_uring_register(2).

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
v2:
- fixed grammar issues [Jens]
---
 man/io_uring_register.2 | 79 +++++++++++++++++++++++++++++++++++++++--
 1 file changed, 77 insertions(+), 2 deletions(-)

diff --git a/man/io_uring_register.2 b/man/io_uring_register.2
index 5022c03..225e461 100644
--- a/man/io_uring_register.2
+++ b/man/io_uring_register.2
@@ -19,7 +19,8 @@ io_uring_register \- register files or user buffers for asynchronous I/O
 
 The
 .BR io_uring_register ()
-system call registers user buffers or files for use in an
+system call registers resources (e.g. user buffers, files, eventfd,
+personality, restrictions) for use in an
 .BR io_uring (7)
 instance referenced by
 .IR fd .
@@ -232,6 +233,58 @@ must be set to the id in question, and
 .I arg
 must be set to NULL. Available since 5.6.
 
+.TP
+.B IORING_REGISTER_ENABLE_RINGS
+This operation enables an io_uring ring started in a disabled state
+.RB (IORING_SETUP_R_DISABLED
+was specified in the call to
+.BR io_uring_setup (2)).
+While the io_uring ring is disabled, submissions are not allowed and
+registrations are not restricted.
+
+After the execution of this operation, the io_uring ring is enabled:
+submissions and registration are allowed, but they will
+be validated following the registered restrictions (if any).
+This operation takes no argument, must be invoked with
+.I arg
+set to NULL and
+.I nr_args
+set to zero. Available since 5.10.
+
+.TP
+.B IORING_REGISTER_RESTRICTIONS
+.I arg
+points to a
+.I struct io_uring_restriction
+array of
+.I nr_args
+entries.
+
+With an entry it is possible to allow an
+.BR io_uring_register ()
+.I opcode,
+or specify which
+.I opcode
+and
+.I flags
+of the submission queue entry are allowed,
+or require certain
+.I flags
+to be specified (these flags must be set on each submission queue entry).
+
+All the restrictions must be submitted with a single
+.BR io_uring_register ()
+call and they are handled as an allowlist (opcodes and flags not registered,
+are not allowed).
+
+Restrictions can be registered only if the io_uring ring started in a disabled
+state
+.RB (IORING_SETUP_R_DISABLED
+must be specified in the call to
+.BR io_uring_setup (2)).
+
+Available since 5.10.
+
 .SH RETURN VALUE
 
 On success,
@@ -242,16 +295,30 @@ is set accordingly.
 
 .SH ERRORS
 .TP
+.B EACCES
+The
+.I opcode
+field is not allowed due to registered restrictions.
+.TP
 .B EBADF
 One or more fds in the
 .I fd
 array are invalid.
 .TP
+.B EBADFD
+.B IORING_REGISTER_ENABLE_RINGS
+or
+.B IORING_REGISTER_RESTRICTIONS
+was specified, but the io_uring ring is not disabled.
+.TP
 .B EBUSY
 .B IORING_REGISTER_BUFFERS
 or
 .B IORING_REGISTER_FILES
-was specified, but there were already buffers or files registered.
+or
+.B IORING_REGISTER_RESTRICTIONS
+was specified, but there were already buffers, files, or restrictions
+registered.
 .TP
 .B EFAULT
 buffer is outside of the process' accessible address space, or
@@ -283,6 +350,14 @@ is non-zero or
 .I arg
 is non-NULL.
 .TP
+.B EINVAL
+.B IORING_REGISTER_RESTRICTIONS
+was specified, but
+.I nr_args
+exceeds the maximum allowed number of restrictions or restriction
+.I opcode
+is invalid.
+.TP
 .B EMFILE
 .B IORING_REGISTER_FILES
 was specified and
-- 
2.26.2

