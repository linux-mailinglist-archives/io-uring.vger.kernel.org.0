Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 732BE58C643
	for <lists+io-uring@lfdr.de>; Mon,  8 Aug 2022 12:20:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242535AbiHHKUk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 8 Aug 2022 06:20:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242496AbiHHKUh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 8 Aug 2022 06:20:37 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21C5864E1;
        Mon,  8 Aug 2022 03:20:36 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id q30so10295743wra.11;
        Mon, 08 Aug 2022 03:20:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=M0he5Go9fj5sZtod3L10U6cY98vEYvhLvSwdvfZFRy4=;
        b=LG5qSNqT2JJX558617sZsTm/x1GVdc33O5C2ZvV9LFwSf0Taya3QKaq2FNjiT1gmXa
         AO34vQAZY27gcplpKOG5AYWyOuQNFORHwsVKv/SZh1h72ITT60s7iF0KnDLeAp/EXh28
         fTeoqglikt4zTo1yW1UkYcrysdR1yKPYFAxyQjC81W2nrJYMK4oclK9OWphrnDJ5pw47
         9W3+qcd3fx7EhN0X/yMXvGcENFkZscwuSJFBb+MvJLaMZv13mriWR+vb3MYg88IiPvHG
         HPb5z06HWUNDhnAyBxB+G0KaPQXQd96d5+PP+WLhl4xxqVDNzGW3YCI8FKdte+/VUfCW
         vupQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=M0he5Go9fj5sZtod3L10U6cY98vEYvhLvSwdvfZFRy4=;
        b=AbQdcMlEmVaa5BYv9LhjfPrcVMH390N+P+/gB/LlQAykDyx9ppNJNrdVsjhC+3XLKH
         jr2BHAc3btRKkzhNsZYX7QSYHU7HCPzLD5aDAcDHiw1uqW5vFQl8wGMaxUljDVt+66wg
         H4j5B+9Orkzbo09hDAgsqSGlyWDiC3QN6GG4YTwVt45bT2LW3cixquJpxDBAItyDIqB3
         JOl6bs9oGxDisq3fmZM5WsyZIjxlMCgUuiovXkPDWb59F8ZfTMRFn8jQgPU0H/jpXTU9
         3lq1dMnT2cb1LPSqVZfIarZZpnEHeOMfuBzY1nZF5ZRz3MawLkBQvUJ6IMtOSn1VRpQG
         xqHQ==
X-Gm-Message-State: ACgBeo1nnDekqN7gXoX8iLMhYyBXzI+9Cg0RzlHN/iRNAjDfEfolA++1
        Pr8RlmTkf+c2i/6Tj/GPIuk=
X-Google-Smtp-Source: AA6agR7ax8R8c9mQtUybOaqiiYYyNxIdrYTlId2y5BpG1dayZFvQX7I3r27NmErdCjerQN67iza3iw==
X-Received: by 2002:a05:6000:1445:b0:220:7fcb:23a8 with SMTP id v5-20020a056000144500b002207fcb23a8mr10818474wrx.204.1659954034513;
        Mon, 08 Aug 2022 03:20:34 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::22ef? ([2620:10d:c092:600::2:c70])
        by smtp.gmail.com with ESMTPSA id d14-20020adfe84e000000b0021badf3cb26sm13111677wrn.63.2022.08.08.03.20.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Aug 2022 03:20:34 -0700 (PDT)
Message-ID: <f2e5d71b-7eb7-5103-28c2-5e39c3c25aed@gmail.com>
Date:   Mon, 8 Aug 2022 11:14:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCHv3 2/7] file: add ops to dma map bvec
Content-Language: en-US
To:     Dave Chinner <david@fromorbit.com>,
        Matthew Wilcox <willy@infradead.org>
Cc:     Keith Busch <kbusch@fb.com>, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, axboe@kernel.dk, hch@lst.de,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Kernel Team <Kernel-team@fb.com>,
        Keith Busch <kbusch@kernel.org>
References: <20220805162444.3985535-1-kbusch@fb.com>
 <20220805162444.3985535-3-kbusch@fb.com>
 <20220808002124.GG3861211@dread.disaster.area>
 <YvBjRfy4XzzBajTX@casper.infradead.org>
 <20220808021501.GH3861211@dread.disaster.area>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20220808021501.GH3861211@dread.disaster.area>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/8/22 03:15, Dave Chinner wrote:
> On Mon, Aug 08, 2022 at 02:13:41AM +0100, Matthew Wilcox wrote:
>> On Mon, Aug 08, 2022 at 10:21:24AM +1000, Dave Chinner wrote:
>>>> +#ifdef CONFIG_HAS_DMA
>>>> +	void *(*dma_map)(struct file *, struct bio_vec *, int);
>>>> +	void (*dma_unmap)(struct file *, void *);
>>>> +#endif
>>>
>>> This just smells wrong. Using a block layer specific construct as a
>>> primary file operation parameter shouts "layering violation" to me.
>>
>> A bio_vec is also used for networking; it's in disguise as an skb_frag,
>> but it's there.
> 
> Which is just as awful. Just because it's done somewhere else
> doesn't make it right.
> 
>>> What we really need is a callout that returns the bdevs that the
>>> struct file is mapped to (one, or many), so the caller can then map
>>> the memory addresses to the block devices itself. The caller then
>>> needs to do an {file, offset, len} -> {bdev, sector, count}
>>> translation so the io_uring code can then use the correct bdev and
>>> dma mappings for the file offset that the user is doing IO to/from.
>>
>> I don't even know if what you're proposing is possible.  Consider a
>> network filesystem which might transparently be moved from one network
>> interface to another.  I don't even know if the filesystem would know
>> which network device is going to be used for the IO at the time of
>> IO submission.
> 
> Sure, but nobody is suggesting we support direct DMA buffer mapping
> and reuse for network devices right now, whereas we have working
> code for block devices in front of us.

Networking is not so far away, with zerocopy tx landed the next target
is peer-to-peer, i.e. transfers from a device memory. It's nothing
new and was already tried out quite some time ago, but to be fair,
it's not ready yet as this patchset. In any case, they have to use
common infra, which means we can't rely on struct block_device.

The first idea was to have a callback returning a struct device
pointer and failing when the file can have multiple devices or change
them on the fly. Networking already has a hook to assign a device to
a socket, we just need to make it's immutable after the assignment.
 From the userspace perspective, if host memory mapping failed it can
be re-registered as a normal io_uring registered buffer with no change
in the API on the submission side.

I like the idea to reserve ranges in the API for future use, but
as I understand it, io_uring would need to do device lookups based on
the I/O offset, which doesn't sound fast and I'm not convinced we want
to go this way now. Could work if the specified range covers only one
device but needs knowledge of how it's chunked and doesn't go well
when devices alternate every 4KB or so.

Another question is whether we want to have some kind of notion of
device groups so the userspace doesn't have to register a buffer
multiple times when the mapping can be shared b/w files.


> What I want to see is broad-based generic block device based
> filesysetm support, not niche functionality that can only work on a
> single type of block device. Network filesystems and devices are a
> *long* way from being able to do anything like this, so I don't see
> a need to cater for them at this point in time.
> 
> When someone has a network device abstraction and network filesystem
> that can do direct data placement based on that device abstraction,
> then we can talk about the high level interface we should use to
> drive it....
> 
>> I think a totally different model is needed where we can find out if
>> the bvec contains pages which are already mapped to the device, and map
>> them if they aren't.  That also handles a DM case where extra devices
>> are hot-added to a RAID, for example.
> 
> I cannot form a picture of what you are suggesting from such a brief
> description. Care to explain in more detail?

-- 
Pavel Begunkov
