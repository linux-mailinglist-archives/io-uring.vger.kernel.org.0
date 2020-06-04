Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 584E51EEB9B
	for <lists+io-uring@lfdr.de>; Thu,  4 Jun 2020 22:13:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727984AbgFDUN4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Jun 2020 16:13:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726666AbgFDUN4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Jun 2020 16:13:56 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACC58C08C5C0;
        Thu,  4 Jun 2020 13:13:55 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id e1so7503611wrt.5;
        Thu, 04 Jun 2020 13:13:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6WwrMeTkKJFQdV7wBhjXqjcjeYILazTc384fW8RnPqw=;
        b=tlrTo/zq8E0ox2ZkSEDA6bUrVjFpMPa5ajodmnoNKnG+Lo+HX0eC4vz8jYEwignAJa
         29Y52W6/PXfZH9h9ffpxuSwuMCfj5Pw1Pug/tbHMFooa2oHbIVPw48CzKgtsYYy2XCvc
         N56rJiTVJ5fw5bo/5siQn9dVzYupew+FGX6Q8DfK5bYr0BjoOslCllzydRwVdiFcZhTV
         65eMOAEnGo0MUZP9bSiGFCB4GnRQ1RO0stxpwHOLkqVJts4nFvB+L8zg0bv+a8ua+Cuo
         BV1yhYbsVsAewsU0jR0RxQpReVZr0XxUtBxRYBUBtSbpGPpjiEhRUsaS8FGoeL7wLUW5
         nh7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6WwrMeTkKJFQdV7wBhjXqjcjeYILazTc384fW8RnPqw=;
        b=ip2KjuUACu3Uxoan8q7N4kINJuopZFCjIanDnjvBf7MbqCSKIhyhh0JU4vR0u4+YUw
         goHqfMyg9VdldLO1JLmK82rrxjjtl3pyjtP4t1mYYfFSsSQQaRdLxl02pw1V47ajoWWD
         ksDW7gCK5c5NBhTxtrMiMi1nO/Xh/m/qlS2uJoiI7GJkMq7QH+fhSjbc6KvfeQqCoeIv
         XYbov0KxbzYB2od8589rJvwK4uU3kQOCeUqjPOqqaJWIkmIWiJU633nBKVxUHeTvhc8a
         qy9qmp39ai6alMZ+EI/ccqY4ILtF1KD21vG4xmgAib9eEgH3RKUQXFJz1ZHmYkT+Cqo5
         1+xw==
X-Gm-Message-State: AOAM531RmPfkpVMX//KmFT5Jxi3dMY8KKdsFfbgzIoP18snkA1R8bSu4
        r8m1zsV0X3/E4jZCuck9u+1POmvf
X-Google-Smtp-Source: ABdhPJwLq33s1kgWhgBIhMj8oqwHaVBJjmYLljwpw6SgBiT+YYKkF+94nrxnc5P5JYNcbIJd7W5R4A==
X-Received: by 2002:adf:ea90:: with SMTP id s16mr5936333wrm.299.1591301634105;
        Thu, 04 Jun 2020 13:13:54 -0700 (PDT)
Received: from [192.168.43.208] ([5.100.193.151])
        by smtp.gmail.com with ESMTPSA id s2sm8179757wmh.11.2020.06.04.13.13.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Jun 2020 13:13:53 -0700 (PDT)
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1591196426.git.asml.silence@gmail.com>
 <414b9a24-2e70-3637-0b98-10adf3636c37@kernel.dk>
 <f5370eb3-af80-5481-3589-675befa41009@kernel.dk>
 <d1d92d99-c6b1-fc6e-ea1d-6c2e5097d83f@gmail.com>
 <cc3197f9-e8b1-ac13-c121-291bb32646e3@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH v3 0/4] forbid fix {SQ,IO}POLL
Message-ID: <947accf4-5ba1-cd39-2aeb-efb7065efb84@gmail.com>
Date:   Thu, 4 Jun 2020 23:12:36 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <cc3197f9-e8b1-ac13-c121-291bb32646e3@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 04/06/2020 22:52, Jens Axboe wrote:
> On 6/4/20 1:22 PM, Pavel Begunkov wrote:
>> On 04/06/2020 20:06, Jens Axboe wrote:
>>> On 6/3/20 12:51 PM, Jens Axboe wrote:
>>>> On 6/3/20 9:03 AM, Pavel Begunkov wrote:
>>>>> The first one adds checks {SQPOLL,IOPOLL}. IOPOLL check can be
>>>>> moved in the common path later, or rethinked entirely, e.g.
>>>>> not io_iopoll_req_issued()'ed for unsupported opcodes.
>>>>>
>>>>> 3 others are just cleanups on top.
>>>>>
>>>>>
>>>>> v2: add IOPOLL to the whole bunch of opcodes in [1/4].
>>>>>     dirty and effective.
>>>>> v3: sent wrong set in v2, re-sending right one 
>>>>>
>>>>> Pavel Begunkov (4):
>>>>>   io_uring: fix {SQ,IO}POLL with unsupported opcodes
>>>>>   io_uring: do build_open_how() only once
>>>>>   io_uring: deduplicate io_openat{,2}_prep()
>>>>>   io_uring: move send/recv IOPOLL check into prep
>>>>>
>>>>>  fs/io_uring.c | 94 ++++++++++++++++++++++++++-------------------------
>>>>>  1 file changed, 48 insertions(+), 46 deletions(-)
>>>>
>>>> Thanks, applied.
>>>
>>> #1 goes too far, provide/remove buffers is fine with iopoll. I'll
>>> going to edit the patch.
>>
>> Conceptually it should work, but from a quick look:
>>
>> - io_provide_buffers() drops a ref from req->refs, which should've
>> been used by iopoll*. E.g. io_complete_rw_iopoll() doesn't do that.
>>
>> - it doesn't set REQ_F_IOPOLL_COMPLETED, thus iopoll* side will
>> call req->file->iopoll().
> 
> We don't poll for provide/remove buffers, or file update. The
> completion is done inline. The REQ_F_IOPOLL_COMPLETED and friends
> is only applicable on read/writes.
> 

1. Let io_provide_buffers() succeeds, putting a ref and returning 0

2. io_issue_sqe() on the way back do IORING_SETUP_IOPOLL check,
where it calls io_iopoll_req_issued(req)

3. io_iopoll_req_issued() unconditionally adds the req into ->poll_list

4. io_do_iopoll() checks the req, doesn't find it flagged with
REQ_F_IOPOLL_COMPLETED, and tries req->file->iopoll().


Do I miss something? Just did a quick and dirty test, which segfaulted.
Not certain about it though.

-- 
Pavel Begunkov
