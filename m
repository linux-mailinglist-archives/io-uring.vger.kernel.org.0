Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49734650E57
	for <lists+io-uring@lfdr.de>; Mon, 19 Dec 2022 16:12:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232195AbiLSPMr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 19 Dec 2022 10:12:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232560AbiLSPMq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 19 Dec 2022 10:12:46 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C231C6317
        for <io-uring@vger.kernel.org>; Mon, 19 Dec 2022 07:12:40 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id h16so8921103wrz.12
        for <io-uring@vger.kernel.org>; Mon, 19 Dec 2022 07:12:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Cg/1HYUCj31GNmgblL15huvKk0ciMPVX9GP2Lf5iEYc=;
        b=KlzCslAd2pO/cJmgFfiiY6mFutAZkBGdzfJfKmgogQDZUE65chQXwzxs9RQc2piwj4
         7Q7wWNhoCwq5ab4ws75s75QkiISPCAlSOZirDJq/E/dJ6GlXjVIyM9p+6j2XAJKro67n
         T6243YlfKx49Uk+Q79rvDQKdtdMBfcVheA5PK1IluBsxQYIBQ0XFMDCbR239S0wcRzw7
         MO3g+m746Rx/cZiKSBJlIZhYULuM/7pioqK1Zuz8uKaxDuCwD9kqP2ftDrswAN4j976y
         WCAyjJyNE64qXiPBQkV2xYbIuFf7/30PsC//ww0dUTn9HNF1IMbzjuIUgdMxMfayY+SH
         hWEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Cg/1HYUCj31GNmgblL15huvKk0ciMPVX9GP2Lf5iEYc=;
        b=kq69TJHx6KU4oURQ1INrX5FoITC73SHVWLawClfXc1xiMdJiqbJ2u/1YO4ccSC8O7c
         Rw05Zh9gl+HM8p3lfQDH8JNSxCGKYZdi+k0RKpUDzPC1MzCCX1Ips1jmSoBampkPkGZv
         i6mLnb+lmhw7clLwkIurVbkqclW06OgDVUnqlWr0t5RhwUwiiA0nAXqf5BAHcOZW+iIB
         FtGwjUsESnGtruAQwQcsdCycyx0FTnn8m5a9OoTt/7xNJ7AjTCpU0GWGQoJwYq44U7EH
         GquHe9EnONTtM8PjzeHcYHRb2he/IQ4CA8vxdzfGfEKgZQEgQA557GL4UMMkABiNwG9y
         AyxA==
X-Gm-Message-State: ANoB5pmGLfx4FMgS316WqYppFsJORljTU3+Bnv3Rz8mfXztogl9w4yzY
        Hi1drecdbLyE1XJXby3yCo0chOsw3hrB+g==
X-Google-Smtp-Source: AA0mqf7IKinDzakRSMAwzDddsUHjgHVcsdBaOeZhI0KKrwbzFUmuNgJI3c+LXP/E9EeyqFWo9x7GgQ==
X-Received: by 2002:a05:6000:1c0d:b0:253:62af:8478 with SMTP id ba13-20020a0560001c0d00b0025362af8478mr15923575wrb.43.1671462759125;
        Mon, 19 Dec 2022 07:12:39 -0800 (PST)
Received: from 127.0.0.1localhost (188.28.109.17.threembb.co.uk. [188.28.109.17])
        by smtp.gmail.com with ESMTPSA id b4-20020a5d4d84000000b002423a5d7cb1sm10168629wru.113.2022.12.19.07.12.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Dec 2022 07:12:38 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 1/1] io_uring/net: fix cleanup after recycle
Date:   Mon, 19 Dec 2022 15:11:40 +0000
Message-Id: <9e326f4ad4046ddadf15bf34bf3fa58c6372f6b5.1671461985.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Don't access io_async_msghdr io_netmsg_recycle(), it may be reallocated.

Cc: stable@vger.kernel.org
Fixes: 9bb66906f23e5 ("io_uring: support multishot in recvmsg")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/net.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 5229976cb582..7395b2c99f86 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -819,10 +819,10 @@ int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 		goto retry_multishot;
 
 	if (mshot_finished) {
-		io_netmsg_recycle(req, issue_flags);
 		/* fast path, check for non-NULL to avoid function call */
 		if (kmsg->free_iov)
 			kfree(kmsg->free_iov);
+		io_netmsg_recycle(req, issue_flags);
 		req->flags &= ~REQ_F_NEED_CLEANUP;
 	}
 
-- 
2.38.1

