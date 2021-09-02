Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CE053FEFB5
	for <lists+io-uring@lfdr.de>; Thu,  2 Sep 2021 16:51:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229941AbhIBOwu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 2 Sep 2021 10:52:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345545AbhIBOwu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 2 Sep 2021 10:52:50 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D019CC061575
        for <io-uring@vger.kernel.org>; Thu,  2 Sep 2021 07:51:51 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id q3so2787143iot.3
        for <io-uring@vger.kernel.org>; Thu, 02 Sep 2021 07:51:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=hvy50r1053DDG1l+8TK8328ndzYkM3zGNxidNhJs8TM=;
        b=SXZiCYywvwYwyNCKqos5QKcB4ShoeVFXAH7zil8TxA3sT4pOWBZUkHkJgJRTKzFT8Y
         lcPEhnc0r4xpuwT3G0L5uNcnzZ2/hBSwvWkLsumrkbks/xTALO6tAS/h7g+C37Iufpe7
         E7X2qkFT6PKTnT7+8FCay1L5j+aQa2Yy81E1LzFxSa6YzAx1VAitaj0npI+oKpiPHzR8
         6gp8ukxO1DuYRuthtmeUXt/4jz+Ufv9Az1X3sSQltU5xvE5aw0M/qF2+eS7jKOZPOHTf
         yMRpHntkLvCRH1dTAH/emM/LO0wEF2gS506oEQF7hglADT9gotVxhCBNc7uj4mfYgY/N
         ozyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=hvy50r1053DDG1l+8TK8328ndzYkM3zGNxidNhJs8TM=;
        b=GL2jIkKOu4WhA4u6JjEA7yx8rCrgWxt196PNt4YSfSqNaGOWzl9ExMukn//+db033m
         GhBIzYUlAaUJrnjZf4gmJJijsoMJrubRk79seKNqirg1oPEGDpST/cmBd8JPyk/PQnPL
         yTWL4TbaxlsHfFpB8qIXOu3Npi+/bLyOc7CMJLkF81iUsnppZr6aZl8d7kZpG4mXuesN
         CsnXJk5VUeHIbKKGj6osoGSRf+mOapmShrHTROgvhw4KGHtIPZngHp4Ym3R+bj/lLSfe
         sBaICJCMXI5Z7nokDVNtmDIdYCyuaFxe4CeM29MqyklNSz24U6fKdG6Wn+kFEG1Err/F
         lfXA==
X-Gm-Message-State: AOAM530DiYxbbtIObP/RbR8fUAShZZM29W2sDYdXGXShk9gWYAJBV1T1
        upMLT8b/JMJ/EBVHf6lpK4Ps8LuRMef9XA==
X-Google-Smtp-Source: ABdhPJz9tmpYQvETliGbht/Re35Z60R81NJrUnsoK115hUDL8d4LfZvT2nfXgHBwxN80vu8K82IYeA==
X-Received: by 2002:a6b:b586:: with SMTP id e128mr3086174iof.37.1630594310965;
        Thu, 02 Sep 2021 07:51:50 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id m10sm1081158ilg.20.2021.09.02.07.51.50
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Sep 2021 07:51:50 -0700 (PDT)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io-wq: ensure that hash wait lock is IRQ disabling
Message-ID: <88634a5c-d147-648e-7417-94394464c929@kernel.dk>
Date:   Thu, 2 Sep 2021 08:51:49 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

A previous commit removed the IRQ safety of the worker and wqe locks,
but that left one spot of the hash wait lock now being done without
already having IRQs disabled.

Ensure that we use the right locking variant for the hashed waitqueue
lock.

Fixes: a9a4aa9fbfc5 ("io-wq: wqe and worker locks no longer need to be IRQ safe")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 94f8f2ecb8e5..a94060b72f84 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -405,7 +405,7 @@ static void io_wait_on_hash(struct io_wqe *wqe, unsigned int hash)
 {
 	struct io_wq *wq = wqe->wq;
 
-	spin_lock(&wq->hash->wait.lock);
+	spin_lock_irq(&wq->hash->wait.lock);
 	if (list_empty(&wqe->wait.entry)) {
 		__add_wait_queue(&wq->hash->wait, &wqe->wait);
 		if (!test_bit(hash, &wq->hash->map)) {
@@ -413,7 +413,7 @@ static void io_wait_on_hash(struct io_wqe *wqe, unsigned int hash)
 			list_del_init(&wqe->wait.entry);
 		}
 	}
-	spin_unlock(&wq->hash->wait.lock);
+	spin_unlock_irq(&wq->hash->wait.lock);
 }
 
 /*

-- 
Jens Axboe

