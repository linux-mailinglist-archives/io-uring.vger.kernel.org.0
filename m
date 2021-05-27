Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DCAF3934C0
	for <lists+io-uring@lfdr.de>; Thu, 27 May 2021 19:27:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236968AbhE0R27 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 27 May 2021 13:28:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58432 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236969AbhE0R26 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 27 May 2021 13:28:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622136445;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GzMol78bVGcIW11Te4X3+WhXNCOWxLfeqzpVW8dA0z8=;
        b=iBgcjbIRYyX8OhpdL+75gVHpF25nBHOAsIuL3uKu4DQR0EMr9E1/aYjLMbuVW1hnJ1a78s
        +CqoDw0lO9L3s9Bon66no7ZbtZXi5iBtz7qpdkeLDVRi06KXH4nQp1RgyiCOm0V4uxJy54
        rStNKF138o12I3GA1eEAioadH5sLDb0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-43-ViXTwQLXOR-Ms0fFwaEzDw-1; Thu, 27 May 2021 13:27:23 -0400
X-MC-Unique: ViXTwQLXOR-Ms0fFwaEzDw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3D547801B1E;
        Thu, 27 May 2021 17:27:21 +0000 (UTC)
Received: from madcap2.tricolour.ca (unknown [10.3.128.13])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 43DE75D9DC;
        Thu, 27 May 2021 17:27:10 +0000 (UTC)
Date:   Thu, 27 May 2021 13:27:07 -0400
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Stefan Metzmacher <metze@samba.org>,
        Paul Moore <paul@paul-moore.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        selinux@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-audit@redhat.com, Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [RFC PATCH 2/9] audit,io_uring,io-wq: add some basic audit
 support to io_uring
Message-ID: <20210527172707.GI2268484@madcap2.tricolour.ca>
References: <CAHC9VhRjzWxweB8d8fypUx11CX6tRBnxSWbXH+5qM1virE509A@mail.gmail.com>
 <162219f9-7844-0c78-388f-9b5c06557d06@gmail.com>
 <CAHC9VhSJuddB+6GPS1+mgcuKahrR3UZA=1iO8obFzfRE7_E0gA@mail.gmail.com>
 <8943629d-3c69-3529-ca79-d7f8e2c60c16@kernel.dk>
 <CAHC9VhTYBsh4JHhqV0Uyz=H5cEYQw48xOo=CUdXV0gDvyifPOQ@mail.gmail.com>
 <0a668302-b170-31ce-1651-ddf45f63d02a@gmail.com>
 <CAHC9VhTAvcB0A2dpv1Xn7sa+Kh1n+e-dJr_8wSSRaxS4D0f9Sw@mail.gmail.com>
 <18823c99-7d65-0e6f-d508-a487f1b4b9e7@samba.org>
 <20210526154905.GJ447005@madcap2.tricolour.ca>
 <aaa98bcc-0515-f0e4-f15f-058ef0eb61e7@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aaa98bcc-0515-f0e4-f15f-058ef0eb61e7@kernel.dk>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2021-05-26 11:22, Jens Axboe wrote:
> On 5/26/21 9:49 AM, Richard Guy Briggs wrote:
> >> So why is there anything special needed for io_uring (now that the
> >> native worker threads are used)?
> > 
> > Because syscall has been bypassed by a memory-mapped work queue.
> 
> I don't follow this one at all, that's just the delivery mechanism if
> you choose to use SQPOLL. If you do, then a thread sibling of the
> original task does the actual system call. There's no magic involved
> there, and the tasks are related.
> 
> So care to expand on that?

These may be poor examples, but hear me out...

In the case of an open call, I'm guessing that they are mapped 1:1
syscall to io_uring action so that the action can be asynchronous.  So
in this case, there is a record of the action, but we don't see the
result success/failure.  I assume that file paths can only be specified
in the original syscall and not in an SQPOLL action?

In the case of a syscall read/write (which aren't as interesting
generally to audit, but I'm concerned there are other similar situations
that are), the syscall would be called for every buffer that is passed
back and forth user/kernel and vice versa, providing a way to log all
that activity.  In the case of SQPOLL, I understand that a syscall sets
up the action and then io_uring takes over and does the bulk transfer
and we'd not have the visibility of how many times that action was
repeated nor that the result success/failure was due to its asynchrony.

Perhaps I am showing my ignorance, so please correct me if I have it
wrong.

> >> Is there really any io_uring opcode that bypasses the security checks the corresponding native syscall
> >> would do? If so, I think that should just be fixed...
> > 
> > This is by design to speed it up.  This is what Paul's iouring entry and
> > exit hooks do.
> 
> As far as I can tell, we're doing double logging at that point, if the
> syscall helper does the audit as well. We'll get something logging the
> io_uring opcode (eg IORING_OP_OPENAT2), then log again when we call the
> fs helper. That's _assuming_ that we always hit the logging part when we
> call into the vfs, but that's something that can be updated to be true
> and kept an eye on for future additions.
> 
> Why is the double logging useful? It only tells you that the invocation
> was via io_uring as the delivery mechanism rather than the usual system
> call, but the effect is the same - the file is opened, for example.
> 
> I feel like I'm missing something here, or the other side is. Or both!

Paul addressed this in his reply, but let me add a more concrete
example...  There was one corner case I was looking at that showed up
this issue.  Please indicate if I have mischaracterized or
misunderstood.

A syscall would generate records something like this:

	AUDIT_SYSCALL
	AUDIT_...
	AUDIT_EOE

A io_uring SQPOLL event would generate something like this:

	AUDIT_URINGOP
	AUDIT_...
	AUDIT_EOE

The "hybrid" event that is a syscall that starts an io_uring action
would generate something like this:

	AUDIT_URINGOP
	[possible AUDIT_CONFIG_CHANGE (from killed_trees)]
	AUDIT_SYSCALL
	AUDIT_...
	AUDIT_EOE

The AUDIT_... is all the operation-specific records that log parameters
that aren't able to be expressed in the SYSLOG or URINGOP records such
as pathnames, other arguments, and context (pwd, etc...).  So this isn't
"double logging".  It is either introducing an io_uring event, or it is
providing more detail about the io_uring arguments to a syscall event.

> Jens Axboe

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635

