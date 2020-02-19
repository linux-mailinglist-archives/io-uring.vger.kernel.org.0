Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B1B11652EF
	for <lists+io-uring@lfdr.de>; Thu, 20 Feb 2020 00:09:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726677AbgBSXJl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 19 Feb 2020 18:09:41 -0500
Received: from mail-pl1-f179.google.com ([209.85.214.179]:37680 "EHLO
        mail-pl1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726613AbgBSXJl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 19 Feb 2020 18:09:41 -0500
Received: by mail-pl1-f179.google.com with SMTP id c23so723514plz.4
        for <io-uring@vger.kernel.org>; Wed, 19 Feb 2020 15:09:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+Ykc+kUHELN9O6UeFfEW3j5bxzW6ZdMCsdV6h6puxO8=;
        b=JX77W7E9Rc4EP/kLzq1wfJ4rPHF4YXcWjNDY9oUtR/idVwqyrxAgSoV88nBXIpL5eO
         1MM2lAFfslxe7lBp6D07OtVP4y3KQPScK9XELm5gPZneffKPIeV/AwVmf3ABN+btOKRN
         tH36/X4/Y+wuO9XcDdQMfhmOF1Rt0AM/4E5NeWuTfxI8YiqQuMryjUhJNugUmenZR2Uy
         nG7OP0tNOsibGzMPx0s8JbRn8ZDXTCdTHz2Y7ywsqePI970Mfi/6ZwQklH95wg8fJVbC
         x9Ug6icfckElzIHxbZgp1cifxyuem8k8L42TFd2P2zUeI2vKZmjc1qB6iUCx6ibCsFhO
         3E3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+Ykc+kUHELN9O6UeFfEW3j5bxzW6ZdMCsdV6h6puxO8=;
        b=NeY2T4od1FtE1K1Aznm0Jk+iEBRDKR9wGK9U7OQiAG+zjU7gjcSWe2CXMWv4n0Kvlc
         rez0TvbR2oj8WAxnx0KfZxbeda6u6LsA0ov5Z55X5J9apD7bubMGSSdUI8fUEXokX1r7
         /UghOtY4A8wn0Vbtcd1VJZ56gS9sciGzSPfunR/b7gpmEJ2jm+uRSEMU5kZZxMlYYpXF
         3ECsAvyJky/vyFqV+LK0U39FZRsp0ulGUwH/Tq+RdeH371o6/KQwrGgU1wNJJR6XrQfh
         gD6Hd/T3C3LK3LapXDLnOvr63DUyOeBLHhamO4DzMdXCJtEua8Tn2uPFBGcWQnQiJxnC
         dEwQ==
X-Gm-Message-State: APjAAAXRveH7rQm0T3O+sahMopGg/gKe9+ox6pSYB7HQbsKTKpilDTNb
        WoQpBR1TnnMxte8GktuZpE3e/8IC6dY=
X-Google-Smtp-Source: APXvYqz3DQMz5eeikIYJWytE+M+isW7vh56LyurrGX+zzdtbiCAVKX3Bs1LBFnxQD91VDRxf1f87pQ==
X-Received: by 2002:a17:902:7d86:: with SMTP id a6mr28575850plm.212.1582153778965;
        Wed, 19 Feb 2020 15:09:38 -0800 (PST)
Received: from ?IPv6:2605:e000:100e:8c61:c9a5:cb41:ce0a:b599? ([2605:e000:100e:8c61:c9a5:cb41:ce0a:b599])
        by smtp.gmail.com with ESMTPSA id t186sm769099pgd.26.2020.02.19.15.09.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Feb 2020 15:09:38 -0800 (PST)
Subject: Re: crash on accept
To:     Avi Kivity <avi@scylladb.com>, Glauber Costa <glauber@scylladb.com>
Cc:     io-uring@vger.kernel.org
References: <CAD-J=zZnmnjgC9Epd5muON2dx6reCzYMzJBD=jFekxB9mgp6GA@mail.gmail.com>
 <ec98e47f-a08f-59ba-d878-60b8cd787a1f@kernel.dk>
 <CAD-J=zbm3a4nYvUo83UL706nhOicRC8LUh=iphWwL6inAa37RA@mail.gmail.com>
 <f74646a0-72a2-a14c-f6fd-8be4c8d87894@kernel.dk>
 <CAD-J=zb2Y_U3W6=8RUfX_zSP7YbdYLxFY0UDcmCqKRH8Jin4bQ@mail.gmail.com>
 <fba5b599-3e07-5e35-3d44-3018be19309f@scylladb.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <20ab3016-9964-9811-c5b9-be848f072764@kernel.dk>
Date:   Wed, 19 Feb 2020 15:09:36 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <fba5b599-3e07-5e35-3d44-3018be19309f@scylladb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/19/20 1:29 PM, Avi Kivity wrote:
> On 2/19/20 10:25 PM, Glauber Costa wrote:
>> On Wed, Feb 19, 2020 at 3:13 PM Jens Axboe <axboe@kernel.dk> wrote:
>>> On 2/19/20 1:11 PM, Glauber Costa wrote:
>>>> On Wed, Feb 19, 2020 at 3:09 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>>> On 2/19/20 9:23 AM, Glauber Costa wrote:
>>>>>> Hi,
>>>>>>
>>>>>> I started using af0a72622a1fb7179cf86ae714d52abadf7d8635 today so I could consume the new fast poll flag, and one of my tests that was previously passing now crashes
>>>>> Thanks for testing the new stuff! As always, would really appreciate a
>>>>> test case that I can run, makes my job so much easier.
>>>> Trigger warning:
>>>> It's in C++.
>>> As long as it reproduces, I don't really have to look at it :-)
>> Instructions:
>> 1. clone https://github.com/glommer/seastar.git, branch uring-accept-crash
>> 2. git submodule update --recursive --init, because we have a shit-ton
>> of submodules because why not.
> 
> 
> Actually, seastar has only one submodule (dpdk) and it is optional, so 
> you need not clone it.
> 
> 
>> 3. install all dependencies with ./install-dependencies.sh
>>      note: that does not install liburing yet, you need to have at
>> least 0.4 (I trust you do), with the patch I just sent to add the fast
>> poll flag. It still fails sometimes in my system if liburing is
>> installed in /usr/lib instead of /usr/lib64 because cmake is made by
>> the devil.
>> 3. ./configure.py --mode=release
> 
> 
> --mode dev will compile many times faster
> 
> 
>> 4. ninja -C build/release tests/unit/unix_domain_test
>> 5. crash your system (hopefully) by executing
>> ./build/release/tests/unit/unix_domain_test -- -c1
>> --reactor-backend=uring
>>
> s/release/dev/ in steps 4, 5 if you use dev mode.

Thanks, this is great, I can reproduce!


-- 
Jens Axboe

