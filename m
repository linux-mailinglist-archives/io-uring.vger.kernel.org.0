Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C710554C615
	for <lists+io-uring@lfdr.de>; Wed, 15 Jun 2022 12:29:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237457AbiFOK3D (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Jun 2022 06:29:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348426AbiFOK2j (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Jun 2022 06:28:39 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 727FC1835C
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 03:28:34 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id a10so6054640wmj.5
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 03:28:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=0+l1D+JoEorjY09g4z4FPIC6C4TNzkomigqLUkVqKzA=;
        b=O7ktvNw/Lcqut+a/FmEoYWQcKUfgkbVIY+GQqqkKsLF0JvT9w0iEIkf8wy7+7ihPNP
         cPs24uQgh8GvTmyZ9jr8ilXdb14bQ+ZQ17DkjpDNwDft8LXZoh0WhI0Se/WZtAue7eOF
         jk0fnaH/YL+XXTaWZbUXEiP6VSrx5eUcyNbO+nbSIat/OPQgX0iSPkexwAqVEjdCN9Cu
         t3sr8U7adbWwQR3CFs6izcRk20cBBRm89MLmf46ZGJ1Ea5bqmaEqJrRfuox6Pvad5QBE
         8vOTHVFXw35tdJunrrBAoeAXuXT/jLop2mhKff+9QwJg/VVp69TeoW6NwU+gqE0tVnH1
         huhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=0+l1D+JoEorjY09g4z4FPIC6C4TNzkomigqLUkVqKzA=;
        b=Yo+slVvTyJQDUaW/CU2nTF5QFi/tcNbZv14iwPZAekRVwpdVllLShtpH7SlRZKMuQ2
         bbR2PArfE+mlectTa2q95Nz6N5QwVrL3DnR92X2iNqgwrqXAkjMQMue+wcY0yxigoAQx
         WSEX7sU8cSgCgkO1qSCUTVymZaHfZbkk4f8k3dnH/ECy4P0mx1CxYRHuItme2Q6Aj/zx
         Fugy4XuW0GtiDy7KzYyejP5G86ZA3AbYct7hFMNtZrl4MsxFHIjxf+RiVfB8seBrmqzZ
         A67DBmKXio+yJbAg52rjsuGjY0OZ/4plGG7viba7vQe27SYt+5ZTPsDpCjQbKVtfoNRG
         2b3A==
X-Gm-Message-State: AOAM533w9alyq4jrlNvYNWeTnw2X1LacH05lZfnX1MfNAR8H/a7ScZ+m
        ghEkVzUrB0tjd+WUuYUAqsEvO1f4/mfjcw==
X-Google-Smtp-Source: ABdhPJzO0ZSHBhVz/ZX2BYI8PB27zO3djcUBmOuGeZKaqN4tN74syqL07l9nxNPvTFpcvT3STI5Syg==
X-Received: by 2002:a05:600c:58a:b0:39c:80ed:68be with SMTP id o10-20020a05600c058a00b0039c80ed68bemr9115385wmd.150.1655288912600;
        Wed, 15 Jun 2022 03:28:32 -0700 (PDT)
Received: from [192.168.8.198] (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id i9-20020adfb649000000b0020fe35aec4bsm13921978wre.70.2022.06.15.03.28.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jun 2022 03:28:32 -0700 (PDT)
Message-ID: <6bf7ce15-f317-3d39-30f1-eb189b7ed1f4@gmail.com>
Date:   Wed, 15 Jun 2022 11:28:12 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH liburing 1/3] io_uring: update headers with
 IORING_SETUP_SINGLE_ISSUER
Content-Language: en-US
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
References: <cover.1655213733.git.asml.silence@gmail.com>
 <b5e78497efd3a50bcc75f5d9aab1992375952c93.1655213733.git.asml.silence@gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <b5e78497efd3a50bcc75f5d9aab1992375952c93.1655213733.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/15/22 11:05, Pavel Begunkov wrote:
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>

Something did go wrong here... just ignore it,
the v2 sent yesterday is up to date.

> ---
>   src/include/liburing/io_uring.h | 5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_uring.h
> index 15d9fbd..ee6ccc9 100644
> --- a/src/include/liburing/io_uring.h
> +++ b/src/include/liburing/io_uring.h
> @@ -137,9 +137,12 @@ enum {
>    * IORING_SQ_TASKRUN in the sq ring flags. Not valid with COOP_TASKRUN.
>    */
>   #define IORING_SETUP_TASKRUN_FLAG	(1U << 9)
> -
>   #define IORING_SETUP_SQE128		(1U << 10) /* SQEs are 128 byte */
>   #define IORING_SETUP_CQE32		(1U << 11) /* CQEs are 32 byte */
> +/*
> + * Only one task is allowed to submit requests
> + */
> +#define IORING_SETUP_SINGLE_ISSUER	(1U << 12)
>   
>   enum io_uring_op {
>   	IORING_OP_NOP,

-- 
Pavel Begunkov
