Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0D25630042
	for <lists+io-uring@lfdr.de>; Fri, 18 Nov 2022 23:39:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbiKRWjc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 18 Nov 2022 17:39:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbiKRWjb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 18 Nov 2022 17:39:31 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 741097615F
        for <io-uring@vger.kernel.org>; Fri, 18 Nov 2022 14:39:30 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id s12so9072692edd.5
        for <io-uring@vger.kernel.org>; Fri, 18 Nov 2022 14:39:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1BGpxpj2TDu7xbuC1ns4teIkSkEA6cf/goeA6UYS/vA=;
        b=jihopXEESN7AeHe5WptFGZ/z+QlniFrbdj5O7Q3MW8jde9hA51jOj7lkV5iv08NlsX
         vDLydtUOmPR7n6cR+baMcUJ2Wk2ilzZxzHWa+X3zXXJ0tlrv1/KY1sb9Wp/o9TSwqIc7
         JXWcx9vozHjtGQ9DY9ux1WdgMBOLqW3+l46XDE7Etu5wOavFeg3KpQHCWW6XCT53zqho
         d9A59ntUZvNtO7wR1kMXjBdv6XCB6hkpLVwm3s0XROiYdgw3+Vv8kI0EsUdnAE1uIf3n
         PFwTh7uyGTnmnI7TBZTxYMcJpb+uqq2jexKgl5R+7dvYHszawrzknolH+jDB2/jtMFKp
         e2sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1BGpxpj2TDu7xbuC1ns4teIkSkEA6cf/goeA6UYS/vA=;
        b=cx0MEmuans6EmeWmjra6aQ1m2X7Ovg+9FB4ceepBCbErFYB1fAisc5tSFrkEhwnrTm
         90VeA+XDRUemU8oYccSbFw/Yd4BRX/JpwtdbC81DR+VUBCmuJUyGpCV18ktPKmGuocjU
         +WZlhjJnQn2gashSf2MJJ6+p6Jka1JDKMbckwEi9+28NioitnFPj+eTArrfucTeXvvuT
         6kDMmMelMJrXza7g1ZFG/qTtE+tB2km+5Vo3/X+ekglvsAJ5PXBhg5GO28QnjBRlZ5W2
         Vcq4PXdhRpam8S3MWBlrazEOkA3EIw3iBhbOPdlvLwzx4Qy/cZ+oCpaMS5psrNFYCrza
         1ozA==
X-Gm-Message-State: ANoB5plmGlVvUJeI2JQNLGPcjiTNAhY8mD0diNOwV8u1V/oJ9CPEvbKj
        l5PmxgksA0hXi2SH1/IgAXASksmeGxo=
X-Google-Smtp-Source: AA0mqf7IsCVBeTkwPO9AnOBI4V0RKciN+w4fcSjRn6YXtgeXVl70X45rSYLWKzDO6HTezWmJ0NeDCA==
X-Received: by 2002:a05:6402:4:b0:463:cb99:5c8 with SMTP id d4-20020a056402000400b00463cb9905c8mr7876931edu.395.1668811168631;
        Fri, 18 Nov 2022 14:39:28 -0800 (PST)
Received: from [192.168.8.100] (188.28.224.148.threembb.co.uk. [188.28.224.148])
        by smtp.gmail.com with ESMTPSA id ee47-20020a056402292f00b00468f7bb4895sm1995830edb.43.2022.11.18.14.39.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Nov 2022 14:39:28 -0800 (PST)
Message-ID: <f95c8321-3f64-4a34-7fdd-343e4a6718d3@gmail.com>
Date:   Fri, 18 Nov 2022 22:39:00 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH for-6.1 v2] io_uring: make poll refs more robust
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, Lin Horse <kylin.formalin@gmail.com>
References: <394b02d5ebf9d3f8ec0428bb512e6a8cd4a69d0f.1668802389.git.asml.silence@gmail.com>
Content-Language: en-US
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <394b02d5ebf9d3f8ec0428bb512e6a8cd4a69d0f.1668802389.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/18/22 20:20, Pavel Begunkov wrote:
> poll_refs carry two functions, the first is ownership over the request.
> The second is notifying the io_poll_check_events() that there was an
> event but wake up couldn't grab the ownership, so io_poll_check_events()
> should retry.
> 
> We want to make poll_refs more robust against overflows. Instead of
> always incrementing it, which covers two purposes with one atomic, check
> if poll_refs is large and if so set a retry flag without attempts to
> grab ownership. The gap between the bias check and following atomics may
> seem racy, but we don't need it to be strict. Moreover there might only
> be maximum 4 parallel updates: by the first and the second poll entries,
> __io_arm_poll_handler() and cancellation. From those four, only poll wake
> ups may be executed multiple times, but they're protected by a spin.
> 
> Cc: stable@vger.kernel.org
> Reported-by: Lin Horse <kylin.formalin@gmail.com>
> Fixes: aa43477b04025 ("io_uring: poll rework")
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
[...]
> @@ -590,7 +624,7 @@ static int __io_arm_poll_handler(struct io_kiocb *req,
>   		 * locked, kick it off for them.
>   		 */
>   		v = atomic_dec_return(&req->poll_refs);
> -		if (unlikely(v & IO_POLL_REF_MASK))
> +		if (unlikely(v & IO_POLL_RETRY_MASK))

Still no good, this chunk is about ownership and so should use
IO_POLL_REF_MASK as before. Jens, please drop the patch, needs
more testing

>   			__io_poll_execute(req, 0);
>   	}
>   	return 0;

-- 
Pavel Begunkov
