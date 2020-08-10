Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D01724125D
	for <lists+io-uring@lfdr.de>; Mon, 10 Aug 2020 23:28:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726806AbgHJV26 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 10 Aug 2020 17:28:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726778AbgHJV25 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 10 Aug 2020 17:28:57 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF04AC061756
        for <io-uring@vger.kernel.org>; Mon, 10 Aug 2020 14:28:57 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id c10so533719pjn.1
        for <io-uring@vger.kernel.org>; Mon, 10 Aug 2020 14:28:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7ovusC5ymRilGnca285N5N6IQ0jcb5m4vBETi0CdHc0=;
        b=vTlTK94VXh2YfUxx03dmgoaT384TMX27RddIZMQD4S6rDDEHGACcG2UTnunJ2klzhE
         652c0izG8oH4dsOMxaHWHKr7MgGlwffN35MBFEnpX4LNqRDenvKyHDrYwTdeJ7fE0fwU
         YHiF0aSDhQjb4ccLBswSJGCgjMlmUJ6byKpxKbp7gQp0lsEx7vrmXVQHOhVc3XnYP7vf
         3FcObBBAYp7oJ6IJAcmB9rIqS2Thj5xbzZa6SRW1gHLASRntHKWsmQQqR57q0d/6MRuy
         vPueLkumdC1DJWXuM3Q31z83M2y8zli9aKPhJ0o+NDyC7ozyBfrsiPsuE4KbdeLmQWeq
         Tdmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7ovusC5ymRilGnca285N5N6IQ0jcb5m4vBETi0CdHc0=;
        b=F+ZhKGNwnITv6epEA2V+zp/y0H78J1JPUVodre4+1W4oN7kxfyBSX2pY9rDvS3fYxG
         hQOxpnTkM2MmKdJXibGpZo3nXK5YlVdFDwLeoMEQ+DDqUtK4IN+2x9ZDBOlcDtqQCkyO
         IrdmR+NauW3CKWKXd5OGLV98cWQGbu0AXz4Lo4Ro2C8psF0GEqJB4yNDkRC/BHYf5dvR
         he1omKmr/O0+DF7zTIINv5U+zrPP3wKzj5hL4Ttf7LEjZ2+kkrYoUh62jsnbJy3huLNR
         p+OdKuPq5OOGGu8q1Ay/2AEW/WryQp+j2VrPZ5VPgRpwnKQQASXcSIKb2ROZejVwlFAV
         Uz7Q==
X-Gm-Message-State: AOAM533xqtflLJDgMMwwa7aO0aPQTTI9GIQlwOC6fsTW+nmEH5+EcPyn
        0geAjpA5VRlhFZZsxuHd2EUEKQ==
X-Google-Smtp-Source: ABdhPJztuFS3a4EHf3IGZ078xB8d6jRgxZYd6JyfYGiTf+X+r3/pQsr1AJVEtGzQlKCaNetVdc38HA==
X-Received: by 2002:a17:90a:c7cb:: with SMTP id gf11mr1276529pjb.108.1597094937348;
        Mon, 10 Aug 2020 14:28:57 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id 124sm23777870pfb.19.2020.08.10.14.28.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Aug 2020 14:28:56 -0700 (PDT)
Subject: Re: [PATCH 2/2] io_uring: use TWA_SIGNAL for task_work if the task
 isn't running
To:     Jann Horn <jannh@google.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        io-uring <io-uring@vger.kernel.org>,
        stable <stable@vger.kernel.org>, Josef <josef.grieb@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>
References: <20200808183439.342243-1-axboe@kernel.dk>
 <20200808183439.342243-3-axboe@kernel.dk>
 <20200810114256.GS2674@hirez.programming.kicks-ass.net>
 <a6ee0a6d-5136-4fe9-8906-04fe6420aad9@kernel.dk>
 <07df8ab4-16a8-8537-b4fe-5438bd8110cf@kernel.dk>
 <20200810201213.GB3982@worktop.programming.kicks-ass.net>
 <4a8fa719-330f-d380-522f-15d79c74ca9a@kernel.dk>
 <faf2c2ae-834e-8fa2-12f3-ae07f8a68e14@kernel.dk>
 <CAG48ez0+=+Q0tjdFxjbbZbZJNkimYL9Bd5odr0T9oWwty6qgoQ@mail.gmail.com>
 <03c0e282-5317-ea45-8760-2c3f56eec0c0@kernel.dk>
 <20200810211057.GG3982@worktop.programming.kicks-ass.net>
 <5628f79b-6bfb-b054-742a-282663cb2565@kernel.dk>
 <CAG48ez2dEyxe_ioQaDC3JTdSyLsdOiFKZvk6LGP00ELSfSvhvg@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <1629f8a9-cee0-75f1-810a-af32968c4055@kernel.dk>
Date:   Mon, 10 Aug 2020 15:28:55 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAG48ez2dEyxe_ioQaDC3JTdSyLsdOiFKZvk6LGP00ELSfSvhvg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/10/20 3:26 PM, Jann Horn wrote:
> On Mon, Aug 10, 2020 at 11:12 PM Jens Axboe <axboe@kernel.dk> wrote:
>> On 8/10/20 3:10 PM, Peter Zijlstra wrote:
>>> On Mon, Aug 10, 2020 at 03:06:49PM -0600, Jens Axboe wrote:
>>>
>>>> should work as far as I can tell, but I don't even know if there's a
>>>> reliable way to do task_in_kernel().
>>>
>>> Only on NOHZ_FULL, and tracking that is one of the things that makes it
>>> so horribly expensive.
>>
>> Probably no other way than to bite the bullet and just use TWA_SIGNAL
>> unconditionally...
> 
> Why are you trying to avoid using TWA_SIGNAL? Is there a specific part
> of handling it that's particularly slow?

Not particularly slow, but it's definitely heavier than TWA_RESUME. And
as we're driving any pollable async IO through this, just trying to
ensure it's as light as possible.

It's not a functional thing, just efficiency.

-- 
Jens Axboe

