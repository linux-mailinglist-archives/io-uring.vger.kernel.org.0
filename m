Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D674C15D7AE
	for <lists+io-uring@lfdr.de>; Fri, 14 Feb 2020 13:52:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728083AbgBNMwH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 14 Feb 2020 07:52:07 -0500
Received: from mail-lf1-f46.google.com ([209.85.167.46]:41504 "EHLO
        mail-lf1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728062AbgBNMwH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 14 Feb 2020 07:52:07 -0500
Received: by mail-lf1-f46.google.com with SMTP id m30so6665543lfp.8
        for <io-uring@vger.kernel.org>; Fri, 14 Feb 2020 04:52:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=AHuFgxg6ao65G+XFnKoRYjRjQZtw3Zl0IwZYrENLSD0=;
        b=nCeKoA6UJHhs0PYPZV8yNjeH9KC7YyUMwxGuZxc3ibnHnIUFhtj0zyVPR3cnYikeTx
         tFOpGoYKaQgrNCikiTVHphcFiBLrx+UIpq4BmdwgoPxYmS8z1Dvtm8Y1qGfSFYYOkj6h
         wR3TstuH6/VBun1DcYRuLIjaeEJKzYvbXU92XT8p9Og3vJju7XIF3CPiJI4RKP6+YEuy
         Z8XK3v+LuSgKLcYFJfFr/zHYLmA2IFuw7LXvSfR+yZxCxLapHfXXNuUwbfrP1uy+Wl15
         YA+Dv2pU67Mo3drGeArGy6zc87u/FCtgZGhJF28aakY7/7gXZ3Oz1perLD0JwL+RKDnq
         qJrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AHuFgxg6ao65G+XFnKoRYjRjQZtw3Zl0IwZYrENLSD0=;
        b=QrFi696u5vSrBi6FtHDbi8oKnz5nrqcd06j3qjMWPKHlZgFcG/rQu193T/fLMktTKM
         VGXeypwTbY1g5oV63YFutDd5tL22zaVEWCgIuVpMaE2Tofv6XZygCwhI+6M1STS+urdu
         WwM+cAWLl8cd2J/BwT2E4nSX0yckgp7wXd3BZ6DL2Oyg8mq1/BbA7GURtEY+Ln2SdXTD
         cFTneR8wWLrkR2i/ZONuX/o1LdH15YfAIAsavqnxn9clL7/s9sRiVwjRD1olW/7kt12M
         23z4RBF2tS2nhqsIyo7GoyVG04yAu8bZnh+OuAGhcJX0+gmt61LCUm9jhBNBBgwDclNi
         lFWQ==
X-Gm-Message-State: APjAAAV8zCrafMIMOuUYXUS1xyee+ofqA/hfJl0n/X92MXkEW/QQ7mrA
        FZhk11bxhcA7II6Jv3dt6ut2ZyHzIRM=
X-Google-Smtp-Source: APXvYqy0kxXzPsHMq1WBP+ZLW47kwc+M496U59iudag8ACB0x72YO5eQuAVJxjzjjeeLoXws9docpw==
X-Received: by 2002:a19:ca0e:: with SMTP id a14mr1645766lfg.186.1581684724448;
        Fri, 14 Feb 2020 04:52:04 -0800 (PST)
Received: from [172.31.190.83] ([86.57.146.226])
        by smtp.gmail.com with ESMTPSA id h10sm3523983ljc.39.2020.02.14.04.52.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Feb 2020 04:52:03 -0800 (PST)
Subject: Re: [FEATURE REQUEST] Specify a sqe won't generate a cqe
To:     =?UTF-8?B?Q2FydGVyIExpIOadjumAmua0sg==?= <carter.li@eoitek.com>
Cc:     io-uring <io-uring@vger.kernel.org>
References: <9A41C624-3D2C-40BC-A910-59CBDC5BB76E@eoitek.com>
 <30d88cf3-527e-4396-4934-fff13c449a80@gmail.com>
 <7C48911C-9C0F-42E1-90DA-7C277E37D986@eoitek.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <19236051-0949-ed5c-d1d5-458c07681f36@gmail.com>
Date:   Fri, 14 Feb 2020 15:52:02 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <7C48911C-9C0F-42E1-90DA-7C277E37D986@eoitek.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/14/2020 2:27 PM, Carter Li 李通洲 wrote:
> 
>> 2020年2月14日 下午6:34，Pavel Begunkov <asml.silence@gmail.com> 写道：
>>
>> On 2/14/2020 11:29 AM, Carter Li 李通洲 wrote:
>>> To implement io_uring_wait_cqe_timeout, we introduce a magic number
>>> called `LIBURING_UDATA_TIMEOUT`. The problem is that not only we
>>> must make sure that users should never set sqe->user_data to
>>> LIBURING_UDATA_TIMEOUT, but also introduce extra complexity to
>>> filter out TIMEOUT cqes.
>>>
>>> Former discussion: https://github.com/axboe/liburing/issues/53
>>>
>>> I’m suggesting introducing a new SQE flag called IOSQE_IGNORE_CQE
>>> to solve this problem.
>>>
>>> For a sqe tagged with IOSQE_IGNORE_CQE flag, it won’t generate a cqe
>>> on completion. So that IORING_OP_TIMEOUT can be filtered on kernel
>>> side.
>>>
>>> In addition, `IOSQE_IGNORE_CQE` can be used to save cq size.
>>>
>>> For example `POLL_ADD(POLLIN)->READ/RECV` link chain, people usually
>>> don’t care the result of `POLL_ADD` is ( since it will always be
>>> POLLIN ), `IOSQE_IGNORE_CQE` can be set on `POLL_ADD` to save lots
>>> of cq size.
>>>
>>> Besides POLL_ADD, people usually don’t care the result of POLL_REMOVE
>>> /TIMEOUT_REMOVE/ASYNC_CANCEL/CLOSE. These operations can also be tagged
>>> with IOSQE_IGNORE_CQE.
>>>
>>> Thoughts?
>>>
>>
>> I like the idea! And that's one of my TODOs for the eBPF plans.
>> Let me list my use cases, so we can think how to extend it a bit.
>>
>> 1. In case of link fail, we need to reap all -ECANCELLED, analise it and
>> resubmit the rest. It's quite inconvenient. We may want to have CQE only
>> for not cancelled requests.
>>
>> 2. When chain succeeded, you in the most cases already know the result
>> of all intermediate CQEs, but you still need to reap and match them.
>> I'd prefer to have only 1 CQE per link, that is either for the first
>> failed or for the last request in the chain.
>>
>> These 2 may shed much processing overhead from the userspace.
> 
> I couldn't agree more!
> 
> Another problem is that io_uring_enter will be awaked for completion of
> every operation in a link, which results in unnecessary context switch.
> When awaked, users have nothing to do but issue another io_uring_enter
> syscall to wait for completion of the entire link chain.

Good point. Sounds like I have one more thing to do :)
Would the behaviour as in the (2) cover all your needs?

There is a nuisance with linked timeouts, but I think it's reasonable
for REQ->LINKED_TIMEOUT, where it didn't fired, notify only for REQ


>>
>> 3. If we generate requests by eBPF even the notion of per-request event
>> may broke.
>> - eBPF creating new requests would also need to specify user-data, and
>>  this may be problematic from the user perspective.
>> - may want to not generate CQEs automatically, but let eBPF do it.
>>
>> -- 
>> Pavel Begunkov
> 

-- 
Pavel Begunkov
