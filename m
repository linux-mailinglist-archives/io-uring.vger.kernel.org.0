Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93BFE514E95
	for <lists+io-uring@lfdr.de>; Fri, 29 Apr 2022 16:57:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378091AbiD2PBM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 29 Apr 2022 11:01:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378094AbiD2PBM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 29 Apr 2022 11:01:12 -0400
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D47CB1884
        for <io-uring@vger.kernel.org>; Fri, 29 Apr 2022 07:57:53 -0700 (PDT)
Received: by mail-il1-x133.google.com with SMTP id g10so4139796ilf.6
        for <io-uring@vger.kernel.org>; Fri, 29 Apr 2022 07:57:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Cr3Zt15MQjCzCNKsSqxMTPsVbsWgRFV0S7vyyuG8sbM=;
        b=nY1dyv5w83XyODNYvjrS7chHOeIc+yJnNWPAwrJOPO123XvcEKgvsM09h7YhAZYH2L
         3bWFFsmV1/zmZ2/4F9wiqImI2gsz6TdCyYSqgauxcLTe9cocNC62UDBMQIpbw5++nqog
         3Q10o2otI22CgM5Oq9qlXLyYn0U1j2N783Y1PmytIBvQoJYg9aeFYibqjsXCsXPqveT3
         ZuxY3R67hqFE13Ungi9+5PFt05+kk3ty/VRz5CNmBft5NcCoQqFA14tUp22/dWPCbat9
         PMGyfx5AmVrHf4jo1czLD5rPhBCKTirJPS1Bh2WgdSrB3zG0J5bU37ncydLOkHLle1zA
         T4pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Cr3Zt15MQjCzCNKsSqxMTPsVbsWgRFV0S7vyyuG8sbM=;
        b=xbJZiWMb8pNpnMyvIrmY8b8P8/3CxSkS5jRm0iYUq3mhuUJ+Q74PI1RYhC1zPT16x7
         ZZXrhyoCHZbhrWMOEG8RAJ0/kmVE2AWw7GvVzeIlt4QVq4m+SFG4ZXBHbM9/fSOTiMbB
         zdZwB5BASy6zYOYRVG8jVqIK78aiz7uQG25GYSqfABcHzDykTbDeHaMg6fIbgaZt0sEj
         nDuHivSlWg3whzB8LT6/1qOi04TRTfNiTINJ0FpFyhTB1DTCjbTElMUfM08F0zZQbzvc
         NeesnyTIoSHgdXwFF7E01d03Sej96iEoeeQIz2qblCXJzzruX4gTxOntQoBlTFtH/nbL
         x53g==
X-Gm-Message-State: AOAM532ifpdofFbowaRKHpi++CZmg5KhTlXRy9TSK1ZJ9IJovypux4k7
        QnwG74aLsZjI066xP+YX/NHb+GpfcXfg5A==
X-Google-Smtp-Source: ABdhPJyp0QqOyHM1xhrKHIFym4BhvQF9Cqws/ZuBL1YjzdyUPBCbLQuUhGELrMM0kL8JvObUkIPgdA==
X-Received: by 2002:a05:6e02:1d04:b0:2cc:4c42:9b99 with SMTP id i4-20020a056e021d0400b002cc4c429b99mr14630135ila.168.1651244272475;
        Fri, 29 Apr 2022 07:57:52 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id u23-20020a02aa97000000b0032b3a78174csm630064jai.16.2022.04.29.07.57.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Apr 2022 07:57:52 -0700 (PDT)
Message-ID: <a513e86d-747e-8439-71b6-7d1b22299eac@kernel.dk>
Date:   Fri, 29 Apr 2022 08:57:51 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH 10/10] io_uring: add support for ring mapped supplied
 buffers
Content-Language: en-US
To:     Victor Stewart <v@nametag.social>
Cc:     io-uring@vger.kernel.org
References: <20220429122803.41101-1-axboe@kernel.dk>
 <20220429122803.41101-11-axboe@kernel.dk>
 <CAM1kxwhyPpZFQ2ZEhWGdENz6Bw6a0QN-NWMkmAuYjVxDDHP_Aw@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAM1kxwhyPpZFQ2ZEhWGdENz6Bw6a0QN-NWMkmAuYjVxDDHP_Aw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/29/22 7:21 AM, Victor Stewart wrote:
> top posting because this is a tangential but related comment.
> 
> the way i manage memory in my network server is by initializing with a
> fixed maximum number of supported clients, and then mmap an enormous
> contiguous buffer of something like (100MB + 100MB) * nMaxClients, and
> then for each client assign a fixed 100MB range for receive and
> another for send.
> 
> then with transparent huge pages disabled, only the pages with bytes
> in them are ever resident, memset-ing bytes to 0 as they?re consumed
> by the send or receive paths.
> 
> so this provides a perfectly optimal deterministic memory
> architecture, which makes client memory management effortless, while
> costing nothing? without the hassle of recycling buffers or worrying
> about what range to recv into or write into.
> 
> but i know that registered buffers as is have some restriction on
> maximum number of bytes one can register (i forget exactly).

You can have 64K groups, and 64K buffers in each. Each buffer can be
INT_MAX.

> so maybe there?s some way in the future to accommodate this scheme as
> well, which i believe is optimal out of all options.

As you noted, this patch doesn't change how provided buffers work, it
merely changes the mechanism with which they can be provided and
consumed to be more efficient.

One idea that we have entertained internally is to allow incremental
consumption of a buffer. Let's assume your setup. I'm going to exclude
send as those aren't relevant for this discussion. This means you have
100MB of buffer space for receive per client. Each client would have a
buffer group ID associated with it, for their receive buffers. If you
know what size your receives will be, then you'd provide your 100MB in
chunks of that. Each receive would pick a chunk, recv data, then post
the completion that holds information on what buffer was picked for it.
When the client is done with the data, it puts it back into the provided
pool.

If you have wildly different receive sizes, and no idea how much you'd
get at any point in time, then this scheme doesn't work so well as you
have to then either do multiple receive requests to get all the data, or
size your chunks such that any receive will fit. Obviously that can be
wasteful, as you end up with fewer available chunks, and maybe you need
to throw more than 100MB at it at that point.

If we allowed incremental consumption, you could provide your 100MB as
just one chunk. When a recv request is posted for eg 1500 bytes, you'd
simply chop 1500 off the front of that buffer and use it. You're now
left with a single chunk that's 100MB-1500B in size.

One complication here is that we don't have enough room in the CQE to
tell the app where we consumed from. Hence we'd need to ensure that the
kernel and application agree on where data is consumed from for any
given receive. Given full ordering of completions wrt data receive, this
isn't impossible, but it does seem a bit fragile to me.

We do have pending patches that allow for bigger CQEs, with the initial
use case being the passthrough support for eg NVMe. With that, you have
two u64 extra fields for any CQE, if you configure your ring to use big
CQEs. With that, we could do incremental consumption and just have the
recv completion be:

cqe = {
	.user_data	/* whatever app set user_data to for recv */
	.res		/* bytes received */
	.flags		/* IORING_CQE_F_INC_BUFFER */
	.extra1		/* start address of where data landed */
	.extra2		/* still unused */
}

and the client now knows that data was received into the address at
.extra1 and of .res bytes in length. This would not supported vectored
recv, but that seems like a minor thing as you can just do big buffers.

This does suffer from the fragmentation issue again. Your case probably
does not as you have a group per client, but other use cases might have
shared groups.

That was a long winded way of saying that "yes this patch doesn't
fundamentally change how provided buffers work, it just makes it more
efficient to use and allows easy re-provide options that previously
made provided buffers too slow to use for some use cases".

I welcome feedback! It's not entirely clear to me what your suggestion
is, it looks more like you're describing your use cases and soliciting
ideas on how provided buffers could work better for that?

-- 
Jens Axboe

