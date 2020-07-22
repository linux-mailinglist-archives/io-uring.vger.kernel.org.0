Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AA8D2299DF
	for <lists+io-uring@lfdr.de>; Wed, 22 Jul 2020 16:15:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730987AbgGVOOR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 22 Jul 2020 10:14:17 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:46054 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728351AbgGVOOQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 22 Jul 2020 10:14:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595427254;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ps88iqkraXTn/rbzr2+oz1MZHz7VliYQ9j+dqbYwLek=;
        b=iLjk0zupNKG2xMkFtim2T4NUeI11SrH8aEBlNLdAe2vUXWYxLqNFSmNqwBNXyUDCE7ypJ3
        ozJwgPDdWkLDUGDoT5j+/o4loPa2aCJZQPkviaVkxP+Z6F9MKZ9UblVo6FJnlELECiwQto
        ouCE7oYQtiwiEKHFD7FS25AsVKriIY0=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-393-hLCHUBq-OSixWr4KW3WNPw-1; Wed, 22 Jul 2020 10:14:11 -0400
X-MC-Unique: hLCHUBq-OSixWr4KW3WNPw-1
Received: by mail-wr1-f72.google.com with SMTP id s23so500127wrb.12
        for <io-uring@vger.kernel.org>; Wed, 22 Jul 2020 07:14:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ps88iqkraXTn/rbzr2+oz1MZHz7VliYQ9j+dqbYwLek=;
        b=pSBGwR7FdgDb8sGCtEN1adaPNFDaJAs669nCp8XEMfzLL+lrSugM3acYToagn2iFfz
         PIneh5sLdOhO6KGR3x9fTZDB/L3uBoDr6dmnlG/hNVWlIY6GiBRHpbDdQKC7cH3XTy38
         xv9s/c83ETy13NyTm2kkEgRWRo8BhwlbI4gNKk5wuxmmHg0dBg5zN2qSFYT+XFKT5P5I
         qFwtwmttt6ewg5yIWjoIaM8w/P3my3KrGahIkub6hUYoW8qJ/0TP3iyuGOpEWM9RxCEU
         ec6V5RkzCaHudSSA4YLUIMi0GCjV5Hmd6e0rscR0Nm+zh3xyvqnDTKVLVRd+ftff4SYq
         HstQ==
X-Gm-Message-State: AOAM530p4aCVoxeBkeW0pPSMig4rf/gYxDk7daXzv/k+usyjlxGBYGNi
        3HLCBvOwFG/GjFz+XkU8lt7ewVhbOhDwL1LrTf1e59FPNFJjkObek1T0jiVjTgo59IaHtaaPy2z
        2sdAI4mpYHS0GqNccrTQ=
X-Received: by 2002:a7b:cd83:: with SMTP id y3mr8594857wmj.105.1595427250732;
        Wed, 22 Jul 2020 07:14:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz178qGAQ1jCBRTkpJrLbY4BB2WPhou45FPoMFaFZC17iXHMBUam/196r1RSA2qFKbt6kQqYQ==
X-Received: by 2002:a7b:cd83:: with SMTP id y3mr8594833wmj.105.1595427250464;
        Wed, 22 Jul 2020 07:14:10 -0700 (PDT)
Received: from steredhat ([5.180.207.22])
        by smtp.gmail.com with ESMTPSA id d18sm92174wrj.8.2020.07.22.07.14.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2020 07:14:09 -0700 (PDT)
Date:   Wed, 22 Jul 2020 16:14:04 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Daurnimator <quae@daurnimator.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        Kees Cook <keescook@chromium.org>,
        Aleksa Sarai <asarai@suse.de>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Sargun Dhillon <sargun@sargun.me>,
        Jann Horn <jannh@google.com>,
        io-uring <io-uring@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, Jeff Moyer <jmoyer@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC v2 2/3] io_uring: add IOURING_REGISTER_RESTRICTIONS
 opcode
Message-ID: <20200722141404.jfzfl3alpyw7o7dw@steredhat>
References: <20200716124833.93667-1-sgarzare@redhat.com>
 <20200716124833.93667-3-sgarzare@redhat.com>
 <0fbb0393-c14f-3576-26b1-8bb22d2e0615@kernel.dk>
 <20200721104009.lg626hmls5y6ihdr@steredhat>
 <15f7fcf5-c5bb-7752-fa9a-376c4c7fc147@kernel.dk>
 <CAEnbY+fCP-HS_rWfOF2rnUPos-eZRF1dL+m2Q8CZidi_W=a7xw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEnbY+fCP-HS_rWfOF2rnUPos-eZRF1dL+m2Q8CZidi_W=a7xw@mail.gmail.com>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Jul 22, 2020 at 12:35:15PM +1000, Daurnimator wrote:
> On Wed, 22 Jul 2020 at 03:11, Jens Axboe <axboe@kernel.dk> wrote:
> >
> > On 7/21/20 4:40 AM, Stefano Garzarella wrote:
> > > On Thu, Jul 16, 2020 at 03:26:51PM -0600, Jens Axboe wrote:
> > >> On 7/16/20 6:48 AM, Stefano Garzarella wrote:
> > >>> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> > >>> index efc50bd0af34..0774d5382c65 100644
> > >>> --- a/include/uapi/linux/io_uring.h
> > >>> +++ b/include/uapi/linux/io_uring.h
> > >>> @@ -265,6 +265,7 @@ enum {
> > >>>     IORING_REGISTER_PROBE,
> > >>>     IORING_REGISTER_PERSONALITY,
> > >>>     IORING_UNREGISTER_PERSONALITY,
> > >>> +   IORING_REGISTER_RESTRICTIONS,
> > >>>
> > >>>     /* this goes last */
> > >>>     IORING_REGISTER_LAST
> > >>> @@ -293,4 +294,30 @@ struct io_uring_probe {
> > >>>     struct io_uring_probe_op ops[0];
> > >>>  };
> > >>>
> > >>> +struct io_uring_restriction {
> > >>> +   __u16 opcode;
> > >>> +   union {
> > >>> +           __u8 register_op; /* IORING_RESTRICTION_REGISTER_OP */
> > >>> +           __u8 sqe_op;      /* IORING_RESTRICTION_SQE_OP */
> > >>> +   };
> > >>> +   __u8 resv;
> > >>> +   __u32 resv2[3];
> > >>> +};
> > >>> +
> > >>> +/*
> > >>> + * io_uring_restriction->opcode values
> > >>> + */
> > >>> +enum {
> > >>> +   /* Allow an io_uring_register(2) opcode */
> > >>> +   IORING_RESTRICTION_REGISTER_OP,
> > >>> +
> > >>> +   /* Allow an sqe opcode */
> > >>> +   IORING_RESTRICTION_SQE_OP,
> > >>> +
> > >>> +   /* Only allow fixed files */
> > >>> +   IORING_RESTRICTION_FIXED_FILES_ONLY,
> > >>> +
> > >>> +   IORING_RESTRICTION_LAST
> > >>> +};
> > >>> +
> > >>
> > >> Not sure I totally love this API. Maybe it'd be cleaner to have separate
> > >> ops for this, instead of muxing it like this. One for registering op
> > >> code restrictions, and one for disallowing other parts (like fixed
> > >> files, etc).
> > >>
> > >> I think that would look a lot cleaner than the above.
> > >>
> > >
> > > Talking with Stefan, an alternative, maybe more near to your suggestion,
> > > would be to remove the 'struct io_uring_restriction' and add the
> > > following register ops:
> > >
> > >     /* Allow an sqe opcode */
> > >     IORING_REGISTER_RESTRICTION_SQE_OP
> > >
> > >     /* Allow an io_uring_register(2) opcode */
> > >     IORING_REGISTER_RESTRICTION_REG_OP
> > >
> > >     /* Register IORING_RESTRICTION_*  */
> > >     IORING_REGISTER_RESTRICTION_OP
> > >
> > >
> > >     enum {
> > >         /* Only allow fixed files */
> > >         IORING_RESTRICTION_FIXED_FILES_ONLY,
> > >
> > >         IORING_RESTRICTION_LAST
> > >     }
> > >
> > >
> > > We can also enable restriction only when the rings started, to avoid to
> > > register IORING_REGISTER_ENABLE_RINGS opcode. Once rings are started,
> > > the restrictions cannot be changed or disabled.
> >
> > My concerns are largely:
> >
> > 1) An API that's straight forward to use
> > 2) Something that'll work with future changes
> >
> > The "allow these opcodes" is straightforward, and ditto for the register
> > opcodes. The fixed file I guess is the odd one out. So if we need to
> > disallow things in the future, we'll need to add a new restriction
> > sub-op. Should this perhaps be "these flags must be set", and that could
> > easily be augmented with "these flags must not be set"?
> >
> > --
> > Jens Axboe
> >
> 
> This is starting to sound a lot like seccomp filtering.
> Perhaps we should go straight to adding a BPF hook that fires when
> reading off the submission queue?
> 

You're right. I e-mailed about that whit Kees Cook [1] and he agreed that the
restrictions in io_uring should allow us to address some issues that with
seccomp it's a bit difficult. For example:
- different restrictions for different io_uring instances in the same
  process
- limit SQEs to use only registered fds and buffers

Maybe seccomp could take advantage of the restrictions to filter SQEs opcodes.

Thanks,
Stefano

[1] https://lore.kernel.org/io-uring/202007160751.ED56C55@keescook/

