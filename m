Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CB242B92A5
	for <lists+io-uring@lfdr.de>; Thu, 19 Nov 2020 13:38:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727280AbgKSMiZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 19 Nov 2020 07:38:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727096AbgKSMiZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 19 Nov 2020 07:38:25 -0500
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00760C0613CF;
        Thu, 19 Nov 2020 04:38:24 -0800 (PST)
Received: by mail-wm1-x344.google.com with SMTP id c198so5147449wmd.0;
        Thu, 19 Nov 2020 04:38:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=g5OCS+3DQz7Ea5OMMP9QWzIynexAFFgWX0tm/4Z5oko=;
        b=d30vgQqotHV48w2ArtccBzIaiOGmPp0buvGmsv8v/27kceQH8XlKTDqOShNy9YknnB
         mB8qyQTD1hVVwuV5nj4jXYrMGaaDnrfMLabwLWzQkxsaMwPg2GOwggXwSOE0rOjfRELr
         efDfmg1kc4+M5zvUYbRJtnDAuzG63L5pxrNnkHwipLjVnLVKWR1n25A5rHlKBkzZVPlt
         UohPBbWYpHogXQdIfDGoEdicUcu248+qkb1bGWpd8vUJhpdn1rFJlyEtEzQdykVmwNBl
         wiW33MpuJUtQP1XSTZE7XizB3eW8CoJv6EJcGD8u7iqd89ktIpjVmbXF4c4N9wRLm+xa
         lqZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=g5OCS+3DQz7Ea5OMMP9QWzIynexAFFgWX0tm/4Z5oko=;
        b=WmuhC6IaQF2Os3P4MDBJM+niQ4G7LfiqMpksLSCc2RZiuRmuXikJZgKvnZiuTuO8kx
         iAhAXWSNy25TV9f2S4IY73TJ4mFb0jnQ4eYp49DuHFc+isSH9CpvwahW7dH3Wa3h8dOa
         jG5jf08/F1hkVdcsG9/MK0R8dCzldB4XIYN1w8E5dSxZhuzFX7fvp6WR7xOw3mLykVPW
         0bo+NmwNFt2c+gWBylerAbejuD6/POP32F8OQ4LVeWFOW0j31+pnVHtRwhYfO6WUNeQ+
         jg6QGqDCFMCUu0nqdPT2mXnd3GtqYMy0h463Y91WvyWSkDdfyOer6PNze7eyJGBhyAvg
         zwEQ==
X-Gm-Message-State: AOAM533P/lCpPiH9/MdthkjDssHNRndZqQG91HZcDwck5NfHuXUyzRrf
        SKeXarcncUHVZgTDi+6/GI05eHtghkI/KQ==
X-Google-Smtp-Source: ABdhPJz86HOzzqqT9FXVVnQ03wd9cIQgODp8/POepa9dqHvmVxzqzZDKOF/uh6zgYWVC/sHP5jxZAg==
X-Received: by 2002:a1c:4055:: with SMTP id n82mr4710640wma.68.1605789503774;
        Thu, 19 Nov 2020 04:38:23 -0800 (PST)
Received: from localhost.localdomain (host109-152-100-189.range109-152.btcentralplus.com. [109.152.100.189])
        by smtp.gmail.com with ESMTPSA id d10sm39362320wro.89.2020.11.19.04.38.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2020 04:38:23 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        io-uring@vger.kernel.org
Subject: [PATCH v2] blk-mq: skip hybrid polling if iopoll doesn't spin
Date:   Thu, 19 Nov 2020 12:35:09 +0000
Message-Id: <972a4d02be5d52d98e8e5523ff4440d30a9cf00a.1605789192.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cb5e5c3bb9ac13ca7e1026ceb484c03c0367e14b.1605788995.git.asml.silence@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_uring might be iterating over several devices/files iopoll'ing each
of them, for that it passes spin=false expecting quick return if there
are no requests to complete.

However, blk_poll() will sleep if hybrid poll is enabled. Skip sleeping
there if specified not to spin.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---

v2: inverse invalid spin check

 block/blk-mq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 55bcee5dc032..38262212fc99 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3865,7 +3865,7 @@ int blk_poll(struct request_queue *q, blk_qc_t cookie, bool spin)
 	 * the IO isn't complete, we'll get called again and will go
 	 * straight to the busy poll loop.
 	 */
-	if (blk_mq_poll_hybrid(q, hctx, cookie))
+	if (spin && blk_mq_poll_hybrid(q, hctx, cookie))
 		return 1;
 
 	hctx->poll_considered++;
-- 
2.24.0

