Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B750E36C66F
	for <lists+io-uring@lfdr.de>; Tue, 27 Apr 2021 14:52:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236247AbhD0MxF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 27 Apr 2021 08:53:05 -0400
Received: from us2-ob1-7.mailhostbox.com ([208.91.199.213]:35480 "EHLO
        us2-ob1-7.mailhostbox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235426AbhD0MxF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 27 Apr 2021 08:53:05 -0400
Received: from smtp.oswalpalash.com (unknown [49.36.71.250])
        (Authenticated sender: hello@oswalpalash.com)
        by us2.outbound.mailhostbox.com (Postfix) with ESMTPA id D3507185091;
        Tue, 27 Apr 2021 12:52:15 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oswalpalash.com;
        s=20160715; t=1619527939;
        bh=QJ1ItH+nby/xw42i3yg7qBH/TbUz3BBp9ZHK6FTGYB0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=OdckFU0fJid7KqGPk3e2N7cQrEkblGfvE+861jC6730L1f3Qc8y30JUnFWclKB/ck
         3jug+RMij0FXdZKxXs3jjCgg2rdwkJHHExndUpC313ZXVbHIPGVSpgfNih/QZdoOYT
         /TYRWgt+9TbIx9JpkgbWyGoELgefgTTd6e2o9wMo=
From:   Palash Oswal <hello@oswalpalash.com>
To:     asml.silence@gmail.com
Cc:     axboe@kernel.dk, dvyukov@google.com, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, oswalpalash@gmail.com,
        syzbot+be51ca5a4d97f017cd50@syzkaller.appspotmail.com,
        syzkaller-bugs@googlegroups.com,
        Palash Oswal <hello@oswalpalash.com>, stable@vger.kernel.org
Subject: [PATCH 5.13] io_uring: Check current->io_uring in io_uring_cancel_sqpoll
Date:   Tue, 27 Apr 2021 18:21:49 +0530
Message-Id: <20210427125148.21816-1-hello@oswalpalash.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <e67b2f55-dd0a-1e1f-e34b-87e8613cd701@gmail.com>
References: <e67b2f55-dd0a-1e1f-e34b-87e8613cd701@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Score: 0
X-CMAE-Analysis: v=2.3 cv=M6Qz1B4s c=1 sm=1 tr=0
        a=/01j2yjeSAkpGUovTkZ0Ew==:117 a=/01j2yjeSAkpGUovTkZ0Ew==:17
        a=X6f2t9OlHk8md9mV9bYA:9
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

syzkaller identified KASAN: null-ptr-deref Write in
io_uring_cancel_sqpoll on v5.12

io_uring_cancel_sqpoll is called by io_sq_thread before calling
io_uring_alloc_task_context. This leads to current->io_uring being
NULL. io_uring_cancel_sqpoll should not have to deal with threads
where current->io_uring is NULL.

In order to cast a wider safety net, perform input sanitisation
directly in io_uring_cancel_sqpoll and return for NULL value of
current->io_uring.

Reported-by: syzbot+be51ca5a4d97f017cd50@syzkaller.appspotmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Palash Oswal <hello@oswalpalash.com>
---
 fs/io_uring.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index dff34975d86b..eccad51b7954 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8998,6 +8998,8 @@ static void io_uring_cancel_sqpoll(struct io_ring_ctx *ctx)
 	s64 inflight;
 	DEFINE_WAIT(wait);
 
+	if (!current->io_uring)
+		return;
 	WARN_ON_ONCE(!sqd || ctx->sq_data->thread != current);
 
 	atomic_inc(&tctx->in_idle);
-- 
2.27.0

