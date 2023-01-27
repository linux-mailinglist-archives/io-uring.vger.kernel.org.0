Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1B3267F189
	for <lists+io-uring@lfdr.de>; Fri, 27 Jan 2023 23:56:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230195AbjA0W4W (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 27 Jan 2023 17:56:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231287AbjA0W4U (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 27 Jan 2023 17:56:20 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5A1379633
        for <io-uring@vger.kernel.org>; Fri, 27 Jan 2023 14:55:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674860115;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TBTNNrJ5H6EIuuMcTERsk2lhrSBPK+9yag5Mpha8Oo4=;
        b=WiIbe+b1ma/IziK5e+7w3RjK3SCZQ9Yd10fnW8a3n2/v5FBIXAzWA8HonIsH5vpkBVv8EI
        gOYsHsVav7SUgWN0TY451M3zLmztHaAAZUh6YE+41zbWc/8/q774GM1txkb7/4kq2W+3RB
        jH6nCiN/eew8XRjDzcDIP3NNHj2QoAk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-57-zpUWEGnYOdO8AhFhqMBwyw-1; Fri, 27 Jan 2023 17:55:10 -0500
X-MC-Unique: zpUWEGnYOdO8AhFhqMBwyw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9035229AA3B3;
        Fri, 27 Jan 2023 22:55:09 +0000 (UTC)
Received: from madcap2.tricolour.ca (ovpn-0-3.rdu2.redhat.com [10.22.0.3])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id F05D318EC1;
        Fri, 27 Jan 2023 22:55:07 +0000 (UTC)
Date:   Fri, 27 Jan 2023 17:55:05 -0500
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Paul Moore <paul@paul-moore.com>
Cc:     Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, io-uring@vger.kernel.org,
        Eric Paris <eparis@parisplace.org>,
        Steve Grubb <sgrubb@redhat.com>, Stefan Roesch <shr@fb.com>,
        Christian Brauner <brauner@kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH v1 1/2] io_uring,audit: audit IORING_OP_FADVISE but not
 IORING_OP_MADVISE
Message-ID: <Y9RWSZJt7NruCPZ+@madcap2.tricolour.ca>
References: <cover.1674682056.git.rgb@redhat.com>
 <68eb0c2dd50bca1af91203669f7f1f8312331f38.1674682056.git.rgb@redhat.com>
 <CAHC9VhSZNGs+SQU7WCD+ObMcwv-=1ZkBts8oHn40qWsQ=n0pXA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHC9VhSZNGs+SQU7WCD+ObMcwv-=1ZkBts8oHn40qWsQ=n0pXA@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2023-01-27 17:35, Paul Moore wrote:
> On Fri, Jan 27, 2023 at 12:24 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> >
> > Since FADVISE can truncate files and MADVISE operates on memory, reverse
> > the audit_skip tags.
> >
> > Fixes: 5bd2182d58e9 ("audit,io_uring,io-wq: add some basic audit support to io_uring")
> > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > ---
> >  io_uring/opdef.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/io_uring/opdef.c b/io_uring/opdef.c
> > index 3aa0d65c50e3..a2bf53b4a38a 100644
> > --- a/io_uring/opdef.c
> > +++ b/io_uring/opdef.c
> > @@ -306,12 +306,12 @@ const struct io_op_def io_op_defs[] = {
> >         },
> >         [IORING_OP_FADVISE] = {
> >                 .needs_file             = 1,
> > -               .audit_skip             = 1,
> >                 .name                   = "FADVISE",
> >                 .prep                   = io_fadvise_prep,
> >                 .issue                  = io_fadvise,
> >         },
> 
> I've never used posix_fadvise() or the associated fadvise64*()
> syscalls, but from quickly reading the manpages and the
> generic_fadvise() function in the kernel I'm missing where the fadvise
> family of functions could be used to truncate a file, can you show me
> where this happens?  The closest I can see is the manipulation of the
> page cache, but that shouldn't actually modify the file ... right?

I don't know.  I was going on the advice of Steve Grubb.  I'm looking
for feedback, validation, correction, here.

> >         [IORING_OP_MADVISE] = {
> > +               .audit_skip             = 1,
> >                 .name                   = "MADVISE",
> >                 .prep                   = io_madvise_prep,
> >                 .issue                  = io_madvise,
> 
> I *think* this should be okay, what testing/verification have you done
> on this?  One of the things I like to check is to see if any LSMs
> might perform an access check and/or generate an audit record on an
> operation, if there is a case where that could happen we should setup
> audit properly.  I did a very quick check of do_madvise() and nothing
> jumped out at me, but I would be interested in knowing what testing or
> verification you did here.

No testing other than build/boot/audit-testsuite.  You had a test you
had developed that went through several iterations?

> paul-moore.com

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635

