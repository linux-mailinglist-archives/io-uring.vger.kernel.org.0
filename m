Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5376E2A87F1
	for <lists+io-uring@lfdr.de>; Thu,  5 Nov 2020 21:22:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732349AbgKEUV6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 5 Nov 2020 15:21:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732325AbgKEUV4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 5 Nov 2020 15:21:56 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17C6EC0613CF
        for <io-uring@vger.kernel.org>; Thu,  5 Nov 2020 12:21:56 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id x12so3239276wrm.8
        for <io-uring@vger.kernel.org>; Thu, 05 Nov 2020 12:21:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:references:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Cs2qwytA3lBbYxhKsa4X+TnhcU78eQcQy/sBUbLuL7E=;
        b=lzECJV1BFDUN5+9wxT09cHREw3MXkSojxPd7pORDifYVrQwhKH08it7U3u9P1gQP5Q
         HGmsnl2JR7zlblwm7cTlYKEu4rLObrtalK0ESVt5HH7vQb1bcFoU1+6nhSkAgkror/Pl
         yS5C3uLRfNAdGzTQ8FDlfHzBooFLZaQUl7BVnt1LDdi1UsCP4RY28ctZTM3F9RLex9DE
         SLWog8zIfQYIRn0dgRBhMy/wwo5RMInuk45QdWxEq3QhVhUl561TW+rBlUamSi6Q2CyQ
         Yt+9CL8L/UuljCOQqhtTHzrmikE1E9HT8qkto4g92Qog4Kno8Ol5xGpIkT/7PCw4fhd3
         8byg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:references:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Cs2qwytA3lBbYxhKsa4X+TnhcU78eQcQy/sBUbLuL7E=;
        b=gdjGANQM0GpBLBGsxmNzAVa61Wly0oVuGbrgXuLHgDouuzI2LdHGQzxpxCSWV28ASG
         Kx9mKrUp1KLEFWHSsCK6TYqIC8ldAy8bOVMGXni9eaH75ebPlr9/4idgLJRbJhUQBMUT
         k1SoqxO8wvLhCdrRL6dOAGIenP2m7eRoWJS97VLK3P31mm/Nw++xJ3zOflcZTdobReOZ
         NasYMqGRdOhpCqhBLwV4jEyRYTWozDZIyo4j43uX+711W6vEmq0qy98D6XDtD16Cm3XR
         I//H4PHD2gOaON7X7V4mbTAdql5YHHefQiu4SUG+IGFcokg2BiRe2hdx3zNYrNxXFIUG
         PcXw==
X-Gm-Message-State: AOAM532enCpdevU5t+RhxOBChaexc2RrLMJH22FV7EirR8iZ0WvPxblB
        e/GT59IJelmAbvoqHj81df0ik06aH6E=
X-Google-Smtp-Source: ABdhPJyudiD5xKXYYrvTfNDQFcjJA3sfmpWW2ax6YQX2O8DAxGMT+jPdh/4I98Bqz0V7M48IP/wlOg==
X-Received: by 2002:adf:c388:: with SMTP id p8mr4994304wrf.307.1604607714560;
        Thu, 05 Nov 2020 12:21:54 -0800 (PST)
Received: from [192.168.1.47] (host109-152-100-228.range109-152.btcentralplus.com. [109.152.100.228])
        by smtp.gmail.com with ESMTPSA id 205sm4167470wme.38.2020.11.05.12.21.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Nov 2020 12:21:53 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Dmitry Kadashev <dkadashev@gmail.com>, io-uring@vger.kernel.org
References: <CAOKbgA5ojRs0xuor9TEtBEHUfhEj5sJewDoNgsbAYruhrFmPQw@mail.gmail.com>
 <1c1cd326-d99a-b15b-ab73-d5ee437db0fa@gmail.com>
 <7db39583-8839-ac9e-6045-5f6e2f4f9f4b@gmail.com>
 <97810ccb-2f85-9547-e7c1-ce1af562924d@kernel.dk>
 <38141659-e902-73c6-a320-33b8bf2af0a5@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: Use of disowned struct filename after 3c5499fa56f5?
Message-ID: <7875f7ef-4555-c374-aa33-37cc163a4f5e@gmail.com>
Date:   Thu, 5 Nov 2020 20:18:53 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <38141659-e902-73c6-a320-33b8bf2af0a5@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 05/11/2020 20:04, Pavel Begunkov wrote:
> On 05/11/2020 19:37, Jens Axboe wrote:
>> On 11/5/20 7:55 AM, Pavel Begunkov wrote:
>>> On 05/11/2020 14:22, Pavel Begunkov wrote:
>>>> On 05/11/2020 12:36, Dmitry Kadashev wrote:
>>> Hah, basically filename_parentat() returns back the passed in filename if not
>>> an error, so @oldname and @from are aliased, then in the end for retry path
>>> it does.
>>>
>>> ```
>>> put(from);
>>> goto retry;
>>> ```
>>>
>>> And continues to use oldname. The same for to/newname.
>>> Looks buggy to me, good catch!
>>
>> How about we just cleanup the return path? We should only put these names
>> when we're done, not for the retry path. Something ala the below - untested,
>> I'll double check, test, and see if it's sane.
> 
> Retry should work with a comment below because it uses @oldname knowing that
> it aliases to @from, which still have a refcount, but I don't like this
> implicit ref passing. If someone would change filename_parentat() to return
> a new filename, that would be a nasty bug.
> 
> options I see
> 1. take a reference on old/newname in the beginning.
> 
> 2. don't return a filename from filename_parentat().
> struct filename *name = ...;
> int ret = filename_parentat(name, ...);
> // use @name
> 
> 3. (also ugly)
> retry:
> 	oldname = from; 
> 
>>
>>
>> diff --git a/fs/namei.c b/fs/namei.c
>> index a696f99eef5c..becb23ec07a8 100644
>> --- a/fs/namei.c
>> +++ b/fs/namei.c
>> @@ -4473,16 +4473,13 @@ int do_renameat2(int olddfd, struct filename *oldname, int newdfd,
>>  	if (retry_estale(error, lookup_flags))
>>  		should_retry = true;
>>  	path_put(&new_path);
>> -	putname(to);
>>  exit1:
>>  	path_put(&old_path);
>> -	putname(from);
>>  	if (should_retry) {	
>>  		should_retry = false;
>>  		lookup_flags |= LOOKUP_REVAL;
>>  		goto retry;
>>  	}
>> -	return error;
>>  put_both:
> 
> I don't see oldname to be cleared after filename_parentat(),
> so it puts both @from and @oldname, but there is only 1 ref.

I'm wrong here, you don't put @from.

Still filename_parentat() may fail, put oldname inside, destroy
it and return an error, but as we don't clear oldname put_both:
and below would do putname(oldname) again.

> 
>>  	if (!IS_ERR(oldname))
>>  		putname(oldname);
>>
> 

-- 
Pavel Begunkov
