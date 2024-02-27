Return-Path: <io-uring+bounces-779-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F2616869875
	for <lists+io-uring@lfdr.de>; Tue, 27 Feb 2024 15:33:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 62EE81F25705
	for <lists+io-uring@lfdr.de>; Tue, 27 Feb 2024 14:33:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EE4354FB1;
	Tue, 27 Feb 2024 14:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="YEKZ+pxO"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f42.google.com (mail-io1-f42.google.com [209.85.166.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF048146003
	for <io-uring@vger.kernel.org>; Tue, 27 Feb 2024 14:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709044334; cv=none; b=RlMOsSamxeRnBEi2JOAw2wwetpnwzQ0uTDZa09y8v/UaCYMEmHSJ/kfxiqIYpLH+urj61lonrcGBqGpbMAhWmailElaLFRnwf0sNM9wYaxhQOUHG7fgOMAvYljuM/qxHnNTpbf9WVRwvK4CKxTzZ6+u7ptRO8GoNELmhwLSpyTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709044334; c=relaxed/simple;
	bh=3UdTML6FLbG8HjREZ3OMF2ve9lvmGJGNdTfd8mFuocs=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=UC4lPxl99oPDbOLbDdQkLM2w4vaeK7G1+a58KK0oR5vBtCfMJ7Q+WCh4FEFUYzf3s04se54sgXNfdZt6/WWzbX1w5aKpZv0gxCu+88IqJxwk16p6AzHLbfHK/hZHu/jQI9GNa1Up/NLkX6e3IN0hkozxWxB4znwgOK5htH7It24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=YEKZ+pxO; arc=none smtp.client-ip=209.85.166.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f42.google.com with SMTP id ca18e2360f4ac-7c495be1924so65801839f.1
        for <io-uring@vger.kernel.org>; Tue, 27 Feb 2024 06:32:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1709044330; x=1709649130; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Tcsjg/dvbThnbFXEiecEoRAg/o04RfYuLMA2awh0jlA=;
        b=YEKZ+pxO3z9+w2txw6nOX11AhHFEhgdW+AeEXq/NO5p9SXa4SfHo6zYMBIoprN+cfc
         QG0aq++p2afLOIbRSGUcdLwTFrddYoDRT0KXialCF/i8WD4sTA1TiwfVMsE2OL/iScQh
         tFxQ+iBGXYRO7kOnEDx2di6eJZWgnwrSTFeKPhKtQYMewZf9kgR9NavPLx/KzHuWaGCA
         3NogQYd74c9q+9Mq4DpYulzxGavskALbsNRw7GWnXJPzepLhUj7KdtMno9C84Y2ttv7g
         WR/rOo/FFn2ZuxmGl6jo1qOyflby3LIPxFLWdgjRUX0KsLJYRf8FqsGnAp8YVr+v+yp4
         jLRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709044330; x=1709649130;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Tcsjg/dvbThnbFXEiecEoRAg/o04RfYuLMA2awh0jlA=;
        b=TNh3A9w235raz2PwHAXSNfDc+AfaXfLAGlgp0vQvsi63UnKhNEWvurLeFScDLddbnD
         x6RZEMdbn2nJgV5WbOdFe3vstiF1d9WEtRqS01WD9a9us7idqecpO98BTgiJK4GT21p0
         3ZLGixgoRF55T9uW8Lp2PQsh9q1komSY1ycI8yhO7YY17UfZNaz7Yx/v6WTKqGNEHN/8
         ybptsR6WnEdp8Xcb7Quh7ON6NTjFDHRNUTKgdPtVMCcgaPOATpeO7RsDZY5p4vy6+rms
         lCu7zVnMzCv9JEgqXA6zHkguXaXAbs4eD2A9U/q8IldumUMzn+WDjxN9xAA8wExiRhkb
         2Efg==
X-Gm-Message-State: AOJu0YwnESwYyXnlK4Oe9tBJXkN9yEhnKkxGTkWiv06pyLs5AJIK+Bqw
	RQ/wpO2d5Fu/GvHNwkiGjVxiYRxp/QYcQxgA/DJT17/ry1riYt3pWKGH9KX13X45lACqOP1xxlE
	A
X-Google-Smtp-Source: AGHT+IHbv+O/K4uEYZHVvQLPWF6QcjZMlBXxoq0+HGncOLyuOZDMAJRvF3AGvuYdIQE53NNDUSNizA==
X-Received: by 2002:a05:6e02:1d98:b0:365:2f19:e58e with SMTP id h24-20020a056e021d9800b003652f19e58emr9905801ila.3.1709044330389;
        Tue, 27 Feb 2024 06:32:10 -0800 (PST)
Received: from ?IPV6:2620:10d:c085:21e1::1138? ([2620:10d:c090:400::5:6000])
        by smtp.gmail.com with ESMTPSA id m13-20020a633f0d000000b005cd835182c5sm5786363pga.79.2024.02.27.06.32.09
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Feb 2024 06:32:09 -0800 (PST)
Message-ID: <0dd1079b-03a4-47ec-866b-73317e7e218a@kernel.dk>
Date: Tue, 27 Feb 2024 07:32:08 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: io-uring <io-uring@vger.kernel.org>
From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH v2] io_uring/net: improve the usercopy for sendmsg/recvmsg
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

We're spending a considerable amount of the sendmsg/recvmsg time just
copying in the message header. And for provided buffers, the known
single entry iovec.

Be a bit smarter about it and enable/disable user access around our
copying. In a test case that does both sendmsg and recvmsg, the
runtime before this change (averaged over multiple runs, very stable
times however):

Kernel          Time            Diff
====================================
-git            4720 usec
-git+commit     4311 usec       -8.7%

and looking at a profile diff, we see the following:

0.25%     +9.33%  [kernel.kallsyms]     [k] _copy_from_user
4.47%     -3.32%  [kernel.kallsyms]     [k] __io_msg_copy_hdr.constprop.0

where we drop more than 9% of _copy_from_user() time, and consequently
add time to __io_msg_copy_hdr() where the copies are now attributed to,
but with a net win of 6%.

In comparison, the same test case with send/recv runs in 3745 usec, which
is (expectedly) still quite a bit faster. But at least sendmsg/recvmsg is
now only ~13% slower, where it was ~21% slower before.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

v2:	- add missing access_ok() for the iovec copy
	- only copy iov->iov_len, we never use iov->iov_base

diff --git a/io_uring/net.c b/io_uring/net.c
index fcbaeb7cc045..7bba7aa3a014 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -282,12 +282,17 @@ static int __io_msg_copy_hdr(struct io_kiocb *req, struct io_async_msghdr *iomsg
 	struct user_msghdr msg;
 	int ret;
 
-	if (copy_from_user(&msg, sr->umsg, sizeof(*sr->umsg)))
+	if (!user_access_begin(sr->umsg, sizeof(*sr->umsg)))
 		return -EFAULT;
 
-	ret = __copy_msghdr(&iomsg->msg, &msg, addr);
-	if (ret)
-		return ret;
+	ret = -EFAULT;
+	unsafe_get_user(msg.msg_name, &sr->umsg->msg_name, uaccess_end);
+	unsafe_get_user(msg.msg_namelen, &sr->umsg->msg_namelen, uaccess_end);
+	unsafe_get_user(msg.msg_iov, &sr->umsg->msg_iov, uaccess_end);
+	unsafe_get_user(msg.msg_iovlen, &sr->umsg->msg_iovlen, uaccess_end);
+	unsafe_get_user(msg.msg_control, &sr->umsg->msg_control, uaccess_end);
+	unsafe_get_user(msg.msg_controllen, &sr->umsg->msg_controllen, uaccess_end);
+	msg.msg_flags = 0;
 
 	if (req->flags & REQ_F_BUFFER_SELECT) {
 		if (msg.msg_iovlen == 0) {
@@ -295,11 +300,14 @@ static int __io_msg_copy_hdr(struct io_kiocb *req, struct io_async_msghdr *iomsg
 			iomsg->fast_iov[0].iov_base = NULL;
 			iomsg->free_iov = NULL;
 		} else if (msg.msg_iovlen > 1) {
-			return -EINVAL;
+			ret = -EINVAL;
+			goto uaccess_end;
 		} else {
-			if (copy_from_user(iomsg->fast_iov, msg.msg_iov,
-					   sizeof(*msg.msg_iov)))
-				return -EFAULT;
+			/* we only need the length for provided buffers */
+			if (!access_ok(&msg.msg_iov[0].iov_len, sizeof(__kernel_size_t)))
+				goto uaccess_end;
+			unsafe_get_user(iomsg->fast_iov[0].iov_len,
+					&msg.msg_iov[0].iov_len, uaccess_end);
 			sr->len = iomsg->fast_iov[0].iov_len;
 			iomsg->free_iov = NULL;
 		}
@@ -307,10 +315,16 @@ static int __io_msg_copy_hdr(struct io_kiocb *req, struct io_async_msghdr *iomsg
 		if (ddir == ITER_DEST && req->flags & REQ_F_APOLL_MULTISHOT) {
 			iomsg->namelen = msg.msg_namelen;
 			iomsg->controllen = msg.msg_controllen;
-			if (io_recvmsg_multishot_overflow(iomsg))
-				return -EOVERFLOW;
+			if (io_recvmsg_multishot_overflow(iomsg)) {
+				ret = -EOVERFLOW;
+uaccess_end:
+				user_access_end();
+				return ret;
+			}
 		}
+		user_access_end();
 	} else {
+		user_access_end();
 		iomsg->free_iov = iomsg->fast_iov;
 		ret = __import_iovec(ddir, msg.msg_iov, msg.msg_iovlen,
 				     UIO_FASTIOV, &iomsg->free_iov,
@@ -319,6 +333,12 @@ static int __io_msg_copy_hdr(struct io_kiocb *req, struct io_async_msghdr *iomsg
 			ret = 0;
 	}
 
+	ret = __copy_msghdr(&iomsg->msg, &msg, addr);
+	if (!ret)
+		return 0;
+
+	kfree(iomsg->free_iov);
+	iomsg->free_iov = NULL;
 	return ret;
 }
 
-- 
Jens Axboe


