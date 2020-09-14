Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5FC326870C
	for <lists+io-uring@lfdr.de>; Mon, 14 Sep 2020 10:18:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726186AbgINISj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Sep 2020 04:18:39 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:32631 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726139AbgINIGI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Sep 2020 04:06:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600070744;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ah/7JZ3FhL4+IfM21SDySx/N6XTyrRtw0c9SJaONCMg=;
        b=MwD8kP4T4icAXOzbLD4Mu4ATUJKdB0s01gdA9BLtFCbXE+bIBb34Pyosvf81y3w96jYNNh
        c+/7ymvPu8LaFaI4945qDYsesBvp/vlzmXcrOshZHWZzgCseaUiiO3TEon7SzHUVRC5mfe
        eEBrJ5khrIDp1Y+oujzepAw2u8VV6yY=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-321-yD2rt6w1PrGTU9CDtXyTkw-1; Mon, 14 Sep 2020 04:05:42 -0400
X-MC-Unique: yD2rt6w1PrGTU9CDtXyTkw-1
Received: by mail-wr1-f69.google.com with SMTP id o6so6563614wrp.1
        for <io-uring@vger.kernel.org>; Mon, 14 Sep 2020 01:05:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ah/7JZ3FhL4+IfM21SDySx/N6XTyrRtw0c9SJaONCMg=;
        b=a/cI0QlVrdR0eIxRXf3qoY8fJ3IVTAy8ynGxLNvoREB/E53gaYmbRibAto/4hafflh
         KDdbZeAieL6swnBs3noQxZyeHJM+A+0bSPZLDsrMc5I+jS9ftXxhYQ5sw9lxBjs02Rhl
         RgkxPNNx6YatAoNKtDJElWzPA4GBHcviW5xbFqTl1Mr/ObovTcqbmWGYolk1QzTePZNW
         jzjFRLi7BnjyN9GZRcA14KE24J9rp2kfo+PD+1uDlzwELWm7+4i8tuFigJxfu7i7Dvwg
         yY4+cB1UtM4PDMMhXI+wAsthGB8E0oHQLY4xdwgwOjKFpq+xu24EEkzvvAQCchIXPj5l
         vp0g==
X-Gm-Message-State: AOAM531uy1Y5WEw/ijwybcYAWfBm8m16zyAjs3Y2TUpr2ttnchYxw7it
        A3tefbFZJiU3ankAoCdhNqeT7AmIpVPFMxPEA0VN3yh7IcKGheAjGMaIal/4CNFuIUGLkw4hCYG
        3JaFJrQm47P43K6JIHxs=
X-Received: by 2002:adf:cc8c:: with SMTP id p12mr15051445wrj.92.1600070740836;
        Mon, 14 Sep 2020 01:05:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxNWAA+VC6Vv/Gx/VPVlov5nDySuyU4Ne7h5LIQho215gxKlinuQ4wkVEc3qtrRVHbcQwic+Q==
X-Received: by 2002:adf:cc8c:: with SMTP id p12mr15051424wrj.92.1600070740647;
        Mon, 14 Sep 2020 01:05:40 -0700 (PDT)
Received: from steredhat (host-79-51-197-141.retail.telecomitalia.it. [79.51.197.141])
        by smtp.gmail.com with ESMTPSA id t22sm21041873wmt.1.2020.09.14.01.05.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2020 01:05:40 -0700 (PDT)
Date:   Mon, 14 Sep 2020 10:05:37 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
Subject: Re: [PATCH liburing 3/3] man/io_uring_enter.2: add EACCES and EBADFD
 errors
Message-ID: <20200914080537.2ybouuxtjvckorc2@steredhat>
References: <20200911133408.62506-1-sgarzare@redhat.com>
 <20200911133408.62506-4-sgarzare@redhat.com>
 <d38ae8b4-cb3e-3ebf-63e3-08a1f24ddcbb@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d38ae8b4-cb3e-3ebf-63e3-08a1f24ddcbb@kernel.dk>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Sep 11, 2020 at 09:36:02AM -0600, Jens Axboe wrote:
> On 9/11/20 7:34 AM, Stefano Garzarella wrote:
> > These new errors are added with the restriction series recently
> > merged in io_uring (Linux 5.10).
> > 
> > Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> > ---
> >  man/io_uring_enter.2 | 18 ++++++++++++++++++
> >  1 file changed, 18 insertions(+)
> > 
> > diff --git a/man/io_uring_enter.2 b/man/io_uring_enter.2
> > index 5443d5f..4773dfd 100644
> > --- a/man/io_uring_enter.2
> > +++ b/man/io_uring_enter.2
> > @@ -842,6 +842,16 @@ is set appropriately.
> >  .PP
> >  .SH ERRORS
> >  .TP
> > +.B EACCES
> > +The
> > +.I flags
> > +field or
> > +.I opcode
> > +in a submission queue entry is not allowed due to registered restrictions.
> > +See
> > +.BR io_uring_register (2)
> > +for details on how restrictions work.
> > +.TP
> >  .B EAGAIN
> >  The kernel was unable to allocate memory for the request, or otherwise ran out
> >  of resources to handle it. The application should wait for some completions and
> > @@ -861,6 +871,14 @@ field in the submission queue entry is invalid, or the
> >  flag was set in the submission queue entry, but no files were registered
> >  with the io_uring instance.
> >  .TP
> > +.B EBADFD
> > +The
> > +.I fd
> > +field in the submission queue entry is valid, but the io_uring ring is not
> > +in the right state (enabled). See
> > +.BR io_uring_register (2)
> > +for details on how to enable the ring.
> > +.TP
> 
> I actually think some of this needs general updating. io_uring_enter()
> will not return an error on behalf of an sqe, it'll only return an error
> if one happened outside the context of a specific sqe. Any error
> specific to an sqe will generate a cqe with the result.

Mmm, right.

For example in this case, EACCES is returned by a cqe and EBADFD is
returned by io_uring_enter().

Should we create 2 error sections?

Thanks,
Stefano

