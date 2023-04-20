Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E49BC6E95F9
	for <lists+io-uring@lfdr.de>; Thu, 20 Apr 2023 15:40:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231420AbjDTNkH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Apr 2023 09:40:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229769AbjDTNkG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Apr 2023 09:40:06 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C0544ED4;
        Thu, 20 Apr 2023 06:40:05 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id sz19so6548759ejc.2;
        Thu, 20 Apr 2023 06:40:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681998003; x=1684590003;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6+FbR3f35Ea1Q5h4PMa66mgR6tADBXSDeYnQHZVkU7M=;
        b=JGy/6vdlhycjs0A1ZxdvEqVuHFFrwFP+hCc/vnEOLzg9Etz+bmipAQ+qZxhjfZ/ecp
         kq47QHxN808TUrxwXfA+WAtH+B+XgAuKWNPFHuCpDUcUBk26hRcMOY279DMz9WwSOrJe
         oS6v5lfQ8/Ze8O0tgVgiGIKs2SeG1kFSFIJyqSGMtNLlM6qiFn7gqqthumuqMmOjAVFm
         fuWa9om+ulIuvUaAbBfLjsLXzwp8pW3b5PzEAoZyn51gVICu+2WlwiNsp7pTnL0Fy2s7
         hg9qgO57OBB3dQ8ld/02kJj5xu6rGaPO4lT39bO2rZTamRStnI+Znt1uY3ZdYvztULHL
         s7+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681998003; x=1684590003;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6+FbR3f35Ea1Q5h4PMa66mgR6tADBXSDeYnQHZVkU7M=;
        b=lAYVES8yc6vH3ELT2WKVSFEWG/I9jYGJZXHzXuxktJT8JBXtM/D8sJsXmIxBLrT0QX
         s5gfvYgyXjitHLXm3PWbf5UCQo8ZJfTnpwE04diwkFUPNgmHZLnkM3CT5FCNTpM4z0++
         6RjGRu2TAl2Bt7ncyF2T2nDFinep0i6dvfsN0HMnwPpdM7MtT87y7PGGQXpMKLpeuV64
         F/suwBiMhbxRDP0VyXrx/PoN+xYBXX8R3Xujg+y40jZDt2iJSOl7PyKnOF15Ks2SbwtW
         Vz8nS0sJRWk0bxX3fFYO/yGoXxSJKodKk1ee04CpxQbURUQRwKb9p9vhByDK1IZy+hyt
         T/uQ==
X-Gm-Message-State: AAQBX9fZ8KXTINEFgQXQt10jqCQmhIg88y4ehtu0EBXaKng76ymZvz8b
        hYTvyHJ/4SQ4Z4+VBug00J0=
X-Google-Smtp-Source: AKy350aO8sDsBSOJ20epFjGg6Rn4Rg3tRiQyvP4oz3yfAvPZtWgW/5hYn1Z12PeDVF6InuQwvfMr7A==
X-Received: by 2002:a17:906:2ad1:b0:94e:83d3:1b51 with SMTP id m17-20020a1709062ad100b0094e83d31b51mr1372015eje.23.1681998003188;
        Thu, 20 Apr 2023 06:40:03 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::26ef? ([2620:10d:c092:600::2:7db2])
        by smtp.gmail.com with ESMTPSA id r20-20020a170906705400b0094f05fee9d3sm732721ejj.211.2023.04.20.06.40.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Apr 2023 06:40:02 -0700 (PDT)
Message-ID: <c94afa59-e1b9-d7b0-a83e-6c722324e7ef@gmail.com>
Date:   Thu, 20 Apr 2023 14:36:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v4 4/6] io_uring: rsrc: avoid use of vmas parameter in
 pin_user_pages()
Content-Language: en-US
To:     Matthew Wilcox <willy@infradead.org>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Lorenzo Stoakes <lstoakes@gmail.com>, Jens Axboe <axboe@kernel.dk>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>, io-uring@vger.kernel.org
References: <956f4fc2204f23e4c00e9602ded80cb4e7b5df9b.1681831798.git.lstoakes@gmail.com>
 <936e8f52-00be-6721-cb3e-42338f2ecc2f@kernel.dk>
 <c2e22383-43ee-5cf0-9dc7-7cd05d01ecfb@kernel.dk>
 <f82b9025-a586-44c7-9941-8140c04a4ccc@lucifer.local>
 <69f48cc6-8fc6-0c49-5a79-6c7d248e4ad5@kernel.dk>
 <bec03e0f-a0f9-43c3-870b-be406ca848b9@lucifer.local>
 <8af483d2-0d3d-5ece-fb1d-a3654411752b@kernel.dk>
 <d601ca0c-d9b8-4e5d-a047-98f2d1c65eb9@lucifer.local>
 <ZEAxhHx/4Ql6AMt2@casper.infradead.org> <ZEAx90C2lDMJIux1@nvidia.com>
 <ZEA0dbV+qIBSD0mG@casper.infradead.org>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <ZEA0dbV+qIBSD0mG@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/19/23 19:35, Matthew Wilcox wrote:
> On Wed, Apr 19, 2023 at 03:24:55PM -0300, Jason Gunthorpe wrote:
>> On Wed, Apr 19, 2023 at 07:23:00PM +0100, Matthew Wilcox wrote:
>>> On Wed, Apr 19, 2023 at 07:18:26PM +0100, Lorenzo Stoakes wrote:
>>>> So even if I did the FOLL_ALLOW_BROKEN_FILE_MAPPING patch series first, I
>>>> would still need to come along and delete a bunch of your code
>>>> afterwards. And unfortunately Pavel's recent change which insists on not
>>>> having different vm_file's across VMAs for the buffer would have to be
>>>> reverted so I expect it might not be entirely without discussion.
>>>
>>> I don't even understand why Pavel wanted to make this change.  The
>>> commit log really doesn't say.
>>>
>>> commit edd478269640
>>> Author: Pavel Begunkov <asml.silence@gmail.com>
>>> Date:   Wed Feb 22 14:36:48 2023 +0000
>>>
>>>      io_uring/rsrc: disallow multi-source reg buffers
>>>
>>>      If two or more mappings go back to back to each other they can be passed
>>>      into io_uring to be registered as a single registered buffer. That would
>>>      even work if mappings came from different sources, e.g. it's possible to
>>>      mix in this way anon pages and pages from shmem or hugetlb. That is not
>>>      a problem but it'd rather be less prone if we forbid such mixing.
>>>
>>>      Cc: <stable@vger.kernel.org>
>>>      Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>>      Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>
>>> It even says "That is not a problem"!  So why was this patch merged
>>> if it's not fixing a problem?
>>>
>>> It's now standing in the way of an actual cleanup.  So why don't we
>>> revert it?  There must be more to it than this ...
>>
>> https://lore.kernel.org/all/61ded378-51a8-1dcb-b631-fda1903248a9@gmail.com/
> 
> So um, it's disallowed because Pavel couldn't understand why it
> should be allowed?  This gets less and less convincing.

Excuse me? I'm really sorry you "couldn't understand" the explanation
as it has probably been too much of a "mental load", but let me try to
elaborate.

Because it's currently limited what can be registered, it's indeed not
a big deal, but that will most certainly change, and I usually and
apparently nonsensically prefer to tighten things up _before_ it becomes
a problem. And again, taking a random set of buffers created for
different purposes and registering it as a single entity is IMHO not a
sane approach.

Take p2pdma for instance, if would have been passed without intermixing
there might not have been is_pci_p2pdma_page()/etc. for every single page
in a bvec. That's why in general, it won't change for p2pdma but there
might be other cases in the future.


> FWIW, what I was suggesting was that we should have a FOLL_SINGLE_VMA
> flag, which would use our shiny new VMA lock infrastructure to look
> up and lock _one_ VMA instead of having the caller take the mmap_lock.
> Passing that flag would be a tighter restriction that Pavel implemented,
> but would certainly relieve some of his mental load.
> 
> By the way, even if all pages are from the same VMA, they may still be a
> mixture of anon and file pages; think a MAP_PRIVATE of a file when
> only some pages have been written to.  Or an anon MAP_SHARED which is
> accessible by a child process.

-- 
Pavel Begunkov
