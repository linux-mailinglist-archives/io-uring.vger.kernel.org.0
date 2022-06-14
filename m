Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 432AE54B51F
	for <lists+io-uring@lfdr.de>; Tue, 14 Jun 2022 17:53:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238075AbiFNPvR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Jun 2022 11:51:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234677AbiFNPvQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Jun 2022 11:51:16 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D86CF36160
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 08:51:15 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id d13so8059938plh.13
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 08:51:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:cc:in-reply-to:content-transfer-encoding;
        bh=jqsBXeP1XgHrXChK5MA1sTIdOSvl2hvXL1mzPtgHYR4=;
        b=Z9LhkwsZvz3hqPzHs0DwdqRCwrSFRSsuJ5qQNPZg/EUmc+qYQF/FiDVQHnl5blmDT6
         nwZbfw8UU4wvGIXepORNhvmsYEsLYS410Fvk2dn0qiGstJkYLKZ9G1mD/KWalVTG7z47
         11+xQ9nKqt2Lsk935sbfxfsUnMZ3X5UeSH0mlKxtF4s/gHwgDzL0956uRORYzg5vh2VB
         gXVUiqtzwfZmtNt+z4FJw+bbPCD+SKJ8udEcosGQIPVG5/FBlEbw1jrxYf1B/w80JxuE
         ZpRT/SUYr+y9jq6vgJzZpslWpCzHlJfD3nUf3Ji8fGpvB4ERDqQQp/1169bFxfn09k56
         GVsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:cc:in-reply-to
         :content-transfer-encoding;
        bh=jqsBXeP1XgHrXChK5MA1sTIdOSvl2hvXL1mzPtgHYR4=;
        b=wYUxWllMsH7iWEepornuEsiuicgXhT9ixR/6tnyF9kgS7GLT0OxDEQYxwP7Hf9lirR
         tarx3wGMkfUxLOIE7F/XaZMFE3+5SDvIJFAo6eKkfxmjPqogZt7pIO6hUESmRN93H9oK
         LOkKktGmILbAlsWsl2wNOC3XI56aNK9MeqUe31GXsQfjyfd6QLmzeVm+iAI1zqCY/50+
         1AkgjU22MdwglKzQHrfmkj+Yx2EMSnw3LO5RMR8dYbEhEdkyU3UqqQAziXvR3bNPJrNj
         3Wl/mJaha6/7tdwCt5zsHHmxsHXQsgaUZ2YL8YwceEQSDCc2jepggctxO8Z090JAGU+b
         eamQ==
X-Gm-Message-State: AJIora+TcyfBx0xOYEoKNDTXMmP5hXDxQX/5FuH0/nN7+9alIU+oPOJt
        3vIXz2+AcYsDcb6dL4+lAHo9hw==
X-Google-Smtp-Source: AGRyM1s+99FTHyH/1Q63c3L8OxNk7HC3QGq7gfE9oqx2hC/V3A/GEVSPDwfxUGD8Qysspu50aif6pA==
X-Received: by 2002:a17:902:c951:b0:163:efad:406d with SMTP id i17-20020a170902c95100b00163efad406dmr4866003pla.55.1655221875317;
        Tue, 14 Jun 2022 08:51:15 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id y1-20020a056a001c8100b0051b97714703sm7639659pfw.187.2022.06.14.08.51.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jun 2022 08:51:14 -0700 (PDT)
Message-ID: <bd18039b-2a06-62c8-77e2-6b86ba3c2d73@kernel.dk>
Date:   Tue, 14 Jun 2022 09:51:13 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH liburing v2 0/3] single-issuer and poll benchmark
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1655219150.git.asml.silence@gmail.com>
 <9b2daabd-3412-7cd8-79d8-8a9dfe4b27d2@kernel.dk>
 <da4c0717-be10-c298-9074-b237ea613ba5@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Cc:     Dylan Yudaken <dylany@fb.com>
In-Reply-To: <da4c0717-be10-c298-9074-b237ea613ba5@gmail.com>
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

On 6/14/22 9:48 AM, Pavel Begunkov wrote:
> On 6/14/22 16:30, Jens Axboe wrote:
>> On 6/14/22 9:27 AM, Pavel Begunkov wrote:
>>> Add some tests to check the kernel enforcing single-issuer right, and
>>> add a simple poll benchmark, might be useful if we do poll changes.
>>
>> Should we add a benchmark/ or something directory rather than use
>> examples/ ?
>>
>> I know Dylan was looking at that at one point. I don't feel too
>> strongly, as long as it doesn't go into test/.
> 
> I don't care much myself, I can respin it once (if) the kernel
> side is queued.

I'm leaning towards just using examples/ - but maybe Dylan had some
reasoning for the new directory. CC'ed.

-- 
Jens Axboe

