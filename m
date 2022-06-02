Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0581753B48A
	for <lists+io-uring@lfdr.de>; Thu,  2 Jun 2022 09:47:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231890AbiFBHrn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 2 Jun 2022 03:47:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231852AbiFBHrm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 2 Jun 2022 03:47:42 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1BE31C2052
        for <io-uring@vger.kernel.org>; Thu,  2 Jun 2022 00:47:40 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id h5so5373325wrb.0
        for <io-uring@vger.kernel.org>; Thu, 02 Jun 2022 00:47:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=9kdMgzSp/zK4XvFrabmbmRZg12uCf3858qxXGwAU0cU=;
        b=PFNJNTA87IOCDhrW3/l/NwQNA6jwdVkbiAXLWvLuNEY60NW8N0PZkJCexuXZVNw0q8
         +3mivkQPgmEh/KWakNv2h2WvK+XnOYVeB1WNERgA5D1mfStggP4jQ1Anc4+DVBA9b9TO
         0HdTEDFsDRrkkpbv6n9Vf80AgTP2eMSp0fI+BAr4hicZXn3iI7tR55sfNEEfCXy/svs7
         7uhBnU94JvVzua11hxDZvfbLnKPqCh95jR0dB5ngPafxtF8pvNYitqWbaatbX10wIy2U
         aWHhEA4T5Fbum1ST3sb9RfdXRQHEahzWd3+josZpnpvBkCXTRsTRCT9vJY7ALO7A4pIr
         Psww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=9kdMgzSp/zK4XvFrabmbmRZg12uCf3858qxXGwAU0cU=;
        b=YaYi2pjNIyDpMRW9py0QbmTSNHWIqB7GgD4qRTdXmyMerecdX5Dgd+pmDbj8F+onmR
         R5VB4RsyzgVk84xPvb5Vy2kj0fj8HPiQO8E1fWMVFL6CzmYcm37mycDOHqbP/pccwuJ6
         OKF+i4v8s7Ik6dkbSX0WGUPBnsgXtV6eoWPUfRvwe9B7hXvLkD9jRS8hxy5WYE8IhOZM
         ZEpR4yztEtaRI2a+qmopNfVAqV87kQsSCm/nXII8pelUWQ+Wr6uWfN1qltLWSUFvaLUm
         e7WtFnXPUzWUjjHQTTrGXIez3vnBh0uzVToI406Lfi/sOprSYNHe/ytiQJekBBEqCm5Y
         uDcQ==
X-Gm-Message-State: AOAM533eRweX5lxOOHIGC3qfm6dbz8+kG76F4lBON79+rMoRJaMg1Uaw
        8TXTvrOn5vq1IbuMAwTy647m7g==
X-Google-Smtp-Source: ABdhPJwZ2W6qYjAzEYw/UNnt2Cpq7X1kA43QSCreWUXMta5Zt9NBJrgMDyBFeBFYCx4T7SWbzQh3Mg==
X-Received: by 2002:a05:6000:34f:b0:210:346c:1df3 with SMTP id e15-20020a056000034f00b00210346c1df3mr2578894wre.292.1654156059446;
        Thu, 02 Jun 2022 00:47:39 -0700 (PDT)
Received: from [10.40.36.78] ([193.52.24.5])
        by smtp.gmail.com with ESMTPSA id v5-20020a5d4b05000000b0020d0c37b350sm4309277wrq.27.2022.06.02.00.47.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Jun 2022 00:47:38 -0700 (PDT)
Message-ID: <1647636f-007e-2912-c2d9-7fed172ca352@kernel.dk>
Date:   Thu, 2 Jun 2022 01:47:38 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH] io_uring: Remove redundant NULL check before kfree
Content-Language: en-US
To:     cgel.zte@gmail.com
Cc:     asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, Minghao Chi <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
References: <20220602071841.278214-1-chi.minghao@zte.com.cn>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220602071841.278214-1-chi.minghao@zte.com.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/2/22 1:18 AM, cgel.zte@gmail.com wrote:
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 1fc0166d9133..d1fe967f2343 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -4445,8 +4445,7 @@ static int io_read(struct io_kiocb *req, unsigned int issue_flags)
>  	kiocb_done(req, ret, issue_flags);
>  out_free:
>  	/* it's faster to check here then delegate to kfree */
> -	if (iovec)
> -		kfree(iovec);
> +	kfree(iovec);
>  	return 0;
>  }

There is _literally_ a comment right above your change that explains why
this is there. Please read surrounding code, at least.

-- 
Jens Axboe

