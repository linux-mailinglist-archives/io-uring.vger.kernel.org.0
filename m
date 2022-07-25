Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9E6357FE6A
	for <lists+io-uring@lfdr.de>; Mon, 25 Jul 2022 13:34:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234608AbiGYLeg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 25 Jul 2022 07:34:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230246AbiGYLeg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 Jul 2022 07:34:36 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 418D418B3F
        for <io-uring@vger.kernel.org>; Mon, 25 Jul 2022 04:34:35 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id g2so7476399wru.3
        for <io-uring@vger.kernel.org>; Mon, 25 Jul 2022 04:34:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yxu4107jmTsoo7q3bVLPhe9zrE/aRhyRcRQfpGqOJMg=;
        b=GwUdiNSEvdJjGYB7ziVE2wXdXUGhMEmWbp4qZVVZRZ9H6socNF0bmULdFMAEwuxVbg
         SMk3ve+CNteBLcaCZM+jt3iL59ol06qF+nuZMkBP6SYNiaM8jzYwPr8y3z/dqafooyVQ
         tYvfXuyJgLFvqbEmOHuk75MK0n6Fkgqp8sYVF5d3Xnw3+BphrIyonQzzXS23k1FOROVF
         +VeZDY+4h5X3xMTztKYkKutTfs9spSVZcaEwoqe5hDbXtqr1lw5QGrFmMTZPe72POaPA
         lD1fQF6T4TF/3M7LRphK5hp2swiStD6WRPccTUkqQcDk9hOV8ss6RtgGNRWhm3P8lITh
         QCRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yxu4107jmTsoo7q3bVLPhe9zrE/aRhyRcRQfpGqOJMg=;
        b=QRTKn7tW83Z7lq69VFcGNc2lSpoa5mmSaFeJiiXHqjBMHmT2XKqsgcP+BYMdVGF+pB
         /36CwMmibVKYznIuflAYAVH0CLMx9LvjSXZYxnp4D1HEjhBAF2dg3+oB6n66p5gocBwU
         QcjP9DJzhfaTOnxQsQnh3R0A0e1xm+qdvV4bDgXCHhICZdTucX0VnYXIPPL888NubMo/
         LdBx7I+9mxz1Mtp412ZPWGapesxYSN9qv8dAxzlDnMzVXQH6yFFOZ7bi80qPk5L9Hsc9
         xxouLFMnOcal0eRzxBKI9NeBxh0RTh4Hieg0Nb/webzhQ92jlFRgkFuo1+txfesoswHX
         D9SA==
X-Gm-Message-State: AJIora/AzvoqYStAKA20Q1gaE//XXMYj9JY08pguwAYY9x+l6XEIppon
        X8VJS4KUsWPpe1MCm/Zu8+stMeabYuGRFA==
X-Google-Smtp-Source: AGRyM1tV3fFyLyZuSAMt8B7EGTP9Npvkt7tLwvxUFmQQ6mj7rnB1ETxDYodOBUsY2TS6hI3T5/MZ7Q==
X-Received: by 2002:a5d:50c4:0:b0:21e:8776:bb95 with SMTP id f4-20020a5d50c4000000b0021e8776bb95mr3365825wrt.461.1658748873397;
        Mon, 25 Jul 2022 04:34:33 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c093:600::1:9f35])
        by smtp.gmail.com with ESMTPSA id e29-20020a5d595d000000b0021e501519d3sm11659991wri.67.2022.07.25.04.34.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 04:34:32 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com,
        Ammar Faizi <ammarfaizi2@gnuweeb.org>
Subject: [PATCH liburing v2 0/5] zerocopy send headers and tests
Date:   Mon, 25 Jul 2022 12:33:17 +0100
Message-Id: <cover.1658748623.git.asml.silence@gmail.com>
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

v2:
	use T_EXIT_*
	fix ptr <-> int conversions for 32 bits arches
	slight renaming
	get rid of error() in the test
	add patch 5/5

Pavel Begunkov (5):
  io_uring.h: sync with kernel for zc send and notifiers
  liburing: add zc send and notif helpers
  tests: add tests for zerocopy send and notifications
  examples: add a zerocopy send example
  liburing: improve fallocate typecasting

 examples/Makefile               |   3 +-
 examples/send-zerocopy.c        | 366 +++++++++++++
 src/include/liburing.h          |  47 +-
 src/include/liburing/io_uring.h |  37 +-
 src/liburing.map                |   2 +
 src/register.c                  |  20 +
 test/Makefile                   |   1 +
 test/send-zerocopy.c            | 888 ++++++++++++++++++++++++++++++++
 8 files changed, 1358 insertions(+), 6 deletions(-)
 create mode 100644 examples/send-zerocopy.c
 create mode 100644 test/send-zerocopy.c

-- 
2.37.0

