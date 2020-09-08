Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7C912615A0
	for <lists+io-uring@lfdr.de>; Tue,  8 Sep 2020 18:54:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732094AbgIHQxi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Sep 2020 12:53:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:38967 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732104AbgIHQwv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Sep 2020 12:52:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599583969;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=x9IxqrF0vyUOtjvBry7cfcM/diY+UKBt1XA6JqwfYSo=;
        b=QFniC5E5mJEAJPULqEfmSh2CTyjfTdMP3rLoFG+qswrohq79XA60HpXYYwKVB+6VaEetCw
        ZlB2XBpImhAEQegzLm+Pv719KD5gP9ZND2i8LB0KgC6Ko7EV4Gtyw6K2M5xEMWgkqPenV+
        iDgkicFGxXxJcnjdt5NEt0T7IZPycWY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-484-YZ65STXjPaa0J3He7po5SQ-1; Tue, 08 Sep 2020 12:52:46 -0400
X-MC-Unique: YZ65STXjPaa0J3He7po5SQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C565618BE163;
        Tue,  8 Sep 2020 16:52:44 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-112-55.ams2.redhat.com [10.36.112.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8568761176;
        Tue,  8 Sep 2020 16:52:43 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH for-next] io_uring: return EBADFD when ring isn't in the right state
Date:   Tue,  8 Sep 2020 18:52:42 +0200
Message-Id: <20200908165242.124957-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This patch uniforms the returned error (EBADFD) when the ring state
(enabled/disabled) is not the expected one.

The changes affect io_uring_enter() and io_uring_register() syscalls.

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---

Hi Jens,
I also updated the test/register-restrictions in liburing here:

https://github.com/stefano-garzarella/liburing (branch: fix-disabled-ring-error)

Thanks,
Stefano
---
 fs/io_uring.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 0490edfcdd88..cf5992e79d88 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8642,6 +8642,7 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 	if (!percpu_ref_tryget(&ctx->refs))
 		goto out_fput;
 
+	ret = -EBADFD;
 	if (ctx->flags & IORING_SETUP_R_DISABLED)
 		goto out_fput;
 
@@ -9137,7 +9138,7 @@ static int io_register_restrictions(struct io_ring_ctx *ctx, void __user *arg,
 
 	/* Restrictions allowed only if rings started disabled */
 	if (!(ctx->flags & IORING_SETUP_R_DISABLED))
-		return -EINVAL;
+		return -EBADFD;
 
 	/* We allow only a single restrictions registration */
 	if (ctx->restrictions.registered)
@@ -9201,7 +9202,7 @@ static int io_register_restrictions(struct io_ring_ctx *ctx, void __user *arg,
 static int io_register_enable_rings(struct io_ring_ctx *ctx)
 {
 	if (!(ctx->flags & IORING_SETUP_R_DISABLED))
-		return -EINVAL;
+		return -EBADFD;
 
 	if (ctx->restrictions.registered)
 		ctx->restricted = 1;
-- 
2.26.2

