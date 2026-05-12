Return-Path: <io-uring+bounces-13286-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SFchFz0pA2qw1AEAu9opvQ
	(envelope-from <io-uring+bounces-13286-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 12 May 2026 15:21:01 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 52CBB521077
	for <lists+io-uring@lfdr.de>; Tue, 12 May 2026 15:21:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 44A2E30B3BC7
	for <lists+io-uring@lfdr.de>; Tue, 12 May 2026 13:08:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F39439AD51;
	Tue, 12 May 2026 13:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OigBHdyY"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B21A39AD44;
	Tue, 12 May 2026 13:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778591182; cv=none; b=jHoCUc1z5wEeLu63AQ8WuBStBxdhbW0QgGBpWWCF3y+8uIm8vMj9iXya8J6et8UUx+1+mZtXKVInKdriZkd8S8e8YQ3rPYU5Zsrw+TCxs2uvjBRkW9AAC2L4A/dMLNBP46s9dteL8/ofuMuuqP1dYLv+XuTjQJOaNzFi5mDiKcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778591182; c=relaxed/simple;
	bh=UFLh1HQgMVqyhIdcFfusQ2fCIb61H7oDcv3Fks5hcaI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KCIMWUmOyU+RTpyYqIVc5j6pHq7NXeq3SxlIb6Degf1CK7hbqS9jPPQtZp8dPQm3TDSMdchLdC3EeVaLU4hYfGWiTdrpQ8b41+XRj88FbHi0FyRKx/nS5nTEVXAo4jorn+kZdQwlzvPp4CBljWqjPz8X/G7kENGjJyybETuL67s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OigBHdyY; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FCF6C2BCB0;
	Tue, 12 May 2026 13:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778591182;
	bh=UFLh1HQgMVqyhIdcFfusQ2fCIb61H7oDcv3Fks5hcaI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OigBHdyYCbSkyyYJz6QrJH3KYMSIvtlAOUcjWa3CC9hvJooqA61fezXX9Re/DWLzX
	 yZ00J0vFIkefV1t6g5WAnvIOtzF/msDuR8WjVl3nUS4C/jYUodzgjbOfv+BN/7tIJd
	 vaQXyjVeRsT4rOGE83hIFlAwBbBD605lLXU2wKZf+pXQTJcSnd/DCKVyVC4v0SDatn
	 iVt09xOZg9xi2qlbj5oPwxYvo1isXtXHHM8v7+XUMl9Xz977t/iG5Q6CAlbneLJrvb
	 UNkM5XnRsW0s1TtnGsm7ScxI175pctMoM/7CZy2r6Sl49h/MiTxR5L50tdLZSv6ROF
	 d8S2jMfkvw+uA==
Date: Tue, 12 May 2026 15:06:14 +0200
From: Christian Brauner <brauner@kernel.org>
To: Kuniyuki Iwashima <kuniyu@google.com>
Cc: Jori Koolstra <jkoolstra@xs4all.nl>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, Eric Dumazet <edumazet@google.com>, 
	Paolo Abeni <pabeni@redhat.com>, Willem de Bruijn <willemb@google.com>, 
	"David S . Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
	Kees Cook <kees@kernel.org>, Simon Horman <horms@kernel.org>, 
	Andy Lutomirski <luto@amacapital.net>, Will Drewry <wad@chromium.org>, Jeff Layton <jlayton@kernel.org>, 
	Oleg Nesterov <oleg@redhat.com>, Andrei Vagin <avagin@gmail.com>, 
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, Mateusz Guzik <mjguzik@gmail.com>, 
	Joel Granados <joel.granados@kernel.org>, Charlie Mirabile <cmirabil@redhat.com>, 
	Aleksa Sarai <cyphar@cyphar.com>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	netdev@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [RFC PATCH 1/2] net: af_unix: Useful handling of LSM denials on
 SCM_RIGHTS
Message-ID: <20260512-sparflamme-themen-4f3f10225b2a@brauner>
References: <20260428175125.2705296-1-jkoolstra@xs4all.nl>
 <20260428175125.2705296-2-jkoolstra@xs4all.nl>
 <CAAVpQUBKeN2KtRkRAFr8sYJM1_-rbkdjsujau5fAyaiP_dO6FA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAVpQUBKeN2KtRkRAFr8sYJM1_-rbkdjsujau5fAyaiP_dO6FA@mail.gmail.com>
X-Rspamd-Queue-Id: 52CBB521077
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [2.34 / 15.00];
	MID_END_EQ_FROM_USER_PART(4.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	URIBL_MULTI_FAIL(0.00)[xs4all.nl:server fail,sin.lore.kernel.org:server fail];
	TAGGED_FROM(0.00)[bounces-13286-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[26];
	FREEMAIL_CC(0.00)[xs4all.nl,zeniv.linux.org.uk,suse.cz,google.com,redhat.com,davemloft.net,kernel.org,kernel.dk,amacapital.net,chromium.org,gmail.com,virtuozzo.com,cyphar.com,vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[brauner@kernel.org,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[io-uring];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Action: no action

On Wed, Apr 29, 2026 at 07:04:25PM -0700, Kuniyuki Iwashima wrote:
> On Tue, Apr 28, 2026 at 10:51 AM Jori Koolstra <jkoolstra@xs4all.nl> wrote:
> >
> > Right now if some LSM such as Smack denies an AF_UNIX socket peer to
> > receive an SCM_RIGHTS fd the SCM_RIGHTS fd array will be cut short at
> > that point, and MSG_CTRUNC is set on return of recvmsg(). This is
> > highly problematic behaviour, because it leaves the receiver
> > wondering what happened. As per man page MSG_CTRUNC is supposed to
> > indicate that the control buffer was sized too short, but suddenly
> > a permission error might result in the exact same flag being set.
> > Moreover, the receiver has no chance to determine how many fds got
> > originally sent and how many were suppressed.[1]
> >
> > Add two MSG_* flags:
> 
> Since we only have 5 bits remaining for future extension,
> we need to consider the use case a bit more carefully.
> 
> 
> >  - MSG_RIGHTS_DENIAL is set whenever any file is rejected by the LSM
> >    during recvmsg() of SCM_RIGHTS fds.
> 
> Is this really needed ?
> 
> Even if the fd array is truncated, the application will traverse
> the array anyway since it has some fds already installed (to
> clean up in case of MSG_CTRUNC ?).

The socket option suggested later: Wouldn't it be simpler to just add a
socket that instructs the scm layer to send all fds that were denied
with a -EPERM sentinel. Then systemd can:

* detect all fds that were denied simply by seeing they were -EPERM
* keep the count in tact

and - see below - get rid of the blatant layering violation in here...

> Then, it will find the -EPERM entry.

I assume we're talking about the same thing. All the complicated rest
should be dropped. There's a bunch of nonsense in that uapi entry -
quite a few items are merely drafts.

> > -int receive_fd(struct file *file, int __user *ufd, unsigned int o_flags)
> > +int receive_fd_msg(struct file *file, int __user *ufd, unsigned int o_flags,
> > +              unsigned int *msg_flags)
> >  {
> >         int error;
> >
> >         error = security_file_receive(file);
> > -       if (error)
> > +       if (error) {
> > +               if (msg_flags)
> > +                       *msg_flags |= MSG_RIGHTS_DENIAL;
> > +
> > +               if (ufd)
> > +                       put_user(-EPERM, ufd);
> > +
> >                 return error;
> > +       }

I don't like this. It's bad enought that the generic file layer needs to
call into __receive_sock() I don't want it to poke into other subsystems
internals even more. That's just not appropriate. Get this out of the
VFS's way, please.

