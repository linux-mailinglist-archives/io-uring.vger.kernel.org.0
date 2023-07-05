Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 564FE7484BF
	for <lists+io-uring@lfdr.de>; Wed,  5 Jul 2023 15:16:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232190AbjGENQm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 5 Jul 2023 09:16:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232198AbjGENQk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 5 Jul 2023 09:16:40 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59FF5171A;
        Wed,  5 Jul 2023 06:16:35 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id a640c23a62f3a-992ca792065so716104766b.2;
        Wed, 05 Jul 2023 06:16:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1688562993; x=1691154993;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ky2bacl+8cb9+h1iNfSacu7+r2tigkvvezKA98Z6r80=;
        b=Yug/YH6yIbgbFD8TQRxdDuV7hjAcm2fJdWqB9qCXHpmhtn/cSWbWdw/uYAfBA5ILHm
         /GiYDADsUCyHUU0s+uCNkzcoNGGsC0kR+tGsmqsel8omJgoxYLzikdoa2hm3WvVge03d
         7DivqXx4oEJg0AxI3e7yaNDTUmARYrHEPu8RlwSZAE0rOwSLZDLRGIpAC9jGTaoY1dc+
         5GPalW7VxeA55kBHcdcLELj1pDyMSh9c7JJOvIKpWdwXLORUOATfBEHWvNAXhvoLGVhP
         ucVxBwbfzYXOpFCYbgWO1VLwnU88bU/wkyaHL1Su42vtwawE+CmDsOxSiY3VzGYD6MpQ
         9Zhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688562993; x=1691154993;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ky2bacl+8cb9+h1iNfSacu7+r2tigkvvezKA98Z6r80=;
        b=UGNlcAThOqLj0pLm+Qopu2qtEMmwfOHnOK7b0YOuIvxuXPneD9DvbACeQYyPBdy22E
         PvfdjbK1dR6a8/SqnvXyXnmXkEZB8gGcVWJc+pz7wI1LwGuM4cSXvC4VfJ6kIntgHJ40
         2qj6UoKw/qhlTpjzQcg2cdFWulJrqXjPuxR3Ukog/nsx3/3Kg8I5jokKnqTD48KA6wn2
         L4snb/Yy7nX2lTA14GFpTIuQkWrFRimE81hwY20m5CEsb7RM4Bc2Sg7CSEsuuJCPQ4nj
         KG4lSJ0NRq0ZayhxuNCmkh+08QHLPYPtwtkQhJTsafFMYNIFSGuPzff6eCZY51DmrFTP
         gf6g==
X-Gm-Message-State: ABy/qLb6POeGPZbd9TB5Hk7U36dxsNIKOoOHyR9F7BUWhs6SIDx/yFRG
        fOXHcQnQ5FG3TNyamdNOq2YuLWumdRU=
X-Google-Smtp-Source: APBJJlFakP97cPdcR8kQ+HsNs4RVg1WB+3eIzlytJVz3++ouiVppK4Q4amYL0PtxCskZ94j8eyHBeQ==
X-Received: by 2002:a17:906:edd2:b0:993:16b4:d5a5 with SMTP id sb18-20020a170906edd200b0099316b4d5a5mr10835595ejb.16.1688562993624;
        Wed, 05 Jul 2023 06:16:33 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::2eef? ([2620:10d:c092:600::2:4b35])
        by smtp.gmail.com with ESMTPSA id s17-20020a170906bc5100b009920a690cd9sm11038165ejv.59.2023.07.05.06.16.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Jul 2023 06:16:33 -0700 (PDT)
Message-ID: <0205607a-d909-069a-301a-d4479d535f17@gmail.com>
Date:   Wed, 5 Jul 2023 14:13:04 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 08/11] io_uring: add function to unregister fixed workers
Content-Language: en-US
To:     Hao Xu <hao.xu@linux.dev>, io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, Wanpeng Li <wanpengli@tencent.com>,
        linux-fsdevel@vger.kernel.org
References: <20230609122031.183730-1-hao.xu@linux.dev>
 <20230609122031.183730-9-hao.xu@linux.dev>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20230609122031.183730-9-hao.xu@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/9/23 13:20, Hao Xu wrote:
> From: Hao Xu <howeyxu@tencent.com>
> 
> Add a new register api to unregister fixed workers.
> 
> Signed-off-by: Hao Xu <howeyxu@tencent.com>
> ---
>   include/uapi/linux/io_uring.h |  3 +++
>   io_uring/io-wq.c              | 50 ++++++++++++++++++++++++++++++++++-
>   io_uring/io-wq.h              |  1 +
>   io_uring/io_uring.c           | 45 +++++++++++++++++++++++++++++++
>   4 files changed, 98 insertions(+), 1 deletion(-)
> 
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index 6dc43be5009d..b0a6e3106b42 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -538,6 +538,9 @@ enum {
>   	/* set/get number of fixed workers */
>   	IORING_REGISTER_IOWQ_FIXED_WORKERS      = 26,
>   
> +	/* destroy fixed workers */
> +	IORING_UNREGISTER_IOWQ_FIXED_WORKERS      = 27,

Do we need a new code? I think it's cleaner if we use
IORING_REGISTER_IOWQ_FIXED_WORKERS and do sth like

struct io_uring_fixed_worker_arg arg;

if (arg.nr_workers)
	do_unregister_fixed_workers();
...

-- 
Pavel Begunkov
