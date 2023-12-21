Return-Path: <io-uring+bounces-344-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CA1981BB7B
	for <lists+io-uring@lfdr.de>; Thu, 21 Dec 2023 17:06:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D2EC6B2423D
	for <lists+io-uring@lfdr.de>; Thu, 21 Dec 2023 16:06:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63EA653A17;
	Thu, 21 Dec 2023 16:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="cswgoiIZ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D3D955E4B
	for <io-uring@vger.kernel.org>; Thu, 21 Dec 2023 16:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-1d3fe03b6b7so2617115ad.1
        for <io-uring@vger.kernel.org>; Thu, 21 Dec 2023 08:06:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1703174767; x=1703779567; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=koux1OiWe0C6HGh1pomufAvZvjuSS7y5HHLlY61rqDU=;
        b=cswgoiIZLzelkjSm8Hjb3Vq/U9UpG+Pf4B0I9F5USlAC8i+aW9YczYDMrxTWhIxV6R
         SdU6HE5Cp3F6mH6gGlvS3nEHmpHQOSObmV3lsmAqVaOCoEv5kl9kaEVtglzPRCkXb9ms
         f8g8IfR2Rx1Rpk2megDqt6TZHnRf6Ow1Pw0Frg+SAzgXkqIfui938dhMFkY1oQfk9MGr
         QWD7BTAQo1UQkCwO+7VEPhUd7zg7usgjJwwRRd+vf29fr4mh53E9Sn4RF23p27ZvdRIi
         oiGo0kZub2eWcRvW8nCdkqO0S1Jo/479hEvysQhiJCZyl7B3lYIKx1v8fUgGUJJ0M39Y
         6meg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703174767; x=1703779567;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=koux1OiWe0C6HGh1pomufAvZvjuSS7y5HHLlY61rqDU=;
        b=FDl042y2YSNfr07HzC6Y3SA1M/HGxDdX/baBaQJqgExNppgHFNFmkczLoy7mj/ADts
         7IHdn6IdwmXJmAtfb8qjdiBMi0J4VfE4dlctNf0TqXYIFYBdSCbS3DZMq6UfX4ZMrsZP
         HVurYCfgYin52ZyBeZj0JjV5kkDjnYYWUdo7mwyc6MLlf24P0euLyGd0f7tvItlGc/Kr
         uKTvmuylbW++NvDoshP81i2+bAuXUYE5nR94HDdgx+sgwoLtY+yOKJa8g2Yly70+qJ24
         3GrkFAjnOa4JmQ6RbI8V3jDNOyI/QkvP4iigyzQKN7Sd1GWarYxpD1Cz5i9C0F1Oo9kb
         lB4A==
X-Gm-Message-State: AOJu0YwX5lQGTNNddDrY/0QyU6zrxQcRRW5P5U5oKocA59tLMrKDXQAD
	GQXWJCONc3URv+gTDdorYnSteGlzt7kOTkDYdlyU/g==
X-Google-Smtp-Source: AGHT+IEYWFZjGaUJO6LraZvBvPmw0K0cn0mtoaI2Qoy3qNysHSnhXtFnk9FoiHaZyvOdTyBmYmIwtg==
X-Received: by 2002:a17:90a:730a:b0:28b:ecbb:29da with SMTP id m10-20020a17090a730a00b0028becbb29damr2246192pjk.3.1703174766852;
        Thu, 21 Dec 2023 08:06:06 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id mg5-20020a17090b370500b0028b73564d7dsm1982193pjb.24.2023.12.21.08.06.05
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Dec 2023 08:06:06 -0800 (PST)
Message-ID: <7fb42968-17fd-47d8-b2cd-55a3382f1540@kernel.dk>
Date: Thu, 21 Dec 2023 09:06:04 -0700
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
Subject: [PATCH] io_uring/kbuf: add method for returning provided buffer ring
 head
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

The tail of the provided ring buffer is shared between the kernel and
the application, but the head is private to the kernel as the
application doesn't need to see it. However, this also prevents the
application from knowing how many buffers the kernel has consumed.
Usually this is fine, as the information is inherently racy in that
the kernel could be consuming buffers continually, but for cleanup
purposes it may be relevant to know how many buffers are still left
in the ring.

Add IORING_REGISTER_PBUF_STATUS which will return status for a given
provided buffer ring. Right now it just returns the head, but space
is reserved for more information later in, if needed.

Link: https://github.com/axboe/liburing/discussions/1020
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index db4b913e6b39..7a673b52827b 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -567,6 +567,9 @@ enum {
 	/* register a range of fixed file slots for automatic slot allocation */
 	IORING_REGISTER_FILE_ALLOC_RANGE	= 25,
 
+	/* return status information for a buffer group */
+	IORING_REGISTER_PBUF_STATUS		= 26,
+
 	/* this goes last */
 	IORING_REGISTER_LAST,
 
@@ -693,6 +696,13 @@ struct io_uring_buf_reg {
 	__u64	resv[3];
 };
 
+/* argument for IORING_REGISTER_PBUF_STATUS */
+struct io_uring_buf_status {
+	__u32	buf_group;	/* input */
+	__u32	head;		/* output */
+	__u32	resv[8];
+};
+
 /*
  * io_uring_restriction->opcode values
  */
diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 72b6af1d2ed3..0991adf98950 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -750,6 +750,27 @@ int io_unregister_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg)
 	return 0;
 }
 
+int io_register_pbuf_status(struct io_ring_ctx *ctx, void __user *arg)
+{
+	struct io_uring_buf_status buf_status;
+	struct io_buffer_list *bl;
+
+	if (copy_from_user(&buf_status, arg, sizeof(buf_status)))
+		return -EFAULT;
+
+	bl = io_buffer_get_list(ctx, buf_status.buf_group);
+	if (!bl)
+		return -ENOENT;
+	if (!bl->is_mapped)
+		return -EINVAL;
+
+	buf_status.head = bl->head;
+	if (copy_to_user(arg, &buf_status, sizeof(buf_status)))
+		return -EFAULT;
+
+	return 0;
+}
+
 void *io_pbuf_get_address(struct io_ring_ctx *ctx, unsigned long bgid)
 {
 	struct io_buffer_list *bl;
diff --git a/io_uring/kbuf.h b/io_uring/kbuf.h
index 9be5960817ea..53dfaa71a397 100644
--- a/io_uring/kbuf.h
+++ b/io_uring/kbuf.h
@@ -53,6 +53,7 @@ int io_provide_buffers(struct io_kiocb *req, unsigned int issue_flags);
 
 int io_register_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg);
 int io_unregister_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg);
+int io_register_pbuf_status(struct io_ring_ctx *ctx, void __user *arg);
 
 void io_kbuf_mmap_list_free(struct io_ring_ctx *ctx);
 
diff --git a/io_uring/register.c b/io_uring/register.c
index a4286029e920..708dd1d89add 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -542,6 +542,12 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 			break;
 		ret = io_register_file_alloc_range(ctx, arg);
 		break;
+	case IORING_REGISTER_PBUF_STATUS:
+		ret = -EINVAL;
+		if (!arg || nr_args != 1)
+			break;
+		ret = io_register_pbuf_status(ctx, arg);
+		break;
 	default:
 		ret = -EINVAL;
 		break;

-- 
Jens Axboe


