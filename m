Return-Path: <io-uring+bounces-9403-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E2A30B3A3BF
	for <lists+io-uring@lfdr.de>; Thu, 28 Aug 2025 17:11:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BD0207A91F8
	for <lists+io-uring@lfdr.de>; Thu, 28 Aug 2025 15:10:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42B0C256C6C;
	Thu, 28 Aug 2025 15:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="F4EzrEn8";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="zhLl8rfg"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D23C2594B4;
	Thu, 28 Aug 2025 15:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756393890; cv=fail; b=I2Ze48ZtpOWXA+rFNogWU8EHjiNky9V6HkYPv2wYVPoTCoFCr4UbQXTllS+54Hdr5wWx0xnhV2lylvhthmAdDjckr/NbbkG6J3c9+1VoB784AANd1EZjw7G7gCKH0GFF7pnTZBdxjPgCUErKrDFrMe91ritLqqRAwD/1r2UaHEw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756393890; c=relaxed/simple;
	bh=f1B+G22k25naP+TFhUtrZONG6dy3xoNV4ZwNudY7sx8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=KBobEXDECbG2gCZ/QFKkU0btwpt859dFtc7kjcwgTV79eOHFt7McMV31+swa1iu6PTi/oeUzX7pQ/P11myEi4ExohK4UGZ8/1r3APGiiGRAi9gt+zeSn3Geh6Bkz6a48EYlrYhjX92c8KIwsmKbFeAUysQ4bOqT88+wRrZuOkdY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=F4EzrEn8; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=zhLl8rfg; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57SEN3Lt014322;
	Thu, 28 Aug 2025 15:10:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=lCzIiDAHpA/+ZJFaYQ
	hicCpWw1MlwuIDwATtg9A7QlI=; b=F4EzrEn8VAGWdB94oqmcruonAPQvHHfs5p
	t2WExDARvK2h9I5E69okUS45avyOOfQO7QHJl2QFeDWGd4QuTfeB4SITwNGwGrT1
	0VSlH8voArco4YRby8uFU4at3Zpp57KIJJ6Jok3H/zNgjL5dpkhg1owOKHj7aKNt
	oaFvK7sP1Y+ns8eX8TE0Q1fauTMU/rodRGBa1zdvitEoX5jXv1xPAdJZACx6CxaB
	ruB4UNdUUMaAKotCb9ivqanWRFbvZBWYa9BZTucu2nOF1Ly3IQaoMfeCg6Kswel0
	0Mi3kp+t/4a9zW5d2+Ha1kLUObxdRuWr3Emf4ndLvFnR0kJ/IGhg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q6790r7u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Aug 2025 15:10:42 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57SEi6Ue018982;
	Thu, 28 Aug 2025 15:10:41 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012022.outbound.protection.outlook.com [40.107.209.22])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48q43c3trv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Aug 2025 15:10:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cmbSg8auLOyNbd9rZazCjeTFY6Bh1ryGMKtC0b/ipWHaKOU874YqL91XSRJWZO3ogTlDiwmFwHDJZ0QYR1gMVH80ujPErDVaJ7zTssKiQWRiAecELCXQ9i3b8cLfn15Ib4wcZFuMo4x5EB0oKLTOZMIclZ/OXp+x95ZdkrYUchiPoc0XDibZ5Tvbb8a2R4rkNbLhGBGA/KMft+TAL3gsKXXvHon+YzURSfPu1buKK7Nq3WoRWh4QsCw09kn+jYgyYTCCvUX97h9tTTHmwdQVvSnul8mQzZGVNBCvbWbpx8fikuWX2ABmCMsmssugdmRazpmLdlXn71RQpKbp757b5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lCzIiDAHpA/+ZJFaYQhicCpWw1MlwuIDwATtg9A7QlI=;
 b=dIY7tS8Rxy/0nnpIeFrR5aZn6ReF3jcRLV+XXYFq5Di1TS9uthZxSi/zzOOYD/li+C+NJLOz35aaywL8k7IxzCrlGTzdo7LM8OMQPwCLdnHP6w9CHDLQIggz6ZOSauYyor05/8Dbbeq37452XHuDjBq9WNizT/clVAKbV3SQQImsHsoAw4XYxkq4bPKcwVfKlIDfn33V6xkDrPD9pZDEgWZLV211lEqD60M70YJ45ySXJ8XyDLBKf+eMPUQxdT0wzVjl1qArc0Ulfy4Fe3jczP9nisUfwlCAoWJiiVP0EtHLEJDh6LZcFIPYfIzctRa1bpnxcQwnRVA82M0p8eiIWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lCzIiDAHpA/+ZJFaYQhicCpWw1MlwuIDwATtg9A7QlI=;
 b=zhLl8rfgeRDm38RGVEdmDYt/lBqdL6ux2lIUzAQhSImTwmn0qq1b2Y3qteGQEMjvOuYO0wN1wf7hSJvnZX0XjWlPxBr8+I3rMBtozLRoWNJjXeZQjp9xtYkdF5mBbUm+BYqA36PV0XoUWBsDVLGqBPu4shwHrcT/ZBXsmIAVMTk=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CY5PR10MB5937.namprd10.prod.outlook.com (2603:10b6:930:2e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.21; Thu, 28 Aug
 2025 15:10:33 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9052.019; Thu, 28 Aug 2025
 15:10:33 +0000
Date: Thu, 28 Aug 2025 16:10:23 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, Zi Yan <ziy@nvidia.com>,
        "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
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
        Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
        netdev@vger.kernel.org, Oscar Salvador <osalvador@suse.de>,
        Peter Xu <peterx@redhat.com>, Robin Murphy <robin.murphy@arm.com>,
        Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
        virtualization@lists.linux.dev, Vlastimil Babka <vbabka@suse.cz>,
        wireguard@lists.zx2c4.com, x86@kernel.org
Subject: Re: [PATCH v1 11/36] mm: limit folio/compound page sizes in
 problematic kernel configs
Message-ID: <baa1b6cf-2fde-4149-8cdf-4b54e2d7c60d@lucifer.local>
References: <20250827220141.262669-1-david@redhat.com>
 <20250827220141.262669-12-david@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250827220141.262669-12-david@redhat.com>
X-ClientProxiedBy: LO4P265CA0012.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2ad::7) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CY5PR10MB5937:EE_
X-MS-Office365-Filtering-Correlation-Id: 625b1358-066d-4efe-fcee-08dde64508e2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?LL4w0YcNYy78wu8pTOJ2K+15VnzCjrbawgbkl6p/MXPfE9cQJ3lLUalcGjSH?=
 =?us-ascii?Q?Cl8X9ANVvl5TM0y9zK6llR5DAzD3lysbEXUg8SMS/WlhrTfd15OO3XZLb3yj?=
 =?us-ascii?Q?zTiyZNjnRTpJ33iJyhOpq+rDV+oTZnM7Mz/pPCXs1lrlGVyDLvNQhv7RI/cx?=
 =?us-ascii?Q?SHgD3QPKns7ODye1/9kKeooohCCFCSeWVVwko0hvSspV8js3wfmWeUzj1wM8?=
 =?us-ascii?Q?EFGxetwlyP7mYEOGokfn4L2vzSTryHzULaDgtD6ZhNutw7oj96/e92Bf3/Ff?=
 =?us-ascii?Q?+A9gZKCpKtZ0aYSLhMROugW3xcLuEd304uNnEqIdt41FpeUx+rg14rjVNsNm?=
 =?us-ascii?Q?EOZaNCgPta+Ij2Mgd1bU6tD59/+ymsK7gi7ISFhJpYeTbh5VGPoM1tLikbad?=
 =?us-ascii?Q?D1o3IUAOKctlVcyFve0Us3OxBcFDkN9XW+Qp+6qZ1XfNU4az/u12+BsDW1GE?=
 =?us-ascii?Q?wJWszfLQ/jg0MZQKw1n4pEBlGmPbSZMLlv4olD1SGY1oDbRHX5EZYdMTRWXA?=
 =?us-ascii?Q?myz8wSY6cT9rxJWACxkPbylL2pqbSH5ijA/mqTGpdg2dF6A0Jgl9NMnMYoBa?=
 =?us-ascii?Q?5X0a8IsRpGzw3354ZeBGu/A1iqNVYOVsM36wM74dQv+YiGzMhn4rPeCPGtUP?=
 =?us-ascii?Q?Z6c9PahDOZzkr+rcaK73xxyBdqjjMxOys3Ki6baSflACqghnuNO37/gct6hR?=
 =?us-ascii?Q?3xHomb6PQvO9g+VrtzWb5lj+V/+F4yyFCuol6i0AGnJUGHrJRVRw95xG2d4D?=
 =?us-ascii?Q?yd9v14rLmJ4ar+usnH9Ab7trorYbxlWy8tcPYBF9arZzmbVmGOQdNMu1MoKv?=
 =?us-ascii?Q?nsDYvY2Mq9iu3BFG9pxltezFP36feDomAk+REzjOKJqcaxpdfhco06D7DZfM?=
 =?us-ascii?Q?B6hVb+QYXxktCR0y+u6h1ZTqJ7Z17lCttIJDLckfyF42vYlAPsbAm+bRj0pK?=
 =?us-ascii?Q?we0aNBvrCMN0YXXNZmVwe0frBs/cf7uHFVE6nkQPNsQYoQ2Q2DHLaDYPuUZt?=
 =?us-ascii?Q?jZfZw/d7a2HQ1fKyb645OCgvkOxGtQCwRRnCxgg+k6R/BnHWWhgFy9ylGQqE?=
 =?us-ascii?Q?TvgEVDxyUkOSNUyAFaN+YjnPzglfkJkhLIU9lGi5icsn0hYDZwQWAUp0hhno?=
 =?us-ascii?Q?LyE+px5XiWP4DmfRw8+Koj06nWu8osQhuBe10PYq8L3SNA7zNwiMart0y/eP?=
 =?us-ascii?Q?Jc32pz3C0P35vWjE5pgDGGjxQqr5Y+1Z2FuIYW8KmvlRnzV6i1zIFWObG5bq?=
 =?us-ascii?Q?s4Vz51KTWMCM6ozOX7GBKadfVyCJHiGNvA2j3txs8jP+pu3sLoQ72RGClAlw?=
 =?us-ascii?Q?W8D3wWAKnNzUDobydmi4ks3vqnNxzGvRghCBfQvnJBzYBhdm0Y1Buq5MFyAQ?=
 =?us-ascii?Q?Nux6RGtbr8XnF7ffqWWfJpznfZeCU5hoHvBAn1+VXfhGylen7036dbob+I6j?=
 =?us-ascii?Q?zRvVxX9388s=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?5rQ8ulp1JlL6fAX+q0totw4qiuLmePDDdzddkb0r/NS2ifNnw4a5Sl4Nzf86?=
 =?us-ascii?Q?OAFoxjTN4LUy3epNoUluM84BWfA3A7Z/n2mE074vw1Gk3ypPbrTejMluG5+d?=
 =?us-ascii?Q?nGQKJhvab96p+v/sVK60X6noHj2Iw00Si5YRSFf6k9ib+ajingAYqzFmIdW7?=
 =?us-ascii?Q?TQqqeILGlV60auXhv821xI1J2hqA6/sCZnKIWWP/KpQfWxNzf37JHF62lwKD?=
 =?us-ascii?Q?SGDxxkxb82GkBRLlef9R6Dx8MsjwY6F7GolN0g1axrYMjnch9vlpy//A0lAX?=
 =?us-ascii?Q?FzT/2klZ9An/H64RMH7j+CkJvTcdTU9ah6PQNj4ZUGD5A+UQGrs1yO+uzDs7?=
 =?us-ascii?Q?lzpVzMv0V7hIBZarlw57YH4W6ZSdM98YykCrJddC07wqHPAlN+JECXvKzNRe?=
 =?us-ascii?Q?+nz7+d6H15OMF6vVGhTobafHBY9b8SkyM5ZONn1K0A8+UzaN4ZLeBDHFwZra?=
 =?us-ascii?Q?psiwigdGIKQG5CXsmC6RQzaawMZ4exjzwRv41NGX+Zzb/dUDIzrFuMInQDqc?=
 =?us-ascii?Q?3QokI0c//4VjawHnkcYt4EemDEKwBHYqvEZx0rQVhsgwmUnuo0kVLPeGlO4X?=
 =?us-ascii?Q?NKrF+4Y4Q/6utF+C6hLKYBh5c8//v6GhL/FbEON3WvR4KT6/FkAV0r4izczV?=
 =?us-ascii?Q?TfG1G1c59RN0540JATXAI4hTlLzjCAQOnowtmWtBH72CmBohSSeZ4O1xJIqH?=
 =?us-ascii?Q?amwWprMCb1dpep2cDb2MblGFMgrjkVFZ5Feh4Cs5ayG7Q5J5tc/mRqT0ti5z?=
 =?us-ascii?Q?B6/s3s4S+1E3K4AlI4LqHh7DZLVubBwwh1ReE3nldjKGCtkFxdDTrXKVo0ys?=
 =?us-ascii?Q?0eZJeQ9fwIgLOEp/vF77tfIKmmM6oN6e3SH7nlYdRIZkpCJ9OXqkOfJ5r1GE?=
 =?us-ascii?Q?3r/jbwDhg/7krxDU0VBqrXxCS12zZlVt9AjlhDba5hzt1n8uAse6g36X5DvP?=
 =?us-ascii?Q?xI+cjZCYh3L6jq9kjhhRCgko3QsdzS+x5jx/yA7JhE2bgm2GFRvFh8lJ4Lwx?=
 =?us-ascii?Q?E9L1qbzaw58FzcNp6IaYB/zvUJM79foEfcM7SV7p9k0/i+KoKhpLZJN92CYD?=
 =?us-ascii?Q?xMIiOvweCmotQRtdKF+KZ7Uphhdwy0f/6dx1dYJKn5GsE4F2dVlCb8HRJsJP?=
 =?us-ascii?Q?RYO7QiSbYkF6zUAQkiEAAMdG7v4qdEnFpaCgTOHAieIXqNj0oX9u5BTu4FPn?=
 =?us-ascii?Q?XPXgZN3UeEApeKq/G83jt9e4Ie/C/5gX8ljiYdDajlYrkRFX8tbrZGDGWWIL?=
 =?us-ascii?Q?NLIrcVnHNA38dCTKasiv83XnBNskM5/PnAFwAC8fRJlvrIV57mruld9nBqHk?=
 =?us-ascii?Q?IDNvY+X3znZFLEC1v+11xdqZm/6IJJPmtb5xvVe3f2dpd53HVgFVUHb8VaUx?=
 =?us-ascii?Q?VyRejnt2/l/UgsNOMvUPXcoeyeT0QtG2pBXGfdMbzRYRuyuAL2TXAY9hIVBN?=
 =?us-ascii?Q?eONqgygUTxIOpRbC7kz7/YKuTjVOxMUvrhhSMDGIE5z86Zh8jAPsVNo8T76Y?=
 =?us-ascii?Q?A5OREJYugNFbIA03dXu5Msw+Yt2vxW4ddvKxxBP5MEP2Q65Csl1OVOZGWHsl?=
 =?us-ascii?Q?P4V+34ZXA+hR0yBArZvUN7lJ9x1pSO1bAvLiWYris+/4ziRjJDktkh9iIzjN?=
 =?us-ascii?Q?tA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	GJ7aPgr9DgsGsVZr3axL7ScpidPBLBIW9t1Q6MylPHud86c3L0o3WZPsrh6VjgBOcwbdYqVNH25FhLT3+FbEkP7Yo0m+ogGTENyCcVXjGMTukB2U7VKB4Z4UF4yoY4rhsFqGe3uLi64rjq/TnKpGxwpg5xNzhJIAc6pVVGmQcCVEj7B65ev7WGWYqwoqSayAzhVx2Xt0krrs1ivVsh6iJOn9+ZXlNZsHH4XBqKRGYPaxv7GjweyJDpYxSBSW4B2lYNJo9HTe4kYiwx0Y0MwLDz3oiKXcorqa4/3dakCSI2n96BcTaghHZAzzDZCTsq71SF3dr9SgiYrDjESFHurhJwPnXWIa7BSQzAZTAauWjgYn+woerGvBrQ+ePNpNGwCZxtU//XhjxNL0+zBiiP97CQzoDl1dApwkdVFA0G7o8WgT//KFk2q8qryib1B2rJY2afW6z6sdiVazYrY0ukv7Jgi5If5i2EQZLFLIlcV42h2NpTAWpnHE2GSanoSzHAvwziA5Of/BDfKUqSc4cFlnmSoYuF+UAXLgbLvFsviBa+zWuH+0jAY4qhwfFFnP8OZ5rzPMIvxozLTxmZAMWkfaeRlpCl/kb/MP++KaDE6Y07o=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 625b1358-066d-4efe-fcee-08dde64508e2
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2025 15:10:33.3422
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LuKm+UOjFPd0iX5C+/q+T9tFICRlnVQkSRmWd1wbaogU65mp4UvjRULqjia856eKDqSAjTb/LB1aWtvlszRuBS/+PZ8fxzK6ky9+q53tqZc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB5937
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-28_04,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 phishscore=0 bulkscore=0 malwarescore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2508280127
X-Proofpoint-GUID: GrD3p7Qqrn79ZD1t-9EjXIJelplfFebC
X-Proofpoint-ORIG-GUID: GrD3p7Qqrn79ZD1t-9EjXIJelplfFebC
X-Authority-Analysis: v=2.4 cv=NrLRc9dJ c=1 sm=1 tr=0 ts=68b07172 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=Ikd4Dj_1AAAA:8 a=VwQbUJbxAAAA:8
 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8 a=CfW5y3FrfFYA5JlKxcQA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAzNSBTYWx0ZWRfX+BLzAz3B2gaW
 amFxo9BD/Ja4ovXKS2CCmUm7C3KEKY/aOqmsuIhCzbva8cPSHMHgpXeqh3ROxcAbKb09+4HZcnP
 /K6kClShMGudEXUgYH9YXK1AL7ody7Wr38jgP/07f/bYkqAj8fq26L6Le6y8x18KkMN/gZMYphn
 Va1WS1GDPWz1r/kGRmepsGaA/HH/TbAnm0GUIlwgTcoYn6vM6n3hwuJz1XnzDnBeNgMPBxR0JIP
 8LBiEOef+VN/hkOJ82gkDp57wmgryTVbGFqOKH2eI1P6otRY7mqMj/HHas1OYLgNtRpK3usnRe4
 2NNrENhgmqn0AuleBc6Kj/mOefGpaEY/kYY3PAQteykzfbbTG0iLIn+YjcefMEYXDzLYn28se/M
 2QGLxlXV

On Thu, Aug 28, 2025 at 12:01:15AM +0200, David Hildenbrand wrote:
> Let's limit the maximum folio size in problematic kernel config where
> the memmap is allocated per memory section (SPARSEMEM without
> SPARSEMEM_VMEMMAP) to a single memory section.
>
> Currently, only a single architectures supports ARCH_HAS_GIGANTIC_PAGE
> but not SPARSEMEM_VMEMMAP: sh.
>
> Fortunately, the biggest hugetlb size sh supports is 64 MiB
> (HUGETLB_PAGE_SIZE_64MB) and the section size is at least 64 MiB
> (SECTION_SIZE_BITS == 26), so their use case is not degraded.
>
> As folios and memory sections are naturally aligned to their order-2 size
> in memory, consequently a single folio can no longer span multiple memory
> sections on these problematic kernel configs.
>
> nth_page() is no longer required when operating within a single compound
> page / folio.
>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Signed-off-by: David Hildenbrand <david@redhat.com>

Realy great comments, like this!

I wonder if we could have this be part of the first patch where you fiddle
with MAX_FOLIO_ORDER etc. but not a big deal.

Anyway LGTM, so:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
>  include/linux/mm.h | 22 ++++++++++++++++++----
>  1 file changed, 18 insertions(+), 4 deletions(-)
>
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 77737cbf2216a..2dee79fa2efcf 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -2053,11 +2053,25 @@ static inline long folio_nr_pages(const struct folio *folio)
>  	return folio_large_nr_pages(folio);
>  }
>
> -/* Only hugetlbfs can allocate folios larger than MAX_ORDER */
> -#ifdef CONFIG_ARCH_HAS_GIGANTIC_PAGE
> -#define MAX_FOLIO_ORDER		PUD_ORDER
> -#else
> +#if !defined(CONFIG_ARCH_HAS_GIGANTIC_PAGE)
> +/*
> + * We don't expect any folios that exceed buddy sizes (and consequently
> + * memory sections).
> + */
>  #define MAX_FOLIO_ORDER		MAX_PAGE_ORDER
> +#elif defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
> +/*
> + * Only pages within a single memory section are guaranteed to be
> + * contiguous. By limiting folios to a single memory section, all folio
> + * pages are guaranteed to be contiguous.
> + */
> +#define MAX_FOLIO_ORDER		PFN_SECTION_SHIFT

Hmmm, was this implicit before somehow? I mean surely by the fact as you say
that physical contiguity would not otherwise be guaranteed :))

> +#else
> +/*
> + * There is no real limit on the folio size. We limit them to the maximum we
> + * currently expect (e.g., hugetlb, dax).
> + */

This is nice.

> +#define MAX_FOLIO_ORDER		PUD_ORDER
>  #endif
>
>  #define MAX_FOLIO_NR_PAGES	(1UL << MAX_FOLIO_ORDER)
> --
> 2.50.1
>

