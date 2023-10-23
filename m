Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5177B7D3F1D
	for <lists+io-uring@lfdr.de>; Mon, 23 Oct 2023 20:22:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230345AbjJWSWz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 23 Oct 2023 14:22:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230220AbjJWSWy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 23 Oct 2023 14:22:54 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A09FEBE
        for <io-uring@vger.kernel.org>; Mon, 23 Oct 2023 11:22:52 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id ca18e2360f4ac-7a950f1451fso15303139f.1
        for <io-uring@vger.kernel.org>; Mon, 23 Oct 2023 11:22:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1698085372; x=1698690172; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mL2SL1UTe47E7KyTXc6vVLrKBWghoV9pqxAQKd+Y9o8=;
        b=A2BGaMrX9hQUSuUzZ5L2Ok29lMsoFMsX5o/pqTMyzNxDm8fUK+6ZgeiycIUMlPQvqS
         gNSrWsw+HED9GnR1rE3cBRXTtQFlhKisB3ISXKHz/NJfJVAgJVaAgcbENiPOtISYei5V
         y4R8bZpJzLHZUnRltoh4tbiUZr0yibTi25JNKS6IH3Oc9HBe68moqikrdSKZu5/XSovG
         3i1ORNUaBTuKFvP8MnAGqvteq66iJOzTX2AnATnStqEnJNPZ8aKOZ18SkoU/4qnNYgL8
         FDBBUQL3fIbFpI18JAQ5kawP6gvdNviDVHHCyJ2NPgMXlvTjQD5KTS0B6+9oVkqPbk5O
         3Ikg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698085372; x=1698690172;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mL2SL1UTe47E7KyTXc6vVLrKBWghoV9pqxAQKd+Y9o8=;
        b=eN8QsuKAq/iUoz61EKwfFUMjfnA4ZsEqktIImf/Ev2/A4kq+sjpx/j6TlH7EefXBAd
         BkummQc4gIEp/JUoynFpbEWJ+27VYnVABIewnP6plMwR72HsNWkt6dth5JvO1Dq2F+I/
         5/LKJDucxW3xwieyx9mSQnpHqEGJyPa1gHEp4G+nxYwyfp0S54m5xAiaAAKE3kZ5aBTv
         uR8fGvJaR5v+XD2xOmKsE4pYoqfrEXR0PQaCb1ChNxvlhAtv88IGgwaBsE7l4zWp1VD3
         /t/tsThQNvh0Fm7/VbZ/EFhA1gW77xkoi89wHuYKR4yTymOG9dU0sqIRdpWdXWQPWdyk
         bqrw==
X-Gm-Message-State: AOJu0Yzm7zfSsrvRRS74kyUKYm8s6mQt2o+pdZSPnZxxaZBxttr/dHVQ
        IerOVReRjj/uU6+lczdiK6PqtU3FCdc0kjsN0VOhLw==
X-Google-Smtp-Source: AGHT+IG9p3lx0nNhwmXWuzQQ7MxQGcbpTRXLqGn1GvCfXk85H1roISEiNmPIyOc9+hrr4jvCBn8gdA==
X-Received: by 2002:a05:6e02:320a:b0:357:4682:d128 with SMTP id cd10-20020a056e02320a00b003574682d128mr10572678ilb.1.1698085371995;
        Mon, 23 Oct 2023 11:22:51 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id w11-20020a92db4b000000b00357ce043118sm1434098ilq.79.2023.10.23.11.22.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Oct 2023 11:22:51 -0700 (PDT)
Message-ID: <1c9550e7-16f3-4bae-a55e-c5091290429b@kernel.dk>
Date:   Mon, 23 Oct 2023 12:22:50 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] io_uring/fdinfo: park SQ thread while retrieving
 cpu/pid
Content-Language: en-US
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        io-uring <io-uring@vger.kernel.org>
Cc:     Gabriel Krisman Bertazi <krisman@suse.de>
References: <04cfb22e-a706-424f-97ba-36421bf0154a@kernel.dk>
 <3cc4c3ab-9858-4308-8c96-dbf5aa1314a2@gnuweeb.org>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <3cc4c3ab-9858-4308-8c96-dbf5aa1314a2@gnuweeb.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/23/23 12:14 PM, Ammar Faizi wrote:
> On 10/23/23 10:29 PM, Jens Axboe wrote:
>> v2: use the sq_data lock rather than doing a full park/unpark
> 
> Since v2 no longer parks the SQ thread, the commit subject also needs
> to change to lock(&sq->lock).

Oh indeed, good catch. I'll adjust that locally.

-- 
Jens Axboe


