Return-Path: <io-uring+bounces-13573-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iJBAH6YpHWq6VwkAu9opvQ
	(envelope-from <io-uring+bounces-13573-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 01 Jun 2026 08:41:42 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D05BF61A48D
	for <lists+io-uring@lfdr.de>; Mon, 01 Jun 2026 08:41:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7E7EE304D455
	for <lists+io-uring@lfdr.de>; Mon,  1 Jun 2026 06:39:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C341937701C;
	Mon,  1 Jun 2026 06:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="deU2ejyR"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E18BD33F8B1;
	Mon,  1 Jun 2026 06:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780295956; cv=none; b=KbQPeWVnGW8LZl5xUNB3Ows8hF/msKSZ3vz5HIHNzVBkmQd7mkUYk3eePnAwE9XZRFLRpUg+1emhzUVzNjbD2dfRVTeU9ZOZ1eJqdlKzU+bRM7YX84U15W226AJNK74by3WJWs3GbR6+Z9RkR2FxkeSPhkAXD60msqYmj9t1izQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780295956; c=relaxed/simple;
	bh=vj0CG7FLtY3Gdw8dYwgFK/i+ZFxFt/ONhuN1JqJsDMM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=e2ppWQ5oJyNbsUIrgHMel8dY6wT+pFztg0dRtJioqyyofAyuN1lhYH2btcAZ+LgUbqCL/SFnYKG9kI3Sxi6S2KPClkfIV+XaVr2ORucZM7EOQYlkteJ9nQq0TeKkOE1Wc0vB16Il68vtmGn64HZ1hcGywebh/voCOKeDEuSrJkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=deU2ejyR; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C03E81F00893;
	Mon,  1 Jun 2026 06:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780295954;
	bh=rKk6j/n9sj1IniX/7VKjNeDlTH/D2W3IN/BVvbihauI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=deU2ejyRoOMJVQywPOlLu1PqH70E+zWfsku4xW3ejYZB8yKEwCBukyd+rzzgKkdmf
	 vGfMeLir+q2+YLlqYJ/AzObbKzdRw866F6HyGjCNfk4XHBFW0DBz7SfQREAKIrqTih
	 eBi6cugoUG+CYfTUshTd0CccN+PQjgSzwSv7queVBc6p52Wolbj/6fOndd0MpYLxG2
	 cWd4oZ+vbxMMcHUxBTZyTjrMsQm3x2s3VngOun20ayrnEQkV5sF8YIYLuI3Ny72DXa
	 BZJwi4+K5b9H+0C3rpQ6FfqPHiUwR1FUO2dIJha1fHRhWnIHL6s3QX/hRpXpWMsXxA
	 Afp4/cf9Y5iIg==
Message-ID: <5f3ba603-a6ad-4cf2-9a54-aebc10273c59@kernel.org>
Date: Mon, 1 Jun 2026 15:39:06 +0900
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/slab: improve kmem_cache_alloc_bulk
To: Christoph Hellwig <hch@lst.de>, "Vlastimil Babka (SUSE)"
 <vbabka@kernel.org>
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
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <20260529135045.GA10647@lst.de>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------HMU1xMsen67VgPzLuGJEEdMK"
X-Spamd-Result: default: False [-4.26 / 15.00];
	SIGNED_PGP(-2.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20260515];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MIME_GOOD(-0.20)[multipart/signed,multipart/mixed,text/plain];
	MAILLIST(-0.15)[generic];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13573-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+,1:+,2:+,3:~];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[20];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[harry@kernel.org,io-uring@vger.kernel.org];
	HAS_ATTACHMENT(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,sashiko.dev:url]
X-Rspamd-Queue-Id: D05BF61A48D
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------HMU1xMsen67VgPzLuGJEEdMK
Content-Type: multipart/mixed; boundary="------------ub6P4aBhniaWwf9dwX4fSUIh";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: Christoph Hellwig <hch@lst.de>, "Vlastimil Babka (SUSE)"
 <vbabka@kernel.org>
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
Message-ID: <5f3ba603-a6ad-4cf2-9a54-aebc10273c59@kernel.org>
Subject: Re: [PATCH] mm/slab: improve kmem_cache_alloc_bulk
References: <20260528093437.2519248-1-hch@lst.de>
 <20260528093437.2519248-2-hch@lst.de>
 <5f7f90d8-cb32-4ffb-8f1c-0722aafbe869@kernel.org>
 <20260529135045.GA10647@lst.de>
In-Reply-To: <20260529135045.GA10647@lst.de>

--------------ub6P4aBhniaWwf9dwX4fSUIh
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 5/29/26 10:50 PM, Christoph Hellwig wrote:
> On Fri, May 29, 2026 at 01:54:48PM +0200, Vlastimil Babka (SUSE) wrote:=

>> Thanks, I applied it to slab/for-7.2/alloc_bulk and merged to slab/for=
-next
>> (it's still yankable in case of issues)
>>
>> Did some fixups below (the comment was stale prior to the patch; resto=
red
>> unlikely(), simplified one line).
>>
>> A test merge into yesterday's -next found a conflict in drivers/gpu/dr=
m/
>> panthor/panthor_mmu.c. Commit 1013bf53650e ("drm/panthor: Split
>> panthor_vm_prepare_map_op_ctx() to prepare for reclaim") moved the cha=
nged
>> codeto a new function panthor_vm_op_ctx_prealloc_pts().
>> But it's solvable so no need for a complicated coordination I think.
>=20
> Ok, thanks.  The two Sashiko complains also look like they had merrits,=

> but I won't get to looking into them until Monday.
The review:
https://sashiko.dev/#/patchset/20260528093437.2519248-2-hch%40lst.de

So there is a user who might call kmem_cache_alloc_bulk() with size =3D 0=

(although the comment says @size must be larger than 0!) and
kmem_cache_alloc_bulk() returning 0 was considered a success in that case=
=2E

Either fixing kmem_cache_alloc_bulk() (and the comment) or fixing the
user sounds fine to me.

And yeah freeing an object via kfree() allocated via kvmalloc is a bug...=


--=20
Cheers,
Harry / Hyeonggon


--------------ub6P4aBhniaWwf9dwX4fSUIh--

--------------HMU1xMsen67VgPzLuGJEEdMK
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCah0pCgAKCRCGXBN6rc5S
1rmyAP4xYSWajEqm+MA0a6gB0YMw8PYGMERv/Liiv8qq9FfVwQEA0LaAVOUS0vOJ
pFwKYpvxOLNGK+0ssT0N7hdbranbAAA=
=ebwI
-----END PGP SIGNATURE-----

--------------HMU1xMsen67VgPzLuGJEEdMK--

