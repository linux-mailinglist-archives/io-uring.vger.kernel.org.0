Return-Path: <io-uring+bounces-1165-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9289C8819AC
	for <lists+io-uring@lfdr.de>; Wed, 20 Mar 2024 23:58:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2F517B24E7F
	for <lists+io-uring@lfdr.de>; Wed, 20 Mar 2024 22:58:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3AD285C7F;
	Wed, 20 Mar 2024 22:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="VYrs/SvY"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0647A381D1
	for <io-uring@vger.kernel.org>; Wed, 20 Mar 2024 22:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710975483; cv=none; b=UatTgfOseKXte1WFaCr7IYVsrH7lmn9Egsk3J3Qg296gbjxIIhUm4zEgArC8hpgUvDJABCBYDOt9jqPvkhjENi//RwGKYxOuC2gREhEmXdp8YEhEAfmD/2Rq+LetAre3JU7GWiohiamhV+d8kmwo0UwTDGEuHcDHEbiJuhndC5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710975483; c=relaxed/simple;
	bh=i3ZO/MQd00/JoBnmbo/zhQ8cFmmTzPDS293qrfzRk8A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hQTuETrtLbz6hmZU/yJsRnpWvOxpC/KMztPPYKfP1tbPbOZ+8Ojdow2vW1GyKcXUWJ86/+qourHzECrSJ3oYMshJeVIxgMAN3Jn2zyZ8lNRtaB4KbizDPA53h/b/huEY0fghDJ2qAFpj/LR5JPGTLY/whrUGvzUSQ2AJ62OnbxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=VYrs/SvY; arc=none smtp.client-ip=209.85.166.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f179.google.com with SMTP id e9e14a558f8ab-366b8b0717cso600325ab.1
        for <io-uring@vger.kernel.org>; Wed, 20 Mar 2024 15:58:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1710975480; x=1711580280; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Su5svnrduXYJh/wm/Ca9h9p5ZzSZLkUyEZMUZZYxFx0=;
        b=VYrs/SvYNu5FzIsRfmCfiO32pkfLWJ4rEmmQqtIghfctCd0vCunxW7oyLecL1oY5NQ
         EtddgU3L/a4Y4PuZgM4v27ZsDjyDYZy/SYHm1cJshwXjUCvGWumKNyOV48n/6zakHfGT
         yKA97qm5gkBjPpmFP5TJ7TnTrFbCYk/yKrss/UT6Jf7QxNct8o6sXwfvBkkLFjy5ztY7
         M+LJPSKVl1QRhART61h+XVKAqJdG5rcklyhLMCkpEwYpkXkt9p2VkocAScvAvOk36LUR
         AITFlRGFi6qlZ4vjL3lkibXvPoD7AuhJ8WlsyQCMgpi8uLDEbgAx9QgWRNf1jJ/dwo75
         JzmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710975480; x=1711580280;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Su5svnrduXYJh/wm/Ca9h9p5ZzSZLkUyEZMUZZYxFx0=;
        b=Cpn3C5MNe/edfFmSk64XZIW+k9wmgZlVwarvHOp/6xjiRxPNX+HGrbz4liB8aEwkHd
         aNyebYBd43YBTBVWlamZaFp3JZGWAnnN+Xq3jvAx4DqcFV/eeaHPD7kiGwsmP97KqNfL
         oxacqISJEbPiCdfsDCygwPTcXccxR7OngyXi3CUEkiYspjQM32VTIGBQQ6tcp+AmB4mZ
         FBBpjZTRlIRum1o48iJ4giMQOP57u8iuUBiMft8h2K3DgEcMsl3JCrUQrLusuTHhHYl4
         aJmDwEBbsDuWS8Ott4E9OBmDj725RaSPRt1hozNqs7/kMz4NaTd4XXHKIiPYCswbklB9
         GGWQ==
X-Gm-Message-State: AOJu0YxHCflJvKEOdCI9ESy7EAxUcegC697ubC53CL4wic5OsR0TZ0f0
	x5X1tHfez6JD97c/7uE2b8C3kol5Yxn4R3vHmsA9USmkMsYejh8VzhbPO2sTQzuUJMp7nTSGY0d
	i
X-Google-Smtp-Source: AGHT+IFjnDTf35oAbzLEpm1PUszkguGP6g8BJPzPkHI71G5plcoyLCtPZR9tNFsozBmMJbVQKbmTwg==
X-Received: by 2002:a5e:a80c:0:b0:7cf:24de:c5f with SMTP id c12-20020a5ea80c000000b007cf24de0c5fmr1835513ioa.1.1710975479720;
        Wed, 20 Mar 2024 15:57:59 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id z19-20020a6b0a13000000b007cf23a498dcsm434384ioi.38.2024.03.20.15.57.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Mar 2024 15:57:57 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 03/17] io_uring/net: unify cleanup handling
Date: Wed, 20 Mar 2024 16:55:18 -0600
Message-ID: <20240320225750.1769647-4-axboe@kernel.dk>
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

Now that recv/recvmsg both do the same cleanup, put it in the retry and
finish handlers.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/net.c | 26 +++++++++++---------------
 1 file changed, 11 insertions(+), 15 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index d571115f4909..2df59fb19a15 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -688,10 +688,16 @@ int io_recvmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	return 0;
 }
 
-static inline void io_recv_prep_retry(struct io_kiocb *req)
+static inline void io_recv_prep_retry(struct io_kiocb *req,
+				      struct io_async_msghdr *kmsg)
 {
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 
+	if (kmsg->free_iov) {
+		kfree(kmsg->free_iov);
+		kmsg->free_iov = NULL;
+	}
+
 	req->flags &= ~REQ_F_BL_EMPTY;
 	sr->done_io = 0;
 	sr->len = 0; /* get from the provided buffer */
@@ -723,7 +729,7 @@ static inline bool io_recv_finish(struct io_kiocb *req, int *ret,
 		struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 		int mshot_retry_ret = IOU_ISSUE_SKIP_COMPLETE;
 
-		io_recv_prep_retry(req);
+		io_recv_prep_retry(req, kmsg);
 		/* Known not-empty or unknown state, retry */
 		if (cflags & IORING_CQE_F_SOCK_NONEMPTY || kmsg->msg.msg_inq < 0) {
 			if (sr->nr_multishot_loops++ < MULTISHOT_MAX_RETRY)
@@ -732,10 +738,9 @@ static inline bool io_recv_finish(struct io_kiocb *req, int *ret,
 			sr->nr_multishot_loops = 0;
 			mshot_retry_ret = IOU_REQUEUE;
 		}
-		if (issue_flags & IO_URING_F_MULTISHOT)
+		*ret = io_setup_async_msg(req, kmsg, issue_flags);
+		if (*ret == -EAGAIN && issue_flags & IO_URING_F_MULTISHOT)
 			*ret = mshot_retry_ret;
-		else
-			*ret = -EAGAIN;
 		return true;
 	}
 
@@ -746,6 +751,7 @@ static inline bool io_recv_finish(struct io_kiocb *req, int *ret,
 		*ret = IOU_STOP_MULTISHOT;
 	else
 		*ret = IOU_OK;
+	io_req_msg_cleanup(req, kmsg, issue_flags);
 	return true;
 }
 
@@ -929,11 +935,6 @@ int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 	if (!io_recv_finish(req, &ret, kmsg, mshot_finished, issue_flags))
 		goto retry_multishot;
 
-	if (mshot_finished)
-		io_req_msg_cleanup(req, kmsg, issue_flags);
-	else if (ret == -EAGAIN)
-		return io_setup_async_msg(req, kmsg, issue_flags);
-
 	return ret;
 }
 
@@ -1037,11 +1038,6 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 	if (!io_recv_finish(req, &ret, kmsg, ret <= 0, issue_flags))
 		goto retry_multishot;
 
-	if (ret == -EAGAIN)
-		return io_setup_async_msg(req, kmsg, issue_flags);
-	else if (ret != IOU_OK && ret != IOU_STOP_MULTISHOT)
-		io_req_msg_cleanup(req, kmsg, issue_flags);
-
 	return ret;
 }
 
-- 
2.43.0


