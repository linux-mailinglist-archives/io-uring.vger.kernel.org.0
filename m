Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E73573BD0D
	for <lists+io-uring@lfdr.de>; Fri, 23 Jun 2023 18:48:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232482AbjFWQsX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 23 Jun 2023 12:48:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232484AbjFWQsP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 23 Jun 2023 12:48:15 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD710295E
        for <io-uring@vger.kernel.org>; Fri, 23 Jun 2023 09:48:12 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id d9443c01a7336-1b3ecb17721so1212345ad.0
        for <io-uring@vger.kernel.org>; Fri, 23 Jun 2023 09:48:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1687538892; x=1690130892;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dd/IY/rhGZi+33z0aLAZgR+jpqqduQJQDHihiNUSDnY=;
        b=MIXBrkFJykHaU5BsR4IZHs+AYkCdYBzKWaUnQaEVGwwwW4a7anD843JxbUxACrpdhg
         k5FYebv6WVeRgENNp2PxnBkINUR2uAoib1F98W6pj10aHWN4A4ZK5ocD5rmrKMJP9Aqv
         kzbCMkB4Zm/EE+X7l8dHFBcbi07rAAxq/5wnEZjBdylFhGLdqVkgOatDuNYdyBcpEkya
         hmFF0im3P96RKNVT0CCoE0UR79dQFTWefVydMCwvVVXjbvK3FcOC06qJLcD/EyPNdIZB
         D2nx7O+96JNOtxwBgTzXlbl2HSZR/ZTLSfHdvke9TyzgaGtIrEpmWHarbZ2M7/JP7rt+
         QPFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687538892; x=1690130892;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dd/IY/rhGZi+33z0aLAZgR+jpqqduQJQDHihiNUSDnY=;
        b=FOnxs1q6A6x/BgLd6DC/MnnorGIp9sIi0DVd1RbxFe6agfr+cKEsoV70+7h9drg7/O
         zQ6Tt/uJYwM3hqovpYBd72oHdsyaXut7HTYha4eCH3xsRS2/6A+dwHMdfQIAbwuNYpls
         twGXyab7Wp/rDRS9ujEfrYAimZpxKx2zcBI5q8ZcQtxosPB3+TTyHh3ytbv2UYJu1Srq
         tYQo0CY0qnK3kpk1V0cbcAet4nW3aJLsAE5k5De6HVNY94n9GIW1Qfl3I9aKgEsEJUXL
         lGPQ5eE7gAa8y7ALf4swMLli3eBlID+DHFXraY7qsfVhJKAguvtJYNfdq4JVWNUGzhxn
         +gaQ==
X-Gm-Message-State: AC+VfDy1IX7nHd/rwKORztl87NpTojYNE1+KgMyGlyPR1eql4rV9N17N
        +qHtX247pcjLLMcZ2wSTzifyOc4NmtReZWfgQ7o=
X-Google-Smtp-Source: ACHHUZ4Tv/X4BvtZaOoVdX1rYYZ3M/Pf7qEV4Y/SlABn2yEwTzvH0yeZtHofWpZuGzIlfclnmSo6GQ==
X-Received: by 2002:a17:902:da91:b0:1b0:3d54:358f with SMTP id j17-20020a170902da9100b001b03d54358fmr25386195plx.0.1687538891750;
        Fri, 23 Jun 2023 09:48:11 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id n4-20020a170903110400b001b55c0548dfsm7454411plh.97.2023.06.23.09.48.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jun 2023 09:48:10 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/8] io_uring/timeout: always set 'ctx' in io_cancel_data
Date:   Fri, 23 Jun 2023 10:47:58 -0600
Message-Id: <20230623164804.610910-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230623164804.610910-1-axboe@kernel.dk>
References: <20230623164804.610910-1-axboe@kernel.dk>
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

In preparation for using a generic handler to match requests for
cancelation purposes, ensure that ctx is set in io_cancel_data. The
timeout handlers don't check for this as it'll always match, but we'll
need it set going forward.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/timeout.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/io_uring/timeout.c b/io_uring/timeout.c
index fb0547b35dcd..4200099ad96e 100644
--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -409,7 +409,7 @@ static int io_timeout_update(struct io_ring_ctx *ctx, __u64 user_data,
 			     struct timespec64 *ts, enum hrtimer_mode mode)
 	__must_hold(&ctx->timeout_lock)
 {
-	struct io_cancel_data cd = { .data = user_data, };
+	struct io_cancel_data cd = { .ctx = ctx, .data = user_data, };
 	struct io_kiocb *req = io_timeout_extract(ctx, &cd);
 	struct io_timeout *timeout = io_kiocb_to_cmd(req, struct io_timeout);
 	struct io_timeout_data *data;
@@ -473,7 +473,7 @@ int io_timeout_remove(struct io_kiocb *req, unsigned int issue_flags)
 	int ret;
 
 	if (!(tr->flags & IORING_TIMEOUT_UPDATE)) {
-		struct io_cancel_data cd = { .data = tr->addr, };
+		struct io_cancel_data cd = { .ctx = ctx, .data = tr->addr, };
 
 		spin_lock(&ctx->completion_lock);
 		ret = io_timeout_cancel(ctx, &cd);
-- 
2.40.1

