Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7893D2686BA
	for <lists+io-uring@lfdr.de>; Mon, 14 Sep 2020 10:02:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726196AbgINICz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Sep 2020 04:02:55 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:43499 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726122AbgINICv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Sep 2020 04:02:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600070569;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7qkLrk8oFTkLu/qeNEH0NqnfnkcSVIVp8/l5gLhzm90=;
        b=byaImQm68Pypmzj0y7jW2nIZQVJ7NzCNHZGciPKgmVKRhfuMEJ3oqGt+C0W7kfiMsPvx0e
        k8Pm+ebaEXK+R3iZtJ1L15GYWQFJEESxH4wybu8Yh6c+6yy+lqKhDC1Q9N0Sf4Rfldzy+u
        DosSb4VY1iWFzJemImZk1AAHwQ0Jc/4=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-537-98R1zhhhPdehBhu_H4czPg-1; Mon, 14 Sep 2020 04:02:47 -0400
X-MC-Unique: 98R1zhhhPdehBhu_H4czPg-1
Received: by mail-wr1-f71.google.com with SMTP id g6so6587444wrv.3
        for <io-uring@vger.kernel.org>; Mon, 14 Sep 2020 01:02:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7qkLrk8oFTkLu/qeNEH0NqnfnkcSVIVp8/l5gLhzm90=;
        b=nlb3YrYYNKVo+PGpdD45OqQBYRMrtKgmTsmL68ZgkMuCThCYe8enI8TBfYr6Y8XJJ4
         W/h4TEwIabXQ/Kw3YwITAFzL8aucUyEhzX1vLHDyE/sbNA4OLfOsxY1zFEzaRCrZQ1bs
         kYGckznY3x3WYBmd663P3MEnItDsBIJmhx9HSa7hRSgH3Eztu7A2j1xSFYrSPajXuu06
         u+IrIp/jZfQsohA/0WC/NzV+Je0a58Adgn/wUKOMRtqIhCQ2iNlwdIoCsY9q0f4PaEUB
         qFgY3O+xT+RcXWUBpdIu0J6O9nSl8gPjEvRs17Kp9/bg66EoVGYSoyg4D5ESn0uWmjLP
         umJA==
X-Gm-Message-State: AOAM531i8BcK4i+LHl8d8970YbbfA/Yimu0USkHzslxeuXhAt0OE7dzP
        n/sV/2/1GI7j049gY7+ba0ppAkz6VSEEEWwzh+kuhgpOnWlDSQNN/TSdFVUivlCnky1lJpl4fgH
        fYiFDFgroi+VzaeoYFjs=
X-Received: by 2002:a5d:4cc1:: with SMTP id c1mr14488214wrt.122.1600070565578;
        Mon, 14 Sep 2020 01:02:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyybtu3wLwPrUVuG6y1d827PYb4+fMX5rSrsoRiyiOjQro4hDsSsNCIDkSm9q1yRyNMatJKCg==
X-Received: by 2002:a5d:4cc1:: with SMTP id c1mr14488186wrt.122.1600070565303;
        Mon, 14 Sep 2020 01:02:45 -0700 (PDT)
Received: from steredhat (host-79-51-197-141.retail.telecomitalia.it. [79.51.197.141])
        by smtp.gmail.com with ESMTPSA id y5sm18968771wrh.6.2020.09.14.01.02.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2020 01:02:44 -0700 (PDT)
Date:   Mon, 14 Sep 2020 10:02:42 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
Subject: Re: [PATCH liburing 2/3] man/io_uring_register.2: add description of
 restrictions
Message-ID: <20200914080242.w3tmy2owzxlhivb6@steredhat>
References: <20200911133408.62506-1-sgarzare@redhat.com>
 <20200911133408.62506-3-sgarzare@redhat.com>
 <13663e4a-d5a0-17c2-199a-46d03700de6e@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <13663e4a-d5a0-17c2-199a-46d03700de6e@kernel.dk>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Sep 11, 2020 at 09:33:01AM -0600, Jens Axboe wrote:
> On 9/11/20 7:34 AM, Stefano Garzarella wrote:
> > Starting from Linux 5.10 io_uring supports restrictions.
> > This patch describes how to register restriction, enable io_uring
> > ring, and potential errors returned by io_uring_register(2).
> > 
> > Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> > ---
> >  man/io_uring_register.2 | 79 +++++++++++++++++++++++++++++++++++++++--
> >  1 file changed, 77 insertions(+), 2 deletions(-)
> > 
> > diff --git a/man/io_uring_register.2 b/man/io_uring_register.2
> > index 5022c03..ce39ada 100644
> > --- a/man/io_uring_register.2
> > +++ b/man/io_uring_register.2
> > @@ -19,7 +19,8 @@ io_uring_register \- register files or user buffers for asynchronous I/O
> >  
> >  The
> >  .BR io_uring_register ()
> > -system call registers user buffers or files for use in an
> > +system call registers resources (e.g. user buffers, files, eventfd,
> > +personality, restrictions) for use in an
> >  .BR io_uring (7)
> >  instance referenced by
> >  .IR fd .
> > @@ -232,6 +233,58 @@ must be set to the id in question, and
> >  .I arg
> >  must be set to NULL. Available since 5.6.
> >  
> > +.TP
> > +.B IORING_REGISTER_ENABLE_RINGS
> > +This operation enables io_uring ring started in a disabled state
> 
> enables an io_uring
> 
> > +.RB (IORING_SETUP_R_DISABLED
> > +was specified in the call to
> > +.BR io_uring_setup (2)).
> > +While the io_uring ring is disabled, submissions are not allowed and
> > +registrations are not restricted.
> > +
> > +After the execution of this operation, the io_uring ring is enabled:
> > +submissions and registration are allowed, but they will
> > +be validated following the registered restrictions (if any).
> > +This operation takes no argument, must be invoked with
> > +.I arg
> > +set to NULL and
> > +.I nr_args
> > +set to zero. Available since 5.10.
> > +
> > +.TP
> > +.B IORING_REGISTER_RESTRICTIONS
> > +.I arg
> > +points to a
> > +.I struct io_uring_restriction
> > +array of
> > +.I nr_args
> > +entries.
> > +
> > +With an entry it is possible to allow an
> > +.BR io_uring_register ()
> > +.I opcode,
> > +or specify which
> > +.I opcode
> > +and
> > +.I flags
> > +of the submission queue entry are allowed,
> > +or require certain
> > +.I flags
> > +to be specified (these flags must be set on each submission queue entry).
> > +
> > +All the restrictions must be submitted with a single
> > +.BR io_uring_register ()
> > +call and they are handled as an allowlist (opcodes and flags not registered,
> > +are not allowed).
> > +
> > +Restrictions can be registered only if the io_uring ring started in a disabled
> > +state
> > +.RB (IORING_SETUP_R_DISABLED
> > +must be specified in the call to
> > +.BR io_uring_setup (2)).
> > +
> > +Available since 5.10.
> > +
> >  .SH RETURN VALUE
> >  
> >  On success,
> > @@ -242,16 +295,30 @@ is set accordingly.
> >  
> >  .SH ERRORS
> >  .TP
> > +.B EACCES
> > +The
> > +.I opcode
> > +field is not allowed due to registered restrictions.
> > +.TP
> >  .B EBADF
> >  One or more fds in the
> >  .I fd
> >  array are invalid.
> >  .TP
> > +.B EBADFD
> > +.B IORING_REGISTER_ENABLE_RINGS
> > +or
> > +.B IORING_REGISTER_RESTRICTIONS
> > +was specified, but the io_uring ring is not disabled.
> > +.TP
> >  .B EBUSY
> >  .B IORING_REGISTER_BUFFERS
> >  or
> >  .B IORING_REGISTER_FILES
> > -was specified, but there were already buffers or files registered.
> > +or
> > +.B IORING_REGISTER_RESTRICTIONS
> > +was specified, but there were already buffers or files or restrictions
> > +registered.
> 
> buffers, files, or restrictions
> 
> >  .TP
> >  .B EFAULT
> >  buffer is outside of the process' accessible address space, or
> > @@ -283,6 +350,14 @@ is non-zero or
> >  .I arg
> >  is non-NULL.
> >  .TP
> > +.B EINVAL
> > +.B IORING_REGISTER_RESTRICTIONS
> > +was specified, but
> > +.I nr_args
> > +exceeds the maximum allowed number of restrictions or restriction
> > +.I opcode
> > +is invalid.
> > +.TP
> >  .B EMFILE
> >  .B IORING_REGISTER_FILES
> >  was specified and
> 
> Apart from that, looks good to me.
> 

Thanks,
I'll fix the issues in the v2.

Stefano

