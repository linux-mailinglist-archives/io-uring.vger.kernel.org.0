Return-Path: <io-uring+bounces-7747-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A1605A9ED2C
	for <lists+io-uring@lfdr.de>; Mon, 28 Apr 2025 11:50:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 68C3D188E349
	for <lists+io-uring@lfdr.de>; Mon, 28 Apr 2025 09:48:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F079267B06;
	Mon, 28 Apr 2025 09:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fI2x5IYh"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3019267B01
	for <io-uring@vger.kernel.org>; Mon, 28 Apr 2025 09:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745833504; cv=none; b=B+N4lxbFJtQMgq8Wmh7bXld9Jj+qNxI+W7p6e3p4cFxD8EuOvoFqYKEDlJLFNd0MlbwOgD6ynmzIfhrpMbTxZ0KIDyTI1RwKIHk0SYSHGav//hv/nznnKyklCZqBzz3LhVBsvGWZxatDFUlLHzpEYQt53/u3goEdEv8cqMvZ5uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745833504; c=relaxed/simple;
	bh=4u5F4/wIhDQfBfAzaPzbbPLZ6VnPCk1PliIafV6JKt8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D2RvA5O2F2tbMtobbfmqfSH0TAU7sTQoF5r3Yt/Swwgb9BGzEJQBNVsbXYmNVr2s7pqD7SM2rDakIllFZXnKnqjr/2k0jLmsLmoolNCs9NquuxEZteYUcdH8dVGThMSCsOirclJEI49biPgP5Yn43Ol7Cl/ulc185fdACVDxynM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fI2x5IYh; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745833501;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QP01s+NoXelB0ooV/FSKEfgslbq8CyPujrmfjLYSHV0=;
	b=fI2x5IYhwrNaAdONPDbSs+7NoEcKm47ZZZIj6uQ82LwF2N3yT5HCnlE9DFhsI9jwCezM40
	f6mWOKY2B14w39+GxCUGr7X2Lr/RHhsGq/BJAjhN26HdiYRc1IQQPfNMRZL7Z65lgbVvCD
	0ew2RQiAtButw4rtjDrhcIfhOfSbu7I=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-438-H6jL_4WUNAqlHRUmvbQw8Q-1; Mon,
 28 Apr 2025 05:44:57 -0400
X-MC-Unique: H6jL_4WUNAqlHRUmvbQw8Q-1
X-Mimecast-MFC-AGG-ID: H6jL_4WUNAqlHRUmvbQw8Q_1745833491
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D0EF11800373;
	Mon, 28 Apr 2025 09:44:50 +0000 (UTC)
Received: from localhost (unknown [10.72.116.134])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A9EB519560A3;
	Mon, 28 Apr 2025 09:44:49 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org,
	Pavel Begunkov <asml.silence@gmail.com>,
	linux-block@vger.kernel.org
Cc: Uday Shankar <ushankar@purestorage.com>,
	Caleb Sander Mateos <csander@purestorage.com>,
	Keith Busch <kbusch@kernel.org>,
	Ming Lei <ming.lei@redhat.com>
Subject: [RFC PATCH 4/7] ublk: convert to refcount_t
Date: Mon, 28 Apr 2025 17:44:15 +0800
Message-ID: <20250428094420.1584420-5-ming.lei@redhat.com>
In-Reply-To: <20250428094420.1584420-1-ming.lei@redhat.com>
References: <20250428094420.1584420-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Convert to refcount_t and prepare for supporting to register bvec buffer
automatically, which needs to initialize reference counter as 2, and
kref doesn't provide this interface, so convert to refcount_t.

Suggested-by: Caleb Sander Mateos <csander@purestorage.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/block/ublk_drv.c | 19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index ac56482b55f5..9cd331d12fa6 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -79,7 +79,7 @@
 	 UBLK_PARAM_TYPE_DMA_ALIGN | UBLK_PARAM_TYPE_SEGMENT)
 
 struct ublk_rq_data {
-	struct kref ref;
+	refcount_t ref;
 };
 
 struct ublk_uring_cmd_pdu {
@@ -484,7 +484,6 @@ static blk_status_t ublk_setup_iod_zoned(struct ublk_queue *ubq,
 #endif
 
 static inline void __ublk_complete_rq(struct request *req);
-static void ublk_complete_rq(struct kref *ref);
 
 static dev_t ublk_chr_devt;
 static const struct class ublk_chr_class = {
@@ -644,7 +643,7 @@ static inline void ublk_init_req_ref(const struct ublk_queue *ubq,
 	if (ublk_need_req_ref(ubq)) {
 		struct ublk_rq_data *data = blk_mq_rq_to_pdu(req);
 
-		kref_init(&data->ref);
+		refcount_set(&data->ref, 1);
 	}
 }
 
@@ -654,7 +653,7 @@ static inline bool ublk_get_req_ref(const struct ublk_queue *ubq,
 	if (ublk_need_req_ref(ubq)) {
 		struct ublk_rq_data *data = blk_mq_rq_to_pdu(req);
 
-		return kref_get_unless_zero(&data->ref);
+		return refcount_inc_not_zero(&data->ref);
 	}
 
 	return true;
@@ -666,7 +665,8 @@ static inline void ublk_put_req_ref(const struct ublk_queue *ubq,
 	if (ublk_need_req_ref(ubq)) {
 		struct ublk_rq_data *data = blk_mq_rq_to_pdu(req);
 
-		kref_put(&data->ref, ublk_complete_rq);
+		if(refcount_dec_and_test(&data->ref))
+			__ublk_complete_rq(req);
 	} else {
 		__ublk_complete_rq(req);
 	}
@@ -1124,15 +1124,6 @@ static inline void __ublk_complete_rq(struct request *req)
 	blk_mq_end_request(req, res);
 }
 
-static void ublk_complete_rq(struct kref *ref)
-{
-	struct ublk_rq_data *data = container_of(ref, struct ublk_rq_data,
-			ref);
-	struct request *req = blk_mq_rq_from_pdu(data);
-
-	__ublk_complete_rq(req);
-}
-
 static void ublk_complete_io_cmd(struct ublk_io *io, struct request *req,
 				 int res, unsigned issue_flags)
 {
-- 
2.47.0


