Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A91A633F584
	for <lists+io-uring@lfdr.de>; Wed, 17 Mar 2021 17:30:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232387AbhCQQaP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 17 Mar 2021 12:30:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232547AbhCQQ3r (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 17 Mar 2021 12:29:47 -0400
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9750C06175F
        for <io-uring@vger.kernel.org>; Wed, 17 Mar 2021 09:29:46 -0700 (PDT)
Received: by mail-il1-x12a.google.com with SMTP id c17so2070660ilj.7
        for <io-uring@vger.kernel.org>; Wed, 17 Mar 2021 09:29:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PCA7N2X5Raq2d3LtcNMpsViy+1JDTW63F75baHR4QzQ=;
        b=Mf7u82YG76iAGEAN2Dml4c6cXKc5pl7Ng1E25vwtPB9KjFx5e+47ox4xnGgpJonfuj
         UDh5Hq7V5SqNV73WPbjh+CWOw86bLZ8PY3kNeOp0Zikc5Y2WxTG5jqkP/SeBYXBUpEUP
         Zivw9DmdoW2ABhKhECWLMiIjHvaCyeqiiCo88PJ7TnD4DkQINim0tK9wRW61SvaeNAIe
         60PRVfuOw6bfy4D1uXtjt0XDwFlgAuDSbSu6hRknlQ6/8Va2IL0M1crDVsnNVPPHzRfG
         ukxLUHjcUH7WAcsl1hos3G6G1gaSUUKNWgI9doqh1raur6dJidA4O5jBod8937bjsvXe
         fT3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PCA7N2X5Raq2d3LtcNMpsViy+1JDTW63F75baHR4QzQ=;
        b=ithfOZ5o0vB29mze0a+eemJuyrRejbxvUbwoHbPpsNLaFbH/yjb8o3hq3pPlsXoG3x
         OAZnyG9jf+AobOA7xCRBppPxLAjeHW2KsboshcnjhAO2nToub/5Cbb0LqFbAgrjhOS9X
         9zkfsTO8TWGmmaPbXhCAyv1HwfkBGa19poplMccdh0xrdb35M+BR+0JyTOEERC5m/jVj
         ACmhYh8tQjpGAHE6l7QPQJwbxvI7ChQHUjGjcOTe7KwHSAl6gR6EZprU6WgBa1lYvok2
         49t3bhNNO7puiJO2wzl8xpp+pa1FuofIIWGjCruI6UMTOpdchuAD2SWRUpSB6IswPXAu
         i0ag==
X-Gm-Message-State: AOAM531rXtjNIbesJCBS7nfqY9p7vvb6qd9S3DWrsy9381SsOPMHdZ61
        hV98tYE1bs+uLjY4tfqe9NKMvRTPDUnKOg==
X-Google-Smtp-Source: ABdhPJy49z6su/Avas5cTt7VXqppfAXlr6zpwsq86O9tB2Jbte+1oNM5NPwd9ubtRmik1VdxUMmL8g==
X-Received: by 2002:a92:d604:: with SMTP id w4mr8287304ilm.11.1615998586147;
        Wed, 17 Mar 2021 09:29:46 -0700 (PDT)
Received: from p1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id h1sm11164271ilo.64.2021.03.17.09.29.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 09:29:45 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/9] io_uring: correct comment on poll vs iopoll
Date:   Wed, 17 Mar 2021 10:29:35 -0600
Message-Id: <20210317162943.173837-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210317162943.173837-1-axboe@kernel.dk>
References: <20210317162943.173837-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The correct function is io_iopoll_complete(), which deals with completions
of IOPOLL requests, not io_poll_complete().

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5538568f24e9..4aa93dfa3186 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2559,7 +2559,7 @@ static void io_complete_rw_iopoll(struct kiocb *kiocb, long res, long res2)
 		req_set_fail_links(req);
 
 	WRITE_ONCE(req->result, res);
-	/* order with io_poll_complete() checking ->result */
+	/* order with io_iopoll_complete() checking ->result */
 	smp_wmb();
 	WRITE_ONCE(req->iopoll_completed, 1);
 }
-- 
2.31.0

