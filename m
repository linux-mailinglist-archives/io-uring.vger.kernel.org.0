Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 229F5438355
	for <lists+io-uring@lfdr.de>; Sat, 23 Oct 2021 13:14:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230361AbhJWLQt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 23 Oct 2021 07:16:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230320AbhJWLQo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 23 Oct 2021 07:16:44 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE9E7C061764
        for <io-uring@vger.kernel.org>; Sat, 23 Oct 2021 04:14:13 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id d3so5247056wrh.8
        for <io-uring@vger.kernel.org>; Sat, 23 Oct 2021 04:14:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LY2goCGsqDkwhcUEh3IhX4upkkdQvvcmgcZb2AGt/Vw=;
        b=Up7MsDYlbvPYVEK2EGwZgc8U/iSRkJWE5VRPuD/hgm1wSUNKiwIdSbgsYcNhl7X+R5
         +7FC/bMMK6f6nMaQ3ctvalt813p5LIIiCLJZHydYg7tQOKDs//6dcgtU3+Ac6vdHjqg8
         qFJiQJDpYT5p2efBVI3UsDn8PuQqTGErmjlBS4JpWfeWoQKuiFpwfH7qLf/ofdFJ/FVN
         iGIquptErRdjpJdHq5PqhjutlO+JTQH0kiqhdZ+MnJyWchiMHHdhSHF00TG5NFP6Vdd2
         Q2ydDjK/wbPDiN4pgAQX5iTZwn+Ku6RcCQqNUaOqMj5TlnjlJ6vdaj1vAK2mN6XoLIQF
         X92A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LY2goCGsqDkwhcUEh3IhX4upkkdQvvcmgcZb2AGt/Vw=;
        b=vrBFPA5RXdkQxrrXBxujboNpd1dj11uXNKnquPJS0F5uTbKCJ+q9u3agIEVx5W4MZi
         LHLDe/lPQ2xL+neKJpTmxyzq4IvwM0Envky0uc8vMUwN4Kt23v38zsRUAVslF9Zva7pi
         d6RR7u3nlfiGvNsqEcn6zlVo2l8Vw/+3HhNwGmIBx67m96hMSdTtOwD9p5wBZ2JDbaGE
         6A1pann9wMeAgFBetR2x6P2BAAMFyI/KQa13JcVdtBUUXwfOW9UeJaWqXV/CQDCaqe7J
         aiJVIeSUK6xheHiC/Z5SQ4oCKwBIcOTYic6al28YVs8uncryAqtz0LHMrlK/14YfJJcU
         Cjkg==
X-Gm-Message-State: AOAM5320jCjGtfbe37Q8qhqoxlNsuUyh166TRiy9Ar9g4mbFgj2IqFW5
        PpMdEiNJlLc5mELiqXUjMxGM5VOH5is=
X-Google-Smtp-Source: ABdhPJw8WSMdE99avEFFLK3MxYtiH2FMFnDy7elY+a0aFfOzcciyc6tKoZvzCSX4I2wyvVc6pNFUvQ==
X-Received: by 2002:a05:6000:24a:: with SMTP id m10mr7078091wrz.378.1634987652345;
        Sat, 23 Oct 2021 04:14:12 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.133.195])
        by smtp.gmail.com with ESMTPSA id w2sm10416316wrt.31.2021.10.23.04.14.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Oct 2021 04:14:12 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, Hao Xu <haoxu@linux.alibaba.com>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 4/8] io_uring: check if opcode needs poll first on arming
Date:   Sat, 23 Oct 2021 12:13:58 +0100
Message-Id: <9adfe4f543d984875e516fce6da35348aab48668.1634987320.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1634987320.git.asml.silence@gmail.com>
References: <cover.1634987320.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

->pollout or ->pollin are set only for opcodes that need a file, so if
io_arm_poll_handler() tests them first we can be sure that the request
has file set and the ->file check can be removed.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 58cb3a14d58e..bff911f951ed 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5584,12 +5584,10 @@ static int io_arm_poll_handler(struct io_kiocb *req)
 	struct io_poll_table ipt;
 	__poll_t ret, mask = EPOLLONESHOT | POLLERR | POLLPRI;
 
-	if (!req->file || !file_can_poll(req->file))
-		return IO_APOLL_ABORTED;
-	if (req->flags & REQ_F_POLLED)
-		return IO_APOLL_ABORTED;
 	if (!def->pollin && !def->pollout)
 		return IO_APOLL_ABORTED;
+	if (!file_can_poll(req->file) || (req->flags & REQ_F_POLLED))
+		return IO_APOLL_ABORTED;
 
 	if (def->pollin) {
 		mask |= POLLIN | POLLRDNORM;
-- 
2.33.1

