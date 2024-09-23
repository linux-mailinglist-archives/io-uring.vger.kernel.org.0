Return-Path: <io-uring+bounces-3269-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C1AC97F049
	for <lists+io-uring@lfdr.de>; Mon, 23 Sep 2024 20:17:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F1EF6B21A5A
	for <lists+io-uring@lfdr.de>; Mon, 23 Sep 2024 18:17:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8964F19F41C;
	Mon, 23 Sep 2024 18:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="JX9fAy/6"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FCD513B7BD;
	Mon, 23 Sep 2024 18:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727115433; cv=none; b=hWTFfUGItsSoSBpHXvaK4pwOkr61WKbovmDhhMdsUtrvEMZHZxWhapvdXv3vrkgt5iBdynbVI6aZjl74Yj+fSsW0fNTdT1ICA+nrDinUQHn9Ij308mm7dRzdT3jUmxWrHUg3ZJOolNRAPuNOjELtZKIPXZZhjKxjlq9yafq4csc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727115433; c=relaxed/simple;
	bh=Nj+v7Jlg27lFBLxy1idpRfesBjRZ6ZzCQnuv5ZShD8s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XFfogl9XlfA1VVQ+Y2SGaIlnCBwNN3YE/p1k9DtJtXpNG9wgcmgWZr7vV4OoGL1c86vK6twk5IG8GuHaenQktsq9mZcIxtrKxPG8IEi9X1bTzMKqj/6uTK+4FUSJ7jtKj97NCo6UCUZvj8FRgZLK6/osY3mU5GlSLAuKX8/7BWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=JX9fAy/6; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=VPWUsWG3ybD6/U+EOW86OpKDYTxJrUN5xaHj5/gB7dE=; b=JX9fAy/6frn1zojIwqEx32fSmT
	SYeRzfrerRojWGknwCjYwlaT9Bep3SsK+r854jnehJB1sVC5jGqfj9E3ly1DXH3WAL2xEvR/IG1qD
	LF2gWg2xfExwf+mOslew+pwvidrhzK6MWsLOVfHfxn9K6EIaifNlOPiIOY26EYOdz458Wf8KL9jYJ
	zgbuTCdrva87i1WK5JGq4RXErlfI7PUQsu8PzQcAh/W+3tZBLgjeV8dmU2OCmhIYtReUMKgWrcg/l
	ttJd7Sj3MCnAIBsXxDfeW4+AKEIO5UKli8KXASv8TL2+k0+8WlpsosRhm2WE1R1mLeu159/czjS66
	j9vo1eTg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98 #2 (Red Hat Linux))
	id 1ssncS-0000000ExAr-1Bli;
	Mon, 23 Sep 2024 18:17:08 +0000
Date: Mon, 23 Sep 2024 19:17:08 +0100
From: Al Viro <viro@zeniv.linux.org.uk>
To: Paul Moore <paul@paul-moore.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
	audit@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [RFC] struct filename, io_uring and audit troubles
Message-ID: <20240923181708.GC3550746@ZenIV>
References: <20240922004901.GA3413968@ZenIV>
 <20240923015044.GE3413968@ZenIV>
 <62104de8-6e9a-4566-bf85-f4c8d55bdb36@kernel.dk>
 <CAHC9VhQMGsL1tZrAbpwTHCriwZE2bzxAd+-7MSO+bPZe=N6+aA@mail.gmail.com>
 <20240923144841.GA3550746@ZenIV>
 <CAHC9VhSuDVW2Dmb6bA3CK6k77cPEv2vMqv3w4FfGvtcRDmgL3A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHC9VhSuDVW2Dmb6bA3CK6k77cPEv2vMqv3w4FfGvtcRDmgL3A@mail.gmail.com>
Sender: Al Viro <viro@ftp.linux.org.uk>

On Mon, Sep 23, 2024 at 12:14:29PM -0400, Paul Moore wrote:

> > And having everything that passed through getname()/getname_kernel()
> > shoved into ->names_list leads to very odd behaviour, especially with
> > audit_names conversions in audit_inode()/audit_inode_child().
> >
> > Look at the handling of AUDIT_DEV{MAJOR,MINOR} or AUDIT_OBJ_{UID,GID}
> > or AUDIT_COMPARE_..._TO_OBJ; should they really apply to audit_names
> > resulting from copying the symlink body into the kernel?  And if they
> > should be applied to audit_names instance that had never been associated
> > with any inode, should that depend upon the string in those being
> > equal to another argument of the same syscall?
> >
> > I'm going through the kernel/auditsc.c right now, but it's more of
> > a "document what it does" - I don't have the specs and I certainly
> > don't remember such details.
> 
> My approach to audit is "do what makes sense for a normal person", if
> somebody needs silly behavior to satisfy some security cert then they
> can get involved in upstream development and send me patches that
> don't suck.

root@kvm1:/tmp# auditctl -l
-a always,exit -S all -F dir=/tmp/blah -F perm=rwxa -F obj_uid=0
root@kvm1:/tmp# su - al
al@kvm1:~$ cd /tmp/blah
al@kvm1:/tmp/blah$ ln -s a a
al@kvm1:/tmp/blah$ ln -s c b
al@kvm1:/tmp/blah$ ls -l
total 0
lrwxrwxrwx 1 al al 1 Sep 23 13:44 a -> a
lrwxrwxrwx 1 al al 1 Sep 23 13:44 b -> c
al@kvm1:/tmp/blah$ ls -ld 
drwxr-xr-x 2 al al 4096 Sep 23 13:44 .

resulting in
type=USER_START msg=audit(1727113434.684:497): pid=3433 uid=0 auid=0 ses=1 subj=unconfined msg='op=PAM:session_open grantors=pam_key
init,pam_env,pam_env,pam_mail,pam_limits,pam_permit,pam_unix,pam_ecryptfs acct="al" exe="/usr/bin/su" hostname=? addr=? terminal=/de
v/pts/0 res=success'^]UID="root" AUID="root"
type=SYSCALL msg=audit(1727113466.464:498): arch=c000003e syscall=266 success=yes exit=0 a0=7ffc441ad843 a1=ffffff9c a2=7ffc441ad845 a3=7f10e4816a90 items=3 ppid=3434 pid=3449 auid=0 uid=1000 gid=1000 euid=1000 suid=1000 fsuid=1000 egid=1000 sgid=1000 fsgid=1000 tty=pts0 ses=1 comm="ln" exe="/usr/bin/ln" subj=unconfined key=(null)^]ARCH=x86_64 SYSCALL=symlinkat AUID="root" UID="al" GID="al" EUID="al" SUID="al" FSUID="al" EGID="al" SGID="al" FSGID="al"
type=CWD msg=audit(1727113466.464:498): cwd="/tmp/blah"
type=PATH msg=audit(1727113466.464:498): item=0 name="/tmp/blah" inode=135460 dev=08:14 mode=041777 ouid=1000 ogid=1000 rdev=00:00 nametype=PARENT cap_fp=0 cap_fi=0 cap_fe=0 cap_fver=0 cap_frootid=0^]OUID="al" OGID="al"
type=PATH msg=audit(1727113466.464:498): item=1 name="c" nametype=UNKNOWN cap_fp=0 cap_fi=0 cap_fe=0 cap_fver=0 cap_frootid=0
type=PATH msg=audit(1727113466.464:498): item=2 name="b" inode=135497 dev=08:14 mode=0120777 ouid=1000 ogid=1000 rdev=00:00 nametype=CREATE cap_fp=0 cap_fi=0 cap_fe=0 cap_fver=0 cap_frootid=0^]OUID="al" OGID="al"
type=PROCTITLE msg=audit(1727113466.464:498): proctitle=6C6E002D7300630062
type=USER_END msg=audit(1727113560.852:499): pid=3433 uid=0 auid=0 ses=1 subj=unconfined msg='op=PAM:session_close grantors=pam_keyinit,pam_env,pam_env,pam_mail,pam_limits,pam_permit,pam_unix,pam_ecryptfs acct="al" exe="/usr/bin/su" hostname=? addr=? terminal=/dev/pts/0 res=success'^]UID="root" AUID="root"

Note that
	* none of the filesystem objects involved have UID 0
	* of two calls of symlinkat(), only the second one triggers the rule
... and removing the -F obj_uid=0 from the rule catches both (as expected),
with the first one getting *two* items instead of 3 - there's PARENT (identical
to the second call), there's CREATE (for "a" instead of "b", obviously) and
there's no UNKNOWN with the symlink body.

Does the behaviour above make sense for a normal person, by your definition?

What happens is that we start with two UNKNOWN (for oldname and newname arguments
of symlinkat(); incidentally, for the order is undefined - it's up to compiler
which argument of do_symlinkat(getname(oldname), newdfd, getname(newname)) gets
evaluated first).  When we get through the call of __filename_parentat(), we get
the newname's audit_names instance hit by audit_inode(...., AUDIT_INODE_PARENT).
That converts the one for newname from UNKNOWN to PARENT.  Then, in may_create(),
we hit it with audit_inode_child() for AUDIT_TYPE_CHILD_CREATING.  Which finds
the parent (newname's audit_names, converted to PARENT by that point) and goes
looking for child.

That's where the execution paths diverge - for symlink("a", "a") the oldname's
audit_names instance looks like a valid candidate and gets converted to CHILD_CREATING.
For symlink("c", "b") such candidate is there, so we get a new item allocated -
CHILD_CREATING for "b".  Name reference gets cloned from PARENT.

Now, ->symlink() is done, it succeeds and fsnotify_create(dir, dentry) gets
called.  We get an identical audit_inode_child() call, except that now dentry
is positive.  It finds PARENT instance, finds CHILD_CREATING one, and slaps
the inode metadata into it, setting ->uid to non-zero.

As the result, in one case you are left with PARENT, UNKNOWN, CHILD_CREATING and
in another - PARENT, CHILD_CREATING.  Modulo reordering first two items if
compiler decides to evaluate the first argument of do_symlinkat() call before
the third one...  In any case, AUDIT_OBJ_UID(0) gives a match on UNKNOWN -
if it's there.  Since both PARENT and CHILD_CREATING refer to non-root-owned
inodes, AUDIT_OBJ_UID(0) does not match either...

