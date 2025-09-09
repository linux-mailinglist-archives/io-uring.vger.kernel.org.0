Return-Path: <io-uring+bounces-9675-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3157CB50183
	for <lists+io-uring@lfdr.de>; Tue,  9 Sep 2025 17:37:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 06E2D188AA38
	for <lists+io-uring@lfdr.de>; Tue,  9 Sep 2025 15:36:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F934265614;
	Tue,  9 Sep 2025 15:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jmEM/3Rb"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A2D3261B9C;
	Tue,  9 Sep 2025 15:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757431851; cv=none; b=l9R5SlIxCQPQOjCjjxBTsKk5FK2PioZHULwnbbnEK2LaJ9Pv7zvhERuL5K3Sx5Qou4rrihQu9XfXSNHqoyG8RGH3MzR+d5xX1O8j8LeCQKd+KqTMi2Q50uee6R0dGoG+hOgYpdu1Aoa8L0NUHhikugxX+gCDR7/zGRkgiqERVgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757431851; c=relaxed/simple;
	bh=aqbkms/gaWJEiLDhpqirH0jBS2oRw9HZsMKz5UUm7sc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BIN2qgIXjxMtP60/TyHM+BLk1XgpwFc+TLGe4NNc1+lR0bVQncfu0JOoQgxHgNRCv1mSWnrjU/rJckqvOsgM/ufxm57cxLVBaW+IBGIhdlYkXWaQLLACR/ylqtU9ltFchE4hoCuIh8H3RP1UN4iMObzc6JkVjXk7Xb+sqAPpOBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jmEM/3Rb; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 917C1C4CEFD;
	Tue,  9 Sep 2025 15:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757431850;
	bh=aqbkms/gaWJEiLDhpqirH0jBS2oRw9HZsMKz5UUm7sc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=jmEM/3RbEX9zp1m9XfXMmJIreIM9tJwO8TRPbQ55Rpe4WMenRgTNxmGsmhFmm3cUm
	 l3bpa8ld9Xjn3m0P1KOVMoctyWK1eUlZ5gCXhu7G1YSWvlQXa9tI7HLG5ypQLbHjTa
	 +fF2N/ER+8/XsHzeSckfnqVbMgC27ucxhbTRNtOKpbjKCh9h2QSY/Td+8kwlPqN9sO
	 BmWG/F602ZaYVR/zOPQqA2bSCrqTaFhuCL8sPnmlI+mYknqUHncsvoHwgV1rBY8HW4
	 NwyG/BQFNEZA0IVEB+ZB3wZvxpynFxeTh5ClnE1azsIvKDTEiDZXPXnKrwopejlbBh
	 y5YkYl2kLlEgQ==
Received: by mail-ot1-f44.google.com with SMTP id 46e09a7af769-74be52f5447so1388115a34.1;
        Tue, 09 Sep 2025 08:30:50 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVu/iBlS2GYI8uhHk4JSzzzZT+VsqpMzFHHEpOD1ObO1RC5OlvdtOOrE0qEjASGFJazXgmXxFFUj1wa@vger.kernel.org, AJvYcCXuVWQ+doHlHPnKxmMcONvTSbCgbchB/vLzExQKsMSRtkaPE1WabfQrx96TPQ3IzwwbMBDNqHR+dQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwJAwt+AshdakH5WuZ53e9+uT1UOUTJtLxNMZ9XefPrTjSmdlrn
	7ijpF6rJzyq0IBHotMm3Ata0Jz2JBinhTo7g6oa46CGBUfP8gDLQAwKqvaom9QBJ/cNKRcuxG9v
	Qh0ElDAgoIrByC1xvRbnML/CCLkjLa5Q=
X-Google-Smtp-Source: AGHT+IGgWTC3wonPX7S7YCnJtpNSY94WtsUb6/ca3Eob64Yuj64Zt1XCduqWGmQo0D5x7YC8+6IqhDX2Rms1CcstavE=
X-Received: by 2002:a05:6830:6507:b0:74b:7c40:3586 with SMTP id
 46e09a7af769-74c6f317ec8mr6938783a34.4.1757431849789; Tue, 09 Sep 2025
 08:30:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <9ef87524-d15c-4b2c-9f86-00417dad9c48@kernel.dk>
 <20250905-sparkling-stalwart-galago-8a87e0@lemur> <68bf3854f101b_4224d100d7@dwillia2-mobl4.notmuch>
 <5922560.DvuYhMxLoT@rafael.j.wysocki> <20250909071818.15507ee6@kernel.org>
 <92dc8570-84a2-4015-9c7a-6e7da784869a@kernel.dk> <20250909-green-oriole-of-speed-85cd6d@lemur>
 <497c9c10-3309-49b9-8d4f-ff0bc34df4e5@suse.cz> <be98399d-3886-496e-9cf4-5ec909124418@kernel.dk>
In-Reply-To: <be98399d-3886-496e-9cf4-5ec909124418@kernel.dk>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Tue, 9 Sep 2025 17:30:38 +0200
X-Gmail-Original-Message-ID: <CAJZ5v0g-T44CWLn5EXufpELOk30OsFJZUo9jipAhwPq1A=dJuQ@mail.gmail.com>
X-Gm-Features: Ac12FXyw4fqcGB_l4oZBh1HyZIx2_1JLlbY4Zh4sO8kLc-SI7kz2BD0P2JwT9IA
Message-ID: <CAJZ5v0g-T44CWLn5EXufpELOk30OsFJZUo9jipAhwPq1A=dJuQ@mail.gmail.com>
Subject: Re: Link trailers revisited (was Re: [GIT PULL] io_uring fix for 6.17-rc5)
To: Jens Axboe <axboe@kernel.dk>
Cc: Vlastimil Babka <vbabka@suse.cz>, Konstantin Ryabitsev <konstantin@linuxfoundation.org>, 
	Jakub Kicinski <kuba@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, 
	"Rafael J. Wysocki" <rafael@kernel.org>, dan.j.williams@intel.com, 
	Caleb Sander Mateos <csander@purestorage.com>, io-uring <io-uring@vger.kernel.org>, 
	workflows@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 9, 2025 at 4:50=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 9/9/25 8:48 AM, Vlastimil Babka wrote:
> > On 9/9/25 16:42, Konstantin Ryabitsev wrote:
> >> On Tue, Sep 09, 2025 at 08:35:18AM -0600, Jens Axboe wrote:
> >>>>> On a global scale, that's quite a number of saved mailing list arch=
ive searches.
> >>>>
> >>>> +1 FWIW. I also started slapping the links on all patches in a serie=
s,
> >>>> even if we apply with a merge commit. I don't know of a good way wit=
h
> >>>> git to "get to the first parent merge" so scanning the history to fi=
nd
> >>>> the link in the cover letter was annoying me :(
> >>>
> >>> Like I've tried to argue, I find them useful too. But after this whol=
e
> >>> mess of a thread, I killed -l from my scripts. I do think it's a mist=
ake
> >>> and it seems like the only reason to remove them is that Linus expect=
s
> >>> to find something at the end of the link rainbow and is often
> >>> disappointed, and that annoys him enough to rant about it.
> >>>
> >>> I know some folks downstream of me on the io_uring side find them use=
ful
> >>> too, because they've asked me several times to please remember to ens=
ure
> >>> my own self-applied patches have the link as well. For those, I tend =
to
> >>> pick or add them locally rather than use b4 for it, which is why they=
've
> >>> never had links.
> >>>
> >>> As far as I can tell, only two things have been established here:
> >>>
> >>> 1) Linus hates the Link tags, except if they have extra information
> >>> 2) Lots of other folks find them useful
> >>>
> >>> and hence we're at a solid deadlock here.
> >>
> >> I did suggest that provenance links use the patch.msgid.link subdomain=
. This
> >
> > Yes, and the PR that started this thread had a normal lore link. Would =
it
> > have been different with a patch.msgid.link as perhaps Linus would not =
try
> > opening it and become disappointed?
> > You did kinda ask that early in the thread but then the conversation we=
nt in
> > different directions.
>
> I think we all know the answer to that one - it would've been EXACTLY
> the same outcome. Not to put words in Linus' mouth, but it's not the
> name of the tag that he finds repulsive, it's the very fact that a link
> is there and it isn't useful _to him_.

Well, I think that the convention associated with patch.msgid.link is
clear, like for the "Fixes:" and "Cc: stable" tags.  Those tags are
also generally useful, but mostly in the post-development part of the
process, so to speak.

So, if there are no problems with adding "Fixes:" and "Cc: stable"
tags, why would there be a problem with patch.msgid.link?

