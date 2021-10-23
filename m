Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43329438346
	for <lists+io-uring@lfdr.de>; Sat, 23 Oct 2021 13:14:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230126AbhJWLQa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 23 Oct 2021 07:16:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbhJWLQa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 23 Oct 2021 07:16:30 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33B42C061764
        for <io-uring@vger.kernel.org>; Sat, 23 Oct 2021 04:14:11 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id o4-20020a1c7504000000b0032cab7473caso571103wmc.1
        for <io-uring@vger.kernel.org>; Sat, 23 Oct 2021 04:14:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rhkNSEj+MwuT8OSFJvZnXHVp9T/stZZXrj/7MDJv7rc=;
        b=jRKCzXvnN+KDVPWvglbPW0tk0jtzyV5yIdFoTWQCuldpQDX5hMIy/bATIiFHGEW4hz
         A772HAAwMc0/jxYHmIrM/f2txGMMBB6w6xMplgj3CLlrcsRsnAHeh1KSgEm7xoRopQdp
         M1twWalxj/omlz7/6eXZjnyJdHdsKGdYW7npSRsRJDzGdNTdSdoH07vd8cryHAZ6kiWu
         f/33C53p6140T6d0JWYcULOI2Z1FRSyA8OsRLmci7MvYZA+Nkgm9RrKOVXJcqaAv806B
         9fK6rTsDU+f1N/ntzZzuIX9iUHzkEwVc3HFfekhDWTN/tDMOVw+dYPjefn8NTES4VMwn
         s03Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rhkNSEj+MwuT8OSFJvZnXHVp9T/stZZXrj/7MDJv7rc=;
        b=ogFaUIlww0wCfR+SOhvz+CVA1ikD5z3kiUl9ki3Pi7ZH0ycBxn1P2EmRRjDd2UIS+F
         Oj2+Gj3NyOz3tjK1VDOBSxY87YPKjC3yi563ldaIkKOS7VCU0cOlbqQqnVYiVLOEie8u
         v7hpWQVpq5Gmu7cNvJ7WrL+n+N4gfrw/Ie4BLFjgb391vJZXnNSQTNTjKVmzhOMPTnbf
         2zxJnFWwnNeP69VtsHwmQyQcqFoHsx2I7PHpHI9//7CvQgy79f3WWJIhb/QaibwN9nZb
         Z9Q4S06IY2aE3N7gvFnYTgN77joFhJuGhTlTfsgw2bBW5mk8gR7HE9iBEjy6+0wjpyrd
         dEIg==
X-Gm-Message-State: AOAM532Mm0faTvBRvXpUP/Mns1W7ij47sSLefowTveWGzopOU18NOQph
        wlXEGBzIzBErG+Lcgb6qC3yFHUVqFnc=
X-Google-Smtp-Source: ABdhPJz/ORh5HHPhI/mo3nx21dqlHyZx/+5ug3dzCrBOaeTbHN5r2Zms3wHeFivxADs/TlN2kLvZFw==
X-Received: by 2002:a7b:ce08:: with SMTP id m8mr35962240wmc.93.1634987649270;
        Sat, 23 Oct 2021 04:14:09 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.133.195])
        by smtp.gmail.com with ESMTPSA id w2sm10416316wrt.31.2021.10.23.04.14.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Oct 2021 04:14:09 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, Hao Xu <haoxu@linux.alibaba.com>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 1/8] io-wq: use helper for worker refcounting
Date:   Sat, 23 Oct 2021 12:13:55 +0100
Message-Id: <6f95f09d2cdbafcbb2e22ad0d1a2bc4d3962bf65.1634987320.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1634987320.git.asml.silence@gmail.com>
References: <cover.1634987320.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Use io_worker_release() instead of hand coding it in io_worker_exit().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io-wq.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 811299ac9684..0c283bb18fb2 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -178,8 +178,7 @@ static void io_worker_exit(struct io_worker *worker)
 {
 	struct io_wqe *wqe = worker->wqe;
 
-	if (refcount_dec_and_test(&worker->ref))
-		complete(&worker->ref_done);
+	io_worker_release(worker);
 	wait_for_completion(&worker->ref_done);
 
 	raw_spin_lock(&wqe->lock);
-- 
2.33.1

