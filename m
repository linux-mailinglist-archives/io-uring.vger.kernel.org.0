Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09E4D753E7A
	for <lists+io-uring@lfdr.de>; Fri, 14 Jul 2023 17:10:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235488AbjGNPK3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 14 Jul 2023 11:10:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235858AbjGNPK1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 14 Jul 2023 11:10:27 -0400
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89A613A8C
        for <io-uring@vger.kernel.org>; Fri, 14 Jul 2023 08:10:18 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id e9e14a558f8ab-3463955e8c6so1397315ab.1
        for <io-uring@vger.kernel.org>; Fri, 14 Jul 2023 08:10:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689347418; x=1691939418;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=N+0bo1A0pIC0yWkAcCX4SV3mNtEnYae4fbz/HivthS8=;
        b=eGm+mzbwakWAjbMb6AVzDzyUMqQn4SGbnF6iGH1ZX6e+lbROw0F8RcpwHPdk6as8bZ
         gCy8E7KLnDvkETEvEtKFVySKfdfuVA0gDdq/ggQ2M332XKv5o4J8ZJSQpTzO4IGuh5kK
         Pq/qJJWyn8QRXR3q83pFs0DcsLzxAJVUOz1t1YGns6mtth7Rw3IihGDZSLcl0Jynyseo
         glSHhZlEub32Ks5AKK9g0PQwlRKT0oKB9LGtweRQRvwj0PUNk5U7dikzwOf9cB/lxKPG
         LluUvzH/8cmB0OAX2/9+WeVO7lRZJvPB2rUuc8Ed9HIsb2AzegI1LsFYTgUiV699+EKU
         90cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689347418; x=1691939418;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=N+0bo1A0pIC0yWkAcCX4SV3mNtEnYae4fbz/HivthS8=;
        b=agxqyNFhO4VYH3sFLOQd1iYN3r9VKR+3/YrM1VJ31Rzq44/fBiCYocjXVHtXOEX15A
         a7XxwUGhg1/I23Oz3bhTMmLjvjhEmmPy1SfmvOSDXrTpQm/1FqVPFzw11CSicyd2HmpP
         Lsqq5fntrMAn2fZVhzgT8JzeqGZ4oPLocPxnh3syKmpptY6cbZfOxUtp/gfGWiVsw1Qr
         +OEAb3EcQNIfpvm/oai+AvtipjvC+/bEMRpI8UrvXOlK0eEx/XpOIAzVHuGmv8bHAcvz
         vQ6ABpq9EB7MtusRp0Nhtrd4ZdGfbIOqo5ZMfHHjsaJ/8MIqY71SIHxptfVG5QR1FoGK
         MaTQ==
X-Gm-Message-State: ABy/qLYLBxFZnnMCk7nPjWrLe4Z+8MxxSeQQEKhWvfJnnGTwn1TSPNOp
        3Y3z4gVfTtaA7qdFXfGUgAJO8A==
X-Google-Smtp-Source: APBJJlH7efkmR/mKOGDyLyVFmiiKisdxFqSupgj0fXefQZnTyYXQLYk53140cugOtM0hgMwG5iPdtA==
X-Received: by 2002:a92:a80a:0:b0:345:e438:7381 with SMTP id o10-20020a92a80a000000b00345e4387381mr3474119ilh.2.1689347417863;
        Fri, 14 Jul 2023 08:10:17 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id k9-20020a92c9c9000000b00345babb873csm2790571ilq.64.2023.07.14.08.10.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Jul 2023 08:10:17 -0700 (PDT)
Message-ID: <4d9e696f-f4d7-9e20-4361-2a97460b37ba@kernel.dk>
Date:   Fri, 14 Jul 2023 09:10:16 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 4/8] io_uring: add support for futex wake and wait
Content-Language: en-US
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, andres@anarazel.de
References: <20230712162017.391843-1-axboe@kernel.dk>
 <20230712162017.391843-5-axboe@kernel.dk>
 <20230713111513.GH3138667@hirez.programming.kicks-ass.net>
 <20230713172455.GA3191007@hirez.programming.kicks-ass.net>
 <bcf174d8-607b-e61a-2091-eccd3ffe0dfe@kernel.dk>
 <20230714150850.GB3261758@hirez.programming.kicks-ass.net>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230714150850.GB3261758@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/14/23 9:08?AM, Peter Zijlstra wrote:
> On Fri, Jul 14, 2023 at 08:52:40AM -0600, Jens Axboe wrote:
>> Saw your series - I'll take a look. In terms of staging when we get
>> there, would it be possible to split your flags series into the bare
>> minimum and trivial, and then have that as a dependency for this series
>> and the rest of your series?
> 
> I think you only really need the first three patches, and I hope those
> are the least controversial of the lot.

That's what it looks like to me, and yes those look trivial and risk
free :-)

I'll just put those at the base of my series for now, and once they are
stamped, would be great if you could then stuff them in a stable branch
that I could pull in.

> After those, I can implement the extra flags independently of the
> io_uring thing and all interfaces should just have it work.
> 
> So yes :-)

That's the plan then!

-- 
Jens Axboe

