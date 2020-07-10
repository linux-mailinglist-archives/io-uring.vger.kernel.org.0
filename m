Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A406021B7EC
	for <lists+io-uring@lfdr.de>; Fri, 10 Jul 2020 16:11:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727097AbgGJOLr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Jul 2020 10:11:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726496AbgGJOLr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 10 Jul 2020 10:11:47 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 048F7C08C5CE;
        Fri, 10 Jul 2020 07:11:47 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id o8so6312650wmh.4;
        Fri, 10 Jul 2020 07:11:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VGeeR8+VbNtB7URPLqfeyF8R/0u0wMAauszGUX1N1UI=;
        b=fk0BU7iaq6X8TwybCHTvJwUCTakRRnB6bs6MI80jO2k/15kDhIIIoHZt5ZVGA7a6nv
         hV6Yh9e81iPov/qajATCsYe/c6NeRIcS20LNg52siwqUX6u3VxeNYDkHCaYpXDz3sesR
         3Ulry/Xu+YcNYFGogM36GHBVr/nLyKWwB8yN+B4JOfNdNDvsgl6Xyx9sHtC8js15nxNc
         nklaZ6IT1IayDupdAOiUuueQIAip22AQGlYBr81JJttcMam+vf9cCdSbd7Dr0GbPPo8S
         WuCA8IGNqtAVATytmAJ1Fk+OlPI//tMI5/RRQlUAb47OVCI6/1nGJ7E0n7Scdyv45XhO
         GJUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VGeeR8+VbNtB7URPLqfeyF8R/0u0wMAauszGUX1N1UI=;
        b=abY8ydoh2znbR3wVQPv5/cy10JYdkWgKdo+75Z2CEXQ12HV6M6tB22Zc5gNoGoG6cc
         i2KArNk9Y2xlAb8HNcpFZe6ZyKCWeDfw8WacJpVx5C+P5chbY1TXRx6DAGXdvJDl7mpp
         8ZYnUdhv8ZNpM6f7e5sizuMZeuCaMYLS/aZa4obbEl5oqWoErlRRupzFs24+3uUJbooO
         3G8YwshUZ6GfdFvzCJr9egWuzBxX57S8dQUUN+ZgAhegksfUHoPo7DpWvGldqFoiAVUn
         dOxqsscScMDmG9apCoPtAVP13Dda8giMUiONEYgl7ovpma4lcqbqhlmPpeH160EFXMIr
         qkiQ==
X-Gm-Message-State: AOAM533kd7eKPkaZRLA2DrS+Eqq/y+pkNlMAgPqDZ0YcWsKQK3CRgS/T
        F0SSyQVIxsMI9zoANrcL+MGLBC7lox5CBwCZoeM=
X-Google-Smtp-Source: ABdhPJysoJRlQ8UFaxjIgEOwBzA5N40n6EBPhXu9a+0n6/TXYajVrD/1a1tH7ji3ATsg3D0/tZUikVlkV5IOILYSjyk=
X-Received: by 2002:a1c:9e45:: with SMTP id h66mr5276012wme.15.1594390305664;
 Fri, 10 Jul 2020 07:11:45 -0700 (PDT)
MIME-Version: 1.0
References: <20200709085501.GA64935@infradead.org> <adc14700-8e95-10b2-d914-afa5029ae80c@kernel.dk>
 <20200709140053.GA7528@infradead.org> <2270907f-670c-5182-f4ec-9756dc645376@kernel.dk>
 <CA+1E3r+H7WEyfTufNz3xBQQynOVV-uD3myYynkfp7iU+D=Svuw@mail.gmail.com>
 <f5e3e931-ef1b-2eb6-9a03-44dd5589c8d3@kernel.dk> <CA+1E3rLna6VVuwMSHVVEFmrgsTyJN=U4CcZtxSGWYr_UYV7AmQ@mail.gmail.com>
 <20200710131054.GB7491@infradead.org> <20200710134824.GK12769@casper.infradead.org>
 <20200710134932.GA16257@infradead.org> <20200710135119.GL12769@casper.infradead.org>
In-Reply-To: <20200710135119.GL12769@casper.infradead.org>
From:   Kanchan Joshi <joshiiitr@gmail.com>
Date:   Fri, 10 Jul 2020 19:41:19 +0530
Message-ID: <CA+1E3rKOZUz7oZ_DGW6xZPQaDu+T5iEKXctd+gsJw05VwpGQSQ@mail.gmail.com>
Subject: Re: [PATCH v3 4/4] io_uring: add support for zone-append
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Jens Axboe <axboe@kernel.dk>,
        Kanchan Joshi <joshi.k@samsung.com>, viro@zeniv.linux.org.uk,
        bcrl@kvack.org, Damien.LeMoal@wdc.com, asml.silence@gmail.com,
        linux-fsdevel@vger.kernel.org, "Matias Bj??rling" <mb@lightnvm.io>,
        linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        Selvakumar S <selvakuma.s1@samsung.com>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Jul 10, 2020 at 7:21 PM Matthew Wilcox <willy@infradead.org> wrote:
>
> On Fri, Jul 10, 2020 at 02:49:32PM +0100, Christoph Hellwig wrote:
> > On Fri, Jul 10, 2020 at 02:48:24PM +0100, Matthew Wilcox wrote:
> > > If we're going to go the route of changing the CQE, how about:
> > >
> > >  struct io_uring_cqe {
> > >          __u64   user_data;      /* sqe->data submission passed back */
> > > -        __s32   res;            /* result code for this event */
> > > -        __u32   flags;
> > > +   union {
> > > +           struct {
> > > +                   __s32   res;            /* result code for this event */
> > > +                   __u32   flags;
> > > +           };
> > > +           __s64   res64;
> > > +   };
> > >  };
> > >
> > > then we don't need to change the CQE size and it just depends on the SQE
> > > whether the CQE for it uses res+flags or res64.
> >
> > How do you return a status code or short write when you just have
> > a u64 that is needed for the offset?
>
> it's an s64 not a u64 so you can return a negative errno.  i didn't
> think we allowed short writes for objects-which-have-a-pos.

If we are doing this for zone-append (and not general cases), "__s64
res64" should work -.
64 bits = 1 (sign) + 23 (bytes-copied: cqe->res) + 40
(written-location: chunk_sector bytes limit)

-- 
Joshi
