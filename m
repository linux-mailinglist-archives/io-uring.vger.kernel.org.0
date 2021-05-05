Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85EAC3747C6
	for <lists+io-uring@lfdr.de>; Wed,  5 May 2021 20:06:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235681AbhEESFQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 5 May 2021 14:05:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235952AbhEESEg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 5 May 2021 14:04:36 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52B0CC07E5DE
        for <io-uring@vger.kernel.org>; Wed,  5 May 2021 10:56:36 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id o26-20020a1c4d1a0000b0290146e1feccdaso3500536wmh.0
        for <io-uring@vger.kernel.org>; Wed, 05 May 2021 10:56:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=qEnVLAuWkaaufGswmOXdOQ6m2FErwe5o2WLVCUHiVOY=;
        b=BwKiSP92TddZRuTT2U3t0iFRPjAnt8r8SKTAaHZDHjvMIVSksArIBiN9egFIo+a2G4
         B4mQ+6oZU4RSWZzuzzYLCCjh+5EcTujnvw6r8/Vo8CchhE7OqO4WALXAVkamddbDK1eL
         MOajzANXqtXWugvE6hSSYyMzWGA0P2hIlE/b12zBEA23LCRl5dq+UDZk3Mf0GObY7Ydv
         DSxkjKI5mC10qplwVX0sl92Ua2RBZzrgQYM2778sBI+zMw28Avi96Qf1FB3VaJYH/7BC
         n799AoxPw770+apk6UjgbAtF4vLRRG3jzaqulELUXdIN8c3di45XDLsAp67/rqXGloR8
         Gzfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qEnVLAuWkaaufGswmOXdOQ6m2FErwe5o2WLVCUHiVOY=;
        b=FE7yWLCOQEDNPbQ+xtjummFkb12dldtjkjp8HGb2nfgqPYWdxbB7TrJvVHhAi9cADb
         8rVAoc2dTJH7F49ZDahtwR78brmbW5tIWPoekpvrLvWKLD1gNWA6R2Y/hdO5wysSy8lA
         L3326MbSMT5onLoo52SrpXwrjtHUGtyHQhVROZqhaKzFivawK+9cOZmUyPBgDa4w0ecA
         LNH3KJc6ekQs+Jz6yZFG4DHcfVWKKhEG7MzHI0uVkt3MgwzlMoHtoOJltAPqE8Zr8S2W
         MvLn5JMq5Twwb1kB04n0+BogUA51nhRM6aEiiIIndW5vFWz1F9XV5cwGkBb5evBYn564
         R9cg==
X-Gm-Message-State: AOAM5300Vzx9Nj1K3cbzpZUYiV1fCAvCL28UepN17Z8RzPXB6n1L6Y9Q
        aVyF1WeWN+dm1uYgR8y3rZRp9nmgfkg=
X-Google-Smtp-Source: ABdhPJzv2o1GhWa+8+zYtzqILLzx+PesWPlIpzryI+FSQNX6l4iYJE+XTDbJGTl/RvZS4VMBqhzaeQ==
X-Received: by 2002:a05:600c:48a8:: with SMTP id j40mr56145wmp.114.1620237394869;
        Wed, 05 May 2021 10:56:34 -0700 (PDT)
Received: from [192.168.8.197] ([185.69.144.196])
        by smtp.gmail.com with ESMTPSA id r1sm8262090wrx.22.2021.05.05.10.56.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 May 2021 10:56:34 -0700 (PDT)
Subject: Re: IORING_OP_POLL_ADD/IORING_OP_POLL_REMOVE questions
To:     Olivier Langlois <olivier@trillion01.com>,
        io-uring <io-uring@vger.kernel.org>
References: <8992f5f989808798ad2666b0a3ef8ae8d777b7de.camel@trillion01.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <db4d01cc-9f58-c04d-d1b6-1208f8fb7220@gmail.com>
Date:   Wed, 5 May 2021 18:56:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <8992f5f989808798ad2666b0a3ef8ae8d777b7de.camel@trillion01.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/4/21 7:06 PM, Olivier Langlois wrote:
> Hi,
> 
> I have started to use io_uring with kernel 5.11.16 and libev 4.33.
> 
> Actually, I did significantly change libev code mostly to use liburing
> instead of replacing most of its boilerplace code for my prototype.
> 
> There is no SQPOLL thread in my setup. io_uring initialisation is as
> plain as it can be:
> 
> ecb_cold
> static int
> iouring_internal_init (EV_P)
> {
>   struct io_uring_params params = { 0 };
> 
>   if (!have_monotonic) /* cannot really happen, but what if!! */
>     return -1;
> 
>   if (io_uring_queue_init_params(iouring_entries, &iouring_ring,
> &params) < 0)
>     return -1;
> 
>   return 0;
> }
> 
> I use io_uring for polling O_NONBLOCK TCP sockets.
> 
> For the most part, io_uring works as expected EXCEPT for this scenario:
> 
> I want to update the polling mask from POLLIN to POLLIN|POLLOUT.
> 
> To achieve that, I do submit to SQEs:
> 
> inline_speed
> void *
> iouring_build_user_data(char type, int fd, uint32_t egen)
> {
>     return (void *)((uint32_t)fd | ((__u64)(egen && 0x00ffffff) << 32 )
> |
>                     ((__u64)type << 56));
> }
> 
> inline_speed
> void
> iouring_decode_user_data(uint64_t data, char *type, int *fd, uint32_t
> *egen)
> {
>   *type = data >> 56;
>   *fd   = data & 0xffffffffU;
>   *egen = (data >> 32) & 0x00ffffffU;
> }
> 
>           struct io_uring_sqe *sqe = iouring_sqe_get (EV_A);
>           printf("%d %d remove %d %u\n", oev, nev, fd, (uint32_t)anfds
> [fd].egen);
>           io_uring_prep_poll_remove(sqe,
> iouring_build_user_data(IOURING_POLL, fd, anfds [fd].egen));
> //          io_uring_sqe_set_data(sqe,
> iouring_build_user_data(IOURING_POLL, fd, anfds [fd].egen));
> 
>           /* increment generation counter to avoid handling old events
> */
>           ++anfds [fd].egen;
> 
>           struct io_uring_sqe *sqe = iouring_sqe_get (EV_A);
>           io_uring_prep_poll_add(sqe, fd, (nev & EV_READ ? POLLIN : 0)
> | (nev & EV_WRITE ? POLLOUT : 0));
>           io_uring_sqe_set_data(sqe,
> iouring_build_user_data(IOURING_POLL, fd, anfds [fd].egen));
> printf("%d %d add %d %u\n", oev, nev, fd, (uint32_t)anfds [fd].egen);
> 
> Followed by a io_uring_enter() call buried in liburing code to submit the 2 sqes at the same time:
> 
> inline_speed
> int
> iouring_enter (EV_P_ ev_tstamp timeout)
> {
>   int res;
>   struct __kernel_timespec ts;
>   struct io_uring_cqe *cqe_ptr;
>   EV_TS_SET(ts, timeout);
>   EV_RELEASE_CB;
> 
>   res = io_uring_wait_cqe_timeout(&iouring_ring, &cqe_ptr, &ts);
> 
>   EV_ACQUIRE_CB;
> 
>   return res;
> }
> 
> On the CQE processing side, I have the following trace:
> 
> // fd is hardcoded to filter out all the calls working fine
> if (fd == 85)
>             printf("85 gen %d res %d\n", (uint32_t)gen, res);
> 
> Here is the output:
> 85 gen 1 res 195
> 0 1 add 85 1
> 
> // Those 2 sqes are submitted at the same time
> 1 3 remove 85 1
> 1 3 add 85 2
> 
> 85 gen 1 res -125
> 85 gen 1 res 4
> 
> When I receive '85 gen 1 res 4', it is discarded because gen 1 poll
> request has been cancelled. The code will process gen 2 cqes from
> there.
> 
> My '1 3 add 85 2' sqe has been silently discarded. After 1 minute of
> unexpected fd inactivity, I try to remove my gen 2 POLL request and it
> result to a cqe reporting an ENOENT error.
> 
> 1. 195 is the cqe result for a successful IORING_OP_POLL_ADD
> submission. I only check the POLLIN|POLLOUT bits. What is the meaning
> of the other bits?
> 
> 2. I don't understand what I am looking at. Why am I receiving a
> completion notification for a POLL request that has just been
> cancelled? What is the logic behind silently discarding a
> IORING_OP_POLL_ADD sqe meant to replace an existing one?

I'm lost in your message, so let's start with simple reasons. All
requests post one CQE (almost true), including poll_remove requests.

io_uring_prep_poll_remove(sqe, iouring_build_user_data(IOURING_POLL, fd, anfds [fd].egen));
// io_uring_sqe_set_data(sqe, iouring_build_user_data(IOURING_POLL, fd, anfds [fd].egen));

If poll remove and poll requests have identical user_data, as in
the second (commented?) line you'll get two CQEs with that user_data.

Did you check return value (in CQE) of poll remove? I'd recommend
set its user_data to something unique. Did you consider that it
may fail?
 
> 3. As I am writing this email, I have just noticed that it was possible
> to update an existing POLL entry with IORING_OP_POLL_REMOVE through
> io_uring_prep_poll_update(). Is this what I should do to eliminate my
> problems? What are the possible race conditions scenarios that I should
> be prepared to handle by using io_uring_prep_poll_update() (ie:
> completion of the poll entry to update while my process is inside
> io_uring_enter() to update it...)?

Update is preferable, but it's Linux kernel 5.13.
Both remove and update may fail. e.g. with -EALREADY

-- 
Pavel Begunkov
