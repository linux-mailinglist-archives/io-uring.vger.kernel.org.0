Return-Path: <io-uring+bounces-13607-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id VfweDNtHIWrcCQEAu9opvQ
	(envelope-from <io-uring+bounces-13607-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 04 Jun 2026 11:39:39 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id E9EF563E9DA
	for <lists+io-uring@lfdr.de>; Thu, 04 Jun 2026 11:39:38 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b="gk wQ7pQ";
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b="hKgd3/UY";
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13607-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.232.135.74 as permitted sender) smtp.mailfrom="io-uring+bounces-13607-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=reject) header.from=qualcomm.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=2")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id E2A9C308F810
	for <lists+io-uring@lfdr.de>; Thu,  4 Jun 2026 09:37:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED7CA38E8D9;
	Thu,  4 Jun 2026 09:37:11 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D2813A9017
	for <io-uring@vger.kernel.org>; Thu,  4 Jun 2026 09:37:08 +0000 (UTC)
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780565831; cv=pass; b=WaXJhnh/gNr8PamM+8jrua5GCRkt9HSwvaxEi+3SeeohHVgJ5Ir5Lss5sRh8mRm310v9Ofgm3P5/K2a734BSwDhY+bOgcX1cgJUyyXBFE2kcpM2CFNd1XSjBo+Ex6vIcV/bgxF6wklPK57P6yyt99xoB4IBeQ/S0WSKnrPa2f/I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780565831; c=relaxed/simple;
	bh=LKFmCuDQNLkJpDjv10PTCN7SoRI92sQX+juYlxXSmCU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=e66TU9sPm+iiWjaOJkGFpEFvZGKNt+oc3WW10XvZalG+/TI3coLjUzCCARRIZUdc4WRVRhMK+gC5FaQdkRqQ5vT7z/Cto5BMFm3jexbDg6kH3/E3gFpaWf0T7EWLLAoL5HoLJwLSciscjh1tWV+JlHkqtBzw56Ygz4zfquFl80U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=gkwQ7pQG; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=hKgd3/UY; arc=pass smtp.client-ip=205.220.180.131
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6543iWv73233934
	for <io-uring@vger.kernel.org>; Thu, 4 Jun 2026 09:37:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:reply-to:subject:to; s=
	qcppdkim1; bh=LbH2Ej66t35eFH01LN7Yn1mCVFPgBbI2BNIp23nOi0I=; b=gk
	wQ7pQGrydVH4blqAd03q/e5Ae1bc6NbOQrmi8+rkuGoe4hzxNhqsJTwdZ7wdW/+N
	qDxXNeOTPUwizWZs2hH9w8/Dguipy6CaRuCRoLEcFNj16hvzbndv+YDWdp5V7tbO
	myZCEQ905ekyZ8KmSkGZ4nHoSkeaSZo90THNZ8f1Ow09YhZkoFIQTeHNfhZw9Vx4
	PFfg/aVoZC4rsLW1ANya/izCW3kjD78HPRL82MviYJ9f77AWmu3ujblBlbiwXYV0
	1gWu4CL/J3Nn8B9UV26DMYO+HnPLUwIs+kzQRLfroybnAOf5kfTrCEXsRYwhpABP
	B5FOeZZdPcS6JqR0hCZw==
Received: from mail-oa1-f69.google.com (mail-oa1-f69.google.com [209.85.160.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ejs4s31mj-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Thu, 04 Jun 2026 09:37:07 +0000 (GMT)
Received: by mail-oa1-f69.google.com with SMTP id 586e51a60fabf-43d1fa463d0so478056fac.0
        for <io-uring@vger.kernel.org>; Thu, 04 Jun 2026 02:37:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780565827; cv=none;
        d=google.com; s=arc-20240605;
        b=TLeJ/yN+MQzmOZCRDHlFzjfZ2E31WS9lsElNNFaPPVxDEXlbXfjzIIDSkRAr+w9OBf
         ub9iIQh0/2qngn+yEftsxyOm1KOoNt9hqwLSNR+cQsA9+Gg8U09ZK2AyBxcKl+R2fnaW
         M48rFBv49x5xqOCzWxklVuadRkd+GLv0kJl2V4gBvArDnjqWugS9EYUOwZddDtLmPmMD
         GqWgPnkIsg0Ds1jPUElJwrA6dQAZcrjhOysqIiSeC8cASbGvJRJB+DiCQE/5DcD1UjBF
         4C1kpWbclmEW5oTNfMElZzZnIUtEx6eo0yW3u6AjynGgzszbl221wKLIAK2vnFHbk2TF
         NYQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :reply-to:in-reply-to:references:mime-version:dkim-signature;
        bh=LbH2Ej66t35eFH01LN7Yn1mCVFPgBbI2BNIp23nOi0I=;
        fh=/cwL4KcMac9MUEEH4vkTBXRPuEORTZsgMfZ5SeTWABo=;
        b=U2Ar6CVALCqM5CJ7xLYy2K44GG5eYUWsugCvN1T8OS1KFl50/fquI4ut2/DxTICwTz
         0uXbGCjx8u5LKwmR5K5kcmKFCTc8UbPu0PFfwMIaguUWF1h26KSJ5v6JvKS8VG8D5ywi
         n9FXe4iPK0UaRc2i1G7QyXr27h4AlJ2d0U9sxuigDcpWA676MPKHfGjdsOS/Hd567wiu
         gZVQjxx6jNpg4yXl6VzJbT47O2wYwhhx/nsSsOw7PzhdiaNDY5Dpcy6kP8q8PIpDHF6/
         pby2Vc6eTJY22xSf5ZL6S6OXJ5XRRC0CP8ehH31byx4Zy6fj4inev62MnIZQfxpD0lpk
         TOTQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1780565827; x=1781170627; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :reply-to:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=LbH2Ej66t35eFH01LN7Yn1mCVFPgBbI2BNIp23nOi0I=;
        b=hKgd3/UYOYkLn6Vt4jiCJoWhjU3CQEf++REHBScqG1MtabumpLwC9RKT1QDzSOVkzW
         5Hjej8nFe4FFnlmi3imAptcteDpfftBYMQqE/T+qGOFskaHDM6oW6metZC29PA1GadHC
         Mh00QfXDC4poTJJAqxGY/gmRGRm32+56z/BI6HRLa7mdBTFOcL7ntieksrsxudwfExJt
         kVEw+rr2a3ncxokBKwoRwPRQU3psljLRwWHeoQTqrSwVnpwr779e/7GNdrceGr2MKAyQ
         ko7Ai7QJp7wPy/t0aoxUvFxxQPVef7teClXNSmzsFYK0j/LEA4fjuLV7TW87WkK5/9p4
         80mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780565827; x=1781170627;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :reply-to:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LbH2Ej66t35eFH01LN7Yn1mCVFPgBbI2BNIp23nOi0I=;
        b=Y9wyRstsJHRfx3ghC5ioDs5ic2ACslrt0k37BhJz3HFN6+iQSXr0xdQsk5NrIkKWEe
         OdyKDI4mXpTi8RglbROaNBMrWYK2PtV/SNPrWsqYKkYjTjqfJukT9Q4/T09mx+m7ENj6
         Yc1VyVO7fE2usNwHy2Nkn/H23AmD/DSCTa9SUVkC47hURdnMlBRA5FmyalsRq1kq/0wi
         2XgbceA2wSK+HxpqFs1QQmKoCGKdldHIzAZJhn6yS4WMcEwN2i2BMP+yvbWY4mXSBa64
         B3vqdtVKiw9qgeybcrbIsUeRrC/P5caVjinBJ7YJ+36SCld4NdK1CR2zcbslkDrcxZGG
         sVaA==
X-Forwarded-Encrypted: i=1; AFNElJ/6OXfiWZFhH4O4T3Vb0/uBAoTVnOrisOHQE0oGicrlMLowT+oBNa306tkURv6jHvtpaKjLRhti0w==@vger.kernel.org
X-Gm-Message-State: AOJu0YwPLVqn2NUeQYOlgd4IAJS6Yyu4ykSatu3aUGJoVi4+RtHQj9yp
	9SXlW8mW/xy2rvySj5HL5Y4Km4CQFw0mcdGfGYDdYs40QudHayq8I/OIQTMJcRkh49AcET5qdiN
	yEVF2ESP69YDIyWn68LhYq0e55yH90HcVtfTEBxfoJi4CZdDrB0BNbMOrQ2BD4VnOyYoPwjnaRg
	VP3ryKiGd8RIdC6Sf7NVLNQGxdBdc8MO+uFubA
X-Gm-Gg: Acq92OHpu0M67SvZppWJ2doxBGcG+YcZd1YIqe+tOuH3PF6hRBBzApnf+40ZXcgBRda
	OUJj1glAIgA0sWX0xnJERfmrt59g/K3PnArR0JwCL6Aw+st1WQggCgVokJpDkoiqKPx0aaUD2Mm
	22NURbhiD0VN3CWZMnZ6duX0IIWZMF1AMo/lkaKN6y/KKPKM538E430kY3jR8m44o4ILkjh58q2
	5CazCwtc/Jm/Z7JIw==
X-Received: by 2002:a05:6870:d0d3:b0:43b:9922:9df2 with SMTP id 586e51a60fabf-440db7cf55cmr4593215fac.21.1780565827216;
        Thu, 04 Jun 2026 02:37:07 -0700 (PDT)
X-Received: by 2002:a05:6870:d0d3:b0:43b:9922:9df2 with SMTP id
 586e51a60fabf-440db7cf55cmr4593192fac.21.1780565826858; Thu, 04 Jun 2026
 02:37:06 -0700 (PDT)
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
 <CACSVV00dNWgpNVU5rB=Hmg+3oWF18yTyfKNr_tWesjoP1jMxwg@mail.gmail.com>
 <5e6948b3-d235-4b61-aed7-e8b4d0f5b452@kernel.org> <CACSVV02v0Fuc6=Rqyd89D-_tcSjEXuQmxz0+2-4aoRAEwJE4zg@mail.gmail.com>
 <b6f6323e-6f5b-4928-b474-bd2743eac3f2@kernel.org> <f027078c-6a55-463b-8938-95ede02dca3b@kernel.org>
 <29bd5886-15c7-462b-8a39-f2ff25269ddf@kernel.org>
In-Reply-To: <29bd5886-15c7-462b-8a39-f2ff25269ddf@kernel.org>
Reply-To: rob.clark@oss.qualcomm.com
From: Rob Clark <rob.clark@oss.qualcomm.com>
Date: Thu, 4 Jun 2026 02:36:55 -0700
X-Gm-Features: AVVi8CdLwF-PFxeKWBcz71YZzZxxEA0LQrJYMS3qkVqAqJLyt2EL9LT70o-g4fs
Message-ID: <CACSVV03Ez9uKw0WDm9G2HTfyXy8SLu9AFGGnY58z-GK+32DV3A@mail.gmail.com>
Subject: Re: [PATCH] mm/slab: improve kmem_cache_alloc_bulk
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, Christoph Hellwig <hch@lst.de>,
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
X-Proofpoint-ORIG-GUID: 0iwWYQ3PBM_mkb1YbHrKTdlT7AxvP328
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjA0MDA5MiBTYWx0ZWRfXwcU5NtS2G8Bo
 /ZNoiZscpiRmWT/fFcn9NjaAnoJxwOcKcOfTV3Tg5qShcnKpT9naSaEibRbBEul5BqnyRX0Dt1m
 c3wRqcP3kOgHHFSoCXt8F3iROoeA91XfrZhmwk4TbLnkvFmcu0+jNpdo83RDF2xe3QvdUhaYc3X
 jBsLFGb5FV+PVz60kgLcsX9s4zWUajQE1mSG6Bc0vuBY9Hzvq3P9baWlg+/dm6/T7rWGplZcvwh
 /ULpQE/pDF7sT6eXpDl6XerILwufKgFafVvnjar0006+yLpWSb8/MOUSnye80w+25PX6HNu+X1o
 MJuEuYTMhcpJ2M4Mk327jxlrP8mgKUtnLKdDw1344cScFkX4om//OUOrcFFCv6BUCRqTUR3hvFc
 GsPBqnqRjhc4Ut4YqGiMOYhvV1A+Yc1tVPG4N5ilnhnMwBtKLd7juDHqFkg1iHtvoy136XdnB+q
 /BhS7kIRd3m3KFO5FkA==
X-Authority-Analysis: v=2.4 cv=afRRWxot c=1 sm=1 tr=0 ts=6a214743 cx=c_pps
 a=zPxD6eHSjdtQ/OcAcrOFGw==:117 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10
 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=rJkE3RaqiGZ5pbrm-msn:22 a=VwQbUJbxAAAA:8 a=G_pyjxEXS8sYRXXvRXQA:9
 a=QEXdDO2ut3YA:10 a=y8BKWJGFn5sdPF1Y92-H:22
X-Proofpoint-GUID: 0iwWYQ3PBM_mkb1YbHrKTdlT7AxvP328
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-04_03,2026-05-28_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 bulkscore=0 phishscore=0 clxscore=1015
 adultscore=0 lowpriorityscore=0 spamscore=0 impostorscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605210000 definitions=main-2606040092
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[qualcomm.com,reject];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[qualcomm.com:s=qcppdkim1,oss.qualcomm.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-13607-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:vbabka@kernel.org,m:harry@kernel.org,m:hch@lst.de,m:akpm@linux-foundation.org,m:broonie@kernel.org,m:hao.li@linux.dev,m:cl@gentwo.org,m:rientjes@google.com,m:roman.gushchin@linux.dev,m:hawk@kernel.org,m:linux-arm-msm@vger.kernel.org,m:dri-devel@lists.freedesktop.org,m:freedreno@lists.freedesktop.org,m:linux-kernel@vger.kernel.org,m:linux-mm@kvack.org,m:io-uring@vger.kernel.org,m:kasan-dev@googlegroups.com,m:bpf@vger.kernel.org,m:netdev@vger.kernel.org,m:aleksander.lobakin@intel.com,m:boris.brezillon@collabora.com,s:lists@lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,oss.qualcomm.com:dkim,oss.qualcomm.com:from_mime,oss.qualcomm.com:replyto,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,vger.kernel.org:from_smtp]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: E9EF563E9DA

On Thu, Jun 4, 2026 at 12:35=E2=80=AFAM Vlastimil Babka (SUSE)
<vbabka@kernel.org> wrote:
>
> On 6/4/26 09:10, Harry Yoo wrote:
> >
> >
> > On 6/4/26 1:22 AM, Vlastimil Babka (SUSE) wrote:
> >> On 6/3/26 13:13, Rob Clark wrote:
> >>> On Wed, Jun 3, 2026 at 2:17=E2=80=AFAM Vlastimil Babka (SUSE) <vbabka=
@kernel.org> wrote:
> >>>>
> >>>> We know p->pages is NULL in this case, right? Because it was allocat=
ed by
> >>>> vm_bind_job_create() using kzalloc().
> >>>> And the job can't be reused with a leftover value?
> >>>> (msm_iommu_pagetable_prealloc_cleanup doesn't set p->pages to zero).
> >>>> Or should we set p->pages to NULL here.
> >>>
> >>> Correct, the job is not reused.  But I suppose setting p->pages to
> >>> NULL would make things more obvious, so no objection to that.
> >>
> >> OK, did that, just in case. Thanks.
> >
> > The kvfree() -> kfree() part should probably be a separate patch
> > with Fixes: 830d68f2cb8a ("drm/msm: Fix pgtable prealloc error
> > path") and Cc: stable?
> >
> > ...as the commit landed v6.18.
>
> Hm right, but realistically, can there be so many pages necessary, that t=
he
> array to hold their pointers would be over what kmalloc() can provide?

Pretty unlikely.. IIRC kvmalloc won't fallback to vmalloc for anything
under PAGE_SIZE, so count=3D=3D512..  which is more than 10x what I've
seen in practice

BR,
-R

> >>> BR,
> >>> -R
> >>>
> >>>>> +
> >>>>>         p->pages =3D kvmalloc_objs(*p->pages, p->count);
> >>>>>         if (!p->pages)
> >>>>>                 return -ENOMEM;
> >>>>>
> >>>>>         ret =3D kmem_cache_alloc_bulk(pt_cache, GFP_KERNEL, p->coun=
t, p->pages);
> >>>>>         if (ret !=3D p->count) {
> >>>>> -               kfree(p->pages);
> >>>>> +               kvfree(p->pages);
> >>>>>                 p->pages =3D NULL;
> >>>>>                 p->count =3D ret;
> >>>>>                 return -ENOMEM;
> >
>

