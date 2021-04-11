Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 234D935B112
	for <lists+io-uring@lfdr.de>; Sun, 11 Apr 2021 02:51:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234963AbhDKAvW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 10 Apr 2021 20:51:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234944AbhDKAvW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 10 Apr 2021 20:51:22 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECE7EC06138B
        for <io-uring@vger.kernel.org>; Sat, 10 Apr 2021 17:51:06 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id o20-20020a05600c4fd4b0290114265518afso4851287wmq.4
        for <io-uring@vger.kernel.org>; Sat, 10 Apr 2021 17:51:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=cbyg3MU4OQMkL9FINUnarsCoRin2v7VnTCazhm3BE0k=;
        b=dS0hf5w+OZMTEdMdfhWjoDlKpXrSRt6Kw56ynQ9TMbSRTs7Q2f5k0+K3KmudnQfxkf
         sipEAaQ4JQlJXm92RD2GpT3HhhLl2xh34N61uXXVZemDaULtmxxhEBZ7vej23s9ratEz
         XWNljgdHCqWCE8Egzn7oo30aD835LhKftLnNe1/V384Zy5aRIHxuCKmhfoB5rRefnStG
         0UpIHU9WrSmt6dyb4h645SWlCUdhmuqpgC4FT+PredLCNV3Fo4h4DK4g+KAm09yjzIbR
         yZoR1RmJexv6YD3yXhjjFQODCGDFUZbeLYakGr9SMOf1E8ScOVMW/BMTkRXwYk5MY3lj
         9RBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cbyg3MU4OQMkL9FINUnarsCoRin2v7VnTCazhm3BE0k=;
        b=PjjMr8DIQP+mOMD/WIgsf+ZuXvhQuwopBCGY0xRAd5MpMAOzeG0PWrq13jab1yRgFV
         Mz3E8r4tjpCEOnbBuyL19I1KHbQWBGFDbvimHTqhndajbDgKoCTw6RkTEeKcztDsAFnl
         xlxvugMjBX1NsjtUh6PLH5E32zOEb0B342T7sf4xEqhprvvHTwJrrhEAd6sn9UbwYjAB
         njW3c2nxKe/7YajsqtdEck/iMHWFDjogTkp05aQYlPhfq17h8eGsXfFDhfr8S6XSE1wW
         aGHyXqhMX2fJvDDpi2tf3HAX/oasJ71IG2GJvNW1OTIgLlTo/k/vYBLn0WsegddxQAT5
         57Xw==
X-Gm-Message-State: AOAM533zUq9qmz3DS1O52A7p1G42sCZXA2W7M9XwOhQVwdMmLX+BSSoU
        Qjf859EbSrdv8WZ08XJPGzo=
X-Google-Smtp-Source: ABdhPJxa+e2OLjW7JyW5egGXbHmAHuDbQPpGCZ/z05cZ+4lMml+RUr3lgxPq+i4yfdaMI0V9ae6udg==
X-Received: by 2002:a7b:c110:: with SMTP id w16mr16107121wmi.141.1618102265744;
        Sat, 10 Apr 2021 17:51:05 -0700 (PDT)
Received: from localhost.localdomain ([85.255.237.117])
        by smtp.gmail.com with ESMTPSA id y20sm9204735wma.45.2021.04.10.17.51.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Apr 2021 17:51:05 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 14/16] io_uring: improve sqo stop
Date:   Sun, 11 Apr 2021 01:46:38 +0100
Message-Id: <653b24ee93843a50ff65a45847d9138f5adb76d7.1618101759.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1618101759.git.asml.silence@gmail.com>
References: <cover.1618101759.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Set IO_SQ_THREAD_SHOULD_STOP before taking sqd lock, so the sqpoll task
sees earlier. Not a problem, it will stop eventually. Also check
invariant that it's stopped only once.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index d14a64cd2741..4e6a6f6df6a2 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7234,9 +7234,10 @@ static void io_sq_thread_park(struct io_sq_data *sqd)
 static void io_sq_thread_stop(struct io_sq_data *sqd)
 {
 	WARN_ON_ONCE(sqd->thread == current);
+	WARN_ON_ONCE(test_bit(IO_SQ_THREAD_SHOULD_STOP, &sqd->state));
 
-	mutex_lock(&sqd->lock);
 	set_bit(IO_SQ_THREAD_SHOULD_STOP, &sqd->state);
+	mutex_lock(&sqd->lock);
 	if (sqd->thread)
 		wake_up_process(sqd->thread);
 	mutex_unlock(&sqd->lock);
-- 
2.24.0

