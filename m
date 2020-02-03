Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65B701502E5
	for <lists+io-uring@lfdr.de>; Mon,  3 Feb 2020 10:03:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727509AbgBCJDP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 3 Feb 2020 04:03:15 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:30179 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727339AbgBCJDO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 3 Feb 2020 04:03:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580720594;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QS5DhuU6CK4wbCVngU1PiTIKsJWzHpQ1TW55BC4N5Uk=;
        b=T9nd9bccIXS/uGVYZHsgsR58ozdWibm75Ea2Jb7lNxWE/m69cfpoPJVz3rnigqhtx/3cpd
        0+EVzVg7xZegzVT/CyvCLoWKThvX0t+Zkgktv8HkT5cYOUqN9UH9TiE+6+KdpjQMFaVKw4
        WZYq687HZEQu6pJy8y26PWiOTNkGpMY=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-5-Ey5vO2XQMbKGsW6_Fgl_TQ-1; Mon, 03 Feb 2020 04:03:11 -0500
X-MC-Unique: Ey5vO2XQMbKGsW6_Fgl_TQ-1
Received: by mail-wm1-f69.google.com with SMTP id m4so3752411wmi.5
        for <io-uring@vger.kernel.org>; Mon, 03 Feb 2020 01:03:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QS5DhuU6CK4wbCVngU1PiTIKsJWzHpQ1TW55BC4N5Uk=;
        b=IkoxzLuPoAJV7YRwbp4T/e7L0nJzlLSYzskfNAN79tABiDaqqyG3VlUKJn1eQQ4Ydo
         A8MpeB37PtjIvH2W6evugRl8GI82Oya1d6OPhNmHHJio89LfTgDSTAaJle2J4b+owqO0
         LjkZwG+iBR/tbUs8ChUwZFYlMTpS/bv6vTqpwOwYFpDU8pW2R0N9ZAFRHpV8FcwRo3SY
         qCcbO1qoQdo8ZDvSYJ5RgWeF/iXudwaJB75DiFyoD/co5EZbK+sdWkBH/yY6Mba8wPwR
         O8KpPXeI9igE+4RX5IFjzObb2SP3kJSs0bnmYj7tGHE4vrg2UbvtoWI1MItpdGK6yYjX
         ytXg==
X-Gm-Message-State: APjAAAUsi6KWVL6XUMAbxYwUDvN2wqE087FO8gYum6zZl0Z19HIVtPVr
        YybdhRL/WAlQFiB6HQuCCQc1QGnhJm8pg8Zwg6uBTa/zaDm7Y4Kjoy5LvsxATXOGvzV7uBqJGZv
        PSWDBQpdVMiZAh3rwlY8=
X-Received: by 2002:adf:f3cd:: with SMTP id g13mr14468738wrp.54.1580720590477;
        Mon, 03 Feb 2020 01:03:10 -0800 (PST)
X-Google-Smtp-Source: APXvYqz0JZN0rHbvb/Lu2ak4/sjEHlVgc/AoTaAYJxDdu2O/mLRd8Vkl39m/5i4aqwiKZvESy1fumw==
X-Received: by 2002:adf:f3cd:: with SMTP id g13mr14468698wrp.54.1580720590131;
        Mon, 03 Feb 2020 01:03:10 -0800 (PST)
Received: from steredhat (host209-4-dynamic.27-79-r.retail.telecomitalia.it. [79.27.4.209])
        by smtp.gmail.com with ESMTPSA id f189sm24145163wmf.16.2020.02.03.01.03.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Feb 2020 01:03:09 -0800 (PST)
Date:   Mon, 3 Feb 2020 10:03:07 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH liburing v2 0/1] test: add epoll test case
Message-ID: <CAGxU2F4kKCGeg0xrGsAkj=ZWkfbswxswm6QF2EzDH_6+QQk5Zg@mail.gmail.com>
References: <20200131142943.120459-1-sgarzare@redhat.com>
 <ebc2efdb-4e7f-0db9-ef04-c02aac0b08b1@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ebc2efdb-4e7f-0db9-ef04-c02aac0b08b1@kernel.dk>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Jan 31, 2020 at 4:39 PM Jens Axboe <axboe@kernel.dk> wrote:
> On 1/31/20 7:29 AM, Stefano Garzarella wrote:
> > Hi Jens,
> > this is a v2 of the epoll test.
> >
> > v1 -> v2:
> >     - if IORING_FEAT_NODROP is not available, avoid to overflow the CQ
> >     - add 2 new tests to test epoll with IORING_FEAT_NODROP
> >     - cleanups
> >
> > There are 4 sub-tests:
> >     1. test_epoll
> >     2. test_epoll_sqpoll
> >     3. test_epoll_nodrop
> >     4. test_epoll_sqpoll_nodrop
> >
> > In the first 2 tests, I try to avoid to queue more requests than we have room
> > for in the CQ ring. These work fine, I have no faults.
>
> Thanks!
>
> > In the tests 3 and 4, if IORING_FEAT_NODROP is supported, I try to submit as
> > much as I can until I get a -EBUSY, but they often fail in this way:
> > the submitter manages to submit everything, the receiver receives all the
> > submitted bytes, but the cleaner loses completion events (I also tried to put a
> > timeout to epoll_wait() in the cleaner to be sure that it is not related to the
> > patch that I send some weeks ago, but the situation doesn't change, it's like
> > there is still overflow in the CQ).
> >
> > Next week I'll try to investigate better which is the problem.
>
> Does it change if you have an io_uring_enter() with GETEVENTS set? I wonder if
> you just pruned the CQ ring but didn't flush the internal side.

Yes, If I use the io_uring_wait_cqe() instead of io_uring_peek_cqe() all
the tests work great, but it is blocking and the epoll_wait() it is used
only the first time.

>
> > I hope my test make sense, otherwise let me know what is wrong.
>
> I'll take a look...

Thanks!

>
> > Anyway, when I was exploring the library, I had a doubt:
> > - in the __io_uring_get_cqe() should we call sys_io_uring_enter() also if
> >   submit and wait_nr are zero, but IORING_SQ_NEED_WAKEUP is set in the
> >   sq.kflags?
>
> It's a submission side thing, the completion side shouldn't care. That
> flag is only relevant if you're submitting IO with SQPOLL. Then it tells
> you that the thread needs to get woken up, which you need io_uring_enter()
> to do. But for just reaping completions and not needing to submit
> anything new, we don't care if the thread is sleeping.

Thank you for clarifying that,
Stefano

