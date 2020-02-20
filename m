Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BA81166A21
	for <lists+io-uring@lfdr.de>; Thu, 20 Feb 2020 23:02:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727801AbgBTWCO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Feb 2020 17:02:14 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:33520 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727786AbgBTWCO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Feb 2020 17:02:14 -0500
Received: by mail-pl1-f196.google.com with SMTP id ay11so2094191plb.0
        for <io-uring@vger.kernel.org>; Thu, 20 Feb 2020 14:02:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=EcMAAMrcXwE+YqaCVQd+nTGM8VJMkkrtiKRLaFo4uyI=;
        b=NJlHGHK9xohzI60iSDjZRc33xNtIoeiFt1DoDHgoNOdmGDaHqx18+mNMrL9zpVJ4my
         67cSVZkLE4ej5hFpv3DkldMtlaHd2wmO2kNatywp/NTC1E5iq9RyIKJ0l2op0BtYxrnj
         0BOkJWSkQI4WaXeRw3QkPqlnLDrN/jUWpP/+eHuUCFV4wj0saVNONa9jph42qnxX9Eqv
         6pHUwKdvFw7+6MhfHIKzy3ffUJcAeXNHQ0diLhbrwqSd+Im2gShPo8ADr89B5h+lxhxH
         jgrNCMNmdOu3IcDCu5Xr12P6tYgA2GpukPpNTLLFBKBVDxwAFZwzBBHrg45eXGbWH8W8
         p7Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EcMAAMrcXwE+YqaCVQd+nTGM8VJMkkrtiKRLaFo4uyI=;
        b=YGczW4qDZMJdxyjWHNs+MMXWFWUkDLG8N3VDlh8qri7d2cSKxkeHL3IQzJe0b+5s2Q
         woGL1auPmht6e/p9AGLOBt/WoVRES7ccA9pE7AeIjtsCsQi4mi61HcPdkuQ6ovCGdTgJ
         mvm8qEWKh37hAl4rsb6gCMUbTicl/ZWOkOdy6rqo0tIMRCAJN55z/YH5G0PEDYoYx6li
         2bbtFc6E8m8dAtj1SCo0pYc2usHtPaCgyWOIgekd2gAiSXvmH3teGAt5V+naAnxZQjz7
         Z9mE4eVyoyCnziGFbG9K6kLqlmyK18I295wrjovg23wie3TAhtIuWyDOLuCtRjs61s/k
         6khw==
X-Gm-Message-State: APjAAAX9G26rCz1hBDZNvodBkHOrvKcjM7Sv5AcdL+GJj8QVbg+Sxg+q
        xDcuiFm8nG28CwOyQCjkgspDXg==
X-Google-Smtp-Source: APXvYqwKE5jdnC03NN9ppjR+bG3o2wu94mCM9mkRPQwmqVBrU/+6IcOWLaNnUW3yfCXSyYWut/yM4A==
X-Received: by 2002:a17:902:b68c:: with SMTP id c12mr32263268pls.160.1582236133924;
        Thu, 20 Feb 2020 14:02:13 -0800 (PST)
Received: from ?IPv6:2620:10d:c081:1130::1006? ([2620:10d:c090:180::17d5])
        by smtp.gmail.com with ESMTPSA id q17sm542602pfg.123.2020.02.20.14.02.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Feb 2020 14:02:13 -0800 (PST)
Subject: Re: [PATCH 6/9] sched: add a sched_work list
From:   Jens Axboe <axboe@kernel.dk>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     io-uring@vger.kernel.org, glauber@scylladb.com,
        asml.silence@gmail.com
References: <20200220203151.18709-1-axboe@kernel.dk>
 <20200220203151.18709-7-axboe@kernel.dk>
 <20200220211744.GN11457@worktop.programming.kicks-ass.net>
 <42c87f4d-cf37-7240-b232-2a811c7750b8@kernel.dk>
Message-ID: <ff0bc330-0880-f516-8ba6-00adac05fe0b@kernel.dk>
Date:   Thu, 20 Feb 2020 14:02:10 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <42c87f4d-cf37-7240-b232-2a811c7750b8@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/20/20 2:53 PM, Jens Axboe wrote:
> On 2/20/20 2:17 PM, Peter Zijlstra wrote:
>> On Thu, Feb 20, 2020 at 01:31:48PM -0700, Jens Axboe wrote:
>>> This is similar to the task_works, and uses the same infrastructure, but
>>> the sched_work list is run when the task is being scheduled in or out.
>>>
>>> The intended use case here is for core code to be able to add work
>>> that should be automatically run by the task, without the task needing
>>> to do anything. This is done outside of the task, one example would be
>>> from waitqueue handlers, or anything else that is invoked out-of-band
>>> from the task itself.
>>>
>>
>>
>>> diff --git a/kernel/task_work.c b/kernel/task_work.c
>>> index 3445421266e7..ba62485d5b3d 100644
>>> --- a/kernel/task_work.c
>>> +++ b/kernel/task_work.c
>>> @@ -3,7 +3,14 @@
>>>  #include <linux/task_work.h>
>>>  #include <linux/tracehook.h>
>>>  
>>> -static struct callback_head work_exited; /* all we need is ->next == NULL */
>>> +static void task_exit_func(struct callback_head *head)
>>> +{
>>> +}
>>> +
>>> +static struct callback_head work_exited = {
>>> +	.next	= NULL,
>>> +	.func	= task_exit_func,
>>> +};
>>
>> Do we really need this? It seems to suggest we're trying to execute
>> work_exited, which would be an error.
>>
>> Doing so would be the result of calling sched_work_run() after
>> exit_task_work(). I suppose that's actually possible.. the problem is
>> that that would reset sched_work to NULL and re-allow queueing works,
>> which would then leak.
>>
>> I'll look at it in more detail tomorrow, I'm tired...
> 
> Let me try and instrument it, I definitely hit it on task exit
> but might have been induced by some earlier bugs.

I suspect I hit this before we added sched_work_run() to
exit_task_work(). I re-ran all the testing, and it's definitely
not trigger now.

So I'll remove it for now.

-- 
Jens Axboe

