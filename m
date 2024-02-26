Return-Path: <io-uring+bounces-772-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 35B438684CD
	for <lists+io-uring@lfdr.de>; Tue, 27 Feb 2024 00:55:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 56DAB1C22EF7
	for <lists+io-uring@lfdr.de>; Mon, 26 Feb 2024 23:55:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06F2F135A50;
	Mon, 26 Feb 2024 23:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="fJchxITo"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0194A1E894
	for <io-uring@vger.kernel.org>; Mon, 26 Feb 2024 23:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708991704; cv=none; b=NgHLUtUKOwft3v8oFbUxIcKmdFtcC9byh1MOdvvlzc+URcgLRzC6aR6RhLYct3x2rIrhKHpv6bAHG8LfFT4lSq63R+8VvpbYkJq02D6NtOerGQALIwefKOwXCbrawmGT92C18NlacreOUJ15YEbRTc1272Z0INAfoKIdVRm2siY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708991704; c=relaxed/simple;
	bh=mBD2/CWzTf7raVUNGIA2TtqtPZZ7VpS8ZXiMaUmUwjA=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=lpRlsrYYF8AVYXLJyESd/KdcmSwmM2Jk1JOj103ZiNzCoHeo2F8lr3P3kf7XHtvwpl+Njb7oVlkwNeapm+6/Pd9ilrfv5x6xTs/r9Lhi08ntgpvT4ziEBALgtDFtbwOAhDj+QWJMXI0YpddxDWqpjoY7fZkBinvOyB1ruHSrxMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=fJchxITo; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-6e45c698090so705333b3a.0
        for <io-uring@vger.kernel.org>; Mon, 26 Feb 2024 15:55:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1708991700; x=1709596500; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KBHeR9aqT2KtI+Jg1PoB/RqcsUPOEy0a9xgnnkqfgBw=;
        b=fJchxIToajzOfg43rLhg+l8k8oAQwmFm4I4skefG+OtQoWFrE4KaKZe6EAQWLgOB51
         J6G37t1nLi4JWmHJ+ByD8nBtuS+VI4sJlzsWV6NzW2mW9B9mhLgV62cz6PZNNMvrk2pu
         sGm2pYuFjSTcgTB8HKAFLznYrADxlW9cjJfessop9yMUFt42W6aS4+7/o26tXz04f5Mi
         3ZYBVUV4AA6p9VtyTGZB97SUsF+BLKgV0BFQE/DvFAian/B3jtZunnwduYaFgFDMsQKl
         maHidFHqoO7enfjZSXpPw9vNWuyK839nkg/W5w9AUVHjoOPJ0lAlp4BDQR5YddUGMTx4
         CrmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708991700; x=1709596500;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=KBHeR9aqT2KtI+Jg1PoB/RqcsUPOEy0a9xgnnkqfgBw=;
        b=lBb5SCwLkv2v57ZGLivhj63PPeQYVGHHL9UP+3nC5xmHqs0M8ZhrxanwkAeaEOvJ/k
         twRakoaMwtuYiAQMBbfFtvSmMgV0mXOOrtWLghEfoU6/smjqanJV+YJmNz95jTpB/YVZ
         aU3FLqPYLFkyKfFUL4iM1pIQNdOtfuuQi35O2z9XVZRuz/nKvHqovh+gw5sjyrc57coF
         p1V3cjqg7h0bC1SnMF0f0cGv9bKl8lbpk2qsKCwJFKcDEwK8IlukVkM1fHjoapRD2Cx6
         lWSaam7tIOtJ2kszemvq59p6YPTY8e/qTx3ODa9IngC76Z225JJjgRzE7l5w66VY4sTQ
         6WbQ==
X-Gm-Message-State: AOJu0Yxjf6PD6z/FtaJNJxO51k9XMkDkFW1veycsVOwmZg5bghgcMTVS
	z5j3gBJnya9XsNytIjkbfI+quRs3+N7bmkWZga/e02AlJktXZBTVRItkSe4bcfKLdOgQxtZZxl/
	J
X-Google-Smtp-Source: AGHT+IHvvVhO6Wq7W/EvTPQnyUcsOuAfMhxRyzF/bjTFw0MjOuBPIYEhzCrpV6IGH0dff7mfUj7NYQ==
X-Received: by 2002:a05:6a00:2da4:b0:6e5:109d:8373 with SMTP id fb36-20020a056a002da400b006e5109d8373mr5523720pfb.0.1708991700323;
        Mon, 26 Feb 2024 15:55:00 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id c7-20020a62f847000000b006e5359e621csm1855914pfm.182.2024.02.26.15.54.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Feb 2024 15:54:59 -0800 (PST)
Message-ID: <3cbf09fa-74e6-42f7-ad98-27a48556ba29@kernel.dk>
Date: Mon, 26 Feb 2024 16:54:58 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: io-uring <io-uring@vger.kernel.org>,
 Pavel Begunkov <asml.silence@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring/net: improve the usercopy for sendmsg/recvmsg
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

Since we discussed sendmsg vs send in the previous thread, I took a
closer look at if we had any low hanging fruit on sendmsg in general.
Turns out we very much do. While this doesn't get them on par, it at
least cuts the gap almost in half. And with the unified helper for
copying msghdr for both recvmsg and sendmsg, we get the benefit for
both.

diff --git a/io_uring/net.c b/io_uring/net.c
index c9d9dc611087..67765150e088 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -292,12 +292,17 @@ static int __io_msg_copy_hdr(struct io_kiocb *req, struct io_async_msghdr *iomsg
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
@@ -305,11 +310,13 @@ static int __io_msg_copy_hdr(struct io_kiocb *req, struct io_async_msghdr *iomsg
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
+			unsafe_get_user(iomsg->fast_iov[0].iov_base,
+					&msg.msg_iov[0].iov_base, uaccess_end);
+			unsafe_get_user(iomsg->fast_iov[0].iov_len,
+					&msg.msg_iov[0].iov_len, uaccess_end);
 			sr->len = iomsg->fast_iov[0].iov_len;
 			iomsg->free_iov = NULL;
 		}
@@ -317,10 +324,16 @@ static int __io_msg_copy_hdr(struct io_kiocb *req, struct io_async_msghdr *iomsg
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
@@ -329,6 +342,12 @@ static int __io_msg_copy_hdr(struct io_kiocb *req, struct io_async_msghdr *iomsg
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


