Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86B2F249E9C
	for <lists+io-uring@lfdr.de>; Wed, 19 Aug 2020 14:49:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727022AbgHSMtG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 19 Aug 2020 08:49:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728361AbgHSMtC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 19 Aug 2020 08:49:02 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6230C061757
        for <io-uring@vger.kernel.org>; Wed, 19 Aug 2020 05:49:01 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id r11so11620690pfl.11
        for <io-uring@vger.kernel.org>; Wed, 19 Aug 2020 05:49:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=S3U6q3yjc5fHGYE0wMX79t0QFPOSQxmM3tunXfU+Ycc=;
        b=aHM24PWp9CxI/x5OorG9nK6teX/yuHGfBzb+B3z+1bLCbPm5Qn+HFYSCzUMUsReMW9
         GvGsTw8zmjcP0hvJ2G7A973hXM3uy4YuLUAxFb8aBVMiF2wxfGoIemb0nO2HdybxNBaa
         HuMXN7aAq6l870aLRraeH8YDD3EcGEzNlytHYHBfj+Xk93vbltDxCt33yYDB53tw4SXY
         gBWehiHk16iitG/iP0GIN4Cs6/L2KoKHcIXYOYQYA68P0yRZzzLTbLrIuQS1C+QvlcJG
         S6gIvIOac4l8LwCWWtaQW08X8lrqyIAhxDcvu6Huw0clJ/PzhIBaVQRDGYBjuHh6bSOI
         Qo5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=S3U6q3yjc5fHGYE0wMX79t0QFPOSQxmM3tunXfU+Ycc=;
        b=FY/PSQxYHCQWWhRwMkkwCMWxT0HqQdfTEa4nShJgnBRA8aBH8btZ0oTbN6XuiGzmH1
         76IubVq2KaH9oZtQM1WT1P6vhvWUb/Ix+OBmzbzHy2Iu9uEanhi9+r4mtrTDIR8tyfae
         RMzRShrAtYhgChap0LUpSJdl6FCbjusGOn91vHeekeRLhPueW5Q/A4P0+NHk7N7srWf9
         0ECTryniv9l1wlB+Y573VDUtyFEPxMXyuSPc4bsoWTV1FKMvzh2v+Tl+p5Hwi8LNIRGD
         iR94iulc3zZM/N74SX6YZXpdQMTx654OoYQaj1LZFo7wT+lUV/Ni//H+FUnWVS4YgZCM
         Opnw==
X-Gm-Message-State: AOAM5331V1/R4Mz3G82Fbx8l9ICnxQPZID0sa4d5L+D0DkgUAijzoMYp
        kj/BOLMbZQGpFJXOoZANV9hJb23SZe8byQjG
X-Google-Smtp-Source: ABdhPJwHAoePUoscwlAh2dPm5jptF70LU873InZKJfXmrYV1QJU2ZKWa3kD0arxVytC9i8CaIe/+LA==
X-Received: by 2002:a63:4e56:: with SMTP id o22mr15992294pgl.381.1597841341029;
        Wed, 19 Aug 2020 05:49:01 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id x28sm28753155pfq.141.2020.08.19.05.48.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Aug 2020 05:49:00 -0700 (PDT)
Subject: Re: [PATCHSET v2 0/2] io_uring: handle short reads internally
To:     Stefan Metzmacher <metze@samba.org>,
        Anoop C S <anoopcs@cryptolab.net>
Cc:     david@fromorbit.com, jmoyer@redhat.com, io-uring@vger.kernel.org
References: <20200814195449.533153-1-axboe@kernel.dk>
 <4c79f6b2-552c-f404-8298-33beaceb9768@samba.org>
 <8beb2687-5cc3-a76a-0f31-dcfa9fc4b84b@kernel.dk>
 <97c2c3ab-d25b-e6bb-e8aa-a551edecc7b5@kernel.dk>
 <e22220a8-669a-d302-f454-03a35c9582b4@kernel.dk>
 <5f6d3f16-cd0c-9598-4484-6003101eb47a@samba.org>
 <db051fac-da0f-9546-2c32-1756d9e74529@kernel.dk>
 <631dbeff8926dbef4fec5a12281843c8a66565e5.camel@cryptolab.net>
 <4ffd97f6-848d-69ff-f76c-2197abbd5e6d@kernel.dk>
 <d9bec86b-50a3-5dbd-ce67-84eebae1dbbc@kernel.dk>
 <ad6cd95adb2e7622860fd9a80c19e48230ae2747.camel@cryptolab.net>
 <d45cd537-187d-be96-ac3a-f8375fd893f5@samba.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <49aa35e5-347c-c1aa-a4d3-7dce328ea2b1@kernel.dk>
Date:   Wed, 19 Aug 2020 06:48:58 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <d45cd537-187d-be96-ac3a-f8375fd893f5@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/19/20 1:31 AM, Stefan Metzmacher wrote:
> Hi Anoop,
> 
>> @metze,
>>
>> Looks like issue is fixed with patched version of v5.7.15. For the
>> record I am noting down the steps followed:
>>
>> Following is my configuration:
>> OS: Fedora 32
>> Kernel: 5.7.15 [5.7.15-200]
>>         5.7.15+patches from 5.7-stable branch [5.7.15-202]
>> Samba: 4.12.6 [4.12.6-0]
>>        4.12.6+git reverts for vfs_io_uring [4.12.6-1]
>> liburing: 0.7
>> Client: Win 10, build 1909
>> Issue: SHA256 mismatch on files copied from io_uring enabled Samba
>>        share using Windows explorer
>>
>> * Issue not seen with unpatched 5.7.15 and samba-4.12.6
>>
>> * prepared samba-4.12.6 build[1] with reverts(see attachment) for
>> vfs_io_uring(as per https://bugzilla.samba.org/show_bug.cgi?id=14361)
>> and reproduced issue with unpatched 5.7.15.
>>
>> * prepared kernel-5.7.15 build[2] with extra commits(see attachment) as
>> per 5.7-stable branch from git://git.kernel.dk/linux-block. SHA256
>> mismatch is no longer seen.
>>
>> [1] https://koji.fedoraproject.org/koji/taskinfo?taskID=49539069
>> [2] https://koji.fedoraproject.org/koji/taskinfo?taskID=49585679
> 
> Great, thanks!

Indeed, thanks a lot for retesting! It helps validate that the backport
is sane in general, both from a "now handles short reads and retries them
without issue" and the "didn't mess anything else up majorly" side
of things :-)

-- 
Jens Axboe

