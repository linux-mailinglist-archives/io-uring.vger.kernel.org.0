Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C8626BA4ED
	for <lists+io-uring@lfdr.de>; Wed, 15 Mar 2023 02:56:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229765AbjCOB4o (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Mar 2023 21:56:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbjCOB4o (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Mar 2023 21:56:44 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37BE453D8F
        for <io-uring@vger.kernel.org>; Tue, 14 Mar 2023 18:56:43 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id h12-20020a17090aea8c00b0023d1311fab3so350066pjz.1
        for <io-uring@vger.kernel.org>; Tue, 14 Mar 2023 18:56:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1678845402; x=1681437402;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=i5IH03pQZjwk7lRVaB0AtmwortHKqQqoh+2hh3e3YH4=;
        b=ySTInQCS6j25INrSTRESAw5vZUdUaY4O87QkAel2y9D9rWytLhPR8chlcsKzTzhXfT
         woc/EJKJB383heVDRflus+/uuNoBD2CTcEfFbJB5y42XWF0WE6LL67DRgsEE8f1dLVCF
         61E+pnEHTgjLPStbtBYdn7TmTQV24EFmDYSgLXF5JjLq3RGUeqbppoHcO/4YFo/E6+HO
         yybgW4L04X/nfwE111japN0vkyxwLX3wgU6ToE/zKjP1zOqp8GeRq8LMQPb1yrLBB7hQ
         grzMWmDqIul0c2k+fnDlHwjeBdH116MRZ8ytzY1P0jZGCOCHq977hCIJFsdZTQaDwZRp
         B4Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678845402; x=1681437402;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=i5IH03pQZjwk7lRVaB0AtmwortHKqQqoh+2hh3e3YH4=;
        b=qeoflxsrRAixNByTA49yKxemePXcnYfQggWE2NxwCJb9ewvZ82xFtKQ2I4l/BOXx5x
         pPVuBjH2436s4kEdakVSj7XWCri9GrnRLgh7uDG+vcqzUWdiDN3NY8IPhbWQD0fcSAmQ
         uiNhGYI2qGEpYZVlsP1Mk3dIDw5eVfVJN7/Tzcfgk5N8+7mI0fjuokkWGAATU4dQf16b
         Cpw+z6hK5H0J7keb6zVhc/CNdP4m95SfMt0TWsc8628EOif78zm7YOppI2n+AcGAVi7K
         DgSy5JCd+0qZ9f5tJejVHuSjdopBNHdi6n2kE0O4pMu+xj+Y0um5SuM1dWXHtb7PW2Pq
         pZWw==
X-Gm-Message-State: AO0yUKV3m2XhBbxHVcrioLHm7M24vmo5RNuA0tSf61QOAb5Cq7qNn5US
        qq6N1HmkJh9cW5feuB8utAFE7A==
X-Google-Smtp-Source: AK7set+cVL5tyx6fOgkY3foB4lrF0Z22+CBQkavE9m6h4Zwg7gjTLHGtoBdkukMcYv+wezMc8gD8TA==
X-Received: by 2002:a17:903:2c1:b0:1a0:7663:731b with SMTP id s1-20020a17090302c100b001a07663731bmr1184444plk.5.1678845402661;
        Tue, 14 Mar 2023 18:56:42 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id le8-20020a170902fb0800b0019f3e339fb4sm2365408plb.187.2023.03.14.18.56.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Mar 2023 18:56:42 -0700 (PDT)
Message-ID: <516dc8a8-ea4e-2294-3776-31a2625910b5@kernel.dk>
Date:   Tue, 14 Mar 2023 19:56:41 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH] io_uring: rsrc: Optimize return value variable 'ret'
Content-Language: en-US
To:     Li zeming <zeming@nfschina.com>, asml.silence@gmail.com
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230316181303.6583-1-zeming@nfschina.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230316181303.6583-1-zeming@nfschina.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/16/23 12:13 PM, Li zeming wrote:
> The function returns here and returns ret directly. It may look better.

I think it'd be better to just initialize 'ret' to 0 instead.

-- 
Jens Axboe


