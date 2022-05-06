Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC95951DA93
	for <lists+io-uring@lfdr.de>; Fri,  6 May 2022 16:32:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234940AbiEFOgC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 6 May 2022 10:36:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346332AbiEFOgB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 6 May 2022 10:36:01 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D2BA69294
        for <io-uring@vger.kernel.org>; Fri,  6 May 2022 07:32:18 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id i17so7601637pla.10
        for <io-uring@vger.kernel.org>; Fri, 06 May 2022 07:32:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=IKnXMed6jjWK05WYFoholdPPT2WTMXKXyNFJA5ty2Dk=;
        b=0kcU7geC2AF508oHhQS9Aw5hC5iqBBoisB+DWdgDAmQYPIJ2O/4jUueZ78D02Yd2LQ
         OUN1VDfPfgyoRSDtWDQK8jb3VfQXYCRR4IzNQYQ3ut427FFO7QTLye+05E9x9zEXhr2F
         wlJ102s3dIPqTpCCTth4dsluVPd3FdGvhpJUl6NVrBAnEZIS1cwbij+kmqjxuab3grqE
         ti4uAHJY1Gce2w08VRZb4Tug+1v1RNH5/X/e6Ib7dRPhvSyGY+9ta/Eja+uyQ67Mfv0h
         K3XaKKIDr2asH+uZLMvaFbwmplP2XJCqIUDiFbqTtALM+5WISexAHhuyzz/kMigmsI5D
         o0OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=IKnXMed6jjWK05WYFoholdPPT2WTMXKXyNFJA5ty2Dk=;
        b=gt4fv6EXV79wJ2qtGfttalIX+rPKbVqQ602hF7RaypwHqPny6Y+l6/ygeg20V+944s
         XdILjACx0/47+jdfYbN1QgDx66imIPVdonMqE/7lHb8dn+Rce46wrKITHFLE15FknFq3
         v3PTG+zuRvDPoFyF2/vrWcVLgCWd6wSh7pFKD6cVVdV4s6FwoDoxoo/eDEdm25Uu00HT
         1wHfsVygnI4d56UoKTn2j44/L44/3vdY3fNhg5Rr7AZs6PiRmyKqE9bz24Us0azb+8Jk
         6Zjgnmi4ZGUElTD/plHB5U+zM4U3ltQGsysDOe4zUtdzTlyjrSkXAyy0iFDAUU34rnuM
         xMPQ==
X-Gm-Message-State: AOAM533r0cyW+4epiU5TP4/mdU+KzqIT8WJGbHMVxjrM0Uic0d43cVfp
        0Wi1j5bXaOJ+0NVXiDwz7WLQgg==
X-Google-Smtp-Source: ABdhPJwVyFybgmdHBomugJ71MT4xk5tQqyokCS5kc4G+IAjCk8YTvnuhoAqBC71a7VwwMtOibv+lAg==
X-Received: by 2002:a17:903:2ca:b0:156:f1cc:7cb6 with SMTP id s10-20020a17090302ca00b00156f1cc7cb6mr3939764plk.174.1651847537881;
        Fri, 06 May 2022 07:32:17 -0700 (PDT)
Received: from [192.168.4.166] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id w5-20020a170902ca0500b0015e8d4eb285sm1773280pld.207.2022.05.06.07.32.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 May 2022 07:32:17 -0700 (PDT)
Message-ID: <b60eb1c5-4836-5f62-315e-211a0fe03362@kernel.dk>
Date:   Fri, 6 May 2022 08:32:16 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH 1/5] io_uring: add IORING_ACCEPT_MULTISHOT for accept
Content-Language: en-US
To:     Hao Xu <haoxu.linux@gmail.com>, io-uring@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        linux-kernel@vger.kernel.org
References: <20220506070102.26032-1-haoxu.linux@gmail.com>
 <20220506070102.26032-2-haoxu.linux@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220506070102.26032-2-haoxu.linux@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/6/22 1:00 AM, Hao Xu wrote:
> From: Hao Xu <howeyxu@tencent.com>
> 
> add an accept_flag IORING_ACCEPT_MULTISHOT for accept, which is to
> support multishot.
> 
> Signed-off-by: Hao Xu <howeyxu@tencent.com>
> ---
>  include/uapi/linux/io_uring.h | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index fad63564678a..73bc7e54ac18 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -213,6 +213,11 @@ enum {
>  #define IORING_ASYNC_CANCEL_FD	(1U << 1)
>  #define IORING_ASYNC_CANCEL_ANY	(1U << 2)
>  
> +/*
> + * accept flags stored in accept_flags
> + */
> +#define IORING_ACCEPT_MULTISHOT	(1U << 15)

It isn't stored in accept_flags, is it? This is an io_uring private
flag, and it's in ioprio. Which is honestly a good place for per-op
private flags, since nobody really uses ioprio outside of read/write
style requests. But the comment is wrong :-)

-- 
Jens Axboe

