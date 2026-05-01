Return-Path: <io-uring+bounces-13194-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qPukEV3I9GmPEgIAu9opvQ
	(envelope-from <io-uring+bounces-13194-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 01 May 2026 17:35:57 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 91B1C4AD9EF
	for <lists+io-uring@lfdr.de>; Fri, 01 May 2026 17:35:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BEF4B3026772
	for <lists+io-uring@lfdr.de>; Fri,  1 May 2026 15:35:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E35243CE4A2;
	Fri,  1 May 2026 15:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=xs4all.nl header.i=@xs4all.nl header.b="jnTpLX1R"
X-Original-To: io-uring@vger.kernel.org
Received: from ewsoutbound.kpnmail.nl (ewsoutbound.kpnmail.nl [195.121.94.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 770F22E5B2A
	for <io-uring@vger.kernel.org>; Fri,  1 May 2026 15:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.121.94.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777649752; cv=none; b=YZf3eWU99r0N/A0FqwP+4C/Hr8VzKfO2dvMvTGDs4NQnuaLcxytlD2EadV9S37QAESRhTkWU+sz+OrvueVZd0znhJ/sAs9+PMqSFFIRxuXSJgaYolkJmf0KwpZQwNUsKX4AVbYG4MENC6MbipRSUxQ+dNS35LOk57uJwyJBhHfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777649752; c=relaxed/simple;
	bh=27HBlAxg0ZM6N2nrQoLYUcVV7TnAlR8/aIP3GxzSa9s=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=LZ+DelxzA09fFAgVG/8lEW3EN/P0I0+Zkn60tJmHaM1mv4aXeYBA1+m45iQ3XX/CDgTCUbP1nNQsTeexaM419ydQFwuEwJeSuEsmLJ+44xlDovLeKnGhBeQFBCvVyYXismBaq/+CZfoRRNT2uZvCuhmnUY6emuWo262WY0NSX+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xs4all.nl; spf=pass smtp.mailfrom=xs4all.nl; dkim=pass (2048-bit key) header.d=xs4all.nl header.i=@xs4all.nl header.b=jnTpLX1R; arc=none smtp.client-ip=195.121.94.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xs4all.nl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xs4all.nl
X-KPN-MessageId: 451195f7-4573-11f1-afe2-005056994fde
Received: from mta.kpnmail.nl (unknown [10.31.161.189])
	by ewsoutbound.so.kpn.org (Halon) with ESMTPS
	id 451195f7-4573-11f1-afe2-005056994fde;
	Fri, 01 May 2026 17:34:40 +0200 (CEST)
Received: from mtaoutbound.kpnmail.nl (unknown [10.128.135.189])
	by mta.kpnmail.nl (Halon) with ESMTP
	id 45107614-4573-11f1-b5d1-0050569981f5;
	Fri, 01 May 2026 17:34:40 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=xs4all.nl; s=xs4all01;
	h=content-type:mime-version:subject:message-id:to:from:date;
	bh=yWlYvHDKJLboPw9xhm3CMUezHzmqhjNa6HKZQkEvPVQ=;
	b=jnTpLX1Ri3JA4mDO10E7pg44QFiChMj5lRgY4JAZEiVY2yZCGnTQc8cRaBhaVjpt7ZltUgK2RMZ3E
	 M78CQ86x2rRoZxcMJdnbES5oddauFOdW2vX3n1GQfnsXzQ+mGrYuh5mCGjVHMdnmc5zzpmxU4t5KrO
	 9QJ/0D5hdkS6X1sHYi+yZnJNitTfhvUK1i+0YwJN/qp39Kri9r51h+5x7+FDFKWJmmnw3nuKisftzZ
	 UblDWpvZqwkotbs3kYhIIfmqIgl5iCzkD+Sh6losmwQFndSax7Cqo+Fwe3Upj8en/AUcIetXgdHg19
	 Eq31JTRYRp73sO//MsNbYLe10mApeFw==
X-KPN-MID: 33|+wst0lK91gmxlExsuJLOoikJCsA0QLTVmXpcK9nSTwrmv8tILalQp4kUKabb/fl
 23gsYBj7cofRS+4WVOGphlVqzjqy98YIhFTStYjYCvDY=
X-CMASSUN: 33|pyE9OPP/7F9Ad8pTvxO8IbpJEd1c575BI62ZUn6pjmt4BfrO94fDDv6nxUOe1PV
 AfWwg25InOqgBieh3R8hXPg==
X-KPN-VerifiedSender: Yes
Received: from cpxoxapps-mh01 (cpxoxapps-mh01.personalcloud.so.kpn.org [10.128.135.207])
	by mtaoutbound.kpnmail.nl (Halon) with ESMTPSA
	id 4503de11-4573-11f1-94b1-00505699eff2;
	Fri, 01 May 2026 17:34:40 +0200 (CEST)
Date: Fri, 1 May 2026 17:34:40 +0200 (CEST)
From: Jori Koolstra <jkoolstra@xs4all.nl>
To: Kuniyuki Iwashima <kuniyu@google.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemb@google.com>,
	"David S . Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Kees Cook <kees@kernel.org>, Simon Horman <horms@kernel.org>,
	Andy Lutomirski <luto@amacapital.net>,
	Will Drewry <wad@chromium.org>, Jeff Layton <jlayton@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>, Andrei Vagin <avagin@gmail.com>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	Mateusz Guzik <mjguzik@gmail.com>,
	Joel Granados <joel.granados@kernel.org>,
	Charlie Mirabile <cmirabil@redhat.com>,
	Aleksa Sarai <cyphar@cyphar.com>, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	io-uring@vger.kernel.org
Message-ID: <89346381.2074764.1777649680664@kpc.webmail.kpnmail.nl>
In-Reply-To: <CAAVpQUBKeN2KtRkRAFr8sYJM1_-rbkdjsujau5fAyaiP_dO6FA@mail.gmail.com>
References: <20260428175125.2705296-1-jkoolstra@xs4all.nl>
 <20260428175125.2705296-2-jkoolstra@xs4all.nl>
 <CAAVpQUBKeN2KtRkRAFr8sYJM1_-rbkdjsujau5fAyaiP_dO6FA@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] net: af_unix: Useful handling of LSM denials on
 SCM_RIGHTS
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Priority: 3
Importance: Normal
X-Rspamd-Queue-Id: 91B1C4AD9EF
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[xs4all.nl,reject];
	R_DKIM_ALLOW(-0.20)[xs4all.nl:s=xs4all01];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13194-lists,io-uring=lfdr.de];
	HAS_X_PRIO_THREE(0.00)[3];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[zeniv.linux.org.uk,kernel.org,suse.cz,google.com,redhat.com,davemloft.net,kernel.dk,amacapital.net,chromium.org,gmail.com,virtuozzo.com,cyphar.com,vger.kernel.org];
	FREEMAIL_FROM(0.00)[xs4all.nl];
	RCPT_COUNT_TWELVE(0.00)[26];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jkoolstra@xs4all.nl,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[xs4all.nl:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]


> Op 30-04-2026 04:04 CEST schreef Kuniyuki Iwashima <kuniyu@google.com>:
>=20
> =20
> On Tue, Apr 28, 2026 at 10:51=E2=80=AFAM Jori Koolstra <jkoolstra@xs4all.=
nl> wrote:
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
>=20
> Since we only have 5 bits remaining for future extension,
> we need to consider the use case a bit more carefully.
>=20

Right. Since it wasn't a lot of work I implemented it exactly as the reques=
t
was made from userspace, and then discuss it from there. By the way, I supp=
ose
nothing can be done about that small flag space?

>=20
> >  - MSG_RIGHTS_DENIAL is set whenever any file is rejected by the LSM
> >    during recvmsg() of SCM_RIGHTS fds.
>=20
> Is this really needed ?
>=20
> Even if the fd array is truncated, the application will traverse
> the array anyway since it has some fds already installed (to
> clean up in case of MSG_CTRUNC ?).
>=20
> Then, it will find the -EPERM entry.
>=20
> I assume no one uses MSG_RIGHTS_DENIAL without
> MSG_RIGHTS_FILTER.
>=20

I guess that is a fair assumption to make. We can certainly do without
MSG_RIGHTS_DENIAL if saving flags is important. I also suggested that
we may see whether we can make MSG_RIGHTS_FILTER the default behavior.
In the mean time I've found grep.app, and it turns out the answer is no.
Apparently almost no one checks even for the truncation flag (mostly 1 fd
is passed and then it is check the cmsg lenght). But cpython has this for
instance:

    /* Close all descriptors coming from SCM_RIGHTS, so they don't leak. */
    for (cmsgh =3D ((msg.msg_controllen > 0) ? CMSG_FIRSTHDR(&msg) : NULL);
         cmsgh !=3D NULL; cmsgh =3D CMSG_NXTHDR(&msg, cmsgh)) {
        cmsg_status =3D get_cmsg_data_len(&msg, cmsgh, &cmsgdatalen);
        if (cmsg_status < 0)
            break;
        if (cmsgh->cmsg_level =3D=3D SOL_SOCKET &&
            cmsgh->cmsg_type =3D=3D SCM_RIGHTS) {
            size_t numfds;
            int *fdp;
            numfds =3D cmsgdatalen / sizeof(int);
            fdp =3D (int *)CMSG_DATA(cmsgh);
            while (numfds-- > 0)
                close(*fdp++);
        }
        if (cmsg_status !=3D 0)
            break;
    }

>=20
> >  - If MSG_RIGHTS_FILTER is passed as a flag to recvmsg(), the SCM_RIGHT=
S
>=20
> Does this flag need per-recvmsg() granularity ?
>=20

Perhaps not. What would be the alternative? A fcntl option for the socket f=
d?

> If the application does not welcome the truncated fd array,
> it would have passed MSG_RIGHTS_FILTER to every
> recvmsg(), no ?
>=20

Correct.


Thanks,
Jori.

