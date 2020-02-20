Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3ED616545C
	for <lists+io-uring@lfdr.de>; Thu, 20 Feb 2020 02:37:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727888AbgBTBhY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 19 Feb 2020 20:37:24 -0500
Received: from mail-pf1-f172.google.com ([209.85.210.172]:38670 "EHLO
        mail-pf1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727224AbgBTBhY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 19 Feb 2020 20:37:24 -0500
Received: by mail-pf1-f172.google.com with SMTP id x185so1053030pfc.5
        for <io-uring@vger.kernel.org>; Wed, 19 Feb 2020 17:37:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=NAQluwEc2ebdhHeWMUC1wWqJnzIRMoBmfhVSBq16FaU=;
        b=yKa5j+1tzzX7NJ1UVA+y5Jhj8YSgDy9eo7bHKE9rnmf+nfEN/q5xd5cT4HV8IJuoah
         23PI4dBkaFmFDtoIZMSJ0o7Vn7MWtBFIJR/IW++qCeLYiov4sdK++KXWXabCF3NO+V3j
         CDoaCrTiZCMXxlwCRQ4ME4sFCIKULigOkvbVHsNgGwGvQId9FmybPm2y9yj00IM7rVnQ
         iKhKTJ47WuN/Uj/fnYs+SQH/7ZeWwshr3JCXramk3K3lpe5S9C/QKdh8O4GrlaFglMZf
         QACXuIcRxcfZFTjpPV2RNw5uVSj1I+9DjWxezOGAE4TevjNcK1zZ5bqE5mJnsunPVEXt
         nbgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NAQluwEc2ebdhHeWMUC1wWqJnzIRMoBmfhVSBq16FaU=;
        b=Ao4OZNV92IPWL2BQ+5kLT/eXKtJJW5n1lWKyivp1XcIsXqWr0KEwCvthCLlbVYD6Il
         h+Ptny31TIUaY4ZdwDxE5C5g6l+edYdjYMW7er6aBWAVLmESRit+JocT63rjuN/kCvkf
         GAiK6jPiydvfsDl9JY4CjOy4rr9HVLuh0zgoo48t/Srzdio0rQ3qPNYyKsHLpknaDLFy
         t412Ade08qe7vOdQEGUzU5kqrjDtvBmMkDPuoOFoAkg2mhpGHX5v0lSP1Zl6OSoSEE1u
         nvNLB1ksdWLThfwj9Nep9eqrWJOOnyiPILtsfFZf2XrT7fZBP6HS/xOCFL6IcZxqzwn4
         yxmQ==
X-Gm-Message-State: APjAAAXGI46+0ZYhuKXC6U0p8MIQCfTs/ad/SZ3gwUX1B3U0tYeOwc3n
        3v2b7Prx0Ht9HaAdd+ucYEJwyiRQigY=
X-Google-Smtp-Source: APXvYqy3Zdnlkd0UD/pDRUFTl/mhzRvYZaEtHQzZJMtIVaGH4hZTNJXO8f+ZKfigEI8OY4Cc8AEmMQ==
X-Received: by 2002:a63:511:: with SMTP id 17mr30903958pgf.221.1582162640757;
        Wed, 19 Feb 2020 17:37:20 -0800 (PST)
Received: from ?IPv6:2605:e000:100e:8c61:c9a5:cb41:ce0a:b599? ([2605:e000:100e:8c61:c9a5:cb41:ce0a:b599])
        by smtp.gmail.com with ESMTPSA id a17sm972339pjv.6.2020.02.19.17.37.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Feb 2020 17:37:20 -0800 (PST)
Subject: Re: crash on accept
From:   Jens Axboe <axboe@kernel.dk>
To:     Avi Kivity <avi@scylladb.com>, Glauber Costa <glauber@scylladb.com>
Cc:     io-uring@vger.kernel.org
References: <CAD-J=zZnmnjgC9Epd5muON2dx6reCzYMzJBD=jFekxB9mgp6GA@mail.gmail.com>
 <ec98e47f-a08f-59ba-d878-60b8cd787a1f@kernel.dk>
 <CAD-J=zbm3a4nYvUo83UL706nhOicRC8LUh=iphWwL6inAa37RA@mail.gmail.com>
 <f74646a0-72a2-a14c-f6fd-8be4c8d87894@kernel.dk>
 <CAD-J=zb2Y_U3W6=8RUfX_zSP7YbdYLxFY0UDcmCqKRH8Jin4bQ@mail.gmail.com>
 <fba5b599-3e07-5e35-3d44-3018be19309f@scylladb.com>
 <20ab3016-9964-9811-c5b9-be848f072764@kernel.dk>
Message-ID: <3e5c6df3-c4ab-1cd5-5bb1-e1a5d44180ad@kernel.dk>
Date:   Wed, 19 Feb 2020 17:37:19 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20ab3016-9964-9811-c5b9-be848f072764@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/19/20 4:09 PM, Jens Axboe wrote:
> On 2/19/20 1:29 PM, Avi Kivity wrote:
>> On 2/19/20 10:25 PM, Glauber Costa wrote:
>>> On Wed, Feb 19, 2020 at 3:13 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>> On 2/19/20 1:11 PM, Glauber Costa wrote:
>>>>> On Wed, Feb 19, 2020 at 3:09 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>>>> On 2/19/20 9:23 AM, Glauber Costa wrote:
>>>>>>> Hi,
>>>>>>>
>>>>>>> I started using af0a72622a1fb7179cf86ae714d52abadf7d8635 today so I could consume the new fast poll flag, and one of my tests that was previously passing now crashes
>>>>>> Thanks for testing the new stuff! As always, would really appreciate a
>>>>>> test case that I can run, makes my job so much easier.
>>>>> Trigger warning:
>>>>> It's in C++.
>>>> As long as it reproduces, I don't really have to look at it :-)
>>> Instructions:
>>> 1. clone https://github.com/glommer/seastar.git, branch uring-accept-crash
>>> 2. git submodule update --recursive --init, because we have a shit-ton
>>> of submodules because why not.
>>
>>
>> Actually, seastar has only one submodule (dpdk) and it is optional, so 
>> you need not clone it.
>>
>>
>>> 3. install all dependencies with ./install-dependencies.sh
>>>      note: that does not install liburing yet, you need to have at
>>> least 0.4 (I trust you do), with the patch I just sent to add the fast
>>> poll flag. It still fails sometimes in my system if liburing is
>>> installed in /usr/lib instead of /usr/lib64 because cmake is made by
>>> the devil.
>>> 3. ./configure.py --mode=release
>>
>>
>> --mode dev will compile many times faster
>>
>>
>>> 4. ninja -C build/release tests/unit/unix_domain_test
>>> 5. crash your system (hopefully) by executing
>>> ./build/release/tests/unit/unix_domain_test -- -c1
>>> --reactor-backend=uring
>>>
>> s/release/dev/ in steps 4, 5 if you use dev mode.
> 
> Thanks, this is great, I can reproduce!

Can you try the current branch? Should be 77aac7e7738 (or newer).

-- 
Jens Axboe

