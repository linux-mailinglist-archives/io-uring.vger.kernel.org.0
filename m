Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CA9538999E
	for <lists+io-uring@lfdr.de>; Thu, 20 May 2021 01:07:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229967AbhESXJL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 19 May 2021 19:09:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbhESXJK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 19 May 2021 19:09:10 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3E48C061574;
        Wed, 19 May 2021 16:07:49 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id t11so8129336pjm.0;
        Wed, 19 May 2021 16:07:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JJgI804V8+GisJoccWZ4H8urJEjP8SBVK3/sos6whD8=;
        b=tcLT0NM08so9FI4OpB4PBLbarrM0gozK9gJI1dMvCwosgAtgs61t/k2zSPMa+DLd9G
         Wt51eYZA5c1hDgB+X22uyirdRZ6NRRKdp1LlHFF06HBCB4KWs6AwUBlyRRsE42aoIHen
         Az9D+nZx3KPKaaHrS802VKokCTbKI0LLWPhVG5m7erZP2WY0l9deUrPGrRBEg4/Sdz8M
         UXltfIMC137PDWre8aiEwP0j8T5J+G/jnBkIsdER8KBLvW3/LLrfVMlaUj0mhAr7RFbq
         KBv6iXbcSV/mg65MlVgphABPe1KvRXqGgT7+VektzAqP5e+r1pjmN2ldGmtIt5CYxD2I
         /WbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JJgI804V8+GisJoccWZ4H8urJEjP8SBVK3/sos6whD8=;
        b=mAJraDOGX0mTn0pCIW2WtCYy619WiMP4VLS2dG26tu4hfJwSsJJmCjOBBgElt7jhjw
         0VEPYRAF54ClX/nKoPFfjZ0wv/K1zHhgW9FlRtgq9u8BY84bmOrUdfVsFX0Te2QinMmL
         Q2XsGgIM96j0b8spYlvYSA2sD2EQqoxYOyH8yCIrOSMYQ74bt9UkShSuzxa/2OnCUlTm
         R5GPK4dD2ddxzTFKQpzutRJlAoaksdJIrQsc7qPxbyhBSAMXP2icZVp0ad/WRzxtq+Ko
         zao+Gskkjy69E++VamuqxPF20Im0zMdPaLB7skO/iGFSk6u0OtE6/RwE7LvIxjxafVde
         cn0Q==
X-Gm-Message-State: AOAM532PQMfjph5Z0kjsnw501KYtQvnJAIUOvb+dFxpJOBmXObVbv1T3
        DGvIHy7WEAM174P9NxaUQMI=
X-Google-Smtp-Source: ABdhPJwZ2IBT3ZwppVgbY5fgBPeqRoLVCsB5V+J33sJycwrmIrkomAm3UGaIfZVqCPWYa/+QxNWgOw==
X-Received: by 2002:a17:90a:c285:: with SMTP id f5mr1763196pjt.221.1621465669105;
        Wed, 19 May 2021 16:07:49 -0700 (PDT)
Received: from localhost ([2409:4063:4c14:9209:2c39:fff0:5625:d9ad])
        by smtp.gmail.com with ESMTPSA id r13sm333417pfl.191.2021.05.19.16.07.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 May 2021 16:07:48 -0700 (PDT)
Date:   Thu, 20 May 2021 04:37:10 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Paul Moore <paul@paul-moore.com>
Cc:     io-uring@vger.kernel.org, Pavel Emelyanov <xemul@openvz.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Lokesh Gidra <lokeshgidra@google.com>,
        Eric Biggers <ebiggers@google.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] fs: anon_inodes: export anon_inode_getfile_secure
 helper
Message-ID: <20210519230710.k3hzomsr27onevhf@apollo>
References: <20210519113058.1979817-1-memxor@gmail.com>
 <20210519113058.1979817-2-memxor@gmail.com>
 <CAHC9VhTBcCJ1TfvB-HbzrByroeqfFE-SF_REik9PDSdqmJbuYA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHC9VhTBcCJ1TfvB-HbzrByroeqfFE-SF_REik9PDSdqmJbuYA@mail.gmail.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, May 19, 2021 at 08:52:51PM IST, Paul Moore wrote:
> On Wed, May 19, 2021 at 7:37 AM Kumar Kartikeya Dwivedi
> <memxor@gmail.com> wrote:
> >
> > This is the non-fd installing analogue of anon_inode_getfd_secure. In
> > addition to allowing LSMs to attach policy to the distinct inode, this
> > is also needed for checkpoint restore of an io_uring instance where a
> > mapped region needs to mapped back to the io_uring fd by CRIU. This is
> > currently not possible as all anon_inodes share a single inode.
> >
> > Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> > ---
> >  fs/anon_inodes.c            | 9 +++++++++
> >  include/linux/anon_inodes.h | 4 ++++
> >  2 files changed, 13 insertions(+)
>
> [NOTE: dropping dancol@google as that email is bouncy]
>
> > diff --git a/fs/anon_inodes.c b/fs/anon_inodes.c
> > index a280156138ed..37032786b211 100644
> > --- a/fs/anon_inodes.c
> > +++ b/fs/anon_inodes.c
> > @@ -148,6 +148,15 @@ struct file *anon_inode_getfile(const char *name,
> >  }
> >  EXPORT_SYMBOL_GPL(anon_inode_getfile);
>
> This function should have a comment block at the top similar to
> anon_inode_getfile(); in fact you can likely copy-n-paste the bulk of
> it to use as a start.
>
> If you don't want to bother respinning, I've got this exact patch
> (+comments) in my patchset that I'll post later and I'm happy to
> give/share credit if that is important to you.
>

That'd be great; no credit is fine :). Please CC me when you post it.

> > +struct file *anon_inode_getfile_secure(const char *name,
> > +                                      const struct file_operations *fops,
> > +                                      void *priv, int flags,
> > +                                      const struct inode *context_inode)
> > +{
> > +       return __anon_inode_getfile(name, fops, priv, flags, context_inode, true);
> > +}
> > +EXPORT_SYMBOL_GPL(anon_inode_getfile_secure);
>
> --
> paul moore
> www.paul-moore.com

--
Kartikeya
