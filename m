Return-Path: <io-uring+bounces-489-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 324E783F023
	for <lists+io-uring@lfdr.de>; Sat, 27 Jan 2024 22:11:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 827261F22286
	for <lists+io-uring@lfdr.de>; Sat, 27 Jan 2024 21:11:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0270B677;
	Sat, 27 Jan 2024 21:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="NNzcV+RS"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B072A1A71F
	for <io-uring@vger.kernel.org>; Sat, 27 Jan 2024 21:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706389892; cv=none; b=BFcNa4AwdjrTALDbDwbUztI4CJxJ3mrPPOmp7lUxf2fUeXzjHtB6etee9T7hlG9OUjXX4UBND+Kvg6Hv/k4xF1MLPLOhtw6FJAICRYr2Ntph064qwSqmzwTetorI2lCppGETq5YCDT5MVw+O5Ywz6GDsHFAw5TIuiiXkC8/P3PU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706389892; c=relaxed/simple;
	bh=9zTwJy3/l3BB3jP0VtyQyw5AyuAelQt9Lj/ymYhezEw=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=cK1qrHkbDu/2i9o8nTZ+Ncppn75aD18iqgpgMiYGdG3UXvKzAXpYT5Lal/VKTVW9cyp67yiCOfFGezKAcEulAgRcprN5P6oYcyx2syVheLiryoyr5VFPRspmw4WhPFBvzkXnR2vi/RfQWeglW3vZE9v+ye65+Hmty/tBR/+XEJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=NNzcV+RS; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-58962bf3f89so568426a12.0
        for <io-uring@vger.kernel.org>; Sat, 27 Jan 2024 13:11:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1706389887; x=1706994687; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EGUh2EFpapG7ptxMeypaku+HxyO/+LlIxuN0EZ3dl50=;
        b=NNzcV+RSHZTeRVTWf3RP7ATb84tz4Jg5sgfq9bESn0yj1BMkjZHuyUqoWptOnrhleq
         TrDW7JKzh16bBYAJ6GqG02EKcW4ipKrgVd/R2lB9ijtWxp0zW4elLZdE3+vlDGN+jPgQ
         UD5yNkICen6VrMEDIYrVgKcY4roJ65+tJ1Dn6BQNQbs52KDg7n/bswE1d9XeRJ/9ufQc
         VBTTgvHPCi3lpDzK+T0v+knA26rkh2WrTnGnW7oiYvQnnxX0WJgGqkMHmKuvij0s80ae
         ZJ/gJ/gYztrS0i7lBnf9nLp1Bn+n4xZRAUE0JI3ES4wIBZyJjlsPWYs3pRPwqp0DFQEu
         80GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706389887; x=1706994687;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=EGUh2EFpapG7ptxMeypaku+HxyO/+LlIxuN0EZ3dl50=;
        b=u6l0bW1iqcneaROdUGN6pY43cdIkCjQPCngY8A0GuyCdbRm8kRZU9GSGxYjLv9fqag
         chtE6oKsGqsDLPxxgKHtRYTotqnJyTIZsKcPOZQDSk0IYQy8PaezuYycISkGg5fOLKja
         xHRnMBz8SzfoR1LAuaUFRJ8KRfqiJsAbQGTIvZM6vkJuUOiOZdBbWt287b12pAdJ5Ri8
         habs+9IqW4QizYCbLKYGUG7BIkvBJmPO3Cg0Dr81d0ksoN+Irtx5ZgZXodekAPmyke5f
         hAtyy4BxgEnLU7RIvIoIPFTRRBZehzufhWv/NG+XsWtPzL2qZM1kp6JbX++/7hM0W2L5
         8L9w==
X-Gm-Message-State: AOJu0Yzzfc7jQ7lGsqjJmQqsHCsk5P3WOYT4da2TN3RGkL2/WFdxVAnf
	j9LB5vdWsdDWeSB/keyZbIUkm79UdoVuJyA03lYsvUYc8f0mDAMOjllx0lMStBZTqcKnhPPGFcs
	+Wh8=
X-Google-Smtp-Source: AGHT+IFv2pneshkXor/KsNv/nMM5DiePSKw/lST72foWzopTu8F/e7n87irYPDkXELVTgM885c2i6A==
X-Received: by 2002:a05:6a21:7886:b0:19c:9df1:e37a with SMTP id bf6-20020a056a21788600b0019c9df1e37amr3215036pzc.0.1706389886767;
        Sat, 27 Jan 2024 13:11:26 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id l4-20020a639844000000b005d8c164fcfesm364705pgo.69.2024.01.27.13.11.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 27 Jan 2024 13:11:25 -0800 (PST)
Message-ID: <1ec748fe-040a-42d3-b4fc-336672953bac@kernel.dk>
Date: Sat, 27 Jan 2024 14:11:25 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: io-uring <io-uring@vger.kernel.org>
Cc: Pavel Begunkov <asml.silence@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring/rw: ensure poll based multishot read retries
 appropriately
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

io_read_mshot() always relies on poll triggering retries, and this works
fine as long as we do a retry per size of the buffer being read. The
buffer size is given by the size of the buffer(s) in the given buffer
group ID.

But if we're reading less than what is available, then we don't always
get to read everything that is available. For example, if the buffers
available are 32 bytes and we have 64 bytes to read, then we'll
correctly read the first 32 bytes and then wait for another poll trigger
before we attempt the next read. This next poll trigger may never
happen, in which case we just sit forever and never make progress, or it
may trigger at some point in the future, and now we're just delivering
the available data much later than we should have.

io_read_mshot() could do retries itself, but that is wasteful as we'll
be going through all of __io_read() again, and most likely in vain.
Rather than do that, bump our poll reference count and have
io_poll_check_events() do one more loop and check with vfs_poll() if we
have more data to read. If we do, io_read_mshot() will get invoked again
directly and we'll read the next chunk.

io_poll_multishot_retry() must only get called from inside
io_poll_issue(), which is our multishot retry handler, as we know we
already "own" the request at this point.

Cc: stable@vger.kernel.org
Link: https://github.com/axboe/liburing/issues/1041
Fixes: fc68fcda0491 ("io_uring/rw: add support for IORING_OP_READ_MULTISHOT")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

Wrote and committed a test case for this as well, find it here:

https://git.kernel.dk/cgit/liburing/commit/?id=a8277668275e9d9bf60aa45622584a6a92039608

diff --git a/io_uring/poll.h b/io_uring/poll.h
index ff4d5d753387..bfd93e5ed3a7 100644
--- a/io_uring/poll.h
+++ b/io_uring/poll.h
@@ -24,6 +24,13 @@ struct async_poll {
 	struct io_poll		*double_poll;
 };
 
+static inline void io_poll_multishot_retry(struct io_kiocb *req,
+					   unsigned int issue_flags)
+{
+	if (issue_flags & IO_URING_F_MULTISHOT)
+		atomic_inc(&req->poll_refs);
+}
+
 int io_poll_add_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_poll_add(struct io_kiocb *req, unsigned int issue_flags);
 
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 118cc9f1cf16..1e2882e144b5 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -18,6 +18,7 @@
 #include "opdef.h"
 #include "kbuf.h"
 #include "rsrc.h"
+#include "poll.h"
 #include "rw.h"
 
 struct io_rw {
@@ -962,8 +963,15 @@ int io_read_mshot(struct io_kiocb *req, unsigned int issue_flags)
 		if (io_fill_cqe_req_aux(req,
 					issue_flags & IO_URING_F_COMPLETE_DEFER,
 					ret, cflags | IORING_CQE_F_MORE)) {
-			if (issue_flags & IO_URING_F_MULTISHOT)
+			if (issue_flags & IO_URING_F_MULTISHOT) {
+				/*
+				 * Force retry, as we might have more data to
+				 * be read and otherwise it won't get retried
+				 * until (if ever) another poll is triggered.
+				 */
+				io_poll_multishot_retry(req, issue_flags);
 				return IOU_ISSUE_SKIP_COMPLETE;
+			}
 			return -EAGAIN;
 		}
 	}

-- 
Jens Axboe


