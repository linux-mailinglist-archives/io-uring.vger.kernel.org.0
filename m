Return-Path: <io-uring+bounces-13105-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +Oz2Hi/f52kBCAIAu9opvQ
	(envelope-from <io-uring+bounces-13105-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 21 Apr 2026 22:33:51 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id CB4E843F7FE
	for <lists+io-uring@lfdr.de>; Tue, 21 Apr 2026 22:33:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BACD13005797
	for <lists+io-uring@lfdr.de>; Tue, 21 Apr 2026 20:29:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AC9734DCFF;
	Tue, 21 Apr 2026 20:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="rSK38VVt";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="nOwgJ5sb"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF87733F58C;
	Tue, 21 Apr 2026 20:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776803347; cv=fail; b=nR+laZV+COeBKnchhY8IVdhPi+8xMb+9V3BMBS9osRhE7Uu8DZAhsxEa1v0fjYsau+KXozgfBcFsK0FHUZOeCR6oqHTiOfl8V9KM/Qrm/SZ9EwDoN7GwH/+CCwNCU62d4nHrha5780WxCvJgUrLswKyDKpjTVCKwMKNly5NboNI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776803347; c=relaxed/simple;
	bh=wnXzDvYJZnCFlEw7BW85iKNm//we6E0G1FBvKP/zAZM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=MwhUe0MMq61pSuiQjGHte99dJfARluCKlw7Ze8u0rPD/EzactxzPIWbUk2XauGE6uoeYjO2LAChKrPvOplGvADEPvdDBIM0IUBFn/NSE+UI8ju67/10Gdq+5nSrvAWurmkfNWG+iXxoGLnu6UJelY2nYJmSIzgTpfd2TwWnHcVw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=rSK38VVt; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=nOwgJ5sb; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63LIb2mH4137553;
	Tue, 21 Apr 2026 20:28:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=F0QZL41byZWdbBJLDS
	4+958jdwm9Hi97R1vXacHmxyo=; b=rSK38VVt3rH727sQ9fWtvdUZ/3pmnOCJZ7
	XbxYx7VijKNlzDwtVTDRVATLzu2M4KIqPPlt+NZWseXXHYNSw+YUM7NDwVrdtPUP
	+L4L67+T3HZUssuarGB0aQ6KSNn89b9B8Dga+11q1ZZQZaXXXShqFHSddludlZ8X
	YFvkYP40+NaO2h0mo/CouGjNka820JThrjHcgFdtS2mv3Ymvprtrx8isCfthPsXx
	9qXjE+lk680KeSiNhI+cJXvtekntuQbJSuay8HzQpjuSIiC5+TyDABvby9BoLorM
	M88+On65nHUKtbdk0O3Lrs3gAHBMqfZ/DoSppPnHVreJbbGoRH2A==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dpenmg6bd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Apr 2026 20:28:58 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63LKQLxh020099;
	Tue, 21 Apr 2026 20:28:57 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010047.outbound.protection.outlook.com [52.101.46.47])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4dn19gjy71-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Apr 2026 20:28:57 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ORovLWRuxJbb+xBhJZUwONe/pmbtwaPL/Q7tHlyX/FBsLaTV6JVZKC/tzbRsqBB7eYgYXdwPFiQW0bTWDQEu0fUzqVjTR0SZNMAKMwQkQXtE8H5vtWl5LLdAXDh2MauyoebPba6YgpA9aLVjsJV4uOTeEXUVaLz+pQARzPhFTos9kl6ZBPbwhpt2sZcZfFa9oqNz2AZ0BVohgxn5nQ1Lwzw7rT+bSSG+VIcEAeIqe4/8hEZ6SJHXwgwe5SScqYPNUk409nigXTSHZBbEc3cUad9GyAD+kB0OrL8hQBHMP3R+0C99q6XJAYjQ/F1HClYRS/d65pQiMvBcQsefqbmxhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F0QZL41byZWdbBJLDS4+958jdwm9Hi97R1vXacHmxyo=;
 b=K/vm51RC9oZdpIIroGmB8uAd3Ix2t/aaHAjFlX63/20QFhhdxInaxdOnmARw8qHUow8IU0paJ4uCgQ/5dSv1JpgmZ4iFbz1sCIVZ3fOVh+tKGKekMpJh/wEeeGUMB3jlTRamZzXaIb/BnDJt8QITjOKP80cBg6OiwonNxi0kRRJna7BmMp4xDRgs+ewk+O9Srqnc0DkHTW0CwcRXbU0K8q7K9FiPmrfUwFWO7GCt97sJIOnK/3Bf4sc7QX9F5Nmcqj7cTMJlj+hqQh7uSyKEOVHlbyH/uKVgEqaSz8omm32eg6QbZVdlpE8L5nu+xgy8mVhpsa/p2Xl1SDrUDhFumw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F0QZL41byZWdbBJLDS4+958jdwm9Hi97R1vXacHmxyo=;
 b=nOwgJ5sbXiEMEbf1pzjti2Qa1HAH2b9X9iJbxMbC/HPkkTg3rTAAxU1FT8l/3wAXtiHY5sixdakv5I4MDXhvFyJjdvn/bBCmGTaV4iyWekAQPk4PDuolN/Hu/uWOqrpGfiBAbon9w41C7KpETm66xN/0pAX9qtl8Xzb0GsYAyq8=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by MN6PR10MB8118.namprd10.prod.outlook.com (2603:10b6:208:4fa::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.32; Tue, 21 Apr
 2026 20:28:54 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9818.033; Tue, 21 Apr 2026
 20:28:54 +0000
Date: Tue, 21 Apr 2026 16:28:39 -0400
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Ming Lei <tom.leiming@gmail.com>, io-uring <io-uring@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Subject: Re: RCU warning off ublk_buf_cleanup() -> mas_for_each()
Message-ID: <qyob3dbqkicviyjs77q6mmxldtwm6qdpgwznzw6ulipztphlbl@nb4bzctzlsnw>
References: <0349d72d-dff8-4f9f-b448-919fa5ae96da@kernel.dk>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0349d72d-dff8-4f9f-b448-919fa5ae96da@kernel.dk>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: YT4PR01CA0317.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10a::10) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|MN6PR10MB8118:EE_
X-MS-Office365-Filtering-Correlation-Id: 43f1ce41-451d-43aa-ddf6-08de9fe49b54
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	GSqx8HMo2xaTRrlL1iyJSJ3NrPON6ckWj68D/NGEVkchhqRDMeYKeTGHwvamUat3x7Sux3wEA2uxh/JsFAw+LqUhJucQj1HryQTJFR2WyTPuwy4ug4QYlc40RzXFS53GMlwpbrrQw7HBGRoNkGDt4wnAtbSrh+o0JYm6BeD9mPCpuDlA9hWti92jwzttLh1jFm5znXoAAqbg1gWAp7U6P86nkTbIn5PhrpPIOp3NcB5jAsaQtibtgVod1eEVqFbDGiEImiSCYFqq0aetzLecRPf/bCcf+4Kx6Oe5P4GYmbAgKECrT81UebtnHetnj3wqfSNI5zhAtNEZPfaKIEfWhmA12VU5DUXJwcnCFDrYDykuBmvw2oY2gAA6glFe1WIp7JS3Bxuq4K/pgly5SG/GsCp6zusfiBDlOCJprGM88CoM22NScmvfH5/BuvtkVPBo7NJctyiaYgGsZrz8vJxOD7EUbFm7k9alyRZ64Iv6pwuTm9pd/NeZifXrOyXldB0dA7TuxFZC5X2Y2OuroeNZqQN48XTXuNvtswRyzJJLSWjklSlqO+iBr0a1BzE6ZulCzGrtMddgdFZnc2z5CiXMEJESA+UfWYpWTv0PEsAXY1Q4ibFo+AYXHLUl/NTil4l3JrkbiLL5mODr1oY7+fyA90ANd9JmPXM0RUiqvaImxZPnTwVYNRn9kZ6Pw64fBR8pdOwKJ0X8c5g8Kg39KUlhw/8T0QCwdcDfVqbddwzQrXM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?r3nVuiNiq+rIuZ8lTiFCAsn7xC5VrK8/oiQpSlndv9jRaSpgDch8NDPpJlp1?=
 =?us-ascii?Q?pfUNEQuKKchpsi19rdn8ZlP0K6RAD/i5eVcBrmtOVmzHDNPoJRmaAgNioKdy?=
 =?us-ascii?Q?LFkI+wpAVEyrOwHbAJXUJnBK1o9QBeXP8R5wPbOaOJSy4GMHudkiEuyeVYtT?=
 =?us-ascii?Q?l9dsRJ/7vb2aXJaP/AZcir0ZtHjRB4MjUqoLYVrZw3/dmU81he0oIkdgn193?=
 =?us-ascii?Q?HEbZUEe1vySyZkCZqt6GFFON56ZJvT5NsR1xS7S1qBNUwynOB6DaVmnBbXK1?=
 =?us-ascii?Q?4bLej9a5CoxBwfdXFpEVQT/w0Rdi9cQQSYpMYimrZoWu8UyLpywZXldUCnIV?=
 =?us-ascii?Q?+0MiozUa36GjaSbs4bbxUCPkq6ElHAszbGaHQe7GfIrF7aob0GEYgSsoEfxJ?=
 =?us-ascii?Q?v0+iy1G4RbsMeiKCHdgFgZGIHARAcJVIj+DBdHYJPOXfMxYJ5dGErpx1OtKS?=
 =?us-ascii?Q?xuxI55swpAXnIIG87Xxwrm6fI2VeGVd+XjycPDOCOvTd2w/NPMShC2mq7Fgk?=
 =?us-ascii?Q?iOegJIsZz5mGiQEtLl8abfrGVmP4kKHV38wFb5Svk9AQ/bUtp2DhEAfwU+xk?=
 =?us-ascii?Q?jRtpHR6jOQcFXN7et+UlFcT5gna4+BCeLXsr/a2kLxAOBwdLpTCmVXdTlqr4?=
 =?us-ascii?Q?HanBDFbwMYpAKYGhmYYSvMMX8fWgrx5VXbKZABKVBCYdqQ5dwfg8N3Q0xRmk?=
 =?us-ascii?Q?h/x7Y7xnx6QIkrgdsM32ny7Wa89ZygnYVnZjfCyNFXP9O4vmGBLwSinoMy9K?=
 =?us-ascii?Q?TIsnXZyKfecKXbahevAE1ISSHG1ZIb0EXgNFWNTCHeMKozq14Yn4WdOVJ57+?=
 =?us-ascii?Q?RGJai17HC/LnMOnfkpS4/+6ycU5847MELuTaB75dqdNzTGegkY2iRIix715Y?=
 =?us-ascii?Q?MS5dl6ArZH7IqBPUPpUmxpujytaWSecrRgUwW7dx5bperm7FqTRFTY09cECX?=
 =?us-ascii?Q?FUl6FNL19qLbKN78/hJ/xMmnOnhQ1Q8zoCwZjx3Jm5vC0h7Txb6nnTG8Cpuf?=
 =?us-ascii?Q?0xNiC5aj16c/lJszUQHXo3/VJHp1YAuBOEijvMkF8IBlA+XsblD/n/5RyESS?=
 =?us-ascii?Q?MPF/ZBg0ILSZuddk2WNttyJ8EX1hqj1tWmCTmntZUQt0jJrYRiTGZrSUBR/t?=
 =?us-ascii?Q?oauGytb+pcjcTkKBS0maQ5SEuxLcuRPXAJynUsDmXVEe6kM6SHa8fJLAmmRs?=
 =?us-ascii?Q?t+uKrCk2aMa6ytYz7Q8UcbgI9HlcYcDzMM5IlQrswxBp8Kf9+QqRvkS3HUn3?=
 =?us-ascii?Q?4U0BnUVuPg6mSikQTjrTd2e9WKQdHcp6j68/M7Avfc5Mzg1cjO05oLVRYlgn?=
 =?us-ascii?Q?SVANCjxok0L4My/OhmRsiSzG6eYUQ556wGLXnta0uQxqw5nP5sx4qNkDWdf2?=
 =?us-ascii?Q?4JUiHDqtQEZBRika4Bp+z1JQkW21UIPUzMG8QFkQmcxjzZJwV8sLh2LYklrA?=
 =?us-ascii?Q?Cs25TN3sAoUj3i5vlZ18oYuYVlPeuxt9i6m5ScPYcRWdbnXpjmvE5G/1yV4T?=
 =?us-ascii?Q?iVQkdoV32Pirabm9lFMwsCoyP21UUIWZj7EZDRillZGxffgRKBr6OCBd1WkL?=
 =?us-ascii?Q?ey3zAS0xuUoaW42d1TgEBHh6DXdoL2V58DqTJcgBtPsJBZZdlfIKANnIT5QQ?=
 =?us-ascii?Q?akoejBIW/w2SFBpdRrmfbHDxmNDc9LTcxhdHOf4OW3n99PAIzz1co84V0zc6?=
 =?us-ascii?Q?7yeIwyUsIRoYcNZ3SZvw288LeSWHfaB8NCPJvMdX1Ai6BetHiZLH/n/okm58?=
 =?us-ascii?Q?OG9+LuOV1w=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	QhwpaoL5VoF0mpptIIKf1wiyr4bPXQpEBsveUDFC3WYL80X5OYqW3LFV/1WbmizK8IFeHL66PRLDHOd2eEn2gNeIsArwE3PHE9G8/SrIsN3M1vsjFo4I/d157UkW8ty87oJ+0YH5SJrF+pLtBHlW+6h6A0u0X7QaDrGwCwJ2efroju/FvObFOY8/dX0CEV4OuPA3D+LRHv3XB2PGi+TUCpBAZ941G9lB3HzJti43g2XeNBSq88+006MhK2KsPyQTS8Jtuof9NhGRiuM7WAyUEZzqxyOUx8paVbLtN4RcrXaTrxUCve8NpYEnwq4THdXpxmVJbXf3Ga/BQCdMmvQa+g==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	KaBsmJBdGZ7Xcy1vKb+NvaItkOSHHlKjJIFAk7JBf08OuLh55rqQvjzNPXYVmCVv1pAegY9mKcees/77h3smmYE+ysMEPDhjFKbfn2sbGQ4By0J46QuAznW1TtqkHqWoF1Bf4P1kabXbeU8P/2YtuYNgDqS8QuEU8KH92LIdyZ93ysjR8GCPNoT0OUm3XSNYPW/HxKOUs5LcYtGOwp+NtxO3HooFtVz7FZ6GnZnHrxfov5ivXkuZnRfquCmDcS3RENBadOcfw5YJvXQOayxm8Vyzk5N4G1i/90vy8mvG6f9AJouVw0JWRTEckBPXKZve6/h5lONce05QIyZJCEzOt2dm4vT0Mh73OK2EuF4AiDLM04xJBZBrlb9g/60AMy2rNuQ5hmT7QCGFbL54sxZSaj7HdJ3QLMwAXhip9lYwPb1+8fJMf5EYA1Ra3DFpRNJZG3JZD5H0wMI4F0yWVOxNC5WP1Uy6fubDmNYQR1FQ8D4o2sMobZgIJvXYiXF1z6eivypB/TApLzlAB/UD74VqGpKGLGWRkuExTj6tegcznA30wxhn19KMObtiFYhbmxgbT5RiJE09DG3fGUtaaHRNmGt93dDZMUYbvWnIn8pQc3A=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43f1ce41-451d-43aa-ddf6-08de9fe49b54
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2026 20:28:54.2102
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S2fS9LFDTFcgpO7/qDqi4KEmmfWae7PRMp2fgvSQus0vXrl6h2lVNLgDvErR38P2dX4F6epht5IcAtZ6Vg8Mzw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR10MB8118
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-21_03,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 lowpriorityscore=0 suspectscore=0 malwarescore=0 spamscore=0 mlxscore=0
 phishscore=0 bulkscore=0 mlxlogscore=772 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2604070000 definitions=main-2604210203
X-Authority-Analysis: v=2.4 cv=PsSjqQM3 c=1 sm=1 tr=0 ts=69e7de0a b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=A5OVakUREuEA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x4eqshVgHu-cdnggieHk:22 a=4FB8OatBTTTgXyZOUkIA:9
 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12292
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDIxMDIwMyBTYWx0ZWRfX1GNdk6lf/Zm+
 KiKj12DjEh6vTEOfVF4ttl8Juf1ODB7RU7IvoPj6awr7Jv6+K7es7x0vMfXLE2Lp9kLkoGG6hSE
 IrDOI5CydnuVh++UIF+4ZCmAg3gBFm/Y9w1iUV68FquKm+24VrQCeC1UvcxG9w85DfjMvEnVXrp
 Yiu10jLkwolw8Sk0sjy0ml3nxmdgOe8U/g3GgCKnvswKecC1ynUV0S4+k3oog6fJtyp3Ya2tNFc
 rsudfuLGJKCNFwPjiNYCyjExzt0PVVrRDk6JV/JBPHCH8jHYduAcv9gMZhPsnHe1fv2oZpBcLiw
 aRvG6w58wxRZFkKaqtSLQ4Bimy/ut5T5Sqo/GPCmt2HrE2Dt1Vt7dFamHeyY/WwsI1bVt6VXNqb
 z/njTaD1koT7XzzDSOYUFnKgAx8NMV3tblYoDNZpEBtkAiZoCirKlsiUAks1Zrxf9kC6SH6UPmd
 9x3Jm/GRIVZFpvSxZLEiJC8h+H7cEVB+Its5H3b0=
X-Proofpoint-GUID: du-uNb0a7l2i815kdpZW2DOdruRGsAqM
X-Proofpoint-ORIG-GUID: du-uNb0a7l2i815kdpZW2DOdruRGsAqM
X-Spamd-Result: default: False [0.34 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[oracle.com,reject];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[oracle.com:s=corp-2025-04-25,oracle.onmicrosoft.com:s=selector2-oracle-onmicrosoft-com];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13105-lists,io-uring=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[oracle.com:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,oracle.onmicrosoft.com:dkim,kernel.dk:email];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	TO_DN_SOME(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[oracle.com:+,oracle.onmicrosoft.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[Liam.Howlett@oracle.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_COUNT_SEVEN(0.00)[9]
X-Rspamd-Queue-Id: CB4E843F7FE
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

* Jens Axboe <axboe@kernel.dk> [260421 13:47]:
> Hi Ming,
> 
> Ran into the below running tests on the current tree:
> 
> =============================
> WARNING: suspicious RCU usage
> 7.0.0+ #16 Tainted: G                 N 
> -----------------------------
> lib/maple_tree.c:759 suspicious rcu_dereference_check() usage!
> 
> other info that might help us debug this:
> 
> 
> rcu_scheduler_active = 2, debug_locks = 1
> 1 lock held by iou-wrk-55535/55536:
>  #0: ffff800085a451a0 (ublk_ctl_mutex){+.+.}-{4:4}, at: ublk_ctrl_del_dev+0xdc/0x2f8
> 
> stack backtrace:
> CPU: 4 UID: 0 PID: 55536 Comm: iou-wrk-55535 Tainted: G                 N  7.0.0+ #16 PREEMPT 
> Tainted: [N]=TEST
> Hardware name: linux,dummy-virt (DT)
> Call trace:
>  show_stack+0x1c/0x30 (C)
>  dump_stack_lvl+0x68/0x90
>  dump_stack+0x18/0x20
>  lockdep_rcu_suspicious+0x170/0x200
>  mas_walk+0x3f0/0x6a0
>  mas_find+0x1b4/0x6b0
>  ublk_buf_cleanup+0xe0/0x240
>  ublk_cdev_rel+0x34/0x1b0
>  device_release+0xa4/0x350
>  kobject_put+0x138/0x250
>  put_device+0x18/0x30
>  ublk_put_device+0x18/0x28
>  ublk_ctrl_del_dev+0x120/0x2f8
>  ublk_ctrl_uring_cmd+0x598/0x29b8
>  io_uring_cmd+0x1e0/0x468
>  __io_issue_sqe+0xa4/0x748
>  io_issue_sqe+0x80/0xf68
>  io_wq_submit_work+0x26c/0xdc8
>  io_worker_handle_work+0x334/0xf20
>  io_wq_worker+0x278/0x9e8
>  ret_from_fork+0x10/0x20
> Buffer I/O error on dev ublkb0, logical block 0, async page read
> Buffer I/O error on dev ublkb0, logical block 0, async page read
>  ublkb0: unable to read partition table
> Buffer I/O error on dev ublkb0, logical block 0, async page read
> Buffer I/O error on dev ublkb0, logical block 0, async page read
> Buffer I/O error on dev ublkb0, logical block 512, async page read
> Buffer I/O error on dev ublkb0, logical block 512, async page read
> Buffer I/O error on dev ublkb0, logical block 0, async page read
> Buffer I/O error on dev ublkb0, logical block 512, async page read
> 
> and I briefly looked at it, but then just gave up as a) the maple tree
> documentation is not that detailed,

Which documentation is lacking?  I will fix it.

I have user documentation in the Documentation directory while
technical details are in the code.


>and b) other in-tree users also just
> call mas_for_each() without either a lock held or RCU read side locked.

mas_for_each() must hold a lock of some type.

> 
> Adding Liam for shedding some light on this...
> 
> -- 
> Jens Axboe
> 

