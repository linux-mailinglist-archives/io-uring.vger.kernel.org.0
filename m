Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C15525E590
	for <lists+io-uring@lfdr.de>; Sat,  5 Sep 2020 07:04:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725818AbgIEFEq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 5 Sep 2020 01:04:46 -0400
Received: from mail.nickhill.org ([77.72.3.32]:53322 "EHLO mail.nickhill.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725800AbgIEFEp (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Sat, 5 Sep 2020 01:04:45 -0400
Received: from _ (localhost [127.0.0.1])
        by mail.nickhill.org (Postfix) with ESMTPSA id DE97740C9E;
        Sat,  5 Sep 2020 05:04:42 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 04 Sep 2020 22:04:42 -0700
From:   nick@nickhill.org
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
Subject: Re: WRITEV with IOSQE_ASYNC broken?
In-Reply-To: <fe3784cf-3389-6096-9dfd-f3aa8cd3a769@kernel.dk>
References: <382946a1d3513fbb1354c8e2c875e036@nickhill.org>
 <bfd153eb-0ab9-5864-ca5d-1bc8298f7a21@kernel.dk>
 <fe3784cf-3389-6096-9dfd-f3aa8cd3a769@kernel.dk>
Message-ID: <6428c1ee0234105d18c5e3e88aa00c57@nickhill.org>
X-Sender: nick@nickhill.org
User-Agent: Roundcube Webmail
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2020-09-04 20:57, Jens Axboe wrote:
> On 9/4/20 9:53 PM, Jens Axboe wrote:
>> On 9/4/20 9:22 PM, nick@nickhill.org wrote:
>>> Hi,
>>> 
>>> I am helping out with the netty io_uring integration, and came across
>>> some strange behaviour which seems like it might be a bug related to
>>> async offload of read/write iovecs.
>>> 
>>> Basically a WRITEV SQE seems to fail reliably with -BADADDRESS when 
>>> the
>>> IOSQE_ASYNC flag is set but works fine otherwise (everything else the
>>> same). This is with 5.9.0-rc3.
>> 
>> Do you see it just on 5.9-rc3, or also 5.8? Just curious... But that 
>> is
>> very odd in any case, ASYNC writev is even part of the regular tests.
>> Any sort of deferral, be it explicit via ASYNC or implicit through
>> needing to retry, saves all the needed details to retry without
>> needing any of the original context.
>> 
>> Can you narrow down what exactly is being written - like file type,
>> buffered/O_DIRECT, etc. What file system, what device is hosting it.
>> The more details the better, will help me narrow down what is going 
>> on.
> 
> Forgot, also size of the IO (both total, but also number of iovecs in
> that particular request.
> 
> Essentially all the details that I would need to recreate what you're
> seeing.

I only started testing on 5.9-rc3 so not sure about earlier versions, 
but I'll try and report back.

It's a socket with O_NONBLOCK, iovec array length is ~30 and sum of 
buffer sizes ~1MB.

If it's not easy to recreate then please don't waste time since it could 
be my mistake - I'll try to make a standalone reproducer in that case.
