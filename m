Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E442214879
	for <lists+io-uring@lfdr.de>; Sat,  4 Jul 2020 21:45:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726643AbgGDTpo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 4 Jul 2020 15:45:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726153AbgGDTpn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 4 Jul 2020 15:45:43 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0217C061794
        for <io-uring@vger.kernel.org>; Sat,  4 Jul 2020 12:45:43 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id o1so7231275plk.1
        for <io-uring@vger.kernel.org>; Sat, 04 Jul 2020 12:45:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cDmTxwqjX6nBc+rZ5EqUO3QWtah2Pbwxcw4wvdpB+FQ=;
        b=dBNu7PGyboI8cOvT0BU3O4l/VU+vPyuFm4t3rdJNJSvf1lzApP82YETZDI+k/MyJVK
         AvoLO278hXMevTtzavIRn1S6mmuhddXCga1cRfykkF6/5mQ3WAp1BsVbFebQNpIHkAz/
         akFyHWHAvJQ9VcqHOo34DbD4d8XFrFTE3wYD4pl5+n2Lav0YvODkmxwQl9U44tlNoI1e
         uzQVp17yZTd12uXRYtfNv+VWmEGRO1UmRdK2gPtvnKZssxxjlOVdxG8WofQZ2Xi4bGBv
         1NBqhw7HzQGwzuon2s77CDOCuF//Ia+B+/Q2gKVgmuxnfIR91lbWMgbH0ICANycBWCnA
         9VuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cDmTxwqjX6nBc+rZ5EqUO3QWtah2Pbwxcw4wvdpB+FQ=;
        b=QzX4m2xa63+jyDZMM9ZSYXUKfM7byhqWsGePE2eYC8pdTI1zrUrHPlbFPnBgZzWKg8
         Fr5+CiqAqwu/6/MTp7dhuf3kp9qbuT/TWosChWNv2O9ELQMfLUTZ5ImUqWH9uKIrAoax
         n+xR1Mvjx42mKWweNl99IYowRHA5JNvFs5dAKHor/b4hz6QlliwXQ0hrMTeG/PL2HeCs
         UZQzIR+lXxeXLPWyfOGyqPt3v05t7G23QArl7c6hlI0jlQv8S0SFtqIGNe4DRSIrlu0n
         GzuI723QvCr94srJDSFw0iQHUGM0ReFTdJqzHzV3iFhQThsFt7tofZ7kBFGCTnK2qtg3
         E9Pg==
X-Gm-Message-State: AOAM532mTcYmUMZLsUNbd2d1Pq/vspokyl4U1QDY+CZIrWSdoPZuReGP
        qq1EzY7ahmDolhIzDS8MSjCZfw==
X-Google-Smtp-Source: ABdhPJzlVN5qvSF5yX5Yn58Y0coVRgtUPdGoHK/yVuKyfVuPtq/MRcaY2qfE25ZFLimcmzO99gochg==
X-Received: by 2002:a17:90b:11d8:: with SMTP id gv24mr26555593pjb.131.1593891943006;
        Sat, 04 Jul 2020 12:45:43 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id 144sm15357562pfb.31.2020.07.04.12.45.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 04 Jul 2020 12:45:42 -0700 (PDT)
Subject: Re: signals not reliably interrupting io_uring_enter anymore
To:     Andres Freund <andres@anarazel.de>
Cc:     io-uring@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>
References: <20200704000049.3elr2mralckeqmej@alap3.anarazel.de>
 <20200704001541.6isrwsr6ptvbykdq@alap3.anarazel.de>
 <70fb9308-2126-052b-730a-bc5adad552f9@kernel.dk>
 <7C9DC2D8-6FF5-477D-B539-3A9F5DE1B13B@anarazel.de>
 <f2620bef-4b4c-1a5d-a1e8-f97f445f78ef@kernel.dk>
 <c83cfb86-7b8e-550b-5c04-395c34415171@kernel.dk>
 <624c0af9-886e-0c5f-0c35-dd245496b365@kernel.dk>
 <a82e680a-7db6-3569-2b53-e43e087ef464@kernel.dk>
 <20200704191127.f4fqzleo4r53p647@alap3.anarazel.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <9bbc856c-3755-f007-09d6-a09f5ef538c3@kernel.dk>
Date:   Sat, 4 Jul 2020 13:45:41 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200704191127.f4fqzleo4r53p647@alap3.anarazel.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/4/20 1:11 PM, Andres Freund wrote:
> Hi,
> 
> On 2020-07-04 08:55:39 -0600, Jens Axboe wrote:
>> This tests out fine for me, and it avoids TWA_SIGNAL if we're not using
>> an eventfd.
> 
> I tried this variant and it does fix the problem for me, all my tests
> pass again.  I assume this will eventually need to be in stable for 5.7?

Yeah, it should go in with the original, I'm aware of it and will keep
an eye on it.

Thanks for testing! Both this patch, but also the -rc series. So much
easier to catch incidents like this upfront.

-- 
Jens Axboe

