Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F43D14A9C1
	for <lists+io-uring@lfdr.de>; Mon, 27 Jan 2020 19:25:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725955AbgA0SZl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Jan 2020 13:25:41 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:22218 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725893AbgA0SZl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Jan 2020 13:25:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580149540;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BFX8a4sKZH8kQ5L4CHJJx/4RB7a0Z7xmq0iIUpWzSgw=;
        b=VSzmjEZeZAKCx8Sf0aAel9lIPL5fBdjUDTy4d0fGiD5yRTWkviVDYgMyl2BGNXXLehOgIp
        gfVpAXSS2q4sdCu57+A4aTYZbQVVVM/QyAehS5lWA+4kpOc3UTNIdWGF0oHoXGU13MdTu7
        KrkDeT2ew9IL2LbVmzNpiZr2OuQcOkU=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-44-Ok-kvFWSNJOvD5SzjD1oyw-1; Mon, 27 Jan 2020 13:25:38 -0500
X-MC-Unique: Ok-kvFWSNJOvD5SzjD1oyw-1
Received: by mail-wm1-f70.google.com with SMTP id s25so1766032wmj.3
        for <io-uring@vger.kernel.org>; Mon, 27 Jan 2020 10:25:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BFX8a4sKZH8kQ5L4CHJJx/4RB7a0Z7xmq0iIUpWzSgw=;
        b=IjX9xQXxGD5FRwOgD7fazHcgQ6T7eiZ1MOG0hEu0ESYS4lGU15g/ftNIrj3h0G9DmV
         SRNlQJWmd4L15h+6ubI27elqSX+5GOh+RwF6bbIa6UqXg+BMCadVHV1qfBzPVhW/X9zq
         w/uQA6NLyJV/xGx26rMJqpf9zxb2kzC03EIb1OsdbPX8GA7xD9bKX88p/eL0z4MW4cuN
         rc/AOJljPrOiITu0q4Srika9mYYzxUHP1kTFApUOZzJvn/31XBjL+3wJQpAhSkew9rmW
         QjKBRn7q2wezwJ8mhQZN16WY2UEXfRm5UQncYQT+88HI+t7vVKSeZNP4Jd1xxoa30q5n
         Hsxg==
X-Gm-Message-State: APjAAAUVT1fz6dLA9U3b8E85Fn7IOoeiaH9ooNVGSY0/iJ3CXXvEjZzw
        zH0J4haycZ2/oUBuFiIA/Iy49T/H2gW2gjYFeHysiMGiD4fzkZH+ZPPJNj/1ONR90CCBgHC0I45
        zvnFytBcBkbT6ybDcJBY=
X-Received: by 2002:a1c:9ac6:: with SMTP id c189mr23260wme.59.1580149537060;
        Mon, 27 Jan 2020 10:25:37 -0800 (PST)
X-Google-Smtp-Source: APXvYqyDrE5ynqU3V8zhMZJssfW8GCZe6nB1OYfPuUC0PRWyZEmUR9pW1XXezbAKi6dGcOgvbIoxHA==
X-Received: by 2002:a1c:9ac6:: with SMTP id c189mr23244wme.59.1580149536832;
        Mon, 27 Jan 2020 10:25:36 -0800 (PST)
Received: from steredhat ([80.188.125.198])
        by smtp.gmail.com with ESMTPSA id w8sm21405151wmm.0.2020.01.27.10.25.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jan 2020 10:25:36 -0800 (PST)
Date:   Mon, 27 Jan 2020 19:25:34 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH liburing 1/1] test: add epoll test case
Message-ID: <20200127182534.5ljsj53vzpj6kkru@steredhat>
References: <20200127161701.153625-1-sgarzare@redhat.com>
 <20200127161701.153625-2-sgarzare@redhat.com>
 <b1b26e79-507a-b339-2850-d2686661e669@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b1b26e79-507a-b339-2850-d2686661e669@kernel.dk>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Jan 27, 2020 at 09:32:43AM -0700, Jens Axboe wrote:
> On 1/27/20 9:17 AM, Stefano Garzarella wrote:
> > Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> 
> You're not reaping CQ events, and hence you overflow the ring. Once
> overflown, an attempt to submit new IO will returns in a -16/-EBUSY
> return value. This is io_uring telling you that it won't submit more
> IO until you've emptied the completion ring so io_uring can flush
> the overflown entries to the ring.

How can I reaping CQ events? (I was hoping the epoll would help me with that)

What I'm seeing is that the producer (EPOLLOUT) can fill the SQ without issues,
the consumer (read()) is receiving all the buffers produced, but the thread
that frees the buffers (EPOLLIN) is not woken up.

I tried to set a timeout to the epoll_wait(), but the io_uring_peek_cqe()
returns -EAGAIN.

If I'm using a ring with 16 entries, it seems to work better, but
sometimes I lose events and the thread that frees the buffer doesn't wake up.

Maybe I'm missing something...

Thanks,
Stefano

