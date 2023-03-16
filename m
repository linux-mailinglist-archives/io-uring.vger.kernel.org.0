Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 935436BD386
	for <lists+io-uring@lfdr.de>; Thu, 16 Mar 2023 16:28:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231453AbjCPP2R (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Mar 2023 11:28:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231436AbjCPP2Q (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Mar 2023 11:28:16 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C95E6EB9C
        for <io-uring@vger.kernel.org>; Thu, 16 Mar 2023 08:27:16 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id w9so9246993edc.3
        for <io-uring@vger.kernel.org>; Thu, 16 Mar 2023 08:27:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678980434;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=DTTLwusKBLYA9yfncFozjaKD7sn7REZqof2Yoy1oU/U=;
        b=NNLJrKV9eMdNyaHJXYaKTyORraj2yxz6Wc5RvoAr8h+XdrJOWn7hEyMg528npcG2O7
         7v4LsEeTJCGaZuT/vzdO5Z5P3DMskGo0B/thlq/TwdDANYe4H8TlDD9zmtwuXtLKBKsz
         cshqF76y4UozTMcEbrtfFRNfCRSkE6zan4oI+3vJ5UxblC9mwuSE9NmVmZ+Q7KJJfWFd
         4z+s2YPUISalKYgatLcpvR9LZfIGpcLNYsFS4uVL077l928nLJcFaMRXPYsi138y0Ynq
         FI2vAM8LTHmG3QEpENXFknjsDV3HaCuOCoYW/AEjNjlP4nGJuk30XaxuGbCpRrX4NIvB
         xnZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678980434;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DTTLwusKBLYA9yfncFozjaKD7sn7REZqof2Yoy1oU/U=;
        b=1dPmb1twnK0n9YpMhlzDnAPQhybsRxp8HWlIvBDZ3VtxsInanRopqTeGm6UDkQ104z
         drkwew2Fh6PRY/uMRux46AuS+6CnjIM0Zt3pjTvP4INxfrLv2ucOSB9e7xICkOQKtG/d
         Hjq+DE+ypQu/9pLPpGxg87DS895kVXA7QjrO3ntZVNaRl6VWetcZ86iADwPxu84xu1Fo
         kvXVBi/oUt18gxCaQMXqnNpWUXCF/Gf4dW4reaxPtgcgQ23aZ+fsLFGFlLU59T5O7/JB
         N4K44/xgJ0ElZVF3r4hykWTKEUN0HmKHnHnDCbbnOuIJLVcZDDUZFI4mEBRG51k6pZDu
         jw9Q==
X-Gm-Message-State: AO0yUKUGQ8FMqndwIeXMfbdt4x2gC8DhSky6B1VPpA2i5dERYhcB14vO
        g/VcvtkpTJD9OsX+o0SNO/5CulIQKf0=
X-Google-Smtp-Source: AK7set/HKHkafmaP9bkfUm/ygPz+qR+2fSL/JCfM2eGfF+ky2XR/F30aV/99D+vkKlKBvgTVPZFK8Q==
X-Received: by 2002:a17:906:face:b0:92a:3709:e872 with SMTP id lu14-20020a170906face00b0092a3709e872mr10426081ejb.19.1678980434504;
        Thu, 16 Mar 2023 08:27:14 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::2:7abd])
        by smtp.gmail.com with ESMTPSA id r8-20020a170906c28800b00928e0ea53e5sm3958174ejz.84.2023.03.16.08.27.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 08:27:14 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com,
        Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH 1/1] io_uring/rsrc: fix folly accounting
Date:   Thu, 16 Mar 2023 15:26:05 +0000
Message-Id: <10efd5507d6d1f05ea0f3c601830e08767e189bd.1678980230.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.39.1
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

| BUG: Bad page state in process kworker/u8:0  pfn:5c001
| page:00000000bfda61c8 refcount:0 mapcount:0 mapping:0000000000000000 index:0x20001 pfn:0x5c001
| head:0000000011409842 order:9 entire_mapcount:0 nr_pages_mapped:0 pincount:1
| anon flags: 0x3fffc00000b0004(uptodate|head|mappedtodisk|swapbacked|node=0|zone=0|lastcpupid=0xffff)
| raw: 03fffc0000000000 fffffc0000700001 ffffffff00700903 0000000100000000
| raw: 0000000000000200 0000000000000000 00000000ffffffff 0000000000000000
| head: 03fffc00000b0004 dead000000000100 dead000000000122 ffff00000a809dc1
| head: 0000000000020000 0000000000000000 00000000ffffffff 0000000000000000
| page dumped because: nonzero pincount
| CPU: 3 PID: 9 Comm: kworker/u8:0 Not tainted 6.3.0-rc2-00001-gc6811bf0cd87 #1
| Hardware name: linux,dummy-virt (DT)
| Workqueue: events_unbound io_ring_exit_work
| Call trace:
|  dump_backtrace+0x13c/0x208
|  show_stack+0x34/0x58
|  dump_stack_lvl+0x150/0x1a8
|  dump_stack+0x20/0x30
|  bad_page+0xec/0x238
|  free_tail_pages_check+0x280/0x350
|  free_pcp_prepare+0x60c/0x830
|  free_unref_page+0x50/0x498
|  free_compound_page+0xcc/0x100
|  free_transhuge_page+0x1f0/0x2b8
|  destroy_large_folio+0x80/0xc8
|  __folio_put+0xc4/0xf8
|  gup_put_folio+0xd0/0x250
|  unpin_user_page+0xcc/0x128
|  io_buffer_unmap+0xec/0x2c0
|  __io_sqe_buffers_unregister+0xa4/0x1e0
|  io_ring_exit_work+0x68c/0x1188
|  process_one_work+0x91c/0x1a58
|  worker_thread+0x48c/0xe30
|  kthread+0x278/0x2f0
|  ret_from_fork+0x10/0x20

Mark reports an issue with the recent patches coalescing compound pages
while registering them in io_uring. The reason is that we try to drop
excessive references with folio_put_refs(), but pages were acquired
with pin_user_pages(), which has extra accounting and so should be put
down with matching unpin_user_pages() or at least gup_put_folio().

As a fix unpin_user_pages() all but first page instead, and let's figure
out a better API after.

Fixes: 57bebf807e2abcf8 ("io_uring/rsrc: optimise registered huge pages")
Reported-by: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Jens Axboe <axboe@kernel.dk>
Tested-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/rsrc.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 056f40946ff6..3c5ab0360317 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1235,7 +1235,13 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
 			}
 		}
 		if (folio) {
-			folio_put_refs(folio, nr_pages - 1);
+			/*
+			 * The pages are bound to the folio, it doesn't
+			 * actually unpin them but drops all but one reference,
+			 * which is usually put down by io_buffer_unmap().
+			 * Note, needs a better helper.
+			 */
+			unpin_user_pages(&pages[1], nr_pages - 1);
 			nr_pages = 1;
 		}
 	}
-- 
2.39.1

