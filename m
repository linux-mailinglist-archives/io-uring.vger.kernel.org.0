Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1C576E80A6
	for <lists+io-uring@lfdr.de>; Wed, 19 Apr 2023 19:51:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232944AbjDSRvf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 19 Apr 2023 13:51:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232644AbjDSRve (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 19 Apr 2023 13:51:34 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDC0F421C
        for <io-uring@vger.kernel.org>; Wed, 19 Apr 2023 10:51:31 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id d2e1a72fcca58-63d32d21f95so29839b3a.1
        for <io-uring@vger.kernel.org>; Wed, 19 Apr 2023 10:51:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1681926691; x=1684518691;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7/q8cJ9Qt44yJA/0rDh4+g7HN0YJHtvTInO2OuaJ3mY=;
        b=cwoFJPgT7nwOViKlcuQPukO04ZVRLClIdjlVxCmC4pnAsImARQW+z6JpQ+qrGVkWf8
         WihJ+Ulxfm+51a7Ct2tCg8pvD0hnQS5+weUCeSURGJoVOr6RLG2MioZKMGOTY2J+GC1R
         AhNxkjFGJAiqjKONJkM8dTICDVN9fMU6iohDRZaMyirsDSnp9d3ZeyNKCv3GYphCPNKo
         M/lkx1UU9qKJPKlPBPEkyys6Ghkt9PZADKPtnLx9Ao6YNYOvGbdJZDIBDB9LY4Uv00kJ
         nH+R2OOiyo6Myto0UpfgzneJsydPj7nplBuf4CsA5or/emEZgA4K4zEheQ2RjDEb97GZ
         n+sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681926691; x=1684518691;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7/q8cJ9Qt44yJA/0rDh4+g7HN0YJHtvTInO2OuaJ3mY=;
        b=YX8E6rQJpVuPzhnbin63y8ZhTH0+I/FalsbAypkC0Kx7cZ5LCHEmrzOmc8CkUwTOHk
         3eFLbJh99169QhmllveqqRbAe+IlvyLZXKMJofh/wKz6DH3WA7NjR5q6MBI0GQitDv0t
         JH46VC6lw1lagFGRfjpAC2TxdVnlq9G3UoGSjZ37ka63ntMJEGqQUSFVl/Pg6cnYGWjx
         wCVZKNNZL2n70wBhUT7ueAQfCNZQo+fWJwthzflQ0KNGRaiJdgIzUKwLytDioac8+mcx
         NNOgAwPIvZqzKszJjSeU73H66VbpOdQeLnCBH3MqDYsmRQ7GRLUr4QjGf5VMuHKvmQjR
         hkEA==
X-Gm-Message-State: AAQBX9euado5ANDo4Z9xq6xdKjYs3/B9hd5ETKTbFD0c2i8N8CnrYCpz
        hhJnl/TqttwFDkyk8zTZktVo0g==
X-Google-Smtp-Source: AKy350Y3j8tmoGCXFfV+RtZYpzzHbIgkWtMT3eW+y8zGh/LXBSEmxJrCExZ4sGYZzQm72/pMCA0SMQ==
X-Received: by 2002:a05:6a00:4ac8:b0:633:4c01:58b4 with SMTP id ds8-20020a056a004ac800b006334c0158b4mr19325177pfb.2.1681926691066;
        Wed, 19 Apr 2023 10:51:31 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id t26-20020a62ea1a000000b0063a1e7d7439sm11312135pfh.69.2023.04.19.10.51.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Apr 2023 10:51:30 -0700 (PDT)
Message-ID: <8af483d2-0d3d-5ece-fb1d-a3654411752b@kernel.dk>
Date:   Wed, 19 Apr 2023 11:51:29 -0600
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
 <69f48cc6-8fc6-0c49-5a79-6c7d248e4ad5@kernel.dk>
 <bec03e0f-a0f9-43c3-870b-be406ca848b9@lucifer.local>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <bec03e0f-a0f9-43c3-870b-be406ca848b9@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/19/23 11:47?AM, Lorenzo Stoakes wrote:
> On Wed, Apr 19, 2023 at 11:35:58AM -0600, Jens Axboe wrote:
>> On 4/19/23 11:23?AM, Lorenzo Stoakes wrote:
>>> On Wed, Apr 19, 2023 at 10:59:27AM -0600, Jens Axboe wrote:
>>>> On 4/19/23 10:35?AM, Jens Axboe wrote:
>>>>> On 4/18/23 9:49?AM, Lorenzo Stoakes wrote:
>>>>>> We are shortly to remove pin_user_pages(), and instead perform the required
>>>>>> VMA checks ourselves. In most cases there will be a single VMA so this
>>>>>> should caues no undue impact on an already slow path.
>>>>>>
>>>>>> Doing this eliminates the one instance of vmas being used by
>>>>>> pin_user_pages().
>>>>>
>>>>> First up, please don't just send single patches from a series. It's
>>>>> really annoying when you are trying to get the full picture. Just CC the
>>>>> whole series, so reviews don't have to look it up separately.
>>>>>
>>>>> So when you're doing a respin for what I'll mention below and the issue
>>>>> that David found, please don't just show us patch 4+5 of the series.
>>>>
>>>> I'll reply here too rather than keep some of this conversaion
>>>> out-of-band.
>>>>
>>>> I don't necessarily think that making io buffer registration dumber and
>>>> less efficient by needing a separate vma lookup after the fact is a huge
>>>> deal, as I would imagine most workloads register buffers at setup time
>>>> and then don't change them. But if people do switch sets at runtime,
>>>> it's not necessarily a slow path. That said, I suspect the other bits
>>>> that we do in here, like the GUP, is going to dominate the overhead
>>>> anyway.
>>>
>>> Thanks, and indeed I expect the GUP will dominate.
>>
>> Unless you have a lot of vmas... Point is, it's _probably_ not a
>> problem, but it might and it's making things worse for no real gain as
>> far as I can tell outside of some notion of "cleaning up the code".
>>
>>>> My main question is, why don't we just have a __pin_user_pages or
>>>> something helper that still takes the vmas argument, and drop it from
>>>> pin_user_pages() only? That'd still allow the cleanup of the other users
>>>> that don't care about the vma at all, while retaining the bundled
>>>> functionality for the case/cases that do? That would avoid needing
>>>> explicit vma iteration in io_uring.
>>>>
>>>
>>> The desire here is to completely eliminate vmas as an externally available
>>> parameter from GUP. While we do have a newly introduced helper that returns
>>> a VMA, doing the lookup manually for all other vma cases (which look up a
>>> single page and vma), that is more so a helper that sits outside of GUP.
>>>
>>> Having a separate function that still bundled the vmas would essentially
>>> undermine the purpose of the series altogether which is not just to clean
>>> up some NULL's but rather to eliminate vmas as part of the GUP interface
>>> altogether.
>>>
>>> The reason for this is that by doing so we simplify the GUP interface,
>>> eliminate a whole class of possible future bugs with people holding onto
>>> pointers to vmas which may dangle and lead the way to future changes in GUP
>>> which might be more impactful, such as trying to find means to use the fast
>>> paths in more areas with an eye to gradual eradication of the use of
>>> mmap_lock.
>>>
>>> While we return VMAs, none of this is possible and it also makes the
>>> interface more confusing - without vmas GUP takes flags which define its
>>> behaviour and in most cases returns page objects. The odd rules about what
>>> can and cannot return vmas under what circumstances are not helpful for new
>>> users.
>>>
>>> Another point here is that Jason suggested adding a new
>>> FOLL_ALLOW_BROKEN_FILE_MAPPINGS flag which would, by default, not be
>>> set. This could assert that only shmem/hugetlb file mappings are permitted
>>> which would eliminate the need for you to perform this check at all.
>>>
>>> This leads into the larger point that GUP-writing file mappings is
>>> fundamentally broken due to e.g. GUP not honouring write notify so this
>>> check should at least in theory not be necessary.
>>>
>>> So it may be the case that should such a flag be added this code will
>>> simply be deleted at a future point :)
>>
>> Why don't we do that first then? There's nothing more permanent than a
>> temporary workaround/fix. Once it's in there, motivation to get rid of
>> it for most people is zero because they just never see it. Seems like
>> that'd be a much saner approach rather than the other way around, and
>> make this patchset simpler/cleaner too as it'd only be removing code in
>> all of the callers.
>>
> 
> Because I'd then need to audit all GUP callers to see whether they in some
> way brokenly access files in order to know which should and should not use
> this new flag. It'd change this series from 'remove the vmas parameter' to
> something a lot more involved.
> 
> I think it's much safer to do the two separately, as I feel that change
> would need quite a bit of scrutiny too.
> 
> As for temporary, I can assure you I will be looking at introducing this
> flag, for what it's worth :) and Jason is certainly minded to do work in
> this area also.

It's either feasible or it's not, and it didn't sound too bad in terms
of getting it done to remove the temporary addition. Since we're now
days away from the merge window and any of this would need to soak in
for-next anyway for a bit, why not just do that other series first? It
really is backward. And this happens sometimes when developing
patchsets, at some point you realize that things would be easier/cleaner
with another prep series first. Nothing wrong with that, but let's not
be hesitant to shift direction a bit when it makes sense to do so.

I keep getting this sense of urgency for a cleanup series. Why not just
do it right from the get-go and make this series simpler? At that point
there would be no discussion on it at all, as it would be a straight
forward cleanup without adding an intermediate step that'd get deleted
later anyway.

-- 
Jens Axboe

