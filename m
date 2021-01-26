Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F025F305D2B
	for <lists+io-uring@lfdr.de>; Wed, 27 Jan 2021 14:30:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238374AbhA0N3B (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 27 Jan 2021 08:29:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S313529AbhAZWgE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Jan 2021 17:36:04 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54A45C061574
        for <io-uring@vger.kernel.org>; Tue, 26 Jan 2021 14:35:49 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id q2so7820108plk.4
        for <io-uring@vger.kernel.org>; Tue, 26 Jan 2021 14:35:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=U/gTopYltrrJc1dTREuk/A2wQizUgvSrGUICEAeE/K8=;
        b=Lob7zMlJuqwewE7KfMTDtxoQ1xEaslixZrytqcBXDc8eLSMjCC6VVyxqXxx5bat3s5
         jFpE/NxC5P7ARuCB/vU9lapdSWd4jbv6X2bIcsof7H3bIN0jHXOs4HtZoWsPicYwbEB2
         MNsOmcT+DtYGPqoQKK/Wp7tQp6BvyaMXg9ctBAseuFZg/EDHA/1WNOMQzc1YsAj1BP7f
         Kf8ZZzcrLVijyUXFzrTnZWWDv83faPW5q730fJ1qjXglY2LR/QZUs7vyq7cwek9Z2E55
         f6X7zSI4HtErssMsdXDYTgXtx+IfPuhGOVTaytV7FfuF+rjTPXVBJCb4hi8KqfjM0yLK
         FkOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=U/gTopYltrrJc1dTREuk/A2wQizUgvSrGUICEAeE/K8=;
        b=Dk+bxx4DzCORYh6iWdw6dPaGIQsaNT2/rPW8EZjTbyR7RZEvVfVPdy5eRJXJjdjIUs
         5i9MhYHjAh1qlAANIs/w17SM9rlqn10HOMm7CzOfBpDJwDPKIKsSeQ+43klWPzXpn3wD
         eJzR+2A9UyqwAN31QqEd+PA4yx5mlyJIWUxSolfiGnE8oIxl2is4yv4qxhfdaSHAnJyx
         iGjF35lX5ckO1rh6VtY69k6Nb+pCy5yIUdMU5va6ggQaOU1TLxiUaDm6Ii4uSzAjWNTo
         1wU9c69c/G8ZkdDkNj8UZABP6brjj0J49jZ6I5YAYR7XGaxu3NyN0MOpAaUiN6VWJezi
         l3+A==
X-Gm-Message-State: AOAM531zNwwuytCIpQaD84AKVxBmF63qTQ5+mUKLQ8uR2YwDTPZWpoRF
        69EC1Bc+Cz4phL9QxX4BvV2ZwA==
X-Google-Smtp-Source: ABdhPJyoObj/wMoAZnPVEU/T4hv96oHZNGqRP7y0lw/jJ0yjTaifCzkMrIVJeyB00nsWRX5D/0XTXA==
X-Received: by 2002:a17:90a:578a:: with SMTP id g10mr2070988pji.74.1611700548683;
        Tue, 26 Jan 2021 14:35:48 -0800 (PST)
Received: from [192.168.4.41] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id y10sm107012pff.197.2021.01.26.14.35.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Jan 2021 14:35:48 -0800 (PST)
Subject: Re: [PATCH 0/2] io_uring: add mkdirat support
To:     Dmitry Kadashev <dkadashev@gmail.com>, io-uring@vger.kernel.org
Cc:     viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org
References: <20201116044529.1028783-1-dkadashev@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <3bb5781b-8e48-e4db-a832-333c01dba8ab@kernel.dk>
Date:   Tue, 26 Jan 2021 15:35:46 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201116044529.1028783-1-dkadashev@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/15/20 9:45 PM, Dmitry Kadashev wrote:
> This adds mkdirat support to io_uring and is heavily based on recently
> added renameat() / unlinkat() support.
> 
> The first patch is preparation with no functional changes, makes
> do_mkdirat accept struct filename pointer rather than the user string.
> 
> The second one leverages that to implement mkdirat in io_uring.
> 
> Based on for-5.11/io_uring.

I want to tentatively queue this up. Do you have the liburing support
and test case(s) for it as well that you can send?

-- 
Jens Axboe

