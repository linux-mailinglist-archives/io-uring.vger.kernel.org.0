Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2BC717FE2C
	for <lists+io-uring@lfdr.de>; Tue, 10 Mar 2020 14:33:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727950AbgCJNd1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 10 Mar 2020 09:33:27 -0400
Received: from mail-il1-f194.google.com ([209.85.166.194]:42183 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727966AbgCJNd0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 10 Mar 2020 09:33:26 -0400
Received: by mail-il1-f194.google.com with SMTP id x2so11955506ila.9
        for <io-uring@vger.kernel.org>; Tue, 10 Mar 2020 06:33:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hsGsElZsB/5daJjMXNc/s6X6QC1H/m/QNHMEgZVdSms=;
        b=cyCK5LR3yohV4Ngggy7ZMc9MpoXpxx1wF7UVQKIRLfHUHNAyo362GFaVSGdAoDwaCq
         SkgPp1Q4LjqNliGBEVD1bdgM9rhQ6CzSuDggiCCKhjIdDT4aZ308erxEwMFBWe++wLjM
         vjgtFwStR72tX/9vWbMJN7wxRy9cIbpZmnELMMjC26S1RNAwMNmMfRiU+SQG9MTQda2a
         Oj2UC5En5KoYwiayLa4H/EtLw6Eqi9vxc+tDf7A2qBUNr1pwUFn4sR9fxaifjhfIBbQ0
         x2IBhDrSFo7p2yKn5ZWURwIXGMU37AHF4PuJq7mU7Uz43vY3Sp0ysfiRZ6lIAEPiuyKJ
         XgfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hsGsElZsB/5daJjMXNc/s6X6QC1H/m/QNHMEgZVdSms=;
        b=HNwnvibkzHvPUEKPYRfvvPEDIKY2WYwz6XaeduKGX38ZXg55wYjQe9JxVEKzCCj8o6
         yurHMAG1ipx/wx8VHWGK2HNPqUkMeez1FjnMG3Hk5eP9nQ2sKeF7wF45NPUv9Ev6FAtY
         cFPcRLL+akjkEHgXp0teQT0+z2VcPzjg5VXnQyYZA92kdLIn8DBCVmcirS1/8tfb3L3A
         BdHwLXTUtylsXojqjD8IqHT8dBbidwCc/M4WhU0JxLSBACPjWlhO6f47yxa/YD+Fd2qY
         CVt3+Mug/sGLpHcnZXZLJmSsrelTMAxvcNvSoVQRAjQNms9azMREP1wjierVX1nIt2hB
         +OLw==
X-Gm-Message-State: ANhLgQ1AYY8vi3U6Ev7H0DUE3hS0movl9suEvYgtQxwv9I4J1pn2vXP7
        vylWm4ArG0cQkPkcpQQert6WvR2A+a8z9A==
X-Google-Smtp-Source: ADFU+vv0ASj4RIsiiL92Rapj3EmIlYgpQS9Up3b5xldmkxxirqTmzPx5vwQkLm1Hed5S2GPBaJER7A==
X-Received: by 2002:a92:884d:: with SMTP id h74mr20024712ild.3.1583847204846;
        Tue, 10 Mar 2020 06:33:24 -0700 (PDT)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id h8sm6839885ile.8.2020.03.10.06.33.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Mar 2020 06:33:24 -0700 (PDT)
Subject: Re: [PATCH 2/6] io_uring: add IORING_OP_PROVIDE_BUFFERS
To:     Andres Freund <andres@anarazel.de>
Cc:     io-uring@vger.kernel.org
References: <20200228203053.25023-1-axboe@kernel.dk>
 <20200228203053.25023-3-axboe@kernel.dk>
 <20200309170313.perf4zbtdhq4jtvs@alap3.anarazel.de>
 <a2283eb6-4b86-b858-a440-af4a8a7c2ba9@kernel.dk>
 <20200309172846.ilh27woo7tsaqadf@alap3.anarazel.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <f4cfb6c8-cb0d-51fd-1f43-78a00242fb90@kernel.dk>
Date:   Tue, 10 Mar 2020 07:33:23 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200309172846.ilh27woo7tsaqadf@alap3.anarazel.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/9/20 11:28 AM, Andres Freund wrote:
> Hi,
> 
> On 2020-03-09 11:17:46 -0600, Jens Axboe wrote:
>>>> +static int io_add_buffers(struct io_provide_buf *pbuf, struct list_head *list)
>>>> +{
>>>> +	struct io_buffer *buf;
>>>> +	u64 addr = pbuf->addr;
>>>> +	int i, bid = pbuf->bid;
>>>> +
>>>> +	for (i = 0; i < pbuf->nbufs; i++) {
>>>> +		buf = kmalloc(sizeof(*buf), GFP_KERNEL);
>>>> +		if (!buf)
>>>> +			break;
>>>> +
>>>> +		buf->addr = addr;
>>>> +		buf->len = pbuf->len;
>>>> +		buf->bid = bid;
>>>> +		list_add(&buf->list, list);
>>>> +		addr += pbuf->len;
>>>> +		bid++;
>>>> +	}
>>>> +
>>>> +	return i;
>>>> +}
>>>
>>> Hm, aren't you loosing an error here if you kmalloc fails for i > 0?
>>> Afaict io_provide_buffes() only checks for ret != 0. I think userland
>>> should know that a PROVIDE_BUFFERS failed, even if just partially (I'd
>>> just make it fail wholesale).
>>
>> The above one does have the issue that we're losing the error for i ==
>> 0, current one does:
>>
>> return i ? i : -ENOMEM;
>>
>> But this is what most interfaces end up doing, return the number
>> processed, if any, or error if none of them were added. Like a short
>> read, for example, and you'd get EIO if you forwarded and tried again.
>> So I tend to prefer doing it like that, at least to me it seems more
>> logical than unwinding. The application won't know what buffer caused
>> the error if you unwind, whereas it's perfectly clear if you asked to
>> add 128 and we return 64 that the issue is with the 65th buffer.
> 
> Fair enough. I was/am thinking that this'd pretty much always be a fatal
> error for the application. Which does seem a bit different from the
> short read/write case, where there are plenty reasons to handle them
> "silently" during normal operation.
> 
> But I can error out with the current interface, so ...

Even if it is most likely a fatal condition for the application, it
would usually indicate that the application is doing something wrong.
Which means you want to debug it, and that's a lot more approachable
if you know exactly which buffer caused the issue. There's merit to
saying "buffer N isn't valid" rather than "One of the N buffers
submitted has an issue, good luck!".

-- 
Jens Axboe

