Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C2A670FCE9
	for <lists+io-uring@lfdr.de>; Wed, 24 May 2023 19:45:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234734AbjEXRpF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 24 May 2023 13:45:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235342AbjEXRpE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 24 May 2023 13:45:04 -0400
Received: from mail-oo1-xc2f.google.com (mail-oo1-xc2f.google.com [IPv6:2607:f8b0:4864:20::c2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 202E91B5
        for <io-uring@vger.kernel.org>; Wed, 24 May 2023 10:44:23 -0700 (PDT)
Received: by mail-oo1-xc2f.google.com with SMTP id 006d021491bc7-54f92ee633bso679306eaf.0
        for <io-uring@vger.kernel.org>; Wed, 24 May 2023 10:44:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1684950262; x=1687542262;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x4dZEXSdTO8+ISYl2uCjt8z0fDkvLzr8sNFCsQ3aoOo=;
        b=jfPtLyt5BRmYDduuwHqe1ay0vpPJ86otXsWhQE4mCR4RZelpspEDYd7L1oxEz2pNZn
         T+Cg3tIUhwYY8EofqCdmq2ZnRRfx1OVSHPcitsfohewPYNoiQmb7Uq4+ApJsk7UJKJYc
         sA5od3UsgreNpSb/qzS+4FXEgIvViRHseCXP4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684950262; x=1687542262;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=x4dZEXSdTO8+ISYl2uCjt8z0fDkvLzr8sNFCsQ3aoOo=;
        b=VPVwJ3u3LJEc4xzS6KSNwsovswU54um0JqTMlj5YTpgRJCgShTnuz8xJOrV0zGpHJv
         5Y6KQXrbHQ5BY/WKXrT7elJtyzgbesUBuOMEHXCUphtUuNih9R+wJ8hFZsyoYWL54kwQ
         FGIxxQKAs8rJrgO55e1ZY+pJia70ZksSacwXztGGxpmpP8NXCi3ekdYoVSmojb6LTCVG
         BfqLu6xB5jxBpV95TU9nDQpjHsrD/tzyxqqL+r6rpzlyQ5W5bAAEUxYOOI++6nXa1dtp
         X0MNH4UXgd1mOJ5yTgzvxY8hGjuSjVnaAG2erCYSgKBQBZYGBoJiqDA4D0qlR+N7GTqb
         bR9A==
X-Gm-Message-State: AC+VfDwl1FIY1hnrl/dtj+c7/s/zRkEOB3cw1cRFv8yfBuxtkRZ88Vj1
        ztrX1nn0/np5rlvvnIFVk6jz9EtUiq2CTb0Qt3K+ewG8UjRGCmEJtp0=
X-Google-Smtp-Source: ACHHUZ7I4NMhGlKykSrKWNYHjtfo0l+XJZtUJhF8RoGdxCwtJat3LD2mISz2YOZr+W3iaIIS6J3HQG/agGdIWs9KssI=
X-Received: by 2002:a4a:3c4a:0:b0:552:4bca:a9dc with SMTP id
 p10-20020a4a3c4a000000b005524bcaa9dcmr8566083oof.1.1684950262054; Wed, 24 May
 2023 10:44:22 -0700 (PDT)
MIME-Version: 1.0
References: <CABi2SkUp45HEt7eQ6a47Z7b3LzW=4m3xAakG35os7puCO2dkng@mail.gmail.com>
 <d8af0d2b-127c-03ef-0fe6-36a633fb8b49@kernel.dk>
In-Reply-To: <d8af0d2b-127c-03ef-0fe6-36a633fb8b49@kernel.dk>
From:   Jeff Xu <jeffxu@chromium.org>
Date:   Wed, 24 May 2023 10:44:11 -0700
Message-ID: <CABi2SkXyMcYEKSwtg7Acg7_j6WCYFmrOeJOLrKTMXCm4FL2fcQ@mail.gmail.com>
Subject: Re: Protection key in io uring kthread
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Jens,
Thanks for responding.

On Wed, May 24, 2023 at 8:06=E2=80=AFAM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 5/23/23 8:48?PM, Jeff Xu wrote:
> > Hi
> > I have a question on the protection key in io_uring. Today, when a
> > user thread enters the kernel through syscall, PKRU is preserved, and
> > the kernel  will respect the PKEY protection of memory.
> >
> > For example:
> > sys_mprotect_pkey((void *)ptr, size, PROT_READ | PROT_WRITE, pkey);
> > pkey_write_deny(pkey); <-- disable write access to pkey for this thread=
.
> > ret =3D read(fd, ptr, 1); <-- this will fail in the kernel.
> >
> > I wonder what is the case for io_uring, since read is now async, will
> > kthread have the user thread's PKUR ?
>
> There is no kthread. What can happen is that some operation may be
> punted to the io-wq workers, but these act exactly like a thread created
> by the original task. IOW, if normal threads retain the protection key,
> so will any io-wq io_uring thread. If they don't, they do not.
>
Does this also apply to when the IORING_SETUP_SQPOLL [1] flag is used
? it mentions a kernel thread is created to perform submission queue
polling.

[1] https://manpages.debian.org/unstable/liburing-dev/io_uring_setup.2.en.h=
tml#IORING_SETUP_SQPOLL

> > In theory, it is possible, i.e. from io_uring_enter syscall. But I
> > don't know the implementation details of io_uring, hence asking the
> > expert in this list.
>
> Right, if the IO is done inline, then it won't make a difference if eg
> read(2) is used or IORING_OP_READ (or similar) with io_uring.
>
Can you please clarify what "IO is done inline" means ? i.e. are there
cases that are not inline ?

Thanks!
-Jeff

> --
> Jens Axboe
>
