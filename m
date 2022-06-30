Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E401561DDA
	for <lists+io-uring@lfdr.de>; Thu, 30 Jun 2022 16:28:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235450AbiF3O1t (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Jun 2022 10:27:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237184AbiF3O12 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Jun 2022 10:27:28 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7305B7BD1D
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 07:10:56 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id s1so27493524wra.9
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 07:10:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TmpCTVvj8NE8cu1FzuCWFNpspE7so1s0yYDE3phm0v8=;
        b=ocZrRpT3n/cYB9AJALzyLpHcGmJj5qZI6e7D59kGr3xWZMaOgvOpNUl5g+6oGb8tEC
         /pERVSo0WdWffDSoyLwLjDg1sHBT82WnDy1YXUoD1xH/toVzJKPQ5OiWNIHBYzCPkRJd
         bwMjpqctqOOFO6OTh2FvHTvk2Xnq1XDocfzbzL94F+cL6aiAVM2F62jRXB+5adFtjcYb
         RvDsvWQzbyJaXEQjvcuyORtr1r1S1qioBDRVdJVYPuk9qeVWboivsgqIFgzbpIvcA2ch
         zXCyEBZn9zsk9kIw/0hyREb5YFijdsKiyfGkDfEvOC7ebowBh19gKR/Nv6255Gbfj9wh
         U7Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TmpCTVvj8NE8cu1FzuCWFNpspE7so1s0yYDE3phm0v8=;
        b=HCVHg1sAbov8xdiR878PMjQRO1r8VvQAQfetZxKOHMuzZx5SxDKLQ1w2NIjGvZn2sr
         UnV85lTplWQqDhvHCvtRK1JzJ7JfBmbBUr7rw0XXCGqowi0s3sYeFDHzpgmQTnUZpLlG
         4JtK1/PrOjRCteKhOB7IXyhjEbd8j1G2qikKYXSf6Eh9yNxmufD6BAtzWbOAGkRYKTy0
         1aHHzCGXy1H9smshQMEgy7JQ6S3lhooZUkSiHlWT5lu3peA0Tjw8RPdOzUDXVzdqw746
         gEvlofsk+wz1TytF1d6OwrS/e7mYW4zpNCQKZMJ6bpIlj2UQ3uLhzv8D0JgbWzXgN4YJ
         0Rgw==
X-Gm-Message-State: AJIora/gGeffw+85WWNydvRVsRZ4cq9boFg3GpPW1zp8Z+hAM1KxsmHY
        WYQZmF1O+/58AErasUWaJo16jNuaCa7A2g==
X-Google-Smtp-Source: AGRyM1tF9DVbZkVXq4Lk9eG6LSG2hYfHG+vQg3/ZC8BVdL8CdRzWTigbGXI6nxh5IL9+k+RrameczA==
X-Received: by 2002:adf:e491:0:b0:213:ba6b:b017 with SMTP id i17-20020adfe491000000b00213ba6bb017mr8765599wrm.652.1656598236114;
        Thu, 30 Jun 2022 07:10:36 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-232-9.dab.02.net. [82.132.232.9])
        by smtp.gmail.com with ESMTPSA id ay29-20020a05600c1e1d00b003a03be171b1sm3741392wmb.43.2022.06.30.07.10.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jun 2022 07:10:35 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing v2 0/5] ranged file slot alloc
Date:   Thu, 30 Jun 2022 15:10:12 +0100
Message-Id: <cover.1656597976.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
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

Add helpers and test ranged file slot allocation feature

Pavel Begunkov (5):
  update io_uring.h with file slot alloc ranges
  alloc range helpers
  file-register: fix return codes
  tests: print file-register errors to stderr
  test range file alloc

 src/include/liburing.h          |   3 +
 src/include/liburing/io_uring.h |  10 ++
 src/liburing.map                |   1 +
 src/register.c                  |  14 ++
 test/file-register.c            | 235 +++++++++++++++++++++++++++-----
 5 files changed, 231 insertions(+), 32 deletions(-)

-- 
2.36.1

