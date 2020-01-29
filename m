Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0326C14D229
	for <lists+io-uring@lfdr.de>; Wed, 29 Jan 2020 21:55:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726826AbgA2UzY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 29 Jan 2020 15:55:24 -0500
Received: from mail-il1-f196.google.com ([209.85.166.196]:37135 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726317AbgA2UzY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 29 Jan 2020 15:55:24 -0500
Received: by mail-il1-f196.google.com with SMTP id v13so1137640iln.4
        for <io-uring@vger.kernel.org>; Wed, 29 Jan 2020 12:55:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vZx+LqMJGedh2GUpB/4YKxyFKNdSsoRL2znZdQP5Ktk=;
        b=cRLqrnGIdbg3Pp586L35ZL7AA6RyHGOZ15XhZIQbUnT1n5m2arBjeUXPJUP02ad4lJ
         mvHqtPkTJg4feczdHRh7YMaSgd1orKEpy7p2eGI4+Lu2oOqjz8IS4BuVDk0RkwjVEsBA
         1I9swxX2gxMK6beZr7j1d8g17QNjCvPIef23z1R4UdskOb4qDt9ehaPgObmtS0rE7Uoc
         CAgKQElAtF3j0XQKNE/pPT0MvcMlGSoUoqyEcP//Nxk87YFPrrGZ18CJ2oIqo96c1fL6
         XmsI8LrhC/uG9wTomsVxzZMPTArZGbd7+Q+au8qD3U2vE3u1glr13/7C4ddCQLyd7xC+
         sXxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vZx+LqMJGedh2GUpB/4YKxyFKNdSsoRL2znZdQP5Ktk=;
        b=X09SK0hKjoOlYurJ6CXJsDTwG5emExFZvwLES93kugwte+KdRCCx13jJh9M/casbMs
         k3sJ52MZURp1kxzmPrpouwDXKQcItwHWOfRIRQ7Z530LWvWxLe3zsWxrdXrNsNFYNIhx
         aodiLJJ9s9NIyTHtW+XOumfrymh0cFSvOUrI4wJ2N13m6xpfV1WNRT1ZvRnQ7wIXEDj5
         21oAJuZgio+BVtWGWvZVYIE4cq90Vl1Cw4c+7DHoD/jNq4W5RfmFJ4jM6nBbp72pPfln
         KeWdDVzDIGuttWaIMrDmkxEsoauEgzE85/AVXzqoHQo058Ij6ro2Yw1GQ/pAuYNkfHpr
         mWmw==
X-Gm-Message-State: APjAAAWysNixRQ1zHAbGToBf3x95ecb5HiSRpCUvcr6qanwnly+9Mdoq
        ZEGRj3kvfGjRgzcmPmfNRzkq0g==
X-Google-Smtp-Source: APXvYqwntu0z99IQp2/CUF15omUF3AG1GpPBvzUABISPhp8oy7pWAohHcfl8L8Aryo2Si4ilv8WYDA==
X-Received: by 2002:a92:1b51:: with SMTP id b78mr1132505ilb.14.1580331323128;
        Wed, 29 Jan 2020 12:55:23 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id k16sm1071075ili.35.2020.01.29.12.55.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jan 2020 12:55:22 -0800 (PST)
Subject: Re: [PATCH] add a helper function to verify io_uring functionality
To:     Glauber Costa <glauber@scylladb.com>, io-uring@vger.kernel.org
Cc:     Avi Kivity <avi@scylladb.com>
References: <20200129192016.6407-1-glauber@scylladb.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <a682d038-046a-4b72-b43c-60e3e559f9e2@kernel.dk>
Date:   Wed, 29 Jan 2020 13:55:21 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200129192016.6407-1-glauber@scylladb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/29/20 12:20 PM, Glauber Costa wrote:
> It is common for an application using an ever-evolving interface to want
> to inquire about the presence of certain functionality it plans to use.
> 
> The boilerplate to do that is about always the same: find places that
> have feature bits, match that with what we need, rinse, repeat.
> Therefore it makes sense to move this to a library function.
> 
> We have two places in which we can check for such features: the feature
> flag returned by io_uring_init_params(), and the resulting array
> returning from io_uring_probe.
> 
> I tried my best to communicate as well as possible in the function
> signature the fact that this is not supposed to test the availability
> of io_uring (which is straightforward enough), but rather a minimum set
> of requirements for usage.

I wonder if we should have a helper that returns the fully allocated
io_uring_probe struct filled out by probing the kernel. My main worry
here is that some applications will probe for various things, each of
which will setup/teardown a ring, and do the query.

Maybe it'd be enough to potentially pass in a ring?

While this patch works with a sparse command opcode field, not sure it's
the most natural way. If we do the above, maybe we can just have a
is_this_op_supported() query, since it'd be cheap if we already have the
probe struct filled out?

Outside of this discussion, some style changes are needed:

- '*' goes next to the name, struct foo *ptr, not struct foo* ptr
- Some lines over 80 chars

-- 
Jens Axboe

