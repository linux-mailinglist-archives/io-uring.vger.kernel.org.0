Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA68840D173
	for <lists+io-uring@lfdr.de>; Thu, 16 Sep 2021 03:54:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232171AbhIPBze (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Sep 2021 21:55:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229816AbhIPBze (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Sep 2021 21:55:34 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67E2FC061574
        for <io-uring@vger.kernel.org>; Wed, 15 Sep 2021 18:54:14 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id h9so5050129ile.6
        for <io-uring@vger.kernel.org>; Wed, 15 Sep 2021 18:54:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=WtNmc6qqmH7pLBdaQblb7eZLauQJCuXmNOHa3K79qE4=;
        b=sVdToojuWdHZYWvGSy6DsSXlYF5fhE5qGkjGCETDDNXvnu+hjvR7Y8P7QmYW18f3Cv
         O0Nu1MqA8+xJY+cMhxzri4sv+hYHbXji0BB624gYvbUIGeIel7OEl2T+v5ipBCazpkYr
         48knVF5Q9qYDHyhoY1B8rVqI2W81kH+thpCNOGtJzwx5TO1jeqLxR8KwAJcbp5i5ujj7
         adCRpxj4SST2a1au7DWhCznMZrsjTubkEtznpf+QE8eDU/tXWKuC0UTiiYM6OewQsGA8
         gg6+utOQlmWSX01q+O7xPpGZTk/iwheNvyaEc+IpP6PDDXhVr8fmX4vZx7V2UStbDCmF
         FOng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WtNmc6qqmH7pLBdaQblb7eZLauQJCuXmNOHa3K79qE4=;
        b=sDZGf7u/PXIsvsnr19aN7djycrBfjjWIE2bPERnkGWBCSA/lBJEEx6XJoOTOK5f7Vb
         vfzlcQkjGaQqoW0Jeumfu4FhxT0EkBaALaZXJClycAfQz8kMhXdJGf2Z+EFYtarcu10c
         +UOX+xPf5jodwtUNHhwGd0a3TRPDs5By3N0iapYc/a7wHwCoge++0ntqokifiQg8H+Uj
         Sw/1GtHATkyec0bVeD1pJHl7oG6Q1T+7a57lyNqN8kmEf2ov9tCjmRbsvKB6LBp0t52M
         /NuDucOb75g1YRBv1im1KOsUnIq0OBqO8uifiqpCcc6nLg2coifoJwnq2vJUE4/qgDSr
         Z45A==
X-Gm-Message-State: AOAM533dpYUugBt2Z7P81Ltcie9PhFmK5h6pm/pgysR1LQcvQ/3pBXnL
        8GEQHyJlLSaqMU0OpZzremiVKI0R1VHYrQ==
X-Google-Smtp-Source: ABdhPJwUvvGq0cyIB3VfXWaduyKXymM6PRUgyjiaHaisTgV5nF9E1D5jS/7o5wn1/ouiibdWvbBQgg==
X-Received: by 2002:a05:6e02:13ef:: with SMTP id w15mr2199524ilj.255.1631757253700;
        Wed, 15 Sep 2021 18:54:13 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id g8sm848674ild.31.2021.09.15.18.54.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Sep 2021 18:54:13 -0700 (PDT)
Subject: Re: [PATCH for-next] io_uring: optimise io_req_init() sqe flags
 checks
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <dccfb9ab2ab0969a2d8dc59af88fa0ce44eeb1d5.1631703764.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <5e041f1e-c8e6-d911-e558-e5d1269e5534@kernel.dk>
Date:   Wed, 15 Sep 2021 19:54:12 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <dccfb9ab2ab0969a2d8dc59af88fa0ce44eeb1d5.1631703764.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/15/21 5:03 AM, Pavel Begunkov wrote:
> IOSQE_IO_DRAIN is quite marginal and we don't care too much about
> IOSQE_BUFFER_SELECT. Save to ifs and hide both of them under
> SQE_VALID_FLAGS check. Now we first check whether it uses a "safe"
> subset, i.e. without DRAIN and BUFFER_SELECT, and only if it's not
> true we test the rest of the flags.

Applied, thanks.

-- 
Jens Axboe

