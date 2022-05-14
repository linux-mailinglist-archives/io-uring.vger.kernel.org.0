Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EBA552720C
	for <lists+io-uring@lfdr.de>; Sat, 14 May 2022 16:35:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233331AbiENOfW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 14 May 2022 10:35:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233346AbiENOfU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 14 May 2022 10:35:20 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 987331FCEE
        for <io-uring@vger.kernel.org>; Sat, 14 May 2022 07:35:19 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id d22so10514677plr.9
        for <io-uring@vger.kernel.org>; Sat, 14 May 2022 07:35:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qdGAXSdby4zffm1iNWyctAoBMUKn7tqhTgOmt6ZtLYk=;
        b=NzTwuHZ2sltYPrY7Qa550g1DAGQv/5Hn6ISNjvELJR86t3dDlNYstvSYiA1sazmS5Y
         MwrHa+DfuslIaHzAing8DbDqh/yeApfM+RYlPJHve8EsTjt5qGvTwwLlhRnBcWPPX0dl
         F1gIZZJ1D2Y4p1DDASSoMqP1V8jwcf+Wpbiv9m8AveYMwqpG/8C2mc59aI8tlBvVb//A
         qsckKHCcyZzFfFSXn2cr3rlfRpkZQpC2I3YtZrgMO4vJHCt4myJyStJHvA6Zz1ayo4dx
         IbqEukDYSQO8E250abKgoGoPOAVUI8gXIq2wLWoNOaFqpktPHGzcI/1NXz45P+KsRz7g
         oqBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qdGAXSdby4zffm1iNWyctAoBMUKn7tqhTgOmt6ZtLYk=;
        b=JKH9xsjmsGkeraTwM/qHA+JyldWTD/B1fJv8G+eYvheQx4CLYmDmSJmJHqrwIQCMmu
         OcHMLTV0o90KVRj0rYs7kmvDCfQbphTODOxPLmim00nBS44/9QyMw1jzJ6fdozOYo14d
         7gRVzuGFN+28t4NyDSJLR6YultbKidK4b35vhfCUbq1wG09ZgjWV5atEQ8chw0piHHQ8
         wT7TlkkVfOAl2+K4MyEX4zgiip2k6iiZd/buhBqmnOC+yREmTBdW2J+tpfmjuSusaMfY
         lKanSf/Sr3CeWwwR398yEOHcbR9QEaKxvVKyfhtcnTdpAJ613Y7fnlES/wjqzn/6W7Zx
         pAqw==
X-Gm-Message-State: AOAM532CzRiYmT0ByTWr8njKnJXrZTPMMddDnrjJxKtrpzjkZb2pLCuy
        /toeTcMH45rUNIBKru8ifT4rFeEY40PgxNi5
X-Google-Smtp-Source: ABdhPJz9rBnbg+grWSToFpBPnqVnBcB09bDj7Ez9qUqXVrsmOVmpDlrZkq8f1xnZJCCeiJBttooQlw==
X-Received: by 2002:a17:90b:1001:b0:1d8:4978:c7d5 with SMTP id gm1-20020a17090b100100b001d84978c7d5mr10219920pjb.167.1652538919064;
        Sat, 14 May 2022 07:35:19 -0700 (PDT)
Received: from HOWEYXU-MB0.tencent.com ([203.205.141.20])
        by smtp.gmail.com with ESMTPSA id j13-20020a170902c3cd00b0015ea95948ebsm3762179plj.134.2022.05.14.07.35.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 14 May 2022 07:35:18 -0700 (PDT)
From:   Hao Xu <haoxu.linux@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 1/6] test/accept.c: close the listen fd at the end of the test
Date:   Sat, 14 May 2022 22:35:29 +0800
Message-Id: <20220514143534.59162-2-haoxu.linux@gmail.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220514143534.59162-1-haoxu.linux@gmail.com>
References: <20220514143534.59162-1-haoxu.linux@gmail.com>
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

From: Hao Xu <howeyxu@tencent.com>

Close the listen fd when it goes to the end, otherwise it may causes
issues for the next tests

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 test/accept.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/test/accept.c b/test/accept.c
index c591e761b43b..a0f4a13f5975 100644
--- a/test/accept.c
+++ b/test/accept.c
@@ -425,9 +425,11 @@ static int test_accept_cancel(unsigned usecs, unsigned int nr)
 	}
 
 	io_uring_queue_exit(&m_io_uring);
+	close(fd);
 	return 0;
 err:
 	io_uring_queue_exit(&m_io_uring);
+	close(fd);
 	return 1;
 }
 
-- 
2.36.0

