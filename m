Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 245C96F3654
	for <lists+io-uring@lfdr.de>; Mon,  1 May 2023 20:53:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232662AbjEASxK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 1 May 2023 14:53:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232718AbjEASxJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 1 May 2023 14:53:09 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AABEFE65
        for <io-uring@vger.kernel.org>; Mon,  1 May 2023 11:52:49 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id 4fb4d7f45d1cf-50bc4d96e14so11584018a12.1
        for <io-uring@vger.kernel.org>; Mon, 01 May 2023 11:52:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bnoordhuis-nl.20221208.gappssmtp.com; s=20221208; t=1682967168; x=1685559168;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=E0h7t1U6v1ndqGE0MIvwz7KRYAzJlURxmpjO+aCSq78=;
        b=p5Jn95mMC/gSaIpMM/cy/zn1wPgyjVDlBlGSF0cn5OsHbCJuhyF7ixYZ2OZsWaPRYf
         Dn1zc0ATxvvb8XDPLBfubkq4ZIJ6odQjOI+WSTLjZUwvznLrPPzgoN6ePqDa00uij6o9
         EbWcFF3ExFEAHT5wO1CBCo3zdmr1IQtRZ+W1cSliPaDjmdpfYPvvWX+IXkjU5PQjKlgW
         t8L5ozWhTwq3SL8b/HXZ+F+WApBpw3WTq8+uWJ3LRc5Cs2iKg5PPJa2I4U+O381eiCND
         rmqm53ERKd2VTItGZr9YkDIIqtMwoUW/kTlpIT3vq1q0q6wz00Zz6WwSu6iwCa1tGpxh
         UaWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682967168; x=1685559168;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=E0h7t1U6v1ndqGE0MIvwz7KRYAzJlURxmpjO+aCSq78=;
        b=c+Z3uET+Iaq4D/Ox1m8hq6xU6tqaRufn5TPP75wdE6dQTcPmBd1R0c66WtO2xtwTP/
         pgESHceya+u5TpJMoUbgJrjg1qC/fDdF19Op0htbDXdbiZ1nHpihmh57UgcEePzC6FEC
         VlIDSGJbB4j7k1PoWhw2qJ+QQ5SXGrXzsOyS1qzM4exGPMoXDeEty34OL4e15jgmXnPP
         Muyta+SPCoapZb4BKd3FX090n0jK0rtNDHFGV5zLZ8NrVSUZogJLnYNZgFhjBSBACbra
         +jNTQRS05Sf7q0B/9bayGnD8oHV9vy6/kD0qLIin/zV2QJ8JEX2g27oqpB8Pgt2aDaqk
         JEFA==
X-Gm-Message-State: AC+VfDyvdUP+VNUwOmFqhH4MHqPS1B/kzIUiMv0y9AAFGbHfzUFoJcKH
        quyz77g3DzO0tGzbpkPs2fDVsw/JcXd/gRC7QaE=
X-Google-Smtp-Source: ACHHUZ4ruVUkiMFIatsIj/VXA7UxkhoYKRvr3ih68Rrr1Wlt3kRWZQj1u3wYesVbekDXW3f4Cdc/wQ==
X-Received: by 2002:a05:6402:34cd:b0:4fc:97d9:18ec with SMTP id w13-20020a05640234cd00b004fc97d918ecmr6104447edc.21.1682967168208;
        Mon, 01 May 2023 11:52:48 -0700 (PDT)
Received: from bender.fritz.box ([94.231.240.204])
        by smtp.gmail.com with ESMTPSA id qt2-20020a170906ece200b0094e1344ddfdsm14994919ejb.34.2023.05.01.11.52.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 May 2023 11:52:47 -0700 (PDT)
From:   Ben Noordhuis <info@bnoordhuis.nl>
To:     io-uring@vger.kernel.org
Cc:     Ben Noordhuis <info@bnoordhuis.nl>
Subject: [PATCH] io_uring: undeprecate epoll_ctl support
Date:   Mon,  1 May 2023 20:52:40 +0200
Message-Id: <20230501185240.352642-1-info@bnoordhuis.nl>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Libuv recently started using it so there is at least one consumer now.

Link: https://github.com/libuv/libuv/pull/3979
---
 io_uring/epoll.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/io_uring/epoll.c b/io_uring/epoll.c
index 9aa74d2c80bc..89bff2068a19 100644
--- a/io_uring/epoll.c
+++ b/io_uring/epoll.c
@@ -25,10 +25,6 @@ int io_epoll_ctl_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_epoll *epoll = io_kiocb_to_cmd(req, struct io_epoll);
 
-	pr_warn_once("%s: epoll_ctl support in io_uring is deprecated and will "
-		     "be removed in a future Linux kernel version.\n",
-		     current->comm);
-
 	if (sqe->buf_index || sqe->splice_fd_in)
 		return -EINVAL;
 
-- 
2.37.2

