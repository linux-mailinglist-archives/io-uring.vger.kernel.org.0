Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F3DB3FA65C
	for <lists+io-uring@lfdr.de>; Sat, 28 Aug 2021 17:04:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233953AbhH1PFE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 28 Aug 2021 11:05:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32650 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230290AbhH1PFE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 28 Aug 2021 11:05:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630163053;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wglBM2MJS2lBJlgPHQBwj1WY2WdgpcdiWGWzu/KrEVc=;
        b=fBycUlj4zj7GNEirrbuStbeuQAlv1valqVlTors8xFQ6HcMd5Jh/QegxQOn/R8H6bep18z
        ZATndREgDwEWJS+dEI1hcJmxiBeiCoz9WDORIRbvDZogomjLyguMSdKMamI0DvVrSSAu1b
        uJXZqLAh7FobIIxQYsrgtOagystGMwY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-267-lyzpeIZ6MuKCbueB33J4iQ-1; Sat, 28 Aug 2021 11:04:09 -0400
X-MC-Unique: lyzpeIZ6MuKCbueB33J4iQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D44EF1082923;
        Sat, 28 Aug 2021 15:04:07 +0000 (UTC)
Received: from madcap2.tricolour.ca (unknown [10.3.128.14])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A02AE18428;
        Sat, 28 Aug 2021 15:03:59 +0000 (UTC)
Date:   Sat, 28 Aug 2021 11:03:56 -0400
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Paul Moore <paul@paul-moore.com>
Cc:     linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        linux-audit@redhat.com, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [RFC PATCH v2 0/9] Add LSM access controls and auditing to
 io_uring
Message-ID: <20210828150356.GH490529@madcap2.tricolour.ca>
References: <162871480969.63873.9434591871437326374.stgit@olly>
 <20210824205724.GB490529@madcap2.tricolour.ca>
 <20210826011639.GE490529@madcap2.tricolour.ca>
 <CAHC9VhSADQsudmD52hP8GQWWR4+=sJ7mvNkh9xDXuahS+iERVA@mail.gmail.com>
 <20210826163230.GF490529@madcap2.tricolour.ca>
 <CAHC9VhTkZ-tUdrFjhc2k1supzW1QJpY-15pf08mw6=ynU9yY5g@mail.gmail.com>
 <20210827133559.GG490529@madcap2.tricolour.ca>
 <CAHC9VhRqSO6+MVX+LYBWHqwzd3QYgbSz3Gd8E756J0QNEmmHdQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="45Z9DzgjV8m4Oswq"
Content-Disposition: inline
In-Reply-To: <CAHC9VhRqSO6+MVX+LYBWHqwzd3QYgbSz3Gd8E756J0QNEmmHdQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


--45Z9DzgjV8m4Oswq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2021-08-27 15:49, Paul Moore wrote:
> On Fri, Aug 27, 2021 at 9:36 AM Richard Guy Briggs <rgb@redhat.com> wrote:
> > On 2021-08-26 15:14, Paul Moore wrote:
> > > On Thu, Aug 26, 2021 at 12:32 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > > > I'm getting:
> > > >         # ./iouring.2
> > > >         Kernel thread io_uring-sq is not running.
> > > >         Unable to setup io_uring: Permission denied
> > > >
> > > >         # ./iouring.3s
> > > >         >>> server started, pid = 2082
> > > >         >>> memfd created, fd = 3
> > > >         io_uring_queue_init: Permission denied
> > > >
> > > > I have CONFIG_IO_URING=y set, what else is needed?
> > >
> > > I'm not sure how you tried to run those tests, but try running as root
> > > and with SELinux in permissive mode.
> >
> > Ok, they ran, including iouring.4.  iouring.2 claimed twice: "Kernel
> > thread io_uring-sq is not running." and I didn't get any URING records
> > with ausearch.  I don't know if any of this is expected.
> 
> Now that I've written iouring.4, I would skip the others; while
> helpful at the time, they are pretty crap.

Ok.

> I have no idea what kernel you are running, but I'm going to assume
> you've applied the v2 patches (if not, you obviously need to do that
> <g>).  Beyond that you may need to set a filter for the
> io_uring_enter() syscall to force the issue; theoretically your audit
> userspace patches should allow a uring op specifically to be filtered
> but I haven't had a chance to try that yet so either the kernel or
> userspace portion could be broken.

I'm running audit/next (on 5.14-rc1) with your v2 patches.

I did set a syscall filter for
	-a exit,always -F arch=b64 -S io_uring_enter,io_uring_setup,io_uring_register -F key=iouringsyscall
and that yielded some records with a couple of orphans that surprised me
a bit.  I've attached that log.  I was a bit surprised there were no
records for ./iouring.3*.

I'm now testing the new "-a uring,always -U ..." to get that userspace
code working as expected...

> At this point if you are running into problems you'll probably need to
> spend some time debugging them, as I think you're the only person who
> has tested your audit userspace patches at this point (and the only
> one who has access to your latest bits).

Yes, I'll do some basic debugging and then publish to avoid wasting
people's time on silly bugs, but to get help on the more serious ones.

> paul moore

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635

--45Z9DzgjV8m4Oswq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="audit.log-2021-08-27-1"

----
type=PROCTITLE msg=audit(2021-08-27 16:41:56.190:328) : proctitle=auditctl -a exit,always -F arch b64 -S io_uring_enter,io_uring_setup,io_uring_register -F key=iouringsyscall 
type=SYSCALL msg=audit(2021-08-27 16:41:56.190:328) : arch=x86_64 syscall=sendto success=yes exit=1072 a0=0x4 a1=0x7ffff3e0dc10 a2=0x430 a3=0x0 items=0 ppid=543 pid=12433 auid=root uid=root gid=root euid=root suid=root fsuid=root egid=root sgid=root fsgid=root tty=ttyS0 ses=1 comm=auditctl exe=/usr/sbin/auditctl subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 key=(null) 
type=CONFIG_CHANGE msg=audit(2021-08-27 16:41:56.190:328) : auid=root ses=1 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 op=add_rule key=iouringsyscall list=exit res=yes 
----
type=PROCTITLE msg=audit(2021-08-27 16:42:22.032:329) : proctitle=./iouring.2 
type=SYSCALL msg=audit(2021-08-27 16:42:22.032:329) : arch=x86_64 syscall=io_uring_setup success=yes exit=3 a0=0x8 a1=0x7fff6037b890 a2=0x7f38ee9de7a7 a3=0x3 items=0 ppid=543 pid=12437 auid=root uid=root gid=root euid=root suid=root fsuid=root egid=root sgid=root fsgid=root tty=ttyS0 ses=1 comm=iouring.2 exe=/root/rgb/testing/iouring/iouring.2 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 key=iouringsyscall 
----
type=PROCTITLE msg=audit(2021-08-27 16:42:22.034:330) : proctitle=./iouring.2 
type=MMAP msg=audit(2021-08-27 16:42:22.034:330) : fd=3 flags=MAP_SHARED|MAP_POPULATE 
type=SYSCALL msg=audit(2021-08-27 16:42:22.034:330) : arch=x86_64 syscall=mmap success=yes exit=139882499366912 a0=0x0 a1=0x260 a2=PROT_READ|PROT_WRITE a3=MAP_SHARED|MAP_POPULATE items=0 ppid=543 pid=12437 auid=root uid=root gid=root euid=root suid=root fsuid=root egid=root sgid=root fsgid=root tty=ttyS0 ses=1 comm=iouring.2 exe=/root/rgb/testing/iouring/iouring.2 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 key=(null) 
type=AVC msg=audit(2021-08-27 16:42:22.034:330) : avc:  denied  { write } for  pid=12437 comm=iouring.2 path=anon_inode:[io_uring] dev="anon_inodefs" ino=26726 scontext=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 tcontext=unconfined_u:object_r:unconfined_t:s0 tclass=anon_inode permissive=1 
type=AVC msg=audit(2021-08-27 16:42:22.034:330) : avc:  denied  { map } for  pid=12437 comm=iouring.2 path=anon_inode:[io_uring] dev="anon_inodefs" ino=26726 scontext=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 tcontext=unconfined_u:object_r:unconfined_t:s0 tclass=anon_inode permissive=1 
----
type=PROCTITLE msg=audit(2021-08-27 16:42:22.036:331) : proctitle=./iouring.2 
type=SYSCALL msg=audit(2021-08-27 16:42:22.036:331) : arch=x86_64 syscall=io_uring_register success=yes exit=0 a0=0x3 a1=0x2 a2=0x7fff6037b854 a3=0x1 items=0 ppid=543 pid=12437 auid=root uid=root gid=root euid=root suid=root fsuid=root egid=root sgid=root fsgid=root tty=ttyS0 ses=1 comm=iouring.2 exe=/root/rgb/testing/iouring/iouring.2 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 key=iouringsyscall 
----
type=PROCTITLE msg=audit(2021-08-27 16:42:22.037:332) : proctitle=./iouring.2 
type=SYSCALL msg=audit(2021-08-27 16:42:22.037:332) : arch=x86_64 syscall=io_uring_enter success=yes exit=2 a0=0x3 a1=0x2 a2=0x0 a3=0x2 items=0 ppid=543 pid=12437 auid=root uid=root gid=root euid=root suid=root fsuid=root egid=root sgid=root fsgid=root tty=ttyS0 ses=1 comm=iouring.2 exe=/root/rgb/testing/iouring/iouring.2 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 key=iouringsyscall 
----
type=PROCTITLE msg=audit(2021-08-27 16:42:22.037:333) : proctitle=./iouring.2 
type=SYSCALL msg=audit(2021-08-27 16:42:22.037:333) : arch=x86_64 syscall=io_uring_enter success=yes exit=0 a0=0x3 a1=0x0 a2=0x1 a3=0x1 items=0 ppid=543 pid=12437 auid=root uid=root gid=root euid=root suid=root fsuid=root egid=root sgid=root fsgid=root tty=ttyS0 ses=1 comm=iouring.2 exe=/root/rgb/testing/iouring/iouring.2 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 key=iouringsyscall 
----
type=PROCTITLE msg=audit(2021-08-27 16:42:22.038:334) : proctitle=./iouring.2 
type=SYSCALL msg=audit(2021-08-27 16:42:22.038:334) : arch=x86_64 syscall=io_uring_enter success=yes exit=0 a0=0x3 a1=0x0 a2=0x1 a3=0x1 items=0 ppid=543 pid=12437 auid=root uid=root gid=root euid=root suid=root fsuid=root egid=root sgid=root fsgid=root tty=ttyS0 ses=1 comm=iouring.2 exe=/root/rgb/testing/iouring/iouring.2 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 key=iouringsyscall 
----
type=PROCTITLE msg=audit(2021-08-27 16:42:22.084:335) : proctitle=./iouring.2 
type=SYSCALL msg=audit(2021-08-27 16:42:22.084:335) : arch=x86_64 syscall=io_uring_enter success=yes exit=0 a0=0x3 a1=0x0 a2=0x1 a3=0x1 items=0 ppid=543 pid=12437 auid=root uid=root gid=root euid=root suid=root fsuid=root egid=root sgid=root fsgid=root tty=ttyS0 ses=1 comm=iouring.2 exe=/root/rgb/testing/iouring/iouring.2 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 key=iouringsyscall 
----
type=PROCTITLE msg=audit(2021-08-27 16:42:30.624:336) : proctitle=./iouring.4 sqpoll 
type=SYSCALL msg=audit(2021-08-27 16:42:30.624:336) : arch=x86_64 syscall=io_uring_setup success=yes exit=4 a0=0x8 a1=0x7fefe5ac10d8 a2=0x7fefe5ac10d8 a3=0x3 items=0 ppid=543 pid=12447 auid=root uid=root gid=root euid=root suid=root fsuid=root egid=root sgid=root fsgid=root tty=ttyS0 ses=1 comm=iouring.4 exe=/root/rgb/testing/iouring/iouring.4 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 key=iouringsyscall 
----
type=PROCTITLE msg=audit(2021-08-27 16:42:30.625:337) : proctitle=./iouring.4 sqpoll 
type=SYSCALL msg=audit(2021-08-27 16:42:30.625:337) : arch=x86_64 syscall=io_uring_register success=yes exit=1 a0=0x4 a1=0x9 a2=0x0 a3=0x0 items=0 ppid=543 pid=12447 auid=root uid=root gid=root euid=root suid=root fsuid=root egid=root sgid=root fsgid=root tty=ttyS0 ses=1 comm=iouring.4 exe=/root/rgb/testing/iouring/iouring.4 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 key=iouringsyscall 
----
type=PROCTITLE msg=audit(2021-08-27 16:42:30.626:338) : proctitle=./iouring.4 sqpoll 
type=SYSCALL msg=audit(2021-08-27 16:42:30.626:338) : arch=x86_64 syscall=io_uring_enter success=yes exit=1 a0=0x4 a1=0x1 a2=0x0 a3=0x2 items=0 ppid=543 pid=12447 auid=root uid=root gid=root euid=root suid=root fsuid=root egid=root sgid=root fsgid=root tty=ttyS0 ses=1 comm=iouring.4 exe=/root/rgb/testing/iouring/iouring.4 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 key=iouringsyscall 
----
type=PROCTITLE msg=audit(2021-08-27 16:42:30.627:341) : proctitle=./iouring.4 sqpoll 
type=SYSCALL msg=audit(2021-08-27 16:42:30.627:341) : arch=x86_64 syscall=io_uring_enter success=yes exit=0 a0=0x4 a1=0x0 a2=0x1 a3=0x1 items=0 ppid=543 pid=12447 auid=root uid=root gid=root euid=root suid=root fsuid=root egid=root sgid=root fsgid=root tty=ttyS0 ses=1 comm=iouring.4 exe=/root/rgb/testing/iouring/iouring.4 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 key=iouringsyscall 
----
type=URINGOP msg=audit(2021-08-27 16:42:30.628:339) : uring_op=18 success=no exit=EAGAIN(Resource temporarily unavailable) items=0 ppid=543 pid=12447 auid=root uid=root gid=root euid=root suid=root fsuid=root egid=root sgid=root fsgid=root subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 key=(null) 
----
type=PATH msg=audit(2021-08-27 16:42:30.628:340) : item=1 name=/tmp/iouring.4.txt inode=33 dev=00:1f mode=file,644 ouid=root ogid=root rdev=00:00 obj=unconfined_u:object_r:user_tmp_t:s0 nametype=NORMAL cap_fp=none cap_fi=none cap_fe=0 cap_fver=0 cap_frootid=0 
type=PATH msg=audit(2021-08-27 16:42:30.628:340) : item=0 name=/tmp/ inode=1 dev=00:1f mode=dir,sticky,777 ouid=root ogid=root rdev=00:00 obj=system_u:object_r:tmp_t:s0 nametype=PARENT cap_fp=none cap_fi=none cap_fe=0 cap_fver=0 cap_frootid=0 
type=CWD msg=audit(2021-08-27 16:42:30.628:340) : cwd=/root/rgb/testing/iouring 
type=URINGOP msg=audit(2021-08-27 16:42:30.628:340) : uring_op=18 success=yes exit=0 items=2 ppid=543 pid=12447 auid=root uid=root gid=root euid=root suid=root fsuid=root egid=root sgid=root fsgid=root subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 key=(null) 
----
type=PROCTITLE msg=audit(2021-08-27 16:42:30.629:342) : proctitle=./iouring.4 sqpoll 
type=SYSCALL msg=audit(2021-08-27 16:42:30.629:342) : arch=x86_64 syscall=io_uring_register success=yes exit=0 a0=0x4 a1=0x2 a2=0x7ffff75290a8 a3=0x1 items=0 ppid=543 pid=12447 auid=root uid=root gid=root euid=root suid=root fsuid=root egid=root sgid=root fsgid=root tty=ttyS0 ses=1 comm=iouring.4 exe=/root/rgb/testing/iouring/iouring.4 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 key=iouringsyscall 
----
type=PROCTITLE msg=audit(2021-08-27 16:42:30.629:343) : proctitle=./iouring.4 sqpoll 
type=SYSCALL msg=audit(2021-08-27 16:42:30.629:343) : arch=x86_64 syscall=io_uring_enter success=yes exit=0 a0=0x4 a1=0x0 a2=0x1 a3=0x1 items=0 ppid=543 pid=12447 auid=root uid=root gid=root euid=root suid=root fsuid=root egid=root sgid=root fsgid=root tty=ttyS0 ses=1 comm=iouring.4 exe=/root/rgb/testing/iouring/iouring.4 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 key=iouringsyscall 
----
type=PROCTITLE msg=audit(2021-08-27 16:42:30.631:344) : proctitle=./iouring.4 sqpoll 
type=SYSCALL msg=audit(2021-08-27 16:42:30.631:344) : arch=x86_64 syscall=io_uring_enter success=yes exit=0 a0=0x4 a1=0x0 a2=0x1 a3=0x1 items=0 ppid=543 pid=12447 auid=root uid=root gid=root euid=root suid=root fsuid=root egid=root sgid=root fsgid=root tty=ttyS0 ses=1 comm=iouring.4 exe=/root/rgb/testing/iouring/iouring.4 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 key=iouringsyscall 
----
type=PROCTITLE msg=audit(2021-08-27 16:42:30.632:346) : proctitle=./iouring.4 sqpoll 
type=SYSCALL msg=audit(2021-08-27 16:42:30.632:346) : arch=x86_64 syscall=io_uring_enter success=yes exit=0 a0=0x4 a1=0x0 a2=0x1 a3=0x1 items=0 ppid=543 pid=12447 auid=root uid=root gid=root euid=root suid=root fsuid=root egid=root sgid=root fsgid=root tty=ttyS0 ses=1 comm=iouring.4 exe=/root/rgb/testing/iouring/iouring.4 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 key=iouringsyscall 
----
type=URINGOP msg=audit(2021-08-27 16:42:30.633:345) : uring_op=19 success=yes exit=0 items=0 ppid=543 pid=12447 auid=root uid=root gid=root euid=root suid=root fsuid=root egid=root sgid=root fsgid=root subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 key=(null) 
----
type=PROCTITLE msg=audit(2021-08-27 16:42:30.634:347) : proctitle=./iouring.4 sqpoll 
type=SYSCALL msg=audit(2021-08-27 16:42:30.634:347) : arch=x86_64 syscall=io_uring_register success=yes exit=0 a0=0x4 a1=0x3 a2=0x0 a3=0x0 items=0 ppid=543 pid=12447 auid=root uid=root gid=root euid=root suid=root fsuid=root egid=root sgid=root fsgid=root tty=ttyS0 ses=1 comm=iouring.4 exe=/root/rgb/testing/iouring/iouring.4 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 key=iouringsyscall 
----
type=PROCTITLE msg=audit(2021-08-27 16:42:36.895:348) : proctitle=./iouring.4 t1 
type=SYSCALL msg=audit(2021-08-27 16:42:36.895:348) : arch=x86_64 syscall=io_uring_setup success=yes exit=4 a0=0x8 a1=0x7fcaf2b8a0d8 a2=0x7fcaf2b8a0d8 a3=0x3 items=0 ppid=543 pid=12451 auid=root uid=root gid=root euid=root suid=root fsuid=root egid=root sgid=root fsgid=root tty=ttyS0 ses=1 comm=iouring.4 exe=/root/rgb/testing/iouring/iouring.4 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 key=iouringsyscall 
----
type=PROCTITLE msg=audit(2021-08-27 16:42:36.896:349) : proctitle=./iouring.4 t1 
type=SYSCALL msg=audit(2021-08-27 16:42:36.896:349) : arch=x86_64 syscall=io_uring_register success=yes exit=1 a0=0x4 a1=0x9 a2=0x0 a3=0x0 items=0 ppid=543 pid=12451 auid=root uid=root gid=root euid=root suid=root fsuid=root egid=root sgid=root fsgid=root tty=ttyS0 ses=1 comm=iouring.4 exe=/root/rgb/testing/iouring/iouring.4 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 key=iouringsyscall 
----
type=PROCTITLE msg=audit(2021-08-27 16:42:36.902:350) : proctitle=./iouring.4 t1_child 
type=PATH msg=audit(2021-08-27 16:42:36.902:350) : item=0 name=/tmp/iouring.4.txt nametype=UNKNOWN cap_fp=none cap_fi=none cap_fe=0 cap_fver=0 cap_frootid=0 
type=CWD msg=audit(2021-08-27 16:42:36.902:350) : cwd=/root/rgb/testing/iouring 
type=SYSCALL msg=audit(2021-08-27 16:42:36.902:350) : arch=x86_64 syscall=io_uring_enter success=yes exit=1 a0=0x4 a1=0x1 a2=0x0 a3=0x0 items=1 ppid=12451 pid=12452 auid=root uid=root gid=root euid=root suid=root fsuid=root egid=root sgid=root fsgid=root tty=ttyS0 ses=1 comm=iouring.4 exe=/root/rgb/testing/iouring/iouring.4 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 key=iouringsyscall 
type=URINGOP msg=audit(2021-08-27 16:42:36.902:350) : uring_op=18 items=1 ppid=12451 pid=12452 auid=root uid=root gid=root euid=root suid=root fsuid=root egid=root sgid=root fsgid=root subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 key=iouringsyscall 
----
type=PATH msg=audit(2021-08-27 16:42:36.902:351) : item=0 name=/tmp/iouring.4.txt inode=33 dev=00:1f mode=file,644 ouid=root ogid=root rdev=00:00 obj=unconfined_u:object_r:user_tmp_t:s0 nametype=NORMAL cap_fp=none cap_fi=none cap_fe=0 cap_fver=0 cap_frootid=0 
type=CWD msg=audit(2021-08-27 16:42:36.902:351) : cwd=/root/rgb/testing/iouring 
type=URINGOP msg=audit(2021-08-27 16:42:36.902:351) : uring_op=18 success=yes exit=0 items=1 ppid=12451 pid=12452 auid=root uid=root gid=root euid=root suid=root fsuid=root egid=root sgid=root fsgid=root subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 key=(null) 
----
type=PROCTITLE msg=audit(2021-08-27 16:42:36.902:352) : proctitle=./iouring.4 t1_child 
type=SYSCALL msg=audit(2021-08-27 16:42:36.902:352) : arch=x86_64 syscall=io_uring_enter success=yes exit=0 a0=0x4 a1=0x0 a2=0x1 a3=0x1 items=0 ppid=12451 pid=12452 auid=root uid=root gid=root euid=root suid=root fsuid=root egid=root sgid=root fsgid=root tty=ttyS0 ses=1 comm=iouring.4 exe=/root/rgb/testing/iouring/iouring.4 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 key=iouringsyscall 
----
type=PROCTITLE msg=audit(2021-08-27 16:42:36.902:353) : proctitle=./iouring.4 t1_child 
type=SYSCALL msg=audit(2021-08-27 16:42:36.902:353) : arch=x86_64 syscall=io_uring_register success=yes exit=0 a0=0x4 a1=0x2 a2=0x7ffc0645bcb8 a3=0x1 items=0 ppid=12451 pid=12452 auid=root uid=root gid=root euid=root suid=root fsuid=root egid=root sgid=root fsgid=root tty=ttyS0 ses=1 comm=iouring.4 exe=/root/rgb/testing/iouring/iouring.4 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 key=iouringsyscall 
----
type=PROCTITLE msg=audit(2021-08-27 16:42:36.903:354) : proctitle=./iouring.4 t1_child 
type=SYSCALL msg=audit(2021-08-27 16:42:36.903:354) : arch=x86_64 syscall=io_uring_enter success=yes exit=1 a0=0x4 a1=0x1 a2=0x0 a3=0x0 items=0 ppid=12451 pid=12452 auid=root uid=root gid=root euid=root suid=root fsuid=root egid=root sgid=root fsgid=root tty=ttyS0 ses=1 comm=iouring.4 exe=/root/rgb/testing/iouring/iouring.4 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 key=iouringsyscall 
----
type=PROCTITLE msg=audit(2021-08-27 16:42:36.903:355) : proctitle=./iouring.4 t1_child 
type=SYSCALL msg=audit(2021-08-27 16:42:36.903:355) : arch=x86_64 syscall=io_uring_enter success=yes exit=0 a0=0x4 a1=0x0 a2=0x1 a3=0x1 items=0 ppid=12451 pid=12452 auid=root uid=root gid=root euid=root suid=root fsuid=root egid=root sgid=root fsgid=root tty=ttyS0 ses=1 comm=iouring.4 exe=/root/rgb/testing/iouring/iouring.4 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 key=iouringsyscall 
----
type=PROCTITLE msg=audit(2021-08-27 16:42:36.903:356) : proctitle=./iouring.4 t1_child 
type=SYSCALL msg=audit(2021-08-27 16:42:36.903:356) : arch=x86_64 syscall=io_uring_enter success=yes exit=1 a0=0x4 a1=0x1 a2=0x0 a3=0x0 items=0 ppid=12451 pid=12452 auid=root uid=root gid=root euid=root suid=root fsuid=root egid=root sgid=root fsgid=root tty=ttyS0 ses=1 comm=iouring.4 exe=/root/rgb/testing/iouring/iouring.4 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 key=iouringsyscall 
----
type=PROCTITLE msg=audit(2021-08-27 16:42:36.903:357) : proctitle=./iouring.4 t1_child 
type=SYSCALL msg=audit(2021-08-27 16:42:36.903:357) : arch=x86_64 syscall=io_uring_enter success=yes exit=0 a0=0x4 a1=0x0 a2=0x1 a3=0x1 items=0 ppid=12451 pid=12452 auid=root uid=root gid=root euid=root suid=root fsuid=root egid=root sgid=root fsgid=root tty=ttyS0 ses=1 comm=iouring.4 exe=/root/rgb/testing/iouring/iouring.4 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 key=iouringsyscall 
----
type=PROCTITLE msg=audit(2021-08-27 16:42:36.904:358) : proctitle=./iouring.4 t1_child 
type=SYSCALL msg=audit(2021-08-27 16:42:36.904:358) : arch=x86_64 syscall=io_uring_enter success=yes exit=1 a0=0x4 a1=0x1 a2=0x0 a3=0x0 items=0 ppid=12451 pid=12452 auid=root uid=root gid=root euid=root suid=root fsuid=root egid=root sgid=root fsgid=root tty=ttyS0 ses=1 comm=iouring.4 exe=/root/rgb/testing/iouring/iouring.4 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 key=iouringsyscall 
type=URINGOP msg=audit(2021-08-27 16:42:36.904:358) : uring_op=19 items=0 ppid=12451 pid=12452 auid=root uid=root gid=root euid=root suid=root fsuid=root egid=root sgid=root fsgid=root subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 key=iouringsyscall 
----
type=PROCTITLE msg=audit(2021-08-27 16:42:36.904:359) : proctitle=./iouring.4 t1_child 
type=SYSCALL msg=audit(2021-08-27 16:42:36.904:359) : arch=x86_64 syscall=io_uring_register success=yes exit=0 a0=0x4 a1=0x3 a2=0x0 a3=0x0 items=0 ppid=12451 pid=12452 auid=root uid=root gid=root euid=root suid=root fsuid=root egid=root sgid=root fsgid=root tty=ttyS0 ses=1 comm=iouring.4 exe=/root/rgb/testing/iouring/iouring.4 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 key=iouringsyscall 
----

--45Z9DzgjV8m4Oswq--

