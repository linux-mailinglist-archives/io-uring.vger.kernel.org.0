Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E5F1263071
	for <lists+io-uring@lfdr.de>; Wed,  9 Sep 2020 17:23:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728936AbgIIPXO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Sep 2020 11:23:14 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:49207 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728297AbgIIPWJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Sep 2020 11:22:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599664879;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=sbe1MYStSybtVRq6YvsVpm4HxML9pRlo3wGjsU8lVrI=;
        b=SImLyaqcTKsVhJh4yUSQJal9qcRZkSRHY1wmAvP+3vWY40eDLNho8bgXDSgiVbX/+zki50
        gYF1lhfQpe4+m6Z3Aq4+NzfO9k6+2iGX7GwFu+M3OabDIwCpMjtCHrpNYCQlqvLnuLxrju
        C3TgYLh8c70XgNugRBi40456YJWq/14=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-527--z1QE4rGOeyVvlexIryBsg-1; Wed, 09 Sep 2020 11:19:05 -0400
X-MC-Unique: -z1QE4rGOeyVvlexIryBsg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BC7071019627;
        Wed,  9 Sep 2020 15:19:03 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-113-207.ams2.redhat.com [10.36.113.207])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F383A7E8D3;
        Wed,  9 Sep 2020 15:19:01 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>, io-uring@vger.kernel.org,
        Stefano Garzarella <sgarzare@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH for-next] io_uring: fix ctx refcounting in io_uring_enter()
Date:   Wed,  9 Sep 2020 17:19:00 +0200
Message-Id: <20200909151900.60321-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If the ring is disabled we don't decrease the 'ctx' refcount since
we wrongly jump to 'out_fput' label.

Instead let's jump to 'out' label where we decrease the 'ctx' refcount.

Fixes: 7ec3d1dd9378 ("io_uring: allow disabling rings during the creation")
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index bd1ac8581d38..8fc44967fd52 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8645,7 +8645,7 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 
 	ret = -EBADFD;
 	if (ctx->flags & IORING_SETUP_R_DISABLED)
-		goto out_fput;
+		goto out;
 
 	/*
 	 * For SQ polling, the thread will do all submissions and completions.
-- 
2.26.2

