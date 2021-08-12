Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1A4A3EAA79
	for <lists+io-uring@lfdr.de>; Thu, 12 Aug 2021 20:48:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229874AbhHLStC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 12 Aug 2021 14:49:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbhHLStB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 12 Aug 2021 14:49:01 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 074BDC061756
        for <io-uring@vger.kernel.org>; Thu, 12 Aug 2021 11:48:36 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id oa17so11312075pjb.1
        for <io-uring@vger.kernel.org>; Thu, 12 Aug 2021 11:48:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=6Ge7u7q31I96Pm8MLfWirG2bsSSm4DQjkdR5gK+Hw8s=;
        b=0Xl6CZnOz7FkNVVkyeKctUkSylAWaZmU7Uf/lUwSkO77xXon3s7KR6DXy5IeYJvg6m
         cx4QD+WgEzDG2JkC+HB6Yxf2zwycEf9PnSOmQpBrqimLXjRzdJZ4Zpy/yt2ZEJBBE26p
         moTekUlHoNXRuFcFcwhO3oG4wtF5HnQeWFOO7/h3U9hVsL9L2eYXczkqrCVY+gucYeFw
         /fo0yJdYc0XTrxXWcsiV29L3cKbhBccHoYxXCzYSx7hIUeOGLOhENaR4tArb0MqOfCU+
         kGMMbH1q8DjvtR/iYJClL8ZXBfe0ANvKeXiizg/UagLeDKLxL+Z44OD6xdt2aiQwZWep
         Z0Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=6Ge7u7q31I96Pm8MLfWirG2bsSSm4DQjkdR5gK+Hw8s=;
        b=WMAdWmCEc8nkBez4QG3TZrGFtfFs4ksx/aFXRhG0MH1z7pPkiJN1qBDlJKB8/VHmKs
         v+hVocARsxx+0Z90ztAw9Ph2aXRv+2pS4LUVzMDThZWOd9xwYLAASvR4AX4ufz/61n0f
         WG53cxxK/zVWGgQrzjEEKhmROnGCfT1pY5dSSmq/zpsmJbqzU9zUfxmnUj9qhzjkn3zu
         RJ1D29P+nfb138Mv/MfPt943RKUQYveq1KvqotlHxXMSm77OqIGnsy8wSw6pcEHwsDLG
         J85dL0LJT8uaaHvD1qryl4q/J118ZYOfr6BAIRHQ9mCzJUfT1SycqQk4loY8wdEjC9QN
         FkcA==
X-Gm-Message-State: AOAM531oRxrV0OnOyi07uAmIYVtfKlpZToGPWiwhi54xjMJl6fq2qXLA
        y7+RAmL1ipvB3eCIR2OM1MkAXJdPcsOsfy0e
X-Google-Smtp-Source: ABdhPJy42URVoCCB3h51AqoEMiUEQjum/9MKxMddiWsXfc61HHaDBQePbS9gpuzBzl0MJgJrEDy/Dg==
X-Received: by 2002:a17:90a:1b2a:: with SMTP id q39mr5493287pjq.219.1628794115322;
        Thu, 12 Aug 2021 11:48:35 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id g3sm4607220pgj.66.2021.08.12.11.48.34
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Aug 2021 11:48:35 -0700 (PDT)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: correct __must_hold annotation
Message-ID: <eb89c471-b730-3d9e-e5ba-a3de223faf7d@kernel.dk>
Date:   Thu, 12 Aug 2021 12:48:34 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_req_free_batch() has a __must_hold annotation referencing a
request being passed in, but we're passing in the context.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 14cb0af57396..8dcfc5296a7f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2180,7 +2180,7 @@ static void io_req_free_batch(struct req_batch *rb, struct io_kiocb *req,
 }
 
 static void io_submit_flush_completions(struct io_ring_ctx *ctx)
-	__must_hold(&req->ctx->uring_lock)
+	__must_hold(&ctx->uring_lock)
 {
 	struct io_submit_state *state = &ctx->submit_state;
 	int i, nr = state->compl_nr;

-- 
Jens Axboe

