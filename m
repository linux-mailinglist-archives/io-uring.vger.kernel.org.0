Return-Path: <io-uring+bounces-6642-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 58A87A41063
	for <lists+io-uring@lfdr.de>; Sun, 23 Feb 2025 18:21:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E17987AA3AD
	for <lists+io-uring@lfdr.de>; Sun, 23 Feb 2025 17:20:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0755FCA4B;
	Sun, 23 Feb 2025 17:21:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OWch3Xzh"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 430F478F46
	for <io-uring@vger.kernel.org>; Sun, 23 Feb 2025 17:21:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740331309; cv=none; b=hM7H3+9+5wSTIfdlOevjHH2Ojp4zlJO81/htrtdMJGHDLcEe16mYEOEI+dhsj/54H2LyuLq2qSQ55SymK56+ZNQUIVc9aj34PyxXaINKVEsu6oy48bMXYrjLGLyXMqvAe7ni3ZIxd5drl0/VgqNf8Lv16zhEGTG0zUNxDHvwF4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740331309; c=relaxed/simple;
	bh=Z6NDeIIHJsZ/MIOHzwQUFO5Nr2FUJMJ7ePuoeEt5IOQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XsMxUivBjdFaQ0TbghgKr2rK7zivS8uspSUUvYh5+xtWn8eGWRaDns+T275/a6KosoRhDhQ4kUGUro7j8zTOyQJ4g12Qp0QVAt/oUKAGNXt/Mp2ZnnEprS7zKQ9qXkIYS1k+NB3RQ6gSrn+YqFgYcG/R93h9Xx7WgCZUmmwaWug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OWch3Xzh; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-38f3ee8a119so1746114f8f.0
        for <io-uring@vger.kernel.org>; Sun, 23 Feb 2025 09:21:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740331306; x=1740936106; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sasaUeW0+Wy+FJGZVV0GAt6C+s0g70GHMAWt1JiKZfQ=;
        b=OWch3XzhuCfrRxGWFjni1mSSGbMsCFIqaeAtf94x8eWjuC8hRPjsqcVznu0FVcGImo
         72B9ZYNiifbtJJe0tv61tXTpEZ2x1zr2ZXKy7gRWyqlPX9Cue8jjeSJ4P6HvNmuW7SdH
         kJ683zU2TNahxf1iRZtx9dTxAFG2knjCDZIEKDTkdCs84EZU/iRYHHZGWFy2ORFGZiz0
         q7ExoAzIwBToEeZJndawlu67x5Btmeuf84X9kEkF9f+ObTWVeqmrq3/Hx6va7O9Wac2F
         ZED1Nq0I6+u5lJLiaisnp0tToti2+YucqVjDT5zSSYtjAuhvxLYkJG92GUw0oOQYwNlr
         d3ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740331306; x=1740936106;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sasaUeW0+Wy+FJGZVV0GAt6C+s0g70GHMAWt1JiKZfQ=;
        b=V2/MbpWZMUZWluY3ZKyo5zm7sr4IZVRj2vn9y4tXfjeTsaEClO6i05RkfGI4lO2VpS
         WDeo3BIqHeX6PymDbWhWUz8URbIyEbZJW6sEf2aKk4N/XUpGXa5QJFmVR5aTS4QhKnzl
         mhPrXcLm8YP3o0lpQXu5oTFyij12XGgZRupBuc2S3Ia2dKsyYKvXwHq4LVGd/ElLIxBC
         ItTH9v7Z+Y13tiV3cD+eyjF2jNLXTbDcPsb9+a1e0niUYeTOKUXWjM4Q27+BLQScb8Gp
         1M8Qg7x3McOYI2LQpxc3xY7NTaWVHgOqAd3YC5499CyDunFHW7XuyjXfaUOUFSDzOTSF
         4tCQ==
X-Gm-Message-State: AOJu0YxjzNs1jZvrg2xX1fWUelk4GIv+GGZPTTyqZa+RTF51bFjcw239
	cadJxjIsYlFs1xta6hYkhULYsR16Q4yJOlsIqe0KcbUU29k5bbhujvUJEA==
X-Gm-Gg: ASbGncvjr6FiFoQUTI1G9zWlurimY1zniJ4ls8ZiqSIB2LCbK1YXi2gLVwGuDXQQwhr
	DBMJsNZ2ISxir/E6Bw9JS455xXb/o/FewgZjIzE7+RIHqrwlnSvcwqkcxPYAEKFtrJm8JB+Ywz9
	sgwUOv8nTo7yPdqEYfz3dhIu1SloBXCBh7aX2nZyTCdXoSs/icjeFQOhNm2/Un8/7cCzvYxyaw7
	0gOlVWOKI9mnco80SREIVcAXPzYt3f8jGhjVJPJWM94GynUppMY6YEfapu6iQwA11Hs6L4T7pG3
	njOMIFW61ZVFNPNNKa0mZLeDn1Ti4OfX9paA7Yc=
X-Google-Smtp-Source: AGHT+IGlqfpf/G8jRqf/wao4AGU1yDfChu5nuT6iJd2jmBJdDattMU/iAWTHpiw+HxSJeYSLNO6LOg==
X-Received: by 2002:a05:6000:2a2:b0:38f:4fa5:58ce with SMTP id ffacd0b85a97d-38f70772a64mr7207728f8f.6.1740331305792;
        Sun, 23 Feb 2025 09:21:45 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.146.93])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-439b02d684dsm82117765e9.16.2025.02.23.09.21.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Feb 2025 09:21:44 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 2/3] io_uring/net: canonise accept mshot handling
Date: Sun, 23 Feb 2025 17:22:30 +0000
Message-ID: <daf5c0df7e2966deb0a115021c065fc6161a52d7.1740331076.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1740331076.git.asml.silence@gmail.com>
References: <cover.1740331076.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use a more recongnisable pattern for mshot accept, first try to post an
mshot cqe if needed and after do terminating handling.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/net.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 657b8f5341cf..d22fa61539a3 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1689,7 +1689,6 @@ int io_accept(struct io_kiocb *req, unsigned int issue_flags)
 		}
 		if (ret == -ERESTARTSYS)
 			ret = -EINTR;
-		req_set_fail(req);
 	} else if (!fixed) {
 		fd_install(fd, file);
 		ret = fd;
@@ -1702,14 +1701,8 @@ int io_accept(struct io_kiocb *req, unsigned int issue_flags)
 	if (!arg.is_empty)
 		cflags |= IORING_CQE_F_SOCK_NONEMPTY;
 
-	if (!(req->flags & REQ_F_APOLL_MULTISHOT)) {
-		io_req_set_res(req, ret, cflags);
-		return IOU_OK;
-	}
-
-	if (ret < 0)
-		return ret;
-	if (io_req_post_cqe(req, ret, cflags | IORING_CQE_F_MORE)) {
+	if (ret >= 0 && (req->flags & REQ_F_APOLL_MULTISHOT) &&
+	    io_req_post_cqe(req, ret, cflags | IORING_CQE_F_MORE)) {
 		if (cflags & IORING_CQE_F_SOCK_NONEMPTY || arg.is_empty == -1)
 			goto retry;
 		if (issue_flags & IO_URING_F_MULTISHOT)
@@ -1718,6 +1711,8 @@ int io_accept(struct io_kiocb *req, unsigned int issue_flags)
 	}
 
 	io_req_set_res(req, ret, cflags);
+	if (ret < 0)
+		req_set_fail(req);
 	if (!(issue_flags & IO_URING_F_MULTISHOT))
 		return IOU_OK;
 	return IOU_STOP_MULTISHOT;
-- 
2.48.1


