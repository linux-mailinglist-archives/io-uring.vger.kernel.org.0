Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1D8350722C
	for <lists+io-uring@lfdr.de>; Tue, 19 Apr 2022 17:53:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354050AbiDSPyQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 19 Apr 2022 11:54:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354044AbiDSPyP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 19 Apr 2022 11:54:15 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45D6C1DA6D
        for <io-uring@vger.kernel.org>; Tue, 19 Apr 2022 08:51:32 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id g20so21828795edw.6
        for <io-uring@vger.kernel.org>; Tue, 19 Apr 2022 08:51:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=scylladb-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:organization:in-reply-to:content-transfer-encoding;
        bh=6BkgCrcha6FsQN+8ex3MJaqWgGhD40i1QkMx54VLyhg=;
        b=6KbZmJhn1IRbpALhb++9XoMo+pNJDm4YN6lXTKmMfOTRVllzHQ1nMkCoihPS0USoLx
         vuqv3jYzxgBrDwx4nsAH6nV8gwMhkP/CayOVvRHVcwQCSJ6Z7o8eToz8oXzXX9qa/5Jr
         BrSdRzbr92I1uu/GfYzNuwrc7jePGA6dL1Ynfy7BT0fojLXaD+ZnUbg6PDeap+Lot9cX
         eu0SmJL0/ExT3B0Ct4aJImXk0hIKUlNiPXzgrwNBTwyyPtmLfC7FG3R+xcUgmeBccPf/
         RCLvQSiDlp+AbhPEOYTCuSm21MWASci+4uCZ4HQ0o1K8lspmbrRh0G/7TJt9bXGZY3NW
         NqdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=6BkgCrcha6FsQN+8ex3MJaqWgGhD40i1QkMx54VLyhg=;
        b=Fr9n5l/9rrR8YFjPxsh7VqBeYkFt9NcCwF8+jariUvcBx++2IMWWAMBaBo8pAFPS+s
         WEarh7h9TaUWuzkPF9Rj5ytqhJmZ91HBE4WGcPpSFGdFKTmhM7AYeIFpETpVQ0hnvvLW
         LYsotZ2rsxF+k1z2OwR7U4/DBh0l7mpxKFMavlp5vSZoxgMytdPU39yrY0OJcfZtH0gr
         i4V6jVJf7sCW61DNChO9MDTby9iDLS9L8ZZQ2zIK4csD5YQGact7vzyCjYIbdOx82gtz
         uM6ud4yl9hCS1SRt1v6skWeyscx8r32TgC/xQvKsKFgwYKLVYoHpQGzUfqIOJh5IlDTA
         cxUA==
X-Gm-Message-State: AOAM533pfTPMeXaOWGLVN1X5aqSJPHDmVVb4X68nj3XSrYGvImxpAbjf
        bwqjW7uKTVYtnFw4g+yXQnUGXA==
X-Google-Smtp-Source: ABdhPJwSEiP7cWkkHMrWQ3cHIuh3XDhsDk57/WShCTq+xxxr3tiIetmbfc635nSxGb68rj2PlXAM+A==
X-Received: by 2002:aa7:c5d4:0:b0:420:11ef:c1c9 with SMTP id h20-20020aa7c5d4000000b0042011efc1c9mr18110742eds.392.1650383490753;
        Tue, 19 Apr 2022 08:51:30 -0700 (PDT)
Received: from [10.0.0.1] (system.cloudius-systems.com. [199.203.229.89])
        by smtp.gmail.com with ESMTPSA id vr7-20020a170906bfe700b006e8325fe130sm5720901ejb.31.2022.04.19.08.51.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Apr 2022 08:51:30 -0700 (PDT)
Message-ID: <6cb5d5b3-1b62-02bf-fcd8-41cbe57bc1c5@scylladb.com>
Date:   Tue, 19 Apr 2022 18:51:28 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: IORING_OP_POLL_ADD slower than linux-aio IOCB_CMD_POLL
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <9b749c99-0126-f9b2-99f5-5c33433c3a08@scylladb.com>
 <9e277a23-84d7-9a90-0d3e-ba09c9437dc4@kernel.dk>
 <e7ffdf1e-b6a8-0e46-5879-30c25446223d@scylladb.com>
 <b585d3b4-42b3-b0db-1cef-5d6c8b815bb7@kernel.dk>
 <e90bfb07-c24f-0e4d-0ac6-bd67176641fb@scylladb.com>
 <8e816c1b-213b-5812-b48a-a815c0fe2b34@kernel.dk>
 <16030f8f-67b1-dbc9-0117-47c16bf78c34@kernel.dk>
From:   Avi Kivity <avi@scylladb.com>
Organization: ScyllaDB
In-Reply-To: <16030f8f-67b1-dbc9-0117-47c16bf78c34@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On 19/04/2022 18.21, Jens Axboe wrote:
> On 4/19/22 6:31 AM, Jens Axboe wrote:
>> On 4/19/22 6:21 AM, Avi Kivity wrote:
>>> On 19/04/2022 15.04, Jens Axboe wrote:
>>>> On 4/19/22 5:57 AM, Avi Kivity wrote:
>>>>> On 19/04/2022 14.38, Jens Axboe wrote:
>>>>>> On 4/19/22 5:07 AM, Avi Kivity wrote:
>>>>>>> A simple webserver shows about 5% loss compared to linux-aio.
>>>>>>>
>>>>>>>
>>>>>>> I expect the loss is due to an optimization that io_uring lacks -
>>>>>>> inline completion vs workqueue completion:
>>>>>> I don't think that's it, io_uring never punts to a workqueue for
>>>>>> completions.
>>>>> I measured this:
>>>>>
>>>>>
>>>>>
>>>>>    Performance counter stats for 'system wide':
>>>>>
>>>>>            1,273,756 io_uring:io_uring_task_add
>>>>>
>>>>>         12.288597765 seconds time elapsed
>>>>>
>>>>> Which exactly matches with the number of requests sent. If that's the
>>>>> wrong counter to measure, I'm happy to try again with the correct
>>>>> counter.
>>>> io_uring_task_add() isn't a workqueue, it's task_work. So that is
>>>> expected.
> Might actually be implicated. Not because it's a async worker, but
> because I think we might be losing some affinity in this case. Looking
> at traces, we're definitely bouncing between the poll completion side
> and then execution the completion.


What affinity are we losing?


Maybe it's TWA_SIGNAL, which causes the poll notification (which could 
happen while httpd is running) to interrupt httpd? Although it should 
happen during tcp processing in softirq, which should be co-located with 
httpd and therefore httpd wasn't running?


>
> Can you try this hack? It's against -git + for-5.19/io_uring. If you let
> me know what base you prefer, I can do a version against that. I see
> about a 3% win with io_uring with this, and was slower before against
> linux-aio as you saw as well.
>

Sure, I'll try it against for-5.19/io_uring, though I don't doubt you 
fixed it.


> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index caa5b673f8f5..f3da6c9a9635 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -6303,6 +6303,25 @@ static void io_apoll_task_func(struct io_kiocb *req, bool *locked)
>   		io_req_complete_failed(req, ret);
>   }
>   
> +static bool __io_poll_execute_direct(struct io_kiocb *req, int mask, int events)
> +{
> +	struct io_ring_ctx *ctx = req->ctx;
> +
> +	if (ctx->has_evfd || req->flags & REQ_F_INFLIGHT ||
> +	    req->opcode != IORING_OP_POLL_ADD)
> +		return false;
> +	if (!spin_trylock(&ctx->completion_lock))
> +		return false;


This looks as if it's losing some affinity, before all completions were 
co-located with httpd and now some are not. So maybe it's the TWA_SIGNAL 
thing.


> +
> +	req->cqe.res = mangle_poll(mask & events);
> +	hash_del(&req->hash_node);
> +	__io_req_complete_post(req, req->cqe.res, 0);
> +	io_commit_cqring(ctx);
> +	spin_unlock(&ctx->completion_lock);
> +	io_cqring_ev_posted(ctx);
> +	return true;
> +}
> +
>   static void __io_poll_execute(struct io_kiocb *req, int mask, int events)
>   {
>   	req->cqe.res = mask;
> @@ -6384,7 +6403,8 @@ static int io_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
>   			else
>   				req->flags &= ~REQ_F_SINGLE_POLL;
>   		}
> -		__io_poll_execute(req, mask, poll->events);
> +		if (!__io_poll_execute_direct(req, mask, poll->events))
> +			__io_poll_execute(req, mask, poll->events);
>   	}
>   	return 1;
>   }
>
