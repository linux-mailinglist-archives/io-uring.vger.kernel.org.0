Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5163041ADA0
	for <lists+io-uring@lfdr.de>; Tue, 28 Sep 2021 13:11:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240161AbhI1LMt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 28 Sep 2021 07:12:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239450AbhI1LMr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 28 Sep 2021 07:12:47 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1090FC061575
        for <io-uring@vger.kernel.org>; Tue, 28 Sep 2021 04:11:07 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id q127-20020a1ca785000000b0030cb71ea4d1so2452620wme.1
        for <io-uring@vger.kernel.org>; Tue, 28 Sep 2021 04:11:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nu36SwEXmL+H8czZHP/1KuU6l6R503rc3SU55iq6a3g=;
        b=iV5pROT9gaEJTI0De4XehhEwq913mOQKzf44DOzM9o5pdkTKmn21eZiL6yPHMhnTH2
         mxoYK7gbwd2d1xZeAJPxvzK+H5Q5/Ifn2l/68sQLuavTVDmb6pICE3gBNvMhL/aUH3oP
         aHlHkF12s1S8u+/PEn/l+TVIcejqLcCDLUUZxG4ZlqtLV0d8pcmrX+WBI0ryP9EuN4GR
         fNB1WBRF0IUQl1JAXxv8B3PDd33og8pY1RCA+wkcO8Nas2IsrhjlH2yL5IRHP3FeSULV
         QYyrpBtUkb5h5DhD/+HGo2q89maqvhxz+S0ETdlVWbUZ0Yf9KJ9HkeNenejMEYaJGyFS
         IdCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nu36SwEXmL+H8czZHP/1KuU6l6R503rc3SU55iq6a3g=;
        b=2i8x6LRq/Wom/WuRqkVmN/7bNRuWBYP1yW3GOHwIiRcqfAjprhC0D+xZ2QBC1sACB2
         B3qbYIGOJ7B8mgO4WKHUAopnjRGYI2K3F8J5tsa5dXni0/sBM8wZnUwCi0OF+eN/KaoB
         yyTfnHDJCvNGFn+S+cfDHz9VMY3f6J4VJ3RMsIVxNCOmVcLNBfFg9DzY4aEQyDsg4LuQ
         vAnxfcOg5ww+wY3Ioxxc4b+Mr0rYCPvpa+nN3+u7VT2gYXX1k4sUHgFfeqDkfVCDvXk3
         JXlCzv4DGYJ07pftO5vCFokhXdTGVppUEX1OMM9E/7o0cYiQZ07sF2pXMXgMRYRiJwbr
         syXg==
X-Gm-Message-State: AOAM5333vNB/6KwumGb+J7skOuAu/P/2adDuvTWcVHGFHKZTnsQKA6uO
        2J43d07szksEWSJwgA+5/QY93pMCkXc=
X-Google-Smtp-Source: ABdhPJwZjY2aDfPSDNQktjKokMLGB8F+fwwn/E8nrA1qv7rrPOG14XsLNpkfVQZEXZVfy+5coLQ3+g==
X-Received: by 2002:a05:600c:21d6:: with SMTP id x22mr4137807wmj.121.1632827465687;
        Tue, 28 Sep 2021 04:11:05 -0700 (PDT)
Received: from [192.168.8.197] ([185.69.144.229])
        by smtp.gmail.com with ESMTPSA id j14sm19140743wrp.21.2021.09.28.04.11.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Sep 2021 04:11:05 -0700 (PDT)
Subject: Re: [PATCH 2/8] io-wq: add helper to merge two wq_lists
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210927061721.180806-1-haoxu@linux.alibaba.com>
 <20210927061721.180806-3-haoxu@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <e01e512d-2666-ae0d-2e26-ca5368f58aae@gmail.com>
Date:   Tue, 28 Sep 2021 12:10:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210927061721.180806-3-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/27/21 7:17 AM, Hao Xu wrote:
> add a helper to merge two wq_lists, it will be useful in the next
> patches.
> 
> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
> ---
>  fs/io-wq.h | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
> 
> diff --git a/fs/io-wq.h b/fs/io-wq.h
> index 8369a51b65c0..7510b05d4a86 100644
> --- a/fs/io-wq.h
> +++ b/fs/io-wq.h
> @@ -39,6 +39,26 @@ static inline void wq_list_add_after(struct io_wq_work_node *node,
>  		list->last = node;
>  }
>  
> +/**
> + * wq_list_merge - merge the second list to the first one.
> + * @list0: the first list
> + * @list1: the second list
> + * after merge, list0 contains the merged list.
> + */
> +static inline void wq_list_merge(struct io_wq_work_list *list0,
> +				     struct io_wq_work_list *list1)
> +{
> +	if (!list1)
> +		return;
> +
> +	if (!list0) {
> +		list0 = list1;

It assigns a local var and returns, the assignment will be compiled
out, something is wrong

> +		return;
> +	}
> +	list0->last->next = list1->first;
> +	list0->last = list1->last;
> +}
> +
>  static inline void wq_list_add_tail(struct io_wq_work_node *node,
>  				    struct io_wq_work_list *list)
>  {
> 

-- 
Pavel Begunkov
