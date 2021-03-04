Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C5A532C999
	for <lists+io-uring@lfdr.de>; Thu,  4 Mar 2021 02:19:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231893AbhCDBJ5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 3 Mar 2021 20:09:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348570AbhCDAbi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 3 Mar 2021 19:31:38 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D64AC0613B6
        for <io-uring@vger.kernel.org>; Wed,  3 Mar 2021 16:27:10 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id ba1so15068281plb.1
        for <io-uring@vger.kernel.org>; Wed, 03 Mar 2021 16:27:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=h+4EutnHIq5OGGuXo0Sb205EKv6pcfjm7AKrSAdrd+4=;
        b=vzWfTnNjqRxvhOnz9VSfypVjZfeWJ5rbHJxpf+nFEu/iXqV8jzpTJx1rW3jJnyb9z9
         GywI6GhE117EZJCTdw4JvZBvwiKZNgYDzA8pAyWqLoVzB3/hEEfopu3JqG3tp9tB8Xm7
         /we9g5g+JVNle3KbclKWf2Ua31cqzKYMVtSX0CAhFP1OnCehnajNyF4n2DltJQsP4HH4
         TYZTcN1n0ZHIkxsLTPlxiLWaMbMf1TYTpyI1xEH2gmpOBOtvYPCmndbrtIEmV2Yj8aic
         moAq/k9a3gmOHT3L1TS33A8M2lrKFCRYeEGI5xScGzEMb2MiI5OB76jRhWqlZO+Vn3to
         FfKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=h+4EutnHIq5OGGuXo0Sb205EKv6pcfjm7AKrSAdrd+4=;
        b=Ds7Oa5hWxyA8rZ65jZM4AuFXeaihTyrtkhqbbPDB1rrFGW2TLrusp0g3xAm09iRs3w
         ISgrbgEj2qzGAPCoJvr3ExmJOhv3QyGLfT+KtjL7gUljV4ufsE099uJngQNY9CZiWNLw
         Y4ydsYKHD265BTbKJGitmz/l1yGRXZU7UCOfBVbq6uhf7vjk6GP87rrN7++JBLyg8pdr
         9rn1+5p3z4+sn6QzYPgGINbarsrA6Yv/hwmXdSnXxOZWxBcEFDL9CCA7IyXMeocr7di1
         hPTCmTmXhbdCJ/Y7/Opcz2hVhI/MugpV4RtL75fLlbSt2goy+aRXDbbRi0B35/owrlmg
         5hdQ==
X-Gm-Message-State: AOAM530z1NPswMyhIvRIcdHPQd3glXY7HzjGEYBZopLqqzNkDjwu1zaQ
        3m4jgJw5IOPaJzCd3MnKW3YEHxNuFz5Ap5Yf
X-Google-Smtp-Source: ABdhPJxwnB51BebuoBzlQx5Z3/jnE12AMkO5I+NdhGV9ReVuBIywMsmclLKv0TknEcYA4n3+zZUemA==
X-Received: by 2002:a17:902:f68a:b029:e5:b17f:9154 with SMTP id l10-20020a170902f68ab02900e5b17f9154mr1497922plg.28.1614817629329;
        Wed, 03 Mar 2021 16:27:09 -0800 (PST)
Received: from localhost.localdomain ([2600:380:7540:52b5:3f01:150c:3b2:bf47])
        by smtp.gmail.com with ESMTPSA id b6sm23456983pgt.69.2021.03.03.16.27.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 16:27:09 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 03/33] io-wq: don't ask for a new worker if we're exiting
Date:   Wed,  3 Mar 2021 17:26:30 -0700
Message-Id: <20210304002700.374417-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210304002700.374417-1-axboe@kernel.dk>
References: <20210304002700.374417-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If we're in the process of shutting down the async context, then don't
create new workers if we already have at least the fixed one.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io-wq.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index a61f867f98f4..d2b55ac817ef 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -673,6 +673,8 @@ static inline bool io_wqe_need_worker(struct io_wqe *wqe, int index)
 {
 	struct io_wqe_acct *acct = &wqe->acct[index];
 
+	if (acct->nr_workers && test_bit(IO_WQ_BIT_EXIT, &wqe->wq->state))
+		return false;
 	/* if we have available workers or no work, no need */
 	if (!hlist_nulls_empty(&wqe->free_list) || !io_wqe_run_queue(wqe))
 		return false;
-- 
2.30.1

