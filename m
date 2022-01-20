Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE17D4953E2
	for <lists+io-uring@lfdr.de>; Thu, 20 Jan 2022 19:10:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232511AbiATSKq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Jan 2022 13:10:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232336AbiATSKp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Jan 2022 13:10:45 -0500
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56166C061574
        for <io-uring@vger.kernel.org>; Thu, 20 Jan 2022 10:10:45 -0800 (PST)
Received: by mail-il1-x12a.google.com with SMTP id d14so5712475ila.1
        for <io-uring@vger.kernel.org>; Thu, 20 Jan 2022 10:10:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=1tmWeP9e/IA10sRfB+rgtR1rkvJ+UJ6unnuIuvel9FA=;
        b=qVg6sJZwrs8eNGZDPeBzeDzRFlh6rDfhN3mTTHA7V7Z9PtpoQCHptfEISMNboVQ2mU
         Ywxahj97zY0qqwoLq0hn5NIHKHpEcsS+NuC6IUhvFiBwTGmstPKixP5OkyT/utm2L0Pd
         e0O19PUgxhDcCCzDHnb7f2IQLkTooyMz+/zQ68ppdA6vpgZnbKs9A+4bOsZGu0b3RWvz
         LuOqx4mSwYcU4aS1ZUEXi37gaR3CRm0y4RRR+EdpemE6pXlfntsi6u7+LmiOKqFaKW9L
         Le5VxoCI9JOxJIoh9q6HBtTc+KKD8hhBDEMYjmVFlUeHwh3h8rmUbMm9v2PHbaD5d+As
         TkJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=1tmWeP9e/IA10sRfB+rgtR1rkvJ+UJ6unnuIuvel9FA=;
        b=EWLoi8E+LU991IlITXOOIBOg/2hsr0AMkQV6V6Xms3ZD07f6vhCLRrCMcpqzB3qXhk
         Sv2A6Lr2SrCGgKY6df21gXQp5fwrS14e9mpnBTb859/rporO6G27/WlWt+4KIKpnQyFO
         fZQEIsvnE8dtgJGSiltvQN72v2G75g0KhBOhrD1ik4okO+Idy2e7uI510Swfdw0lCyc3
         lI92qh/av4he10Ud41marRqvLpInfHU3jBEj2DLbiRFmBTfG5J4AaaDyiC4jlkZdVokl
         9AYIsfUT2pr2OZU4AqXiGQAGmkGbIwB+RMeyL7RawekNg6FEOLHml9k4FcCntIx7vbaX
         laVA==
X-Gm-Message-State: AOAM530ee9CPMKPsKvTSRWk77zb5ZAlmM0bFPIYQ307Zndmjhxvmn7Wo
        lSPcnzWhA8hZNsh+b6L5HtZT+L4hvE/cLw==
X-Google-Smtp-Source: ABdhPJxHTMAraOb3+wNaMARNL3zD5jIJyeo1+nPWemIaVfxrfKGv6iUB8vaphdFWOB+8MK0t6xhQWQ==
X-Received: by 2002:a92:ca49:: with SMTP id q9mr91485ilo.23.1642702244457;
        Thu, 20 Jan 2022 10:10:44 -0800 (PST)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id i3sm1781188ilu.28.2022.01.20.10.10.43
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Jan 2022 10:10:43 -0800 (PST)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io-wq: delete dead lock shuffling code
Message-ID: <d4532a4d-a2e5-e29d-4b2b-5f98689d985d@kernel.dk>
Date:   Thu, 20 Jan 2022 11:10:43 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We used to have more code around the work loop, but now the goto and
lock juggling just makes it less readable than it should. Get rid of it.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

Came across this one while looking at related code.

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 1efb134c98b7..013e12b9fabf 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -547,7 +547,7 @@ static void io_worker_handle_work(struct io_worker *worker)
 
 	do {
 		struct io_wq_work *work;
-get_next:
+
 		/*
 		 * If we got some work, mark us as busy. If we didn't, but
 		 * the list isn't empty, it means we stalled on hashed work.
@@ -606,11 +606,6 @@ static void io_worker_handle_work(struct io_worker *worker)
 				spin_unlock_irq(&wq->hash->wait.lock);
 				if (wq_has_sleeper(&wq->hash->wait))
 					wake_up(&wq->hash->wait);
-				raw_spin_lock(&wqe->lock);
-				/* skip unnecessary unlock-lock wqe->lock */
-				if (!work)
-					goto get_next;
-				raw_spin_unlock(&wqe->lock);
 			}
 		} while (work);
 
-- 
Jens Axboe

