Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5F8A2C202A
	for <lists+io-uring@lfdr.de>; Tue, 24 Nov 2020 09:38:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730579AbgKXIiU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 24 Nov 2020 03:38:20 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36837 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726689AbgKXIiU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 24 Nov 2020 03:38:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606207098;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NRJX4VhiqVmNoxpnU+pR55O097A93FWf1GdhM0WFCag=;
        b=UPqLgxSLXIZauRJ1fJREFi4o7kELe8Nv+RvkAsHRCq/rp0zVuzHS7Pl9WlU2Qn3bnuX0u4
        VJV0KKn3ZRuOHlfEwXgvHg7MxZVWBOD8JySEm9prsqK2LqbWAr5m4J0L7jhmlUsZaiBP+G
        1AXuvtTNgFd//Skr9eet/bnhM2EUs0I=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-229-mK0Bf020P6yjLS5H7Inv8A-1; Tue, 24 Nov 2020 03:38:16 -0500
X-MC-Unique: mK0Bf020P6yjLS5H7Inv8A-1
Received: by mail-wm1-f70.google.com with SMTP id g72so889210wme.6
        for <io-uring@vger.kernel.org>; Tue, 24 Nov 2020 00:38:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NRJX4VhiqVmNoxpnU+pR55O097A93FWf1GdhM0WFCag=;
        b=FBywa/cd8FR8EpUTv/u0VvSCGqdQavq3bvg54jWd+kQ4VBZ0F/Wp1yyfg5PqhTMmrh
         9i0omELiCWYVGFAW8LD1tFLqMUdirL2NzHasJfmN11eC6lvG8jY89AYZBhzUKwCQmMIh
         KFXSI/9N98Y1y9JhLYRxNdo/JLuP2/fCadr0RkuwsI4WcXf/sny5Oh+2JJtxsl0AL3g2
         ATdyu3mbsUtydIioTLf4W65njTvpJLZqlJPOci7nlQgrXlS9VIfPgfxe1hQqf7Z43DfY
         Zhb2y4wVnNHIO/mFaBG6R6ERjcCrpy7S+6Al1HH9ySgiNy9NnNRfTDNfHZ0hr2rJ4rSS
         G7pw==
X-Gm-Message-State: AOAM532QOdHv/h4fB60PWRLM7ItcP4ObVVLzmanRT25YXnDVSBg0j2GU
        +LZYj7bmfPtK83pA4tf6dl+SZPqNJ7+n6R8f4CkfndqTw9uQSJvXP9uat6jv30MzG0a26vVKpcP
        by3EH43ExpEX8HS/0o1s=
X-Received: by 2002:a1c:9804:: with SMTP id a4mr3034449wme.158.1606207095208;
        Tue, 24 Nov 2020 00:38:15 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyo7L2x2ooWthppFqmPCuYdKeTNseFvgSDwy9/2ciRj5aLqNh/LZKVqffDoFMzdbURPyr0VkQ==
X-Received: by 2002:a1c:9804:: with SMTP id a4mr3034422wme.158.1606207094950;
        Tue, 24 Nov 2020 00:38:14 -0800 (PST)
Received: from steredhat (host-79-17-248-175.retail.telecomitalia.it. [79.17.248.175])
        by smtp.gmail.com with ESMTPSA id a144sm4181571wmd.47.2020.11.24.00.38.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2020 00:38:14 -0800 (PST)
Date:   Tue, 24 Nov 2020 09:38:12 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Joseph Qi <joseph.qi@linux.alibaba.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Subject: Re: [PATCH] io_uring: fix shift-out-of-bounds when round up cq size
Message-ID: <20201124083812.bnvshaiur4ifa3lr@steredhat>
References: <1606201383-62294-1-git-send-email-joseph.qi@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1606201383-62294-1-git-send-email-joseph.qi@linux.alibaba.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Nov 24, 2020 at 03:03:03PM +0800, Joseph Qi wrote:
>Abaci Fuzz reported a shift-out-of-bounds BUG in io_uring_create():
>
>[ 59.598207] UBSAN: shift-out-of-bounds in ./include/linux/log2.h:57:13
>[ 59.599665] shift exponent 64 is too large for 64-bit type 'long unsigned int'
>[ 59.601230] CPU: 0 PID: 963 Comm: a.out Not tainted 5.10.0-rc4+ #3
>[ 59.602502] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
>[ 59.603673] Call Trace:
>[ 59.604286] dump_stack+0x107/0x163
>[ 59.605237] ubsan_epilogue+0xb/0x5a
>[ 59.606094] __ubsan_handle_shift_out_of_bounds.cold+0xb2/0x20e
>[ 59.607335] ? lock_downgrade+0x6c0/0x6c0
>[ 59.608182] ? rcu_read_lock_sched_held+0xaf/0xe0
>[ 59.609166] io_uring_create.cold+0x99/0x149
>[ 59.610114] io_uring_setup+0xd6/0x140
>[ 59.610975] ? io_uring_create+0x2510/0x2510
>[ 59.611945] ? lockdep_hardirqs_on_prepare+0x286/0x400
>[ 59.613007] ? syscall_enter_from_user_mode+0x27/0x80
>[ 59.614038] ? trace_hardirqs_on+0x5b/0x180
>[ 59.615056] do_syscall_64+0x2d/0x40
>[ 59.615940] entry_SYSCALL_64_after_hwframe+0x44/0xa9
>[ 59.617007] RIP: 0033:0x7f2bb8a0b239
>
>This is caused by roundup_pow_of_two() if the input entries larger
>enough, e.g. 2^32-1. For sq_entries, it will check first and we allow
>at most IORING_MAX_ENTRIES, so it is okay. But for cq_entries, we do
>round up first, that may overflow and truncate it to 0, which is not
>the expected behavior. So check the cq size first and then do round up.
>
>Fixes: 88ec3211e463 ("io_uring: round-up cq size before comparing with rounded sq size")
>Reported-by: Abaci Fuzz <abaci@linux.alibaba.com>
>Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
>---
> fs/io_uring.c | 6 ++++--
> 1 file changed, 4 insertions(+), 2 deletions(-)
>
>diff --git a/fs/io_uring.c b/fs/io_uring.c
>index a8c136a..f971589 100644
>--- a/fs/io_uring.c
>+++ b/fs/io_uring.c
>@@ -9252,14 +9252,16 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p,
> 		 * to a power-of-two, if it isn't already. We do NOT impose
> 		 * any cq vs sq ring sizing.
> 		 */
>-		p->cq_entries = roundup_pow_of_two(p->cq_entries);
>-		if (p->cq_entries < p->sq_entries)
>+		if (!p->cq_entries)
> 			return -EINVAL;
> 		if (p->cq_entries > IORING_MAX_CQ_ENTRIES) {
> 			if (!(p->flags & IORING_SETUP_CLAMP))
> 				return -EINVAL;
> 			p->cq_entries = IORING_MAX_CQ_ENTRIES;
> 		}
>+		p->cq_entries = roundup_pow_of_two(p->cq_entries);
>+		if (p->cq_entries < p->sq_entries)
>+			return -EINVAL;

Your changes reflect what we do for sq_entries, so it feels right to do 
the same for cq_entries. Also moving the check after the roundup 
prevents the issues fixed in 88ec3211e463, so:

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

Thanks,
Stefano

