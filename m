Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9317B67F13A
	for <lists+io-uring@lfdr.de>; Fri, 27 Jan 2023 23:38:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231782AbjA0WiW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 27 Jan 2023 17:38:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231738AbjA0WiU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 27 Jan 2023 17:38:20 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8E82193E0
        for <io-uring@vger.kernel.org>; Fri, 27 Jan 2023 14:38:17 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id b10so5961426pjo.1
        for <io-uring@vger.kernel.org>; Fri, 27 Jan 2023 14:38:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wT576QX9xHllxN0lRYKR47JyczROgIwu1/PNvL2Rutc=;
        b=N8uiweR9oBNu+LgBzfjcYD4LfOcGUNYX6AHlx0v6YVDeAc66gmMpNn3oZIayWzKsDn
         926K9JP3uxel/Ho9K5Ois/lhxo8W+Ox4nSXlrgjlf6aSxotydEAMHwubMa2/94+Fjb9U
         snv15PToWK5Rm3Nvw2dlDhXwHgCOEL5lpuczC71l0Pw5TLfQ70xqL8QLG/nHA0lhS1xF
         p1RGKHlbaLtfoPufbjbyeSMNGYrUpaUHK62ieAKW9wB2SgvaUtWrnT9p6EiHTEgB9K2c
         Zw2+2NsaN5M5EbpyDQQjjGaPDJghbSPIb6yujk23VLQ7JvnOCyKlYGH0+DnJ2J96bHSF
         S7VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wT576QX9xHllxN0lRYKR47JyczROgIwu1/PNvL2Rutc=;
        b=4zMxzVOFKX7lhKB6BaEo0S6wktkETbUfooCS8QLCa5wCIwXLYoqmEJenurJu+99rcj
         7SOlekdbWF+gCs5kJWx6N11+3lfPn+91weYx4pZ5QqLORimQVYCtjOy4Qjam7kWEhUuN
         J9ren+7yOU904GEvBP1IBKOYLY5/2UMS2uBwVAl1n5fIqWUEjDkkvgKSekO4tgyUr0/K
         4aG5tm1D0ZN23+JHrfqrIdAR6fURf6aDE0DYIJrhyXF67oowAuKbnbHcxlTo6poi8djc
         2FNRmRXHmMINd8rrH2CtDeQ9T7WYEOiP6PPmabz3/VcMAiodoF5FOPUw/ir2E/R/WSly
         E0Fg==
X-Gm-Message-State: AFqh2krkE/tlcDXGPoinFtG9f517cwvbcpS7B11ch39adWAgCTuCldOx
        UZauJ4/UImpTWBkEQzRgvewXDDrn+UTUzwrlqqqe
X-Google-Smtp-Source: AMrXdXunM/785t5txnw7UTNhE9KblolcGjVvpPCwHuVLwD9hj4/sdRedAvzglIcjinAMhc5wbooE+A37rMqn4q3jEpU=
X-Received: by 2002:a17:90b:3903:b0:225:de08:b714 with SMTP id
 ob3-20020a17090b390300b00225de08b714mr5008556pjb.193.1674859097412; Fri, 27
 Jan 2023 14:38:17 -0800 (PST)
MIME-Version: 1.0
References: <cover.1674682056.git.rgb@redhat.com> <da695bf4-bd9b-a03d-3fbc-686724a7b602@kernel.dk>
 <CAHC9VhSRbay5bEUMJngpj+6Ss=WLeRoyJaNNMip+TyTkTJ6=Lg@mail.gmail.com> <24fbe6cb-ee80-f726-b260-09f394ead764@kernel.dk>
In-Reply-To: <24fbe6cb-ee80-f726-b260-09f394ead764@kernel.dk>
From:   Paul Moore <paul@paul-moore.com>
Date:   Fri, 27 Jan 2023 17:38:06 -0500
Message-ID: <CAHC9VhRuvV9vjhmTM4eGJkWmpZmSkgVaoQ=L6g3cahej-F52tQ@mail.gmail.com>
Subject: Re: [PATCH v1 0/2] two suggested iouring op audit updates
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Richard Guy Briggs <rgb@redhat.com>,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, io-uring@vger.kernel.org,
        Eric Paris <eparis@parisplace.org>,
        Steve Grubb <sgrubb@redhat.com>, Stefan Roesch <shr@fb.com>,
        Christian Brauner <brauner@kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Jan 27, 2023 at 2:43 PM Jens Axboe <axboe@kernel.dk> wrote:
> On 1/27/23 12:42=E2=80=AFPM, Paul Moore wrote:
> > On Fri, Jan 27, 2023 at 12:40 PM Jens Axboe <axboe@kernel.dk> wrote:
> >> On 1/27/23 10:23=E2=80=AFAM, Richard Guy Briggs wrote:
> >>> A couple of updates to the iouring ops audit bypass selections sugges=
ted in
> >>> consultation with Steve Grubb.
> >>>
> >>> Richard Guy Briggs (2):
> >>>   io_uring,audit: audit IORING_OP_FADVISE but not IORING_OP_MADVISE
> >>>   io_uring,audit: do not log IORING_OP_*GETXATTR
> >>>
> >>>  io_uring/opdef.c | 4 +++-
> >>>  1 file changed, 3 insertions(+), 1 deletion(-)
> >>
> >> Look fine to me - we should probably add stable to both of them, just
> >> to keep things consistent across releases. I can queue them up for 6.3=
.
> >
> > Please hold off until I've had a chance to look them over ...
>
> I haven't taken anything yet, for things like this I always let it
> simmer until people have had a chance to do so.

Thanks.  FWIW, that sounds very reasonable to me, but I've seen lots
of different behaviors across subsystems and wanted to make sure we
were on the same page.

--=20
paul-moore.com
