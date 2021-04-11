Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A44B135B10A
	for <lists+io-uring@lfdr.de>; Sun, 11 Apr 2021 02:51:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234548AbhDKAvQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 10 Apr 2021 20:51:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234903AbhDKAvP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 10 Apr 2021 20:51:15 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B6E2C06138C
        for <io-uring@vger.kernel.org>; Sat, 10 Apr 2021 17:51:00 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id f12so9286434wro.0
        for <io-uring@vger.kernel.org>; Sat, 10 Apr 2021 17:51:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=rWNCnlZRaV7HOQmboEsYk0jfiAS3rW7UT1YeWFbaJe0=;
        b=Z3mu7HLGxQ4e9Q1r8Xix3kLKjs07btdmI6hxZ5sKmUQOGAmavT94oiQYwEmp07NhFN
         JSmMqYUdfblIRm1GI3IhpIQdjkxdaDgpxGgLZS8nXWbxkwEvl1xlLAnbTfCNMy1g5JfO
         t9iaQZAX2DF7p25bniknSq1U9ZZG5Z742YJQQ+hdOMngjuObMuzbFuPFfTEamw1Lmjc+
         HvlgMxDuebWI2LiPgIyGygqa7ypHJRsUZAgRdppXoArj8K2RUM7QbuYR5RcgkAmj0ZIT
         VjSwRc6vXYRVxoqwQ+iDWxKzRAvJY9s29+n7iBkWCJq9ZtsqcVusluQJYCGmDiL/NRdP
         whmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rWNCnlZRaV7HOQmboEsYk0jfiAS3rW7UT1YeWFbaJe0=;
        b=thVZBeKob4Ba6nioXDdpqjiJUCFu3RhWHPKKJ2GgpnrKporq2dXfz9x0jBxSMQ+TVH
         Q2v+630TJtQl5HGLvA7qrJbkT0QHwR8xQ0ycRCPeoyQixSjH5xRhna3Dw4xl4PKya6/2
         DAQanA+S+rybHPYw/d8Yd8VTxWalzdo0wdlehx71F6pYtPAetF8BzJWGElfDsf5rPFpx
         2h3sQ4tHrMVnLzHxlzxPKYXS6bp77DfQ0aJcGUnxkBKbfBuO68oMuJOzzdAhm4C0xbTg
         faeFU8za3SsqBYu3JeJIl2N769h87KONzBmYJMsp9yLcgZ5789rSPYIRTO+NN6I9h0HH
         2kZw==
X-Gm-Message-State: AOAM533mBABKlWeeQihYYp6Uk+fjAMyTXp+ZzHJ0XyhcOBYarR/mTvpz
        oNJCjQoFkWsZQIgQW4Dzopg=
X-Google-Smtp-Source: ABdhPJx4U5fod1taJQHAjWquS3ZSTefACUeJSf66p5+qpxyKVrRHhOvdfySdPmLjejP4vuP3g0NuMg==
X-Received: by 2002:a5d:670f:: with SMTP id o15mr10848757wru.63.1618102259046;
        Sat, 10 Apr 2021 17:50:59 -0700 (PDT)
Received: from localhost.localdomain ([85.255.237.117])
        by smtp.gmail.com with ESMTPSA id y20sm9204735wma.45.2021.04.10.17.50.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Apr 2021 17:50:58 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 06/16] io_uring: refactor compat_msghdr import
Date:   Sun, 11 Apr 2021 01:46:30 +0100
Message-Id: <73fd644dea1518f528d3648981cf777ce6e537e9.1618101759.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1618101759.git.asml.silence@gmail.com>
References: <cover.1618101759.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add an entry for user pointer to compat_msghdr into io_connect, so it's
explicit that we may use it as this, and removes annoying casts.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index cfd77500e16c..dd9dffbd4da6 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -572,8 +572,9 @@ struct io_connect {
 struct io_sr_msg {
 	struct file			*file;
 	union {
-		struct user_msghdr __user *umsg;
-		void __user		*buf;
+		struct compat_msghdr __user	*umsg_compat;
+		struct user_msghdr __user	*umsg;
+		void __user			*buf;
 	};
 	int				msg_flags;
 	int				bgid;
@@ -4438,16 +4439,14 @@ static int __io_recvmsg_copy_hdr(struct io_kiocb *req,
 static int __io_compat_recvmsg_copy_hdr(struct io_kiocb *req,
 					struct io_async_msghdr *iomsg)
 {
-	struct compat_msghdr __user *msg_compat;
 	struct io_sr_msg *sr = &req->sr_msg;
 	struct compat_iovec __user *uiov;
 	compat_uptr_t ptr;
 	compat_size_t len;
 	int ret;
 
-	msg_compat = (struct compat_msghdr __user *) sr->umsg;
-	ret = __get_compat_msghdr(&iomsg->msg, msg_compat, &iomsg->uaddr,
-					&ptr, &len);
+	ret = __get_compat_msghdr(&iomsg->msg, sr->umsg_compat, &iomsg->uaddr,
+				  &ptr, &len);
 	if (ret)
 		return ret;
 
-- 
2.24.0

