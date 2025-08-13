Return-Path: <io-uring+bounces-8953-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 21EC4B2498F
	for <lists+io-uring@lfdr.de>; Wed, 13 Aug 2025 14:32:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 08FAD3B24DA
	for <lists+io-uring@lfdr.de>; Wed, 13 Aug 2025 12:32:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CD7917F4F6;
	Wed, 13 Aug 2025 12:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="1qhKeLKr"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9067E39FF3
	for <io-uring@vger.kernel.org>; Wed, 13 Aug 2025 12:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755088331; cv=none; b=PpP+oM7fZLCpTDUn7jTrjhmnJs9I+8XYG2VzZpSSyLr9svhFObHNkNYOqJlIgcKAwePxryLCDFIW2/Sd/+eEP+fTOAEzDMmJ0I+WGzjhCxMM1Q4fvq30Vh0fWlxDlZFISP/m7YIh+qbKBOVFUMw2xKMFL/rLtOxSJAWME7Hjfno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755088331; c=relaxed/simple;
	bh=kCLF79S+Mb1JWtTQJUEzjwnCXMGeURP0ljdTXMIY0Uw=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=DW7t3jQVfa55TP6LRSgL6snqXPdlPOe7yewb79ryNbYHKuhbzg818ZQhHYJRAN7lrFYJ9rB+ueW2HQ8kwd0hCt47AJ6EIEAphUTzDcTY3C9Yn3EsiAkv1CNJaL40i5COJdcNxzezfF08I3PW+Pl2yHEo6eMY+ErG/BS235g3bp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=1qhKeLKr; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-76bc55f6612so934015b3a.0
        for <io-uring@vger.kernel.org>; Wed, 13 Aug 2025 05:32:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1755088327; x=1755693127; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BGZSqFydtVB2Q6IiOGQndK2n2nD5qmZcbK0ywXyAOuE=;
        b=1qhKeLKroAWoXccopGZ32rZS1n5TISrvPTjzhUKeefPeqpXPlLNa0oCSTFX2Orw4OY
         uwDrqYjc99WpmLrVV7yUIax61jexk3FJYSQKjx8aiIZ2l9sL3xI7NmZQkizDP4Qrdxmy
         5s0amw1oNgEVVvaiEQHBNhoosoXpzAfcBDuPchizhjaHDu3731j+ZnkW4hgQPVeNixvO
         WY8rcNvTPS5MIOh05T62SQmdQgddzLoV3aAlteYy9f9gH5wfB3INmRz/zqaBGltbqHKS
         Cv29C/koJXGYpvOvIL/moSMCBamI3qeoRlXl8Yfmhn9OID4JYtuYY9zjwozVj+IxRnE9
         t0gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755088327; x=1755693127;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=BGZSqFydtVB2Q6IiOGQndK2n2nD5qmZcbK0ywXyAOuE=;
        b=lPtAVBEbAHjZyZ5Ku4d5XHkA03MRWzHbqCChYBjYh0jxfnDTpmeudqBZMFdJlVJF3A
         8y8Ajsc7n/IKK8XYDHDl8lxE6J0VQ92WrWc63zxqXj+aCsdmhB59d3KSLG52Wgqc9yR8
         JUHO6lvg2xmFtiozAfZ/suMdojm8Xhe0Z1BY58V+NQe7QsHzUVCgyrPkGrQdmGHMdW1W
         xUysAAphSFM9qQtejlKU+I0ZQrPMoBw02n6jxCQyxUgRrSH2lyRFKD9OT97WNKA9D5ur
         Xo6ZaVmVcnDpIqBFFTEWWfcA2jg9FYiuWZMdWPzmKsA9lYZ8tQY0Y/TGP6zd1ca1PhiY
         k0gw==
X-Gm-Message-State: AOJu0YxqVsY4/Fj09JE/YHevMI4HhlkyaHwY57VdsKLeN+B7eRbb1+VG
	t9DbGiCO4Ca7XjizgMQZSuR4kOtuszHkXIwmoiKXfywd0DqD56Tld2h+Ie7OEv3QY6NEUB1KNIN
	Qyzpr
X-Gm-Gg: ASbGncsTylvds9+369zjqGDLxAJTHyzvk1VWnrt0AIECC3oRx5DR3LhnuOEbVzprmAy
	dEwArxnxVUsauBHD+0HaTDcq5obI5GG86TDXCKt0TI1BS7vwtIg/cLK/tG6VmzVY3XrklY0okRm
	5rNuLcQavID/iB40VpDMC5OFbtX8G8bmdXG302I5jr4XG0zRALpC3B4SSElnO/UPNVsCc6ZGRZ7
	YSXFhIX9sPTBTveCua/nrLHHFaE76/HrSwaXt9oYbwCF/o37TMEUtBzhOsxtvFLGhd5JJcA75ZV
	WdbVWZVV7UacB6ffN1ee84W+YKKQnCwo/zw8T6N24DOkXAFKvn4utlKKXgXaSmUqpk3d9+DVoR8
	+N9vnCI7NOaPFWAjdvaklCoeRv7DAhc4=
X-Google-Smtp-Source: AGHT+IHGK0nmPU/xT5sWzsNvewYSWQUCF18qkvucSDtR6Ihru6yqSRlQWSFPhWSXPvBfEDmlYAOjzA==
X-Received: by 2002:a05:6a21:3391:b0:1f3:31fe:c1da with SMTP id adf61e73a8af0-240ab3a240emr3845281637.11.1755088327073;
        Wed, 13 Aug 2025 05:32:07 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-76bcceab592sm32005200b3a.58.2025.08.13.05.32.06
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Aug 2025 05:32:06 -0700 (PDT)
Message-ID: <6efa6355-3ad0-4041-adb0-f6ea3840b824@kernel.dk>
Date: Wed, 13 Aug 2025 06:32:05 -0600
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
Subject: [PATCH] io_uring/net: commit partial buffers on retry
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Ring provided buffers are potentially only valid within the single
execution context in which they were acquired. io_uring deals with this
and invalidates them on retry. But on the networking side, if
MSG_WAITALL is set, or if the socket is of the streaming type and too
little was processed, then it will hang on to the buffer rather than
recycle or commit it. This is problematic for two reasons:

1) If someone unregisters the provided buffer ring before a later retry,
   then the req->buf_list will no longer be valid.

2) If multiple sockers are using the same buffer group, then multiple
   receives can consume the same memory. This can cause data corruption
   in the application, as either receive could land in the same
   userspace buffer.

Fix this by disallowing partial retries from pinning a provided buffer
across multiple executions, if ring provided buffers are used.

Cc: stable@vger.kernel.org
Reported-by: pt x <superman.xpt@gmail.com>
Fixes: c56e022c0a27 ("io_uring: add support for user mapped provided buffer ring")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/net.c b/io_uring/net.c
index dd96e355982f..d69f2afa4f7a 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -494,6 +494,15 @@ static int io_bundle_nbufs(struct io_async_msghdr *kmsg, int ret)
 	return nbufs;
 }
 
+static int io_net_kbuf_recyle(struct io_kiocb *req,
+			      struct io_async_msghdr *kmsg, int len)
+{
+	req->flags |= REQ_F_BL_NO_RECYCLE;
+	if (req->flags & REQ_F_BUFFERS_COMMIT)
+		io_kbuf_commit(req, req->buf_list, len, io_bundle_nbufs(kmsg, len));
+	return IOU_RETRY;
+}
+
 static inline bool io_send_finish(struct io_kiocb *req, int *ret,
 				  struct io_async_msghdr *kmsg,
 				  unsigned issue_flags)
@@ -562,8 +571,7 @@ int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
 			kmsg->msg.msg_controllen = 0;
 			kmsg->msg.msg_control = NULL;
 			sr->done_io += ret;
-			req->flags |= REQ_F_BL_NO_RECYCLE;
-			return -EAGAIN;
+			return io_net_kbuf_recyle(req, kmsg, ret);
 		}
 		if (ret == -ERESTARTSYS)
 			ret = -EINTR;
@@ -674,8 +682,7 @@ int io_send(struct io_kiocb *req, unsigned int issue_flags)
 			sr->len -= ret;
 			sr->buf += ret;
 			sr->done_io += ret;
-			req->flags |= REQ_F_BL_NO_RECYCLE;
-			return -EAGAIN;
+			return io_net_kbuf_recyle(req, kmsg, ret);
 		}
 		if (ret == -ERESTARTSYS)
 			ret = -EINTR;
@@ -1071,8 +1078,7 @@ int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 		}
 		if (ret > 0 && io_net_retry(sock, flags)) {
 			sr->done_io += ret;
-			req->flags |= REQ_F_BL_NO_RECYCLE;
-			return IOU_RETRY;
+			return io_net_kbuf_recyle(req, kmsg, ret);
 		}
 		if (ret == -ERESTARTSYS)
 			ret = -EINTR;
@@ -1218,8 +1224,7 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 			sr->len -= ret;
 			sr->buf += ret;
 			sr->done_io += ret;
-			req->flags |= REQ_F_BL_NO_RECYCLE;
-			return -EAGAIN;
+			return io_net_kbuf_recyle(req, kmsg, ret);
 		}
 		if (ret == -ERESTARTSYS)
 			ret = -EINTR;
@@ -1500,8 +1505,7 @@ int io_send_zc(struct io_kiocb *req, unsigned int issue_flags)
 			zc->len -= ret;
 			zc->buf += ret;
 			zc->done_io += ret;
-			req->flags |= REQ_F_BL_NO_RECYCLE;
-			return -EAGAIN;
+			return io_net_kbuf_recyle(req, kmsg, ret);
 		}
 		if (ret == -ERESTARTSYS)
 			ret = -EINTR;
@@ -1571,8 +1575,7 @@ int io_sendmsg_zc(struct io_kiocb *req, unsigned int issue_flags)
 
 		if (ret > 0 && io_net_retry(sock, flags)) {
 			sr->done_io += ret;
-			req->flags |= REQ_F_BL_NO_RECYCLE;
-			return -EAGAIN;
+			return io_net_kbuf_recyle(req, kmsg, ret);
 		}
 		if (ret == -ERESTARTSYS)
 			ret = -EINTR;

-- 
Jens Axboe


