Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 271EF2DE327
	for <lists+io-uring@lfdr.de>; Fri, 18 Dec 2020 14:17:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726212AbgLRNQl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 18 Dec 2020 08:16:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725885AbgLRNQl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 18 Dec 2020 08:16:41 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8F02C0617A7
        for <io-uring@vger.kernel.org>; Fri, 18 Dec 2020 05:16:00 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id w5so2082872wrm.11
        for <io-uring@vger.kernel.org>; Fri, 18 Dec 2020 05:16:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ltAQpk04NVCNQn+ihwqXy5GvQIUKeiX0tH71s2ni/GU=;
        b=eE4Sv2AfmVYOjN6RBoq5lJlnmYd6+SGdlOgtk2MkuSsUgT81bEE451FN0dASUXIjvc
         zGdUqyPgWwDZ7/n2eY9Fg8THFhltM7a1kTVx1HE5tFCqsozpgfvpt7HHH9FLH9cMUbZm
         /8R11fUrFynA2ZT/SsASDrwYt+8cV/C3RK9cJFsrkxJfjSrYsRgtEsp8k0CaQDkVRJgp
         OzArkNdt3GqBk79wXQm9E1MkYNOxKlExrCcHImPbo5cSUvKxNAxrHuND9Dq3aP1PUj6c
         gNCodO54/7TJpbABDBPqghvFpcvQz4ChIDKMHkCKUHulV6bdPWL3gBYshYcW3OvJf6uK
         4efw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ltAQpk04NVCNQn+ihwqXy5GvQIUKeiX0tH71s2ni/GU=;
        b=PMf3NlKmGZuqXuWMtxVzDGYenqBeo3rbzRd6wcA2GeDtvo0jlKEyRLc0VEzSZH6RM5
         r+p5ZBF/35P6imEi/fb5ZDW6COSgJw5MpGlmxxwwLr3ZqnNIWJeS+/DucSeywjuWhlE2
         l/RlVBeleXgm2P3N87lF/ZMGdZYTXOM123zD1wk30+qDzBpGqeMVfGLHMbKtLntLaZXU
         yXpKsJeMndzU5ozWeVq3DaTee1L++7i2jz7XqumpLbhuQTp4qleQPY9jRc8Gh6mcbEkh
         nJdU6J3oDSgOlwqjx4/jRMCLtWFZwCmWbzL/T8gKLvKFtIfK3IItD0GxF9S8c/8qXTlc
         ZiCQ==
X-Gm-Message-State: AOAM530JcJNRJGMYk0sS6ZfMmXxXFsWPZK8CuA5vYuwbrz1hEkAeILc+
        J9TkXLXcSuUgfgib+FugJab60yflJJ2UQw==
X-Google-Smtp-Source: ABdhPJzWioez2Xkkfx0C4SU9oN2bh6Nd9qc/YoQmrCBCIIVLtPP4D4WcHqw5Ls2EwqqrwZGG85Cz/A==
X-Received: by 2002:a5d:6789:: with SMTP id v9mr4423986wru.86.1608297359357;
        Fri, 18 Dec 2020 05:15:59 -0800 (PST)
Received: from localhost.localdomain ([85.255.234.120])
        by smtp.gmail.com with ESMTPSA id b9sm12778595wmd.32.2020.12.18.05.15.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Dec 2020 05:15:58 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 0/8] a fix + cancellation unification
Date:   Fri, 18 Dec 2020 13:12:20 +0000
Message-Id: <cover.1608296656.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

I suggest for 1/8 to go for current, and the rest are for next.
Patches 2-8 finally unify how we do task and files cancellation removing
boilerplate and making it easier to understand overall. As a bonus to it
->inflight_entry is now used only for iopoll, probably can be put into a
union with something and save 16B of io_kiocb if that would be needed.

Pavel Begunkov (8):
  io_uring: close a small race gap for files cancel
  io_uring: further deduplicate #CQ events calc
  io_uring: account per-task #requests with files
  io_uring: explicitly pass tctx into del_task_file
  io_uring: draft files cancel based on inflight cnt
  io_uring: remove old files cancel mechanism
  io_uring: cleanup task cancel
  io_uring: kill not used anymore inflight_lock

 fs/io_uring.c            | 166 +++++++++++++--------------------------
 include/linux/io_uring.h |  13 ++-
 2 files changed, 59 insertions(+), 120 deletions(-)

-- 
2.24.0

