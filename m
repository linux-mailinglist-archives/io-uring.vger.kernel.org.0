Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D09404932F1
	for <lists+io-uring@lfdr.de>; Wed, 19 Jan 2022 03:32:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350645AbiASCcg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 18 Jan 2022 21:32:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238636AbiASCcg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 18 Jan 2022 21:32:36 -0500
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38057C061574
        for <io-uring@vger.kernel.org>; Tue, 18 Jan 2022 18:32:36 -0800 (PST)
Received: by mail-io1-xd2e.google.com with SMTP id p7so1102333iod.2
        for <io-uring@vger.kernel.org>; Tue, 18 Jan 2022 18:32:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:from:to:references:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=D6B/fgC2MSIAqlf3Bm32Sp/DJo2rENOVnIMGvI7bvHk=;
        b=mXJaKoenRgkNgF5QEe72pslGwYno2UPSzL+4/H4J6jj6HGAQLjOC2p9dz2v5+mY/ch
         Qs/faMmLM4ofjTSToSz8+PEs1igxZyv7fVpcmAGeTPyOZEAvJ1N3tDbOKx5mdFIgTUtK
         vsmVrA6i+Fyc2apmRw+G9hcxGt5/l3yFD2o1Gze9ilbwXtRCMN3x2A3MgDPpbvijDoIy
         GXX6h2GLueH84KDojxHtAbujYrUnEUowkhYCOa1W0JGXRT2ij+bwGBdUajlcthQvDbhb
         HD7xxI2DzzIJ7FlwUn+qlgw9sFUoczHmPi0t/bu0+oJ5AL9fA7fiWogCJMRUxLvqx0cN
         maww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:from:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=D6B/fgC2MSIAqlf3Bm32Sp/DJo2rENOVnIMGvI7bvHk=;
        b=wPN0zaWuV/QYNh5v+zEYwbUjRxhcHy9G8C6GVh5nJqC7XFcKTXaMao4LGDNa+tZnzq
         76GyD/jsBnZBrAiNioUeJ2EK/jLLgc/hcDjMSa9LS/ejbgAYoW23mC0FIDMrw01Dee7L
         LiH/sbM2y6VhaJKOYIDHFBPbeKMm3QflfkgzJDJGHNYv56JKyaYRTzdgU+z45xXmVMui
         WZcGaU3yivO3DQGxUryjs3aoeIvA02u3/Nv8HGFJDT4q4W3vP1Z9G5xq5XSaGMilPVfK
         nGMx7J7I3TlEwDRjIcDjDNEZrrBa4rXFhlFkGZM0sBlOVspw1dAtpX2Oz2kxT0UrV7ap
         iItw==
X-Gm-Message-State: AOAM531y348jtJLHbrHE4BbniCvZXu1CnwRhK/r9V9HaIA1wodVyWryE
        LeE6DMLztU0/TMT7O11zlHxifK6o4GmufQ==
X-Google-Smtp-Source: ABdhPJwubRGKaOLijpvg8qaO1vHE1xjpUNPTO65b8Cp28zIXss1Ru2Fqp0MC9Hlg6uB7nmtHeBlQKA==
X-Received: by 2002:a05:6638:515:: with SMTP id i21mr7726015jar.23.1642559555535;
        Tue, 18 Jan 2022 18:32:35 -0800 (PST)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id x11sm6591693ill.78.2022.01.18.18.32.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Jan 2022 18:32:34 -0800 (PST)
Subject: Re: Canceled read requests never completed
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, flow@cs.fau.de
References: <20220118151337.fac6cthvbnu7icoc@pasture>
 <81656a38-3628-e32f-1092-bacf7468a6bf@kernel.dk>
 <20220118200549.qybt7fgfqznscidx@pasture>
 <1ec0f92c-117e-d584-f456-036d41348332@kernel.dk>
Message-ID: <21588bc9-592c-7793-c72a-498ba0db4937@kernel.dk>
Date:   Tue, 18 Jan 2022 19:32:34 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1ec0f92c-117e-d584-f456-036d41348332@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/18/22 4:36 PM, Jens Axboe wrote:
> On 1/18/22 1:05 PM, Florian Fischer wrote:
>>>> After reading the io_uring_enter(2) man page a IORING_OP_ASYNC_CANCEL's return value of -EALREADY apparently
>>>> may not cause the request to terminate. At least that is our interpretation of "…res field will contain -EALREADY.
>>>> In this case, the request may or may not terminate."
>>>
>>> I took a look at this, and my theory is that the request cancelation
>>> ends up happening right in between when the work item is moved between
>>> the work list and to the worker itself. The way the async queue works,
>>> the work item is sitting in a list until it gets assigned by a worker.
>>> When that assignment happens, it's removed from the general work list
>>> and then assigned to the worker itself. There's a small gap there where
>>> the work cannot be found in the general list, and isn't yet findable in
>>> the worker itself either.
>>>
>>> Do you always see -ENOENT from the cancel when you get the hang
>>> condition?
>>
>> No we also and actually more commonly observe cancel returning
>> -EALREADY and the canceled read request never gets completed.
>>
>> As shown in the log snippet I included below.
> 
> I think there are a couple of different cases here. Can you try the
> below patch? It's against current -git.

Cleaned it up and split it into functional bits, end result is here:

https://git.kernel.dk/cgit/linux-block/log/?h=io_uring-5.17

-- 
Jens Axboe

