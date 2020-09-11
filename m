Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80D58266265
	for <lists+io-uring@lfdr.de>; Fri, 11 Sep 2020 17:45:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726206AbgIKPpf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 11 Sep 2020 11:45:35 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:39396 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726591AbgIKPp0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 11 Sep 2020 11:45:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599839125;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hs42NkXRZXpSPiKst/2zaD4uLiz/DzuG1jt01Ktm7Qg=;
        b=BP90ilNpAOwLWS4LFs1E34AWv+1WmI7stEr5xbn+Gbkvco42n8qMwMeMm7ixsSIsi0qd7E
        mB9GbcmnffWFENdpXZ87kOKhw1QfjJ+TQvkTyWwb8Bi+fp8YFrkpmBWxWDP4Ipu7nIfdm+
        vMN1N6ky1uE88kCWwKIIfnVAanmc3F8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-461-a3y5Hp4xPASGV2JsrDWNEQ-1; Fri, 11 Sep 2020 09:34:15 -0400
X-MC-Unique: a3y5Hp4xPASGV2JsrDWNEQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BEA9918B9F02;
        Fri, 11 Sep 2020 13:34:13 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-114-89.ams2.redhat.com [10.36.114.89])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DC1D05D9E8;
        Fri, 11 Sep 2020 13:34:12 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
Subject: [PATCH liburing 3/3] man/io_uring_enter.2: add EACCES and EBADFD errors
Date:   Fri, 11 Sep 2020 15:34:08 +0200
Message-Id: <20200911133408.62506-4-sgarzare@redhat.com>
In-Reply-To: <20200911133408.62506-1-sgarzare@redhat.com>
References: <20200911133408.62506-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

These new errors are added with the restriction series recently
merged in io_uring (Linux 5.10).

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 man/io_uring_enter.2 | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/man/io_uring_enter.2 b/man/io_uring_enter.2
index 5443d5f..4773dfd 100644
--- a/man/io_uring_enter.2
+++ b/man/io_uring_enter.2
@@ -842,6 +842,16 @@ is set appropriately.
 .PP
 .SH ERRORS
 .TP
+.B EACCES
+The
+.I flags
+field or
+.I opcode
+in a submission queue entry is not allowed due to registered restrictions.
+See
+.BR io_uring_register (2)
+for details on how restrictions work.
+.TP
 .B EAGAIN
 The kernel was unable to allocate memory for the request, or otherwise ran out
 of resources to handle it. The application should wait for some completions and
@@ -861,6 +871,14 @@ field in the submission queue entry is invalid, or the
 flag was set in the submission queue entry, but no files were registered
 with the io_uring instance.
 .TP
+.B EBADFD
+The
+.I fd
+field in the submission queue entry is valid, but the io_uring ring is not
+in the right state (enabled). See
+.BR io_uring_register (2)
+for details on how to enable the ring.
+.TP
 .B EFAULT
 buffer is outside of the process' accessible address space
 .TP
-- 
2.26.2

