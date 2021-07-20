Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9AB73CF734
	for <lists+io-uring@lfdr.de>; Tue, 20 Jul 2021 11:51:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229903AbhGTJKo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 20 Jul 2021 05:10:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232506AbhGTJKn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 20 Jul 2021 05:10:43 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D57E0C061574
        for <io-uring@vger.kernel.org>; Tue, 20 Jul 2021 02:51:17 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id o30-20020a05600c511eb029022e0571d1a0so1652899wms.5
        for <io-uring@vger.kernel.org>; Tue, 20 Jul 2021 02:51:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JKJfdnPXqsrfjULYYWvdwVZkrkH9GubJr4aLxS5N59w=;
        b=GqHQa8DCeGAEFqEspHpPTPOfUHrhZLaMun9v02NOrQAo3CXm3DFbONiJKcAQzHBrQy
         G1T33UHH9EJpxo7Ai1MrkbXL3bFgVo/sBJVKCGSlDlDQnCKsMNuKXwYIfmi2yPUoD8+4
         gOd2kPqJkVDN08YWYOqEoo363Ys5gaMqWAsRwJgjQv55SdmqQ1vTzsM8KHca3xEOdsBy
         B5lLnWlAsf6vKlDtbEoHz/xkZ9VQLXnuQ5DlareC606MDUbwdtHRtoPOQ2YI2n7vQGuJ
         L0xcnARcTnjfJBQRVuwhmkJAEU37kQ656ojAPLHq6PObDux9OA9gRSd8adNMYlDUVhnl
         TLwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JKJfdnPXqsrfjULYYWvdwVZkrkH9GubJr4aLxS5N59w=;
        b=MMdGy0noYG08c5tkSUKEajBeKG45yu9Y72KB1YSZ628wEJc+rw0op0NWEpSKMcf7v5
         se86AuWMCALwXnKixH4hZq4AcvuR6pYYS3E/XqnBw3bIEmIq2kn0eR7bdMxOqmI6GEJn
         veJpFgD08yV1F4t2PLF4NFkgBQbVeF+Nzn7/GikJ7E+40zwm/ZW9TUqI952Jwo+Amn/9
         xWvKfNje2QfjGEzN40iOVifAZoYRWWDI0eg1mzj+Q7en3FDrijCDP8+sgfZ/ir/n2lRF
         hEausHIMXWl3TV9C4VhQmeCHJLBZamrK18VXnVrls5giKB5r+/9w/0QED9LAv+5SSDb8
         JUVw==
X-Gm-Message-State: AOAM531KLra3EAvFP8eyFoAVfRh1oRpp61/eZVfHRglJp0QXYji00ehy
        pAn8FDxYnTtdBWXm7K8hZhk=
X-Google-Smtp-Source: ABdhPJy/wLrd1kg+8eBVCEAouDDtvmDay/tOL4R9iW3OPC1J/2WmAnGcalJ0XdaXr7grX9Gq4NKCMw==
X-Received: by 2002:a1c:38c7:: with SMTP id f190mr30681245wma.30.1626774676549;
        Tue, 20 Jul 2021 02:51:16 -0700 (PDT)
Received: from localhost.localdomain ([148.252.132.204])
        by smtp.gmail.com with ESMTPSA id p9sm22297701wrx.59.2021.07.20.02.51.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jul 2021 02:51:16 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
Subject: [PATCH 2/2] io_uring: remove double poll entry on arm failure
Date:   Tue, 20 Jul 2021 10:50:44 +0100
Message-Id: <0ec1228fc5eda4cb524eeda857da8efdc43c331c.1626774457.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1626774457.git.asml.silence@gmail.com>
References: <cover.1626774457.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

__io_queue_proc() can enqueue both poll entries and still fail
afterwards, so the callers trying to cancel it should also try to remove
the second poll entry (if any).

For example, it may leave the request alive referencing a io_uring
context but not accessible for cancellation:

[  282.599913][ T1620] task:iou-sqp-23145   state:D stack:28720 pid:23155 ppid:  8844 flags:0x00004004
[  282.609927][ T1620] Call Trace:
[  282.613711][ T1620]  __schedule+0x93a/0x26f0
[  282.634647][ T1620]  schedule+0xd3/0x270
[  282.638874][ T1620]  io_uring_cancel_generic+0x54d/0x890
[  282.660346][ T1620]  io_sq_thread+0xaac/0x1250
[  282.696394][ T1620]  ret_from_fork+0x1f/0x30

Cc: stable@vger.kernel.org
Fixes: 18bceab101add ("io_uring: allow POLL_ADD with double poll_wait() users")
Reported-and-tested-by: syzbot+ac957324022b7132accf@syzkaller.appspotmail.com
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 6668902cf50c..6486b54a0f62 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5113,6 +5113,8 @@ static __poll_t __io_arm_poll_handler(struct io_kiocb *req,
 		ipt->error = -EINVAL;
 
 	spin_lock_irq(&ctx->completion_lock);
+	if (ipt->error)
+		io_poll_remove_double(req);
 	if (likely(poll->head)) {
 		spin_lock(&poll->head->lock);
 		if (unlikely(list_empty(&poll->wait.entry))) {
-- 
2.32.0

