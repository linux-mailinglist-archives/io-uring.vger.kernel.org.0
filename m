Return-Path: <io-uring+bounces-12055-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qLGRMmbWhGlo5gMAu9opvQ
	(envelope-from <io-uring+bounces-12055-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 05 Feb 2026 18:41:58 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5DDCBF611A
	for <lists+io-uring@lfdr.de>; Thu, 05 Feb 2026 18:41:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 7B8FA3016D28
	for <lists+io-uring@lfdr.de>; Thu,  5 Feb 2026 17:41:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 989EA2FD7C3;
	Thu,  5 Feb 2026 17:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="CjDF/j2n"
X-Original-To: io-uring@vger.kernel.org
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011013.outbound.protection.outlook.com [52.101.62.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44EA02F617D;
	Thu,  5 Feb 2026 17:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770313301; cv=fail; b=uRrx7UiISd0wCWPU47OSsvH96ltcWny7cslMnycW6oFaZrXsny7M0F55m0YRa82TMikTchefyWnnoCfWYbGIWExJzQtwCG4Z9DWVtPanZjOyl1oOqnBIJJJuFhO3xJsqpBhs8JE+w+W2GC9sMjcwUxwJCBVpF6yhOJC+mtDl8e8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770313301; c=relaxed/simple;
	bh=12YR3zjq5AXXNbH6VeMK6lgWS2cB25SvOu2Hx4DynpU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=lG2ZarNtKuX86sGmhsvKvpMvhBnSnK2MLI1ILpG9GM9imr2tv4e6eC6ZdU9whbV1hY2ZxK9aTL37wS6JynFNPG09ClgiByrHUEEqiEIi/GPSpxMzC560uPL2p7+GMz2xzelzJMSozLHR4t/alFcK59QTfFst9t+XAzQoAY/C4D0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=CjDF/j2n; arc=fail smtp.client-ip=52.101.62.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=C3Xh5uifUKC2ZVNdY9vyqOcz+Eraa6CrvNv0rob0VewLSHse1Wl8bDLWnlOapl3rPVA61GxXJEmBM4L2vFVYLC1y6ec6SoiSKW2eBB53fBQj1iALkD7PQvMTI3GQ9yJ+x/41tjQ5ww78wmeUkh7qSTIqhPb6X3KsNWNnHPhnT0wYFyn2brCfGfdP98meQ9VQrQ6RBwzHizCSThnRjIK7Iz03bHOLEcw5YnPUXriA7TndwQMsiOY9CNMll7pXT0zuvM8zimwmT3mVpvkHuvCYt0AGbxFJMJx0EU0LG5rHvPMhNkk2tFRRH4oVphXUuGYIqEwObrFt4D+LKtKPwwdkMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/UjN1EitWDhGyRmiDeCYmS6Ua/kDYSYiwqLTfo54qwk=;
 b=c2aDcaBKzXFiUgr+xaL9yol/+mC1+NndNJ4+GiTwbE2j1dS79xAkKJguMKRaWufUUKZrh+hDWFpDUaEor2XL5jp9HMrEsCdyXvoWps9CZAzMt6AlqJbPKyhByhErEU32d65Z3EUEzAERFZqa1LXiZt2nvWW/npqTYRFcm0J01DdFMrnkDLsfIX1+YUVnX70hwuiTnyfpb7e32IdJ8yEzBDxqfTSyuwqAqYvOl2/SQzuVo5rGTMbFO8l5cWqmyXNBStJl9iVHgC5IJ0CLHGmrfbXHl32hIc7ii9oQj6Pi44Tz3KN03p1cH4TQIcEzpkattu9ewl/99gZUn813lcmDPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/UjN1EitWDhGyRmiDeCYmS6Ua/kDYSYiwqLTfo54qwk=;
 b=CjDF/j2n37fHDTK/AtpZQ5kPL/yaePWaQbddl3D11gN8Q7sVlxDe+wvpDsL5WhAJNmHJ8OMQir0Tj2YzAnTZ1d5eTDydaSNjUA/Xy23cGl43B7vfUc4+Sp26H8lBzkW8999mvvTaBrkddmoqyNR3UJ619Qybc7yZsCgigW+DP6SxO1HwRiLJpK4QrxVIpmFTMjHK6btJs6y9F/EfJdN3bNpkOHwrU2nL+E/MafU8J4mMn8n7fQb4HqDLzoxbHWsA8X6o7LEqh6uZbqwHE6mDXxFo+Sa/YSgXy7NLL5OhHJ51C9wWtRmhN8+8jKgfYiwzxlmX8DfmQ25T90V/tunolw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY1PR12MB9601.namprd12.prod.outlook.com (2603:10b6:930:107::16)
 by MW4PR12MB7032.namprd12.prod.outlook.com (2603:10b6:303:1e9::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.16; Thu, 5 Feb
 2026 17:41:37 +0000
Received: from CY1PR12MB9601.namprd12.prod.outlook.com
 ([fe80::cd76:b497:475f:4de3]) by CY1PR12MB9601.namprd12.prod.outlook.com
 ([fe80::cd76:b497:475f:4de3%6]) with mapi id 15.20.9587.010; Thu, 5 Feb 2026
 17:41:37 +0000
Date: Thu, 5 Feb 2026 13:41:35 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: linux-block@vger.kernel.org, io-uring <io-uring@vger.kernel.org>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"Gohad, Tushar" <tushar.gohad@intel.com>,
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
	Christoph Hellwig <hch@lst.de>, Kanchan Joshi <joshi.k@samsung.com>,
	Anuj Gupta <anuj20.g@samsung.com>,
	Nitesh Shetty <nj.shetty@samsung.com>,
	"lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
Subject: Re: [LSF/MM/BPF TOPIC] dmabuf backed read/write
Message-ID: <20260205174135.GA444713@nvidia.com>
References: <4796d2f7-5300-4884-bd2e-3fcc7fdd7cea@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4796d2f7-5300-4884-bd2e-3fcc7fdd7cea@gmail.com>
X-ClientProxiedBy: MN2PR05CA0038.namprd05.prod.outlook.com
 (2603:10b6:208:236::7) To CY1PR12MB9601.namprd12.prod.outlook.com
 (2603:10b6:930:107::16)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY1PR12MB9601:EE_|MW4PR12MB7032:EE_
X-MS-Office365-Filtering-Correlation-Id: ff75421a-f588-47d9-ff54-08de64ddcfb0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?uj/ZrHOLav22e69oQr5xZFEiTQahJMt7D72pNWQ4hjMbgEP10ZWDQTIzR/bY?=
 =?us-ascii?Q?5hiLlRnFzJKwo4A6CtM5P8fyd8EZjiqvNbFWhvPwddM7njxkrg/cGQomifvx?=
 =?us-ascii?Q?wY0Z+ST2Rf98AOSRDf9VrMnbecGYwXCeujAHWYr9FeU2/LUjfe13us2bUH4F?=
 =?us-ascii?Q?wNTRIgZBaKbngbtQnNRDMG8T/0k09Sw+Jhrw5cjHdM8WTHSd/BvF6WZx+oxC?=
 =?us-ascii?Q?+lFr7Dc5jeiliThII4eQ8UkCP8QH5NJcSyZzVT0pHDKfLsBnBZClNpxTGiET?=
 =?us-ascii?Q?oGNHD/UHk4Yq4wDLOFftrma08myhg3Z988l1HML2VQssYGgJPhhbcZ4oaVov?=
 =?us-ascii?Q?mtlRdQVc2lBNHnJMfNMjpYsBq071OPFYP+9gBPxa2UXhArQkjwF8qCn2nYYQ?=
 =?us-ascii?Q?rfFoK2UYZxoemi08di+IxdTLLaj2JYg5GOg441WMbofn9r/h/6DhKegMrCRT?=
 =?us-ascii?Q?VdD4K3ynygJ374zzUN5PlULAm3CqsVDVr70oQmpA+9PExGZfYTYeCp1ozMsG?=
 =?us-ascii?Q?xHS3h0UZy/O3DQwlNuUPoJepW6ps3wmoWS1cXlkDamW+jHRtJyWH8FS0Exz4?=
 =?us-ascii?Q?1dAfTtqnboPgDUVehnaHblknuFQ2PHBH1nBlf6XClYWCZPRSIxQd7u/s1Wn3?=
 =?us-ascii?Q?StFW43k/Im2ngzhIQgJU0TJDaDrYgc1JzoEoBz1PGM2Wv8piY9TMuduOaHwz?=
 =?us-ascii?Q?wEbQe1JWQGf/01uzO211y2r3jtj1ILWBT5EQ+Ys1tpuHhs1rjLmmX+PVOR7k?=
 =?us-ascii?Q?eLY92C2H9L6muE1DtnrBViKx2UR98diNT6UYaAcCu60d7xGNGQ0m+BUJTxEE?=
 =?us-ascii?Q?qNVOEMmfrU3Dc6TlD90NJ69rKcIVcRWZO+3YCbGxFbnAknoZbQZCgp0Oa983?=
 =?us-ascii?Q?33Zxf0Upku4KGxaJsoSNbM2fw16EgM82xxO50QjbUPvTP54Z7ppfhOqfnSs3?=
 =?us-ascii?Q?u029XXc+mscyX9v6us0GyH0avtO5dDr+ChCwfjwFJv36RtMZueF+D2RZkint?=
 =?us-ascii?Q?Rc6UTe32xm933k5UMlIRypmjCMfYFeUiDVJ2QwxCmqyLHFBxGe93FNFNbi1v?=
 =?us-ascii?Q?A9/uPLgTIyi88m3GnG7mN7Cl7LiBTz/b7AO1t3MwXErIU7nZTRkQjPKoQBGP?=
 =?us-ascii?Q?Gp4QbJj5/AgN1yXGRHlLA8A8N9XZmNNugUSaXcOJe+9eBDSiFthdqPdzYxyP?=
 =?us-ascii?Q?UQUV9l8N7+ylzdk/dJnHVtx/+ia5t7DS8ByOW7Ajz55oRjOk4NfnKvN7iEGl?=
 =?us-ascii?Q?SQPTfJIoZJ7A2x21+BvGkjgWPZyi8siX0mj0ObqbfkI4rn2SEz/rSIWp9CIP?=
 =?us-ascii?Q?n9wpC5EV8hH3rUOTOMkwUfARBb8Aldb5+5GHs1k35EUPhteQVtZPis92kxzV?=
 =?us-ascii?Q?fL1WK7DzXc1c67bb2sxfjwEbbk1gD/LwCO9s+JZh4zSSta2AIUAJPQGZzSv5?=
 =?us-ascii?Q?3yFlf8/Fyta/Dm1bO0hXxzABUZ41hknov8pSO4h15QkiLHGC3c+v48RKQyeb?=
 =?us-ascii?Q?eYQM52vBtYjeruqpmihOafGCwKuOIpUMBGZte1D9D/QC/ALU7rnbKQI2ZyIp?=
 =?us-ascii?Q?p4vH3rKrnH8cdP2z22w=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY1PR12MB9601.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?nQdSYpJvZElZXjMh2WMwdV0CcqPNwpWXeqrESBHxZyd5YboziP/ZdsUmHGTR?=
 =?us-ascii?Q?3rQRZ85gqMv5LSlSthnOl5zIgmF2a49bJtLyZ+KOfMzWWyZ+87ZjxiVXD91S?=
 =?us-ascii?Q?+9IWa1fVc73BgY2hjrT6y4dcYhqdfUyLv8xvu55z82vMw4Rx+tePNNOAvf+V?=
 =?us-ascii?Q?B2fDsmWuGnkDQzdy19Aeox6B3MY3qqLaxAQhklXENE7FkhYI6oBJ4YG7Ao/a?=
 =?us-ascii?Q?JraF5WEGHly6FrU4pF5TFBHVE2q4gn0sKH/PlsXyFqdERaRFBQDs8SNHOQai?=
 =?us-ascii?Q?kcdP6+WpfS1Zpf8CjwcZiUHIfwShY8JXejhZ5GiXD9cWcR8fB7FvXP2/qj3H?=
 =?us-ascii?Q?/cFP/7paX+lxSckkrkGzzvm137yCkYnfPPnei+ip/qUb8l7IwMKyGdGQV+Zo?=
 =?us-ascii?Q?0EqENihUZ3uBG/bBf6qgu5O/OH1CQq8PmFqfRrxUSP38NPSqa8MXajxvLdXS?=
 =?us-ascii?Q?HRi/+tb9jIFXe1PtMfPUAdaJUyNu8zDyH/zWV8ziP8/KPHND0aBh8qb6K5Ol?=
 =?us-ascii?Q?xwtAVesHguPcpvXCwbE1HKYZeMx7Hcb5fjAan1DV06RGAOklKruVti6Hsl6N?=
 =?us-ascii?Q?Fr1oW0G9PtL6OBqve6qUr9JR+tP5Kgzp6OiaMjkoT0GLwZpYFl+u02G8QcRV?=
 =?us-ascii?Q?7U9vpQzc6xyNvGtCaTa0QEqOCKVtce9yONo4lK3KLJaeS1am8/qfFrv1vW4x?=
 =?us-ascii?Q?7V8Loj9BnjyAu4Jpbp/x1YyMkc6KmhCO1WiTs2Aa7G5fiouEkQL3rGoAh04Z?=
 =?us-ascii?Q?87BrPzoiUSTxBxLLh8IQfyO+Et7hY7AMP6kdz7NypKHpQtU+F0Zq12BqJrMK?=
 =?us-ascii?Q?kdKevpF0k5igjG8KXNVNd+dYUx0yJUmKHDGM5KhH1BwyRAYv056QF2opLJEv?=
 =?us-ascii?Q?txAL9EfSgrzTpL7YbH43xuGSru9bKAzUwOQLUJQy4xvavtN0yY0dgKdymFP+?=
 =?us-ascii?Q?/keDVsYZpbvBN1/DabyzhiPlLxUMt6D97JK5QIxz6PuOPTAU5e4t8ERt/9iC?=
 =?us-ascii?Q?56fJMJetBA/SbgrY8SMiMeABryijrceIyjHFFnI2MOIFNzhEEEh55E+b2nvy?=
 =?us-ascii?Q?Z0ekCtkxdNigw3OHHLWdX3OnzgI8JvTZw7ZpB2MT5TdEXgTKYAoy2FbtEIvU?=
 =?us-ascii?Q?6ixmEv6ItxlMvnxDTJkSbfEQ+NAmwkVsBj8O7st+9N3dEyMVhR1MQp6uq+5e?=
 =?us-ascii?Q?1Jd6Dh+zJTs8IGwtHhDjdzjH2K4mncxJX7+4PWLQ9M2chw15qpK+Meps9MPf?=
 =?us-ascii?Q?G+xK8EySwzMgroMVZx1e1i7fKlh1jqZUynFMKHAlVOsup7Z/AfvyS+Q5kSCA?=
 =?us-ascii?Q?e7tqH3Y2SXiwa2DXBCPk2+9B64TELXPZj2GWy6wNCsMOrTmLwSTJ35yvHa8l?=
 =?us-ascii?Q?Ib4BgC7O4x4/+tlHOfWPWp/BLSdoc9R0LANHcjOfFCSsMM08tVpxkav4FNs2?=
 =?us-ascii?Q?S/jeqsA4TycNhKdN4P6rUsaCvPF/MFqcdgJwpJi3D8834uFR4XflfhbepAHl?=
 =?us-ascii?Q?1KZu8ntT7P5laURgBkSdHvuYPZK1x1zyWMbYpO2QH+lmkYh+JmQvt5glqAA+?=
 =?us-ascii?Q?sg6U98mAJ4EEHM1OdxojlsXiwUekF4Jq0do3BSBCFJdOlNlI4BxfLnwAFGzG?=
 =?us-ascii?Q?whzsW7SWIjIZHZI3XE5xoFImmFX6Mnev2N4hpV4+AXSxvUu1KqdrXXzr9IMu?=
 =?us-ascii?Q?zlthV+FRMxmnWZZ2HdYItkvlmi2iKCad0bvuIIOi//MD4MD4sH/RP376cKFk?=
 =?us-ascii?Q?s90yvMws2A=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff75421a-f588-47d9-ff54-08de64ddcfb0
X-MS-Exchange-CrossTenant-AuthSource: CY1PR12MB9601.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2026 17:41:37.0992
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bTqwBcqHsVKwuAVLOx0/NkbdgrSEkH45lrZ/rCWPqsvOVDIJZe4DeyQRpV2eve1O
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7032
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.34 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[nvidia.com,reject];
	R_DKIM_ALLOW(-0.20)[Nvidia.com:s=selector2];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-12055-lists,io-uring=lfdr.de];
	FREEMAIL_TO(0.00)[gmail.com];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[Nvidia.com:+];
	MISSING_XM_UA(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jgg@nvidia.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	RCPT_COUNT_SEVEN(0.00)[11];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,nvidia.com:mid,Nvidia.com:dkim]
X-Rspamd-Queue-Id: 5DDCBF611A
X-Rspamd-Action: no action

On Tue, Feb 03, 2026 at 02:29:55PM +0000, Pavel Begunkov wrote:

> The proposal consists of two parts. The first is a small in-kernel
> framework that allows a dma-buf to be registered against a given file
> and returns an object representing a DMA mapping. 

What is this about and why would you need something like this?

The rest makes more sense - pass a DMABUF (or even memfd) to iouring
and pre-setup the DMA mapping to get dma_addr_t, then directly use
dma_addr_t through the entire block stack right into the eventual
driver.

> Tushar was helping and mention he got good numbers for P2P transfers
> compared to bouncing it via RAM. 

We can already avoid the bouncing, it seems the main improvements here
are avoiding the DMA map per-io and allowing the use of P2P without
also creating struct page. Meanginful wins for sure.

Jason

