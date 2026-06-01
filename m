Return-Path: <io-uring+bounces-13581-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8NeDLIpvHWqWawkAu9opvQ
	(envelope-from <io-uring+bounces-13581-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 01 Jun 2026 13:39:54 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 5384861E736
	for <lists+io-uring@lfdr.de>; Mon, 01 Jun 2026 13:39:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 60B9D3008D78
	for <lists+io-uring@lfdr.de>; Mon,  1 Jun 2026 11:39:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86CB436A377;
	Mon,  1 Jun 2026 11:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fhQbD7Wt"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 813A981AA8;
	Mon,  1 Jun 2026 11:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780313990; cv=none; b=QfBZWe5q2HRkBEFSnMUbQV9x23UCUWJsCpmVrSxXTZWxyus2p/K1JXIzEcfx05GfDZK62RK6StctXM/ooxTYhadh8qmdrL5gWtzpOPZ5X63V/7CulR1gmap8fhRBCKOeR/9zphmdKZJTPR5KWEZI+tzdIomyFrywfJcyXJP14FI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780313990; c=relaxed/simple;
	bh=5o271WQzEJ1Cggn1C0amqJkMDlDlgYGn7SPDBqhVqJU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Uf3k+B5oHb/B3001cJi3VmqhV921yypTPNWf4T1whxpoxX3vPGX7t2C/3djeOAy0yAUUpBbmVXzInjr0qWCkGjOXozJh8Jr9RTx8/fe2hLJztuvL1/Dq70p7I3tJOeiBJrmpx2NCTfg1Nvps0S27xd9/SICXU1CLgSIXE26Pez0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fhQbD7Wt; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E21B1F00893;
	Mon,  1 Jun 2026 11:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780313989;
	bh=5MMXZTkE9Ksy8r/e1+0LdFptK92/DrsLI/CT08d5UQ8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=fhQbD7WtYmzfm3aO27P3MUdk1PYXtWtZRyjEbt1BF4stHyg0uRK+76axAKeOrgWDi
	 +MDRJzoDAjER/TkerBiZ6pMsxnVf+EI5Sbm6Cq3INBW+ZBsyIzYpL3iBZYgt1lB4+u
	 HjQ+nGLuY8hFZur08h5UjnV+3mEoTJiHhdlZSr6qVL4bZzZhLX1zKwlGyj5QD1jic0
	 UkDzGkcO1Z5agDNQLNVSXMQoNuE17jqfJy33oa27Z1JSDerxJk1wpv48niFk3Df/7s
	 W/FrJHStGRgZmeMdYp1ZcncnjGDoCc6TCD43KfzJKdGvUYNlcBcSVthzLF9qDJG5Va
	 qQREa+iz/Gd9g==
Message-ID: <aad27c5f-01a6-4a2a-a55c-c7e411c4dd05@kernel.org>
Date: Mon, 1 Jun 2026 20:39:40 +0900
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/slab: improve kmem_cache_alloc_bulk
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Christoph Hellwig <hch@lst.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mark Brown
 <broonie@kernel.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Jesper Dangaard Brouer <hawk@kernel.org>, linux-arm-msm@vger.kernel.org,
 dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, io-uring@vger.kernel.org,
 kasan-dev@googlegroups.com, bpf@vger.kernel.org, netdev@vger.kernel.org,
 Alexander Lobakin <aleksander.lobakin@intel.com>,
 Boris Brezillon <boris.brezillon@collabora.com>
References: <20260528093437.2519248-1-hch@lst.de>
 <20260528093437.2519248-2-hch@lst.de>
 <5f7f90d8-cb32-4ffb-8f1c-0722aafbe869@kernel.org>
 <20260529135045.GA10647@lst.de>
 <5f3ba603-a6ad-4cf2-9a54-aebc10273c59@kernel.org>
 <58cc76e7-2348-443d-a989-2a06e61178af@kernel.org>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <58cc76e7-2348-443d-a989-2a06e61178af@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------YwQVGEEKxGzkrAPA10HjJL0h"
X-Spamd-Result: default: False [-4.26 / 15.00];
	SIGNED_PGP(-2.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20260515];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MIME_GOOD(-0.20)[multipart/signed,multipart/mixed,text/plain];
	MAILLIST(-0.15)[generic];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13581-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+,1:+,2:+,3:~];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[20];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[harry@kernel.org,io-uring@vger.kernel.org];
	HAS_ATTACHMENT(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo,sashiko.dev:url]
X-Rspamd-Queue-Id: 5384861E736
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------YwQVGEEKxGzkrAPA10HjJL0h
Content-Type: multipart/mixed; boundary="------------Fos0wBgvdCggrd0C0H32WobZ";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Christoph Hellwig <hch@lst.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mark Brown
 <broonie@kernel.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Jesper Dangaard Brouer <hawk@kernel.org>, linux-arm-msm@vger.kernel.org,
 dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, io-uring@vger.kernel.org,
 kasan-dev@googlegroups.com, bpf@vger.kernel.org, netdev@vger.kernel.org,
 Alexander Lobakin <aleksander.lobakin@intel.com>,
 Boris Brezillon <boris.brezillon@collabora.com>
Message-ID: <aad27c5f-01a6-4a2a-a55c-c7e411c4dd05@kernel.org>
Subject: Re: [PATCH] mm/slab: improve kmem_cache_alloc_bulk
References: <20260528093437.2519248-1-hch@lst.de>
 <20260528093437.2519248-2-hch@lst.de>
 <5f7f90d8-cb32-4ffb-8f1c-0722aafbe869@kernel.org>
 <20260529135045.GA10647@lst.de>
 <5f3ba603-a6ad-4cf2-9a54-aebc10273c59@kernel.org>
 <58cc76e7-2348-443d-a989-2a06e61178af@kernel.org>
In-Reply-To: <58cc76e7-2348-443d-a989-2a06e61178af@kernel.org>

--------------Fos0wBgvdCggrd0C0H32WobZ
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 6/1/26 5:16 PM, Vlastimil Babka (SUSE) wrote:
> On 6/1/26 08:39, Harry Yoo wrote:
>>
>>
>> On 5/29/26 10:50 PM, Christoph Hellwig wrote:
>>> On Fri, May 29, 2026 at 01:54:48PM +0200, Vlastimil Babka (SUSE) wrot=
e:
>>>> Thanks, I applied it to slab/for-7.2/alloc_bulk and merged to slab/f=
or-next
>>>> (it's still yankable in case of issues)
>>>>
>>>> Did some fixups below (the comment was stale prior to the patch; res=
tored
>>>> unlikely(), simplified one line).
>>>>
>>>> A test merge into yesterday's -next found a conflict in drivers/gpu/=
drm/
>>>> panthor/panthor_mmu.c. Commit 1013bf53650e ("drm/panthor: Split
>>>> panthor_vm_prepare_map_op_ctx() to prepare for reclaim") moved the c=
hanged
>>>> codeto a new function panthor_vm_op_ctx_prealloc_pts().
>>>> But it's solvable so no need for a complicated coordination I think.=

>>>
>>> Ok, thanks.  The two Sashiko complains also look like they had merrit=
s,
>>> but I won't get to looking into them until Monday.
>> The review:
>> https://sashiko.dev/#/patchset/20260528093437.2519248-2-hch%40lst.de
>>
>> So there is a user who might call kmem_cache_alloc_bulk() with size =3D=
 0
>=20
> I don't know if it can really happen there, but maybe DRM folks can tel=
l us.

Yeah beyond my area :)

>> (although the comment says @size must be larger than 0!) and
>=20
> The comment is however new, the caller existed when there was no commen=
t and
> the return value 0 when asked for 0 was working there.

Haha, you're right. Didn't notice that...

>> kmem_cache_alloc_bulk() returning 0 was considered a success in that c=
ase.
>>
>> Either fixing kmem_cache_alloc_bulk() (and the comment) or fixing the
>> user sounds fine to me.
>=20
> Would it be wrong if we just returned true for size of 0? Would somethi=
ng
> else break?

I think it won't break as nobody should be accessing an array of size 0,
and it matches the previous behavior.

--=20
Cheers,
Harry / Hyeonggon


--------------Fos0wBgvdCggrd0C0H32WobZ--

--------------YwQVGEEKxGzkrAPA10HjJL0h
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCah1vfAAKCRCGXBN6rc5S
1n8cAQCqp4CsOu+ZPkt9JTKGMEjAbun8lhAPjYEe5ZxQbjlUnQD/Yqc0JkpGdJ3B
cq4AV3Pw4qMLNMrm3+rVRHMdUu9OmQ0=
=RNAw
-----END PGP SIGNATURE-----

--------------YwQVGEEKxGzkrAPA10HjJL0h--

