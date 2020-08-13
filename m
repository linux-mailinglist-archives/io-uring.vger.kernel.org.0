Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97E3C244147
	for <lists+io-uring@lfdr.de>; Fri, 14 Aug 2020 00:31:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726591AbgHMWbv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 13 Aug 2020 18:31:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726568AbgHMWbv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 13 Aug 2020 18:31:51 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6877EC061757
        for <io-uring@vger.kernel.org>; Thu, 13 Aug 2020 15:31:51 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id y206so3544411pfb.10
        for <io-uring@vger.kernel.org>; Thu, 13 Aug 2020 15:31:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=HL0boH9f/6g4x59TkaSVU8AHlDUPYgL8whmbto2/a6M=;
        b=AGEicqwWHDzDFEnRrthDh6sZOgA38z8TU47/zN/1zlasFrxp96VRgEy4IDxPiD6wkr
         e/kiz13yOd2YR9WHBfH9Zn5wY8Ieo1GLGfZrrZzkgjsuBROclI83EdPJngU1F3Xr5ypX
         EWniQUptpN4XVdk8cfouKvH5gU+FCARO4wiNguHWsEr9I3iwcrbOkGZL+lJ7hMEt7wxe
         EqpamTMQ5xlVl0ywX3S8JNPsPj3iXfLosZBcEHN1JIUNShstL/USUhpi3QqZmXCgkRpj
         wHtRtGAs9UXvkrBW7EHawtzkbqIc9Vcd3Iw4x1YenGhYUoV62y7tbt9P/7Pgxp0aKwoR
         DA6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HL0boH9f/6g4x59TkaSVU8AHlDUPYgL8whmbto2/a6M=;
        b=i5pRJ7edoTKNcwc2lKJT/5AteklKpA5aK7Om6gZENfQiXBbtWFdp7QpP7pOF5Si1Wb
         Xrf7Vv63hWmHQl22YmiFPYPD3oO0eWpvyPaDY+4Jzzj7SPEdjxokTJLWN2Ig8k1j+gny
         71YVIcpRUT0GqVFtZUsum6Xq3bjrR98eVqkSjWktyEt0aJ/BXizFkY+tUac7fNEfpIPd
         51pBfTX3UEjoe7+wlkO+VptTByfbg4j+0h+qbT/iY+PAhIZ0ccq1xhRltJpWq2IA+s2P
         mdaG3JGpWcR8pSjx9gBnsN9TIpMV070udFvyn22LvYeMdcud5iizhZfKnci7wc66TR28
         N6QA==
X-Gm-Message-State: AOAM532qL+PjocrkLiC6gGLwyuA9yo6tsNk65HVDutxObSHX1pDgk48m
        zkiXPe1MDSzjOBSSKwDGoHct6XW1dC0=
X-Google-Smtp-Source: ABdhPJxLuZDWn1imAHh1ofppvgCbgDWaviQugBvvjW+LLZIiy0ZXoHXuYUJ3Ur8Pg0/+qqXnIgDhxQ==
X-Received: by 2002:a63:2584:: with SMTP id l126mr5371146pgl.126.1597357910700;
        Thu, 13 Aug 2020 15:31:50 -0700 (PDT)
Received: from ?IPv6:2600:380:7450:f4f3:ef44:fab:2a3e:c12d? ([2600:380:7450:f4f3:ef44:fab:2a3e:c12d])
        by smtp.gmail.com with ESMTPSA id 27sm6251481pgk.89.2020.08.13.15.31.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Aug 2020 15:31:50 -0700 (PDT)
Subject: Re: [PATCHSET 0/2] io_uring: handle short reads internally
To:     Jeff Moyer <jmoyer@redhat.com>
Cc:     io-uring@vger.kernel.org, david@fromorbit.com
References: <20200813175605.993571-1-axboe@kernel.dk>
 <x497du2z424.fsf@segfault.boston.devel.redhat.com>
 <99c39782-6523-ae04-3d48-230f40bc5d05@kernel.dk>
 <9f050b83-a64a-c112-fc26-309342076c71@kernel.dk>
 <e77644ac-2f6c-944e-0426-5580f5b6217f@kernel.dk>
 <x49364qz2yk.fsf@segfault.boston.devel.redhat.com>
 <b25ecbbd-bb43-c07d-5b08-4850797378e7@kernel.dk>
 <x49y2mixk42.fsf@segfault.boston.devel.redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <aadb4728-abc5-b070-cd3b-02f480f27d61@kernel.dk>
Date:   Thu, 13 Aug 2020 16:31:48 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <x49y2mixk42.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/13/20 4:21 PM, Jeff Moyer wrote:
> Jens Axboe <axboe@kernel.dk> writes:
> 
>>>>> BTW, what git sha did you run?
>>>>
>>>> I do see a failure with dm on that, I'll take a look.
>>>
>>> I ran it on a file system atop nvme with 8 poll queues.
>>>
>>> liburing head: 9e1d69e078ee51f253a829ff421b17cfc996d158
>>> linux-block head: ff1353802d86a9d8e40ef1377efb12a1d3000a20
>>
>> Fixed it, and actually enabled a further cleanup.
> 
> Great, thanks!  Did you push that out somewhere?

It's pushed to io_uring-5.9, current sha is:

ee6ac2d3d5cc50d58ca55a5967671c9c1f38b085

FWIW, the issue was just for fixed buffers. It's running through the
usual testing now.

-- 
Jens Axboe

