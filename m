Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51462736D28
	for <lists+io-uring@lfdr.de>; Tue, 20 Jun 2023 15:21:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232774AbjFTNVb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 20 Jun 2023 09:21:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232685AbjFTNVJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 20 Jun 2023 09:21:09 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4FE91989
        for <io-uring@vger.kernel.org>; Tue, 20 Jun 2023 06:20:02 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id d2e1a72fcca58-657c4bcad0bso1238230b3a.1
        for <io-uring@vger.kernel.org>; Tue, 20 Jun 2023 06:20:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1687267196; x=1689859196;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UEFA34pFUwhVcGgci//ZeJKWc+7aQOxgXhgfZEM3Q/Q=;
        b=ya2A/mmIkilyKXn+oAp77W7Pf7FCL8440ojqTqGZ5In/oho9ka2KOZzV/i5VBfyzw3
         7GNkmyPIvyUvdwlBfir9ZGHykUT8ofXyyg9aiHZCtgngEzXKdiAimNtfRely8Ro+zPQN
         uHZXphFgxq88eQif+u1yn7T2ZRjnlDTgv+ap6n+HlnlLkd6amTDad/gXFpcLTYhnWGHY
         x6251eSMvK0q0H5vtbFbSilMphQzsDjOPBwyzS35XFaXwA4FrkhWuMbQVPiA0zPlGr0H
         PeXYzw+C7rdbPY/wcRbQHZk4EH9QY7nKXUmRNupY1sMMUn8XjxMDRF96OgpJPYU8J0MF
         iINA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687267196; x=1689859196;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=UEFA34pFUwhVcGgci//ZeJKWc+7aQOxgXhgfZEM3Q/Q=;
        b=Ki+ZTX9W49bsAL7FB8jduS3qpQMpOanHciubLvkQ6MkbRCxfE6LBd5HXBXw4qOFume
         KHXjNJy9ai3cZZnqKeyOHBMA2Q+r3688aVWGYPVPNgVRqS2Ogt3ShiJIlOvTNJYoZj35
         Rllq0Nla9lBpHjBnGFMGvGM7AmOy4Q7WNtwmSdTCP8JctUQfVnxZA8KZClmnvG/4ASgu
         ydNZtQVkhxWVM1Ph/xgv8V/AQ1MIZ0E795OMaruWlnliM/dhzez5LGvL1gRrFOz5Mvhj
         TWZkGRkPQfJPTtAGFlV1eFDTUiLDyxR1PiPf2k63a5XPvoI/Ld7QO63xPH0AVJ5Xlfa7
         NHMw==
X-Gm-Message-State: AC+VfDx/Sm1WX3IMUwPPZq5j/FztlgA4ob1iE7aGaM/dtzIFE2bsBKBn
        NGxkxMYpUeI05BRKCkTJE9ZZBXw9FcOVr7ha098=
X-Google-Smtp-Source: ACHHUZ7yB5zEpB4wrzL27UlyV1IS8nj6Bn1FOLUVEuwk1rKMAXj0wm++gjrsYOW4SOySKj1JtlQWEQ==
X-Received: by 2002:a05:6a00:1d13:b0:668:6eed:7c15 with SMTP id a19-20020a056a001d1300b006686eed7c15mr7845893pfx.2.1687267195751;
        Tue, 20 Jun 2023 06:19:55 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id g24-20020a62e318000000b00665deed742asm1322790pfh.193.2023.06.20.06.19.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Jun 2023 06:19:55 -0700 (PDT)
Message-ID: <7e16d521-7c8a-3ac7-497a-04e69fee1afe@kernel.dk>
Date:   Tue, 20 Jun 2023 07:19:54 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH v2] io_uring/net: disable partial retries for recvmsg with
 cmsg
To:     io-uring <io-uring@vger.kernel.org>
Cc:     Stefan Metzmacher <metze@samba.org>
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We cannot sanely handle partial retries for recvmsg if we have cmsg
attached. If we don't, then we'd just be overwriting the initial cmsg
header on retries. Alternatively we could increment and handle this
appropriately, but it doesn't seem worth the complication.

Move the MSG_WAITALL check into the non-multishot case while at it,
since MSG_WAITALL is explicitly disabled for multishot anyway.

Link: https://lore.kernel.org/io-uring/0b0d4411-c8fd-4272-770b-e030af6919a0@kernel.dk/
Cc: stable@vger.kernel.org # 5.10+
Reported-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---

v2: correct msg_controllen check and move into non-mshot branch

 io_uring/net.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index c0924ab1ea11..2bc2cb2f4d6c 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -789,16 +789,19 @@ int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 	flags = sr->msg_flags;
 	if (force_nonblock)
 		flags |= MSG_DONTWAIT;
-	if (flags & MSG_WAITALL)
-		min_ret = iov_iter_count(&kmsg->msg.msg_iter);
 
 	kmsg->msg.msg_get_inq = 1;
-	if (req->flags & REQ_F_APOLL_MULTISHOT)
+	if (req->flags & REQ_F_APOLL_MULTISHOT) {
 		ret = io_recvmsg_multishot(sock, sr, kmsg, flags,
 					   &mshot_finished);
-	else
+	} else {
+		/* disable partial retry for recvmsg with cmsg attached */
+		if (flags & MSG_WAITALL && !kmsg->msg.msg_controllen)
+			min_ret = iov_iter_count(&kmsg->msg.msg_iter);
+
 		ret = __sys_recvmsg_sock(sock, &kmsg->msg, sr->umsg,
 					 kmsg->uaddr, flags);
+	}
 
 	if (ret < min_ret) {
 		if (ret == -EAGAIN && force_nonblock) {
-- 
2.39.2

-- 
Jens Axboe

