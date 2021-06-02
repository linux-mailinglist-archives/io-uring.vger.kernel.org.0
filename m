Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44C1A398F31
	for <lists+io-uring@lfdr.de>; Wed,  2 Jun 2021 17:46:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232246AbhFBPsg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 2 Jun 2021 11:48:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22568 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232079AbhFBPsg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 2 Jun 2021 11:48:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622648812;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VHIsflmb9bo7+7z4ppg/I+v72fjIcbK96I8VFOpCXh8=;
        b=XH9OmckizezjF4RAMxVaEPAx7hYSaRmk4E3/BgXyJseVdXapbaRLGGKfdZms+S4+wtDQBR
        MY4pKs3O20pxf1OuXbQTTrpoKXUiWvIUH97iu+A/M36oLj/SWvQ0ehf/NG9JWOqEpQFmod
        rkPSpVZUo5l0aRy0cZQZGQonyw+alxI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-537--p8Xm_ZOMI6igpusBMRAAg-1; Wed, 02 Jun 2021 11:46:51 -0400
X-MC-Unique: -p8Xm_ZOMI6igpusBMRAAg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D1AFB180E46D;
        Wed,  2 Jun 2021 15:46:49 +0000 (UTC)
Received: from madcap2.tricolour.ca (unknown [10.3.128.13])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E9CCA100238C;
        Wed,  2 Jun 2021 15:46:40 +0000 (UTC)
Date:   Wed, 2 Jun 2021 11:46:38 -0400
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Paul Moore <paul@paul-moore.com>, Jens Axboe <axboe@kernel.dk>,
        selinux@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-audit@redhat.com, Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [RFC PATCH 2/9] audit,io_uring,io-wq: add some basic audit
 support to io_uring
Message-ID: <20210602154638.GA3711857@madcap2.tricolour.ca>
References: <CAHC9VhTYBsh4JHhqV0Uyz=H5cEYQw48xOo=CUdXV0gDvyifPOQ@mail.gmail.com>
 <9e69e4b6-2b87-a688-d604-c7f70be894f5@kernel.dk>
 <3bef7c8a-ee70-d91d-74db-367ad0137d00@kernel.dk>
 <fa7bf4a5-5975-3e8c-99b4-c8d54c57da10@kernel.dk>
 <a7669e4a-e7a7-7e94-f6ce-fa48311f7175@kernel.dk>
 <CAHC9VhSKPzADh=qcPp7r7ZVD2cpr2m8kQsui43LAwPr-9BNaxQ@mail.gmail.com>
 <b20f0373-d597-eb0e-5af3-6dcd8c6ba0dc@kernel.dk>
 <CAHC9VhRZEwtsxjhpZM1DXGNJ9yL59B7T_p2B60oLmC_YxCrOiw@mail.gmail.com>
 <CAHC9VhSK9PQdxvXuCA2NMC3UUEU=imCz_n7TbWgKj2xB2T=fOQ@mail.gmail.com>
 <94e50554-f71a-50ab-c468-418863d2b46f@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <94e50554-f71a-50ab-c468-418863d2b46f@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2021-06-02 09:26, Pavel Begunkov wrote:
> On 5/28/21 5:02 PM, Paul Moore wrote:
> > On Wed, May 26, 2021 at 4:19 PM Paul Moore <paul@paul-moore.com> wrote:
> >> ... If we moved the _entry
> >> and _exit calls into the individual operation case blocks (quick
> >> openat example below) so that only certain operations were able to be
> >> audited would that be acceptable assuming the high frequency ops were
> >> untouched?  My initial gut feeling was that this would involve >50% of
> >> the ops, but Steve Grubb seems to think it would be less; it may be
> >> time to look at that a bit more seriously, but if it gets a NACK
> >> regardless it isn't worth the time - thoughts?
> >>
> >>   case IORING_OP_OPENAT:
> >>     audit_uring_entry(req->opcode);
> >>     ret = io_openat(req, issue_flags);
> >>     audit_uring_exit(!ret, ret);
> >>     break;
> > 
> > I wanted to pose this question again in case it was lost in the
> > thread, I suspect this may be the last option before we have to "fix"
> > things at the Kconfig level.  I definitely don't want to have to go
> > that route, and I suspect most everyone on this thread feels the same,
> > so I'm hopeful we can find a solution that is begrudgingly acceptable
> > to both groups.
> 
> May work for me, but have to ask how many, and what is the
> criteria? I'd think anything opening a file or manipulating fs:
> 
> IORING_OP_ACCEPT, IORING_OP_CONNECT, IORING_OP_OPENAT[2],
> IORING_OP_RENAMEAT, IORING_OP_UNLINKAT, IORING_OP_SHUTDOWN,
> IORING_OP_FILES_UPDATE
> + coming mkdirat and others.
> 
> IORING_OP_CLOSE? IORING_OP_SEND IORING_OP_RECV?
> 
> What about?
> IORING_OP_FSYNC, IORING_OP_SYNC_FILE_RANGE,
> IORING_OP_FALLOCATE, IORING_OP_STATX,
> IORING_OP_FADVISE, IORING_OP_MADVISE,
> IORING_OP_EPOLL_CTL
> 
> 
> Another question, io_uring may exercise asynchronous paths,
> i.e. io_issue_sqe() returns before requests completes.
> Shouldn't be the case for open/etc at the moment, but was that
> considered?

This would be why audit needs to monitor a thread until it wraps up, to
wait for the result code.  My understanding is that both sync and async
parts of an op would be monitored.

> I don't see it happening, but would prefer to keep it open
> async reimplementation in a distant future. Does audit sleep?

Some parts do, some parts don't depending on what they are interacting
with in the kernel.  It can be made to not sleep if needed.

> Pavel Begunkov

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635

