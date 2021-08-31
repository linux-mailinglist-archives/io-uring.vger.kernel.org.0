Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 164763FC7F6
	for <lists+io-uring@lfdr.de>; Tue, 31 Aug 2021 15:13:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233575AbhHaNOs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 31 Aug 2021 09:14:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230175AbhHaNOs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 31 Aug 2021 09:14:48 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D846DC061760
        for <io-uring@vger.kernel.org>; Tue, 31 Aug 2021 06:13:52 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id o39-20020a05600c512700b002e74638b567so2529053wms.2
        for <io-uring@vger.kernel.org>; Tue, 31 Aug 2021 06:13:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Upgzhm0KaDTOG77AZfdtOs5gu+3bdbvWcYwySiIoiI0=;
        b=Y+3C9L34PrZrv4bpN/U8LS2yWbCuxGUDswg5pJNcnS0m7pZhxQIKtvH3i8bIFVhS4N
         +pdI+m9F1DnX5eu/WhVDF9aoMZelrEI4wAFVQICvdYHLF0+AGU5u/F+UOF/qDm7SHv04
         z6O+7aNQNiR8k7bAX9nGv+kGW/12v4glIfiJrifVhG1O03tIdmneBwExcSGmbVAiXTsD
         UIBC74FkDbnAZWHKw9clzbBgPI6pezR/rwgE7XaFK8zP2UwUCC9HVJWfLwsRghdQ0E+1
         hfNEbPd5egXC1mJZSoaf/vUGu9rW10p4jJZeKzxRxg+uNgTOAknUD531z/agOQ2PA3Su
         DczQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Upgzhm0KaDTOG77AZfdtOs5gu+3bdbvWcYwySiIoiI0=;
        b=cq5NdIgAKUE0S9XEo9ze9S8PpTV2HE+QcyQe+ap+CUWzx4mLoydGFVEAqhPYGD31eu
         cMao08gL/ymRhDper0nKbo1Ogb7h0IPEev0VITDFOoc4ZSIWdD12ZLRu9Sl6ii/5SHTS
         FMnHxdjW/YVJWfE0ovxrFPTMhJhV4mADhU5l/XzcNkR+y/ZjA3a81WXakuIK3BeWwcq8
         hhsDHQqAWaDnHO1rk5XL/uNVsEgaTsEwVLCNLR5NWcPQg7ijH/k2/D3imRzqyZuGmeKc
         z1arvOCBj22uhuMQnvK6UjkmN6fEAFg7aMn3wI0AJCgU+jGvQHZFQdZQydcDpOjGQYtA
         5P0g==
X-Gm-Message-State: AOAM530ESCT+4qWIUl/odi6Scm2YHfbWmJadTDIfmPqVK3+zt4zSw1nC
        /66fnR0d6yLhDP3qiEFJJvDgIFnoCDk=
X-Google-Smtp-Source: ABdhPJx07HFWKnrgJtoV3SizfhLvpIoPYiRDD7TnTWGtfLEFc9bAzH8zv4RHTcaZMOykks54t2drmw==
X-Received: by 2002:a05:600c:3543:: with SMTP id i3mr4331176wmq.2.1630415631513;
        Tue, 31 Aug 2021 06:13:51 -0700 (PDT)
Received: from localhost.localdomain ([148.252.133.138])
        by smtp.gmail.com with ESMTPSA id t14sm18246586wrw.59.2021.08.31.06.13.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Aug 2021 06:13:51 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     Hao Xu <haoxu@linux.alibaba.com>
Subject: [PATCH v2 2/2] io_uring: don't submit half-prepared drain request
Date:   Tue, 31 Aug 2021 14:13:11 +0100
Message-Id: <e411eb9924d47a131b1e200b26b675df0c2b7627.1630415423.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1630415423.git.asml.silence@gmail.com>
References: <cover.1630415423.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

[ 3784.910888] BUG: kernel NULL pointer dereference, address: 0000000000000020
[ 3784.910904] RIP: 0010:__io_file_supports_nowait+0x5/0xc0
[ 3784.910926] Call Trace:
[ 3784.910928]  ? io_read+0x17c/0x480
[ 3784.910945]  io_issue_sqe+0xcb/0x1840
[ 3784.910953]  __io_queue_sqe+0x44/0x300
[ 3784.910959]  io_req_task_submit+0x27/0x70
[ 3784.910962]  tctx_task_work+0xeb/0x1d0
[ 3784.910966]  task_work_run+0x61/0xa0
[ 3784.910968]  io_run_task_work_sig+0x53/0xa0
[ 3784.910975]  __x64_sys_io_uring_enter+0x22/0x30
[ 3784.910977]  do_syscall_64+0x3d/0x90
[ 3784.910981]  entry_SYSCALL_64_after_hwframe+0x44/0xae

io_drain_req() goes before checks for REQ_F_FAIL, which protect us from
submitting under-prepared request (e.g. failed in io_init_req(). Fail
such drained requests as well.

Fixes: a8295b982c46d ("io_uring: fix failed linkchain code logic")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 6e07456d9842..2514adced460 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6232,6 +6232,11 @@ static bool io_drain_req(struct io_kiocb *req)
 	int ret;
 	u32 seq;
 
+	if (req->flags & REQ_F_FAIL) {
+		io_req_complete_fail_submit(req);
+		return true;
+	}
+
 	/*
 	 * If we need to drain a request in the middle of a link, drain the
 	 * head request and the next request/link after the current link.
-- 
2.33.0

