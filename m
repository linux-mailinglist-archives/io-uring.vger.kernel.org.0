Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2645D38F67A
	for <lists+io-uring@lfdr.de>; Tue, 25 May 2021 01:51:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229540AbhEXXxB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 May 2021 19:53:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbhEXXxA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 May 2021 19:53:00 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B0D9C061756
        for <io-uring@vger.kernel.org>; Mon, 24 May 2021 16:51:31 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id i17so30180653wrq.11
        for <io-uring@vger.kernel.org>; Mon, 24 May 2021 16:51:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=c/QKuJN5Jm97QWE7aEbrVa5PnDbSM3MSddQL4qcekgE=;
        b=pqdoMY8CQ/ftWtLpca2yaLOltFKybJkUD07roamEIcEe26qliTXYQueIGaFypWpcqF
         Ww3iuPn5crDoqkgygPc5EMSbRTzTVkr3R1iKEiTHGKn6bvX39YI74KVNbTpJne4RFeae
         MqRIoR4zYg+0blSHE5kiKaeX+CEZKdTaImtxct5wX3cV5r6PiLkB1qUnVCocVPwz97+o
         vcLcrCF2n8o7CJP+t+rxEvjqwb+5y3M6vRbXsqkDkpTk9nOBmeXqGr10IAbi7NbqeFcF
         mGGfr+u2QxfoWAblyFIWlHAWE+pZqNywjAtWzbw0B1uNu1l42FNlLBC3r5nbbzaCfE5Z
         Zkpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=c/QKuJN5Jm97QWE7aEbrVa5PnDbSM3MSddQL4qcekgE=;
        b=Z6F0v9ULvNr+A0SWStqIVc1mfBh6EvXFnri4K0uofm85ChBwQ+gg+gJphOLquTsPAo
         apSV6L2p9Mf313WphqAgYpe3Ld8hhSJfVOOj7n1yPlrEOU6t1qsaPueLJ1Us1PMI6C7M
         Eo1DmvkKnBQJXBp6zaJGBNzV4e0UmFBqqrnXpjt4gqCOxk5DBh4qEY90qOXIfxJNssoe
         YsSnERwyZKfwo2bZLqKYOoIezfOpMKFJGfJiLNhGMm/zYdQcQOAO+1tWK9uFDlVsQAwT
         Ax/FV5dIFHyRZqedxQiflomtl+NEjyDQGysqdvWriC38QSYvAykh6Ug2xlQ5lHgYTNQz
         oZ2g==
X-Gm-Message-State: AOAM533f4+O0Xa4GaDKuKRlq/2nCmOkeEzuSW0oMiKAdJLUgCIsIPoDc
        rJNSuMDh6xjKB5JRJbprIVA4tROWf4e+eCbO
X-Google-Smtp-Source: ABdhPJzVTHsUS2vBrYGX2wncRjavyAcsqttmk2ezrAlLmV2uS0iJSds5RVHtli1ecAcwINarDbMk0w==
X-Received: by 2002:adf:db4e:: with SMTP id f14mr23925950wrj.48.1621900289546;
        Mon, 24 May 2021 16:51:29 -0700 (PDT)
Received: from localhost.localdomain ([85.255.235.116])
        by smtp.gmail.com with ESMTPSA id f7sm8961069wmq.30.2021.05.24.16.51.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 16:51:29 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 01/13] io-wq: embed wqe ptr array into struct io_wq
Date:   Tue, 25 May 2021 00:51:00 +0100
Message-Id: <9c47df759e2fadc2ab12e4fb789223f577a3a772.1621899872.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1621899872.git.asml.silence@gmail.com>
References: <cover.1621899872.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io-wq keeps an array of pointers to struct io_wqe, allocate this array
as a part of struct io-wq, it's easier to code and saves an extra
indirection for nearly each io-wq call.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io-wq.c | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index de9b7ba3ba01..961c4dbf1220 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -102,7 +102,6 @@ struct io_wqe {
  * Per io_wq state
   */
 struct io_wq {
-	struct io_wqe **wqes;
 	unsigned long state;
 
 	free_work_fn *free_work;
@@ -118,6 +117,8 @@ struct io_wq {
 	struct hlist_node cpuhp_node;
 
 	struct task_struct *task;
+
+	struct io_wqe *wqes[];
 };
 
 static enum cpuhp_state io_wq_online;
@@ -907,17 +908,12 @@ struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
 	if (WARN_ON_ONCE(!data->free_work || !data->do_work))
 		return ERR_PTR(-EINVAL);
 
-	wq = kzalloc(sizeof(*wq), GFP_KERNEL);
+	wq = kzalloc(struct_size(wq, wqes, nr_node_ids), GFP_KERNEL);
 	if (!wq)
 		return ERR_PTR(-ENOMEM);
-
-	wq->wqes = kcalloc(nr_node_ids, sizeof(struct io_wqe *), GFP_KERNEL);
-	if (!wq->wqes)
-		goto err_wq;
-
 	ret = cpuhp_state_add_instance_nocalls(io_wq_online, &wq->cpuhp_node);
 	if (ret)
-		goto err_wqes;
+		goto err_wq;
 
 	refcount_inc(&data->hash->refs);
 	wq->hash = data->hash;
@@ -962,8 +958,6 @@ struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
 	cpuhp_state_remove_instance_nocalls(io_wq_online, &wq->cpuhp_node);
 	for_each_node(node)
 		kfree(wq->wqes[node]);
-err_wqes:
-	kfree(wq->wqes);
 err_wq:
 	kfree(wq);
 	return ERR_PTR(ret);
@@ -1033,7 +1027,6 @@ static void io_wq_destroy(struct io_wq *wq)
 		kfree(wqe);
 	}
 	io_wq_put_hash(wq->hash);
-	kfree(wq->wqes);
 	kfree(wq);
 }
 
-- 
2.31.1

