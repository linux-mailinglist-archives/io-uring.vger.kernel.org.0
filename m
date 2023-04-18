Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE5D76E6AE0
	for <lists+io-uring@lfdr.de>; Tue, 18 Apr 2023 19:26:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232284AbjDRR00 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 18 Apr 2023 13:26:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232137AbjDRR0X (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 18 Apr 2023 13:26:23 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 922A8A26B;
        Tue, 18 Apr 2023 10:26:15 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id kt6so36997718ejb.0;
        Tue, 18 Apr 2023 10:26:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681838774; x=1684430774;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aaiw7V8k8wH9z4JrB/y3wNpwn08pUbQDV+4iNNk5WrU=;
        b=slO5u1I33nFyQxFlfCgyBo+J74Re+1J1463nwzWYqPkwrbiXf9UfUSSgyj+q9o4y/u
         TczsfqbyYkGfjNy5NJzxcL2leWPyOR5ExvWJzRSJCLHVD7yG0ybCdTz/yvpDJWwixRTV
         1DZ39d50cjclVvrcehqYr4bTd2UmhmBTj4UqRFlh1UmK0dyDCoDpHO+Ff2aD/vz4YquI
         YyBQv5afqPuxYwN/YZu9CD2keQnWpmwEAU5+uZ8gTuH5hQdr+iAWxNAOPVSzQD9N95hi
         rUVukbFdSdorBanuJ6PZZB7FKP1aPSnSf8oP3bxw59WLMFDvZzGoFbwSgvUMbpm+J1Qc
         tudA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681838774; x=1684430774;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aaiw7V8k8wH9z4JrB/y3wNpwn08pUbQDV+4iNNk5WrU=;
        b=HsOtqN+XLb+5h6Zg74x9+g2Z4wfOUGGGyPC4zxkeTRvnsyRynqp2p7HgSyGZ6kaqdA
         boxUIEtAYXqBOFGjxguVFKZy/mwpemOVUhkuNGlYrJPMjMIF1Oc7/jJSFAcMTz+5zVeP
         tT1fUdGJWIySYpYtzGuDO/QBGOJa/oXt+23xlnAey18u6SGD3/w/+zLZqbwS9GWCuPwZ
         0hNIr8wOimYfrBASe6v7EZhFl++UeRrudACXlliFPoTnffwgPE0ZtW4En2e+wuYySQoF
         Ru7gWHlapdymhFKb0UZiy0X3ISVUn90FkYnMHZ94MJ8NYKU5g3bO8RVpsO9aR2kVtW6x
         vJYw==
X-Gm-Message-State: AAQBX9dmzITAzZakUFFt/A51NeJ7+MI+h9LnmcmCyMNuC815jPUo4gbW
        YREPKps5Qsn9fxF4zPSlX0I=
X-Google-Smtp-Source: AKy350ZUpa9TcFQ41rMxn9IQ2/E64zbqR+REpUN9wbwr+bM2ZrAMz2N9JQIk5BFk7IQBm04QEsifSQ==
X-Received: by 2002:a17:906:35d4:b0:94e:c317:2ff0 with SMTP id p20-20020a17090635d400b0094ec3172ff0mr11550407ejb.33.1681838773901;
        Tue, 18 Apr 2023 10:26:13 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::26ef? ([2620:10d:c092:600::2:5697])
        by smtp.gmail.com with ESMTPSA id gs8-20020a1709072d0800b0094f694e4ecbsm3667417ejc.146.2023.04.18.10.26.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Apr 2023 10:26:13 -0700 (PDT)
Message-ID: <61ded378-51a8-1dcb-b631-fda1903248a9@gmail.com>
Date:   Tue, 18 Apr 2023 18:25:24 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 5/7] io_uring: rsrc: use FOLL_SAME_FILE on
 pin_user_pages()
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Lorenzo Stoakes <lstoakes@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>,
        David Hildenbrand <david@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1681508038.git.lstoakes@gmail.com>
 <17357dec04b32593b71e4fdf3c30a346020acf98.1681508038.git.lstoakes@gmail.com>
 <ZD1CAvXee5E5456e@nvidia.com>
 <c19b3651-624b-f60e-3e63-fe9fadc6981f@gmail.com>
 <ZD7HGbdBt1XqIDX/@nvidia.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <ZD7HGbdBt1XqIDX/@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/18/23 17:36, Jason Gunthorpe wrote:
> On Tue, Apr 18, 2023 at 05:25:08PM +0100, Pavel Begunkov wrote:
>> On 4/17/23 13:56, Jason Gunthorpe wrote:
>>> On Sat, Apr 15, 2023 at 12:27:45AM +0100, Lorenzo Stoakes wrote:
>>>> Commit edd478269640 ("io_uring/rsrc: disallow multi-source reg buffers")
>>>> prevents io_pin_pages() from pinning pages spanning multiple VMAs with
>>>> permitted characteristics (anon/huge), requiring that all VMAs share the
>>>> same vm_file.
>>>
>>> That commmit doesn't really explain why io_uring is doing such a weird
>>> thing.
>>>
>>> What exactly is the problem with mixing struct pages from different
>>> files and why of all the GUP users does only io_uring need to care
>>> about this?
>>
>> Simply because it doesn't seem sane to mix and register buffers of
>> different "nature" as one.
> 
> That is not a good reason. Once things are converted to struct pages
> they don't need to care about their "nature"

Arguing purely about uapi, I do think it is. Even though it can be
passed down and a page is a page, Frankenstein's Monster mixing anon
pages, pages for io_uring queues, device shared memory, and what not
else doesn't seem right for uapi. I see keeping buffers as a single
entity in opposite to a set of random pages beneficial for the future.

And again, as for how it's internally done, I don't have any preference
whatsoever.

>> problem. We've been asked just recently to allow registering bufs
>> provided mapped by some specific driver, or there might be DMA mapped
>> memory in the future.
> 
> We already have GUP flags to deal with it, eg FOLL_PCI_P2PDMA
> 
>> Rejecting based on vmas might be too conservative, I agree and am all
>> for if someone can help to make it right.
> 
> It is GUP's problem to deal with this, not the callers.

Ok, that's even better for io_uring if the same can be achieved
just by passing flags.


> GUP is defined to return a list of normal CPU DRAM in struct page
> format. The caller doesn't care where or what this memory is, it is
> all interchangable - by API contract of GUP itself.
> 
> If you use FOLL_PCI_P2PDMA then the definition expands to allow struct
> pages that are MMIO.
> 
> In future, if someone invents new memory or new struct pages with
> special needs it is their job to ensure it is blocked from GUP - for
> *everyone*. eg how the PCI_P2PDMA was blocked from normal GUP.
> 
> io_uring is not special, there are many users of GUP, they all need to
> work consistently.

-- 
Pavel Begunkov
