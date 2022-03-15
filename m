Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4506B4DA43D
	for <lists+io-uring@lfdr.de>; Tue, 15 Mar 2022 21:51:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351820AbiCOUwU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 15 Mar 2022 16:52:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351817AbiCOUwT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 15 Mar 2022 16:52:19 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B596554BC
        for <io-uring@vger.kernel.org>; Tue, 15 Mar 2022 13:51:07 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id w7so217046ioj.5
        for <io-uring@vger.kernel.org>; Tue, 15 Mar 2022 13:51:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=RgWAMLFv+tmtHhtXg2VeXD6gCZhvEGGnUzKqtvwRlBs=;
        b=PDyoBXAtwbBXWLbIJf7SAPJhDCJmeYpfIn/wWVdDrN2ZAIlH/4AbsilEfMNRv9WMEI
         amA+kuveqgduZRI8vHu/O06+IH2S2lrEoJS8x9yQ/7hWuazQU+TX5sNhDa/htYhuUcGd
         /6QQJN872IgR5/ciLLy2LQXouT3pwunLRRYs2Ner12snxCTh0om5mPqa4lIhVbr0GYwW
         z27T58iq7RCAkODj985mip4GP2I8FoBDI+PmrAWDLWE9Vf0s7CU1298EUcUqMAN/lLLM
         abjbTaSXGi5pY56Xe+mGkAh4WBtvC3tyemUP3vDVydaOby+A3ifEtCltPETohke0QBHU
         EEog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=RgWAMLFv+tmtHhtXg2VeXD6gCZhvEGGnUzKqtvwRlBs=;
        b=XNukiL+ck1qq/OZfnwc3BxvxJXA2vUcA4241Q57FKBJoil1T1grgr7aPv5CP1zaO2S
         UmzZAdDVMq1lL5/KGPTvDqkSyZHL6KQVEikUeMFTncEN7ssdPYTBFAYPmFW3BkH9gmvq
         tn3Cowchm8jMNP1TDGcZJ97BEPIoULjA9rXzlnMth5Ao1yxUC3XDpEIN5sRE6PJufYif
         f8cDRnzBF9IaYscYfHeLbdvEDIy6ibVopUkIzsEbIAeOgb8wC8oi0NGdqxga3/BTbQmv
         xKQG1E93VwmH6UHItNnR6E+5/RMnAZBLmQcweILAPDHuhTNdeKpOJ/lJ4zDx9Dy9NsDZ
         Kmqg==
X-Gm-Message-State: AOAM533DHz5MN1pzHWQzknjTisO1LO2xxx62v8No1HI5dILGbov+8pUh
        uivzenmHnFebVf5OXjaNv7uvEE4z5XNL6OUQ
X-Google-Smtp-Source: ABdhPJxzVqNG4TRQmPArX1wQCNZTlM/pIkJeAtYPVEFY9eTo9fiit2EarjeSxK0U5tpfRn++GCPE9g==
X-Received: by 2002:a05:6638:1382:b0:31a:1caa:5755 with SMTP id w2-20020a056638138200b0031a1caa5755mr2952747jad.199.1647377466629;
        Tue, 15 Mar 2022 13:51:06 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id h20-20020a056602009400b00640d0a52c17sm14229iob.2.2022.03.15.13.51.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Mar 2022 13:51:06 -0700 (PDT)
Message-ID: <6ddf5f6b-98f5-9e64-8451-19e548fa290c@kernel.dk>
Date:   Tue, 15 Mar 2022 14:51:05 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Subject: Re: [PATCH] io_uring: make tracing format consistent
Content-Language: en-US
To:     Dylan Yudaken <dylany@fb.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
Cc:     kernel-team@fb.com
References: <20220315204829.2908979-1-dylany@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220315204829.2908979-1-dylany@fb.com>
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

On 3/15/22 2:48 PM, Dylan Yudaken wrote:
> Make the tracing formatting for user_data and flags consistent.
> 
> Having consistent formatting allows one for example to grep for a specific
> user_data/flags and be able to trace a single sqe through easily.
> 
> Change user_data to be %llu everywhere, and flags to be %u. Additionally
> remove the '=' for flags in io_uring_req_failed, again for consistency.

Shouldn't we rather make flags be %x everywhere? Doesn't make a lot of
sense to have a flag based value be in decimal.

Ditto on user_data actually, I would guess the most common use case is
stuffing an address in there. And if it's a masked value, then it's
easier to read in hex too.

Hmm?

-- 
Jens Axboe

