Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B294141433
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2020 23:36:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728760AbgAQWgc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 17 Jan 2020 17:36:32 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:54338 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727009AbgAQWgc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 17 Jan 2020 17:36:32 -0500
Received: by mail-pj1-f66.google.com with SMTP id kx11so3765058pjb.4
        for <io-uring@vger.kernel.org>; Fri, 17 Jan 2020 14:36:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XtWUfgleS7tWusH2llDzuITHbPBooY2G7TQrQIa4jbQ=;
        b=c8kqtU/fuGtildlbXqGQuR5Wty5GpjcjjtOI37WDgpw0nOCDjDFdT7iFg5agkHyJ0L
         bpZPbBfBhmbDJiJLAdonr93zhSUYWKhxrvX+MXQLhrzroOq2WOPVVXuc8AkxUvMPp2+b
         ycw4AOtnE13AOxKsvpaxY4Ln+/TeFPqdicX+PO73cR7hODTjqkmp1Ku4Vj5//NEx5d/B
         VmYSLLai5X33uLAJn9GI0KwWz5r+66lkEiPIjCuOTAJNfkwRN7qJFARK1ZehTAiXTSu9
         LiUjTg2yKvTvPbMyFzeKClp/40RJt2OwwOcQtsQadkQ8LGEVuhVtSFF2Xjc+lgPVQd/5
         Vdeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XtWUfgleS7tWusH2llDzuITHbPBooY2G7TQrQIa4jbQ=;
        b=okJZP8y+Gyp95afp1qvWAeD1YU7pmSACSGCxK254YQCbmFNIA4rbn86HoD4Jeq8opo
         lkzaglaHeYqVj4xsJdxQ/liNPY/nMVECuo6+yTG0UCqOeaxhEyXe9fgalFeP2HFQ786+
         ES3D3ETcSvpaBDCG2ypXEA9j3qy/Be+kgYMZSU5T2cOEan4Js1Gx7XKotqeDFb62Lsu+
         EijUgn/6I2GEQtKM5a+He76zxX+S3zWx5fR0opfiE3M/alq/CS+7+C7fXqJDy36aEFdg
         Z/FJ4uyHo2cTio/+S487jXtgjz57I7Mssq+WFKFA0x+zTjq0tb2Pmr+G2Zs+qFZkIyDd
         pNRw==
X-Gm-Message-State: APjAAAUPwY9UY4N42g7HHc0Ttzrg/9vWaMIlGb723PSYnluBHgEj5pTq
        hnFRjE2u/QLfxfHFngjaKnZt4q9OOmM=
X-Google-Smtp-Source: APXvYqxT3XzsFV+4p025Gs8B66GWmFGv8+/htgVfLtik+Fp+i+/sLR9wNBIVdgKY7t4SfAOGFbbiVA==
X-Received: by 2002:a17:90a:300b:: with SMTP id g11mr8411307pjb.123.1579300592042;
        Fri, 17 Jan 2020 14:36:32 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id o7sm8434018pjs.28.2020.01.17.14.36.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jan 2020 14:36:31 -0800 (PST)
Subject: Re: [PATCHSET v2 0/6] io_uring: add support for open/close
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Colin Walters <walters@verbum.org>,
        Stefan Metzmacher <metze@samba.org>, io-uring@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org
References: <20200107170034.16165-1-axboe@kernel.dk>
 <e4fb6287-8216-529e-9666-5ec855db02fb@samba.org>
 <4adb30f4-2ab3-6029-bc94-c72736b9004a@kernel.dk>
 <4dffd58e-5602-62d5-d1af-343c4a091ed9@samba.org>
 <eb99e387-f385-c36d-b1d9-f99ec470eba6@kernel.dk>
 <9a407238-5505-c446-80b7-086646dd15be@kernel.dk>
 <d4d3fa40-1c59-a48a-533b-c8b221e0f221@samba.org>
 <1e8a9e98-67f8-4e2f-8185-040b9979bc1a@www.fastmail.com>
 <964c01cc-94f5-16b2-cc61-9ee5789b1f43@gmail.com>
 <cbdb0621-3bc8-fc41-a365-56b2639e39a0@kernel.dk>
 <991faae8-909c-0aed-a9ee-aab01f8db8e9@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <8b3f182c-7c4b-da41-7ec8-bb4f22429ed1@kernel.dk>
Date:   Fri, 17 Jan 2020 15:36:29 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <991faae8-909c-0aed-a9ee-aab01f8db8e9@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/17/20 3:27 PM, Pavel Begunkov wrote:
> On 17/01/2020 18:21, Jens Axboe wrote:
>> On 1/17/20 2:32 AM, Pavel Begunkov wrote:
>>> On 1/17/2020 3:44 AM, Colin Walters wrote:
>>>> On Thu, Jan 16, 2020, at 5:50 PM, Stefan Metzmacher wrote:
>>>>> The client can compound a chain with open, getinfo, read, close
>>>>> getinfo, read and close get an file handle of -1 and implicitly
>>>>> get the fd generated/used in the previous request.
>>>>
>>>> Sounds similar to  https://capnproto.org/rpc.html too.
>>>>
>>> Looks like just grouping a pack of operations for RPC.
>>> With io_uring we could implement more interesting stuff. I've been
>>> thinking about eBPF in io_uring for a while as well, and apparently it
>>> could be _really_ powerful, and would allow almost zero-context-switches
>>> for some usecases.
>>>
>>> 1. full flow control with eBPF
>>> - dropping requests (links)
>>> - emitting reqs/links (e.g. after completions of another req)
>>> - chaining/redirecting
>>> of course, all of that with fast intermediate computations in between
>>>
>>> 2. do long eBPF programs by introducing a new opcode (punted to async).
>>> (though, there would be problems with that)
>>>
>>> Could even allow to dynamically register new opcodes within the kernel
>>> and extend it to eBPF, if there will be demand for such things.
>>
>> We're also looking into exactly that at Facebook, nothing concrete yet
>> though. But it's clear we need it to take full advantage of links at
>> least, and it's also clear that it would unlock a lot of really cool
>> functionality once we do.
>>
>> Pavel, I'd strongly urge you to submit a talk to LSF/MM/BPF about this.
>> It's the perfect venue to have some concrete planning around this topic
>> and get things rolling.
> 
> Sounds interesting, I'll try this, but didn't you intend to do it
> yourself?  And thanks for the tip!

Just trying to delegate a bit, and I think you'd be a great candidate to
drive this. I'll likely do some other io_uring related topic there.

-- 
Jens Axboe

