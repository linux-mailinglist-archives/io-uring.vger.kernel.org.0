Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C516334BCC
	for <lists+io-uring@lfdr.de>; Wed, 10 Mar 2021 23:45:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233367AbhCJWol (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 10 Mar 2021 17:44:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233829AbhCJWoP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 10 Mar 2021 17:44:15 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E462C061761
        for <io-uring@vger.kernel.org>; Wed, 10 Mar 2021 14:44:15 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id a188so13165654pfb.4
        for <io-uring@vger.kernel.org>; Wed, 10 Mar 2021 14:44:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ff8262sXYdAs5eFjlJhBLMb7k29k1R9YL06T/WsbgL8=;
        b=pkN6GeGPOSnpP76lEfH03ntfag49oleOtxAVKLMgXlft2e6O9KDBz8PVVH6uzN/eDF
         U6YoT3ERwlKUT5B//Jqj6a9V2U9eOfIiuQvZhETfAwDA0aDstP/7q8Kf0SUmyEoCDAQd
         TPzn7dc5n7BekfWKkg17QtDjdMWFw8LZb1F6iz3gImsgpPKXgBIlYa3W3I1D3K6jKQiF
         mzGHXEXxe5sVvZMcDTFFoUuaHX3kmKt+k55MqFEowZyYtjuWLzQBzZg677szFHLWuKLa
         6HOPOK3eWXh9xDmSf6N68pe7ZB+qTZJ/2tGk91H0c/C0AETI/fjeRbWuzMICejvChMF+
         FMyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ff8262sXYdAs5eFjlJhBLMb7k29k1R9YL06T/WsbgL8=;
        b=nAgOKIA8Q/07trCFkqytt5deaL9MqZgIUL4BdpDInt4NJbwC8SZmRr1H8tZ/t72VjM
         I7bYmk+7I9y9ccZ5Dwfr85EOeRXaVFhF3nh69qMQe4v/i/EZutgV92mnheYCS25bDoH4
         iS0XXtC5uZ1C6uXwd5PzOMMedBTON2DjeLH3j/6UP+njarGWs6yWfk/S906VPh8CYS8B
         RlPPztf2BqKiktLIxNpLv3rLQ5N1Gu+XD/PpndkuapUK0sJzCCK53UangMzLgL8mcKA4
         cwPph9mOwblqZg9Cm7FhLejwpzdIFYgXMbJUedUI0Gd+nLuyB6+pOsumLqUSVfQ6EMSx
         EPNg==
X-Gm-Message-State: AOAM530mRkHp4TwEQr0e5tZfvs9ptg2nb1sBNpl2GENNzYMnZq0R66IM
        yByYPRgxb3p+DIbaMlKc7h24CDb6HUDqpQ==
X-Google-Smtp-Source: ABdhPJw5HKUI81tw5m/0l/DqNnEO9WRYb40RU35yaAfSogO9M7lrh+hj/MSgk6GkB0O17/qcAv9D8g==
X-Received: by 2002:a62:c301:0:b029:1ed:c3d5:54d6 with SMTP id v1-20020a62c3010000b02901edc3d554d6mr4861760pfg.18.1615416254753;
        Wed, 10 Mar 2021 14:44:14 -0800 (PST)
Received: from localhost.localdomain ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id j23sm475783pfn.94.2021.03.10.14.44.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 14:44:14 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 10/27] io-wq: warn on creating manager while exiting
Date:   Wed, 10 Mar 2021 15:43:41 -0700
Message-Id: <20210310224358.1494503-11-axboe@kernel.dk>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210310224358.1494503-1-axboe@kernel.dk>
References: <20210310224358.1494503-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

Add a simple warning making sure that nobody tries to create a new
manager while we're under IO_WQ_BIT_EXIT. That can potentially happen
due to racy work submission after final put.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io-wq.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 1bfdb86336e4..1ab9324e602f 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -774,6 +774,8 @@ static int io_wq_fork_manager(struct io_wq *wq)
 	if (wq->manager)
 		return 0;
 
+	WARN_ON_ONCE(test_bit(IO_WQ_BIT_EXIT, &wq->state));
+
 	init_completion(&wq->worker_done);
 	atomic_set(&wq->worker_refs, 1);
 	tsk = create_io_thread(io_wq_manager, wq, NUMA_NO_NODE);
-- 
2.30.2

