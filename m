Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5D776C02A4
	for <lists+io-uring@lfdr.de>; Sun, 19 Mar 2023 16:18:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229759AbjCSPSp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 19 Mar 2023 11:18:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229676AbjCSPSo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 19 Mar 2023 11:18:44 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B76718A81
        for <io-uring@vger.kernel.org>; Sun, 19 Mar 2023 08:18:40 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id u5so10003504plq.7
        for <io-uring@vger.kernel.org>; Sun, 19 Mar 2023 08:18:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1679239119;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+cBF+padkUpYf1ApfDxWlCstEh5dnDMuhSFJv3Ch0vU=;
        b=RoYH2FZPeDTuyEI/XAaNE5kmeAtmHwroQhc1qf5cnjXvr1xNVEXJNsfvNzCYFqnFEV
         I/NLH51uZKafvzd0Az3mKrURAbtKe0ZBMTU2lLKC8BA+UVb27TlB/qRUTB8kwkc67Hgy
         h2ZTMEnnRQor7GLhua4OStmKMzaHA2EIVxDmosWdcnZydpOvkm5AjeseVeQcmDSVgccC
         vhKad1Xa7NaOO/0mo1N7Tym+8IX9kbhYfaGz8y1Oa0cAkbO4tJ5OQC9epH+mx47xDqIO
         +XYO1Hs8SN6ka70tzBItDWoDHaMz4fJQuZxfJwVk5bN0weCoqXlYOz/QfG/xaGIub2F4
         QhRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679239119;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=+cBF+padkUpYf1ApfDxWlCstEh5dnDMuhSFJv3Ch0vU=;
        b=wLWTTYadl26favCMIR3JPjs70ekzZaHpnlVDYZRj3TcaP+xTeWgUcS75iuqAPqH4Bu
         HQEZRtBq9UtlowCHkBKmxIcP6T2OCNqtIsVzO3hD/ZLmAU+zIUh/nSj50hJfiJ0tXk+G
         Aq+roGm9ot0V83MWwJp+9CrR7hkf3g1qA2OjOu0pwq7h2Z/2xwkCa45wfWcQABm58EQX
         XN1HYy80hanM/zhm0hy/fLEpd4mC73gfIM4kogK8jsvSPiT7RyU+gq6goJ5908u5uUtw
         xktsarhbo0gNP1BI4QeFZNOZhNVrCE5yqKWZdo2ZOi6ZMEGoAiJu4+lSrAN+BwfAymXl
         2Sdg==
X-Gm-Message-State: AO0yUKW54CvnQ+Wehe8jCX8fXUEAKjqAxznnFV0LoneYAH40kQ9wtVQJ
        tiz+bZU+oFqg69tlKBrmeOss6mWh3DQoRpOf62WRPg==
X-Google-Smtp-Source: AK7set9CmltndXH1Wdfl+IK4G7pID6zeKSBlDm9lSuL8fwOaO2KE6/mz29VdZrsTxHyV7F39jA9GIQ==
X-Received: by 2002:a17:903:32c9:b0:196:8d96:dc6b with SMTP id i9-20020a17090332c900b001968d96dc6bmr14409473plr.2.1679239119467;
        Sun, 19 Mar 2023 08:18:39 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id x5-20020a1709028ec500b001a04d37a4acsm4894750plo.9.2023.03.19.08.18.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Mar 2023 08:18:38 -0700 (PDT)
Message-ID: <4b4e3526-e6b5-73dd-c6fb-f7ddccf19f33@kernel.dk>
Date:   Sun, 19 Mar 2023 09:18:37 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>
Cc:     Kanchan Joshi <joshi.k@samsung.com>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring/uring_cmd: push IRQ based completions through
 task_work
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is similar to what we do on the non-passthrough read/write side,
and helps take advantage of the completion batching we can do when we
post CQEs via task_work. On top of that, this avoids a uring_lock
grab/drop for every completion.

In the normal peak IRQ based testing, this increases performance in
my testing from ~75M to ~77M IOPS, or an increase of 2-3%.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 2e4c483075d3..b4fba5f0ab0d 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -45,18 +45,21 @@ static inline void io_req_set_cqe32_extra(struct io_kiocb *req,
 void io_uring_cmd_done(struct io_uring_cmd *ioucmd, ssize_t ret, ssize_t res2)
 {
 	struct io_kiocb *req = cmd_to_io_kiocb(ioucmd);
+	struct io_ring_ctx *ctx = req->ctx;
 
 	if (ret < 0)
 		req_set_fail(req);
 
 	io_req_set_res(req, ret, 0);
-	if (req->ctx->flags & IORING_SETUP_CQE32)
+	if (ctx->flags & IORING_SETUP_CQE32)
 		io_req_set_cqe32_extra(req, res2, 0);
-	if (req->ctx->flags & IORING_SETUP_IOPOLL)
+	if (ctx->flags & IORING_SETUP_IOPOLL) {
 		/* order with io_iopoll_req_issued() checking ->iopoll_complete */
 		smp_store_release(&req->iopoll_completed, 1);
-	else
-		io_req_complete_post(req, 0);
+		return;
+	}
+	req->io_task_work.func = io_req_task_complete;
+	io_req_task_work_add(req);
 }
 EXPORT_SYMBOL_GPL(io_uring_cmd_done);
 
-- 
Jens Axboe

