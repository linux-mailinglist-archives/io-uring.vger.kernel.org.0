Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D00F6A709B
	for <lists+io-uring@lfdr.de>; Wed,  1 Mar 2023 17:14:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229847AbjCAQN7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 1 Mar 2023 11:13:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbjCAQN5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 1 Mar 2023 11:13:57 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C41912BF21
        for <io-uring@vger.kernel.org>; Wed,  1 Mar 2023 08:13:56 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id q16so13827556wrw.2
        for <io-uring@vger.kernel.org>; Wed, 01 Mar 2023 08:13:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=b9tU+gjMq0hijVf/5NlnHgA3Vzpsvcb3bHjRYrKXgHA=;
        b=Ri7sE9b/r9sSi1IuoehxXtvraY1sIQZzC0MyICICGGgSwUSKp0xa6J7Rh3UcYfEXMY
         XN0wraiQT5LpVksBY7b7Qb3NSkOfnrBE4RynXXt1Qz66mWxRLptg0Ou7PoMoM2amExc5
         yY5hthP9zSIqThM1510SEB/UT9l2+4w3xD0kIIl3uy+pgkdoWcjhJlvKON/0WIKMVSwh
         Mj8cA0a0mKInkP/61awVQNsUJ7T6Om4NdWRnV/Tgg+uJQw3pJK5nnSU/3xf0Bx1VwbR6
         /dV/IxOJJJMD4gN0FrTNNegbEOTvxrmjY/V6UQ+SSkHNS5zHB+P314BwIVrXF4jO2NFb
         View==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=b9tU+gjMq0hijVf/5NlnHgA3Vzpsvcb3bHjRYrKXgHA=;
        b=r63UgmagbFSes7kkSLOENrzUyefc/edZmOlt9SZIk5aMobiV5gwOKj7kfk974U+0iz
         /SZ+TYO9/qN36TIZRs+PAdnQaWDuDjfOLR2718MZfHAGeV8/JWS1jPYpKIY2ILyRYuc8
         6C4Rt9n0jjsf98s5QpBUiPNJDKalTupO68uxsnl5Tfx0mLKElVHdP9FkpCUFwi9FWq8G
         DrlHY5a82qgQYR6puZ/N8HOyY7TereUljbZTAbXs5Bz72ZnbZUVRq7jyWybLNhfzUGYq
         rrtMjnxCwDzIr+2VYIPYa/roeyMDR9I9JHEKLGVwcsksqI+9/LmM80BbzLbpd5dWTiv4
         paLQ==
X-Gm-Message-State: AO0yUKVDhhoEVmJPejxE/7ezY8w9oC6vBvCavG9shEUwaRVuvnTIFuRk
        pbV3cIReN12mt2hG3Nw6aLy1SDIYYlY=
X-Google-Smtp-Source: AK7set8FTj7GUNMc180VTdQ/5ZuGiC84Og9w/J3NRs1wDb59Awp1vY8KFg2pVjaiMzyfvPeNV1ln3g==
X-Received: by 2002:a5d:4205:0:b0:2c5:5bbe:efc5 with SMTP id n5-20020a5d4205000000b002c55bbeefc5mr5630855wrq.5.1677687234838;
        Wed, 01 Mar 2023 08:13:54 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::2:94bb])
        by smtp.gmail.com with ESMTPSA id s2-20020adfeb02000000b002cda9aa1dc1sm2701474wrn.111.2023.03.01.08.13.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Mar 2023 08:13:54 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing 0/3] sendzc test improvements
Date:   Wed,  1 Mar 2023 16:10:09 +0000
Message-Id: <cover.1677686850.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.39.1
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

Add affinity, multithreading and the server

Pavel Begunkov (3):
  examples/send-zc: add affinity / CPU pinning
  examples/send-zc: add multithreading
  examples/send-zc: add the receive part

 examples/Makefile        |   3 +
 examples/send-zerocopy.c | 277 ++++++++++++++++++++++++++++++++++-----
 2 files changed, 249 insertions(+), 31 deletions(-)

-- 
2.39.1

