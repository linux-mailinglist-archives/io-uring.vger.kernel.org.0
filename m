Return-Path: <io-uring+bounces-100-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3972B7F10F7
	for <lists+io-uring@lfdr.de>; Mon, 20 Nov 2023 11:56:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4E6BC2820D2
	for <lists+io-uring@lfdr.de>; Mon, 20 Nov 2023 10:56:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1AC4212B92;
	Mon, 20 Nov 2023 10:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="C1jPGUS1"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BBBC10C
	for <io-uring@vger.kernel.org>; Mon, 20 Nov 2023 02:56:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700477762;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=58d2U9xwG/dFDTm6m8iS0jLQCEukimChxPfpR9Nt88k=;
	b=C1jPGUS1pQeoAu9IDUZyMYQxTuadi4yXWp8LWysslGajb/moW44IixkEN2fAWrWGmXrWS+
	DHwqRkQzVfEKPa0k8ln9HOTMAp9nQAlxdpyKk+fBEmqaaM2dtx79nYIigCCoRt9w46dHm4
	V8Fo2uk23ooGa1+0hV/SBca60Ifc6So=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-656-1JNkX8rcO2iydwKGkdNdiQ-1; Mon, 20 Nov 2023 05:55:58 -0500
X-MC-Unique: 1JNkX8rcO2iydwKGkdNdiQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 78EC38007B3;
	Mon, 20 Nov 2023 10:55:58 +0000 (UTC)
Received: from cmirabil.redhat.com (unknown [10.22.8.164])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1E4F65036;
	Mon, 20 Nov 2023 10:55:58 +0000 (UTC)
From: Charles Mirabile <cmirabil@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: axboe@kernel.dk,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org,
	Charles Mirabile <cmirabil@redhat.com>,
	stable@vger.kernel.org
Subject: [PATCH] io_uring/fs: consider link->flags when getting path for LINKAT
Date: Mon, 20 Nov 2023 05:55:45 -0500
Message-ID: <20231120105545.1209530-1-cmirabil@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5

In order for `AT_EMPTY_PATH` to work as expected, the fact
that the user wants that behavior needs to make it to `getname_flags`
or it will return ENOENT.

Fixes: cf30da90bc3a ("io_uring: add support for IORING_OP_LINKAT")
Cc: stable@vger.kernel.org
Link: https://github.com/axboe/liburing/issues/995
Signed-off-by: Charles Mirabile <cmirabil@redhat.com>
---
 io_uring/fs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/fs.c b/io_uring/fs.c
index 08e3b175469c..eccea851dd5a 100644
--- a/io_uring/fs.c
+++ b/io_uring/fs.c
@@ -254,7 +254,7 @@ int io_linkat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	newf = u64_to_user_ptr(READ_ONCE(sqe->addr2));
 	lnk->flags = READ_ONCE(sqe->hardlink_flags);
 
-	lnk->oldpath = getname(oldf);
+	lnk->oldpath = getname_uflags(oldf, lnk->flags);
 	if (IS_ERR(lnk->oldpath))
 		return PTR_ERR(lnk->oldpath);
 
-- 
2.41.0


