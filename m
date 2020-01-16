Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 351E313DC5C
	for <lists+io-uring@lfdr.de>; Thu, 16 Jan 2020 14:50:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726406AbgAPNty (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Jan 2020 08:49:54 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:24066 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726084AbgAPNty (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Jan 2020 08:49:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579182593;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=tW8QepJVzZQv/Ygdvwl07xvaRaFmGC5EBwa4NFuhNeM=;
        b=Kat1ueh6URun3U1Gioba4aadsYehGLOvYzefcLU/PleyAhq0GxYRr0wxXuA0gW3XcuLotu
        lcnOsJJFdykht33mkCXt3DG4OVLYPmjbzFPbZjajdVuWleJCKWVj5KKmc20fZ24TVCGOJP
        ao8oC9G68RrktlFxypXayENsI2GhwK0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-92-jzdK0iVEON-09vfB4a5Ciw-1; Thu, 16 Jan 2020 08:49:50 -0500
X-MC-Unique: jzdK0iVEON-09vfB4a5Ciw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1E9EC8DF704;
        Thu, 16 Jan 2020 13:49:49 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-117-242.ams2.redhat.com [10.36.117.242])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CF7AA860DA;
        Thu, 16 Jan 2020 13:49:47 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH] io_uring: wakeup threads waiting for EPOLLOUT events
Date:   Thu, 16 Jan 2020 14:49:46 +0100
Message-Id: <20200116134946.184711-1-sgarzare@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Content-Transfer-Encoding: quoted-printable
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_uring_poll() sets EPOLLOUT flag if there is space in the
SQ ring, then we should wakeup threads waiting for EPOLLOUT
events when we expose the new SQ head to the userspace.

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---

Do you think is better to change the name of 'cq_wait' and 'cq_fasync'?

Thanks,
Stefano
---
 fs/io_uring.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 38b54051facd..5c6ff5f9e741 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3687,6 +3687,11 @@ static void io_commit_sqring(struct io_ring_ctx *c=
tx)
 		 * write new data to them.
 		 */
 		smp_store_release(&rings->sq.head, ctx->cached_sq_head);
+
+		if (wq_has_sleeper(&ctx->cq_wait)) {
+			wake_up_interruptible(&ctx->cq_wait);
+			kill_fasync(&ctx->cq_fasync, SIGIO, POLL_OUT);
+		}
 	}
 }
=20
--=20
2.24.1

