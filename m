Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 511084FB053
	for <lists+io-uring@lfdr.de>; Sun, 10 Apr 2022 23:15:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234044AbiDJVSA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 10 Apr 2022 17:18:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232134AbiDJVR7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 10 Apr 2022 17:17:59 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C9DE2CCB7
        for <io-uring@vger.kernel.org>; Sun, 10 Apr 2022 14:15:47 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id a42so6371540pfx.7
        for <io-uring@vger.kernel.org>; Sun, 10 Apr 2022 14:15:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:from
         :subject:content-transfer-encoding;
        bh=5VmphU1+l7tMvSsRdYkd4ne/th0H0E9uxfVPtzlETdM=;
        b=oHt2nx6afupArxttvXbPYlHDEiY6TJD+0iRUibiDVUy3aEGekO62XbznGMf8WKOkXx
         NkmBr7EytyL54ca8//aczSK9/LJ/0FDpaicSNWgzk0KMHS6bhcuUtMw+gYVIv5wfTSQM
         LJZcRMw3opluNfEz4TQexeRrmN7VkeEBc4TWrVcR6i1I7vwfsI9io0EmJmNX3ZIio1s7
         9AEEZJN/JVOeF38yDHwoq9AvI16l5A7c+2RPpyZCvYzjzuFb6R7lv6uVcFep24H9Ccf7
         x3mn+B+3KIv4ebo0OEvlBIZZgTIRFocq/zIZRfugLnOlm9UhsKfcYiPDKzyCYsXCBPg0
         OEGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:from:subject:content-transfer-encoding;
        bh=5VmphU1+l7tMvSsRdYkd4ne/th0H0E9uxfVPtzlETdM=;
        b=I5n8sclmCcHPeTPFNtJj2yiLUaRoxAG//Ct/i+4LQauui3vZAHI6IVMhvCKx1lzsE/
         7TBGHflToTlZFXSGJdmBMRNkLJO5QfGAxeKCnwdb4AVDqroDiU8d7DX16Ebku/K972jx
         LfNLI+XPsJ9qKCfZGsjpmu7MuUwzVGswY1nhdVUbs2ar9Fu2UBdYPzneEjI8/vkWSFpf
         /lCUOk5P8CD/km2WAKfLW6cSdr7Uv8B3WCC7hd+ymqxMMeE/VJAhOzvlDWtJuoN7CLeP
         G7ztaIUO2AQzPXhnAUal/SSzOaD5IfZ0T1Cjvh9qvQJWRksylgh7KdQ6ZlMyWSzfmFDK
         HtbQ==
X-Gm-Message-State: AOAM530NIqjJtafeD6aF0BOskFNPtUtypvjqdxSxHERL0xynIrE/bHVN
        hQqUeO9wQ3MzgYjevO3FTaSQcvT5b47pTQ==
X-Google-Smtp-Source: ABdhPJxCRD/8v42umBgWsge0x2txkTA5z07NQlvCwrjC8EKDE6eyviOEZuUqATkZwVv1BYsR3uWqsg==
X-Received: by 2002:a65:6e41:0:b0:39c:c97b:2aef with SMTP id be1-20020a656e41000000b0039cc97b2aefmr15317470pgb.473.1649625346657;
        Sun, 10 Apr 2022 14:15:46 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id m2-20020a056a00164200b00505a31a064esm5065186pfc.103.2022.04.10.14.15.45
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 10 Apr 2022 14:15:46 -0700 (PDT)
Message-ID: <b2f8bfdd-76b4-5911-f279-818de779d73f@kernel.dk>
Date:   Sun, 10 Apr 2022 15:15:45 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: flag the fact that linked file assignment is sane
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

Give applications a way to tell if the kernel supports sane linked files,
as in files being assigned at the right time to be able to reliably
do <open file direct into slot X><read file from slot X> while using
IOSQE_IO_LINK to order them.

Not really a bug fix, but flag it as such so that it gets pulled in with
backports of the deferred file assignment.

Fixes: 6bf9c47a3989 ("io_uring: defer file assignment")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 659f8ecba5b7..f060ad018ba4 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -11178,7 +11178,8 @@ static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
 			IORING_FEAT_CUR_PERSONALITY | IORING_FEAT_FAST_POLL |
 			IORING_FEAT_POLL_32BITS | IORING_FEAT_SQPOLL_NONFIXED |
 			IORING_FEAT_EXT_ARG | IORING_FEAT_NATIVE_WORKERS |
-			IORING_FEAT_RSRC_TAGS | IORING_FEAT_CQE_SKIP;
+			IORING_FEAT_RSRC_TAGS | IORING_FEAT_CQE_SKIP |
+			IORING_FEAT_LINKED_FILE;
 
 	if (copy_to_user(params, p, sizeof(*p))) {
 		ret = -EFAULT;
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 784adc6f6ed2..1845cf7c80ba 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -296,6 +296,7 @@ struct io_uring_params {
 #define IORING_FEAT_NATIVE_WORKERS	(1U << 9)
 #define IORING_FEAT_RSRC_TAGS		(1U << 10)
 #define IORING_FEAT_CQE_SKIP		(1U << 11)
+#define IORING_FEAT_LINKED_FILE		(1U << 12)
 
 /*
  * io_uring_register(2) opcodes and arguments

-- 
Jens Axboe

