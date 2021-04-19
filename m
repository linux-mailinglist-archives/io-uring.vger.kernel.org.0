Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52C1F364201
	for <lists+io-uring@lfdr.de>; Mon, 19 Apr 2021 14:48:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233536AbhDSMtX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 19 Apr 2021 08:49:23 -0400
Received: from us2-ob2-7.mailhostbox.com ([208.91.199.208]:35224 "EHLO
        us2-ob2-7.mailhostbox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232709AbhDSMtX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 19 Apr 2021 08:49:23 -0400
X-Greylist: delayed 610 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Apr 2021 08:49:23 EDT
Received: from smtp.oswalpalash.com (unknown [49.36.79.38])
        (Authenticated sender: hello@oswalpalash.com)
        by us2.outbound.mailhostbox.com (Postfix) with ESMTPA id 95FBC78261C;
        Mon, 19 Apr 2021 12:38:39 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oswalpalash.com;
        s=20160715; t=1618835922;
        bh=kT29ypuv7A855UVCqwpU0b49/ZfU+kqo9AeK/OVIgUE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=EpviTtNh58mftTBiwOb64P4RptPndOhK0W0A6d9nW0z0h8TFf1pMvQawvCXc8Y8zQ
         rBZuWS8LCZC+u77COSNtdAjOOPrRe7jpgOAYKrB2idOkdxS/o9KWAgQAbjde9AByx7
         fpQIZ3ZNLNm1EJWt7zsCbWzJosmi2FQpgzf4XQeo=
From:   Palash Oswal <hello@oswalpalash.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Palash Oswal <hello@oswalpalash.com>
Subject: [PATCH] io_uring: check ctx->sq_data before io_sq_offload_start
Date:   Mon, 19 Apr 2021 18:06:31 +0530
Message-Id: <20210419123630.62212-1-hello@oswalpalash.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: https://lore.kernel.org/io-uring/d346085f-8b9b-d620-1e0c-aa78fee8db13@gmail.com
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Score: 0
X-CMAE-Analysis: v=2.3 cv=I7wbu+og c=1 sm=1 tr=0
        a=cdGxx36Ay0PF3zJPwW0H8g==:117 a=cdGxx36Ay0PF3zJPwW0H8g==:17
        a=1WgTlICyNIAsNvkEdfwA:9
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

syzkaller identified KASAN: null-ptr-deref Read in io_uring_create
bug on the stable 5.11-y tree.

BUG: KASAN: null-ptr-deref in io_sq_offload_start fs/io_uring.c:8254 [inline]
BUG: KASAN: null-ptr-deref in io_disable_sqo_submit fs/io_uring.c:8999 [inline]
BUG: KASAN: null-ptr-deref in io_uring_create+0x1275/0x22f0 fs/io_uring.c:9824
Read of size 8 at addr 0000000000000068 by task syz-executor.0/4350

A simple reproducer for this bug is:

int main(void)
{
  syscall(__NR_mmap, 0x20000000ul, 0x1000000ul, 7ul, 0x32ul, -1, 0ul);
  intptr_t res = 0;
  pid_t parent = getpid();
  *(uint32_t*)0x20000084 = 0;
  *(uint32_t*)0x20000088 = 0x42;
  *(uint32_t*)0x2000008c = 0;
  *(uint32_t*)0x20000090 = 0;
  *(uint32_t*)0x20000098 = -1;
  *(uint32_t*)0x2000009c = 0;
  *(uint32_t*)0x200000a0 = 0;
  *(uint32_t*)0x200000a4 = 0;
  if (fork() == 0) {
    kill(parent,SIGKILL);
    exit(0);
  }
  res = syscall(__NR_io_uring_setup, 0x7994, 0x20000080ul);
  return 0;
}

Due to the SIGKILL sent to the process before io_uring_setup
completes, ctx->sq_data is NULL. Therefore, io_sq_offload_start
does a null pointer dereferenced read. More details on this bug
are in [1]. Discussion for this patch happened in [2].

[1] https://oswalpalash.com/exploring-null-ptr-deref-io-uring-submit
[2] https://lore.kernel.org/io-uring/a08121be-f481-e9f8-b28d-3eb5d4f
a5b76@gmail.com/

Signed-off-by: Palash Oswal <hello@oswalpalash.com>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 95b4a89dad4e..82a89ff315a4 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8995,7 +8995,7 @@ static void io_disable_sqo_submit(struct io_ring_ctx *ctx)
 {
 	mutex_lock(&ctx->uring_lock);
 	ctx->sqo_dead = 1;
-	if (ctx->flags & IORING_SETUP_R_DISABLED)
+	if (ctx->flags & IORING_SETUP_R_DISABLED && ctx->sq_data)
 		io_sq_offload_start(ctx);
 	mutex_unlock(&ctx->uring_lock);
 

base-commit: 2aa8861eab092599ad566c5b20d7452d9ec0ca8e
-- 
2.27.0

