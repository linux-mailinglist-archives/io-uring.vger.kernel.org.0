Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04BA55374EA
	for <lists+io-uring@lfdr.de>; Mon, 30 May 2022 09:23:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232936AbiE3GiW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 30 May 2022 02:38:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231825AbiE3GiV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 30 May 2022 02:38:21 -0400
Received: from pv50p00im-ztdg10021901.me.com (pv50p00im-ztdg10021901.me.com [17.58.6.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73BBD19C0D
        for <io-uring@vger.kernel.org>; Sun, 29 May 2022 23:38:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com;
        s=1a1hai; t=1653892700;
        bh=tA3Nii9CNGxKYW/YSQxFuTscgNq9xe/LMk37rOL/+Ls=;
        h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
        b=iGvO8vTrgFZCQDG7KcdoaG1NGzByZTV/wTMucdRDu4Br46Zg2qb/QQeZv8iC3J+or
         zNk73vawfq0Lg1ODisO2asPpJmGWfdH8tlKTBF+WRez+SMo0AxNF4edhJlRIiVoEqt
         YnGclyQjoUEr8lmCOxrtd2fp3L76DldpiRuugSZWfvUus1faoRieju37NJ0Qxf/da0
         rDSNyT8H+hBgmnesB+qBxvSozUNfvp/Sge9DdFPkB0W5L9hpqQlPte/0I6o0a7LE3H
         56wXo4l7mm2r0ZE6ac8zK/D4ldZNQvEgDNdvSaCIeWYsQwtFpExXL82UXcbwYuaTla
         yJzWGNgPpTg7w==
Received: from [192.168.31.207] (pv50p00im-dlb-asmtp-mailmevip.me.com [17.56.9.10])
        by pv50p00im-ztdg10021901.me.com (Postfix) with ESMTPSA id E91BC8149E;
        Mon, 30 May 2022 06:38:17 +0000 (UTC)
Message-ID: <5aa1d864-f4ee-643d-500d-0542d6fb72f3@icloud.com>
Date:   Mon, 30 May 2022 14:38:13 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 2/2] io_uring: switch cancel_hash to use per list spinlock
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <20220529162000.32489-1-haoxu.linux@icloud.com>
 <20220529162000.32489-3-haoxu.linux@icloud.com>
 <37c50986-8a47-5eb4-d416-cbbfd54497b0@kernel.dk>
 <2c7bf862-5d94-892c-4026-97e85ba78593@icloud.com>
 <2ed2d510-759b-86fb-8f31-4cb7522c77e6@kernel.dk>
 <d476c344-56ea-db57-052a-876605662362@gmail.com>
From:   Hao Xu <haoxu.linux@icloud.com>
In-Reply-To: <d476c344-56ea-db57-052a-876605662362@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-30_02:2022-05-27,2022-05-30 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015 mlxscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-2009150000 definitions=main-2205300034
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/30/22 06:50, Pavel Begunkov wrote:
> On 5/29/22 19:40, Jens Axboe wrote:
>> On 5/29/22 12:07 PM, Hao Xu wrote:
>>> On 5/30/22 00:25, Jens Axboe wrote:
>>>> On 5/29/22 10:20 AM, Hao Xu wrote:
>>>>> From: Hao Xu <howeyxu@tencent.com>
>>>>>
>>>>> From: Hao Xu <howeyxu@tencent.com>
>>>>>
>>>>> Use per list lock for cancel_hash, this removes some completion lock
>>>>> invocation and remove contension between different cancel_hash entries
>>>>
>>>> Interesting, do you have any numbers on this?
>>>
>>> Just Theoretically for now, I'll do some tests tomorrow. This is
>>> actually RFC, forgot to change the subject.
>>>
>>>>
>>>> Also, I'd make a hash bucket struct:
>>>>
>>>> struct io_hash_bucket {
>>>>      spinlock_t lock;
>>>>      struct hlist_head list;
>>>> };
>>>>
>>>> rather than two separate structs, that'll have nicer memory locality 
>>>> too
>>>> and should further improve it. Could be done as a prep patch with the
>>>> old locking in place, making the end patch doing the per-bucket lock
>>>> simpler as well.
>>>
>>> Sure, if the test number make sense, I'll send v2. I'll test the
>>> hlist_bl list as well(the comment of it says it is much slower than
>>> normal spin_lock, but we may not care the efficiency of poll
>>> cancellation very much?).
>>
>> I don't think the bit spinlocks are going to be useful, we should
>> stick with a spinlock for this. They are indeed slower and generally not
>> used for that reason. For a use case where you need a ton of locks and
>> saving the 4 bytes for a spinlock would make sense (or maybe not
>> changing some struct?), maybe they have a purpose. But not for this.
> 
> We can put the cancel hashes under uring_lock and completely kill
> the hash spinlocking (2 lock/unlock pairs per single-shot). The code
> below won't even compile and missing cancellation bits, I'll pick it
> up in a week.
> 
> Even better would be to have two hash tables, and auto-magically apply
> the feature to SINGLE_SUBMITTER, SQPOLL (both will have uring_lock held)
> and apoll (need uring_lock after anyway).
> 
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 6be21967959d..191fa7f31610 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -7120,12 +7120,20 @@ static void io_poll_task_func(struct io_kiocb 
> *req, bool *locked)
>       }
> 
>       io_poll_remove_entries(req);
> -    spin_lock(&ctx->completion_lock);
> -    hash_del(&req->hash_node);
> -    __io_req_complete_post(req, req->cqe.res, 0);
> -    io_commit_cqring(ctx);
> -    spin_unlock(&ctx->completion_lock);
> -    io_cqring_ev_posted(ctx);
> +
> +    if (ctx->flags & IORING_MUTEX_HASH) {
> +        io_tw_lock(ctx, locked);
> +        hash_del(&req->hash_node);
> +        io_req_complete_state(req, req->cqe.res, 0);
> +        io_req_add_compl_list(req);
> +    } else {
> +        spin_lock(&ctx->completion_lock);
> +        hash_del(&req->hash_node);
> +        __io_req_complete_post(req, req->cqe.res, 0);
> +        io_commit_cqring(ctx);
> +        spin_unlock(&ctx->completion_lock);
> +        io_cqring_ev_posted(ctx);
> +    }
>   }
> 
>   static void io_apoll_task_func(struct io_kiocb *req, bool *locked)
> @@ -7138,9 +7146,14 @@ static void io_apoll_task_func(struct io_kiocb 
> *req, bool *locked)
>           return;
> 
>       io_poll_remove_entries(req);
> -    spin_lock(&ctx->completion_lock);
> -    hash_del(&req->hash_node);
> -    spin_unlock(&ctx->completion_lock);
> +    if (ctx->flags & IORING_MUTEX_HASH) {
> +        io_tw_lock(ctx, locked);
> +        hash_del(&req->hash_node);
> +    } else {
> +        spin_lock(&ctx->completion_lock);
> +        hash_del(&req->hash_node);
> +        spin_unlock(&ctx->completion_lock);
> +    }
> 
>       if (!ret)
>           io_req_task_submit(req, locked);
> @@ -7332,9 +7345,13 @@ static int __io_arm_poll_handler(struct io_kiocb 
> *req,
>           return 0;
>       }
> 
> -    spin_lock(&ctx->completion_lock);
> -    io_poll_req_insert(req);
> -    spin_unlock(&ctx->completion_lock);
> +    if (ctx->flags & IORING_MUTEX_HASH) {

Does IORING_MUTEX_HASH exclude IOSQE_ASYNC as well? though IOSQE_ASYNC
is uncommon but users may do that.

> +        io_poll_req_insert(req);
> +    } else {
> +        spin_lock(&ctx->completion_lock);
> +        io_poll_req_insert(req);
> +        spin_unlock(&ctx->completion_lock);
> +    }
> 
>       if (mask) {
>           /* can't multishot if failed, just queue the event we've got */

