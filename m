Return-Path: <io-uring+bounces-6988-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AA519A56C8A
	for <lists+io-uring@lfdr.de>; Fri,  7 Mar 2025 16:48:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B8D4218907AE
	for <lists+io-uring@lfdr.de>; Fri,  7 Mar 2025 15:48:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B78A21D008;
	Fri,  7 Mar 2025 15:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dSm90Dz/"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DABEDF71
	for <io-uring@vger.kernel.org>; Fri,  7 Mar 2025 15:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741362501; cv=none; b=qWlVoykWx6Qqe2ifygwbOZ5/PhrhLRIoH9FENEY56qdhzVDCbsSsxV5+k+oLk/9C11xfnTEoGD9dvVSa3PH8maTc1wS/R/Y/4am6XZmuLm3znlRs2cLNeyvw31eR34Hup967yzgVSKC9r0A7TOTz02M7i8VVd9/4aZP6mBZZxrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741362501; c=relaxed/simple;
	bh=dFLQOj2ZLIbINKKwcv5tlrqtAVZRjLUjvTJ5sPCh7Go=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m60cndu9ooRQXSftstmgZN67NajNqaO6Nh01LraMe+sHC8AqefiaE1TDv4F9ZT07FUOpjEsmx8Alq9MWZ0Q4h9+qa+SbRX9DMKmoZN6F87D5wEVZLLo8/Av3Q9CtyqPCe72bvbKxtjXZUAg3UMFQWvTBnovEmG07IQNvgfq07SQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dSm90Dz/; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-ab78e6edb99so310725266b.2
        for <io-uring@vger.kernel.org>; Fri, 07 Mar 2025 07:48:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741362497; x=1741967297; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xq9H3dhjnKdFz5nEV9/T6Wusp8ITCyq4E/MzF/cO3lc=;
        b=dSm90Dz/MgaUYub7LDuoPz2+fnNYRh6qvl5EYGqgIZIecOIlMcI/vias095IgYOCrq
         2jamepk6lnf4XHMfa1puiq5apD3okZZBib1S6RujKVgRbXezfE1gc72yR5NoZGWuQlL+
         Nh5LyQBpR62S/zavVxf9zMN63056W+i1YFEdMQMg91JARWfvYLcUMvSkN6AxzLBRJV3B
         dQ40B3cxnrLsjaocEH9sH7uRfiGyMtlPzoNYc1agxPsLrkVnMiDsOA5hvQgN6ckIgCpo
         csvc7AcmMovosN4Ydsa/3Apm7uOhDe/WELy1xQIJHpyNCvYEKy916vqHKdgWqZhebOVz
         sxzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741362497; x=1741967297;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xq9H3dhjnKdFz5nEV9/T6Wusp8ITCyq4E/MzF/cO3lc=;
        b=UxVuJQD5cPnxBG5/k2Oq3MbPTcqfCwbwVGqBJLhJTkEzmHXZsyq7e5VsMt/4mVGlhO
         8zUOxpfYMi71b1Q5O6nm9MefnqwTWoDMeI0JV7X4FjsSCt+HeEj+OG7CML6am7ekg3gb
         MRvdLgEPokeLK533+Ybkf7xAkrJ+yIBxc0gNnf2GpCjNMJqWDO4IJWRtKSznYWUUBpIX
         idL9RVP7pXTcEJSJT8bP3Z7I5ft1qbtGscVoKeIBAsyko3+Kwl6MxN8d5JM6oaqa5DID
         8G8bm53pP28ELp0e17rs3VeRFeF36f95XcG3hlAF84Nnqz/wT7f+NpczmJV+q0HrDj2K
         P/fQ==
X-Gm-Message-State: AOJu0YzMaguag+IDDlncMougbwTXzEO9uPDeJiLdjptG/xOE7oLDP7rq
	OyX0ZRX9NLU+HTQdlBfnaoahYQAxmMabAHE8ogRdJzF896t8fgmGPSHSTQ==
X-Gm-Gg: ASbGnct1sFFFErCTBWRvCi/IPE4PkMgSxukvH8AvJwYbqMmUTYawu0K/JQQqxr7CoEe
	baoDNsff3hD+r9qlOtPB586Uq82zztd9iMnMo5wpksZTo2vC7VjKhmsH6+LuQIukG1OnCScdCnM
	489ObGkzU1NpqjCnFCwLzY8mlnB4egvUGyoE+ZBcz8E/1InCh9DGqBpdZdMSLXUqXfqpKk5NxVe
	7hvF6C8G17uog2AJwWGpbtLkuoeWWidfA8rcFga/3S4QnklXk2TVxtxqYcXJveiE9WR7Zz877Rt
	blgyfcGs4yMyY3OcPx0GBXi0JHDi
X-Google-Smtp-Source: AGHT+IFtiesCHuNrORx96JsQDdJG2OxoxpxMdqYEE5kiMfy9VSZYOWXnHl0Ur1pkEz5EXiHdShECJg==
X-Received: by 2002:a17:907:2d8d:b0:abf:6db5:c9a9 with SMTP id a640c23a62f3a-ac252f9f653mr479879066b.39.1741362497021;
        Fri, 07 Mar 2025 07:48:17 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:1422])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5e5c766a033sm2665591a12.56.2025.03.07.07.48.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Mar 2025 07:48:16 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v3 6/9] io_uring/net: pull vec alloc out of msghdr import
Date: Fri,  7 Mar 2025 15:49:07 +0000
Message-ID: <e60010541dead44a0d1d04c68c72fa69da9a5584.1741361926.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1741361926.git.asml.silence@gmail.com>
References: <cover.1741361926.git.asml.silence@gmail.com>
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


