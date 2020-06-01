Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFE0A1EA59C
	for <lists+io-uring@lfdr.de>; Mon,  1 Jun 2020 16:15:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726017AbgFAOPB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 1 Jun 2020 10:15:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726962AbgFAOO5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 1 Jun 2020 10:14:57 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80E15C03E96F
        for <io-uring@vger.kernel.org>; Mon,  1 Jun 2020 07:14:56 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id t7so2710644pgt.3
        for <io-uring@vger.kernel.org>; Mon, 01 Jun 2020 07:14:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9vOcJSYuJJnYePrRcpmlNi98VlvUeqMvdIZYemDmBzo=;
        b=cPAowrvg3+8qpPhWODryKeUzF16vt+n1EfUw78CDYf7Lmd27WHSykd1EAJniDvxoHr
         iGcxqup+zi2L/8Xbac/DxZOOAa7a9GrvsICk2grrQ5f/PK8GuJJ1LgXraOaaG0Y+tfF9
         kx2d6ZjJKrNhnEth5VY4l2ltmhRhjlCNlnp4AokjwZSnNxl5D3NExhU5MtUgSUUkMEvw
         3ncRizoIv+h1P3kk2/tvP/fTQqdAr+f9fNzLUXrK9MjDSWl9mqob5TZxOkaqCXdkKXwz
         YdOJtPJAD6CaC31PGpqhjkREk/45yfElugELO9/U6LpN5A08ZVxv19ginlCQKZWb+ce/
         8EkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9vOcJSYuJJnYePrRcpmlNi98VlvUeqMvdIZYemDmBzo=;
        b=HLcYVGI6OAwG2au+mMNk6PX3RdJ+W85Pdt/mxzgrTSRSv3ZxsupRxwxQvpT1aIp1vP
         1f4Hy9GNoNwpQiVnHZDW0si9GwOqFe3Xe1CCyBKh8yyw34927vi1aJSxuREh8FE0KdSS
         v/KTJpjxwddHOilM8TwgQ5k01FSmQ+uMWAV74IiS5+7eP+ck1QBEMowD2277wa8yY8Qe
         9Cl7x3FGAaGvKvjGRsGhXkZWM7T1INHwsx5BkvevMwzozir+PKVgnGmySJ8+S+uIwjGL
         yX/Hi6dIZJMwxkU+St6Sdz4m9ZGRxsGwvIhXOgW4ZcXw04p8fFQ1LwtB3w9WxVAUuHwa
         uJ5w==
X-Gm-Message-State: AOAM530ccGDs9NNp+0LjQxqR6NSF9AWefI3x5MHJ8f8xrxFomWvbPsdI
        cea5LnzAQkqrerpF1iwX77tomg==
X-Google-Smtp-Source: ABdhPJzre5AcvNL/dtRANT5mUdNrjeNyCn2H4102/mC652nMm3G+J97guUP+QFSgYAFiENMgxqf2bA==
X-Received: by 2002:a62:ed02:: with SMTP id u2mr21244554pfh.60.1591020895906;
        Mon, 01 Jun 2020 07:14:55 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id z29sm14780695pff.120.2020.06.01.07.14.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Jun 2020 07:14:55 -0700 (PDT)
Subject: Re: [PATCHSET v5 0/12] Add support for async buffered reads
To:     sedat.dilek@gmail.com
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org
References: <20200526195123.29053-1-axboe@kernel.dk>
 <CA+icZUWfX+QmroE6j74C7o-BdfMF5=6PdYrA=5W_JCKddqkJgQ@mail.gmail.com>
 <bab2d6f8-4c65-be21-6a8e-29b76c06807d@kernel.dk>
 <CA+icZUUgazqLRwnbQgFPhCa5vAsAvJhjCGMYs7KYBZgA04mSyw@mail.gmail.com>
 <CA+icZUUwz5TPpT_zS=P4MZBDzzrAcFvZMUce8mJu8M1C7KNO5A@mail.gmail.com>
 <CA+icZUVJT8X3zyafrgbkJppsp4nJEKaLjYNs1kX8H+aY1Y10Qw@mail.gmail.com>
 <CA+icZUWHOYcGUpw4gfT7xP2Twr15YbyXiWA_=Mc+f7NgzZCETw@mail.gmail.com>
 <230d3380-0269-d113-2c32-6e4fb94b79b8@kernel.dk>
 <CA+icZUXxmOA-5+dukCgxfSp4eVHB+QaAHO6tsgq0iioQs3Af-w@mail.gmail.com>
 <CA+icZUV4iSjL8=wLA3qd1c5OQHX2s1M5VKj2CmJoy2rHmzSVbQ@mail.gmail.com>
 <CA+icZUXkWG=08rz9Lp1-ZaRCs+GMTwEiUaFLze9xpL2SpZbdsQ@mail.gmail.com>
 <cdb3ac15-0c41-6147-35f1-41b2a3be1c33@kernel.dk>
 <CA+icZUUfxAc9LaWSzSNV4tidW2KFeVLkDhU30OWbQP-=2bYFHw@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <b24101f1-c468-8f6b-9dcb-6dc59d0cd4b9@kernel.dk>
Date:   Mon, 1 Jun 2020 08:14:53 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <CA+icZUUfxAc9LaWSzSNV4tidW2KFeVLkDhU30OWbQP-=2bYFHw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/1/20 8:13 AM, Sedat Dilek wrote:
> On Mon, Jun 1, 2020 at 4:04 PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 6/1/20 7:35 AM, Sedat Dilek wrote:
>>> Hi Jens,
>>>
>>> with Linux v5.7 final I switched to linux-block.git/for-next and reverted...
>>>
>>> "block: read-ahead submission should imply no-wait as well"
>>>
>>> ...and see no boot-slowdowns.
>>
>> Can you try with these patches applied instead? Or pull my async-readahead
>> branch from the same location.
>>
> 
> Yes, I can do that.
> I pulled from linux-block.git#async-readahead and will report later.
> 
> Any specific testing desired by you?

Just do your boot timing test and see if it works, thanks.

-- 
Jens Axboe

