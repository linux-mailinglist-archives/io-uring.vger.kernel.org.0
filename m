Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D0CA5ADB1F
	for <lists+io-uring@lfdr.de>; Tue,  6 Sep 2022 00:08:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231331AbiIEWIS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 5 Sep 2022 18:08:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232525AbiIEWIR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 5 Sep 2022 18:08:17 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA5E15B04E
        for <io-uring@vger.kernel.org>; Mon,  5 Sep 2022 15:08:14 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id bd26-20020a05600c1f1a00b003a5e82a6474so6366745wmb.4
        for <io-uring@vger.kernel.org>; Mon, 05 Sep 2022 15:08:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=AKrZ1urcngCqlh4eeSJunnwPCrMDBRenolGBDYtEd20=;
        b=d93NuYUmP4wBknHanSaFrre0GEk7fq2okamL5PihkWE8KEjB1aiogd62sHaTH5XVbd
         mc/rH76UDBv06QtpYZ2/5T8qbKbZPYJlV9PZBUutBjq0nkO8VO8/Jv8y0YfgnLJelmoQ
         vJeB0eUuAu5GQP1XPykrgDVm783Z5JgoA9aU+itTlOPSFkkFjzgyb42CU+2oEaNi/E5B
         C1zYgmJaWGP+zNu2l3w5nw0ti9kzdAOvoOI+W1g29BJlqkssc/FjLggTJXrLHGX5PP2d
         MEJWxvboaKNFX/fM5A3ErzIbrxQC3gbP+9mHCN1JWFt3po2JqKt7HNqrm4PBCaYjWXJq
         CGyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=AKrZ1urcngCqlh4eeSJunnwPCrMDBRenolGBDYtEd20=;
        b=o399xLbSOdeA1asPKOHYttQs07GQZPKFpeHg9su4LmPiT9iTP7oq3IVHvRmefSTv7x
         HCWvDJi5Guu0wK7Emg6kNIL7fLQTt0d+ilfD3dvR/RYSTTmjEmXpUgsbJJGREfoYnw+g
         WDk5WQ4/QUCu786GRSDdcADBHLyMnAAtJ4uHgg3h8P/HbU/yoo8L78FkyKg9lJ7m0uTe
         qrrPzjzaDSkdbvEp/O/ziBHYnsV4WHLQHaT4itLN9IaSpyXxeDe6PV6vYlOBIhgfca/h
         9yruJ6tSjS6FwSXLdyGIYXwA+GQwH+HB8N08RRWSIuHQnyoPaBu2hSLjszE1IEsW8EDJ
         jnvA==
X-Gm-Message-State: ACgBeo2NsENGpQTeyuLkyjnHUJ+SKeWQxxzM0IqIwMdJyFSLeOMjezli
        f4KyQz9bQXB8HnIw6NDHBwyIC0M/K5E=
X-Google-Smtp-Source: AA6agR5KxGDaxuJWUfO6iN81dJpthifB3PpTTVR3+2a0uPCQPme4amSfUCCAHvExqessivDZXt5m7A==
X-Received: by 2002:a05:600c:3512:b0:3a5:e9d3:d418 with SMTP id h18-20020a05600c351200b003a5e9d3d418mr12098780wmq.0.1662415692915;
        Mon, 05 Sep 2022 15:08:12 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.126.24.threembb.co.uk. [188.28.126.24])
        by smtp.gmail.com with ESMTPSA id z7-20020a05600c0a0700b003a5c1e916c8sm33791067wmp.1.2022.09.05.15.08.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Sep 2022 15:08:12 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing v2 3/5] tests/zc: fix udp testing
Date:   Mon,  5 Sep 2022 23:06:00 +0100
Message-Id: <f85ddc0dd0712ce17a5e7f73639c55d9c612cedf.1662404421.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <cover.1662404421.git.asml.silence@gmail.com>
References: <cover.1662404421.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The tcp vs large_buf skip condition is not what we want and it skips udp
testing, fix it and also make sure we serialise cork requests with
IOSQE_IO_LINK as they might get executed OOO.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/send-zerocopy.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/test/send-zerocopy.c b/test/send-zerocopy.c
index f80a5cd..bfe4cf7 100644
--- a/test/send-zerocopy.c
+++ b/test/send-zerocopy.c
@@ -285,6 +285,8 @@ static int do_test_inet_send(struct io_uring *ring, int sock_client, int sock_se
 		}
 		if (force_async)
 			sqe->flags |= IOSQE_ASYNC;
+		if (cork && i != nr_reqs - 1)
+			sqe->flags |= IOSQE_IO_LINK;
 	}
 
 	sqe = io_uring_get_sqe(ring);
@@ -380,11 +382,9 @@ static int test_inet_send(struct io_uring *ring)
 			int buf_idx = aligned ? 0 : 1;
 			bool force_async = i & 128;
 
-			if (!tcp || !large_buf)
-				continue;
 			if (large_buf) {
 				buf_idx = 2;
-				if (!aligned || !tcp || small_send)
+				if (!aligned || !tcp || small_send || cork)
 					continue;
 			}
 			if (!buffers_iov[buf_idx].iov_base)
-- 
2.37.2

