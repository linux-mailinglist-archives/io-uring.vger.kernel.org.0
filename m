Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7E39164FA2
	for <lists+io-uring@lfdr.de>; Wed, 19 Feb 2020 21:13:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726734AbgBSUND (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 19 Feb 2020 15:13:03 -0500
Received: from mail-pf1-f173.google.com ([209.85.210.173]:45391 "EHLO
        mail-pf1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726634AbgBSUNC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 19 Feb 2020 15:13:02 -0500
Received: by mail-pf1-f173.google.com with SMTP id 2so601591pfg.12
        for <io-uring@vger.kernel.org>; Wed, 19 Feb 2020 12:13:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=g9O3XoVMS3tPM3CIav8VUqjIyvIMDPgIil/ijB/7m30=;
        b=AFiQcslSDGPhe5eEnEaAuxnRYWeJvy4ePMNtPmVSbkncc493OgkbLOMcxlquVcphOZ
         bgnvzwN4xj7LVN2GbW+KRBauGeIVffOqO3nsdO/VEW8WOX/PfPkjLRFS22gAxSFS4089
         wZuWdfJF8Bs9w23/z+0Ll3pB0AVKpup19k4P0/ZCFkZujojAE0GN2iRijVNGNeqcMz1d
         C/YDqAEaB05rFGFI1HqEpinyFtPyohSh4d5d6MvDAMWC3ySW4HXq2qV1PlCJKPHgBeLm
         y33iaAfSMWWfCIbPWPo3KXvK5hqEB8jG43X2Ea+rSIyVxREH2WnujD4tEkEEmqLaEiaK
         8BxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=g9O3XoVMS3tPM3CIav8VUqjIyvIMDPgIil/ijB/7m30=;
        b=Pel0C28IMHJhegzwJPrTIietQCgifGwPn+asM+pGkYcxBbaklabAT4/2r+aGZ5JV/o
         WmmzEPwqiXOBWeNz06r7l4ybYKYyz0Z/4n7EA1ZgqkxoRiBN/TMNM2YwH4LJLvjWB6Yt
         SD60icFbDvgtj/qynt0/bgK0lWxCPgfVvQNnP3HrPRyib3QEYZ+AAD45mv/T1MhZHUAq
         ANnGzPSRzQFBTI+pHH5EG/5hB1FHgKv7sl3hEuaSUi8yDW5Eqd1mLXtqwfjesAw8ivex
         xzKmoqEKsugy4255k5lK7BvgEcoveTWO+0oD6k6dUUMwlZf8mV+uI64VhmQS7wtra4DX
         fP1w==
X-Gm-Message-State: APjAAAUzwIExB7MtqqtnaQAPe8v2iFs+p8ls/ozSscFW9fc5cH/g/M6R
        MqkjqAeF/HtONkioy/VA/ElLcQ==
X-Google-Smtp-Source: APXvYqwsZE6Oj6DYgFfm+wJpbvFZWTmrgS3yxJwdxbaeRALDTZAdNcvGaR7KTKvgY4yldPJs250Sdg==
X-Received: by 2002:a65:4305:: with SMTP id j5mr30743913pgq.315.1582143182207;
        Wed, 19 Feb 2020 12:13:02 -0800 (PST)
Received: from ?IPv6:2605:e000:100e:8c61:f1aa:b818:cddd:a786? ([2605:e000:100e:8c61:f1aa:b818:cddd:a786])
        by smtp.gmail.com with ESMTPSA id s130sm485249pfc.62.2020.02.19.12.13.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Feb 2020 12:13:01 -0800 (PST)
Subject: Re: crash on accept
To:     Glauber Costa <glauber@scylladb.com>
Cc:     io-uring@vger.kernel.org, Avi Kivity <avi@scylladb.com>
References: <CAD-J=zZnmnjgC9Epd5muON2dx6reCzYMzJBD=jFekxB9mgp6GA@mail.gmail.com>
 <ec98e47f-a08f-59ba-d878-60b8cd787a1f@kernel.dk>
 <CAD-J=zbm3a4nYvUo83UL706nhOicRC8LUh=iphWwL6inAa37RA@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <f74646a0-72a2-a14c-f6fd-8be4c8d87894@kernel.dk>
Date:   Wed, 19 Feb 2020 12:12:59 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <CAD-J=zbm3a4nYvUo83UL706nhOicRC8LUh=iphWwL6inAa37RA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/19/20 1:11 PM, Glauber Costa wrote:
> On Wed, Feb 19, 2020 at 3:09 PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 2/19/20 9:23 AM, Glauber Costa wrote:
>>> Hi,
>>>
>>> I started using af0a72622a1fb7179cf86ae714d52abadf7d8635 today so I could consume the new fast poll flag, and one of my tests that was previously passing now crashes
>>
>> Thanks for testing the new stuff! As always, would really appreciate a
>> test case that I can run, makes my job so much easier.
> 
> Trigger warning:
> It's in C++.

As long as it reproduces, I don't really have to look at it :-)

> I am finishing refactoring some of my code now. It's nothing
> substantial so I am positive it will hit again. Once I re-reproduce
> I'll send you instructions.
> 
> Reading the code it's not obvious to me how it happens, so it'll be
> harder for me to cook up a simple C reproducer ATM.

I'll look here as well, as time permits.


-- 
Jens Axboe

