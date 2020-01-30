Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEB9D14DDCF
	for <lists+io-uring@lfdr.de>; Thu, 30 Jan 2020 16:29:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727208AbgA3P3d (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Jan 2020 10:29:33 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:33477 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727217AbgA3P3d (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Jan 2020 10:29:33 -0500
Received: by mail-io1-f67.google.com with SMTP id z8so4493255ioh.0
        for <io-uring@vger.kernel.org>; Thu, 30 Jan 2020 07:29:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=OhK06CA3YzAzN+bOzkkl05V2NgQ7hdpBskjx0RBNIgQ=;
        b=Z55DQngxsnsYFCrXpbLkjaQWg9zQ2oQh+VqVKZMRkvOs4l/cTBL11kQ24AUyR/5WHU
         yk0lC3J2Z9vrq8qOuxnRe61SytIgq3TojUu3D0vhvRoUrdEWjkpsgVJTQcdlw5EJ/ki+
         1qONJ/mGwUH85kFbV6sWZhXtQXfhENCGg01lZgRWdy9Z1Op6QyyUlp9G/jKC8o59SxP6
         yajsgVIMrQ2o+1+knBHMT06mycCPkjWu3GnemFRownkDe48nn8M7i0fN48ARxXJHtf5Y
         rmT4zVTvxqwtpTTx13LJ5kU7tTTPSRnOoqjdvgha8NLSZV8oTgXflYKado4+vSoqu84K
         B69Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OhK06CA3YzAzN+bOzkkl05V2NgQ7hdpBskjx0RBNIgQ=;
        b=KnvK+kvk3dpHw3oOKm7nsmssS+r7ZAGvNdjPIT+5hlFiIIPLMo2nAXJF2qOf4+22vG
         HJFvzF86sPDzIyUnF4sCd56eXDet4Wkmi/ahOoy3jxm/sHyHP2kPppyGVBq4MKeFohLN
         se9vkXffORTpe7B6oXlOaOmqJymSNFFv4dRIj60IEt72I2IeBk/IvDWMVizNFDhsiwG5
         oLXoX8v8/D2TR3VchcPU6NnGA8Tz4xUulr8CGM0bH4JpxJC+rwQKPCKIOXDCSfZuL8TH
         qh1O0Y1EmVhZWvHANzS9OqHIAZYTb95Lf4Rpb274mpmOk9ImXhqXRWF+veCHNS4TJDNr
         L8CQ==
X-Gm-Message-State: APjAAAX+u8+eRMzaDTAswQaeJGMrJ1KHDNgNcCa93rCiJMzjnyMgNqkg
        EWm68+TXcp870pHPnZXoRiv3ZA==
X-Google-Smtp-Source: APXvYqyIMDoQlsl43QCNsVhRYXpoYITg5VIfY+O2wLl8i+CLi7wPBZ/xxHMFQvzgoHS6cWZ48vXyxQ==
X-Received: by 2002:a5e:8417:: with SMTP id h23mr4407052ioj.17.1580398171787;
        Thu, 30 Jan 2020 07:29:31 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id z8sm1958345ilk.9.2020.01.30.07.29.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jan 2020 07:29:31 -0800 (PST)
Subject: Re: IORING_REGISTER_CREDS[_UPDATE]() and credfd_create()?
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Jann Horn <jannh@google.com>, Stefan Metzmacher <metze@samba.org>,
        io-uring <io-uring@vger.kernel.org>,
        Linux API Mailing List <linux-api@vger.kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>
References: <b29e972e-5ca0-8b5f-46b3-36f93d865723@kernel.dk>
 <1ac31828-e915-6180-cdb4-36685442ea75@kernel.dk>
 <0d4f43d8-a0c4-920b-5b8f-127c1c5a3fad@kernel.dk>
 <b88f0590-71c9-d2bd-9d17-027b05d30d7a@kernel.dk>
 <CAG48ez17Ums4s=gjai-Lakr2tWf9bjmYYeNb5aGrwAD51ypZMA@mail.gmail.com>
 <4f833fc5-b4c0-c304-c3c2-f63c050b90a2@kernel.dk>
 <9ce2e571-ed84-211a-4e99-d830ecdaf0e2@kernel.dk>
 <CAG48ez1qVCoOwcdA7YZcKObQ9frWNxCjHOp6RYeqd+q_n4KJJQ@mail.gmail.com>
 <20200130102635.ar2bohr7n4li2hyd@wittgenstein>
 <cf801c52-7719-bb5c-c999-ab9aab0d4871@kernel.dk>
 <20200130151342.u554shnaliau42jq@wittgenstein>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <e6d98755-7122-63f5-2047-18ef9f42c60e@kernel.dk>
Date:   Thu, 30 Jan 2020 08:29:30 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200130151342.u554shnaliau42jq@wittgenstein>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/30/20 8:13 AM, Christian Brauner wrote:
> On Thu, Jan 30, 2020 at 07:11:08AM -0700, Jens Axboe wrote:
>> On 1/30/20 3:26 AM, Christian Brauner wrote:
>>> On Thu, Jan 30, 2020 at 11:11:58AM +0100, Jann Horn wrote:
>>>> On Thu, Jan 30, 2020 at 2:08 AM Jens Axboe <axboe@kernel.dk> wrote:
>>>>> On 1/29/20 10:34 AM, Jens Axboe wrote:
>>>>>> On 1/29/20 7:59 AM, Jann Horn wrote:
>>>>>>> On Tue, Jan 28, 2020 at 8:42 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>>>>>> On 1/28/20 11:04 AM, Jens Axboe wrote:
>>>>>>>>> On 1/28/20 10:19 AM, Jens Axboe wrote:
>>>>>>> [...]
>>>>>>>>>> #1 adds support for registering the personality of the invoking task,
>>>>>>>>>> and #2 adds support for IORING_OP_USE_CREDS. Right now it's limited to
>>>>>>>>>> just having one link, it doesn't support a chain of them.
>>>>>>> [...]
>>>>>>>> I didn't like it becoming a bit too complicated, both in terms of
>>>>>>>> implementation and use. And the fact that we'd have to jump through
>>>>>>>> hoops to make this work for a full chain.
>>>>>>>>
>>>>>>>> So I punted and just added sqe->personality and IOSQE_PERSONALITY.
>>>>>>>> This makes it way easier to use. Same branch:
>>>>>>>>
>>>>>>>> https://git.kernel.dk/cgit/linux-block/log/?h=for-5.6/io_uring-vfs-creds
>>>>>>>>
>>>>>>>> I'd feel much better with this variant for 5.6.
>>>>>>>
>>>>>>> Some general feedback from an inspectability/debuggability perspective:
>>>>>>>
>>>>>>> At some point, it might be nice if you could add a .show_fdinfo
>>>>>>> handler to the io_uring_fops that makes it possible to get a rough
>>>>>>> overview over the state of the uring by reading /proc/$pid/fdinfo/$fd,
>>>>>>> just like e.g. eventfd (see eventfd_show_fdinfo()). It might be
>>>>>>> helpful for debugging to be able to see information about the fixed
>>>>>>> files and buffers that have been registered. Same for the
>>>>>>> personalities; that information might also be useful when someone is
>>>>>>> trying to figure out what privileges a running process actually has.
>>>>>>
>>>>>> Agree, that would be a very useful addition. I'll take a look at it.
>>>>>
>>>>> Jann, how much info are you looking for? Here's a rough start, just
>>>>> shows the number of registered files and buffers, and lists the
>>>>> personalities registered. We could also dump the buffer info for
>>>>> each of them, and ditto for the files. Not sure how much verbosity
>>>>> is acceptable in fdinfo?
>>>>
>>>> At the moment, I personally am just interested in this from the
>>>> perspective of being able to audit the state of personalities, to make
>>>> important information about the security state of processes visible.
>>>>
>>>> Good point about verbosity in fdinfo - I'm not sure about that myself either.
> 
> Afaik, there's no rule here. I would expect that it shouldn't exceed
> 4096kb just because that is the limit that seems to be enforced for
> writes to proc files atm; other than that it should be the wild west.
> The fdinfo files are mostly interesting for anon_inode fds imho and the
> ones that come to mind right now simply don't have a lot of information
> to provide:
> 
> eventfd
> timerfd
> seccomp_notify_fd
> 
> Potentially, the mount fds from David could be extended in the future.

4MB is huge, I'd not get anywhere near that. So I'd say the current
format is probably fine. I honed it a little bit to be prettier, looks
good to me. I'll send it out for review.

> (Side note: One thing that comes to mind is that we should probably
> enforce^Wdocument that all fdinfo files use CamelCase?)

Fine with me, seems to already be the norm, would be nice to have it
documented.

-- 
Jens Axboe

