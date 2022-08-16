Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF68B59562D
	for <lists+io-uring@lfdr.de>; Tue, 16 Aug 2022 11:27:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229619AbiHPJ1E (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 16 Aug 2022 05:27:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230190AbiHPJ0h (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 16 Aug 2022 05:26:37 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1DD81156D5
        for <io-uring@vger.kernel.org>; Tue, 16 Aug 2022 00:43:21 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id z2so12429773edc.1
        for <io-uring@vger.kernel.org>; Tue, 16 Aug 2022 00:43:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=yL9KMlGpdg9BXl91lHEuJpFKflSPibL4uaK39/OjXoE=;
        b=Sz2DM+g9nF6nCODCGwdG0fWeK/fJxipGp92/xU4o4tC8Ka9enWkyX0OcA9BfW5EMkC
         +IvlkcNZI5OGbg203hHL2vJe7fTrk9rLSLSjhT2Tvwk5TNynICpvpjAf5hS0mzvht5RM
         u4Cjsb/HTCVAbWZLA/EHjbhgeMY2VrlxI+neaUuLN1wYYvtzvcE4WER9xjwIyRnYhFa9
         9rjICwyEs4hFHP4KPHwIYxsbOg93mYyRggF/9YM5FHAaePUYWU3kb/YXsF7t+wS0/4WE
         edHLjAhRT4QPZOGriVvcZ4vmzucT9dRljKDZ22jf8z44ZFPvLieEGPywCPNItA4/EPpF
         U5Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=yL9KMlGpdg9BXl91lHEuJpFKflSPibL4uaK39/OjXoE=;
        b=mkKDaZdnAOfHyRbaU4EiSGEdBZKTmZAHRbgz4WFUy8p5q80uj5NnI+wWq5YgodSbHY
         XL1ycTFfcDoVeKli/UT1KdUTcFPZz/wrS6FbiVblqQPFPfQhsN5QpHCoMTc1J4oQbAN9
         dNM41EDSAk2KcS4+/ZTxqehnxny0YGy6rHBg77MOANwCPRhnR8J/NA/kClbHxIYotx5M
         3znJkjJGItioe2Aq+2K4ajiCG/AybEdmnm8AOPiCwePiGgX+5sJCge0OaCqNvP2VcF+b
         lrpBfVjYvJolmPDxbJ7vGrhDPjpFwcauHchm9hhn5hcR6fAtJeHzvrS/j9/7EJxv6xoA
         B46A==
X-Gm-Message-State: ACgBeo2EtjZg6YnavZZf4qjiMUdPlDnBRC2ob0KNBhcIJOURneeSfoK5
        xucJEz/ItXwGlKMpLYSXoiF8Dmq2wF8=
X-Google-Smtp-Source: AA6agR7F0F1tJQT99FaxL9zTfMAANVSzGJLuJODyW/bEo/FjYy+tOssqVcOHp3dXBBEe0Vw3TjnCYA==
X-Received: by 2002:aa7:c70d:0:b0:440:432a:5f9e with SMTP id i13-20020aa7c70d000000b00440432a5f9emr17243983edq.110.1660635800042;
        Tue, 16 Aug 2022 00:43:20 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.126.24.threembb.co.uk. [188.28.126.24])
        by smtp.gmail.com with ESMTPSA id e1-20020a1709062c0100b00730799724c3sm5057363ejh.149.2022.08.16.00.43.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 00:43:19 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com,
        Dylan Yudaken <dylany@fb.com>,
        Stefan Metzmacher <metze@samba.org>
Subject: [RFC 0/2] io_uring zc notification tag override
Date:   Tue, 16 Aug 2022 08:41:59 +0100
Message-Id: <cover.1660635140.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.0
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

Following up user feedback, we'd better to have a way to set a notification
tag on the fly comparing to statically at the registration time at it's
currently implemented. Add a feature to allow to copy send_sqe->user_data
into the notification it's flushing.

With 1/2 we can also add a cqe flag for when it fallback from zerocopy
to normal copy execution.

A git branch for convenience:
https://github.com/isilence/linux.git zc-override-tag

https://github.com/isilence/linux/tree/net/zc-override-tag

Pavel Begunkov (2):
  io_uring/notif: change notif CQE uapi format
  io_uring/net: allow to override notification tag

 include/uapi/linux/io_uring.h | 10 ++++++++++
 io_uring/net.c                |  6 +++++-
 io_uring/notif.c              |  4 ++--
 3 files changed, 17 insertions(+), 3 deletions(-)

-- 
2.37.0

