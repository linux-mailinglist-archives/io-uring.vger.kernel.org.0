Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60C2E4E5238
	for <lists+io-uring@lfdr.de>; Wed, 23 Mar 2022 13:33:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241040AbiCWMfD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Mar 2022 08:35:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231716AbiCWMfD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Mar 2022 08:35:03 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD1CDDFD2
        for <io-uring@vger.kernel.org>; Wed, 23 Mar 2022 05:33:33 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id s72so998111pgc.5
        for <io-uring@vger.kernel.org>; Wed, 23 Mar 2022 05:33:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=fJOb/7OQ4wyGWhUUDl8F3tlLlbKrxJJ/UFu0kMMEack=;
        b=UjdYj6RJthvT8Mi0Y8kXQ/Ijf7ElKSdweY+vykTtY5QbCAimO3wjK/QqgCdZA1ONZP
         QZLHL++rCXyyIs9YWbNYPO5S2HAhKV/WcdIex49m3G6lxZmJsTfLDMpawwHviYfFeDat
         +9W6Y/326S05F/GmGn7v5bxOwtiRNTvD5ZOiB9H4EmgjieKzWzKly+F7hScuEZ+Hc0Ns
         I2dwPINH/CDe/da5oOQaLPrHG0PjTLQeG/hLEDtDjWmUHEylvrv8sR89+tRgDrMCcUnn
         54LVhTcQwt4L3sAOPuVzAGfc24KUhhkLNbpe9edNdksUN90WnNlrpE2+W2FUWxa6iaKv
         M8Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=fJOb/7OQ4wyGWhUUDl8F3tlLlbKrxJJ/UFu0kMMEack=;
        b=OUgRFRma57Za9L+S0qqk6ttKdbZfqcfV314qbvNW59T4XD/USZJ7HIYees6BlyTWEn
         LJCxTO+NHXVoWtFLGHCZCKDhRtEPa7xM9/Xo1VD6VX6sKH/7wothBD+cqpPt5Kpb8pOM
         0QIA0OG6qq/VjamW2+7pN4g2ICZTZTG0NYD3c/4ED8uNsLZ3CBq5335srVKp5noaje7R
         ofEFh/OveIWAW/oTn2kIqmyx/vQBTtq4sco8jNWDQSm84b5dwhM1DBPbhWP9sGnyLblj
         YezvQXRJG50XBkqFkXxAgoQ094MqvxhjuVunFGUGzsn4Hs04vTzR/Cn5oacsQhrLX6NJ
         2nZA==
X-Gm-Message-State: AOAM5335M9S5MQ6+hS/JTpmTzDWdKZJ1EqQa2ODm9Oj97YYV14aBZEfo
        974FRf6hZX9yacYyN6Jq24sbu7l8XJa/Gc5D
X-Google-Smtp-Source: ABdhPJx1FvngDUWcOb1SCydfsO6MeUqigx9Gj+G54WeQ2GCeXDronyDs0uLTa8zUV/Y7DRkhUibNaw==
X-Received: by 2002:a63:e409:0:b0:382:6cc1:ae26 with SMTP id a9-20020a63e409000000b003826cc1ae26mr14011090pgi.583.1648038813168;
        Wed, 23 Mar 2022 05:33:33 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id ip13-20020a17090b314d00b001bfaa1f060bsm6652108pjb.5.2022.03.23.05.33.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Mar 2022 05:33:32 -0700 (PDT)
Message-ID: <c304efea-3aa5-f7fd-74f7-825740497b97@kernel.dk>
Date:   Wed, 23 Mar 2022 06:33:32 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] io_uring: add overflow checks for poll refcounting
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <0727ecf93ec31776d7b9c3ed6a6a3bb1b9058cf9.1648033233.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <0727ecf93ec31776d7b9c3ed6a6a3bb1b9058cf9.1648033233.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/23/22 5:14 AM, Pavel Begunkov wrote:
> We already got one bug with ->poll_refs overflows, let's add overflow
> checks for it in a similar way as we do for request refs. For that
> reserve the sign bit so underflows don't set IO_POLL_CANCEL_FLAG and
> making us able to catch them.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  fs/io_uring.c | 28 +++++++++++++++++++++-------
>  1 file changed, 21 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 245610494c3e..594ed8bc4585 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -5803,8 +5803,13 @@ struct io_poll_table {
>  	int error;
>  };
>  
> -#define IO_POLL_CANCEL_FLAG	BIT(31)
> -#define IO_POLL_REF_MASK	GENMASK(30, 0)
> +/* keep the sign bit unused to improve overflow detection */
> +#define IO_POLL_CANCEL_FLAG	BIT(30)
> +#define IO_POLL_REF_MASK	GENMASK(29, 0)
> +
> +/* 2^16 is choosen arbitrary, would be funky to have more than that */
> +#define io_poll_ref_check_overflow(refs) ((unsigned int)refs >= 65536u)
> +#define io_poll_ref_check_underflow(refs) ((int)refs < 0)

Should that be larger? I agree that it'd be funky to have > 64k, but we
just had such a case with remove all which triggered this whole thing.
That case actually would've worked fine, albeit slower, if we weren't
limited to 20 bits of refs at that time. Maybe just trigger when we're
halfway there, AND'ing with bit 29?

-- 
Jens Axboe

