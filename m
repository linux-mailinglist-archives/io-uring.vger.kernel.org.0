Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0EEF5F4DBD
	for <lists+io-uring@lfdr.de>; Wed,  5 Oct 2022 04:35:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229446AbiJECfE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 4 Oct 2022 22:35:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbiJECfC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 4 Oct 2022 22:35:02 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9664613E07
        for <io-uring@vger.kernel.org>; Tue,  4 Oct 2022 19:35:00 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id a23so6508528pgi.10
        for <io-uring@vger.kernel.org>; Tue, 04 Oct 2022 19:35:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date;
        bh=zQbW+5OCsry4zMFWE4a6Xr5jbROqHyZ9G+KNpoilOvg=;
        b=t75OUgSioKorSyr3iSN4seE0Nmm/lOZRWjSKigile+UdGR7ynoXYvhvwxr0wPKPMT9
         y67qRaiAB6SQY1JwTFh+m8KEY4+k3R2CpvPmzFMAyUpUek2HmRAaO6Xqsr9ymVDiK1/g
         e8/MFo7IJAEHaCenKQuDFK0/+BIp12BjaD58x+3g3fOjZNCgk1AvEhaMtKqtvWqXmFS9
         qDv9VtlyMifiiJhqjxhqUvvoaJAlwLMbcWJFgiXbDgFeCOfca3GID0d4hO5Fuh6dhQJF
         OC6lOhpikF8ZSdPnBBpjlbavY/UTPT+JI/rzMq2+xWzrc064goEzxdhchf/3sItpssYZ
         Nlnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date;
        bh=zQbW+5OCsry4zMFWE4a6Xr5jbROqHyZ9G+KNpoilOvg=;
        b=ON59FBDWCKZW/q/JpoTaPFeCa3c+jIPdjpK8rHciCajHoQr65+1AUnRfssdqWEabci
         OAQwM4Wh1ko+xDAjinwkZ1GN8BYWbFuK4GF5t5pjbt9opGMkhVuSb1LUw8H7MSWN9VeX
         HoS+To0ePUowXPVO5NDhoLa2tSVY+oBF194RHZ16aEWrWftRNIyRyvemTm83m8vMfCdR
         /0GJJjEIC5FbdT1+Ju2TyMlCv6W1p/7Y4rBY7ScjqUqyEbbyAhts/hOSAAfmo8waexIK
         U4voerPsUAGCn7Wr+OLK+8+/H/Udc7IXBaR1btaIMHM6Y9EECPP6DKev0NsWp/wyP0to
         dU/A==
X-Gm-Message-State: ACrzQf0LLK+ApQkqMQuqyZQBgCdObIeZGkVI7hsGwFP5Am5hD4ZflN5z
        mQRAq0JlvPGbhcRUhEKHMYjonO9OcaAVww==
X-Google-Smtp-Source: AMsMyM675NIyvI7mg9/ZcnhlRuwTDIZmkJbuEcWQMMRkDvb+k7IBsUmw/Psj+9MITEL0g128NJtDWw==
X-Received: by 2002:a65:6d86:0:b0:438:f775:b45d with SMTP id bc6-20020a656d86000000b00438f775b45dmr26015297pgb.291.1664937299818;
        Tue, 04 Oct 2022 19:34:59 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e7-20020a170902ef4700b0017b264a2d4asm3949882plx.44.2022.10.04.19.34.58
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Oct 2022 19:34:59 -0700 (PDT)
Message-ID: <225ba417-7a82-59e0-6339-37cfd0ad4f7d@kernel.dk>
Date:   Tue, 4 Oct 2022 20:34:58 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring/net: handle -EINPROGRESS correct for
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

diff --git a/io_uring/net.c b/io_uring/net.c
index 6b69eff6887e..2b6d55e365cb 100644
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
 
@@ -1404,11 +1406,25 @@ int io_connect(struct io_kiocb *req, unsigned int issue_flags)
 		io = &__io;
 	}
 
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
 	file_flags = force_nonblock ? O_NONBLOCK : 0;
 
 	ret = __sys_connect_file(req->file, &io->address,
 					connect->addr_len, file_flags);
 	if ((ret == -EAGAIN || ret == -EINPROGRESS) && force_nonblock) {
+		if (ret == -EINPROGRESS)
+			connect->in_progress = true;
 		if (req_has_async_data(req))
 			return -EAGAIN;
 		if (io_alloc_async_data(req)) {

-- 
Jens Axboe
