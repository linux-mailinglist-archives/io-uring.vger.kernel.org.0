Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FEA222D99C
	for <lists+io-uring@lfdr.de>; Sat, 25 Jul 2020 21:41:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727912AbgGYTlD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 25 Jul 2020 15:41:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726681AbgGYTlD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 25 Jul 2020 15:41:03 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 661FEC08C5C0
        for <io-uring@vger.kernel.org>; Sat, 25 Jul 2020 12:41:02 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id t15so7192650pjq.5
        for <io-uring@vger.kernel.org>; Sat, 25 Jul 2020 12:41:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=M0+rsqNFiXByqy8E9wZiLEvnGAyW/FTWcoV9u27R4Xw=;
        b=UTIMpcP0dLACHoAI8pp0a3RBhFXCzf9b9nPp6448snwLu+cDCnCmp+/Nuq3JZWsS7Q
         eQxtvl2lDC1IdNKcTyu1JlPw/dpAXusoYRPYpntwI3Lzr/iPMhjmvjLtNuyFMi58i83h
         zCFf0FninfVdNBIJKGeSsQ6ZBJYz62ly+DWKElxktDIWd2787ufegOuQ71rsx+mMfHsG
         fIQU2/I5jej6YAzKS7K1rdmklqWXqU+QCpPw0dcOK0/ntMiFtRi3YeWk5qeWtGc2wESm
         5lTqCqnGqcxKwLJVWrGoQCRoaCsAbon9IdXNV4i7Y2t5AFhgJX6R6Wuv9hsl9swm8Wkq
         27vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=M0+rsqNFiXByqy8E9wZiLEvnGAyW/FTWcoV9u27R4Xw=;
        b=OwneoFyDPzw7IaI2UHeDC7TQmdgr8BSfOw/OnJz4mqgAAmYSoQlVLrmVX7z/+/Jbp+
         /circjHOedmnDwL6OKCZ5vRIRRVHEczlkby9SMPRlRaW+9UwUnLpH3bFD+I0yVIr5W9E
         Ef+fQWqYSUcFMroZnWI6CkS9fLqTqeIpZwvxkCe10eMyATpSGlB/UvrPmpSxBUNyvirT
         CpEvcNGFUNvyNCIb+apSHr6jyo7X/eYVZYtlnAtSNl8pJ8yWB1n2lWgBUPqcOsbMt+Fm
         MO0K/FzE2ZectlTU2lRYb7Fv86aq3wbZHvow2befykvjaxQsXUbIT4fqOPhxvui98Z7v
         rb1w==
X-Gm-Message-State: AOAM5327arBTBbBz0Sro292oroECljFt49mhGvCHy/I7G2ywFdQ8XDD3
        FligKKBjtzVLAXT9XTYt/Qo5bou4xAU=
X-Google-Smtp-Source: ABdhPJzlFtCjo7AQ9AqeSZu9TFNasCukWU10lMPe/aRX1pOomOEsbOGGLiG4IEMMZXfXyM1NpTWJKw==
X-Received: by 2002:a17:90a:1d46:: with SMTP id u6mr10522139pju.220.1595706061148;
        Sat, 25 Jul 2020 12:41:01 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id y19sm9484574pgj.35.2020.07.25.12.41.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Jul 2020 12:41:00 -0700 (PDT)
Subject: Re: [RFC 0/2] 3 cacheline io_kiocb
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1595664743.git.asml.silence@gmail.com>
 <467e93fb-876d-e2a5-7596-4b9e21317d67@kernel.dk>
 <faf48a78-4327-50e6-083a-f5c762f66e8a@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <b0ca655f-96ed-a249-6371-bea409b1f065@kernel.dk>
Date:   Sat, 25 Jul 2020 13:40:59 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <faf48a78-4327-50e6-083a-f5c762f66e8a@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/25/20 12:24 PM, Pavel Begunkov wrote:
> On 25/07/2020 18:45, Jens Axboe wrote:
>> On 7/25/20 2:31 AM, Pavel Begunkov wrote:
>>> That's not final for a several reasons, but good enough for discussion.
>>> That brings io_kiocb down to 192B. I didn't try to benchmark it
>>> properly, but quick nop test gave +5% throughput increase.
>>> 7531 vs 7910 KIOPS with fio/t/io_uring
>>>
>>> The whole situation is obviously a bunch of tradeoffs. For instance,
>>> instead of shrinking it, we can inline apoll to speed apoll path.
>>>
>>> [2/2] just for a reference, I'm thinking about other ways to shrink it.
>>> e.g. ->link_list can be a single-linked list with linked tiemouts
>>> storing a back-reference. This can turn out to be better, because
>>> that would move ->fixed_file_refs to the 2nd cacheline, so we won't
>>> ever touch 3rd cacheline in the submission path.
>>> Any other ideas?
>>
>> Nothing noticeable for me, still about the same performance. But
>> generally speaking, I don't necessarily think we need to go all in on
>> making this as tiny as possible. It's much more important to chase the
>> items where we only use 2 cachelines for the hot path, and then we have
>> the extra space in there already for the semi hot paths like poll driven
>> retry. Yes, we're still allocating from a pool that has slightly larger
>> objects, but that doesn't really matter _that_ much. Avoiding an extra
>> kmalloc+kfree for the semi hot paths are a bigger deal than making
>> io_kiocb smaller and smaller.
>>
>> That said, for no-brainer changes, we absolutely should make it smaller.
>> I just don't want to jump through convoluted hoops to get there.
> 
> Agree, but that's not the end goal. The first point is to kill the union,
> but it already has enough space for that.

Right

> The second is to see, whether we can use the space in a better way. From
> the high level perspective ->apoll and ->work are alike and both serve to
> provide asynchronous paths, hence the idea to swap them naturally comes to
> mind.

Totally agree, which is why the union of those kind of makes sense.
We're definitely NOT using them at the same time, but the fact that we
had various mm/creds/whatnot in the work_struct made that a bit iffy.

> TBH, I don't think it'd do much, because init of ->io would probably
> hide any benefit.

There should be no ->io init/alloc for this test case.

-- 
Jens Axboe

