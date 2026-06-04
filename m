Return-Path: <io-uring+bounces-13605-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id TIl0J8EmIWoQ/wAAu9opvQ
	(envelope-from <io-uring+bounces-13605-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 04 Jun 2026 09:18:25 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 204E963D938
	for <lists+io-uring@lfdr.de>; Thu, 04 Jun 2026 09:18:25 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mTlK76AL;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13605-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13605-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 81A49302D96B
	for <lists+io-uring@lfdr.de>; Thu,  4 Jun 2026 07:10:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 706B53DD871;
	Thu,  4 Jun 2026 07:10:19 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74EDC3C3BE6;
	Thu,  4 Jun 2026 07:10:18 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780557019; cv=none; b=Pts9MkGon0MgQn+7BOFcZhPureUILyufJjXR35AL0Pnq6QSAt2gIoeqL23ogw4PdKN026BDmvU7Zhbum9mzveNtaEVKWLYafCaxI4sVehRIXrl+3P308DQLVh+DlCqwGg9LPjA1EBLdpnmt/+PpLym8CW14GXRn9T86ezTtDNdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780557019; c=relaxed/simple;
	bh=Ws4H9Q+8t06VACzdZSGsOKt9b28u1KPCCkBtrR11z9g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RhqPJVKO0Zi3Cfmdq5/SeJJaIvJcR/EaUFXuuovvWu1SSPDMTXgMB+rwiwfCyfGhvLcQjRj8hfiMrbTx9xLUMfH4S6SSA2A8+1lENfiz/bDHzVi+hd6COgjIGV+y7GRt3NnVRZ/KZpWgu1TO06BLsM8EzHmt2ErItKgw2QV2DhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mTlK76AL; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 724E31F00893;
	Thu,  4 Jun 2026 07:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780557018;
	bh=AhMxEQwcegOFcYLIZ9y5iV53bw04kwuyEtOBVhEDYMA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=mTlK76ALzPHk/Pz+6x8nTHyAjcgK/SS+Mku9+Qi7I3SNA0dfcHu6BhFEs+C19pRU6
	 E5+OGsyWwtumgMG/WJ2Le0aae5LQxGXgowtVmcepxAXxMfqCWAilCKaYGk/5+kRVkP
	 4cO9j+hmH6qM30B4Ytx/qU6yvKs9erS3UMZLX0LxVk1/5u7oTpy2ME5T1T/npLCOGU
	 s4u+Pk89mJTbVKzFZ55WRg+drPIILWBGGd5p/DVxhd0Z2F7ICIpxvMp25Jq0zQa4Gy
	 HAb3eZDLpekHG+5x0DW3wia0LnDWOcTfGSaDl10ol+7lmMFjJhA3KS0hZK1C8ogR+c
	 F4m/GYKhfbnJQ==
Message-ID: <f027078c-6a55-463b-8938-95ede02dca3b@kernel.org>
Date: Thu, 4 Jun 2026 16:10:08 +0900
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/slab: improve kmem_cache_alloc_bulk
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, rob.clark@oss.qualcomm.com
Cc: Christoph Hellwig <hch@lst.de>, Andrew Morton
 <akpm@linux-foundation.org>, Mark Brown <broonie@kernel.org>,
 Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
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
 <20260601113831.GA25535@lst.de>
 <d7b08296-7f6e-4d89-ab3b-04e43d04929e@kernel.org>
 <CACSVV00k-fxW6+waHNqvmYcnVNDkRexoWWprFzfayZfqdyMuuA@mail.gmail.com>
 <CACSVV00dNWgpNVU5rB=Hmg+3oWF18yTyfKNr_tWesjoP1jMxwg@mail.gmail.com>
 <5e6948b3-d235-4b61-aed7-e8b4d0f5b452@kernel.org>
 <CACSVV02v0Fuc6=Rqyd89D-_tcSjEXuQmxz0+2-4aoRAEwJE4zg@mail.gmail.com>
 <b6f6323e-6f5b-4928-b474-bd2743eac3f2@kernel.org>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <b6f6323e-6f5b-4928-b474-bd2743eac3f2@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------wiFRKWLl9yvmDjGQCVE2s47E"
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.26 / 15.00];
	SIGNED_PGP(-2.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20260515];
	MIME_GOOD(-0.20)[multipart/signed,multipart/mixed,text/plain];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-13605-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:vbabka@kernel.org,m:rob.clark@oss.qualcomm.com,m:hch@lst.de,m:akpm@linux-foundation.org,m:broonie@kernel.org,m:hao.li@linux.dev,m:cl@gentwo.org,m:rientjes@google.com,m:roman.gushchin@linux.dev,m:hawk@kernel.org,m:linux-arm-msm@vger.kernel.org,m:dri-devel@lists.freedesktop.org,m:freedreno@lists.freedesktop.org,m:linux-kernel@vger.kernel.org,m:linux-mm@kvack.org,m:io-uring@vger.kernel.org,m:kasan-dev@googlegroups.com,m:bpf@vger.kernel.org,m:netdev@vger.kernel.org,m:aleksander.lobakin@intel.com,m:boris.brezillon@collabora.com,s:lists@lfdr.de];
	FORGED_SENDER(0.00)[harry@kernel.org,io-uring@vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[21];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+,1:+,2:+,3:~];
	FORWARDED(0.00)[lists@lfdr.de];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[harry@kernel.org,io-uring@vger.kernel.org];
	HAS_ATTACHMENT(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,vger.kernel.org:from_smtp]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 204E963D938

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------wiFRKWLl9yvmDjGQCVE2s47E
Content-Type: multipart/mixed; boundary="------------wMYGC0PsvxX072tLl8xZovbN";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, rob.clark@oss.qualcomm.com
Cc: Christoph Hellwig <hch@lst.de>, Andrew Morton
 <akpm@linux-foundation.org>, Mark Brown <broonie@kernel.org>,
 Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Jesper Dangaard Brouer <hawk@kernel.org>, linux-arm-msm@vger.kernel.org,
 dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, io-uring@vger.kernel.org,
 kasan-dev@googlegroups.com, bpf@vger.kernel.org, netdev@vger.kernel.org,
 Alexander Lobakin <aleksander.lobakin@intel.com>,
 Boris Brezillon <boris.brezillon@collabora.com>
Message-ID: <f027078c-6a55-463b-8938-95ede02dca3b@kernel.org>
Subject: Re: [PATCH] mm/slab: improve kmem_cache_alloc_bulk
References: <20260528093437.2519248-1-hch@lst.de>
 <20260528093437.2519248-2-hch@lst.de>
 <5f7f90d8-cb32-4ffb-8f1c-0722aafbe869@kernel.org>
 <20260529135045.GA10647@lst.de>
 <5f3ba603-a6ad-4cf2-9a54-aebc10273c59@kernel.org>
 <58cc76e7-2348-443d-a989-2a06e61178af@kernel.org>
 <20260601113831.GA25535@lst.de>
 <d7b08296-7f6e-4d89-ab3b-04e43d04929e@kernel.org>
 <CACSVV00k-fxW6+waHNqvmYcnVNDkRexoWWprFzfayZfqdyMuuA@mail.gmail.com>
 <CACSVV00dNWgpNVU5rB=Hmg+3oWF18yTyfKNr_tWesjoP1jMxwg@mail.gmail.com>
 <5e6948b3-d235-4b61-aed7-e8b4d0f5b452@kernel.org>
 <CACSVV02v0Fuc6=Rqyd89D-_tcSjEXuQmxz0+2-4aoRAEwJE4zg@mail.gmail.com>
 <b6f6323e-6f5b-4928-b474-bd2743eac3f2@kernel.org>
In-Reply-To: <b6f6323e-6f5b-4928-b474-bd2743eac3f2@kernel.org>

--------------wMYGC0PsvxX072tLl8xZovbN
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 6/4/26 1:22 AM, Vlastimil Babka (SUSE) wrote:
> On 6/3/26 13:13, Rob Clark wrote:
>> On Wed, Jun 3, 2026 at 2:17=E2=80=AFAM Vlastimil Babka (SUSE) <vbabka@=
kernel.org> wrote:
>>>
>>> We know p->pages is NULL in this case, right? Because it was allocate=
d by
>>> vm_bind_job_create() using kzalloc().
>>> And the job can't be reused with a leftover value?
>>> (msm_iommu_pagetable_prealloc_cleanup doesn't set p->pages to zero).
>>> Or should we set p->pages to NULL here.
>>
>> Correct, the job is not reused.  But I suppose setting p->pages to
>> NULL would make things more obvious, so no objection to that.
>=20
> OK, did that, just in case. Thanks.

The kvfree() -> kfree() part should probably be a separate patch
with Fixes: 830d68f2cb8a ("drm/msm: Fix pgtable prealloc error
path") and Cc: stable?

=2E..as the commit landed v6.18.

>> BR,
>> -R
>>
>>>> +
>>>>         p->pages =3D kvmalloc_objs(*p->pages, p->count);
>>>>         if (!p->pages)
>>>>                 return -ENOMEM;
>>>>
>>>>         ret =3D kmem_cache_alloc_bulk(pt_cache, GFP_KERNEL, p->count=
, p->pages);
>>>>         if (ret !=3D p->count) {
>>>> -               kfree(p->pages);
>>>> +               kvfree(p->pages);
>>>>                 p->pages =3D NULL;
>>>>                 p->count =3D ret;
>>>>                 return -ENOMEM;

--=20
Cheers,
Harry / Hyeonggon

--------------wMYGC0PsvxX072tLl8xZovbN--

--------------wiFRKWLl9yvmDjGQCVE2s47E
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCaiEk0AAKCRCGXBN6rc5S
1v0/AQCTdSzVR1AlZpSbYogIVVB+443eCQzT7065V9OSIICLswD/e6Yg56WZBHlu
kh1s01feILBrZKf2TcrQ69haUSsKKgk=
=BoaG
-----END PGP SIGNATURE-----

--------------wiFRKWLl9yvmDjGQCVE2s47E--

