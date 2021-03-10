Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09375334BD3
	for <lists+io-uring@lfdr.de>; Wed, 10 Mar 2021 23:45:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233905AbhCJWon (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 10 Mar 2021 17:44:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233941AbhCJWoW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 10 Mar 2021 17:44:22 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38A1BC061763
        for <io-uring@vger.kernel.org>; Wed, 10 Mar 2021 14:44:22 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id u18so9214385plc.12
        for <io-uring@vger.kernel.org>; Wed, 10 Mar 2021 14:44:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XOMAq/oxzmWsD5x+J1237ergaI5C/YWGcY56phEQ/fs=;
        b=BXUs06Jv//HRi/u6j2//wI2NkUiP+Sh0OQp60klBUol0i5vpSB9AxTGA5mYJaKH9l5
         2BYNH/S0wwFRp0XPUaBAOIBpKDpqlYEb9iSIQWjzD4aj7UJpf3voN/bO95dZHNKsmUjE
         5LE0kUCNqu2AGXpoH113jS2ovzEQX9vQr3Jr70jlZNltXdeYF/7Nux33q2Ki+Z2vRrWA
         ci71MOCmS4tcAi4GOogOpCevBSyB9p9hC/Tw704pkfxhUUAjd38vwlQzBR/ccmExD/E3
         6pPQuI3TFSX520izV8iLjCNKWU1CBAjGHKuinucW0qrbLm/pzS420RbuCXpJdYEcB1GA
         vIUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XOMAq/oxzmWsD5x+J1237ergaI5C/YWGcY56phEQ/fs=;
        b=PLCbFpiE4s+qEAgY6Ns/KoLoDt/n+lGMtYYIGRL2rgmzcQRHbC3rgqJzbEbjihPt5U
         q6X//izU3VktNa0C01F0f16VBuCE0Ng/8rH0e2ogpPWGrRfPqD8UmSgnUv5KRy3ZePFe
         UIJQ5qoX1+FILnoUumNGku0LhPn7IHlbGK8KQNQCYM86VLeAmafVTXfnpPeQXbzb52gt
         DEs4NIdGpWcIKnWKD93QYIUEPEh2sfBaSYh2cvnxUj5UEmnfaoUDvkjVURUZdDKA1XUi
         dnZqdFH+RWabpCFNTtfOE1snV9LPsPaBIennVKdmHlKHIHoDpYrvTDw38E7Dz8lBJhEu
         fGOg==
X-Gm-Message-State: AOAM531Dl8YFKluYuhg2c+S3HKyGdkBHIFSm2JUSHO05qMThBoy2f5IQ
        7R/WGvyal13EhUcR8ALTaVTzsg4dFdZ7Ag==
X-Google-Smtp-Source: ABdhPJyO0Em3dic1nYcHsMdxAILNj8jSrsVSoHd+RMvHWnAnflZH1M7qcLGDcmTr4YXQtxWf/ogpMA==
X-Received: by 2002:a17:902:ee82:b029:e5:fd49:ca09 with SMTP id a2-20020a170902ee82b02900e5fd49ca09mr5182937pld.55.1615416261570;
        Wed, 10 Mar 2021 14:44:21 -0800 (PST)
Received: from localhost.localdomain ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id j23sm475783pfn.94.2021.03.10.14.44.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 14:44:21 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 17/27] io-wq: remove unused 'user' member of io_wq
Date:   Wed, 10 Mar 2021 15:43:48 -0700
Message-Id: <20210310224358.1494503-18-axboe@kernel.dk>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210310224358.1494503-1-axboe@kernel.dk>
References: <20210310224358.1494503-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Previous patches killed the last user of this, now it's just a dead member
in the struct. Get rid of it.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io-wq.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 1ab9324e602f..c2e7031f6d09 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -110,7 +110,6 @@ struct io_wq {
 	io_wq_work_fn *do_work;
 
 	struct task_struct *manager;
-	struct user_struct *user;
 
 	struct io_wq_hash *hash;
 
-- 
2.30.2

