Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C216B17D810
	for <lists+io-uring@lfdr.de>; Mon,  9 Mar 2020 03:13:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726414AbgCICNm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 8 Mar 2020 22:13:42 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:36415 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726346AbgCICNl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 8 Mar 2020 22:13:41 -0400
Received: by mail-pg1-f193.google.com with SMTP id d9so3998757pgu.3
        for <io-uring@vger.kernel.org>; Sun, 08 Mar 2020 19:13:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=cYdedVmS6neOi3Aiud/LZc+mvwjY90q8sYJtfAg6Xno=;
        b=F0N7u5jxIUkmb6GrGXNY/GTMFUFuAakJe0VuKus6seHf50gdftczQKkHW3S7L1v3E3
         kRM9YXqNDLjSooPYEfsal+Wmghb+jMhTH6uTCRqR340XOgpCvhZJTIivmOdGWRTvQER+
         J6XG7Rvt4BuRH1L4fuMRSqYyZXN9LV9W5SfKCQSBkID1vPpwP98+1rOlt8VyacHffB77
         NLMShJwpt+CerZz3yd1XBxlkFV49CuXdNPY5lhuYUmDnT18G6CGKRoIju74XVR4nKwuT
         YwQKeLsAcsO9J05MvRKBjuxS3UDT4l3X7WoTrb5UMinLyCFxaJX6aqBXBiMG1kjRuSYU
         oYyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=cYdedVmS6neOi3Aiud/LZc+mvwjY90q8sYJtfAg6Xno=;
        b=MzmU2Z5DvB/eVwFYAQFR5NKVMhWp36ox+nTQxprgbhuQoZo96Rn7Qm8Ne2dCHRy3BN
         acDIwZT7ahfqK1U9VaQYJNUJ5X7TKyH3/Eypb6k+suDIcQSSyHpJJlpAtbXMMoPaa44w
         ZH6K/mgVXzguIVZeMnXJFAkaQIL5EajiArwgkXk+wYgAZiPRn1sdGENSPPjV+M7iuhk3
         HTBFoFr7jYozH1BLhXDibjVCf9WI1FNe5aWloxLJHN3fq4LWzR2zES4YDtePxEXFdRW3
         m6bVmHkEVb8nTWd5IzJ23vG6eSPCmm7VY7EanFpA81SOZLDNmkz9ACgOisxLmSQQrbQ/
         w55g==
X-Gm-Message-State: ANhLgQ2UX56yw6Z0sTFz17Ie4mRLFq50/5QkapdR/OrxA+3dJ37Dvm1s
        P6uGcklKnE4ebhTF1Fy3frp4dw==
X-Google-Smtp-Source: ADFU+vuLFg3BySMjkg11+Hd0plG9sd71PB/mWxFszh4hFDoaj0kDMOYxk3PKFyVkrYRK+FgCQWCWvA==
X-Received: by 2002:a63:120f:: with SMTP id h15mr14389579pgl.235.1583720018911;
        Sun, 08 Mar 2020 19:13:38 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id s25sm15842747pfe.147.2020.03.08.19.13.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 08 Mar 2020 19:13:38 -0700 (PDT)
To:     io-uring <io-uring@vger.kernel.org>
Cc:     Jann Horn <jannh@google.com>, Paul McKenney <paulmck@kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: ensure RCU callback ordering with rcu_barrier()
Message-ID: <8caf1bef-bd07-f8b6-6ada-c1145e3337fc@kernel.dk>
Date:   Sun, 8 Mar 2020 20:13:37 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

After more careful studying, Paul informs me that we cannot rely on
ordering of RCU callbacks in the way that the the tagged commit did.
The current construct looks like this:

        void C(struct rcu_head *rhp)
        {
                do_something(rhp);
                call_rcu(&p->rh, B);
        }

        call_rcu(&p->rh, A);
        call_rcu(&p->rh, C);

and we're relying on ordering between A and B, which isn't guaranteed.
Make this explicit instead, and have a work item issue the rcu_barrier()
to ensure that A has run before we manually execute B.

While thorough testing never showed this issue, it's dependent on the
per-cpu load in terms of RCU callbacks. The updated method simplifies
the code as well, and eliminates the need to maintain an rcu_head in
the fileset data.

Fixes: c1e2148f8ecb ("io_uring: free fixed_file_data after RCU grace period")
Reported-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io_uring.c b/fs/io_uring.c
index c06082bb039a..1b2517291b78 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -191,7 +191,6 @@ struct fixed_file_data {
 	struct llist_head		put_llist;
 	struct work_struct		ref_work;
 	struct completion		done;
-	struct rcu_head			rcu;
 };
 
 struct io_ring_ctx {
@@ -5331,24 +5330,21 @@ static void io_file_ref_kill(struct percpu_ref *ref)
 	complete(&data->done);
 }
 
-static void __io_file_ref_exit_and_free(struct rcu_head *rcu)
+static void io_file_ref_exit_and_free(struct work_struct *work)
 {
-	struct fixed_file_data *data = container_of(rcu, struct fixed_file_data,
-							rcu);
-	percpu_ref_exit(&data->refs);
-	kfree(data);
-}
+	struct fixed_file_data *data;
+
+	data = container_of(work, struct fixed_file_data, ref_work);
 
-static void io_file_ref_exit_and_free(struct rcu_head *rcu)
-{
 	/*
-	 * We need to order our exit+free call against the potentially
-	 * existing call_rcu() for switching to atomic. One way to do that
-	 * is to have this rcu callback queue the final put and free, as we
-	 * could otherwise have a pre-existing atomic switch complete _after_
-	 * the free callback we queued.
+	 * Ensure any percpu-ref atomic switch callback has run, it could have
+	 * been in progress when the files were being unregistered. Once
+	 * that's done, we can safely exit and free the ref and containing
+	 * data structure.
 	 */
-	call_rcu(rcu, __io_file_ref_exit_and_free);
+	rcu_barrier();
+	percpu_ref_exit(&data->refs);
+	kfree(data);
 }
 
 static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
@@ -5369,7 +5365,8 @@ static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
 	for (i = 0; i < nr_tables; i++)
 		kfree(data->table[i].files);
 	kfree(data->table);
-	call_rcu(&data->rcu, io_file_ref_exit_and_free);
+	INIT_WORK(&data->ref_work, io_file_ref_exit_and_free);
+	queue_work(system_wq, &data->ref_work);
 	ctx->file_data = NULL;
 	ctx->nr_user_files = 0;
 	return 0;

-- 
Jens Axboe

