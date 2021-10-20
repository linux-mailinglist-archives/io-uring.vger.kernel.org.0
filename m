Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E62A6434F61
	for <lists+io-uring@lfdr.de>; Wed, 20 Oct 2021 17:54:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230398AbhJTP4y (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 20 Oct 2021 11:56:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229952AbhJTP4y (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 20 Oct 2021 11:56:54 -0400
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BF85C06161C
        for <io-uring@vger.kernel.org>; Wed, 20 Oct 2021 08:54:39 -0700 (PDT)
Received: by mail-ot1-x32f.google.com with SMTP id l24-20020a9d1c98000000b00552a5c6b23cso8748829ota.9
        for <io-uring@vger.kernel.org>; Wed, 20 Oct 2021 08:54:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PhLwty28vCvNZLgw069sXpB0Vll3DDYU0wThiq3ImDI=;
        b=w9hfdO/uti83kRx1XnfnMfaLmGyj7meTGje7nVpMZYfbaIpC80cZZxZKpFic5BMUMh
         V80Cn03Bs3vqg3ahUuzvV10BBHjp5p0JdeN2j23KAyr+XYmGGtIrVE/772jHWNVdXC1y
         UVAHAzlG5r277y+SvbCo89XT2OV653ofhpHoKeb1Nmazx3CjUVHfrbAiieE91qUddcKd
         HZ5p3dDVXSSmH8wTK98nGrhYi+i6IEN/zyFH9PpCvCazJwgidvLkVE4XvX0vRE0vz7tH
         DOiQLzdakaZuaMV1Dxwt3zdsiqbAlqKbwqbW3yyw7yHyDeQcav8Aqq/ZMsClYyGMrQTh
         KF0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PhLwty28vCvNZLgw069sXpB0Vll3DDYU0wThiq3ImDI=;
        b=s5e7S49HxzwbpzyMPJwl0XDf6F2p08oaoVpbDlVgE+/z4z8u8L8KZaFzYKDH5K7TXL
         B9HuE8Ul0lUq3tFOm4jHfgQYgmX3hiiNYO8n5bglLbZkpFst16sSe0Gf8oj4Tw5rsf4f
         1ys0ObZTvDJxXvX/UenZ/i2/sHS8gANQGOvbUaPePV9ynoxjcB8pUZtSCmfWkkIhyOXf
         dEdZTFbfincykcYmQEZcGQLX36nhLoWyep5X9b9MrOYzuTQCHv7ZsiPnpJi1tuuxXvi7
         jQpV/bAdzXbDxPxq0no3ziQJywRHFLEO7GHPnrchfSA8Yk69W5RC8FAV+F+yBYz5SziV
         Uy6A==
X-Gm-Message-State: AOAM532RFZgh+gVDHi/1zMhS0iaXDGUcEJYVDktQAIB13XtgGj5tB06I
        K8u558PSQPFSlat9To8G2NleQA==
X-Google-Smtp-Source: ABdhPJwnkUxkmjNfrYRHsa9NfXj8ZgUgUW1VVdmMRYEuxgP1VEaCnqLOlu9B0nSWvENq4gSgL2d28g==
X-Received: by 2002:a9d:5382:: with SMTP id w2mr45622otg.102.1634745278873;
        Wed, 20 Oct 2021 08:54:38 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id b9sm226917ots.77.2021.10.20.08.54.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Oct 2021 08:54:38 -0700 (PDT)
Subject: Re: [PATCH v2 1/1] io_uring: fix ltimeout unprep
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     Beld Zhang <beldzhang@gmail.com>
References: <51b8e2bfc4bea8ee625cf2ba62b2a350cc9be031.1634719585.git.asml.silence@gmail.com>
 <163473846179.730482.6681458910857538254.b4-ty@kernel.dk>
 <7739475f-e07c-3708-4ebc-d22223585e2c@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <aacf29e9-bc5d-52bb-7b24-70a648d55c2c@kernel.dk>
Date:   Wed, 20 Oct 2021 09:54:37 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <7739475f-e07c-3708-4ebc-d22223585e2c@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/20/21 9:45 AM, Pavel Begunkov wrote:
> On 10/20/21 15:01, Jens Axboe wrote:
>> On Wed, 20 Oct 2021 09:53:02 +0100, Pavel Begunkov wrote:
>>> io_unprep_linked_timeout() is broken, first it needs to return back
>>> REQ_F_ARM_LTIMEOUT, so the linked timeout is enqueued and disarmed. But
>>> now we refcounted it, and linked timeouts may get not executed at all,
>>> leaking a request.
>>>
>>> Just kill the unprep optimisation.
> 
> Jens, if the patches are not too deep, would also be lovely to
> add reported-by to this and the other one.
> 
> 
> Link: https://github.com/axboe/liburing/issues/460
> Reported-by: Beld Zhang <beldzhang@gmail.com>

Done

-- 
Jens Axboe

