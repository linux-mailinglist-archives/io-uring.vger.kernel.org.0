Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B816877D629
	for <lists+io-uring@lfdr.de>; Wed, 16 Aug 2023 00:33:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239912AbjHOWdB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 15 Aug 2023 18:33:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240440AbjHOWcc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 15 Aug 2023 18:32:32 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C3791FFE
        for <io-uring@vger.kernel.org>; Tue, 15 Aug 2023 15:32:20 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id ffacd0b85a97d-3197f632449so1665070f8f.1
        for <io-uring@vger.kernel.org>; Tue, 15 Aug 2023 15:32:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692138739; x=1692743539;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=clD27qRrlZWSnkEP+mWZLIV4ZuO805zRtXZ8s1yCw9A=;
        b=dCOCdw2qRsZHx0XuPr3uc7CNFSLrL5tSDrnLcrkUD8pX0SFxNswjtoiYf6MrWj02uK
         s7kgyvhtsRVG6/AheVyq4oDbWvn68aiV3qqm2AeDazAICqnSQTIIG5dZHLRjeECUzmbA
         qWOGOoKw5qSn207tf0wbfMQiYPJkqUgl2nL+fvaOSG+5i5RABUY92z7qYbhoXZ7pJXVL
         EHXI2Z7QgZtLGupMPGx+dOX1OJMtKZhX1pDqfjlcQYsTA7jzam3HxYfqAygW7DFXdI2r
         zc2bBqM8BXxrYNpI4k+RtE5mb1nsl5gmxH2F2RyruFJlLdTeqq2acrR0pwABlk/kfAKh
         Tbhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692138739; x=1692743539;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=clD27qRrlZWSnkEP+mWZLIV4ZuO805zRtXZ8s1yCw9A=;
        b=d8sG9CQn0dj9sBclrRns8/IvOCovRL0fILdCeYb1bZlskaqEEPqSAu6w1D6KISGqDy
         jgNZeSEbuANl46AKnC67XvfOmxDpqbkSeZwbIL2ojM/o64iGaHTiLy6bXACDYkMI9Zmp
         62XICG+RZ12NXcYvvT59lforHL1fHjAAkxZarMvVrkL8lX+HFevVYoBKEa7ZNNsLXYqt
         44hQpuU195KsyEoGpOhdSVnOknqwxSIgQFcHxwnsDMZJj/YPNsnxwlPaWi+qPJJuwqSe
         AbgahrHyCNOYvgFa2P1J6npA0fb6u3v3CVg4CboF+l8ku9Ymz6w6vUnGzUTwG8tC0Ut1
         DkCA==
X-Gm-Message-State: AOJu0YzhM2wdZE85xIGc9P68fRxcbMmPyLPvJs5jYPITZyskZopted92
        iJEYDTnej+oazlwPa05el4CLPWgMDpXDXiXNdZNT7g==
X-Google-Smtp-Source: AGHT+IERbkZ9QTV6CGaib/EXST6dWE91mvlzlFXtd3YT81j0REMWIZkRIsmCG7Ilhnwx+nacGVcNXTypUzsf+mBjjcI=
X-Received: by 2002:a5d:664b:0:b0:317:597b:9f92 with SMTP id
 f11-20020a5d664b000000b00317597b9f92mr52249wrw.57.1692138738877; Tue, 15 Aug
 2023 15:32:18 -0700 (PDT)
MIME-Version: 1.0
References: <20230815032645.1393700-1-willy@infradead.org> <20230815032645.1393700-9-willy@infradead.org>
 <ZNvQ4EbQh/aAwK8L@x1n> <ZNvbApJbLanU55Ze@casper.infradead.org>
In-Reply-To: <ZNvbApJbLanU55Ze@casper.infradead.org>
From:   Yosry Ahmed <yosryahmed@google.com>
Date:   Tue, 15 Aug 2023 15:31:42 -0700
Message-ID: <CAJD7tkY=-Mmrbe5_Z8rKA--zUMo83mTyY1frZEFy6C5NFP-y7A@mail.gmail.com>
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

On Tue, Aug 15, 2023 at 1:07=E2=80=AFPM Matthew Wilcox <willy@infradead.org=
> wrote:
>
> On Tue, Aug 15, 2023 at 03:24:16PM -0400, Peter Xu wrote:
> > On Tue, Aug 15, 2023 at 04:26:44AM +0100, Matthew Wilcox (Oracle) wrote=
:
> > > +++ b/include/linux/page-flags.h
> > > @@ -99,13 +99,15 @@
> > >   */
> > >  enum pageflags {
> > >     PG_locked,              /* Page is locked. Don't touch. */
> > > +   PG_writeback,           /* Page is under writeback */
> > >     PG_referenced,
> > >     PG_uptodate,
> > >     PG_dirty,
> > >     PG_lru,
> > > +   PG_head,                /* Must be in bit 6 */
> >
> > Could there be some explanation on "must be in bit 6" here?
>
> Not on this line, no.  You get 40-50 characters to say something useful.
> Happy to elaborate further in some other comment or in the commit log,
> but not on this line.
>
> The idea behind all of this is that _folio_order moves into the bottom
> byte of _flags_1.  Because the order can never be greater than 63 (and
> in practice I think the largest we're going to see is about 30 -- a 16GB
> hugetlb page on some architectures), we know that PG_head and PG_waiters
> will be clear, so we can write (folio->_flags_1 & 0xff) and the compiler
> will just load a byte; it won't actually load the word and mask it.
>
> We can't move PG_head any lower, or we'll risk having a tail page with
> PG_head set (which can happen with the vmemmmap optimisation, but eugh).
> And we don't want to move it any higher because then we'll have a flag
> that cannot be reused in a tail page.  Bit 6 is the perfect spot for it.

Is there some compile time assertion that the order cannot overflow into bi=
t 6?
