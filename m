Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EB684176E2
	for <lists+io-uring@lfdr.de>; Fri, 24 Sep 2021 16:34:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346874AbhIXOgP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Sep 2021 10:36:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346860AbhIXOgO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Sep 2021 10:36:14 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68936C061571
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 07:34:41 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id m11so12878577ioo.6
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 07:34:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=8jp1/4vyk6salDOIlP5q/sj8GqmuxKCyVbnaUxlCX2Q=;
        b=WPE2t7NtnUJYdI+SgqI5hCyP7uGwBzSx6bpk8AVZV10sA2l28Bq1ixA6VRG7SJorHT
         bIkpaVMtMh2RIlQTxgXvpPyJLhs0SZa6pBlIF0IyilNyktgeeN6vjzwgGdygDP7TDR1k
         Uf25KxFe5+iX/xQ2tyeMJTgGFj/1dDlo7khyIdK5Ajo4AjVaeyN6D5PUNW7XNwxpMhjD
         kGUPtGf1avDOQh3OjtRqpbfB4Hh/MYysYN0+Ez6xvYqYxsCP3WhDXfPt6D1q7RHGwyCO
         gImbivn2RzBytga2URQAHoW0hkPmGJs4BwFAY6e6Q7ciqDHPmAUTffw8JhXw7SnZsXoK
         +H6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=8jp1/4vyk6salDOIlP5q/sj8GqmuxKCyVbnaUxlCX2Q=;
        b=SvWaoKV+5vAK881gz8oADei3x0engficg5SRoVHuS2u0oPR8fAf04B2yPwYqYG+DO6
         2APn/2JAv2ReUcqCMtkKD+izShhZxQCuD0EJoZ8dvqWMel+fs/n9Z4hbkKcFJEAjjRnu
         uqJc1uTlGd319qoLOv9Lw01aJElTfXGZ3O/TW5/Ug4fn6Y8y23Udxed/C2Zi0xfloZWk
         WwTbiLBnO9sN4fJJ4NOvs85ac1kldPuS2cyMyMnKa+sgqNvofYiEKgjR+1nRSj2mZi/k
         O38aqEL6/gY7yEAOppCWlAfTw72aGZyhHvvJR9JbCn5P0ucYdZmz8ahZ54erpo6syJ6g
         0lJA==
X-Gm-Message-State: AOAM530qMSE5mVwBkGXtnv5RIXBEd5VoT236LWh0AERiSjJNMxtPQQwt
        dTDR3EZm/MS2WYh2OgnKgN7YWGCkmCavHeIhQDY=
X-Google-Smtp-Source: ABdhPJzee+Nl/6SqrpitNCyB2bU+THUi19QhohKWvHDJjMrMH31Gtk2qNZQtZaaSMIu3i0HnLC1xjg==
X-Received: by 2002:a05:6602:2bd4:: with SMTP id s20mr9443927iov.63.1632494080477;
        Fri, 24 Sep 2021 07:34:40 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id f7sm4282305ilc.82.2021.09.24.07.34.40
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Sep 2021 07:34:40 -0700 (PDT)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: allow conditional reschedule for intensive
 iterators
Message-ID: <42646dd4-3f85-6e7f-0272-782238c164f5@kernel.dk>
Date:   Fri, 24 Sep 2021 08:34:39 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If we have a lot of threads and rings, the tctx list can get quite big.
This is especially true if we keep creating new threads and rings.
Likewise for the provided buffers list. Be nice and insert a conditional
reschedule point while iterating the nodes for deletion.

Link: https://lore.kernel.org/io-uring/00000000000064b6b405ccb41113@google.com/
Reported-by: syzbot+111d2a03f51f5ae73775@syzkaller.appspotmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io_uring.c b/fs/io_uring.c
index fe5e613b960f..ee33d79f9758 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -9137,8 +9137,10 @@ static void io_destroy_buffers(struct io_ring_ctx *ctx)
 	struct io_buffer *buf;
 	unsigned long index;
 
-	xa_for_each(&ctx->io_buffers, index, buf)
+	xa_for_each(&ctx->io_buffers, index, buf) {
 		__io_remove_buffers(ctx, buf, index, -1U);
+		cond_resched();
+	}
 }
 
 static void io_req_cache_free(struct list_head *list)
@@ -9636,8 +9638,10 @@ static void io_uring_clean_tctx(struct io_uring_task *tctx)
 	struct io_tctx_node *node;
 	unsigned long index;
 
-	xa_for_each(&tctx->xa, index, node)
+	xa_for_each(&tctx->xa, index, node) {
 		io_uring_del_tctx_node(index);
+		cond_resched();
+	}
 	if (wq) {
 		/*
 		 * Must be after io_uring_del_task_file() (removes nodes under

-- 
Jens Axboe

