Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D6154E3330
	for <lists+io-uring@lfdr.de>; Mon, 21 Mar 2022 23:56:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231326AbiCUW47 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 21 Mar 2022 18:56:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231465AbiCUW4A (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 21 Mar 2022 18:56:00 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D2DC52B0C
        for <io-uring@vger.kernel.org>; Mon, 21 Mar 2022 15:34:29 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id 17so6854786ljw.8
        for <io-uring@vger.kernel.org>; Mon, 21 Mar 2022 15:34:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4o6sPlaUO9jFgEhsfCukmlRkW2zU2S20pGpnW2WaHA4=;
        b=dU6RGYDLk7J1/jBI7FaXzR5JefJCplmvntpycVLGsycLIb0QRba5UkcatRICd66jXZ
         vyJYgOefSilw0zTpzNt2iBAA5ayx+qZFybzhyFYpY1WImgtu1D7EHDfFpfP5Lo5Q2Kh4
         VIYPX8m/NhMvgm8zEV4RMvNxutQCgIbzrGhL5ZC2nRRZR1uqxJa7rBT3cj96bDc5gZ6o
         v23rY0/pKTA+WAMGGBjAsBKrfVLQSZXjh9nRVoEFbvwwWg3lg1qvZDc4zdyjbkdbOwJr
         aqFLz4/8p03X19QX7HIS+qMZfFhNaD3sXOiQ2B98b0c40LLdb4c+VlVilkpZLVq+TF5Y
         RFdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4o6sPlaUO9jFgEhsfCukmlRkW2zU2S20pGpnW2WaHA4=;
        b=67PXL/1+Fxr9frVkDX3otM+K+aWdsptgIKSy0PGHZMgPzjjzynAfwaa0CudXjotop9
         eAqIqqiVjSt6uQUkXenY000SqJ0zQqlmOWLBufKNxGezmRsq9Hgs1D4tN2VrSbM/44G9
         pc95Uwl3oSGANEDk0EAxM/Ll+XWQ6O/aAuJzjwONirh0NREDtN3G4wOqp8vsEZ7JX+3r
         d1LJkARigPQYZ8cXXFYIybMivso6IU2+TSVLBtdKUbjZgPA8WL2B9oOhE9HXBOYM4LVG
         bSYRfm1+JDlfWgXbrqK1oed6IhJl2wmxmL/Qa6HJeel34F7csAgg5hzJoktroboRbtpV
         6k2Q==
X-Gm-Message-State: AOAM5324I/1dk65422GJVFdkws7+Ddxw4JGGvhhzvpjZyDSl25AzK2Su
        FtjQKgGzA3mv8oQc8wqzlPlu23CvvKd/uQ==
X-Google-Smtp-Source: ABdhPJz/NGAOoAJsljbDekgGhzV20hNex1d1n+xvY51iL/tPCzoKG25uX1q63LLp3KY4MkaW0uM78A==
X-Received: by 2002:a17:906:facf:b0:6cd:ed0e:ed7 with SMTP id lu15-20020a170906facf00b006cded0e0ed7mr22139744ejb.376.1647900236059;
        Mon, 21 Mar 2022 15:03:56 -0700 (PDT)
Received: from 127.0.0.1localhost ([85.105.239.232])
        by smtp.gmail.com with ESMTPSA id qb10-20020a1709077e8a00b006dfedd50ce3sm2779658ejc.143.2022.03.21.15.03.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Mar 2022 15:03:55 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 0/6] completion path optimisations
Date:   Mon, 21 Mar 2022 22:02:18 +0000
Message-Id: <cover.1647897811.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.35.1
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

Small optimisations and clean ups. 5/6 in particular removes some overhead
from io_free_batch_list(), which is hot enough to care about it.

Pavel Begunkov (6):
  io_uring: small optimisation of tctx_task_work
  io_uring: remove extra ifs around io_commit_cqring
  io_uring: refactor io_req_find_next
  io_uring: optimise io_free_batch_list
  io_uring: move poll recycling later in compl flushing
  io_uring: clean up io_queue_next()

 fs/io_uring.c | 64 +++++++++++++++++++++++++++------------------------
 1 file changed, 34 insertions(+), 30 deletions(-)

-- 
2.35.1

