Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F7AE3B238F
	for <lists+io-uring@lfdr.de>; Thu, 24 Jun 2021 00:24:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbhFWW0c (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Jun 2021 18:26:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbhFWW0c (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Jun 2021 18:26:32 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78701C061756
        for <io-uring@vger.kernel.org>; Wed, 23 Jun 2021 15:24:13 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id v3so5385110ioq.9
        for <io-uring@vger.kernel.org>; Wed, 23 Jun 2021 15:24:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=rarFiEcktOV4PMyvDV95VcjSVtUjs4RdLS31HBip5uA=;
        b=lE18ucs7drfzcX+0pjDbjf8JgBhEqOnLDKsssvstFzfaLG4LXqUhNmb23n2OZm1CLW
         5t4kdONyJzEb5dcke/lmdRBs5T3a3UFcCGh4xZMhNgx7kpgoWZVHfuuuqCSXCUlBZY9B
         X12yTjz32/pvuyfob3DXa6+5Na58NQXckEia2kAD0lyvMQGf0MWhira1HTjvFXXQLwXi
         0aAED1oC2VMRSdseHbd28orq3+1n4VoQwdfrc4qMHIe2xHBM6Fc4OwPQUV5S7osjO3Rf
         q7oJVXKbb2mDbKR2YIGLt1m/r2KmgvwX6bNJf+IQRKJd4NtGFeiGkW8jFzKrdulyZWvk
         nVmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rarFiEcktOV4PMyvDV95VcjSVtUjs4RdLS31HBip5uA=;
        b=KIp5PmNP4OXX2mgfRds+0IKTLwRuCroE2Pa05uO0to5pb7N1Ev6n1G+6EwU1AqdvxB
         OU8W3E9WCLEtXDQPHgfoN0vVIh3lKftja8xhDq5XMsDEBxttHInAGeZ1e/R+rtIkyhzI
         E8+ub/GVBtLCkZ9fwgWO9IbR/ehQKqCFes50eqhEM/+WJGxHD6q5xHjSoHPonwJdZsmC
         h/RqWSeE0Nn8iu0aoD80nfD+v0Ea2t1nK3iwhBN9hkQ2mW4tPoXZj3smWYXquV1JVuLZ
         9ADAP+nyyHr2eQY0XCoir5MmAysCA8zQpA9OhxX4IBn3z0paJYk2tjVrNO1Fel3KebDs
         a6MQ==
X-Gm-Message-State: AOAM531XpM+3H5/kGGpiUP3XmksBxxV0Pkl9Rzcp9mKVAhSSVFrjYUjz
        L3dHYxIUFJye7YIhGO/nzgbseQ==
X-Google-Smtp-Source: ABdhPJwUZbCdMymItjEzWVPFYctd082FTIQe8OkbfvcjtyCef5RL0iJF8c+C8d4s/rDpQAyCEg8muw==
X-Received: by 2002:a05:6638:379d:: with SMTP id w29mr1727299jal.2.1624487052609;
        Wed, 23 Jun 2021 15:24:12 -0700 (PDT)
Received: from [192.168.1.134] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id b23sm168772ior.4.2021.06.23.15.24.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jun 2021 15:24:12 -0700 (PDT)
Subject: Re: [PATCH v2 0/2] Minor SQPOLL thread fix and improvement
To:     Olivier Langlois <olivier@trillion01.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <cover.1624473200.git.olivier@trillion01.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <e4b52e6b-2e03-58e4-8732-595c59adefbc@kernel.dk>
Date:   Wed, 23 Jun 2021 16:24:10 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1624473200.git.olivier@trillion01.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/23/21 12:50 PM, Olivier Langlois wrote:
> I have been investigated a deadlock situation in my io_uring usage where
> the SQPOLL thread was going to sleep and my user threads were waiting
> inside io_uring_enter() for completions.
> 
> https://github.com/axboe/liburing/issues/367

Applied, thanks.

-- 
Jens Axboe

