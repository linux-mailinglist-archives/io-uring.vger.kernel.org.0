Return-Path: <io-uring+bounces-9959-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A667BCA68B
	for <lists+io-uring@lfdr.de>; Thu, 09 Oct 2025 19:42:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E6B98189C6D0
	for <lists+io-uring@lfdr.de>; Thu,  9 Oct 2025 17:42:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19B39225A38;
	Thu,  9 Oct 2025 17:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="E2u3sHTV"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f181.google.com (mail-il1-f181.google.com [209.85.166.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F22B246762
	for <io-uring@vger.kernel.org>; Thu,  9 Oct 2025 17:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760031714; cv=none; b=KtTfA15SrDlrWKHCku9LuS5eL4/Q8AUTbU6IncnzYZjh7DYzwq8S/ULNEf/O5X3KyzB9lIHXI8sfF/aTy0BkBiy8Yc1tP++jmwLfq+D28rAr75Z2MJXKkciE7dZ1Cb0CO9QMewGd6s5iB2vmwYpSOkWmnnPZ1UqOm4Xq1WvHme0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760031714; c=relaxed/simple;
	bh=OdibdWfS2Wg5Ovy4tx29Mz2CsuEwyisRahy0ScZOqBw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nOiGtKnhAYSbu2SGWz93jEhbnY0nIImokDzPigudef3pI2PuQCwzbtaufwwal+B2CnsshncTtwL12L12t4gv4hzqjpTkmv0eh1GZ7Ez4pcPor8YxmnLWD4gjDV1vqGq4PCgQJFsHHbWS/Ww29bUBU0i+07sP96NCR/nHy9t5Vho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=E2u3sHTV; arc=none smtp.client-ip=209.85.166.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f181.google.com with SMTP id e9e14a558f8ab-42e6df6fe53so4913975ab.2
        for <io-uring@vger.kernel.org>; Thu, 09 Oct 2025 10:41:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1760031709; x=1760636509; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XaaHtVqMik1CjCOfyIwv70HDYUvZK5wv72tN2XTY1+4=;
        b=E2u3sHTViCQ3lbouAop7Vq3WquapTMap9qNURnR6mEoPcknstyxxaKtEkf8oDrq6q2
         ObeXYyiLeVpf8sRO0Cj0jN5bjSxVZwS29oDwwpMhP3R4rFjkady9wSav9pB4FPkEIs1O
         ZEDAdHt8tRnus/I0IfWFEQ4T7dYo2a8RM0s6JoovLeNK0ztEOeJ5tU35eXO0FZREMvoV
         YiKNUqat7DqI76Zk3JLp/mv+IYQdUWZZ8zowXWXXoYqu2pxsxsomrFPQQdxzPFaavtSo
         pJi/rqb2Zj0N07yt/aChmnZXDvytPNEGPMxDsj5XMJNWcxqnJyRR+zgu8QOdxlPRAv+x
         O/Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760031709; x=1760636509;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XaaHtVqMik1CjCOfyIwv70HDYUvZK5wv72tN2XTY1+4=;
        b=TNdqnY0yHsEabfYqoANi48UYH5oRJU1EHodtjT38DMCE3zpCU9NkRQX1LhU8dRqU1x
         EOZOafnPvF4s0UdRmf6o2zGyFuRTBeTOA7T3WeJtYWk6Atq6gZ2bq4tVBnHxryYlrfCq
         Y4/cb9mcuN/Jh0HLA0G3yRzoFRu6X4v5rJDK3JSlSrjbhk3ri0I6w4wKX03+E60Amo/y
         8Febdko3JDYG7FMwKTR3Eb1SIU3Uve6JFqm9DVYvJ8i6/5GehHepCmt/zmPX1jqIGdpc
         3F8QH72ai4Ice5fTi96R2owFVgrI2VSSJz8gegBiEvrpc+m1NooGfIgPdVU3QLcopyPb
         BtGw==
X-Gm-Message-State: AOJu0YwO5uV6waaadLWEgBGHogHps+yFLe881o5rgMoM14r4NHH2OPND
	azzogME3mjH3Jnh+zxy7zJZCujlt54qFx8HIHVvc3XWDFTUMBnPoe3s3RtDej5+M3SwVojgDRqT
	L4ySAWAg=
X-Gm-Gg: ASbGnctMfMuY1RQvCO9MsrRETbggWXYoXtWl97OYhAs+nJ3mdNF6yq5i9+aZfj8R1kf
	S/U7Bh6JwX/+NC355qyYzrLBCKPRCclajcxrx/zQHEvW+TzHnjs/+8LBEhmigMQSIjr2DblXues
	pEqDOiCMCu+3WeWfz+M/5YhclXzyhdwcH1nX9LBD3wplgTi6oKbYK68IEHWnAbb5FCmsznkMqY4
	IsKdZ5CIzZyj46DzfEmEj54JDmV0nGbZZhYCuXuihivL95rGB0VDU14ecXDiQ3D4Q7i6P7WC0Rs
	0pvTGKpquvjMtBjDMuyGs7guJowPdp4XWWweweaBRS2/8eDHFj481yiY24lcJ/cpd3J2NBtT6Eu
	VD/AyxclhG9ujmHzW0it7lNQVeoZcYqPCaZHHKk/u
X-Google-Smtp-Source: AGHT+IElQ1TM/VN930JGtlvwSXmSnczezLQ0XGOHgQ44Hx5VV19MOgJyzt9VpfX01sjB3BzKd77S5A==
X-Received: by 2002:a05:6e02:1c24:b0:42f:9847:15bd with SMTP id e9e14a558f8ab-42f984716b3mr12543245ab.26.1760031709188;
        Thu, 09 Oct 2025 10:41:49 -0700 (PDT)
Received: from m2max ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-42f9037c631sm12955045ab.33.2025.10.09.10.41.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Oct 2025 10:41:48 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/2] io_uring/waitid: have io_waitid_complete() remove wait queue entry
Date: Thu,  9 Oct 2025 11:39:25 -0600
Message-ID: <20251009174145.2209946-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251009174145.2209946-1-axboe@kernel.dk>
References: <20251009174145.2209946-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Both callers of this need the entry potentially removed, so shift the
removal into the completion side and kill it from the two callers.

While at it, add a helper for removing the wait_queue_entry based
on the passed in io_kiocb.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/waitid.c | 26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

diff --git a/io_uring/waitid.c b/io_uring/waitid.c
index f25110fb1b12..ebe3769c54dc 100644
--- a/io_uring/waitid.c
+++ b/io_uring/waitid.c
@@ -109,6 +109,22 @@ static int io_waitid_finish(struct io_kiocb *req, int ret)
 	return ret;
 }
 
+static void io_waitid_remove_wq(struct io_kiocb *req)
+{
+	struct io_waitid *iw = io_kiocb_to_cmd(req, struct io_waitid);
+	struct wait_queue_head *head;
+
+	head = READ_ONCE(iw->head);
+	if (head) {
+		struct io_waitid_async *iwa = req->async_data;
+
+		iw->head = NULL;
+		spin_lock_irq(&head->lock);
+		list_del_init(&iwa->wo.child_wait.entry);
+		spin_unlock_irq(&head->lock);
+	}
+}
+
 static void io_waitid_complete(struct io_kiocb *req, int ret)
 {
 	struct io_waitid *iw = io_kiocb_to_cmd(req, struct io_waitid);
@@ -119,6 +135,7 @@ static void io_waitid_complete(struct io_kiocb *req, int ret)
 	lockdep_assert_held(&req->ctx->uring_lock);
 
 	hlist_del_init(&req->hash_node);
+	io_waitid_remove_wq(req);
 
 	ret = io_waitid_finish(req, ret);
 	if (ret < 0)
@@ -129,7 +146,8 @@ static void io_waitid_complete(struct io_kiocb *req, int ret)
 static bool __io_waitid_cancel(struct io_kiocb *req)
 {
 	struct io_waitid *iw = io_kiocb_to_cmd(req, struct io_waitid);
-	struct io_waitid_async *iwa = req->async_data;
+
+	lockdep_assert_held(&req->ctx->uring_lock);
 
 	/*
 	 * Mark us canceled regardless of ownership. This will prevent a
@@ -141,9 +159,6 @@ static bool __io_waitid_cancel(struct io_kiocb *req)
 	if (atomic_fetch_inc(&iw->refs) & IO_WAITID_REF_MASK)
 		return false;
 
-	spin_lock_irq(&iw->head->lock);
-	list_del_init(&iwa->wo.child_wait.entry);
-	spin_unlock_irq(&iw->head->lock);
 	io_waitid_complete(req, -ECANCELED);
 	io_req_queue_tw_complete(req, -ECANCELED);
 	return true;
@@ -209,8 +224,7 @@ static void io_waitid_cb(struct io_kiocb *req, io_tw_token_t tw)
 				io_waitid_drop_issue_ref(req);
 				return;
 			}
-
-			remove_wait_queue(iw->head, &iwa->wo.child_wait);
+			/* fall through to complete, will kill waitqueue */
 		}
 	}
 
-- 
2.51.0


