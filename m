Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C42142A6AE
	for <lists+io-uring@lfdr.de>; Tue, 12 Oct 2021 16:03:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237089AbhJLOFH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 12 Oct 2021 10:05:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237171AbhJLOFF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 12 Oct 2021 10:05:05 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7632CC061753
        for <io-uring@vger.kernel.org>; Tue, 12 Oct 2021 07:03:03 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id g25so20809884wrb.2
        for <io-uring@vger.kernel.org>; Tue, 12 Oct 2021 07:03:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QltprBg0sVUSqhUKJysB0Zj4uxQpWcU0nGkLkXyI22w=;
        b=Vnjeea32kVvOcaSUU0hpkJ7GbMcYMcR0e9nZOy6P2oPTBWKiOE8ClYN9lTKrqnLka+
         0UnrUbD5BRwJnjUdDFgZxggqmZRsOYdofUZ2IiHB3muvw9fAUZIfv6k0AHhKEak8Nleg
         UHVMCCRO7k/iNeE8bHBtxI6wU5CALGQO/iXOx/F/lu4Ts14XFZ7qWPNlbe61LXayTvQw
         vBwefg82LwAF4jHbkhNlMqb9BlynBE0bamEUMJuCK+8ZdA/GDxDuYdmsBD3zhtp817kk
         o0/7pRQARvrH9Hs4EVMrRDr1kv/jHg1XJMKzIvs01KqH5cjPNfh/AkvAIcs34ECn7o0Y
         9sUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QltprBg0sVUSqhUKJysB0Zj4uxQpWcU0nGkLkXyI22w=;
        b=q4kAfrvXtJK/iH9JrBe0PQo8C0qMZ1wlr4y7xA38PMDqJbroCblEFCVnvcWZ7iJc3n
         jlCNTQU9mBvnhUdyiJN5iT7zAvpQ2eSSQQ649i+YSls+Z/KD7HCy0TJIheL96d+qse0A
         4/wK/lyzaysufFNPYwYzEuGNBFU1UaQJZkaBJxxEpMdLhBX6us2mtpS/dOOVYIUDQiti
         xKWyZYvWVolsx6OAqVJgOOq2Yn+dzjXGqIZ4kGSpX5zCgYQu3YolTYVIkdWwjtlW/ttd
         ONRAicFWgBasvDhcYKH+eXViYsDi9Q3LihqzbpxbKBORJQOdLsbPslNzLPTNtuI8Q0eJ
         T85g==
X-Gm-Message-State: AOAM532W/WnhTl5QOov1WkfEXrx1FdXW3XYUVqgZgr6iyLXyZADDRcON
        BU1Am/VEE+7Q6G/hMdX33HrslmIsFfQ=
X-Google-Smtp-Source: ABdhPJybD2CfGfUMqtwvP3QKRw5zLV4E1rhIDjn1MI4z+zIUpPRka8GsDqukJdNnB4eBKQaOLCB+1Q==
X-Received: by 2002:a05:600c:4fd4:: with SMTP id o20mr5581821wmq.175.1634047381746;
        Tue, 12 Oct 2021 07:03:01 -0700 (PDT)
Received: from localhost.localdomain ([185.69.145.223])
        by smtp.gmail.com with ESMTPSA id z6sm6710625wro.25.2021.10.12.07.03.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 07:03:01 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next] io_uring: fix io_free_batch_list races
Date:   Tue, 12 Oct 2021 15:02:14 +0100
Message-Id: <b1f4df38fbb8f111f52911a02fd418d0283a4e6f.1634047298.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

[  158.514382] WARNING: CPU: 5 PID: 15251 at fs/io_uring.c:1141 io_free_batch_list+0x269/0x360
[  158.514426] RIP: 0010:io_free_batch_list+0x269/0x360
[  158.514437] Call Trace:
[  158.514440]  __io_submit_flush_completions+0xde/0x180
[  158.514444]  tctx_task_work+0x14a/0x220
[  158.514447]  task_work_run+0x64/0xa0
[  158.514448]  __do_sys_io_uring_enter+0x7c/0x970
[  158.514450]  __x64_sys_io_uring_enter+0x22/0x30
[  158.514451]  do_syscall_64+0x43/0x90
[  158.514453]  entry_SYSCALL_64_after_hwframe+0x44/0xae

We should not touch request internals including req->comp_list.next
after putting our ref if it's not final, e.g. we can start freeing
requests from the free cache.

Fixed: 62ca9cb93e7f8 ("io_uring: optimise io_free_batch_list()")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 73135c5c6168..55435464cee0 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2266,9 +2266,10 @@ static void io_free_batch_list(struct io_ring_ctx *ctx,
 		struct io_kiocb *req = container_of(node, struct io_kiocb,
 						    comp_list);
 
-		if (!req_ref_put_and_test(req)) {
+		if (unlikely(req->flags & REQ_F_REFCOUNT)) {
 			node = req->comp_list.next;
-			continue;
+			if (!req_ref_put_and_test(req))
+				continue;
 		}
 
 		io_queue_next(req);
-- 
2.33.0

