Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAA4046EC67
	for <lists+io-uring@lfdr.de>; Thu,  9 Dec 2021 17:00:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239998AbhLIQDe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 9 Dec 2021 11:03:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239834AbhLIQDe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 9 Dec 2021 11:03:34 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47CC2C061746
        for <io-uring@vger.kernel.org>; Thu,  9 Dec 2021 08:00:00 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id v23so4740813pjr.5
        for <io-uring@vger.kernel.org>; Thu, 09 Dec 2021 08:00:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tSG14DSt7/Tmpz/JNuX2OS/Kqmuhs9FcXFa/pRz5wao=;
        b=mI4wfpVBNpZApZ7mdKX9C4ABPIUnuiPnaHLo2UoBdUt7o2rtMQdqf5EnK0VUe/lVoF
         X2ciDblMVWnvdUl8y8NP6+cKUEvpax3ZYKfQbR89Fk9m/t+7FMVniNsYAdTEmQfEVVhY
         7z+nnjc14GkRrMU3Eb0XKTf1aBV4+KYs/IhXXbzDcSuJRSmqTR8LjYXGWE/xC+ycRnit
         CydLeZnjP4ulibKFZztITGwmxoMh8YjPFz35B386XhOIv24IwB3tekPsXz7gmNDDIlaL
         E7Vva0q4bxBiUoQDXhjGfnOur2302rMwYEUJFWHpqGvauggxnoRxdm6o3dhfcO9cc9h7
         EiJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tSG14DSt7/Tmpz/JNuX2OS/Kqmuhs9FcXFa/pRz5wao=;
        b=IeoO/mHdkHfqdom9iMe4IQ+NRlfrC1T/G5hBS8haDHktYDWeg+1CsLmnGM10x9eDXD
         ncZ9OpMqq+X5+FEgh4gAOUy+QDc3QZ8jRPp3fYFOagrqEhbvSYFq2Bg9bEaMKvT5VQH9
         xabeYykkjjlH76Wvm7fYKYh0TOHKq5qpg9Pt/VTFAIpT9H/SknOruqsnZpqSAaqKyWPi
         G+VEML8bFB+2icEarqryVcVguUHOMoG+gZm/zG7HYzjT4v7mX1Ln8jCJ7Qn5biw3DVIL
         Ldj0pBUUDvaa6TcmUbFar4Ju7zWIEK+bdpxb7+og5sO+JiEeBGtVsChlvZkpAxq3i+kd
         /tsA==
X-Gm-Message-State: AOAM530yqyfCsaiSpIXB+a/xcK29TSsupiAUvkIh1DTflXEVEssssipo
        w0LMeArymW6Mm0KWVEKRQdTjuzDhM2vlpg==
X-Google-Smtp-Source: ABdhPJzo02U3Yp+DKsQbLQ21tpfJJWrJgkNZqU7TvOBJnHXN23IzSEbzSzHVey99YMeTVbRiKatEzA==
X-Received: by 2002:a17:902:e74e:b0:142:fa5:49f1 with SMTP id p14-20020a170902e74e00b001420fa549f1mr68249942plf.84.1639065599585;
        Thu, 09 Dec 2021 07:59:59 -0800 (PST)
Received: from localhost.localdomain ([66.185.175.30])
        by smtp.gmail.com with ESMTPSA id q17sm146875pfu.117.2021.12.09.07.59.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Dec 2021 07:59:59 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, stable@vger.kernel.org
Subject: [PATCH 1/2] io_uring: check tctx->in_idle when decrementing inflight_tracked
Date:   Thu,  9 Dec 2021 08:59:55 -0700
Message-Id: <20211209155956.383317-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211209155956.383317-1-axboe@kernel.dk>
References: <20211209155956.383317-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If we have someone potentially waiting for tracked requests to finish,
ensure that we check in_idle and wake them up appropriately.

Cc: stable@vger.kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index c4f217613f56..b4d5b8d168bf 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6640,6 +6640,8 @@ static void io_clean_op(struct io_kiocb *req)
 		struct io_uring_task *tctx = req->task->io_uring;
 
 		atomic_dec(&tctx->inflight_tracked);
+		if (unlikely(atomic_read(&tctx->in_idle)))
+			wake_up(&tctx->wait);
 	}
 	if (req->flags & REQ_F_CREDS)
 		put_cred(req->creds);
-- 
2.34.1

