Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D5D854B4A1
	for <lists+io-uring@lfdr.de>; Tue, 14 Jun 2022 17:30:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236270AbiFNP2K (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Jun 2022 11:28:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343589AbiFNP2F (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Jun 2022 11:28:05 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 588AF2BF6
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 08:28:04 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id h19so8546380wrc.12
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 08:28:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QxpWZiiH5RdjOdj680wieWG4TLUeONyb0CXmr8N2gnQ=;
        b=qOpv18m0A5PfPnqB6vuyHCDMbvESXW6hUvD3COYkOl0Go8kmU3q6qv+tJ1shejhQvv
         j8HR6vlA+QfhsN6mRBG1yiOcyq/MsqAWVRCE/LslFEEcIVez8evs4MN328V6n/9SYOoe
         sUyQ7JLQoVB7/gniFHyODZ34wOlo14ZG6j9yxN6Xs+vHthgB9fFBamTKHua8PRUD+yCA
         XNWvJwERJLwQFtMvN2hMaZ/YwSSadIsRm+mqyNWMo7T8guKGEVMmbFRU+Ep+2eNyZuFH
         WYk6ezCJnVWLTCMjfYhHpTendmi3pm5OdkEC2hIMrzSX9hhK5gg4HS4wr7RuzKqp9/z3
         IuYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QxpWZiiH5RdjOdj680wieWG4TLUeONyb0CXmr8N2gnQ=;
        b=z7VsZZkYywZEas9eP74W705LtXf+cu540qykU2SH0q+z5nMaiNMFpl/xdAm+su/yPi
         ANvIbT8XTx+q2isgTYySmyr5zH9B3tqv6QL3uaW57GuDg3hazBRghluPE6bkza5r46EN
         h8UQFYswodc+QcpDoSELaD5mWX42t+pk61J2Adnd5jHSx8qgBN45LYxScEtoRekzdEj7
         qqku0snL5iF7L7fu3grs32mKQQgxDHnxsSiDf3o56NKWY4VXZxZGvc92HScW9+uewTUJ
         6yvgQz51aRnuSlqhTU+TRYwC+YUlFFQekUSvV6Glm8ld1uJmuiO9Lo5h5uio5MdNS0jP
         yorg==
X-Gm-Message-State: AJIora+293Tycss73End+C8YUaHTFhA7BsY77cLVHyxcxva93RSA5sI5
        jMQ0mds/dKR764QntTVstLmNae8ZV1iM3w==
X-Google-Smtp-Source: AGRyM1sFjOI4IFTnBwhz7eMn0/7PVbg5KBZ3rKnhyy6DLFbGDI+b6be+MXwAZ42BhK6TznOFZro4Bw==
X-Received: by 2002:a5d:6790:0:b0:217:1567:d319 with SMTP id v16-20020a5d6790000000b002171567d319mr5672161wru.16.1655220482560;
        Tue, 14 Jun 2022 08:28:02 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id v22-20020a7bcb56000000b0039482d95ab7sm13313529wmj.24.2022.06.14.08.28.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 08:28:02 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing v2 0/3] single-issuer and poll benchmark
Date:   Tue, 14 Jun 2022 16:27:33 +0100
Message-Id: <cover.1655219150.git.asml.silence@gmail.com>
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

Add some tests to check the kernel enforcing single-issuer right, and
add a simple poll benchmark, might be useful if we do poll changes.

v2:
    remove copy-pasted test comments
    fix poll-bench 'argc' build problem

Pavel Begunkov (3):
  io_uring: update headers with IORING_SETUP_SINGLE_ISSUER
  examples: add a simple single-shot poll benchmark
  tests: test IORING_SETUP_SINGLE_ISSUER

 examples/Makefile               |   3 +-
 examples/poll-bench.c           | 101 +++++++++++++++++++
 src/include/liburing/io_uring.h |   5 +-
 test/Makefile                   |   1 +
 test/single-issuer.c            | 169 ++++++++++++++++++++++++++++++++
 5 files changed, 277 insertions(+), 2 deletions(-)
 create mode 100644 examples/poll-bench.c
 create mode 100644 test/single-issuer.c

-- 
2.36.1

