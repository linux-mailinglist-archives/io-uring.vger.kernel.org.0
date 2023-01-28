Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEA7E67F9AA
	for <lists+io-uring@lfdr.de>; Sat, 28 Jan 2023 17:50:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234600AbjA1Qt6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 28 Jan 2023 11:49:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234595AbjA1Qt4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 28 Jan 2023 11:49:56 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 579262917D
        for <io-uring@vger.kernel.org>; Sat, 28 Jan 2023 08:49:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674924542;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vJMl8Ly6KyE2eDx8S+bXIL1Y4voAlHQIMFALhv1I/e8=;
        b=VGwyWLM8aowmU+qfcM9igXxgGUkmFfe4JSpDtEd1+KXllHR44CiYT2W37Qtz/Zy0lea0IR
        0ZTJcdpwNu23wkqNW9xaknV9q3xmjGaF1MpJoBBf8X0UIsxS2edwmESzzNEpYOYDaOD7U1
        1PuWjEVd3f8wW6xm+u9qV3LRVbv+gu0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-56-dXy7C1ExPIuFHXVj3GmBzg-1; Sat, 28 Jan 2023 11:48:57 -0500
X-MC-Unique: dXy7C1ExPIuFHXVj3GmBzg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CD1D62A59542;
        Sat, 28 Jan 2023 16:48:56 +0000 (UTC)
Received: from x2.localnet (unknown [10.22.8.91])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4C5D514171BE;
        Sat, 28 Jan 2023 16:48:56 +0000 (UTC)
From:   Steve Grubb <sgrubb@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, Paul Moore <paul@paul-moore.com>
Cc:     Richard Guy Briggs <rgb@redhat.com>,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, io-uring@vger.kernel.org,
        Eric Paris <eparis@parisplace.org>, Stefan Roesch <shr@fb.com>,
        Christian Brauner <brauner@kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH v1 1/2] io_uring,audit: audit IORING_OP_FADVISE but not
 IORING_OP_MADVISE
Date:   Sat, 28 Jan 2023 11:48:55 -0500
Message-ID: <5911706.lOV4Wx5bFT@x2>
Organization: Red Hat
In-Reply-To: <CAHC9VhSfG6Oddk3qeFYiwkE5orRKs_PCLAD+F0yK-fRx27UTwg@mail.gmail.com>
References: <cover.1674682056.git.rgb@redhat.com>
 <6d3f76ae-9f86-a96e-d540-cfd45475e288@kernel.dk>
 <CAHC9VhSfG6Oddk3qeFYiwkE5orRKs_PCLAD+F0yK-fRx27UTwg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Friday, January 27, 2023 5:57:30 PM EST Paul Moore wrote:
> On Fri, Jan 27, 2023 at 5:45 PM Jens Axboe <axboe@kernel.dk> wrote:
> > On 1/27/23 3:35?PM, Paul Moore wrote:
> > > On Fri, Jan 27, 2023 at 12:24 PM Richard Guy Briggs <rgb@redhat.com> 
wrote:
> > >> Since FADVISE can truncate files and MADVISE operates on memory,
> > >> reverse
> > >> the audit_skip tags.
> > >> 
> > >> Fixes: 5bd2182d58e9 ("audit,io_uring,io-wq: add some basic audit
> > >> support to io_uring") Signed-off-by: Richard Guy Briggs
> > >> <rgb@redhat.com>
> > >> ---
> > >> 
> > >>  io_uring/opdef.c | 2 +-
> > >>  1 file changed, 1 insertion(+), 1 deletion(-)
> > >> 
> > >> diff --git a/io_uring/opdef.c b/io_uring/opdef.c
> > >> index 3aa0d65c50e3..a2bf53b4a38a 100644
> > >> --- a/io_uring/opdef.c
> > >> +++ b/io_uring/opdef.c
> > >> @@ -306,12 +306,12 @@ const struct io_op_def io_op_defs[] = {
> > >> 
> > >>         },
> > >>         [IORING_OP_FADVISE] = {
> > >>         
> > >>                 .needs_file             = 1,
> > >> 
> > >> -               .audit_skip             = 1,
> > >> 
> > >>                 .name                   = "FADVISE",
> > >>                 .prep                   = io_fadvise_prep,
> > >>                 .issue                  = io_fadvise,
> > >>         
> > >>         },
> > > 
> > > I've never used posix_fadvise() or the associated fadvise64*()
> > > syscalls, but from quickly reading the manpages and the
> > > generic_fadvise() function in the kernel I'm missing where the fadvise
> > > family of functions could be used to truncate a file, can you show me
> > > where this happens?  The closest I can see is the manipulation of the
> > > page cache, but that shouldn't actually modify the file ... right?
> > 
> > Yeah, honestly not sure where that came from. Maybe it's being mixed up
> > with fallocate?
> 
> That was my thought too when I was looking at it.

Oh. Yeah. fallocate is the one that truncates. fadvise can be skipped.

-Steve

> > All fadvise (or madvise, for that matter) does is
> > provide hints on the caching or access pattern. On second thought, both
> > of these should be able to set audit_skip as far as I can tell.
> 
> Agreed on the fadvise side, and probably the madvise side too,
> although the latter has more options/code to sift through so I'm
> curious to hear what analysis Richard has done on that one.




