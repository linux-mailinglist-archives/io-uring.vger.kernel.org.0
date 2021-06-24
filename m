Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F25893B251D
	for <lists+io-uring@lfdr.de>; Thu, 24 Jun 2021 04:37:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229926AbhFXCkJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Jun 2021 22:40:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbhFXCkJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Jun 2021 22:40:09 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E839AC061756
        for <io-uring@vger.kernel.org>; Wed, 23 Jun 2021 19:37:50 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id b14so5980593iow.13
        for <io-uring@vger.kernel.org>; Wed, 23 Jun 2021 19:37:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nkwuDvE+HR2k4/KA2XLAmTJEvEnMjQTVG6B2OziO2Io=;
        b=XYpvJ2kG8oTbE/NQ+W5zRpVdMNFnE9aGmKRIzIsx0+HZK+yLW97TXDBlRvQYDPkGZx
         ygIhePJcvphFPv5PmOb1tqXA6s6fvRsm8hPq8Fi0udnVb2sCJyMDdDTJmeHpxRazdc17
         bP1WP2oqFR2mXAPBFnabeg9q8dBK0g5/m+V6Ashpzq5YXm8Z7DrNa5QHXP4WPtKGlj89
         l23tNhbl5Q3fbCYu8d+TRZ4N+DS5cSst5XNf+XaJNEOXrjLTikbfNG3o+f6ht4UxZCQS
         XvO3LsKVg3yvllfWEXtgbYB95/ehcTx0lnwKvGwVYnphpYDb/z+ugEwmb41VAfBqz23p
         Szcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nkwuDvE+HR2k4/KA2XLAmTJEvEnMjQTVG6B2OziO2Io=;
        b=tv49ERd6P+0wkmDrdtpeMKBhmk9aOgqBflsU9cznR7AY6wSyssVvL0APAk3I8Y0fmS
         ue0fI4hdNFEEWJJbIhVGhEAzZHTNMxq84XXFbOFwhA5ZIynzzYlfQhkCTlj/tin1uRaP
         z2I1BJZ+uKW+t3j5FvZtreFnQl3GIk7ABiyjKRoOnWSrzYJhSOSlsS2tooN19eWHnORS
         zZV526xjeOWon8Ds7EcAwRUsPKA9uS+I26eE38VGvBwNdm0pUyeP3pPDcgzE6iCf4JPE
         Rbl7rPsrPZHi1djX5FSmpRxWwe+tUU6X+XU4qEkUGohNkwsmSduvh+ul0HXDvlph6AaA
         6/vg==
X-Gm-Message-State: AOAM530mrwWVeLLe5haEp8BBqDbunKNdeXK2Bh4+VNojYHCnrbxI6XY0
        Ozn9haB8JFYspDAXRfrW7EZN6w3+GSttRw==
X-Google-Smtp-Source: ABdhPJyO1eFukgzlGGvAx8TjDVAbRx/xdCMSa3OgKVGIW3+Fs/vRyc+C9yDlWjbanO8eI+DMviQd+A==
X-Received: by 2002:a05:6602:140e:: with SMTP id t14mr2195622iov.42.1624502270199;
        Wed, 23 Jun 2021 19:37:50 -0700 (PDT)
Received: from [192.168.1.134] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id t10sm940681ilq.88.2021.06.23.19.37.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jun 2021 19:37:49 -0700 (PDT)
Subject: Re: [PATCH v5 00/10] io_uring: add mkdir, [sym]linkat and mknodat
 support
To:     Dmitry Kadashev <dkadashev@gmail.com>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        linux-fsdevel@vger.kernel.org, io-uring <io-uring@vger.kernel.org>
References: <20210603051836.2614535-1-dkadashev@gmail.com>
 <ee7307f5-75f3-60d7-836e-830c701fe0e5@gmail.com>
 <0441443f-3f90-2d6c-20aa-92dc95a3f733@kernel.dk>
 <b41a9e48-e986-538e-4c21-0e2ad44ccb41@gmail.com>
 <53863cb2-8d58-27a1-a6a4-be41f6f5c606@kernel.dk>
 <CAOKbgA4POGxPdB02NsCac4p6MtC97q6M3pT09_FWWj41Uf3K2A@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <43b17e64-4c56-93d3-1724-2673d5b639f3@kernel.dk>
Date:   Wed, 23 Jun 2021 20:37:47 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAOKbgA4POGxPdB02NsCac4p6MtC97q6M3pT09_FWWj41Uf3K2A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/22/21 11:49 PM, Dmitry Kadashev wrote:
> On Wed, Jun 23, 2021 at 12:32 AM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 6/22/21 11:28 AM, Pavel Begunkov wrote:
>>> On 6/22/21 6:26 PM, Jens Axboe wrote:
>>>> On 6/22/21 5:56 AM, Pavel Begunkov wrote:
>>>>> On 6/3/21 6:18 AM, Dmitry Kadashev wrote:
>>>>>> This started out as an attempt to add mkdirat support to io_uring which
>>>>>> is heavily based on renameat() / unlinkat() support.
>>>>>>
>>>>>> During the review process more operations were added (linkat, symlinkat,
>>>>>> mknodat) mainly to keep things uniform internally (in namei.c), and
>>>>>> with things changed in namei.c adding support for these operations to
>>>>>> io_uring is trivial, so that was done too. See
>>>>>> https://lore.kernel.org/io-uring/20210514145259.wtl4xcsp52woi6ab@wittgenstein/
>>>>>
>>>>> io_uring part looks good in general, just small comments. However, I
>>>>> believe we should respin it, because there should be build problems
>>>>> in the middle.
>>>>
>>>> I can drop it, if Dmitry wants to respin. I do think that we could
>>>> easily drop mknodat and not really lose anything there, better to
>>>> reserve the op for something a bit more useful.
>>>
>>> I can try it and send a fold in, if you want.
>>> Other changes may be on top
>>
>> Sure that works too, will rebase in any case, and I'd like to add
>> Christian's ack as well. I'll just re-apply with the fold-ins.
> 
> Jens, it seems that during this rebase you've accidentally squashed the
> "fs: update do_*() helpers to return ints" and
> "io_uring: add support for IORING_OP_SYMLINKAT" commits, so there is only the
> former one in your tree, but it actually adds the SYMLINKAT opcode to io uring
> (in addition to changing the helpers return types).

Man, I wonder what happened there. I'll just drop the series, so when you
resend this one (hopefully soon if it's for 5.14...), just make it
against the current branch.

-- 
Jens Axboe

