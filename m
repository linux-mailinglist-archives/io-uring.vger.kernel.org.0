Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4622721D7FC
	for <lists+io-uring@lfdr.de>; Mon, 13 Jul 2020 16:12:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729772AbgGMOM2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Jul 2020 10:12:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729649AbgGMOM2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Jul 2020 10:12:28 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CBA6C061755
        for <io-uring@vger.kernel.org>; Mon, 13 Jul 2020 07:12:28 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id u185so6068026pfu.1
        for <io-uring@vger.kernel.org>; Mon, 13 Jul 2020 07:12:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=uPKGwmgauALsxzgBL5JB05kGw280HNgQcbwjzU4O6xo=;
        b=tFwMjLv3eBxpgGTzTvAcFDGLeH409qGxrYvqNrIQu6wtzX23vHOSh3hE3QJV1ypUNI
         ojzF+G7sf5T+Gx022Ez5Ct75uzAr1ti8osoTmzqyuGoHfKXUNQtvKDmAMWdIBVc9tOto
         P0fmTRR2/VNVNqHwp+VJ8JX/FYamYybB/kjNOFgwwkryWsGKeBseA1mhIcsqSr7uLcpy
         G/+kM7coIsfV9umWCC9zX4SfBpb65TCVGTe7FW7Yt138gO/XhTPieOnTYGOm9MhbS84d
         IZSIGMvbdrwPlg2aiDodTbquY4hP2Avwb2t54h9esXezzpYIajmNdapM7PA0h51RNviZ
         jM9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uPKGwmgauALsxzgBL5JB05kGw280HNgQcbwjzU4O6xo=;
        b=Zv1oaxXTLxCvHmnx59gnwSY3JP+7b8WS5zsmHGUQXnxEsd7T3mBj2gowk4JAZV/bBj
         O/LBOeqRLaMmnOT8SuWJpbiGTFm9eakf09zVjbPOAZzvJ5ePNgCpQEQIKa1N+VQURPig
         3tnf1hp/+tfdjrGpolfL16YYLOJbpFhuKmbZhCUUP5loHZYb4Aaw98CgOXkEi+RhCF04
         kHzRQSzMD7PvV1AubhQ4v/r8YNhUIHKnDaGKA+YAX3ExTmAAViqr5sN1fOLUO5Cx1nw4
         Ysbnel82Pp7xZLFgj/MrMYCeZb34WytxseHLvYMgfd+MEXi9AffeKtj7FrH9SBs7ucA3
         wqBA==
X-Gm-Message-State: AOAM530SkBP3PlshO0QDvWaWlzQxVklvM5qdXNoQl2P3aFiVdMYCEPDf
        nlPZ/XTtq7TAq8x1EkHMJb27k8+LccfprA==
X-Google-Smtp-Source: ABdhPJxp7FQiAjfFmZMiULR+kfBWoVKDO9mvO9eBGgpcQES3gmX8hDCNepfYI9TbY2lJ4Rfj7yqqbQ==
X-Received: by 2002:a62:e919:: with SMTP id j25mr66663pfh.123.1594649547857;
        Mon, 13 Jul 2020 07:12:27 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id x13sm8953358pfj.122.2020.07.13.07.12.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Jul 2020 07:12:27 -0700 (PDT)
Subject: Re: [RFC 0/9] scrap 24 bytes from io_kiocb
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1594546078.git.asml.silence@gmail.com>
 <edfa9852-695d-d122-91f8-66a888b482c0@kernel.dk>
 <618bc9a5-420c-b176-df86-260734270f56@gmail.com>
 <3b3ee104-ee6b-7147-0677-bd0eb4efe76e@kernel.dk>
 <7368254d-1f2c-2cc9-1198-8a666f7f8864@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <e1e53293-c57a-6c65-0e88-eb4414783f05@kernel.dk>
Date:   Mon, 13 Jul 2020 08:12:26 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <7368254d-1f2c-2cc9-1198-8a666f7f8864@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/13/20 2:17 AM, Pavel Begunkov wrote:
> On 12/07/2020 23:32, Jens Axboe wrote:
>> On 7/12/20 11:34 AM, Pavel Begunkov wrote:
>>> On 12/07/2020 18:59, Jens Axboe wrote:
>>>> On 7/12/20 3:41 AM, Pavel Begunkov wrote:
>>>>> Make io_kiocb slimmer by 24 bytes mainly by revising lists usage. The
>>>>> drawback is adding extra kmalloc in draining path, but that's a slow
>>>>> path, so meh. It also frees some space for the deferred completion path
>>>>> if would be needed in the future, but the main idea here is to shrink it
>>>>> to 3 cachelines in the end.
>>>>>
>>>>> I'm not happy yet with a few details, so that's not final, but it would
>>>>> be lovely to hear some feedback.
>>>>
>>>> I think it looks pretty good, most of the changes are straight forward.
>>>> Adding a completion entry that shares the submit space is a good idea,
>>>> and really helps bring it together.
>>>>
>>>> From a quick look, the only part I'm not super crazy about is patch #3.
>>>
>>> Thanks!
>>>
>>>> I'd probably rather use a generic list name and not unionize the tw
>>>> lists.
>>>
>>> I don't care much, but without compiler's help always have troubles
>>> finding and distinguishing something as generic as "list".
>>
>> To me, it's easier to verify that we're doing the right thing when they
>> use the same list member. Otherwise you have to cross reference two
>> different names, easier to shoot yourself in the foot that way. So I'd
>> prefer just retaining it as 'list' or something generic.
> 
> If you don't have objections, I'll just leave it "inflight_entry". This
> one is easy to grep.

Sure, don't have strong feelings on the actual name.

>>> BTW, I thought out how to bring it down to 3 cache lines, but that would
>>> require taking io_wq_work out of io_kiocb and kmalloc'ing it on demand.
>>> And there should also be a bunch of nice side effects like improving apoll.
>>
>> How would this work with the current use of io_wq_work as storage for
>> whatever bits we're hanging on to? I guess it could work with a prep
>> series first more cleanly separating it, though I do feel like we've
>> been getting closer to that already.
> 
> It's definitely not a single patch. I'm going to prepare a series for
> discussion later, and then we'll see whether it worth it.

Definitely not. Let's flesh this one out first, then we can move on.

-- 
Jens Axboe

