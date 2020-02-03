Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C8A01502EA
	for <lists+io-uring@lfdr.de>; Mon,  3 Feb 2020 10:04:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727786AbgBCJEN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 3 Feb 2020 04:04:13 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:43721 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727761AbgBCJEN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 3 Feb 2020 04:04:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580720652;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=H6fxCf78eVhuUAJ68T4mXmDzlZwZiDCeV31HsdqoAPA=;
        b=cRJ/xczlawbuqevs9NVEPeP2a+HphBQU4H0OgaBSNW25TJTpab8EV5d8xPKk4tfCLXHruK
        3S/AExvdldWf4ve9RARETRCntFgQoeCmEBzZHBy0QZdRGo7q8xjjZZgbPppOXabbjCHq8N
        1LgcVTzFv76ERgE7/faLXHaV15D2y/Q=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-228-fEWJcbTdMtCTmrB37ZNfRw-1; Mon, 03 Feb 2020 04:04:10 -0500
X-MC-Unique: fEWJcbTdMtCTmrB37ZNfRw-1
Received: by mail-wr1-f70.google.com with SMTP id w17so2761673wrr.9
        for <io-uring@vger.kernel.org>; Mon, 03 Feb 2020 01:04:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=H6fxCf78eVhuUAJ68T4mXmDzlZwZiDCeV31HsdqoAPA=;
        b=p+cUO+5QEwArbXxzakIxGrZ7yOU7mtOKr5GbuT2pa4OIrz8J+5WOQ8j6GYEx/O+ZxO
         d2PK6rfzmAzjVqOUfP3z1ZeI8yJZUHtVHn9ik4QxMX9OTI4Gs72PzbQjrg9LrPRj32Jq
         9eswQu86hgAi0lA4aTFG4mL5J7Uuh2r3GZb0tzVMJ7bznCraD8lOaYROqJadfeOGlPwj
         V9QMtNZJb+oY0LLWr5wOmaE1ZSEy/Y4tcjLyNInhaoV9Tvro5IvCjaXDTMk1oF1FBamw
         89wEPPucyBEja968tfuLaGEOrq9y3O9ci/6gkp44HcikJBwLkYdoUp/0L6OUyiDG7m2G
         MQfA==
X-Gm-Message-State: APjAAAXl24lGfP5a2zZcEsn1fjwAkKC/b/QxlX9nH5qKoTbmr+Op6f4D
        CGn/ABnYqIXDfiQsxwXh/uGzrGmlziw31/hWQFno09t3Kq8D2VEiV0ZVkwJsYxTwekUFPJi0VXs
        k4lbKWGkFgJRlYIrBIw8=
X-Received: by 2002:adf:e2cf:: with SMTP id d15mr14314703wrj.225.1580720649217;
        Mon, 03 Feb 2020 01:04:09 -0800 (PST)
X-Google-Smtp-Source: APXvYqyYREAVG5O0ErdfVCjrJuHlKZLavmASH0lil9NjCzoWb7VUJmnMW/g8uhNveQrKDhLPzLxliw==
X-Received: by 2002:adf:e2cf:: with SMTP id d15mr14314686wrj.225.1580720649063;
        Mon, 03 Feb 2020 01:04:09 -0800 (PST)
Received: from steredhat (host209-4-dynamic.27-79-r.retail.telecomitalia.it. [79.27.4.209])
        by smtp.gmail.com with ESMTPSA id z3sm7458497wrs.32.2020.02.03.01.04.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Feb 2020 01:04:08 -0800 (PST)
Date:   Mon, 3 Feb 2020 10:04:06 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH liburing v2 1/1] test: add epoll test case
Message-ID: <20200203090406.mlgmw2u7lv7a76vd@steredhat>
References: <20200131142943.120459-1-sgarzare@redhat.com>
 <20200131142943.120459-2-sgarzare@redhat.com>
 <00610b2b-2110-36c2-d6ce-85599e46013f@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00610b2b-2110-36c2-d6ce-85599e46013f@kernel.dk>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Jan 31, 2020 at 08:41:49AM -0700, Jens Axboe wrote:
> On 1/31/20 7:29 AM, Stefano Garzarella wrote:
> > This patch add the epoll test case that has four sub-tests:
> > - test_epoll
> > - test_epoll_sqpoll
> > - test_epoll_nodrop
> > - test_epoll_sqpoll_nodrop
> 
> Since we have EPOLL_CTL now, any chance you could also include
> a test case that uses that instead of epoll_ctl()?

Sure, I'll add a test case for EPOLL_CTL!

Stefano

