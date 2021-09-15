Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7166440C543
	for <lists+io-uring@lfdr.de>; Wed, 15 Sep 2021 14:29:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234393AbhIOMan (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Sep 2021 08:30:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40386 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234079AbhIOMan (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Sep 2021 08:30:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631708963;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5J+TJY2OKQSmsTLw8RNIuTywLH66g7pwySr+szl2Xlk=;
        b=cr/zd3lhZSMQH8Iv8pKhXu7tWFgd8V3G6+U/tPKgDJUajAREk1DeIBYI/uxl8+fgl99hGR
        rYIjqoXwrBiNklE6pDgx2FzLGdoR6vSdp89822/i79WEhx4Tj8XIluNgW+6NYPRt0R5/Uh
        4zsSawrLOL1rRc9cVrHus+/ZFsfPgTI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-145-UU_MlMC5NhW1OlLf5NUaTw-1; Wed, 15 Sep 2021 08:29:22 -0400
X-MC-Unique: UU_MlMC5NhW1OlLf5NUaTw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CAEBB80124F;
        Wed, 15 Sep 2021 12:29:20 +0000 (UTC)
Received: from madcap2.tricolour.ca (unknown [10.3.128.14])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EA64D19736;
        Wed, 15 Sep 2021 12:29:10 +0000 (UTC)
Date:   Wed, 15 Sep 2021 08:29:08 -0400
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Paul Moore <paul@paul-moore.com>
Cc:     sgrubb@redhat.com, linux-security-module@vger.kernel.org,
        selinux@vger.kernel.org, linux-audit@redhat.com,
        io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [RFC PATCH v2 0/9] Add LSM access controls and auditing to
 io_uring
Message-ID: <20210915122907.GM490529@madcap2.tricolour.ca>
References: <CAHC9VhTkZ-tUdrFjhc2k1supzW1QJpY-15pf08mw6=ynU9yY5g@mail.gmail.com>
 <20210827133559.GG490529@madcap2.tricolour.ca>
 <CAHC9VhRqSO6+MVX+LYBWHqwzd3QYgbSz3Gd8E756J0QNEmmHdQ@mail.gmail.com>
 <20210828150356.GH490529@madcap2.tricolour.ca>
 <CAHC9VhRgc_Fhi4c6L__butuW7cmSFJxTMxb+BBn6P-8Yt0ck_w@mail.gmail.com>
 <CAHC9VhQD8hKekqosjGgWPxZFqS=EFy-_kQL5zAo1sg0MU=6n5A@mail.gmail.com>
 <20210910005858.GL490529@madcap2.tricolour.ca>
 <CAHC9VhSRJYW7oRq6iLCH_UYukeFfE0pEJ_wBLdr1mw2QGUPh-Q@mail.gmail.com>
 <CAHC9VhTrimTds_miuyRhhHjoG_Fhmk2vH7G3hKeeFWO3BdLpKw@mail.gmail.com>
 <CAHC9VhTUKsijBVV-a3eHajYyOFYLQPWTTqxJ812NnB3_Y=UMeQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHC9VhTUKsijBVV-a3eHajYyOFYLQPWTTqxJ812NnB3_Y=UMeQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2021-09-13 22:49, Paul Moore wrote:
> On Mon, Sep 13, 2021 at 9:50 PM Paul Moore <paul@paul-moore.com> wrote:
> > On Mon, Sep 13, 2021 at 3:23 PM Paul Moore <paul@paul-moore.com> wrote:
> > > On Thu, Sep 9, 2021 at 8:59 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > > > On 2021-09-01 15:21, Paul Moore wrote:
> > > > > On Sun, Aug 29, 2021 at 11:18 AM Paul Moore <paul@paul-moore.com> wrote:
> > > > > > On Sat, Aug 28, 2021 at 11:04 AM Richard Guy Briggs <rgb@redhat.com> wrote:
> > > > > > > I did set a syscall filter for
> > > > > > >         -a exit,always -F arch=b64 -S io_uring_enter,io_uring_setup,io_uring_register -F key=iouringsyscall
> > > > > > > and that yielded some records with a couple of orphans that surprised me
> > > > > > > a bit.
> > > > > >
> > > > > > Without looking too closely at the log you sent, you can expect URING
> > > > > > records without an associated SYSCALL record when the uring op is
> > > > > > being processed in the io-wq or sqpoll context.  In the io-wq case the
> > > > > > processing is happening after the thread finished the syscall but
> > > > > > before the execution context returns to userspace and in the case of
> > > > > > sqpoll the processing is handled by a separate kernel thread with no
> > > > > > association to a process thread.
> > > > >
> > > > > I spent some time this morning/afternoon playing with the io_uring
> > > > > audit filtering capability and with your audit userspace
> > > > > ghau-iouring-filtering.v1.0 branch it appears to work correctly.  Yes,
> > > > > the userspace tooling isn't quite 100% yet (e.g. `auditctl -l` doesn't
> > > > > map the io_uring ops correctly), but I know you mentioned you have a
> > > > > number of fixes/improvements still as a work-in-progress there so I'm
> > > > > not too concerned.  The important part is that the kernel pieces look
> > > > > to be working correctly.
> > > >
> > > > Ok, I have squashed and pushed the audit userspace support for iouring:
> > > >         https://github.com/rgbriggs/audit-userspace/commit/e8bd8d2ea8adcaa758024cb9b8fa93895ae35eea
> > > >         https://github.com/linux-audit/audit-userspace/compare/master...rgbriggs:ghak-iouring-filtering.v2.1
> > > > There are test rpms for f35 here:
> > > >         http://people.redhat.com/~rbriggs/ghak-iouring/git-e8bd8d2-fc35/
> > > >
> > > > userspace v2 changelog:
> > > > - check for watch before adding perm
> > > > - update manpage to include filesystem filter
> > > > - update support for the uring filter list: doc, -U op, op names
> > > > - add support for the AUDIT_URINGOP record type
> > > > - add uringop support to ausearch
> > > > - add uringop support to aureport
> > > > - lots of bug fixes
> > > >
> > > > "auditctl -a uring,always -S ..." will now throw an error and require
> > > > "-U" instead.
> > >
> > > Thanks Richard.
> > >
> > > FYI, I rebased the io_uring/LSM/audit patchset on top of v5.15-rc1
> > > today and tested both with your v1.0 and with your v2.1 branch and the
> > > various combinations seemed to work just fine (of course the v2.1
> > > userspace branch was more polished, less warts, etc.).  I'm going to
> > > go over the patch set one more time to make sure everything is still
> > > looking good, write up an updated cover letter, and post a v3 revision
> > > later tonight with the hope of merging it into -next later this week.
> >
> > Best laid plans of mice and men ...
> >
> > It turns out the LSM hook macros are full of warnings-now-errors that
> > should likely be resolved before sending anything LSM related to
> > Linus.  I'll post v3 once I fix this, which may not be until tomorrow.
> >
> > (To be clear, the warnings/errors aren't new to this patchset, I'm
> > likely just the first person to notice them.)
> 
> Actually, scratch that ... I'm thinking that might just be an oddity
> of the Intel 0day test robot building for the xtensa arch.  I'll post
> the v3 patchset tonight.

I was in the middle of reviewing the v2 patchset to add my acks when I
forgot to add the comment that you still haven't convinced me that ses=
isn't needed or relevant if we are including auid=.

> paul moore

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635

