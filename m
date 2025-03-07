Return-Path: <io-uring+bounces-6998-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9DEC4A56CEC
	for <lists+io-uring@lfdr.de>; Fri,  7 Mar 2025 17:01:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 598A917AD5E
	for <lists+io-uring@lfdr.de>; Fri,  7 Mar 2025 16:00:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DB93221577;
	Fri,  7 Mar 2025 15:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nYyzi0oB"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9F95221708
	for <io-uring@vger.kernel.org>; Fri,  7 Mar 2025 15:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741363194; cv=none; b=AjZaCpf30t4xJjP6ltMOjiJFB/HUzfEQSWiiLhVK+yWhUSnSOlX2MuFwiirAB2FYBaRfL/USM4aqvRmm3RFvXmCyRTOPdThgJBjTGY8Y1XSnxYaVem8VKCtH1IaDgDeu0O8kU+YxuaG5qKvC5TOr8tEexf7yn209ajihOUTHGn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741363194; c=relaxed/simple;
	bh=dFLQOj2ZLIbINKKwcv5tlrqtAVZRjLUjvTJ5sPCh7Go=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sCf4XcaFjXSzBXwHdrV1fr6rD6rhPPLwRo93AJ0DarDuiF0IuKSjwrLjwXIi3UtX5pL9QqWSZd376B5OrQqfTAhD3jVItR9lcTECswq9BTXRZA+CxPAMEDHVnATbXstHOs5K/DfB00RXSwLHnyAFL19OMqeqkrtcU12OOZ2haMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nYyzi0oB; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-ac2400d1c01so326444966b.1
        for <io-uring@vger.kernel.org>; Fri, 07 Mar 2025 07:59:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741363190; x=1741967990; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xq9H3dhjnKdFz5nEV9/T6Wusp8ITCyq4E/MzF/cO3lc=;
        b=nYyzi0oBTaqufiDXhi29AitTWF9bzojZ7i7dyKRGURaQ29PhTQlbQORHAObZTJoac6
         b7JYKW4U/F/Jgy55ukKMy6A+Rr4eAHwG513IDeULR4MktbNFK/Sn8A4zD3obuIQ8l9za
         WTZQrH4HzUdF4/rJLewNajjht+7PyzQc47G0NhK/INUlis4jrNHrqdrMzxxWl8xwiDJB
         rJrSa7QHzTTrAd5v+M4QnMBN9dfjhtPEHnCsZf/jww6bHZw7x0u9KFfGyeOYn02zHlcH
         fAUWKDmVfn2ElUSsiXlkUW4Ui9h+BHenDXqLd99ADSNIC151Iy/69bm9wh3kTH4Z5QJ+
         nfmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741363190; x=1741967990;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xq9H3dhjnKdFz5nEV9/T6Wusp8ITCyq4E/MzF/cO3lc=;
        b=I69J+e1nP7JRHbSivUg+CgC0SBjVSxKl39IMsUiqy40mjqfEiWgFK06A03mxiOd4Wr
         tWUBw2yCSaWWaZqRR4NBGpTf8XPZjDBXADQ7fExvSWV3chw7IyXiRa2KSsjAXBAdjU6w
         ERm+jYzHQHiayH3tnao12Be0Gfd2r+doCbF6stId5+kpL1v059Kf7UVHPNDrIZlIx0j5
         j97mvGhGVZDr6JmxZYGBY8Lyw1DCqNKG2QT0Tl6aoxA8JondO7TjCbXi/0Ei3SmgM91y
         QU3WwHSZ8cepOKEOAdxETQF7SVQlcGQZrqkZjL9rlrV0sxtL09giZzisKTjGIbYO2dWi
         Irgg==
X-Gm-Message-State: AOJu0YyGvWlftp61RJvvxFmvWQIauURULAhAU3drFeD21y+g87nTzSSW
	njGA8FknRwiihb1Kk9liKaiU6Zq03ZH99U7lMbOpBkF9s1VhJvYo3n2/yg==
X-Gm-Gg: ASbGncuFF0UwtwaPZnOc6DQ5kWOWasnCl9iI8hb/rj20FL9F3u8dc0xHwVhTW2gQ9r5
	2FvFOfJ9+E5Va5Hcp+ib1PvTdlE9pjs9Kx8Jc1YZqS2pqMCcD5bsbcnTAx7oKmuPF649Utretrj
	miGtMvCY7I06DIUyC7JytToXPqSGWNxyo/3adVR6X+38YIZZzwbDDGOSu/K5r6Cp9hu+wS5wk46
	jT2rPeImq7CMCxAX1IeX0tIbEqNX60XFpUIbag5oHsAXdDg2ZWLD1thERhFbfvhn0B83qH3sGi5
	2Je8nTB1/LwuUe8Au/IG8dEF/O0U
X-Google-Smtp-Source: AGHT+IHREUlUgY1xD3cb8snnrqKyFaNBjxZiyrxPDgvRG5l9cYyvNjCdFc+b4lp058/Dmd9FMIu8Xw==
X-Received: by 2002:a17:907:7f23:b0:abf:4a3b:454d with SMTP id a640c23a62f3a-ac26ca31a38mr6506766b.7.1741363190353;
        Fri, 07 Mar 2025 07:59:50 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:a068])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac2399d7a17sm297369166b.179.2025.03.07.07.59.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Mar 2025 07:59:49 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v4 6/9] io_uring/net: pull vec alloc out of msghdr import
Date: Fri,  7 Mar 2025 16:00:34 +0000
Message-ID: <9600ea6300f620e65d39da481c22605ddc898850.1741362889.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1741362889.git.asml.silence@gmail.com>
References: <cover.1741362889.git.asml.silence@gmail.com>
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


