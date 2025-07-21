Return-Path: <io-uring+bounces-8755-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 78D87B0BD18
	for <lists+io-uring@lfdr.de>; Mon, 21 Jul 2025 09:00:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9C8BD173D11
	for <lists+io-uring@lfdr.de>; Mon, 21 Jul 2025 07:00:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51CED280CD3;
	Mon, 21 Jul 2025 07:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="QTwusR4h"
X-Original-To: io-uring@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2081.outbound.protection.outlook.com [40.107.223.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B1741F0E53;
	Mon, 21 Jul 2025 07:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753081224; cv=fail; b=jiT8Xgkrkn7QIKA3myJBexVyqm79czIn8dUoL8sMwzmBZjyfWp3gaTi7MeVgg+ebfd0jRdFogOVtJ9sFS1xkDtCUVac4XlaJ4JvJLnCMGnNi2q2Gj9JpsP/RtZyBWI9mDNvqWEqqT0VmvCGGDG0mNUyQkN/VEut8h79CWRimU3A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753081224; c=relaxed/simple;
	bh=qxyYmJeO1/D1R52DkjWXu9XQPuZHiZAqgEvwycInOpI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Ua91DDBiBBw/qi5eGUp2J/XO4tPKNR+OPk1QN3SRo5Llulr5DbG6kUFv0quiAoXjMqGJ9a1d8dpD7byq+i5OjQKPVIhY4/HIxerg9VoZcKY/yF6Aodbec+nAmrXIB6LhPAV7cZ7/kuKOSPNOhcL8usdIehuK8FAH2QYxHmyICiM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=QTwusR4h; arc=fail smtp.client-ip=40.107.223.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lS2U/0z/J37Dt8odB2bGVt6YKl8tDx3TadnuiRDktrjVDjG/HCpPNUUWkkHAIbsrnKPwhfWQ0dUYK+rTxtyPLlR4j8mxvYRKHE/PzZwtyGAbr/LzdFXnNMjKJ5SBVMeZy09apSgUOpgfOj8SFdx1ecgSaqCzNiF+MtHkcA3vWMklAfN2CBCM43AvZ7tbM9CFGQYyj1W/jC95zKWTOHDYI6VhKktRF+fLHEKM+ByBi80qqshPxAMCH5DjeknbrIfqruZxwcPM9D+i2HnOrDcYUIzPUD3WiR+/RKe2kra3/PE98da+NeknLsCqvVVx/e6DbNF6xL5J+CNza5RTr+SQvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h/EidE/Cd/RHf5WbQKaHJDcIHJ4MfB/kPM3bnafTkd0=;
 b=H6Ugh9h2KTnxjmZCok0iZnh8ZXuHx2k7s4K4ZgoPaIkIoEdRSgxNADaX8m8xPVKbQ2L3TL2N6pBpWmqnDj2QWITo4Uj2mAyduTIukDEzsIEVWB6O6k86JUbm2PMGkkvx2mYL5p/GoA/wbVJuWCaKti0WG2ey75Yho+n/SFkQxKdqp5sTUqDc97tJIyTcSnBEdZNl4agZ0uMUQu7paqsHrjfbT1aPVP4PH5ttYGclCUFXrL27lwZG/GJJSqStdBLjMNURQ/QQgsFMwZiDnnxqpM4sLakBCaXp4nJSO+ahN1Np3pw8iZHs4R3cu0zF1c9kVO6Aw/j14GsdQpcOa9/Asg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h/EidE/Cd/RHf5WbQKaHJDcIHJ4MfB/kPM3bnafTkd0=;
 b=QTwusR4higY00rrWbpmm26hV9/X303y9iPFKspb8RcUnucMKJE3/cvq2NvqOlAw1z345peNLG7LVtBAXeWTL5gDvbbG2kSB8809vNnwkpL/XzKYHuTjzwXxm9+odsnB52d4nRrI8vh40ivMmNC+ohPwMotB7nR2QxZPJ6oY/d9BnpL3xX36PHZl5W72n9qwi5NzQ5gpqMdGwmvppze8dCSNQo/U7vqvVGq10eP8qbmoQPhlgYmoO0IaQyGuRDZWOBVsNA91dRA8yrkjM3NpnW5pLOC+JyjVgKYbCvgFPR+ruTnE3cV4HYo8ERVnucg4IQ3S18SaRFsBO9ozV5Fkybg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA1PR12MB9031.namprd12.prod.outlook.com (2603:10b6:208:3f9::19)
 by CY8PR12MB7705.namprd12.prod.outlook.com (2603:10b6:930:84::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.30; Mon, 21 Jul
 2025 07:00:14 +0000
Received: from IA1PR12MB9031.namprd12.prod.outlook.com
 ([fe80::1fb7:5076:77b5:559c]) by IA1PR12MB9031.namprd12.prod.outlook.com
 ([fe80::1fb7:5076:77b5:559c%6]) with mapi id 15.20.8943.029; Mon, 21 Jul 2025
 07:00:14 +0000
Date: Mon, 21 Jul 2025 07:00:02 +0000
From: Dragos Tatulea <dtatulea@nvidia.com>
To: Parav Pandit <parav@nvidia.com>, Christoph Hellwig <hch@infradead.org>, 
	Jakub Kicinski <kuba@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Andrew Lunn <andrew+netdev@lunn.ch>, Jens Axboe <axboe@kernel.dk>, Cosmin Ratiu <cratiu@nvidia.com>, 
	Tariq Toukan <tariqt@nvidia.com>, Pavel Begunkov <asml.silence@gmail.com>, 
	Mina Almasry <almasrymina@google.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
Subject: Re: [PATCH v2 net-next] net: Allow SF devices to be used for ZC DMA
Message-ID: <msagplmsxewgtlj5e2iynvv2fizrnvms6ccntilqygojactkdh@a5ei7ktu6xrv>
References: <20250711092634.2733340-2-dtatulea@nvidia.com>
 <20250714181136.7fd53312@kernel.org>
 <aHXbgr67d1l5atW8@infradead.org>
 <20250715060649.03b3798c@kernel.org>
 <aHeJfLYpkmwDvvN8@infradead.org>
 <CY8PR12MB71955664081E1B2B7BE5FAFCDC56A@CY8PR12MB7195.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CY8PR12MB71955664081E1B2B7BE5FAFCDC56A@CY8PR12MB7195.namprd12.prod.outlook.com>
X-ClientProxiedBy: TL2P290CA0003.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:2::20) To IA1PR12MB9031.namprd12.prod.outlook.com
 (2603:10b6:208:3f9::19)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR12MB9031:EE_|CY8PR12MB7705:EE_
X-MS-Office365-Filtering-Correlation-Id: cfa94698-67ab-4dcf-f59b-08ddc8243df5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?cfz3BE9CDtwF3v2FNuc9ujDbb+mp0GDyfPTJF9clN81gbCDLyBZ3Zg7kWdXD?=
 =?us-ascii?Q?bneXbAfqrGk2Yw0gJKMrFc0WPttDpqtq8ySS2g2BuBmnEq1XhUJRMp0noGV/?=
 =?us-ascii?Q?cdFVkpI8Hokj5HsYkRRip9MAxJNfPKwvPeKEbUl6BHxVFEPmIx7aWivBSXjI?=
 =?us-ascii?Q?voioy4BO5iyxILRxmYnGRQKJEYMoI63ChH14G4GgxFuszPTGOMWjmoTUgf98?=
 =?us-ascii?Q?G7KTFWrQP3DbV/lK3lent9gkTD1LYO/+78Hqv7HahnmgSOOZMvzms1u6lW5G?=
 =?us-ascii?Q?2kezqydIH0f3JNzOunUdHvI4SVPTs00h1dABRO3cmFdyqrAFGCnPPtq9zIQ0?=
 =?us-ascii?Q?SbM/zMb2hiXl4FQpULI6uAzO8j06+GyxSg1Vxw5ggBeEGWmO+KN8z0hKb4UK?=
 =?us-ascii?Q?2EGUfn53+sGyEvBGYZ0fCjJKHJbn3/YaHrJ2WlHjgYqtMab5S+jsAoFfGPPL?=
 =?us-ascii?Q?2lxCZ4fHI9eBjFYU/ZImz37O0KUJXDMw7X/YL4qIhLsbzhcnZDRr33BS0GhJ?=
 =?us-ascii?Q?S5zNHFpkFDEIwuRvwSY6LTg9oE/9HJIMecE8zSuuaeSTTrhHJ4eQwi5zzspD?=
 =?us-ascii?Q?JlSepAWL0JHI+yWvVMiMc3yf9aFKNj0gapd5IzzQyLoeyAVL7TePt9HwmIqA?=
 =?us-ascii?Q?0X5Vs58uh6USc6QFyf7ofS4vMVwk8xbrps5EQHSMJjVBOgYrMp2ttsMi3F2T?=
 =?us-ascii?Q?6Dgq4C0AXYsC0OSxCLh70ZD5B7GTGJrZwFsBHQCY4FcmlQqxwiA9Lbfw3Hwc?=
 =?us-ascii?Q?S2DnwfhpuzlPMU0dbncT7jDTCfvB8KkziktgFNESNzevGpYp7CzItZ8lKuka?=
 =?us-ascii?Q?AIYBGsA5ahkKjKkpv2LQmL42gOyw4jeOrT7pyeliAGFEQEhd0hcP5Vo0yBM4?=
 =?us-ascii?Q?2OvSSKxHRTph8uppg+Pldw7w6mfldHmVtfT8MdKqp7VfLVeG2awJ6HCTrsnc?=
 =?us-ascii?Q?HW3xXvtq47CXixat8h1C9c91Btl9upnPWWDD75v5uqw/pXTPpw6sSenqBw7r?=
 =?us-ascii?Q?pVfTmpM+wc/ko+083NPb0eJHzL8ERHLenjMLLB/BxRV8t7AvqmMx2DwXwPIx?=
 =?us-ascii?Q?Js0HuyqRnKRNat6y+IZNbI+v/Ys+AY9jWOkGPv/f6BJB6XR5HdhX4UdT85WT?=
 =?us-ascii?Q?kW4DHkpNyyrqP4GhvaeOtVstcvVcTRN7Zb+U2AN/1Pyb9J7yq7cUJMQvdFRZ?=
 =?us-ascii?Q?hdCaS1opr5z+ueRZO8HeO4uKG2hZeiw35mXAB190ZQbz5TUcI8JM/BFu+f2I?=
 =?us-ascii?Q?ij+k9G7HL0KkVQUu1ba3al4ymHHI467T2p171F7XSy/+4aYhfglGuNxaVMAC?=
 =?us-ascii?Q?2cYYb/dEII10WkHeBbqiYvjuS4zd8ZcHHqRjQIagKLnHh2HqFTR46ySGzVfU?=
 =?us-ascii?Q?hH6qLoJq2ve/qlGWLhWHyVP+Qglmylz9SLqvlTrLxtgJ+kyYQqmGEbEUpYI2?=
 =?us-ascii?Q?fqO/C+SMWZo=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB9031.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?NwrKnk68V6rMnZReRthAtQ/fpG3WMdGriQVP28LvfO2R25Ksl/DMtdW80qco?=
 =?us-ascii?Q?zaigSXqqSzFodSxepRsYDxag1yRKysKGf6iM/k7HuWGqZB7OZM9G3/QgSLg7?=
 =?us-ascii?Q?hRYRJRHLYhkvxyC8nSpO3KlWwFeJ6eGp7BgPyPLD29BhfVTOWuAGy4jC2+yg?=
 =?us-ascii?Q?3x22aMOCSJiSNky5Dk3k/I3605S/nBYoCtmSk7Tn6UOn7umqxUqqpZhZVZva?=
 =?us-ascii?Q?WBhIdFbMlBDGpH5jc6ZiyjqfDKqvnOve5d44fkbxWV/tV9hTPEN+KgOmvR6L?=
 =?us-ascii?Q?CV6TMjAkrEPfuUlJBeg14JAB8evaYV/9/MGdnz/AEwRIBq++RgtK7dWcTEAB?=
 =?us-ascii?Q?+DCqHIDPg4Q/seB2zDakGWm1ejHnp9J63hZt11Im/UmliXdPIuXtHYPVrJ9P?=
 =?us-ascii?Q?ajf+sTkHlffxtOBs4Kass5BiwfQsPjDZ6fRaaslFVaZnTxYlezvEk3sg75pV?=
 =?us-ascii?Q?pzSh5zB1t/EmjR0riFVQm/Jspkxx4Zx15lSmd02UxxJXxYLuljjGJ4lfPirZ?=
 =?us-ascii?Q?uliAexNscNr84rl0AdRLkxouyrnUpn7PZlJlp7tqS8970dhHqitisRjI9Cxe?=
 =?us-ascii?Q?W4gfyx8AshmeYzeYcH6lG6fE5RW5Mxeb8fIXYeGFE2b6mu0IDAJEscvjVpfL?=
 =?us-ascii?Q?LSBtt2c2N4IHcnA8QwDzU4qYkEKyx39sgj1UybROe8xWRKvE0FGzyrreMcxQ?=
 =?us-ascii?Q?pxLKOT7inA4AVyu0xbBW96pYh9oSawpSc98ahghnlCxbCWd1+y9xo9rHTzi7?=
 =?us-ascii?Q?FvxiUcbtHV3NpMOkCTMLiizrMO0GNZaxJI0rAv3kMLRo8o0m+FDJ++wOl0Ry?=
 =?us-ascii?Q?oizR2D3GVoB9qfSJAkCMhkzYgqtpwN+2l09p82MpCponuBwOVf4ZbFfzn8eD?=
 =?us-ascii?Q?Ulwyd6mIsdG/6DH22okIOlyQtyH6lGf5QCBY53qCLpllqh2JNM7J5lAG3ftq?=
 =?us-ascii?Q?8oIFlQqPjirx2TYPDVZDHYlpm6vHsVQs4Z/r1GIWcX7O9kSf+ZlAQ5vAdbQp?=
 =?us-ascii?Q?QtUKW80CNRcaVxRu44RiwJTv4XP995VBm6dPBJ+7JX5DOBKBAhtsUUNB1B0i?=
 =?us-ascii?Q?FaXa7mAoaQiZxNKNoT4cNsHXKJmF3pmbhZwZXeo2EUoeE2wmsQwu92F2BeyJ?=
 =?us-ascii?Q?3+xG7+XL0U5k39lHxYwNXzPhLTmkmT8C7olgUUDzuyCQH5ZDpFBT19GEfw7u?=
 =?us-ascii?Q?fNkcjOAfLi6HpQ6rsaM31lRRS7Qg4jP3LLV5++hqQ9Drxpxz+4fJK2zGMhV7?=
 =?us-ascii?Q?R7gGxPiVoDSHcW0Vc+HjNDwAUptYXJilTYPvGfTnQs9+m9ygm9TnTvUSaTBm?=
 =?us-ascii?Q?xNH2xD+LWTrxrBwzaJ1hbvgxIABCIiLsnrvDlGr1HDImFOirXfIwETJrmzY+?=
 =?us-ascii?Q?kgEG424WkpoYtzqQDTMLHaNIomkpUXNrimuRHBG13UUCVaKfHs3bnLUnXskI?=
 =?us-ascii?Q?IK/57u7eLYVcn2nGvJuamzw6XE1vt3SHRuxUtYP48vzA9vSn1do54P6w3OtM?=
 =?us-ascii?Q?avIBxitoBS5IVFx1IZQI7bgsKHIgO+9vZUXunt5erTVa5Pv0Lz6675xuiMrJ?=
 =?us-ascii?Q?I0q/M5IiG8PLzeU8Te482ZHJ/bh2swKBl4+v9q+6?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cfa94698-67ab-4dcf-f59b-08ddc8243df5
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB9031.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2025 07:00:14.2903
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ndFnUuNO5O7zx1tPK6AS7KBSDOxdyo4rIpD81wM+DaYqBkDLgBS3mQ2ZU8JeleMDlKAdXaAjW0VAcx/S9SP5hA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7705

On Wed, Jul 16, 2025 at 01:23:13PM +0200, Parav Pandit wrote:
> 
> > From: Christoph Hellwig <hch@infradead.org>
> > Sent: 16 July 2025 04:44 PM
> > 
> > On Tue, Jul 15, 2025 at 06:06:49AM -0700, Jakub Kicinski wrote:
> > > On Mon, 14 Jul 2025 21:39:30 -0700 Christoph Hellwig wrote:
> > > > > LGTM, but we need a better place for this function. netdevice.h is
> > > > > included directly by 1.5k files, and indirectly by probably another 5k.
> > > > > It's not a great place to put random helpers with 2 callers.
> > > > > Maybe net/netdev_rx_queue.h and net/core/netdev_rx_queue.c?
> > > > > I don't think it needs to be a static inline either.
> > > >
> > > > The whole concept is also buggy.  Trying to get a dma-able device by
> > > > walking down from an upper level construct like the netdevice can't
> > > > work reliably.  You'll need to explicitly provide the dma_device
> > > > using either a method or a pointer to it instead of this guesswork.
> > >
> > > Yeah, I'm pretty sure we'll end up with a method in queue ops.
> > > But it's not that deep, an easy thing to change.
> > 
> > Why not get this right now instead of adding more of the hacky parent
> > walking?
> The previous RFC version (v1) [1], the driver was explicitly providing dma_dev 
> at device level.
> Queue level is even better; it will address the Netdev with two pci devs socket direct use case too.
Yup. This was the second more generic proposal in the RFC [1].

> Not sure how difficult it is. 
> 
> Dragos can you please evaluate?
>
It is not difficult. But some changes are required in
net_devmem_bind_dmabuf() and its callers.

Will send a v3 with the changes.

> I believe the dma_mask check in [1] should be removed regardless.
> 
> [1] https://lore.kernel.org/netdev/20250702172433.1738947-2-dtatulea@nvidia.com/
Why is that? What if the parent device really doesn't support DMA?

[1] https://lore.kernel.org/netdev/22kf5wtxym5x3zllar7ek3onkav6nfzclf7w2lzifhebjme4jb@h4qycdqmwern/

Thanks,
Dragos

