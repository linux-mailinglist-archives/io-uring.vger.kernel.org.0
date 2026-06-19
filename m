Return-Path: <io-uring+bounces-13784-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id CgxRLnLKNGpLhAYAu9opvQ
	(envelope-from <io-uring+bounces-13784-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 19 Jun 2026 06:49:54 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 23C656A3D5E
	for <lists+io-uring@lfdr.de>; Fri, 19 Jun 2026 06:49:54 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=proton.me header.s=protonmail header.b=QfWET3Ne;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13784-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.105.105.114 as permitted sender) smtp.mailfrom="io-uring+bounces-13784-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=quarantine) header.from=proton.me;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 2A03A305068C
	for <lists+io-uring@lfdr.de>; Fri, 19 Jun 2026 04:49:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8467531E858;
	Fri, 19 Jun 2026 04:49:50 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-24429.protonmail.ch (mail-24429.protonmail.ch [109.224.244.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 733861E4AF
	for <io-uring@vger.kernel.org>; Fri, 19 Jun 2026 04:49:45 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781844590; cv=none; b=fw/FvZlrYLjUlKr6IwN2Glmu/+iu2sw00vDjjU4TkUsvbL86EKm1KSMhuxibaN4NEXEekPinqY6o6CUyJCR/xMDQu+MhGfErhpTfz8JexXJaQ7SBchMszRFNeWFYC1yfzKUW3IFtsqULUgWqpTI7d+g3xyTDl9Sg+Q5uGJMEEZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781844590; c=relaxed/simple;
	bh=XOhN/dkzUFC8iyTkzVJokobmMiKOQ750un/kaUB1WQU=;
	h=Date:To:From:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=XDIVnAflWiyz40H12oK8QJsMT29gSG1jhuTpFK9AQ0nFXF0m+PAvhpp/mjSwd9mbiTlAZMZabNA1C2OP9vqIaPZ5vLVPPuO3auSlifD8N0DGRLkulnx+5ftLAXj/K72LFbreAcLEJTz8GiF9ceOV8PNywSTyAXv8nRQjoHIdmbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me; spf=pass smtp.mailfrom=proton.me; dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b=QfWET3Ne; arc=none smtp.client-ip=109.224.244.29
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=protonmail; t=1781844577; x=1782103777;
	bh=XOhN/dkzUFC8iyTkzVJokobmMiKOQ750un/kaUB1WQU=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=QfWET3Ne+FbNzsYhR1vFiALJ0tw9SydlAb18cCAeD+jbWKKpth3Z7XTeJkvceECtR
	 uF5rl/yF0eBBAWsp0pG+9uYSyiR48SH7Tu/ahoPs0CezKRgIi0szxvGaunqN/lo0jD
	 PC/CfOYGhCMZmuTv/5sx8Jy5SaXQ14GzjTQYA8oCpoTOAputsVqaGPgAhVYMHWldTS
	 TZKSoQmK7QwfW6i2iSz8xZz1LkSyX1rzG3iBfXR5LrCvpDeJcgkROD6mqSyEkk/FQR
	 yOlcdI+fYYeybtlr5GZboRVwMa16u4sFXn4//Or0ilSpVS/gEMHZne5NJLnNTku1Gn
	 e3MztLLHzr+Tw==
Date: Fri, 19 Jun 2026 04:49:32 +0000
To: "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
From: Cyber_black <Cyberblackk@proton.me>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "axboe@kernel.dk" <axboe@kernel.dk>, "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: [BUG] io_uring: possible CQE32 overflow flush inconsistency in __io_cqring_overflow_flush()
Message-ID: <wK6w40HQFWE32Zzw_hyI9ctCQpBgXgOxWsfBFc2ptY-VZFPHBE5_wzDIu4AT-8ZX2wdr-C3-T6g3mUblIqOMqjCvBhTyMRg0BvOCwmh7E-E=@proton.me>
Feedback-ID: 117998405:user:proton
X-Pm-Message-ID: e8a1d8f424541267f1d28a035f43c643d920d2c5
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[proton.me,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[proton.me:s=protonmail];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TO_DN_EQ_ADDR_ALL(0.00)[];
	TAGGED_FROM(0.00)[bounces-13784-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:io-uring@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:axboe@kernel.dk,m:stable@vger.kernel.org,s:lists@lfdr.de];
	RCVD_COUNT_THREE(0.00)[3];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_SENDER(0.00)[Cyberblackk@proton.me,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	FORGED_SENDER_FORWARDING(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[Cyberblackk@proton.me,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[proton.me:+];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 23C656A3D5E


Hi,

I believe there is a bug in __io_cqring_overflow_flush() in io_uring/io_uri=
ng.c
where `is_cqe32` and `cqe_size` are left in an inconsistent state when
IORING_SETUP_CQE32 is set, potentially leading to an out-of-bounds write in=
to
the CQ ring.

AFFECTED FILE
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
io_uring/io_uring.c
Function: __io_cqring_overflow_flush()

KERNEL VERSION
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Observed in current upstream (v6.8+). Please confirm against your tree.


Found File
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
https://github.com/torvalds/linux/blob/master/io_uring/io_uring.c



DESCRIPTION
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Inside the flush loop, `cqe_size` and `is_cqe32` are both initialized and t=
hen
conditionally updated:

=C2=A0 =C2=A0 size_t cqe_size =3D sizeof(struct io_uring_cqe); /* 16 bytes =
/
=C2=A0 =C2=A0 bool is_cqe32 =3D false;

=C2=A0 =C2=A0 / Block A */
=C2=A0 =C2=A0 if (ocqe->cqe.flags & IORING_CQE_F_32 ||

ctx->flags & IORING_SETUP_CQE32) {

is_cqe32 =3D true;
=C2=A0 =C2=A0 =C2=A0 =C2=A0 cqe_size <<=3D 1; /* cqe_size =3D 32 bytes /
=C2=A0 =C2=A0 }

=C2=A0 =C2=A0 / Block B */
=C2=A0 =C2=A0 if (ctx->flags & IORING_SETUP_CQE32)

is_cqe32 =3D false; /* only is_cqe32 reset, cqe_size NOT reset */

=C2=A0 =C2=A0 if (!dying) {
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!io_get_cqe_overflow(ctx, &cqe, true, is_cq=
e32))
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
=C2=A0 =C2=A0 =C2=A0 =C2=A0 memcpy(cqe, &ocqe->cqe, cqe_size);

}

When IORING_SETUP_CQE32 is set, Block A correctly doubles cqe_size to 32 an=
d
sets is_cqe32 =3D true. Block B then resets is_cqe32 back to false, but lea=
ves
cqe_size at 32.

This means:
=C2=A0 - io_get_cqe_overflow() is called with is_cqe32 =3D false
=C2=A0 =C2=A0 =E2=86=92 it returns a pointer to a 16-byte CQE slot in the r=
ing
=C2=A0 - memcpy() then copies cqe_size =3D 32 bytes into that 16-byte slot
=C2=A0 =C2=A0 =E2=86=92 16 bytes past the end of the allocated CQE slot are=
 overwritten

The destination `cqe` points directly into the shared CQ ring memory
(ctx->rings->cqes[]), so the excess bytes corrupt the adjacent CQE entry.

If the corrupted slot is the last one in the ring, the overflow writes past
the array and corrupts other fields in struct io_rings (e.g., sq_flags, cq_=
flags).

IMPACT
=3D=3D=3D=3D=3D=3D
On a ring configured with IORING_SETUP_CQE32, flushing the overflow list
causes silent corruption of adjacent CQE entries (or adjacent ring metadata=
).
This can manifest as:

=C2=A0 - Userspace receiving garbled CQE data (wrong user_data, res, flags)
=C2=A0 - Link chains or multishot requests making decisions based on corrup=
t
=C2=A0 =C2=A0 completions
=C2=A0 - Unpredictable kernel behavior if ring metadata is overwritten
=C2=A0 - Potential data integrity issues in applications relying on io_urin=
g with CQE32

STEPS TO REPRODUCE
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
1. Create an io_uring instance with IORING_SETUP_CQE32.
2. Submit enough requests to fill the CQ ring and trigger overflow
=C2=A0 =C2=A0(i.e., force entries onto ctx->cq_overflow_list).

3. Call io_uring_enter() or close the ring to trigger
=C2=A0 =C2=A0__io_cqring_overflow_flush().
4. Observe that the CQE following the flushed entry (or ring metadata) is
=C2=A0 =C2=A0silently overwritten. This can be verified by reading the CQ r=
ing from
=C2=A0 =C2=A0userspace.

SUSPECTED ROOT CAUSE
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Block B appears to have been added to handle IORING_SETUP_CQE_MIXED, where =
the
ctx-level CQE32 flag should not be passed down to io_get_cqe_overflow() (si=
nce
in mixed mode the slot size is determined per-entry by the flag, not global=
ly).
However, Block B resets only is_cqe32 and not cqe_size, creating the
inconsistency.

PROPOSED FIX
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
If Block B is intentional (i.e. io_get_cqe_overflow already handles CQE32 s=
lot
sizing internally when IORING_SETUP_CQE32 is set), then cqe_size must also =
be
reset:

=C2=A0 =C2=A0 if (ctx->flags & IORING_SETUP_CQE32) {

is_cqe32 =3D false;
=C2=A0 =C2=A0 =C2=A0 =C2=A0 cqe_size =3D sizeof(struct io_uring_cqe); /* un=
do Block A */
=C2=A0 =C2=A0 }

Alternatively, if Block B is dead/incorrect code, it should be removed enti=
rely
and io_get_cqe_overflow() called with is_cqe32 =3D true when appropriate.

The correct fix depends on the intended semantics of is_cqe32 vs ctx flag
inside io_get_cqe_overflow(), which the maintainer is best placed to confir=
m.

RELEVANT CODE (verbatim)
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- a/io_uring/io_uring.c (v6.8)
=C2=A0 =C2=A0 __io_cqring_overflow_flush(), lines ~541-552:

=C2=A0 =C2=A0 if (ocqe->cqe.flags & IORING_CQE_F_32 ||

ctx->flags & IORING_SETUP_CQE32) {

is_cqe32 =3D true;
=C2=A0 =C2=A0 =C2=A0 =C2=A0 cqe_size <<=3D 1;
=C2=A0 =C2=A0 }
=C2=A0 =C2=A0 if (ctx->flags & IORING_SETUP_CQE32)

is_cqe32 =3D false; /* BUG: cqe_size not restored /

=C2=A0 =C2=A0 if (!dying) {
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!io_get_cqe_overflow(ctx, &cqe, true, is_cq=
e32))
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break;
=C2=A0 =C2=A0 =C2=A0 =C2=A0 memcpy(cqe, &ocqe->cqe, cqe_size); / OOB if slo=
t < cqe_size */

}

Thanks for looking into this.

Best Regards
Eneshan Erdo=C4=9Fan Karaca.

