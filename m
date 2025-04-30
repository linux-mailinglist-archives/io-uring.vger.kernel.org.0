Return-Path: <io-uring+bounces-7793-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DCB2AA50E7
	for <lists+io-uring@lfdr.de>; Wed, 30 Apr 2025 17:55:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 88C4E4C2CEA
	for <lists+io-uring@lfdr.de>; Wed, 30 Apr 2025 15:55:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 116AE2609D0;
	Wed, 30 Apr 2025 15:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="K2wiGfB1"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A54525DAFB;
	Wed, 30 Apr 2025 15:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746028534; cv=none; b=SntuzETGlUnzhR0gtWvHSal0Xx1lBD6uG0IJTQGjTnSuUHkcsJYdPQZiCLgEeX19Mrz+9q/F7LBxt5egLpAUSDsfdM72ZvWWSwzQe+EMcYod7PjgQWLPS3DlP6Wf1aJRL3ti84u0pGFnujmjh5RUXhnih9nBHNKgaLZpv0nVFDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746028534; c=relaxed/simple;
	bh=pAi1g0+GcrXhsxxUwg/COVu8QWbSDq0H9FeDRKmvTZo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OJbQgkD6jSq9Auoskjsuuwj7G0Tv7aWDOmOD7UqydCATVtyIX6s2gRgK8YC5zO0tnVfpI1laAt+vnwfBnWqE6fLuawu7E5eJgUPTSYVTGx3AIHM56HwEkyHcnEK+66nu9QWAkilfi9ZkLtmaVZV0UqSQVRPqgIaJDuHwF3x3Wus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=K2wiGfB1; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53UDnBtg027609;
	Wed, 30 Apr 2025 15:54:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=0rJOsX
	oPMQhpiqynyefL1qZwMh6TkDUagnvd4/qOyd8=; b=K2wiGfB15TYazXEnpvRv1V
	CpV8N8jNb1inCirUlCY5p1+Mpp/dKc9l6G+rth3k3o7nHl5+c3OWq6Npvs5h+nWW
	Lcm7zbgzHrVXdY7cUj0/fjTV+4A4ELvvRncr/+0hlIFwk2gjmH6ZoCB6G0CyPiN4
	t+9DR3Qccj5dFQ7j4N9y9zmHw41KNdMG97QxmQR2mwoi9YwYnLWa5FAT9QD4tTC2
	o/vT7uGXCG51UopyBrzbcy+ZWUZaOvOD1xUxDrAeHcxBG94GyS7dFD3TvnLmt6k6
	mApOaKQs/+bHcz4nY8N1iERMAdVAhklDXOEMNCGfpp9xY/TLyRj0g5TGw8etc08Q
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46b8r0un51-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 30 Apr 2025 15:54:55 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 53UFmj17027098;
	Wed, 30 Apr 2025 15:54:54 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46b8r0un4u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 30 Apr 2025 15:54:54 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 53UFdC7A031677;
	Wed, 30 Apr 2025 15:54:53 GMT
Received: from smtprelay07.wdc07v.mail.ibm.com ([172.16.1.74])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4699tu8pwy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 30 Apr 2025 15:54:53 +0000
Received: from smtpav02.dal12v.mail.ibm.com (smtpav02.dal12v.mail.ibm.com [10.241.53.101])
	by smtprelay07.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 53UFspgu14156496
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 30 Apr 2025 15:54:52 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C11CE5805A;
	Wed, 30 Apr 2025 15:54:51 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B44C25805C;
	Wed, 30 Apr 2025 15:54:49 +0000 (GMT)
Received: from [9.61.85.22] (unknown [9.61.85.22])
	by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 30 Apr 2025 15:54:49 +0000 (GMT)
Message-ID: <c8e88c29-e1bb-4845-a362-dc352d690508@linux.ibm.com>
Date: Wed, 30 Apr 2025 11:54:49 -0400
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/167] 6.1.136-rc1 review
To: Naresh Kamboju <naresh.kamboju@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
        hargar@microsoft.com, broonie@kernel.org,
        clang-built-linux <llvm@lists.linux.dev>,
        Nathan Chancellor <nathan@kernel.org>,
        Anders Roxell <anders.roxell@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Dan Carpenter <dan.carpenter@linaro.org>, linux-s390@vger.kernel.org,
        linux-mips@vger.kernel.org, io-uring@vger.kernel.org,
        virtualization@lists.linux.dev, Halil Pasic <pasic@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>
References: <20250429161051.743239894@linuxfoundation.org>
 <CA+G9fYuNjKcxFKS_MKPRuga32XbndkLGcY-PVuoSwzv6VWbY=w@mail.gmail.com>
Content-Language: en-US
From: Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <CA+G9fYuNjKcxFKS_MKPRuga32XbndkLGcY-PVuoSwzv6VWbY=w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNDMwMDExMSBTYWx0ZWRfX7Wf07gSrdqCk zb0K3R03TxsVsyR1iTUQrpsn8SgfAs0YFKySz/5l60nS4Ty5Ocio1IGZiRsSV+b6BaQ34Fw0vKl ioFN6STKCZicQtlKBajk+fMGVQHIWLwsOHmjMfdnISc6UX6/lQi32CbkOacKy/qWe59SsGqD1FW
 yGAw7jomIrcY7Y+QlX3QnxqhlFLuOCqh+3nvUuQYjBBEicyOXHCNHfg56gMlKo5TQ/HU7CKD1Vz W4soxBFSdg8ydvaCNHKx0zyGUk5RgEVNwU6w4KkJxsKXecKKMDQcqtH9SDveCufpn4QuNdXaLOW HAoIki6/XzHtkh/RZDURZLd+FVRmQ2ZYWFKlr3RObtf5HJq1oVyxlxnHoPOrM947oMgF6/F//iH
 LrRowoVxEOQ07s5PL23CPXOo0ntDDhtUxrPRU8Domof8K1cr/useUFXFiV+noDH/q8fUiJLd
X-Authority-Analysis: v=2.4 cv=OqdPyz/t c=1 sm=1 tr=0 ts=681247cf cx=c_pps a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17 a=IkcTkHD0fZMA:10 a=XR8D0OoHHMoA:10 a=eZE_XS7iPCa-stX4-vkA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: Sij4fx90_ksNlpmCP9y4w-QIVKqfbDsT
X-Proofpoint-ORIG-GUID: 2ilcYsyPiGbEAPeMVPlTbkq5Tf2pWo3G
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-04-30_04,2025-04-24_02,2025-02-21_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 malwarescore=0 priorityscore=1501 bulkscore=0 mlxscore=0
 lowpriorityscore=0 adultscore=0 clxscore=1011 spamscore=0 mlxlogscore=602
 phishscore=0 classifier=spam authscore=0 authtc=n/a authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2504070000
 definitions=main-2504300111


> 2)
> Regressions on s390 with defconfig builds with gcc-13, gcc-8 and
> clang-20 and clang-nightly toolchains on the stable-rc 6.1.136-rc1.
> 
> * s390, build
>   - clang-20-defconfig
>   - clang-nightly-defconfig
>   - gcc-13-allmodconfig
>   - gcc-13-defconfig
>   - gcc-8-defconfig-fe40093d
> 
> Regression Analysis:
>  - New regression? Yes
>  - Reproducibility? Yes
> 
...
> drivers/s390/virtio/virtio_ccw.c:88:9: error: unknown type name 'dma64_t'
>    88 |         dma64_t queue;
>       |         ^~~~~~~
> drivers/s390/virtio/virtio_ccw.c:95:9: error: unknown type name 'dma64_t'
>    95 |         dma64_t desc;
>       |         ^~~~~~~
> drivers/s390/virtio/virtio_ccw.c:99:9: error: unknown type name 'dma64_t'
>    99 |         dma64_t avail;
>       |         ^~~~~~~
> drivers/s390/virtio/virtio_ccw.c:100:9: error: unknown type name 'dma64_t'
>   100 |         dma64_t used;
>       |         ^~~~~~~
> drivers/s390/virtio/virtio_ccw.c:109:9: error: unknown type name 'dma64_t'
>   109 |         dma64_t summary_indicator;
>       |         ^~~~~~~
> drivers/s390/virtio/virtio_ccw.c:110:9: error: unknown type name 'dma64_t'
>   110 |         dma64_t indicator;
>       |         ^~~~~~~
> drivers/s390/virtio/virtio_ccw.c: In function 'virtio_ccw_drop_indicator':
> drivers/s390/virtio/virtio_ccw.c:370:25: error: implicit declaration
> of function 'virt_to_dma64'; did you mean 'virt_to_page'?
> [-Werror=implicit-function-declaration]
>   370 |                         virt_to_dma64(get_summary_indicator(airq_info));
>       |                         ^~~~~~~~~~~~~
>       |                         virt_to_page
> drivers/s390/virtio/virtio_ccw.c:374:28: error: implicit declaration
> of function 'virt_to_dma32'; did you mean 'virt_to_page'?
> [-Werror=implicit-function-declaration]
>   374 |                 ccw->cda = virt_to_dma32(thinint_area);
>       |                            ^~~~~~~~~~~~~
>       |                            virt_to_page
> drivers/s390/virtio/virtio_ccw.c: In function 'virtio_ccw_setup_vq':
> drivers/s390/virtio/virtio_ccw.c:552:45: error: implicit declaration
> of function 'u64_to_dma64' [-Werror=implicit-function-declaration]
>   552 |                 info->info_block->l.queue = u64_to_dma64(queue);
>       |                                             ^~~~~~~~~~~~
> drivers/s390/virtio/virtio_ccw.c: In function 'virtio_ccw_find_vqs':
> drivers/s390/virtio/virtio_ccw.c:654:9: error: unknown type name 'dma64_t'
>   654 |         dma64_t *indicatorp = NULL;
>       |         ^~~~~~~
> cc1: some warnings being treated as errors

The virtio_ccw errors are caused by '[PATCH 6.1 033/167] s390/virtio_ccw: fix virtual vs physical address confusion'

Picking the following 2 dependencies would resolve the build error:

1bcf7f48b7d4 s390/cio: use bitwise types to allow for type checking
8b19e145e82f s390/cio: introduce bitwise dma types and helper functions

