Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 516D72DB137
	for <lists+io-uring@lfdr.de>; Tue, 15 Dec 2020 17:22:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729936AbgLOQVi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 15 Dec 2020 11:21:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729877AbgLOQU6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 15 Dec 2020 11:20:58 -0500
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE23DC0617A6
        for <io-uring@vger.kernel.org>; Tue, 15 Dec 2020 08:20:09 -0800 (PST)
Received: by mail-io1-xd41.google.com with SMTP id d9so21049994iob.6
        for <io-uring@vger.kernel.org>; Tue, 15 Dec 2020 08:20:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cepPKu2YWOPZxpSDeaZeJhoYzcrR4WvsyJobJwX+cEc=;
        b=jQfglxdlcpjwlCFYyRKad59C0OEt5BWrVVeVe1DKWwGLkeZnvvjbLlJ7HInYMsaqFz
         qtdpxVJVA1MTUBvDF80/01zIsS2bPvnUzS87uHhxvRdMT1vH3o5mnZ8KAQeKHZeK74LL
         IySCLeVfBPSHbBMQTlS+3IJDhgC9C1sKTQWNC6DkTuv3PamR9RYYrqSul/AuqzAuiG44
         zLYTzcHKR2l9PajGAA7vZmCbqSttLw3+6ExgtzBL3OG5El/rIsi/5TBc1Z1Pb4n3p6CN
         nzGG8pdnoQ48GcrrrkFTCXPScfRELCKGaR/7DPx24KbvKwpL7qKxi82I24Ae/xMYz9Sq
         5DvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cepPKu2YWOPZxpSDeaZeJhoYzcrR4WvsyJobJwX+cEc=;
        b=ol2C/5b+QLolvNYG+vcSD3ZD21NhbT3jI4qrO2oWj2ZFeLAy3QtAt9wjMxxUkigC2t
         fV6XEGIgzqyBqWzJFi2PK2GrAD9+VDR0yLbhrUmZOtm/Vx5pkbBVmBobO693suMJzwKU
         mCKbdcEVAWZFlt8uALZoBMLg5Tgjax9q2tjG9a9xayUbiYTT+/eB+CoBem3Y16ZVvoH6
         CXNek3rxqGaa+ZIuCeNgygSCnVs333bwdulFQ+rg2zIl2G+0k3k5xES4b8dUB94z74VZ
         TB9YzBn0rbhlacb8tomULVfMXsDRIKLflYXZQ9yXeTW/3GEHnEB2PD57FtoPLCtCauAz
         WALQ==
X-Gm-Message-State: AOAM530uefJrx16lyH5iCTD6vabeDL3Ms9pSKOE23dOcMVl/VwuyKKhh
        ih5xjgwQUYiHcKtU1iaNIyPOAIvzUU2xiw==
X-Google-Smtp-Source: ABdhPJxrv7RdVYxK2HHPkxKa0iwCPR0qpoB0UlMbi1sTvAwnuTsoszvGvdwO9TJ1HOwagg8HsddCXw==
X-Received: by 2002:a02:ce2f:: with SMTP id v15mr40055639jar.44.1608049209264;
        Tue, 15 Dec 2020 08:20:09 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id t14sm1523148iof.23.2020.12.15.08.20.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Dec 2020 08:20:08 -0800 (PST)
Subject: Re: [PATCH 0/2] io_uring: add mkdirat support
To:     Dmitry Kadashev <dkadashev@gmail.com>, viro@zeniv.linux.org.uk
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20201116044529.1028783-1-dkadashev@gmail.com>
 <X8oWEkb1Cb9ssxnx@carbon.v>
 <CAOKbgA7MdAF1+MQePoZHALxNC5ye207ET=4JCqvdNcrGTcrkpw@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <faf1a897-3acf-dd82-474d-dadd9fa9a752@kernel.dk>
Date:   Tue, 15 Dec 2020 09:20:08 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAOKbgA7MdAF1+MQePoZHALxNC5ye207ET=4JCqvdNcrGTcrkpw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/15/20 4:43 AM, Dmitry Kadashev wrote:
> On Fri, Dec 4, 2020 at 5:57 PM Dmitry Kadashev <dkadashev@gmail.com> wrote:
>>
>> On Mon, Nov 16, 2020 at 11:45:27AM +0700, Dmitry Kadashev wrote:
>>> This adds mkdirat support to io_uring and is heavily based on recently
>>> added renameat() / unlinkat() support.
>>>
>>> The first patch is preparation with no functional changes, makes
>>> do_mkdirat accept struct filename pointer rather than the user string.
>>>
>>> The second one leverages that to implement mkdirat in io_uring.
>>>
>>> Based on for-5.11/io_uring.
>>>
>>> Dmitry Kadashev (2):
>>>   fs: make do_mkdirat() take struct filename
>>>   io_uring: add support for IORING_OP_MKDIRAT
>>>
>>>  fs/internal.h                 |  1 +
>>>  fs/io_uring.c                 | 58 +++++++++++++++++++++++++++++++++++
>>>  fs/namei.c                    | 20 ++++++++----
>>>  include/uapi/linux/io_uring.h |  1 +
>>>  4 files changed, 74 insertions(+), 6 deletions(-)
>>>
>>> --
>>> 2.28.0
>>>
>>
>> Hi Al Viro,
>>
>> Ping. Jens mentioned before that this looks fine by him, but you or
>> someone from fsdevel should approve the namei.c part first.
> 
> Another ping.
> 
> Jens, you've mentioned the patch looks good to you, and with quite
> similar changes (unlinkat, renameat) being sent for 5.11 is there
> anything that I can do to help this to be accepted (not necessarily
> for 5.11 at this point)?

Since we're aiming for 5.12 at this point, let's just hold off a bit and
see if Al gets time to ack/review the VFS side of things. There's no
immediate rush.

It's on my TODO list, so we'll get there eventually.

-- 
Jens Axboe

