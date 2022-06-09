Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9350E544847
	for <lists+io-uring@lfdr.de>; Thu,  9 Jun 2022 12:07:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232917AbiFIKHB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 9 Jun 2022 06:07:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229887AbiFIKHA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 9 Jun 2022 06:07:00 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50E295FC8
        for <io-uring@vger.kernel.org>; Thu,  9 Jun 2022 03:06:58 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id u23so37223545lfc.1
        for <io-uring@vger.kernel.org>; Thu, 09 Jun 2022 03:06:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=r0gZ0jny0LMqI9awlnQmWlMhBrZloPwUyDd+klyKx/o=;
        b=GYE6nUf1W8d2w+fJg7LzEu8j/pA0p0yUWUnzDD7L+VcxnzoY1OTnVpw+N29yStwqlS
         ykhbqjrzq6AyECQQSE3KJm8a9UGcPkcy+llGPufO4x9RT7IRcHIlib/lrvxRXX4DcZH1
         VH3acO2daiSwAYr6WbFDyflEgBuIwHpHdztwP4SeNYE/+DDmo+yP1bgdSqd+D2Ti8N1Y
         p/Ecs4P3f1zQQfBOt+dUbSRTSQ8GPKuxEFF+4HJfF4n2TuYak/8odE97DRRbA9c/IHOh
         XH/U1GnTNbrHhxrwPBFZGE72xRIlyVQLQtJoQJznvRjPAvQaikLoG6UuppEBr4qiOmf/
         gH7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=r0gZ0jny0LMqI9awlnQmWlMhBrZloPwUyDd+klyKx/o=;
        b=hGtMV4D3OnZK8FQUhcfT0iDt2CUssVsUBl2ygnkWIqo24F4QdOqauwE/nMcBw3cAac
         wuvV2e6W2LY/Qvx/YdXuj1GOAiztULI0Czg/BiYqQHlVhSOuRSQJ5hU5KG+IRZJ8LjoT
         UHvMCFZs812p+feIeWDd//JRVDUFFjQ0MotooFM7IVdTKlOtsvR9KdYQo+OFTlMmrNke
         uacR1KI5skpUykPm8TIe2RmDnX9Wnaxm5f/tnkNsYbPFxrOXyfGwWKBIeDeeHllTzrWe
         uFzR3xf+JRUx39yrAqL+RIHjp6mwn+9aBiEyw/wn+GvuCGEa857mw8g5sXkfwlQnodNd
         pfCQ==
X-Gm-Message-State: AOAM530u+36jpv7o87sJeyJ7WkGRTe3kWiEyGbx0A7PdnnT8TEQ4JQlP
        pHKHH1na3fwSswRSt+eTKmd5I/ddJG2W7xed
X-Google-Smtp-Source: ABdhPJxADLn3JtRU263hfJAQ1I6PhezAwM4IVRv3y1wQ3GrzQnyn041D303ijbHPil22p56Q7QqaXw==
X-Received: by 2002:ac2:4642:0:b0:479:130c:68f2 with SMTP id s2-20020ac24642000000b00479130c68f2mr22330013lfo.221.1654769216523;
        Thu, 09 Jun 2022 03:06:56 -0700 (PDT)
Received: from [192.168.172.199] (176-20-186-40-dynamic.dk.customer.tdc.net. [176.20.186.40])
        by smtp.gmail.com with ESMTPSA id v20-20020a2e87d4000000b002553768424esm3667253ljj.112.2022.06.09.03.06.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jun 2022 03:06:54 -0700 (PDT)
Message-ID: <7c563209-7b33-4cc8-86d9-fecfef68c274@kernel.dk>
Date:   Thu, 9 Jun 2022 04:06:52 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: Possible bug for ring-mapped provided buffer
Content-Language: en-US
To:     Hao Xu <hao.xu@linux.dev>, io-uring <io-uring@vger.kernel.org>
Cc:     Pavel Begunkov <asml.silence@gmail.com>
References: <1884ea45-07df-303a-c22c-319a2394b20f@linux.dev>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <1884ea45-07df-303a-c22c-319a2394b20f@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/9/22 1:53 AM, Hao Xu wrote:
> Hi all,
> I haven't done tests to demonstrate it. It is for partial io case, we
> don't consume/release the buffer before arm_poll in ring-mapped mode.
> But seems we should? Otherwise ring head isn't moved and other requests
> may take that buffer. What do I miss?

On vacation this week, so can't take a look at the code. But the
principle is precisely not to consume the buffer if we arm poll, because
then the next one can grab it instead. We don't want to consume a buffer
over poll, as that defeats the purpose of a provided buffer. It should
be grabbed and consumed only if we can use it right now.

Hence the way it should work is that we DON'T consume the buffer in this
case, and that someone else can just use it. At the same time, we should
ensure that we grab a NEW buffer for this case, whenever the poll
triggers and we can retry the IO. As mentioned I can't check the code
right now, but perhaps you can take a look.

-- 
Jens Axboe

