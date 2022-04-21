Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72D0B50A84C
	for <lists+io-uring@lfdr.de>; Thu, 21 Apr 2022 20:43:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352470AbiDUSqR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 Apr 2022 14:46:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386752AbiDUSqQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 Apr 2022 14:46:16 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 220FD4BFEA
        for <io-uring@vger.kernel.org>; Thu, 21 Apr 2022 11:43:22 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id r187-20020a1c44c4000000b0038ccb70e239so6449038wma.3
        for <io-uring@vger.kernel.org>; Thu, 21 Apr 2022 11:43:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=kTKYE5UFke3JiydCVjcYHfozz0oggRX38PeOi/RedoQ=;
        b=mS3p5PHffG9BnBHKwjlLwgxtDDo2gVzglqW08ahFq94HsZpN3+hgacmGHkkx5Mmytc
         uGnp+qQZNJPFOwUemAK/M34mnctq4kM56Ix4bsJNDS/D6SgB3Qt7UDq4wcwk+lbPAcPj
         y3R72Y0gbIjpmog2UCZnTA6jCt1fpsInTT0RgjhoKxarEyOo0umd57KMCRdL1GOPmLqw
         rL57ZUJQ5V9baqdZek3Kc1cV27IUz1bdXRRzdjMpuKW/8Tqu9R9ad3KJW5MCxnSOKkBU
         kUHDBjTLMtNT9s1AaPjHSVwvsnXiAYc/RCzWHRa9rW+Ke6JInSrSMTzLI8XPgbYsNona
         yODQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=kTKYE5UFke3JiydCVjcYHfozz0oggRX38PeOi/RedoQ=;
        b=0/GKVkXTma92AycM7ZMGBMJg/OLs2VPpDWnwYfA1C2aHliPH7Zo0x5Adh+iW1DSRGT
         bQgD+uR/s9dBcC2wnUn0lf71PSZaHhYf1cyET7TrLu4WSvI/CFNtjB/LbKprnHg603L7
         aUBv3/SgMtciwlEF1MfTCPyQNqqyFpBmG35uR1vETrpAU79ytsrN0g+ahufCv4U1RdGX
         qjLltYuuj7y41ITdgpX/dIpyF42XQLq+lnBeP5qrYrNiqOMGjYAn/5iiDbCxcpAuS0vK
         70MjcrmcVFPBrkL0JpUnpaIAsGvPvdpi+ge3e4p1UC+tDmqh20CzPkdJ+/uu9HuDpugh
         ugvw==
X-Gm-Message-State: AOAM532mg7ntD0+ylBIx8K0bMOfDg4udAgb4Fap2wFXPCV00Ub3FYsM6
        gyjgh3zuWTCW7FrxNLdnKPI=
X-Google-Smtp-Source: ABdhPJzO5wae/qbq/1LcnlIfIWWhkFY34IYPKCs98eaevzbKr2R7U76uFKxtVppT65X1MV5DX5ESkA==
X-Received: by 2002:a05:600c:4f55:b0:38f:f897:28d1 with SMTP id m21-20020a05600c4f5500b0038ff89728d1mr642224wmq.97.1650566600639;
        Thu, 21 Apr 2022 11:43:20 -0700 (PDT)
Received: from [192.168.8.198] ([148.252.129.201])
        by smtp.gmail.com with ESMTPSA id j16-20020adfff90000000b0020947cf914bsm2793607wrr.31.2022.04.21.11.43.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Apr 2022 11:43:20 -0700 (PDT)
Message-ID: <5676b135-b159-02c3-21f8-9bf25bd4e2c9@gmail.com>
Date:   Thu, 21 Apr 2022 19:42:42 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v2 00/12] add large CQE support for io-uring
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, kernel-team@fb.com,
        io-uring@vger.kernel.org, shr@fb.com
References: <20220420191451.2904439-1-shr@fb.com>
 <165049508483.559887.15785156729960849643.b4-ty@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <165049508483.559887.15785156729960849643.b4-ty@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/20/22 23:51, Jens Axboe wrote:
> On Wed, 20 Apr 2022 12:14:39 -0700, Stefan Roesch wrote:
>> This adds the large CQE support for io-uring. Large CQE's are 16 bytes longer.
>> To support the longer CQE's the allocation part is changed and when the CQE is
>> accessed.
>>
>> The allocation of the large CQE's is twice as big, so the allocation size is
>> doubled. The ring size calculation needs to take this into account.

I'm missing something here, do we have a user for it apart
from no-op requests?


> Applied, thanks!
> 
> [01/12] io_uring: support CQE32 in io_uring_cqe
>          commit: be428af6b204c2b366dd8b838bea87d1d4d9f2bd
> [02/12] io_uring: wire up inline completion path for CQE32
>          commit: 8fc4fbc38db6538056498c88f606f958fbb24bfd
> [03/12] io_uring: change ring size calculation for CQE32
>          commit: d09d3b8f2986899ff8f535c91d95c137b03595ec
> [04/12] io_uring: add CQE32 setup processing
>          commit: a81124f0283879a7c5e77c0def9c725e84e79cb1
> [05/12] io_uring: add CQE32 completion processing
>          commit: c7050dfe60c484f9084e57c2b1c88b8ab1f8a06d
> [06/12] io_uring: modify io_get_cqe for CQE32
>          commit: f23855c3511dffa54069c9a0ed513b79bec39938
> [07/12] io_uring: flush completions for CQE32
>          commit: 8a5be11b11449a412ef89c46a05e9bbeeab6652d
> [08/12] io_uring: overflow processing for CQE32
>          commit: 2f1bbef557e9b174361ecd2f7c59b683bbca4464
> [09/12] io_uring: add tracing for additional CQE32 fields
>          commit: b4df41b44f8f358f86533148aa0e56b27bca47d6
> [10/12] io_uring: support CQE32 in /proc info
>          commit: 9d1b8d722dc06b9ab96db6e2bb967187c6185727
> [11/12] io_uring: enable CQE32
>          commit: cae6c1bdf9704dee2d3c7803c36ef73ada19e238
> [12/12] io_uring: support CQE32 for nop operation
>          commit: 460527265a0a6aa5107a7e4e4640f8d4b2088455
> 
> Best regards,

-- 
Pavel Begunkov
