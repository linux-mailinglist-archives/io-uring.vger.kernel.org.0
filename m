Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACEB84D2522
	for <lists+io-uring@lfdr.de>; Wed,  9 Mar 2022 02:13:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbiCIBEe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Mar 2022 20:04:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229798AbiCIBEB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Mar 2022 20:04:01 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E4361CCB28
        for <io-uring@vger.kernel.org>; Tue,  8 Mar 2022 16:41:19 -0800 (PST)
Received: from [192.168.43.69] (unknown [182.2.75.207])
        by gnuweeb.org (Postfix) with ESMTPSA id 42EFE7E6CA;
        Wed,  9 Mar 2022 00:41:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1646786479;
        bh=Uw6X5Lk8FqzvsSIuTvcDgkig1zAgSiWVyzC5BXTQ4Gg=;
        h=Date:To:Cc:References:From:Subject:In-Reply-To:From;
        b=jji03fbdB+fFbmktVHTOGaWI2ix1Gfd29ydJHG5FVWanZIHvJrdiTBuRz8Vjj/C9Y
         1fflPGTuZEa0zaVkq7n4r5uREGck1x85/nRNAo5onEOpKpfVPKF8oOfxZ1uJmUB1aC
         ZIqxsHkqfzrn/FyQDHdSuPAWp00aeV6PucgMXvMzddFdVh8205IXuq/DMhuJbtyOEz
         w3ZuaMRd1KcHNTPbEz0bEphZBf8tmSBwfrqGoYLkpjViNGkNK+SRr0NtW6I7f/GUEH
         ubINEwJpVGq+0Dx7aGVMs3R1XObgyV0woTuzVdnMsq/IqxAkLqbEa0jwhyCS20gVVq
         S9ZNZa0jpwfeA==
Message-ID: <ac922806-7966-2940-a7aa-51421c8e83c6@gnuweeb.org>
Date:   Wed, 9 Mar 2022 07:41:14 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-Language: en-US
To:     Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Alviro Iskandar Setiawan <alviro.iskandar@gmail.com>,
        io-uring Mailing list <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
References: <20220308224002.3814225-1-alviro.iskandar@gnuweeb.org>
 <20220308224002.3814225-3-alviro.iskandar@gnuweeb.org>
 <acccd7d5-4570-1da3-0f27-1013fb4138ab@gnuweeb.org>
 <CAOG64qNECK73RGZek10_5se-H9T5EY3XwRaA4Jj-1PuCJv5F=w@mail.gmail.com>
 <CAOG64qNjjy9j5QcdqSKjiETUFn6AZb6A4OKWN25nZdia=6X2ew@mail.gmail.com>
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
Subject: Re: [PATCH liburing 2/2] src/Makefile: Add header files as dependency
In-Reply-To: <CAOG64qNjjy9j5QcdqSKjiETUFn6AZb6A4OKWN25nZdia=6X2ew@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/9/22 7:23 AM, Alviro Iskandar Setiawan wrote:
> On Wed, Mar 9, 2022 at 6:06 AM Alviro Iskandar Setiawan wrote:
>> On Wed, Mar 9, 2022 at 5:52 AM Ammar Faizi wrote:
>>> This is ugly, it blindly adds all of them to the dependency while
>>> they're actually not dependencies for all the C files here. For
>>> example, when compiling for x86, we don't touch aarch64 files.
>>>
>>> It is not a problem for liburing at the moment, because we don't
>>> have many files in the src directory now. But I think we better
>>> provide a long term solution on this.
>>>
>>> For the headers files, I think we should rely on the compilers to
>>> generate the dependency list with something like:
>>>
>>>      "-MT ... -MMD -MP -MF"
>>>
>>> Then include the generated dependency list to the Makefile.
>>>
>>> What do you think?
>>
>> Yes, I think it's better to do that. I'll fix this in v2.
>> thx
> 
> Sir, I am a bit confused with the include dependency files to the Makefile.
> 
> I use like this:
> 
>     -MT <object_filename> -MMD -MP -MF <dependency_file>
> 
> the dependency file is generated, but how to include them dynamically?
> I think it shouldn't be included one by one.
> 
> So after this
> 
>     [...] -MT "setup.os" -MMD -MP -MF ".deps/setup.os.d" [...]
>     [...] -MT "queue.os" -MMD -MP -MF ".deps/queue.os.d" [...]
>     [...] -MT "register.os" -MMD -MP -MF ".deps/register.os.d" [...]
>     [...] -MT "syscall.os" -MMD -MP -MF ".deps/syscall.os.d" [...]
> 
> files .deps/{setup,queue,registers,syscall}.os.d are generated, but I
> have to include them to Makefile right? How to include them all at
> once?

Untested, but I think you can do something like:

   -include $(liburing_objs:%=.deps/%.d)

where liburing_objs is the variable that contains:
{setup,queue,registers,syscall}.os.

-- 
Ammar Faizi
