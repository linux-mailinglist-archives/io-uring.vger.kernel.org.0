Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D47C036DAC2
	for <lists+io-uring@lfdr.de>; Wed, 28 Apr 2021 17:06:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234353AbhD1PCJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 28 Apr 2021 11:02:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235511AbhD1PBm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 28 Apr 2021 11:01:42 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B95D9C0612A3
        for <io-uring@vger.kernel.org>; Wed, 28 Apr 2021 07:56:41 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id q9so9245507wrs.6
        for <io-uring@vger.kernel.org>; Wed, 28 Apr 2021 07:56:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LIjG1GjO5XO2MJV3Pv5x70tJzrUwAkiK4DHOEOI7g6Y=;
        b=YEhuBizmoaMNvK9dq4Q+h/qtWEvYh3Bq3QIPujpfesJbifGBz06XRh+WiHeTxafoyQ
         kdgOwFUabfArdjrO57iR8nnMwwpL6h8j6XnA5WSTGgSzEVXihNIkLhlkJVm37PTF9fv+
         OROCM/E8ZzU5JbLH2BFoIHZge0gb05aYBCq4kIX267UZsx1cA0Rn8HtZ1dloRXVdcDDZ
         KI3g0LKm6Xzafde38NK+lrwg/BC4iNNjS03hnTa5jsxd9NcmVFnmv3tnz+rTZj+ZzdQz
         1PvcMREbqFawz8mHfyISnmdb3r/p4VcqS7sF2hawndHzwp4ylC9EyA0Bd85SxCCtk73w
         G8cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LIjG1GjO5XO2MJV3Pv5x70tJzrUwAkiK4DHOEOI7g6Y=;
        b=rO/S5XklznJPW0l4sPvxnL06t5xxCXiQ2yTT9keTFcW8+ZiW22zbFuU5nwvyTloD/2
         eqwNJ2wvwHQSZ1qh2UxoG4sPWZOo2cKNhGMj/7VqB+j+BRa+1DMtGyih6sU7EhLrSZaO
         nJ6MqzDs3+pH8JHxbbnX0QDAgcLRNE3GPKcaXimeiTMfB0fvD+D5L1Vsmp11WzqObb4b
         WeeH46Y2/J3baxEVXVb53lxIUs9uRdzIJtg3Nv68BRCM/6rpyhf1EpGq9xqydQw2Pn5q
         loS+XM7gNS3QITUajohUsXnt0uq6+26OEBFjQkKXYkS4qnMfoKbXKJhjxhp/W4rHuDXl
         n8HQ==
X-Gm-Message-State: AOAM533NoE3EYiQRxfuIQlAkhXUHmI8RKxT39IEnK/DME5VQlh8S03sn
        GWHR6JAPSYDjxKDIg1SFv7w=
X-Google-Smtp-Source: ABdhPJyg+EfLB02ogqA/3z+Bf6zVJUPw0wuH4fZQQcVZnNjzkYdzMKOEFp9jT5+fWlRi1YtwNd/p6A==
X-Received: by 2002:a5d:5745:: with SMTP id q5mr24162070wrw.250.1619621800520;
        Wed, 28 Apr 2021 07:56:40 -0700 (PDT)
Received: from [192.168.8.197] ([185.69.145.35])
        by smtp.gmail.com with ESMTPSA id h63sm4213860wmh.13.2021.04.28.07.56.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Apr 2021 07:56:40 -0700 (PDT)
Subject: Re: [PATCH RFC 5.13 2/2] io_uring: submit sqes in the original
 context when waking up sqthread
To:     Jens Axboe <axboe@kernel.dk>, Hao Xu <haoxu@linux.alibaba.com>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <1619616748-17149-1-git-send-email-haoxu@linux.alibaba.com>
 <1619616748-17149-3-git-send-email-haoxu@linux.alibaba.com>
 <571b5633-3286-feba-af6b-e388f52fc89b@gmail.com>
 <d8316547-311d-7995-7faa-4008d577c74c@kernel.dk>
 <093a196a-1925-4f0d-aa2f-0cc1d46484c8@gmail.com>
 <ae723745-ed9b-1de3-e8fc-b4f6e320f17a@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <f13139f3-37ef-e86f-5225-b49a03decbef@gmail.com>
Date:   Wed, 28 Apr 2021 15:56:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <ae723745-ed9b-1de3-e8fc-b4f6e320f17a@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/28/21 3:53 PM, Jens Axboe wrote:
> On 4/28/21 8:50 AM, Pavel Begunkov wrote:
>> On 4/28/21 3:39 PM, Jens Axboe wrote:
>>> On 4/28/21 8:34 AM, Pavel Begunkov wrote:
>>>> On 4/28/21 2:32 PM, Hao Xu wrote:
>>>>> sqes are submitted by sqthread when it is leveraged, which means there
>>>>> is IO latency when waking up sqthread. To wipe it out, submit limited
>>>>> number of sqes in the original task context.
>>>>> Tests result below:
>>>>
>>>> Frankly, it can be a nest of corner cases if not now then in the future,
>>>> leading to a high maintenance burden. Hence, if we consider the change,
>>>> I'd rather want to limit the userspace exposure, so it can be removed
>>>> if needed.
>>>>
>>>> A noticeable change of behaviour here, as Hao recently asked, is that
>>>> the ring can be passed to a task from a completely another thread group,
>>>> and so the feature would execute from that context, not from the
>>>> original/sqpoll one.
>>>>
>>>> Not sure IORING_ENTER_SQ_DEPUTY knob is needed, but at least can be
>>>> ignored if the previous point is addressed.
>>>
>>> I mostly agree on that. The problem I see is that for most use cases,
>>> the "submit from task itself if we need to enter the kernel" is
>>> perfectly fine, and would probably be preferable. But there are also
>>> uses cases that absolutely do not want to spend any extra cycles doing
>>> submit, they are isolating the submission to sqpoll exclusively and that
>>> is part of the win there. Based on that, I don't think it can be an
>>> automatic kind of feature.
>>
>> Reasonable. 
>>  
>>> I do think the naming is kind of horrible. IORING_ENTER_SQ_SUBMIT_IDLE
>>> would likely be better, or maybe even more verbose as
>>> IORING_ENTER_SQ_SUBMIT_ON_IDLE.
>>>
>>> On top of that, I don't think an extra submit flag is a huge deal, I
>>> don't imagine we'll end up with a ton of them. In fact, two have been
>>> added related to sqpoll since the inception, out of the 3 total added
>>> flags.
>>
>> I don't care about the flag itself, nor about performance as it's
>> nicely under the SQPOLL check, but I rather want to leave a way to
>> ignore the feature if we would (ever) need to disable it, either
>> with flag or without it.
> 
> I think we just return -EINVAL for that case, just like we'd do now if
> you attempted to use the flag as we don't grok it. As it should be
> functionally equivalent if we do the submit inline or not, we could also
> argue that we simply ignore the flag if it isn't feasible to submit
> inline.

Yeah, no-brainer if we limit context to the original thread group, as
I described in the first reply.

-- 
Pavel Begunkov
