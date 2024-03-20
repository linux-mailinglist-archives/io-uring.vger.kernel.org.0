Return-Path: <io-uring+bounces-1171-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 592AD8819B2
	for <lists+io-uring@lfdr.de>; Wed, 20 Mar 2024 23:58:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0E3E92829E8
	for <lists+io-uring@lfdr.de>; Wed, 20 Mar 2024 22:58:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4479885C65;
	Wed, 20 Mar 2024 22:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="cvGB6TXt"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3CD485C74
	for <io-uring@vger.kernel.org>; Wed, 20 Mar 2024 22:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710975493; cv=none; b=Yn6+uDLZuZSOldoTn5YSXZWRYIRvJyWvhcYJwJatJBHdK7dj5QsScqxJiWLupuHYFkrpn/IsGrSSkI6oPCkQAEl54yM8H2EvVCS++TMJ6nJoRotqLef/mYsGcnSfR2+tQYNKMO207LZAsqNMGBIwN2m24w+1mQpcLJp/1K78cJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710975493; c=relaxed/simple;
	bh=avWACbZY8rQBC3TVNGyl7ZB+G5kSSJrbeH+QRlrTXgo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gNTc/ih5qwgRNdzH9xIWrQ3KMYO5f2J7ZA7a6VQkzQN7W8auyBZDBKKtKe3mkxWo2aumiarssuXu3zNzafAnf8wJ2FNcQJtLhxaH50o4hlU+tB4XE0yGle+rbGI2F5FiOiBpfMiN5ZyoWMcBzhSFOxCIsD8lJQbeLYRUxQiw29A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=cvGB6TXt; arc=none smtp.client-ip=209.85.166.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f173.google.com with SMTP id e9e14a558f8ab-367c7daa395so273255ab.1
        for <io-uring@vger.kernel.org>; Wed, 20 Mar 2024 15:58:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1710975490; x=1711580290; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R/6uV6v08bWDnGXGmh/MSUfDQcxo0+hKEOxpX5v6xvo=;
        b=cvGB6TXtx1hN7ovY+QvUoAYc3tqImBNcOnSNUJgOH12gNAgtN3asTyQcYD508/0JBK
         DQO+Gq9oH6ZkUDoNnpvuu0fhQNcBzkxWzatHtqYK3UeZOITqA00vrFEljzBIvntIn9bv
         WTzsIs7ZnBqSIsODl2//ZF3otgPF+WrSf3Bo+XxQN/HPNQukl8tBnTLjS/7QZDbbgsjd
         4Od8tug9WWTffKY/xB4quAUeb/e3H51neH27IsA8N8jIfYF3OyfEvET+bGyjHu7H5IvM
         7q1rBRuyMR/AMnNOw3KKbM5bXjYLJdVzLzDWr1zXy7P11QhVvUHa9RZ9iBUq+VObEsUp
         y1Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710975490; x=1711580290;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=R/6uV6v08bWDnGXGmh/MSUfDQcxo0+hKEOxpX5v6xvo=;
        b=Gs1ZmpmD2GtpYIdwuTTVNR2/HW6CLFbEHj0hKYBHRWksuwoEazUlav1xlt4N7IuPQY
         9ceFs8xDe/OXCdEU5Uyeo+1xBTm9kre6AEimGbF6+0bk61mfLat2fD6wlDg4oF2Yauka
         8LHr7dGm/X5eXpQvwkMkGZew0XXFHBefBplO6pmOXdgfMyW8hXQBxpJRj47MoW+1IuMZ
         T0dFFiMDvx1IZLN7BkxUzHHUuk/BcHFVENsgnqnFGDit17oqK4/seWXV+wNyQj1KdWB7
         z6oAKJBvNqWm0YdY+Z8kwplpQvzeey/EMgLQ5vu6faJ2Eiodxr0kqnxFAbCApgki+6BP
         O4yQ==
X-Gm-Message-State: AOJu0YydlFZVNzKbJT2Rg24m+i42C2P3A/FuNaGpb+MaMg9BVKU4J1eR
	fhdmhD81WD6wXVBY3ZNgFEOT6EpdjDaTLwLc9camrrP5Nt+qgi+nONx7Gd1LKuQaYBvDUUKpmek
	Y
X-Google-Smtp-Source: AGHT+IF6TfnFjXXkSU6yYtKW3lsUbB9fcVsbfWwMw5xC5SW9pWf/nbnS7T1SwOcWSSygDXobFLK+3A==
X-Received: by 2002:a6b:c9d2:0:b0:7cc:6b9:a59c with SMTP id z201-20020a6bc9d2000000b007cc06b9a59cmr7464638iof.1.1710975490405;
        Wed, 20 Mar 2024 15:58:10 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id z19-20020a6b0a13000000b007cf23a498dcsm434384ioi.38.2024.03.20.15.58.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Mar 2024 15:58:09 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 09/17] io_uring/net: drop 'kmsg' parameter from io_req_msg_cleanup()
Date: Wed, 20 Mar 2024 16:55:24 -0600
Message-ID: <20240320225750.1769647-10-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240320225750.1769647-1-axboe@kernel.dk>
References: <20240320225750.1769647-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Now that iovec recycling is being done, the iovec is no longer being
freed in there. Hence the kmsg parameter is now useless.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/net.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 20d6427f4250..9472a66e035c 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -415,7 +415,6 @@ int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 }
 
 static void io_req_msg_cleanup(struct io_kiocb *req,
-			       struct io_async_msghdr *kmsg,
 			       unsigned int issue_flags)
 {
 	req->flags &= ~REQ_F_NEED_CLEANUP;
@@ -461,7 +460,7 @@ int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
 			ret = -EINTR;
 		req_set_fail(req);
 	}
-	io_req_msg_cleanup(req, kmsg, issue_flags);
+	io_req_msg_cleanup(req, issue_flags);
 	if (ret >= 0)
 		ret += sr->done_io;
 	else if (sr->done_io)
@@ -515,7 +514,7 @@ int io_send(struct io_kiocb *req, unsigned int issue_flags)
 		ret += sr->done_io;
 	else if (sr->done_io)
 		ret = sr->done_io;
-	io_req_msg_cleanup(req, kmsg, issue_flags);
+	io_req_msg_cleanup(req, issue_flags);
 	io_req_set_res(req, ret, 0);
 	return IOU_OK;
 }
@@ -723,7 +722,7 @@ static inline bool io_recv_finish(struct io_kiocb *req, int *ret,
 		*ret = IOU_STOP_MULTISHOT;
 	else
 		*ret = IOU_OK;
-	io_req_msg_cleanup(req, kmsg, issue_flags);
+	io_req_msg_cleanup(req, issue_flags);
 	return true;
 }
 
@@ -1209,7 +1208,7 @@ int io_send_zc(struct io_kiocb *req, unsigned int issue_flags)
 	 */
 	if (!(issue_flags & IO_URING_F_UNLOCKED)) {
 		io_notif_flush(zc->notif);
-		io_req_msg_cleanup(req, kmsg, 0);
+		io_req_msg_cleanup(req, 0);
 	}
 	io_req_set_res(req, ret, IORING_CQE_F_MORE);
 	return IOU_OK;
@@ -1270,7 +1269,7 @@ int io_sendmsg_zc(struct io_kiocb *req, unsigned int issue_flags)
 	 */
 	if (!(issue_flags & IO_URING_F_UNLOCKED)) {
 		io_notif_flush(sr->notif);
-		io_req_msg_cleanup(req, kmsg, 0);
+		io_req_msg_cleanup(req, 0);
 	}
 	io_req_set_res(req, ret, IORING_CQE_F_MORE);
 	return IOU_OK;
-- 
2.43.0


