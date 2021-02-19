Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 912F231FD9F
	for <lists+io-uring@lfdr.de>; Fri, 19 Feb 2021 18:13:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229746AbhBSRKx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Feb 2021 12:10:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbhBSRKw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Feb 2021 12:10:52 -0500
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B69DC061222
        for <io-uring@vger.kernel.org>; Fri, 19 Feb 2021 09:10:33 -0800 (PST)
Received: by mail-io1-xd33.google.com with SMTP id q7so6391079iob.0
        for <io-uring@vger.kernel.org>; Fri, 19 Feb 2021 09:10:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=S6aXReAOH/r1zkhoTxhRzRN8MMOH917AAspm2AbvCr8=;
        b=ysuhE1MnF0aK4xjQwf0VgZWjv5B2VdctL/id7qEC5CTMuJmIcgSHPz1cXWvQylvQla
         B3ZIwidJ21Qgxit/wHWtZO4MEIxOAvPFCakb9zm7Eznb2Z9l7is3/e+AV/EnmyeZ4ER7
         2cPNgKecjEOF1BtehTCzdiA4WT20AMKHJKmN2wutgLf/GKitUssVfbJEacIXn5ZbJEEp
         e0H06d9DcCu3I6qrUcNCwNqWrnk2SumYD2yeLPPXD7g88vZasWstKFw6CGkMvVL/Fnrq
         YA/tA69aR1ILjTNmDOJunbUzbHvTCDUWskAzyCQ/Ix33ISh2ouvj9lmsleFd9toLB36N
         JCBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=S6aXReAOH/r1zkhoTxhRzRN8MMOH917AAspm2AbvCr8=;
        b=hJT7U2QDxIsXdoNbwa9/mDKnskqL60T2mMV9oaizs6Xaryx9qVHZQ07XZd8CF4/3Xr
         DyqYLtxIam5oKWIq9htduLmpOdbH7WoSpSG/2iXFUmpEf9VoKQqUwBOnsSAMnplkRlpl
         MR+i+SOnCAKTxwx8Nw83Y4xWiu/sCdMnceQKgJM8+KOrdCzvhtu8NOkC162vId+FIzfd
         5JW9mpCE6xCah8m7r5RRaxworQno0OBZ7Yqwh2RddN/YDsG7o+J88FPLeomvXb13KeGA
         PqC8s5Um4YeuN2c/TwkHVqEL9en1NEedWnD78MuC1kLrLrbk9vbVKzkbgdTZW8RV6rpH
         OzBw==
X-Gm-Message-State: AOAM530nDpIAXpybEogFeZEKkbqDhKHC3hry3Q7UE+TMlmtT2yP7dbTE
        e9hTg9VFeo+l59ePS0tJTUIdsq1LhQgCBHI7
X-Google-Smtp-Source: ABdhPJxSog2zX1NGySdl9mk35Cg9VVs6Mql7KS0GgK9lklTlux21N+iK5cewMb/XO951qQsjfhdkVA==
X-Received: by 2002:a05:6638:2683:: with SMTP id o3mr10904259jat.8.1613754631706;
        Fri, 19 Feb 2021 09:10:31 -0800 (PST)
Received: from p1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id o17sm4805431ilo.73.2021.02.19.09.10.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Feb 2021 09:10:31 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     ebiederm@xmission.com, viro@zeniv.linux.org.uk,
        torvalds@linux-foundation.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 18/18] net: remove cmsg restriction from io_uring based send/recvmsg calls
Date:   Fri, 19 Feb 2021 10:10:10 -0700
Message-Id: <20210219171010.281878-19-axboe@kernel.dk>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210219171010.281878-1-axboe@kernel.dk>
References: <20210219171010.281878-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

No need to restrict these anymore, as the worker threads are direct
clones of the original task. Hence we know for a fact that we can
support anything that the regular task can.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 net/socket.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/net/socket.c b/net/socket.c
index 33e8b6c4e1d3..71fb2af118f5 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -2408,10 +2408,6 @@ static int ___sys_sendmsg(struct socket *sock, struct user_msghdr __user *msg,
 long __sys_sendmsg_sock(struct socket *sock, struct msghdr *msg,
 			unsigned int flags)
 {
-	/* disallow ancillary data requests from this path */
-	if (msg->msg_control || msg->msg_controllen)
-		return -EINVAL;
-
 	return ____sys_sendmsg(sock, msg, flags, NULL, 0);
 }
 
@@ -2620,12 +2616,6 @@ long __sys_recvmsg_sock(struct socket *sock, struct msghdr *msg,
 			struct user_msghdr __user *umsg,
 			struct sockaddr __user *uaddr, unsigned int flags)
 {
-	if (msg->msg_control || msg->msg_controllen) {
-		/* disallow ancillary data reqs unless cmsg is plain data */
-		if (!(sock->ops->flags & PROTO_CMSG_DATA_ONLY))
-			return -EINVAL;
-	}
-
 	return ____sys_recvmsg(sock, msg, umsg, uaddr, flags, 0);
 }
 
-- 
2.30.0

