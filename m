Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F215D4EF79D
	for <lists+io-uring@lfdr.de>; Fri,  1 Apr 2022 18:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346156AbiDAQLb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 1 Apr 2022 12:11:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351991AbiDAQLB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 1 Apr 2022 12:11:01 -0400
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F5CF143C7E
        for <io-uring@vger.kernel.org>; Fri,  1 Apr 2022 08:36:27 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id y16so2191754ilc.7
        for <io-uring@vger.kernel.org>; Fri, 01 Apr 2022 08:36:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=JcuIO7mlr0OUifXwpXBrWm6kMzQVDkcTDqgugzIHvIQ=;
        b=gCit9uoU6QDSlyzOPAPdDxlZD6WcMm7TNTvkkeac0jx/FQFU60/sLbOeN52nPrXQoi
         V/FnFxQGjl7vkpRl5noRvOdZmDUT5p0memUGCAKvtgydSNIyIv+s2JVhmCwfNhI6T4GG
         ECt+yCu4YUGx28r5+lrNweCdXz6/ZJIGD0kh+fD6uZ0U1RP8ZbfqSNdKkHWKeNrd1in0
         yxBbF0RVpr9tvNJG2AN4yZMHHMHR1u8EKss2lRT/4CdK32+OKYlj3miNqaxAPBePERV7
         Fzk9Cqy9ym9ugq+j3NXii4njQjwNNvq6QDX3rechhRsiIbtxxZsJmnTikyMAL4dlcdHh
         eA2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=JcuIO7mlr0OUifXwpXBrWm6kMzQVDkcTDqgugzIHvIQ=;
        b=CjQd+n6QNbAvizgwMNcZhOVgQA4FFXdtTFdo4d4+7XT2CjvwME/chHn8RD0PoMMZjT
         bfhia9G3K+ms9JRFZw2V3O1W1V3e/nU57YhfNduOfKx2Z+WMIEsABohGBFU4AOSURVhL
         /cR/xmRaEFbgGZAl8ck+6XOGO5PNk7kjgu9cxsTSYohZ7C7IEm1u3mn960QjqP+gYIe4
         nB1XeEXd92LVOg50VdZVpgTTyNpTj1/MVn/Jb1z48G9nrnSs1AkKEZlV0ZGi/I5j/G5G
         6SV3KIR5PQJQKLZNgD2I6gVPfCFFAxPyrRs0VnyqrvGQTyxufDlN6lhzlXnbJshp3IwZ
         vr9g==
X-Gm-Message-State: AOAM53130XpzRd+709j4oPE1ZFnDmqkDkGHnXbWjhW092dDTa4Dr0fNf
        E5kUahHeHJcxwLz67J2H7iGCcC5SXNGDa8Og
X-Google-Smtp-Source: ABdhPJzfCsx4SoQ0sa9RSN8WqADTLOS77xZxdarO7tN0A63VAt6lmsiXsIBiQR0Mra/hUqc9ajAKsg==
X-Received: by 2002:a92:6012:0:b0:2c6:b0d:240e with SMTP id u18-20020a926012000000b002c60b0d240emr161344ilb.177.1648827387211;
        Fri, 01 Apr 2022 08:36:27 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id j13-20020a056e02014d00b002c98acb8d32sm1453965ilr.45.2022.04.01.08.36.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Apr 2022 08:36:26 -0700 (PDT)
Message-ID: <fbf3b195-7415-7f84-c0e6-bdfebf9692f2@kernel.dk>
Date:   Fri, 1 Apr 2022 09:36:25 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: io_uring_prep_openat_direct() and link/drain
Content-Language: en-US
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     io-uring@vger.kernel.org
References: <CAJfpegvVpFbDX5so8EVaHxubZLNQ4bo=myAYopWeRtMs0wa6nA@mail.gmail.com>
 <89322bd1-5e6f-bcc6-7974-ffd22363a165@kernel.dk>
 <CAJfpegtr+Bo0O=i9uShDJO_=--KAsFmvdzodwH6qF7f+ABeQ5g@mail.gmail.com>
 <0c5745ab-5d3d-52c1-6a1d-e5e33d4078b5@kernel.dk>
 <CAJfpegtob8ZWU1TDBoUf7SRMQJhEcEo2sPUumzpNd3Mcg+1aog@mail.gmail.com>
 <52dca413-61b3-8ded-c4cc-dd6c8e8de1ed@kernel.dk>
 <CAJfpegtEG2c3H8ZyOWPT69HJN2UWU1es-n9P+CSgV7jiZMPtGg@mail.gmail.com>
 <23b62cca-8ec5-f250-e5a3-7e9ed983e190@kernel.dk>
 <CAJfpeguZji8x+zXSADJ4m6VKbdmTb6ZQd5zA=HCt8acxvGSr3w@mail.gmail.com>
 <CAJfpegsADrdURSUOrGTjbu1DoRr7-8itGx23Tn0wf6gNdO5dWA@mail.gmail.com>
 <77229971-72cd-7d78-d790-3ef4789acc9e@kernel.dk>
 <CAJfpeguiZ7U=YQhgGa-oPWO07tpBL6sf3zM=xtAk66njb1p2cw@mail.gmail.com>
 <c5f27130-b4ad-3f4c-ce98-4414227db4fd@kernel.dk>
 <61c2336f-0315-5f76-3022-18c80f79e0b5@kernel.dk>
 <38436a44-5048-2062-c339-66679ae1e282@kernel.dk>
 <CAJfpegvM3LQ8nsJf=LsWjQznpOzC+mZFXB5xkZgZHR2tXXjxLQ@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAJfpegvM3LQ8nsJf=LsWjQznpOzC+mZFXB5xkZgZHR2tXXjxLQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/1/22 2:40 AM, Miklos Szeredi wrote:
> On Wed, 30 Mar 2022 at 19:49, Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 3/30/22 9:53 AM, Jens Axboe wrote:
>>> On 3/30/22 9:17 AM, Jens Axboe wrote:
>>>> On 3/30/22 9:12 AM, Miklos Szeredi wrote:
>>>>> On Wed, 30 Mar 2022 at 17:05, Jens Axboe <axboe@kernel.dk> wrote:
>>>>>>
>>>>>> On 3/30/22 8:58 AM, Miklos Szeredi wrote:
>>>>>>> Next issue:  seems like file slot reuse is not working correctly.
>>>>>>> Attached program compares reads using io_uring with plain reads of
>>>>>>> proc files.
>>>>>>>
>>>>>>> In the below example it is using two slots alternately but the number
>>>>>>> of slots does not seem to matter, read is apparently always using a
>>>>>>> stale file (the prior one to the most recent open on that slot).  See
>>>>>>> how the sizes of the files lag by two lines:
>>>>>>>
>>>>>>> root@kvm:~# ./procreads
>>>>>>> procreads: /proc/1/stat: ok (313)
>>>>>>> procreads: /proc/2/stat: ok (149)
>>>>>>> procreads: /proc/3/stat: read size mismatch 313/150
>>>>>>> procreads: /proc/4/stat: read size mismatch 149/154
>>>>>>> procreads: /proc/5/stat: read size mismatch 150/161
>>>>>>> procreads: /proc/6/stat: read size mismatch 154/171
>>>>>>> ...
>>>>>>>
>>>>>>> Any ideas?
>>>>>>
>>>>>> Didn't look at your code yet, but with the current tree, this is the
>>>>>> behavior when a fixed file is used:
>>>>>>
>>>>>> At prep time, if the slot is valid it is used. If it isn't valid,
>>>>>> assignment is deferred until the request is issued.
>>>>>>
>>>>>> Which granted is a bit weird. It means that if you do:
>>>>>>
>>>>>> <open fileA into slot 1, slot 1 currently unused><read slot 1>
>>>>>>
>>>>>> the read will read from fileA. But for:
>>>>>>
>>>>>> <open fileB into slot 1, slot 1 is fileA currently><read slot 1>
>>>>>>
>>>>>> since slot 1 is already valid at prep time for the read, the read will
>>>>>> be from fileA again.
>>>>>>
>>>>>> Is this what you are seeing? It's definitely a bit confusing, and the
>>>>>> only reason why I didn't change it is because it could potentially break
>>>>>> applications. Don't think there's a high risk of that, however, so may
>>>>>> indeed be worth it to just bite the bullet and the assignment is
>>>>>> consistent (eg always done from the perspective of the previous
>>>>>> dependent request having completed).
>>>>>>
>>>>>> Is this what you are seeing?
>>>>>
>>>>> Right, this explains it.   Then the only workaround would be to wait
>>>>> for the open to finish before submitting the read, but that would
>>>>> defeat the whole point of using io_uring for this purpose.
>>>>
>>>> Honestly, I think we should just change it during this round, making it
>>>> consistent with the "slot is unused" use case. The old use case is more
>>>> more of a "it happened to work" vs the newer consistent behavior of "we
>>>> always assign the file when execution starts on the request".
>>>>
>>>> Let me spin a patch, would be great if you could test.
>>>
>>> Something like this on top of the current tree should work. Can you
>>> test?
>>
>> You can also just re-pull for-5.18/io_uring, it has been updated. A last
>> minute edit make a 0 return from io_assign_file() which should've been
>> 'true'...
> 
> Yep, this works now.
> 
> Next issue:  will get ENFILE even though there are just 40 slots.
> When running as root, then it will get as far as invoking the OOM
> killer, which is really bad.
> 
> There's no leak, this apparently only happens when the worker doing
> the fputs can't keep up.  Simple solution:  do the fput() of the
> previous file synchronously with the open_direct operation; fput
> shouldn't be expensive...  Is there a reason why this wouldn't work?

I take it you're continually reusing those slots? If you have a test
case that'd be ideal. Agree that it sounds like we just need an
appropriate breather to allow fput/task_work to run. Or it could be the
deferral free of the fixed slot.

-- 
Jens Axboe

