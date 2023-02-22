Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 978A069FB00
	for <lists+io-uring@lfdr.de>; Wed, 22 Feb 2023 19:30:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232093AbjBVSaW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 22 Feb 2023 13:30:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232365AbjBVSaV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 22 Feb 2023 13:30:21 -0500
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D09839CC5
        for <io-uring@vger.kernel.org>; Wed, 22 Feb 2023 10:30:17 -0800 (PST)
Received: by mail-il1-x12e.google.com with SMTP id r4so1033018ila.2
        for <io-uring@vger.kernel.org>; Wed, 22 Feb 2023 10:30:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1677090617;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/OiGxXdhMijif1OrnbqcE7MLbFzI92LPmx4R6TbKMMc=;
        b=W+vuxZLUd+mJ/F8W+ZcBVKYcXbuIEKmpD5s5pnEKXDFW9CLflCZRp6TF47PIZwBAmJ
         M7nTySzgGanAsSVnGZB8jiSW2AEN4oUhGQjCRv53nW/KD/nWIC42gQQ/ZxhS2GBfrG+R
         7kJZgPoe1A4PbbXRTV0oFKciryCmH7ZYVewL6Pw5CUAlZ3QSLkbiUf7HMejD2sgD/BtY
         47MPGZF7R9msLMlSO64M4zFyu1OQrZ18kkE8b9v3kXhGVrEMvhOWXMPtEHw4v6d6LNSq
         i5oW6858mcF3gSuOInrQ4cfPx69Z9WkQeJaWV67zjxPR6xjzRJQtCOWRpo0U4BHVSpvl
         PgTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677090617;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/OiGxXdhMijif1OrnbqcE7MLbFzI92LPmx4R6TbKMMc=;
        b=4gLN1sO7sJ23lp5yUTk+P2BvBOGOFJ9BMSBALaE9p2jdT/U9MHk3YM83h0i/ubVNxQ
         CXCizyIMek1/OWBg1QOh9qaRCRa5wx4PT/xQBruTegJFizHThQwL0vKQ0nqMSC7yMPFJ
         eITY6QbLd2rtg/Ld/WNIV5iUgdgLJmAkjg28Vr7ACgpW6oTl8JFEAwCDv3Sg7NYVT+P4
         /uh2zikjQtUrO8kaGTXYwcI8Koi2gSmwYAkimotk/ljxsXH+0+Xs9jEj4DH0hQ5HEGFR
         /M39UQvikOo7Q7rFELQJfZHkQRTXkRzZZZdpLKDK7WXj2mZiZpiNd0aQGS5Nqf8kXAR7
         yWEQ==
X-Gm-Message-State: AO0yUKVx+Qvhlvc2r2XECKgX+tPe++t0l66Q8L2KmeqxvXT5pHAhUOEd
        +TJnoTM9VIJdZIFmhgnE+3F3MQ==
X-Google-Smtp-Source: AK7set/e1iwBIhPd5GBJKzX/zo+fr7RQssIJpTzPLRJTrJallE9NEohMFmQMhtKpGONDG2YzmQu8nw==
X-Received: by 2002:a05:6e02:d08:b0:316:e2ee:3a15 with SMTP id g8-20020a056e020d0800b00316e2ee3a15mr2621798ilj.1.1677090617221;
        Wed, 22 Feb 2023 10:30:17 -0800 (PST)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id g14-20020a056e021a2e00b00313d86cd988sm2579889ile.49.2023.02.22.10.30.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Feb 2023 10:30:16 -0800 (PST)
Message-ID: <b0c82199-fb96-08a2-6158-cb1655b6ba3d@kernel.dk>
Date:   Wed, 22 Feb 2023 11:30:15 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [PATCH v2 2/2] io_uring: Add KASAN support for alloc_caches
Content-Language: en-US
To:     Breno Leitao <leitao@debian.org>, asml.silence@gmail.com,
        io-uring@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, gustavold@meta.com, leit@meta.com,
        kasan-dev@googlegroups.com, Breno Leitao <leit@fb.com>
References: <20230222180035.3226075-1-leitao@debian.org>
 <20230222180035.3226075-3-leitao@debian.org>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230222180035.3226075-3-leitao@debian.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/22/23 11:00?AM, Breno Leitao wrote:
> -static inline struct io_cache_entry *io_alloc_cache_get(struct io_alloc_cache *cache)
> +static inline struct io_cache_entry *io_alloc_cache_get(struct io_alloc_cache *cache,
> +							size_t size)
>  {
>  	if (cache->list.next) {
>  		struct io_cache_entry *entry;
>  		entry = container_of(cache->list.next, struct io_cache_entry, node);
> +		kasan_unpoison_range(entry, size);
>  		cache->list.next = cache->list.next->next;
>  		return entry;
>  	}

Does this generate the same code if KASAN isn't enabled? Since there's a
4-byte hole in struct io_alloc_cache(), might be cleaner to simply add
the 'size' argument to io_alloc_cache_init() and store it in the cache.
Then the above just becomes:

	kasan_unpoison_range(entry, cache->elem_size);

instead and that'd definitely generate the same code as before if KASAN
isn't enabled.

-- 
Jens Axboe

