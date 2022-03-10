Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFA804D3ED2
	for <lists+io-uring@lfdr.de>; Thu, 10 Mar 2022 02:36:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbiCJBhn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Mar 2022 20:37:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232808AbiCJBhl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Mar 2022 20:37:41 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21AEA1275EB
        for <io-uring@vger.kernel.org>; Wed,  9 Mar 2022 17:36:41 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id e2so3508450pls.10
        for <io-uring@vger.kernel.org>; Wed, 09 Mar 2022 17:36:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=Y8+ehtFJJiePMQxGafSfUqd1ycIQvjf/gQ1D9tm1yFs=;
        b=agfoIgmBDmcV7Rp+Xi7JB2oCh15Y2GRMVx0EaFpfXUTUee89aV77abIwXPwlzMbgYq
         aQ0Za6NIklpT9QU8ENQ66BSqRkpa+nLU6y3TYMO11unJBskt6z71z3cIt8FfmLnvk3En
         /80cUoZRkVX2O/phu2R5KoF/uyNhBVP+TpxKSMDKDU/GxaRNEyCiAtYgktO4fKRmqCxk
         fsvarIKIAX68kQdK/ZdFAp9rdM1zwVLM3mTz1Uf81q14Sf2MDjj3bMht2/+6rCf9A3LH
         S8I2rD5gdYXihHchRw6A1FzG3UA9rgkQ92OY+skN2392Ht0m1f6Wt3f3sb8bx6KTZibk
         IGrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Y8+ehtFJJiePMQxGafSfUqd1ycIQvjf/gQ1D9tm1yFs=;
        b=Sd/Nq2sJrOBaoq7iof8Mjk+5AvrZw822If65ItBfIX3MgxmnjbRIEulN2gQ1Fntl2v
         PPzZIcP7QxzleLHqZfhGITVrkqwOtkmpq1j87KfMhmK4w4vM9PyjaZfUnyaQUd39ldk3
         IdVrSVivmB0149oaTZX2FnfsT7Yo+02umXxuwOR2f81ZHYL/k86N5ZPLUGFjLGilc2iB
         dXidUy5ZmmN5/649cvnXk82AJZkeb4nAnkfxZQVLrdvqr4oJwWLUptO8z3mjzO9hENJs
         9jR3MWEoWs5BBT1DAmRlFXOBOCzOHloBXZfzFrtEoDwu0FSIZ58dClAzwAqYu9/1UK/Y
         LdPg==
X-Gm-Message-State: AOAM533OKv6UIebwvrEs2JTGdA60x6CYUjylPBDMsdHLJJ2JVjY3HVSB
        WBTM01vBEUk8iVU2kOK9/uhvuprKmK1ww/Zr
X-Google-Smtp-Source: ABdhPJxv/qAHPn7HUjAlcpTpJMb2i1cf6nlI+OcUCMv9A1/wJ3S/eNcr24mVABR6OVPf+d8pZg8jsw==
X-Received: by 2002:a17:90a:19d2:b0:1be:d815:477f with SMTP id 18-20020a17090a19d200b001bed815477fmr2457469pjj.23.1646876200508;
        Wed, 09 Mar 2022 17:36:40 -0800 (PST)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id z72-20020a627e4b000000b004f70cbcb06esm4328390pfc.49.2022.03.09.17.36.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Mar 2022 17:36:40 -0800 (PST)
Message-ID: <e31e5b96-5c20-d49b-da90-db559ba44927@kernel.dk>
Date:   Wed, 9 Mar 2022 18:36:39 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: Sending CQE to a different ring
Content-Language: en-US
To:     Artyom Pavlov <newpavlov@gmail.com>, io-uring@vger.kernel.org
References: <bf044fd3-96c0-3b54-f643-c62ae333b4db@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <bf044fd3-96c0-3b54-f643-c62ae333b4db@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/9/22 4:49 PM, Artyom Pavlov wrote:
> Greetings!
> 
> A common approach for multi-threaded servers is to have a number of
> threads equal to a number of cores and launch a separate ring in each
> one. AFAIK currently if we want to send an event to a different ring,
> we have to write-lock this ring, create SQE, and update the index
> ring. Alternatively, we could use some kind of user-space message
> passing.
> 
> Such approaches are somewhat inefficient and I think it can be solved
> elegantly by updating the io_uring_sqe type to allow accepting fd of a
> ring to which CQE must be sent by kernel. It can be done by
> introducing an IOSQE_ flag and using one of currently unused padding
> u64s.
> 
> Such feature could be useful for load balancing and message passing
> between threads which would ride on top of io-uring, i.e. you could
> send NOP with user_data pointing to a message payload.

So what you want is a NOP with 'fd' set to the fd of another ring, and
that nop posts a CQE on that other ring? I don't think we'd need IOSQE
flags for that, we just need a NOP that supports that. I see a few ways
of going about that:

1) Add a new 'NOP' that takes an fd, and validates that that fd is an
   io_uring instance. It can then grab the completion lock on that ring
   and post an empty CQE.

2) We add a FEAT flag saying NOP supports taking an 'fd' argument, where
   'fd' is another ring. Posting CQE same as above.

3) We add a specific opcode for this. Basically the same as #2, but
   maybe with a more descriptive name than NOP.

Might make sense to pair that with a CQE flag or something like that, as
there's no specific user_data that could be used as it doesn't match an
existing SQE that has been issued. IORING_CQE_F_WAKEUP for example.
Would be applicable to all the above cases.

I kind of like #3 the best. Add a IORING_OP_RING_WAKEUP command, require
that sqe->fd point to a ring (could even be the ring itself, doesn't
matter). And add IORING_CQE_F_WAKEUP as a specific flag for that.

-- 
Jens Axboe

