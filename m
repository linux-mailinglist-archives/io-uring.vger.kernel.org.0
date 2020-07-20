Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17C1A226F91
	for <lists+io-uring@lfdr.de>; Mon, 20 Jul 2020 22:18:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729044AbgGTURt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 20 Jul 2020 16:17:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727123AbgGTURt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 20 Jul 2020 16:17:49 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CF75C061794;
        Mon, 20 Jul 2020 13:17:49 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id 88so8791109wrh.3;
        Mon, 20 Jul 2020 13:17:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Jzw/8onKma0qauB0WGLcDc9iDqAqJvDHoJWk74V2lfo=;
        b=CHHIdvTfP8EqK9uyRez8Lcjdq5Oe+D6Y7pnyDlXGm1LUZuhlkz0Krw3rk/qbSEC6Am
         ruzsz3YaCd2sHkMTRIF1I5OnVcwnh9XSgvSvFoboW8IKdyCwAgSsp42T/oBex6yLYEZj
         eTO5kvRRfcadyvvtUxlO/Hl6A4zzwWxn8uiQHZbTWtrigambUNXvgKseo+As8PQbpe/o
         Rrpm4tddDCNl5F6gUrvPhXxnyDYgsVr80aEwaPdjZLC0SMnGHf9DsvNaZpKVcGgHH62n
         6LoY6IW7yZa9nh+rePv4N5G2GSWS06nEbicm9GhwgPHFMnu5fSM/9P6mXqFprykqGyH0
         hmsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Jzw/8onKma0qauB0WGLcDc9iDqAqJvDHoJWk74V2lfo=;
        b=AtdBxNgVzp8ootlckDr1a5GtV8nhd40u7CVergJAGPnU/wWctHPn1eGqgGOGyN65d4
         AapS/TLNrzYG12OyxCGeUzAPmPNl/bfrrfNbZU+Tvj/tE6013XomMyyCSlFwZmK9XaU7
         Vjm72hBH+hK8CkBXdW502hdDH4IS7Jdp0dv7flfo+g9k2iLYEf7Ry9oN9s9WpdYYcFf0
         ebCDcm89+c+MKwPP/NFcDwrepHtY1+7rqulG7w1yxqvOfzvDD2TZ7qZXbjiII7XhIjMz
         PVllbyit9pFSQTQCcEAc7ZUSFQS8iUcsl93IA7AIauXpAW6cYoQLfO3FCRgteiGbTrRQ
         GSRw==
X-Gm-Message-State: AOAM530xSfsrBlvry0+G4ESJIxz15rjwYWvKk+I1uSNwqNH9Rda8IU6e
        xWBoipf5LQ0A2MaXTVJWxNOLVYRHCfmZA7DgMj4=
X-Google-Smtp-Source: ABdhPJwPxH7QBtP6wc4HBaQCIWU0o/YJOzNcPKhclaoxZuQg8Gf7VoRYP5hEuqNnOXAm3b1u0V1tXFsd75nMfdMeAAY=
X-Received: by 2002:adf:f0ce:: with SMTP id x14mr22656173wro.137.1595276267720;
 Mon, 20 Jul 2020 13:17:47 -0700 (PDT)
MIME-Version: 1.0
References: <2270907f-670c-5182-f4ec-9756dc645376@kernel.dk>
 <CA+1E3r+H7WEyfTufNz3xBQQynOVV-uD3myYynkfp7iU+D=Svuw@mail.gmail.com>
 <f5e3e931-ef1b-2eb6-9a03-44dd5589c8d3@kernel.dk> <CA+1E3rLna6VVuwMSHVVEFmrgsTyJN=U4CcZtxSGWYr_UYV7AmQ@mail.gmail.com>
 <20200710131054.GB7491@infradead.org> <20200710134824.GK12769@casper.infradead.org>
 <20200710134932.GA16257@infradead.org> <20200710135119.GL12769@casper.infradead.org>
 <CA+1E3rKOZUz7oZ_DGW6xZPQaDu+T5iEKXctd+gsJw05VwpGQSQ@mail.gmail.com>
 <CA+1E3r+j=amkEg-_KUKSiu6gt2TRU6AU-_jwnB1C6wHHKnptfQ@mail.gmail.com> <20200720171416.GY12769@casper.infradead.org>
In-Reply-To: <20200720171416.GY12769@casper.infradead.org>
From:   Kanchan Joshi <joshiiitr@gmail.com>
Date:   Tue, 21 Jul 2020 01:47:20 +0530
Message-ID: <CA+1E3rLNo5sFH3RPFAM4_SYXSmyWTCdbC3k3-6jeaj3FRPYLkQ@mail.gmail.com>
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

On Mon, Jul 20, 2020 at 10:44 PM Matthew Wilcox <willy@infradead.org> wrote:
>
> On Mon, Jul 20, 2020 at 10:19:57PM +0530, Kanchan Joshi wrote:
> > On Fri, Jul 10, 2020 at 7:41 PM Kanchan Joshi <joshiiitr@gmail.com> wrote:
> > > If we are doing this for zone-append (and not general cases), "__s64
> > > res64" should work -.
> > > 64 bits = 1 (sign) + 23 (bytes-copied: cqe->res) + 40
> > > (written-location: chunk_sector bytes limit)
>
> No, don't do this.
>
>  struct io_uring_cqe {
>         __u64   user_data;      /* sqe->data submission passed back */
> -       __s32   res;            /* result code for this event */
> -       __u32   flags;
> +       union {
> +               struct {
> +                       __s32   res;    /* result code for this event */
> +                       __u32   flags;
> +               };
> +               __s64           res64;
> +       };
>  };
>
> Return the value in bytes in res64, or a negative errno.  Done.

I concur. Can do away with bytes-copied. It's either in its entirety
or not at all.
