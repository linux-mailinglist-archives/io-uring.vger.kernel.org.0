Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD81633D87F
	for <lists+io-uring@lfdr.de>; Tue, 16 Mar 2021 17:01:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238265AbhCPQBN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 16 Mar 2021 12:01:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238386AbhCPQAM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 16 Mar 2021 12:00:12 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85E32C061756
        for <io-uring@vger.kernel.org>; Tue, 16 Mar 2021 09:00:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Date:Message-ID:From:To:CC;
        bh=ad4vdd6FJ5m0FjpwXbYrm26nhLVju9gq4YP3QuiYB3Y=; b=z1Hj4SyR+d2T0YEuKBzr1fN2/L
        fOtx4apOXQLRl/FFOwGbi7/0WuDMIzaVbYVvBTRYsWWbW0FfTUy/E84touLFxsrc1zxdPGUgD4ROC
        urLYwKyw117d1UPvEN+15LdSzXdZgtVU+i9R1EHobGGsdfw/ZOTqyADcjMyQr2cXg0C4tb/u0AhyE
        RACGzbHoVyHGEN/07grA5gCjjZp2wLoB2K2CvGjdJ+w6uw32Li3SA3H0WCdeCIxxxjwVhu/kC+5XI
        BwAKwMwE98dBi9NMhQ0QWsiVPprUym8bGAy5uJud5iI4HcUJVc6Mqza0PdUqcE68HVPDArsJYhx6o
        a0GsRAswYcRd9ddlrq9uGcvHtBlanPc7XzRYK015FAyFBXLYD7Fy3XqqYPi1FXKdvFQ7ALWf9CSrt
        x02zwf1GycAvxhKn9tX1qvDSwQ76Vwd6MY0NXoJYCFoeuyBe2VZI7bNDSyTbi/F0L1AyzqwhZRQZn
        BTI0kU0FT2mnIB+xoejsVm1m;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1lMC77-00016m-8z; Tue, 16 Mar 2021 16:00:09 +0000
To:     Jens Axboe <axboe@kernel.dk>,
        Norman Maurer <norman.maurer@googlemail.com>,
        io-uring <io-uring@vger.kernel.org>
References: <371592A7-A199-4F5C-A906-226FFC6CEED9@googlemail.com>
 <e83c9ef0-8016-2c4a-9dd0-b2a1318238ef@kernel.dk>
From:   Stefan Metzmacher <metze@samba.org>
Subject: Re: IORING_OP_RECVMSG not respects non-blocking nature of the fd
Message-ID: <f61d1b62-fab6-75db-1e2a-695d8765d15f@samba.org>
Date:   Tue, 16 Mar 2021 17:00:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <e83c9ef0-8016-2c4a-9dd0-b2a1318238ef@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


Am 16.03.21 um 15:23 schrieb Jens Axboe:
> On 3/16/21 8:00 AM, Norman Maurer wrote:
>> Hi there,
>>
>> I think I found a bug in the current io_uring implementation. It seems
>> like recvmsg currently not respect when a fd is set to non-blocking.
>> At the moment recvmsg never returns in this case. I can work around
>> this by using MSG_DONTWAIT but I don’t think this should be needed.
>>
>> I am using the latest 5.12 code base atm.
> 
> This is actually "by design" in that system calls that offer a "don't
> block for this operation" (like MSG_DONTWAIT here) will not be looking
> at the O_NONBLOCK flag. Though it is a bit confusing and potentially
> inconsistent, my argument here is that this is the case for system calls
> in general, where even O_NONBLOCK has very hazy semantics depending on
> what system call you are looking at.
> 
> The issue is mostly around when to use -EAGAIN to arm async retry, and
> when to return -EAGAIN to the application.
> 
> I'd like to hear from others here, but as far as io_uring is concerned,
> we _should_ be consistent in how we treat O_NONBLOCK _depending_ on if
> that system call allows a flags method of passing in nonblock behavior.

As ____sys_recvmsg() has this:

        if (sock->file->f_flags & O_NONBLOCK)
                flags |= MSG_DONTWAIT;

The difference is that we don't block in__sys_recvmsg() within a worker thread,
but instead handle it via io_arm_poll_handler()?

I think it should be documented, but I guess it might be useful to keep a way
to switch between the 3 available modes in order to find the one that
performances best depending on the workload.

metze
