Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21ECD67F1FF
	for <lists+io-uring@lfdr.de>; Sat, 28 Jan 2023 00:06:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232316AbjA0XGB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 27 Jan 2023 18:06:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjA0XGB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 27 Jan 2023 18:06:01 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A05F17CC5
        for <io-uring@vger.kernel.org>; Fri, 27 Jan 2023 15:06:00 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id h5-20020a17090a9c0500b0022bb85eb35dso6105517pjp.3
        for <io-uring@vger.kernel.org>; Fri, 27 Jan 2023 15:06:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=1SPNH/LuDCM3wOe70lK0cYgps5LwNXpnI8bzZ3//AbM=;
        b=MDwuoJJtiomygUMFF/B8y+4g7aisnz4J4XIO5q0BR7BxvV2Gu8ANB47cq0YRT2DbCp
         Z2KP+Vt1dC5JKe10rBHOAydrEvkrtuAvIWFPkKf3FFrK3aqPJwrrMgUI+wJXGEYmfyT3
         V/bGu7sIgtSx2n44NQj6Sw6XFXqqtaw/t5sz/IduXulaxtJLasS4slRnsx15PhxpE62s
         Pkod7ZRGJ+FHkgNS3CpLtqzA6+Umg9lNmhiDFdZH4GrhxLu1w5C7ggS6OmK0LWmxBvkp
         OE56Wyrp2ngKSrhd7hst/N5DsDw7QwOz9Z3f5Bj03JscRIXUZPh/uRLksH9rm8uhfsRM
         kAyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1SPNH/LuDCM3wOe70lK0cYgps5LwNXpnI8bzZ3//AbM=;
        b=58EHcYfLjKazbnX3fWgfk0vrrBuMJjr3l8uDdYDV780Z2rgydoJWSmdPJ7X/VDkORW
         ru4mDgF7ag3D85BUHBwS+6NwTCjhZHn8JejwC0Xn6f8EvX7QIdkFWdAI/Px0IFoB5iXD
         E/4kU6Q3DU0XoSd0Nl+o2l7QoV0/gUX2XJordg92R+mjJ38wEmdrNiPDOCQzoKKqY41W
         3Vs03JQei+ZAzNXeQAcRbS/vNHZE8NIH1e3PcBz0ZypxoYZigoEHS+ArrkMWHGSekdnK
         ptDxplwI53j6PuMv7shZ+RFpZhLFCd2u8pYtWC2Ximirxe6LStuQvLn9SNN8RRF0uBFS
         bPVA==
X-Gm-Message-State: AFqh2kobdGZFfUPziA4hrw+nZ4D6OkRY2YNlHrHFSbCKY7gunokkuRUd
        iux/HkCIUIszCG7zRMQLPJ37X3EK+iNYgSNsu2nT
X-Google-Smtp-Source: AMrXdXtoibC4sO4UJhtHedLXn5EFBmLz6kt4lH87+Hx2zFU5xSqW1t6YpxwqhFQuareAum3b2p5DvXjIZlBbat9W5SI=
X-Received: by 2002:a17:902:c404:b0:194:954c:fb8 with SMTP id
 k4-20020a170902c40400b00194954c0fb8mr4841408plk.20.1674860759548; Fri, 27 Jan
 2023 15:05:59 -0800 (PST)
MIME-Version: 1.0
References: <cover.1674682056.git.rgb@redhat.com> <68eb0c2dd50bca1af91203669f7f1f8312331f38.1674682056.git.rgb@redhat.com>
 <CAHC9VhSZNGs+SQU7WCD+ObMcwv-=1ZkBts8oHn40qWsQ=n0pXA@mail.gmail.com> <Y9RWSZJt7NruCPZ+@madcap2.tricolour.ca>
In-Reply-To: <Y9RWSZJt7NruCPZ+@madcap2.tricolour.ca>
From:   Paul Moore <paul@paul-moore.com>
Date:   Fri, 27 Jan 2023 18:05:48 -0500
Message-ID: <CAHC9VhS_xpiiiweR_mtKzNanDx_m9tkvhN5dy7FuQm-tuMK6iA@mail.gmail.com>
Subject: Re: [PATCH v1 1/2] io_uring,audit: audit IORING_OP_FADVISE but not IORING_OP_MADVISE
To:     Richard Guy Briggs <rgb@redhat.com>
Cc:     Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, io-uring@vger.kernel.org,
        Eric Paris <eparis@parisplace.org>,
        Steve Grubb <sgrubb@redhat.com>, Stefan Roesch <shr@fb.com>,
        Christian Brauner <brauner@kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Jan 27, 2023 at 5:55 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> On 2023-01-27 17:35, Paul Moore wrote:
> > On Fri, Jan 27, 2023 at 12:24 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > >
> > > Since FADVISE can truncate files and MADVISE operates on memory, reverse
> > > the audit_skip tags.
> > >
> > > Fixes: 5bd2182d58e9 ("audit,io_uring,io-wq: add some basic audit support to io_uring")
> > > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > > ---
> > >  io_uring/opdef.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/io_uring/opdef.c b/io_uring/opdef.c
> > > index 3aa0d65c50e3..a2bf53b4a38a 100644
> > > --- a/io_uring/opdef.c
> > > +++ b/io_uring/opdef.c
> > > @@ -306,12 +306,12 @@ const struct io_op_def io_op_defs[] = {
> > >         },
> > >         [IORING_OP_FADVISE] = {
> > >                 .needs_file             = 1,
> > > -               .audit_skip             = 1,
> > >                 .name                   = "FADVISE",
> > >                 .prep                   = io_fadvise_prep,
> > >                 .issue                  = io_fadvise,
> > >         },
> >
> > I've never used posix_fadvise() or the associated fadvise64*()
> > syscalls, but from quickly reading the manpages and the
> > generic_fadvise() function in the kernel I'm missing where the fadvise
> > family of functions could be used to truncate a file, can you show me
> > where this happens?  The closest I can see is the manipulation of the
> > page cache, but that shouldn't actually modify the file ... right?
>
> I don't know.  I was going on the advice of Steve Grubb.  I'm looking
> for feedback, validation, correction, here.

Keep in mind it's your name on the patch, not Steve's, and I would
hope that you should be able to stand up and vouch for your own patch.
Something to keep in mind for the future.

As it stands, I think the audit_skip line should stay for
IORING_OP_FADVISE, if you feel otherwise please provide more
explanation as to why auditing is necessary for this operation.

> > >         [IORING_OP_MADVISE] = {
> > > +               .audit_skip             = 1,
> > >                 .name                   = "MADVISE",
> > >                 .prep                   = io_madvise_prep,
> > >                 .issue                  = io_madvise,
> >
> > I *think* this should be okay, what testing/verification have you done
> > on this?  One of the things I like to check is to see if any LSMs
> > might perform an access check and/or generate an audit record on an
> > operation, if there is a case where that could happen we should setup
> > audit properly.  I did a very quick check of do_madvise() and nothing
> > jumped out at me, but I would be interested in knowing what testing or
> > verification you did here.
>
> No testing other than build/boot/audit-testsuite.  You had a test you
> had developed that went through several iterations?

There is an io_uring test in the audit-testsuite that verifies basic
audit record generation, it is not exhaustive.

Patch 2/2 is a no-go from a security perspective (we want to see those
records), and I think skipping on IORING_OP_FADVISE is the correct
thing to do.  It may be that skipping on IORING_OP_MADVISE is the
correct thing, but given that it doesn't appear a lot of in-depth
investigation has gone into these patches I would really like to see
some more reasoning on this before we change the current behavior.

-- 
paul-moore.com
