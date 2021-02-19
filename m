Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 456EE31FFFD
	for <lists+io-uring@lfdr.de>; Fri, 19 Feb 2021 21:50:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbhBSUuH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Feb 2021 15:50:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbhBSUuG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Feb 2021 15:50:06 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21413C061786
        for <io-uring@vger.kernel.org>; Fri, 19 Feb 2021 12:49:26 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id f7so9151588wrt.12
        for <io-uring@vger.kernel.org>; Fri, 19 Feb 2021 12:49:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=ZyTwY5vdUUD/+YZlFi12xNn+AuHE/EaDeHywsrNm3PA=;
        b=q5Oz5mDaZcV1U3EycLUc6D+X00W6xckG87ScRjR1QkBcJp6Juv5y6BHhRyLgmFLnTT
         196UOWVZWPOPUe7GaqnxhSwQ7Ohp7DjOBGFLA6+KpYNqKdFaPqtt7ePUxcN14hWq7ri/
         MyxWepTNOtuuB0ZQgwoIz47fcxap3BlntsjNdgyQJP9Xj1vbucq6m+8sg7BxAlElI5JK
         VOkQhkHLixPuulMS5y3YTGtbYS8W+BY+FtUltLRa89H7nBFg5Ebo2GExnYKSHb9wNL7e
         /D6Ee62h+R4C1MQmpA50uJKGzC7Dvh+UNeyK13WvbSF/BRM87DnDFjL3oqEPUEKFSGd1
         Raew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZyTwY5vdUUD/+YZlFi12xNn+AuHE/EaDeHywsrNm3PA=;
        b=cozoovdc/chuQ0upOUUhCeZMY+G0gUUeuWAlAUNTdizXexrMWPxXY0QUk1WgW+phyk
         MdFfJK1iwNXE3Py3w6o2p3APcC0TJe6P2qaVIv2hZ8drEK5b/uir7mtPbCNiYnjiuNE1
         HS7EUt1fpTNt0KUFIJA5vYM/EvPaLuW5mREau9ZuyECSEiF0dI5DqvuAHdhzaQxmcD0t
         me/nP2LsgXOXV1tJpERioD8jD1S8hXjd9T+itDGJBdpXqeogi+8SCbI95m/5/sbr45Ah
         69dpHAtJzYBbuLEAa6vLzbfr54gt+crt8aHk2NQCkJPfhM9bZ7jIDbfhdXMNi/CUlwkH
         +oVQ==
X-Gm-Message-State: AOAM533PUgq9LEgScX2MzlBNag+hlkZ0NLFw0N322C+ZtSaUfIvHuQiu
        zYb+sG2iv3wpuAYqkRWYToX2fMSknE2Tcg==
X-Google-Smtp-Source: ABdhPJxFTbgDIzBof4eZWcd4sCr55nNyvBxmPGgBa+KsHtcd524uLGqpxkRvDQHKteJXjK143ld/0g==
X-Received: by 2002:a5d:5104:: with SMTP id s4mr10662045wrt.277.1613767764869;
        Fri, 19 Feb 2021 12:49:24 -0800 (PST)
Received: from localhost.localdomain ([85.255.236.139])
        by smtp.gmail.com with ESMTPSA id l17sm3207298wmq.46.2021.02.19.12.49.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Feb 2021 12:49:24 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 1/3] io_uring: zero ref_node after killing it
Date:   Fri, 19 Feb 2021 20:45:24 +0000
Message-Id: <611ab369e6aab4d4008a4e41e17a53d44c5d7c04.1613767375.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1613767375.git.asml.silence@gmail.com>
References: <cover.1613767375.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

After a rsrc/files reference node's refs are killed, it must never be
used. And that's how it works, it either assigns a new node or kills the
whole data table.

Let's explicitly NULL it, that shouldn't be necessary, but if something
would go wrong I'd rather catch a NULL dereference to using a dangling
pointer.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index b7bae301744b..50d4dba08f82 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7335,6 +7335,7 @@ static void io_sqe_rsrc_kill_node(struct io_ring_ctx *ctx, struct fixed_rsrc_dat
 
 	io_rsrc_ref_lock(ctx);
 	ref_node = data->node;
+	data->node = NULL;
 	io_rsrc_ref_unlock(ctx);
 	if (ref_node)
 		percpu_ref_kill(&ref_node->refs);
-- 
2.24.0

