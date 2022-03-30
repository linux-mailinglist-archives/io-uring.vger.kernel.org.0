Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 678914EC4A5
	for <lists+io-uring@lfdr.de>; Wed, 30 Mar 2022 14:41:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345592AbiC3Mnf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 30 Mar 2022 08:43:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345218AbiC3Mn3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 30 Mar 2022 08:43:29 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71E5C29FC5F
        for <io-uring@vger.kernel.org>; Wed, 30 Mar 2022 05:35:10 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id i11so9040342plg.12
        for <io-uring@vger.kernel.org>; Wed, 30 Mar 2022 05:35:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=yLI0Y4xd3BYkjRhIkD+4rgkVCO00sjLNZ4pzlr4ppgc=;
        b=y40Gn3+93CF48xPWSCumw/l5oZymWA85DwTjF/0mUV5S4/GqhXlLTckmV/vM0fFxVr
         MnL1NBHUyzplbDsFykXYkeYAovcJ+LfNUM9yb+hgcig2A95mg+7hKmb7bKFcav/Br2JS
         2eE+WvIPi8utpZrK7LLDvK8aS4cAi9B4gNguv7nCKGlY+okZk2oyQFj0zrglNtgwTK5q
         3LAOFyrLA2/FReZe3MCXwvfCN9Dwhr7k5XF8wRNGJbm8zmSXxD0ODXhUuEpz/EiplN8D
         aOUg4qU7T+RVRNrb10AT43LSBePfjUuDkctG/aidg/q4xamEODFKxjE9QkpMt2TWPN9Z
         NVzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=yLI0Y4xd3BYkjRhIkD+4rgkVCO00sjLNZ4pzlr4ppgc=;
        b=cPR/9EMiD7deU2txRfzJJh7sWaq40447sndV+ax+NGXKhSf9b8G4KnP8sho4IBbpeA
         Zp0ZkK8Epn8WUzCNAaNMNVLOEEFYM7XKYSJItflNOQteyYj784Apm/PVHwddtksltU6G
         qyRMlrFJ9E1EGP5ck/Jo1z0YupxEKm5b7J0+rDYPdBjP2x3sWV6KjMlecenpJ31s9tUx
         1Gz6Z8KkbtbXt1sT5Rvjdg5Ry+WKGGmMS7ji72eEQIzsX8dnOZRtfKcOFpTGiClAAzj3
         6ALNeLp7+LAQymrcj8ad48BbNqpX9qOfsl95DuTEhOXHuL2zi12Cwl3vdi21bY7YGDfj
         ZxPg==
X-Gm-Message-State: AOAM530OcSJadCyVhDTWilmIT4z96DxwHyrjCunYtCQZS7A/D3DUgZXY
        bhqYWrtRPgctPKyXYrQZCRY/kaNepZkQzWge
X-Google-Smtp-Source: ABdhPJzsk1FsDBqHnQEdkR3A5j7qIeo8vPhlueEkOCMqWgT2w/AMu2DFBNL+3WyAWkdjEQJ9jlZw+g==
X-Received: by 2002:a17:90a:bb0d:b0:1bd:3baf:c8b4 with SMTP id u13-20020a17090abb0d00b001bd3bafc8b4mr4873237pjr.15.1648643709568;
        Wed, 30 Mar 2022 05:35:09 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id s135-20020a63778d000000b0038259e54389sm18686800pgc.19.2022.03.30.05.35.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Mar 2022 05:35:09 -0700 (PDT)
Message-ID: <52dca413-61b3-8ded-c4cc-dd6c8e8de1ed@kernel.dk>
Date:   Wed, 30 Mar 2022 06:35:08 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: io_uring_prep_openat_direct() and link/drain
Content-Language: en-US
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     io-uring@vger.kernel.org
References: <CAJfpegvVpFbDX5so8EVaHxubZLNQ4bo=myAYopWeRtMs0wa6nA@mail.gmail.com>
 <8145e724-d960-dd85-531e-16e564a02f05@kernel.dk>
 <c8872b69-f042-dc35-fa3d-6862f09a5385@kernel.dk>
 <CAJfpegs1o3HNkpxPa85LmNCoVVk-T2rt3vJXBvRf_M93P+6ouA@mail.gmail.com>
 <115fc7d1-9b9c-712b-e75d-39b2041df437@kernel.dk>
 <CAJfpegs=GcTuXcor-pbhaAxDKeS5XRy5rwTGXUcZM0BYYUK2LA@mail.gmail.com>
 <89322bd1-5e6f-bcc6-7974-ffd22363a165@kernel.dk>
 <CAJfpegtr+Bo0O=i9uShDJO_=--KAsFmvdzodwH6qF7f+ABeQ5g@mail.gmail.com>
 <0c5745ab-5d3d-52c1-6a1d-e5e33d4078b5@kernel.dk>
 <CAJfpegtob8ZWU1TDBoUf7SRMQJhEcEo2sPUumzpNd3Mcg+1aog@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAJfpegtob8ZWU1TDBoUf7SRMQJhEcEo2sPUumzpNd3Mcg+1aog@mail.gmail.com>
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

On 3/30/22 2:18 AM, Miklos Szeredi wrote:
> On Tue, 29 Mar 2022 at 22:03, Jens Axboe <axboe@kernel.dk> wrote:
> 
>> Can you try and repull the branch? I rebased the top two, so reset to
>> v5.17 first and then pull it.
> 
> This one works in all cases, except if there's a link flag on the
> read.  In that case the read itself will succeed but following
> requests on the link chain will fail with -ECANCELED.

That sounds like you're asking for more data than what is being read,
in which case the link should correctly break and cancel the rest.
That's expected behavior, a short read is not a successful read in that
regard.

-- 
Jens Axboe

