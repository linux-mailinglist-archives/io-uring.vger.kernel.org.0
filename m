Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8D4724FF86
	for <lists+io-uring@lfdr.de>; Mon, 24 Aug 2020 16:06:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725890AbgHXOGy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Aug 2020 10:06:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725780AbgHXOGs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Aug 2020 10:06:48 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7AF8C061573
        for <io-uring@vger.kernel.org>; Mon, 24 Aug 2020 07:06:48 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id s1so8738033iot.10
        for <io-uring@vger.kernel.org>; Mon, 24 Aug 2020 07:06:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Ua76pblU+7nsDLQxC3/2lfZ03EpaZdfkBHXJQNE0zLQ=;
        b=wZ+dWXBr0/PHMTaR22VJ0tgK7JfW+2iFS4yQxp0qrOsp0FjgtB35dFG92Qv1D1Yil5
         UJiZG/wl5sAlx6UJyFwgm/ugTQmGsntEUqH51XhO4lCdEf8NhLgJAMYNdR1+mWqZsFZS
         G1pw3esqZK/Jzuq9ECo5NoJp+FrTxabQScId1/aE88vsMRjYU/+yu5mqgN43rEgRYqPR
         Kfrn1DdPbqDXY/fsLjEWYRcBmPGecHdJk7c5byJAyp/Rp9OhkD6Wl6w+avRIW378cotE
         4bI2nIGEsSK+/VWQeYGjoxVhY6wVJylQqwZpxeCMtvUXd7rBpQ8609yFuCqSVeAqEXbR
         HxDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ua76pblU+7nsDLQxC3/2lfZ03EpaZdfkBHXJQNE0zLQ=;
        b=DQVpM+2+9RacU0mnrNihh+RD/7ifsDk6S+ieNDmpImh9uc6nuZ07bcJKpHdZ1FbbFN
         T//YmNhSRg4MWibFcLElIQaX8UJL9lMj84+feI4wEW1jwkiy4s0vp/oB1bQEwsoS5z+L
         Q1tcnJQhAmxBZgQ5UqM8OCxoI6mCJaXMey3clX7W7QVycRCw/klb5qUXqvRp8Jwm1CWO
         PSdCmtiJKkUaM/qW4T5RCy7bCtaXKlS4/J0tFvWmuptz66IeK+K0cDRDyj5DeLcHMwvP
         QpY/+O8mw6HVnbZ1rOYmQRIIpPUDOMSRGuHHvaYpChSXcSaKEAANd2KojTWepmQimuVw
         bwVw==
X-Gm-Message-State: AOAM533PistMvOj5goWjIcadeeCqx472cqXnOvVyqRk5JyGOoFgGGNiM
        1O3qwLHBJBBqZDqXbCiSwf345hwN7y3hZF8O
X-Google-Smtp-Source: ABdhPJwISmvrmVTROwfA+S7OtX9+L0L8xMkj9GGbiLxHWyWDYR3y54qDe8uFQjZVYrea7rDZRDK8mQ==
X-Received: by 2002:a6b:e517:: with SMTP id y23mr4971430ioc.190.1598278005329;
        Mon, 24 Aug 2020 07:06:45 -0700 (PDT)
Received: from [192.168.1.58] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id h7sm7283275ilo.51.2020.08.24.07.06.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Aug 2020 07:06:44 -0700 (PDT)
Subject: Re: Large number of empty reads on 5.9-rc2 under moderate load
To:     Dmitry Shulyak <yashulyak@gmail.com>
Cc:     io-uring@vger.kernel.org
References: <CAF-ewDqBd4gSLGOdHE8g57O_weMTH0B-WbfobJud3h6poH=fBg@mail.gmail.com>
 <7a148c5e-4403-9c8e-cc08-98cd552a7322@kernel.dk>
 <CAF-ewDpvLwkiZ3sJMT64e=efCRFYVkt2Z71==1FztLg=vZN8fg@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <06d07d6c-3e91-b2a7-7e03-f6390e787085@kernel.dk>
Date:   Mon, 24 Aug 2020 08:06:43 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAF-ewDpvLwkiZ3sJMT64e=efCRFYVkt2Z71==1FztLg=vZN8fg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/24/20 5:09 AM, Dmitry Shulyak wrote:
> library that i am using https://github.com/dshulyak/uring
> It requires golang 1.14, if installed, benchmark can be run with:
> go test ./fs -run=xx -bench=BenchmarkReadAt/uring_8 -benchtime=1000000x
> go test ./fs -run=xx -bench=BenchmarkReadAt/uring_5 -benchtime=8000000x
> 
> note that it will setup uring instance per cpu, with shared worker pool.
> it will take me too much time to implement repro in c, but in general
> i am simply submitting multiple concurrent
> read requests and watching read rate.

I'm fine with trying your Go version, but I can into a bit of trouble:

axboe@amd ~/g/go-uring (master)> 
go test ./fs -run=xx -bench=BenchmarkReadAt/uring_8 -benchtime=1000000x
# github.com/dshulyak/uring/fixed
fixed/allocator.go:38:48: error: incompatible type for field 2 in struct construction (cannot use type uint64 as type syscall.Iovec_len_t)
   38 |  iovec := []syscall.Iovec{{Base: &mem[0], Len: uint64(size)}}
      |                                                ^
FAIL	github.com/dshulyak/uring/fs [build failed]
FAIL
axboe@amd ~/g/go-uring (master)> go version
go version go1.14.6 gccgo (Ubuntu 10.2.0-5ubuntu1~20.04) 10.2.0 linux/amd64

-- 
Jens Axboe

