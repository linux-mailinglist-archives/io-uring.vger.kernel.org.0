Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA806398ECF
	for <lists+io-uring@lfdr.de>; Wed,  2 Jun 2021 17:38:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230479AbhFBPkB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 2 Jun 2021 11:40:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35521 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231617AbhFBPj5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 2 Jun 2021 11:39:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622648293;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OoDYbRr379F6FTuv88EzuNEkheMz0XG6rFrrTSsT7nk=;
        b=gRGXLElDwmv8Se0NFCpD5M3wQNlROFgbJu4q77BF1aGe0CJpDnPTZeFFRGrlB1W3Sc7nSZ
        pgLqliRmWxR+Sktlxls4Zwf0Pv3t26bympZ8i6dkUcVsWaydxucnywWW6oTL+F7O25xdM0
        31zvL3bIXJ+c9Uw0JW2cD17JAi4EMfw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-51-AvKItOf-O5GpYddClO36OQ-1; Wed, 02 Jun 2021 11:38:10 -0400
X-MC-Unique: AvKItOf-O5GpYddClO36OQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 740BC6D251;
        Wed,  2 Jun 2021 15:38:08 +0000 (UTC)
Received: from madcap2.tricolour.ca (unknown [10.3.128.13])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4F61860938;
        Wed,  2 Jun 2021 15:38:00 +0000 (UTC)
Date:   Wed, 2 Jun 2021 11:37:57 -0400
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Paul Moore <paul@paul-moore.com>
Cc:     linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        linux-audit@redhat.com, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [RFC PATCH 4/9] audit: add filtering for io_uring records
Message-ID: <20210602153757.GQ2268484@madcap2.tricolour.ca>
References: <162163367115.8379.8459012634106035341.stgit@sifl>
 <162163380685.8379.17381053199011043757.stgit@sifl>
 <20210528223544.GL447005@madcap2.tricolour.ca>
 <CAHC9VhTr_hw_RBPf5yGD16j-qV2tbjjPJkimMNNQZBHtrJDbuQ@mail.gmail.com>
 <20210531134408.GL2268484@madcap2.tricolour.ca>
 <CAHC9VhSFNNE7AGGA20fDk201VLvzr5HB60VEqqq5qt9yGTH4mg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHC9VhSFNNE7AGGA20fDk201VLvzr5HB60VEqqq5qt9yGTH4mg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2021-06-01 21:40, Paul Moore wrote:
> On Mon, May 31, 2021 at 9:44 AM Richard Guy Briggs <rgb@redhat.com> wrote:
> > On 2021-05-30 11:26, Paul Moore wrote:
> > > On Fri, May 28, 2021 at 6:36 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > > > On 2021-05-21 17:50, Paul Moore wrote:
> > > > If we abuse the syscall infrastructure at first, we'd need a transition
> > > > plan to coordinate user and kernel switchover to seperate mechanisms for
> > > > the two to work together if the need should arise to have both syscall
> > > > and uring filters in the same rule.
> > >
> > > See my comments above, I don't currently see why we would ever want
> > > syscall and io_uring filtering to happen in the same rule.  Please
> > > speak up if you can think of a reason why this would either be needed,
> > > or desirable for some reason.
> >
> > I think they can be seperate rules for now.  Either a syscall rule
> > catching all io_uring ops can be added, or an io_uring rule can be added
> > to catch specific ops.  The scenario I was thinking of was catching
> > syscalls of specific io_uring ops.
> 
> Perhaps I'm misunderstand you, but that scenario really shouldn't
> exist.  The io_uring ops function independently of syscalls; you can
> *submit* io_uring ops via io_uring_enter(), but they are not
> guaranteed to be dispatched synchronously (obviously), and given the
> cred shenanigans that can happen with io_uring there is no guarantee
> the filters would even be applicable.

That wasn't my understanding.  There are a number of io_uring calls
starting with at least open that are currently synchronous (but may
become async in future) that we may want to single out which would be a
specific io_uring syscall with a specific io_uring opcode.  I guess
that particular situation would be caught by the io_uring opcode
triggering an event that includes SYSCALL and URINGOP records.

> It isn't an issue of "can" the filters be separate, they *have* to be separate.

> paul moore

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635

