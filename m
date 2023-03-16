Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66D826BD06A
	for <lists+io-uring@lfdr.de>; Thu, 16 Mar 2023 14:10:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229802AbjCPNKo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Mar 2023 09:10:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbjCPNKn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Mar 2023 09:10:43 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9424BDD3B
        for <io-uring@vger.kernel.org>; Thu, 16 Mar 2023 06:10:41 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id eg48so7314714edb.13
        for <io-uring@vger.kernel.org>; Thu, 16 Mar 2023 06:10:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678972240;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=WPMLf8a+zBTJRKuH1Yp9ZHv1RzL/oFygII4L/7vCnQo=;
        b=jSSm3wF9wVLyaD6wY96x34RHV6B8u3xpsX17zj59DanO+cOLO1fyBfaXxq0k834MLB
         TyyGPJKdsdkg1aHiObREW08SylIlPCVDuPa5vWbtUhsa7/W1UPC/Ae4bwTNFtGVn71s3
         BItQzJ5GNCAEQEYqL99SMFv45IhwM0GYHfJ69XMnIV9zbTZcEweiwT6jApsVVUXHNrrl
         og0qxtBCAxCCI49LeMmk3zqv3O2vo4IjAkIlakOaLJ+9UkXYrluJr1lXOuscA6yQBB7R
         08amiccnVM3PcEcS4LLpnZ6XDfC440s1NBSfmfMXnqM7jv6AzCNVmDO0i24YutSemZWq
         rDNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678972240;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WPMLf8a+zBTJRKuH1Yp9ZHv1RzL/oFygII4L/7vCnQo=;
        b=gcQt4i+66n6ypEswRzFwiDPR///YNRxS3pHkxGEpZtjAfjmds+1CzTugGQIY3bh75M
         tk7yuWV1EZTdnmkKwEVhSPfP1sn5Pfppmj4FlBEBHuQEeMgkg44NM+tXGWJI+gOfKP6k
         WZYKCEGxfJL7LtCEBgmw8U/uqO72xCBiDqQanXk79z6WAr1UESL+mU7f+aYbrBbtVoz0
         4vHBRAyuqEXsELxfRrlr6LYa+8G2PITkRLGRjWIjVwZegRNT/d7U5N3PCk5U2fCoG8g9
         7LMnDuMdgzn0tKQjCxE9UHE4LuXV8bFZR5nLTrcihGQr0cECXr0h46mwWys8dG/7lgO0
         z4nA==
X-Gm-Message-State: AO0yUKV13VC9zhbjRGYhrAjm7a+AccjiOq+RTwK/ey2PDM5U6TVkPzlL
        W6G66okWYcfw8QVgQIYUdroFMSgVlrU=
X-Google-Smtp-Source: AK7set861YIVLSMGi1yl+QHJ4M2Kejg0lDztN91YA5rbLAWTcmhgDXa7Qf6l8iMwOQdsoe+u01T41g==
X-Received: by 2002:a17:907:9494:b0:92e:efa:b9b4 with SMTP id dm20-20020a170907949400b0092e0efab9b4mr12435067ejc.22.1678972239957;
        Thu, 16 Mar 2023 06:10:39 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::2:7abd])
        by smtp.gmail.com with ESMTPSA id n18-20020a170906701200b00927f6c799e6sm3814967ejj.132.2023.03.16.06.10.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 06:10:39 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing for-next 0/2] fd msg-ring slot allocation tests
Date:   Thu, 16 Mar 2023 13:09:19 +0000
Message-Id: <cover.1678968783.git.asml.silence@gmail.com>
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

Add a helper for fd msg-ring passing a file and auto allocating the
target index, and test it.

Pavel Begunkov (2):
  Add io_uring_prep_msg_ring_fd_alloc() helper
  test: test fd msg-ring allocating indexes

 src/include/liburing.h |  9 +++++++++
 test/fd-pass.c         | 37 ++++++++++++++++++++++++++++++++++---
 2 files changed, 43 insertions(+), 3 deletions(-)

-- 
2.39.1

