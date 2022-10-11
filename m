Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D94585FB4DB
	for <lists+io-uring@lfdr.de>; Tue, 11 Oct 2022 16:46:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbiJKOql (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 11 Oct 2022 10:46:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbiJKOql (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 11 Oct 2022 10:46:41 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDDA4558F6;
        Tue, 11 Oct 2022 07:46:39 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id n12so21947378wrp.10;
        Tue, 11 Oct 2022 07:46:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pVRX8pYTtQAG3+TzCp971/FLhIq1VC8zp6i/V1rYGLE=;
        b=Ul8/Q1MUC/mqm4e8tNaegcyk2KVH5l0X6MV8za1OhpCdwAF+uLD1dwGise32mK67gV
         lqo7EhhTeeNzcdZ86xOukWwx9dz6DM7XvnorLHHTB6LldQZYu8cSKqO4o1YgyqhozjlD
         9fI47bIMUT8TRJ3grVOhNLhlyP/UjLPNksTvl/3+dHZwVHLKnXzlDOzuQGsXGFhflLFR
         /knHs/y5E+cEpPjzCYyLr0gBYnqYyN0u/Q5802znVgvkw2ZQX7WXrlgHqZrVoQ4y/jgT
         nR2WRn9bFSO25iQdW6uZqCB6KQUvxo35SNv9LuVzujRjk47jJsEJg+dl/JY2D7cdZ6Me
         Db+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pVRX8pYTtQAG3+TzCp971/FLhIq1VC8zp6i/V1rYGLE=;
        b=ILWOONcmMdjH0EQkGeGI7xitYtHj2D8rOiCQBW5zGNfHBnCrzEbVmsCV6YEXh5I42e
         dID/qZrnVzkJeF2OFaE3izSznbNZil0uRg3cjMh95F8fmnK28bn6qO8hqL5TvkcaA7ng
         K6qOy5GjSNmyDIc3IegKEZnRUscyqH3xtk0tHlI3ApFe8xGXYEdIrFNmGEP6H4OrvD28
         S4FEL90Ib4Wny6fxVGgZMV2BMqs8CiXYi3BqIbB/K0LC0X3rJFmToQ4fpgF/5QHYgI7e
         l5tPLrNKd/Mmr4h3A1ZPGVZZVfpSAQ9Q5Ax+fGz7+nF2ME7X76od15vA5ET/qb75xMWn
         abWA==
X-Gm-Message-State: ACrzQf1SM/lLhsTLNLvlan2NnjXquC7BWxk7iyixE0uX2lD34Napc+EO
        fXLQLQRifJS+60jmoUb0lrl+kNXNDvY=
X-Google-Smtp-Source: AMsMyM58YFJB0+r/UwgmUil1lQ8dWj5VsixcT9IVWetIUTGLclOdKLtxAzPzU4g9yuUAMaQ09aYfnA==
X-Received: by 2002:a5d:64e2:0:b0:22e:7060:b4a7 with SMTP id g2-20020a5d64e2000000b0022e7060b4a7mr14661244wri.129.1665499598230;
        Tue, 11 Oct 2022 07:46:38 -0700 (PDT)
Received: from [192.168.8.100] (94.196.234.149.threembb.co.uk. [94.196.234.149])
        by smtp.gmail.com with ESMTPSA id j10-20020a05600c190a00b003c6b7f5567csm3655901wmq.0.2022.10.11.07.46.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Oct 2022 07:46:37 -0700 (PDT)
Message-ID: <3aa0d616-58cc-5a3f-3662-149c089cd6b9@gmail.com>
Date:   Tue, 11 Oct 2022 15:39:42 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [regression, v6.0-rc0, io-uring?] filesystem freeze hangs on
 sb_wait_write()
To:     Jens Axboe <axboe@kernel.dk>, Dave Chinner <david@fromorbit.com>,
        viro@zeniv.linux.org.uk
Cc:     linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org
References: <20221010050319.GC2703033@dread.disaster.area>
 <20221011004025.GE2703033@dread.disaster.area>
 <8e45c8ee-fe38-75a9-04f4-cfa2d54baf88@gmail.com>
 <697611c3-04b0-e8ea-d43d-d05b7c334814@kernel.dk>
 <db66c011-4b86-1167-f1e0-9308c7e6eb71@gmail.com>
 <fbec411b-afd9-8b3b-ee2d-99a36f50a01b@kernel.dk>
 <1941f3d3-5b7a-7b87-cc53-382cac1647d6@kernel.dk>
Content-Language: en-US
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <1941f3d3-5b7a-7b87-cc53-382cac1647d6@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/11/22 15:18, Jens Axboe wrote:
> On 10/10/22 8:54 PM, Jens Axboe wrote:
>> On 10/10/22 8:10 PM, Pavel Begunkov wrote:
>>> On 10/11/22 03:01, Jens Axboe wrote:
>>>> On 10/10/22 7:10 PM, Pavel Begunkov wrote:
>>>>> On 10/11/22 01:40, Dave Chinner wrote:
>>>>> [...]
>>>>>> I note that there are changes to the the io_uring IO path and write
>>>>>> IO end accounting in the io_uring stack that was merged, and there
>>>>>> was no doubt about the success/failure of the reproducer at each
>>>>>> step. Hence I think the bisect is good, and the problem is someone
>>>>>> in the io-uring changes.
>>>>>>
>>>>>> Jens, over to you.
>>>>>>
>>>>>> The reproducer - generic/068 - is 100% reliable here, io_uring is
>>>>>> being exercised by fsstress in the background whilst the filesystem
>>>>>> is being frozen and thawed repeatedly. Some path in the io-uring
>>>>>> code has an unbalanced sb_start_write()/sb_end_write() pair by the
>>>>>> look of it....
>>>>>
>>>>> A quick guess, it's probably
>>>>>
>>>>> b000145e99078 ("io_uring/rw: defer fsnotify calls to task context")
>>>>>
>>>>> ?From a quick look, it removes? kiocb_end_write() -> sb_end_write()
>>>>> from kiocb_done(), which is a kind of buffered rw completion path.
>>>>
>>>> Yeah, I'll take a look.
>>>> Didn't get the original email, only Pavel's reply?
>>>
>>> Forwarded.
>>
>> Looks like the email did get delivered, it just ended up in the
>> fsdevel inbox.
> 
> Nope, it was marked as spam by gmail...
> 
>>> Not tested, but should be sth like below. Apart of obvious cases
>>> like __io_complete_rw_common() we should also keep in mind
>>> when we don't complete the request but ask for reissue with
>>> REQ_F_REISSUE, that's for the first hunk
>>
>> Can we move this into a helper?
> 
> Something like this? Not super happy with it, but...

Sounds good. Would be great to drop a comment why it's ok to move
back io_req_io_end() into __io_complete_rw_common() under the
io_rw_should_reissue() "if".


> diff --git a/io_uring/rw.c b/io_uring/rw.c
> index 453e0ae92160..1c8d00f9af9f 100644
> --- a/io_uring/rw.c
> +++ b/io_uring/rw.c
> @@ -234,11 +234,32 @@ static void kiocb_end_write(struct io_kiocb *req)
>   	}
>   }
>   
> +/*
> + * Trigger the notifications after having done some IO, and finish the write
> + * accounting, if any.
> + */
> +static void io_req_io_end(struct io_kiocb *req)
> +{
> +	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
> +
> +	if (rw->kiocb.ki_flags & IOCB_WRITE) {
> +		kiocb_end_write(req);
> +		fsnotify_modify(req->file);
> +	} else {
> +		fsnotify_access(req->file);
> +	}
> +}
> +
>   static bool __io_complete_rw_common(struct io_kiocb *req, long res)
>   {
>   	if (unlikely(res != req->cqe.res)) {
>   		if ((res == -EAGAIN || res == -EOPNOTSUPP) &&
>   		    io_rw_should_reissue(req)) {
> +			/*
> +			 * Reissue will start accounting again, finish the
> +			 * current cycle.
> +			 */
> +			io_req_io_end(req);
>   			req->flags |= REQ_F_REISSUE | REQ_F_PARTIAL_IO;
>   			return true;
>   		}
> @@ -264,15 +285,7 @@ static inline int io_fixup_rw_res(struct io_kiocb *req, long res)
>   
>   static void io_req_rw_complete(struct io_kiocb *req, bool *locked)
>   {
> -	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
> -
> -	if (rw->kiocb.ki_flags & IOCB_WRITE) {
> -		kiocb_end_write(req);
> -		fsnotify_modify(req->file);
> -	} else {
> -		fsnotify_access(req->file);
> -	}
> -
> +	io_req_io_end(req);
>   	io_req_task_complete(req, locked);
>   }
>   
> @@ -317,6 +330,7 @@ static int kiocb_done(struct io_kiocb *req, ssize_t ret,
>   		req->file->f_pos = rw->kiocb.ki_pos;
>   	if (ret >= 0 && (rw->kiocb.ki_complete == io_complete_rw)) {
>   		if (!__io_complete_rw_common(req, ret)) {
> +			io_req_io_end(req);
>   			io_req_set_res(req, final_ret,
>   				       io_put_kbuf(req, issue_flags));
>   			return IOU_OK;
> 

-- 
Pavel Begunkov
