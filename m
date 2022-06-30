Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A66D3561621
	for <lists+io-uring@lfdr.de>; Thu, 30 Jun 2022 11:20:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234242AbiF3JTg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Jun 2022 05:19:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234363AbiF3JSy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Jun 2022 05:18:54 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5CDA41313
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 02:18:12 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id d2so26015199ejy.1
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 02:18:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=sApA87lduuQzneHtAJklrRjnVfPZzDvObIxcRLbX5c8=;
        b=bJ3/Ac19Mns/RctbqhlZ9moQaxR530DyjhGTvL6Tpw+IHKveEH9YVg28mJk/NRDHM9
         BOSWpxAQcnUz6fe4pyK/h02r3MSPmNj58cjfxSURm1Sut+GWsyCP84TUUot93qdQNm/V
         /Tx2ZA9vZVi4cQgxxRID+XIN732Yvfbfo7c8lgvkcp97TqG4qPPts70zsbXdkXg08dsh
         wuUbIu8rf0gagiNZ9ipEBxJ0MoM/1FhgUYdtAATKTjx96dqI3gTGO0yO7moX2sHcAmvK
         3jzjwzGx+Th3rjAXRK+u0ZBOS8LyJIB/WDU0hK12GQn4kvJh3L3CCz2B754rYCMwV7Sg
         1dBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=sApA87lduuQzneHtAJklrRjnVfPZzDvObIxcRLbX5c8=;
        b=4K68yolaEP29hi8PilLTXjqJN9iewz/slt/eFsEUd33YdJs8vkux9DNTI4a4+xtQj5
         fL1ArntApm1YH1wykZIzEv2j7WX69FHdLznAWp6KjNW3QV5X10dab9093r24bsQQxFuI
         NbA+NcpMA2ONTQygKb/npxIhSqtOJDWsGY9D8rNARbcclIIk7RB5QYfIUzv890qu5zLt
         73AfZQ88cKdyjzm3sp9P2mc1qzV+AiIfGHuFAD61lE4n4yvk9stDQm0Fe/lVna1e3bSM
         VKuD1w9bManLjtmRAFThe8el3C4t5yBek1gEZwT/fpTihVU7CN8uAD5uOmrlVbCd9QYT
         6Qsw==
X-Gm-Message-State: AJIora/SkRq2Ta2kp81fWQ9ZnpEZnBY4WEtNGQax3BXHCflXhL9WnzVs
        6MvudY9ZtRgnCnjpwcxWCXGW7Haax8uuoQ==
X-Google-Smtp-Source: AGRyM1t74vM3MDYjMpVBBVvTZqaTBzvVhdDXvpiP+Q5HbWvlgCeMz3VpLBbt/otE67LGDsUX4OJd0g==
X-Received: by 2002:a17:906:cc87:b0:722:fb3e:9f9c with SMTP id oq7-20020a170906cc8700b00722fb3e9f9cmr7707410ejb.624.1656580691199;
        Thu, 30 Jun 2022 02:18:11 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::26ef? ([2620:10d:c092:600::2:a3ae])
        by smtp.gmail.com with ESMTPSA id k18-20020a056402049200b0042dcbc3f302sm11370283edv.36.2022.06.30.02.18.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jun 2022 02:18:10 -0700 (PDT)
Message-ID: <6f30d707-e7fc-17a4-1c70-4b636201ec50@gmail.com>
Date:   Thu, 30 Jun 2022 10:18:05 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH for-next 0/3] ranged file slot alloc
Content-Language: en-US
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
References: <cover.1656580293.git.asml.silence@gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1656580293.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/30/22 10:13, Pavel Begunkov wrote:
> Add helpers and test ranged file slot allocation feature

s/for-next/liburing/ in the subject


> 
> Pavel Begunkov (3):
>    update io_uring.h with file slot alloc ranges
>    alloc range helpers
>    test range file alloc
> 
>   src/include/liburing.h          |   3 +
>   src/include/liburing/io_uring.h |  10 ++
>   src/register.c                  |  14 +++
>   test/file-register.c            | 171 ++++++++++++++++++++++++++++++++
>   4 files changed, 198 insertions(+)
> 

-- 
Pavel Begunkov
