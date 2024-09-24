Return-Path: <io-uring+bounces-3293-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E913984EC9
	for <lists+io-uring@lfdr.de>; Wed, 25 Sep 2024 01:17:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0140DB23DA2
	for <lists+io-uring@lfdr.de>; Tue, 24 Sep 2024 23:17:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65CB5136330;
	Tue, 24 Sep 2024 23:17:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="DIbpnzDg"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com [209.85.128.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 973C51482E7
	for <io-uring@vger.kernel.org>; Tue, 24 Sep 2024 23:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727219835; cv=none; b=YR+Rc7ssoPLDLAb7KqtV2wgc1boQw3PH4znFZF0CMPwgPzkr2Bx309X3b8+NrGIwtPvSz+6M04B7SN7sp+f7sjQGGzCpZP9etyWH9WdMUhqsht+C7FbLu9Pm5o8/4MZvPGZfim3+wivFE3UPUmoNZ7JSs3c7ouVDYhAncWyBaPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727219835; c=relaxed/simple;
	bh=dCTuIyEupdKJi62lAkCUN6rhJtTPQEIz8/uT/xtgEXU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KivCalS1itgjx8mhC75KhkOH+uef834I/gu6E1ztKnnig7Vyxw7fHLfvYnZUVyiQX2y/y+oN7kp+4q2hbJSvhHI3tVgW4GKDFnqxoa2SP1cNHQl87teItWlqEueFdyOz27NhIIBWsHKs4oxg37OceYd57kV7UWvrLhGJQK84OzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=DIbpnzDg; arc=none smtp.client-ip=209.85.128.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-6ddceaaa9f4so48565377b3.2
        for <io-uring@vger.kernel.org>; Tue, 24 Sep 2024 16:17:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1727219832; x=1727824632; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DQbz1KV9DawuCKGwIlA9WAqzoJlKO0SVrBIhzZt0liU=;
        b=DIbpnzDgpp0Uorn5AOWcjIM6oOn1xEaIDIhvLNH57OfCxu6SkY6jg8sGRiAzlDuqws
         ePUhSpjJo5T07Rmo2bvKnav88xwYukqBHVqykKX+naU1HYtfrlmt1kMrbi0lqize12CY
         LuLTE7GUqoZCTUZAaSMyqpuixjedfHUFPLVoPnKfkBmMCTHFrX6g/wehQ3+eWtjnFukh
         o7RPcmfY15xaMlsXMQXS/lpm3fWaTEKhZnyoSzxgzHvSLOCm7v1xcF7OSjKmEC/E+/U3
         CSFcTtZpapTHqba66kRIwEtYYib6BhYLq9YT/yICBCCRsyvNuRuztMXSzLVkSl5Nzg9X
         LLZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727219832; x=1727824632;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DQbz1KV9DawuCKGwIlA9WAqzoJlKO0SVrBIhzZt0liU=;
        b=SSDETGe9V+3w1Z6ywMBTwXLYA9AAksh5qnapEIwby2WAd/n8p6n52D13IPnM5xHMOj
         5hK+5knMrrMuCm9dKYcOtPaM3nUpQjtSAKszpwXTb+RlQqt9oFfnhjO8pnvYKdgi0MB6
         WxMO79c3uVgg5kZKmlKPk1PczwxoUrTQyaC+sF0fVJPFUt5zfKyLgSepvhWMTd6WWOQq
         WDcTJD3/Fpj43EAGGaRVL4HQi0qEBbb1mlwe0IR+quA+Bsx7GP78oyMr/JPGKCBCfyAe
         QJkxsQc6ikpls1O7+9j3F61kCKr6Ww51QGZpn+UxFXhH/qL12LXNnYb0tu2sGDzb7vsL
         UJDQ==
X-Forwarded-Encrypted: i=1; AJvYcCVaEvZ+wovElBNhrBxUZ98gKu/F+ffTzOyzqifoh9prRVN5SeU4dil2YIFEY5mdtrpPBorMU+i3tQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzGxRowjhJUyPVAvf1FGDOLecRT0SJBN1u+jZMN8i8O1YDxUin/
	N0nQhtm7fLbZrHenHwsfcF152eX9JeLo8ONO5UO/9H2Ai9osZXwZfaZUTF4QNgn6+3gaIyTjwbu
	/KhzMnyrLNElURxKW3fRIx/tEYucKaFtlO3sF
X-Google-Smtp-Source: AGHT+IH4aRIyQqyU98Rdh10Z3hWLXz8ZHU3ntO6rXPkkvkLAunfU3PHMTjgosB+ymac/L0JJ7lv61EsN2BQzXxMakZI=
X-Received: by 2002:a05:690c:4584:b0:6af:eaaf:2527 with SMTP id
 00721157ae682-6e21d8a2b89mr8920407b3.18.1727219832337; Tue, 24 Sep 2024
 16:17:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240922004901.GA3413968@ZenIV> <20240923015044.GE3413968@ZenIV>
 <62104de8-6e9a-4566-bf85-f4c8d55bdb36@kernel.dk> <CAHC9VhQMGsL1tZrAbpwTHCriwZE2bzxAd+-7MSO+bPZe=N6+aA@mail.gmail.com>
 <20240923144841.GA3550746@ZenIV> <CAHC9VhSuDVW2Dmb6bA3CK6k77cPEv2vMqv3w4FfGvtcRDmgL3A@mail.gmail.com>
 <20240923203659.GD3550746@ZenIV> <CAHC9VhSq=6MK=HKCJ8KCjYNQZ4j_eCSgTpuYyHtk2T-_m2Br3Q@mail.gmail.com>
 <20240924070137.GE3550746@ZenIV>
In-Reply-To: <20240924070137.GE3550746@ZenIV>
From: Paul Moore <paul@paul-moore.com>
Date: Tue, 24 Sep 2024 19:17:01 -0400
Message-ID: <CAHC9VhR-c8T=KykMHKsovwzRKmpfSbQwYMjRQbEp-ojraCxm-g@mail.gmail.com>
Subject: Re: [RFC] struct filename, io_uring and audit troubles
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org, audit@vger.kernel.org, 
	io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 24, 2024 at 3:01=E2=80=AFAM Al Viro <viro@zeniv.linux.org.uk> w=
rote:
> On Mon, Sep 23, 2024 at 08:11:51PM -0400, Paul Moore wrote:
> > > Umm...  IIRC, sgrubb had been involved in the spec-related horrors, b=
ut
> > > that was a long time ago...
> >
> > Yep, he was.  Last I spoke to Steve a year or so ago, audit was no
> > longer part of his job description; Steve still maintains his
> > userspace audit tools, but that is a nights/weekends job as far as I
> > understand.
> >
> > The last time I was involved in any audit/CC spec related work was
> > well over a decade ago now, and all of those CC protection profiles
> > have long since expired and been replaced.
>
> Interesting...  I guess eparis would be the next victim^Wpossible source
> of information.

Eric was the one who dumped the audit subsystem in my lap ~10 years
ago so he could run off and play with containers.  Fortunately for
Eric I was much more trusting back then and didn't read all the fine
print before agreeing to look after audit.

> > >         * looking at the users of that stuff, I would probably prefer=
 to
> > > separate getname*() from insertion into audit context.  It's not that
> > > tricky - __set_nameidata() catches *everything* that uses nd->name (i=
.e.
> > > all that audit_inode() calls in fs/namei.c use).
> >
> > That should be a pretty significant simplification, that sounds good to=
 me.
> >
> > > ... What remains is
> > >         do_symlinkat() for symlink body
> > >         fs_index() on the argument (if we want to bother - it's a par=
t
> > > of weird Missed'em'V sysfs(2) syscall; I sincerely doubt that there's
> > > anybody who'd use it)
> >
> > We probably should bother, folks that really care about audit don't
> > like blind spots.  Perhaps make it a separate patch if it isn't too
> > ugly to split it out.
>
> Heh...  I suggest you to look at the manpage of that thing.

Ooof.  That's something isn't it?  Yeah, that's ugly, and since it
doesn't really return any user or sensitive system information I think
it's safe to skip - my mistake.

> > >         That's all it takes.  With that done, we can kill ->aname;
> > > just look in the ->names_list for the first entry with given ->name -
> > > as in, given struct filename * value, no need to look inside.
> >
> > Seems reasonable to me.  I can't imagine these special cases being any
> > worse than what we have now in fs/namei.c, and if nothing else having
> > a single catch point for the bulk of the VFS lookups makes it worth it
> > as far as I'm concerned.
>
> Huh?  Right now we allocate audit_names at getname_flags()/getname_kernel=
()
> time; grep for audit_getname() - that's as centralized as it gets.
> What I want to do is somewhat _de_centralize it; that way they would not
> go anywhere other than audit_context of the thread actually doing the
> work.
>
> There is a lot of calls of audit_inode(), but I'm not planning to touch
> any of those.

Sorry.  I'm a bit foggy from traveling, and trying to play catch-up
back at home.  I'm sure it will make more sense once I see the
patches.

--=20
paul-moore.com

