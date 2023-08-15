Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFEA677D12A
	for <lists+io-uring@lfdr.de>; Tue, 15 Aug 2023 19:34:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238908AbjHORdg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 15 Aug 2023 13:33:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238926AbjHORdW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 15 Aug 2023 13:33:22 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92BC01BDD
        for <io-uring@vger.kernel.org>; Tue, 15 Aug 2023 10:33:21 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id a640c23a62f3a-99d6d5054bcso1075501966b.1
        for <io-uring@vger.kernel.org>; Tue, 15 Aug 2023 10:33:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692120800; x=1692725600;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RiLtehMN9WT6sO8RFHE9JdGWLEysvvJYWKRAtymGPlA=;
        b=o/YFJuAYY9V81CQ/5UVni8MUEQ7yeMXeCSihqeEwRdd9R/5ykqBwuu40YVHELDCk0g
         nR2CqrcqAi0p6Wao/MnBkkkcWDHSUTmPhJZGbp/5EaEOtuEPcwIoNazJcdzzvxtAGCtv
         4twox8HdsIyF5kgtZ+/3GF8DPcTxfFg0PJVmtPqf3isMyiaRSuAXouJO9Olv93q2+rpJ
         Wcv+ePyNDRETP9wh6kUwNjb7axWbT83jdB8URFRhQezdbLgv5sA/L/oLPBHJOb+x0jO2
         V5FG0CYA7DaekU2VVQL1VmNi9RRYlPXs+CT6OkkA8oBHo23RWfnoTkReGcaAvbfcra4H
         +/iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692120800; x=1692725600;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RiLtehMN9WT6sO8RFHE9JdGWLEysvvJYWKRAtymGPlA=;
        b=VoxCjymwSgENeNavZibsQTDU8dvbR1JrxhvHtxd+uuf0AP1/HW9nhndqQUZY3jetMF
         bkdy+UR+OLhMJqifJlhbp+zKuILdmK92sqie1m1f80ieht0CBIEBG5S9GUiqmx8UG5/B
         oyW6ayDchU6+I5coBnEA9mwKyCUivgx9i8sIGaBimAdspjECyo/c4+cZYxstFqTSWAft
         HeqmLYljjOHu2dW6cP2YZcwasDR7G/Vf6H7POsTTOC33PsAhIOrNdo76BqIWzCNV5aso
         qhbok5BCbv41Nrozrfk9zDB/uqhjPMI04QCJsYkwG75Tl+JJtmL5WDgPQ2kaxMre7Dh5
         ayLw==
X-Gm-Message-State: AOJu0YzUa6kL9DDzNgdHQ/ygKwIETxuA4QPDIvPaVlPCo79emV4/wNjM
        4V9N2F2qq+ArFvmAVK2uVn4Xltdg63M=
X-Google-Smtp-Source: AGHT+IELz+jhyAzyNS7Y6zhqu8ogX+db2t0VUDByHfdRYuV+havxdiiWVlhPUZyJzz9gEWBwf23DMA==
X-Received: by 2002:a17:907:928e:b0:99c:572:c0e4 with SMTP id bw14-20020a170907928e00b0099c0572c0e4mr2668642ejc.7.1692120799713;
        Tue, 15 Aug 2023 10:33:19 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::2:6d35])
        by smtp.gmail.com with ESMTPSA id kk9-20020a170907766900b0099cc36c4681sm7269878ejc.157.2023.08.15.10.33.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Aug 2023 10:33:19 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 08/16] io_uring: compact SQ/CQ heads/tails
Date:   Tue, 15 Aug 2023 18:31:37 +0100
Message-ID: <5e3fade0f17f0357684536d77bc75e0028f2b62e.1692119257.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1692119257.git.asml.silence@gmail.com>
References: <cover.1692119257.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Queues heads and tails cache line aligned. That makes sq, cq taking 4
lines or 5 lines if we include the rest of struct io_rings (e.g.
sq_flags is frequently accessed).

Since modern io_uring is mostly single threaded, it doesn't make much
send to sread them as such, it wastes space and puts additional pressure
on caches. Put them all into a single line.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/io_uring_types.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index c0c03d8059df..608a8e80e881 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -69,8 +69,8 @@ struct io_uring_task {
 };
 
 struct io_uring {
-	u32 head ____cacheline_aligned_in_smp;
-	u32 tail ____cacheline_aligned_in_smp;
+	u32 head;
+	u32 tail;
 };
 
 /*
-- 
2.41.0

