Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1F632DBB00
	for <lists+io-uring@lfdr.de>; Wed, 16 Dec 2020 07:06:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725902AbgLPGGd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Dec 2020 01:06:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725274AbgLPGGc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Dec 2020 01:06:32 -0500
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E2E1C0613D6;
        Tue, 15 Dec 2020 22:05:52 -0800 (PST)
Received: by mail-il1-x12d.google.com with SMTP id q5so941703ilc.10;
        Tue, 15 Dec 2020 22:05:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=P6Sg59zP5ptq5x2K8by0U8XXwiQHFOoVbiJ3Fi37iXw=;
        b=S67YoxV9n23ZqrrblS/5Nup+FG7AyOTKzOim1I60JAAfBqrXAiDI1Z2Nbo2UtU/Hl4
         hNB8LNLiBciaj5lQ3EuaLuia4g5D0M+Vu/12VIkGmM2TffzVi7a/Vi+8mit7yduMv90X
         Iqg5INRAAUosZtjf7tC9SKWhZqb1+6jKuhmbcfVoJahp9K+naipFvqzU29HUJNKK20gd
         zGD0IiWx6snzfqN/dN/wVnJDZ7Q5bKCVvPBpnr1VAIkYtdgfhQV0oKmP9tzi8Qa7pPDI
         HlDZJ53G/ZI/cGpbaraS759rnSy1v+RfRryagK2FqelP8EMsmMyY/fwlIbvx1mN7KpB4
         5GVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=P6Sg59zP5ptq5x2K8by0U8XXwiQHFOoVbiJ3Fi37iXw=;
        b=tbdNcEd6/YDPawA0cwtceJUvOwU2PNCM1Ec21WmWLKW9TdinxB+yOj0gCUoGshOBZl
         jPPH0iHuKYgsrcSKo0NoZtgO8pYBQsBM6F1Ayf3BhGvBQT6sJZfuXp+PgJgLwjZ+daJu
         InLxcFoRQpfMLRLdsPuEjB27vWtxIex3SIw5jYwZECqL6p1CJDrb5JcCHxeR2yTzEPZS
         pMW7Gl3TwV64DRAS6/OEMSILugicfvGtj8QfBY0gbX2TaEa0IVp8I7k7J413th6fx3lo
         bYWa4RBnR06g+UrQJiNN6g8npz55DQ4M5IFO9cv8by76hthKKKLfQ8xrmZujom++N5DL
         Jw6A==
X-Gm-Message-State: AOAM530csCZ6zfaIsyYLtsVqvsLYzRKEZAXX3/E/vbogZ+1iFjb42vNY
        7OyhjJLsAzvZk67dsF+Iz24c989rQiwP1TplphQ=
X-Google-Smtp-Source: ABdhPJxkFEjPMeTtp8jY66KaeuBieLp+BWoFhm36itUGcJKrrFpceUCJoG9X2suKji0F8TrrsXuxiHC5hnDdcR6SWC8=
X-Received: by 2002:a92:2912:: with SMTP id l18mr33420710ilg.173.1608098752016;
 Tue, 15 Dec 2020 22:05:52 -0800 (PST)
MIME-Version: 1.0
References: <20201116044529.1028783-1-dkadashev@gmail.com> <X8oWEkb1Cb9ssxnx@carbon.v>
 <CAOKbgA7MdAF1+MQePoZHALxNC5ye207ET=4JCqvdNcrGTcrkpw@mail.gmail.com> <faf1a897-3acf-dd82-474d-dadd9fa9a752@kernel.dk>
In-Reply-To: <faf1a897-3acf-dd82-474d-dadd9fa9a752@kernel.dk>
From:   Dmitry Kadashev <dkadashev@gmail.com>
Date:   Wed, 16 Dec 2020 13:05:41 +0700
Message-ID: <CAOKbgA46PHvVW6h1s6U-kgVt2jdq0t+UXSiy7nn=JTonpXYAPQ@mail.gmail.com>
Subject: Re: [PATCH 0/2] io_uring: add mkdirat support
To:     Jens Axboe <axboe@kernel.dk>
Cc:     viro@zeniv.linux.org.uk, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Dec 15, 2020 at 11:20 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 12/15/20 4:43 AM, Dmitry Kadashev wrote:
> > On Fri, Dec 4, 2020 at 5:57 PM Dmitry Kadashev <dkadashev@gmail.com> wrote:
> >>
> >> On Mon, Nov 16, 2020 at 11:45:27AM +0700, Dmitry Kadashev wrote:
> >>> This adds mkdirat support to io_uring and is heavily based on recently
> >>> added renameat() / unlinkat() support.
> >>>
> >>> The first patch is preparation with no functional changes, makes
> >>> do_mkdirat accept struct filename pointer rather than the user string.
> >>>
> >>> The second one leverages that to implement mkdirat in io_uring.
> >>>
> >>> Based on for-5.11/io_uring.
> >>>
> >>> Dmitry Kadashev (2):
> >>>   fs: make do_mkdirat() take struct filename
> >>>   io_uring: add support for IORING_OP_MKDIRAT
> >>>
> >>>  fs/internal.h                 |  1 +
> >>>  fs/io_uring.c                 | 58 +++++++++++++++++++++++++++++++++++
> >>>  fs/namei.c                    | 20 ++++++++----
> >>>  include/uapi/linux/io_uring.h |  1 +
> >>>  4 files changed, 74 insertions(+), 6 deletions(-)
> >>>
> >>> --
> >>> 2.28.0
> >>>
> >>
> >> Hi Al Viro,
> >>
> >> Ping. Jens mentioned before that this looks fine by him, but you or
> >> someone from fsdevel should approve the namei.c part first.
> >
> > Another ping.
> >
> > Jens, you've mentioned the patch looks good to you, and with quite
> > similar changes (unlinkat, renameat) being sent for 5.11 is there
> > anything that I can do to help this to be accepted (not necessarily
> > for 5.11 at this point)?
>
> Since we're aiming for 5.12 at this point, let's just hold off a bit and
> see if Al gets time to ack/review the VFS side of things. There's no
> immediate rush.

OK, sounds good, thanks.

-- 
Dmitry Kadashev
