Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E17712CF19C
	for <lists+io-uring@lfdr.de>; Fri,  4 Dec 2020 17:11:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725923AbgLDQKY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 4 Dec 2020 11:10:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727008AbgLDQKX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 4 Dec 2020 11:10:23 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35CD8C0613D1
        for <io-uring@vger.kernel.org>; Fri,  4 Dec 2020 08:09:43 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id g14so5809629wrm.13
        for <io-uring@vger.kernel.org>; Fri, 04 Dec 2020 08:09:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:cc:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FPZYdf7u3BbeuownBe460HeNCirzUuFNJeU8+KeItlI=;
        b=YT3w9SW9CZFdL0zg4or8kPk7aBCJ8ahXPoKgeeeMEN96xoAGtgEv19eCmIx9x32I8K
         K7UE8FNXvK6GRevmyTBOgwmfjYup7LY+SAhmbArm7Yjcp/Mru2ZVB/xkorAJz9Aw1Idz
         RuJFJvj+IHpBNVYXxhQ9C60VqfZ3My4tsCVVhMrk7mOtDbcZZqaDbtC2iv4yaISJmTRW
         5V+EC6i5fayGikF6TXicvg1ijf3DriNRR5gr5nUZoO/e7uXlUpP8Wixh1PstuTl9BzI9
         IpkUBDagrsh+1ptf8BPhIElm0nJ9BBaYDM6WoFd59RJHK5I/hZhFEx3ejHV7/IA3jLY5
         V+tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:cc:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=FPZYdf7u3BbeuownBe460HeNCirzUuFNJeU8+KeItlI=;
        b=tQMoZpY/f/sFmseeQvLYJeTQpCTsz2l7ujIhXAodoGYzeV3EeaRDdjsdsr1kmV4BWD
         NHd35HF7W5PdENZHjYSRKf/5CphgAeylKOtf56nl7aJdr9jOK1j+sGkRYRFsDUuV0lr5
         cu9LXRuU8OflkGEk/KsEUUGmMWf+Uq7xYJkwmY9I9LpglxGN5RTlYFq1u58oKVzHhVmG
         s4JNLGXy/tSVIU2uakXKxLQjmx+HGa56glhgu7veCfJsoo5LCmbi65QNHZWJmzVZ/KQn
         6dns7VKlpwds6+51EC84S3hB2W9AtZaECE5IFEoCwTu5XRpFhwh6EjDpIHSvr7cekSmQ
         vd4A==
X-Gm-Message-State: AOAM533qDRTLyRJv7PGz7a4PlcaycLI6YuMb3V0WFJFsbe6Gpkiwa2QV
        CeVeDeDefl4rGgjK94B3/LDtnKcGG8twiw==
X-Google-Smtp-Source: ABdhPJzBMcBdeGDUc+9i03IPMLRW2D/hwaGPtTLfXwZZzO80uCfFLmdToZ4ZX6pTQGCS0mP4fyW9ew==
X-Received: by 2002:adf:e801:: with SMTP id o1mr5772908wrm.3.1607098180163;
        Fri, 04 Dec 2020 08:09:40 -0800 (PST)
Received: from [192.168.8.100] ([185.69.145.93])
        by smtp.gmail.com with ESMTPSA id 90sm4107026wrl.60.2020.12.04.08.09.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Dec 2020 08:09:39 -0800 (PST)
To:     Ricardo Ribalda <ribalda@chromium.org>
References: <CANiDSCsXd1BLUJwgdET5XBF8wQEpbape6BoCPpG9cTGAkUJOBA@mail.gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Cc:     io-uring@vger.kernel.org
Subject: Re: Zero-copy irq-driven data
Message-ID: <f0490f07-c59b-1dab-067f-f17dcfbb61da@gmail.com>
Date:   Fri, 4 Dec 2020 16:06:24 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <CANiDSCsXd1BLUJwgdET5XBF8wQEpbape6BoCPpG9cTGAkUJOBA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 03/12/2020 15:26, Ricardo Ribalda wrote:
> Hello
> 
> I have just started using io_uring so please bear with me.
> 
> I have a device that produces data at random time and I want to read
> it with the lowest latency possible and hopefully zero copy.
> 
> In userspace:
> 
> I have a sqe with a bunch of io_uring_prep_read_fixed and when they
> are ready I process them and push them again to the sqe, so it always
> has operations.

SQ - submission queue, SQE - SQ entry.
To clarify misunderstanding I guess you wanted to say that you have
an SQ filled with fixed read requests (i.e. SQEs prep'ed with
io_uring_prep_read_fixed()), and so on.

> 
> In kernelspace:
> 
> I have implemented the read() file operation in my driver. The data

I'd advise you to implement read_iter() instead, otherwise io_uring
won't be able to get all performance out of it, especially for fixed
reqs.

> handling follows this loop:
> 
> loop():
>  1) read() gets called by io_uring
>  2) save the userpointer and the length into a structure
>  3) go to sleep
>  4) get an IRQ from the device, with new data
>  5) dma/copy the data to the user
>  6) wake up read() and return
> 
> I guess at this point you see my problem.... What happens if I get an
> IRQ between 6 and 1?
> Even if there are plenty of read_operations waiting in the sqe, that
> data will be lost. :(

Frankly, that's not related to io_uring and more rather a device driver
writing question. That's not the right list to ask these questions.
Though I don't know which would suit your case...

> So I guess what I am asking is:
> 
> A) Am I doing something stupid?

In essence, since you're writing up your own driver from scratch
(not on top of some framework), all that stuff is to you to handle.
E.g. you may create a list and adding a short entry with an address
to dma on each IRQ. And then dma and serve them only when you've got
a request. Or any other design. But for sure there will be enough
of pitfalls on your way.

Also, I'd recommend first to make it work with old good read(2) first.

> 
> B) Is there a way for a driver to call a callback when it receives
> data and push it to a read operation on the cqe?

In short: No

After you fill an SQE (which is also just a chunk of memory), io_uring
gets it and creates a request, which in your case will call ->read*().
So you'd get a driver-visible read request (not necessarily issued by
io_uring)

> 
> C) Can I ask the io_uring to call read() more than once if there are
> more read_operations in the sqe?

"read_operations in the sqe" what it means?

> 
> D) Can the driver inspect what is in the sqe, to make an educated

No, and shouldn't be needed.

> decision of delaying the irq handling for some cycles if there are
> more reads pending?

-- 
Pavel Begunkov
