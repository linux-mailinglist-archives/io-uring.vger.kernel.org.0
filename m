Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E75F6FB65C
	for <lists+io-uring@lfdr.de>; Mon,  8 May 2023 20:42:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229974AbjEHSmD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 8 May 2023 14:42:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229865AbjEHSmC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 8 May 2023 14:42:02 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7B6C59E9
        for <io-uring@vger.kernel.org>; Mon,  8 May 2023 11:42:00 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id ca18e2360f4ac-760dff4b701so30552539f.0
        for <io-uring@vger.kernel.org>; Mon, 08 May 2023 11:42:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1683571320; x=1686163320;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aOiU3DLL+j/h0VrJ9+wvAaTjkIuW4uAfTjBeqaSp4Eo=;
        b=WEzGqoAEbT6ufIzeocePwcRLqyqOAwDUbz1aeiAq8ka5altBg2TIH8wdDBSIVLGakU
         TenOwH1KUa29IV+YriaxxOi0b2+QY8DXDQ2jLjzl6NfsGCrwYJ/imEO051R66hicp1cS
         jckgQWHP3tBunnW0OMTHId0y/hskXiAT7E5xnUTTJtmVX+kbWe2mm+CVpdT85WuXBGXK
         mdVMg0E4+lULG5RhkBhzDgUULv7YxLMK9T5MfaLZ4QBtRoR9E57JUzO4Eq7kYsc9zfzI
         vJ96eTMghjXib1tYCre7HMKc3jmlTLrMtDmh3saKxTHEgkI4c0+q9TLALeBO0lwLiX8l
         zCMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683571320; x=1686163320;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aOiU3DLL+j/h0VrJ9+wvAaTjkIuW4uAfTjBeqaSp4Eo=;
        b=hh39SV2uGz6sofK/PlS9/lmu5S3tzeCBiurCtyMsWt7fpbhL2fA6LOs2+q3+zA97G/
         l4jKU+7TRW0CZamGWQts2EsOOhyMYDXrLhpWgR7OY/RnnOheH68NQctpsF8C8jSeWV9J
         7tJCvZ1OZrdFhn5VCd+JeoMAWKin3CHAEvfWwgrWdfesaLq0RM9FKV2s3Jt2jVam8f1X
         RvAnYH7LN6kHnKszyTpCskRbcrWYxXGvah8HPZ8UkhbBWQh/kI4IGTlZmLLjpZedQivH
         z7UWYmuJ+N+9h1Xoqgo76qXHcV9weuHbSDYMgPA3xHpTIx02KKs3Pb2yEKE0yss3wb9L
         hQsA==
X-Gm-Message-State: AC+VfDzurhe6f+biA7zFHNhkgL35aEftJFCWpusGtH+1fzQOiKZuidIn
        UgW4lNn9Xi/W974z5iIf4rd23w==
X-Google-Smtp-Source: ACHHUZ4H4cFhAfzI82v/JZ4s3Wl91ECSwQyoqKml28c/cb3Nx2n/sxwnrl+SjAhPBOJHqUY/Daf9yg==
X-Received: by 2002:a05:6602:14d6:b0:76c:54b1:3e7 with SMTP id b22-20020a05660214d600b0076c54b103e7mr547936iow.0.1683571320128;
        Mon, 08 May 2023 11:42:00 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id n14-20020a92d9ce000000b0030c0dce44b1sm2598205ilq.15.2023.05.08.11.41.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 May 2023 11:41:59 -0700 (PDT)
Message-ID: <fb84f054-517c-77d4-eb11-d3df61f53701@kernel.dk>
Date:   Mon, 8 May 2023 12:41:58 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [GIT PULL] Final io_uring updates for 6.4-rc1
Content-Language: en-US
To:     Chen-Yu Tsai <wenst@chromium.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>, linux-kernel@vger.kernel.org
References: <9b2e791d-aeba-a2c7-1877-797ff5c680a3@kernel.dk>
 <20230508031852.GA4029098@google.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230508031852.GA4029098@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_CSS_A autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/7/23 9:18?PM, Chen-Yu Tsai wrote:
> Hi,
> 
> On Sun, May 07, 2023 at 06:00:48AM -0600, Jens Axboe wrote:
>> Hi Linus,
>>
>> Nothing major in here, just two different parts:
>>
>> - Small series from Breno that enables passing the full SQE down
>>   for ->uring_cmd(). This is a prerequisite for enabling full network
>>   socket operations. Queued up a bit late because of some stylistic
>>   concerns that got resolved, would be nice to have this in 6.4-rc1
>>   so the dependent work will be easier to handle for 6.5.
>>
>> - Fix for the huge page coalescing, which was a regression introduced
>>   in the 6.3 kernel release (Tobias).
>>
>> Note that this will throw a merge conflict in the ublk_drv code, due
>> to this branch still being based off the original for-6.4/io_uring
>> branch. Resolution is pretty straight forward, I'm including it below
>> for reference.
>>
>> Please pull!
>>
>>
>> The following changes since commit 3c85cc43c8e7855d202da184baf00c7b8eeacf71:
>>
>>   Revert "io_uring/rsrc: disallow multi-source reg buffers" (2023-04-20 06:51:48 -0600)
>>
>> are available in the Git repository at:
>>
>>   git://git.kernel.dk/linux.git tags/for-6.4/io_uring-2023-05-07
>>
>> for you to fetch changes up to d2b7fa6174bc4260e496cbf84375c73636914641:
>>
>>   io_uring: Remove unnecessary BUILD_BUG_ON (2023-05-04 08:19:05 -0600)
>>
>> ----------------------------------------------------------------
>> for-6.4/io_uring-2023-05-07
>>
>> ----------------------------------------------------------------
>> Breno Leitao (3):
>>       io_uring: Create a helper to return the SQE size
>>       io_uring: Pass whole sqe to commands
> 
> This commit causes broken builds when IO_URING=n and NVME_CORE=y, as
> io_uring_sqe_cmd(), called in drivers/nvme/host/ioctl.c, ends up being
> undefined. This was also reported [1] by 0-day bot on your branch
> yesterday, but it's worse now that Linus merged the pull request.
> 
> Not sure what the better fix would be. Move io_uring_sqe_cmd() outside
> of the "#if defined(CONFIG_IO_URING)" block?

Queued up a patch for this:

https://git.kernel.dk/cgit/linux/commit/?h=io_uring-6.4&id=5d371b2f2b0d1a047582563ee36af8ffb5022847

-- 
Jens Axboe

