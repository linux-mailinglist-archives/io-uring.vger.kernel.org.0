Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 061496003D8
	for <lists+io-uring@lfdr.de>; Mon, 17 Oct 2022 00:09:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229562AbiJPWJz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 16 Oct 2022 18:09:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229670AbiJPWJy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 16 Oct 2022 18:09:54 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07AF81B7BB
        for <io-uring@vger.kernel.org>; Sun, 16 Oct 2022 15:09:53 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id e18so13601485edj.3
        for <io-uring@vger.kernel.org>; Sun, 16 Oct 2022 15:09:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=AgbW6Doc8boTRQALD5ED+CMJ4H08iThDApHNmiIxAeI=;
        b=Nnj2Usco1eU370ZeGQx1YVYaVpPxpiRZpZQAharo4Xb7uSNTXnOLes+5yUqJzd6qFs
         EyOp6DckTkywVXOoJ1amTfDD08Qf6usqCcORg2zKCdlfbajJVPXZqcx8kc45quOr3VD2
         w806/3X8q8DPD1c1wiRHKEm52X4AzHwXC5r8SnAGUf4hyMqHIn1mdqcyG7I0ZNzWGGXz
         P2P+6DafNGxZu9ZkjpfdZBcR+Q+UKJ3kCjkfp3B8xjiqXqkByyz5d/xte9r0QerJVX84
         6KatoTAEJU/13VawMLG2Ngbfp4f0H6SJenAKqs1590Ajt1peV9Abk5qLz1koZNPLb+l4
         i42A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AgbW6Doc8boTRQALD5ED+CMJ4H08iThDApHNmiIxAeI=;
        b=WwuZDNt6Pdib8QxSkV292Qi8EEQrg6zOhin/jwda6IqDqf28wmWLHq5/ke8v93Fk2q
         Y86r1mHc2rt/vEoeNrlOMXZk+vRhQeNUtcPsyTBnsp1OcNA/TvvVC0eTM2HdYwsF8gll
         vFQEi9dgDLmRAfrvI4uObXKXb5mRe6wF9ap/nmMqoLMTivIWKGE3lynUyGhE+alaITC8
         fqsqV+vNxQw1S3H10OZb9s6lR/aqaQKOZEMR8/zaDYzHdn+9d/7nlCgKjNnESzLoOO2f
         zgT/xE0laE+iL5hZYYdLsTQUugqysT20PoF9q6tk6FmIzLu2e1nenrli2RHTMXVzmsyE
         5jhg==
X-Gm-Message-State: ACrzQf0Mv9Ch56rQU/fn/se7DvvrGGNwNXoiKVGgibdj+J1FU/LFzwyf
        GWxedX/KQdAG6E3X9ldswMx9GjB+qSM=
X-Google-Smtp-Source: AMsMyM57hGykVplU5CTYwRWwjE33o6eKQ/NfctRh+Orl2k8D2yBrXGO469hieFQ4ApYeAoyxAXpW5g==
X-Received: by 2002:a05:6402:2751:b0:443:d90a:43d4 with SMTP id z17-20020a056402275100b00443d90a43d4mr7727186edd.368.1665958191317;
        Sun, 16 Oct 2022 15:09:51 -0700 (PDT)
Received: from 127.0.0.1localhost (94.196.234.149.threembb.co.uk. [94.196.234.149])
        by smtp.gmail.com with ESMTPSA id r11-20020a170906704b00b0073d9630cbafsm5161496ejj.126.2022.10.16.15.09.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Oct 2022 15:09:50 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing 1/1] tests: fix zc support checks
Date:   Sun, 16 Oct 2022 23:07:35 +0100
Message-Id: <0c8bf4d5dd7135c990f4fa9232a54c8cd6cc024f.1665958020.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.0
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

We should be checking cqe->res for -EINVAL to figure out whether we
support zerocopy or not. It makes the test fail with older kernels.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/send-zerocopy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/test/send-zerocopy.c b/test/send-zerocopy.c
index 31d66e3..c6279bc 100644
--- a/test/send-zerocopy.c
+++ b/test/send-zerocopy.c
@@ -91,7 +91,7 @@ static int test_basic_send(struct io_uring *ring, int sock_tx, int sock_rx)
 	ret = io_uring_wait_cqe(ring, &cqe);
 	assert(!ret);
 	assert(cqe->user_data == 1);
-	if (ret == -EINVAL) {
+	if (cqe->res == -EINVAL) {
 		assert(!(cqe->flags & IORING_CQE_F_MORE));
 		return T_EXIT_SKIP;
 	}
-- 
2.38.0

