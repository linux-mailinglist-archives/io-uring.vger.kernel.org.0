Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4D3267F1F0
	for <lists+io-uring@lfdr.de>; Sat, 28 Jan 2023 00:03:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229804AbjA0XDi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 27 Jan 2023 18:03:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229721AbjA0XDh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 27 Jan 2023 18:03:37 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF50B9762
        for <io-uring@vger.kernel.org>; Fri, 27 Jan 2023 15:02:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674860572;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Mf9CRtgHatpC1qpwGJMwLup8PY/IMJMqnFA9VKCdeGA=;
        b=KEf7nY+Wf0/3csMuOrJj1iYu43ZkbdMHmTM9VeFJpWgNY8fCap9R/ImveocrazFecjb1R3
        ibIXqQ0GX+3Wcc4l0aAUco+kgMPfJ5ECMHBuVCr05VVVqIicBx+5xUlcnFKJ1HVlAfbNpD
        szxxv5vOCKbzYzSxxcOCnz7jhrVuuM8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-13-w782ddsCPOONwnl5-GTUQQ-1; Fri, 27 Jan 2023 18:02:48 -0500
X-MC-Unique: w782ddsCPOONwnl5-GTUQQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EEEE038149B4;
        Fri, 27 Jan 2023 23:02:47 +0000 (UTC)
Received: from madcap2.tricolour.ca (ovpn-0-3.rdu2.redhat.com [10.22.0.3])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 70FA21121314;
        Fri, 27 Jan 2023 23:02:46 +0000 (UTC)
Date:   Fri, 27 Jan 2023 18:02:44 -0500
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Paul Moore <paul@paul-moore.com>,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, io-uring@vger.kernel.org,
        Eric Paris <eparis@parisplace.org>,
        Steve Grubb <sgrubb@redhat.com>, Stefan Roesch <shr@fb.com>,
        Christian Brauner <brauner@kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH v1 1/2] io_uring,audit: audit IORING_OP_FADVISE but not
 IORING_OP_MADVISE
Message-ID: <Y9RYFHucRL5TrsDh@madcap2.tricolour.ca>
References: <cover.1674682056.git.rgb@redhat.com>
 <68eb0c2dd50bca1af91203669f7f1f8312331f38.1674682056.git.rgb@redhat.com>
 <CAHC9VhSZNGs+SQU7WCD+ObMcwv-=1ZkBts8oHn40qWsQ=n0pXA@mail.gmail.com>
 <6d3f76ae-9f86-a96e-d540-cfd45475e288@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6d3f76ae-9f86-a96e-d540-cfd45475e288@kernel.dk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2023-01-27 15:45, Jens Axboe wrote:
> On 1/27/23 3:35?PM, Paul Moore wrote:
> > On Fri, Jan 27, 2023 at 12:24 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> >>
> >> Since FADVISE can truncate files and MADVISE operates on memory, reverse
> >> the audit_skip tags.
> >>
> >> Fixes: 5bd2182d58e9 ("audit,io_uring,io-wq: add some basic audit support to io_uring")
> >> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> >> ---
> >>  io_uring/opdef.c | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/io_uring/opdef.c b/io_uring/opdef.c
> >> index 3aa0d65c50e3..a2bf53b4a38a 100644
> >> --- a/io_uring/opdef.c
> >> +++ b/io_uring/opdef.c
> >> @@ -306,12 +306,12 @@ const struct io_op_def io_op_defs[] = {
> >>         },
> >>         [IORING_OP_FADVISE] = {
> >>                 .needs_file             = 1,
> >> -               .audit_skip             = 1,
> >>                 .name                   = "FADVISE",
> >>                 .prep                   = io_fadvise_prep,
> >>                 .issue                  = io_fadvise,
> >>         },
> > 
> > I've never used posix_fadvise() or the associated fadvise64*()
> > syscalls, but from quickly reading the manpages and the
> > generic_fadvise() function in the kernel I'm missing where the fadvise
> > family of functions could be used to truncate a file, can you show me
> > where this happens?  The closest I can see is the manipulation of the
> > page cache, but that shouldn't actually modify the file ... right?
> 
> Yeah, honestly not sure where that came from. Maybe it's being mixed up
> with fallocate? All fadvise (or madvise, for that matter) does is
> provide hints on the caching or access pattern. On second thought, both
> of these should be able to set audit_skip as far as I can tell.

That was one suspicion I had.  If this is the case, I'd agree both could
be skipped.

> Jens Axboe

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635

