Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CCA3624915
	for <lists+io-uring@lfdr.de>; Thu, 10 Nov 2022 19:08:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231157AbiKJSId (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 10 Nov 2022 13:08:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbiKJSIc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 10 Nov 2022 13:08:32 -0500
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD39B624C
        for <io-uring@vger.kernel.org>; Thu, 10 Nov 2022 10:08:31 -0800 (PST)
Received: by mail-il1-x12d.google.com with SMTP id 7so1381954ilg.11
        for <io-uring@vger.kernel.org>; Thu, 10 Nov 2022 10:08:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MCKfI4Yw+EIdc0EQpxxDDtfncLisnx8qWHLpEEIttd4=;
        b=LlPhhU0rvjfDTwZfam4iYJi/qFEPwdfvX9wJ+oO0+TwrGtRIT/AicWvxrQ90LRVjnb
         Wm4gG7uhTjQV4j2CGhn2Tb8jnjvn7rBHLfKearLovT/CE1ulLEKjZcj7NgUehfcBxDtM
         Q/ep8nqTbPhIjqvzr/UNnkyK4he3rlqZ53mRgpWWHne5JrclbROalewiVn+xAv0sDwAq
         qZOpAWlcUGbNtkP2Spthfef42hjwInK3HUc7/gSDFbBWaf4t6psMLTO5ZYt7U72+RZZo
         XUDT/MDz+zw6ApveE6Xm0AhiVgW1JM5Xlg4eC7or7G56dRXW2SHwu5QfnXPEaH3D0f0q
         XBxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MCKfI4Yw+EIdc0EQpxxDDtfncLisnx8qWHLpEEIttd4=;
        b=ucaTO69O+H8bOyUkEt+Na7ScnhTycdXPuzrcNrOeFz+wcJyjLsOR4VF51iTmuUUMAD
         x+f0GGIkZzGitZIov73MfmNoSExLIaU827e66YbeljvHGC1KSM/b6UlmPR5Sekhv22tl
         l+q9rCmpPF+Q9VOILAgWJOZq42DwlIYddEjH/OH6O8rN6tYQqpH++PfUPtSnXBom7DRh
         KLZtd1r9VlNW/hliwNtzY5fvVV1iHFh52HmJV/cT5rDAxbg47G1gkIk38NEyGdVkOuCx
         qyKHI5LMK6OzmuE443vyVY98AH62y7wd8Ygn6Xntk6QMxkw49g8uyCUCIMgIF+3ST1Qp
         n8qA==
X-Gm-Message-State: ACrzQf1lHWCS5ZDmZQ65LHyombOT0UyzymxU/GYnxfEinDwWoejtbPrn
        12yVoo+s3hUtroPjFOlYJEE79VfChbD1IQ==
X-Google-Smtp-Source: AMsMyM57SriVe8oiJgQqHaJWQJRrIrRewNrZw2XrAfiTBKjpUt/Ju0vl6WNDRauzImWZRhFUfeurfw==
X-Received: by 2002:a05:6e02:cb0:b0:300:e6f0:432b with SMTP id 16-20020a056e020cb000b00300e6f0432bmr3016478ilg.193.1668103710708;
        Thu, 10 Nov 2022 10:08:30 -0800 (PST)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id n5-20020a056e02140500b00300bd581944sm95500ilo.25.2022.11.10.10.08.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Nov 2022 10:08:30 -0800 (PST)
Message-ID: <ac6a421e-db41-379a-db74-f4578637eb78@kernel.dk>
Date:   Thu, 10 Nov 2022 11:08:28 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH] io_uring: check for rollover of buffer ID when providing
 buffers
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring <io-uring@vger.kernel.org>
Cc:     Olivier Langlois <olivier@trillion01.com>
References: <82171764-77aa-0f8a-a9c7-3c465ffe51a5@kernel.dk>
In-Reply-To: <82171764-77aa-0f8a-a9c7-3c465ffe51a5@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/10/22 10:55 AM, Jens Axboe wrote:
> We already check if the chosen starting offset for the buffer IDs fit
> within an unsigned short, as 65535 is the maximum value for a provided
> buffer. But if the caller asks to add N buffers at offset M, and M + N
> would exceed the size of the unsigned short, we simply add buffers with
> wrapping around the ID.
> 
> This is not necessarily a bug and could in fact be a valid use case, but
> it seems confusing and inconsistent with the initial check for starting
> offset. Let's check for wrap consistently, and error the addition if we
> do need to wrap.
> 
> Reported-by: Oliver Lang <Oliver.Lang@gossenmetrawatt.com>

Sorry, that was the wrong email, I have updated the commit locally.

-- 
Jens Axboe


