Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 592231DB7FB
	for <lists+io-uring@lfdr.de>; Wed, 20 May 2020 17:21:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726443AbgETPVW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 20 May 2020 11:21:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726436AbgETPVV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 20 May 2020 11:21:21 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82040C061A0E
        for <io-uring@vger.kernel.org>; Wed, 20 May 2020 08:21:21 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id cx22so1444310pjb.1
        for <io-uring@vger.kernel.org>; Wed, 20 May 2020 08:21:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=89tmmmXLegLQteCtRqKtlbtBAadU0X9hfP3mM1b9LsE=;
        b=aznRGJJMvObfBr5LSM9wNvnZ7yEhA3tKLmrdn5ngQsX2ZaqbNViDNEQYA7B+f7dwSO
         4MZz0IBysisSz+flMyetzfWZ3besR5PCVJd+YrDlnhPX8jG+BSy5ri8bW+LKej1IRW8e
         2yNdN4onx7roN6o7aysfgjdln2jFRFEYVvxMfYgvlvgVf5yyA7U6j+mkWpCKFUyat0Yr
         BsHK13Ck92uC8BgKxncioEwniWIun60CxUsELvd1woKK1dRMrsi7bKJiw09cydM1I7B+
         ZziavqzqID4+duDak9WlaRd9EN9V9QWBRraQyC0ts08Gft2wyimMWTuxR9CIyHVPNowT
         +u9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=89tmmmXLegLQteCtRqKtlbtBAadU0X9hfP3mM1b9LsE=;
        b=elsc30AtF1+IoQblpbBlOnxtkyCYD9eRaM+GJB4clhCN4WULKK7K/Av/Q0q8KBn75O
         vGlMXKfrDQXUaCYCYuV+f+Z5tvBHRUUo3jZ9b6ZOh7yDEE+fPqDtI3Q6uu8pFo4mfyVe
         Ju4JgpIY6Wlxz1s1XyZ1Ad1OUM3/QgOv/B94S79ZLutqq0gVwYu11fvKr8lNADalISvx
         yxwid6ulwqywJY1FCR0/kx117SmyATXV+nJrUK7wWFPBBamxVikukmaz+FD4QeOVAyIc
         TGNDiZ9rPpfxrxMlhaO0sXFP5VQRtQ5Jsi6IXnG6gInrpOkLu1DHv6LQwCGTZPbFHGbn
         eQZQ==
X-Gm-Message-State: AOAM530TxHJQmJJrk/g8jgyTdOD9hPruDIPXms9taPQYpPDNq3nYrzyt
        auuxg3Oy0Nu8xuN/Mg1Cl8IokvRQH4w=
X-Google-Smtp-Source: ABdhPJwYznCqSPVLuRhZow2zkoQmx9Jytl5c1MtV6bpK3j475SIO9Fmnukgyh8xC8h41QO0yAYbNrA==
X-Received: by 2002:a17:902:d90c:: with SMTP id c12mr4945778plz.113.1589988080536;
        Wed, 20 May 2020 08:21:20 -0700 (PDT)
Received: from [192.168.86.156] (cpe-75-85-219-51.dc.res.rr.com. [75.85.219.51])
        by smtp.gmail.com with ESMTPSA id f66sm2470085pfg.174.2020.05.20.08.21.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 May 2020 08:21:19 -0700 (PDT)
Subject: Re: [PATCH liburing 3/5] Add helpers to set and get eventfd
 notification status
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     io-uring@vger.kernel.org
References: <20200515164331.236868-1-sgarzare@redhat.com>
 <20200515164331.236868-4-sgarzare@redhat.com>
 <5bee86d5-f8bf-5b61-dd26-5e7d0448a217@kernel.dk>
 <20200515171111.zwgblergup6a23p2@steredhat>
 <20200520131221.rktn7dy42e633rvg@steredhat>
 <dc504f4a-6fbf-114a-086a-f6392baac84e@kernel.dk>
 <20200520151143.22n3jkv2byfhioqj@steredhat>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <24944ac7-e9c5-be43-cad7-4f31b644eebd@kernel.dk>
Date:   Wed, 20 May 2020 09:19:05 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200520151143.22n3jkv2byfhioqj@steredhat>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/20/20 9:11 AM, Stefano Garzarella wrote:
> On Wed, May 20, 2020 at 07:43:43AM -0600, Jens Axboe wrote:
>> On 5/20/20 7:12 AM, Stefano Garzarella wrote:
>>>>> The bigger question is probably how to handle kernels that don't
>>>>> have this feature. It'll succeed, but we'll still post events. Maybe
>>>>> the kernel side should have a feature flag that we can test?
>>>>
>>>> I thought about that, and initially I added a
>>>> IORING_FEAT_EVENTFD_DISABLE, but then I realized that we are adding
>>>> the CQ 'flags' field together with the eventfd disabling feature.
>>>>
>>>> So I supposed that if 'p->cq_off.flags' is not zero, than the kernel
>>>> supports CQ flags and also the IORING_CQ_EVENTFD_DISABLED bit.
>>>>
>>>> Do you think that's okay, or should we add IORING_FEAT_EVENTFD_DISABLE
>>>> (or something similar)?
>>>
>>> Hi Jens,
>>> I'm changing io_uring_cq_eventfd_enable() to io_uring_cq_eventfd_toggle().
>>
>> Sounds good.
>>
>>> Any advice on the error and eventual feature flag?
>>
>> I guess we can use cq_off.flags != 0 to tell if we have this feature or
>> not, even though it's a bit quirky. But at the same time, probably not
>> worth adding a specific feature flag for.
> 
> Agree.
> 
>>
>> For the error, -EOPNOTSUPP seems fine if we don't have the feature. Just
>> don't flag errors for enabling when already enabled, or vice versa. It's
> 
> Okay.
> 
>> inherently racy in that completions can come in while the app is calling
>> the helper, so we should make the interface relaxed.
> 
> Yes, do you think we should also provide an interface to do double
> check while re-enabling notifications?
> Or we can leave this to the application?
> 
> I mean something like this:
> 
>     bool io_uring_cq_eventfd_safe_enable(struct io_uring *ring)
>     {
>         /* enable notifications */
>         io_uring_cq_eventfd_toggle(ring, true);
> 
>         /* Do we have any more cqe in the ring? */
>         if (io_uring_cq_ready(ring)) {
>             io_uring_cq_eventfd_toggle(ring, false);
>             return false;
>         }
> 
>         return true;
>     }

Let's just leave it for now unless/until there's a clear need for
something like that.

-- 
Jens Axboe

