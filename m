Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30EEF3EF514
	for <lists+io-uring@lfdr.de>; Tue, 17 Aug 2021 23:37:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234753AbhHQVh5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 17 Aug 2021 17:37:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231630AbhHQVhy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 17 Aug 2021 17:37:54 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5BA7C061764
        for <io-uring@vger.kernel.org>; Tue, 17 Aug 2021 14:37:20 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id r7so251492wrs.0
        for <io-uring@vger.kernel.org>; Tue, 17 Aug 2021 14:37:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DcEN+HqGDOK/WXAJ1DXyrWlR120dUHQQM8Ql1ldB96w=;
        b=ANcGyJ0NLuDxXf3tSl/+iPJE5ShDl7BtWS7hwE9xjK9U7jUcbs6pYyjTRYtubsG5od
         Gul4ULiqSYtW9662xXXwx/Rh9yXO9kLCUJBPgyyweVdWDiG3qSBaLZN3VojIXzJ4uhtj
         lljlnuCDZqGz3NIxgf9+A9YKu41c1U2725tPF8/KwgmiWLDOybkI6nDhhltJTZHU3z5n
         pSekoiiK5+9za1Rvknhwhcft+wcUQCqJVG89PBR9cqIdw1aC/BBFISOA11ZJk12Fh/8j
         mgLePLJBgbUIl5DOhguDqnHzSspwR1Z+J7gdoCPgffrul7oOdr7N87Cvnrgg5Oq9DqiO
         a7+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DcEN+HqGDOK/WXAJ1DXyrWlR120dUHQQM8Ql1ldB96w=;
        b=DjB7mpOI0M8mxFEYo9zomN31gYPYx4OtuTErGJVRoEcN1mzb7h6MJSRcOn9Q9d2DtS
         Ulv9pdTMlKFfAgBVZb7I/vvj3Jfkd2P7xPkvnjOTjN7t5JuLSFCbjh5mTKS3WS3nb0mq
         2sc40CB3Es5t4MshFHvKOUFRMwerIaJwl3s+y7oNVEXO2hFhjwzVPZY4e84UZ0LgEUk8
         aw5XZYJA96emOY9OlI7eQQK7WaEoM3ZZVvDHNfQiDoNZsd6NPaKphwnsoosL6jn1C6VM
         /Fc70p/niC2We+ToWwde8/WaRKjYoB85eV5JheCkq1clE6pz1MqD1Ykw5tw+2e7MdIyE
         TCJw==
X-Gm-Message-State: AOAM5306ZeuTNotPP7HvvCQa9MtWY2NpRODj+i+0rlTszTPw0DwlLy6l
        Ln6Wm3qXN2Q2xwn4Q2I8RYs=
X-Google-Smtp-Source: ABdhPJwmdWYHaKBjUGL4R4Utxz4b6u5gce0bMD6nPyE2V2dAMo0PXvqeKOLnSi8HGds0u4TVXKakmw==
X-Received: by 2002:adf:ebd2:: with SMTP id v18mr6870033wrn.248.1629236239572;
        Tue, 17 Aug 2021 14:37:19 -0700 (PDT)
Received: from localhost.localdomain ([85.255.233.12])
        by smtp.gmail.com with ESMTPSA id e3sm3895521wrv.65.2021.08.17.14.37.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Aug 2021 14:37:19 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 5.14] io_uring: pin ctx on fallback execution
Date:   Tue, 17 Aug 2021 22:36:44 +0100
Message-Id: <833a494713d235ec144284a9bbfe418df4f6b61c.1629235576.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Pin ring in io_fallback_req_func() by briefly elevating ctx->refs in
case any task_work handler touches ctx after releasing a request.

Fixes: 9011bf9a13e3b ("io_uring: fix stuck fallback reqs")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---

p.s. I had been considering back then but don't remember why it was
dropped. Just be extra careful to not regress in 5.14

 fs/io_uring.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 6a092a534d2b..979941bcd15a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2477,8 +2477,10 @@ static void io_fallback_req_func(struct work_struct *work)
 	struct llist_node *node = llist_del_all(&ctx->fallback_llist);
 	struct io_kiocb *req, *tmp;
 
+	percpu_ref_get(&ctx->refs);
 	llist_for_each_entry_safe(req, tmp, node, io_task_work.fallback_node)
 		req->io_task_work.func(req);
+	percpu_ref_put(&ctx->refs);
 }
 
 static void __io_complete_rw(struct io_kiocb *req, long res, long res2,
-- 
2.32.0

