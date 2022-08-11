Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A82D558FE6D
	for <lists+io-uring@lfdr.de>; Thu, 11 Aug 2022 16:35:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235266AbiHKOfo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 11 Aug 2022 10:35:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235558AbiHKOfg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 11 Aug 2022 10:35:36 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE31F5B784
        for <io-uring@vger.kernel.org>; Thu, 11 Aug 2022 07:35:34 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id y141so16636562pfb.7
        for <io-uring@vger.kernel.org>; Thu, 11 Aug 2022 07:35:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=eeoOp3oav/Act9cWRNSAB9I+E0THPSuYxHn6PdI6waA=;
        b=laBdP2WYFPp1+YOf7qsuN11tihzz9drTqpIHgcUD/TAgQXaZ2ZsoFDPm2Zizo8zX/M
         oC5C4INgN7i5n27CD+zALjS4Y/CkVlHq+5JymgeESKrbXUXMyKWrkErIdFESCeKaSFzg
         11bqMvsB4PyZCedBz87Jm7VGozOFV/hkgWeJYRJ2m5nCDcCU5nvvEF0jRMqGDdqSuj99
         K6r8pUhgpe5h5XCvFgAtal0UMkYPfSI5jmK2loX7xL8w0RIgO2JTmK6xKGHsVx0WnOkp
         xy6C4fyuAGvXHCv1g/9AEyxDfHjKpaKn+pcl+wG4TRl7HQAUPtIa59yj5jYx70r8lHEV
         ozFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=eeoOp3oav/Act9cWRNSAB9I+E0THPSuYxHn6PdI6waA=;
        b=pNnLodz2AnJns4mQk8Q7loZe6OTNjsq4CIhkE1uvYWKWdcd4dfh/Kr0wZfoCKe+Cki
         eD/LQ/SvAeSEVgN3fCZgdVkA9235A3eYIWjvdK6uMyciGGcIJyhByavkd88/jEoWR7Fs
         HBD2wLC0T1zTwh9S5qWHPyXAHgb4QwQA2gsczYrkZOSTr1TcqG5v+qFHdhH/Xhy5bP7G
         fc6dPrivaFX9cuI2EowKpMRHmSoFOm7Mmg0qNDICkd5PWIy8hoo2tnrzyTl03ICfA83C
         kR52/GbXVaw9WabHNOz8gIhjytJ1pRDVbwmqtz4fN6lsOxn/VI0zsOuXx7fMyhZn+as4
         Y7zg==
X-Gm-Message-State: ACgBeo3Ppe5A4yoW8bH0DgmJ9qV0VCzLdAAAFBWVJyTg1MVcs4rRvfpb
        +n0nnCzcB6vUJt00QgqLuhRLsJY8GHm+Eg==
X-Google-Smtp-Source: AA6agR5V464bDXoT0RwF9wxQXHuOvZSfHFyv/KhVT35/SvV6tbuxAEyj1wvYJpfjWUbGvIfjVN2zuA==
X-Received: by 2002:a05:6a00:158b:b0:52e:6fe3:537d with SMTP id u11-20020a056a00158b00b0052e6fe3537dmr32108999pfk.51.1660228534111;
        Thu, 11 Aug 2022 07:35:34 -0700 (PDT)
Received: from ?IPV6:2600:380:766f:10a9:aeaa:ac41:5e56:1dd? ([2600:380:766f:10a9:aeaa:ac41:5e56:1dd])
        by smtp.gmail.com with ESMTPSA id n16-20020aa79850000000b0053249b67215sm75040pfq.131.2022.08.11.07.35.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Aug 2022 07:35:33 -0700 (PDT)
Message-ID: <19a8a47d-2283-3c7a-a1d5-56704285aaa3@kernel.dk>
Date:   Thu, 11 Aug 2022 08:35:32 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [GIT PULL] io_uring fixes for 6.0-rc1
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
References: <6e669626-3920-47c0-8a9b-a94c229f1120@kernel.dk>
In-Reply-To: <6e669626-3920-47c0-8a9b-a94c229f1120@kernel.dk>
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

On 8/10/22 7:01 PM, Jens Axboe wrote:
> Hi Linus,
> 
> A few fixes that should go upstream before 6.0-rc1. In detail:
> 
> - Regression fix for this merge window, fixing a wrong order of
>   arguments for io_req_set_res() for passthru (Dylan)
> 
> - Fix for the audit code leaking context memory (Peilin)
> 
> - Ensure that provided buffers are memcg accounted (Pavel)
> 
> - Correctly handle short zero-copy sends (Pavel)
> 
> - Sparse warning fixes for the recvmsg multishot command (Dylan)
> 
> Please pull!

Of course a few more things came in right after sending this one. Just
disregard this pull request, will send another one in a day or two.
Thanks!

-- 
Jens Axboe

