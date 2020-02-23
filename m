Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02BC1169826
	for <lists+io-uring@lfdr.de>; Sun, 23 Feb 2020 15:49:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726302AbgBWOtH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 23 Feb 2020 09:49:07 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:37267 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726208AbgBWOtH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 23 Feb 2020 09:49:07 -0500
Received: by mail-pj1-f66.google.com with SMTP id m13so2927728pjb.2
        for <io-uring@vger.kernel.org>; Sun, 23 Feb 2020 06:49:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=L+S7bKVhGH2zgsF4PKwFe9zrC506jjX7aC6VW4ArOck=;
        b=guWoB/6ZN7xyh2dEqJboY4FC0xGOyPf/ARNdMVThs3pgIrXmqjBAaWbdnRSnaiU76r
         LCQUOYE2sNLt4uSe0c3pHQ8ilXzhK+7TDh1yG1D3PxqDPhX08p7SJ00cv3Fle/o3Sns7
         TMpng84l5ZDWxod93ZUo+P9TYVmdjwcu7KwDyeLYUg5VWWiJ21KUo2qZaNbzE2vJ8z7J
         ho/bi20CI+cWiikMqq4fJ1u8PCqGmrMU4h6KOaBIHs1hDTOAqNryFatXk+eLJEKE0AsY
         2ndGsCXJAQmHJHvnAKd8MYSCjgHImmR9XwjKnuD3FQI80ydwovK4hWgZKFqMJpfFgOKo
         G3eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=L+S7bKVhGH2zgsF4PKwFe9zrC506jjX7aC6VW4ArOck=;
        b=FY/8eucc9uN+GA5YKsqIzU6T38SzNefDKGcifhxeK/nPQlffHLH+gG+cLguvwG9Nhs
         VzOoTHu2A56HPO1l/VOu1gRapND3WsIadJImmVpuYLpTNa4LImb03NB8C7wdGYDv0ts4
         7v/D3+BitRnpnbVvB18+u9Lehkk4DTneJSXIj3GZSCozJu76NiY5QGFbXLl9l2MOuX6x
         Ztc5VpLALGaoEq54CrB3d0TUFcdyv0n6BPUse0BeEhaDG4nW+id4taZJ2Is2IlP0fC66
         puxgiH34BGF5Cmd8WCnhkndYI4nLCZvvWpNyK/Np6NbWmunuyTSDdXhOalDYFxh2w2x+
         tjJw==
X-Gm-Message-State: APjAAAWAdTKa+hKgrHRjd0yryhgw5CY4XJzlrJkiIH4yj8k4bfPg5/iN
        mvb539kZExecTEMN3pmpCyKMEg==
X-Google-Smtp-Source: APXvYqxwYhpcwnLA0AGXp89dYkGUR9JKYN3SVrK7uJC1QUGKKip13d2SsP11v6O6w1eyQRZ0vqDGGA==
X-Received: by 2002:a17:90a:3603:: with SMTP id s3mr15184266pjb.61.1582469346170;
        Sun, 23 Feb 2020 06:49:06 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id y10sm9510602pfq.110.2020.02.23.06.49.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 23 Feb 2020 06:49:05 -0800 (PST)
Subject: Re: [PATCH 7/9] io_uring: add per-task callback handler
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     glauber@scylladb.com, peterz@infradead.org,
        Jann Horn <jannh@google.com>
References: <20200220203151.18709-1-axboe@kernel.dk>
 <20200220203151.18709-8-axboe@kernel.dk>
 <862fb96f-cebe-dfd8-0042-3284985d8704@gmail.com>
 <3c9a3fca-a780-6d04-65cb-c08ef382a2eb@kernel.dk>
 <a5258ad9-ab20-8068-2cb8-848756cf568d@gmail.com>
 <2d869361-18d0-a0fa-cc53-970078d8b826@kernel.dk>
 <08564f4e-8dd1-d656-a22a-325cc1c3e38f@kernel.dk>
 <231dc76e-697f-d8dd-46cb-53776bdc920d@kernel.dk>
 <fcfcf572-f808-6b3a-f9eb-379657babba5@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <18d38bb6-70e2-24ce-a668-d279b8e3ce4c@kernel.dk>
Date:   Sun, 23 Feb 2020 07:49:02 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <fcfcf572-f808-6b3a-f9eb-379657babba5@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/23/20 4:02 AM, Pavel Begunkov wrote:
> On 23/02/2020 09:26, Jens Axboe wrote:
>> On 2/22/20 11:00 PM, Jens Axboe wrote:
>>> On 2/21/20 12:10 PM, Jens Axboe wrote:
>>>>> Got it. Then, it may happen in the future after returning from
>>>>> __io_arm_poll_handler() and io_uring_enter(). And by that time io_submit_sqes()
>>>>> should have already restored creds (i.e. personality stuff) on the way back.
>>>>> This might be a problem.
>>>>
>>>> Not sure I follow, can you elaborate? Just to be sure, the requests that
>>>> go through the poll handler will go through __io_queue_sqe() again. Oh I
>>>> guess your point is that that is one level below where we normally
>>>> assign the creds.
>>>
>>> Fixed this one.
> 
> Looking at
> 
> io_async_task_func() {
> 	...
> 	/* ensure req->work.creds is valid for __io_queue_sqe() */
> 	req->work.creds = apoll->work.creds;
> }
> 
> It copies creds, but doesn't touch the rest req->work fields. And if you have
> one, you most probably got all of them in *grab_env(). Are you sure it doesn't
> leak, e.g. mmgrab()'ed mm?

You're looking at a version that only existed for about 20 min, had to
check I pushed it out. But ce21471abe0fef is the current one, it does
a full memcpy() of it.

>>>>> BTW, Is it by design, that all requests of a link use personality creds
>>>>> specified in the head's sqe?
>>>>
>>>> No, I think that's more by accident. We should make sure they use the
>>>> specified creds, regardless of the issue time. Care to clean that up?
>>>> Would probably help get it right for the poll case, too.
>>>
>>> Took a look at this, and I think you're wrong. Every iteration of
>>> io_submit_sqe() will lookup the right creds, and assign them to the
>>> current task in case we're going to issue it. In the case of a link
>>> where we already have the head, then we grab the current work
>>> environment. This means assigning req->work.creds from
>>> get_current_cred(), if not set, and these are the credentials we looked
>>> up already.
> 
> Yeah, I've spotted that there something wrong, but never looked up properly.

And thanks for that!

>> What does look wrong is that we don't restore the right credentials for
>> queuing the head, so basically the opposite problem. Something like the
>> below should fix that.
>> index de650df9ac53..59024e4757d6 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -4705,11 +4705,18 @@ static void __io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>  {
>>  	struct io_kiocb *linked_timeout;
>>  	struct io_kiocb *nxt = NULL;
>> +	const struct cred *old_creds = NULL;
>>  	int ret;
>>  
>>  again:
>>  	linked_timeout = io_prep_linked_timeout(req);
>>  
>> +	if (req->work.creds && req->work.creds != get_current_cred()) {
> 
> get_current_cred() gets a ref.

Oops yes

> See my attempt below, it fixes miscount, and should work better for
> cases changing back to initial creds (i.e. personality 0)

Thanks, I'll fold this in, if you don't mind.

> Anyway, creds handling is too scattered across the code, and this do a
> lot of useless refcounting and bouncing. It's better to find it a
> better place in the near future.

I think a good cleanup on top of this would be to move the personality
lookup to io_req_defer_prep(), and kill it from io_submit_sqe(). Now
__io_issue_sqe() does the right thing, and it'll just fall out nicely
with that as far as I can tell.

Care to send a patch for that?

-- 
Jens Axboe

