Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0E4529CD27
	for <lists+io-uring@lfdr.de>; Wed, 28 Oct 2020 02:47:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726127AbgJ1Bif (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 27 Oct 2020 21:38:35 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:33833 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1833007AbgJ0X2s (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 27 Oct 2020 19:28:48 -0400
Received: by mail-wr1-f66.google.com with SMTP id i1so3770950wro.1
        for <io-uring@vger.kernel.org>; Tue, 27 Oct 2020 16:28:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=L6eSCPG6vRHu6NGNBlsUyBbOII3JqJwfhehdvXTugPc=;
        b=V9x+eZC8MUrKecZTlIEMHyt7QrmTBHphAiuTJBJm6CXqV7lLikMwMfeD/nrSKqyTDg
         tOlO5GJLIkH6JwzQogzafMgH2o/uhAW9YExZwnL7A3KcTzepdb66E7X2NC1UPAtdRZFb
         6Y31m+ceDeWecGRLM34bJjcveVutnAppa2ByiGjKMds4pXfnmYGtiMD+IwgJKrDjxGxM
         JyDVlrlocH8bqjCs+Y8vAwKLTBFZG/YibVbyvGGN4XOCgX2ZQl+uLpk48wGkafkMmqaQ
         EvNYe7Y+WQphDp5jdLjJ7NfMwqyTov6S4bJWklIIXbzg1FxUztWy4bLINhQTnguTnhm8
         ekHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=L6eSCPG6vRHu6NGNBlsUyBbOII3JqJwfhehdvXTugPc=;
        b=LvHdAUFAh8XeASk+n8d5z/0bZJF0S5z2FDJbN7wI6EWbd8Wip7GKW9BtAV3bIJ6zLq
         UEjKZayZlqPy39KvNNeQjL8HNNuz8IpfNkuwQL4PNK4yDTi0ySveV171Pu/aJS7V774h
         4+DDH74NVvkyUs8Tq8UTYmVNkzt2v84e1SsDzsw2WEJaxQ5KFH3VQ7aioGmkRGV6vgrs
         KFqHqkwovBVPLCGwzDFsThlechV+OFrBErySWsc29DJwCvi5VKYDykuDcBttH+fduYnQ
         8366yLKEpNTDgW4smXmcnCEAqQ0CShVo2RES75kEpu33O8+hzDXW8Yv41sNatoxVCceu
         Ewkw==
X-Gm-Message-State: AOAM531lAC7A8GnQhEMgkbAYpvEsyckUH5+9tDGBBeZGS4N26Rgnr1UC
        CN3hGIkm4WR4TTG8veuAkp+is3URSoVBMw==
X-Google-Smtp-Source: ABdhPJyqklZiEm2f7TOlzZy5/vQmrkjvr8/WwgC67GzguUbX6tQiJP/dA+nAqADThxgluYUyATkrVw==
X-Received: by 2002:a5d:448b:: with SMTP id j11mr5337691wrq.129.1603841324792;
        Tue, 27 Oct 2020 16:28:44 -0700 (PDT)
Received: from localhost.localdomain (host109-152-100-164.range109-152.btcentralplus.com. [109.152.100.164])
        by smtp.gmail.com with ESMTPSA id a15sm4336990wrp.90.2020.10.27.16.28.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2020 16:28:44 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 4/4] io_uring: toss io_kiocb fields for better caching
Date:   Tue, 27 Oct 2020 23:25:38 +0000
Message-Id: <3433e27c9d3222522225a9c698ef71785d449f6d.1603840701.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1603840701.git.asml.silence@gmail.com>
References: <cover.1603840701.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We've got extra 8 bytes in the 2nd cacheline, put ->fixed_file_refs
there, so inline execution path mostly doesn't touch the 3rd cacheline
for fixed_file requests as well.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index b8b5131dd017..4298396028cc 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -687,14 +687,13 @@ struct io_kiocb {
 	u64				user_data;
 
 	struct io_kiocb			*link;
+	struct percpu_ref		*fixed_file_refs;
 
 	/*
 	 * 1. used with ctx->iopoll_list with reads/writes
 	 * 2. to track reqs with ->files (see io_op_def::file_table)
 	 */
 	struct list_head		inflight_entry;
-
-	struct percpu_ref		*fixed_file_refs;
 	struct callback_head		task_work;
 	/* for polled requests, i.e. IORING_OP_POLL_ADD and async armed poll */
 	struct hlist_node		hash_node;
-- 
2.24.0

