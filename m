Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF1EA3F7BDF
	for <lists+io-uring@lfdr.de>; Wed, 25 Aug 2021 19:58:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231602AbhHYR7n (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 25 Aug 2021 13:59:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231231AbhHYR7n (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 25 Aug 2021 13:59:43 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 649DAC061757
        for <io-uring@vger.kernel.org>; Wed, 25 Aug 2021 10:58:57 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id y18so153141ioc.1
        for <io-uring@vger.kernel.org>; Wed, 25 Aug 2021 10:58:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=4qkKGG+SD83l3lFuBfhw/aPClW2YzVxvWcfCxTW/8Iw=;
        b=WkE60/ZhGpfV27YfliZfV/3ztUoZutzAFyZOgy6xE+2uBmzBS6XPzkBZvmHA9eb6RM
         Ob6GirqQFwf3fErtSuP8GjFXk3hxV/Yix+bwgdKzOMFhzHrbHmB0xLBOWBovLQZ1hHpe
         KikjsXFuQVqJYLFMFBfzu99f1tb8TVD/rJf3UL79NiFG9ucCfZfn9s2X8nL9Ar3GeHhh
         yeaPTG9mZnYFHesD5iRelLTwNWq6Xn9FG31ErVf7jIHdk98U4E7i4GOV5ol4u13iDf3Y
         +akqK+z2yq7/hw0/ZCEQEW+qIuKqXH4huXoIp64M8yjmChQ20CcaujsJBkTHxTNtC6Jh
         iWxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4qkKGG+SD83l3lFuBfhw/aPClW2YzVxvWcfCxTW/8Iw=;
        b=ZIBES2r8D6l97c0T8k+NZ85f2Ki1ko9F6HmmxvW0S16yQUdYGQs8bFhKAyXciXfOEH
         jAiURE8OIa1041hWwSz7OaUEiCTYo+TTUcEN+7XP/TOZF1NMhux49XeiCX++EgPh1RSS
         LMdRCfSwB9l63GDyAKpVrZNK0/uMTMqF+waGRf5XiZ9qUzq9gImziDqaNYqDZl/Bh9DW
         2sBCnL5Pkv3ieGMFLhSDmWbAia6RYz3Km2Bj4nMxtUBrE3oi5XdKnvtJwLZT37b7DGnn
         IzdHOBGjm2ChsGuto9SuACnnSRC5QtL29Y5BBfE6Jo/xx6aIVpc5H0B3UN3IIZ9dUunh
         shCg==
X-Gm-Message-State: AOAM530PfM27i2WNkpXGXH4LUwfIlYSIlStoteISnqcGkcAIRjD6V69t
        LJ/MG2Y/zRmGGr/C8LuPbH+jpg==
X-Google-Smtp-Source: ABdhPJwy6QrfCEfrCvIB+MF5TBKJUyHxnez3p+ezKlS6jKTrFemOY2fwGSphZph0JxroZNoOAsvD+g==
X-Received: by 2002:a5d:990c:: with SMTP id x12mr17253637iol.122.1629914336819;
        Wed, 25 Aug 2021 10:58:56 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id g23sm238944ioc.8.2021.08.25.10.58.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Aug 2021 10:58:56 -0700 (PDT)
Subject: Re: [PATCH liburing 1/1] tests: test open/accept directly into fixed
 table
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        Josh Triplett <josh@joshtriplett.org>
References: <e4326cd1629f9f3c5db3aee7cd976d99df18aff9.1629560358.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <c3b0f5d5-9f4e-2977-eb3f-b86c78e9b2c7@kernel.dk>
Date:   Wed, 25 Aug 2021 11:58:55 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <e4326cd1629f9f3c5db3aee7cd976d99df18aff9.1629560358.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/21/21 9:53 AM, Pavel Begunkov wrote:
> Test a new feature allowing to open/accept directly into io_uring's
> fixed table bypassing normal fdtable.

Applied, thanks.

-- 
Jens Axboe

