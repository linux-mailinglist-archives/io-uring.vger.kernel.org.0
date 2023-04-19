Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3822B6E8079
	for <lists+io-uring@lfdr.de>; Wed, 19 Apr 2023 19:36:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231580AbjDSRgD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 19 Apr 2023 13:36:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229991AbjDSRgB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 19 Apr 2023 13:36:01 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C4C06E85
        for <io-uring@vger.kernel.org>; Wed, 19 Apr 2023 10:36:00 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id d2e1a72fcca58-63b78525ac5so32540b3a.0
        for <io-uring@vger.kernel.org>; Wed, 19 Apr 2023 10:36:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1681925760; x=1684517760;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lmO38VAM37rREvey7UoSOou6N388un70Vf6aBhszREY=;
        b=z/iFo4N29sXIdiv1sY4QI9CNza3JqdfEZW150D4CJIyqs1ftdbuyC35lNkAkp8OIHw
         FNH/iNpv40tp9PaqWqjijJTveL3b5HpsywAKFu+NXKt/C8ueBJnMRfskUMFxudaPVNIp
         kCIkoO8IWDzaXtbHl9fycm6UjiCF7sVT5BJ5r9GYti6tjakHnx2OfmLJyt7gXEmbtohV
         ySDWqn/WS98cIV+84UiYqFj9Rj5GDlNaOafgCPKp5H4qsl/dug8Vwen37K5r4XpdX4q/
         ors2vzE7K+LQzdnH59H3Hk42tcHrIqRSJVQ9NBXcEKzTcsvJKl1bGe9AEY/IN1eVMPQ1
         CnbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681925760; x=1684517760;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lmO38VAM37rREvey7UoSOou6N388un70Vf6aBhszREY=;
        b=XZTizyh3AbEvT4JZ5SfvY5tihTXby5q0jmEDVPzfpjcohgjFnv/Yw+5zJEOz4n/a0Z
         svjIf0hnf1cbrxOYXiDJnc/YABYRBGzUd40uSL1OLGESmcQdSybV1K38gqkRS3X+hRfF
         TZe5RydPGk3+ldA6ebl9fQbayf0ZtsasPNyEGfGxwzDFVR8aw276oK2fnHJ64xIzFauj
         wVWvhV75RikLuACDUgJ9aBrv5ZhxyCPYpgOFG/dX+U6XqtQQ/01e27/MBLOGppVusxdh
         m/92zAtujBtJxNr7CvAU43OXcm4vmphqwAStiXj6suzHMstCJBuWId8zsdcfOVariipi
         uc7Q==
X-Gm-Message-State: AAQBX9frI0H2IZMY1do0+qpJL03bjOEKQkQZssr51OtmcvP5Z8CvbsoY
        Au3VuA8gJJ4cndQAxnf07imHtg==
X-Google-Smtp-Source: AKy350azjREW+qIem/g1t7Qyf3FDL/wCTe61ppZquIOiZUWzxLxOfqTXaZiTcn3AdljAFh3tJFhQQw==
X-Received: by 2002:a17:902:dad1:b0:1a1:956d:2281 with SMTP id q17-20020a170902dad100b001a1956d2281mr22828705plx.3.1681925759947;
        Wed, 19 Apr 2023 10:35:59 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id jf7-20020a170903268700b001a2135e7eabsm11700385plb.16.2023.04.19.10.35.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Apr 2023 10:35:59 -0700 (PDT)
Message-ID: <69f48cc6-8fc6-0c49-5a79-6c7d248e4ad5@kernel.dk>
Date:   Wed, 19 Apr 2023 11:35:58 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH v4 4/6] io_uring: rsrc: avoid use of vmas parameter in
 pin_user_pages()
Content-Language: en-US
To:     Lorenzo Stoakes <lstoakes@gmail.com>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>,
        David Hildenbrand <david@redhat.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>
References: <cover.1681831798.git.lstoakes@gmail.com>
 <956f4fc2204f23e4c00e9602ded80cb4e7b5df9b.1681831798.git.lstoakes@gmail.com>
 <936e8f52-00be-6721-cb3e-42338f2ecc2f@kernel.dk>
 <c2e22383-43ee-5cf0-9dc7-7cd05d01ecfb@kernel.dk>
 <f82b9025-a586-44c7-9941-8140c04a4ccc@lucifer.local>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <f82b9025-a586-44c7-9941-8140c04a4ccc@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/19/23 11:23?AM, Lorenzo Stoakes wrote:
> On Wed, Apr 19, 2023 at 10:59:27AM -0600, Jens Axboe wrote:
>> On 4/19/23 10:35?AM, Jens Axboe wrote:
>>> On 4/18/23 9:49?AM, Lorenzo Stoakes wrote:
>>>> We are shortly to remove pin_user_pages(), and instead perform the required
>>>> VMA checks ourselves. In most cases there will be a single VMA so this
>>>> should caues no undue impact on an already slow path.
>>>>
>>>> Doing this eliminates the one instance of vmas being used by
>>>> pin_user_pages().
>>>
>>> First up, please don't just send single patches from a series. It's
>>> really annoying when you are trying to get the full picture. Just CC the
>>> whole series, so reviews don't have to look it up separately.
>>>
>>> So when you're doing a respin for what I'll mention below and the issue
>>> that David found, please don't just show us patch 4+5 of the series.
>>
>> I'll reply here too rather than keep some of this conversaion
>> out-of-band.
>>
>> I don't necessarily think that making io buffer registration dumber and
>> less efficient by needing a separate vma lookup after the fact is a huge
>> deal, as I would imagine most workloads register buffers at setup time
>> and then don't change them. But if people do switch sets at runtime,
>> it's not necessarily a slow path. That said, I suspect the other bits
>> that we do in here, like the GUP, is going to dominate the overhead
>> anyway.
> 
> Thanks, and indeed I expect the GUP will dominate.

Unless you have a lot of vmas... Point is, it's _probably_ not a
problem, but it might and it's making things worse for no real gain as
far as I can tell outside of some notion of "cleaning up the code".

>> My main question is, why don't we just have a __pin_user_pages or
>> something helper that still takes the vmas argument, and drop it from
>> pin_user_pages() only? That'd still allow the cleanup of the other users
>> that don't care about the vma at all, while retaining the bundled
>> functionality for the case/cases that do? That would avoid needing
>> explicit vma iteration in io_uring.
>>
> 
> The desire here is to completely eliminate vmas as an externally available
> parameter from GUP. While we do have a newly introduced helper that returns
> a VMA, doing the lookup manually for all other vma cases (which look up a
> single page and vma), that is more so a helper that sits outside of GUP.
> 
> Having a separate function that still bundled the vmas would essentially
> undermine the purpose of the series altogether which is not just to clean
> up some NULL's but rather to eliminate vmas as part of the GUP interface
> altogether.
> 
> The reason for this is that by doing so we simplify the GUP interface,
> eliminate a whole class of possible future bugs with people holding onto
> pointers to vmas which may dangle and lead the way to future changes in GUP
> which might be more impactful, such as trying to find means to use the fast
> paths in more areas with an eye to gradual eradication of the use of
> mmap_lock.
> 
> While we return VMAs, none of this is possible and it also makes the
> interface more confusing - without vmas GUP takes flags which define its
> behaviour and in most cases returns page objects. The odd rules about what
> can and cannot return vmas under what circumstances are not helpful for new
> users.
> 
> Another point here is that Jason suggested adding a new
> FOLL_ALLOW_BROKEN_FILE_MAPPINGS flag which would, by default, not be
> set. This could assert that only shmem/hugetlb file mappings are permitted
> which would eliminate the need for you to perform this check at all.
> 
> This leads into the larger point that GUP-writing file mappings is
> fundamentally broken due to e.g. GUP not honouring write notify so this
> check should at least in theory not be necessary.
> 
> So it may be the case that should such a flag be added this code will
> simply be deleted at a future point :)

Why don't we do that first then? There's nothing more permanent than a
temporary workaround/fix. Once it's in there, motivation to get rid of
it for most people is zero because they just never see it. Seems like
that'd be a much saner approach rather than the other way around, and
make this patchset simpler/cleaner too as it'd only be removing code in
all of the callers.

-- 
Jens Axboe

