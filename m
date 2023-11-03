Return-Path: <io-uring+bounces-23-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A1FD07E0982
	for <lists+io-uring@lfdr.de>; Fri,  3 Nov 2023 20:37:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 31321281BC8
	for <lists+io-uring@lfdr.de>; Fri,  3 Nov 2023 19:37:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9634522F0B;
	Fri,  3 Nov 2023 19:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="zHuUJB1r"
X-Original-To: io-uring@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E214B22F09
	for <io-uring@vger.kernel.org>; Fri,  3 Nov 2023 19:36:52 +0000 (UTC)
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A00681BF
	for <io-uring@vger.kernel.org>; Fri,  3 Nov 2023 12:36:50 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id d2e1a72fcca58-6bcbfecf314so757409b3a.1
        for <io-uring@vger.kernel.org>; Fri, 03 Nov 2023 12:36:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1699040209; x=1699645009; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+9zcpz3Bwk0141Wg1FXIYGT/AFwd7HE1w5iBTgGwVrE=;
        b=zHuUJB1rfOSy5zjDzzSU9oPRCTOEISpoBLlpr0mK+dmE34BqpPXPlu05d66yQ/drk3
         uKb6CeV6CRo+t4B/kAk8ey9jjySn8xeDP8/z2kNQBdklMuKYiuyNXbxX0y/lEVm4WcIT
         KDCZuUl9bQj4Jaz7khbZW3wJQbbWPC1o+47wpp3cHuhqdgt/5jeKMvtKIDfFysI0+8kg
         HWk1+J3KuP9yy9C205+p960CqN2qE2I+Ckof/yS+Dpllx4o3d6+epHb+33t5tNSf7EhQ
         zneO4dvvMe0MOkie4BFDA75hcPkwg677K11pyx0ISIo5m3kGQxUrD/WjtDk17Nm5uoQT
         aRQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699040209; x=1699645009;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=+9zcpz3Bwk0141Wg1FXIYGT/AFwd7HE1w5iBTgGwVrE=;
        b=AtIddmFcoZB5PoqcLatefUSUuzpi1GVGJaH9qDMgP5oZ4pdDJrIp1sYge2TeL3WgGA
         I2CZqVElMrZwZu9u5BrEmnXPB6C4wb8hfVIHP1b7Y0N6gzTMEL6WHZtNdW7+4gI7mJLt
         xhc5AQHdnwt9z5Y4mT0J0gpQaxzAjVvgGb17qU0Rbk/51j7ZKxIYkCZPAvAUlJ7URCPo
         yjB9Pl0gVqO+ll+HWNFSBZUIeqzrN07JeKhVic1AxYX7FImhsvqEILrTBAcFA6tyQqkQ
         oGFJNdPgLRUpmZ3KNlkLPgvQ/jHNUhwe2H0icUpe2P7Yarc95NCfmjuz/a6kZyp4CoEh
         bABQ==
X-Gm-Message-State: AOJu0YypNHeJmvEk85o0N5forFmOS0Rg1ZV6WsYHi4rwgGauqKXApEWs
	w8ii/srLAZwPicuB3XNZ6EubPUxjwpqQDBPE4RjiJw==
X-Google-Smtp-Source: AGHT+IGtFcrzzz/EzpNIxD/8FtWfM6IWJDrNoLOcYL1c3IlQDOjQJV8l6mTK9daQZI394J5YcWN7lg==
X-Received: by 2002:a05:6a20:e687:b0:15d:f804:6907 with SMTP id mz7-20020a056a20e68700b0015df8046907mr23352996pzb.0.1699040209225;
        Fri, 03 Nov 2023 12:36:49 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id l19-20020a17090b079300b002609cadc56esm1657129pjz.11.2023.11.03.12.36.48
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Nov 2023 12:36:48 -0700 (PDT)
Message-ID: <893c142c-8673-4a8a-9496-c2f13e7ed746@kernel.dk>
Date: Fri, 3 Nov 2023 13:36:47 -0600
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
Subject: [PATCH v2] io_uring/net: ensure socket is marked connected on connect
 retry
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

io_uring does non-blocking connection attempts, which can yield some
unexpected results if a connect request is re-attempted by an an
application. This is equivalent to the following sync syscall sequence:

sock = socket(AF_INET, SOCK_STREAM | SOCK_NONBLOCK, IPPROTO_TCP);
connect(sock, &addr, sizeof(addr);

ret == -1 and errno == EINPROGRESS expected here. Now poll for POLLOUT
on sock, and when that returns, we expect the socket to be connected.
But if we follow that procedure with:

connect(sock, &addr, sizeof(addr));

you'd expect ret == -1 and errno == EISCONN here, but you actually get
ret == 0. If we attempt the connection one more time, then we get EISCON
as expected.

io_uring used to do this, but turns out that bluetooth fails with EBADFD
if you attempt to re-connect. Also looks like EISCONN _could_ occur with
this sequence.

Retain the ->in_progress logic, but work-around a potential EISCONN or
EBADFD error and only in those cases look at the sock_error(). This
should work in general and avoid the odd sequence of a repeated connect
request returning success when the socket is already connected.

This is all a side effect of the socket state being in a CONNECTING
state when we get EINPROGRESS, and only a re-connect or other related
operation will turn that into CONNECTED.

Cc: stable@vger.kernel.org
Fixes: 3fb1bd688172 ("io_uring/net: handle -EINPROGRESS correct for IORING_OP_CONNECT")
Link: https://github.com/axboe/liburing/issues/980
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

v2: rather than fiddle with the socket state directly, go back to our
connect retry that we initially did before that bluetooth issue. This
feels safer and would be closer to what a sync application would do.

diff --git a/io_uring/net.c b/io_uring/net.c
index 7a8e298af81b..75d494dad7e2 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1461,16 +1461,6 @@ int io_connect(struct io_kiocb *req, unsigned int issue_flags)
 	int ret;
 	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
 
-	if (connect->in_progress) {
-		struct socket *socket;
-
-		ret = -ENOTSOCK;
-		socket = sock_from_file(req->file);
-		if (socket)
-			ret = sock_error(socket->sk);
-		goto out;
-	}
-
 	if (req_has_async_data(req)) {
 		io = req->async_data;
 	} else {
@@ -1490,9 +1480,7 @@ int io_connect(struct io_kiocb *req, unsigned int issue_flags)
 	    && force_nonblock) {
 		if (ret == -EINPROGRESS) {
 			connect->in_progress = true;
-			return -EAGAIN;
-		}
-		if (ret == -ECONNABORTED) {
+		} else if (ret == -ECONNABORTED) {
 			if (connect->seen_econnaborted)
 				goto out;
 			connect->seen_econnaborted = true;
@@ -1506,6 +1494,16 @@ int io_connect(struct io_kiocb *req, unsigned int issue_flags)
 		memcpy(req->async_data, &__io, sizeof(__io));
 		return -EAGAIN;
 	}
+	if (connect->in_progress) {
+		/*
+		 * At least bluetooth will return -EBADFD on a re-connect
+		 * attempt, and it's (supposedly) also valid to get -EISCONN
+		 * which means the previous result is good. For both of these,
+		 * grab the sock_error() and use that for the completion.
+		 */
+		if (ret == -EBADFD || ret == -EISCONN)
+			ret = sock_error(sock_from_file(req->file)->sk);
+	}
 	if (ret == -ERESTARTSYS)
 		ret = -EINTR;
 out:

-- 
Jens Axboe


