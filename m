Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3211B134828
	for <lists+io-uring@lfdr.de>; Wed,  8 Jan 2020 17:40:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728051AbgAHQkJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Jan 2020 11:40:09 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:40204 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727127AbgAHQkJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Jan 2020 11:40:09 -0500
Received: by mail-pj1-f68.google.com with SMTP id bg7so1316798pjb.5
        for <io-uring@vger.kernel.org>; Wed, 08 Jan 2020 08:40:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jZgMbISEx5/ZwoweCKstWunPDGLwVoLwLQ95l7OM00w=;
        b=c1XmWKiHp2h+A3AfXzToAFiFWv45qJzXO/2M/Bsahue/9KGEAiRt4bPT6TJm0Rj6Uv
         c+1AkxCjKpJYOzfneSOtEIcGP0hWqQerjLMrFqT8i+5KPYGwQMhQPWmnARAVEX0LaRhm
         jUv0jSr/Igtxw5YIkxmUC90tY/XY6ozONNZxuD9rJd+O+G8YZOSC+IjLkpdNg/hkFnWI
         pvOgtIMaeXfgz27wwEAL3mQSXRHWOuNXgtoyZTclACUBEoDcZY/O0LdctV2ZbfUKcwXo
         ryqVuHt6tcBhsQ/j3YH0o6ihLQZix1r+mYJmAr7+/Xv9dKTi4L2G9gsII3PzYx/2EURp
         RG2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jZgMbISEx5/ZwoweCKstWunPDGLwVoLwLQ95l7OM00w=;
        b=GcBP8TQ0xgbGBmnf8+RtaOAn+CcgEG5rzEgklEtO9p+g1+uJxLXj47YClM2wgWJxws
         Dd2QIGTs7DxTGbrGEdrTJCwYuMpI0CmiKOSMDLDP7u5NvWn7EV+FxvxuKbMIYA9vaen8
         wIfww48wcVa8eBK3GL+STGV3LKpvCx6xpbmGsQqXvirjNfiDMqM60cK7pRtVG57uht+B
         CGB+NpL3bbhO/ByUMdGurSQtJbDoN6LbZl6HrdWiBkYF1+4jBT6FqY9yju4KUzCxmM7H
         wBttzRvk2ToXWqjGHje/WOuFdqWB6lmsZEL4gG6uYqFAZiytn+ya8zg1OOApXza17+zj
         XX0A==
X-Gm-Message-State: APjAAAWAFV6/ptT+Ir8lkFUIDIgJsDKABYTxuCddSnJhwsDUs/LFCJho
        m52IsCqUSaAdT9HiQpQ7F23oiA==
X-Google-Smtp-Source: APXvYqwJet9UKFMoX7hR+EMWyyPQvpc5T0YWzIkbowE8RkaStgCLhh43PIO66X8TH5tZ/KuEpJ1z1w==
X-Received: by 2002:a17:90a:9b88:: with SMTP id g8mr5353248pjp.72.1578501608336;
        Wed, 08 Jan 2020 08:40:08 -0800 (PST)
Received: from ?IPv6:2620:10d:c081:1130::1133? ([2620:10d:c090:180::38c8])
        by smtp.gmail.com with ESMTPSA id k23sm4179804pgg.7.2020.01.08.08.40.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jan 2020 08:40:07 -0800 (PST)
Subject: Re: [PATCH 3/6] io_uring: add support for IORING_OP_OPENAT
To:     Stefan Metzmacher <metze@samba.org>, io-uring@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk
References: <20200107170034.16165-1-axboe@kernel.dk>
 <20200107170034.16165-4-axboe@kernel.dk>
 <82a015c4-f5b9-7c85-7d80-78964cb0d82e@samba.org>
 <4ccb935c-7ff9-592f-8c27-0af3d38326d7@kernel.dk>
 <2afdd5a5-0eb5-8fba-58d1-03001abbab7e@samba.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <9672da37-bf6f-ce2d-403c-5e2692c67782@kernel.dk>
Date:   Wed, 8 Jan 2020 09:40:05 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <2afdd5a5-0eb5-8fba-58d1-03001abbab7e@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/8/20 9:32 AM, Stefan Metzmacher wrote:
> Am 08.01.20 um 17:20 schrieb Jens Axboe:
>> On 1/8/20 6:05 AM, Stefan Metzmacher wrote:
>>> Hi Jens,
>>>
>>>> This works just like openat(2), except it can be performed async. For
>>>> the normal case of a non-blocking path lookup this will complete
>>>> inline. If we have to do IO to perform the open, it'll be done from
>>>> async context.
>>>
>>> Did you already thought about the credentials being used for the async
>>> open? The application could call setuid() and similar calls to change
>>> the credentials of the userspace process/threads. In order for
>>> applications like samba to use this async openat, it would be required
>>> to specify the credentials for each open, as we have to multiplex
>>> requests from multiple user sessions in one process.
>>>
>>> This applies to non-fd based syscall. Also for an async connect
>>> to a unix domain socket.
>>>
>>> Do you have comments on this?
>>
>> The open works like any of the other commands, it inherits the
>> credentials that the ring was setup with. Same with the memory context,
>> file table, etc. There's currently no way to have multiple personalities
>> within a single ring.
> 
> Ah, it's user = get_uid(current_user()); and ctx->user = user in
> io_uring_create(), right?

That's just for the accounting, it's the:

ctx->creds = get_current_cred();

>> Sounds like you'd like an option for having multiple personalities
>> within a single ring?
> 
> I'm not sure anymore, I wasn't aware of the above.
> 
>> I think it would be better to have a ring per personality instead.
> 
> We could do that. I guess we could use per user rings for path based
> operations and a single ring for fd based operations.
> 
>> One thing we could do to make this more lightweight
>> is to have rings that are associated, so that we can share a lot of the
>> backend processing between them.
> 
> My current idea is to use the ring fd and pass it to our main epoll loop.
> 
> Can you be more specific about how an api for associated rings could
> look like?

The API would be the exact same, there would just be some way to
associate rings when you create them. Probably a new field in struct
io_uring_params (and an associated flag), which would tell io_uring that
two separate rings are really the same "user". This would allow io_uring
to use the same io-wq workqueues, for example, etc.

This depends on the fact that you can setup the rings with the right
personalities, that they would be known upfront. From your description,
I'm not so sure that's the case? If not, then we would indeed need
something that can pass in the credentials on a per-command basis. Not
sure what that would look like.

-- 
Jens Axboe

