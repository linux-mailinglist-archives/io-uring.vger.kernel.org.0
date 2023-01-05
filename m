Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92DB665E9B5
	for <lists+io-uring@lfdr.de>; Thu,  5 Jan 2023 12:23:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232319AbjAELXk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 5 Jan 2023 06:23:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233114AbjAELXc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 5 Jan 2023 06:23:32 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46CAE559CF
        for <io-uring@vger.kernel.org>; Thu,  5 Jan 2023 03:23:30 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id g25-20020a7bc4d9000000b003d97c8d4941so1053497wmk.4
        for <io-uring@vger.kernel.org>; Thu, 05 Jan 2023 03:23:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=RnLeKlrGDU56Ei5ffb3SVEyPQtQDN3I3l1VVzmAdBIM=;
        b=j89qbQS1IAXOeeOxYmQ5PbOjVHweMoV9rwSwFZXtrayJa7oMhMB0MYD3N+AIvUJW9a
         JYg35xOUOni+uz/spJBHSRRbM9Z9z+SNa0JKB5c7zau6Vj4A42jjznELS+DXxJKh9WB5
         lpmI2P9WKfyH83cQ1Jlg7yYv3RywWCV5pONN8M06+hvcstWXjqZA9ctjzkM0D1DXmndf
         iOP7oJaSB3xWmTSJEbNYh2HgraqyJTV0bg3DUq8p5n0Pck2XkAKaTlg08WLESlSXIzIn
         0QlSE0OdPLMFjZ/ItiUfR4W5mHvG46KPhE59DTDS5dQhIWHvvHt0Hg07kEEgBzlyiZ3c
         g4KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RnLeKlrGDU56Ei5ffb3SVEyPQtQDN3I3l1VVzmAdBIM=;
        b=6VQzpNyxQKKDr0hgwqq7/gxx+NBrxa7D4f9gaipDAD39NYmPuWNJVZjb7vANo5Ngxr
         eAFIRK13z+mBo6t3l2e4o8okUTYl0YwqnWGHnzuPN0p1gQWKmUF4e9JdsZQLGaa4hhMA
         SzJzc+G4Nq6pnH4sHXtvloa2e6OVURXG2qwCRoEGjgHr/lXrYoj0iSaoYUPRorbclVr+
         o3qoPN5a/mRjNIEzKKnMoOqdxBYoKj1mJxjMbxuTTDZcaIVwxgCXBXMGsDhkAO5SzsKt
         8ikGZhemIDORabCFz0XIoPbeJdPAkaSrpxkSkDnrU+eThPzUvja3kw6jxPBHgd57GJJc
         PYRg==
X-Gm-Message-State: AFqh2kqlZItMFfqJgOuctUkKhsDT2RF6s3PS37wTpTg5s9liygR4gBm2
        wYYUHl4bZisjz4WPcMKnYeddZJ1UgRc=
X-Google-Smtp-Source: AMrXdXtE+12YcXDG662vGmblRFk8Y0355hORG4VohL91PB/feCB6u5PnewDI02lK7AE3izqce+4UZQ==
X-Received: by 2002:a05:600c:1d89:b0:3d3:58cb:f6a6 with SMTP id p9-20020a05600c1d8900b003d358cbf6a6mr35850532wms.41.1672917808597;
        Thu, 05 Jan 2023 03:23:28 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::2:5c5f])
        by smtp.gmail.com with ESMTPSA id u13-20020a05600c19cd00b003c6f1732f65sm2220688wmq.38.2023.01.05.03.23.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jan 2023 03:23:28 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCHSET REBASE 00/10] cq wait refactoring rebase
Date:   Thu,  5 Jan 2023 11:22:19 +0000
Message-Id: <cover.1672916894.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
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

Rebase of 6.3, i.e. recent CQ waiting refactoring series on top of
just sent 6.2 patch ("io_uring: fix CQ waiting timeout handling").

Apart from that there are 2 more patches on top, 9/10 squeezes
an extra 1% of perf for one of my tests.

Pavel Begunkov (10):
  io_uring: rearrange defer list checks
  io_uring: don't iterate cq wait fast path
  io_uring: kill io_run_task_work_ctx
  io_uring: move defer tw task checks
  io_uring: parse check_cq out of wq waiting
  io_uring: mimimise io_cqring_wait_schedule
  io_uring: simplify io_has_work
  io_uring: set TASK_RUNNING right after schedule
  io_uring: optimise non-timeout waiting
  io_uring: keep timeout in io_wait_queue

 io_uring/io_uring.c | 137 +++++++++++++++++++++++---------------------
 io_uring/io_uring.h |  25 ++------
 2 files changed, 77 insertions(+), 85 deletions(-)

-- 
2.38.1

