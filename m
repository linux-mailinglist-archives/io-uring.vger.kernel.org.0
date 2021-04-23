Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DEC93689B1
	for <lists+io-uring@lfdr.de>; Fri, 23 Apr 2021 02:19:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231605AbhDWAUT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 22 Apr 2021 20:20:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235977AbhDWAUS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 22 Apr 2021 20:20:18 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37C4FC061574
        for <io-uring@vger.kernel.org>; Thu, 22 Apr 2021 17:19:41 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id c15so37605095wro.13
        for <io-uring@vger.kernel.org>; Thu, 22 Apr 2021 17:19:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=khza0+emDH/8SGke3kG+FG/pDGPnQ2DdXv9AOpxij7M=;
        b=WWIPuo1WXOZLdQb4UmmsUsN+DxrF9Mm2JTKFUdejcHLJ2EBDnflfkkida0b7DG0Le7
         qqi52tEnMLsUXIBp8YS9/uQ/gSeJrrbnR+sXJwljelCGUf6KUENg0XRJSUH/NM17iCsm
         Dl4/7a6N167xBScqnkvUHcTxDhsJo1NBXFUdHet114E4THVsZN4vlKGaoE4DFFTR08qI
         //KiXFtuxGRtuHQow98LTwnGVEqkdPE6/SGuwLYDyNr0ZNjSklUc04R7I4ceO2IlWkvo
         hanWwZeQrSTc8js2wbYLqjpUxLoJdiM7lSG1b70td86QKxkyRHQ6AG8Z1y/baNilhdyU
         HBuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=khza0+emDH/8SGke3kG+FG/pDGPnQ2DdXv9AOpxij7M=;
        b=FUFLzCyetAH3wRJVixdVtN+qTxMxM+B+r2+ekT7krtcpVVVh4ZuzIwt7xrD3O1XfoC
         gmmqtlZO6o6hGO+er6LCxRHt5YAlnxDjfulbZNEfjqAMWQYzKx02GXQ3nutDROoTcr9F
         IakmBIjzr7+gwmZPwXSB0ccyQmO+iHaBjc/0ha0RF7lfqtBkmKvSCb5wN/wQ3RzOOPnJ
         BOiRLFom2NufG1khBuLUbwzPfAmimUl6OAmdKdNQoPyGjKUU1U7o+/lU5SC9IfpWDrSF
         5K2cAFNVu+UWGTBomlbXcsP6Japzqok2ovbFws+nfr5Djwp5htxHWwKaojeJ1DLMdB58
         2/kg==
X-Gm-Message-State: AOAM532mVeHt6hvKj497mVeXs28XG6Pfp+N2nxWp0OT5k5UndAmkVKDH
        0ySHu1K0J+Tv9n7rJhNVgNI=
X-Google-Smtp-Source: ABdhPJyq2CrMAlNw8Y4RbB/dNDeIipitwO49QsPQqBFM2IVlEuXiVfudbC5+rc6nRx+PbV2DSvKTkw==
X-Received: by 2002:a5d:4a8b:: with SMTP id o11mr1026756wrq.233.1619137180079;
        Thu, 22 Apr 2021 17:19:40 -0700 (PDT)
Received: from localhost.localdomain ([148.252.128.225])
        by smtp.gmail.com with ESMTPSA id g12sm6369605wru.47.2021.04.22.17.19.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 17:19:39 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 02/11] io_uring: return back rsrc data free helper
Date:   Fri, 23 Apr 2021 01:19:19 +0100
Message-Id: <562d1d53b5ff184f15b8949a63d76ef19c4ba9ec.1619128798.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1619128798.git.asml.silence@gmail.com>
References: <cover.1619128798.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add io_rsrc_data_free() helper for destroying rsrc_data, easier for
search and the function will get more stuff to destroy shortly.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 70e331349213..a1f89340e844 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7109,6 +7109,11 @@ static int io_rsrc_ref_quiesce(struct io_rsrc_data *data, struct io_ring_ctx *ct
 	return ret;
 }
 
+static void io_rsrc_data_free(struct io_rsrc_data *data)
+{
+	kfree(data);
+}
+
 static struct io_rsrc_data *io_rsrc_data_alloc(struct io_ring_ctx *ctx,
 					       rsrc_put_fn *do_put)
 {
@@ -7147,7 +7152,7 @@ static void __io_sqe_files_unregister(struct io_ring_ctx *ctx)
 	}
 #endif
 	io_free_file_tables(&ctx->file_table, ctx->nr_user_files);
-	kfree(ctx->file_data);
+	io_rsrc_data_free(ctx->file_data);
 	ctx->file_data = NULL;
 	ctx->nr_user_files = 0;
 }
@@ -7624,7 +7629,7 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 	io_free_file_tables(&ctx->file_table, nr_args);
 	ctx->nr_user_files = 0;
 out_free:
-	kfree(ctx->file_data);
+	io_rsrc_data_free(ctx->file_data);
 	ctx->file_data = NULL;
 	return ret;
 }
-- 
2.31.1

