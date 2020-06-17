Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45ECB1FD6A6
	for <lists+io-uring@lfdr.de>; Wed, 17 Jun 2020 23:05:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726878AbgFQVFv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 17 Jun 2020 17:05:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726761AbgFQVFu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 17 Jun 2020 17:05:50 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5CC9C06174E
        for <io-uring@vger.kernel.org>; Wed, 17 Jun 2020 14:05:49 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id i4so1665345pjd.0
        for <io-uring@vger.kernel.org>; Wed, 17 Jun 2020 14:05:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=Z6jZ0aodOKoUvdg5lC5IfR88q4h28yCSUDl3KQFWjGM=;
        b=0UmSKNq7pYV+R4G70DeAXukCqKPU6voX2+rCOj9HKdiZC7f0mj3dR9lGbf9bMf6S8X
         yltADrKDQyKZ7Fh347MKVKskNcJt4xDunemWUFYrpOC09BSCqZOGaQtvknCB4mRrseDM
         kFJaMf1104AULtPouEnNd6S1h/iHM8oJRxk9FT+33lPp+JxGUB36bw66Z/pxrf41pKJn
         m8669eTbBDgbG8eaxzEGKJ28+ggLLP1i4b1g6VbVAabtSXgLxePicMvDUb9FgJTVhrx8
         hthupdhvCTsD6H2kUQT4x5kK1MaPLh0iEqQEwycycYKhQASgvQA/dujd2cWHqQ2OvE3h
         6/Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=Z6jZ0aodOKoUvdg5lC5IfR88q4h28yCSUDl3KQFWjGM=;
        b=MryDcC8Z6H2CVL81Z1rjHrfxI5oaNk6KkfCmHym++m3cDQuj4KbHxfNtglIflB+OzM
         a0dhY8D1YBw8hcF0v8cuExYljPCJbQ2TsPR6HjqT3hPp4QIGizhEGytoF781NlJInCcE
         pg0S1F2bAlwIojoDVU1CU6cx+C2xZf+8ptFpjYz4m6VwomtnQMdIdARnabtwj/3ji+vp
         A/e0j+4I5eImXxw2NdxM7s0Kw2othTZUFTBlTGJGn2WJ+HXJUWWNEjuGx1r85yWW7HoA
         sA/BhqM6BwYEqH6nQK6BGKnnDMEjtKBhW6IJxNJ8FR99zeOVOnNdKif+4gelXwbwAEim
         ydOw==
X-Gm-Message-State: AOAM530z2CkxAkBjMttaIsgGz6EFnk7Y3iU+t7VvDaHui1ZRqbthsxkf
        jhDTjM7ygclrhZVIBUrI8KQb7G32QtwQFQ==
X-Google-Smtp-Source: ABdhPJw3SnxXvACOlg8WeaS8CjLoBqJQR16Ks3N/LdMbDTzM+92Wm9xLmrtfd/TPQMY3fCLi3NJMjg==
X-Received: by 2002:a17:902:8c84:: with SMTP id t4mr803071plo.315.1592427948725;
        Wed, 17 Jun 2020 14:05:48 -0700 (PDT)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id f205sm669604pfa.218.2020.06.17.14.05.47
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Jun 2020 14:05:48 -0700 (PDT)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: reap poll completions while waiting for refs to
 drop on exit
Message-ID: <f1c1611f-1242-2d4c-1a19-59dbf2a9c674@kernel.dk>
Date:   Wed, 17 Jun 2020 15:05:46 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If we're doing polled IO and end up having requests being submitted
async, then completions can come in while we're waiting for refs to
drop. We need to reap these manually, as nobody else will be looking
for them.

Break the wait into 1/20th of a second time waits, and check for done
poll completions if we time out. Otherwise we can have done poll
completions sitting in ctx->poll_list, which needs us to reap them but
we're just waiting for them.

Cc: stable@vger.kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 98c83fbf4f88..2038d52c5450 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7363,7 +7363,17 @@ static void io_ring_exit_work(struct work_struct *work)
 	if (ctx->rings)
 		io_cqring_overflow_flush(ctx, true);
 
-	wait_for_completion(&ctx->ref_comp);
+	/*
+	 * If we're doing polled IO and end up having requests being
+	 * submitted async (out-of-line), then completions can come in while
+	 * we're waiting for refs to drop. We need to reap these manually,
+	 * as nobody else will be looking for them.
+	 */
+	while (!wait_for_completion_timeout(&ctx->ref_comp, HZ/20)) {
+		io_iopoll_reap_events(ctx);
+		if (ctx->rings)
+			io_cqring_overflow_flush(ctx, true);
+	}
 	io_ring_ctx_free(ctx);
 }
 
-- 
Jens Axboe

