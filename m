Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B43C5EB66E
	for <lists+io-uring@lfdr.de>; Tue, 27 Sep 2022 02:45:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbiI0Aps (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 26 Sep 2022 20:45:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiI0Apr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 26 Sep 2022 20:45:47 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC35984E53
        for <io-uring@vger.kernel.org>; Mon, 26 Sep 2022 17:45:46 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id i6so4108737pfb.2
        for <io-uring@vger.kernel.org>; Mon, 26 Sep 2022 17:45:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=r9kWVnIz+w584NZU7M0ieJsslzqBXXhc/AvsKgAFWWs=;
        b=uy9XQTAQY+XbpwWjxwmC6BdjfCzSfBbqby0vjXm5Az4Ndk+cfptSkbiVQ57w2lMpz5
         FHDRRLKpP7D5RdNyXiw5hBY3bgLU8zrcpM2B1xAJoFpWP5qcVY92AyUL1LeBrAcvNJK4
         UVlT1FrAsjIcNuMbf0qZBzxL1e4v49jKKZ9TynDwrKHLOBCVkRTAW5HA1b6h5WwPEN0f
         BtTRcRUZN1ugs4y41B4upjuQAJWssniafyWI8qJwivSkH1byZjCQIlQWT2+k/v95mtwW
         9Eo1eOd8hSp6JEoKjXGVujunIM49U2w/0veZ8paGqL1FhIucN9MOfEDfbFG9FZLo26z3
         FZYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=r9kWVnIz+w584NZU7M0ieJsslzqBXXhc/AvsKgAFWWs=;
        b=bVgfecyR9BRbz4xgsqj21DnWxwHSxSKiyhKEdaXocaxysfXRMZhG5BSZNe4M18xXmY
         /cFawA+oQC2hQrlCCoa4Z+POvGYvCiPGsqhc8VSTLiwWy93kjdp4Hnr8Xx870ByLNlZe
         ZVOs3rE3U2moY+FScWmKUeS7101xIeNjs+DEL9L0WC5rzTf2SFw0negvBpglYHeaYA+y
         /Kq+G0d748OZfk7y2a6TSw3YTLHVUOwg3EuOBHS7zglvWQlaJsnJu2imr5XTfKB+fki9
         ZiB0iZ5IaMh7QCDb33CerWyeeEEH30+V1vnUYltN9Q1seM+LJ6yo/rmW1/u5ASWvJDqD
         HaWA==
X-Gm-Message-State: ACrzQf33ku8N+bhtDuLLtVcrMJWShH4YIadeFx9yn4C2x6az357Be9Zs
        P0A8gchxuhaB5zVZs+Nr9PmNEMfBBmayWQ==
X-Google-Smtp-Source: AMsMyM70wsqhynNDS2aBVX3GRp/qM75B1MD4KhhMnbF1D8oI79/NNX01N1A2IS2aed5irCPFR7lFEQ==
X-Received: by 2002:a05:6a00:e8f:b0:536:c98e:8307 with SMTP id bo15-20020a056a000e8f00b00536c98e8307mr26281939pfb.73.1664239546215;
        Mon, 26 Sep 2022 17:45:46 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id q6-20020a17090311c600b0016c4546fbf9sm52276plh.128.2022.09.26.17.45.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Sep 2022 17:45:45 -0700 (PDT)
Message-ID: <b6e7e6cb-521a-cf38-c71c-3db5f09ad6ae@kernel.dk>
Date:   Mon, 26 Sep 2022 18:45:44 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH for-next 0/2] rw link fixes
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1664234240.git.asml.silence@gmail.com>
 <166423939676.14387.16777903330163991810.b4-ty@kernel.dk>
In-Reply-To: <166423939676.14387.16777903330163991810.b4-ty@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/26/22 6:43 PM, Jens Axboe wrote:
> On Tue, 27 Sep 2022 00:20:27 +0100, Pavel Begunkov wrote:
>> 1/2 fixes an unexpected link breakage issue with reads.
>> 2/2 makes pre-retry setup fails a bit nicer.
>>
>> Pavel Begunkov (2):
>>   io_uring/rw: fix unexpected link breakage
>>   io_uring/rw: don't lose short results on io_setup_async_rw()
>>
>> [...]
> 
> Applied, thanks!
> 
> [1/2] io_uring/rw: fix unexpected link breakage
>       commit: 99562357ddaa4ec7f62e0cf68c13cbcde41e8e8e
> [2/2] io_uring/rw: don't lose short results on io_setup_async_rw()
>       commit: 819c4df334438b7d47ccccb5549a8b862ef38e03

Oops, saw v2 after this. Dropped this series and took v2 instead
to get the attributes.

-- 
Jens Axboe


