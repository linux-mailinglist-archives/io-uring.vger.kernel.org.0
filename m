Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C7E115D936
	for <lists+io-uring@lfdr.de>; Fri, 14 Feb 2020 15:17:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729320AbgBNORE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 14 Feb 2020 09:17:04 -0500
Received: from mail-lj1-f180.google.com ([209.85.208.180]:45568 "EHLO
        mail-lj1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729268AbgBNORE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 14 Feb 2020 09:17:04 -0500
Received: by mail-lj1-f180.google.com with SMTP id e18so10864226ljn.12
        for <io-uring@vger.kernel.org>; Fri, 14 Feb 2020 06:17:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QIQQDJpBzINR/Rd5ILrXesYGD1sjTERZcja7ii0ZiCw=;
        b=GTiLOhl9kHS8JgI460SwSmFooPw9sSeiOp24oDaPNMLAynwSPcwUIInf9uJQIeh+tW
         bIUgGNULYssCv3w80j/BjwZNXdaMET0zpTgtH/cmw4zhSdBeSDTecQDfnKyuf5W61arG
         y9bYi6emA9qjExy1G/q6f9OMj5lh6qbEK4G5qnbhtKB+DIKjaN9aoSsp1yr6pejH3VOg
         NQqSuZG/8FiatW2lqkulPyGPX3hSh600J4hl+HG4fmcF7W+1iiYpH1GF1HFyItXXJiPR
         ehq5poUbd+tf4Y9ZKEBpwiTuo2YJ92xV0rEXmjMjWIOWOL/rxc9CiWguXxmPb1xgCmN4
         DlfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QIQQDJpBzINR/Rd5ILrXesYGD1sjTERZcja7ii0ZiCw=;
        b=Ph0JiwylV2F4h1hqwM2gcNj8Wq/ofqFpC+zCEDXSm293ZiufYJD/U5vRScKjcTqrnJ
         IpWD/yGZCgc4Qtd+HCRVDfIYvXWIiYekcwuSdMXs1NXgz8pGzdtkOMnOuHb6CKpytNxo
         7Xg7hhuKqAolBAI3vGhQvJlXcFFJQDFyDkRJY/EY7mhmQZ45H9agU/C4vQzQmuhF4Zln
         rds/7pJ7SP7ezwytk3KtoO5xuEDu5F8ETAU2IPYcppC0V1q3SzSppaNnTy+vYfxEpktb
         09p4fhzNuwTXdgQ7ZH0TGKBN+YpnANLc8KCWg5XNqCXsefqMhSCgKwmC0qmMWrFCtoX6
         4NwQ==
X-Gm-Message-State: APjAAAUptlBWoGavH8fbgKtobwnRime8e4PVKbK9joSZKBs5Ugkw50wu
        5Ue8398ZDAxKtotlO6BafsI8onY+Xnw=
X-Google-Smtp-Source: APXvYqyPwmPrTE3WDeKfYOFHJAPsRmhXnH/UWaM1xGABUn9JQ/lfjiOclcyGePXm8arLWoUgbV5K7A==
X-Received: by 2002:a2e:9596:: with SMTP id w22mr2185561ljh.21.1581689821483;
        Fri, 14 Feb 2020 06:17:01 -0800 (PST)
Received: from [172.31.190.83] ([86.57.146.226])
        by smtp.gmail.com with ESMTPSA id e8sm4368107ljb.45.2020.02.14.06.17.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Feb 2020 06:17:00 -0800 (PST)
Subject: Re: [FEATURE REQUEST] Specify a sqe won't generate a cqe
To:     =?UTF-8?B?Q2FydGVyIExpIOadjumAmua0sg==?= <carter.li@eoitek.com>
Cc:     io-uring <io-uring@vger.kernel.org>
References: <9A41C624-3D2C-40BC-A910-59CBDC5BB76E@eoitek.com>
 <30d88cf3-527e-4396-4934-fff13c449a80@gmail.com>
 <7C48911C-9C0F-42E1-90DA-7C277E37D986@eoitek.com>
 <19236051-0949-ed5c-d1d5-458c07681f36@gmail.com>
 <57BDF3A6-7279-4250-B200-76FDCDB04765@eoitek.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <67b28e66-f2f8-99a1-dfd1-14f753d11f7a@gmail.com>
Date:   Fri, 14 Feb 2020 17:16:59 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <57BDF3A6-7279-4250-B200-76FDCDB04765@eoitek.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/14/2020 4:27 PM, Carter Li 李通洲 wrote:
>> 2020年2月14日 下午8:52，Pavel Begunkov <asml.silence@gmail.com> 写道：
>> On 2/14/2020 2:27 PM, Carter Li 李通洲 wrote:
>>>> 2020年2月14日 下午6:34，Pavel Begunkov <asml.silence@gmail.com> 写道：
>>>> On 2/14/2020 11:29 AM, Carter Li 李通洲 wrote:
>>>>> To implement io_uring_wait_cqe_timeout, we introduce a magic number
>>>>> called `LIBURING_UDATA_TIMEOUT`. The problem is that not only we
>>>>> must make sure that users should never set sqe->user_data to
>>>>> LIBURING_UDATA_TIMEOUT, but also introduce extra complexity to
>>>>> filter out TIMEOUT cqes.
>>>>>
>>>>> Former discussion: https://github.com/axboe/liburing/issues/53
>>>>>
>>>>> I’m suggesting introducing a new SQE flag called IOSQE_IGNORE_CQE
>>>>> to solve this problem.
>>>>>
>>>>> For a sqe tagged with IOSQE_IGNORE_CQE flag, it won’t generate a cqe
>>>>> on completion. So that IORING_OP_TIMEOUT can be filtered on kernel
>>>>> side.
>>>>>
>>>>> In addition, `IOSQE_IGNORE_CQE` can be used to save cq size.
>>>>>
>>>>> For example `POLL_ADD(POLLIN)->READ/RECV` link chain, people usually
>>>>> don’t care the result of `POLL_ADD` is ( since it will always be
>>>>> POLLIN ), `IOSQE_IGNORE_CQE` can be set on `POLL_ADD` to save lots
>>>>> of cq size.
>>>>>
>>>>> Besides POLL_ADD, people usually don’t care the result of POLL_REMOVE
>>>>> /TIMEOUT_REMOVE/ASYNC_CANCEL/CLOSE. These operations can also be tagged
>>>>> with IOSQE_IGNORE_CQE.
>>>>>
>>>>> Thoughts?
>>>>>
>>>>
>>>> I like the idea! And that's one of my TODOs for the eBPF plans.
>>>> Let me list my use cases, so we can think how to extend it a bit.
>>>>
>>>> 1. In case of link fail, we need to reap all -ECANCELLED, analise it and
>>>> resubmit the rest. It's quite inconvenient. We may want to have CQE only
>>>> for not cancelled requests.
>>>>
>>>> 2. When chain succeeded, you in the most cases already know the result
>>>> of all intermediate CQEs, but you still need to reap and match them.
>>>> I'd prefer to have only 1 CQE per link, that is either for the first
>>>> failed or for the last request in the chain.
>>>>
>>>> These 2 may shed much processing overhead from the userspace.
>>>
>>> I couldn't agree more!
>>>
>>> Another problem is that io_uring_enter will be awaked for completion of
>>> every operation in a link, which results in unnecessary context switch.
>>> When awaked, users have nothing to do but issue another io_uring_enter
>>> syscall to wait for completion of the entire link chain.
>>
>> Good point. Sounds like I have one more thing to do :)
>> Would the behaviour as in the (2) cover all your needs?
> 
> (2) should cover most cases for me. For cases it couldn’t cover ( if any ),
> I can still use normal sqes.
> 

Great! I need to give a thought, what I may need for eBPF-steering
stuff, but sounds like a plan.

>>
>> There is a nuisance with linked timeouts, but I think it's reasonable
>> for REQ->LINKED_TIMEOUT, where it didn't fired, notify only for REQ
>>
>>>>
>>>> 3. If we generate requests by eBPF even the notion of per-request event
>>>> may broke.
>>>> - eBPF creating new requests would also need to specify user-data, and
>>>> this may be problematic from the user perspective.
>>>> - may want to not generate CQEs automatically, but let eBPF do it.
>>>>

-- 
Pavel Begunkov
