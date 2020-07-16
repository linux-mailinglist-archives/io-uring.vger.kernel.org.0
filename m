Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05F7E222DA9
	for <lists+io-uring@lfdr.de>; Thu, 16 Jul 2020 23:20:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726195AbgGPVU5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Jul 2020 17:20:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726125AbgGPVU4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Jul 2020 17:20:56 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C1FAC08C5C0
        for <io-uring@vger.kernel.org>; Thu, 16 Jul 2020 14:20:56 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id q74so7687526iod.1
        for <io-uring@vger.kernel.org>; Thu, 16 Jul 2020 14:20:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LEv+cQHA0XVbPMchrlnqMxvR2K1AYW3g6zK4UFsmFr4=;
        b=n8TtjlSgQK6zU0sdra5ATCoBC6aOE8/1mnUXbCo8BmXqg8Y12GIOpFWzYBy40wj23U
         JmoMk0rduLiaC+UVOW7D/nGGfwTrey+2CrevmYppsxQULo8eDxbunzsZNk0LLJ6HtOGq
         ZsscAzjF0679jB4Qb+S39HskAxrgsRKj9NoYzU+iFB/OVxvFtbwgib1KEwtVPGcaB6SG
         qp3z1ZJ7zcxrN121ZMsjZNknSEJCYp95O85MD4wG3pGulD20kBSlPl0xXhVLAQJgbXC6
         goO5rKY/VaWec0XlG3xAf+9pbAmCycTC5aJ9vYExN1xKg352hKcLAEpkifJF+Fryj3mZ
         coZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LEv+cQHA0XVbPMchrlnqMxvR2K1AYW3g6zK4UFsmFr4=;
        b=U1zRUWXt9Te+chgyJfF0GVWc+lGOy0NpRi/fTbKH1nt/s8KOFDGW5MVL+bP41zFc9P
         6FPUIbLtqDfTj3m3MoqpkKMYRI5Oh6UwYWGPy9FfIBxH6fJvwDXNMYcToDe16RB2rrBd
         OPWDaMYhiAWiKRszcCAe1H1LrJjohWqU1NflTc4o3VbHCDtfb/GerxD2EbV6qjmpcv8U
         PLZU8jLDOJSbTCV3HqFSH0adVp9NB2uBQVAcYI1lUe0xfzX3KCcdUJIYHDayc1UrBYky
         09wbsisDiFWXuAwpqd+s9TzQO/w1k55HpHwf5MkGWR9vdyqq9dFIq9AjA6s3r1a2fe07
         +Zbw==
X-Gm-Message-State: AOAM531lc6oyfAFz055LMWLIWQwfDZM4NHrw1kCafKiBJEurqoLSmR1y
        hDgeb1sCqg5ekhvcvhXpF3E9lQ==
X-Google-Smtp-Source: ABdhPJxkpXHzsahyntnkdfZ9wBuSP7clR/vwRWqejN6tIPNw6BoYR132PIZwKZWkDVV6KrHlU2MY5A==
X-Received: by 2002:a92:4913:: with SMTP id w19mr6104024ila.185.1594934455696;
        Thu, 16 Jul 2020 14:20:55 -0700 (PDT)
Received: from [192.168.1.58] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id v15sm2238190ili.28.2020.07.16.14.20.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jul 2020 14:20:54 -0700 (PDT)
Subject: Re: [PATCH RFC v2 1/3] io_uring: use an enumeration for
 io_uring_register(2) opcodes
From:   Jens Axboe <axboe@kernel.dk>
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Stefano Garzarella <sgarzare@redhat.com>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        Kees Cook <keescook@chromium.org>,
        Aleksa Sarai <asarai@suse.de>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Sargun Dhillon <sargun@sargun.me>,
        Jann Horn <jannh@google.com>, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Jeff Moyer <jmoyer@redhat.com>,
        linux-kernel@vger.kernel.org
References: <20200716124833.93667-1-sgarzare@redhat.com>
 <20200716124833.93667-2-sgarzare@redhat.com>
 <ca242a15-576d-4099-a5f8-85c08985e3ff@gmail.com>
 <a2f109b2-adbf-147d-9423-7a1a4bf99967@kernel.dk>
 <20326d79-fb5a-2480-e52a-e154e056171f@gmail.com>
 <76879432-745d-a5ca-b171-b1391b926ea2@kernel.dk>
Message-ID: <0357e544-d534-06d2-dc61-1169fc172d20@kernel.dk>
Date:   Thu, 16 Jul 2020 15:20:53 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <76879432-745d-a5ca-b171-b1391b926ea2@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/16/20 2:51 PM, Jens Axboe wrote:
> On 7/16/20 2:47 PM, Pavel Begunkov wrote:
>> On 16/07/2020 23:42, Jens Axboe wrote:
>>> On 7/16/20 2:16 PM, Pavel Begunkov wrote:
>>>> On 16/07/2020 15:48, Stefano Garzarella wrote:
>>>>> The enumeration allows us to keep track of the last
>>>>> io_uring_register(2) opcode available.
>>>>>
>>>>> Behaviour and opcodes names don't change.
>>>>>
>>>>> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
>>>>> ---
>>>>>  include/uapi/linux/io_uring.h | 27 ++++++++++++++++-----------
>>>>>  1 file changed, 16 insertions(+), 11 deletions(-)
>>>>>
>>>>> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
>>>>> index 7843742b8b74..efc50bd0af34 100644
>>>>> --- a/include/uapi/linux/io_uring.h
>>>>> +++ b/include/uapi/linux/io_uring.h
>>>>> @@ -253,17 +253,22 @@ struct io_uring_params {
>>>>>  /*
>>>>>   * io_uring_register(2) opcodes and arguments
>>>>>   */
>>>>> -#define IORING_REGISTER_BUFFERS		0
>>>>> -#define IORING_UNREGISTER_BUFFERS	1
>>>>> -#define IORING_REGISTER_FILES		2
>>>>> -#define IORING_UNREGISTER_FILES		3
>>>>> -#define IORING_REGISTER_EVENTFD		4
>>>>> -#define IORING_UNREGISTER_EVENTFD	5
>>>>> -#define IORING_REGISTER_FILES_UPDATE	6
>>>>> -#define IORING_REGISTER_EVENTFD_ASYNC	7
>>>>> -#define IORING_REGISTER_PROBE		8
>>>>> -#define IORING_REGISTER_PERSONALITY	9
>>>>> -#define IORING_UNREGISTER_PERSONALITY	10
>>>>> +enum {
>>>>> +	IORING_REGISTER_BUFFERS,
>>>>> +	IORING_UNREGISTER_BUFFERS,
>>>>> +	IORING_REGISTER_FILES,
>>>>> +	IORING_UNREGISTER_FILES,
>>>>> +	IORING_REGISTER_EVENTFD,
>>>>> +	IORING_UNREGISTER_EVENTFD,
>>>>> +	IORING_REGISTER_FILES_UPDATE,
>>>>> +	IORING_REGISTER_EVENTFD_ASYNC,
>>>>> +	IORING_REGISTER_PROBE,
>>>>> +	IORING_REGISTER_PERSONALITY,
>>>>> +	IORING_UNREGISTER_PERSONALITY,
>>>>> +
>>>>> +	/* this goes last */
>>>>> +	IORING_REGISTER_LAST
>>>>> +};
>>>>
>>>> It breaks userspace API. E.g.
>>>>
>>>> #ifdef IORING_REGISTER_BUFFERS
>>>
>>> It can, yes, but we have done that in the past. In this one, for
>>
>> Ok, if nobody on the userspace side cares, then better to do that
>> sooner than later.

I actually don't think it's a huge issue. Normally if applications
do this, it's because they are using it and need it. Ala:

#ifndef IORING_REGISTER_SOMETHING
#define IORING_REGISTER_SOMETHING	fooval
#endif

and that'll still work just fine, even if an identical enum is there.

-- 
Jens Axboe

