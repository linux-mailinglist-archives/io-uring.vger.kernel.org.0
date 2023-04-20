Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F11C96E8702
	for <lists+io-uring@lfdr.de>; Thu, 20 Apr 2023 02:52:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230473AbjDTAw6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 19 Apr 2023 20:52:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230298AbjDTAw5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 19 Apr 2023 20:52:57 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E159B10E2
        for <io-uring@vger.kernel.org>; Wed, 19 Apr 2023 17:52:56 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id 5b1f17b1804b1-3f1763eea08so2855995e9.2
        for <io-uring@vger.kernel.org>; Wed, 19 Apr 2023 17:52:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681951975; x=1684543975;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UF1yQcCdVna269C7MW4dp10q8+KJ6vnAzpLc/7O4BOQ=;
        b=H0IU7PWyiqzMpSxukvqABq7EaNe/Srd1D5D8OeRAKHmvLbYd9lwPvBP0zPoIL0R498
         42Zi8Q0t/Zf7kLT1mQiNrIKYNssm41hnwB7GSXV6+vVK9xP+cYgWnQHhUwx2W3BJKx95
         M8JC7Jan283NPrud74NsZV0JvNeY4eUJX+5U03sOtRjalJKfF3hfl0k672EsgOTPMgGl
         BtdV83xRwoYH0bSMTrUwNVAe2vWM74T6pyQX3G7/0aYI1FS8EVQOc8ihSzb33u7c4H4Q
         Cjobugv67t0111+gEFK8JzrVyhexCy2iJ6A6dEBoYJ8zGBYnp+LNtm83BXxNJ7dtX8Xw
         5zYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681951975; x=1684543975;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UF1yQcCdVna269C7MW4dp10q8+KJ6vnAzpLc/7O4BOQ=;
        b=IQX+SUQcE+oU4dGGFo6sQSwq3/ojOE+DfUaJquY2oSo9KzmtK+7xySpwKXgspjVsu0
         ZU2ofnb4s+mE/rkmxWuFkDVakz4pkz9EWu1ZmvUvoKVhv5C26oDGE+ufhr9ohGIi2Z87
         Aj+6XyqVP3JvB63u4VlNQ/PMbQsdPzLZDREf7XUkqpMxs3ETftATldsCkkapmEU1MPgK
         9muFhOJXHzaIJv8T8TQZ8PzOTSDHD51Ek0kes12mM6Z0ASQUbBnPI6cyoVHmId0LRGR+
         BZqTgvaRXPaySPfMzOe34lHwsurYLXJy9UmYaNZuMfDAsfStCN7SzUn1xZ4Shsh5TL7G
         Yj6w==
X-Gm-Message-State: AAQBX9ce4aEqIE6BBLbQH34L1ciOmHifpst8BqQoR9fm5nOStrLrbQxW
        ZaFn4hh7PMd3960zM7rKpQ0=
X-Google-Smtp-Source: AKy350ZQmV1JBb2UlEYWDWR+/o7bncL7qur+YiiD4ivw223ls7uEmAxR3JtgKzWL3McRYCs5Jmrt4Q==
X-Received: by 2002:a5d:688e:0:b0:2f8:f775:c885 with SMTP id h14-20020a5d688e000000b002f8f775c885mr5565597wru.6.1681951975306;
        Wed, 19 Apr 2023 17:52:55 -0700 (PDT)
Received: from [192.168.8.100] (188.28.97.56.threembb.co.uk. [188.28.97.56])
        by smtp.gmail.com with ESMTPSA id q17-20020a1cf311000000b003eeb1d6a470sm352387wmq.13.2023.04.19.17.52.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Apr 2023 17:52:55 -0700 (PDT)
Message-ID: <8d07228f-6e18-7656-2bee-f70640f40744@gmail.com>
Date:   Thu, 20 Apr 2023 01:50:01 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 2/6] io_uring: move poll_refs up a cacheline to fill a
 hole
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     luhongfei@vivo.com
References: <20230419162552.576489-1-axboe@kernel.dk>
 <20230419162552.576489-3-axboe@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20230419162552.576489-3-axboe@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/19/23 17:25, Jens Axboe wrote:
> After bumping the flags to 64-bits, we now have two holes in io_kiocb.
> The best candidate for moving is poll_refs, as not to split the task_work
> related items.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>   include/linux/io_uring_types.h | 6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
> index 84f436cc6509..4dd54d2173e1 100644
> --- a/include/linux/io_uring_types.h
> +++ b/include/linux/io_uring_types.h
> @@ -535,6 +535,9 @@ struct io_kiocb {
>   	 * and after selection it points to the buffer ID itself.
>   	 */
>   	u16				buf_index;
> +
> +	atomic_t			poll_refs;

poll wake is often done by a random CPU, would be great to limit
cache sharing, i.e. the 2nd cache line is never touched by
io_poll_wake() and it'd only need the poll entry and
the 3rd line with io_task_work().

There is one place that doesn't care about it, i.e.
clearing REQ_F_[SINGLE,DOUBLE]_POLL in poll wake, but
it's a place to improve.


> +
>   	u64				flags;
>   
>   	struct io_cqe			cqe;
> @@ -565,9 +568,8 @@ struct io_kiocb {
>   		__poll_t apoll_events;
>   	};
>   	atomic_t			refs;
> -	atomic_t			poll_refs;
> -	struct io_task_work		io_task_work;
>   	unsigned			nr_tw;
> +	struct io_task_work		io_task_work;
>   	/* for polled requests, i.e. IORING_OP_POLL_ADD and async armed poll */
>   	union {
>   		struct hlist_node	hash_node;

-- 
Pavel Begunkov
