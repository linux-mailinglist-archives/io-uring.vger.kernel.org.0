Return-Path: <io-uring+bounces-9471-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CAD6B3BE7A
	for <lists+io-uring@lfdr.de>; Fri, 29 Aug 2025 16:48:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AC6EC173CBC
	for <lists+io-uring@lfdr.de>; Fri, 29 Aug 2025 14:48:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8206322A2D;
	Fri, 29 Aug 2025 14:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="sfY/bdwe";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="wnFxpf/L"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4774B320CBF;
	Fri, 29 Aug 2025 14:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756478768; cv=fail; b=AzmQLdV+6KuKf8Sgv4v35H1jPSWiDV9wBL2I6Sk/ERCVV+SG3P7alcUXRnz/JWCcHORhZMtt4qBNcA5T5h1xVC3y3bhKh/jW9rNyFZPwC9hopEICdlAacWpHuzVFjuLLTyfiu93N8cgBl0rcygZf8hvjn0hocIMbODjhJmpkzZ8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756478768; c=relaxed/simple;
	bh=Dwvu1S+UH8FB99BAWOrU3VflHrptNcHavg3ldBa7CRg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Un4hqPA+R7LG8mEkyAoTlyJiDIr8sQhS16nGRb1ACt9pMdoaUAbeoXI80UMFv9itQiwp+vD2u4alEiaz+4KafOX+xplm8/x+bXgIUABiGodcRQgRgdk2r3IJBJnO696A+hvf8Sesl4LipyeVOb5EYum22EclPuY2jyWfzuQ25TE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=sfY/bdwe; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=wnFxpf/L; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57TCuEtR020434;
	Fri, 29 Aug 2025 14:45:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=Wj9HDML+13E4bxM9yz
	rqxxojbP+sR9POgqKLDKuHOe4=; b=sfY/bdweQEAHvZ+Ci5LGGmDpGrbbd5MHZU
	eeOHC0FFFzJ9owuje2L/i7tT4EIJIQ9+9jVTgYqLrTAt+etA+t3uOgcQRX+1B+2f
	KaF6Vc1EpRGmgWTCIeAka+TZRyk9tg8Cel2QKfM4aOrlvpSBVgbzBD/qVdiaE+Xe
	cUGcR2t9V9hUlcwFcczbKFPAbozd/ckMPaH0lhYE/zUAgQ96GtlIvUqyyPsJ1rah
	qH2rp+gi/urAFtjIx6OE3O+OfvSrPysFT8oJJLso23x1Ot3aqAOkLlJr8tg4QP4a
	fxp0jmz/5Ng4omOq3Nm7bFLWGEN5ieP4/Pu3zmSuGbIXZs1+ZwLA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48r8twhb8k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 29 Aug 2025 14:45:19 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57TEAspw026710;
	Fri, 29 Aug 2025 14:45:18 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10on2054.outbound.protection.outlook.com [40.107.92.54])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48q43d3134-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 29 Aug 2025 14:45:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NhhCOJ+coHh9Yh32hsnTTpe6ao2g+Fyofsgkd4doCSGnBsWiAoejT+87DLt4BhUsQ1EXtB3f+t4Z7xp21jgqJg/VlpkeybYQBSrdn7cO8sBBOFiD9r0NlyRi37EOx11mJymM7cPM0LLzy5xCKbiiaJZWKnChALdsZd9oA0B+hXmWz5rBEvXFUf97Fs7xxmXTdVPuHrygIqQrPHbl3bwjD3xQeffwVKzhOYj4js2OyrK6CauKfWUOYHM6bwukB2eNrTKcuYL4HJpH+1+vdw5UR4wJqk0bTlpp3B8WojKYnGVc/ylmiqrlywWQtD1oZ7JOT+fenM9qJPmcrjA56NrciQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Wj9HDML+13E4bxM9yzrqxxojbP+sR9POgqKLDKuHOe4=;
 b=EnGMWB83tY1YKtoLok1PXD3HOShgqYSP0mds/ppAqnb+cT2XqOf+vXK+5m073YGlpe9QnJvdZ/JTifoIKiBi2zljJjG0MQZk9JCDd6FP5ekI6kF0U+T0nrsQ9QgboRmtsRhcAhytE45yJNVBGSopIZCAMzdno1BfYe4wxXJyqeL7x6oBeOnYxgtcMBlJpYzmbkisgyVUnB4xtzj0XRhnA7tNxMGrcTiWIwGklVkCO5Gz6N4T8I4bfcq4onbJzSkVIGDsK5LJ+HFE3tkC/6rMkYvpOSdKCpE36hg6Juri+8AOVBtvsvt2SmUh96xY+LhX+52cWCsBtoJTZ5+6pAvn6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wj9HDML+13E4bxM9yzrqxxojbP+sR9POgqKLDKuHOe4=;
 b=wnFxpf/Lkf53/R/Xi96c7wfiWoiJbsY2WhUtWAMRZpO4fUIMLCXu9w9gZQ1kpXIhjnIbSRFrleYvTRC1zdkqPAXFSVfUsal8bpv/EohkkHa9+XsHj4m51w8kvZ6lEzWYN9pYHpMf1rgcv+EK08RSS5JXYH/5zireljnTP9+U+6o=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DS0PR10MB7296.namprd10.prod.outlook.com (2603:10b6:8:f8::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.16; Fri, 29 Aug
 2025 14:45:10 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9052.019; Fri, 29 Aug 2025
 14:45:09 +0000
Date: Fri, 29 Aug 2025 15:45:08 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Alexander Potapenko <glider@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Brendan Jackman <jackmanb@google.com>,
        Christoph Lameter <cl@gentwo.org>, Dennis Zhou <dennis@kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, iommu@lists.linux.dev,
        io-uring@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>,
        Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>,
        John Hubbard <jhubbard@nvidia.com>, kasan-dev@googlegroups.com,
        kvm@vger.kernel.org, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-arm-kernel@axis.com, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-mm@kvack.org,
        linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-scsi@vger.kernel.org, Marco Elver <elver@google.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
        Muchun Song <muchun.song@linux.dev>, netdev@vger.kernel.org,
        Oscar Salvador <osalvador@suse.de>, Peter Xu <peterx@redhat.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
        virtualization@lists.linux.dev, Vlastimil Babka <vbabka@suse.cz>,
        wireguard@lists.zx2c4.com, x86@kernel.org, Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH v1 20/36] mips: mm: convert __flush_dcache_pages() to
 __flush_dcache_folio_pages()
Message-ID: <c3e822d9-2aeb-428b-af39-49c89ed42890@lucifer.local>
References: <20250827220141.262669-1-david@redhat.com>
 <20250827220141.262669-21-david@redhat.com>
 <ea74f0e3-bacf-449a-b7ad-213c74599df1@lucifer.local>
 <2be7db96-2fa2-4348-837e-648124bd604f@redhat.com>
 <549a60a6-25e2-48d5-b442-49404a857014@lucifer.local>
 <e877229a-ffd8-4459-a31b-ecabde28e07f@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e877229a-ffd8-4459-a31b-ecabde28e07f@redhat.com>
X-ClientProxiedBy: LO4P123CA0589.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:295::17) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DS0PR10MB7296:EE_
X-MS-Office365-Filtering-Correlation-Id: c22a6981-488a-44a2-622d-08dde70aa74a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?F6UoXxA14lHiHxoPL1Q0wkEk7OsQu3hs2AuhTw6sbN+GcZ3WDzWYM6Q0wmhC?=
 =?us-ascii?Q?cOBiudkxQGC6TdjU0AqHUR4OFqf6rOmPKj6EQNdcM9JyTIGnBtwSLlVQPyAk?=
 =?us-ascii?Q?+58QqsvGWQZ2jHHAfPCPq7jnQKWa/0Gs01yZG+h8ycIt4CKxlGoxzd03eimL?=
 =?us-ascii?Q?bmeI1+i2mH4ywF57yTAHJu+VEEIyLAh9ld2OMyE+yUxNP7Fsx4AmwsUYBQTD?=
 =?us-ascii?Q?4hTE65faWeKb8t3p/EYbPNfoHpFXtrR5doBblG49q29E8MMXcqfYK1OYhKin?=
 =?us-ascii?Q?wDiMwpBUbDHaDtFylu7ziuDCuFqyr/PEV3NZvI20FUtWiqpXz0lp3g57tDQQ?=
 =?us-ascii?Q?Kg8dyw9F28aIZfMimQEBJzsHwuCqyeWmY3aUf5QTZu/58ivYpjMOBPs8tpTn?=
 =?us-ascii?Q?/vRG0MSSrQ7Y6mSQSDqWeaXmxnkVMWd0I1fCzO+wWlupM2pHUZMgO/kpJSmO?=
 =?us-ascii?Q?ra955M9Z9pKyiVkp0KZ1yG/LbhT+os1Clk1Bvz3MtIv7NFfs6BYGzQQGKNo6?=
 =?us-ascii?Q?gW9Hnh0T82R0t33gmde9Ibf1YAy4FRK+lskKieWZ/FbROdTGYss844+z7CsI?=
 =?us-ascii?Q?JL3Qx/qelZ64swLUDq93ULRoCQFjS+Uj3QkEVBJwJ0abvkPP8AiYC+5DUXJM?=
 =?us-ascii?Q?Sttm3UKAArm21/J2bKrPySdOnK72RkjmtgroEKVl9NYNra5vfD6+uGVBLwvh?=
 =?us-ascii?Q?Goun/HBUMtzquiwShHUe4TYki3kgbIzvVFzGAd34AM6cMCygDO2H1RqRjDN7?=
 =?us-ascii?Q?LZBlimQed3nfJ8sSl6WsMBLnubD2s8XNA5kCtGem2gRyS/BYJJF4UT3u90bE?=
 =?us-ascii?Q?qvTYnZTHsOoHERts1RWq1dN95a+4tzqKTD3uBbVPq4ZjeW3a7D6Jh+6h3igd?=
 =?us-ascii?Q?TfQbAwX8CjnfExNO+wrgVPoUww6w9psp8/a6QlIJZkRN5ItuHwy7jYGnddXS?=
 =?us-ascii?Q?M3KPS+9NHVDcS/Dkc+XzBtfmyim9A9NNQ/MmtjBb+wZHFFAWB3emflbKTMiX?=
 =?us-ascii?Q?M+uCQ6LqtCKd5mmfexyQOTsaL28G4eoZwQ54WqWYQ5/JPJ51QcuyYSHloP95?=
 =?us-ascii?Q?ursc6IxEOsL0GwXksOXzZzC7IED80jSQix0OjMdxp/GVRTbyq94LsxoF62ac?=
 =?us-ascii?Q?rdCSX4EdDgfLJsbw+QZeTHyr0I3lFRmNOk8ZkVub6jpmJ80rU3WdOVSBIC7z?=
 =?us-ascii?Q?A3qiCgrQ0AOlqF+imO3x/o4WO0r6H6WLZ9dNlEAuXTpxyMfMLPzdP1i8DzDm?=
 =?us-ascii?Q?FP9Rq0iwfJg3Kq01BNEJb7xJvNVxB4jfJbf24XNBsJ1DKPrqMs6V5+w4U3pC?=
 =?us-ascii?Q?+FiUT0BRVMYrdpA5yscCgkHQI26H2qV9je7bJr1NUUZh1xgI5N3HPQIFqr+z?=
 =?us-ascii?Q?ygp2sEJ1y3+wja+qRqAQNK9rcoD2s4ILdwKfoojdLh5wh63d1EIktYaFbFWa?=
 =?us-ascii?Q?P7A8F9wvRtc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ActtIyQQw0PUnAVUJ0Y7OqI2YqB1+SXV0zXACZRWIBi+sHPms5jPKDzh353a?=
 =?us-ascii?Q?yHImyTBF3vp5cgSU/0FwohVIXdAEkkGJHi4rBRMRjB7/xtwLqGzJXmuY8kzt?=
 =?us-ascii?Q?wUWUurDbtzKMchO8ij7VEbS/jTlz3pypjzzg3syGI3M4nxuD/pJj1ljwZHnA?=
 =?us-ascii?Q?VGJmNHnmkfMdq8yefkpLmXfKhOYgWfQWRmyNk3796QrABO7JLlyuTGWMXiDJ?=
 =?us-ascii?Q?kYTkVcDVOvICmXl4/ncdigNLS3KModH8TMC5g8rOUYuXViiyNa/EoEDXf7IW?=
 =?us-ascii?Q?uG4krL+DvN1DMTguTnuJq8XXR0C6IKY4kI1ZHesITEo82a00W2HinnL+OGuH?=
 =?us-ascii?Q?XXVqgw4cGkf5iA+BIvh/3tUN5r9zlsi5rsa93xGfdG85+3lJkKxFbBLlQKyT?=
 =?us-ascii?Q?H3T/8r1ciV9G4Mk4R8l3/npTNqTrzniKafRbK2odHDdSsaiZC30s4RcBC3XV?=
 =?us-ascii?Q?Heqzy0Rs9iEZOAZ/WGk9SGpNt6kas5IEhx3Dyo0ah3qU2+lNiVb/E5qk0lal?=
 =?us-ascii?Q?jSbl+/RUgSCQyn2wE3EqKkqNt4jd2SFTPULPZ8QR5i+N0EB+HjpvXpMBdj9N?=
 =?us-ascii?Q?cImAJDxa5LV9z2SGUIISnseswRN9gHQbQ8REjLPR+Nw4mo9H/rp3MalHOQ4O?=
 =?us-ascii?Q?nvwtd97tCOg3vIRXywM6udhggBuB3SU71Bkq2Fc7drrIe8LzlwaIH2i+cOrS?=
 =?us-ascii?Q?0d5/5pQcE3FVs9R83AQ3oa273ZLRA5a+FFnEy+zRzZBOhu8tWsTZzWolxC05?=
 =?us-ascii?Q?tfwwmr9G21sdNZGJ4GOLU8IasDTOFJ2j3JDjLTryyNYIirFgZnyKQAsh7DXi?=
 =?us-ascii?Q?IksDe2H1rE3Wq1sBWOLfC+c4r7rgbHArzkRtjQGzpuhbZt8dsNQqRU+MMm6N?=
 =?us-ascii?Q?jS4HPx7UC8G41S0bbDnOM2KFItcg3O6YFGG3fGhYfvQf9zqotl1dVbrhvnXq?=
 =?us-ascii?Q?DKac+sBM3ZO2hKPBnam2nhCVvYP0truJkOKYJY+L23ObPrqzxQbaDqklmtPl?=
 =?us-ascii?Q?93k/qFk0Z75Q4kQ0pV/eeLlYjFfKsNdZvUal3iCebLg3pjHhR026xTUHQltv?=
 =?us-ascii?Q?cT+ph5DjripqR2MS+slRSF33xxsHLC6bvuAE5M/OM8ERDuVsiVvWNNm01PPj?=
 =?us-ascii?Q?CD6HQZJ1g2RLcLPo7t1VD2k0WralU9sLfOB43G21L+9QOg1r22gZsb97uTxL?=
 =?us-ascii?Q?KgM01SO4ks2J/UIyNVjA8TBi5mTWtCyBZkoe5TI+DdH1YE8CIYJwUEI7hXZF?=
 =?us-ascii?Q?QQm87sacJ8NqTFmtngAP8rT38yOzQBxNyal32GIdKXMqjoIq9Lk96mkhreBu?=
 =?us-ascii?Q?FHS+UVAxrLAlqjsQnvgW4ukHmFUauPAj5E5OpbnGIFGmg+R1Gib2Ie2FhDUF?=
 =?us-ascii?Q?ylinNq40H5lBToJbr+B9jmUDtvmkg4L1sOta2Y8l57xCoWTLzWISyHDTJY7X?=
 =?us-ascii?Q?agxQMq+g2xgmKmmyRVZjcYyDaYpVHR4REEsVpk8mWsYLT+kRu6u9w+L2dtWX?=
 =?us-ascii?Q?kDUXGjj5X18p3Nroqc5CotCJBBcBEThFhlcbcRdgrCwLtRvhJW9A6QBDYGyk?=
 =?us-ascii?Q?ut1GsRwzhu++a4xwbGmH9btdcVtLb3khQZm7cBCQKZP/P5MbAWlqDOAVNHys?=
 =?us-ascii?Q?dg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Pv8uCinyQBF92j2zduDNai43RN5BzUAoytgSM2j10ico5KHV8bE0J5TQOFF/lFJf9SjYpRfiMGA0+hOb3yLCYbUXcUKWWxMjPKS+N32ifTq5wvxHRJRRDktVpwt4ioUjedcWRpwr3mZzJC58S8Gw5rpFKxtV5XNdIbz1DNj0C5Z3BpUPwu1jFk+ef1Z2GaCA4Vjeum8KmGS9higgvfFkge8blbL8cds+MCnbfgS/3fuHReiCnQ5uclhDyUl5VQKlZ1lGl26FSY6/ipoigXmwySWbrBIOQII3nuRGnOXicng00AzmOuMmrrp+mB/Ra1vwXiJteUQStycmdYRmQXpx77iqGVn+/DaJPsIt6oFEDjdJ9BuLTn4qIJ4MldRK9+cWfmxTvXFheeWiD46IBPw0kfq5x60p8kT0A/vSkIp9leDTh+MbGVAwIePiSGZv9nP0BhkZ0cNinFqF5I+tVK7i25AQavmClTcLVmHT8J8KCSlHvCjHopEbe05fLlh4GyAqGsMpsVwc0f3ZRKXsexXzBjw7xIXseHrf1RupDnyaT070FdfsB98MwIj9Z7bGp29FcjeqcY6fwxV6OcrVf0jfuAQ9IMQqapAwrTu5lyC6Wi8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c22a6981-488a-44a2-622d-08dde70aa74a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2025 14:45:09.9471
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UYzM9cC9u6QXEMCF29cRRdX4oBW3xU8MsTZh0oUiExHBXhLuIXXR+I9e5lusxqmJEiTCIC5rwyGKUV6o7sV+auKZHCh0eMEzsIWNFMkD5Rs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7296
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-29_05,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 malwarescore=0
 adultscore=0 phishscore=0 suspectscore=0 mlxlogscore=837 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2508290124
X-Proofpoint-ORIG-GUID: iL7ekxRxS-mIH12WbU1aPgdEFwFIlfgP
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODI0MDE4NCBTYWx0ZWRfX1R+4bkIGjmQ0
 4DgljLtXaqZcqgIVc18sDHZ4Ze0tMAmU9FPnQZ1uiCkJOpV/93P4wvj/ErxbDF6fNl/WNmkEDJ+
 H1zzjSdzuCB/Tdm0NEx8lwLB6YyF316RtjmovHogoMJIvl0ztGfKJo5WWr6IPbdH/pHCh85SNaV
 0UwRBicBr5MYx4q8gOdIpjuUYCCcIDxU/MOXoRePkDRM2QkNDI5H4qWqT+kemWmMTBPoUSIZcjb
 z0dXLxcNL6eglUVUojE09nxReUkNKSNWM5ySQRvP6lIaeA6+zrAN3uLU8/JRauuGMHhjdbNeWbW
 Bdcbx9Ju2xvhOPG79g5tkPlqQK3eZOxIIHUpdCr3esMZ6z35GjmXQbwZlOPVY9EJNmvqwQB7Jrl
 Ha5/S3pO
X-Proofpoint-GUID: iL7ekxRxS-mIH12WbU1aPgdEFwFIlfgP
X-Authority-Analysis: v=2.4 cv=IciHWXqa c=1 sm=1 tr=0 ts=68b1bcff cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=20KFwNOVAAAA:8 a=LZ6zlcjlEepz2M0PLPMA:9
 a=CjuIK1q_8ugA:10

On Fri, Aug 29, 2025 at 03:44:20PM +0200, David Hildenbrand wrote:
> On 29.08.25 14:51, Lorenzo Stoakes wrote:
> > On Thu, Aug 28, 2025 at 10:51:46PM +0200, David Hildenbrand wrote:
> > > On 28.08.25 18:57, Lorenzo Stoakes wrote:
> > > > On Thu, Aug 28, 2025 at 12:01:24AM +0200, David Hildenbrand wrote:
> > > > > Let's make it clearer that we are operating within a single folio by
> > > > > providing both the folio and the page.
> > > > >
> > > > > This implies that for flush_dcache_folio() we'll now avoid one more
> > > > > page->folio lookup, and that we can safely drop the "nth_page" usage.
> > > > >
> > > > > Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
> > > > > Signed-off-by: David Hildenbrand <david@redhat.com>
> > > > > ---
> > > > >    arch/mips/include/asm/cacheflush.h | 11 +++++++----
> > > > >    arch/mips/mm/cache.c               |  8 ++++----
> > > > >    2 files changed, 11 insertions(+), 8 deletions(-)
> > > > >
> > > > > diff --git a/arch/mips/include/asm/cacheflush.h b/arch/mips/include/asm/cacheflush.h
> > > > > index 5d283ef89d90d..8d79bfc687d21 100644
> > > > > --- a/arch/mips/include/asm/cacheflush.h
> > > > > +++ b/arch/mips/include/asm/cacheflush.h
> > > > > @@ -50,13 +50,14 @@ extern void (*flush_cache_mm)(struct mm_struct *mm);
> > > > >    extern void (*flush_cache_range)(struct vm_area_struct *vma,
> > > > >    	unsigned long start, unsigned long end);
> > > > >    extern void (*flush_cache_page)(struct vm_area_struct *vma, unsigned long page, unsigned long pfn);
> > > > > -extern void __flush_dcache_pages(struct page *page, unsigned int nr);
> > > > > +extern void __flush_dcache_folio_pages(struct folio *folio, struct page *page, unsigned int nr);
> > > >
> > > > NIT: Be good to drop the extern.
> > >
> > > I think I'll leave the one in, though, someone should clean up all of them
> > > in one go.
> >
> > This is how we always clean these up though, buuut to be fair that's in mm.
> >
>
> Well, okay, I'll make all the other functions jealous and blame it on you!
> :P

;)

>
> --
> Cheers
>
> David / dhildenb
>

