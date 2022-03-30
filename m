Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1648A4ECB0F
	for <lists+io-uring@lfdr.de>; Wed, 30 Mar 2022 19:49:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239952AbiC3Rve (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 30 Mar 2022 13:51:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348079AbiC3Rvd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 30 Mar 2022 13:51:33 -0400
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0568B6E550
        for <io-uring@vger.kernel.org>; Wed, 30 Mar 2022 10:49:36 -0700 (PDT)
Received: by mail-il1-x133.google.com with SMTP id y16so6943286ilc.7
        for <io-uring@vger.kernel.org>; Wed, 30 Mar 2022 10:49:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=JetUkGCT+ILg2Zfmrh4m8iENvaO8W7pR29oGldUxR7E=;
        b=lv34UgwYHir3wxQNql3yPVBdhiNYsrjFYQmVEDuvPTjlr2+ccP3qbX/if2TeCYxaVI
         rwkYUA4u8dC+93BJKfscEZzCjXdY6IOQXeN9/i/VjoerlJ5NK9fGLcwqwU6S4DEj2QTa
         x4440v9rsLjd4ofEyMDWNk2+e39XWqoWhsx4xUPMmnxGiMzGoctVcoRkKgqbJkUiBybB
         cQBnH/Hu4QvTU6HOFgzXKqGhJe4mCXL7OHcDtmhJRBw3u4arngBZzMVDrsiybXPWR+vB
         6r5wiMXoxQNr/oBDeUP7jU+/xAi1bVA0g9b5NlmoNvU2pGzWTxBkFFefq/4XruY4Ryaf
         wjEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=JetUkGCT+ILg2Zfmrh4m8iENvaO8W7pR29oGldUxR7E=;
        b=m8SQvaskHrpEaJSnE1KyHbeXuQPQp656iDTnMSfzkWwzMUJN4k72Z2O4ETJx7CbO8r
         smbbo86hc7dQiFUSu8CoXKzOXW2WIDo3CS+sHGGx/dPxPJJXGmdEfoN4l96vrheksAs0
         79JQ/mD/zOTuOZOtzU0225cdtf0almixg/g2K4lSovfjDN/P+ZCUPZjpvcoOT4CUbJFY
         Q3X6Q86WIeDetdDa7HTkcFTzAQqm5CQ8HAGuzzMlygRBv8qwpxuzL0RHAmoq+0YxF1pp
         eNLqWETtPmFIYHMrG/Veijyv/dP98jHYc6a9UiFAKjEvm8Ys6t6X/1a7HMYTo0hLeWQw
         SiIQ==
X-Gm-Message-State: AOAM530Ync+1CKdrm/gRM+luWvN0cxl3qhgH6yP9ir4kIybEQUhCGfnL
        XLaHmlbV1BUA9ijSvmSuP4UfoFH+7eFVN9LY
X-Google-Smtp-Source: ABdhPJxX8ZGwtuj+h+KnGQIIBvFRrG2Go4s6K4+L/3WDDqb3NZURJttknnFB9L3tXh8cPuYBkoD2Ew==
X-Received: by 2002:a92:440c:0:b0:2be:5bd3:ac98 with SMTP id r12-20020a92440c000000b002be5bd3ac98mr11010326ila.323.1648662576077;
        Wed, 30 Mar 2022 10:49:36 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id a14-20020a921a0e000000b002c993d9cf63sm7229310ila.64.2022.03.30.10.49.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Mar 2022 10:49:35 -0700 (PDT)
Message-ID: <38436a44-5048-2062-c339-66679ae1e282@kernel.dk>
Date:   Wed, 30 Mar 2022 11:49:34 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: io_uring_prep_openat_direct() and link/drain
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     io-uring@vger.kernel.org
References: <CAJfpegvVpFbDX5so8EVaHxubZLNQ4bo=myAYopWeRtMs0wa6nA@mail.gmail.com>
 <115fc7d1-9b9c-712b-e75d-39b2041df437@kernel.dk>
 <CAJfpegs=GcTuXcor-pbhaAxDKeS5XRy5rwTGXUcZM0BYYUK2LA@mail.gmail.com>
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
In-Reply-To: <61c2336f-0315-5f76-3022-18c80f79e0b5@kernel.dk>
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

On 3/30/22 9:53 AM, Jens Axboe wrote:
> On 3/30/22 9:17 AM, Jens Axboe wrote:
>> On 3/30/22 9:12 AM, Miklos Szeredi wrote:
>>> On Wed, 30 Mar 2022 at 17:05, Jens Axboe <axboe@kernel.dk> wrote:
>>>>
>>>> On 3/30/22 8:58 AM, Miklos Szeredi wrote:
>>>>> Next issue:  seems like file slot reuse is not working correctly.
>>>>> Attached program compares reads using io_uring with plain reads of
>>>>> proc files.
>>>>>
>>>>> In the below example it is using two slots alternately but the number
>>>>> of slots does not seem to matter, read is apparently always using a
>>>>> stale file (the prior one to the most recent open on that slot).  See
>>>>> how the sizes of the files lag by two lines:
>>>>>
>>>>> root@kvm:~# ./procreads
>>>>> procreads: /proc/1/stat: ok (313)
>>>>> procreads: /proc/2/stat: ok (149)
>>>>> procreads: /proc/3/stat: read size mismatch 313/150
>>>>> procreads: /proc/4/stat: read size mismatch 149/154
>>>>> procreads: /proc/5/stat: read size mismatch 150/161
>>>>> procreads: /proc/6/stat: read size mismatch 154/171
>>>>> ...
>>>>>
>>>>> Any ideas?
>>>>
>>>> Didn't look at your code yet, but with the current tree, this is the
>>>> behavior when a fixed file is used:
>>>>
>>>> At prep time, if the slot is valid it is used. If it isn't valid,
>>>> assignment is deferred until the request is issued.
>>>>
>>>> Which granted is a bit weird. It means that if you do:
>>>>
>>>> <open fileA into slot 1, slot 1 currently unused><read slot 1>
>>>>
>>>> the read will read from fileA. But for:
>>>>
>>>> <open fileB into slot 1, slot 1 is fileA currently><read slot 1>
>>>>
>>>> since slot 1 is already valid at prep time for the read, the read will
>>>> be from fileA again.
>>>>
>>>> Is this what you are seeing? It's definitely a bit confusing, and the
>>>> only reason why I didn't change it is because it could potentially break
>>>> applications. Don't think there's a high risk of that, however, so may
>>>> indeed be worth it to just bite the bullet and the assignment is
>>>> consistent (eg always done from the perspective of the previous
>>>> dependent request having completed).
>>>>
>>>> Is this what you are seeing?
>>>
>>> Right, this explains it.   Then the only workaround would be to wait
>>> for the open to finish before submitting the read, but that would
>>> defeat the whole point of using io_uring for this purpose.
>>
>> Honestly, I think we should just change it during this round, making it
>> consistent with the "slot is unused" use case. The old use case is more
>> more of a "it happened to work" vs the newer consistent behavior of "we
>> always assign the file when execution starts on the request".
>>
>> Let me spin a patch, would be great if you could test.
> 
> Something like this on top of the current tree should work. Can you
> test?

You can also just re-pull for-5.18/io_uring, it has been updated. A last
minute edit make a 0 return from io_assign_file() which should've been
'true'...

-- 
Jens Axboe

