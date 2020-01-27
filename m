Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9853614AC33
	for <lists+io-uring@lfdr.de>; Mon, 27 Jan 2020 23:40:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726164AbgA0WkE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Jan 2020 17:40:04 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:37151 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726101AbgA0WkE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Jan 2020 17:40:04 -0500
Received: by mail-pj1-f66.google.com with SMTP id m13so117673pjb.2
        for <io-uring@vger.kernel.org>; Mon, 27 Jan 2020 14:40:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KHLioOHt5qhxcibEXEQ1fG9u/J8Vb5qt2dsMdCQG9V8=;
        b=I0nlR7eLObzLw1V6/A6Npg/3/wihfzD8/V8X2odSeFB6RhkjqS7sSMjebpZVjz8XLV
         3ProDHTmZCevxNvAb5ToRIgCCLsrgCW6dLtW+X4io20XbcfBqLqUjIELv62R8wRoWt+u
         d3o21KB0zh7t2NCj3Uu5iGkmzSxYad046Q0m0o4sF6FHhnwSz+p8nY+UzgcXmZuCeUr6
         GJGAF5w6dLRh6fkB1UjWTerH/ypGL3MIc6BArwf14qx3OXrXuSm+PB17tx0kDYuJAhKa
         qP+d4RojdvOs0A+gruK9IYzOfQJ5Gc+CJIehzq8RiehGcdh3ym0BndvD6HferMz0mY4c
         sP4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KHLioOHt5qhxcibEXEQ1fG9u/J8Vb5qt2dsMdCQG9V8=;
        b=g8ISNZRfXLDARsdRcPH2InQ5/26SV20BHx0H21QFXRNB2IiXPh7sl5LTotx1oSMmu4
         o9AQGe0yOuRPv4Eh1LcsExZiBKy4XHa1TCT0J8mOcKV22O/E+t6s5UFLhQA3sIn49utx
         LKdI/+IUc499sJrTo1EA8pG82aIZbLqQhoXmLmgEti9kRcuc/xGfUNJtV+VRmcJedxuS
         K1Di87VGcKZN2swaOwQ5IOVKUVHxQVZ/3kT4oBcFCLvyBEJQTFR28Il0RGAq3rzUdM0f
         sPwxG7702ax0XxdmnpecCcuRQAf8WDuif71WPOrZG17jK7AOwdgS/+aypsQMLDN9bRVq
         zU4g==
X-Gm-Message-State: APjAAAXL+93mFoK6S1p7Bu3K7SRTJfu7yTgDdZPf4symo94gO15J6vSR
        /O53WG8cEsgu4xipcmEyXCM+A6WiCYA=
X-Google-Smtp-Source: APXvYqyhd966E832pmjdtYB8sbTOo8uPnKyfFm0iNS9EWdjXJmIpb3VgS3PKhOgT8KuHPG66xxCH2g==
X-Received: by 2002:a17:90a:db49:: with SMTP id u9mr1008817pjx.13.1580164803642;
        Mon, 27 Jan 2020 14:40:03 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id c184sm17377805pfa.39.2020.01.27.14.40.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Jan 2020 14:40:02 -0800 (PST)
Subject: Re: [PATCHSET 0/4] Add support for shared io-wq backends
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Daurnimator <quae@daurnimator.com>
Cc:     io-uring@vger.kernel.org
References: <20200123231614.10850-1-axboe@kernel.dk>
 <CAEnbY+c34Uiguq=11eZ1F0z_VZopeBbw1g1gfn-S0Fb5wCaL5A@mail.gmail.com>
 <4917a761-6665-0aa2-0990-9122dfac007a@gmail.com>
 <694c2b6f-6b51-fd7b-751e-db87de90e490@kernel.dk>
 <a9fcf996-88ed-6bc4-f5ef-6ce4ed2253c5@gmail.com>
 <92e92002-f803-819a-5f5e-44cf09e63c9b@kernel.dk>
 <3b3b5e03-2c7e-aa00-c1fd-3af8b2620d5e@gmail.com>
 <1b24da2d-dd92-608e-27b6-b827a728e7ab@kernel.dk>
 <e15d7700-7d7b-521e-0e78-e8bff9013277@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <c432d4e1-9cf0-d342-3d87-84bd731e07f3@kernel.dk>
Date:   Mon, 27 Jan 2020 15:40:00 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <e15d7700-7d7b-521e-0e78-e8bff9013277@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/27/20 2:45 PM, Pavel Begunkov wrote:
> On 27/01/2020 23:33, Jens Axboe wrote:
>> On 1/27/20 7:07 AM, Pavel Begunkov wrote:
>>> On 1/27/2020 4:39 PM, Jens Axboe wrote:
>>>> On 1/27/20 6:29 AM, Pavel Begunkov wrote:
>>>>> On 1/26/2020 8:00 PM, Jens Axboe wrote:
>>>>>> On 1/26/20 8:11 AM, Pavel Begunkov wrote:
>>>>>>> On 1/26/2020 4:51 AM, Daurnimator wrote:
>>>>>>>> On Fri, 24 Jan 2020 at 10:16, Jens Axboe <axboe@kernel.dk> wrote:
>>>>> Ok. I can't promise it'll play handy for sharing. Though, you'll be out
>>>>> of space in struct io_uring_params soon anyway.
>>>>
>>>> I'm going to keep what we have for now, as I'm really not imagining a
>>>> lot more sharing - what else would we share? So let's not over-design
>>>> anything.
>>>>
>>> Fair enough. I prefer a ptr to an extendable struct, that will take the
>>> last u64, when needed.
>>>
>>> However, it's still better to share through file descriptors. It's just
>>> not secure enough the way it's now.
>>
>> Is the file descriptor value really a good choice? We just had some
>> confusion on ring sharing across forks. Not sure using an fd value
>> is a sane "key" to use across processes.
>>
> As I see it, the problem with @mm is that uring is dead-bound to it.
> For example, a process can create and send uring (e.g. via socket),
> and then be killed. And that basically means
> 1. @mm of the process is locked just because of the sent uring
> instance.
> 2. a process may have an io_uring, which bound to @mm of another
> process, even though the layouts may be completely different.
> 
> File descriptors are different here, because io_uring doesn't know
> about them, They are controlled by the userspace (send, dup, fork,
> etc), and don't sabotage all isolation work done in the kernel. A dire
> example here is stealing io-wq from within a container, which is
> trivial with global self-made id. I would love to hear, if I am
> mistaken somewhere.
> 
> Is there some better option?

OK, so how about this:

- We use the 'fd' as the lookup key. This makes it easy since we can
  just check if it's a io_uring instance or not, we don't need to do any
  tracking on the side. It also means that the application asking for
  sharing must already have some relationship to the process that
  created the ring.

- mm/creds must be transferred through the work item. Any SQE done on
  behalf of io_uring_enter() directly already has that, if punted we
  must pass the creds and mm. This means we break the static setup of
  io_wq->mm/creds. It also means that we probably have to add that to
  io_wq_work, which kind of sucks, but...

I think with that we have a decent setup, that's also safe. I've dropped
the sharing patches for now, from the 5.6 tree.

-- 
Jens Axboe

