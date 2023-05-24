Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C0C770EBCC
	for <lists+io-uring@lfdr.de>; Wed, 24 May 2023 05:17:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239284AbjEXDRk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 May 2023 23:17:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232367AbjEXDRD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 May 2023 23:17:03 -0400
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8F5110E3
        for <io-uring@vger.kernel.org>; Tue, 23 May 2023 20:15:23 -0700 (PDT)
Received: by mail-il1-x133.google.com with SMTP id e9e14a558f8ab-3381a0cae92so2845895ab.0
        for <io-uring@vger.kernel.org>; Tue, 23 May 2023 20:15:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684898123; x=1687490123;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5K82624dp/INLh8L6r9QVknrsFryPWSF3j8ZLvRKTiE=;
        b=e/4OJHPkTyx00JQOTEW9U4E27IXL8VKFC1f1GgfxVXoLRPDtyytfWlXv7eD/QpgqZa
         124UFeTO21kf+f/gXYyshYpQOxYZBgWgD0UqpB4JUwWpcf2sht2Ujk+HdDOWptso1R/D
         3N44mdapRS/+EE0wirElSRFe6ghVqtDEfCiMyt5aFlcuBDZ5Uh4PVoxpWzWf8KQl1LpB
         vpP+RToKn9YBCiOvH9Hy2NhIJ5MOzPjRRclENgWvMvffYTDFMNl+Vb14M3ygC9GAAYAH
         lJj75T5y/GeKEQ/WuL63uuK3U9gasggTMXqkMeniYu4adZxP5WCF/Z7PoFcUCWPi5rh3
         l2Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684898123; x=1687490123;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5K82624dp/INLh8L6r9QVknrsFryPWSF3j8ZLvRKTiE=;
        b=F9S0RmDski4YqiaZwad4QKQ92GPDHf3hlpohZSFeJ/C3MlN975yw+iUCcA48ixxaKY
         0vckueRn7Sw/U2cxB7361RXPWXd2SxxV2JKyae5lbEOO1sBoA+P4tgS1tCMPN0TXjOSy
         QWv8fBRs+kLyhwwFYIS8Rox9azKnXvtEkAi+fx355Dy6LW3vSyu3LmzOHQJo+aceR638
         hmIXnzKwvy42DcbkjM/HoChX+rbJrJ+VqNKUH6kerDUqVsSqjQnl5diibOI3rtc6m6Nq
         zTyQeSoOGQ24dGkSgSRK5DZU7XvL1XyzKrGnbmF6X636fzug+mMfrMavNIhtsYDXCoOB
         IIxw==
X-Gm-Message-State: AC+VfDwxLyewGnWprJYiUYcBMoHjayRmFlv62HfRqAhE6K9t3zYKaofB
        znmZdf4paJo9b7Hzdt6aXRzs55DzPCSm+/amlsM=
X-Google-Smtp-Source: ACHHUZ50kU8JOY3ukdMLD1DqyUpH6PupTgg8j+mU/P+m8eyJV7pr/LD+69bJWPPiKEa2w+lSyAIr5tROM6oRi4pfvo8=
X-Received: by 2002:a92:cf4c:0:b0:331:5aec:5a34 with SMTP id
 c12-20020a92cf4c000000b003315aec5a34mr11278888ilr.0.1684898122945; Tue, 23
 May 2023 20:15:22 -0700 (PDT)
MIME-Version: 1.0
References: <3e79156a106e8b5b3646672656f738ba157957ef.1684505086.git.asml.silence@gmail.com>
 <CAAehj2nmnN98ZYzcFMR0DsKXqEM7L8DH8SM4NusPqzoHu_VNPw@mail.gmail.com>
 <4ec09942-2855-8be4-3f51-d1fedea8d2f3@gmail.com> <CAAehj2kOScdWU6_N+gs-Zo+yCx2Q2_x5vdX3U=Cc8R2=ruJb9Q@mail.gmail.com>
 <700f61ec-dc97-4572-d05c-9cbddf3addc8@gmail.com>
In-Reply-To: <700f61ec-dc97-4572-d05c-9cbddf3addc8@gmail.com>
From:   yang lan <lanyang0908@gmail.com>
Date:   Wed, 24 May 2023 11:15:12 +0800
Message-ID: <CAAehj2nPSJzZer_jhd0=VvTDjTD2uaCtdidKqeFK=js75YA_+g@mail.gmail.com>
Subject: Re: [PATCH 1/1] io_uring: more graceful request alloc OOM
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

Thanks.

Regards,

Yang

Pavel Begunkov <asml.silence@gmail.com> =E4=BA=8E2023=E5=B9=B45=E6=9C=8823=
=E6=97=A5=E5=91=A8=E4=BA=8C 20:15=E5=86=99=E9=81=93=EF=BC=9A
>
> On 5/22/23 08:55, yang lan wrote:
> > Hi,
> >
> > Thanks. I'm also analyzing the root cause of this bug.
>
> The repro indeed triggers, this time in another place. Though
> when I patch all of them it would fail somewhere else, like in
> ext4 on a pagefault.
>
> We can add a couple more those "don't oom but fail" and some
> niceness around, but I think it's fine as it is as allocations
> are under cgroup. If admin cares about collision b/w users there
> should be cgroups, so allocations of one don't affect another. And
> if a user pushes it to the limit and oom's itself and gets OOM,
> that should be fine.
>
> > By the way, can I apply for a CVE? And should I submit a request to
> > some official organizations, such as Openwall, etc?
>
> Sorry, but we cannot help you here. We don't deal with CVEs.
>
> That aside, I'm not even sure it's CVE'able because it shouldn't
> be exploitable in a configured environment (unless it is). But
> I'm not an expert in that so might be wrong.
>
>
>
> > Pavel Begunkov <asml.silence@gmail.com> =E4=BA=8E2023=E5=B9=B45=E6=9C=
=8822=E6=97=A5=E5=91=A8=E4=B8=80 08:45=E5=86=99=E9=81=93=EF=BC=9A
> >>
> >> On 5/20/23 10:38, yang lan wrote:
> >>> Hi,
> >>>
> >>> Thanks for your response.
> >>>
> >>> But I applied this patch to LTS kernel 5.10.180, it can still trigger=
 this bug.
> >>>
> >>> --- io_uring/io_uring.c.back    2023-05-20 17:11:25.870550438 +0800
> >>> +++ io_uring/io_uring.c 2023-05-20 16:35:24.265846283 +0800
> >>> @@ -1970,7 +1970,7 @@
> >>> static struct io_kiocb *io_alloc_req(struct io_ring_ctx *ctx)
> >>>           __must_hold(&ctx->uring_lock)
> >>>    {
> >>>           struct io_submit_state *state =3D &ctx->submit_state;
> >>> -       gfp_t gfp =3D GFP_KERNEL | __GFP_NOWARN;
> >>> +       gfp_t gfp =3D GFP_KERNEL | __GFP_NOWARN | __GFP_NORETRY;
> >>>           int ret, i;
> >>>
> >>>           BUILD_BUG_ON(ARRAY_SIZE(state->reqs) < IO_REQ_ALLOC_BATCH);
> >>>
> >>> The io_uring.c.back is the original file.
> >>> Do I apply this patch wrong?
> >>
> >> The patch looks fine. I run a self-written test before
> >> sending with 6.4, worked as expected. I need to run the syz
> >> test, maybe it shifted to another spot, e.g. in provided
> >> buffers.
> >>
> >> --
> >> Pavel Begunkov
>
> --
> Pavel Begunkov
