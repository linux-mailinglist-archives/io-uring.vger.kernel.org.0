Return-Path: <io-uring+bounces-1787-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 233588BD29A
	for <lists+io-uring@lfdr.de>; Mon,  6 May 2024 18:23:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D2F7B286BD6
	for <lists+io-uring@lfdr.de>; Mon,  6 May 2024 16:23:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48CB2156232;
	Mon,  6 May 2024 16:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RxKJ0I7z"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0425156646
	for <io-uring@vger.kernel.org>; Mon,  6 May 2024 16:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715012615; cv=none; b=f2ko+1MWT+9tGhiXEyhqtH8B61CI9bUPc0W7DZAcatkcAb7xSmw5Op2F7pzbKxR3Q1svC6wx8lxBWXLlZqbABYERJALKrPx43WXESQTcJOZP8jDtXXKieGxhLdfq8oeW0z0sepo8QAgC7/853zfENx7jJ/90HLy34JpAAl07Mh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715012615; c=relaxed/simple;
	bh=jxHgMM5fF1aPJtUQC3QbqJ1sUIh/mw6qszEyfKsRtzg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aP934eRGG8dFjAZOsMml/PleZiC8n0z9fY6Aa93JuiK2WdXYeJBeD/pc/xhiaefNmAP9JKJTo+Y/gjCpmRP2WF4yg5yoHHBI+CUX62SWnUxCEl15B9J8jTkjXEI7/gG25tdphNWAv8wsfqdAYNbT+pVysoNeu0t9Ak8X/Fls8YU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RxKJ0I7z; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715012612;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TrgPfpcrRc09tnbLEWPeSPT7KeBHVt0OIaxEmJNBJNE=;
	b=RxKJ0I7z+t9WhTN8jOe0/bU/YVZykGs2vgPEIO21oTrK/XGxBX4WLiV67kybOKTLrsafNh
	UX9rsFrHOhkiow109mujjGdL6aQ0PfE8lTD3dGFIC+9ORPCcgmZw//dmu3sQcGaJTQ1mMT
	RV0J9OlNtuKjVCm6w2oAuJpo8YF/2LU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-528-BHi2FoYHNbuvoCgl671uCg-1; Mon, 06 May 2024 12:23:29 -0400
X-MC-Unique: BHi2FoYHNbuvoCgl671uCg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4DB138021A5;
	Mon,  6 May 2024 16:23:29 +0000 (UTC)
Received: from localhost (unknown [10.72.116.15])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5CBBA8C4;
	Mon,  6 May 2024 16:23:28 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org
Cc: linux-block@vger.kernel.org,
	Pavel Begunkov <asml.silence@gmail.com>,
	Kevin Wolf <kwolf@redhat.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [RFC PATCH V2 4/9] io_uring: move marking REQ_F_CQE_SKIP out of io_free_req()
Date: Tue,  7 May 2024 00:22:40 +0800
Message-ID: <20240506162251.3853781-5-ming.lei@redhat.com>
In-Reply-To: <20240506162251.3853781-1-ming.lei@redhat.com>
References: <20240506162251.3853781-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1

Prepare for supporting sqe group, which requires to post group leader's
CQE after all members' CQEs are posted. For group leader request, we can't
do that in io_req_complete_post, and REQ_F_CQE_SKIP can't be set in
io_free_req().

So move marking REQ_F_CQE_SKIP out of io_free_req().

No functional change.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 io_uring/io_uring.c | 5 +++--
 io_uring/timeout.c  | 3 +++
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index e4be930e0f1e..c184c9a312df 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1027,8 +1027,6 @@ __cold void io_free_req(struct io_kiocb *req)
 {
 	/* refs were already put, restore them for io_req_task_complete() */
 	req->flags &= ~REQ_F_REFCOUNT;
-	/* we only want to free it, don't post CQEs */
-	req->flags |= REQ_F_CQE_SKIP;
 	req->io_task_work.func = io_req_task_complete;
 	io_req_task_work_add(req);
 }
@@ -1797,6 +1795,9 @@ struct io_wq_work *io_wq_free_work(struct io_wq_work *work)
 	if (req_ref_put_and_test(req)) {
 		if (req->flags & IO_REQ_LINK_FLAGS)
 			nxt = io_req_find_next(req);
+
+		/* we have posted CQEs in io_req_complete_post() */
+		req->flags |= REQ_F_CQE_SKIP;
 		io_free_req(req);
 	}
 	return nxt ? &nxt->work : NULL;
diff --git a/io_uring/timeout.c b/io_uring/timeout.c
index 1c9bf07499b1..202f540aa314 100644
--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -47,6 +47,9 @@ static inline void io_put_req(struct io_kiocb *req)
 {
 	if (req_ref_put_and_test(req)) {
 		io_queue_next(req);
+
+		/* we only want to free it, don't post CQEs */
+		req->flags |= REQ_F_CQE_SKIP;
 		io_free_req(req);
 	}
 }
-- 
2.42.0


