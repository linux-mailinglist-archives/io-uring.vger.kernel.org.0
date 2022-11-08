Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE9EE621571
	for <lists+io-uring@lfdr.de>; Tue,  8 Nov 2022 15:12:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235340AbiKHOM1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Nov 2022 09:12:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235254AbiKHOMI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Nov 2022 09:12:08 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55FF657B64
        for <io-uring@vger.kernel.org>; Tue,  8 Nov 2022 06:11:39 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id f5-20020a17090a4a8500b002131bb59d61so1375317pjh.1
        for <io-uring@vger.kernel.org>; Tue, 08 Nov 2022 06:11:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oZHx4y3weBuBx+FzuZMSRre6FOFJgGjdQjTkVXXo5u4=;
        b=o48oSb1SL0C2lmFgsiJTLeloedwOdAai/2XQ1N7l93I/NbHqzYlWkgh0yGaodWsOk/
         6XDStMW9l5r7wXxN9nLqhKESb78Ibla5yoFh00NyH20T8foWaz7OhRsKRox9Gn+ff4JB
         qWO/5AKFfLSOI847viAIp7ZoPQ4yi9ykVYqFRwr7hsE/Bb4DZ+fSHLcTILVSxKo+4DzH
         QYIUFAQGLavZYduv2uNxhg21nuNSiUyAM6pZ0Ae8ZgoIfeg5WMGy7DphzVPGuaQoXu3Y
         Y3E+hGdSkyajrcT/hlOTAGJoor0a6+tbg1NbXUpEWNixQGNMcfCiLSH+3XexrE7oifbl
         XZiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oZHx4y3weBuBx+FzuZMSRre6FOFJgGjdQjTkVXXo5u4=;
        b=x/bt0MxHc1HMT5iRoj3u0PFw+WTAXUyIha/g426K5rq8H28rnKMdo1H4mnWEPhN54g
         qFpowOVvsZskr37Hg4afSr1mHNssYNKN4ET+gX+hjv1I6MypH5hM7ND+Dk2KpXT7zAV8
         XLtAjgYvOoCdaLlhJm0zhLOYw2/pyYaw9pQLt9rysR0We+4SNVQtAiCyXbwZCHE4iw93
         nMN6Cx64c6aJ1MbdA/YSo8plI699xcWisRc/xjnfhLXdSCDLehI5KcCQyLjd4tc9D0WT
         FGjJHrgbt/8ArfJsLffC/RPDfzSj3lYrfl1Tfjwls6mjQ8lCkErO38kIuwkUFv7AVIv9
         NGeg==
X-Gm-Message-State: ACrzQf01rLLR9fXhZuWYw3e4UHqnj7uQJzRh9zmaQv2VPI0FZpua0UAR
        YrqGOE88M/FNAdq3fdyr4iBLSQ==
X-Google-Smtp-Source: AMsMyM4Yhs/VjvzEgByTTPu4cGBFNDdbEMZ0OhJCS8xo1iKsouZrBYWRBkDNaBEdQHiGINEjIiRm6w==
X-Received: by 2002:a17:90a:f2cb:b0:213:9afa:d13a with SMTP id gt11-20020a17090af2cb00b002139afad13amr56652486pjb.180.1667916698561;
        Tue, 08 Nov 2022 06:11:38 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id v126-20020a626184000000b00565cf8c52c8sm6625328pfb.174.2022.11.08.06.11.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Nov 2022 06:11:37 -0800 (PST)
Message-ID: <7f50c81a-6cb6-b8d7-8f80-bd3e49b0f401@kernel.dk>
Date:   Tue, 8 Nov 2022 07:11:34 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH liburing v4] test that unregister_files processes task
 work
Content-Language: en-US
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Dylan Yudaken <dylany@meta.com>
Cc:     io-uring Mailing List <io-uring@vger.kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>
References: <20221108124207.751615-1-dylany@meta.com>
 <741d8fb7-863a-b0c5-c42b-5e227d0f7937@gnuweeb.org>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <741d8fb7-863a-b0c5-c42b-5e227d0f7937@gnuweeb.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/8/22 5:50 AM, Ammar Faizi wrote:
> On 11/8/22 7:42 PM, Dylan Yudaken wrote:
>> Ensure that unregister_files processes task work from defer_taskrun even
>> when not explicitly flushed.
>>
>> Signed-off-by: Dylan Yudaken <dylany@meta.com>
> 
> I feel a bit irritated because the close() and io_uring_queue_exit()
> don't get invoked in the error paths. But not a big deal, since in the
> test we'll be exiting soon after that :p

Yeah, lots of tests to that - in case of error, just return the error
and the test will exit anyway. Obviously not kosher for a real
application, but I view it like leaking heap data in that regard. It'll
get reaped when the application goes away, and is again not something
you'd do in a real application.

-- 
Jens Axboe
