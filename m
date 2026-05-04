Return-Path: <io-uring+bounces-13235-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GK4KKs/a+GnG2QIAu9opvQ
	(envelope-from <io-uring+bounces-13235-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 04 May 2026 19:43:43 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7272F4C20DA
	for <lists+io-uring@lfdr.de>; Mon, 04 May 2026 19:43:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id DAA273005ABB
	for <lists+io-uring@lfdr.de>; Mon,  4 May 2026 17:43:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E29713E4C66;
	Mon,  4 May 2026 17:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=xs4all.nl header.i=@xs4all.nl header.b="X9uVeR9j"
X-Original-To: io-uring@vger.kernel.org
Received: from ewsoutbound.kpnmail.nl (ewsoutbound.kpnmail.nl [195.121.94.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 899431862
	for <io-uring@vger.kernel.org>; Mon,  4 May 2026 17:43:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.121.94.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777916619; cv=none; b=N9U62+M9pIrAz/SMmy6LN1f309vW0Ds+rwSGAPJ8VSe6av21moYGXrcC/L11Ptodi1q0pY3W+dZTWugFV8kG7umxpkPtGXke0GgTf6bCkCpcxPa9Xy0+KeNFRfQjyjQ1+mVDFZV0M7U8CYMo/Ng8mnLoBtn93Cn3rf6cRe+cVhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777916619; c=relaxed/simple;
	bh=UmnAEidipRT5i3DpB57vlHvWvY7ZbghL8NryuFr/o2E=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=W51yPz2apBxNR7Z4uXCnGy1nLIXCEBzZizVTwdcTGVz4Cjt3yHoaP8PZtVKvvJ/9cA7b+2IgzWXFIKZo90pPkxQiRIF4spCryQGj2OxngC/Blhh5AJjIwp8mWrveAFyHlRUaVB39aSpnZ5kgP5PQi1LV4r4wQdIZTCJ3tXHcuZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xs4all.nl; spf=pass smtp.mailfrom=xs4all.nl; dkim=pass (2048-bit key) header.d=xs4all.nl header.i=@xs4all.nl header.b=X9uVeR9j; arc=none smtp.client-ip=195.121.94.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xs4all.nl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xs4all.nl
X-KPN-MessageId: c3abf1da-47e0-11f1-bea8-005056992ed3
Received: from mta.kpnmail.nl (unknown [10.31.161.188])
	by ewsoutbound.so.kpn.org (Halon) with ESMTPS
	id c3abf1da-47e0-11f1-bea8-005056992ed3;
	Mon, 04 May 2026 19:43:30 +0200 (CEST)
Received: from mtaoutbound.kpnmail.nl (unknown [10.128.135.189])
	by mta.kpnmail.nl (Halon) with ESMTP
	id c3b04f5b-47e0-11f1-80fc-00505699693e;
	Mon, 04 May 2026 19:43:30 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=xs4all.nl; s=xs4all01;
	h=content-type:mime-version:subject:message-id:to:from:date;
	bh=kdpYfIX+URTvw/wf5koeiRsTKprTy2NaYWQX03NB+IU=;
	b=X9uVeR9j1Iz9IcchmfYfcB2+oARQT9t00sirJbn8eZN5SB+W/czEx2L9vOWtBlE8YYIw1a9/uf0QL
	 JtbgDvpP0p7Bn/X00H82OIfktOat2f8Mui7MMc74KIrTzVkqjdOaWRu+BxVGultMEfJeQTMm1o1Nb/
	 wXLCaW1fqbs5QxhPTQd8CNfbnfC3LDUvFajwKv3AxyvSAoQeJ3TjvNA2+6jc5r1adRgt0Wqt4KXbBW
	 eSmyroMauz3V3v89IiN8uQCMNOGlng/LskwtHpT4/WxmRQhQEFQOihrl+k1RpmdagSJAKn2HVWWAB0
	 iPtn6T0mXfDGEfuhS0K/CA9XfW+PVAg==
X-KPN-MID: 33|Oe96tHjdqLcXG0+4p3g9qL+qjYCkVqfDCbZeSJ15n5e+210MBUIX8rTzjMrdbVD
 FRArJlNNiY+UlB9IHfFx7dOSKHBq8DIgfF2pCihJ73ow=
X-CMASSUN: 33|sm6o1OA6K6UEpMWW6cTWJ0kgfRL2hfIYXSaPNctPG5j1Bd6gVKJ0hWLwCZMWN+I
 Bk/mQSOTh0WfSmVVk1hIwew==
X-KPN-VerifiedSender: Yes
Received: from cpxoxapps-mh02 (cpxoxapps-mh02.personalcloud.so.kpn.org [10.128.135.208])
	by mtaoutbound.kpnmail.nl (Halon) with ESMTPSA
	id c39bf502-47e0-11f1-94b1-00505699eff2;
	Mon, 04 May 2026 19:43:30 +0200 (CEST)
Date: Mon, 4 May 2026 19:43:30 +0200 (CEST)
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
Message-ID: <1440036704.77422.1777916610532@kpc.webmail.kpnmail.nl>
In-Reply-To: <CAAVpQUDKgWdgPjPmJKhNxofssasS8-RdaLAcbFXHMWH8ztMJXA@mail.gmail.com>
References: <20260428175125.2705296-1-jkoolstra@xs4all.nl>
 <20260428175125.2705296-2-jkoolstra@xs4all.nl>
 <CAAVpQUBKeN2KtRkRAFr8sYJM1_-rbkdjsujau5fAyaiP_dO6FA@mail.gmail.com>
 <89346381.2074764.1777649680664@kpc.webmail.kpnmail.nl>
 <CAAVpQUDKgWdgPjPmJKhNxofssasS8-RdaLAcbFXHMWH8ztMJXA@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] net: af_unix: Useful handling of LSM denials on
 SCM_RIGHTS
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
Importance: Normal
X-Rspamd-Queue-Id: 7272F4C20DA
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[xs4all.nl,reject];
	R_DKIM_ALLOW(-0.20)[xs4all.nl:s=xs4all01];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13235-lists,io-uring=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,xs4all.nl:dkim]


> Op 02-05-2026 03:24 CEST schreef Kuniyuki Iwashima <kuniyu@google.com>:
> 
> > >
> > > Does this flag need per-recvmsg() granularity ?
> > >
> >
> > Perhaps not. What would be the alternative? A fcntl option for the socket fd?
> 
> I'd add a new socket option like
> 
> setsockopt(SOL_SOCKET, SO_RIGHTS_TRUNC, &(int){0}, sizeof(int));
> 
> 

I think this is reasonable suggestion (and better than using the MSG_ flags).
Let's just let this sit for a few days to see if anyone else has suggestions/
objections.

