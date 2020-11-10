Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AAEE2AE401
	for <lists+io-uring@lfdr.de>; Wed, 11 Nov 2020 00:26:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732259AbgKJX03 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 10 Nov 2020 18:26:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732120AbgKJX03 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 10 Nov 2020 18:26:29 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA1C1C0613D1
        for <io-uring@vger.kernel.org>; Tue, 10 Nov 2020 15:26:28 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id c9so28479wml.5
        for <io-uring@vger.kernel.org>; Tue, 10 Nov 2020 15:26:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KK60/gAVBhb4TBfuPg0YSh4Ay3Vw5jsaChY3ePP79xc=;
        b=VIXYzem/Va1Xp3IQDcvi27/gyTBlFN23YmI7rrUN7oz6FcAcqo/MBsHi+RS2SGMfVB
         xxN2DsdQaBMST2XWcRGVuTgqnMGodOM6eRrvI+k4XCEtaxhafwq0weCyvQllurAqbQk1
         ThJ9J80vGcw44WYflzmcCj0C27dxo8MRk7hs6YN5Weh9Z9/vECp0ktd9y0Zwq9ApVK2N
         og7ngCqRuRnplMdqxrt3h+imI5iCbj1hGkgbpF9ztPmCPtF7cvqFxB8h76U7oypJ8Ko5
         7MqGef3zEBcsQjgqrQNKGZd+wEKyCjUnv8V5DI4BLFCavRk6Z0iLnujhpX72ED55D8TB
         qVrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KK60/gAVBhb4TBfuPg0YSh4Ay3Vw5jsaChY3ePP79xc=;
        b=SnPizGd8VUXL+uP6wX6jRQjIXC3VL37ijrxXJp2+WI8v2SfgofSxKBlgp6gVgPyu9u
         j/JLPgWOuIHgiqveoD7ae6EVTNxYyl8Z41K7zGicyZCl32k1Bl0Ouv3Q7qhlaU6i31HC
         R30SS2rx4MpUMMZIwNZe92NIHtc8bI9y33MO8ckBh3f/dN9J9iF/5QpMY9FSN4sORibW
         gBbXau3F5FNGDB9Mn0mtE9K/fYq8Kz2YhfRg4IueV4zTv/Ag5ZUkE97aP23a1T4A/z1g
         SUvy1rbwPI1L48Tx7gSlazJVKErt3wt9YRriALxLr0MU/k3Fr7kNvN6RA38Ofi/3WfTC
         Eaug==
X-Gm-Message-State: AOAM531tf6bcyoanGzu3rKCK7By/PD4jbmRVN/sNuBnnhXJALrqk3fN/
        x34u0JiSFS20eEl9/nUWgCXCsMi84bPhzw==
X-Google-Smtp-Source: ABdhPJzsdZK1a0zonsQ+89zpO5Kzk8fcjdSzJG6PgrAWxMDd0nvIRClfizOnP+IM6w0XfUGVNfxxbQ==
X-Received: by 2002:a1c:2ece:: with SMTP id u197mr553658wmu.58.1605050787292;
        Tue, 10 Nov 2020 15:26:27 -0800 (PST)
Received: from [192.168.1.96] (host109-152-100-164.range109-152.btcentralplus.com. [109.152.100.164])
        by smtp.gmail.com with ESMTPSA id v6sm278518wrb.53.2020.11.10.15.26.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Nov 2020 15:26:26 -0800 (PST)
To:     Victor Stewart <v@nametag.social>, io-uring@vger.kernel.org
References: <CAM1kxwgKGMz9UcvpFr1239kmdvmKPuzAyBEwKi_rxDog1MshRQ@mail.gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: io_uring-only sendmsg + recvmsg zerocopy
Message-ID: <acc66238-0d27-cd22-dac4-928777a8efbc@gmail.com>
Date:   Tue, 10 Nov 2020 23:23:22 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <CAM1kxwgKGMz9UcvpFr1239kmdvmKPuzAyBEwKi_rxDog1MshRQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/11/2020 21:31, Victor Stewart wrote:
> here’s the design i’m flirting with for "recvmsg and sendmsg zerocopy"
> with persistent buffers patch.

Ok, first we need make it to work with registered buffers. I had patches
for that but need to rebase+refresh it, I'll send it out this week then.

Zerocopy would still go through some pinning,
e.g. skb_zerocopy_iter_*() -> iov_iter_get_pages()
		-> get_page() -> atomic_inc()
but it's lighter for bvec and can be optimised later if needed.

And that leaves hooking up into struct ubuf_info with callbacks
for zerocopy. 

> 
> we'd be looking at approx +100% throughput each on the send and recv
> paths (per TCP_ZEROCOPY_RECEIVE benchmarks).> 
> these would be io_uring only operations given the sendmsg completion
> logic described below. want to get some conscious that this design
> could/would be acceptable for merging before I begin writing the code.
> 
> the problem with zerocopy send is the asynchronous ACK from the NIC
> confirming transmission. and you can’t just block on a syscall til
> then. MSG_ZEROCOPY tackled this by putting the ACK on the
> MSG_ERRQUEUE. but that logic is very disjointed and requires a double
> completion (once from sendmsg once the send is enqueued, and again
> once the NIC ACKs the transmission), and requires costly userspace
> bookkeeping.
> 
> so what i propose instead is to exploit the asynchrony of io_uring.
> 
> you’d submit the IORING_OP_SENDMSG_ZEROCOPY operation, and then
> sometime later receive the completion event on the ring’s completion
> queue (either failure or success once ACK-ed by the NIC). 1 unified
> completion flow.

I though about it after your other email. It makes sense for message
oriented protocols but may not for streams. That's because a user
may want to call

send();
send();

And expect right ordering, and that where waiting for ACK may add a lot
of latency, so returning from the call here is a notification that "it's
accounted, you may send more and order will be preserved".

And since ACKs may came a long after, you may put a lot of code and stuff
between send()s and still suffer latency (and so potentially throughput
drop).

As for me, for an optional feature sounds sensible, and should work well
for some use cases. But for others it may be good to have 2 of
notifications (1. ready to next send(), 2. ready to recycle buf).
E.g. 2 CQEs, that wouldn't work without a bit of io_uring patching.

> 
> we can somehow tag the socket as registered to io_uring, then when the

I'd rather tag a request

> NIC ACKs, instead of finding the socket's error queue and putting the
> completion there like MSG_ZEROCOPY, the kernel would find the io_uring
> instance the socket is registered to and call into an io_uring
> sendmsg_zerocopy_completion function. Then the cqe would get pushed
> onto the completion queue.> 
> the "recvmsg zerocopy" is straight forward enough. mimicking
> TCP_ZEROCOPY_RECEIVE, i'll go into specifics next time.

Receive side is inherently messed up. IIRC, TCP_ZEROCOPY_RECEIVE just
maps skbuffs into userspace, and in general unless there is a better
suited protocol (e.g. infiniband with richier src/dst tagging) or a very
very smart NIC, "true zerocopy" is not possible without breaking
multiplexing.

For registered buffers you still need to copy skbuff, at least because
of security implications.

> 
> the other big concern is the lifecycle of the persistent memory
> buffers in the case of nefarious actors. but since we already have
> buffer registration for O_DIRECT, I assume those mechanics already

just buffer registration, not specifically for O_DIRECT

> address those issues and can just be repurposed?

Depending on how long it could stuck in the net stack, we might need
to be able to cancel those requests. That may be a problem.

> 
> and so with those persistent memory buffers, you'd only pay the cost
> of pinning the memory into the kernel once upon registration, before
> you even start your server listening... thus "free". versus pinning
> per sendmsg like with MSG_ZEROCOPY... thus "true zerocopy".
> 

-- 
Pavel Begunkov
