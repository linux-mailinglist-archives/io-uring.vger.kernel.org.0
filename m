Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB53360794D
	for <lists+io-uring@lfdr.de>; Fri, 21 Oct 2022 16:13:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231383AbiJUONN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Oct 2022 10:13:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231360AbiJUONM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 Oct 2022 10:13:12 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6882827BB2F
        for <io-uring@vger.kernel.org>; Fri, 21 Oct 2022 07:13:11 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id p6so2461407plr.7
        for <io-uring@vger.kernel.org>; Fri, 21 Oct 2022 07:13:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=y0NTODMfudUNzVZhqqkbyUH2w4rIFr8Jh/nz9kcJg7s=;
        b=t8r1RZJlj8zGFrHigKV4EmaFkf2gwzobgfqE20UCawL7CKBXM0PGsJANOmYFiHLTxF
         U6s3VEMkjgXc5B21pDDbAQtyQ5U6+lT9Lb61MRY1OKN+5kldsFePFANpSINE8y6MY08I
         GhOAVlHP04HHYRLSMs6AbwAAnl1gDTEENFIBdi7hYglYrHBjoWsrRSUt9GPN1Xpf2H/7
         hNEcJ16d4BwCE5GApv29dJn2RnBM9ylLsTbIB7twCUc4+7VVJVrw+5U5M7rwuTLf6lC4
         ANLMlb6SLd4HLwYnv4PYD5svHC57/kTWZfEZOpr7FDd6Mt0Gx+bYcOmiLensS2Gwp57w
         o22Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=y0NTODMfudUNzVZhqqkbyUH2w4rIFr8Jh/nz9kcJg7s=;
        b=sSJmoo2X4f19a9vwn1WASOi700gvXCO51kRI7152BV7SInaIVf/femU32CZI5M487A
         AenwWZ6UgjGQwUy7o4twCSzeQ9OGyGgRGT2Gpi/hHk8tR49OuKWr1qVGt36nivnZ2iyQ
         QQUF9alwIfn7xbxDPiKa1OQCpvtdhXsr8Fn9a1li7i3Q5InSMDqc/9I1O29/FgAeIqiF
         WGp2xTvJ9hbZ7iJOikIHzmpeZ/P5HW55gNLAFkL47MJNyKkBwA0gwmGW8i92WLSIDgnF
         TUclkauYFQdzLQWH64ImvCoEuadtynmdwufjXhKn0060XYHU71q24ujhchayaPwDoCAy
         LL3g==
X-Gm-Message-State: ACrzQf2wUtpgmL5FfN1lc06VvbsOmzLpoG3LKczJjgsjWigRCA1Vdlqa
        r0IEin4wV+IMkCHbDzCiBT/JlRtUm7sZNVbn
X-Google-Smtp-Source: AMsMyM7aISNDp6MXWhosCZCWix7lK8yFn0RBWusVFCtmitcUos06a0M64aVBauZ+yb1k5g09C4OMwg==
X-Received: by 2002:a17:902:ef4c:b0:186:6399:6b48 with SMTP id e12-20020a170902ef4c00b0018663996b48mr8837924plx.128.1666361590861;
        Fri, 21 Oct 2022 07:13:10 -0700 (PDT)
Received: from [192.168.4.201] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id i6-20020a628706000000b00553b37c7732sm15148813pfe.105.2022.10.21.07.13.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Oct 2022 07:13:10 -0700 (PDT)
Message-ID: <54995d78-5e82-119b-bd98-bcabaeab9a7f@kernel.dk>
Date:   Fri, 21 Oct 2022 07:13:09 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Subject: Re: [PATCH liburing 0/3] improve sendzc man pages
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1666357688.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <cover.1666357688.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/21/22 6:10 AM, Pavel Begunkov wrote:
> Add a note about failing zc requests with -EOPNOTSUPP and add a paragraph
> about IORING_RECVSEND_FIXED_BUF.
> 
> Pavel Begunkov (3):
>   io_uring_enter.2: add sendzc -EOPNOTSUPP note
>   io_uring_enter.2: document IORING_RECVSEND_POLL_FIRST
>   io_uring_enter.2: document IORING_RECVSEND_FIXED_BUF
> 
>  man/io_uring_enter.2 | 98 +++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 96 insertions(+), 2 deletions(-)

Applied with minor edits, thanks!

-- 
Jens Axboe


