Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8882727CF08
	for <lists+io-uring@lfdr.de>; Tue, 29 Sep 2020 15:23:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729906AbgI2NXr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 29 Sep 2020 09:23:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:56039 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727495AbgI2NXq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 29 Sep 2020 09:23:46 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601385825;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5W1n/LAI37PNidmu7PHN5yniiE1Ma+spXoYQKKeGO2E=;
        b=R8eb25oautvJvTbJd+CplWn4jPf8HTAjAJCiCjRON+KyViT2EAMZGWx7Mj+XkYSCSSbJLB
        1KFmu6o+ed1aV+g2wK57KAzcgVS2QIPy/6owCHjyQbqYVI88UX491KgPcLAz6uIsiW7bdH
        WOvpRSK+9M40j/utMp2mAMnMACUM6GI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-418-GZjxf_ODM5yCHzF8vPNoZw-1; Tue, 29 Sep 2020 09:23:43 -0400
X-MC-Unique: GZjxf_ODM5yCHzF8vPNoZw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A127A8015C5;
        Tue, 29 Sep 2020 13:23:42 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-114-58.ams2.redhat.com [10.36.114.58])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D37E761983;
        Tue, 29 Sep 2020 13:23:41 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
Subject: [PATCH liburing v2 1/3] man/io_uring_setup.2: add IORING_SETUP_R_DISABLED description
Date:   Tue, 29 Sep 2020 15:23:37 +0200
Message-Id: <20200929132339.45710-2-sgarzare@redhat.com>
In-Reply-To: <20200929132339.45710-1-sgarzare@redhat.com>
References: <20200929132339.45710-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This new flag is available starting from Linux 5.10.

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 man/io_uring_setup.2 | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/man/io_uring_setup.2 b/man/io_uring_setup.2
index f0aebde..a903b04 100644
--- a/man/io_uring_setup.2
+++ b/man/io_uring_setup.2
@@ -173,6 +173,13 @@ being set to an existing io_uring ring file descriptor. When set, the
 io_uring instance being created will share the asynchronous worker
 thread backend of the specified io_uring ring, rather than create a new
 separate thread pool.
+.TP
+.B IORING_SETUP_R_DISABLED
+If this flag is specified, the io_uring ring starts in a disabled state.
+In this state, restrictions can be registered, but submissions are not allowed.
+See
+.BR io_uring_register (2)
+for details on how to enable the ring. Available since 5.10.
 .PP
 If no flags are specified, the io_uring instance is setup for
 interrupt driven I/O.  I/O may be submitted using
-- 
2.26.2

