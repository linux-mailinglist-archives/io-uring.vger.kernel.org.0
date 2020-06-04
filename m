Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 325AD1EEBB4
	for <lists+io-uring@lfdr.de>; Thu,  4 Jun 2020 22:17:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729707AbgFDURb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Jun 2020 16:17:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729531AbgFDURb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Jun 2020 16:17:31 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6CE2C08C5C0
        for <io-uring@vger.kernel.org>; Thu,  4 Jun 2020 13:17:30 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id nm22so1609808pjb.4
        for <io-uring@vger.kernel.org>; Thu, 04 Jun 2020 13:17:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=H1eh8obpCVvS2HNCrovSqQnp/TRwxmNDTy89WEbh5+g=;
        b=SqOksEvREgLepLVQGAzPlfCPWhWU72ZgIQdIiHFeGpJSEp/iKfbdPSbazf9TiUzt5Z
         K/pDmo0kkiNA6a90CKohwCSDHTQrGnYHMjRm606324czREVrBKd4XoPoCBv0D6VpTDE6
         2csOEiMwD14URodWHNHix++//jtig92l5p5po54rQ6ZJBOu+qY02PbcqILGdCWyHa9aZ
         yG1nEz/NUC/hxeWTO0njMi5xqpEd90T+tcCg3MA2G//ZQHMJMhZVFLtlR7Djn4Nk46SB
         i+TfqLe5YFFWUO83ph/BsY0aRtQ4TUBf+y5sz0xNyrG20OXqK798gwBzadXJh4orsXsv
         VHFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=H1eh8obpCVvS2HNCrovSqQnp/TRwxmNDTy89WEbh5+g=;
        b=EHLh/NsNtbOIMCWvZEF60YRP8dogUmob6g8K6olYvXe8/p//PPCljI52NEJ79iYisI
         xZxZgOEHumCKfYfRHV/M7K99QOXRKb/A/aCalKK8qWWri2ZEQ7KYD/lChruzLY1S707g
         xnHHYwCIJ7RpI7cGP1cZXs4HNItkTP5de1hdDJfyf7QMkrVSQsgvylYIns0HvlDmnGF6
         RiHIFfcKdqyQBcr4kzAcBrK89lqsA1RvFYRWtLzegwSBoRibB12rdtVtg9tiRyWS78Ft
         U5boMDdkDYAdZJS9Fj5nfn/BS9Ac0uJFBYWzkelZY59RPWA+1a38h+81bpcYuNa4MMSb
         3XAw==
X-Gm-Message-State: AOAM5313BUgqWRvbhQf+8N56yekiaOiTcXb8BLoqGTtBQO5n9i+wbSY/
        cvt8iDOHvGA5VbzijUUIZexVxQ==
X-Google-Smtp-Source: ABdhPJzbunpclwUqC1RO0emeXvryKd+sGoxw5dp06T0g0ioRPbuzl/0CXQTIAgShoiy6zsrfbWV1QA==
X-Received: by 2002:a17:90a:2843:: with SMTP id p3mr7407272pjf.187.1591301850054;
        Thu, 04 Jun 2020 13:17:30 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id z128sm4827699pfb.201.2020.06.04.13.17.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Jun 2020 13:17:29 -0700 (PDT)
Subject: Re: [PATCH v3 0/4] forbid fix {SQ,IO}POLL
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1591196426.git.asml.silence@gmail.com>
 <414b9a24-2e70-3637-0b98-10adf3636c37@kernel.dk>
 <f5370eb3-af80-5481-3589-675befa41009@kernel.dk>
 <d1d92d99-c6b1-fc6e-ea1d-6c2e5097d83f@gmail.com>
 <cc3197f9-e8b1-ac13-c121-291bb32646e3@kernel.dk>
 <947accf4-5ba1-cd39-2aeb-efb7065efb84@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <8d817367-436b-073c-6a2c-e60830d7646e@kernel.dk>
Date:   Thu, 4 Jun 2020 14:17:27 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <947accf4-5ba1-cd39-2aeb-efb7065efb84@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/4/20 2:12 PM, Pavel Begunkov wrote:
> On 04/06/2020 22:52, Jens Axboe wrote:
>> On 6/4/20 1:22 PM, Pavel Begunkov wrote:
>>> On 04/06/2020 20:06, Jens Axboe wrote:
>>>> On 6/3/20 12:51 PM, Jens Axboe wrote:
>>>>> On 6/3/20 9:03 AM, Pavel Begunkov wrote:
>>>>>> The first one adds checks {SQPOLL,IOPOLL}. IOPOLL check can be
>>>>>> moved in the common path later, or rethinked entirely, e.g.
>>>>>> not io_iopoll_req_issued()'ed for unsupported opcodes.
>>>>>>
>>>>>> 3 others are just cleanups on top.
>>>>>>
>>>>>>
>>>>>> v2: add IOPOLL to the whole bunch of opcodes in [1/4].
>>>>>>     dirty and effective.
>>>>>> v3: sent wrong set in v2, re-sending right one 
>>>>>>
>>>>>> Pavel Begunkov (4):
>>>>>>   io_uring: fix {SQ,IO}POLL with unsupported opcodes
>>>>>>   io_uring: do build_open_how() only once
>>>>>>   io_uring: deduplicate io_openat{,2}_prep()
>>>>>>   io_uring: move send/recv IOPOLL check into prep
>>>>>>
>>>>>>  fs/io_uring.c | 94 ++++++++++++++++++++++++++-------------------------
>>>>>>  1 file changed, 48 insertions(+), 46 deletions(-)
>>>>>
>>>>> Thanks, applied.
>>>>
>>>> #1 goes too far, provide/remove buffers is fine with iopoll. I'll
>>>> going to edit the patch.
>>>
>>> Conceptually it should work, but from a quick look:
>>>
>>> - io_provide_buffers() drops a ref from req->refs, which should've
>>> been used by iopoll*. E.g. io_complete_rw_iopoll() doesn't do that.
>>>
>>> - it doesn't set REQ_F_IOPOLL_COMPLETED, thus iopoll* side will
>>> call req->file->iopoll().
>>
>> We don't poll for provide/remove buffers, or file update. The
>> completion is done inline. The REQ_F_IOPOLL_COMPLETED and friends
>> is only applicable on read/writes.
>>
> 
> 1. Let io_provide_buffers() succeeds, putting a ref and returning 0
> 
> 2. io_issue_sqe() on the way back do IORING_SETUP_IOPOLL check,
> where it calls io_iopoll_req_issued(req)

Only if req->file is valid, which it isn't for these non-file requests.

> 
> 3. io_iopoll_req_issued() unconditionally adds the req into ->poll_list
> 
> 4. io_do_iopoll() checks the req, doesn't find it flagged with
> REQ_F_IOPOLL_COMPLETED, and tries req->file->iopoll().
> 
> 
> Do I miss something? Just did a quick and dirty test, which segfaulted.
> Not certain about it though.
> 


-- 
Jens Axboe

