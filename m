Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1683A406496
	for <lists+io-uring@lfdr.de>; Fri, 10 Sep 2021 03:01:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234656AbhIJBCS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 9 Sep 2021 21:02:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21833 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231357AbhIJBAa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 9 Sep 2021 21:00:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631235554;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rEYBK0tEXu7q0azGTgiJfTmsZEZVrhulDelo/AmjQLo=;
        b=STF4/ZihYH5UsMM77Y/fjcqhSui4izuSaZTxuWdtDJ/JBS1APiZ5KkzzTsHzsVT1JbwFhz
        dOOuO/22ztR/xQW1aACqCGic/ijJecBszxuadVeEqVInI7uj6lgGJylfrOWRKRtkrwapuf
        oTP4tmGXsJDagh7+4zeS+zpaLMdez/o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-581-nO22jQVyOLC4bLxymQTwYg-1; Thu, 09 Sep 2021 20:59:13 -0400
X-MC-Unique: nO22jQVyOLC4bLxymQTwYg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 03CC11084685;
        Fri, 10 Sep 2021 00:59:12 +0000 (UTC)
Received: from madcap2.tricolour.ca (unknown [10.3.128.14])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9A4D819D9B;
        Fri, 10 Sep 2021 00:59:01 +0000 (UTC)
Date:   Thu, 9 Sep 2021 20:58:58 -0400
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Paul Moore <paul@paul-moore.com>, sgrubb@redhat.com
Cc:     linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        linux-audit@redhat.com, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [RFC PATCH v2 0/9] Add LSM access controls and auditing to
 io_uring
Message-ID: <20210910005858.GL490529@madcap2.tricolour.ca>
References: <20210824205724.GB490529@madcap2.tricolour.ca>
 <20210826011639.GE490529@madcap2.tricolour.ca>
 <CAHC9VhSADQsudmD52hP8GQWWR4+=sJ7mvNkh9xDXuahS+iERVA@mail.gmail.com>
 <20210826163230.GF490529@madcap2.tricolour.ca>
 <CAHC9VhTkZ-tUdrFjhc2k1supzW1QJpY-15pf08mw6=ynU9yY5g@mail.gmail.com>
 <20210827133559.GG490529@madcap2.tricolour.ca>
 <CAHC9VhRqSO6+MVX+LYBWHqwzd3QYgbSz3Gd8E756J0QNEmmHdQ@mail.gmail.com>
 <20210828150356.GH490529@madcap2.tricolour.ca>
 <CAHC9VhRgc_Fhi4c6L__butuW7cmSFJxTMxb+BBn6P-8Yt0ck_w@mail.gmail.com>
 <CAHC9VhQD8hKekqosjGgWPxZFqS=EFy-_kQL5zAo1sg0MU=6n5A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHC9VhQD8hKekqosjGgWPxZFqS=EFy-_kQL5zAo1sg0MU=6n5A@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2021-09-01 15:21, Paul Moore wrote:
> On Sun, Aug 29, 2021 at 11:18 AM Paul Moore <paul@paul-moore.com> wrote:
> > On Sat, Aug 28, 2021 at 11:04 AM Richard Guy Briggs <rgb@redhat.com> wrote:
> > > I did set a syscall filter for
> > >         -a exit,always -F arch=b64 -S io_uring_enter,io_uring_setup,io_uring_register -F key=iouringsyscall
> > > and that yielded some records with a couple of orphans that surprised me
> > > a bit.
> >
> > Without looking too closely at the log you sent, you can expect URING
> > records without an associated SYSCALL record when the uring op is
> > being processed in the io-wq or sqpoll context.  In the io-wq case the
> > processing is happening after the thread finished the syscall but
> > before the execution context returns to userspace and in the case of
> > sqpoll the processing is handled by a separate kernel thread with no
> > association to a process thread.
> 
> I spent some time this morning/afternoon playing with the io_uring
> audit filtering capability and with your audit userspace
> ghau-iouring-filtering.v1.0 branch it appears to work correctly.  Yes,
> the userspace tooling isn't quite 100% yet (e.g. `auditctl -l` doesn't
> map the io_uring ops correctly), but I know you mentioned you have a
> number of fixes/improvements still as a work-in-progress there so I'm
> not too concerned.  The important part is that the kernel pieces look
> to be working correctly.

Ok, I have squashed and pushed the audit userspace support for iouring:
	https://github.com/rgbriggs/audit-userspace/commit/e8bd8d2ea8adcaa758024cb9b8fa93895ae35eea
	https://github.com/linux-audit/audit-userspace/compare/master...rgbriggs:ghak-iouring-filtering.v2.1
There are test rpms for f35 here:
	http://people.redhat.com/~rbriggs/ghak-iouring/git-e8bd8d2-fc35/

userspace v2 changelog:
- check for watch before adding perm
- update manpage to include filesystem filter
- update support for the uring filter list: doc, -U op, op names
- add support for the AUDIT_URINGOP record type
- add uringop support to ausearch
- add uringop support to aureport
- lots of bug fixes

"auditctl -a uring,always -S ..." will now throw an error and require
"-U" instead.

> As usual, if you notice anything awry while playing with the userspace
> changes please let me know.

Same for userspace...  I think I already see one mapping uring op names
in ausearch...

> paul moore

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635

