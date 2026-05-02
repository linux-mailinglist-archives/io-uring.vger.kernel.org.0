Return-Path: <io-uring+bounces-13202-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qX7gD19S9WmDKQIAu9opvQ
	(envelope-from <io-uring+bounces-13202-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 02 May 2026 03:24:47 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B78B4B0912
	for <lists+io-uring@lfdr.de>; Sat, 02 May 2026 03:24:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id E83063001FB5
	for <lists+io-uring@lfdr.de>; Sat,  2 May 2026 01:24:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85AF9273816;
	Sat,  2 May 2026 01:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tglJjcaN"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-dl1-f50.google.com (mail-dl1-f50.google.com [74.125.82.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1775133EF
	for <io-uring@vger.kernel.org>; Sat,  2 May 2026 01:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777685080; cv=pass; b=HrDHIEdX7rf1zymySw8qpJnM6jkEHXnk4TUzmUcaoZ4zskOgYPMg00Hfr+Ww2dZXO4oTOV0MG0Chsc5aKvKD1gBi9HL5mFQF3K8FP99S2Irr66jsKXpesYdWbNdOeMgTPHqQLBUvZ1k0YgXrS+NFy29NLXFr/8bMe5odAdViquE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777685080; c=relaxed/simple;
	bh=tlWzm/LweUKhSpUnvp6PcsofBh7GX2GlpWV4iQcCDA4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EKmluMFY8oU1516bLOuVAln0uz4cfGC0vXtM/pnXlCkTooUBu7Fnh3jg3EGfgx7jXDmgFd0/4GWis85UgLQn9aUnebK0h9KTcgSE9NmKhntT+8e3T/jRVXpEzVbFf2YelM9FYIzu9HVIjgzyA//ygLUnvvdc97hxmmctrbW17Ok=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tglJjcaN; arc=pass smtp.client-ip=74.125.82.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-dl1-f50.google.com with SMTP id a92af1059eb24-12c8f9846c8so3257965c88.0
        for <io-uring@vger.kernel.org>; Fri, 01 May 2026 18:24:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777685078; cv=none;
        d=google.com; s=arc-20240605;
        b=OTtY3p6fxK27WK9zp3L+RXa/GoN9bvPAnMTIkP2HCmzSRUrwCYxvGeDhGiW1BOvW/e
         AexkjBaIUELtbouSfhr2qyeppBKtGZT86C5M9ppToOmFWJrSalBstF0N6AorknvsP0tq
         9up59E34hGrq2RJbnZF54Z8OGFjHxfZl5hGvL+jmQHr1bTkQ+NVkxUIkgDdL5yNY9TNu
         UrVVkAScf0Ty1FTJB7B1ONrXbt74F0cbi5f2qmAHqx5vDGSmcA7OHUmo0qUJjVXVqax+
         kGJD8AAkZpJeTgU6fmbFhtPEqVyYKF5244hYkbu+MWF71VJLpKMvXRENC6O08/bwrSxb
         hoZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=UTYEXtZbnOW94bihUSWzw/uzxtoul8H4TwtkWQ/OOcs=;
        fh=gCDGH669WkeCCEllPXyN6Sb6NDX2ZNZXB/aewTkDJlU=;
        b=HidMC52vjNXpsIvlkIgNamNbnr2ThsNmU6Wq+bSUh4bSmbBKLcKDIDN7692CstXd/p
         WBWqqGlLNxntlacEMLkgXOYD9XbN6AkhPUqzXgwumqcfXd3zyyXc2jaXPrE+9N01pyAW
         HCQMPV+xjJmMp2Zah1CalAmehTa++VW7a5uhnhZ8TTYuC1ToQs2MbTOzYU4SvO/A0oMw
         JwCMWM9nXlwW4LUKrqJnf8L4i5M6q6OBRow6OTxvt/82a/eoZme003uu41kY6AnfW4kt
         SwH6zhtZpg5B7blODuxs4b4AE0lwG+x35vdsOI4U1aILr/iB9JE7ZAYiXFF4Jdz6yadt
         z5dQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777685078; x=1778289878; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UTYEXtZbnOW94bihUSWzw/uzxtoul8H4TwtkWQ/OOcs=;
        b=tglJjcaNWzt4y7utHMv+h2WL5OY5tf5X5qF5TicSwYXh7uIlMSi3KGJkcoVmkjYyk7
         NRPdtihqKCqv0HTBx8FcZrVYkTJOT0IhjprmkHL88ahl8tGnbEw9q3Bk95tIRC4vPjC5
         huKTLA6roSivAdw/1nwE/w+FaU0jaHvMhFPS+NGeD9YXIsDfXL9ZBp6UTL8rnABdmcGo
         K8PrvuslN0Hr8RQeiJhswis2WE5mgekajTIad+8M9TuDZ+BpNsyx0/qpGfUzlTwY6McZ
         ey407Z2nBmi+QqZU9C01XJBn+Jc9oWjE5MqdVr7mzP5cDy3FuvEdDLJvElRZHKhvSbHQ
         m7Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777685078; x=1778289878;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UTYEXtZbnOW94bihUSWzw/uzxtoul8H4TwtkWQ/OOcs=;
        b=iGxvYKCHFxzsLAN/iF0+Brsqt2DhYVxjzpjOecl2Am9nG2/mXatSXhMwoXhlDyhWLO
         LDAGum2l4tRbmNEdR2cFbCGTz4+Uhc06C4sWI/mumAqazvZ4a5Bm1kBLAsygFtdKW5ak
         pFLCc7V58VsKVi7Bv8hd+KlJ5A19zx3HfhTdlC3A6CeNjeIIhWfM98pGF+baDue+SmBp
         5F/zNdYxL+cBTvlbu4qMCpd2k5yA4nH7Xi/clF2U28mZBjGjzhoQSAua/3UQS6HOL1KF
         DG9gJJY96016ooY9HL1ZT6ueSNPGfbpkhoH4hiE2RN+ArdOJEDN89UNIOXmquvDB+Eyp
         wXEw==
X-Forwarded-Encrypted: i=1; AFNElJ9OMV3bewpB6eMF3xelips+BlwLUQMlHPzga9fcFW3aAt7Nk1TaJfjO8LV4cuntyiBCXUFbtkuSVg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwUWnzsF/vJfFfICu4quBnn5zbkUZD+3nt+5vTzbXZQxITXjvHz
	u4HSPY0kVNX58pqtsykKisQ5qvNMBaOkAYWvY7eJCZvZnkyls78ueX8XtX374+o7hom0i5As2qG
	SpEw6zXeII3eG4MmBT01QixY7ue6AxbgozA1cM29g
X-Gm-Gg: AeBDiev9kPQVY1CEdDI/pqKqoLu+Tz33DEI5zeLLcXdvoXAGASTSbBqrj9wy7FcNDEc
	QmA2KJ5sed6hUy4e5rwPbuvVZ9+QEKrrsoxY5n9BQX9I3YVFhechwYNh9fo1mpyY7obiqL4h4II
	Ae06V60iImMZa6YcPUi9pzLWjAH6AM+twJPIx57P4p5dQBrpD24LpdfUxS632Mw6MY4jVTu+EKa
	8D1vLXWepA18NNtw7zMSFQWyIaADob5MadDF2mH0y8DCu5q2eg0lTfS8LW1KAiRfUXV3gc704Eo
	DjbmOOWBhnlBXBd/ripiXM09NhcEO/Jumad9SwY8rmCN+duzvzhszOqYoZiagQUFe9QZk+RFUsa
	355gTyIrUEC8ahg+mFEY3Bc1xRX3NcJb4DH06BcSveCORys6AtlDApXBFyg4Z8B/Xme4SCcyrhw
	==
X-Received: by 2002:a05:7022:2514:b0:12d:de3f:f3d9 with SMTP id
 a92af1059eb24-12dfd8459ffmr501080c88.35.1777685077641; Fri, 01 May 2026
 18:24:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260428175125.2705296-1-jkoolstra@xs4all.nl> <20260428175125.2705296-2-jkoolstra@xs4all.nl>
 <CAAVpQUBKeN2KtRkRAFr8sYJM1_-rbkdjsujau5fAyaiP_dO6FA@mail.gmail.com> <89346381.2074764.1777649680664@kpc.webmail.kpnmail.nl>
In-Reply-To: <89346381.2074764.1777649680664@kpc.webmail.kpnmail.nl>
From: Kuniyuki Iwashima <kuniyu@google.com>
Date: Fri, 1 May 2026 18:24:26 -0700
X-Gm-Features: AVHnY4Ivy4FFEa5elE6XvX0acVHEeFy5f9-HW7mgZQCbQK3BFpKAMdSRMm9bNLQ
Message-ID: <CAAVpQUDKgWdgPjPmJKhNxofssasS8-RdaLAcbFXHMWH8ztMJXA@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] net: af_unix: Useful handling of LSM denials on SCM_RIGHTS
To: Jori Koolstra <jkoolstra@xs4all.nl>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, 
	Willem de Bruijn <willemb@google.com>, "David S . Miller" <davem@davemloft.net>, 
	Jakub Kicinski <kuba@kernel.org>, Jens Axboe <axboe@kernel.dk>, Kees Cook <kees@kernel.org>, 
	Simon Horman <horms@kernel.org>, Andy Lutomirski <luto@amacapital.net>, Will Drewry <wad@chromium.org>, 
	Jeff Layton <jlayton@kernel.org>, Oleg Nesterov <oleg@redhat.com>, Andrei Vagin <avagin@gmail.com>, 
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, Mateusz Guzik <mjguzik@gmail.com>, 
	Joel Granados <joel.granados@kernel.org>, Charlie Mirabile <cmirabil@redhat.com>, 
	Aleksa Sarai <cyphar@cyphar.com>, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org, 
	io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 2B78B4B0912
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4];
	R_DKIM_ALLOW(-0.20)[google.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-13202-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FREEMAIL_TO(0.00)[xs4all.nl];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[26];
	FREEMAIL_CC(0.00)[zeniv.linux.org.uk,kernel.org,suse.cz,google.com,redhat.com,davemloft.net,kernel.dk,amacapital.net,chromium.org,gmail.com,virtuozzo.com,cyphar.com,vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kuniyu@google.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,mail.gmail.com:mid]

On Fri, May 1, 2026 at 8:34=E2=80=AFAM Jori Koolstra <jkoolstra@xs4all.nl> =
wrote:
>
>
> > Op 30-04-2026 04:04 CEST schreef Kuniyuki Iwashima <kuniyu@google.com>:
> >
> >
> > On Tue, Apr 28, 2026 at 10:51=E2=80=AFAM Jori Koolstra <jkoolstra@xs4al=
l.nl> wrote:
> > >
> > > Right now if some LSM such as Smack denies an AF_UNIX socket peer to
> > > receive an SCM_RIGHTS fd the SCM_RIGHTS fd array will be cut short at
> > > that point, and MSG_CTRUNC is set on return of recvmsg(). This is
> > > highly problematic behaviour, because it leaves the receiver
> > > wondering what happened. As per man page MSG_CTRUNC is supposed to
> > > indicate that the control buffer was sized too short, but suddenly
> > > a permission error might result in the exact same flag being set.
> > > Moreover, the receiver has no chance to determine how many fds got
> > > originally sent and how many were suppressed.[1]
> > >
> > > Add two MSG_* flags:
> >
> > Since we only have 5 bits remaining for future extension,
> > we need to consider the use case a bit more carefully.
> >
>
> Right. Since it wasn't a lot of work I implemented it exactly as the requ=
est
> was made from userspace, and then discuss it from there. By the way, I su=
ppose
> nothing can be done about that small flag space?

We could reuse an existing flag (e.g. MSG_FIN, MSG_RST)
if we were confident enough that the userspace does not use
the flag for a specific socket type.

Another option is to add another syscall, recvmsg2.


>
> >
> > >  - MSG_RIGHTS_DENIAL is set whenever any file is rejected by the LSM
> > >    during recvmsg() of SCM_RIGHTS fds.
> >
> > Is this really needed ?
> >
> > Even if the fd array is truncated, the application will traverse
> > the array anyway since it has some fds already installed (to
> > clean up in case of MSG_CTRUNC ?).
> >
> > Then, it will find the -EPERM entry.
> >
> > I assume no one uses MSG_RIGHTS_DENIAL without
> > MSG_RIGHTS_FILTER.
> >
>
> I guess that is a fair assumption to make. We can certainly do without
> MSG_RIGHTS_DENIAL if saving flags is important. I also suggested that
> we may see whether we can make MSG_RIGHTS_FILTER the default behavior.
> In the mean time I've found grep.app, and it turns out the answer is no.
> Apparently almost no one checks even for the truncation flag (mostly 1 fd
> is passed and then it is check the cmsg lenght). But cpython has this for
> instance:
>
>     /* Close all descriptors coming from SCM_RIGHTS, so they don't leak. =
*/
>     for (cmsgh =3D ((msg.msg_controllen > 0) ? CMSG_FIRSTHDR(&msg) : NULL=
);
>          cmsgh !=3D NULL; cmsgh =3D CMSG_NXTHDR(&msg, cmsgh)) {
>         cmsg_status =3D get_cmsg_data_len(&msg, cmsgh, &cmsgdatalen);
>         if (cmsg_status < 0)
>             break;
>         if (cmsgh->cmsg_level =3D=3D SOL_SOCKET &&
>             cmsgh->cmsg_type =3D=3D SCM_RIGHTS) {
>             size_t numfds;
>             int *fdp;
>             numfds =3D cmsgdatalen / sizeof(int);
>             fdp =3D (int *)CMSG_DATA(cmsgh);
>             while (numfds-- > 0)
>                 close(*fdp++);
>         }
>         if (cmsg_status !=3D 0)
>             break;
>     }
>
> >
> > >  - If MSG_RIGHTS_FILTER is passed as a flag to recvmsg(), the SCM_RIG=
HTS
> >
> > Does this flag need per-recvmsg() granularity ?
> >
>
> Perhaps not. What would be the alternative? A fcntl option for the socket=
 fd?

I'd add a new socket option like

setsockopt(SOL_SOCKET, SO_RIGHTS_TRUNC, &(int){0}, sizeof(int));


>
> > If the application does not welcome the truncated fd array,
> > it would have passed MSG_RIGHTS_FILTER to every
> > recvmsg(), no ?
> >
>
> Correct.
>
>
> Thanks,
> Jori.

