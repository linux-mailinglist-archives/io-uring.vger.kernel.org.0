Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D6675EC7BD
	for <lists+io-uring@lfdr.de>; Tue, 27 Sep 2022 17:30:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229572AbiI0PaX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 27 Sep 2022 11:30:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231864AbiI0PaW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 27 Sep 2022 11:30:22 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1674188BDB
        for <io-uring@vger.kernel.org>; Tue, 27 Sep 2022 08:30:21 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id z6so15602784wrq.1
        for <io-uring@vger.kernel.org>; Tue, 27 Sep 2022 08:30:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=c7v4TVohXs7SBEdvopvYP8okUEpIiIFuSN3/lEizWB4=;
        b=NsRfdmOmk6ycbtTHEXmUXIEy4K/9uV4WZPjz0vrM7OJhYP61uw0ZrQATdNQCbVvI11
         6v/ICC7RAvjsu3CoxStTi2C71c8JQs627AhGJh9/dNd7/6FKcuMsKrDmBzTAtJuyGMlv
         9wirVgmhL0t0qXZM8P9xki+cRtxF7eAP/VjlgGDV5nzhFO6FTZtZiO9ledoLLD62fQWa
         7/bZVKpydG6Q8rb8Sc35BSuDsKgHo+Hes+fxgtDgfIq02DRktZprp1hJnV5qSTEmqP/W
         6ikb96XCPK3zlAoXLleF+o+TffZsCGT5QdZfCLvwrlSE08JFlSNmMZV+/D5wKhdJUOkb
         ODkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=c7v4TVohXs7SBEdvopvYP8okUEpIiIFuSN3/lEizWB4=;
        b=LjGP14b06o47k+ijxs9Cu6kb9XfkxqxMdkV2UPgk50WXdCwbFTDdICrNLm5alu46A3
         8qHzU/bFDGu7dZrUOLlg19FAaGk/vAAVAWUYuRGXtnS5OSN4F3oYanJRenYJx2vbYyRd
         T5SclDM8ktnX1XjQw9G+4JGOljazGW1UXXQVd2u9mqOFeXSwZZJVgqCoNfZS6TqzqjTH
         g+aLfgtG5dvwB0bQ+gBxKan4/hVL/Yvt3Lqv3xhhErTckPhBUzui9CA1GA/Up5CF4EWW
         WYlaB+ueeRP+zyrFaZa+g2DRM37AYXkml6cuwo/wcoOEXTnEP0NQns7nQmBJY/yS1mrH
         TMEA==
X-Gm-Message-State: ACrzQf2ugn8/++ZybKcdthmWvy2IP9834MIgtIawa2ixHQZScBLSdThA
        4VCUtT9/XC7Q01AkzDQe+ja7Q3Z7s7g=
X-Google-Smtp-Source: AMsMyM65NBeqwqppgrodSrluJcEkv0dhXhyP5FJOYFp1L8fDF3B59G+xJq83JOabmPzs8bxXpjeKNg==
X-Received: by 2002:a5d:6088:0:b0:228:e0c5:da5f with SMTP id w8-20020a5d6088000000b00228e0c5da5fmr16641214wrt.221.1664292619663;
        Tue, 27 Sep 2022 08:30:19 -0700 (PDT)
Received: from 127.0.0.1localhost (94.196.228.157.threembb.co.uk. [94.196.228.157])
        by smtp.gmail.com with ESMTPSA id j27-20020a05600c1c1b00b003b332a7bf15sm15314705wms.7.2022.09.27.08.30.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Sep 2022 08:30:19 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing 1/1] tests: a small fix for zc tests
Date:   Tue, 27 Sep 2022 16:28:59 +0100
Message-Id: <4794c23f60a3a0f4c5f6e83af4598eca47dda68a.1664292508.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.2
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

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/send-zerocopy.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/test/send-zerocopy.c b/test/send-zerocopy.c
index 1c4e5f2..88578e0 100644
--- a/test/send-zerocopy.c
+++ b/test/send-zerocopy.c
@@ -141,9 +141,7 @@ static int test_send_faults(struct io_uring *ring, int sock_tx, int sock_rx)
 		assert(!ret);
 		assert(cqe->user_data <= 2);
 
-		if (cqe->flags & IORING_CQE_F_NOTIF) {
-			assert(ret > 0);
-		} else {
+		if (!(cqe->flags & IORING_CQE_F_NOTIF)) {
 			assert(cqe->res == -EFAULT);
 			if (cqe->flags & IORING_CQE_F_MORE)
 				nr_cqes++;
-- 
2.37.2

