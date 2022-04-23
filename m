Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 301C350CC93
	for <lists+io-uring@lfdr.de>; Sat, 23 Apr 2022 19:30:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229956AbiDWRdv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 23 Apr 2022 13:33:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236599AbiDWRdu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 23 Apr 2022 13:33:50 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEB615BD33
        for <io-uring@vger.kernel.org>; Sat, 23 Apr 2022 10:30:51 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id h12so14069748plf.12
        for <io-uring@vger.kernel.org>; Sat, 23 Apr 2022 10:30:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=ejkC3bNKbW5VJmyXqz8z+2lndZy9EQv2UEyV+pJ2N34=;
        b=5o6uESre8QWszpNB/aSj3m8cXKUpjYIxajuKv7qo+XELjyye10U5SyqC98cfG+5Aqp
         IyoyKc4sAaH/9AdNJTorsCz0fGX12FEUNIOAWhIVkVPDIxf4vxjIspFmpgfGYF56A5w3
         vYKFdtD51yt2suRScUugPtXRc5/TbfndEoIWa76loF2rGQ7Kxp8XKOeO7NN4T/N02UdU
         vvVkDxGtpkj1/I2Ao23LYkfRXcCxDhfXcHR1CPuRLpvULTjHMyEKUOplMFQyxcc0XWQe
         G9X/SOZxGWjzBMCGgJcBHlYy5HIu99EMuWcqo7df8cL1F77a4nI4jH6B4o0c/CXiYg5T
         Z16w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ejkC3bNKbW5VJmyXqz8z+2lndZy9EQv2UEyV+pJ2N34=;
        b=Om28J6rfh9kdTH2t2UJ0KppLmMJ6DPPOwxkq/bOup0K1KK6nLOLRtZUIlCPXC0uUrW
         N8edW0RMGzNO786qggiZKIc+SAUOzZx82eWsZWoT/y24/3uKyPPMoeXxcNP/uUpVf/7r
         bwFcknda2yXlur4xXYzBJcqz5BW87BCTmeSlIcaWgM8q/Ei6qqXYs1ft92A6vclQIkeO
         vFsXXc2N31AZ4bLSBDELAuOed0nPC+oePUk4dfF5MB5IgqbWGMKW7pzWu0xWiraHyGxS
         ImtQRHwfi/IZxz2nBByccLcCAMAlO2zVa83v3xlo+f2JusI4G8bOz0wqW4VaQjRjWTOd
         /4yQ==
X-Gm-Message-State: AOAM530dA4iomsqhHyAJZhxCDaFXS2KahpsUSg7vDGlqugje1P22sEb1
        fCw8p0Q0vltfuTY+3qhyQRPhSg==
X-Google-Smtp-Source: ABdhPJzXL65K0OCI46VDBMw6iFRhjMT3hTyy4OxhSSluZmGBRk5WBHrQkGcSY3Gfka2ptR/prIh5Qg==
X-Received: by 2002:a17:90b:110a:b0:1d2:bde4:e277 with SMTP id gi10-20020a17090b110a00b001d2bde4e277mr11572075pjb.188.1650735051143;
        Sat, 23 Apr 2022 10:30:51 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id x2-20020a17090aa38200b001cb6527ca39sm9961278pjp.0.2022.04.23.10.30.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 23 Apr 2022 10:30:50 -0700 (PDT)
Message-ID: <1acd11b7-12e7-d31b-775a-4f62895ac2f7@kernel.dk>
Date:   Sat, 23 Apr 2022 11:30:49 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: memory access op ideas
Content-Language: en-US
To:     Avi Kivity <avi@scylladb.com>, io-uring@vger.kernel.org
References: <e2de976d-c3d1-8bd2-72a8-a7e002641d6c@scylladb.com>
 <17ea341d-156a-c374-daab-2ed0c0fbee49@kernel.dk>
 <c03c4041-ed0f-2f6f-ed84-c5afe5555b4f@scylladb.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <c03c4041-ed0f-2f6f-ed84-c5afe5555b4f@scylladb.com>
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

On 4/23/22 10:23 AM, Avi Kivity wrote:
> Perhaps the interface should be kept separate from io_uring. e.g. use
> a pidfd to represent the address space, and then issue
> IORING_OP_PREADV/IORING_OP_PWRITEV to initiate dma. Then one can copy
> across process boundaries.

Then you just made it a ton less efficient, particularly if you used the
vectored read/write. For this to make sense, I think it has to be a
separate op. At least that's the only implementation I'd be willing to
entertain for the immediate copy.

> A different angle is to use expose the dma device as a separate fd.
> This can be useful as dma engine can often do other operations, like
> xor or crc or encryption or compression. In any case I'd argue for the
> interface to be useful outside io_uring, although that considerably
> increases the scope. I also don't have a direct use case for it,
> though I'm sure others will.

I'd say that whoever does it get to at least dictate the initial
implementation. For outside of io_uring, you're looking at a sync
interface, which I think already exists for this (ioctls?).

> The kernel itself should find the DMA engine useful for things like
> memory compaction.

That's a very different use case though and just deals with wiring it up
internally.

Let's try and keep the scope here reasonable, imho nothing good comes
out of attempting to do all the things at once.

-- 
Jens Axboe

