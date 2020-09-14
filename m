Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFEFD26919E
	for <lists+io-uring@lfdr.de>; Mon, 14 Sep 2020 18:33:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726420AbgINQdT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Sep 2020 12:33:19 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:38470 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726174AbgINQDT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Sep 2020 12:03:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600099371;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=P4EcRJzHBVhG1AHJYDfhpMOIq/bL3fXRmHwzcE2CSEM=;
        b=Y5VgxWkLap0b0opLPTFc6itOzUi3/SYaXTovYDENJqK4ULVh/IbQ4YbUZZu0HiVW/yE2rv
        S8F1mZjXpbM5EBfjp8Xh5PUjsPjQz532xKgWUoIfCN7ypgXaWzQrmLhYSSkcl6Ekz4oSc/
        kzUnmXrTYAaW67BXAgD7SmMgx4N8bEA=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-592-UxjTy176N-WMZInuQFozSQ-1; Mon, 14 Sep 2020 12:02:49 -0400
X-MC-Unique: UxjTy176N-WMZInuQFozSQ-1
Received: by mail-wr1-f69.google.com with SMTP id f18so37773wrv.19
        for <io-uring@vger.kernel.org>; Mon, 14 Sep 2020 09:02:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=P4EcRJzHBVhG1AHJYDfhpMOIq/bL3fXRmHwzcE2CSEM=;
        b=t0+Ofd5Mjok5uWbOmlSqsg5QHsd3iD61b4Xno4O1IGHosdz1AA0GqpOmwqESiX7eDa
         lAtUXoP0Y6/PlfeLkc0Q1sVq+s1BOeRFe4szZXSppOg/p5MHCKg2oA34GgNVFmjiG/0q
         M6iEZHnwYGy0P/FoifB8IsPAfYQMhESf3NfOH2is3qgoKCxDf2u1r4YVw99EeZv/OPBO
         28XaU9ka/HdqHTwZ4Q/j5aLQEl8tSfffZxSIWyXaDZSp/JQrvl3ecebADE6VL8gz6D1o
         rASuporDlb8A2B9aQ9T5RxTJoIGIMUM2A1xd8k4xsu2KK4x9jl26BD89v02O/LYWfM7N
         Qd3w==
X-Gm-Message-State: AOAM533wFRS30S7nDDSxoyKqHeIIEx1xMdpnws7ot1gLaVWenkX5gH/w
        wI3UbAMeiVJK9VBtFOdXLJUsNyXoyJulvYSL2BoigVULg4KhMwGko7/TObprFbAeTlD4+GuapQ6
        FiuVXx8WQ/EMI2+KnJfE=
X-Received: by 2002:adf:e2c7:: with SMTP id d7mr16590262wrj.110.1600099367650;
        Mon, 14 Sep 2020 09:02:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxWv8TNQN2mFtmo8Hg2xtFYV0CSgU4qFBX0CF5Vzsebbgi5NbuTSg8FAOuECiXvau4q8ieo6g==
X-Received: by 2002:adf:e2c7:: with SMTP id d7mr16590232wrj.110.1600099367380;
        Mon, 14 Sep 2020 09:02:47 -0700 (PDT)
Received: from steredhat (host-79-51-197-141.retail.telecomitalia.it. [79.51.197.141])
        by smtp.gmail.com with ESMTPSA id n10sm7467444wmk.7.2020.09.14.09.02.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2020 09:02:46 -0700 (PDT)
Date:   Mon, 14 Sep 2020 18:02:43 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
Subject: Re: [PATCH liburing 3/3] man/io_uring_enter.2: add EACCES and EBADFD
 errors
Message-ID: <20200914160243.o4vldl5isqktrvdd@steredhat>
References: <20200911133408.62506-1-sgarzare@redhat.com>
 <20200911133408.62506-4-sgarzare@redhat.com>
 <d38ae8b4-cb3e-3ebf-63e3-08a1f24ddcbb@kernel.dk>
 <20200914080537.2ybouuxtjvckorc2@steredhat>
 <dc01a74f-db66-0da9-20b7-b6c6e6cb1640@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dc01a74f-db66-0da9-20b7-b6c6e6cb1640@kernel.dk>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Sep 14, 2020 at 09:38:25AM -0600, Jens Axboe wrote:
> On 9/14/20 2:05 AM, Stefano Garzarella wrote:
> > On Fri, Sep 11, 2020 at 09:36:02AM -0600, Jens Axboe wrote:
> >> On 9/11/20 7:34 AM, Stefano Garzarella wrote:
> >>> These new errors are added with the restriction series recently
> >>> merged in io_uring (Linux 5.10).
> >>>
> >>> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> >>> ---
> >>>  man/io_uring_enter.2 | 18 ++++++++++++++++++
> >>>  1 file changed, 18 insertions(+)
> >>>
> >>> diff --git a/man/io_uring_enter.2 b/man/io_uring_enter.2
> >>> index 5443d5f..4773dfd 100644
> >>> --- a/man/io_uring_enter.2
> >>> +++ b/man/io_uring_enter.2
> >>> @@ -842,6 +842,16 @@ is set appropriately.
> >>>  .PP
> >>>  .SH ERRORS
> >>>  .TP
> >>> +.B EACCES
> >>> +The
> >>> +.I flags
> >>> +field or
> >>> +.I opcode
> >>> +in a submission queue entry is not allowed due to registered restrictions.
> >>> +See
> >>> +.BR io_uring_register (2)
> >>> +for details on how restrictions work.
> >>> +.TP
> >>>  .B EAGAIN
> >>>  The kernel was unable to allocate memory for the request, or otherwise ran out
> >>>  of resources to handle it. The application should wait for some completions and
> >>> @@ -861,6 +871,14 @@ field in the submission queue entry is invalid, or the
> >>>  flag was set in the submission queue entry, but no files were registered
> >>>  with the io_uring instance.
> >>>  .TP
> >>> +.B EBADFD
> >>> +The
> >>> +.I fd
> >>> +field in the submission queue entry is valid, but the io_uring ring is not
> >>> +in the right state (enabled). See
> >>> +.BR io_uring_register (2)
> >>> +for details on how to enable the ring.
> >>> +.TP
> >>
> >> I actually think some of this needs general updating. io_uring_enter()
> >> will not return an error on behalf of an sqe, it'll only return an error
> >> if one happened outside the context of a specific sqe. Any error
> >> specific to an sqe will generate a cqe with the result.
> > 
> > Mmm, right.
> > 
> > For example in this case, EACCES is returned by a cqe and EBADFD is
> > returned by io_uring_enter().
> > 
> > Should we create 2 error sections?
> 
> Yep, I think we should. One that describes that io_uring_enter() would
> return in terms of errors, and one that describes cqe->res returns.

Yeah, that would be much better!

> 
> Are you up for this? Would be a great change, making it a lot more
> accurate.

Sure! I'll prepare a patch with this change, and I'll also try to catch
all possible return values, then I'll rebase this series on top of that.

Thanks,
Stefano

