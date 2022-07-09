Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2147456C978
	for <lists+io-uring@lfdr.de>; Sat,  9 Jul 2022 15:10:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229477AbiGINKA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 9 Jul 2022 09:10:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbiGINJ7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 9 Jul 2022 09:09:59 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E23727145
        for <io-uring@vger.kernel.org>; Sat,  9 Jul 2022 06:09:57 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id cp18-20020a17090afb9200b001ef79e8484aso3012564pjb.1
        for <io-uring@vger.kernel.org>; Sat, 09 Jul 2022 06:09:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc:from
         :subject:content-transfer-encoding;
        bh=ebMhuXzlEOJJA8oEf0a4J3s3X9PShNuFv4U4XZn8r44=;
        b=Ly7Soe4N58b/A+s7fRefcQE7SA6L6cV5CLnSa7+UIz4WMtAJ7dD0MItimzkOT4MznZ
         7WHl1sNqaz8ykraBQfbvkvkGuFyb+hAolvN8iSfQRF1phrgctLDy2EPWLBa7RVMiqzbW
         XRrQBGYOc9UyIC1ZSvCW3DXr8SKg36oBXwJ0JFmkVgiUt0pjLKFnR8YDWAYd22i88iMC
         If2A8JLnUdWYXCpdxiNE38YCDHJUIBonsTpPOmUi/d+sFRu1Wmqv6ibQHeHo4k39JtrX
         D3s9WndgO9j3f+BLC5zLDrK3HJFmHrAKblGkegd6N4aSdjExB7Ejof+pvZSnJ1IuM2Fk
         XWGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:from:subject:content-transfer-encoding;
        bh=ebMhuXzlEOJJA8oEf0a4J3s3X9PShNuFv4U4XZn8r44=;
        b=6G/7ZMDU9VVOeh7QjGKiqV/l6ITpNb7jcL5vQ82I4TNTSNxdkL4p5HOTqc4vrt3Lyr
         v3ZsqiYkMUyGiUjO5SazkdGabkesHSguAvsml7Hq91h7pwANgjy8Lvm+WsiV2Ds2HIyq
         hD/zyCcC/oQ2BxXK52wCruIRQTNMXcCRPQbcem7URGxgYC1kuh8v0fGFubTEVRGmHyTt
         w1cl2OKcV0NSUBeSMaZnEgGlUt6IS6jN+NrF7Vs9or6KB/u5Eqr4d9YNO9B8V4i25BP5
         FgOeZFMfJ701nNerv+Ca/s3tHJxoKwqw7+EJuOiQKo7TNfecdhm28vQKu6aeANDK1CJ3
         k4CA==
X-Gm-Message-State: AJIora/B97xM8/jtF8NbwRd6aWC0KyTUEjqlKriq/papIQEKFr0Lm98u
        nk5a/Hxw1W9DN0vWiU3olUXoE8WQhTiQVw==
X-Google-Smtp-Source: AGRyM1sP9Lg6k/LzcTX6iCyaicvoyLahdR9mWy96IbePkGy+ocaRSjmpFnX8oCnWrYZT4VNu3M86gw==
X-Received: by 2002:a17:903:22ca:b0:16b:f798:1d07 with SMTP id y10-20020a17090322ca00b0016bf7981d07mr9084008plg.59.1657372196131;
        Sat, 09 Jul 2022 06:09:56 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id n11-20020a170902e54b00b0015ee985999dsm1305112plf.97.2022.07.09.06.09.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 09 Jul 2022 06:09:55 -0700 (PDT)
Message-ID: <d5a19c1e-9968-e22e-5917-c3139c5e7e89@kernel.dk>
Date:   Sat, 9 Jul 2022 07:09:54 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>
Cc:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: check that we have a file table when allocating
 update slots
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If IORING_FILE_INDEX_ALLOC is set asking for an allocated slot, the
helper doesn't check if we actually have a file table or not. The non
alloc path does do that correctly, and returns -ENXIO if we haven't set
one up.

Do the same for the allocated path, avoiding a NULL pointer dereference
when trying to find a free bit.

Fixes: a7c41b4687f5 ("io_uring: let IORING_OP_FILES_UPDATE support choosing fixed file slots")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index cddc0e8490af..a01ea49f3017 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7973,6 +7973,9 @@ static int io_files_update_with_index_alloc(struct io_kiocb *req,
 	struct file *file;
 	int ret, fd;
 
+	if (!req->ctx->file_data)
+		return -ENXIO;
+
 	for (done = 0; done < req->rsrc_update.nr_args; done++) {
 		if (copy_from_user(&fd, &fds[done], sizeof(fd))) {
 			ret = -EFAULT;
-- 
2.35.1

-- 
Jens Axboe

