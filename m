Return-Path: <io-uring+bounces-13602-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id K0UKIYoMIGo6vAAAu9opvQ
	(envelope-from <io-uring+bounces-13602-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 03 Jun 2026 13:14:18 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 02C3B636E8F
	for <lists+io-uring@lfdr.de>; Wed, 03 Jun 2026 13:14:18 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b="Sy FYwlG";
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=ZMT4jcY4;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13602-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.105.105.114 as permitted sender) smtp.mailfrom="io-uring+bounces-13602-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=reject) header.from=qualcomm.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=2")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id A8CED3027356
	for <lists+io-uring@lfdr.de>; Wed,  3 Jun 2026 11:14:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A4E3423158;
	Wed,  3 Jun 2026 11:14:04 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E14CA405869
	for <io-uring@vger.kernel.org>; Wed,  3 Jun 2026 11:14:02 +0000 (UTC)
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780485244; cv=pass; b=n/R4FLKUrcthehSk0IR0QKUipNUtZrfsdg2zOHh31xHasFC0HwtLtQ1c3VCRHmJKwWAdMIMgBg08r6N+2mOIkBCNlMAqIUQzEalGMUDWfSgxsdBKRIonA2rJHRbTwEaLVvGL7OAA+YCwBwSHV4ZzgjBJszLYZV0yn2iOT0Zz5CE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780485244; c=relaxed/simple;
	bh=uBAyAR0iY1bN17nsLETbGFhwL/pntlsubwaqpvC8ork=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pzr9l/j6q8p5+rYkXh1efO1LSFC7iWrisYKaUJRID8DBSK6ycF6es8B95IXdLTbuUsLdVG69ErSQdev/hDBvlcXDXHnVD+u+tPylV3PI+qGYJB8twz+P8f4qJSNVCFQ9YAGYmVKFE1eeD3G/aUD9N7NUv7ILIugvh+LuNVFjhfg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=SyFYwlGa; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=ZMT4jcY4; arc=pass smtp.client-ip=205.220.168.131
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6536RJMx380273
	for <io-uring@vger.kernel.org>; Wed, 3 Jun 2026 11:14:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:reply-to:subject:to; s=
	qcppdkim1; bh=19tJFy9lIf9VnTinb1+YfhqFSRdeYqD56zDrzVGVBoM=; b=Sy
	FYwlGagsxvh7ElOxJmaihXiqez53lfLpIWWl8M297FhjleULl5awjFAoM5CCEWiB
	JvXI+mZLsZQPYSnPNcg2ugnoQ/gJEUl8hFeBJujbGpipnoB6KK60ku7kENQ97OWA
	5Y/dnbMSMl+swmylyF04SqbWrrIOMrvp+538/VQuHGmfDt4QM8n6aJnQps0CPeQQ
	Zw5xpD95r/bTbUfArT1S42IVDtiPxePAIKB86A54NhuZ4lBvfoIlKToh7F1xnAco
	R3BVyIm8rwKaAb/B6rU2fDdMyufOt99LQP2nwge0bnpH662XZoHu41TfCP8gn3UN
	eZaHisN6F0jKdQZxaU/A==
Received: from mail-oa1-f70.google.com (mail-oa1-f70.google.com [209.85.160.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ejewhs6u4-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Wed, 03 Jun 2026 11:14:02 +0000 (GMT)
Received: by mail-oa1-f70.google.com with SMTP id 586e51a60fabf-43d1e4bca47so2896637fac.3
        for <io-uring@vger.kernel.org>; Wed, 03 Jun 2026 04:14:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780485241; cv=none;
        d=google.com; s=arc-20240605;
        b=LXMt9Ghee3wtJcSrc6KGr4gN0wvo3Q+koz5YTL6vZhm0/zXaYk1mvNmtzr6Cc2Hgrb
         py2VrGV6lotypAdDPHZ3Ejz1gxMSuDWkvkkXDOs8YSZYq9HWMKDlWN1qNzicVEoxNu9d
         QcEaGpMtieKx6Kh804cubNYBWVvQs5w1THg/klYAA+B+e2MgdrlPK1du7mE8kdBBM5y1
         yAh4cP6vMGfuBRmGhQogdId/bcerCMKy168Cqx0QF7GXE0bvfOAyLbDPE/QPDoHofJZ1
         eGA2kBeNS9IQUQjIFj5qM5XvEuASfsB4eQBPDlK9RBIqXMlQVTrFKF7vqnaVtYGmdbUQ
         8wVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :reply-to:in-reply-to:references:mime-version:dkim-signature;
        bh=19tJFy9lIf9VnTinb1+YfhqFSRdeYqD56zDrzVGVBoM=;
        fh=7Qrcs4S9AKgotDv4CaThLXPwKX21CdFdaxO82d6fB8g=;
        b=f34PF3hM3m8LLiBA/huN4pHYtVsR4vrhXISgPtyjwpy2zMPwl1ogwpb2wxMXHFNzkN
         f0VhY0JWs8P32YkZ4EB90N/DiERQnKYhHJ+ba1DWTWfUEK0Mk6VXHxZMkBbQcUfm71XS
         OILLYux78cyCn/rtzBbv5aBXfo9Vmv/D+jR2CaOpP2d8nC4UEGgZIbntl+2jkYCV10Xb
         N2N1S09T7dSFZuJ7eB5SZrMOz2Nu+qstuicdexLelFn0l8WXkf2Bks+WkL7kC8/Huv4x
         aVtHGJQTpl7ou2eWvrY9lklcIS93HNJ9M2aTPnIERcwkW5yK/BJsVXyim6FeTG75rKF4
         7HXg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1780485241; x=1781090041; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :reply-to:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=19tJFy9lIf9VnTinb1+YfhqFSRdeYqD56zDrzVGVBoM=;
        b=ZMT4jcY4SxKVBIo7ObriG4J0i/pcBqJ9zDSy0Oj29nWI/wuoBpaqf7p/ExlvWTZZ0q
         CNtcxrSXY0PZ37gEjFajforGGp+XKofPwLJ8stBiAuZXoneTWTeShQAYXSeIgTiQE2KO
         cpvbXgVFLj2CzIs8k0l3Xu6NPSVc7myNGRY12JcvGx0RW5erfPmfwnXnfPkct/pzM8z3
         8Li46cXMXJOnQMS16jyXLft6Ibxjl3E/4g9KUect5eQdsmBR/Qh04btQrGRMt9rb1W7w
         kvWzcTpN4isXL0n6Oy6QwJnZ7XAyrUJQViRxiomth1eAmJen7vbUbaBUdfCgA9OEpFlu
         6A/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780485241; x=1781090041;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :reply-to:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=19tJFy9lIf9VnTinb1+YfhqFSRdeYqD56zDrzVGVBoM=;
        b=XISTHyADdNCpG2E1WwELGcsJlDP4HrvW0XW/lsiqZMEFFZ8fVgCnv1E06GQMEVfgPN
         o/KkOZBp7AGMyH3I1D/94Fg5IvNeqDJc47oJtFyHsD7Soks+2+M4rFdy9Zqq1OPwUH6s
         f+YiclX9DwnqXrqtS/vMm8fMNMr7wYvgUAYAEpcz2c0n33gz0lWv9xGjYe6l7xDwW4QB
         5mj7cl7+AlxySIek3NZHramlgj02SCYRlVhKjzHUHyJWqomvLaSDODrTNYCXg95C8KSt
         q0T5Eeg4p5OrOIhbRttNuE5WHWQSvSZO3bokrbaQG1JpQreEY6A6eClPFiIkE8scVCgV
         0KAw==
X-Forwarded-Encrypted: i=1; AFNElJ/TftLbfUcyiQ+ULwjZYyuy+sHU0xfjNdbv2iUPziVDOwzn5t7+YFnXgWs7Ks2J8pFaicZVlvX1fA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyuHrRFNCn8LxDuHHLCCWpFm6tkT4i27mKVqX9IUxVyKHm0elVX
	ZPSL9/lgcBTe4pcdLwFzW190aCIP4HUqQF7jD+IIXHBWlqcZ8ALxIcc/wO5bQiRJ9PtV54LMdMo
	NOVlUO1Zl59jDWa9CEj7cBe9fS1rfhEnMwqiGoLU5OdFL6GJZyE4ydSGQoN6joUkQjqZa5dbEy4
	nyVrJ0nd8+9ruI7mm49iq26PqmQpzwOqyysy5xjasicpxN
X-Gm-Gg: Acq92OE3I9ViVPrDYihKcMngSF4kLBzU2m7BVhDkxwhJ7In6mypswEN54uf1NFZ5mo/
	ng6uIZKD1/DeiZcwrwzhKXF6R3MLiaYSjLilucJEuk2AW46FyXOLbWy50lipXkpjWwTRSZFA+PS
	SoZWxfCpKKKdokrLE2jlOKzigS+auv9urNiHyIsLDRheoWkg1VZFOIkwEJ9e12QRNdBtctlk/RY
	4m9EK1zOJftdALDNA==
X-Received: by 2002:a05:6870:171b:b0:439:d504:1465 with SMTP id 586e51a60fabf-440db44d16dmr1912779fac.5.1780485241389;
        Wed, 03 Jun 2026 04:14:01 -0700 (PDT)
X-Received: by 2002:a05:6870:171b:b0:439:d504:1465 with SMTP id
 586e51a60fabf-440db44d16dmr1912767fac.5.1780485240990; Wed, 03 Jun 2026
 04:14:00 -0700 (PDT)
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
 <CACSVV00k-fxW6+waHNqvmYcnVNDkRexoWWprFzfayZfqdyMuuA@mail.gmail.com>
 <CACSVV00dNWgpNVU5rB=Hmg+3oWF18yTyfKNr_tWesjoP1jMxwg@mail.gmail.com> <5e6948b3-d235-4b61-aed7-e8b4d0f5b452@kernel.org>
In-Reply-To: <5e6948b3-d235-4b61-aed7-e8b4d0f5b452@kernel.org>
Reply-To: rob.clark@oss.qualcomm.com
From: Rob Clark <rob.clark@oss.qualcomm.com>
Date: Wed, 3 Jun 2026 04:13:49 -0700
X-Gm-Features: AVHnY4L4Mu1tTTnLDgXjw8iz5Wj3eHB3OSZ6g8qAAhd22vyCAP_N07hQtlCZoOc
Message-ID: <CACSVV02v0Fuc6=Rqyd89D-_tcSjEXuQmxz0+2-4aoRAEwJE4zg@mail.gmail.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjAzMDEwNyBTYWx0ZWRfX8eRJnaugTUQi
 ew+PioRnPvDBt1yU0u96LPU4dZS5rH8dMG4mcZGBB8t1gzqSiAQiPsiM6SbD4qgd9Ph+mnsxdq6
 dcjEywvqI6E8V0hgoIKvtJSQW5xGtm/izQLsuRtJFmQ2DzFMIGW7at3fY9wn/l9aagHGf53nite
 yIDth76mrYNb6WpyETH3gkMQ4Ub6mLIixBGH9s+Ln2+WBvmSTsloK8mZzrevqvYli1rAFMZpPcg
 /KrOFUTBmgsR2kMBeYQYlbYMBKPk2xDamr320ar7rHDBC4gcjluM9fV0moYmp4nKzMy/+VMjhjn
 pxlbxj6Utd5UaurFzJXh6Ay+zUzRsZNX6Qar9V9gbE2gC1fA3EVGW6WUZbF+lSoOxZoHpVCpu3t
 i6ktLPva+ESyf62dAIzueUFd5ocecSCGRwwA3tD53IQTMdlqvTkmC5X+6OnqJrBGzN6B3uUm7ME
 veVopvuOVkbt42/xfMQ==
X-Authority-Analysis: v=2.4 cv=Zewt8MVA c=1 sm=1 tr=0 ts=6a200c7a cx=c_pps
 a=nSjmGuzVYOmhOUYzIAhsAg==:117 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10
 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=yOCtJkima9RkubShWh1s:22 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8
 a=8jdotb935GZv83SU0eMA:9 a=QEXdDO2ut3YA:10 a=1zu1i0D7hVQfj8NKfPKu:22
X-Proofpoint-GUID: kCKJi59jCPE7ZF25x08YttcddNFt2ynB
X-Proofpoint-ORIG-GUID: kCKJi59jCPE7ZF25x08YttcddNFt2ynB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-03_04,2026-05-28_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=0 spamscore=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 adultscore=0 priorityscore=1501 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605210000 definitions=main-2606030107
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[qualcomm.com,reject];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[qualcomm.com:s=qcppdkim1,oss.qualcomm.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-13602-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:vbabka@kernel.org,m:hch@lst.de,m:harry@kernel.org,m:akpm@linux-foundation.org,m:broonie@kernel.org,m:hao.li@linux.dev,m:cl@gentwo.org,m:rientjes@google.com,m:roman.gushchin@linux.dev,m:hawk@kernel.org,m:linux-arm-msm@vger.kernel.org,m:dri-devel@lists.freedesktop.org,m:freedreno@lists.freedesktop.org,m:linux-kernel@vger.kernel.org,m:linux-mm@kvack.org,m:io-uring@vger.kernel.org,m:kasan-dev@googlegroups.com,m:bpf@vger.kernel.org,m:netdev@vger.kernel.org,m:aleksander.lobakin@intel.com,m:boris.brezillon@collabora.com,s:lists@lfdr.de];
	FORGED_SENDER(0.00)[rob.clark@oss.qualcomm.com,io-uring@vger.kernel.org];
	FORWARDED(0.00)[lists@lfdr.de];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[21];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[qualcomm.com:+,oss.qualcomm.com:+];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[rob.clark@oss.qualcomm.com,io-uring@vger.kernel.org];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	HAS_REPLYTO(0.00)[rob.clark@oss.qualcomm.com];
	ALIAS_RESOLVED(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,mail.gmail.com:mid,vger.kernel.org:from_smtp,qualcomm.com:email,qualcomm.com:dkim,oss.qualcomm.com:dkim,oss.qualcomm.com:from_mime,oss.qualcomm.com:replyto]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 02C3B636E8F

On Wed, Jun 3, 2026 at 2:17=E2=80=AFAM Vlastimil Babka (SUSE) <vbabka@kerne=
l.org> wrote:
>
> On 6/1/26 16:39, Rob Clark wrote:
> > On Mon, Jun 1, 2026 at 6:32=E2=80=AFAM Rob Clark <rob.clark@oss.qualcom=
m.com> wrote:
> >>
> >> On Mon, Jun 1, 2026 at 5:50=E2=80=AFAM Vlastimil Babka (SUSE) <vbabka@=
kernel.org> wrote:
> >> >
> >> > On 6/1/26 13:38, Christoph Hellwig wrote:
> >> > > On Mon, Jun 01, 2026 at 10:16:30AM +0200, Vlastimil Babka (SUSE) w=
rote:
> >> > >> > kmem_cache_alloc_bulk() returning 0 was considered a success in=
 that case.
> >> > >> >
> >> > >> > Either fixing kmem_cache_alloc_bulk() (and the comment) or fixi=
ng the
> >> > >> > user sounds fine to me.
> >> > >>
> >> > >> Would it be wrong if we just returned true for size of 0? Would s=
omething
> >> > >> else break?
> >> > >
> >> > > I don't think it is wrong per se, but it feels like the wrong kind=
 of
> >> > > API.  I.e. I don't think the MSM caller actually wants this, as th=
ey'd
> >> > > also do a zero-sized kvmalloc.
> >> >
> >> > If p->count is 0 then indeed there's a zero-sized kvmalloc so p->pag=
es =3D=3D
> >> > ZERO_SIZE_PTR but then nothing breaks because nothing tries to deref=
erence it?
> >> >
> >> > msm_iommu_pagetable_prealloc_cleanup() has a "if (p->count > 0)" bra=
nch so
> >> > it seems it's considered possible. But then the rest of the function=
s also
> >> > seems working fine, i.e. kmem_cache_free_bulk() of zero size does no=
thing,
> >> > kvfree() of ZERO_SIZE_PTR does nothing.
> >> >
> >> > It seems to me kmem_cache_alloc_bulk() returning true for size =3D=
=3D 0 fits
> >> > naturally in this world and is less likely to result in a gotcha?
> >>
> >> I think I was probably expecting kvmalloc(0) =3D> NULL ... but it
> >> happened to work out before
> >>
> >> Adding an "if (!p->count) return 0;" at the top of
> >> msm_iommu_pagetable_prealloc_allocate() seems like the thing to do..
> >> if you want, I can send that patch (but traveling this week... so
> >> let's see what I can do)
> >
> > Aaaaaand.. sending patch from hotel wifi doesn't seem to be a thing
> > that works.. but I've tested the following w/ deqp-vk cts, and works
> > as expected
>
> Thanks, I will amend the commit in slab tree with this as the easiest way=
 to
> go foward.

Thanks

> Just a quick question though:
>
> > ----------------
> >
> > diff --git a/drivers/gpu/drm/msm/msm_iommu.c b/drivers/gpu/drm/msm/msm_=
iommu.c
> > index 7d449e5202c5..ef744d154bbe 100644
> > --- a/drivers/gpu/drm/msm/msm_iommu.c
> > +++ b/drivers/gpu/drm/msm/msm_iommu.c
> > @@ -332,13 +332,16 @@ msm_iommu_pagetable_prealloc_allocate(struct
> > msm_mmu *mmu, struct msm_mmu_preall
> >         struct kmem_cache *pt_cache =3D get_pt_cache(mmu);
> >         int ret;
> >
> > +       if (!p->count)
> > +               return 0;
>
> We know p->pages is NULL in this case, right? Because it was allocated by
> vm_bind_job_create() using kzalloc().
> And the job can't be reused with a leftover value?
> (msm_iommu_pagetable_prealloc_cleanup doesn't set p->pages to zero).
> Or should we set p->pages to NULL here.

Correct, the job is not reused.  But I suppose setting p->pages to
NULL would make things more obvious, so no objection to that.

BR,
-R

> > +
> >         p->pages =3D kvmalloc_objs(*p->pages, p->count);
> >         if (!p->pages)
> >                 return -ENOMEM;
> >
> >         ret =3D kmem_cache_alloc_bulk(pt_cache, GFP_KERNEL, p->count, p=
->pages);
> >         if (ret !=3D p->count) {
> > -               kfree(p->pages);
> > +               kvfree(p->pages);
> >                 p->pages =3D NULL;
> >                 p->count =3D ret;
> >                 return -ENOMEM;
>

