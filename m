Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98FEC15F6E2
	for <lists+io-uring@lfdr.de>; Fri, 14 Feb 2020 20:31:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729320AbgBNTbr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 14 Feb 2020 14:31:47 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:35165 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729075AbgBNTbr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 14 Feb 2020 14:31:47 -0500
Received: by mail-pf1-f193.google.com with SMTP id y73so5357434pfg.2;
        Fri, 14 Feb 2020 11:31:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=uT4LF3JtjMPCIfz0A4aeioVBUJpYe/gQYOFaUkaqtYE=;
        b=qSFKJiW8EwXhQENOuIpEGjrhOZk/8P3FmjcB5XiyFoaPdPVOe9GdOUlOcz0TgglTv8
         lneyx2TCciIaQ7qMsCk0f4eE6EVFxvf7ns/ecCUXB3CbuMuDI7v0+pZdm1OmloRvqAB7
         mTlJajnkyVwnUfeQXnJ5YsoawL2ayADuZ6rjkVITAbBd5OUy33X+KHW0a4KSyUrET5jp
         /jB5AqyVr7REq1EomEOZgOKS+5BwiaV9ejZlcj8iwUK2SfDUiQLlqsxa+9PNcTvAhOPF
         76h10DK1Z0NRio2fYEur4YsdWMFkkcQRYH2EpBl2iy2JhKFtf+PveuYtFe0s9/FzgNaN
         LNgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=uT4LF3JtjMPCIfz0A4aeioVBUJpYe/gQYOFaUkaqtYE=;
        b=VX1g8OVWIDtt01AlIosbOGYmIqmNCY6Y6HsYsCVeO3mJarjX90URb6f578KTQMQI2H
         A190342ik9NkQmH8W0/Fk5iAekHBpr6fhd4Mmah9B6j2OEg5zI792iiFdEvUS7uQrXKt
         QLEwIRsTjyKsl9KixPoTH60ljwqL3b4bF2hRHm3aDRc4/aa9g8i2hH3GeBHHFJvScEgE
         HV76KfbVdlERdP2+MYmbhOxjP+fTlQD3LTIL56KfOHdGH+DtiJbhlqeqtQyyMd59skid
         S1V8FGfeLV5zTmOo6g0YclVrxj6Neq9F1LDBnGJdycIFuUpt9TjzUFImzSo3pT/GhrGH
         rrmw==
X-Gm-Message-State: APjAAAWLaytiSsz3sLrQsiZ0nlUqtEp0oScSAwZIY8noHgqCbkb2KF4M
        yc29yw9DBPr+aAHc4lhF4cs=
X-Google-Smtp-Source: APXvYqwcrvP+iS1WufeDpLHfT51y6+7J95QazITjNCI2F/pIBee0K2cLezuh/ZwOqM/1iFn0tCp9xQ==
X-Received: by 2002:aa7:8703:: with SMTP id b3mr4816766pfo.67.1581708706830;
        Fri, 14 Feb 2020 11:31:46 -0800 (PST)
Received: from google.com ([2620:15c:211:1:3e01:2939:5992:52da])
        by smtp.gmail.com with ESMTPSA id u12sm7556512pfm.165.2020.02.14.11.31.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Feb 2020 11:31:45 -0800 (PST)
Date:   Fri, 14 Feb 2020 11:31:43 -0800
From:   Minchan Kim <minchan@kernel.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Jann Horn <jannh@google.com>, io-uring <io-uring@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        Linux API <linux-api@vger.kernel.org>,
        Oleksandr Natalenko <oleksandr@redhat.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Tim Murray <timmurray@google.com>,
        Daniel Colascione <dancol@google.com>,
        Sandeep Patil <sspatil@google.com>,
        Sonny Rao <sonnyrao@google.com>,
        Brian Geffon <bgeffon@google.com>,
        Michal Hocko <mhocko@suse.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Shakeel Butt <shakeelb@google.com>,
        John Dias <joaodias@google.com>,
        Joel Fernandes <joel@joelfernandes.org>, sj38.park@gmail.com,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>
Subject: Re: [PATCH v5 1/7] mm: pass task and mm to do_madvise
Message-ID: <20200214193143.GB165785@google.com>
References: <20200214170520.160271-1-minchan@kernel.org>
 <20200214170520.160271-2-minchan@kernel.org>
 <CAG48ez3S5+EasZ1ZWcMQYZQQ5zJOBtY-_C7oz6DMfG4Gcyig1g@mail.gmail.com>
 <68044a15-6a31-e432-3105-f2f1af9f4b74@kernel.dk>
 <20200214184514.GA165785@google.com>
 <93aadcc6-3ef5-4ea0-be6b-23c06862002e@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <93aadcc6-3ef5-4ea0-be6b-23c06862002e@kernel.dk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Feb 14, 2020 at 12:09:50PM -0700, Jens Axboe wrote:
> On 2/14/20 11:45 AM, Minchan Kim wrote:
> > diff --git a/fs/io_uring.c b/fs/io_uring.c
> > index 63beda9bafc5..1c7e9cd6c8ce 100644
> > --- a/fs/io_uring.c
> > +++ b/fs/io_uring.c
> > @@ -2736,7 +2736,7 @@ static int io_madvise(struct io_kiocb *req, struct io_kiocb **nxt,
> >  	if (force_nonblock)
> >  		return -EAGAIN;
> >  
> > -	ret = do_madvise(ma->addr, ma->len, ma->advice);
> > +	ret = do_madvise(NULL, current->mm, ma->addr, ma->len, ma->advice);
> >  	if (ret < 0)
> >  		req_set_fail_links(req);
> >  	io_cqring_add_event(req, ret);
> 
> I think we want to use req->work.mm here - it'll be the same as
> current->mm at this point, but it makes it clear that we're using a
> grabbed mm.

Will fix at respin. Thanks for the review!
