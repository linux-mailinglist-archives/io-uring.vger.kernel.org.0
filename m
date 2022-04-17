Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DF80504758
	for <lists+io-uring@lfdr.de>; Sun, 17 Apr 2022 11:11:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231699AbiDQJNv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 17 Apr 2022 05:13:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233283AbiDQJNu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 17 Apr 2022 05:13:50 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF33A2A272
        for <io-uring@vger.kernel.org>; Sun, 17 Apr 2022 02:11:14 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id b24so14539784edu.10
        for <io-uring@vger.kernel.org>; Sun, 17 Apr 2022 02:11:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ueMtHnt1FiuI41Ya01XLyvRyMPa/Grwlxwz2qs6IFZ4=;
        b=msSv6EMpko5VN03TIdBQjUkQYvd/coy4oFnPz9BgIEkvP2CEpuh5Pb8JOVnNqg/Byu
         uB8Dj3zTwVLublDeipDeGW43L9Ox4a9FLqrA/dglzj30GsTpUhMIa7i6UASCEa4ayq/o
         r8ODj66cVNBzLii0a24XiX6QSagjQZhr7GKmE7WUQjJMp+lZfoWRLeZJ7Ac+Gk137F56
         DHA088juXFRyEcybBayXI0whEZ0wLEGpwoggcwupxIDW/UxMUQxMCvmEkl9iD1rM00/F
         DkEjT+9jknsBMa9TgZD8bseUBuWq+J28F2Ric5iVNwsAkh0tOgKKtAol9/lV6oVN+z2I
         3C9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ueMtHnt1FiuI41Ya01XLyvRyMPa/Grwlxwz2qs6IFZ4=;
        b=RIsKvCreYVT8e1gY0w7N3u/ifeCK9+vAJOzesiCl8kd37RFj6SiL9hak2IYERlNEuW
         eHUBn0pcrvIBY6T+aQq3eQIpee7SEBQtjdTvQ2hi+MiarVZpm7y9Bk/DIulHnlQ1BB0P
         zd4UY2HQB+kPTThbalxuHmcf4ks0E/kiSGe8g5I+qqcPnlztx8oMfSZnohrzAZ6PMkrV
         INBsHPFI++lP56VfphAtTcR517NYaD+GMBtSFjow32egduA3nlAG/IdFuZzP4eXWn4rF
         Q+oUIipqNDgCItKGLSF1ax8DJ7Sz196cbMz5hoGVxx+efMAaRQoujlFukIino6+AHIYN
         Sy2Q==
X-Gm-Message-State: AOAM531usklmfcc5J0QaqOo+4A/pvYLPiqdV55AMo+TbFb5QoEgdsMlc
        YuJNpRm4f+jHtvtTlhwzksJ9DYWasvw=
X-Google-Smtp-Source: ABdhPJxGg6sJiAmNX0jdAtYTDs7xXrcez6KMLYNTFeYo4sq7bo8JH4w8riQepYw33XJSSj7oaxJ+hA==
X-Received: by 2002:a05:6402:4499:b0:41d:7e83:8565 with SMTP id er25-20020a056402449900b0041d7e838565mr7161902edb.332.1650186672630;
        Sun, 17 Apr 2022 02:11:12 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.129.75])
        by smtp.gmail.com with ESMTPSA id ee17-20020a056402291100b0041fe1e4e342sm5265431edb.27.2022.04.17.02.11.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Apr 2022 02:11:12 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH v2] io_uring: fix leaks on IOPOLL and CQE_SKIP
Date:   Sun, 17 Apr 2022 10:10:34 +0100
Message-Id: <5072fc8693fbfd595f89e5d4305bfcfd5d2f0a64.1650186611.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.35.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If all completed requests in io_do_iopoll() were marked with
REQ_F_CQE_SKIP, we'll not only skip CQE posting but also
io_free_batch_list() leaking memory and resources.

Move @nr_events increment before REQ_F_CQE_SKIP check. We'll potentially
return the value greater than the real one, but iopolling will deal with
it and the userspace will re-iopoll if needed. In anyway, I don't think
there are many use cases for REQ_F_CQE_SKIP + IOPOLL.

Fixes: 83a13a4181b0e ("io_uring: tweak iopoll CQE_SKIP event counting")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---

v2: rebase onto 5.18

 fs/io_uring.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 4479013854d2..43f7911ee555 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2797,11 +2797,10 @@ static int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
 		/* order with io_complete_rw_iopoll(), e.g. ->result updates */
 		if (!smp_load_acquire(&req->iopoll_completed))
 			break;
+		nr_events++;
 		if (unlikely(req->flags & REQ_F_CQE_SKIP))
 			continue;
-
 		__io_fill_cqe_req(req, req->result, io_put_kbuf(req, 0));
-		nr_events++;
 	}
 
 	if (unlikely(!nr_events))
-- 
2.35.2

