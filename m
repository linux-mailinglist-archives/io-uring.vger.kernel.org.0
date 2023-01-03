Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DDEE65C200
	for <lists+io-uring@lfdr.de>; Tue,  3 Jan 2023 15:34:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237560AbjACOc6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 3 Jan 2023 09:32:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237887AbjACOcf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 3 Jan 2023 09:32:35 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CA95EE23
        for <io-uring@vger.kernel.org>; Tue,  3 Jan 2023 06:32:34 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id c2so5199573plc.5
        for <io-uring@vger.kernel.org>; Tue, 03 Jan 2023 06:32:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CEOXEFsPClBQb8kDE/4Kms3/TwAvRgkmx5Ov7Z/Nc2E=;
        b=3KwFq++86WZT0CKs5Rj1YUMKBELARNl3dZ815jA4hrdxhP1QboZffBbjXkmSxjbCx/
         Leet4cAyNToZZVlpucdBNsw8gytFKCxDO3722CjZj9Xz0Cvng1o5QrV63QiCKTdxnq7P
         8MXrt8exG+7CONyFGSmtS3PR49SRv2Vcr1XjZ+nMUMiRBGvdUVvPRhzE2O8eeNox/oh3
         wiW2V622Dq9w7DfyxHh9X7//CeNjqaZ0JqFpwYY5oLX6iaoqlg1KPzwOa9La4CKzqUCW
         pIGMS7RIlCswhiLa0ShUcJu1t3/OalAce8QOhmzkQsO3sq7wXbVuAtbmTb/5sTvT42O1
         jUtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=CEOXEFsPClBQb8kDE/4Kms3/TwAvRgkmx5Ov7Z/Nc2E=;
        b=2+RNFQqGIW1KuLjjp56ibC2uyI8l0y8/F9v3S17C5x2c/BEk+KXiZp94UbzZXLegST
         qx5pa5L4i0dfV20dtPih+eicDb2LIG3qcKY34m/ijnBkPOtd2XH64cO5Ac2FVq/xNiXD
         GFP9Sql5kbo9ynIzKmWi326UT2YqXLp2lelGae4UlFNF4U4/K2CY19nMkEs2kwxIyaqS
         DwwPVr8xIIVM9MS0pOCu+gPa96P080d8ICaImD6E2Fv6JQk7056MnF7wdKIS2gbAvImh
         udjSivD6C/3iZIwKSCEsn0MxWyhppsEUINhU3ccUf089CeOk7DeZXpl+g3A69r630Ual
         nTGQ==
X-Gm-Message-State: AFqh2kqGf5qeYKU2sLNl35WsOiLfUA/PVzjJgs1Lp6sLRGBerIYg39/q
        RI8Skyg4/NFIph5ygTG84axMNVvf3/tY/WN6
X-Google-Smtp-Source: AMrXdXtvX3EOYX6siVHTan3dENN2bwWdkYQRg9g4SNvsaKiwsgWSQv1Eo3lwXfQ73lsyFX1YU3UU3g==
X-Received: by 2002:a17:902:a512:b0:192:5c3e:8952 with SMTP id s18-20020a170902a51200b001925c3e8952mr10199318plq.2.1672756353382;
        Tue, 03 Jan 2023 06:32:33 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id s9-20020a170902ea0900b0017f57787a4asm22387144plg.229.2023.01.03.06.32.32
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Jan 2023 06:32:32 -0800 (PST)
Message-ID: <1d287a8e-3c3f-4a8d-f6cc-8199b53ae886@kernel.dk>
Date:   Tue, 3 Jan 2023 07:32:31 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring/io-wq: free worker if task_work creation is canceled
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If we cancel the task_work, the worker will never come into existance.
As this is the last reference to it, ensure that we get it freed
appropriately.

Cc: stable@vger.kernel.org
Reported-by: 진호 <wnwlsgh98@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index 6f1d0e5df23a..992dcd9f8c4c 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -1230,6 +1230,7 @@ static void io_wq_cancel_tw_create(struct io_wq *wq)
 
 		worker = container_of(cb, struct io_worker, create_work);
 		io_worker_cancel_cb(worker);
+		kfree(worker);
 	}
 }
 
-- 
Jens Axboe

