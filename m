Return-Path: <io-uring+bounces-22-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B9D67E070A
	for <lists+io-uring@lfdr.de>; Fri,  3 Nov 2023 17:53:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F3E3CB213B1
	for <lists+io-uring@lfdr.de>; Fri,  3 Nov 2023 16:53:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 392631DA3B;
	Fri,  3 Nov 2023 16:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="I4txSOl0"
X-Original-To: io-uring@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F26031DA32
	for <io-uring@vger.kernel.org>; Fri,  3 Nov 2023 16:53:24 +0000 (UTC)
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7186ED44
	for <io-uring@vger.kernel.org>; Fri,  3 Nov 2023 09:53:22 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id ca18e2360f4ac-7a9541c9b2aso16571039f.0
        for <io-uring@vger.kernel.org>; Fri, 03 Nov 2023 09:53:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1699030401; x=1699635201; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=69f5HkB4QR0DkjU2WK0bnMklVa7nO5Bjr49Fbow8iRI=;
        b=I4txSOl0Fe5pCCR4v3gSL4tXc7MlimEKIyGke/JVbIakj3PkRk2FB3xrDQKT35YJJx
         iQ1TFzF8ZPekK1WQrdnLi6bLniiTWpbm09vfX5OedYhUP0ykqkcs7mwdegoWAXMIzGai
         /38P37KWkBaBZ2a1mXwlrDGbrttoi35a4tAXdteqBJlR4uXv8mY2qtLAl/cb/WyqYLTM
         VlUlVQYdr8nikgM++AgzDYAGhmUPvcj+mKBzAKhEzfnp4Ov5Se2SzbOU4GqQGnLn6SxB
         Ce/GqRvXn1GieAZ2RZwvEbeWEq4WIkBkVdVPg+MEJ6Skbf5Jnr7jy2GEad9IPsZ2QTr4
         N6rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699030401; x=1699635201;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=69f5HkB4QR0DkjU2WK0bnMklVa7nO5Bjr49Fbow8iRI=;
        b=v1Vg8a1mZHUYCEIez3h2+UGtgTlUS+/JtQRA+UoMJswG7H6Dq8EXuL/myJByCBg7j8
         0BheiX/sIP46tZCQYCeWWW94E+zHfBZX4yLrqvenrqCvqw3SAqn9fAPKoUY1x1s9msex
         cBlB5BVJQvrHRc6DzGqRKGxR2AfHJeEdVUgoyS/hgGxDQCMu5lT4XgVukXJouMebULX5
         tZUgz29uml7h8ARf+RYfRO29mSQT+nmkKae7hwaI4Lkrd+pMgw5TGHZXo8ZRqPIXxR2k
         GLnLWVZVTmQ4FAi0Bm/WF5WxUSVJ39bzs0sIqisLfRZAfFGV7+TI7PmN2lhmjzSgmv7H
         ztPQ==
X-Gm-Message-State: AOJu0YwkF/KOPjo+VJwgmnng5gNn9y/O2ToncbkQNcyQaMeE+FSZLbTp
	davsHvJxVL3HLFy+qF6QSBQg0uojdzHtTZt41W0E0Q==
X-Google-Smtp-Source: AGHT+IFTsIAY+q6Qf0wMppwhBdMzZB5b+FqbGShHBJuqbsbp0FeuZ3LdYhC4SZluWcy/hbDQ2hWQLg==
X-Received: by 2002:a05:6e02:d4c:b0:359:3fd2:adcc with SMTP id h12-20020a056e020d4c00b003593fd2adccmr8355105ilj.3.1699030400969;
        Fri, 03 Nov 2023 09:53:20 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id q6-20020a056e02106600b0035260e105fdsm672027ilj.36.2023.11.03.09.53.20
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Nov 2023 09:53:20 -0700 (PDT)
Message-ID: <8717a010-125e-4f4f-a1e9-8d6ee7b31491@kernel.dk>
Date: Fri, 3 Nov 2023 10:53:18 -0600
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
Subject: [PATCH] io_uring/net: mark socket connected on -EINPROGRESS retry
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

With the removal of the retry on -EINPROGRESS, we're not getting the
socket marked connected before another connect attempt is made. This
can result in getting a successful connect completion where we're now
connected, yet it's not marked as such on the net side. A followup
connect request would then return '0' rather than -EISCONN, which then
gets the connectioned marked connected. A second followup would then
correctly return -EISCONN.

If we don't get a socket error on our -EINPROGRESS retry condition,
mark the socket as successfully connected.

Cc: stable@vger.kernel.org
Fixes: 3fb1bd688172 ("io_uring/net: handle -EINPROGRESS correct for IORING_OP_CONNECT")
Link: https://github.com/axboe/liburing/issues/980
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/net.c b/io_uring/net.c
index 7a8e298af81b..b45ac315ef90 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1466,8 +1466,15 @@ int io_connect(struct io_kiocb *req, unsigned int issue_flags)
 
 		ret = -ENOTSOCK;
 		socket = sock_from_file(req->file);
-		if (socket)
+		if (socket) {
 			ret = sock_error(socket->sk);
+			if (!ret) {
+				/* no error, mark us connected */
+				lock_sock(socket->sk);
+				socket->state = SS_CONNECTED;
+				release_sock(socket->sk);
+			}
+		}
 		goto out;
 	}
 
-- 
Jens Axboe


