Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB0EE69E630
	for <lists+io-uring@lfdr.de>; Tue, 21 Feb 2023 18:46:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233728AbjBURqi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 21 Feb 2023 12:46:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233902AbjBURqK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 21 Feb 2023 12:46:10 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A43F2ED78;
        Tue, 21 Feb 2023 09:46:02 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id l2-20020a05600c1d0200b003e1f6dff952so4220630wms.1;
        Tue, 21 Feb 2023 09:46:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uDnRax3P8Rqyh+vEDtWbnJmJDAGSHfiJk1QrjFoAGQc=;
        b=WYc7k04yz2ZCvvMTcnhKsFBcv+CqQzwr+5b7uAUlygEzihNPlXdKwMVllYB+Zul2FX
         IhcJ+BTDKGcqsDTn4lMAFm/wcM8v+VatLVVYRUjOupeeTx8CZC6kHkqIAMUdPrNKB6gC
         Td7K0ZKkxg1X11OaGqpbXThYpVUJPGseC8jG9AO+x8LSbF0c0ztFQOPC8nNPveeu+Yhf
         Wh1ApK61O2XF3F+OaEnPn/rgWj2YuQcBA935UNUn6tJzV234AVwK+z9cR27K3LfbI2Zr
         YIV8aFk/PokCdnwzkavxEPfwwP/+kOaC0OEnZJk7Wf9CR1jZ1gdtwt3IuVtmzRd1RqQ1
         5gRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uDnRax3P8Rqyh+vEDtWbnJmJDAGSHfiJk1QrjFoAGQc=;
        b=5szQ1uBkXP20Dy/795s3LjRw1VCoyD1UHLsidGXQ+xxxQ3r4h8CrJJm11cPseXlnO4
         /76sDMPO3dekauo7EtMCdm0OPaC2D+rkNvtkYPQknG8DkUU7yk750Ob7iemgx2oA7UJu
         CQsh9ohIUcG1IeUyK93mhe7ZQZHAczgDBZ6Q8ylDgaMgfhkFmWTYM2sOdE1QC/ei5Av4
         yubltWzsKFt82BQMCVup+84hBB1/cKQ46rNcVGIp+gRjM0EWQx8bGpM6YTNrp6uLSZ5I
         7yk/5Z0aiv48RsRJoxExhJhVMBE0QoWrLCBIgpLEeeHadsrsd9Nf6HYnN2FTS2jKsrs2
         92KA==
X-Gm-Message-State: AO0yUKVVulTNWI/F7mpNybAda3OG4EiJIbM3CbO32ZmDNErb+Ax/80FG
        EdjA45+l5jwMRJsk8DU1Iek=
X-Google-Smtp-Source: AK7set8pjNw1NwJOpBnT1vnsx7fpIowFzjMraxEwg1udWoNXFw7O2fPzZBbXCRSfLOKzUIJXjW+A/w==
X-Received: by 2002:a05:600c:4496:b0:3d9:fb89:4e3d with SMTP id e22-20020a05600c449600b003d9fb894e3dmr4959116wmo.28.1677001560784;
        Tue, 21 Feb 2023 09:46:00 -0800 (PST)
Received: from [192.168.8.100] (94.196.95.64.threembb.co.uk. [94.196.95.64])
        by smtp.gmail.com with ESMTPSA id g4-20020a056000118400b002c5544b3a69sm2095891wrx.89.2023.02.21.09.46.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Feb 2023 09:46:00 -0800 (PST)
Message-ID: <782b4b43-790c-6e89-ea74-aac1fd4ff1e2@gmail.com>
Date:   Tue, 21 Feb 2023 17:45:02 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [PATCH 1/2] io_uring: Move from hlist to io_wq_work_node
Content-Language: en-US
To:     Breno Leitao <leitao@debian.org>, axboe@kernel.dk,
        io-uring@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, gustavold@meta.com, leit@meta.com
References: <20230221135721.3230763-1-leitao@debian.org>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20230221135721.3230763-1-leitao@debian.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/21/23 13:57, Breno Leitao wrote:
> Having cache entries linked using the hlist format brings no benefit, and
> also requires an unnecessary extra pointer address per cache entry.
> 
> Use the internal io_wq_work_node single-linked list for the internal
> alloc caches (async_msghdr and async_poll)
> 
> This is required to be able to use KASAN on cache entries, since we do
> not need to touch unused (and poisoned) cache entries when adding more
> entries to the list.

Looks good, a few nits

> 
> Suggested-by: Pavel Begunkov <asml.silence@gmail.com>
> Signed-off-by: Breno Leitao <leitao@debian.org>
> ---
>   include/linux/io_uring_types.h |  2 +-
>   io_uring/alloc_cache.h         | 27 +++++++++++++++------------
>   2 files changed, 16 insertions(+), 13 deletions(-)
> 
> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
> index 0efe4d784358..efa66b6c32c9 100644
> --- a/include/linux/io_uring_types.h
> +++ b/include/linux/io_uring_types.h
> @@ -188,7 +188,7 @@ struct io_ev_fd {
>   };
>   
[...]
> -	if (!hlist_empty(&cache->list)) {
> -		struct hlist_node *node = cache->list.first;
> -
> -		hlist_del(node);
> -		return container_of(node, struct io_cache_entry, node);
> +	struct io_wq_work_node *node;
> +	struct io_cache_entry *entry;
> +
> +	if (cache->list.next) {
> +		node = cache->list.next;
> +		entry = container_of(node, struct io_cache_entry, node);

I'd prefer to get rid of the node var, it'd be a bit cleaner
than keeping two pointers to the same chunk.

entry = container_of(node, struct io_cache_entry,
                      cache->list.next);

> +		cache->list.next = node->next;
> +		return entry;
>   	}
>   
>   	return NULL;
> @@ -35,19 +38,19 @@ static inline struct io_cache_entry *io_alloc_cache_get(struct io_alloc_cache *c
>   
>   static inline void io_alloc_cache_init(struct io_alloc_cache *cache)
>   {
> -	INIT_HLIST_HEAD(&cache->list);
> +	cache->list.next = NULL;
>   	cache->nr_cached = 0;
>   }
>   
>   static inline void io_alloc_cache_free(struct io_alloc_cache *cache,
>   					void (*free)(struct io_cache_entry *))
>   {
> -	while (!hlist_empty(&cache->list)) {
> -		struct hlist_node *node = cache->list.first;
> +	struct io_cache_entry *entry;
>   
> -		hlist_del(node);
> -		free(container_of(node, struct io_cache_entry, node));
> +	while ((entry = io_alloc_cache_get(cache))) {
> +		free(entry);

We don't need brackets here. Personally, I don't have anything
against assignments in if, but it's probably better to avoid them,
or there will be a patch in a couple of months based on a random
code analysis report as happened many times before.

while (1) {
	struct io_cache_entry *entry = get();

	if (!entry)
		break;
	free(entry);
}	

-- 
Pavel Begunkov
