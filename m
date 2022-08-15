Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34576593031
	for <lists+io-uring@lfdr.de>; Mon, 15 Aug 2022 15:47:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229889AbiHONrL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 15 Aug 2022 09:47:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiHONrK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 15 Aug 2022 09:47:10 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10A3C205EE
        for <io-uring@vger.kernel.org>; Mon, 15 Aug 2022 06:47:08 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id bv3so9151362wrb.5
        for <io-uring@vger.kernel.org>; Mon, 15 Aug 2022 06:47:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=Ij2tqXS+eSkXBmqorG5dlTgDVOfrAMlACCYb8o/mabw=;
        b=bTNkHIXFjUwTyOV1Gy10mXmPcJXVwD/TT+RavYP+asN8kVVbaeOOXZkOXGfojViK/u
         Wlq3cCtL10j7EKcgS1vRsHoK0nyUaIzQ789KXia+Q6TEReu9/WXhK5hLlNetPdqN5uad
         Kg+EMGiWYUPo5+EpVN++Dn4JuvLYxzvzu317keyPFUz76hypplQawAtbyuMtUfy6/Rmx
         y9VfGdiJW1xThFfp+vi7pDqHXD0KQz2/0ZBsTFPQktDtlMnUSos/x+ydhraNrcVO9EcE
         7fCrjze8x2705lGtNuTzSvYQm6It+f7HOCGsxBa4s5aCxmvQ7xneebo0T7iUPpyUNM2T
         Un0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=Ij2tqXS+eSkXBmqorG5dlTgDVOfrAMlACCYb8o/mabw=;
        b=A/sO3sv7UQJ2dHyahKR7Eoj8Tm8sKt1T5L5gGc/9rUZLhdTA2WLlpHR2mFXTVa0jtX
         1jQE74GZ6jFWc3AW+i9s5IWBtJdMuXPOkL86iZd6eq1fWWXa/pWrj2WeLpp1UDOaEYQC
         Fopig8iHOuAWr+x2Pu0RXTx1Vqr9Wu5rzcpQOF+ndKDikHnW4rXAToeELHaahOrK6ZKK
         8Bqbf6E0872jktwLh5zXJ/JKLxLmcJIbIcinEf6PoGWnECyrPHkOLcziG6cQcvtCkVYJ
         2A4dkWRHzrZij0OBoRbmWLIhWDfeD30xk1aYlOC9Oc0SSB6MhKr9i5Yqo5NI4Xv9lLMO
         sj5Q==
X-Gm-Message-State: ACgBeo2mRvJb2uvGDqAcZFicGgm03NRTv7U1+l0A5DRfNeLogXTi56oJ
        d4hAXjsFfeMzdCDu7NCsCsw=
X-Google-Smtp-Source: AA6agR50A7utF1LEUOI/OfjMoY43JTM4hP/Fy98+WKqa7KHLVlx/XsUYRyfwd2z0SOC/TKrCYZq92A==
X-Received: by 2002:a05:6000:1564:b0:222:c6c4:b445 with SMTP id 4-20020a056000156400b00222c6c4b445mr8542924wrz.602.1660571226493;
        Mon, 15 Aug 2022 06:47:06 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::22ef? ([2620:10d:c092:600::2:886])
        by smtp.gmail.com with ESMTPSA id cl5-20020a5d5f05000000b00224f7c1328dsm5777291wrb.67.2022.08.15.06.47.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Aug 2022 06:47:06 -0700 (PDT)
Message-ID: <119c96ef-5231-7576-e92f-62b9b35e2f8c@gmail.com>
Date:   Mon, 15 Aug 2022 14:46:07 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH for-next 1/7] io_uring: use local ctx variable
Content-Language: en-US
To:     Dylan Yudaken <dylany@fb.com>, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org
Cc:     Kernel-team@fb.com
References: <20220815130911.988014-1-dylany@fb.com>
 <20220815130911.988014-2-dylany@fb.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20220815130911.988014-2-dylany@fb.com>
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

On 8/15/22 14:09, Dylan Yudaken wrote:
> small change to use the local ctx
> 
> Signed-off-by: Dylan Yudaken <dylany@fb.com>
> ---
>   io_uring/io_uring.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index ebfdb2212ec2..ab3e3d9e9fcd 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -1072,8 +1072,8 @@ void io_req_task_work_add(struct io_kiocb *req)
>   		req = container_of(node, struct io_kiocb, io_task_work.node);
>   		node = node->next;
>   		if (llist_add(&req->io_task_work.node,
> -			      &req->ctx->fallback_llist))
> -			schedule_delayed_work(&req->ctx->fallback_work, 1);
> +			      &ctx->fallback_llist))
> +			schedule_delayed_work(&ctx->fallback_work, 1);

Requests here can be from different rings, you can't use @ctx
from above

-- 
Pavel Begunkov
