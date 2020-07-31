Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35A90234831
	for <lists+io-uring@lfdr.de>; Fri, 31 Jul 2020 17:08:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728968AbgGaPIE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 31 Jul 2020 11:08:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728697AbgGaPIE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 31 Jul 2020 11:08:04 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF326C061574;
        Fri, 31 Jul 2020 08:08:03 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id z18so24745934wrm.12;
        Fri, 31 Jul 2020 08:08:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=85y9XZIAhdFrSxuJrcnrzsatwqiXZnaeoI8u9MGBgtM=;
        b=fFFPMMK7xEeboEuM9TpGf+G/ZYPfTaKG5i5Ejhza78kDiyr3MIdoNI5Ufz4P4NysJO
         dZTF7XL8KamTxce/IZmn4sFOHHJVnO8YsNWsCkyQ532iHs1alDBhwO1zuDQnl9YUCygD
         uSf3UF9/7insMKOSTynpcef+WwYjqbLO9442pOMHg+jWcnjTXPEOmmeIUZngmzMCcR/d
         og0U0K5miCxuVk1ovO6NF3mhVtGchiWnyvzVLM/SICzzSnt5rTCxrrDll4VMtl9GuiQl
         iliRGORh32YdOJH2IzKFVyN9MKQMhH4aacClAj9sYru6PPRv+xs6aCLdcfmGgxbfdZjv
         MuQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=85y9XZIAhdFrSxuJrcnrzsatwqiXZnaeoI8u9MGBgtM=;
        b=r/Hea3E0oix0fWMJZl+wVnhM7jRk/JYjdpJN7SbsDyYhzqaTwZqddzHHaNDEpSxkGt
         qDETXvJPysNhCiE0ec18XYnx98g3KAD5mCJxsb9iGTT8vyXg6PxSROd6p5fHaJbU9yVf
         02nWcDSoLKuXV6Wh2md5kV2CpC2EPqGEKcp+AVIooQLR9pwDBzKLCK+Vqq7E1xQx73wx
         7uzCUmcrdjgHzP/34hNVpKhGqwt5cVThhkXsePWMgHTAfQfH3lC8zvie1R+kMkTW8Too
         23MFe0MDNvb3IEgY91cNUrvDhA5Q2wBlZd2Cgw5tJZAvPqw4kqyF/J4dCpc0ZXhaaHhG
         ezXA==
X-Gm-Message-State: AOAM531EXZEwZEGR0dCamI0ptG1c0cFrDUsbglyQMh6BlxMTRAxSJnvM
        IycLKrI0gxmYMOscp8bkwO5CzbD8t45fgEEiJqA=
X-Google-Smtp-Source: ABdhPJzxaoTSidV3fwT9KU1KuP5Nfoicm9e8ljT1UwmUKcsEKIGiIUz4tXNjnKaseFpyXNKlAauBimsG/8bxFAtElAM=
X-Received: by 2002:a5d:4a0b:: with SMTP id m11mr3804806wrq.407.1596208082356;
 Fri, 31 Jul 2020 08:08:02 -0700 (PDT)
MIME-Version: 1.0
References: <MWHPR04MB3758DC08EA17780E498E9EC0E74E0@MWHPR04MB3758.namprd04.prod.outlook.com>
 <20200731064526.GA25674@infradead.org> <MWHPR04MB37581344328A42EA7F5ED13EE74E0@MWHPR04MB3758.namprd04.prod.outlook.com>
 <CA+1E3rLM4G4SwzD6RWsK6Ssp7NmhiPedZDjrqN3kORQr9fxCtw@mail.gmail.com>
 <MWHPR04MB375863C20C1EF2CB27E62703E74E0@MWHPR04MB3758.namprd04.prod.outlook.com>
 <20200731091416.GA29634@infradead.org> <MWHPR04MB37586D39CA389296CE0252A4E74E0@MWHPR04MB3758.namprd04.prod.outlook.com>
 <20200731094135.GA4104@infradead.org> <MWHPR04MB3758A4B2967DB1FABAAD9265E74E0@MWHPR04MB3758.namprd04.prod.outlook.com>
 <20200731125110.GA11500@infradead.org> <20200731130802.GA16665@infradead.org>
In-Reply-To: <20200731130802.GA16665@infradead.org>
From:   Kanchan Joshi <joshiiitr@gmail.com>
Date:   Fri, 31 Jul 2020 20:37:35 +0530
Message-ID: <CA+1E3r+7ZChHK+ZH06LitijEbZ0=UhOtAzLpw4SWVY1ZN4HOSw@mail.gmail.com>
Subject: Re: [PATCH v4 6/6] io_uring: add support for zone-append
To:     "hch@infradead.org" <hch@infradead.org>
Cc:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Kanchan Joshi <joshi.k@samsung.com>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "bcrl@kvack.org" <bcrl@kvack.org>,
        Matthew Wilcox <willy@infradead.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-aio@kvack.org" <linux-aio@kvack.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        SelvaKumar S <selvakuma.s1@samsung.com>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>,
        Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        Naohiro Aota <Naohiro.Aota@wdc.com>
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Jul 31, 2020 at 6:38 PM hch@infradead.org <hch@infradead.org> wrote:
>
> And FYI, this is what I'd do for a hacky aio-only prototype (untested):
>
>
> diff --git a/fs/aio.c b/fs/aio.c
> index 91e7cc4a9f179b..42b1934e38758b 100644
> --- a/fs/aio.c
> +++ b/fs/aio.c
> @@ -1438,7 +1438,10 @@ static void aio_complete_rw(struct kiocb *kiocb, long res, long res2)
>         }
>
>         iocb->ki_res.res = res;
> -       iocb->ki_res.res2 = res2;
> +       if ((kiocb->ki_flags & IOCB_REPORT_OFFSET) && res > 0)
> +               iocb->ki_res.res2 = kiocb->ki_pos - res;
> +       else
> +               iocb->ki_res.res2 = res2;
>         iocb_put(iocb);
>  }
>
> @@ -1452,6 +1455,8 @@ static int aio_prep_rw(struct kiocb *req, const struct iocb *iocb)
>         req->ki_flags = iocb_flags(req->ki_filp);
>         if (iocb->aio_flags & IOCB_FLAG_RESFD)
>                 req->ki_flags |= IOCB_EVENTFD;
> +       if (iocb->aio_flags & IOCB_FLAG_REPORT_OFFSET)
> +               req->ki_flags |= IOCB_REPORT_OFFSET;
>         req->ki_hint = ki_hint_validate(file_write_hint(req->ki_filp));
>         if (iocb->aio_flags & IOCB_FLAG_IOPRIO) {
>                 /*
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index f5abba86107d86..522b0a3437d420 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -316,6 +316,7 @@ enum rw_hint {
>  #define IOCB_WRITE             (1 << 6)
>  #define IOCB_NOWAIT            (1 << 7)
>  #define IOCB_NOIO              (1 << 9)
> +#define IOCB_REPORT_OFFSET     (1 << 10)
>
>  struct kiocb {
>         struct file             *ki_filp;
> diff --git a/include/uapi/linux/aio_abi.h b/include/uapi/linux/aio_abi.h
> index 8387e0af0f768a..e4313d7aa3b7e7 100644
> --- a/include/uapi/linux/aio_abi.h
> +++ b/include/uapi/linux/aio_abi.h
> @@ -55,6 +55,7 @@ enum {
>   */
>  #define IOCB_FLAG_RESFD                (1 << 0)
>  #define IOCB_FLAG_IOPRIO       (1 << 1)
> +#define IOCB_FLAG_REPORT_OFFSET        (1 << 2)
>
>  /* read() from /dev/aio returns these structures. */
>  struct io_event {

Looks good, but it drops io_uring.
How about two flags -
1. RWF_REPORT_OFFSET (only for aio)  ----> aio fails the second one
2. RWF_REPORT_OFFSET_INDIRECT (for io_uring).  ----> uring fails the first one
Since these are RWF flags, they can be used by other sync/async
transports also in future if need be.
Either of these flags will set single IOCB_REPORT_OFFSET, which can be
used by FS/Block etc (they don't have to worry how uring/aio sends it
up).

This is what I mean in code -

diff --git a/fs/aio.c b/fs/aio.c
index 91e7cc4a9f17..307dfbfb04f7 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1472,6 +1472,11 @@ static int aio_prep_rw(struct kiocb *req, const
struct iocb *iocb)
        ret = kiocb_set_rw_flags(req, iocb->aio_rw_flags);
        if (unlikely(ret))
                return ret;
+       /* support only direct offset */
+       if (unlikely(iocb->aio_rw_flags & RWF_REPORT_OFFSET_INDIRECT))
+               return -EOPNOTSUPP;
+
        req->ki_flags &= ~IOCB_HIPRI; /* no one is going to poll for this I/O */
        return 0;
diff --git a/fs/io_uring.c b/fs/io_uring.c
index 3e406bc1f855..5fa21644251f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2451,6 +2451,7 @@ static int io_prep_rw(struct io_kiocb *req,
const struct io_uring_sqe *sqe,
        struct kiocb *kiocb = &req->rw.kiocb;
        unsigned ioprio;
        int ret;
+       rwf_t rw_flags;

        if (S_ISREG(file_inode(req->file)->i_mode))
                req->flags |= REQ_F_ISREG;
@@ -2462,9 +2463,13 @@ static int io_prep_rw(struct io_kiocb *req,
const struct io_uring_sqe *sqe,
        }
        kiocb->ki_hint = ki_hint_validate(file_write_hint(kiocb->ki_filp));
        kiocb->ki_flags = iocb_flags(kiocb->ki_filp);
-       ret = kiocb_set_rw_flags(kiocb, READ_ONCE(sqe->rw_flags));
+       rw_flags = READ_ONCE(sqe->rw_flags);
+       ret = kiocb_set_rw_flags(kiocb, rw_flags);
        if (unlikely(ret))
                return ret;
+       /* support only indirect offset */
+       if (unlikely(rw_flags & RWF_REPORT_OFFSET_DIRECT))
+               return -EOPNOTSUPP;

        ioprio = READ_ONCE(sqe->ioprio);
        if (ioprio) {
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 8a00ba99284e..fe2f1f5c5d33 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3296,8 +3296,17 @@ static inline int kiocb_set_rw_flags(struct
kiocb *ki, rwf_t flags)
                ki->ki_flags |= IOCB_DSYNC;
        if (flags & RWF_SYNC)
                ki->ki_flags |= (IOCB_DSYNC | IOCB_SYNC);
-       if (flags & RWF_APPEND)
+       if (flags & RWF_APPEND) {
                ki->ki_flags |= IOCB_APPEND;
+               /*
+                * 1. These flags do not make sense when used standalone
+                * 2. RWF_REPORT_OFFSET_DIRECT = report result
directly (for aio)
+                * 3. RWF_REPORT_INDIRECT_OFFSER = use pointer (for io_uring)
+                * */
+               if (flags & RWF_REPORT_OFFSET_DIRECT ||
+                               flags & RWF_REPORT_OFFSET_INDIRECT)
+                       ki->ki_flags |= IOCB_REPORT_OFFSET;
