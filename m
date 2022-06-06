Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 390F253E6CC
	for <lists+io-uring@lfdr.de>; Mon,  6 Jun 2022 19:07:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235880AbiFFL4K (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 6 Jun 2022 07:56:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235859AbiFFL4J (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 6 Jun 2022 07:56:09 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E8E17A44E
        for <io-uring@vger.kernel.org>; Mon,  6 Jun 2022 04:56:08 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id v4-20020a1cac04000000b00397001398c0so9882435wme.5
        for <io-uring@vger.kernel.org>; Mon, 06 Jun 2022 04:56:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=3wpKBmPbAf75elvIZlfzv89xcEnWR7j+xL/UvnLGkIk=;
        b=YGFDVJRCofu4TZsPQU1x355nufccHJn02SBSmjS9435RegMbeuojz3oM50AdC8ZTYk
         XQSayCZibbWgoObkQtORzMNsWMbXkqm6bmjKZZex6XHbZa+ZoN/7hpQJSfOIbO7bXGBX
         I1jFnuWKl9pjBG6zRCNbgyqezJnOR63v8RNMoS7+NKRXlmoW1WdAygDEsKMk105vXJ0L
         zkVL/4KgsGsuNcZSi1rUO+mngA4hWj96NP2/roz3xkOEeAL/PGO5EcDyj2Ijfeh0Qjcz
         iPaDj0N8OsNY57LsmvrQD4d2kuiIBiaUhlgYpYyqU2txJJruVkaUvak7pmZX8hFCvhw1
         hVeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=3wpKBmPbAf75elvIZlfzv89xcEnWR7j+xL/UvnLGkIk=;
        b=O+VrlM51xNcXkhIWJDaubTaxFHZK6oYzcSBhxHqC5vP0sqx7z3RbuNrv5yhYcFCu8s
         tRqKZ23wMSbz6xA/AQfxtmngyQpHxI3QWYvXAFhhiAkb6D+F+j/4JmtWf7mtNW24R8+x
         0F/O6dx8g1FWQw+SQihgo/ClcyQewA/8Lg4YJt/bY2s/z2/Hf/BPmcZTjbeAQV1Wfm1b
         0KN9GkzLGkphIwhCPtPgSsWDX7Gd74eHocUWDqEin6JZh5cTlRVSPh8WZf6R+UODJjJN
         LDY9JkwvzbAJ9Eg6nt+w3Bz9VpmO5stLvBUkDzgX7EBLeT99ydMxTBGVy2ZaufmboYjI
         Rlrg==
X-Gm-Message-State: AOAM532uMPhukVEC077uUKuntaKe23a0remYNWtKyO8NqWSgT0F8Iljs
        ydpOWEANb5cv/UbaEl2jvWE=
X-Google-Smtp-Source: ABdhPJxWiidPMMkJnmbcSmbzMAEfWegj/taUJWB77AZsFgEVvMjDVcLqT7uX2EAXcI7vOOsFFcEnuQ==
X-Received: by 2002:a1c:f305:0:b0:39c:4840:ab42 with SMTP id q5-20020a1cf305000000b0039c4840ab42mr10808452wmq.148.1654516566752;
        Mon, 06 Jun 2022 04:56:06 -0700 (PDT)
Received: from [192.168.43.77] (82-132-232-174.dab.02.net. [82.132.232.174])
        by smtp.gmail.com with ESMTPSA id e41-20020a05600c4ba900b0039754d1d327sm16334761wmp.13.2022.06.06.04.56.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Jun 2022 04:56:06 -0700 (PDT)
Message-ID: <27bc9b01-5605-5ce3-303d-79f85d30f6fb@gmail.com>
Date:   Mon, 6 Jun 2022 12:55:46 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 2/3] io_uring: add an io_hash_bucket structure for smaller
 granularity lock
Content-Language: en-US
To:     Hao Xu <haoxu.linux@icloud.com>, io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
References: <20220606065716.270879-1-haoxu.linux@icloud.com>
 <20220606065716.270879-3-haoxu.linux@icloud.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20220606065716.270879-3-haoxu.linux@icloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/6/22 07:57, Hao Xu wrote:
> From: Hao Xu <howeyxu@tencent.com>
> 
> Add a new io_hash_bucket structure so that each bucket in cancel_hash
> has separate spinlock. This is a prep patch for later use.
> 
> Signed-off-by: Hao Xu <howeyxu@tencent.com>
> ---
>   io_uring/cancel.h | 5 +++++
>   1 file changed, 5 insertions(+)
> 
> diff --git a/io_uring/cancel.h b/io_uring/cancel.h
> index 4f35d8696325..b9218310611c 100644
> --- a/io_uring/cancel.h
> +++ b/io_uring/cancel.h
> @@ -4,3 +4,8 @@ int io_async_cancel_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
>   int io_async_cancel(struct io_kiocb *req, unsigned int issue_flags);
>   
>   int io_try_cancel(struct io_kiocb *req, struct io_cancel_data *cd);
> +
> +struct io_hash_bucket {
> +	spinlock_t		lock;
> +	struct hlist_head	list;
> +};

please, in future just merge such patches into the next one,
separately it doesn't do anything meaningful, the struct is
not used here and IMHO only makes reviewing harder.

-- 
Pavel Begunkov
