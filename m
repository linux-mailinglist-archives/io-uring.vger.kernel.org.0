Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C04D42AF899
	for <lists+io-uring@lfdr.de>; Wed, 11 Nov 2020 19:53:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727475AbgKKSx5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 11 Nov 2020 13:53:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727013AbgKKSx5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 11 Nov 2020 13:53:57 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12AB7C0613D1
        for <io-uring@vger.kernel.org>; Wed, 11 Nov 2020 10:53:57 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id l1so3541132wrb.9
        for <io-uring@vger.kernel.org>; Wed, 11 Nov 2020 10:53:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WrWPo1Dmel0ma582T2tEY6TXI1DN5hsrXHlAWrFyQLM=;
        b=mRu0fgSJKvqv0n006Z88fd060hCQOJQH6alzaKcly3Kn/Ifo54kBxsx75Ggsk4r1lE
         f9mu5wIh+d0VZ3LUCTqQaql5BVVPtS63vuEoTCgxjVCyOXWRX8PdVaBRL098YRZcEeEQ
         HtVQHwWsq2AUXLRTELbhea2MAyYCt9MDECrBSorlDlcoK51op+Vr3H5Wp0d0TYqCBflS
         yAf5VgiOsfw2MZl/KrTCzXnV/NHJAf7kmOx41uYozhPaxHLQEuBRIdfDCTMTHHtswQF7
         mrVNHmqFKmkNvclt5cZF/R1JmR34FxGTLw98hh9UFsraNQutUZGvfzVVpSDoFVYzVT4H
         cgHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=WrWPo1Dmel0ma582T2tEY6TXI1DN5hsrXHlAWrFyQLM=;
        b=POl+Jrc5+11/4CI6I1gMj+uxG3XjKI5zc/JA2ZJWhhpQ2sOs7xSj+GvFPiuw0rd3m6
         NtO0XSLwZzKXlHIuA9k+5qcaTMSbI767VAGcTOEIho1sG8V0GHZ/pggF2gEIVrEq2hw+
         yJTeDHZXp/uWqpUME/etmcwCAnFx90NH2a4qvIioOJLmvpFXVwnFfRruAumQKL70KVVH
         D4ESlmKyMngFA9GfyZ/M/HCWzt9wtWFLGZO3mlZYn3N2wVjdjmEWUFSU9Mtxpv61wkKq
         HrpXhIeamoVFkprsxp7i4x6oU+KmylGgbt1Gv0xF3E6rWVIP+wltV4GcxbjnmFtxkMoh
         mRpA==
X-Gm-Message-State: AOAM530wag+6TpGgrkvKkXbcGeCXB0NX+JxYOTtkIt8+xD65vS3ui7wS
        BrnB07x+6nD10FYJ0dO9dj5Vl333T8UppQ==
X-Google-Smtp-Source: ABdhPJwxZShjpmCv1ucH8GmMZAdkryH3c16xYmxI51Wleb187qEyasdXg5ffoTMlv8Sd5yywLRKXLw==
X-Received: by 2002:adf:fa82:: with SMTP id h2mr10633808wrr.24.1605120835332;
        Wed, 11 Nov 2020 10:53:55 -0800 (PST)
Received: from [192.168.1.96] (host109-152-100-164.range109-152.btcentralplus.com. [109.152.100.164])
        by smtp.gmail.com with ESMTPSA id c8sm3392545wrv.26.2020.11.11.10.53.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Nov 2020 10:53:54 -0800 (PST)
To:     Victor Stewart <v@nametag.social>
Cc:     io-uring <io-uring@vger.kernel.org>
References: <CAM1kxwgKGMz9UcvpFr1239kmdvmKPuzAyBEwKi_rxDog1MshRQ@mail.gmail.com>
 <acc66238-0d27-cd22-dac4-928777a8efbc@gmail.com>
 <CAM1kxwjSyLb9ijs0=RZUA06E20qjwBnAZygwM3ckh10WozExag@mail.gmail.com>
 <3913bbb5-50ec-6ad9-13c9-d49a8b7f7e89@gmail.com>
 <CAM1kxwhdCoH7ZAmnaaDTohg3TUSWL264juamO1or_3m-JFnRyg@mail.gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: io_uring-only sendmsg + recvmsg zerocopy
Message-ID: <7e1c3ecd-fe8c-9c1f-e344-974de9cc2b02@gmail.com>
Date:   Wed, 11 Nov 2020 18:50:50 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <CAM1kxwhdCoH7ZAmnaaDTohg3TUSWL264juamO1or_3m-JFnRyg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/11/2020 16:49, Victor Stewart wrote:
> On Wed, Nov 11, 2020 at 1:00 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
>> On 11/11/2020 00:07, Victor Stewart wrote:
>>> On Tue, Nov 10, 2020 at 11:26 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>>>> NIC ACKs, instead of finding the socket's error queue and putting the
>>>>> completion there like MSG_ZEROCOPY, the kernel would find the io_uring
>>>>> instance the socket is registered to and call into an io_uring
>>>>> sendmsg_zerocopy_completion function. Then the cqe would get pushed
>>>>> onto the completion queue.>
>>>>> the "recvmsg zerocopy" is straight forward enough. mimicking
>>>>> TCP_ZEROCOPY_RECEIVE, i'll go into specifics next time.
>>>>
>>>> Receive side is inherently messed up. IIRC, TCP_ZEROCOPY_RECEIVE just
>>>> maps skbuffs into userspace, and in general unless there is a better
>>>> suited protocol (e.g. infiniband with richier src/dst tagging) or a very
>>>> very smart NIC, "true zerocopy" is not possible without breaking
>>>> multiplexing.
>>>>
>>>> For registered buffers you still need to copy skbuff, at least because
>>>> of security implications.
>>>
>>> we can actually just force those buffers to be mmap-ed, and then when
>>> packets arrive use vm_insert_pin or remap_pfn_range to change the
>>> physical pages backing the virtual memory pages submmited for reading
>>> via msg_iov. so it's transparent to userspace but still zerocopy.
>>> (might require the user to notify io_uring when reading is
>>> completed... but no matter).
>>
>> Yes, with io_uring zerocopy-recv may be done better than
>> TCP_ZEROCOPY_RECEIVE but
>> 1) it's still a remap. Yes, zerocopy, but not ideal
>> 2) won't work with registered buffers, which is basically a set
>> of pinned pages that have a userspace mapping. After such remap
>> that mapping wouldn't be in sync and that gets messy.
> 
> well unless we can alleviate all copies, then there isn’t any point
> because it isn’t zerocopy.
> 
> so in my server, i have a ceiling on the number of clients,
> preallocate them, and mmap anonymous noreserve read + write buffers
> for each.
> 
> so say, 150,000 clients x (2MB * 2). which is 585GB. way more than the
> physical memory of my machine. (and have 10 instance of it per
> machine, so ~6TB lol). but at any one time probably 0.01% of that
> memory is in usage. and i just MADV_COLD the pages after consumption.
> 
> this provides a persistent “vmem contiguous” stream buffer per client.
> which has a litany of benefits. but if we persistently pin pages, this
> ceases to work, because pin pages require persistent physical memory
> backing pages.
> 
> But on the send side, if you don’t pin persistently, you’d have to pin
> on demand, which costs more than it’s worth for sends less than ~10KB.

having it non-contiguous and do round-robin IMHO would be a better shot

> And I guess there’s no way to avoid pinning and maintain kernel
> integrity. Maybe we could erase those userspace -> physical page
> mappings, then recreate them once the operation completes, but 1) that
> would require page aligned sends so that you could keep writing and
> sending while you waited for completions and 2) beyond being
> nonstandard and possibly unsafe, who says that would even cost less
> than pinning, definitely costs something. Might cost more because
> you’d have to get locks to the page table?
> 
> So essentially on the send side the only way to zerocopy for free is
> to persistently pin (and give up my per client stream buffers).
> 
> On the receive side actually the only way to realistically do zerocopy
> is to somehow pin a NIC RX queue to a process, and then persistently
> map the queue into the process’s memory as read only. That’s a
> security absurdly in the general case, but it could be root only
> usage. Then you’d recvmsg with a NULL msg_iov[0].iov_base, and have
> the packet buffer location and length written in. Might require driver
> buy-in, so might be impractical, but unsure.

https://blogs.oracle.com/linux/zero-copy-networking-in-uek6
scroll to AF_XDP

> 
> Otherwise the only option is an even worse nightmare how
> TCP_ZEROCOPY_RECEIVE works, and ridiculously impractical for general
> purpose…

Well, that's not so bad, API with io_uring might be much better, but
still would require unmap. However, depending on a use case overhead
for small packets and/or shared b/w many thread mm can potentially be
a deal breaker.

> “Mapping of memory into a process's address space is done on a
> per-page granularity; there is no way to map a fraction of a page. So
> inbound network data must be both page-aligned and page-sized when it
> ends up in the receive buffer, or it will not be possible to map it
> into user space. Alignment can be a bit tricky because the packets
> coming out of the interface start with the protocol headers, not the
> data the receiving process is interested in. It is the data that must
> be aligned, not the headers. Achieving this alignment is possible, but
> it requires cooperation from the network interface

should support scatter-gather in other words

> 
> It is also necessary to ensure that the data arrives in chunks that
> are a multiple of the system's page size, or partial pages of data
> will result. That can be done by setting the maximum transfer unit
> (MTU) size properly on the interface. That, in turn, can require
> knowledge of exactly what the incoming packets will look like; in a
> test program posted with the patch set, Dumazet sets the MTU to
> 61,512. That turns out to be space for fifteen 4096-byte pages of
> data, plus 40 bytes for the IPv6 header and 32 bytes for the TCP
> header.”
> 
> https://lwn.net/Articles/752188/
> 
> Either receive case also makes my persistent per client stream buffer
> zerocopy impossible lol.

it depends

> 
> in short, zerocopy sendmsg with persistently pinned buffers is
> definitely possible and we should do that. (I'll just make it work on
> my end).
> 
> recvmsg i'll have to do more research into the practicality of what I
> proposed above.

1. NIC is smart enough and can locate the end (userspace) buffer and
DMA there directly. That requires parsing TCP/UDP headers, etc., or
having a more versatile API like infiniband. + extra NIC features.

2. map skbufs into the userspace as TCP_ZEROCOPY_RECEIVE does.

-- 
Pavel Begunkov
