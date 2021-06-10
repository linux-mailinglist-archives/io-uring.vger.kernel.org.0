Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 412303A3418
	for <lists+io-uring@lfdr.de>; Thu, 10 Jun 2021 21:33:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230406AbhFJTfP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 10 Jun 2021 15:35:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230130AbhFJTfO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 10 Jun 2021 15:35:14 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D529C061574;
        Thu, 10 Jun 2021 12:33:04 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id l2so3535085wrw.6;
        Thu, 10 Jun 2021 12:33:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:subject:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=5E8cF5VBKpyrJ6DOOtaoDCcGr87nYIq7F2vf6J9aNA8=;
        b=XLlVKTvyCCtFD2F+pDbVMG7on+fgYxcR2PRrrKD+ku1LJwcflhX7OKW9NGx9zrIqZT
         xI4lGLOse3e98Vv25UW2k14zHdxeKlOTIBJ2I17UR+2F4STPzuDTinoBiuGVtbsks4Qf
         xj2jXy+j4rvUrTndTyOy7ElIljlPYTA4B43R3matHiEuey66M37yrefb8WDo7FLq5miK
         hmMkb+/TCIM1S4AnCgiMTyV7DMeOJuipAGtkIjCUQSuWIvAgg7BquAeqskbR3I2bmzL1
         adlUiJcUs7lAsrbJqsA+GCf0XXPpj8s4ujkAY7xfJHRPXXTqLGOj2aHfOh+r9n6xU1YX
         Lh7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5E8cF5VBKpyrJ6DOOtaoDCcGr87nYIq7F2vf6J9aNA8=;
        b=twKQmsWoXJNZKyvmcac7Yq5jB5zXowVEQlQPAo7XsfAvwxhYWpmvzgHgGPVVjAgc7+
         tE3jql16o0c8FydW9xJ0/BxZYaqm/bFZimyoJ5b2kCYEi4Dzhg4AHiAT1ewxruBOUO8V
         hqQiLm0ZEPaCWPJoZYjdiLeBgPPCz2fIsCwoKZVvXF4LMFvoA5+7H/kZUmsmdpiclBz1
         rzvt1l/i84QXsAbw0UtqQmUSvpFFZLUd40p6qi5VT/J1hnXTwzdn9c+YUZyK/Pl+bXcl
         jPO6avkKbhrsHMgQlCqDcNe9q2kbAsHKEoVOJGnTHsyRVWoddDztPSQ8WCHZbhzV1NdK
         +i7g==
X-Gm-Message-State: AOAM531Ssg+HEAiGe670k/rL9B7VPCHOJXCCfAdDtcAPpDVhu0FnSx3V
        CGqtXggw/Qsx91KUrzU+BTzr9Y5+WqB5yQ==
X-Google-Smtp-Source: ABdhPJxhYzEarNnwgTB1VN9Iwqor7i/fxslED2U9Q5D0bDWiaZ5kmUNHtfibpDCcntg9Oj3kOzYzgw==
X-Received: by 2002:a5d:6747:: with SMTP id l7mr99257wrw.220.1623353582764;
        Thu, 10 Jun 2021 12:33:02 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.133.95])
        by smtp.gmail.com with ESMTPSA id o9sm4178660wri.68.2021.06.10.12.33.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Jun 2021 12:33:02 -0700 (PDT)
To:     Olivier Langlois <olivier@trillion01.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <60c13bec.1c69fb81.73967.f06dSMTPIN_ADDED_MISSING@mx.google.com>
 <84e42313-d738-fb19-c398-08a4ed0e0d9c@gmail.com>
 <4b5644bff43e072a98a19d7a5ca36bb5e11497ec.camel@trillion01.com>
 <a7d6f2fd-b59e-e6fa-475a-23962d45b6fa@gmail.com>
 <9938f22a0bb09f344fa5c9c5c1b91f0d12e7566f.camel@trillion01.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH] io_uring: reduce latency by reissueing the operation
Message-ID: <a12e218a-518d-1dac-5e8c-d9784c9850b0@gmail.com>
Date:   Thu, 10 Jun 2021 20:32:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <9938f22a0bb09f344fa5c9c5c1b91f0d12e7566f.camel@trillion01.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/10/21 6:56 PM, Olivier Langlois wrote:
> On Thu, 2021-06-10 at 16:51 +0100, Pavel Begunkov wrote:
>> Right, but it still stalls other requests and IIRC there are people
>> not liking the syscall already taking too long. Consider
>> io_req_task_queue(), adds more overhead but will delay execution
>> to the syscall exit.
>>
>> In any case, would be great to have numbers, e.g. to see if
>> io_req_task_queue() is good enough, how often your problem
>> takes places and how much it gives us.
>>
> I will get you more more data later but I did run a fast test that
> lasted 81 seconds with a single TCP connection.
> 
> The # of times that the sqe got reissued is 57.
> 
> I'll intrumentalize a bit the code to answer the following questions:
> 
> 1. What is the ratio of reissued read sqe/total read sqe
> 2. Average exec time of __io_queue_sqe() for a read sqe when data is
> already available vs avg exec time when sqe is reissued
> 3. average exec time when the sqe is pushed to async when it could have
> been reissued.
> 
> With that info, I think that we will be in better position to evaluate
> whether or not the patch is good or not.
> 
> Can you think of other numbers that would be useful to know to evaluate
> the patch performance?

If throughput + latency (avg + several nines) are better (or any
other measurable improvement), it's a good enough argument to me,
but not sure what test case you're looking at. Single threaded?
Does it saturate your CPU?

-- 
Pavel Begunkov
