Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10DC214C1D4
	for <lists+io-uring@lfdr.de>; Tue, 28 Jan 2020 21:56:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726257AbgA1U4D (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 28 Jan 2020 15:56:03 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:46400 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726211AbgA1U4D (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 28 Jan 2020 15:56:03 -0500
Received: by mail-io1-f65.google.com with SMTP id t26so16040440ioi.13
        for <io-uring@vger.kernel.org>; Tue, 28 Jan 2020 12:56:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XMk/cpahV7fdjcZz6AlvHJnqVQz0wG0GnVUn8cDH8/I=;
        b=vbYQPOqCQ9+tsRt96a+hWnt41zZ0S+6Izi4VNXmDwgpsXxK19GKGo8Qg5bq+niwE5c
         sxCLJNcG0sEp/AhYdnRdIuZldjuXAg0/Ko8UFM3FmN9gKLNaVPEuUd/JExBGwNHbPGlu
         OjfabC1RrKZvGH+ZiECij4BN1DWR7+Ym31oI43/cPAj7zwLiSwsE1IFtwJBX00TU3MHj
         I2BFnqWYl5R8wRy9/YuC4nxu7NW5Hd/FKGcsX+OidB2EgTYByJFTwmUPrnmABM1DPa3X
         FG4Uuzo2ADPZ4a6QREN8Fi0J18T/lgVa5qM1/zAJmL9aTk+OjrEFzGh5o/2zi3UgKNm5
         j/FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XMk/cpahV7fdjcZz6AlvHJnqVQz0wG0GnVUn8cDH8/I=;
        b=R/ZHqbzMJXI5rsUpE3eJyF4PJve0NAO/8XsPGJ0xA5+ik7V/Jqb7K1p3V8IUThJNP1
         FVD/8OBRDVBBlk7YHeCayFrXsvF2As/eQSe89anh6Z3Jv/yIQc+Wy8uPXI4E1sQ2mnSm
         cT8Q3vbXyLSvLCXKDgoIlG+iJCb3H/rPJmi/8EwO9Wyj48t84+q1gx9MoNrlMzbTpVEN
         zfm/uAvUMXLRKHni/DyKUZdRYNGmfaJQA8UYdI+leGH135PF2BNhN60TgOG49iRN1gxm
         NqkmNWmMaDpCgeBf405j5VTpxKLgO53YK4KRMdH3WVcS6nEfr+i3aHLOJqIetjArhq+K
         MKMQ==
X-Gm-Message-State: APjAAAVbXCEn5zoF6dzwpHudpJkFREITkq/x7pv6v5jVJjrie8xON4QH
        fCVKD6Yip4Pcf5k5OnYZpsuzuQeE/mw=
X-Google-Smtp-Source: APXvYqxfWJj5T/7A5l73y+xAJJzdogn+FLeHRff6DOCv+FQrXvdds6k1ciWMqUXxLjIK3mcxDJ1ZDg==
X-Received: by 2002:a02:cf0e:: with SMTP id q14mr6357655jar.107.1580244962537;
        Tue, 28 Jan 2020 12:56:02 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id k18sm3259136ila.23.2020.01.28.12.56.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jan 2020 12:56:02 -0800 (PST)
Subject: Re: IORING_REGISTER_CREDS[_UPDATE]() and credfd_create()?
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Stefan Metzmacher <metze@samba.org>
Cc:     io-uring <io-uring@vger.kernel.org>,
        Linux API Mailing List <linux-api@vger.kernel.org>
References: <ea9f2f27-e9fe-7016-5d5f-56fe1fdfc7a9@samba.org>
 <d6bc8139-abbe-8a8d-7da1-4eeafd9eebe7@kernel.dk>
 <688e187a-75dd-89d9-921c-67de228605ce@samba.org>
 <b29e972e-5ca0-8b5f-46b3-36f93d865723@kernel.dk>
 <1ac31828-e915-6180-cdb4-36685442ea75@kernel.dk>
 <0d4f43d8-a0c4-920b-5b8f-127c1c5a3fad@kernel.dk>
 <b88f0590-71c9-d2bd-9d17-027b05d30d7a@kernel.dk>
 <15ca72fd-5750-db7c-2404-2dd4d53dd196@gmail.com>
 <82b20ec2-ceaa-93f1-4cce-889a933f2c7a@kernel.dk>
 <60253bd9-93a7-4d76-93b6-586e4f55138c@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <43a57f2a-16da-e657-3dca-5aa3afe31318@kernel.dk>
Date:   Tue, 28 Jan 2020 13:56:00 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <60253bd9-93a7-4d76-93b6-586e4f55138c@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/28/20 1:50 PM, Pavel Begunkov wrote:
> On 28/01/2020 23:19, Jens Axboe wrote:
>> On 1/28/20 1:16 PM, Pavel Begunkov wrote:
>>> On 28/01/2020 22:42, Jens Axboe wrote:
>>>> On 1/28/20 11:04 AM, Jens Axboe wrote:
>>>>> On 1/28/20 10:19 AM, Jens Axboe wrote:
>>>>>> On 1/28/20 9:19 AM, Jens Axboe wrote:
>>>>>>> On 1/28/20 9:17 AM, Stefan Metzmacher wrote:
>>>>>> OK, so here are two patches for testing:
>>>>>>
>>>>>> https://git.kernel.dk/cgit/linux-block/log/?h=for-5.6/io_uring-vfs-creds
>>>>>>
>>>>>> #1 adds support for registering the personality of the invoking task,
>>>>>> and #2 adds support for IORING_OP_USE_CREDS. Right now it's limited to
>>>>>> just having one link, it doesn't support a chain of them.
>>>>>>
>>>>>> I'll try and write a test case for this just to see if it actually works,
>>>>>> so far it's totally untested. 
>>>>>>
>>>>>> Adding Pavel to the CC.
>>>>>
>>>>> Minor tweak to ensuring we do the right thing for async offload as well,
>>>>> and it tests fine for me. Test case is:
>>>>>
>>>>> - Run as root
>>>>> - Register personality for root
>>>>> - create root only file
>>>>> - check we can IORING_OP_OPENAT the file
>>>>> - switch to user id test
>>>>> - check we cannot IORING_OP_OPENAT the file
>>>>> - check that we can open the file with IORING_OP_USE_CREDS linked
>>>>
>>>> I didn't like it becoming a bit too complicated, both in terms of
>>>> implementation and use. And the fact that we'd have to jump through
>>>> hoops to make this work for a full chain.
>>>>
>>>> So I punted and just added sqe->personality and IOSQE_PERSONALITY.
>>>> This makes it way easier to use. Same branch:
>>>>
>>>> https://git.kernel.dk/cgit/linux-block/log/?h=for-5.6/io_uring-vfs-creds
>>>>
>>>> I'd feel much better with this variant for 5.6.
>>>>
>>>
>>> To be honest, sounds pretty dangerous. Especially since somebody started talking
>>> about stealing fds from a process, it could lead to a nasty loophole somehow.
>>> E.g. root registers its credentials, passes io_uring it to non-privileged
>>> children, and then some process steals the uring fd (though, it would need
>>> priviledged mode for code-injection or else). Could we Cc here someone really
>>> keen on security?
>>
>> Link? If you can steal fds, then surely you've already lost any sense of
> 
> https://lwn.net/Articles/808997/
> But I didn't looked up it yet.

This isn't new by any stretch, it's always been possible to pass file
descriptors through SCM_RIGHTS. This just gives you a new way to do it.
That's not stealing or leaking, it's deliberately passing it to someone
else.

>> security in the first place? Besides, if root registered the ring, the root
>> credentials are already IN the ring. I don't see how this adds any extra
>> holes.
> 
> Isn't it what you fixed in ("don't use static creds/mm assignments") ?

Sure, but SQPOLL still uses it.

> I'm not sure what capability (and whether any) it would need, but
> better to think such cases through. Just saying, I would prefer to ask
> a person with extensive security experience, unlike me.

I don't disagree, but I really don't think this is any different than
what we already allow.

-- 
Jens Axboe

