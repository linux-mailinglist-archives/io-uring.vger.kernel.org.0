Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F5F0342DD2
	for <lists+io-uring@lfdr.de>; Sat, 20 Mar 2021 16:39:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229954AbhCTPiw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 20 Mar 2021 11:38:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbhCTPin (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 20 Mar 2021 11:38:43 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCCEBC061762
        for <io-uring@vger.kernel.org>; Sat, 20 Mar 2021 08:38:42 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id lr1-20020a17090b4b81b02900ea0a3f38c1so9603889pjb.0
        for <io-uring@vger.kernel.org>; Sat, 20 Mar 2021 08:38:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wKVl2ZBcEmHdyj651ipa5U538ILekXzuQ5XaJkSKBWg=;
        b=hcmSUymtd4ol6ndWFlOUIzTrMuXFoQcWZtBmoeGtDjHCWUcDbUyWzhxW2tvTneuB4O
         MKnjBWPAWejnO9uaRwoLzCid3UeTrW1u7DTu/CewnliwBDB+zlrXC4NJlX3P0tvHqrWy
         PRlGiNE5jA+jWvyBHJ7hpGRayCrm/Eet5uOV1EBtw1wpC2nejzzvE5PHYqZrNZCtk44c
         d6autgz8z3/1+2r2Rj5XFhPf6Kc2SEXMv8ZvjZM1RFJpj10GDoY0Fxpmni7B/7PaJMi0
         y2kb4w42NoDEwBmuIaTei36bnl7SsXeyjD/fuzMZ6Scr4LWwRpMJffi39Pb9Zk2k4beR
         /PGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wKVl2ZBcEmHdyj651ipa5U538ILekXzuQ5XaJkSKBWg=;
        b=gLu8VTGHMZ0K4AzuKjMaoKN1QhlVkoYt30ymf/jO7kvLGs6IV7jTfAkMqpK4uY9lNS
         sFcg2lbBFgs/dgVyp3gKZqco2z93RPT1/HirPlcB5YDd3BsmaSU1c+T/9ZWy0tdr4ELB
         pJWvFKuADsIyptSzFS+XHIjWDdDgnAwViggRld2DL5gDVGNpGAXjFvn3WerltHS78zRg
         QzLrh5etSLGSiRC4uu1IBKndrmW39qoLphNlrq2nTOfewyNEYuZpGEf4CSlogrrGFkRq
         WF8vUno3STKvFLq9Y9rLMzaqF94I8+ZqBp9j3+2BvgFGGDz8ekaDaJKOsm4vdJaRHGqM
         elXg==
X-Gm-Message-State: AOAM532THfq0ghKAnqBMqZNoKHPK6Y8MWSWU/XFwyumU7mAPwfoMeHmB
        w5ZK1F8Y8psCe7Y5yUR/90Zg9vZRKWxdGQ==
X-Google-Smtp-Source: ABdhPJzn8XtjKLDnDMYfmdUP9IvxAFJFXbrVXThoRCum70urq1LvhUslYyGPkT6tyG8lXns8FROIyA==
X-Received: by 2002:a17:90a:f3cc:: with SMTP id ha12mr4079964pjb.180.1616254722015;
        Sat, 20 Mar 2021 08:38:42 -0700 (PDT)
Received: from localhost.localdomain ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id 2sm8658753pfi.116.2021.03.20.08.38.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Mar 2021 08:38:41 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     torvalds@linux-foundation.org, ebiederm@xmission.com,
        linux-kernel@vger.kernel.org, oleg@redhat.com,
        Jens Axboe <axboe@kernel.dk>,
        Stefan Metzmacher <metze@samba.org>
Subject: [PATCH 2/2] signal: don't allow STOP on PF_IO_WORKER threads
Date:   Sat, 20 Mar 2021 09:38:32 -0600
Message-Id: <20210320153832.1033687-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210320153832.1033687-1-axboe@kernel.dk>
References: <20210320153832.1033687-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Just like we don't allow normal signals to IO threads, don't deliver a
STOP to a task that has PF_IO_WORKER set. The IO threads don't take
signals in general, and have no means of flushing out a stop either.

Reported-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 kernel/signal.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/signal.c b/kernel/signal.c
index 730ecd3d6faf..b113bf647fb4 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -2349,6 +2349,10 @@ static bool do_signal_stop(int signr)
 
 		t = current;
 		while_each_thread(current, t) {
+			/* don't STOP PF_IO_WORKER threads */
+			if (t->flags & PF_IO_WORKER)
+				continue;
+
 			/*
 			 * Setting state to TASK_STOPPED for a group
 			 * stop is always done with the siglock held,
-- 
2.31.0

