Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFD0A32D9CF
	for <lists+io-uring@lfdr.de>; Thu,  4 Mar 2021 19:59:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234714AbhCDS5z (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Mar 2021 13:57:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235745AbhCDS5s (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Mar 2021 13:57:48 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1A1DC061765
        for <io-uring@vger.kernel.org>; Thu,  4 Mar 2021 10:56:34 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id h7so1400135wmf.3
        for <io-uring@vger.kernel.org>; Thu, 04 Mar 2021 10:56:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=0KK8fVMBS+gwvpRC8+iZ8nhCxsk3C6HmhNwn/ebTShQ=;
        b=WbNcUPaPEwf/1Qd7tTX5gTtxOT0gSzmnBE5VRTnF+dhj+Hxuwm3VUhYHhml6vc6p1a
         UrSmJL+6FSzkE9FGCbhu8Iy7J54JLid7f8s/FxwRcI/md0Y8WYRWpfwAD3UYK33v1BxC
         mYxIt6Q+fqy/YlOOk2F9JZhEoqmtxe/ulMx+uveebTmRRKGG6ImQP3q7nrzMCXnCmVSE
         R+WuQKhcpGnrjGtiSq10Owxn2ikKpDPWJHk7xc0broS+yUUqM94k2fbmggy6/8T3OBX2
         2n8mtDSLKOBf/QzdB9devnocsaWGePNbM1vnipGalKq8E5SsyTAZ6D59MYeYtvgITV+c
         KSYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0KK8fVMBS+gwvpRC8+iZ8nhCxsk3C6HmhNwn/ebTShQ=;
        b=Adg2mUmUGj7C4g2Kr2sRQYjs67rYsCxs3sNNymxpyeZXKKoM+pkdPevz3pRopOl/PD
         TC3lbVOGtpuaJ+b1h875U4o0UgEEck7hlrsTKLXpN7cQypCYpH6QzUILCPERdapNw0DE
         RqqmpaQGJolom4FRpD3MJUyBDOt/hndDjS1Ks3cABV2oLNgzfZxjkyTjhzLSjJ4UPx9z
         4zlXufoU+dGr4+txml+AVXI6Pwvv/AJ3UNWgUKwXoobQOiKcZgjmV2Ae/r9uwvsNADI+
         Nc7G0STBj6QjtG62jbaMY8ea1vow90lM5+mJJBfvzJ3zRwGPPanO7w6kKxmoViNkWqaQ
         eSSg==
X-Gm-Message-State: AOAM533fz42mZ62JmvJU7qaIoDRXIKn7ef1Un8HoF72rwSkVwxIbvFqN
        NRJOp3xUzRWKz5vDjfAJEY5VXUZxfF/CZw==
X-Google-Smtp-Source: ABdhPJwAo5KvhpPJ9nDyfKDTSxVGFCBuw5jQ1dUZ3r4cajPXKwk7qn1540Nx7w9KD/+kq5W099/VcQ==
X-Received: by 2002:a7b:c119:: with SMTP id w25mr5200098wmi.127.1614884193570;
        Thu, 04 Mar 2021 10:56:33 -0800 (PST)
Received: from localhost.localdomain ([148.252.129.216])
        by smtp.gmail.com with ESMTPSA id k11sm575800wmj.1.2021.03.04.10.56.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 10:56:33 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 08/11] io_uring: set req->work closer to all other fields
Date:   Thu,  4 Mar 2021 18:52:22 +0000
Message-Id: <14c67683bf06ff66f8885767b51ed61265fa89ea.1614883424.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1614883423.git.asml.silence@gmail.com>
References: <cover.1614883423.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Keep req->work init close to setting all other fields, it's in
io_init_req() anyway.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 9ebc447456ab..da5d8d962bff 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6271,6 +6271,9 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	atomic_set(&req->refs, 2);
 	req->task = current;
 	req->result = 0;
+	req->work.list.next = NULL;
+	req->work.flags = 0;
+	req->work.personality = READ_ONCE(sqe->personality);
 
 	/* enforce forwards compatibility on users */
 	if (unlikely(sqe_flags & ~SQE_VALID_FLAGS)) {
@@ -6288,9 +6291,6 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	    !io_op_defs[req->opcode].buffer_select)
 		return -EOPNOTSUPP;
 
-	req->work.list.next = NULL;
-	req->work.flags = 0;
-	req->work.personality = READ_ONCE(sqe->personality);
 	state = &ctx->submit_state;
 
 	/*
-- 
2.24.0

