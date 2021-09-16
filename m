Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2663940DC96
	for <lists+io-uring@lfdr.de>; Thu, 16 Sep 2021 16:19:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236200AbhIPOVM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Sep 2021 10:21:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27190 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236155AbhIPOVM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Sep 2021 10:21:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631801991;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=I5SgVLEas4086/lQL/jidv5o2uhdQC2dIvWnTIvhc88=;
        b=HPO8wPVH04pqHFUp5+enTGD6l9Yj4S0TXbyWZRQ4s/R9xbBTvvf6kPu8fLLE81d8tDmYd7
        ekvT3YyeNqC8/CiA/mAhV4NwEYwqMOJvwUJnSUr8QoniIZUOaus2QAtcskvtwG7hAiIZuI
        iIhIT8428NMB6FMUiDY5BdaUkosfKIw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-381-xhB0Ef0vN-uccA8SO73icg-1; Thu, 16 Sep 2021 10:19:50 -0400
X-MC-Unique: xhB0Ef0vN-uccA8SO73icg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C4598A40C0;
        Thu, 16 Sep 2021 14:19:48 +0000 (UTC)
Received: from madcap2.tricolour.ca (unknown [10.3.128.14])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 65F571B5C0;
        Thu, 16 Sep 2021 14:19:38 +0000 (UTC)
Date:   Thu, 16 Sep 2021 10:19:35 -0400
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Paul Moore <paul@paul-moore.com>
Cc:     linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        linux-audit@redhat.com, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>
Subject: Re: [PATCH v4 2/8] audit,io_uring,io-wq: add some basic audit
 support to io_uring
Message-ID: <20210916141935.GQ490529@madcap2.tricolour.ca>
References: <163172413301.88001.16054830862146685573.stgit@olly>
 <163172457152.88001.12700049763432531651.stgit@olly>
 <20210916133308.GP490529@madcap2.tricolour.ca>
 <CAHC9VhSEj8b7+jH9Atkj3FH+SOdc5iwytxhS3_O1HmTahdj3dQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHC9VhSEj8b7+jH9Atkj3FH+SOdc5iwytxhS3_O1HmTahdj3dQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2021-09-16 10:02, Paul Moore wrote:
> On Thu, Sep 16, 2021 at 9:33 AM Richard Guy Briggs <rgb@redhat.com> wrote:
> > On 2021-09-15 12:49, Paul Moore wrote:
> > > This patch adds basic auditing to io_uring operations, regardless of
> > > their context.  This is accomplished by allocating audit_context
> > > structures for the io-wq worker and io_uring SQPOLL kernel threads
> > > as well as explicitly auditing the io_uring operations in
> > > io_issue_sqe().  Individual io_uring operations can bypass auditing
> > > through the "audit_skip" field in the struct io_op_def definition for
> > > the operation; although great care must be taken so that security
> > > relevant io_uring operations do not bypass auditing; please contact
> > > the audit mailing list (see the MAINTAINERS file) with any questions.
> > >
> > > The io_uring operations are audited using a new AUDIT_URINGOP record,
> > > an example is shown below:
> > >
> > >   type=UNKNOWN[1336] msg=audit(1630523381.288:260):
> > >     uring_op=19 success=yes exit=0 items=0 ppid=853 pid=1204
> > >     uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0
> > >     subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023
> > >     key=(null)
> > >     AUID="root" UID="root" GID="root" EUID="root" SUID="root"
> > >     FSUID="root" EGID="root" SGID="root" FSGID="root"
> > >
> > > Thanks to Richard Guy Briggs for review and feedback.
> >
> > I share Steve's concerns about the missing auid and ses.  The userspace
> > log interpreter conjured up AUID="root" from the absent auid=.
> >
> > Some of the creds are here including ppid, pid, a herd of *id and subj.
> > *Something* initiated this action and then delegated it to iouring to
> > carry out.  That should be in there somewhere.  You had a concern about
> > shared queues and mis-attribution.  All of these creds including auid
> > and ses should be kept together to get this right.
> 
> Look, there are a lot of things about io_uring that frustrate me from
> a security perspective - this is one of them - but I've run out of
> ways to say it's not possible to reliably capture the audit ID or
> session ID here.  With io_uring it is possible to submit an io_uring
> operation, and capture the results, by simply reading and writing to a
> mmap'd buffer.  Yes, it would be nice to have that information, but I
> don't believe there is a practical way to capture it.  If you have any
> suggestions on how to do so, please share, but please make it
> concrete; hand wavy solutions aren't useful at this stage.

I was hoping to give a more concrete solution but have other
distractions at the moment.  My concern is adding it later once the
message format is committed.  We have too many field orderings already.
Recognizing this adds useless characters to the record type at this
time, I'm even thinking auid=? ses=? until a solution can be found.

So you are sure the rest of the creds are correct?

> As for the userspace mysteriously creating an AUID out of thin air,
> that was my mistake: I simply removed the "auid=" field from the
> example and didn't remove the additional fields, e.g. AUID, that
> auditd appends to the end of the record.  I've updated the commit
> description with a freshly generated record and removed the auditd
> bonus bits as those probably shouldn't be shown in an example of a
> kernel generated audit record.  I'm not going to repost the patchset
> just for this small edit to the description, but I have force-pushed
> the update to the selinux/working-io_uring branch.

Understood, no problem here.

> paul moore

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635

