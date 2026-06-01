Return-Path: <io-uring+bounces-13583-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cLYkAIyKHWr5bgkAu9opvQ
	(envelope-from <io-uring+bounces-13583-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 01 Jun 2026 15:35:08 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 60CB06201D1
	for <lists+io-uring@lfdr.de>; Mon, 01 Jun 2026 15:35:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E09D3302EEAF
	for <lists+io-uring@lfdr.de>; Mon,  1 Jun 2026 13:32:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEA1B3AC0F3;
	Mon,  1 Jun 2026 13:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="PFt2RAar";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="G8kWfJNB"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B7343AC0EE
	for <io-uring@vger.kernel.org>; Mon,  1 Jun 2026 13:32:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=205.220.180.131
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780320773; cv=pass; b=M7Ca13pGoL6rXO5ROPx6osw2oxKv5oc0W3JwOmGN2VN5Bx6whv/OJrpg3FO9fMVg2v3Is+S0yKFMog3mEAxAKOtAR036TzetMqcYIS9nCQ5rHVHBFDPSsyOcL8G+nWuw7cv8HBejW2RZuuDCdAQSNqUXG5YdsTiR/9hsGV19ejs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780320773; c=relaxed/simple;
	bh=FBFDEqVj5Q4xuk6WgsiiDkfFNegk6+mZoIoqPl6nERU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ucdtWhhekf3H8l34VfI8nWlOOSuycVegzmGdAHpL9XF27H945VhiPOJREHxGXJoZsd2KYr72KGaIQ9GS4B8NhnxJmA5TdSzB8iND1mXmaBC8+jsFPcA6D3urz6TeP2zmBDwGf/gNE9ux0UJfmUh/d+YA08/goDM4vQDAo8dFsvI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=PFt2RAar; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=G8kWfJNB; arc=pass smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 651BB7t33128003
	for <io-uring@vger.kernel.org>; Mon, 1 Jun 2026 13:32:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:reply-to:subject:to; s=
	qcppdkim1; bh=iSWiEO3+qeWSnedTIbwacWBgpl1B0hKJbCUNlgrD+t8=; b=PF
	t2RAar6Rx4C+bsZIRoMqTfW1WZG9nbsuJlWkqn83U135u0Z0bylMV0sOgc7F72gV
	sqKCXLPyNmXIQQ/LM30PPnvWdr+IvT+bUtFdYo+RGnFTWLchsKVSlh0FDoPSne/x
	pT8kRmrDo3AgwU10bbeSYRFnjrk+ckhVN2RePt2wOCFetIxgLNKUCdTFwqKwNPpH
	/4urPc305YRMDkPdekrkeylcnqus27uRpJqJZU23OIJXdUhw1wsfdevOrPX/7UiD
	bCTMtjBiSsut7/eI+6phiKEIvPexyRmaB5KOJrOAmfDDzb3RzByJ1NpduMDLwrt5
	I75z8vm444bwcKCfbr9A==
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4eh9010hd5-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Mon, 01 Jun 2026 13:32:51 +0000 (GMT)
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-48638b48315so323251b6e.0
        for <io-uring@vger.kernel.org>; Mon, 01 Jun 2026 06:32:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780320771; cv=none;
        d=google.com; s=arc-20240605;
        b=fpD+9Ybg1PoIgVsQn3Tl66KYutSf+pXueJquk0AG3op1lUBmiV+Xaa0r+zcD3Xq4YS
         L0KpnbgyLD+ubgcPYFkZ6x9SXrs9GtnrS1+x5UlcjFYHJEj9macKBvX/Jq3kBQYNB9xn
         7zbkODwDJpmNaHvO4EjOCKv+cAQ/smKU4YGA5Kr5uHYKYUTIwgiJ43ovQCJGyGyaoCPk
         X3V2ouIw44GMfZDNrPML6yZtnCKXErwCEzsM+oiX31BqTv2jJRWLhpHk7pvqYtqUC8Db
         JatkrG9hSv2aK0ggnlmnQ3RjPg/9FqJBCAMbciqDJwi9YFGt5SVDFvGZLLkICxnahwtJ
         SlIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :reply-to:in-reply-to:references:mime-version:dkim-signature;
        bh=iSWiEO3+qeWSnedTIbwacWBgpl1B0hKJbCUNlgrD+t8=;
        fh=Rn3atT6aKLVpNl0xXz7lymkSX9BfTnZwjlLkJ/YC4OQ=;
        b=GZbWhxukcSk7P26T/s8oLBV2lj8GXN4UDLxX5VU4tw0FY5k0cVe9+BVlQewbwWzRS7
         n0UcCOOONzCYQhcgjrqGLe/vCPsrQzPO0723CI1ojhaRh+/fpPgyUMzDbJB77TvUl6ni
         pVZnFGPgj26lp39Rk+GVZQYLdddEGB4+tQfU9FsVdIDtk4SSL92zB2uRBKi/9qTCWrRI
         cqA1AP5sNpJ55wMXDxv6pevTvzRHWi2Lu5Jw7/h3LB/vdKSjfrcGjT9qi6gRwnA1ARxd
         s7KWlec3V1RnnWYJw9yLEmqD0Wkd3uvPximUAM0f3OoNzkyJRHogPKHNeDLIB98+cEJH
         KyjQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1780320771; x=1780925571; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :reply-to:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=iSWiEO3+qeWSnedTIbwacWBgpl1B0hKJbCUNlgrD+t8=;
        b=G8kWfJNBvCJEkN5Ms3mEU4LmMa3PP7mHdsoVpgtqo0yIlEMBnNYWBO7jdsxIaShjtu
         tQmot2goJiWqTfUOaR85jbKL8gIxwMjC3Od5H5gQRe5BsP6QeEcQU59RSF0J0UNfaS/O
         wrZCEJ/wOX08jIYFVEGuaeqo31aJTzw3rCCy6DeDet/YpfMUCsLBiqyq0zW2Dgm8EBVg
         QBbazINhGi1Rv6lEIJ3gkN2ntya5B7bpg0a0/U5wfce3Eeiux+LA26L0NnxCtlth/PwE
         V5FPeIAoKkh+uVbCikVVx8iD2K5ozw5PkAMaI5qFmHgk8pHA30tSxzzpJWT9bRZ+9jaz
         yrWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780320771; x=1780925571;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :reply-to:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iSWiEO3+qeWSnedTIbwacWBgpl1B0hKJbCUNlgrD+t8=;
        b=JMY8VDSGnIXsMdNue98jVCZJMOt+84//G2iv3oeDJea1o4IeWU4Ng+t3qzBXS80Vu8
         cjb4wpFm42OBVDpdTCgVmHu4Lyu0QIQe60bPMDw9klmPqDpotxlTZad6xcQLVoB12VHM
         9EmIWQqRF8iCUdwMVixpSEQzPat2Te8HkJrPclfftR/P5acDQ+F0caHx8QqcNDtlb08n
         D53FMYSookG7XzUmFfmGDOs2sixDqSgX9rVj1dCP7qQnuDtGYoLyR6XRrA9PefFEgapd
         uxuX6BwCfKLDyecYIWmrvR422D0FY8zG5832TqvHMyQpiFaI5lFNvifbRonLvmlsKUKK
         +pCA==
X-Forwarded-Encrypted: i=1; AFNElJ8ivkrzlPXaYjV6ACqNKmVqzqBGc2efnhZZPgMH9fZUhm8mGkdfZTQXl9d5O9QWGmeWkSA6pgF/Ig==@vger.kernel.org
X-Gm-Message-State: AOJu0YyfyNrQMYP8KKftJKswtmAiMjD73WfsSEMZhJfbaJyqzxZwbWJO
	c4Q2xuUhbOEVJzFVR+wCbBsY3FUFTldy/wwyDIv7euL4O3ec03lLe5pk4M5UdB+UyWLTGX7gFtb
	uv4/YBsRW6ku0ByGHzuwqk6HwlojigncRph4+eq15Fafj3k3vRV+EXgcEHI4Gp1/xIXqIWW3nP2
	6ntUbiB12+IDUK77hNA+H1Ku5Iir6haiPlj05j
X-Gm-Gg: Acq92OGC21/00QAPayWBr0HIVeNF67B4zcwIq0je1UHcxNBFg7/fBqF9Dm1CWmMSOim
	5QBTxx+Quwch2ArbMsZwfSGoM/Aea4aNpIAJvM1JzfLbnGpi6wB7gi/48QOWBlsRdeAzWQ5YjFV
	3sXAIRU/uwy+wxkAethBGuBgSqqjy5K/Q+QbOrxsKYbF52DivHnvmOwnBjyXRt4Av6KmmhKtqQZ
	o21O4VmegxngA==
X-Received: by 2002:a05:6808:c413:b0:472:c4ba:32d9 with SMTP id 5614622812f47-485e73685aemr7697314b6e.20.1780320770639;
        Mon, 01 Jun 2026 06:32:50 -0700 (PDT)
X-Received: by 2002:a05:6808:c413:b0:472:c4ba:32d9 with SMTP id
 5614622812f47-485e73685aemr7697281b6e.20.1780320770193; Mon, 01 Jun 2026
 06:32:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260528093437.2519248-1-hch@lst.de> <20260528093437.2519248-2-hch@lst.de>
 <5f7f90d8-cb32-4ffb-8f1c-0722aafbe869@kernel.org> <20260529135045.GA10647@lst.de>
 <5f3ba603-a6ad-4cf2-9a54-aebc10273c59@kernel.org> <58cc76e7-2348-443d-a989-2a06e61178af@kernel.org>
 <20260601113831.GA25535@lst.de> <d7b08296-7f6e-4d89-ab3b-04e43d04929e@kernel.org>
In-Reply-To: <d7b08296-7f6e-4d89-ab3b-04e43d04929e@kernel.org>
Reply-To: rob.clark@oss.qualcomm.com
From: Rob Clark <rob.clark@oss.qualcomm.com>
Date: Mon, 1 Jun 2026 06:32:38 -0700
X-Gm-Features: AVHnY4IDUhXdIIQ59yCVYlfBYI5ZXqh2r6jh6SDaQfttaiXqq2hNkv_bQjj9LiA
Message-ID: <CACSVV00k-fxW6+waHNqvmYcnVNDkRexoWWprFzfayZfqdyMuuA@mail.gmail.com>
Subject: Re: [PATCH] mm/slab: improve kmem_cache_alloc_bulk
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Harry Yoo <harry@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mark Brown <broonie@kernel.org>, Hao Li <hao.li@linux.dev>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        linux-arm-msm@vger.kernel.org, dri-devel@lists.freedesktop.org,
        freedreno@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, io-uring@vger.kernel.org,
        kasan-dev@googlegroups.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org,
        Alexander Lobakin <aleksander.lobakin@intel.com>,
        Boris Brezillon <boris.brezillon@collabora.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Authority-Analysis: v=2.4 cv=H6nrBeYi c=1 sm=1 tr=0 ts=6a1d8a03 cx=c_pps
 a=yymyAM/LQ7lj/HqAiIiKTw==:117 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10
 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=_glEPmIy2e8OvE2BGh3C:22 a=VwQbUJbxAAAA:8 a=gxV2vm59AnE_F2JHV74A:9
 a=QEXdDO2ut3YA:10 a=efpaJB4zofY2dbm2aIRb:22
X-Proofpoint-ORIG-GUID: j5DyHIQgn1ysLumMx0uAA8VYyZPTsb5F
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjAxMDEzNSBTYWx0ZWRfX8V42NoIfDeTF
 4FIuOAd5KdX9JE9sQikyDp3yPNNGawgk5x33f/sGfJyC2QU+WvMwiUtoiKEi9jQTl3aSK8N6cLt
 /skKSd/lq/Yw8RrYSutJLN+PhgIUYarbESjZHktUhEZ/Pa4OT5K1po++O4wDGi9mou8RNyaDDXX
 jvMn5XzxTKkIBpQnubNnZKq92UGDObuX4tUmwybQf754Boae1Ka8Myw8gI4CbI4id2QsgSdTI+0
 WaqCjzDbbMKDJxsc98dRwDtCQ1slDcv7k22Woq20slRRjlWdft0grj3zFPCsyQ+JICY3fUizWKk
 HieehV5aevYxHih1ZQ1xM2xANcv++ZPIwrSdVPf6xAzGDZxppvZzFei2HZpdh8G1YnURiBRD7pV
 k0PLJb4axkthJGX9JOE3agPxWgbQW0lIgx3M4B1IyH/LWy1t5tuvfNL/vS6rODZX0Ebj1w6WIJf
 CtsjvQCa7ZKrCl2UJ3g==
X-Proofpoint-GUID: j5DyHIQgn1ysLumMx0uAA8VYyZPTsb5F
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-01_04,2026-05-28_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 adultscore=0 clxscore=1011 phishscore=0 impostorscore=0
 bulkscore=0 lowpriorityscore=0 priorityscore=1501 spamscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605210000 definitions=main-2606010135
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[qualcomm.com,reject];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[qualcomm.com:s=qcppdkim1,oss.qualcomm.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13583-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[qualcomm.com:+,oss.qualcomm.com:+];
	RCPT_COUNT_TWELVE(0.00)[21];
	MIME_TRACE(0.00)[0:+];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	MISSING_XM_UA(0.00)[];
	HAS_REPLYTO(0.00)[rob.clark@oss.qualcomm.com];
	RCVD_COUNT_FIVE(0.00)[6];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[rob.clark@oss.qualcomm.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,qualcomm.com:dkim,oss.qualcomm.com:replyto,oss.qualcomm.com:dkim,mail.gmail.com:mid]
X-Rspamd-Queue-Id: 60CB06201D1
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Mon, Jun 1, 2026 at 5:50=E2=80=AFAM Vlastimil Babka (SUSE) <vbabka@kerne=
l.org> wrote:
>
> On 6/1/26 13:38, Christoph Hellwig wrote:
> > On Mon, Jun 01, 2026 at 10:16:30AM +0200, Vlastimil Babka (SUSE) wrote:
> >> > kmem_cache_alloc_bulk() returning 0 was considered a success in that=
 case.
> >> >
> >> > Either fixing kmem_cache_alloc_bulk() (and the comment) or fixing th=
e
> >> > user sounds fine to me.
> >>
> >> Would it be wrong if we just returned true for size of 0? Would someth=
ing
> >> else break?
> >
> > I don't think it is wrong per se, but it feels like the wrong kind of
> > API.  I.e. I don't think the MSM caller actually wants this, as they'd
> > also do a zero-sized kvmalloc.
>
> If p->count is 0 then indeed there's a zero-sized kvmalloc so p->pages =
=3D=3D
> ZERO_SIZE_PTR but then nothing breaks because nothing tries to dereferenc=
e it?
>
> msm_iommu_pagetable_prealloc_cleanup() has a "if (p->count > 0)" branch s=
o
> it seems it's considered possible. But then the rest of the functions als=
o
> seems working fine, i.e. kmem_cache_free_bulk() of zero size does nothing=
,
> kvfree() of ZERO_SIZE_PTR does nothing.
>
> It seems to me kmem_cache_alloc_bulk() returning true for size =3D=3D 0 f=
its
> naturally in this world and is less likely to result in a gotcha?

I think I was probably expecting kvmalloc(0) =3D> NULL ... but it
happened to work out before

Adding an "if (!p->count) return 0;" at the top of
msm_iommu_pagetable_prealloc_allocate() seems like the thing to do..
if you want, I can send that patch (but traveling this week... so
let's see what I can do)

BR,
-R

