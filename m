Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05D91253EB2
	for <lists+io-uring@lfdr.de>; Thu, 27 Aug 2020 09:12:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727839AbgH0HMk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 27 Aug 2020 03:12:40 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:57939 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726851AbgH0HMg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 27 Aug 2020 03:12:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598512355;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JL0Nic4lUYEvTQAyILRqVFTBlq5K5PuaRWhSncRHSwg=;
        b=jCAO6CFiJ9r6N/6UpmAGenQWzEPJIHktVq1NqHm2KN58QA3uTsDaFBuus38oJ3tDapI1IC
        7wlAuPnRJmNB2qpIqoYQuaEN6W1diKZzGCWrNY5L5bjzveisDExKyUcDVsCZPcvzGSL6rT
        P1fubMEUWWDu5swIjr1Z4fzsNZh1WXc=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-8-WY6P24pCO2ih-8FSba-fDg-1; Thu, 27 Aug 2020 03:12:33 -0400
X-MC-Unique: WY6P24pCO2ih-8FSba-fDg-1
Received: by mail-wr1-f69.google.com with SMTP id e14so1155628wrr.7
        for <io-uring@vger.kernel.org>; Thu, 27 Aug 2020 00:12:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JL0Nic4lUYEvTQAyILRqVFTBlq5K5PuaRWhSncRHSwg=;
        b=j/JqPaT+Xl+lgH3g1tcgl+1nmeb7WZ47pccUxCFiQFKru+m8RLXpmO1cMDo12moHSb
         ox2rcTG8a64jjylh7alcNwg52+B7zDLPSy1eoncSfZs4myS5KOLu6OdhNobGjAfN1rvk
         4dwSCOaYDIo4/53o4T7mYG5KBwmJfkNnH9obXrN1pBQ14NYhTjsbhqjrpsQVmiS8Xtrp
         LSkK5KvZrSjNgLCjKZUPYIOsBRM9dShMhY54E6PLKyC+jbfcbOkLc3sdDFx7HKq0NJSn
         xvm74tDBvZNRWf/6UnaVg9m6L20KAuCdXv/8zhOOZgMzHwL0L3eGcNdk+ou49sXUljNx
         8ysw==
X-Gm-Message-State: AOAM533KwCNr1VR5qW4xFCbRQeAZmhUAHLOMeL2e4ZgkYez7N4r6oaNB
        TkzdJDloxPjqnDI5Ry0spJFnSLAfkIrpB1tVRalnnEr/pYDrrtqoDeuo64qXfAuIl0+/TymShUK
        aV4colePfUnDGv3acrzI=
X-Received: by 2002:a5d:650b:: with SMTP id x11mr305701wru.46.1598512352240;
        Thu, 27 Aug 2020 00:12:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwUHzxCz2Spgqmv60oYq58isMCoWeEsBIsG0b8y0nTVMsLWHJ63NS9EGPcX3VzzE1QFXWCdbg==
X-Received: by 2002:a5d:650b:: with SMTP id x11mr305672wru.46.1598512351999;
        Thu, 27 Aug 2020 00:12:31 -0700 (PDT)
Received: from steredhat.lan ([5.180.207.22])
        by smtp.gmail.com with ESMTPSA id h11sm3694657wrb.68.2020.08.27.00.12.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2020 00:12:31 -0700 (PDT)
Date:   Thu, 27 Aug 2020 09:12:27 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Kees Cook <keescook@chromium.org>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Jann Horn <jannh@google.com>, Jeff Moyer <jmoyer@redhat.com>,
        linux-fsdevel@vger.kernel.org, Sargun Dhillon <sargun@sargun.me>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        linux-kernel@vger.kernel.org, Aleksa Sarai <asarai@suse.de>,
        io-uring@vger.kernel.org
Subject: Re: [PATCH v4 2/3] io_uring: add IOURING_REGISTER_RESTRICTIONS opcode
Message-ID: <20200827071227.tozlhvidn3iet6xy@steredhat.lan>
References: <20200813153254.93731-1-sgarzare@redhat.com>
 <20200813153254.93731-3-sgarzare@redhat.com>
 <202008261245.245E36654@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202008261245.245E36654@keescook>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Aug 26, 2020 at 12:46:24PM -0700, Kees Cook wrote:
> On Thu, Aug 13, 2020 at 05:32:53PM +0200, Stefano Garzarella wrote:
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
> > +	/* Allow sqe flags */
> > +	IORING_RESTRICTION_SQE_FLAGS_ALLOWED,
> > +
> > +	/* Require sqe flags (these flags must be set on each submission) */
> > +	IORING_RESTRICTION_SQE_FLAGS_REQUIRED,
> > +
> > +	IORING_RESTRICTION_LAST
> > +};
> 
> Same thought on enum literals, but otherwise, looks good:

Sure, I'll fix the enum in the next version.

> 
> Reviewed-by: Kees Cook <keescook@chromium.org>

Thanks for the review,
Stefano

