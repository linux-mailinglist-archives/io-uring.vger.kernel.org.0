Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2F5C3205BD
	for <lists+io-uring@lfdr.de>; Sat, 20 Feb 2021 15:37:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229525AbhBTOhn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 20 Feb 2021 09:37:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbhBTOhj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 20 Feb 2021 09:37:39 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBEEFC061786
        for <io-uring@vger.kernel.org>; Sat, 20 Feb 2021 06:36:57 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id a207so10391239wmd.1
        for <io-uring@vger.kernel.org>; Sat, 20 Feb 2021 06:36:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:references:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=82VvvSQVo4U4eiP5a3s1VgSm07/9QjOpeCDgLncsZrA=;
        b=OcxUtZhlNy0w8n/R3j5W2QYM8VUt1Tck9wnZxJN+LZejz9pm1hDFOCJ0TNMKE4RmIk
         wHicYAD8W5H1n2Gus99Ed0eeZSk5XjDuNS1eFPAKPoW6jwqExs2rlaNV24x9KRCEf6RO
         Nde/P3TtKV5NzifWDb8ZNyd6Dcrzjq4xaaGwRGZ5PM6+0ICkkLOJp7esQBtHuOI2VtOq
         YAZJ4AYJOoP1EudlGnzEmTPYG2gO6CJEM0g7wdd7mga0mghtdsKDN6zZtpj/D0ZVXN6e
         ZTdR8PIwhI17aazxPUT4OW6cn23PfDvxnCqH/V2l5maG4u/RpqKn4Nb8zziE+1CDppbR
         l+7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=82VvvSQVo4U4eiP5a3s1VgSm07/9QjOpeCDgLncsZrA=;
        b=F/nfcqJ2FuJoeACzpRFZSxApHhupC8Gh2cqGu7rq3OeDT1eWWdJnBMlrUsKnrN5AT8
         T5BSoeVw06m8eRQDW9+yShvfi2E/OBvFmFBAKzIMcHYTPpT0MUQgIZAUOJbRSClhmCVr
         H8nuL4j5f1Qf7lmPO6h0rJC4YwxgfW02/BFsdjf3LDxhutgn1mcbUTTH8RQjFUwC5EM4
         0kTwn9IlQrq1tECXM7t7iN9XrHMQ8S7r/51b5SfUwxAu043tAyjaqXow+r5yXtjUqPVr
         Eo+YiRmqHK4gm0wSBqC895SNUNICNfVpfCba8ngtm46bS4jPFWqn+Uq5RYglyKz8F5gT
         xYKg==
X-Gm-Message-State: AOAM531PnmiLDUO4B4LtFvrMyR5CLLyDytTUxk0N2445d0CtDayhfmMA
        BroNmSJJpJszWU4pvl4bfDStjHlPXQVXvA==
X-Google-Smtp-Source: ABdhPJzTuLEJobXtdL7x5kgAs56C6prJV2TN8JrPTsBrE6YRACHEUiYrnuSeU9w0H8T8UkRfgGqMMA==
X-Received: by 2002:a05:600c:898:: with SMTP id l24mr12945917wmp.154.1613831816460;
        Sat, 20 Feb 2021 06:36:56 -0800 (PST)
Received: from [192.168.8.141] ([148.252.132.56])
        by smtp.gmail.com with ESMTPSA id q21sm20621766wmj.18.2021.02.20.06.36.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 20 Feb 2021 06:36:56 -0800 (PST)
Subject: Re: [PATCH 2/3] io_uring: fix io_rsrc_ref_quiesce races
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org
References: <cover.1613767375.git.asml.silence@gmail.com>
 <1b71f4059f088b035ec72307321f051a7be2d44f.1613767375.git.asml.silence@gmail.com>
 <e5c131a0-402d-31df-b5f9-156434bf3f29@linux.alibaba.com>
 <070f2274-187d-8ee8-e841-f44beeba4fd0@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <c298151b-522b-e66c-210d-69cf9a1c52e8@gmail.com>
Date:   Sat, 20 Feb 2021 14:33:06 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <070f2274-187d-8ee8-e841-f44beeba4fd0@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 20/02/2021 14:07, Pavel Begunkov wrote:
> On 20/02/2021 06:31, Hao Xu wrote:
>> 在 2021/2/20 上午4:45, Pavel Begunkov 写道:
>>> There are different types of races in io_rsrc_ref_quiesce()  between
>>> ->release() of percpu_refs and reinit_completion(), fix them by always
>>> resurrecting between iterations. BTW, clean the function up, because
>>> DRY.
>>>
>>> Fixes: 0ce4a72632317 ("io_uring: don't hold uring_lock when calling io_run_task_work*")
>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>> ---
>>> -        /*
>>> -         * There is small possibility that data->done is already completed
>>> -         * So reinit it here
>>> -         */
>>> +        percpu_ref_resurrect(&data->refs);
>> I've thought about this, if we resurrect data->refs, then we can't
>> avoid parallel files unregister by percpu_refs_is_dying.
> 
> Right, totally forgot about it, but otherwise we race with data->done.
> Didn't test yet, but a diff below should do the trick.
> 
>>> +        if (ret < 0)
>>> +            return ret;
>>> +        backup_node = alloc_fixed_rsrc_ref_node(ctx);
>>> +        if (!backup_node)
>>> +            return -ENOMEM;
>> Should we resurrect data->refs and reinit completion before
>> signal or error return?
> 
> Not sure what exactly you mean, we should not release uring_lock with
> inconsistent state, so it's done right before unlock. And we should not
> do it before wait_for_completion_interruptible() before it would take a
> reference.
> 
>>> +        init_fixed_file_ref_node(ctx, backup_node);
>>> +    } while (1);
>>>         destroy_fixed_rsrc_ref_node(backup_node);
>>>       return 0;

upd

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ce5fccf00367..12796de8ad10 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -236,6 +236,7 @@ struct fixed_rsrc_data {
 	struct fixed_rsrc_ref_node	*node;
 	struct percpu_ref		refs;
 	struct completion		done;
+	bool				quiesce;
 };
 
 struct io_buffer {
@@ -7335,10 +7336,12 @@ static int io_rsrc_ref_quiesce(struct fixed_rsrc_data *data,
 	struct fixed_rsrc_ref_node *backup_node;
 	int ret;
 
+	data->quiesce = true;
 	do {
 		backup_node = alloc_fixed_rsrc_ref_node(ctx);
+		ret = -ENOMEM;
 		if (!backup_node)
-			return -ENOMEM;
+			break;
 		backup_node->rsrc_data = data;
 		backup_node->rsrc_put = rsrc_put;
 
@@ -7353,16 +7356,17 @@ static int io_rsrc_ref_quiesce(struct fixed_rsrc_data *data,
 		percpu_ref_resurrect(&data->refs);
 		synchronize_rcu();
 		io_sqe_rsrc_set_node(ctx, data, backup_node);
+		backup_node = NULL;
 		reinit_completion(&data->done);
 		mutex_unlock(&ctx->uring_lock);
 		ret = io_run_task_work_sig();
 		mutex_lock(&ctx->uring_lock);
-		if (ret < 0)
-			return ret;
-	} while (1);
+	} while (ret >= 0);
 
-	destroy_fixed_rsrc_ref_node(backup_node);
-	return 0;
+	data->quiesce = false;
+	if (backup_node)
+		destroy_fixed_rsrc_ref_node(backup_node);
+	return ret;
 }
 
 static struct fixed_rsrc_data *alloc_fixed_rsrc_data(struct io_ring_ctx *ctx)
@@ -7401,7 +7405,7 @@ static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
 	 * Since we possibly drop uring lock later in this function to
 	 * run task work.
 	 */
-	if (!data || percpu_ref_is_dying(&data->refs))
+	if (!data || data->quiesce)
 		return -ENXIO;
 	ret = io_rsrc_ref_quiesce(data, ctx, io_ring_file_put);
 	if (ret)


-- 
Pavel Begunkov
