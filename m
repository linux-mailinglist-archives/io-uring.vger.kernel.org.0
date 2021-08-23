Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8B523F4F0F
	for <lists+io-uring@lfdr.de>; Mon, 23 Aug 2021 19:13:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231224AbhHWROP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 23 Aug 2021 13:14:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231315AbhHWROO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 23 Aug 2021 13:14:14 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75842C06175F
        for <io-uring@vger.kernel.org>; Mon, 23 Aug 2021 10:13:31 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id j14-20020a1c230e000000b002e748b9a48bso357415wmj.0
        for <io-uring@vger.kernel.org>; Mon, 23 Aug 2021 10:13:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=uxII8SgWqfQGgMkEVqy7HXVR00I+kAbMLjgDgJDGhGg=;
        b=tR7N+5krQU1cpX/OiX30qyiSa1M5+pTpawjfRNCS6xbxaepUsrqmg8seKVCjbUdf5t
         gZIv11F6oxGqFNzSj1JzSGgudejUfFTS7w75dSo4cmWzQiamAVrqaetN2BNbOyxOjv5Q
         4SjJtkH+s8IDdR+NfgHNjLSJOoD+N9G2ZGcFrR/miUtCOLbDuNWDiDQMKDRc5299Co94
         ffMQw45it0sqhj8Pbsw/f+zYipLTSM63eHyk7d22XQuwBHv/IdRG9kuxjEbklxvs9M5K
         kzh7hID0lXyiGyvYVcRL1rq9/xIbS9aisEzf1BTWaDDQp5rqdykZ2QDPn/14ypWYcPW6
         Xj6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uxII8SgWqfQGgMkEVqy7HXVR00I+kAbMLjgDgJDGhGg=;
        b=Ngrf6QrzxkZRrvUQKVLThtuoGeFs1fw73Z2+zyka9G3xrhMfGsvOAly9s5Kf3xUhTu
         s5P41ClQloBMIxlfaxGx86XlquGrri8BVRSPY5f8plQfcdf+5sQgIebzSTvPbmvrnCCv
         gcjEK0s14GbonwlxmAcYDmMgzb/XCEIi/WlJKVZfWLt6rzInW2fPVC2JmnoL1TVk2O9G
         e6MGcmgDkAC+HkKeM+fAbhlEsX+XNO8IAWfGgVcpT61KeT1lWD69s2l3mp6nRvuOrtL6
         Z4dF/UJNiHFJ+MvD8yOgtE/o5YBYx3g4tl/3H7I+0GGZ/e4bLPzw1dZWSEMJSvPl9dSW
         eUaw==
X-Gm-Message-State: AOAM531wKLGnNf4rKF17bIVTg1p1FunIYMiLXnGEZ3yv25Si1Jv+Jc6I
        9RxHLw/tM2/163Vt1142he+BuXgbQgQ=
X-Google-Smtp-Source: ABdhPJwqw3zYiOQ/SCnKZAWzu5clI9yUMzNUyneURX1cDrMFWCd6dwD+LMBAcPPlBNV+pcQ8qHdiTg==
X-Received: by 2002:a05:600c:428a:: with SMTP id v10mr5322184wmc.25.1629738810118;
        Mon, 23 Aug 2021 10:13:30 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.233.176])
        by smtp.gmail.com with ESMTPSA id z8sm15496495wrt.77.2021.08.23.10.13.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Aug 2021 10:13:29 -0700 (PDT)
Subject: Re: [PATCH 2/2] io_uring: fix failed linkchain code logic
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210823032506.34857-1-haoxu@linux.alibaba.com>
 <20210823032506.34857-3-haoxu@linux.alibaba.com>
 <7a680e7a-801e-4515-e67c-a3849c581d02@gmail.com>
Message-ID: <7ae63962-51d6-13ff-0397-78cba6eee7f5@gmail.com>
Date:   Mon, 23 Aug 2021 18:12:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <7a680e7a-801e-4515-e67c-a3849c581d02@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/23/21 12:02 PM, Pavel Begunkov wrote:
> On 8/23/21 4:25 AM, Hao Xu wrote:
>> Given a linkchain like this:
>> req0(link_flag)-->req1(link_flag)-->...-->reqn(no link_flag)
>>
>> There is a problem:
>>  - if some intermediate linked req like req1 's submittion fails, reqs
>>    after it won't be cancelled.
>>
>>    - sqpoll disabled: maybe it's ok since users can get the error info
>>      of req1 and stop submitting the following sqes.
>>
>>    - sqpoll enabled: definitely a problem, the following sqes will be
>>      submitted in the next round.
>>
>> The solution is to refactor the code logic to:
>>  - if a linked req's submittion fails, just mark it and the head(if it
>>    exists) as REQ_F_FAIL. Leverage req->result to indicate whether it
>>    is failed or cancelled.
>>  - submit or fail the whole chain when we come to the end of it.
> 
> This looks good to me, a couple of comments below.
> 
> 
>> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
>> ---
>>  fs/io_uring.c | 61 +++++++++++++++++++++++++++++++++++++--------------
>>  1 file changed, 45 insertions(+), 16 deletions(-)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index 44b1b2b58e6a..9ae8f2a5c584 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -1776,8 +1776,6 @@ static void io_preinit_req(struct io_kiocb *req, struct io_ring_ctx *ctx)
>>  	req->ctx = ctx;
>>  	req->link = NULL;
>>  	req->async_data = NULL;
>> -	/* not necessary, but safer to zero */
>> -	req->result = 0;
> 
> Please leave it. I'm afraid of leaking stack to userspace because
                                         ^^^^^
Don't know why I called it "stack", just kernel memory/data

> ->result juggling looks prone to errors. And preinit is pretty cold
> anyway.
> 

-- 
Pavel Begunkov
