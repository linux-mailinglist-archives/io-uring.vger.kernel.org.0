Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6838C342351
	for <lists+io-uring@lfdr.de>; Fri, 19 Mar 2021 18:27:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229996AbhCSR1I (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Mar 2021 13:27:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230218AbhCSR1B (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Mar 2021 13:27:01 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3766CC06174A
        for <io-uring@vger.kernel.org>; Fri, 19 Mar 2021 10:27:01 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id x16so9881589wrn.4
        for <io-uring@vger.kernel.org>; Fri, 19 Mar 2021 10:27:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=ZjVPKVX/Ar+ubzvOPQ2YN2v9vb2yryPgpOH19vNh6aI=;
        b=tHgKQ//J9ICkqIQofs4usxf5iffujprDQ6NJ6B3hhUWTzc8AQ/Xww1TWt+WWbIMY9v
         UmKlYBjljiSb5Tcon98aFppNm9QXjXzUvlAHJ7sjPpVpsOtNS3rFtq46jkFQnfei9iQ0
         f5urDxiuq5tEqrlPP0rsfEXZrSQP5Nz6fjQTJQVaGhHtP10zzAiPfaiomaKFla/I1FQq
         Q6TsjmnH9eJ4voqqO+U5LrHgk2z7+zrAYzI8/A6aaktUDMHNeez+tzPEgv6BPJm4nVUY
         BnNHoudMus2FvfV5RkVKEgwlxcTEdQxeheWh9d2dbiDN5zsaMdDox1EFppWXC3c1dh0+
         gddg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZjVPKVX/Ar+ubzvOPQ2YN2v9vb2yryPgpOH19vNh6aI=;
        b=nx8dC9mivMpLD0ZBPrGlbptDWIdkb1p0LE7F1JuerFI+84w0GYMdLfclSjHvN2pajD
         UjilQfM2h1Hn/ZIdrfQ2iK6bkoDMNpv4CXHHgC7WQgfliIXl97TcOnDu6rGRV7tKX+YL
         Mq8AzsNTUV0aWaKnZaPzQk8a5364LWzMoNWl+gTAMXC8IPmfW++Y/xU+3/2bgWXeYK5D
         yJ9YYhAEBEhM3zoOCF4OXj8fca25YReNiEp+1vYumvR8M6gofuoVywrUvnK4KNm28hJl
         cinWyRMzRW/UM4Gocw/8Iqz7WOfocDKQ2o2IqwcRagvon60c8I9aSp3dZuCVC0823FlZ
         Mduw==
X-Gm-Message-State: AOAM530VXwJcvOjL+E7URaLXZN48An+vM1lTF+RhqQHgt3wWGOUw4caD
        h1F3CTQrPjdYjFXT2Rw7OlpO9/UoS4/Odg==
X-Google-Smtp-Source: ABdhPJyMb24hgUJApfMKnpCCxIEFyaQqcwRzmeWt/yzHSWfl7l7YI7VH12EO9fNsfkKYAwqVrriAKQ==
X-Received: by 2002:adf:fbcc:: with SMTP id d12mr5565384wrs.151.1616174820068;
        Fri, 19 Mar 2021 10:27:00 -0700 (PDT)
Received: from localhost.localdomain ([148.252.133.195])
        by smtp.gmail.com with ESMTPSA id i8sm7112943wmi.6.2021.03.19.10.26.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Mar 2021 10:26:59 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 10/16] io_uring: refactor io_free_req_deferred()
Date:   Fri, 19 Mar 2021 17:22:38 +0000
Message-Id: <808f7eb6608d214137d38fcde3f5250def3d15a3.1616167719.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1616167719.git.asml.silence@gmail.com>
References: <cover.1616167719.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We don't care about ret value in io_free_req_deferred(), make the code a
bit more concise.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 10d0e3c6537c..d081ef54fb02 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2212,11 +2212,8 @@ static void io_put_req_deferred_cb(struct callback_head *cb)
 
 static void io_free_req_deferred(struct io_kiocb *req)
 {
-	int ret;
-
 	req->task_work.func = io_put_req_deferred_cb;
-	ret = io_req_task_work_add(req);
-	if (unlikely(ret))
+	if (unlikely(io_req_task_work_add(req)))
 		io_req_task_work_add_fallback(req, io_put_req_deferred_cb);
 }
 
-- 
2.24.0

