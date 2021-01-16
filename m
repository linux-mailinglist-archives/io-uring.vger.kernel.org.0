Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 809EA2F8EDC
	for <lists+io-uring@lfdr.de>; Sat, 16 Jan 2021 20:15:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725979AbhAPTPg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 16 Jan 2021 14:15:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725964AbhAPTPf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 16 Jan 2021 14:15:35 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 442D3C061573
        for <io-uring@vger.kernel.org>; Sat, 16 Jan 2021 11:14:55 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id i5so8312906pgo.1
        for <io-uring@vger.kernel.org>; Sat, 16 Jan 2021 11:14:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=dWJV0EZVoWiuVJpfJ1bGmjPFUpyaL8M1WvGAUQLJ+k8=;
        b=HtzmhaRb5XHqEvNtUDH0IJG0SXX2IJx+MgLTjum9CEinKDz762oQYYV/HPlPL4SycT
         WARA57vLO5Piw8nJH3PePEj0mUUTxTAYvDVvZNmDkih5O09nrbpePsgJL4nXUYw+oxdx
         +jGuqpgz3kXHGRykLQ8evsMO7mjMn2Zt4aI1sN3/q7LijHGqdzGgvWbtKyEsq9GOUrM5
         5LCyzuALqmvq6alj434btdRXeOfUUKbUe8pzhKy4kjVG+OBByArh3hOiOQB2KfgWmmOO
         MDjCi/clemuiCRjvk/oqgCtQDAWSGU/2nFMuRnFbeQS9XWTEYJ82mqUWpy1qdhMpgW73
         pFIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=dWJV0EZVoWiuVJpfJ1bGmjPFUpyaL8M1WvGAUQLJ+k8=;
        b=kAzpv3xmWrptbMWMiRyYLKpzwI/vSMxrsFJsEs+9tTbdvoFBMdtVe4LLlnYSS+qNAA
         wYimurU4Wt/TCW6sg+PAW7C+SzeAgAa0VyFkkyNImDQRZ3jwhipnHFA33H+TU97w6LHk
         eAjWAC4J1BPDEfKainnd21MW+c6+ecw1SzMNFU5zkN7W7HStK24lZtlK3IiKu1uCXHkc
         lBvBgEPsNJj0roo/psdupb/cC1UKRd7NuY6qvDSIxTnbd5/VX2+BANpbTfu88iQM+2eC
         AAu9aIt1oG3BmG4s13PdV8948shQFme8OBXOlur3IYfzGxH4BkwDXeg86R/jDiPese55
         Uy2A==
X-Gm-Message-State: AOAM532gyD5uQvAmmWENcnGam0yOEwTzgSE6a44leNSo+0AUMGNIs7WI
        2UsJddXwgnkfMdL+ZJURJJAuXv4OlANvag==
X-Google-Smtp-Source: ABdhPJwt1s/C4ZkKvoOSQX3WFK+Vuhp8+EU0+0GrzJmHQ+dWDaeK9xdlG2woZCXg4xfQaxSyUFcUIg==
X-Received: by 2002:a62:864e:0:b029:1ab:e82c:d724 with SMTP id x75-20020a62864e0000b02901abe82cd724mr18861990pfd.9.1610824494468;
        Sat, 16 Jan 2021 11:14:54 -0800 (PST)
Received: from [192.168.4.41] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id b65sm8827464pga.54.2021.01.16.11.14.53
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Jan 2021 11:14:54 -0800 (PST)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: iopoll requests should also wake task ->in_idle
 state
Message-ID: <6bfb5701-01d5-ec11-7355-95d28e495ccd@kernel.dk>
Date:   Sat, 16 Jan 2021 12:14:52 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If we're freeing/finishing iopoll requests, ensure we check if the task
is in idling in terms of cancelation. Otherwise we could end up waiting
forever in __io_uring_task_cancel() if the task has active iopoll
requests that need cancelation.

Cc: stable@vger.kernel.org # 5.9+
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 985a9e3f976d..5cda878b69cf 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2270,6 +2270,8 @@ static void io_req_free_batch_finish(struct io_ring_ctx *ctx,
 		struct io_uring_task *tctx = rb->task->io_uring;
 
 		percpu_counter_sub(&tctx->inflight, rb->task_refs);
+		if (atomic_read(&tctx->in_idle))
+			wake_up(&tctx->wait);
 		put_task_struct_many(rb->task, rb->task_refs);
 		rb->task = NULL;
 	}
@@ -2288,6 +2290,8 @@ static void io_req_free_batch(struct req_batch *rb, struct io_kiocb *req)
 			struct io_uring_task *tctx = rb->task->io_uring;
 
 			percpu_counter_sub(&tctx->inflight, rb->task_refs);
+			if (atomic_read(&tctx->in_idle))
+				wake_up(&tctx->wait);
 			put_task_struct_many(rb->task, rb->task_refs);
 		}
 		rb->task = req->task;
-- 
Jens Axboe

