Return-Path: <io-uring+bounces-12947-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0ENmFwv6z2nM2AYAu9opvQ
	(envelope-from <io-uring+bounces-12947-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 03 Apr 2026 19:34:03 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id B729739706A
	for <lists+io-uring@lfdr.de>; Fri, 03 Apr 2026 19:34:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DC33F3077843
	for <lists+io-uring@lfdr.de>; Fri,  3 Apr 2026 17:30:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AB203502A3;
	Fri,  3 Apr 2026 17:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i9VI3f+f"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4C62299AAB
	for <io-uring@vger.kernel.org>; Fri,  3 Apr 2026 17:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775237419; cv=pass; b=pNlYFLzverNIbyBY8Zqbsh6wdzByIjCwR4n2H72UsXNLJr+EgaFDFafbeyLbAeMfODiYH4kuWzLnOk24PapDG3fKMmuga6FZma2ic8j5isXiWvUcQVLHGTiqlchLXy9ePTVBPaCX0qXhVmVGSe6Ddh4kL3ljU6XABcqbDzi65hk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775237419; c=relaxed/simple;
	bh=r5yFEdmgR+C9qMW5bjqMSuMQWrtQy+/hBBelG5wE1vY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LbMnEMkGnumW5Rs+25XnHm1X3d0PEZ3zMkh+MDjI8GN6/iskwB/xsgzzQI1rQ3z8/r8Q3/ruRJCla7dJLDqRTr+talm6MaH9DKsrdKezKqHYQcouhEuigE8NAjaPvejAbV8gswqQ3IIDDvdopMV8fl9MQj7MfjgYShHU+VS5pfo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=i9VI3f+f; arc=pass smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4887eca00c4so14392715e9.2
        for <io-uring@vger.kernel.org>; Fri, 03 Apr 2026 10:30:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775237416; cv=none;
        d=google.com; s=arc-20240605;
        b=UGSFVf1xwEnzWStuD5urGgfpN6gU1jFu35hUXiQfs7g+1yEgby3RKSeZU6Lee93VOC
         hT7tu56cMR0eU7/WjGRRJdElR/5LnjnpEJ28HzxW7Gjk24f1W4jx7bugIrlzYNwLb6jz
         NiFVqwSS6WmyMwvlNPsajePSrUTJVVuJYZMt+Mj4K0sRtHD7DJwuVy9DFlAUUAQhBadl
         bAV3oGOA6aTbYXz1pn3zkZqNBFyWKkIICKdULf0LJtFDZmHaSInC9BWo/NFzabdgP+jI
         RRzqJrqO/SbRJQCM1jOQsPZmnbwCXRSI7bZ92geue9hQeyQGzuCFE/J3KnZLoskCujY9
         m9BA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=r5yFEdmgR+C9qMW5bjqMSuMQWrtQy+/hBBelG5wE1vY=;
        fh=WexEOD39+eMkUREo/WP6QvXRsD5vVtviwwkA3EuPK+I=;
        b=kQjbfP1Q34c+QpqhZdnnHVrDw6BfO67UiG/PHOgdwlROr++6It1DfxPld9FvU4eQGg
         ZFRysCsyCIDipWyPZ42CHBN18FGcFFhOt9khjYJ60g5XoiElU7pswziT93eA/840C0FU
         hJ8wbKdpIL4a0JIEwo1pYvAOzz5x4E95AZ9Q7Oo7cAilFDhNO/SXrsO5xmwnEQaXxvUo
         XA3GYm5qfvndHG+TJqBs1RJwgpDFIU+7wQPWxhkkkW/eS19SgiK29OUbQTUXnptemCWv
         ktheuFrxM1nSKl2mqrdnqifj5Pt1VQ7ENAcFNnxGmuILJWmV+njJFImKzbtDatn0UduA
         2rTw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775237416; x=1775842216; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r5yFEdmgR+C9qMW5bjqMSuMQWrtQy+/hBBelG5wE1vY=;
        b=i9VI3f+fVUQQ/86+2r6f+Nd69/ow8vBrjBTJQ8f4YA8wv9kjs0Ao6S+Bnlpye1QAND
         ea5QOKIO1S6GUWC9b3vBNZTu8388gyfd+m96Ip72/5n+ZylJjBUn8/F8LFnGgRsPPUpz
         gLODWAderkjBV4S+QpDmt3wq99L3RRSqrohGl994ec1bC2D3Hq39ol/4mmZU8yhrWE9P
         XWUy7bb37pnwJ7r5w4U2kOh9xEQkMPlkChE985TPCKuttS7zWYbPvf5XyLeAH2hrxaJ9
         UfZnywx+zkPWfeafnYVfTMxtJSc1s79ac/nyJALiYABARr5q3aq3BIdsI73RmFLQK02i
         3dqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775237416; x=1775842216;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=r5yFEdmgR+C9qMW5bjqMSuMQWrtQy+/hBBelG5wE1vY=;
        b=fhIsR4ffuiC+UkSRqS0o7JBHItXGRk+3DnMLXGC2QrA6yvjSPeW7YrqT9+9wbK+rd/
         hTqO59oTLam6GkZagqxdAEu8Do3Myrtz/1oaA1YaFTU3HVdUoS09/qgwM3h22or0GCFa
         hDkCHzGyGQO4dbaYkmB8aCtGimd5wL0uWJ39RMM46E7v4lt46mrE7k0q158CsBTmgBxE
         PR0FVluwEBsTtCowEtIiA8p+MdNIJQLfgRzNTEwkFOGYcgo62CqdXaCLJUokLjPeds1E
         zmu9csHFwzS3RcgEotCUvS1T/z39oDbVxtqvS60njHoHwU2KcleDeACZL432uYpJDnoW
         D5eA==
X-Forwarded-Encrypted: i=1; AJvYcCW4XHo3AtEO1+R0W9YmO0nIUVSbZGkyaVF/1X9CMLpoUJ+//pzXW7wUe0Eh4xxY5JOhWl647Z7lag==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw82sGgY1/M9QkIBQL7LBAhcDZmWJqveUZaqBOxB8M8PWaOWLys
	Tw0NQVCxPhcmRPXa4ouqpiazvQTXuwvdSXQAHUYgP/s32Tzb23dpJcrFpaiVuDpmjROqtlEvMa8
	eGKxoZGX6p62gp1/sP/ykBKTGJS2UalQ=
X-Gm-Gg: ATEYQzyNw8aq/pFLSOAP7rIa7WQj6Laimc/a0EJybA3UwJeuH+y90cjKP6dsQsPyaiI
	dK3HCDwPuoyesRk2pdHswlxhfhVKAXp9s9Z2eljepJrfr3FHBYgtBH+AuijDo+G4VvvkeVcagmJ
	jjz3M2+7eF7eYIVoMqv2dryRf2XBzLHWzVGY5MrSxLvhgL29H/kXabMXkYNheUVFcGy6ey7GTrI
	YCXFqpdq1/zBFM95Q66VYhiXbHCYtwlfmLbN80AMlXOsgE0VOPaa8EXYZxF0yqHUvgNtjbYd/px
	VXYHBQ==
X-Received: by 2002:a05:600c:1d1c:b0:477:76bf:e1fb with SMTP id
 5b1f17b1804b1-488997d1392mr61375405e9.16.1775237415777; Fri, 03 Apr 2026
 10:30:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260402160929.2749744-1-joannelkoong@gmail.com> <789726e1-c896-4073-b712-e4d03cce5133@kernel.dk>
In-Reply-To: <789726e1-c896-4073-b712-e4d03cce5133@kernel.dk>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Fri, 3 Apr 2026 10:30:04 -0700
X-Gm-Features: AQROBzDfqCXUCYLRmFfo5h2pqeF2YpjdTIOvfSW5nHAg-esa3Jy2nsIZBQFkhhY
Message-ID: <CAJnrk1b2_nW5YvEn2YmfiJ_+kuOLypFFYd47Gch-=a9rQ2NFbQ@mail.gmail.com>
Subject: Re: [PATCH v5 0/4] io_uring: extend bvec registration
To: Jens Axboe <axboe@kernel.dk>
Cc: csander@purestorage.com, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12947-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joannelkoong@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	FREEMAIL_FROM(0.00)[gmail.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: B729739706A
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Fri, Apr 3, 2026 at 9:21=E2=80=AFAM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 4/2/26 10:09 AM, Joanne Koong wrote:
> > This series refactors and extends the io_uring registered buffers
> > infrastructure to allow external subsystems to register pre-existing bv=
ec
> > arrays directly.
> >
> > The motivation for the patches in this series is to make fuse zero-copy
> > possible. These patches are split out from a previous larger
> > fuse-over-io_uring series [1]. The fuse zero-copy work that builds on t=
op of
> > this is in [2].
> >
> > Thanks,
> > Joanne
> >
> > [1] https://lore.kernel.org/linux-fsdevel/20260116233044.1532965-1-joan=
nelkoong@gmail.com/
> > [2] https://lore.kernel.org/linux-fsdevel/20260324224532.3733468-9-joan=
nelkoong@gmail.com/
> >
> > Changelog:
> > v4: https://lore.kernel.org/io-uring/20260327172631.3380702-1-joannelko=
ong@gmail.com/
> > v4 -> v5:
> > * rebase to origin/for-7.1/io_uring
> > * drop the io_uring_registered_mem_region_get() patch
>
> Series looks good to me, but I don't think you used the right base? It
> does not seem to apply to for-7.1/io_uring, patch 1 runs into issues on
> the ublk part.
>
> Since this touches both and applies to neither right now, maybe do a
> respin and just base it on my for-next. Then I'll setup a
> for-7.1/io_uring-fuse branch that is just for-7.1/io_uring and
> for-7.1/block merged together.

Ahh that's weird, it applies cleanly to for-7.1/io_uring on my end (on
top of commit f847bf6d2930) but I do see some merge conflicts with
for-next for the ublk commit 24d4c90286b9.

I'll rebase this to for-next and send that out.

Thanks,
Joanne


>
> --
> Jens Axboe

