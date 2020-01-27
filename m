Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 476CD14A96D
	for <lists+io-uring@lfdr.de>; Mon, 27 Jan 2020 19:07:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725975AbgA0SHo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Jan 2020 13:07:44 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:32877 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725955AbgA0SHo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Jan 2020 13:07:44 -0500
Received: by mail-pj1-f65.google.com with SMTP id m7so6486pjs.0
        for <io-uring@vger.kernel.org>; Mon, 27 Jan 2020 10:07:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vyLjNX65TqvX4+HTsrUYbj8jYzvexX51y2g4R+mvQ7g=;
        b=w8Jx4wy0f2LkHXyMBqznF1wu63frSCsE+E82q59WmC5F0Fmj4XRoj68pI1xrStwbro
         ZWJayNGwIeg+mim18qXfSOZzie1w9UtdRhtyv2bf/3E2DFi4qcME7Md84yo5Be5Nmn3S
         ggP3CIoUI7qvu0aDFcAt7Dd1hkBZWwQXPULaCnQTNt6exKfDxPo0MfVQmp1xxqegOmLP
         TnKfOG1MhGow0yh5v1i6qOWmfJaGcnHrhVCHxuN/D9CK+N9SpDsv6SS6S3yJJDYgmOCR
         iRBptjhguyj1cQZzA1gBO9b1kWl8UUfnS5mt9Sq5dZyLB7FEKu2hA92ekgoohUQTfGxy
         kf8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vyLjNX65TqvX4+HTsrUYbj8jYzvexX51y2g4R+mvQ7g=;
        b=AqmDEaKWwqKwJi6jjp5ueG5tOCXi6wvCwOiNWxSH6NUvqWcvI/87SDfgHgUeMvEb31
         wXARcMSz0EqYIDrwAh0GuEsEp1zurDn3sAthhOBnYxTOqqTbhVyTwM7SowEsCSYu8yg4
         ZHOftLN1TsdRgk90c/qlak4J18S5XH/Gac+vAquPGDmGl2jCWnzEm0kfoumhimG3qF3/
         Xu1yWSqfxzMU8kC8FDCte/Ju+oHKNer5jUtTGceg2uksBQ3Ibz7aqgvsHo4YjbY5qz0X
         IJ7Nzx2A2eZNtcbiJZt11K6EVf3OnPPZz2tfj4H2CttLlsaXyUHGk1UtM2VzK0HbSSA0
         ScGA==
X-Gm-Message-State: APjAAAW6LGyUnWvaF2Zexamd24Zf7+bjHLQdaAtHQSNB4OOJhbv3ZeKH
        cPjORW3d1+YSP33lhJCB1qCBpQ==
X-Google-Smtp-Source: APXvYqwe/oxWeLbduB8OLf0irC9A5pKjfq5do/KkPqFf4AT7Mm4ybCCstGD0k7+lLYNZx/XfCVf6fQ==
X-Received: by 2002:a17:902:b193:: with SMTP id s19mr10337731plr.205.1580148463685;
        Mon, 27 Jan 2020 10:07:43 -0800 (PST)
Received: from ?IPv6:2620:10d:c081:1133::11c2? ([2620:10d:c090:180::dec1])
        by smtp.gmail.com with ESMTPSA id 199sm15837913pfv.81.2020.01.27.10.07.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Jan 2020 10:07:42 -0800 (PST)
Subject: Re: [PATCH liburing 0/1] test: add epoll test case
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200127161701.153625-1-sgarzare@redhat.com>
 <d409ad33-2122-9500-51f4-37e9748f1d73@kernel.dk>
 <20200127180028.f7s5xhhizii3dsnr@steredhat>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <52df8d77-1cb4-b8d5-d03d-5a8cabaeddb6@kernel.dk>
Date:   Mon, 27 Jan 2020 11:07:41 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200127180028.f7s5xhhizii3dsnr@steredhat>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/27/20 11:00 AM, Stefano Garzarella wrote:
> On Mon, Jan 27, 2020 at 09:26:41AM -0700, Jens Axboe wrote:
>> On 1/27/20 9:17 AM, Stefano Garzarella wrote:
>>> Hi Jens,
>>> I wrote the test case for epoll.
>>>
>>> Since it fails also without sqpoll (Linux 5.4.13-201.fc31.x86_64),
>>> can you take a look to understand if the test is wrong?
>>>
>>> Tomorrow I'll travel, but on Wednesday I'll try this test with the patch
>>> that I sent and also with the upstream kernel.
>>
>> I'll take a look, but your patches are coming through garbled and don't
>> apply.
> 
> Weird, I'm using git-publish as usual. I tried to download the patch
> received from the ML, and I tried to reapply and it seams to work here.
> 
> Which kind of issue do you have? (just to fix my setup)

First I grabbed it from email, and I get the usual =3D (instead of =)
and =20 instead of a space. Longer lines also broken up, with an = at
the end.

Then I grabbed it from the lore io-uring archive, but it was the exact
same thing.

> Anyway I pushed my tree here:
>     https://github.com/stefano-garzarella/liburing.git epoll

As per other email, I think you're having some coordination issues
with the reaping and submitting side being separated. If the reaper
isn't keeping up, you'll get the -EBUSY problem I saw. I'm assuming
that's the failure case you are also seeing, you didn't actually
mention how it fails for you?

-- 
Jens Axboe

