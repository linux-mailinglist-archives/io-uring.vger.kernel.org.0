Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A5544D68C7
	for <lists+io-uring@lfdr.de>; Fri, 11 Mar 2022 19:53:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351001AbiCKSyU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 11 Mar 2022 13:54:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350138AbiCKSyU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 11 Mar 2022 13:54:20 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 701CE25E8A
        for <io-uring@vger.kernel.org>; Fri, 11 Mar 2022 10:53:16 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id b24so11968811edu.10
        for <io-uring@vger.kernel.org>; Fri, 11 Mar 2022 10:53:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mhiJoyGK6i48A+CV44wvGM/sNOc2SA/ZHL0e71y9Ouw=;
        b=oxd6LAQKWQ5hKfBrALwTaY5UPGW3xSf9z0WFCbd/U2Y6H0HdsW/os1CmTDYsESly0w
         tqUHS7uXcBfX3xvTcS15ysDWNektRriLFjwr2sFQrEkwYcoMX8VEWNHfqqXCDF3yJGQv
         NydGiZKzqXKRAx3KfjS9uNw11cYYRQcS/FX2RoEVSsCkVCHpb3WSXmZ63bSDR5fQfyUL
         epYrOqC8w1p7y2RIEPMp8bx2BMtBa3Q61oUyL1IgQd6FtXH1elLFXVm9PyDdAGEDEe3z
         A/aZlLmcTeMQ4MaY52V9j7G8gOX5WZdDofYqd8HZfnGW0lzoThKe4Y+F5geLdfpjodDv
         7Jrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mhiJoyGK6i48A+CV44wvGM/sNOc2SA/ZHL0e71y9Ouw=;
        b=cwsZkvqn+amOUaOksVQrx7zzn9LhGv3D4J8b8/REkx6QhKDizVkhYdx+E6PZ+of7Hg
         FwDNkGBvdsi4zIwdGlQqmitz9j3Vg2zj9H2a+bNg6oJNkk2v0nzBLeuuptrCfT1NpmG3
         sMDMv3J9ztDEaQuEfaBB5EdKaW93m0DsuiMlRxryyIqRDRErJRbFs7R9DJ4oq+pK/Etz
         tjw4woEKuQ8I2AGB+7hi3bSSgQHfoVMzOv/lFLaLvtn+4tNWXVzSq80zf06MGa8rKB7i
         u/ZRiIXAbNEw7Pe1PWrvUJm9J5cb4bv5IRoEesrmptdFufXoy5oZkPSTXJ31tnPB/c64
         WrdQ==
X-Gm-Message-State: AOAM5317aK7xhWPEtqGVp0wuEFTqHOZEhLbwR/sUg8/jyrPq0OO+wLAw
        FfLTWktGmsKBKQQ7+1ko5iwa12dd8X8URnFQmCDd
X-Google-Smtp-Source: ABdhPJwxFS6emBP91ghOo78Xcf38HmQKuJ92uGWWAskNZTBSdMpqT2NKwaEKOmMFF9dvmety1PBkMMF2unwneHLaEzA=
X-Received: by 2002:a05:6402:42d4:b0:412:c26b:789 with SMTP id
 i20-20020a05640242d400b00412c26b0789mr10168594edc.232.1647024794826; Fri, 11
 Mar 2022 10:53:14 -0800 (PST)
MIME-Version: 1.0
References: <20220308152105.309618-1-joshi.k@samsung.com> <CGME20220308152702epcas5p1eb1880e024ac8b9531c85a82f31a4e78@epcas5p1.samsung.com>
 <20220308152105.309618-6-joshi.k@samsung.com> <YiuNZ7+KUjLtuYkr@bombadil.infradead.org>
In-Reply-To: <YiuNZ7+KUjLtuYkr@bombadil.infradead.org>
From:   Paul Moore <paul@paul-moore.com>
Date:   Fri, 11 Mar 2022 13:53:03 -0500
Message-ID: <CAHC9VhTnpO6LyaYWDTjJAy_ztGw+qqf-YS0W7S-djyZVnydVHg@mail.gmail.com>
Subject: Re: [PATCH 05/17] nvme: wire-up support for async-passthru on char-device.
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     Kanchan Joshi <joshi.k@samsung.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        linux-security-module@vger.kernel.org, axboe@kernel.dk, hch@lst.de,
        kbusch@kernel.org, asml.silence@gmail.com,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, sbates@raithlin.com,
        logang@deltatee.com, pankydev8@gmail.com, javier@javigon.com,
        a.manzanares@samsung.com, joshiiitr@gmail.com, anuj20.g@samsung.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Mar 11, 2022 at 12:56 PM Luis Chamberlain <mcgrof@kernel.org> wrote:
>
> On Tue, Mar 08, 2022 at 08:50:53PM +0530, Kanchan Joshi wrote:
> > diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
> > index 5c9cd9695519..1df270b47af5 100644
> > --- a/drivers/nvme/host/ioctl.c
> > +++ b/drivers/nvme/host/ioctl.c
> > @@ -369,6 +469,33 @@ long nvme_ns_chr_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
> >       return __nvme_ioctl(ns, cmd, (void __user *)arg);
> >  }
> >
> > +static int nvme_ns_async_ioctl(struct nvme_ns *ns, struct io_uring_cmd *ioucmd)
> > +{
> > +     int ret;
> > +
> > +     BUILD_BUG_ON(sizeof(struct nvme_uring_cmd_pdu) > sizeof(ioucmd->pdu));
> > +
> > +     switch (ioucmd->cmd_op) {
> > +     case NVME_IOCTL_IO64_CMD:
> > +             ret = nvme_user_cmd64(ns->ctrl, ns, NULL, ioucmd);
> > +             break;
> > +     default:
> > +             ret = -ENOTTY;
> > +     }
> > +
> > +     if (ret >= 0)
> > +             ret = -EIOCBQUEUED;
> > +     return ret;
> > +}
>
> And here I think we'll need something like this:

If we can promise that we will have a LSM hook for all of the
file_operations::async_cmd implementations that are security relevant
we could skip the LSM passthrough hook at the io_uring layer.  It
would potentially make life easier in that we don't have to worry
about putting the passthrough op in the right context, but risks
missing a LSM hook control point (it will happen at some point and
*boom* CVE).

> diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
> index ddb7e5864be6..83529adf130d 100644
> --- a/drivers/nvme/host/ioctl.c
> +++ b/drivers/nvme/host/ioctl.c
> @@ -5,6 +5,7 @@
>   */
>  #include <linux/ptrace.h>      /* for force_successful_syscall_return */
>  #include <linux/nvme_ioctl.h>
> +#include <linux/security.h>
>  #include "nvme.h"
>
>  /*
> @@ -524,6 +525,11 @@ static int nvme_ns_async_ioctl(struct nvme_ns *ns, struct io_uring_cmd *ioucmd)
>
>         BUILD_BUG_ON(sizeof(struct nvme_uring_cmd_pdu) > sizeof(ioucmd->pdu));
>
> +       ret = security_file_ioctl(ioucmd->file, ioucmd->cmd_op,
> +                                 (unsigned long) ioucmd->cmd);
> +       if (ret)
> +               return ret;
> +
>         switch (ioucmd->cmd_op) {
>         case NVME_IOCTL_IO64_CMD:
>                 ret = nvme_user_cmd64(ns->ctrl, ns, NULL, ioucmd);

-- 
paul-moore.com
