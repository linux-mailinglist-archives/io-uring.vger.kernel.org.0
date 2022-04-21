Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57C2F50A980
	for <lists+io-uring@lfdr.de>; Thu, 21 Apr 2022 21:49:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392082AbiDUTv5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 Apr 2022 15:51:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241640AbiDUTv4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 Apr 2022 15:51:56 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A75124D62C
        for <io-uring@vger.kernel.org>; Thu, 21 Apr 2022 12:49:05 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id 125so6445452iov.10
        for <io-uring@vger.kernel.org>; Thu, 21 Apr 2022 12:49:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=IwwPIM11tx8V6UNTONYcWN0vJsN5rB5ub0aaKuD+xXY=;
        b=3wW0x0Gh8w8lXZcdxfHEJYr8TiqIkEd5yDIT96fY7ObnNDBqnmu2zkEcWQ5QnlroCO
         /btp4184wKKKzvo+T+YqstyWCOiwlrEKi23BsQBAMVih4AabVOyu0fb+PhIEilOPMs5Z
         D1DA+HhJnXp1PSPS14/VvwNNjmCCLRFteZNmrs6FUQ7izdEcyTqaY22h7kGqNWbWbhiY
         TVBAEAHPWjtUvHOHSu/liscL2gd/+ihJ0wEoTQxyB9vJyYavg/MkQGi/qHG5CDPkjjs0
         kR33KF5N9Jimc76pP8CAB7mDTrLxP8DwBD+ATd22fURjjd1hok5X/eOjqeDQ/ZIDpltY
         kTcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=IwwPIM11tx8V6UNTONYcWN0vJsN5rB5ub0aaKuD+xXY=;
        b=B2GfF2n/zAyd0c/i7qUfTvBdiQi4tsVQWPPB5KfqizKkdtKbNgoaO4iCJjQK5IHWH8
         OQ80tqNfXAICcIdmASe74pQgofHF6oh41IUayPg1iYa+pbSoF0BWrGu3yCiX7Puc09lx
         3zUQ3rHAoqWEaM9GuEGg7yRlvFpjD/LcH2hbN2KryIxXm9fKk24Iw4N8nqF+Qe4GS5eQ
         B9/KqwuldZuh0+wKMEtZjaHLHpkHfuSDVaCsxDrnZx39RP4Vm38BDbqx14StpDKBUWwA
         ilDSM1d6vmb3MqxBc4mMNeFiHnxAkev1S+W8AU2vmmxECOGcZRCK7b3nfexncXlSPtAI
         rKWQ==
X-Gm-Message-State: AOAM533Q4DbdUEZXoJOg8K4gWIlw5vtEpiZ+gBV9bxVTSecMZOJqkkhe
        nf1DqPDhLI4ZUPGgbNsOp0KEHhai0eHIFA==
X-Google-Smtp-Source: ABdhPJzuDVKmKXeqTCpkqT/5k9bHP6gprecRcRY7D0cm8OVmwFjj0amNca8NgRfmlvVbmI7adBur2A==
X-Received: by 2002:a5d:9947:0:b0:654:b989:699f with SMTP id v7-20020a5d9947000000b00654b989699fmr599311ios.170.1650570545043;
        Thu, 21 Apr 2022 12:49:05 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id g6-20020a5e8b06000000b00654a62df7b1sm7218763iok.38.2022.04.21.12.49.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Apr 2022 12:49:04 -0700 (PDT)
Message-ID: <04d3e2fa-5317-a529-31b8-7c66618d61f4@kernel.dk>
Date:   Thu, 21 Apr 2022 13:49:03 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH liburing 5/5] overflow: add tests
Content-Language: en-US
To:     Dylan Yudaken <dylany@fb.com>, io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com, kernel-team@fb.com
References: <20220421091427.2118151-1-dylany@fb.com>
 <20220421091427.2118151-6-dylany@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220421091427.2118151-6-dylany@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/21/22 3:14 AM, Dylan Yudaken wrote:
> Add tests that verify that overflow conditions behave appropriately.
> Specifically:
>  * if overflow is continually flushed, then CQEs should arrive mostly in
>  order to prevent starvation of some completions
>  * if CQEs are dropped due to GFP_ATOMIC allocation failures it is
>  possible to terminate cleanly. This is not tested by default as it
>  requires debug kernel config, and also has system-wide effects

Since you're doing a v2 of this anyway, can we change:

> +/*
> + * Create an overflow condition and ensure that SQEs are still processed
> + */
> +static int test_overflow_handling(
> +	bool batch,
> +	int cqe_multiple,
> +	bool poll)
> +{

to follow the normal stye of:

static int test_overflow_handling(bool batch, int cqe_multiple,	bool poll)
{

instead?

-- 
Jens Axboe

