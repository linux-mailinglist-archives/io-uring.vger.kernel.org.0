Return-Path: <io-uring+bounces-13584-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WMBAEDmbHWpYcgkAu9opvQ
	(envelope-from <io-uring+bounces-13584-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 01 Jun 2026 16:46:17 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A51F6211BB
	for <lists+io-uring@lfdr.de>; Mon, 01 Jun 2026 16:46:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E37353021E5E
	for <lists+io-uring@lfdr.de>; Mon,  1 Jun 2026 14:39:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCB3E3BBA05;
	Mon,  1 Jun 2026 14:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="fl2WHhoU";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="afHBz6Tw"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 640823C0606
	for <io-uring@vger.kernel.org>; Mon,  1 Jun 2026 14:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=205.220.180.131
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780324772; cv=pass; b=dJDxvYmLys73mgdVN1Wu6i88KKtvtatZ5M7NzL65oYLpFxcAcIDdxwJi0QYVOPJxvukMpdS/YhBLn/henwMI6VxipQMbj+yUJxB8DeXdm2sTrQeUCz2+34q/Q7jwEgUq0VSBRQ+KGY5WqQVb7nGCy0Bj6lgOZ8JnQidd4wkzbL0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780324772; c=relaxed/simple;
	bh=OHSvGqIQ7vUQwbN1UD2YIJMwDDsgXFuN8/NYPDCdXOM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NA3BqdTcugLWUM2MenqOeI2vYPBuiIxqRPz4OJbP6IGmkqkugrnUyAbpoQYYY8AcJ39dtsNMF0OKr7heX1mYtPEeOAuAiVLwZfX+gC86vW8jUrFgEdMs6n6ZsRzWtq4CFNjkyYo02b2o9gbP6jL9ThAbEHwr7xwaP79PD0M/KfA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=fl2WHhoU; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=afHBz6Tw; arc=pass smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 651AxEPu334631
	for <io-uring@vger.kernel.org>; Mon, 1 Jun 2026 14:39:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:reply-to:subject:to; s=
	qcppdkim1; bh=VN4C3LVZuH1k7AUd4KK8MEyJP8WIXP8lg6sKthHlaQM=; b=fl
	2WHhoU2ZbOBnQayMN29RXuPbvfhRf7VSTallEctg+EVOpuK7OgxdBm1XKyW8KVTE
	2FmNSvRNQVGx1p8XxVrQ/Acsaz17y44FmnZf6SXtJAHS7yz6ptk3108QtY5IBJ57
	rGpDJvhLyR6ZpSbbxiv5Cd5Mx+Nx50TKvl7k7InzYMfbjxMf+CT/ouAgiL0kUY12
	hQjpPFe61B5qE52vZYVpldryQZ1paFipGZJISOzTfsMA4uSAHXUCQAf2UYW4q44Z
	m1eRBDEscpykCOKXssGcU4hCKIBbpc83YhNKgOd/8ieznHfQ15SoeqQ1iy/P0qG3
	yGRx31p+5FW9UFEHz3iA==
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4eh8tfrxg5-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Mon, 01 Jun 2026 14:39:30 +0000 (GMT)
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-48638da0e05so296205b6e.3
        for <io-uring@vger.kernel.org>; Mon, 01 Jun 2026 07:39:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780324770; cv=none;
        d=google.com; s=arc-20240605;
        b=J4tqd6X0+lpJZgiSoIRhmcN6K2F0pbN3r1A0bOp3oKfi8Hm9vnGN6qthhregEOrWcR
         4UNVWAqizq/qybkw37Dn2vGNQLGW4M240pmgKFJDFLJ10gnCHWXpUIZ4TcmbSLKM/HZs
         FylMYK9qUK5pBwKXxaR0atE0gkgau5aRZj6hU5ABlai8KR/Do9yJOU1clw9m2Dy4Q+64
         A/L0G/xrGZP+tyazj2GHHpuZPhK8I5DHO0Qc/VYwMZmu1/eK2Jle4XCvzCfN7yrv8sAF
         ShRxyc7ohpTXq1sqrBD2iQxau06Li2I3UJ0uy91DpfPuiyy7beTTUOzfPw88m/KuL+7Q
         1bcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :reply-to:in-reply-to:references:mime-version:dkim-signature;
        bh=VN4C3LVZuH1k7AUd4KK8MEyJP8WIXP8lg6sKthHlaQM=;
        fh=DACXN+AmT+fuU8GodlIzwgDtpbvDvEvw3wlQ1naQbww=;
        b=cseL382r6UMUjmzqVWA7Yt5csPOAj5SfFbeIOGpRjK7iGUz2DvwdA8ydYwx6/9ScBq
         dkja/yf/eTfTCwMRnZ8Wyzdt1VFxghlTrcPPbH4bgnN7u7Q5VrDL/oUTzVN1/Y+xdNwU
         mhikVaegIIDdDHUxWtrA1Q+j48oSIq7rppwQ7GyU38ZhkpK1akcc9Z9K6BHvPuVTtsok
         c4TFWTsY+TsoJzvHs39i/cx93+v3uzNjxdRQuDy12HU73kLj1QlAnO+YHf8DCldgP3mi
         O5mXyBdRZQkQ+435fhdr8isCqTglfQl1ci/wBI4EVla2DQxGgh+00CZ3Er9aA/I0MgXC
         rGjw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1780324770; x=1780929570; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :reply-to:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=VN4C3LVZuH1k7AUd4KK8MEyJP8WIXP8lg6sKthHlaQM=;
        b=afHBz6TwfkNZCAmC3N3h6/jIa9hJYKv6s+OgLCa3CfraPm/DU1XNLjf+e8CjQpmHRm
         YfBmHOeF2XURArLN0nybXFouhC/YLMA9WeZlXiUlEY+6kZ653lxNBfDiiBgGaBaxqpEI
         4p55BYcSQh5rghKDmd0Q81clsV+GKcmYu+v6T92IBM4EAgy3wXtANqel+UHeEeQbkdIt
         0O+T5X37kW1YdIvos7/pMoGWpqGcXoZqxnWu0zlCKyozXJi1kBvY6Nx/QpBrC/7QsW7s
         Py0+uCOYhhWICVx9RI5iv0erUpKg8SWaJVnpHrutIHjeWalHR6vxZMth1R+48NLl/31g
         I8tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780324770; x=1780929570;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :reply-to:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VN4C3LVZuH1k7AUd4KK8MEyJP8WIXP8lg6sKthHlaQM=;
        b=nIQzX8/IKjawRTZ52CbWDCgZnSdyylh4/rP4FUzUD4CFgqe2xehMZKkgwK8DzW5/sf
         TWJR+I6Fkdbm3Us81L9sJA2q72KziklhY9aoGpoLC41cPipFaFHJsuffZzEGLf/rKRKg
         PGyILxFXGPDqj9Jnxh9Jw886uPOpEWTZXxyjsz01w1ZPR1bALXzo8WzzihQazB8AAgtb
         atCtkpMntqTy76Rw4UOCYYMy+QQLxiH4G6q1wvyKyuPvAlMY5a/mffo/68n1GV5m1wch
         VvDyjt/P3/M2rjiEMu4imlxv5IULo3m7XvoasiFU21J4cQ5t4CMehm8Y3lQlmoFXnYJP
         TSNw==
X-Forwarded-Encrypted: i=1; AFNElJ+0/u2s6XrcOggt/R0oap1dUq/Y4Wpss8nMLDL4FYAEbZon4pNgCU/ZZiMStduIGRA9V0Z/8sWMIw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwRPbCJV2L47W2w5Gub6e7nYewmF4/01IoKQPdaROHIbf/K6r3c
	nq0ZrlAGk4SMoTq4H7aCvBbozIU4zO5awhelaGTc2Otw2DJtPhT9BGgjAg2YbFPXQn7nNzjEf8P
	0JVb0bAQ8km+jdP2zN64Z6fB7AxDHZNPQSBJC8TgyX0AISUa6n/On/TMWTwS0zq9+ko5iFgTP3V
	+3shVDb9o1uCX0mqar0sc8BCVLdNV0nJ4QQ+j2
X-Gm-Gg: Acq92OHaYi+kmgidS0EuGFj005502DMoyuIirBmO0HW8/1doiNuKDozT7upBtlux+OD
	wI19gv9veId1EGX0L3wACeecV1Im/xJw/2mYnI+eBG2p2z1UywUkcACmXMyme2OEl1RBSCXbm8c
	IdjjrOTowZUk2y+5Ov14OPlv2uxg3GYexJTs1yH2+0rv3vO3eh61u8Zn/CSFbmes/kZlF0FnZps
	B5/YTFGvWVmgQ==
X-Received: by 2002:a05:6808:1912:b0:485:41fc:71dd with SMTP id 5614622812f47-485fb6a8ec9mr5078448b6e.13.1780324769605;
        Mon, 01 Jun 2026 07:39:29 -0700 (PDT)
X-Received: by 2002:a05:6808:1912:b0:485:41fc:71dd with SMTP id
 5614622812f47-485fb6a8ec9mr5078428b6e.13.1780324769126; Mon, 01 Jun 2026
 07:39:29 -0700 (PDT)
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
In-Reply-To: <CACSVV00k-fxW6+waHNqvmYcnVNDkRexoWWprFzfayZfqdyMuuA@mail.gmail.com>
Reply-To: rob.clark@oss.qualcomm.com
From: Rob Clark <rob.clark@oss.qualcomm.com>
Date: Mon, 1 Jun 2026 07:39:17 -0700
X-Gm-Features: AVHnY4IeX3RPNliDvhMevHdXSnbKaPpqnSaYQnqMtv5VzgFC7cHejpPkwD8NES4
Message-ID: <CACSVV00dNWgpNVU5rB=Hmg+3oWF18yTyfKNr_tWesjoP1jMxwg@mail.gmail.com>
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
X-Proofpoint-GUID: QUx4pClfSdYu6wjnWfB7qddFeSwhqjjB
X-Proofpoint-ORIG-GUID: QUx4pClfSdYu6wjnWfB7qddFeSwhqjjB
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjAxMDE0NiBTYWx0ZWRfX28bUD4lin/HA
 t7fh7YgNy68ZSke5wmQFPqyGALguiCmJBhX2f5URe2k7lJN8//uKuwUSnfJQn6MkyzbQUZYlw+U
 OefGznhwYm457E/DD+geiSItlOFD43801XHJvPm22o6OVTVPBCfTaJ2gtuqaSd7w15kxyxH+eHs
 lVHoQ0syHjJtP+0iFWj70b/8xwZZBYcL5h07hd84PzDFcq9WinL0eG5sbrvVNG9omxxemkfwAHL
 t1YHqPCwdm2RGJOSOSlxU3N39ZI4Ci4+WdReNu1ArZ/fAtK3HPMgP77POOUWeAI0va43Jcr77DZ
 k7xxjSNt6e7IJAJjDaCf136NxkveAuNeaGQ79kI28GrDHVhPoZ89YpqJlRHuIigl5Usa9X9bWAA
 agFXh2wvXzeAS+Lbuq/Fc7bpeORRreWLfB5TvIEJBwRe/4CisAoGJsv4FD6e43ruzdw0jaU93ij
 qOR1Tv5sJVAldQT5XLw==
X-Authority-Analysis: v=2.4 cv=P4YKQCAu c=1 sm=1 tr=0 ts=6a1d99a2 cx=c_pps
 a=AKZTfHrQPB8q3CcvmcIuDA==:117 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10
 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=gowsoOTTUOVcmtlkKump:22 a=EUspDBNiAAAA:8 a=VwQbUJbxAAAA:8
 a=dBKglsDaislA0vfKbgwA:9 a=QEXdDO2ut3YA:10 a=pF_qn-MSjDawc0seGVz6:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-01_04,2026-05-28_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 malwarescore=0 suspectscore=0 impostorscore=0
 clxscore=1015 spamscore=0 lowpriorityscore=0 bulkscore=0 phishscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2605210000
 definitions=main-2606010146
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[qualcomm.com,reject];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[qualcomm.com:s=qcppdkim1,oss.qualcomm.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13584-lists,io-uring=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[qualcomm.com:email,qualcomm.com:dkim,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,oss.qualcomm.com:replyto,oss.qualcomm.com:dkim,mail.gmail.com:mid]
X-Rspamd-Queue-Id: 9A51F6211BB
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Mon, Jun 1, 2026 at 6:32=E2=80=AFAM Rob Clark <rob.clark@oss.qualcomm.co=
m> wrote:
>
> On Mon, Jun 1, 2026 at 5:50=E2=80=AFAM Vlastimil Babka (SUSE) <vbabka@ker=
nel.org> wrote:
> >
> > On 6/1/26 13:38, Christoph Hellwig wrote:
> > > On Mon, Jun 01, 2026 at 10:16:30AM +0200, Vlastimil Babka (SUSE) wrot=
e:
> > >> > kmem_cache_alloc_bulk() returning 0 was considered a success in th=
at case.
> > >> >
> > >> > Either fixing kmem_cache_alloc_bulk() (and the comment) or fixing =
the
> > >> > user sounds fine to me.
> > >>
> > >> Would it be wrong if we just returned true for size of 0? Would some=
thing
> > >> else break?
> > >
> > > I don't think it is wrong per se, but it feels like the wrong kind of
> > > API.  I.e. I don't think the MSM caller actually wants this, as they'=
d
> > > also do a zero-sized kvmalloc.
> >
> > If p->count is 0 then indeed there's a zero-sized kvmalloc so p->pages =
=3D=3D
> > ZERO_SIZE_PTR but then nothing breaks because nothing tries to derefere=
nce it?
> >
> > msm_iommu_pagetable_prealloc_cleanup() has a "if (p->count > 0)" branch=
 so
> > it seems it's considered possible. But then the rest of the functions a=
lso
> > seems working fine, i.e. kmem_cache_free_bulk() of zero size does nothi=
ng,
> > kvfree() of ZERO_SIZE_PTR does nothing.
> >
> > It seems to me kmem_cache_alloc_bulk() returning true for size =3D=3D 0=
 fits
> > naturally in this world and is less likely to result in a gotcha?
>
> I think I was probably expecting kvmalloc(0) =3D> NULL ... but it
> happened to work out before
>
> Adding an "if (!p->count) return 0;" at the top of
> msm_iommu_pagetable_prealloc_allocate() seems like the thing to do..
> if you want, I can send that patch (but traveling this week... so
> let's see what I can do)

Aaaaaand.. sending patch from hotel wifi doesn't seem to be a thing
that works.. but I've tested the following w/ deqp-vk cts, and works
as expected

----------------

diff --git a/drivers/gpu/drm/msm/msm_iommu.c b/drivers/gpu/drm/msm/msm_iomm=
u.c
index 7d449e5202c5..ef744d154bbe 100644
--- a/drivers/gpu/drm/msm/msm_iommu.c
+++ b/drivers/gpu/drm/msm/msm_iommu.c
@@ -332,13 +332,16 @@ msm_iommu_pagetable_prealloc_allocate(struct
msm_mmu *mmu, struct msm_mmu_preall
        struct kmem_cache *pt_cache =3D get_pt_cache(mmu);
        int ret;

+       if (!p->count)
+               return 0;
+
        p->pages =3D kvmalloc_objs(*p->pages, p->count);
        if (!p->pages)
                return -ENOMEM;

        ret =3D kmem_cache_alloc_bulk(pt_cache, GFP_KERNEL, p->count, p->pa=
ges);
        if (ret !=3D p->count) {
-               kfree(p->pages);
+               kvfree(p->pages);
                p->pages =3D NULL;
                p->count =3D ret;
                return -ENOMEM;

