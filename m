Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9FBF4E7277
	for <lists+io-uring@lfdr.de>; Fri, 25 Mar 2022 12:53:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233824AbiCYLzH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 25 Mar 2022 07:55:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357532AbiCYLzA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 25 Mar 2022 07:55:00 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3538EBC99
        for <io-uring@vger.kernel.org>; Fri, 25 Mar 2022 04:53:27 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id r13so14849713ejd.5
        for <io-uring@vger.kernel.org>; Fri, 25 Mar 2022 04:53:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Dn+AH4T/IvR5Xa5cSsVfZCoN6izXppvoWmPY9yJt34U=;
        b=KITJBLgFZ8dZQHM14VaLgw7WywIvNFYx5wVj+rmSxd5sUuini8dLQ30udaUVSvNEJz
         kYJRHfTmUe8ChOqR9I1423S/L9m5f9c13cVa9/DjHeltfV7hB80WB7URcQJZEzqNoz7V
         o5Ed51LhqzcH6ds3NfS1GV/D54XBrNne8VH8E9HyfQtHHoKn7V/Bk/SN//Ouf/9UbCvE
         1S43eHgS22zjt2b7hxNq6Cus3RkbbNBIpzqFoy8R9rvcgKwSV0tFA/v1D2i7nIcw30hU
         O8T69iyYC6dbGCwnV59Lgpqb81yyJFS8JmwGvU/WU7rsNF2y0tFSqThVFx5ozBNXnE6l
         ueIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Dn+AH4T/IvR5Xa5cSsVfZCoN6izXppvoWmPY9yJt34U=;
        b=uh8VVbpuzp7WCjIzJSy40M56ZCZyU9BaI92zmJ0R53FL8dDiNr47qeU2evM54EUN19
         jZlu4MaWe0C/h/Mx1m2cN/vlJCDb470ZD79m0otwIRxZtf9juEHscEwFhqF6gN4Sddq4
         99iCzllqWAAm4SW3zelv8iwWIuBf0APk9rSHTEOWTicDV5Ap42ZbOV7CNf2MHSzfU0DY
         QBjjibSwLvlzuE0YfnrjCo+HFO4q+RxLkFrv0L8G1qc7SyA0L3bmPSfZqr/7WOJ1lylS
         2m9DDme4JVBlOWQh++OfaZZOdFHybEKsfptwRFJ8RISK0YMPWYj8kIboC4nifs2tAn2Q
         dMNQ==
X-Gm-Message-State: AOAM5338jjsDIKoym6UgGz6ywcGrRSuGQme8oCX2gAUifbFgKwcPBsLA
        qJviM7K0jfC7KRcjhY8v/3ni0BmmAwoeaw==
X-Google-Smtp-Source: ABdhPJzWE2Rfxb4DDFUt+WynDHVHUubEdzJ/LdWPFnS+Ur8+h5lmyMnDbe3Wxp9a8Tn4wHPSVruZ3Q==
X-Received: by 2002:a17:906:be1:b0:6ce:c3c8:b4b6 with SMTP id z1-20020a1709060be100b006cec3c8b4b6mr11011756ejg.617.1648209205633;
        Fri, 25 Mar 2022 04:53:25 -0700 (PDT)
Received: from 127.0.0.1localhost ([78.179.227.119])
        by smtp.gmail.com with ESMTPSA id u4-20020aa7db84000000b004136c2c357csm2706777edt.70.2022.03.25.04.53.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Mar 2022 04:53:25 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 3/5] io_uring: silence io_for_each_link() warning
Date:   Fri, 25 Mar 2022 11:52:16 +0000
Message-Id: <f0de77b0b0f8309554ba6fba34327b7813bcc3ff.1648209006.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1648209006.git.asml.silence@gmail.com>
References: <cover.1648209006.git.asml.silence@gmail.com>
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

Some tooling keep complaining about self assignment in
io_for_each_link(), the code is correct but still let's workaround it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index b868c7c85a94..e651a0bb00fe 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7057,9 +7057,10 @@ static int io_req_prep_async(struct io_kiocb *req)
 static u32 io_get_sequence(struct io_kiocb *req)
 {
 	u32 seq = req->ctx->cached_sq_head;
+	struct io_kiocb *cur;
 
 	/* need original cached_sq_head, but it was increased for each req */
-	io_for_each_link(req, req)
+	io_for_each_link(cur, req)
 		seq--;
 	return seq;
 }
-- 
2.35.1

