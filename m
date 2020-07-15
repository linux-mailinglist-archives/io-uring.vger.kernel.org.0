Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C6F8220804
	for <lists+io-uring@lfdr.de>; Wed, 15 Jul 2020 11:02:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729983AbgGOJCJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Jul 2020 05:02:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728250AbgGOJCI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Jul 2020 05:02:08 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4193C061755;
        Wed, 15 Jul 2020 02:02:07 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id ga4so1350331ejb.11;
        Wed, 15 Jul 2020 02:02:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zLtHd+L1gvf9Mf73u2Vk+fGKGwNYy8l9W26vD58LKbY=;
        b=U4PE0wsxb5dm52D6WG63DhDxMllhdzx76pIDkWl8rVmzALIWt/cPi62NBoHIqJz3ic
         2bYNBQ9JUreZRnSvBb7aF39dIDx6sLIcBgbyIXq+y18hg4DE0mDA1PXO39YudWPaUfbB
         +uVCLUqWz8aI5vNPpRAJAfcRfNbWw8eez5vbJliCNzM/g4KWVqmyz1dQkEaHFHrRmC01
         IesWp9RKWl73suFiSpQTeKERboqXqtASbXdMzbVLFXybUH/jWlR+WwiXV7jGjwdO2aeC
         fZlwx1ftu7dUZqxJDKeBbACsy6NA4mpiPSieFqWsYuagNJyEOLyLPGxXZ3QKnk6+iG7I
         cGpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=zLtHd+L1gvf9Mf73u2Vk+fGKGwNYy8l9W26vD58LKbY=;
        b=QHkuMOVLcDoFBvpa3ZHUo6ZmdEsnKkgTzsWXTa7ZSsMudZKRyYRmi77iWwAP8X1bKs
         XvLMprlT99ZPdPzwVFAleDJiGPChFrOfraLzY8tqr3Jf+/4g1RecLqWpeI/Oug1z/Uv/
         LDG8VH8bq8OYzLDLfFqXljDXMTqClK4upnvO5Y/E9fOqAxypFBBrF0wqP1nU5QfZINfs
         ZFk176Nj1kCpLGfOLUKaEmI8fZVY31by7+30i3G/alIFpD+fsfSldKT46Bhkenr1scY+
         vIsKF8I/rdIy8rQOT+jU4z2Ev/bw+h96fgoGzEpQPKKXrdaP6mXPLUKSB4hlj+rJ67AM
         460Q==
X-Gm-Message-State: AOAM532D2YmvqdnQvWB+1+7oZzcERm6fvW+tdTtyv7QXIcrWEhrZ6c+1
        rYXH7wg8423HrE108n+u3XfROZQ9bPs=
X-Google-Smtp-Source: ABdhPJxMw6SQ5yL8X9owvNPMH0CVQQKkqEb9cHoW8Hhw3M/5RBiDT1kMx4yjEn28VEOMLptwqkQHNA==
X-Received: by 2002:a17:906:38d6:: with SMTP id r22mr8276033ejd.219.1594803726163;
        Wed, 15 Jul 2020 02:02:06 -0700 (PDT)
Received: from [192.168.43.236] ([5.100.193.69])
        by smtp.gmail.com with ESMTPSA id v9sm1451053ejd.102.2020.07.15.02.02.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jul 2020 02:02:05 -0700 (PDT)
Subject: Re: [PATCH 0/3] readfile(2): a new syscall to make open/read/close
 faster
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Pavel Machek <pavel@denx.de>, Greg KH <gregkh@linuxfoundation.org>,
        Jan Ziak <0xe2.0x9a.0x9b@gmail.com>,
        Linux API <linux-api@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        linux-man <linux-man@vger.kernel.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>, shuah@kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>, io-uring@vger.kernel.org
References: <CAODFU0q6CrUB_LkSdrbp5TQ4Jm6Sw=ZepZwD-B7-aFudsOvsig@mail.gmail.com>
 <20200705115021.GA1227929@kroah.com> <20200714065110.GA8047@amd>
 <CAJfpegu8AXZWQh3W39PriqxVna+t3D2pz23t_4xEVxGcNf1AUA@mail.gmail.com>
 <4e92b851-ce9a-e2f6-3f9a-a4d47219d320@gmail.com>
 <CAJfpegvroouw5ndHv+395w5PP1c+pUyp=-T8qhhvSnFbhbRehg@mail.gmail.com>
 <7584d754-2044-a892-cf29-65259b9c4eb1@gmail.com>
 <CAJfpegvkw5Exptz=gY5bRy2U8GjvTo+muBHsgdF_PA5=hyhmSA@mail.gmail.com>
 <b3adac43-f4ec-7820-1297-59eee206f308@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <df17d629-59ea-3262-fae4-28c05e5c9294@gmail.com>
Date:   Wed, 15 Jul 2020 12:00:19 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <b3adac43-f4ec-7820-1297-59eee206f308@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 15/07/2020 11:49, Pavel Begunkov wrote:
> On 15/07/2020 11:41, Miklos Szeredi wrote:
>> On Wed, Jul 15, 2020 at 10:33 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>>
>>> On 14/07/2020 14:55, Miklos Szeredi wrote:
>>>> On Tue, Jul 14, 2020 at 1:36 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>>>>
>>>>> On 14/07/2020 11:07, Miklos Szeredi wrote:
>>>>>> On Tue, Jul 14, 2020 at 8:51 AM Pavel Machek <pavel@denx.de> wrote:
>>>>>>>
>>>>>>> Hi!
>>>>>>>
>>>>>>>>> At first, I thought that the proposed system call is capable of
>>>>>>>>> reading *multiple* small files using a single system call - which
>>>>>>>>> would help increase HDD/SSD queue utilization and increase IOPS (I/O
>>>>>>>>> operations per second) - but that isn't the case and the proposed
>>>>>>>>> system call can read just a single file.
>>>>>>>>
>>>>>>>> If you want to do this for multple files, use io_ring, that's what it
>>>>>>>> was designed for.  I think Jens was going to be adding support for the
>>>>>>>> open/read/close pattern to it as well, after some other more pressing
>>>>>>>> features/fixes were finished.
>>>>>>>
>>>>>>> What about... just using io_uring for single file, too? I'm pretty
>>>>>>> sure it can be wrapped in a library that is simple to use, avoiding
>>>>>>> need for new syscall.
>>>>>>
>>>>>> Just wondering:  is there a plan to add strace support to io_uring?
>>>>>> And I don't just mean the syscalls associated with io_uring, but
>>>>>> tracing the ring itself.
>>>>>
>>>>> What kind of support do you mean? io_uring is asynchronous in nature
>>>>> with all intrinsic tracing/debugging/etc. problems of such APIs.
>>>>> And there are a lot of handy trace points, are those not enough?
>>>>>
>>>>> Though, this can be an interesting project to rethink how async
>>>>> APIs are worked with.
>>>>
>>>> Yeah, it's an interesting problem.  The uring has the same events, as
>>>> far as I understand, that are recorded in a multithreaded strace
>>>> output (syscall entry, syscall exit); nothing more is needed>
>>>> I do think this needs to be integrated into strace(1), otherwise the
>>>> usefulness of that tool (which I think is *very* high) would go down
>>>> drastically as io_uring usage goes up.
>>>
>>> Not touching the topic of usefulness of strace + io_uring, but I'd rather
>>> have a tool that solves a problem, than a problem that created and honed
>>> for a tool.
>>
>> Sorry, I'm not getting the metaphor.  Can you please elaborate?
> 
> Sure, I mean _if_ there are tools that conceptually suit better, I'd
> prefer to work with them, then trying to shove a new and possibly alien
> infrastructure into strace.
> 
> But my knowledge of strace is very limited, so can't tell whether that's
> the case. E.g. can it utilise static trace points?

I think, if you're going to push this idea, we should start a new thread
CC'ing strace devs.
	
-- 
Pavel Begunkov
