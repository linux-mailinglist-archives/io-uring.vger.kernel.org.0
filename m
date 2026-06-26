Return-Path: <io-uring+bounces-13849-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id q8WxLOO5PmorKwkAu9opvQ
	(envelope-from <io-uring+bounces-13849-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 26 Jun 2026 19:41:55 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 21AC06CF70B
	for <lists+io-uring@lfdr.de>; Fri, 26 Jun 2026 19:41:55 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="iMRts3/m";
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13849-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.234.253.10 as permitted sender) smtp.mailfrom="io-uring+bounces-13849-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=2")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4FD1430234D2
	for <lists+io-uring@lfdr.de>; Fri, 26 Jun 2026 17:41:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75B9B3EA960;
	Fri, 26 Jun 2026 17:41:41 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E0493E5572
	for <io-uring@vger.kernel.org>; Fri, 26 Jun 2026 17:41:40 +0000 (UTC)
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782495701; cv=pass; b=lfxINBn4VKUstyYXfYo62ozolI2leNL41Rukt9lP5r+LQiNR9915kd4YWozacHCw1FmP+YsxGUc8M6DygL/WDQmqiXjA+IknfuhDcdk3HxjDY/g+NHQuo80P8whrQvpyB9SDAi+EoRlUVC9lSgwM6+cqcPsLrza4q8gwNPxBKls=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782495701; c=relaxed/simple;
	bh=79l5fi0ds3igio4Jw/qhaGuUaI1+Ux0RAJbwkXeHws8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XFyD8QvxFLwr60N7H+ugGeN29vLh7D7z/D1FChyZW7xVT7ddoQHamf7EpnSy+DpOW1wABDMltklgO96DGftQc3VScoGCW0C9SUPe+bcNgWg4J2zGQiKqG3GePzXj1WY3HYA0MFQBmjm//cluli+vZRoSvc8lMpsx20ZoVUAkeqw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iMRts3/m; arc=pass smtp.client-ip=209.85.219.51
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-8dfdfe27ba0so15865536d6.2
        for <io-uring@vger.kernel.org>; Fri, 26 Jun 2026 10:41:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782495699; cv=none;
        d=google.com; s=arc-20260327;
        b=Pgh/cMaB2H0+GqvEgPeY0otJkIrKziR5rL/DCudjs9mWJNtEaTD6z5M8OFPGYCwCIc
         2OnRccv86MB0EYYI/IURTIXCe+9ZxUem7iXre+Bub+dxVuGKmwXILuIN09O2Fbb0/R5e
         9UBKitCWAgDXtUZSHNfCUmjG6Y4gwZYYrM58YuzkUIKa9SJImUQ0pKRHi0Ra1NJxa656
         6u/eCscv7cXUgJC2Y5h4r5C0oR/Wx+nt3xmn/jjCBEK24S8BM5ij61l1pSQKizzqVTvN
         Zpodl5zmihMDuxoIQSzuEknEC4854atJor4jwJe/5/nRZ6XfY+mWfSyzNMGMZTYu3Pf5
         96Qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=79l5fi0ds3igio4Jw/qhaGuUaI1+Ux0RAJbwkXeHws8=;
        fh=Ck+JtrL826Sh/35l9Egxn36xlkENzFfCmh9SqiRmAMQ=;
        b=jCga4ul7a7ddPkHM1v+WbQf8Fsk7GofvLqB8qW4duQfsAWmHXGfMfy3zBQyCk9RqPr
         2D7kpAfZRPSeskAPHp2X3Tr18DsW9Z/3rBuhCyKU8QKDEzOCt16cLqlliybcpiYQDMaZ
         dBdKGK9Y+70RGYmkTj9G43LKQSduIgNgS7W860vyDZ9C9c+TRJH3ojGVa0DwvBr7Jwtu
         h3jZiMt42IMA38TrmAgvLCscRHcPGfwwd6Dshj+8apY21mJNji9xDOIzLGmQIObcc0Pk
         ak/WcJfuz8rcDMmxwFL7CrDMRnMRap9lVcb9KofL+0JCWhYH/GufZjRZ8ROXs3uOe8jH
         9sOg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782495699; x=1783100499; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=79l5fi0ds3igio4Jw/qhaGuUaI1+Ux0RAJbwkXeHws8=;
        b=iMRts3/mqnWYah2juoMDOmYdAmVzuAkcYGOZSLcp8Fcwg9L0DeMe1rSXpeRLhEf229
         P1py53y8ilwwLALWpl46lcPUT8RdIZa9S0aEqznstGxxMOn30rWkVmDeeOKdEp4n2OsX
         Ad6S7yfQtIbzAru2FjnS0rKUiBhJpNLBxcl37atq46FHzFl5OwkGzlEegQOVQzQV+Zag
         TYZoAGQcF5hlAu+gA/p9GipTKDAl+EqtDLplCPCS0mwGGQWDybi5d0A+zLvAngs2M7Nt
         PkBvB8ylJlbUc6uBSlWEsR4gwtc4+B/CcxQocoJKx6col6ADISdsgt6SQdzTHWcnhq93
         4mTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782495699; x=1783100499;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=79l5fi0ds3igio4Jw/qhaGuUaI1+Ux0RAJbwkXeHws8=;
        b=eE0NFFLYM1kDfUIqFZHrd2fomQF8lE1KpqRJ+fwnZ039OytHIHYGfXJHSuDLarajnW
         H4giVHnCHH91AbVw1SlubpaZampMXsyzeeQ5hSfxcgTCweJboDTeX3JVBAFfyBBrX0tQ
         HE2CI60cWKlpERMvdyANyo7JDnWFpxo3Q5+5FFSlLhS+OzKqk9zbMms9NXohZqCSf/vV
         0QOKf3JDERK+Rz40lIL510OEv7Qdmj9489/nTM9ehAaZxBTPF/LYRq0blbqwp2yf14Uc
         XD3acir5zD+M7loybwF1aZ4fnmO0G7weUDRP0KLpY4eE8/EK/XEDn6ZJtLVvQIPm1pOb
         FHVg==
X-Forwarded-Encrypted: i=1; AFNElJ9HMQV5RRpyKxWH2ORAcnwZxFT39p3XLiRXY65BoUD0D/3Zsc5jtssZDEFHQ/0yBRJB2KjEVL8dIA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwwZqpN8ykdsevYHakEGwtN1ZZDK6f3A2FCXgi1GzU8twjjK/P1
	OXp/PDg91x7KBwv1TlsJPyjdxDezzpw5VpUCQwOcGrVDM28bxwEkA7KURysNBiv6h5mlH/ewC3e
	Kcoa7uiQ3rlfYmXwfXiooHLo4VhqA4gA=
X-Gm-Gg: AfdE7cklEA+XiozJKL1qJb5EBmhmsr1Kpq+aH1bMVtatZigK5Augj1wATQ/Q8j4EI9x
	pVDIm9hpKyx+c3ZdXhzzKgv7xNk/12a3uIS04MTNucXNwpZuh1A+UesD4PZmwHcEQKtCxwmShPZ
	oF9c6HjkQmFvUQE0lkW8HMrAk8EOwnqexm43tAk5qQoYPe191JXdbG3e8LkGsbjM/fdc+oqTRby
	qYuCJHYhcZut5FquN83oodMJjZN1mtlrSX1Npbob6dpUcPxpj+1Pc8Fk5Ul9B9YJmlc/wbxJOZl
	H0PMvsf9kkzunE3GjL/coam5GNXT+oiY8NCBNWuEWhUx
X-Received: by 2002:a05:622a:1ba9:b0:51a:8c9a:8fb0 with SMTP id
 d75a77b69052e-51a8c9a9cbamr14488851cf.65.1782495699201; Fri, 26 Jun 2026
 10:41:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260626150946.287781-1-benjamin.james.carey3@gmail.com>
 <85d1f999-7778-4c74-9d72-b8ac8500de31@kernel.dk> <aj6jQyJd3zmZFcwx@kbusch-mbp>
 <1932a509-4e27-485e-8e09-1da67e0082c8@kernel.dk> <aj6p3kZy1a8Mf68S@kbusch-mbp>
 <94614dd9-9351-4a64-83dc-4fc87e377e59@kernel.dk> <aj6tTiAB2NIol9Tf@kbusch-mbp>
 <CA+KFGSoyCSRzgamm-38oyAtEsqd7wZZ8awL79P40x7a819EK4w@mail.gmail.com>
In-Reply-To: <CA+KFGSoyCSRzgamm-38oyAtEsqd7wZZ8awL79P40x7a819EK4w@mail.gmail.com>
From: Ben Carey <benjamin.james.carey3@gmail.com>
Date: Fri, 26 Jun 2026 13:41:27 -0400
X-Gm-Features: AVVi8CcYytuYGd0vmzaC0rX67-sw9EJQXdOWS5X-5vphKDYtXx9qsvTWPKf5b2c
Message-ID: <CA+KFGSp_Gb-pt0YzVDU+OFi0T5XoNj-+QV79Jja=59=gmVzZ=g@mail.gmail.com>
Subject: Re: [BUG] RCU hang with io_uring nvme polling
To: Keith Busch <kbusch@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_THREE(0.00)[4];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13849-lists,io-uring=lfdr.de];
	FORGED_SENDER(0.00)[benjaminjamescarey3@gmail.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:kbusch@kernel.org,m:axboe@kernel.dk,m:io-uring@vger.kernel.org,m:linux-kernel@vger.kernel.org,s:lists@lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	FREEMAIL_FROM(0.00)[gmail.com];
	FORGED_SENDER_FORWARDING(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[benjaminjamescarey3@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,mail.gmail.com:mid]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 21AC06CF70B

On Fri, Jun 26, 2026 at 12:48=E2=80=AFPM Keith Busch <kbusch@kernel.org> wr=
ote:
>
> On Fri, Jun 26, 2026 at 10:35:56AM -0600, Jens Axboe wrote:
> > Yes, it's a bad configuration. I bet it's as simple as:
> >
> > https://lore.kernel.org/linux-block/20260617155051.1266079-1-anuj20.g@s=
amsung.com/
>
> Yep, that's definitely the same problem. Thanks, I hadn't seen that
> thread yet.

(Resending this, didn't enable plain-text mode)

Jens, Keith,

I appreciate you both for the quick responses.

After putting that patch into the kernel, the fio job ran, but most of the
I/O's completed after about 2 milliseconds (makes sense, given the offset.)

Part of me wonders if there's a race between the NVMe driver and the hardwa=
re
controller, but I can't back this up right now.

Ben Carey

