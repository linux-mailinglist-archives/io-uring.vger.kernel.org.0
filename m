Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 535411400B9
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2020 01:19:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730835AbgAQAS5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Jan 2020 19:18:57 -0500
Received: from mail-pf1-f176.google.com ([209.85.210.176]:33612 "EHLO
        mail-pf1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730461AbgAQAS4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Jan 2020 19:18:56 -0500
Received: by mail-pf1-f176.google.com with SMTP id z16so11068049pfk.0
        for <io-uring@vger.kernel.org>; Thu, 16 Jan 2020 16:18:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PP1y9t3+ZSXllNfB2ZNrGJev/DA1JlR1a7P3+3PKC1Q=;
        b=OfUT64e3GF/PACUidZKM/Xn5oiBdwlpzzY5iUghx8DJz02xyINzabeAiBXfyXDBsVA
         2q7sfpQrBK0zo4uv8HJND/WpSZ7hUto9nTep0Zj8aKkBJ8fwaepoSQG7yjTTCPzzE8/b
         I0V6li4eY0BVGbThz6QVigBRJ/ToPEubcCLnqL/DuZ3GfqHgODfQpE+HHbcjdC+e/cAc
         j/MnZRAHOi8AAzzh8ojE3waFtteU+IgEjG+sjepkTX5pBgLSztNT25sQndzZZXv89CP2
         FyOTUEhu00Fx/okBu6Hnrh0PgRtYlm6iLnjgkea8wQ1u9z5Z7EWBqfV1US6cn0/uKq5B
         pCzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PP1y9t3+ZSXllNfB2ZNrGJev/DA1JlR1a7P3+3PKC1Q=;
        b=i8Niugk4/xnhpbCfR/3DETXEZMhpBCRrq8BGZO8fN8oNs88NYFTuxG7ex8eSdjdsC2
         ncEr0me+XM5KAgdf2GdBfdbTfQmUpBi3tznBggzN/8qTI0KvaMiutjfaoOW0ndBR/sey
         jh5Uawz97H51nIDovKr+anAv+gRO8JtnPmGqLZy0Vs68mWLRVSqE2FMIBum/xo1wKvHU
         7Ga1EaeTbXxDJy3axrRMAIZUQmR3NV9MBWaMYM8cEDRf0xy2AR5fsV252wT/2oH9+etL
         E36PkL4/KEFq8uO+xSnlTBKdbmdbrGtd/PnXN1oKXQ0VsFAM3iYAxVlXEY4rVHQmtGph
         ZEhA==
X-Gm-Message-State: APjAAAUJa7xZ3aKQGPnHwN7PgVP1NhUYfs0GwXmnw1y+mgjZGqzAmYTa
        +6jvogXLki1Zu7SybmrBeOrYUQ==
X-Google-Smtp-Source: APXvYqz20xu+mpR9kPehp8RNNgGI4s9ep3R6bzScWDSKJkGb3p0V6Ch6oXe6kAa7UT6WUkqYQWzjmw==
X-Received: by 2002:a63:9d07:: with SMTP id i7mr44392413pgd.344.1579220336135;
        Thu, 16 Jan 2020 16:18:56 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id q64sm4992312pjb.1.2020.01.16.16.18.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jan 2020 16:18:55 -0800 (PST)
Subject: Re: [PATCHSET v2 0/6] io_uring: add support for open/close
To:     Stefan Metzmacher <metze@samba.org>, io-uring@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk
References: <20200107170034.16165-1-axboe@kernel.dk>
 <e4fb6287-8216-529e-9666-5ec855db02fb@samba.org>
 <4adb30f4-2ab3-6029-bc94-c72736b9004a@kernel.dk>
 <4dffd58e-5602-62d5-d1af-343c4a091ed9@samba.org>
 <eb99e387-f385-c36d-b1d9-f99ec470eba6@kernel.dk>
 <9a407238-5505-c446-80b7-086646dd15be@kernel.dk>
 <d4d3fa40-1c59-a48a-533b-c8b221e0f221@samba.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <7324bbb7-8f7b-c0c6-6a45-48b8b77c4be8@kernel.dk>
Date:   Thu, 16 Jan 2020 17:18:53 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <d4d3fa40-1c59-a48a-533b-c8b221e0f221@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/16/20 3:50 PM, Stefan Metzmacher wrote:
> Am 09.01.20 um 03:03 schrieb Jens Axboe:
>> On 1/8/20 6:02 PM, Jens Axboe wrote:
>>> On 1/8/20 4:05 PM, Stefan Metzmacher wrote:
>>>> Am 08.01.20 um 23:57 schrieb Jens Axboe:
>>>>> On 1/8/20 2:17 PM, Stefan Metzmacher wrote:
>>>>>> Am 07.01.20 um 18:00 schrieb Jens Axboe:
>>>>>>> Sending this out separately, as I rebased it on top of the work.openat2
>>>>>>> branch from Al to resolve some of the conflicts with the differences in
>>>>>>> how open flags are built.
>>>>>>
>>>>>> Now that you rebased on top of openat2, wouldn't it be better to add
>>>>>> openat2 that to io_uring instead of the old openat call?
>>>>>
>>>>> The IORING_OP_OPENAT already exists, so it would probably make more sense
>>>>> to add IORING_OP_OPENAT2 alongside that. Or I could just change it. Don't
>>>>> really feel that strongly about it, I'll probably just add openat2 and
>>>>> leave openat alone, openat will just be a wrapper around openat2 anyway.
>>>>
>>>> Great, thanks!
>>>
>>> Here:
>>>
>>> https://git.kernel.dk/cgit/linux-block/log/?h=for-5.6/io_uring-vfs
>>>
>>> Not tested yet, will wire this up in liburing and write a test case
>>> as well.
>>
>> Wrote a basic test case, and used my openbench as well. Seems to work
>> fine for me. Pushed prep etc support to liburing.
> 
> Thanks!
> 
> Another great feature would the possibility to make use of the
> generated fd in the following request.
> 
> This is a feature that's also available in the SMB3 protocol
> called compound related requests.
> 
> The client can compound a chain with open, getinfo, read, close
> getinfo, read and close get an file handle of -1 and implicitly
> get the fd generated/used in the previous request.

Right, the "plan" there is to utilize BPF to make this programmable.
We really need something more expressive to be able to pass information
between SQEs that are linked, or even to decide which link to run
depending on the outcome of the parent.

There's a lot of potential there!

-- 
Jens Axboe

