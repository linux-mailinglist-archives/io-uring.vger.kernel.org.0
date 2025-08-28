Return-Path: <io-uring+bounces-9404-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id ED98CB3A44B
	for <lists+io-uring@lfdr.de>; Thu, 28 Aug 2025 17:25:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B8C543A8222
	for <lists+io-uring@lfdr.de>; Thu, 28 Aug 2025 15:25:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 336052264B6;
	Thu, 28 Aug 2025 15:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UyuIcD0o";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="XAg7Qan5"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C30AB2253A0;
	Thu, 28 Aug 2025 15:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756394697; cv=fail; b=HxGD8geDYjKycrCKnmBsdLYd/WQzMPBzdJCut54l4tX+kULpPoeRqmA0/XZFXdmwdxGiate3mefGjJJ4CnHQfQFKokgyMIDdYlwlqmGLmr+DS9uZpgNQP4cYbynoqapkd40b/sLX9YhSV6FArSHzdeZQJsorCSpwwsrLXSCeS+k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756394697; c=relaxed/simple;
	bh=xum/ha397uuwL9aWbkhjgmsXoect1E41co9LpMZJDuY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=sQ95Z2XXHF0ViW5/suMAwau5KAQHkGX/lmKCETyvrU+Jk+jTATF3K/rpELn69LVI9LmtcVOpZIg4uwzzQKUICpuU6l5PD1Zib4M7n6cLrgZTuVNWV7ImAbS/F71pImdSQ0r/ccoa0+sVW5LAjgD8QJr7l/Rl2B5Oa1H1OUxZdsk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=UyuIcD0o; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=XAg7Qan5; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57SEN0LO030370;
	Thu, 28 Aug 2025 15:24:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=Nsqtf8XEypCGZINCYr
	OqiZdWR/NO3gBHFx4jXwSz3Es=; b=UyuIcD0oTi0B0odEz7o/6utD0NOSba7XTD
	d/Uq+HUOQz81+lrjTA4AgHm4hXPQuirl9Y7nm2iUyt66uVJhBG6oGWQLHW/p3jPg
	rY8crQkR8muyakGrhrA2pfVpFPE3/XUVSINjtHT8d6IKCv5ddtsiBdCyWv3H5XFC
	XyN/g8rVm42KQeDAQB0ifnUYCx3sX5zC7UwcbjvcgixiupL+kOxSOhLFbKVV9xgF
	NPnLVFvXVZmi7A9c1NGlUtEpFVbNZGXqldMY3iT8yxPSqQrg/OI2v22U9Z6u1CSv
	4SDi6184Un8IY/3YF+r5RLaJleJ/6S89srdjZ3d5QQMWF4riQkFw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q4e28vw2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Aug 2025 15:24:19 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57SElsna012172;
	Thu, 28 Aug 2025 15:24:18 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04on2073.outbound.protection.outlook.com [40.107.100.73])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48q43c0cjq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Aug 2025 15:24:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fJnClepSL2ZBQ/2FDxMbZVRgzlYPqt7AefuGOA5m93mWYyM+FY1R95xNOxZEPZtInMDnRQvhXDO0KFldprJ7sx2kNZKj+ggnMdI9WlU0Rg9oa4UkmkcYyQVP6AfyrYdgFtCzMfPOo3gy1f/Na+pCkgi169yjLIPvDjW0m/AaPZBzDwlBDV9qsEpibcmZ7WbgMWPRUj39NT7Z0nvpNnRZ91gudtlSMxIM7nSZ08XQtrenJi7LWPPHcrkV+1WHZCYRoqWX4mGb6sa93nKU4sgcAy/5MBeMHgN+ELa8C2EYCp8QszZMUxDOVDD7bq94h/BotNk89eVDP8E+76eX1C8PUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Nsqtf8XEypCGZINCYrOqiZdWR/NO3gBHFx4jXwSz3Es=;
 b=H5fcWzuV1j0Vt++0kw0hnh6T6Mw/c+E7QNF7iY6w7qoLXPIFeIaVAOR+vzicc16+B/CY4nUOM0xwLNfIGJL0ZJ57CTEvj01jyDBo0cZIBBrKdQsFPaneVDS4b64UfqGyHaiZ23mLv6YD9JVWhMihRWQTNceDpq0y+Aj3+3/H0U29tGT2IBtVlgKqKL6OgYNSbrS2OE107gnR5g3SvpTCcDN6XwStUka8G5W2vp+CU3eF7ugS2gPRbHKJQPTP24CgzYbwPDvp7Tsp9lTqesfF3snR5SPLZYoKLDe827PHJSgz+aT5iI6/zclkfMt5UUYlpGRK6rRQpse5lqCwIfBB5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nsqtf8XEypCGZINCYrOqiZdWR/NO3gBHFx4jXwSz3Es=;
 b=XAg7Qan5olO0MU1Uqtde65+NAaTO3jJSH4SygUNlA8S3qBg6oyBfjYqXWYAfEi3hdjwUQL2Iq5pVd4d79uRD8fJcZZ/leDD7hFWSEhILch69F0RCTIKfaVWAvklSnMee4/yMDuOLr0KFzlnKkObIAxX7qX80neBNuzjHKMvrmbs=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DS0PR10MB6974.namprd10.prod.outlook.com (2603:10b6:8:148::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.21; Thu, 28 Aug
 2025 15:24:12 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9052.019; Thu, 28 Aug 2025
 15:24:12 +0000
Date: Thu, 28 Aug 2025 16:24:04 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, Zi Yan <ziy@nvidia.com>,
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
        wireguard@lists.zx2c4.com, x86@kernel.org
Subject: Re: [PATCH v1 12/36] mm: simplify folio_page() and folio_page_idx()
Message-ID: <7b7406c2-e309-4481-940b-63b6811b986c@lucifer.local>
References: <20250827220141.262669-1-david@redhat.com>
 <20250827220141.262669-13-david@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250827220141.262669-13-david@redhat.com>
X-ClientProxiedBy: LO4P265CA0084.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2bd::17) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DS0PR10MB6974:EE_
X-MS-Office365-Filtering-Correlation-Id: bc1434c5-6cec-4903-85ca-08dde646f0fd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Z+gdjBmvZOaIQzPezpSCAg1aPOFGXGgOBWt9BtArkAZ7j+/xIsJZs0Nt16EE?=
 =?us-ascii?Q?PswnJo+/O23mMQ2ArubTTOzkVGcfxvxfCFn06sWHlL23jX71LYxzJ86rL4Mp?=
 =?us-ascii?Q?QvKIdwtmsJZFwTisjIUdpQpOCBTQAtkSLkb9XoQjg3OBI3U+Gd+NlyJD3fQn?=
 =?us-ascii?Q?N3yNN4gDxo8yWrR6usJZylm1eG6+5UkSrEda4Xotv9cfs8m2Y5KWuhOBWgIk?=
 =?us-ascii?Q?DjZQKYZqgmySI4E1kZXZ62g+ahcTwFIizY3IyyZzpBtCaEGv6sXUcILOx4qI?=
 =?us-ascii?Q?nkA3wFhN1qofRGmtHg0y5GnEeOu5LkFPCXG+0QFrZTFYUmTlXBej1i/xxspI?=
 =?us-ascii?Q?lAjIE50TKz+sNwV5aeur2MdXmKoOamSPpUlQNfQba0wSDjxrMf4rLo3EYoO1?=
 =?us-ascii?Q?OefINDmt6OvZx2UgA2gZRWoJv6Xgz/ldMLSjFBPdvZ2r0zefQSEyMjivFLuz?=
 =?us-ascii?Q?X05FWef6IKSTMAfRZy7zG5uvZibXXRYLHPj9kGHoJpgMz8sAq9n9VewLvv8n?=
 =?us-ascii?Q?Fylk27Vm6XTdY/6ManWssjkX4nsbZmMXY5hSJlURolAGsXqc98PJSRqu2Xn6?=
 =?us-ascii?Q?kkfoGqjXYvT9tGI/+vgNR1Xt3o28ZLu+ZkU3EnpPZkScSBQF07nnF9EVVMvt?=
 =?us-ascii?Q?TA0LWp53I1bDrWIEHXBYrNcC8Cg8BXaiqMQRbC6JSfLhWvJkzWJAGWQ582aR?=
 =?us-ascii?Q?nKDzF82X5iuXA1Q3yEyOfxeJNASfsT2LrL0zVAef3QUOMofkp4lAfCUsIV7L?=
 =?us-ascii?Q?2KmUHo0UrxqP7sIWdAXoXPll9zgXVe+6nBKjvVze/oXrmGr7557gk00FifhB?=
 =?us-ascii?Q?OZwoNP142RLgi9kdcfVVGLJhQwso6AMHA4FMD/NC6xeqBWIkFsz93xNIfIlx?=
 =?us-ascii?Q?2MoY8/mBK7CbF8nw0l9inQexOxOAMTppjn1VrN9LnXWLepUsvxdy2aMuzYx+?=
 =?us-ascii?Q?2Rq6vQ1kM70LEjKSOjt0b5sP+O2/1tGNllnmNI2TSoARKz+8hdtu50gdU+iq?=
 =?us-ascii?Q?4yVq5XOZ0IpddAa602UV4X0FxGuvB7Mrh8ybWqiR4C0YhWb8L9jihYhDJvYu?=
 =?us-ascii?Q?Vd+NDnjSfXRvAvvRq/vOO3RLZgmy8zLI9Lke9m9+GwVNLhuE4t5B71XoQMTF?=
 =?us-ascii?Q?K78S2m7huWeLmTe3MZuguro7rstW5zXJBr+nSLYEwn2auFbn/UIB87jVS4Ny?=
 =?us-ascii?Q?MIN0taclD8pRfXcWpx63iWvWkQtSV4qG5IrmWSW6kOMxuso+TTZJFLmjy1lW?=
 =?us-ascii?Q?lcfYsVg23F4eI5wrc4mTN412G4BimTEZlENd1PSvnAAr+kwrJA8yJv3ZV9eM?=
 =?us-ascii?Q?yPMq8t9rNIXcX/lW/HrGsC/RWXQmv7cKiDNzdPTuI3PmFSxSyrGlZcdbfgAX?=
 =?us-ascii?Q?cLyTTa1NR1OMtMy51vsp2dPMqhvBdG46oO74DpYl6+VAwqi3VrQbUaL6O1NC?=
 =?us-ascii?Q?LuBHzwmjLyM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?b81bmbGxongubGRJY9NRXneJP6SFZ3Rl8n6KJyh+wiWG42IHnml13e0eUEjf?=
 =?us-ascii?Q?DymwA34Yx/KbgevrBh9wfghRklk8ChUUMLNirCHspFWyp5MN3zaUojM+AWrD?=
 =?us-ascii?Q?2Yw1QavHn4WA9sxGrTQa4Qh5NIIVMkoMY5moR7Nzithm/6/6NSB12GQvzCXe?=
 =?us-ascii?Q?DIS1b2knXapTegQrVdGiPszrwvy7Dvm7umfsmrFJxdIqIa/sERtOICACAgng?=
 =?us-ascii?Q?26rXJd9MvlvRT6NBwz26YKB9YhbQ+T7XpSEP4ZPxUm0AYkHvn7wfsE4+AHWK?=
 =?us-ascii?Q?3R7WtR7r9Hj1N1SN70mKghegXHHuqeXmYZwLFqWCeuhi8uGhd8xSA7XVn1I7?=
 =?us-ascii?Q?4WIZL1QzASTfonBz7e6z4fbu8MZUCG59wWlFdbgZlo/ageAK6jyJy76eBzZj?=
 =?us-ascii?Q?8vNudF1fa5u/ORQwu44XlK1cdaeeY8o+v1PD1DPx/hOv7DW+NWEGzXbOcO4x?=
 =?us-ascii?Q?MRGsfRJW6JzvmNT/I9ogYH8pQvyiMLZhmrdelcdwS6aKGzS1mM9wAh0B30Aw?=
 =?us-ascii?Q?j6xj99PldeIjTfax+IjQO1xFkJ5CqIyHyaK7K56GgIMfMBnSLdHMoDs7us/X?=
 =?us-ascii?Q?INpf3If0j5tEWRFCE5ZxLs07uUgPDk9sPrrWQeIErGwzQAGIEvEojqoKwRcp?=
 =?us-ascii?Q?zBlFOZBgxd84wdrx/29L7Bcn5soe0aicq9xYXnnB/YsZlToTBsnCE1TUJ4BP?=
 =?us-ascii?Q?UiCLi2UlmXgpLOvOxazGaxrYY618ZtWNQfQvOvO45niH4vzSJ29Yub/qOBgV?=
 =?us-ascii?Q?+Y//K8cl+0wwL+QynSlz72j2X7i7vZTlltL6dP/HstH3/c6Aeh6g3XZTuZpO?=
 =?us-ascii?Q?Lkn86R7w9UpZ8JjP8PKKkdkPWPYWWl8k1FYITly0AFGEXjREyHmghkJxoEVZ?=
 =?us-ascii?Q?Sw+QgMpp0Gl0iKpPB65UV1GxbbG/Nn+/fWIhSGJ5+P0sL8O6XLyXJKNt4KkI?=
 =?us-ascii?Q?ve+SBna4Rw4q2JslGOKJcfSon3wOij3o9IwJbE5/q3sBgbs10RL/0pdCM3Rm?=
 =?us-ascii?Q?Y1p3i2lJBtPZ9nH8hYuPPBEP8Q2NhUqWvV0gI38CbVYGGxt6s32KUQzlm3OS?=
 =?us-ascii?Q?W3dXu5gvNVW4MfKQp6HuVWlQfAXkn9xNcgevC+y5F3gW9gc/hClTgTP2AJnm?=
 =?us-ascii?Q?q/AwOC0OYNOXIwmPXsdD7gteTr/S9b2FpB5Sj14ommdEWoPkCkuNgN02Nfj9?=
 =?us-ascii?Q?GFzuiH8izxh+P5FexZwO6VjFJqjh1mpmW0I040wJUni3vcmbWIuYR6lXb+zU?=
 =?us-ascii?Q?xwJO4QqVogUCnJOZP6O9fpiGE3u58/Vx8rA1P8zoD1zcPEkvs+7DNNqLlkDH?=
 =?us-ascii?Q?QIbHUWaov8VPWKDwz5NFFmZ28GeFFyxCHrep0itwiJ22QCiaGh71DNUDxIyr?=
 =?us-ascii?Q?GTLYRlPveUwp5IV9hNYwe4NUqJau8JOm7quJ6qIe7SneQnpKhF9nu3xM5/l8?=
 =?us-ascii?Q?CB3WYAy9D/3QQGvJEniAV5ksfBSwUwg3C99oa0qdjZLVSp4I0Clls6i5NUak?=
 =?us-ascii?Q?JokM4fptElwE6NkCDDIUheftRjHw/iv3JJRXwW01+5T+Np8HMBu2eQV1NDtC?=
 =?us-ascii?Q?9aS9wxJz1XtI6YfEifeZ3sTvfPhTR3E6KyeZYgCQUfgktM2UxAfYcikWyEBd?=
 =?us-ascii?Q?qw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	/ytV6vkPLA41jRGpYR8imyAjYjMSvDh1fRBYirb/rzqz8gHLjXgS6ZFpgpNxEpHrZ3oCd6GvjH+Fay7asCUesW94VfZG7HxHs3Wczvah6kQ5ZUY9yz5zqqGtwaYiPuxHEKGDTynZvO+ewJm+ewBQ/PpfbehrFOsCAaY6bKN8Sc4Bim8qdFRScZH5RF4WGzmtWCDWnO4wmL9HoXvB9WOBBnSzqXz244wnhBXwq9tOvXwgvu0e5fLYynukzu6N/J6lv37snpsooQS+uQ/aYNHAGWDV0JZzV7qJKpGE+QJHooZYsAAcmqhA6X2GNm0ltzv3KDBwxd2fac2O34U7k9D3qr+FsyXtiCujwyHBrwvFWLWhrhGl+NcSiWOxy3LBu4bHkLkRYR6qDBcCGX9gswWqKMTPtvmQlfqtIg86IVUZSu9RSDaGk2spL83wDCgT9IL7nQSgILyR7zysTlS/AnRD0kLu3MJPVzI9SdPoQJrPhUwyTKr44QeBbVB4VW0QeuOnBUbhr/CVsWULrSdgJl0sWBTr9frBBQ+OnYog0/ZfhIh0DnPLwNgMhfRfMQW6Ku57exod72Ll3HHT8T/SYmysCXhy9muw6XVgDH4HpPwXVBc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc1434c5-6cec-4903-85ca-08dde646f0fd
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2025 15:24:12.2544
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S5SCbHDNBOlomyW6GOSj5zEL4s9rtwUCBuNT7WMiiQnIGMsO6N9RRHVhRwFpB8swNzEgtI1Yo93Pxe+s2kzm189X+XSU0ISEd1Qht6W46eM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6974
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-28_04,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 adultscore=0 mlxlogscore=999 spamscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2508280128
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAxNyBTYWx0ZWRfX7IKjTqnaRKtf
 2k7dlO3VCY92ZD3UmjF1LP7wMeiIIkSDEUOvLXeXIP6hYYiF1LtMcCmMlWAoqBypOH2/Dzp0abr
 qED19qGM2vdfkA4+jG+tK3cMx0/ev4tlytPq96ZePWJsDnnxPsmFvmfeiERH0qDj8LT5bwRCrnI
 4al0tkzgjp6YoFwrfhBM95SYItE0BYnFOIQLQnz9FmoVm6weGdMlpVddWMrKhUIrmjqXaef3Jsb
 QEs1FmUMcXcXZpxAT8J/cdEDVS/piMku803ANWOe2Wgym4Uj5KbgJRsswhhvxYnrIZP+WWLmcbl
 eMODg5eBnZPXNnKMwx6pzKFZvmxLVofpJXiQb4wjhM+VA1nPZbowZvBVfvGbvCso0+1Ew3S5UEj
 LJfa7zbz0FduxixehDp6b1047OGD5g==
X-Proofpoint-ORIG-GUID: 5Hra0_YS-tk0FodU6MHMZO48m4zjs5L4
X-Proofpoint-GUID: 5Hra0_YS-tk0FodU6MHMZO48m4zjs5L4
X-Authority-Analysis: v=2.4 cv=IauHWXqa c=1 sm=1 tr=0 ts=68b074a3 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=Ikd4Dj_1AAAA:8 a=20KFwNOVAAAA:8
 a=yPCof4ZbAAAA:8 a=XHDgHtscYA0Cfymos64A:9 a=CjuIK1q_8ugA:10 cc=ntf
 awl=host:12069

On Thu, Aug 28, 2025 at 12:01:16AM +0200, David Hildenbrand wrote:
> Now that a single folio/compound page can no longer span memory sections
> in problematic kernel configurations, we can stop using nth_page().
>
> While at it, turn both macros into static inline functions and add
> kernel doc for folio_page_idx().
>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>

LGTM, so:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
>  include/linux/mm.h         | 16 ++++++++++++++--
>  include/linux/page-flags.h |  5 ++++-
>  2 files changed, 18 insertions(+), 3 deletions(-)
>
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 2dee79fa2efcf..f6880e3225c5c 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -210,10 +210,8 @@ extern unsigned long sysctl_admin_reserve_kbytes;
>
>  #if defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
>  #define nth_page(page,n) pfn_to_page(page_to_pfn((page)) + (n))
> -#define folio_page_idx(folio, p)	(page_to_pfn(p) - folio_pfn(folio))
>  #else
>  #define nth_page(page,n) ((page) + (n))
> -#define folio_page_idx(folio, p)	((p) - &(folio)->page)
>  #endif
>
>  /* to align the pointer to the (next) page boundary */
> @@ -225,6 +223,20 @@ extern unsigned long sysctl_admin_reserve_kbytes;
>  /* test whether an address (unsigned long or pointer) is aligned to PAGE_SIZE */
>  #define PAGE_ALIGNED(addr)	IS_ALIGNED((unsigned long)(addr), PAGE_SIZE)
>
> +/**
> + * folio_page_idx - Return the number of a page in a folio.
> + * @folio: The folio.
> + * @page: The folio page.
> + *
> + * This function expects that the page is actually part of the folio.
> + * The returned number is relative to the start of the folio.
> + */
> +static inline unsigned long folio_page_idx(const struct folio *folio,
> +		const struct page *page)
> +{
> +	return page - &folio->page;

Ahh now I see why we did all this stuff with regard to the sparse things before
:) very nice.

> +}
> +
>  static inline struct folio *lru_to_folio(struct list_head *head)
>  {
>  	return list_entry((head)->prev, struct folio, lru);
> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> index 5ee6ffbdbf831..faf17ca211b4f 100644
> --- a/include/linux/page-flags.h
> +++ b/include/linux/page-flags.h
> @@ -316,7 +316,10 @@ static __always_inline unsigned long _compound_head(const struct page *page)
>   * check that the page number lies within @folio; the caller is presumed
>   * to have a reference to the page.
>   */
> -#define folio_page(folio, n)	nth_page(&(folio)->page, n)
> +static inline struct page *folio_page(struct folio *folio, unsigned long n)
> +{
> +	return &folio->page + n;
> +}3
>
>  static __always_inline int PageTail(const struct page *page)
>  {
> --
> 2.50.1
>

