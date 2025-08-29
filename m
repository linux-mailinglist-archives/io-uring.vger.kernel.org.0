Return-Path: <io-uring+bounces-9438-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 314E1B3AF70
	for <lists+io-uring@lfdr.de>; Fri, 29 Aug 2025 02:31:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5BC8CA03BEA
	for <lists+io-uring@lfdr.de>; Fri, 29 Aug 2025 00:30:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94C0E1E25FA;
	Fri, 29 Aug 2025 00:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nhXSu7jG";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="fjTFsQtD"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C88E71C1F05;
	Fri, 29 Aug 2025 00:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756427409; cv=fail; b=Xb5Jd/m1fMY8MOKRPMjUNfTmDcMIAJA9oUTbXa1s7iPBOU7esgActH0LuTanrkcGPC3mvWgRk8gnKZKuU8PpwBBM2JQkZBYOsVAbySHsJe846rp5gVtC0Fex6yE6hArF5P6kYgrDwam0oAuvD/iN4oyy2nDo8llE3niiYS9WAqo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756427409; c=relaxed/simple;
	bh=g4Es+KKAuqN4Ak8jOAjDaDm/ItLW11CZY6uIDH15rks=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=hGh5g2ne9uMT0sTmkRmgQzH4Ij9Di6lJqhlc2Ug0+L3aMytXvoX5D83GSmb9RqyQjRe5qrEivfFLR0ibjst74Ti2qzdUX22UExU6vc3WWjGHpjvRJNr9CnGT3HvGGpe+NvfnP9URfGHmh7ArnIY48KJjHZjOZJcloa7FcJbevbI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=nhXSu7jG; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=fjTFsQtD; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57SLUukF002663;
	Fri, 29 Aug 2025 00:29:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=7co799GYQ3s9+HiQt8
	B79X4fTR1elTZSB+dVFw5DFSo=; b=nhXSu7jGbosxkxu+IQu4UCahJ9IzdjNQXE
	ngdgWMX1039R9mMq/hF2KzYxv923b8l+lUBnwxFiIdipdLHdmofiEQXbwZrH1gBm
	5i+ht+eZ/avP+wds7VWOFORtpedC4DGBywSt8QIuera0u5+TqPM4JK4ZyGgVXN5l
	Hq7sC9o17c4sCuT8X7oS4kgdExSGRJzjDDN6kpd5XKaN+K7RCTWMuntUP/VH54x6
	Zr9Tt7z5b0Y/dEvsgvzPOuQWSUCWJc0w0QAW/C+fXgCo45kJ8OoCmA/cjkXTyd8h
	HlkQE/LmzEZAmox+ofgX5lV4YlpfQy1ay8QyKbQPw4vjxSx0V2Sw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q48espfh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 29 Aug 2025 00:29:30 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57SN6fX4004995;
	Fri, 29 Aug 2025 00:29:30 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10on2082.outbound.protection.outlook.com [40.107.92.82])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48q43cnwnc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 29 Aug 2025 00:29:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=alv0MLskOhFu1dTSbh4GAE1tnNMCO//0VTh4xRAYC2W0tJUzpIrnAO8+oPJmf0K/3bQxXO5VuvJiOqatTVExlRZQQ0AMF2+GLZnyOLMS7QhxNT1T6r2P42EBJ3Y74YbWAP0XPBqBO7B+Y6SbRVXU5eSRj1j1/Gn8aUGqz+UojX5JMQl61xjG1iVG9weS5jmHW7z28yhGj0vMPMswsAu2m1XRf/5ePgNpbYe2K40K/CxsDpBYbrfRhuM2+EnLUanBFrGoks3lgUkh7fR6FPJ49EK3jD65psTzpimVky0yjOGQzgPrCsCrTrGaKIMu3PWQYoByfLHc1V+D05CRlIIH1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7co799GYQ3s9+HiQt8B79X4fTR1elTZSB+dVFw5DFSo=;
 b=kOU49YrstILTnh9rUbVic924GhxH5lgnJrKuxjtpDFSUdbt+PvZLTlkmpWrKp27Cgkbd4fpqYUx7iXBc2F3AOSVhNFD61E5OwY7XHA3MfV0YW00bg7VcZbPYLoo4aHG+VAeJFOE3rIVdkXwNE7RA476caVvscxdF6XzU50/HN2TUrsGqZ5QCSf+4JU5neLHHivIc9tJoOr4SYsR8dBcMzgVMzy/W3YnPox9/G8L14ajtPVjE6m9aBCRIczF4GM6txdjfNkot6E0EiZJ3GzgRuG1nqnxEeiuJssJJm+6lXHt02pdE3Uol/OFm9iXgT7If+ZEtWUOXO4M3WwqWxmT5Fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7co799GYQ3s9+HiQt8B79X4fTR1elTZSB+dVFw5DFSo=;
 b=fjTFsQtDIxxcUM2SwsW1HDo9cxQ4ITURXwcSfCXF+hj1zwC1JJmNVLR7RQL7SxnmMZzj3w6RbEb0MCjdMTb2ZlcYAFlpsnc7FauEtkiDejkWwNKyG4OzS0+bJ+FTvhXtPwi3VZVUO1RSSD2lQwca+rUIOF3nXhtA0KQS6Fhaw+A=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by PH7PR10MB6481.namprd10.prod.outlook.com (2603:10b6:510:1ec::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.17; Fri, 29 Aug
 2025 00:29:22 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.9052.019; Fri, 29 Aug 2025
 00:29:21 +0000
Date: Thu, 28 Aug 2025 20:29:12 -0400
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>, Shuah Khan <shuah@kernel.org>,
        Alexander Potapenko <glider@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Brendan Jackman <jackmanb@google.com>,
        Christoph Lameter <cl@gentwo.org>, Dennis Zhou <dennis@kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, iommu@lists.linux.dev,
        io-uring@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>,
        Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>,
        John Hubbard <jhubbard@nvidia.com>, kasan-dev@googlegroups.com,
        kvm@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>,
        linux-arm-kernel@axis.com, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-mm@kvack.org,
        linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Marco Elver <elver@google.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
        netdev@vger.kernel.org, Oscar Salvador <osalvador@suse.de>,
        Peter Xu <peterx@redhat.com>, Robin Murphy <robin.murphy@arm.com>,
        Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
        virtualization@lists.linux.dev, Vlastimil Babka <vbabka@suse.cz>,
        wireguard@lists.zx2c4.com, x86@kernel.org, Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH v1 05/36] wireguard: selftests: remove
 CONFIG_SPARSEMEM_VMEMMAP=y from qemu kernel config
Message-ID: <faqp5sdyrkcaatjsnvoxssck7l2qf2e7kivuepobmc5zdg4mnl@b5ie7764mkqi>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org, 
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, 
	Shuah Khan <shuah@kernel.org>, Alexander Potapenko <glider@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Brendan Jackman <jackmanb@google.com>, 
	Christoph Lameter <cl@gentwo.org>, Dennis Zhou <dennis@kernel.org>, 
	Dmitry Vyukov <dvyukov@google.com>, dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org, 
	iommu@lists.linux.dev, io-uring@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>, 
	Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>, 
	John Hubbard <jhubbard@nvidia.com>, kasan-dev@googlegroups.com, kvm@vger.kernel.org, 
	Linus Torvalds <torvalds@linux-foundation.org>, linux-arm-kernel@axis.com, linux-arm-kernel@lists.infradead.org, 
	linux-crypto@vger.kernel.org, linux-ide@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mips@vger.kernel.org, linux-mmc@vger.kernel.org, linux-mm@kvack.org, 
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Marco Elver <elver@google.com>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, Michal Hocko <mhocko@suse.com>, 
	Muchun Song <muchun.song@linux.dev>, netdev@vger.kernel.org, Oscar Salvador <osalvador@suse.de>, 
	Peter Xu <peterx@redhat.com>, Robin Murphy <robin.murphy@arm.com>, 
	Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>, virtualization@lists.linux.dev, 
	Vlastimil Babka <vbabka@suse.cz>, wireguard@lists.zx2c4.com, x86@kernel.org, 
	Zi Yan <ziy@nvidia.com>
References: <20250827220141.262669-1-david@redhat.com>
 <20250827220141.262669-6-david@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250827220141.262669-6-david@redhat.com>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: MW4PR04CA0172.namprd04.prod.outlook.com
 (2603:10b6:303:85::27) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|PH7PR10MB6481:EE_
X-MS-Office365-Filtering-Correlation-Id: cde7407a-9262-45ae-453a-08dde693194d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?rCTIcoIGcxsmdQiQZdSZki80GEYdQkG6vXkBErKdHFnT8WkPrpoj7RgIdn85?=
 =?us-ascii?Q?2T1YQQLbGN8Xo5CqM1JTphVorzyct3pzrgCqRKdXljpb60FDy8DnCYHX05KY?=
 =?us-ascii?Q?IPvHW1KYLbHv15yC3mGX4OYGjmQZ+zj1yZS01VY1zSUdh7d55113oP3JWzfH?=
 =?us-ascii?Q?TnfZJxT/UnL99JrHJLNYew4Ei48+BsY6vo6hcFiDO52bMqba/keF/qjx11DR?=
 =?us-ascii?Q?p+ZH2bz+fpAyDEJgYSUVCjHVf52RGfq/RDOafusCLMz23q9sWE5LKZ5BFS2X?=
 =?us-ascii?Q?MTSbluHnc4u8XhxAYGwmlHXqgne8+fFwd7V6Z9emVh127QX/rNS/BCmqDPxC?=
 =?us-ascii?Q?+p/XbBw3JivIAXddFB3PHxRw4aAAhtKqkKgy/o18+mvg/UkO+EoeOs6naagh?=
 =?us-ascii?Q?k1SME7QXdPmh2q9otLGlh7hHam320ohhUCfMxXE8eafN2uTVhMJjTm7FaUNB?=
 =?us-ascii?Q?PXI7T5upfH8MAXKjDyHHw5ugT4AaUWW6m5xeh4Pf1n7Onam1YaZ56yX0oeEq?=
 =?us-ascii?Q?UrWX6WZRk+0JEMbB+yQwAMzDTvKEIR18fayb+IpVsveYhy0T/LtIwrp5MYW9?=
 =?us-ascii?Q?Dosh9aJXmmcTYw4jTKh4eChIA2dgPtOXTcWcKlu5KkiukvYlrbvuJl/b4hUx?=
 =?us-ascii?Q?QafLrypII90eyBAs8BFX8J7GFh/UtNXMbDTt5D8UwoUpFuTug2CA5wgidY4T?=
 =?us-ascii?Q?D31v2lZqZuM/B2S33BoHCuXmoJour/+N5tL1grlCQJ/HEXIei/kFqMNB1GDM?=
 =?us-ascii?Q?tXOw6r5CyN1NoAwNLZlTwjh2fvbGF1dMTStyCrBVEaMsU2mC/gzxt6HiBnQM?=
 =?us-ascii?Q?KJfoAHhUmH+EUmfPDLwaGjgjQOdZ54ursjK+rQbQsJP16H4nTC/E02JbwC3T?=
 =?us-ascii?Q?Iq9KCYO9A2+5YAggrfZ+9hDyEVhFO2aHGYUH9T+H2n2/uNr3/Yr1MUWKejg3?=
 =?us-ascii?Q?zs6Iz8ezLHIa4bYyGMHNEg6TJ/vxrsFpWv0PKRJsR+myIn3IbSdb+qMB6xEF?=
 =?us-ascii?Q?TwoyChDnTKkpGJP94zw2TCLLYPz91j3tpFfIv17Ze7tsPhQL2+nAxrmkGvNJ?=
 =?us-ascii?Q?4BYmq5AWAFzI+EfYSKj0f1RanvJhRXRsNoD50rvv5zdPD2yqwQedK1v4FYlh?=
 =?us-ascii?Q?OdwhBLef/LcQyRlbu8/8npeIjj96spJ2EbOIGpca1CJ9iwDN3W6vFPPo5nEN?=
 =?us-ascii?Q?CO1d2FgKGpUPNLPmXoY0EVKzGxYori1AdxiIH7TuPMqZnHGG1J/+i9NR7ug+?=
 =?us-ascii?Q?Zqu86fYo70fsWRHXVQA6QqkT+o9rOjHOzwWlgHsX5Cdo5PRHnOO06UxumQeE?=
 =?us-ascii?Q?FxVLSm8EV2pQRLmjBc105XJTtwsnrsEIULHEJiKayzHY5DwMQQye393SEQl4?=
 =?us-ascii?Q?vducpUwMHYQKnLQxzsaw674GqMELxEzkWbs//hhpzhEofh9ZaA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?yFy4+6XqsJ+IW7bVX9hEFhMg12KI54isEmcEcn2G2a1Z07+ju/NEKZutsk7K?=
 =?us-ascii?Q?QHSKWZ+aRdbFRJ/jUzDZcMAEXDG3Mrls8nEtGfeoXK7mZAEWNl9jl8N/FqgB?=
 =?us-ascii?Q?063lMa969WMGXP+Z3QkyDq+3KC+bjZKNHyHv2eOyC50O46Hmr5G4mbKOkE92?=
 =?us-ascii?Q?DMI2YAFo6f5GpkkEiIqfy0JyWfigDOQqAnr4jBZzBZbZm9ndzEhKC52JOPok?=
 =?us-ascii?Q?RVtpIwvEulvd9a4EVNe9FjRQAE8w1XWhsJCznAPtPbNL+/nVlIIQm/9gGpHW?=
 =?us-ascii?Q?a/jzIC4ji9PDVrWM9usz2wX8ErRd/YaUW0IG47AqTV4cLZwEh6SoMD7PnTer?=
 =?us-ascii?Q?fGoJs8aByY2d57ejiJJsSE/oXViSq5umKC5vxEH9IMXlsPJPR2lsWKP1IJ0f?=
 =?us-ascii?Q?vq1lVOqLee6lOrrSgIcIPYobztp/Kl++gVq40PzUs5UnEOx3dcQUuYcOjAWt?=
 =?us-ascii?Q?IabhmraGsI62/6NRLjJ5RNoKuuoChiTQJS9WmFVax48Euq37yJICGlhx3VRy?=
 =?us-ascii?Q?RkK0ZxYpfJ5Z/3sbeR5onL8BmGqvItHmsC9KRTXtc0hpna1uNPMK/mv1+MbJ?=
 =?us-ascii?Q?+OWIMT+fl/V1zcYNid5Ngv7g+zeHPF+h9+KlaZSk7JEVc01BydhYm847E/yq?=
 =?us-ascii?Q?PZwQ8XhWMcuJ+OBIZE9CoVQUtg/J3kgY4DXRoQWLyAUwpIr7WG/fmScPdEzh?=
 =?us-ascii?Q?C/8SxBNtJn5tD5oE1EAOlgvgB4aV4tMDWiMd73nx5Xi0MC5ndGr4AsRsWgOq?=
 =?us-ascii?Q?poizh5nYKWF1Xsu1DhI/QaZ7Xo7ipEbSNYv8bPrW0F8jXlsmIFf+4/gxh+LG?=
 =?us-ascii?Q?aNVJr/vblzFGbGve/l44Uz+Fvpq/DNdWSCrqqW39YOEo4OJnAEWhdRBzWO0Y?=
 =?us-ascii?Q?JiEr3bCSSvEaY2d9RLPQ0kOIe7wW4IJhGESB0j9GscEz1yYymCaXRoqJF+ts?=
 =?us-ascii?Q?dDn3ZO4QVauwwkqC3La1bhmbUO7yDU77BZfYp1xq7JjGWH1F/n38bXA+GvKd?=
 =?us-ascii?Q?RfMf1aecnf6m1qa9eAH9ETWZFRK767Zkb2JGDVuke6ZNgiPO4q3d41I5CG50?=
 =?us-ascii?Q?U3L8IPtCBcRr+scQX+wRklGk48tGJpiaQe8Ifh5FNnIzF9U3aXG8LzD6OzhQ?=
 =?us-ascii?Q?QEaT0HhtCWxXlYqPbHySP0O3cH6DS7OlPKtYGr/fYKPKLZxt+ZBRUM+sD7Qh?=
 =?us-ascii?Q?vqz6O6tmpVn58dufOJrt02J1RLSu7DoSRvrCLj1fdTMQNrGtXZV4jFOhU44G?=
 =?us-ascii?Q?6dp7GzMfN8NlVfL5tuAm/KsHoepLcy7g0s/gz7TgI0VWcmpO/IdecJ54eWBM?=
 =?us-ascii?Q?xTgy0AYYDSGTGc+uBdakI9PYjmptzUGXrrWYtcME/K5uDr0LJwiyYGzguAnD?=
 =?us-ascii?Q?Ouo+OXkcn6tQOBUsV1yOeTpnw5EDULhTiJIoMFkwibp18H/bWUQdt8ZnKpWM?=
 =?us-ascii?Q?FwhsTeOmd6HDNx59a2kIvrGYFrBZ39lZDJ46jSuoWByeOSdS3RZFuNyvPkdr?=
 =?us-ascii?Q?eg2qihkZ7RA8sxlXb0tvQTTJoZ0/kKx4jo/7nA8foxPwkgmthVKIWS7KMpI/?=
 =?us-ascii?Q?wjyfKHJeIsr5EpNPjSRS41+BS8tUcEYr8nlUjBfiJch5Pd8zL2CwKS8ZURXZ?=
 =?us-ascii?Q?sA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	FgBTxNNJPuddJ5TX7T0qn+Sm1T1X8ikMwLPkPJWVf6rf+aTK3sVybk52zWqzIDsgztyLlASoicVM5erMu19+DstuXFizMReQaQ3gm0ErbU69ON+vduG6hbFmk2Uj1CZ5Bp5fs79FbhyS70AYKlMEK0JX4KNItOCcXt/GcXVmB6SjiplCu/G8tmtrkI/djNTV52092GBIsgfzqhqOZcJY8VWBX2iBiCilEWnU+0EUssdPAvteD8SZQLeTHLXrSHGwCml0rjBAf53pDHvC5KS6fklPbwura0TnSHCtc0oZ0UyvPTyVCkZRnrkBVRWdbUi8mpT+tjSD7s/uXUQak58fQQg5xmGijEQEfCL9JIM/ajvdMxtt+agCNywKGpRj5gHBJqZ7epjSwEmiRNmXv2kSqAEIQZpxX/1qF6VccnulkugYVCKDlPSUyC6SrBlg/imuh6qxgGzRktra6a4bqxrQjire4vO+1kpQdqFRRD97XVPDaZbt9yQzk2RTUqnFcjSIXvcFTO468KwSMWC7fs9rJAHkUpbuPYHBE1szIuHmrzaVSmrxaA0oYkZDBrH+ZF4SVGg9nwzmSREL8/4yKuucgclSqikLUe6T5jWV9XamIuA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cde7407a-9262-45ae-453a-08dde693194d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2025 00:29:21.8200
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V9MmB6Lao6UPCh4P8OTAs3ObyvJnyn+uI2dfja5kJ8I244B+0icxOrY5Cr8fiAvtNJCz5ou9l/Co8UcCg4W5ZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6481
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-28_04,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0
 mlxlogscore=999 spamscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2508290002
X-Proofpoint-GUID: i9eAXED2WWudCeVYHg1Avbk_R_mGcXuR
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAxNCBTYWx0ZWRfX2akbItr/IGRd
 9ylyFRPDs2DGYA0VeNupiDhV/+HsP+oei0AzrLfowBT3zBAHOpRsWITS4v/I8pRBeTjU8WqrnEs
 mQDvOGAld6PhX6hf5kZ119KajKC823oUsEbHxna/AA/5iMaELDfDw1XL61g5/zoGgUWyJxRi6Xm
 rRH6GRI4WEc9huQbc+56I77vnwM76Fle/IHAcW5GEDYKMbZ6O407GtOFGMdxU0e6vYhzSDv2xLA
 Ri88nwKapKUkXr0cVaIeu4PPJqgG7oIejpJFZP3WJ+nGS2hU6wvch0RFOl7OQO1dPICDDky8pi4
 oAVkTkyWusMDN9WxpeOQkzlmR2cz0WUN8aoQ2WRzFQZIEXo14IGe1nPoxQxzrHv6ah1FGbXFQYQ
 xIxpyZNH
X-Authority-Analysis: v=2.4 cv=FtgF/3rq c=1 sm=1 tr=0 ts=68b0f46a b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8
 a=UGG5zPGqAAAA:8 a=yPCof4ZbAAAA:8 a=S4hedQ7f9s0DpHPo1gAA:9 a=CjuIK1q_8ugA:10
 a=17ibUXfGiVyGqR_YBevW:22
X-Proofpoint-ORIG-GUID: i9eAXED2WWudCeVYHg1Avbk_R_mGcXuR

* David Hildenbrand <david@redhat.com> [250827 18:04]:
> It's no longer user-selectable (and the default was already "y"), so
> let's just drop it.
> 
> It was never really relevant to the wireguard selftests either way.
> 
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>
> Cc: Shuah Khan <shuah@kernel.org>
> Signed-off-by: David Hildenbrand <david@redhat.com>

Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>

> ---
>  tools/testing/selftests/wireguard/qemu/kernel.config | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/wireguard/qemu/kernel.config b/tools/testing/selftests/wireguard/qemu/kernel.config
> index 0a5381717e9f4..1149289f4b30f 100644
> --- a/tools/testing/selftests/wireguard/qemu/kernel.config
> +++ b/tools/testing/selftests/wireguard/qemu/kernel.config
> @@ -48,7 +48,6 @@ CONFIG_JUMP_LABEL=y
>  CONFIG_FUTEX=y
>  CONFIG_SHMEM=y
>  CONFIG_SLUB=y
> -CONFIG_SPARSEMEM_VMEMMAP=y
>  CONFIG_SMP=y
>  CONFIG_SCHED_SMT=y
>  CONFIG_SCHED_MC=y
> -- 
> 2.50.1
> 
> 

