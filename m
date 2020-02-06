Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3ED3F154615
	for <lists+io-uring@lfdr.de>; Thu,  6 Feb 2020 15:26:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728096AbgBFO01 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 6 Feb 2020 09:26:27 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:36415 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727415AbgBFO01 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 6 Feb 2020 09:26:27 -0500
Received: by mail-io1-f66.google.com with SMTP id d15so6519735iog.3
        for <io-uring@vger.kernel.org>; Thu, 06 Feb 2020 06:26:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=p19oP9rAShwHnrZ6I0lQPYswxVWimInnaxXF/O9xV8g=;
        b=sRLuL+ZYZ1mHJ9JzmN+K+3bN8/VG6BkcFKf1MtjNw1A82YrRKTxSvEvUcANj/1tUfA
         Wv15JzdAUTZXWVZaXTLhwSnP/urKWyvFumMrwTqaKLHq/K/EGCt7N36fC7oaUfpReypE
         mDxiYIhzR9aQrNqNaOQMPp/Zqy4RDY6yrO33G7IFNPj311Q6lEpWujuDlMsRVdtTpYs/
         Y8jn/CjiJVpxYmIMUsfkiNNf7kTGpb4QbMASprTY7owa22+ONSjSYglz4PLkW/zR6yju
         ASVKsRqet3GDWnmPbXEsXoY3CTRV8nnW07NN/e72QNHwP0VPTipRDogRgqK9lrHq3gaI
         UMog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=p19oP9rAShwHnrZ6I0lQPYswxVWimInnaxXF/O9xV8g=;
        b=JduZG5UVTxqFRPzu4X3RK9t2Yp5l2RwozOWKv9XbcG3Ktu/ldAc3e+bjBwup5EzWTt
         YBKaauV+Drp3h69AXITPtHjX81YMjkzuSq3T1x9OD8NLu8mZ4gnV66LvFnJWr3o2QW7o
         ramL3/9O5BsKbEfueurhC/lFXgUJ0Bn2wtEVv6Q2Ump+H/CYdlqkZdtNtkgqN/d4nNRJ
         WHJ5VWP1LRMilYHp6FQSmsHtfNOwB/U/4yvizQSVAM+2nIgjIHO8SViGl8EUNFAFvj1D
         6J5U08FigtTvS+1N9C9ieY8Vv9CcRgcz86q3gNfnTxoSY48Tz7pMoL4UpDxbhdhG62C7
         vFOQ==
X-Gm-Message-State: APjAAAWHX9fzSJJWDGgNQpfANodjMgWDAuGN0euYmDhLuG8Ws7kKZEcP
        QeFLUSgan8naXo3yvefq0rM/zg==
X-Google-Smtp-Source: APXvYqw51s/D1fk4n7Ob4XE4Hc14tBW8H6X8kOo3/+J0i5NFi1HV5SRfSTCV1fsBIR2i+U8YVwhLnQ==
X-Received: by 2002:a5d:970e:: with SMTP id h14mr32952567iol.201.1580999184935;
        Thu, 06 Feb 2020 06:26:24 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id s21sm894587ioa.33.2020.02.06.06.26.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Feb 2020 06:26:24 -0800 (PST)
Subject: Re: [PATCH 0/3] io_uring: clean wq path
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1580928112.git.asml.silence@gmail.com>
 <1fdfd8bf-c0cd-04c0-e22e-bc0945ef1734@gmail.com>
 <8c0639c6-78ad-6240-0c18-d3ef8936e2f4@kernel.dk>
 <8ad4a84e-9796-6431-c73e-1d34eed0b0fb@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <858563a9-8a99-dfc2-c4df-53ae09ffdfeb@kernel.dk>
Date:   Thu, 6 Feb 2020 07:26:23 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <8ad4a84e-9796-6431-c73e-1d34eed0b0fb@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/6/20 2:51 AM, Pavel Begunkov wrote:
> On 2/6/2020 5:50 AM, Jens Axboe wrote:
>> On 2/5/20 3:29 PM, Pavel Begunkov wrote:
>>> On 05/02/2020 22:07, Pavel Begunkov wrote:
>>>> This is the first series of shaving some overhead for wq-offloading.
>>>> The 1st removes extra allocations, and the 3rd req->refs abusing.
>>>
>>> Rechecked a couple of assumptions, this patchset is messed up.
>>> Drop it for now.
>>
>> OK, will do, haven't had time to look at it yet anyway.
> 
> Sorry for the fuss. I'll return to it later.

No worries

>> Are you going to do the ->has_user removal? We should just do that
>> separately first.
> Yes. I've spotted a few bugs, so I'm going to patch them first with
> merging/backporting in mind, and then deal with ->has_user. IMO, this
> order makes more sense.

I think it probably makes sense to do it in the opposite order, as the
->has_user cleanup/clarification should go into 5.6 whereas the other
stuff is likely 5.7 material.

-- 
Jens Axboe

