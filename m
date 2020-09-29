Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17EE327CF0A
	for <lists+io-uring@lfdr.de>; Tue, 29 Sep 2020 15:23:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728462AbgI2NXt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 29 Sep 2020 09:23:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:54625 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727495AbgI2NXt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 29 Sep 2020 09:23:49 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601385828;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+Wy5TV2KP0aFrgOM9dDAxBNAUFjrjBl1aVVt9ekP9uA=;
        b=fsfMn0MTqeFxAdKLCTHOe4kxr8qPzmdrWcI1377UXZOUXDrMDfEPhANljzgclYy+NPZpNB
        PNIgdE9N7qcuhdVTtiEnSCpoMLzSSxwm8clHETf8gs4M+xgScfGJI/AY2o7bMM4GznU+k+
        VaPq0mS9UBKuydmVZUfPD8XzI04E484=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-550-p3Im-TUNP8ih2vmadTZEhw-1; Tue, 29 Sep 2020 09:23:45 -0400
X-MC-Unique: p3Im-TUNP8ih2vmadTZEhw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DE8281868417;
        Tue, 29 Sep 2020 13:23:44 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-114-58.ams2.redhat.com [10.36.114.58])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2121561983;
        Tue, 29 Sep 2020 13:23:43 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
Subject: [PATCH liburing v2 3/3] man/io_uring_enter.2: add EACCES and EBADFD errors
Date:   Tue, 29 Sep 2020 15:23:39 +0200
Message-Id: <20200929132339.45710-4-sgarzare@redhat.com>
In-Reply-To: <20200929132339.45710-1-sgarzare@redhat.com>
References: <20200929132339.45710-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

These new errors are added with the restriction series recently
merged in io_uring (Linux 5.10).

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
v2:
- put the errors in right section
---
 man/io_uring_enter.2 | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/man/io_uring_enter.2 b/man/io_uring_enter.2
index 8b87e23..15a5a4a 100644
--- a/man/io_uring_enter.2
+++ b/man/io_uring_enter.2
@@ -869,6 +869,13 @@ try again.
 .I fd
 is not a valid file descriptor.
 .TP
+.B EBADFD
+.I fd
+is a valid file descriptor, but the io_uring ring is not in the right state
+(enabled). See
+.BR io_uring_register (2)
+for details on how to enable the ring.
+.TP
 .B EBUSY
 The application is attempting to overcommit the number of requests it can have
 pending. The application should wait for some completions and try again. May
@@ -904,6 +911,16 @@ These io_uring-specific errors are returned as a negative value in the
 .I res
 field of the completion queue entry.
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
 .B EBADF
 The
 .I fd
-- 
2.26.2

