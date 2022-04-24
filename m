Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5606450D20C
	for <lists+io-uring@lfdr.de>; Sun, 24 Apr 2022 15:30:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234047AbiDXNdH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 24 Apr 2022 09:33:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233855AbiDXNdF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 24 Apr 2022 09:33:05 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D020A64E7
        for <io-uring@vger.kernel.org>; Sun, 24 Apr 2022 06:30:03 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id b15so12477864pfm.5
        for <io-uring@vger.kernel.org>; Sun, 24 Apr 2022 06:30:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=+EVahnp1bGvFGQTMwnnFK2kHuo+sjJWL3aUYVED+/xE=;
        b=cQkQLhtIUytQ1j4/ySOTyFsoHuDHp3jzTwa87hc/rFC2ijQUxRZFsY29RDVxtqsokY
         f6kSaS1lCe2AHrwTkajU/2CiNzW6sRJW1La/xVQlGj6Q0Y4WHeUiB+VeV4Si0wy+e7lW
         xUeoFW78CvEHRNozNzOOTFTLA+bC7jeCSQfihCJoKd4plkOXMmuZ0uD1LYqys6i56cty
         IFvJMKtB6fO2PI+jECOUEC3o7ipJAFQ5uHHTDiujCYOMH9UKyKXJwsRkHWaygovfd1Ce
         5Xie3jQY55aqOv7GNdEAHkdbKIS5uTFJ02ilRzB56KwIo12OW78USl88qHtEbX6GIUmI
         N26w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=+EVahnp1bGvFGQTMwnnFK2kHuo+sjJWL3aUYVED+/xE=;
        b=usEwjxOYnqP78H6JT2qpPtSgmWMema0mCLOGxxEzdx9ILK4N84OHR+Rie3pJ9fuZhW
         WfFtj6EqZTXpl8weSyS8klUbAsZewYgCLv4KDRdSckjQVa0WUS3NnaOfwuUCv62Fecdd
         YFi1hNd6XDdl6Zw6nqRq5LgU08+HP3FOiWymtEwulL617iYCEkf+jhAuwMlvOtK0vEeD
         WtT8RDUd7H0vYEr8Lao7rpHXn5So31yx3OH8Bd0jued0NlFtEU+qRhgE41aCAI80sX54
         MJWn2texTWrN4psfHhMxdMnAxBuR/jfQXwyUJUS23Oax9nBnYxFw6pnUx2FXDlocJUAz
         T2xw==
X-Gm-Message-State: AOAM530dxrXi+0azIaWWxSkEUNYd7jmYGYjKxMDxoR39AFyB5CHLSQy/
        VK11PvoBL2tsxMqIsLljzts4cYdPRI5qwy0K
X-Google-Smtp-Source: ABdhPJxz4lDfet4LRcUFvlF6XJvPVyKXdK75whr9S+Byj2Dlrtd+PjPZBRtyP5H8rLnlwQzGHmMIzw==
X-Received: by 2002:a05:6a00:234f:b0:4f6:f0c0:ec68 with SMTP id j15-20020a056a00234f00b004f6f0c0ec68mr14495236pfj.14.1650807003159;
        Sun, 24 Apr 2022 06:30:03 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id y3-20020a056a00190300b004fa2411bb92sm9091511pfi.93.2022.04.24.06.30.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 24 Apr 2022 06:30:02 -0700 (PDT)
Message-ID: <d4321b8e-7d6a-7279-5e89-7e688a087a36@kernel.dk>
Date:   Sun, 24 Apr 2022 07:30:01 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: memory access op ideas
Content-Language: en-US
To:     Avi Kivity <avi@scylladb.com>, io-uring@vger.kernel.org
References: <e2de976d-c3d1-8bd2-72a8-a7e002641d6c@scylladb.com>
 <17ea341d-156a-c374-daab-2ed0c0fbee49@kernel.dk>
 <c03c4041-ed0f-2f6f-ed84-c5afe5555b4f@scylladb.com>
 <1acd11b7-12e7-d31b-775a-4f62895ac2f7@kernel.dk>
 <ee3f7e59-e7a1-9638-cb9a-4b2c15a5f945@scylladb.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ee3f7e59-e7a1-9638-cb9a-4b2c15a5f945@scylladb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/24/22 7:04 AM, Avi Kivity wrote:
> 
> On 23/04/2022 20.30, Jens Axboe wrote:
>> On 4/23/22 10:23 AM, Avi Kivity wrote:
>>> Perhaps the interface should be kept separate from io_uring. e.g. use
>>> a pidfd to represent the address space, and then issue
>>> IORING_OP_PREADV/IORING_OP_PWRITEV to initiate dma. Then one can copy
>>> across process boundaries.
>> Then you just made it a ton less efficient, particularly if you used the
>> vectored read/write. For this to make sense, I think it has to be a
>> separate op. At least that's the only implementation I'd be willing to
>> entertain for the immediate copy.
> 
> 
> Sorry, I caused a lot of confusion by bundling immediate copy and a
> DMA engine interface. For sure the immediate copy should be a direct
> implementation like you posted!
>
> User-to-user copies are another matter. I feel like that should be a
> stand-alone driver, and that io_uring should be an io_uring-y way to
> access it. Just like io_uring isn't an NVMe driver.

Not sure I understand your logic here or the io_uring vs nvme driver
reference, to be honest. io_uring _is_ a standalone way to access it,
you can use it sync or async through that.

If you're talking about a standalone op vs being useful from a command
itself, I do think both have merit and I can see good use cases for
both.

>>   For outside of io_uring, you're looking at a sync
>> interface, which I think already exists for this (ioctls?).
> 
> 
> Yes, it would be a asynchronous interface. I don't know if one exists,
> but I can't claim to have kept track.

Again not following. So you're saying there should be a 2nd async
interface for it?

>>> The kernel itself should find the DMA engine useful for things like
>>> memory compaction.
>> That's a very different use case though and just deals with wiring it up
>> internally.
>>
>> Let's try and keep the scope here reasonable, imho nothing good comes
>> out of attempting to do all the things at once.
>>
> 
> For sure, I'm just noting that the DMA engine has many different uses
> and so deserves an interface that is untied to io_uring.

And again, not following, what's the point of having 2 interfaces for
the same thing? I can sort of agree if one is just the basic ioctl kind
of interface, a basic sync one. But outside of that I'm a bit puzzled as
to why that would be useful at all.

-- 
Jens Axboe

