Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0054157FCE9
	for <lists+io-uring@lfdr.de>; Mon, 25 Jul 2022 12:05:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234467AbiGYKFK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 25 Jul 2022 06:05:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234497AbiGYKFI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 Jul 2022 06:05:08 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE56717AAF
        for <io-uring@vger.kernel.org>; Mon, 25 Jul 2022 03:05:05 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id v5so6476407wmj.0
        for <io-uring@vger.kernel.org>; Mon, 25 Jul 2022 03:05:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eOaT3p8u2t3UfakztdJFNsorYbkvtWP9Cob0CNUdzXM=;
        b=NPM3gNXFPj/CeOda/4n/aaL2d/XdcSBASiyc7RBMYAxjRKQX8m/505ZQMWfkhBBIeU
         s7dt28Q5vpRK9G6kraOFuUVLdAkj/rbqr5ITr2v5yGBuDrVGernyk0cRnqjZx9jKVzHh
         ulEwRznoKQtoX3+Ag32OHVAt+SNmWgEiGrJZtRsMeKLgv29rT3dN74KeYGLNtiX8iV4g
         JgQAD09g8zGHzOuQ5VQuBfXSBE7kUqZcywZh0mNaYcs31Pl2Vl6DJ5D9hc9jCnZ7RoXP
         huuh3DSNPWA4//0ABjbwVaYWiUxIL2Rn/wms4kKSyuHUBgsN/Xm8lz+hwf7KvZfxq1OG
         PARQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eOaT3p8u2t3UfakztdJFNsorYbkvtWP9Cob0CNUdzXM=;
        b=rLdQ1IRQNKzUiGug/d+aDJj/y6S0fRDyGoHmA1uFMRL0nx8MHgxiCigO8VgnnwXz0E
         PRi5LW9gklVQnIQALqRMkiGek1tRu39MPCLxd5swxHaLSHQrczzriwoLisntnt6SHqXc
         GNmAValcbVEoWYLACSh1IE9hlkQEjlkOehBtZpzduMKaEnmQ71I1tfkkh9RJ2rzf8Cge
         tQBcXNDo6KLhwX0CZkndypGH16xf3v4PgKiUIcDzc8hDiiEwHPMBEqgb01ieAa7KHa3o
         LfuLRUYz7YCZrN1SgLA2kTPDVQ9AqtH2Xb9oagEIntptwFwtmYz0Qbgs1jG/gDNld4Rf
         qt8Q==
X-Gm-Message-State: AJIora++M4ZNJQ5qToaOeMIhx4cfomcfh1Su3Zm5e0TkMpqSOL4lFq0L
        Olftn+u39pRm86Zz6oftE+HefKpjmZ1kmQ==
X-Google-Smtp-Source: AGRyM1vg9dkDQQYeoCwc+NSRPHZlPeJOkw9a4VZofNNTLXAGbCsXm/m4K1fv21/dXrhoR0RMshLzRg==
X-Received: by 2002:a1c:7213:0:b0:3a3:155a:dd5d with SMTP id n19-20020a1c7213000000b003a3155add5dmr7612061wmc.178.1658743503660;
        Mon, 25 Jul 2022 03:05:03 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c093:600::1:9f35])
        by smtp.gmail.com with ESMTPSA id j23-20020a05600c1c1700b003a32251c3f9sm20553959wms.5.2022.07.25.03.05.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 03:05:03 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing 0/4] zerocopy send headers and tests
Date:   Mon, 25 Jul 2022 11:03:53 +0100
Message-Id: <cover.1658743360.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.0
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

Add zerocopy send headers, helpers and tests

Pavel Begunkov (4):
  io_uring.h: sync with kernel for zc send and notifiers
  liburing: add zc send and notif helpers
  tests: add tests for zerocopy send and notifications
  examples: add a zerocopy send example

 examples/Makefile               |   3 +-
 examples/send-zerocopy.c        | 366 +++++++++++++
 src/include/liburing.h          |  41 ++
 src/include/liburing/io_uring.h |  37 +-
 src/liburing.map                |   2 +
 src/register.c                  |  20 +
 test/Makefile                   |   1 +
 test/send-zcopy.c               | 879 ++++++++++++++++++++++++++++++++
 8 files changed, 1346 insertions(+), 3 deletions(-)
 create mode 100644 examples/send-zerocopy.c
 create mode 100644 test/send-zcopy.c

-- 
2.37.0

