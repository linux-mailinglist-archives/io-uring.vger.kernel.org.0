Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAC292E236E
	for <lists+io-uring@lfdr.de>; Thu, 24 Dec 2020 02:40:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727282AbgLXBjV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Dec 2020 20:39:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727057AbgLXBjU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Dec 2020 20:39:20 -0500
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99B6EC061794;
        Wed, 23 Dec 2020 17:38:40 -0800 (PST)
Received: by mail-qt1-x832.google.com with SMTP id c14so722516qtn.0;
        Wed, 23 Dec 2020 17:38:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=4vnkUc3HmN35Oa7RstxVicTeVMJaPv8+xQ6Dlfwsdr4=;
        b=CH7HcDBCXBsxGzoovkps8HGa6Bq9BCVjlCXDh7jg1ThLsHI22KCa7Zt+kiFIHfBPD8
         MOEuBGp4jFAb2OfGHtJaw2tNZKevBUP0LRM4FPQHq/MuRp0lpZObpdsBnjxj1YY+3cR9
         1sUw6jJOjUIZQA7NH1MMrj/ApO6HRb6ZHpfRgjPdTDOCLO/7+9vDATvJFE7PCQMNAL7n
         4NSA1JkYyd5NJ5jQC4cc1TRX/ofcG7r2z9d//knB5DH5gzqTtJf+EldpVQw+oSyb79Dh
         iz23GdD8v/8lBJvAxkCLiu22idQxcq7W/cxvylTgc2HGExjHke1bNXb26ysxmehLT5+C
         tqIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=4vnkUc3HmN35Oa7RstxVicTeVMJaPv8+xQ6Dlfwsdr4=;
        b=W8EHX45L3RjAZP/XSLY6nTGQ7lRQQAdimgnT+qC+Sqfi9JZfVu5OhD9OTegCm5Uh9+
         fhv5aT+XaFUEfmMV1r79Odr2VJqIgABdV3vnABLyB7XlKyLGMwH3VzaTClQw3FCKlErX
         WojEytcKxnzGqumB4m9EGQklMPWUTOvInmPrRRxmX4PNdcTVpf8Hj2ZSfB/bRh/AOyfm
         9pPewXz1vS1+GZx/hrxDag+Zd63sl82DWduC29XC5Pew8Fgu2nwGqafb4DX8RILL6rP8
         t/ywyWix9v+Cjvt6NwjUyDa53El1KxeKmOGqByv1iuYJRDgVecqbzC09snfKoAUjxIGC
         RWjQ==
X-Gm-Message-State: AOAM5329xHruJG5uI8qUzVcbxwOwCILZE9lVhfwW9/KYORfROweiTZ62
        znXRbg9g1S+aseRjEz1adpYsE+ox73NXF9JQFsk=
X-Google-Smtp-Source: ABdhPJzCQ78+XVyv+ltmIInuA6BPrsxX9lDnuwthwioCVBR05xRu1Jc3Df1mDouqoYg1tl5nZNKZnZfYAhP7NmBKKlM=
X-Received: by 2002:ac8:4c99:: with SMTP id j25mr28070469qtv.390.1608773919781;
 Wed, 23 Dec 2020 17:38:39 -0800 (PST)
MIME-Version: 1.0
References: <1608694025-121050-1-git-send-email-yejune.deng@gmail.com>
 <20201223103623.mxjsmitdmqsx6ftd@steredhat> <3c013151-37de-1ef0-e989-9f871665d650@gmail.com>
In-Reply-To: <3c013151-37de-1ef0-e989-9f871665d650@gmail.com>
From:   Yejune Deng <yejune.deng@gmail.com>
Date:   Thu, 24 Dec 2020 09:38:26 +0800
Message-ID: <CABWKuGXfBxeQv7HpVz9J97x0deoSNxUaVRxCToX0C_FTSs=1QQ@mail.gmail.com>
Subject: Re: [PATCH] io_uring: remove io_remove_personalities()
To:     Pavel Begunkov <asml.silence@gmail.com>, sgarzare@redhat.com
Cc:     viro@zeniv.linux.org.uk, axboe@kernel.dk,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

OK=EF=BC=8CI will adopt it and resubmit.

On Wed, Dec 23, 2020 at 8:45 PM Pavel Begunkov <asml.silence@gmail.com> wro=
te:
>
> On 23/12/2020 10:36, Stefano Garzarella wrote:
> > On Wed, Dec 23, 2020 at 11:27:05AM +0800, Yejune Deng wrote:
> >> The function io_remove_personalities() is very similar to
> >> io_unregister_personality(),but the latter has a more reasonable
> >> return value.
> >>
> >> Signed-off-by: Yejune Deng <yejune.deng@gmail.com>
> >> ---
> >> fs/io_uring.c | 25 ++++++-------------------
> >> 1 file changed, 6 insertions(+), 19 deletions(-)
> >
> > The patch LGTM, maybe as an alternative you can leave io_remove_persona=
lity() with the interface needed by idr_for_each() and implement io_unregis=
ter_personality() calling io_remove_personality() with the right parameters=
.
>
> Right, don't replace sane types with void * just because.
> Leave well-typed io_unregister_personality() and call it from
> io_remove_personalities().
>
>
> Also
>  * idr_for_each() - Iterate through all stored pointers.
>  ...
>  * If @fn returns anything other than %0, the iteration stops and that
>  * value is returned from this function.
>
> For io_remove_personality() iod=3D=3DNULL should not happen because
> it's under for_each and synchronised, but leave the return value be
>
> io_remove_personality(void *, ...)
> {
>         struct io_ring_ctx *ctx =3D data;
>
>         io_unregister_personality(ctx, id);
>         return 0;
> }
>
> --
> Pavel Begunkov
