Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6752C503131
	for <lists+io-uring@lfdr.de>; Sat, 16 Apr 2022 01:09:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344632AbiDOVLm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 15 Apr 2022 17:11:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235014AbiDOVLl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 15 Apr 2022 17:11:41 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 334B7C6EE7
        for <io-uring@vger.kernel.org>; Fri, 15 Apr 2022 14:09:12 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id g20so11074933edw.6
        for <io-uring@vger.kernel.org>; Fri, 15 Apr 2022 14:09:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EipeQy8Hnj5gbB/fW/OCGBOT9Th/SCH8SB5f7Ksbeig=;
        b=Lbq5RwpZY5X0GV9t19zCQVtaCXvEqEiX1VKMIfbbQOdhQ4S8Xjj6FUpPhYagNNHCxz
         1MX6wbOr1dElnZX5jKoSqYvX85+yze3xybmclf0ZnFal5xwq41luhHXo7NWwzuyL8bRU
         dp4Kb9dF5V6dvsCC1ljHBlzPd8YUqTJPIb8XIsCeZWAKprjYSLf/7h0po3GX7oPbrpZJ
         DH1nMbQ0Z6F2BO8EpRs2zdzbDBftbyoXDploL7hkttQ6RljeqO5yRIa/QumSC2PFZWO3
         r1GtlFtFqDN4BWLX8fpJKXSGCQc23kwTJ/65mzU14BwqY8zNggXPEx+LEji7UEvldd0h
         QKCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EipeQy8Hnj5gbB/fW/OCGBOT9Th/SCH8SB5f7Ksbeig=;
        b=zRIVjY5sFay0omm+YMMwZvc3izKB5ghfPeinb0FfiFDNzV6cel7pnoY2NvN+m0xGKM
         x2xVCOFMQvOzvZA1SJ7WKiXSDsQ24Nh8yj6qt4QiVAE9KvNKkwQZE6sWJt8lvH/8b+KS
         srfIc5NgeyEqwJZtQ6qqFHB8AlcV4Tj31pfWPS4n91+P3mHSwaS9U3dJ6GDaXOokE9Cy
         W1tyhto/qhXz0hMr8W96XLyW+5mBNxyDb1W8oH0L2e9124mBZrd+QVJU0WwV5ABgQPB/
         MZFp3qg4CqdAjpIn8hPIV/D/IQJg7/7OcIfXj4i+VdddIwhYvVf7z8+gROJKP72QmwyA
         3JBg==
X-Gm-Message-State: AOAM530clq8ccOAMxV/wlJjdM7j9aLUfDmfe9U5YRSE13n/Kd0jYgET4
        tbD2enrlgg5hvEdDeEYkfsaSBe2TTlE=
X-Google-Smtp-Source: ABdhPJywo/0bScV86Aep12iIw4Drw8fTO23xiM57/F/lATQIsVrj3ypY/FhAiBwWOdQGPh2d9u5Lsg==
X-Received: by 2002:aa7:cd87:0:b0:41d:90a8:2670 with SMTP id x7-20020aa7cd87000000b0041d90a82670mr1002619edv.404.1650056950405;
        Fri, 15 Apr 2022 14:09:10 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.133.118])
        by smtp.gmail.com with ESMTPSA id j10-20020aa7de8a000000b004215209b077sm2602938edv.37.2022.04.15.14.09.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 14:09:10 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 00/14] submission path refactoring
Date:   Fri, 15 Apr 2022 22:08:19 +0100
Message-Id: <cover.1650056133.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.35.2
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

Lots of cleanups, most of the patches improve the submission path.

Pavel Begunkov (14):
  io_uring: clean poll tw PF_EXITING handling
  io_uring: add a hepler for putting rsrc nodes
  io_uring: minor refactoring for some tw handlers
  io_uring: kill io_put_req_deferred()
  io_uring: inline io_free_req()
  io_uring: helper for prep+queuing linked timeouts
  io_uring: inline io_queue_sqe()
  io_uring: rename io_queue_async_work()
  io_uring: refactor io_queue_sqe()
  io_uring: introduce IO_REQ_LINK_FLAGS
  io_uring: refactor lazy link fail
  io_uring: refactor io_submit_sqe()
  io_uring: inline io_req_complete_fail_submit()
  io_uring: add data_race annotations

 fs/io_uring.c | 287 +++++++++++++++++++++++---------------------------
 1 file changed, 134 insertions(+), 153 deletions(-)

-- 
2.35.2

