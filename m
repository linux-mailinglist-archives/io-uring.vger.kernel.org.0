Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7DC23758D0
	for <lists+io-uring@lfdr.de>; Thu,  6 May 2021 18:57:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236058AbhEFQ6J (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 6 May 2021 12:58:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236044AbhEFQ6J (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 6 May 2021 12:58:09 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDC54C061574;
        Thu,  6 May 2021 09:57:09 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id k4-20020a7bc4040000b02901331d89fb83so3409436wmi.5;
        Thu, 06 May 2021 09:57:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TCrHRZ7M/4fQ3bLi8NcN3V417Ett4REzgAAg8+rCpSM=;
        b=MNP67Zc8AxV4T80Lt0Ez0ePYTj1itxDH/ZpPF0XgLwV7TPVq6BeCNE/wHqM7Pz8oHg
         iQsUyFwNJe38Q8fngJXvkg0Sy+zpU1VzDOw44EnjMSBqrN4n9p1Rbuxe0Qy/NQpRkSoG
         3gLdHth9/LvuXFxy2WMvkzQkXJTG6DXHK8qRK+ifStXJTYhhPIajUTFHekwykGZ2uRBO
         Z7PeB4gYfjfoCGnwTjJ2VVMvk4IhPqwzkJiZKHnqiZ1c92doEsibUe32dC+PdzecMrrd
         OVCDeu1EY2x8qHhrUsx+iU8PfL/53ONlxW/RZNDonFK4epR1BXkTll0BJikvOTjDEznf
         u0yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TCrHRZ7M/4fQ3bLi8NcN3V417Ett4REzgAAg8+rCpSM=;
        b=kVr4Bbx0VEwhaTkoOq3DhizNqCuUGZx6XbCutUq5Mbl0CDPAExxGlyGNF299fN1ZhW
         aWYTS+R4zFuAOJBWEe+bxVPKjoJua3Uf3ClRrzds69RVwJpEHFwI/rb2gbdmjfT7pDSe
         p1sLQgJnbm/ttLHnQ1g2a1VojBP+rgZzajc0wsIigV1g4gz3dT80JhVirCIM/M26GvEx
         s2ruX05m2Oja3g7ngAyU8o9R3PwpV0cyHN5qh6fy6a/ewl3SvKLZxYIo7fMKVIPFWwyr
         DbYOQQk4aSQGFP76ibheJdR1qlZmRHJiNY2l+eDdPFkgCAoJZyaOjr8TslMQQTF+vvuI
         RcYQ==
X-Gm-Message-State: AOAM530jkpvhK+t+SwCWirEhtyu/c57t7EpYIkmUeUnwA58u5a5/7Arw
        aMXyyHszekz966bFU3Pz15WZMmXc8IY=
X-Google-Smtp-Source: ABdhPJzxMTsnBRzkFIBu+NnK2wR0XFmyEhph0mpb4jj3HKhaEexoguCbklWgSgfO+1A624i4cyTRcQ==
X-Received: by 2002:a1c:1dd5:: with SMTP id d204mr5041138wmd.21.1620320228360;
        Thu, 06 May 2021 09:57:08 -0700 (PDT)
Received: from [192.168.8.197] ([185.69.144.215])
        by smtp.gmail.com with ESMTPSA id p10sm5404678wre.84.2021.05.06.09.57.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 May 2021 09:57:07 -0700 (PDT)
Subject: Re: [PATCH] block: reexpand iov_iter after read/write
To:     Al Viro <viro@zeniv.linux.org.uk>, Jens Axboe <axboe@kernel.dk>
Cc:     yangerkun <yangerkun@huawei.com>, linux-fsdevel@vger.kernel.org,
        linux-block@vger.kernel.org, io-uring@vger.kernel.org
References: <20210401071807.3328235-1-yangerkun@huawei.com>
 <a2e97190-936d-ebe0-2adc-748328076f31@gmail.com>
 <7ff7d1b7-8b6d-a684-1740-6a62565f77b6@gmail.com>
 <3368729f-e61d-d4b6-f2ae-e17ebe59280e@gmail.com>
 <3d6904c0-9719-8569-2ae8-dd9694da046b@huawei.com>
 <05803db5-c6de-e115-3db2-476454b20668@gmail.com>
 <YIwVzWEU97BylYK1@zeniv-ca.linux.org.uk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <d7641b3d-0203-d913-d6ac-57de5c7c9747@gmail.com>
Date:   Thu, 6 May 2021 17:57:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <YIwVzWEU97BylYK1@zeniv-ca.linux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/30/21 3:35 PM, Al Viro wrote:
> On Fri, Apr 30, 2021 at 01:57:22PM +0100, Pavel Begunkov wrote:
>> On 4/28/21 7:16 AM, yangerkun wrote:
>>> Hi,
>>>
>>> Should we pick this patch for 5.13?
>>
>> Looks ok to me
> 
> 	Looks sane.  BTW, Pavel, could you go over #untested.iov_iter
> and give it some beating?  Ideally - with per-commit profiling to see
> what speedups/slowdowns do they come with...

I've heard Jens already tested it out. Jens, is that right? Can you
share? especially since you have much more fitting hardware.

> 
> 	It's not in the final state (if nothing else, it needs to be
> rebased on top of xarray stuff, and there will be followup cleanups
> as well), but I'd appreciate testing and profiling data...
> 
> 	It does survive xfstests + LTP syscall tests, but that's about
> it.
> 

-- 
Pavel Begunkov
