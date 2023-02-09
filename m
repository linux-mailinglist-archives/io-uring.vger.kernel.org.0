Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D614B6912D5
	for <lists+io-uring@lfdr.de>; Thu,  9 Feb 2023 22:54:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230169AbjBIVyJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 9 Feb 2023 16:54:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjBIVyI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 9 Feb 2023 16:54:08 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 613B463116
        for <io-uring@vger.kernel.org>; Thu,  9 Feb 2023 13:53:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675979598;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kZXtytW52eF9I6Wk1wiK455K/DS7KMbgwYg8Bzqjx40=;
        b=SIMZRFOpGe/viybSPsHAZWq7dg1hZixxnVCSnyDPM+Q/f7TllDuXgNoq8mBXvkH6cKb2it
        CmfQ7B4FE0JPx+nktXuJmJ/CISOssE6lQ4nO8sSZhDiTAh41U6dbIkjXZRTEPcm1US33YT
        T807U5uW4O2tWN0Fb9QWk9niTvb7/go=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-349-gVWLNVltPZKBuDqcZfjoOQ-1; Thu, 09 Feb 2023 16:53:16 -0500
X-MC-Unique: gVWLNVltPZKBuDqcZfjoOQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5A14E3806632;
        Thu,  9 Feb 2023 21:53:16 +0000 (UTC)
Received: from madcap2.tricolour.ca (unknown [10.22.50.7])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id ECB16140EBF6;
        Thu,  9 Feb 2023 21:53:14 +0000 (UTC)
Date:   Thu, 9 Feb 2023 16:53:12 -0500
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Paul Moore <paul@paul-moore.com>
Cc:     Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, io-uring@vger.kernel.org,
        Eric Paris <eparis@parisplace.org>,
        Steve Grubb <sgrubb@redhat.com>,
        Christian Brauner <brauner@kernel.org>,
        Stefan Roesch <shr@fb.com>
Subject: Re: [PATCH v2] io_uring,audit: don't log IORING_OP_MADVISE
Message-ID: <Y+VrSLZKZoAGikUS@madcap2.tricolour.ca>
References: <b5dfdcd541115c86dbc774aa9dd502c964849c5f.1675282642.git.rgb@redhat.com>
 <CAHC9VhS0rPfkwUT1WMfqsTF-qYXdbbhHAfVPs=d3ZQVgbXBHnw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHC9VhS0rPfkwUT1WMfqsTF-qYXdbbhHAfVPs=d3ZQVgbXBHnw@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2023-02-01 16:18, Paul Moore wrote:
> On Wed, Feb 1, 2023 at 3:34 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > fadvise and madvise both provide hints for caching or access pattern for
> > file and memory respectively.  Skip them.
> 
> You forgot to update the first sentence in the commit description :/

I didn't forget.  I updated that sentence to reflect the fact that the
two should be treated similarly rather than differently.

> I'm still looking for some type of statement that you've done some
> homework on the IORING_OP_MADVISE case to ensure that it doesn't end
> up calling into the LSM, see my previous emails on this.  I need more
> than "Steve told me to do this".
> 
> I basically just want to see that some care and thought has gone into
> this patch to verify it is correct and good.

Steve suggested I look into a number of iouring ops.  I looked at the
description code and agreed that it wasn't necessary to audit madvise.
The rationale for fadvise was detemined to have been conflated with
fallocate and subsequently dropped.  Steve also suggested a number of
others and after investigation I decided that their current state was
correct.  *getxattr you've advised against, so it was dropped.  It
appears fewer modifications were necessary than originally suspected.

> > Fixes: 5bd2182d58e9 ("audit,io_uring,io-wq: add some basic audit support to io_uring")
> > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > ---
> > changelog
> > v2:
> > - drop *GETXATTR patch
> > - drop FADVISE hunk
> >
> >  io_uring/opdef.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/io_uring/opdef.c b/io_uring/opdef.c
> > index 3aa0d65c50e3..d3f36c633ceb 100644
> > --- a/io_uring/opdef.c
> > +++ b/io_uring/opdef.c
> > @@ -312,6 +312,7 @@ const struct io_op_def io_op_defs[] = {
> >                 .issue                  = io_fadvise,
> >         },
> >         [IORING_OP_MADVISE] = {
> > +               .audit_skip             = 1,
> >                 .name                   = "MADVISE",
> >                 .prep                   = io_madvise_prep,
> >                 .issue                  = io_madvise,
> > --
> > 2.27.0
> 
> -- 
> paul-moore.com
> 

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635

