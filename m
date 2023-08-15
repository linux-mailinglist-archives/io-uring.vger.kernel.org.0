Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19BEC77D6AD
	for <lists+io-uring@lfdr.de>; Wed, 16 Aug 2023 01:34:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240614AbjHOXeN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 15 Aug 2023 19:34:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240621AbjHOXd7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 15 Aug 2023 19:33:59 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 267BB13E
        for <io-uring@vger.kernel.org>; Tue, 15 Aug 2023 16:33:58 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id a640c23a62f3a-99c1c66876aso786891466b.2
        for <io-uring@vger.kernel.org>; Tue, 15 Aug 2023 16:33:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692142436; x=1692747236;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LElZJhpduxEU4sWkxfM25FSwjJTb1QYIyUiD6unT77w=;
        b=Cw6ciT5yRWFFnlG80NSuQLQ9+odQLFxshY152ZCSAUdtA1fGf2JpY4J274xDlsmGU2
         t0XZy8PYHYAgqR8SoSAuRTZ50hmMpobcNaDsK/5xu39ncUlQrnhKXiwPKxzO5jWNKj0h
         Qd5MV/rkq3RyCzT8u18Kf9Adsmu+las7Hxs624oDR2kOuBXjBhIBVon7lqHZPWneTUsq
         iUbFjsBVhaRY9HhSUYLwwL+fydn5gnjKmeHgngWbQZ33hQWmARCuDOmsWL4ECEI5ficT
         cMWj2zhKR8Nrclq+EDNOiKcmJNODuR69koyuu1yEU5lrmFq2f1gGUbmJtGYdjSjJgplq
         WXYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692142436; x=1692747236;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LElZJhpduxEU4sWkxfM25FSwjJTb1QYIyUiD6unT77w=;
        b=MqPwYSlkrzoXntRAzPOmwXmVVyP5C9yumCq01K1zS3GlsnJWSrgJXSaOIhvaW7KK02
         ZcL1ezzWSPnVVgcK/L7lr8K/BUOHbt5XjKloS+iJlVMkztwgJpxd+8TJztNRPt5ED9xO
         tXWTL8U3VJKSmU3drWIk2WSlIUI9GdenNHW6wiJiiQJageFCTE6m0TJc0C+aI7M1PKrz
         7j4ugoKNDo3MR0BDJVmkROLFhVf5PxDcsuQjdVAPqafF/OulzW8k7y8lnaQFsoBgk9m+
         9unjdMNpSSJS6QObCx3baKCUksInLhbIEyqyjJOz1SJ1kM6FxZORoRgrUW7HxzEM159E
         TTXg==
X-Gm-Message-State: AOJu0Yyr0mjls0PASnTGMrWG2UAA6ws2ShxwWrUz4CoJkmh5AHwGhwvh
        uAzV+qDUpQBXCwxJiDOVmrXT9i1E5U2KZQimT20nXg==
X-Google-Smtp-Source: AGHT+IEH2OOpbmLlYO/bY180QT/KSJgeQbAK5EHqLAOJuZGYm9/LkyCpJFHFt3F0wFLVHMdCcDER1YCly9R8Nm3Hr7M=
X-Received: by 2002:a17:906:5910:b0:99d:6b79:6ed1 with SMTP id
 h16-20020a170906591000b0099d6b796ed1mr101047ejq.55.1692142436432; Tue, 15 Aug
 2023 16:33:56 -0700 (PDT)
MIME-Version: 1.0
References: <20230815032645.1393700-1-willy@infradead.org> <20230815032645.1393700-9-willy@infradead.org>
 <ZNvQ4EbQh/aAwK8L@x1n> <ZNvbApJbLanU55Ze@casper.infradead.org>
 <CAJD7tkY=-Mmrbe5_Z8rKA--zUMo83mTyY1frZEFy6C5NFP-y7A@mail.gmail.com> <ZNwDtHqFw1SLDw7m@casper.infradead.org>
In-Reply-To: <ZNwDtHqFw1SLDw7m@casper.infradead.org>
From:   Yosry Ahmed <yosryahmed@google.com>
Date:   Tue, 15 Aug 2023 16:33:19 -0700
Message-ID: <CAJD7tkbcd=goQ5KH9sT+MWz1f=eo=ObxbzjqzxN79Ek+hKAy1A@mail.gmail.com>
Subject: Re: [PATCH 8/9] mm: Rearrange page flags
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Peter Xu <peterx@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Aug 15, 2023 at 4:01=E2=80=AFPM Matthew Wilcox <willy@infradead.org=
> wrote:
>
> On Tue, Aug 15, 2023 at 03:31:42PM -0700, Yosry Ahmed wrote:
> > On Tue, Aug 15, 2023 at 1:07=E2=80=AFPM Matthew Wilcox <willy@infradead=
.org> wrote:
> > >
> > > On Tue, Aug 15, 2023 at 03:24:16PM -0400, Peter Xu wrote:
> > > > On Tue, Aug 15, 2023 at 04:26:44AM +0100, Matthew Wilcox (Oracle) w=
rote:
> > > > > +++ b/include/linux/page-flags.h
> > > > > @@ -99,13 +99,15 @@
> > > > >   */
> > > > >  enum pageflags {
> > > > >     PG_locked,              /* Page is locked. Don't touch. */
> > > > > +   PG_writeback,           /* Page is under writeback */
> > > > >     PG_referenced,
> > > > >     PG_uptodate,
> > > > >     PG_dirty,
> > > > >     PG_lru,
> > > > > +   PG_head,                /* Must be in bit 6 */
> > > >
> > > > Could there be some explanation on "must be in bit 6" here?
> > >
> > > Not on this line, no.  You get 40-50 characters to say something usef=
ul.
> > > Happy to elaborate further in some other comment or in the commit log=
,
> > > but not on this line.
> > >
> > > The idea behind all of this is that _folio_order moves into the botto=
m
> > > byte of _flags_1.  Because the order can never be greater than 63 (an=
d
> > > in practice I think the largest we're going to see is about 30 -- a 1=
6GB
> > > hugetlb page on some architectures), we know that PG_head and PG_wait=
ers
> > > will be clear, so we can write (folio->_flags_1 & 0xff) and the compi=
ler
> > > will just load a byte; it won't actually load the word and mask it.
> > >
> > > We can't move PG_head any lower, or we'll risk having a tail page wit=
h
> > > PG_head set (which can happen with the vmemmmap optimisation, but eug=
h).
> > > And we don't want to move it any higher because then we'll have a fla=
g
> > > that cannot be reused in a tail page.  Bit 6 is the perfect spot for =
it.
> >
> > Is there some compile time assertion that the order cannot overflow int=
o bit 6?
>
> An order-64 folio on a machine with a 4kB page size would be 64
> zettabytes.  I intend to retire before we're managing memory in chunks
> that large.

I should have done the math :)
Never say never though :)
