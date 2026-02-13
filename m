Return-Path: <io-uring+bounces-12204-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IMoZKSOVj2nNRgEAu9opvQ
	(envelope-from <io-uring+bounces-12204-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 13 Feb 2026 22:18:27 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C8F2C139966
	for <lists+io-uring@lfdr.de>; Fri, 13 Feb 2026 22:18:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 03C2E300382F
	for <lists+io-uring@lfdr.de>; Fri, 13 Feb 2026 21:18:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C43927874F;
	Fri, 13 Feb 2026 21:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gnuweeb.org header.i=@gnuweeb.org header.b="A4Kr36Qg"
X-Original-To: io-uring@vger.kernel.org
Received: from server-vie001.gnuweeb.org (server-vie001.gnuweeb.org [89.58.62.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBF2626FA6F
	for <io-uring@vger.kernel.org>; Fri, 13 Feb 2026 21:18:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.62.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771017501; cv=none; b=dnMUBewIS2xfqC96CQmedzKnOEDDi0jMnBKiywC0BvInLAPwB2LSmIcKcLDqNLHymJoEXS/GFYwhxoYxTC6tuHWW3/aMD08J4EqGAB9JNQ4p1/JSFZhK/JCmqmKxJdTBaO1aqQg5UnJJ4E2mDoQbLu+6z/pFIuS2qxy7nUc8vSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771017501; c=relaxed/simple;
	bh=kNVss+x+weoTIm8BVpBje4e7zHC+lQY8Qzc/3s7/OOg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JKZgSM7Et11BhbKBbvXTys8Nejpd0j8b5W06pHvCKcBpdmcdOIcZWG6w7MwzE3m9GJUbrh/facM7MoI/bws7HoVikpipm9/l2BA+5ygGzTcD6z2TpppsWXmvVLLHh8yE+DvOSn5EdueCOHlaG+h4O8qyOE1pX3ToP/70/vY3u6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gnuweeb.org; spf=pass smtp.mailfrom=gnuweeb.org; dkim=pass (2048-bit key) header.d=gnuweeb.org header.i=@gnuweeb.org header.b=A4Kr36Qg; arc=none smtp.client-ip=89.58.62.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=gnuweeb.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnuweeb.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
	s=new2025; t=1771017497;
	bh=kNVss+x+weoTIm8BVpBje4e7zHC+lQY8Qzc/3s7/OOg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type:Content-Transfer-Encoding:Message-ID:Date:From:
	 Reply-To:Subject:To:Cc:In-Reply-To:References:Resent-Date:
	 Resent-From:Resent-To:Resent-Cc:User-Agent:Content-Type:
	 Content-Transfer-Encoding;
	b=A4Kr36Qgv9uz70U0vgYrXfhmb9GiHmYO3gXFWnqI3RsMfmrJHkQCUl31O4UXfWLNu
	 akm5Cxktagb++uf1ZA5QQFpdvV9qKehI3kpaLPgNgK1QKc8sd2Whm4AU7UL+9BXRbV
	 Fe8W6YkLZc5XVfHdjNWUrbYSfOosKehnc4tUQgsBOpyw8ZPyb47DvfFR5rYmGUBUNQ
	 nx4zHttXLl8xPPkBzNDd7EtSCNGg8dCMTJe8iQoQ1VD2PXatLJrHz4TKbXbiiOQSKE
	 WuKygXt8ToL81wkm9WHkIiYC3DaK0nVBwlZX0ILO8h14VzGO3qHuLpUUz+USz7Ek1G
	 bx0HZ3VGnsUfA==
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	by server-vie001.gnuweeb.org (Postfix) with ESMTPSA id CE3C73204B4D
	for <io-uring@vger.kernel.org>; Fri, 13 Feb 2026 21:18:17 +0000 (UTC)
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-50334dd44d2so16202621cf.1
        for <io-uring@vger.kernel.org>; Fri, 13 Feb 2026 13:18:17 -0800 (PST)
X-Gm-Message-State: AOJu0Yy6EjR6822jpxvBAXh5G90gFLfg+RUK/cZuuDp2ZqthAmATyVMu
	SRH41TX+QvLTokOSsq2L8Dad4G3BRr0ySAeML+t5blGC8BMG5GV8RXlvCE6ERxZKcZ5TSZUIyXP
	WPYTk9wjOkdwAq21b/g9JxVZ0Xi7j7C0=
X-Received: by 2002:ac8:58d1:0:b0:4d2:4df8:4cb5 with SMTP id
 d75a77b69052e-506b3f830f9mr12323531cf.4.1771017496717; Fri, 13 Feb 2026
 13:18:16 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260213210548.851503-1-ammarfaizi2@gnuweeb.org>
 <177101682427.298850.12069195780298295812.b4-ty@kernel.dk> <00bc96d8-c304-412c-b176-1b30ff0847af@kernel.dk>
In-Reply-To: <00bc96d8-c304-412c-b176-1b30ff0847af@kernel.dk>
From: Ammar Faizi <ammarfaizi2@gnuweeb.org>
X-Gw-Bpl: wU/cy49Bu1yAPm0bW2qiliFUIEVf+EkEatAboK6pk2H2LSy2bfWlPAiP3YIeQ5aElNkQEhTV9Q==
Date: Sat, 14 Feb 2026 04:18:00 +0700
X-Gmail-Original-Message-ID: <CAFBCWQKswYaojnn+w2bskNGvQk3QG_emYvFV=nPafrBkPhKuvg@mail.gmail.com>
X-Gm-Features: AZwV_QimfzEmjfPstjdplcdpjBWF8klmFVEh_LFnHBCWcxcGeKo6JGy-yNn8nBI
Message-ID: <CAFBCWQKswYaojnn+w2bskNGvQk3QG_emYvFV=nPafrBkPhKuvg@mail.gmail.com>
Subject: Re: [PATCH liburing] src/Makefile: Fix missing bpf_filter.h installation
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring Mailing List <io-uring@vger.kernel.org>, "GNU/Weeb Mailing List" <gwml@vger.gnuweeb.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gnuweeb.org,reject];
	R_DKIM_ALLOW(-0.20)[gnuweeb.org:s=new2025];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12204-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[gnuweeb.org:+];
	TO_DN_ALL(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ammarfaizi2@gnuweeb.org,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,gnuweeb.org:dkim]
X-Rspamd-Queue-Id: C8F2C139966
X-Rspamd-Action: no action

On Sat, Feb 14, 2026 at 4:10=E2=80=AFAM Jens Axboe wrote:
> BTW, for the future, for:
>
> Fixes: 46b5c4d66232dcadd0f46c875e6fabce3b3dea85 ("src/include/liburing.h:=
 add bpf_filter.h header")
>
> shorten the sha to 12 chars, we don't need the full sha.

I see, well noted, thanks for the reminder. Greg told me the same
thing, but I clearly let it slip through the cracks.

I've updated my .gitconfig now.

--=20
Ammar Faizi

