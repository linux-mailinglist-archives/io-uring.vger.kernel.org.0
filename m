Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BAA614B4AB
	for <lists+io-uring@lfdr.de>; Tue, 28 Jan 2020 14:06:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725283AbgA1NGx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 28 Jan 2020 08:06:53 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:54036 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725852AbgA1NGx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 28 Jan 2020 08:06:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580216812;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PVCZBoWITEVn0ar0L5LRVeQOwBalysgHCJ5R42wZfYg=;
        b=aKKGxSDsN79xFOg8vcf9IlKtLbHaBK9ZrZSFYeOS0vv5m8Jaj5LCkJX2D/Ch7mV+6F0h12
        3QoxANEWeopJcP2aO/L1XCAG+4TCBpUMMgTC/8BiVHdp+xRk0kEbygVP8h0koDe8B1LnUZ
        y+raXxSb67A2zp4PiXerKmgndzn0nJ8=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-87-Ur_4pAhSNF26wmfXaLAGpA-1; Tue, 28 Jan 2020 08:06:50 -0500
X-MC-Unique: Ur_4pAhSNF26wmfXaLAGpA-1
Received: by mail-wm1-f70.google.com with SMTP id e12so788928wma.7
        for <io-uring@vger.kernel.org>; Tue, 28 Jan 2020 05:06:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=PVCZBoWITEVn0ar0L5LRVeQOwBalysgHCJ5R42wZfYg=;
        b=MvcttZAppIn6IRc/995Ry6tSmkCZm1AZofoWCrB/p3CRWmiAiKAC56O15aLI+FizZP
         JImUpzAxPURyg5gpdTXL6FNoeKTq6BEvv7duxi+75DfMrTqS4HnIRKmBKpRlv7bSvVlH
         XOkQxyKi7yv9pfT7/pB09yMQZ46bHDaGoYAm032LNpI+W3P3rNmPreUlb4CjZiILfG5+
         DfuR52159cOHJy+NrPmxYdS2Lskj8fnyhsP2I+eiOkiixOQHrSQ3ZCBiZeuLv3749sNa
         cgARLP9LZtDdbY5CQBL2I9576z3EvPedV1ls1pYK88bUVEk2p9V2COZNOSkg1N50juXr
         Y2/Q==
X-Gm-Message-State: APjAAAUN7i61ggvI2inFWO90b9c+tnR3Y+RKQctEu83N/6M1Jg3hllkf
        B/wGk9CxmNuM/HXWHHkB7svPlZSiqTkBQfDjZ6lifWUTGH5aTIOQiKh5R4MrPEpG9CkMseapvVJ
        45kc7/uS7s/hyCPpQpQI=
X-Received: by 2002:a5d:4d4a:: with SMTP id a10mr30027646wru.220.1580216808906;
        Tue, 28 Jan 2020 05:06:48 -0800 (PST)
X-Google-Smtp-Source: APXvYqzFnkEhBvvJuJtmNLUvHluChe4Bv8Ikr8QxAm5+P07CiOQneEKsGEiAF0zCN6YWxKDXkUk42Q==
X-Received: by 2002:a5d:4d4a:: with SMTP id a10mr30027618wru.220.1580216808670;
        Tue, 28 Jan 2020 05:06:48 -0800 (PST)
Received: from steredhat (85-207-217-101.static.bluetone.cz. [85.207.217.101])
        by smtp.gmail.com with ESMTPSA id v17sm25046478wrt.91.2020.01.28.05.06.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jan 2020 05:06:48 -0800 (PST)
Date:   Tue, 28 Jan 2020 14:06:46 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH liburing 1/1] test: add epoll test case
Message-ID: <20200128130646.n3x5co7n3m7gbyzy@steredhat>
References: <20200127161701.153625-1-sgarzare@redhat.com>
 <20200127161701.153625-2-sgarzare@redhat.com>
 <b1b26e79-507a-b339-2850-d2686661e669@kernel.dk>
 <20200127182534.5ljsj53vzpj6kkru@steredhat>
 <646cbb04-9bef-0d99-64ec-322d1584abe7@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <646cbb04-9bef-0d99-64ec-322d1584abe7@kernel.dk>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Jan 27, 2020 at 11:46:34AM -0700, Jens Axboe wrote:
> On 1/27/20 11:25 AM, Stefano Garzarella wrote:
> > On Mon, Jan 27, 2020 at 09:32:43AM -0700, Jens Axboe wrote:
> >> On 1/27/20 9:17 AM, Stefano Garzarella wrote:
> >>> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> >>
> >> You're not reaping CQ events, and hence you overflow the ring. Once
> >> overflown, an attempt to submit new IO will returns in a -16/-EBUSY
> >> return value. This is io_uring telling you that it won't submit more
> >> IO until you've emptied the completion ring so io_uring can flush
> >> the overflown entries to the ring.
> > 
> > How can I reaping CQ events? (I was hoping the epoll would help me with that)
> > 
> > What I'm seeing is that the producer (EPOLLOUT) can fill the SQ without issues,
> > the consumer (read()) is receiving all the buffers produced, but the thread
> > that frees the buffers (EPOLLIN) is not woken up.
> > 
> > I tried to set a timeout to the epoll_wait(), but the io_uring_peek_cqe()
> > returns -EAGAIN.
> > 
> > If I'm using a ring with 16 entries, it seems to work better, but
> > sometimes I lose events and the thread that frees the buffer doesn't wake up.
> > 
> > Maybe I'm missing something...
> 
> OK, so that helps in terms of understanding the issue you are seeing with
> it. I'll take a look at this, but it'll probably be a few days. You can
> try and enable tracing, I see events completed just fine. Maybe a race
> with your epoll wait and event reaping?

(discard previous email wrongly sent by my phone, sorry for the noise)

Okay, the issue was that my kernel doesn’t support IORING_FEAT_NODROP,
so for this reason I missed the CQ events.

Avoiding the CQ overflow keeping this condition true
(submitted - completed < n_entries), solves the issue.

I’ll try with a mainline kernel, handling also the -EBUSY returned by
io_uring_submit().

Thanks,
Stefano

