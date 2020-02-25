Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF66516F0F4
	for <lists+io-uring@lfdr.de>; Tue, 25 Feb 2020 22:13:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726130AbgBYVNt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 25 Feb 2020 16:13:49 -0500
Received: from mail-wr1-f48.google.com ([209.85.221.48]:38177 "EHLO
        mail-wr1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726125AbgBYVNt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 25 Feb 2020 16:13:49 -0500
Received: by mail-wr1-f48.google.com with SMTP id e8so386849wrm.5
        for <io-uring@vger.kernel.org>; Tue, 25 Feb 2020 13:13:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Lxy5Uuc1O6GaqDB6pcG+SCdzoWN71OMpnn1DUNjEAuM=;
        b=JBI4rawlMh5iZVeAC5zAbQfnhAFI4mE8s6W/CJZ1vTaXseU+cUQw6lqlOU4zqFtnLt
         Sy4+uJQBVZiWSHdQOg6NkT7n56xsc/G1UYUni5b1kVdKRpXSGkn8NmIqGx/50aOCc9ji
         bEOMRnkfDjIpwlDx97SiszF7gnDiEwdZwvpSi/0Glrcxm5I8BwY/IkezZOkDq23LkAzj
         mRIUk3kuC/H+U7G706oBQoC2n0Jq08nxOfwMsLzWDL3+RDxXpJsucuLdP6QhpG5Toiwm
         kuyrMhvBHmjNtHZP/n4VCMkZ/Te7nRHNl/nq35wZwZwOQpj34fAH5g+thaUd9isQCnTt
         xxFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=Lxy5Uuc1O6GaqDB6pcG+SCdzoWN71OMpnn1DUNjEAuM=;
        b=Rzpvu3BKEwCSSEdMNd2dn+JrUNd+NkcxO9FJp580a1dLzkez15lBghyeEsDSCLPJjL
         CHLY2PVOyI/wvzdLrJu4dSkc13FTuzgWg2IztMiXw56JlbxOkbqRLgip0BDzSCrskPmT
         gAYK6BzuTe6hHNAZ5abgIMitN8TNOMiV6G38fahSkN4X67d+KuB9fhdRaannzHAVbRTd
         JeODU0draKngNcywU+oo0lpXSrYUZfn2S0Lw2F0j5na0TrBHDCD5rTjqZHYnukR2vaOb
         wfwllYWzt1dn8/8WG4NjA5UOfmA26gKYgY6UX1YNY6sTTmLtzL98jOxBqMrXu1yyzuex
         EG8g==
X-Gm-Message-State: APjAAAWCx7r0Oy7HBrWsiQzw04Ta8qGL/HedRrdRKjwSFBB8HoXa40bu
        sIrCwpRpAmwWN9dfT3x4rFGICTrp
X-Google-Smtp-Source: APXvYqxzt/Hdch51I6N9eQBrlfyIRZ+4pWM+BqXQNz8TdmEfdi5KcWNChTVHvAhZp8yyIO4pof19yw==
X-Received: by 2002:adf:aacc:: with SMTP id i12mr1104387wrc.90.1582665225987;
        Tue, 25 Feb 2020 13:13:45 -0800 (PST)
Received: from [192.168.43.62] ([109.126.137.65])
        by smtp.gmail.com with ESMTPSA id w1sm120624wro.72.2020.02.25.13.13.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Feb 2020 13:13:45 -0800 (PST)
To:     Jens Axboe <axboe@kernel.dk>,
        =?UTF-8?B?Q2FydGVyIExpIOadjumAmua0sg==?= <carter.li@eoitek.com>
Cc:     io-uring <io-uring@vger.kernel.org>
References: <1a9a6022-7175-8ed3-4668-e4de3a2b9ff7@gmail.com>
 <9E393343-7DB8-49D1-A7A2-611F88124C11@eoitek.com>
 <9830e660-0ffa-ed48-37da-493485a5ea17@kernel.dk>
 <56a18348-2949-e9da-b036-600b5bb4dad2@kernel.dk>
 <1e733dd7-acd4-dde6-b3c5-c0ee0fbeda2a@gmail.com>
 <be37a342-9768-5d1e-8d80-6d3d28f236e8@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [RFC] single cqe per link
Message-ID: <9271f312-4863-fd3b-5ced-d200d68cfe22@gmail.com>
Date:   Wed, 26 Feb 2020 00:13:01 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <be37a342-9768-5d1e-8d80-6d3d28f236e8@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 25/02/2020 23:20, Jens Axboe wrote:
> On 2/25/20 3:12 AM, Pavel Begunkov wrote:
>> Flexible, but not performant. The existence of drain is already makes
>> io_uring to do a lot of extra stuff, and even worse when it's actually used.
> 
> Yeah I agree, that's assuming we can make the drain more efficient. Just
> hand waving on possible use cases :-)

I don't even know what to do with sequences and drains when we get to in-kernel
sqe generation. And the current linear numbering won't be the case at all.

E.g. req1 -> DRAIN, and req1 infinitely generates req2, req3, etc. Should they
go before DRAIN? or at any time? What would be performance burden for it?..

I'd rather forbid them for using with some new features. And that's the reason
behind the question about wideness of its use.

>>
>> That's a different thing. Knowing how requests behave (e.g. if
>> nbytes!=res, then fail link), one would want to get cqe for the last
>> executed sqe, whether it's an error or a success for the last one.
>>
>> It makes a link to be handled as a single entity. I don't see a way to
>> emulate similar behaviour with the unconditional masking. Probably, we
>> will need them both.
> 
> But you can easily do that with IOSQE_NO_CQE, in fact that's what I did
> to test this. The chain will have IOSQE_NO_CQE | IOSQE_IO_LINK set on
> all but the last request.

It's fine if you don't expect it to fail. Otherwise, there will be only
-ECANCELELED for the last one, so you don't know error code nor failed
req/user_data. Forcing IOSQE_NO_CQE to emit in case of an error is not really
better.

I know, it's hard to judge base on performance-testing-only patch, but the whole
idea is to greatly simplify userspace cqe handling, including errors. And I'd
like to find something better/faster and doing the same favor.


> 
> My box with the optane2 is out of commission, apparently, cannot get it
> going today. So I had to make do with my laptop, which does about ~600K
> random read IOPS. I don't see any difference there, using polled IO,
> using 4 link deep chains (so 1/4th the CQEs). Both run at around
> 611-613K IOPS.

-- 
Pavel Begunkov
