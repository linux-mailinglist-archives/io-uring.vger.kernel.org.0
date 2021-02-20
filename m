Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C90273205A3
	for <lists+io-uring@lfdr.de>; Sat, 20 Feb 2021 15:11:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229614AbhBTOLm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 20 Feb 2021 09:11:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbhBTOLi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 20 Feb 2021 09:11:38 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13445C061574
        for <io-uring@vger.kernel.org>; Sat, 20 Feb 2021 06:10:58 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id l13so780909wmg.5
        for <io-uring@vger.kernel.org>; Sat, 20 Feb 2021 06:10:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5k4zqm2KaaCSbsr5a2EpFJVEljPsxK/1/8IP1Z4X7J4=;
        b=vgVbCYuG6ob0MIyrN3DLEDS5yqsWus2YQnBwZ4QEqsS1U/EC5pshh6JFksnhsXo+IW
         u4xLCGrogVeCEKBjDujtyFoTRVHDRMkRVGpJCX8OjLwnCOqjNn0ep/JkzldSCMCMzlHs
         NwjUkyyYyOnZlTBCNQx3mlL+xEuFYOFNxjBuZ+YcPhgzPeqPQFkBbMso/GfIdv2IFjCc
         CcwDIXSJuYufm4VJ3qsYIjcTKzK81YVO+p9oEYp9TRNSWaZ1ybdyNfwTpcQ1uYHnAEQm
         2wYfg2FvE/Jv+PryLJyE+0Bmr7lWyyHPHVbffSjvgCR2IEGJKaD7bahNeNp4LJidiXyt
         nmFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5k4zqm2KaaCSbsr5a2EpFJVEljPsxK/1/8IP1Z4X7J4=;
        b=Zw9kfCIYJxcDEUoP1IbhZzDQy1PEBfu+Q40aw6VI/clhEuu8sbD+xmttLQAhA1t0XC
         A89J7IyBTmUH64ILGPEBiAKkSeAFKCf2phIECZrHpAqloNgMIqeImpTrbVwf2Jj3Rtn3
         LHMiBihfOZchQRPkWi/2FsBP1qF4m16zrqT1kuZhri7NOW/G5qgQGxce6iaeBxMSSsAE
         XlUxJKZkzCDChY4kHKIei0kqZbOc58VZyEAJdFvX0c3bp5cxhpG1HWynZjPi+F0M7weL
         Nay09Yg5YjqLcWOwagsvemIQ1XgyyGP31BWJUZ0kRSo9q2WNKLFHu/DJMkLP+DIsC6la
         OvtA==
X-Gm-Message-State: AOAM5308d9866cdB/4AvRom/5Ce1zMIM8HS22T3ktdslNbZ8X9OU/XvS
        mFwrc8Aq7c9NlTszfuLw2E0+Sq90jk1DdQ==
X-Google-Smtp-Source: ABdhPJxrMuNbztKHdjHFexOzerFlwmiLmc0dUoeCKDDzyUmqyQ5TE0VVGvqiHlVSDqJTW4NavbS8ig==
X-Received: by 2002:a1c:9843:: with SMTP id a64mr12500940wme.44.1613830256510;
        Sat, 20 Feb 2021 06:10:56 -0800 (PST)
Received: from [192.168.8.141] ([148.252.132.56])
        by smtp.gmail.com with ESMTPSA id 7sm6627246wmi.27.2021.02.20.06.10.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 20 Feb 2021 06:10:55 -0800 (PST)
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org
References: <cover.1613767375.git.asml.silence@gmail.com>
 <1b71f4059f088b035ec72307321f051a7be2d44f.1613767375.git.asml.silence@gmail.com>
 <e5c131a0-402d-31df-b5f9-156434bf3f29@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH 2/3] io_uring: fix io_rsrc_ref_quiesce races
Message-ID: <070f2274-187d-8ee8-e841-f44beeba4fd0@gmail.com>
Date:   Sat, 20 Feb 2021 14:07:05 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <e5c131a0-402d-31df-b5f9-156434bf3f29@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 20/02/2021 06:31, Hao Xu wrote:
> 在 2021/2/20 上午4:45, Pavel Begunkov 写道:
>> There are different types of races in io_rsrc_ref_quiesce()  between
>> ->release() of percpu_refs and reinit_completion(), fix them by always
>> resurrecting between iterations. BTW, clean the function up, because
>> DRY.
>>
>> Fixes: 0ce4a72632317 ("io_uring: don't hold uring_lock when calling io_run_task_work*")
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
>>   fs/io_uring.c | 46 +++++++++++++---------------------------------
>>   1 file changed, 13 insertions(+), 33 deletions(-)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index 50d4dba08f82..38ed52065a29 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -7316,19 +7316,6 @@ static void io_sqe_rsrc_set_node(struct io_ring_ctx *ctx,
>>       percpu_ref_get(&rsrc_data->refs);
>>   }
>>   -static int io_sqe_rsrc_add_node(struct io_ring_ctx *ctx, struct fixed_rsrc_data *data)
>> -{
>> -    struct fixed_rsrc_ref_node *backup_node;
>> -
>> -    backup_node = alloc_fixed_rsrc_ref_node(ctx);
>> -    if (!backup_node)
>> -        return -ENOMEM;
>> -    init_fixed_file_ref_node(ctx, backup_node);
>> -    io_sqe_rsrc_set_node(ctx, data, backup_node);
>> -
>> -    return 0;
>> -}
>> -
>>   static void io_sqe_rsrc_kill_node(struct io_ring_ctx *ctx, struct fixed_rsrc_data *data)
>>   {
>>       struct fixed_rsrc_ref_node *ref_node = NULL;
>> @@ -7347,36 +7334,29 @@ static int io_rsrc_ref_quiesce(struct fixed_rsrc_data *data,
>>   {
>>       int ret;
>>   -    io_sqe_rsrc_kill_node(ctx, data);
>> -    percpu_ref_kill(&data->refs);
>> -
>> -    /* wait for all refs nodes to complete */
>> -    flush_delayed_work(&ctx->rsrc_put_work);
>>       do {
>> +        io_sqe_rsrc_kill_node(ctx, data);
>> +        percpu_ref_kill(&data->refs);
>> +        flush_delayed_work(&ctx->rsrc_put_work);
>> +
>>           ret = wait_for_completion_interruptible(&data->done);
>>           if (!ret)
>>               break;
>>   -        ret = io_sqe_rsrc_add_node(ctx, data);
>> -        if (ret < 0)
>> -            break;
>> -        /*
>> -         * There is small possibility that data->done is already completed
>> -         * So reinit it here
>> -         */
>> +        percpu_ref_resurrect(&data->refs);
> I've thought about this, if we resurrect data->refs, then we can't
> avoid parallel files unregister by percpu_refs_is_dying.

Right, totally forgot about it, but otherwise we race with data->done.
Didn't test yet, but a diff below should do the trick.

>> +        if (ret < 0)
>> +            return ret;
>> +        backup_node = alloc_fixed_rsrc_ref_node(ctx);
>> +        if (!backup_node)
>> +            return -ENOMEM;
> Should we resurrect data->refs and reinit completion before
> signal or error return?

Not sure what exactly you mean, we should not release uring_lock with
inconsistent state, so it's done right before unlock. And we should not
do it before wait_for_completion_interruptible() before it would take a
reference.

>> +        init_fixed_file_ref_node(ctx, backup_node);
>> +    } while (1);
>>         destroy_fixed_rsrc_ref_node(backup_node);
>>       return 0;
>>
> 

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ce5fccf00367..0af1572634de 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -236,6 +236,7 @@ struct fixed_rsrc_data {
 	struct fixed_rsrc_ref_node	*node;
 	struct percpu_ref		refs;
 	struct completion		done;
+	bool				quiesce;
 };
 
 struct io_buffer {
@@ -7335,6 +7336,7 @@ static int io_rsrc_ref_quiesce(struct fixed_rsrc_data *data,
 	struct fixed_rsrc_ref_node *backup_node;
 	int ret;
 
+	data->quiesce = true;
 	do {
 		backup_node = alloc_fixed_rsrc_ref_node(ctx);
 		if (!backup_node)
@@ -7353,16 +7355,19 @@ static int io_rsrc_ref_quiesce(struct fixed_rsrc_data *data,
 		percpu_ref_resurrect(&data->refs);
 		synchronize_rcu();
 		io_sqe_rsrc_set_node(ctx, data, backup_node);
+		backup_node = NULL;
 		reinit_completion(&data->done);
 		mutex_unlock(&ctx->uring_lock);
 		ret = io_run_task_work_sig();
 		mutex_lock(&ctx->uring_lock);
 		if (ret < 0)
 			return ret;
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
@@ -7401,7 +7406,7 @@ static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
 	 * Since we possibly drop uring lock later in this function to
 	 * run task work.
 	 */
-	if (!data || percpu_ref_is_dying(&data->refs))
+	if (!data || data->quiesce)
 		return -ENXIO;
 	ret = io_rsrc_ref_quiesce(data, ctx, io_ring_file_put);
 	if (ret)
