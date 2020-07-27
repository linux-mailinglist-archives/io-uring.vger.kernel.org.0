Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F70222F8C9
	for <lists+io-uring@lfdr.de>; Mon, 27 Jul 2020 21:17:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728538AbgG0TQ5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Jul 2020 15:16:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728049AbgG0TQ5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Jul 2020 15:16:57 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A13CAC061794;
        Mon, 27 Jul 2020 12:16:56 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id t142so9483728wmt.4;
        Mon, 27 Jul 2020 12:16:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Fmgy8aOrOaosUqw8qw2R0Byip/Q6rVp5BO1Fak+JZ30=;
        b=Ciph4lQ202oxMhxwuDhqC+FaifmbEaM4ku6yFaGBlpMsJ/TBl2hquhabMSj3Ctc68y
         71l5lAisoevj4vjsC3D4Xvz2XPMwRkq0hk+wpcUH15DSQbUpBhvD5QR+D0A7VC75dOs8
         8ZmcuCXrRtXD3nxfdQ1zhCaMFqf7ejIIzp+tNmrd8TvjijIU35BHnQSaNcfx1E+HFXRz
         7nv5RpdBVUuJX/j1WYJ5iaVimObT+9TyGtFbpPbbRE01qD9FZcIkATukdYSXoBVxYhSw
         6sC+q5osarJDE00mlIiAvfMDyM28rLwIV7WK7WG1TEBQFNjLeHl+ITPIVRJBL1pHJPbY
         UwzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Fmgy8aOrOaosUqw8qw2R0Byip/Q6rVp5BO1Fak+JZ30=;
        b=M6ooYpysUgY/E/J/mTDvsBHauO1hberhbKDpACsaMEAodpo3CFpiBlhqKlHXl5dMJq
         g0aGRFL83egBjKPwQqLFnM9jS9qg+d4nioDgyYIi9bun33lmd24WLqxG344UAAM9ZEwg
         m/W0A0l9vBAGIhfIrCRTATkg4YZq7DW6nKC5KdAUBKJZp95DnpY03Kk4AFNRPDk2djwl
         vOTqkFW2qviMcAcnH3UFSB8b+GZlepKb4whFHt5t3CKEWnmWrAGkp8n5USFnH9RUYU9x
         NNWf4CV29tmVAxzSX1Kjtj1oXVKE4m/dvtAl628+qqGpppaHJftgIDiyYmcJ1klXFjhZ
         oKQg==
X-Gm-Message-State: AOAM532L06FFEhbk0LQ0UJge0eWqiafHiSixM7V4kbuqK2+p2H39Poip
        8ciaJWUMa1PyLPbBzzQEJPGI49k1Ajw4pmiSK1U=
X-Google-Smtp-Source: ABdhPJz5ci8PtopFnwl2wC3FFEjn8xB7o/gSCRHwfaULk/Ae+T/JB/W5PEyS1njIUPBTOUz96mZD/TBgW6vKMjQ0LSY=
X-Received: by 2002:a7b:c841:: with SMTP id c1mr679956wml.25.1595877415006;
 Mon, 27 Jul 2020 12:16:55 -0700 (PDT)
MIME-Version: 1.0
References: <1595605762-17010-1-git-send-email-joshi.k@samsung.com>
 <CGME20200724155350epcas5p3b8f1d59eda7f8fbb38c828f692d42fd6@epcas5p3.samsung.com>
 <1595605762-17010-7-git-send-email-joshi.k@samsung.com> <f5416bd4-93b3-4d14-3266-bdbc4ae1990b@kernel.dk>
In-Reply-To: <f5416bd4-93b3-4d14-3266-bdbc4ae1990b@kernel.dk>
From:   Kanchan Joshi <joshiiitr@gmail.com>
Date:   Tue, 28 Jul 2020 00:46:28 +0530
Message-ID: <CA+1E3rJAa3E2Ti0fvvQTzARP797qge619m4aYLjXeR3wxdFwWw@mail.gmail.com>
Subject: Re: [PATCH v4 6/6] io_uring: add support for zone-append
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Kanchan Joshi <joshi.k@samsung.com>, viro@zeniv.linux.org.uk,
        bcrl@kvack.org, Matthew Wilcox <willy@infradead.org>,
        Christoph Hellwig <hch@infradead.org>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        asml.silence@gmail.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        linux-api@vger.kernel.org, SelvaKumar S <selvakuma.s1@samsung.com>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Jul 24, 2020 at 10:00 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 7/24/20 9:49 AM, Kanchan Joshi wrote:
> > diff --git a/fs/io_uring.c b/fs/io_uring.c
> > index 7809ab2..6510cf5 100644
> > --- a/fs/io_uring.c
> > +++ b/fs/io_uring.c
> > @@ -1284,8 +1301,15 @@ static void __io_cqring_fill_event(struct io_kiocb *req, long res, long cflags)
> >       cqe = io_get_cqring(ctx);
> >       if (likely(cqe)) {
> >               WRITE_ONCE(cqe->user_data, req->user_data);
> > -             WRITE_ONCE(cqe->res, res);
> > -             WRITE_ONCE(cqe->flags, cflags);
> > +             if (unlikely(req->flags & REQ_F_ZONE_APPEND)) {
> > +                     if (likely(res > 0))
> > +                             WRITE_ONCE(cqe->res64, req->rw.append_offset);
> > +                     else
> > +                             WRITE_ONCE(cqe->res64, res);
> > +             } else {
> > +                     WRITE_ONCE(cqe->res, res);
> > +                     WRITE_ONCE(cqe->flags, cflags);
> > +             }
>
> This would be nice to keep out of the fast path, if possible.

I was thinking of keeping a function-pointer (in io_kiocb) during
submission. That would have avoided this check......but argument count
differs, so it did not add up.

> > diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> > index 92c2269..2580d93 100644
> > --- a/include/uapi/linux/io_uring.h
> > +++ b/include/uapi/linux/io_uring.h
> > @@ -156,8 +156,13 @@ enum {
> >   */
> >  struct io_uring_cqe {
> >       __u64   user_data;      /* sqe->data submission passed back */
> > -     __s32   res;            /* result code for this event */
> > -     __u32   flags;
> > +     union {
> > +             struct {
> > +                     __s32   res;    /* result code for this event */
> > +                     __u32   flags;
> > +             };
> > +             __s64   res64;  /* appending offset for zone append */
> > +     };
> >  };
>
> Is this a compatible change, both for now but also going forward? You
> could randomly have IORING_CQE_F_BUFFER set, or any other future flags.

Sorry, I didn't quite understand the concern. CQE_F_BUFFER is not
used/set for write currently, so it looked compatible at this point.
Yes, no room for future flags for this operation.
Do you see any other way to enable this support in io-uring?

> Layout would also be different between big and little endian, so not
> even that easy to set aside a flag for this. But even if that was done,
> we'd still have this weird API where liburing or the app would need to
> distinguish this cqe from all others based on... the user_data? Hence
> liburing can't do it, only the app would be able to.
>
> Just seems like a hack to me.

Yes, only user_data to distinguish. Do liburing helpers need to look
at cqe->res (and decide something) before returning the cqe to
application?
I see that happening at once place, but not sure when it would hit
LIBURING_DATA_TIMEOUT condition.
__io_uring_peek_cqe()
{
           do {
                io_uring_for_each_cqe(ring, head, cqe)
                        break;
                if (cqe) {
                        if (cqe->user_data == LIBURING_UDATA_TIMEOUT) {
                                if (cqe->res < 0)
                                        err = cqe->res;
                                io_uring_cq_advance(ring, 1);
                                if (!err)
                                        continue;
                                cqe = NULL;
                        }
                }
                break;
        } while (1);
}



-- 
Joshi
