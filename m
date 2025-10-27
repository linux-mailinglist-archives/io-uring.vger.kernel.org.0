Return-Path: <io-uring+bounces-10248-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C0003C11B5A
	for <lists+io-uring@lfdr.de>; Mon, 27 Oct 2025 23:30:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 749A81A63DE6
	for <lists+io-uring@lfdr.de>; Mon, 27 Oct 2025 22:31:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 428A332D0C4;
	Mon, 27 Oct 2025 22:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Xg1FfGpG"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1CB532C958
	for <io-uring@vger.kernel.org>; Mon, 27 Oct 2025 22:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761604191; cv=none; b=s13ebaE64B20ll0DhoVa34lwNJduATD+njq75qkAlDs5byRDzlIvdYfvAYOvAcQxbrGlO6TDMn5eYta08r2pSLbHaoSwUZ4eVd2i2BNmgsbRjUvwrv7b5ghJT8BB3J87AocE8242Jp+ktNxjGOt8AsLBMrMj0hJ7FLSLhl9cGvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761604191; c=relaxed/simple;
	bh=stH8ERHnLgGKntujVtgWmjtSFkJ9rC8uJoiBNNl6TZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IBud7+sylcdHVxTobq9zHJFLTVkflTq3y8WsII7rJHwCyej4Z0Np9d1V8LV0YB20hYkR14aW9js2ScV+lPH/PUf091+plVQLth7iMgqvz2hdFsMyPiXGsk+jyAw3V51ahS+yJn5JbjdpfEHsPumHSB4yR6AlCQJYpSPR0CNsXbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Xg1FfGpG; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2698384978dso34345345ad.0
        for <io-uring@vger.kernel.org>; Mon, 27 Oct 2025 15:29:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761604189; x=1762208989; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p+v63gqYGD2FdXVPY9KH/Rik9aMUyDvSPJsKuu+HW4g=;
        b=Xg1FfGpGyq01YBBapNHsvJALpASHxOn+HBIbTunQcLUBQ8zg31Ru1iDNWmfvqrS81r
         tdH9WPbyNVkon1uEfe7r7gVoPHFXHr2YYom4hzjI2f6pwB36IW6r/fgtUdcrpvFqGmVH
         G+h1a4CfZZrpOTL3CMkBcnQjv6xTd1pGtU050zKK5Zc8HA4dv/w2wyfHEx1OSmBIJLb/
         nKMTI5kOtIdnBGv9VNjY2OjvboI+oJnhIsT/wf/j1u9gZ+JaMzFBZGgivHIs+w3E2J9H
         Lu/6sfpvZ3qUAwrzJDntDFtKq2KVINC4Yb394VpRYtw5yVVqpI/EhWT4gC+D4XqzIDES
         9i9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761604189; x=1762208989;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=p+v63gqYGD2FdXVPY9KH/Rik9aMUyDvSPJsKuu+HW4g=;
        b=fSeL067J0hQ/dz4t0FryP/q3GE17Y8z+bGy8Y7rpGlb99vrRlVdfkR6EdGSr1s8ffG
         eWCC42sCHOKDNoa4QXMokDZi4lACopv23y9T0SLy/fZhSAfVADWJn0oOuwhbnA65tKb2
         U76ozghY16pOZryqMeSYzXHrhBJv5Bh/4/C8QezRGyT5QzmArxhm1DFLazFn7QFKMov4
         YZ1hwi0Z4wIfu6OhDYzUT250ODn4tyqjm9MnHYkYZ9rHy8w4YME5+NnxocCFbtaPNyj3
         MkoyP+Ia2ZxuL1QFfZ0G11gQ3c9nnVkZIE7HndQozRI3okwhfEA1KTS16so8ieFWXm+W
         OMuQ==
X-Forwarded-Encrypted: i=1; AJvYcCUAxkDxMP5h9OgKEOYxU/2l5uRLwe7C2VGqQ0F4CXTCT07f+vDOgDxTwPqpHydDmKdvcPjkVaR7LA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxwhmgqV/RjnO3LgbREEq+wWATqDuRfAjok2JL4hurMnx3eFe7h
	DGbcbQUTjCvQ3ZzPoLZkR/imVao6yE9umfBYRhkZ/GHAGybFCWogiIX0
X-Gm-Gg: ASbGnctjiWzH+4e6W51+LqhRT6XSUqMmM4AJkn1arCPEf/YDl/3ddU4/mL/njqJD09i
	QXzwGGOFpb9d3sMAqaPDmqCn9K9UfH+882sp/lA/gZLjr5MMnMQVzVaFQJgOjfVMAQH9vgpzREE
	JNib/X3ps6jzojCtgxS5IvtRWqyAchggzAimD8KbuQB1HYRz6TErgKgoiRtNqFp6puz3BCxnkED
	QwMqSHNELx+6Po6ICtEufUoqBhcSQvIfwmLR4RmJNLnVk23wZmWEJB8tc88BnjVy+OhWy7rvblG
	iGdd9ZJN9DF2F+ZPwDiOnU6IRSEo9ybqs5KNpa9X6ApKAYnVRLe9NjfgLRzPu2dAQWh3woAxwFF
	flovVMDVTriklUgv0OM1Ta3jS62Z7aFGhA9Dyr0olVtUM05iN76GN40oJrwb26I1P4yWKLxKSly
	2dNhHg4v2IX+Yvqzar1kBnI9gel2z+ycfEPy3h4llUayv1wtZ6
X-Google-Smtp-Source: AGHT+IFlweAgbb9nw9qjuS5BoAWwd3znV+Q05JzRIHZjrtJZ82lgiBBSkIzlOe1DdxRdzGWrTagr0w==
X-Received: by 2002:a17:903:228c:b0:290:b53b:7455 with SMTP id d9443c01a7336-294cb368c9bmr12258905ad.10.1761604188993;
        Mon, 27 Oct 2025 15:29:48 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:51::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29498d42558sm93052255ad.69.2025.10.27.15.29.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Oct 2025 15:29:48 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: miklos@szeredi.hu,
	axboe@kernel.dk
Cc: linux-fsdevel@vger.kernel.org,
	bschubert@ddn.com,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org,
	xiaobing.li@samsung.com,
	csander@purestorage.com,
	kernel-team@meta.com
Subject: [PATCH v2 6/8] fuse: add user_ prefix to userspace headers and payload fields
Date: Mon, 27 Oct 2025 15:28:05 -0700
Message-ID: <20251027222808.2332692-7-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251027222808.2332692-1-joannelkoong@gmail.com>
References: <20251027222808.2332692-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Rename the headers and payload fields to user_headers and user_payload.
This makes it explicit that these pointers reference userspace addresses
and prepares for upcoming fixed buffer support, where there will be
separate fields for kernel-space pointers to the payload and headers.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 fs/fuse/dev_uring.c   | 17 ++++++++---------
 fs/fuse/dev_uring_i.h |  4 ++--
 2 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
index d96368e93e8d..c814b571494f 100644
--- a/fs/fuse/dev_uring.c
+++ b/fs/fuse/dev_uring.c
@@ -585,11 +585,11 @@ static void __user *get_user_ring_header(struct fuse_ring_ent *ent,
 {
 	switch (type) {
 	case FUSE_URING_HEADER_IN_OUT:
-		return &ent->headers->in_out;
+		return &ent->user_headers->in_out;
 	case FUSE_URING_HEADER_OP:
-		return &ent->headers->op_in;
+		return &ent->user_headers->op_in;
 	case FUSE_URING_HEADER_RING_ENT:
-		return &ent->headers->ring_ent_in_out;
+		return &ent->user_headers->ring_ent_in_out;
 	}
 
 	WARN_ON_ONCE(1);
@@ -645,7 +645,7 @@ static int fuse_uring_copy_from_ring(struct fuse_ring *ring,
 	if (err)
 		return err;
 
-	err = import_ubuf(ITER_SOURCE, ent->payload, ring->max_payload_sz,
+	err = import_ubuf(ITER_SOURCE, ent->user_payload, ring->max_payload_sz,
 			  &iter);
 	if (err)
 		return err;
@@ -674,7 +674,7 @@ static int fuse_uring_args_to_ring(struct fuse_ring *ring, struct fuse_req *req,
 		.commit_id = req->in.h.unique,
 	};
 
-	err = import_ubuf(ITER_DEST, ent->payload, ring->max_payload_sz, &iter);
+	err = import_ubuf(ITER_DEST, ent->user_payload, ring->max_payload_sz, &iter);
 	if (err) {
 		pr_info_ratelimited("fuse: Import of user buffer failed\n");
 		return err;
@@ -710,8 +710,7 @@ static int fuse_uring_args_to_ring(struct fuse_ring *ring, struct fuse_req *req,
 
 	ent_in_out.payload_sz = cs.ring.copied_sz;
 	return copy_header_to_ring(ent, FUSE_URING_HEADER_RING_ENT,
-				   &ent_in_out,
-				   sizeof(ent_in_out));
+				   &ent_in_out, sizeof(ent_in_out));
 }
 
 static int fuse_uring_copy_to_ring(struct fuse_ring_ent *ent,
@@ -1104,8 +1103,8 @@ fuse_uring_create_ring_ent(struct io_uring_cmd *cmd,
 	INIT_LIST_HEAD(&ent->list);
 
 	ent->queue = queue;
-	ent->headers = iov[0].iov_base;
-	ent->payload = iov[1].iov_base;
+	ent->user_headers = iov[0].iov_base;
+	ent->user_payload = iov[1].iov_base;
 
 	atomic_inc(&ring->queue_refs);
 	return ent;
diff --git a/fs/fuse/dev_uring_i.h b/fs/fuse/dev_uring_i.h
index 51a563922ce1..381fd0b8156a 100644
--- a/fs/fuse/dev_uring_i.h
+++ b/fs/fuse/dev_uring_i.h
@@ -39,8 +39,8 @@ enum fuse_ring_req_state {
 /** A fuse ring entry, part of the ring queue */
 struct fuse_ring_ent {
 	/* userspace buffer */
-	struct fuse_uring_req_header __user *headers;
-	void __user *payload;
+	struct fuse_uring_req_header __user *user_headers;
+	void __user *user_payload;
 
 	/* the ring queue that owns the request */
 	struct fuse_ring_queue *queue;
-- 
2.47.3


