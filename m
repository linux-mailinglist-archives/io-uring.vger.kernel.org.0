Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 793CE227D44
	for <lists+io-uring@lfdr.de>; Tue, 21 Jul 2020 12:40:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726657AbgGUKkV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 21 Jul 2020 06:40:21 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:53182 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726484AbgGUKkU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 21 Jul 2020 06:40:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595328018;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JJxds48R6O9rnMt3T/vIXqCudN9Py5s51DW/o643deI=;
        b=JSOHTNBvOqcKoFucvISSaDWrNsxWIjmhdER47qeXF/ijupx13IFe+DiEcNJXtJM25osXs7
        S6ngtjUTAKqcqAIp4YFlxHz6OzB3mT/qZkcom3wLCV275WczVq/2JYTlk0FwYsMpP/exf7
        QHJvwWkVY0XcshdMFe1qG1SKQQtwVxQ=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-149-9eOfC44gM4Gh-kmNHgV_mg-1; Tue, 21 Jul 2020 06:40:16 -0400
X-MC-Unique: 9eOfC44gM4Gh-kmNHgV_mg-1
Received: by mail-wr1-f70.google.com with SMTP id j3so12970654wrq.9
        for <io-uring@vger.kernel.org>; Tue, 21 Jul 2020 03:40:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JJxds48R6O9rnMt3T/vIXqCudN9Py5s51DW/o643deI=;
        b=k5a6YJEv2XDYnE6DEt/kqK4NQCSCF9uwfgEKMFIOkItjhAXERgnTaDuHTyJDkx0GwJ
         C4H5jc7+2dZ9vbg9dxlQGtEnIb4tO8WVQ2Lu7LMHM3JKSOn48ieEaR3Wg6A+VWJGrpJj
         peCXi9ZiP5O7zsIGIbRS5nEkA4+Qt9svkRm1SpKQASbfzDft0u8pIosfxy2b/iokGTOx
         nhNqirJY0kvZWx+eQBIfWc2Gh3rNHwOm6hlZsAP89BAA0HrzgcjSqbNXY8DOvubSMKCN
         6FkMtidAxMK+vjGzVvSFnVa/ICjKFRrpAEp+kyE+i0joPF6L4mwFPGp/kQVz1QRpH9Sg
         YnfQ==
X-Gm-Message-State: AOAM5329HA1ToG93qeg6HSfrBQ8rgZx9pz/waLVyz5b3vZRMTFhicrBV
        jin6oujavy/QvyoUrncK8WtFhIpE9lH9yrLDebAl2DK0ob2LiQ89Yz5H1qGh8vA2oPwlzun2xss
        BXuhKB+nEQ1Toz67TpY4=
X-Received: by 2002:adf:db86:: with SMTP id u6mr27108013wri.27.1595328015237;
        Tue, 21 Jul 2020 03:40:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzBo3RCatz2sWoHwy1o+Mv1N6KLRKOUoDm7SJGud2x81ODcAOg8M1F10bzf/K0KK5XuzJcSCQ==
X-Received: by 2002:adf:db86:: with SMTP id u6mr27107996wri.27.1595328014996;
        Tue, 21 Jul 2020 03:40:14 -0700 (PDT)
Received: from steredhat ([5.180.207.22])
        by smtp.gmail.com with ESMTPSA id b62sm2829754wmh.38.2020.07.21.03.40.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2020 03:40:14 -0700 (PDT)
Date:   Tue, 21 Jul 2020 12:40:09 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        Kees Cook <keescook@chromium.org>,
        Aleksa Sarai <asarai@suse.de>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Sargun Dhillon <sargun@sargun.me>,
        Jann Horn <jannh@google.com>, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Jeff Moyer <jmoyer@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC v2 2/3] io_uring: add IOURING_REGISTER_RESTRICTIONS
 opcode
Message-ID: <20200721104009.lg626hmls5y6ihdr@steredhat>
References: <20200716124833.93667-1-sgarzare@redhat.com>
 <20200716124833.93667-3-sgarzare@redhat.com>
 <0fbb0393-c14f-3576-26b1-8bb22d2e0615@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0fbb0393-c14f-3576-26b1-8bb22d2e0615@kernel.dk>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Jul 16, 2020 at 03:26:51PM -0600, Jens Axboe wrote:
> On 7/16/20 6:48 AM, Stefano Garzarella wrote:
> > diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> > index efc50bd0af34..0774d5382c65 100644
> > --- a/include/uapi/linux/io_uring.h
> > +++ b/include/uapi/linux/io_uring.h
> > @@ -265,6 +265,7 @@ enum {
> >  	IORING_REGISTER_PROBE,
> >  	IORING_REGISTER_PERSONALITY,
> >  	IORING_UNREGISTER_PERSONALITY,
> > +	IORING_REGISTER_RESTRICTIONS,
> >  
> >  	/* this goes last */
> >  	IORING_REGISTER_LAST
> > @@ -293,4 +294,30 @@ struct io_uring_probe {
> >  	struct io_uring_probe_op ops[0];
> >  };
> >  
> > +struct io_uring_restriction {
> > +	__u16 opcode;
> > +	union {
> > +		__u8 register_op; /* IORING_RESTRICTION_REGISTER_OP */
> > +		__u8 sqe_op;      /* IORING_RESTRICTION_SQE_OP */
> > +	};
> > +	__u8 resv;
> > +	__u32 resv2[3];
> > +};
> > +
> > +/*
> > + * io_uring_restriction->opcode values
> > + */
> > +enum {
> > +	/* Allow an io_uring_register(2) opcode */
> > +	IORING_RESTRICTION_REGISTER_OP,
> > +
> > +	/* Allow an sqe opcode */
> > +	IORING_RESTRICTION_SQE_OP,
> > +
> > +	/* Only allow fixed files */
> > +	IORING_RESTRICTION_FIXED_FILES_ONLY,
> > +
> > +	IORING_RESTRICTION_LAST
> > +};
> > +
> 
> Not sure I totally love this API. Maybe it'd be cleaner to have separate
> ops for this, instead of muxing it like this. One for registering op
> code restrictions, and one for disallowing other parts (like fixed
> files, etc).
> 
> I think that would look a lot cleaner than the above.
> 

Talking with Stefan, an alternative, maybe more near to your suggestion,
would be to remove the 'struct io_uring_restriction' and add the
following register ops:

    /* Allow an sqe opcode */
    IORING_REGISTER_RESTRICTION_SQE_OP

    /* Allow an io_uring_register(2) opcode */
    IORING_REGISTER_RESTRICTION_REG_OP

    /* Register IORING_RESTRICTION_*  */
    IORING_REGISTER_RESTRICTION_OP


    enum {
        /* Only allow fixed files */
        IORING_RESTRICTION_FIXED_FILES_ONLY,

        IORING_RESTRICTION_LAST
    }


We can also enable restriction only when the rings started, to avoid to
register IORING_REGISTER_ENABLE_RINGS opcode. Once rings are started,
the restrictions cannot be changed or disabled.

If you agree, I'll send a v3 following this.

Thanks,
Stefano

