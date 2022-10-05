Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C08F5F4DE6
	for <lists+io-uring@lfdr.de>; Wed,  5 Oct 2022 04:45:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230161AbiJECpg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 4 Oct 2022 22:45:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230149AbiJECoe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 4 Oct 2022 22:44:34 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C687E72873
        for <io-uring@vger.kernel.org>; Tue,  4 Oct 2022 19:43:52 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id b5so14205990pgb.6
        for <io-uring@vger.kernel.org>; Tue, 04 Oct 2022 19:43:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date;
        bh=VFDx91/GIoLhChZbz6/LvbWKFiyoMI92tOlDuAV7nGM=;
        b=WXdSLytRlnJxmkUSVZEaVhljcGPlvJAY10H+N+uKLSczglKG8Xbc71t7QkWVMxzI7U
         VwBbXmefNA8CYwyR7j5pHgIlkVoSNV6Hyf64mgOUNs08w9u8EJOjMmeKsPPboZP6VxNA
         ZrGkqUHPp+8pilYJtCOnuKLD3XmcVnOofoVG37kkIC4Z5gZPvyfibyFKUhg7iaRX3Xhl
         XrNd1qwQuiG7Sx/Eu2+wIXLJAyMrAS8/fX9Xmz1zDi6vDeUPSWuNxnEnGj/mIl7S8DFR
         7Yn1B61d2iqf9NOVoZuq1EFrDlDBY3mD/ZXY9dP2LfSDORx4VfFVBwaHO6gPcQ7l3crY
         SM9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date;
        bh=VFDx91/GIoLhChZbz6/LvbWKFiyoMI92tOlDuAV7nGM=;
        b=i1mF+vw+vaUHgLFQCYOQJ1xFvIufJ6m7peb5ZTq7y7DTRkQwjgcfRIgOE90mq8YGx5
         vw1p4NR4qHGY8XS7TJ9ampb49lmZPHeZfNmEGCWpMJ80TXiHWMN27ihaEPHPg78Y8ReZ
         5gBcx6HImoDCHGfHvz+vAnDLLuA6S/tBa9THDxTiS1WFRjTmDsRV8WAlQFAweZ4ANM4H
         TOJNteLmUsEL+JAPdJC0z/GFzv7ODXpbBx+5+P+30bP5VLPx2M/ULsPcHpecMkhpdS+X
         WxsUmdnFlAoIpurYFp7a7KbFgfeZcERTtYG2GpRx/dq6D+mTiEtWMZQQgxToZQ27yUc2
         pifQ==
X-Gm-Message-State: ACrzQf2SRhuzQvp4fD/8p38C4TBowu6cWut/g/S9a29igZ3AmnTLmKhI
        1UFh8hf2Trhue6vgyo3Owt63H7sit2vcKA==
X-Google-Smtp-Source: AMsMyM4TT0L7B9BL6A1J0iE+IxHuqZvBmoD2hfLSSSLP7hyQIxxqcM0dwARLsj1huJ/tekgLnyrNIw==
X-Received: by 2002:a65:6944:0:b0:43c:da07:5421 with SMTP id w4-20020a656944000000b0043cda075421mr26161208pgq.72.1664937832004;
        Tue, 04 Oct 2022 19:43:52 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id z9-20020a170903018900b001746f66244asm9764672plg.18.2022.10.04.19.43.51
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Oct 2022 19:43:51 -0700 (PDT)
Message-ID: <ce9c96ce-c04d-6814-a8e4-46e15acb589c@kernel.dk>
Date:   Tue, 4 Oct 2022 20:43:50 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH v2] io_uring/net: handle -EINPROGRESS correct for
 IORING_OP_CONNECT
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We treat EINPROGRESS like EAGAIN, but if we're retrying post getting
EINPROGRESS, then we just need to check the socket for errors and
terminate the request.

This was exposed on a bluetooth connection request which ends up
taking a while and hitting EINPROGRESS, and yields a CQE result of
-EBADFD because we're retrying a connect on a socket that is now
connected.

Cc: stable@vger.kernel.org
Fixes: 87f80d623c6c ("io_uring: handle connect -EINPROGRESS like -EAGAIN")
Link: https://github.com/axboe/liburing/issues/671
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

Since v1:

- Send out the right version of the patch, there's no need to
  setup async data for the EINPROGRESS retry.

diff --git a/io_uring/net.c b/io_uring/net.c
index 6b69eff6887e..c2fbe8f083fb 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -46,6 +46,7 @@ struct io_connect {
 	struct file			*file;
 	struct sockaddr __user		*addr;
 	int				addr_len;
+	bool				in_progress;
 };
 
 struct io_sr_msg {
@@ -1382,6 +1383,7 @@ int io_connect_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 	conn->addr = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	conn->addr_len =  READ_ONCE(sqe->addr2);
+	conn->in_progress = false;
 	return 0;
 }
 
@@ -1393,6 +1395,18 @@ int io_connect(struct io_kiocb *req, unsigned int issue_flags)
 	int ret;
 	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
 
+	if (connect->in_progress) {
+		struct socket *socket;
+
+		socket = sock_from_file(req->file);
+		if (unlikely(!socket)) {
+			ret = -EBADF;
+			goto out;
+		}
+		ret = sock_error(socket->sk);
+		goto out;
+	}
+
 	if (req_has_async_data(req)) {
 		io = req->async_data;
 	} else {
@@ -1409,13 +1423,17 @@ int io_connect(struct io_kiocb *req, unsigned int issue_flags)
 	ret = __sys_connect_file(req->file, &io->address,
 					connect->addr_len, file_flags);
 	if ((ret == -EAGAIN || ret == -EINPROGRESS) && force_nonblock) {
-		if (req_has_async_data(req))
-			return -EAGAIN;
-		if (io_alloc_async_data(req)) {
-			ret = -ENOMEM;
-			goto out;
+		if (ret == -EINPROGRESS) {
+			connect->in_progress = true;
+		} else {
+			if (req_has_async_data(req))
+				return -EAGAIN;
+			if (io_alloc_async_data(req)) {
+				ret = -ENOMEM;
+				goto out;
+			}
+			memcpy(req->async_data, &__io, sizeof(__io));
 		}
-		memcpy(req->async_data, &__io, sizeof(__io));
 		return -EAGAIN;
 	}
 	if (ret == -ERESTARTSYS)

-- 
Jens Axboe
