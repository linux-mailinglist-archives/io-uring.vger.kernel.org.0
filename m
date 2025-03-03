Return-Path: <io-uring+bounces-6911-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 28070A4C5BC
	for <lists+io-uring@lfdr.de>; Mon,  3 Mar 2025 16:52:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6C3427A7048
	for <lists+io-uring@lfdr.de>; Mon,  3 Mar 2025 15:49:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6CAB213E67;
	Mon,  3 Mar 2025 15:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dqeCb729"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF48C214A68
	for <io-uring@vger.kernel.org>; Mon,  3 Mar 2025 15:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741017012; cv=none; b=Ru1b1fT2LFg+3iRWCEhvkGAjCK7EDFuQWlC+4bEm7sLonqhp1WsH8khLiBoeZjy25I4MHdK0TYwaPW67sMkie5LelVeso2jeeWpAQ2EwHKrfIgDFzE7rY7CJ3XIFtU4GkpdaOTA/Umx6eMR5NoyiEQHqEAxN7Q6C2Y53VnsLzmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741017012; c=relaxed/simple;
	bh=dFLQOj2ZLIbINKKwcv5tlrqtAVZRjLUjvTJ5sPCh7Go=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u8senyEWkPauWPffNxCFhaAdjwALRxmCTrbI3+T6qqnAQfuT1ZPHmMWHpUv03b41RvIKO6Q9qrRNzqADOjM42qxCVLTsquokw9SgaHTISanl4dUqtaJtdYkL+hQJYc3aTqgUOoR8jzOT7oZf/q0u5ED7vE53tPX97NG+Z0c6WZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dqeCb729; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-5e033c2f106so5222851a12.3
        for <io-uring@vger.kernel.org>; Mon, 03 Mar 2025 07:50:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741017009; x=1741621809; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xq9H3dhjnKdFz5nEV9/T6Wusp8ITCyq4E/MzF/cO3lc=;
        b=dqeCb729v11PK/dvlvvXCk8+NwiFdAh+BpzROWdPRcNfNQPbDfdu1DV9IvOXUOgpxu
         Twuh/B2K62/RpDbn3hbFsUYo6v8X7jN23+5Ne3nYpO/PrWHN0COc7kZu+MmuR6G2oLV0
         SQP1wGc+JJu1LOmrIdX9WKHQ6cg1zR47z0t12+q2q7/AifOolJniq8+AAZcILqab2Hmx
         sDYHsZuhW/+h1afV3n6TDnrAATC1vCaAbHeAOExMIUGjMyEqFWI+JoEo0eoLobBotMr/
         Zrz27CAb9AW6hfsmzFm4RGS1cz4CpE6jjntLN0gvpcjevATpaFGKAI5AggJhWyXOGkbw
         GV8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741017009; x=1741621809;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xq9H3dhjnKdFz5nEV9/T6Wusp8ITCyq4E/MzF/cO3lc=;
        b=wSguBSBfLdEBT/nOA1Um6Yrb8QU5ouJT0+GLjqiUoJl3g/ng+mk8DN4DbPmddrNTOv
         WqYU5O9k9SS9gfbHhGKvrN81EDYkJDEpFG34wpPN5DvriCL2jVr190F89FJMbTeGtGtb
         /NgtG2sUeEK4FFOLxX7MWdXZcu1V6EuXv59k9gquNUgBPvhCjKvT5rC8/d6bbwzbHdnP
         mCmb1L2NxK3fgvcLk43mY6DbYMEYg0XwLMe5CIAIFrZNmAv3phcceXvyNP4SX2s26cA8
         Mr8Cr6hAWqpT8vS37rjH7WVon4z0hoMD1K9Y3dh6nmHTFYF+deOvBgYJEDcQKtzLH6Ry
         gOCA==
X-Gm-Message-State: AOJu0YxGImfatCISFKqDgv3dUqgw5A0si/t1UYOCzZC5ujHmPAXgM7vL
	nHsai8+UKwhBeNWTwAdS2rxw9Wapwqk5JDY6qwS8n7iFRgeGf4AIF6CP/A==
X-Gm-Gg: ASbGncvks/vfE6Xe3VdzaZHYkLwDmv4StDUpCpHcAcj70D6AcDw9dn/oqi61GaaVysX
	NNVWzYrJDylzm/KSK7Z0ALbigFaeKbjPXo/piniRrsz5l1S2F7M/Q/aySupVoIHwV2+4I4wThgQ
	7k7An5iOZEoBrLkoM0vLHTaNHnjZ8gPq0Qot7ZrRv9ippd6uXl1uFcBXmzLG4bCbf4MIhmYIkT/
	3SLh9bL9MaLcm26jYJjGSMPxq4/mguFrnVFe3ZQ8xPK2iSDQa50316USXLqCUswreKdUK4vck6N
	U8DvhPX34BdX0r+cyXyC1QjdyQe3
X-Google-Smtp-Source: AGHT+IE+iN/p5Bsx4Qg6XD+UpUhQNchjUI5vLe8Fy6Cod7Xli4OgnfeJCqByb1OdGNiRRlsT0c0DFQ==
X-Received: by 2002:a05:6402:1d4d:b0:5dc:796f:fc86 with SMTP id 4fb4d7f45d1cf-5e4d6af436amr37347679a12.16.1741017008478;
        Mon, 03 Mar 2025 07:50:08 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:299a])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-abf4e50c80esm492335266b.61.2025.03.03.07.50.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Mar 2025 07:50:07 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	Andres Freund <andres@anarazel.de>
Subject: [PATCH 6/8] io_uring/net: pull vec alloc out of msghdr import
Date: Mon,  3 Mar 2025 15:51:01 +0000
Message-ID: <7ddd011c69f9cc12229c43696655fc0d36a54916.1741014186.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1741014186.git.asml.silence@gmail.com>
References: <cover.1741014186.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

I'll need more control over iovec management, move
io_net_import_vec() out of io_msg_copy_hdr().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/net.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 33076bd22c16..cbb889b85cfc 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -253,12 +253,8 @@ static int io_compat_msg_copy_hdr(struct io_kiocb *req,
 				return -EFAULT;
 			sr->len = tmp_iov.iov_len;
 		}
-
-		return 0;
 	}
-
-	return io_net_import_vec(req, iomsg, (struct iovec __user *)uiov,
-				 msg->msg_iovlen, ddir);
+	return 0;
 }
 
 static int io_copy_msghdr_from_user(struct user_msghdr *msg,
@@ -328,10 +324,8 @@ static int io_msg_copy_hdr(struct io_kiocb *req, struct io_async_msghdr *iomsg,
 				return -EFAULT;
 			sr->len = tmp_iov.iov_len;
 		}
-		return 0;
 	}
-
-	return io_net_import_vec(req, iomsg, msg->msg_iov, msg->msg_iovlen, ddir);
+	return 0;
 }
 
 static int io_sendmsg_copy_hdr(struct io_kiocb *req,
@@ -342,6 +336,12 @@ static int io_sendmsg_copy_hdr(struct io_kiocb *req,
 	int ret;
 
 	ret = io_msg_copy_hdr(req, iomsg, &msg, ITER_SOURCE, NULL);
+	if (unlikely(ret))
+		return ret;
+
+	if (!(req->flags & REQ_F_BUFFER_SELECT))
+		ret = io_net_import_vec(req, iomsg, msg.msg_iov, msg.msg_iovlen,
+					ITER_SOURCE);
 	/* save msg_control as sys_sendmsg() overwrites it */
 	sr->msg_control = iomsg->msg.msg_control_user;
 	return ret;
@@ -719,6 +719,13 @@ static int io_recvmsg_copy_hdr(struct io_kiocb *req,
 	ret = io_msg_copy_hdr(req, iomsg, &msg, ITER_DEST, &iomsg->uaddr);
 	if (unlikely(ret))
 		return ret;
+
+	if (!(req->flags & REQ_F_BUFFER_SELECT)) {
+		ret = io_net_import_vec(req, iomsg, msg.msg_iov, msg.msg_iovlen,
+					ITER_DEST);
+		if (unlikely(ret))
+			return ret;
+	}
 	return io_recvmsg_mshot_prep(req, iomsg, msg.msg_namelen,
 					msg.msg_controllen);
 }
-- 
2.48.1


