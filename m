Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B003528F0AB
	for <lists+io-uring@lfdr.de>; Thu, 15 Oct 2020 13:07:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbgJOLHP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 15 Oct 2020 07:07:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:52910 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726144AbgJOLHP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 15 Oct 2020 07:07:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602760033;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BbZJ9VFKhe1dAjeQzb7VnwAbk3+JMSe3B7agTZKVr/c=;
        b=XNn7jBjl6a3ML33W+YKPKsPddrkyypuZIlqwYrpvbwkCz7XZlDu3P8hoZwkELZnJx1z8MZ
        ulSTdgVqS24vpB38s79zmXFJw4wd1I/n3Si8rpLOizb3HLFkfEi1FmtHWm0qWTOILZLvw/
        nvjq6KqURq6F3q9YOkC+r5V6wvxadAo=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-592-FM0qR1pFNq2DDf6vIJwpRw-1; Thu, 15 Oct 2020 07:07:12 -0400
X-MC-Unique: FM0qR1pFNq2DDf6vIJwpRw-1
Received: by mail-wr1-f72.google.com with SMTP id a15so1650667wrx.9
        for <io-uring@vger.kernel.org>; Thu, 15 Oct 2020 04:07:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=BbZJ9VFKhe1dAjeQzb7VnwAbk3+JMSe3B7agTZKVr/c=;
        b=G4RfxQk4V4OGJSxiinuZe0imEpqjXOf0g5T3kMPRTWvf6ht0ahKpzN4HVCnI1Q+tMY
         5KkK+KQ2Nm5zlaS4EUTIX0b3c8S0d781FH9wExDPr4AmpM/1fXRbdHhguVNNbltjaSNT
         g5AGU4tSlYXaulXqxoJoB2PQ2sq1FJhQScwEl6yWOYnmuep9ETqwttTf2La9sgxtscIv
         8kqUk8v9GJulk6m/W59NfKJWWcXxYsf5Q6V045ydSqLbUzwTU7tLfWqr0kAnp7+zvfGK
         aFnvhRoP9nuVdgc5OoK4HM0vtAx9wkxTYrOoXdJrgiywBA/Q6et4YEtC3BZudocrNTYx
         PWww==
X-Gm-Message-State: AOAM5327ohxM99IJGWBG6TLG/Pdj/9sX2L9ARJbm4iKNtOd0JOLwGAod
        iCyXs/qRrAJeBzeBaZNb1MDt1z5jPC6pZAj6KhwA9q+Z5prM11DlekPSjIaZl+u9OIFshpf818R
        ImhiGCP1o62c41bQSaDA=
X-Received: by 2002:a7b:c741:: with SMTP id w1mr3535929wmk.67.1602760030572;
        Thu, 15 Oct 2020 04:07:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzu83B8NbC333SOIgfklmvajT1J3jPo7GaXqWE6SpR5qFwdr4DyTeys911By/FMx48Nt126TA==
X-Received: by 2002:a7b:c741:: with SMTP id w1mr3535908wmk.67.1602760030327;
        Thu, 15 Oct 2020 04:07:10 -0700 (PDT)
Received: from steredhat (host-79-27-201-176.retail.telecomitalia.it. [79.27.201.176])
        by smtp.gmail.com with ESMTPSA id j13sm4070378wru.86.2020.10.15.04.07.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2020 04:07:09 -0700 (PDT)
Date:   Thu, 15 Oct 2020 13:07:07 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Cc:     io-uring@vger.kernel.org, axboe@kernel.dk,
        joseph.qi@linux.alibaba.com
Subject: Re: [PATCH] io_uring: fix possible use after free to sqd
Message-ID: <20201015110707.r77jkzema4nmsvrf@steredhat>
References: <20201015091335.1667-1-xiaoguang.wang@linux.alibaba.com>
 <20201015100142.k2uylzcwy6pu6vzw@steredhat>
 <840c002d-399b-92ba-cdc0-de17522fdbce@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <840c002d-399b-92ba-cdc0-de17522fdbce@linux.alibaba.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Oct 15, 2020 at 06:46:34PM +0800, Xiaoguang Wang wrote:
> hi閿涳拷
> 
> > On Thu, Oct 15, 2020 at 05:13:35PM +0800, Xiaoguang Wang wrote:
> > > Reading codes finds a possible use after free issue to sqd:
> > >            thread1              |       thread2
> > > ==> io_attach_sq_data()        |
> > > ===> sqd = ctx_attach->sq_data;|
> > >                                 | ==> io_put_sq_data()
> > >                                 | ===> refcount_dec_and_test(&sqd->refs)
> > >                                 |     If sqd->refs is zero, will free sqd.
> > >                                 |
> > > ===> refcount_inc(&sqd->refs); |
> > >                                 |
> > >                                 | ====> kfree(sqd);
> > > ===> now use after free to sqd |
> > > 
> > 
> > IIUC the io_attach_sq_data() is called only during the setup of an
> > io_uring context, before that the fd is returned to the user space.
> Sorry I didn't make it clear in commit message.
> In io_attach_sq_data(), we'll try to attach to a previous io_uring instance
> indicated by p->wq_fd, this p->wq_fd could be closed independently.

Thanks to clarify! Got it.

Also in this case, IIUC io_put_sq_data() is called only when
io_uring_release() is invoked on the previous io_uring instance.

Since we are taking a reference with fdget at the begin of io_attach_sq_data()
and we release this reference only at the end of io_attach_sq_data(),
can io_put_sq_data() runs in another thread while we have the reference?

Thanks,
Stefano

> 
> Regards,
> Xiaoguang Wang
> > 
> > So, I'm not sure a second thread can call io_put_sq_data() while the
> > first thread is in io_attach_sq_data().
> > 
> > Can you check if this situation can really happen?
> > 
> > Thanks,
> > Stefano
> > 
> > > Use refcount_inc_not_zero() to fix this issue.
> > > 
> > > Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
> > > ---
> > >   fs/io_uring.c | 6 +++++-
> > >   1 file changed, 5 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/fs/io_uring.c b/fs/io_uring.c
> > > index 33b5cf18bb51..48e230feb704 100644
> > > --- a/fs/io_uring.c
> > > +++ b/fs/io_uring.c
> > > @@ -6868,7 +6868,11 @@ static struct io_sq_data *io_attach_sq_data(struct io_uring_params *p)
> > >   		return ERR_PTR(-EINVAL);
> > >   	}
> > > -	refcount_inc(&sqd->refs);
> > > +	if (!refcount_inc_not_zero(&sqd->refs)) {
> > > +		fdput(f);
> > > +		return ERR_PTR(-EINVAL);
> > > +	}
> > > +
> > >   	fdput(f);
> > >   	return sqd;
> > >   }
> > > -- 
> > > 2.17.2
> > > 
> 

