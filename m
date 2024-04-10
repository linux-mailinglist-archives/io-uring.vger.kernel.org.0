Return-Path: <io-uring+bounces-1493-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CE83C89EDAF
	for <lists+io-uring@lfdr.de>; Wed, 10 Apr 2024 10:35:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 458941F21A49
	for <lists+io-uring@lfdr.de>; Wed, 10 Apr 2024 08:35:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A2C413E3F3;
	Wed, 10 Apr 2024 08:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="U/t3XLwb";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="zMNU5gW3"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBB2513D2A8;
	Wed, 10 Apr 2024 08:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712738127; cv=fail; b=o3AHfPw6iClyCB3+FQjYW16oQHsfdteOrIU/MyobBQ9Nrn+kQ452IwyGoxV6Emz5t3QiW+ulgRunJ6QjXCReuZTgu/FJz3Uu6L7Dm6FDGrqQhgnXlhssncYIACOfz0Rq1u3tqyFOJjJECPBkJUHGH0jt/ld02VGkbtQ8k0NlMCw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712738127; c=relaxed/simple;
	bh=mD8idWZh94jmZ51x9ZdFK5YTbf9qkaUveaAO1cr69IE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ZpgPebiA5rY/WBmdo6HJPlT8JSowQ0zDlvd4Q1Aw4JGdKXQsMTTyOip5GrMflLfxqlP3CU/STQL+75r+FxgjMJU5ngPqeZFEHhp7slZH1PaoMIxAgklVZmQA6lynCVRTzw0Hp9Zy2nRL0Aw2Mu0x965eit68o63uPng+DyRqTWA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=U/t3XLwb; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=zMNU5gW3; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43A7k01M007116;
	Wed, 10 Apr 2024 08:34:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=C4cnDbqcnzUuVa36QWDeAikh/rp+howtodKe+CcyDYc=;
 b=U/t3XLwb935E5DEhPAWPDEG/dNGc/dQsmBWkEKijNztVPmL5B0Cd4REpPWZBSqKjjuJ1
 Sw4CWutw1EwMOigxi7P9lSqP5qcUQFAKi3NDrp+T7VPc9yq0Du8/h1Q18JcSb5kqm7l6
 fZ5AYT32rbjgUl17+YrCu/95zHCbhvUfFF6+N1JsIMSKiJOPbETVBBcDR20fLLcXc/Gk
 HKWtKVCGEut0JiMoK+/4z+s8a1AOQ87zNOs3d6duOVd+qKBrwDXeUHT15ILyKfr71aXm
 KBhPWb9AE8e300SZyzZ3HXphies4vzM96rVeP0ojt/BPb3TsVd8oize1fc49eX33ZTjB 2w== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xaxedpv3w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Apr 2024 08:34:45 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 43A74keh003019;
	Wed, 10 Apr 2024 08:34:45 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3xavue3974-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Apr 2024 08:34:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eb1wLZn2BPqNeUMb7sid3X+tO7JdnN2aidmTvxHUS+zsTIH/g8ltEBPQbbgBefYVTAObS1LeeygmFHaCwv1sOT8jTlcPV3hGsQHwyEf7b7Kzr8/9Gbu284vjnA6G0qzHsPV5GW3wNV/FXRBtTNgM4q4x18q3WqO/uYtgWbYn6Ga1sqdB0P0jg0kkA2ZHFgly7Ld5mpX/P+CTUOzjRUMfNnGX2QxnDc7+oJEaMxqr6hhLAy4z9u/SA8LNqO7gxYOQL53/CM3cn/mZC0EJehNuP7vHBMo/xfpy6mm0CTMZmzqdbAOcBaMsw8PGDfzLOP5XYjT+2vC0YaJEna6e3f3UbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C4cnDbqcnzUuVa36QWDeAikh/rp+howtodKe+CcyDYc=;
 b=Um4JeQ/8462UKqw8rsxN6vTyWpbP/if6k4navfXfEuf3hZzOzvlXVcAN/dEIy5b8Q3OHwFu/QRTcNJhxjClTc8jGoWDg41XmQWu9Xq0pFq7pTY+wEJf2rdjYX/YW+9FWWYNlwwbZ5VV+bQYBu/Qoe8EoAw46WL83Fcld/wDg6VcIkcS9ChmrVYgar0Xr3mjesmU/xtvwbZYCkxJz6qCS9Pt+PPZPbkN2t0+kBaHJSxca6oP71zjFRqAiCaQ/I6K8ssk+83U2uuchM0bplzBSl6xGYrEfwoVsK9yNbrMsMP54p1mRXcECEVdComXYOgWqzfEsmn9U7FFZ6Nf1yS+nFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C4cnDbqcnzUuVa36QWDeAikh/rp+howtodKe+CcyDYc=;
 b=zMNU5gW390wmwcORZztEYZ/lF5tr9jA/Bh8kWSetjgNWSxCqF9QhFkCJz9J47fx7fVeEtNGSi7k9d0nbOVxSR9uf1AGsTS83atkv/cYdXYGFOlDw/aCoiOkKXCUj5qSFAqIqf5tC92ObyOj9BQpm1amo/wXgWl3ta2E1T+RN6xo=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CH0PR10MB4908.namprd10.prod.outlook.com (2603:10b6:610:cb::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.46; Wed, 10 Apr
 2024 08:34:43 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ae68:7d51:133f:324]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ae68:7d51:133f:324%4]) with mapi id 15.20.7409.042; Wed, 10 Apr 2024
 08:34:43 +0000
Message-ID: <b0789a97-7dcf-48aa-9980-8525942dabfa@oracle.com>
Date: Wed, 10 Apr 2024 09:34:36 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 00/10] block atomic writes
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>,
        Pankaj Raghav
 <p.raghav@samsung.com>,
        Daniel Gomez <da.gomez@samsung.com>,
        =?UTF-8?Q?Javier_Gonz=C3=A1lez?= <javier.gonz@samsung.com>,
        axboe@kernel.dk, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me,
        jejb@linux.ibm.com, martin.petersen@oracle.com, djwong@kernel.org,
        viro@zeniv.linux.org.uk, brauner@kernel.org, dchinner@redhat.com,
        jack@suse.cz, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-fsdevel@vger.kernel.org, tytso@mit.edu, jbongio@google.com,
        linux-scsi@vger.kernel.org, ojaswin@linux.ibm.com, linux-aio@kvack.org,
        linux-btrfs@vger.kernel.org, io-uring@vger.kernel.org,
        nilay@linux.ibm.com, ritesh.list@gmail.com
References: <20240326133813.3224593-1-john.g.garry@oracle.com>
 <ZgOXb_oZjsUU12YL@casper.infradead.org>
 <c4c0dad5-41a4-44b4-8f40-2a250571180b@oracle.com>
 <Zg7Z4aJtn3SxY5w1@casper.infradead.org>
 <f3c1d321-0dfc-466f-9f6a-fe2f0513d944@oracle.com>
 <ZhQud1NbO4aMt0MH@bombadil.infradead.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <ZhQud1NbO4aMt0MH@bombadil.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0178.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18a::21) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CH0PR10MB4908:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	c1tVDOe5rNDBkZP5GGOudgxnEoBMnKi5WzC1N/9JR3k1kVRM1hrelBD4uMOCzuyoWEFISpNpLUWj+rhwD5KwSv+X0v289tS7nBPKZv+D/H4yhmk7yhyHOf4kMZ/3IWN9rS/23l9hVQl4BGnBS8X8F+oMmrEJDRSwhTHssaVgyZTdVKNlUhtYSr5CAv1YY/S7GCBlFkNceVscpZ2U+7BqF6ESDoU597tJr/Npv4LSyKNJiKSJ94VxW+niERjlVNa3ahNGGvMlgyl29nMoUsEio1cii9GUfVOaAEHgHWjOReF4ln4lygoszEAFUXdDzwgI3tpYNZIJD0W3cyXV70RYrg+GWSk471sxR3D5mvlQifsXTh/zZ3dkzTBYzqCWWzWNuS7IIg6pGPXHZWpvt7OuDpzI33pycwRKQrPKwqS5drMp/bLQL7riuwxZYuS7EKvH/8h4+u506rchnIZtC673+39nMQdAJ85a1TrmHTQi7itg50pkjqutSj82U1of37Ep+DHNsH7hW2HRJLKv7gkBeKeCL9DzU0zzS4mIcAS28mzWU5kBiqtvTxkgPy4YNLzizXLhuQ7BX+QU5kF9xOaSrYJYtl0EHQjTXZXmDYIekW56RzZIiGVi0p1iMwRKK2GG4XwU1gjoHl2Ztg+JOd2e+IMhh+oWuQH+R+/TkgR8hws=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(7416005)(366007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?MnU5OVFHc0h5TzgrVzF2WDhoTjZTZVh4QUM1cEZPNkVGODJSRkkxRkd5SUxW?=
 =?utf-8?B?dXdiZ04wRXA1Mi9IS2lDUVdVZUQyYklHb2lwRlBMd0ZoZFBJT0JtcFNnSFhL?=
 =?utf-8?B?TDZ2T1pIdVlMYzgvbU9NZmNQcmlCUWN0aURVUHFmZXVpZWZFM3Y4ZW9JYzgy?=
 =?utf-8?B?Tk1aUzMxNldENmZTc1pFWE5PQnBUYkJQcC9VelpxRnpSbGRUN1d1bnZSMi9P?=
 =?utf-8?B?eWJyRzdCa2ZnVmlXT01iNWtLMTRWWENRd1ZVQXluMm1yb29OdjVhSFRsTDNR?=
 =?utf-8?B?VXU4UVA3RnBNZUZGbGJhZEFtU216Q0FWekdFTmFyYkhySVY1YjAxdENjSURG?=
 =?utf-8?B?a2ZaS1RJeU9aVDE0d0xsUkd1Zk9PM2FkTE43TDV2R2N0c2djRFMwTm9lY0FM?=
 =?utf-8?B?U3lGVnN2UEJmUFFDc1dpczVDNUdIYkQzTHFJQXNyVk8vSXFGakE1cHpFTEdC?=
 =?utf-8?B?QUtXWjVQRFk4UVB4Qk9ta0c1b2VoZm1pUGltNWNjZU1HSldhTVU0eVVxTE9N?=
 =?utf-8?B?dDNadlBLaktucXZPUDJscTJxcVZQR0x1L3NKU3BNTmNkTFRRT0ZFb0FGV3FZ?=
 =?utf-8?B?aDROdVltMmhFTzUrQndKT0ZWM0RLN3d6K0xIbFdHZW5hdHQwMFN0M214Vk1r?=
 =?utf-8?B?VW5vc1pDc05NZXhwR2s0S0JlVFBQVkFlUGNPbFJCQWZXd05IblNSbnNTVmdR?=
 =?utf-8?B?cTB6TlgrRm9TVEdVWXZNWExtR2ZxVEJkRm1QQ1dtcm9HUlV3dUpOdVNqT0Yz?=
 =?utf-8?B?UVJPajhWekp4WGxwbTNCYkhTWm1rOFlPeC9GRVhUTkg2VWNvR1pBbkhwaklh?=
 =?utf-8?B?b3NSZStRMXJjTndJbHBjOGU5MUV5YnhhYXVHNE9qNmJJN1hCNlZCUy9Bdm1H?=
 =?utf-8?B?UExJL2ZLVDl2bGdJRHZhSjFkeDRTU1ljMXdPRnZLdStJNHhYV3ljRTE1Mit6?=
 =?utf-8?B?OVlkTjA1Y09wUzBwb202NHp4RTd4MzM5TmRlZjFlM3lIcEczV3J0Rk1VL0d6?=
 =?utf-8?B?MzRGMVpZeUFzc3B4cDlNUURUcXVuVFkwMVNqdmg5ekRIN0FXVFdPNlNsc0tl?=
 =?utf-8?B?KzQ3dVhGN3BVVldycWl1RlRLNkt0d3d0d1k1T2IwbmZEUVN1M3dBVzg5Y2Rn?=
 =?utf-8?B?VlJ5ZGd0dFdyWjRlQXFxdE1zKzdHd25BdjdFUE1KcmUvTXBjeDJNOURpMWth?=
 =?utf-8?B?YnZiMXJMb3N3TG92QTlITW1JREMrbjYzZFJxWXJVZWYvUVArRm5iNWpEYmtK?=
 =?utf-8?B?SEVRTlNOS3B3WTBmSDh6S2FQSy9BUi9TRlJLWFRoeDdxZWFheXJpejBxdU9B?=
 =?utf-8?B?Tzg4Mm0rcmpld2x4MjVGZnRFR2tCa09rT1g0bWsxTURRRTIxWXhOWWh2S3o5?=
 =?utf-8?B?UTh0aElvcTgydGdHb0RBNm11TlRtU3o2bnppTXUzell0VitjQVNFK280Y0hP?=
 =?utf-8?B?Vk84bEsxL25OVUplVFowTVlNaCtZOFo5b0daN2FXQUpodDBVMnhFOWxhOWtF?=
 =?utf-8?B?WGVtYm1vNlJ6bUtFc1dTbnErN2xEclZjZ1J1aHp2SUwyQXlCTWVTNXVhaVFo?=
 =?utf-8?B?NVgwNGN4UWNpQVFvbFZUZmpBWmFiUU52aGZHelNEcFo2UDQ2empIL2lSM0E4?=
 =?utf-8?B?Wk1zVmhxQXYrYW5EcFM1RWhQNy9neEpoUGpBRjFiazVWeGd1OGphSzFRVVVU?=
 =?utf-8?B?N1FPNlI2TUpqeUpiSGk1Z210OC9PQjhvbWVyUGNDQmNhNmlTc245VnhQb1Bw?=
 =?utf-8?B?WWFzckJEc3BrT0FDM3ArT0FSWEZIeElmdW0wd2pyZ2dSSlNHWFJ2MGFuVnQx?=
 =?utf-8?B?eFpkVTNmcWltMDRYYzVWNk9uWjh2TVM1OTRVZTVvOG40NjNuY25NT2lFRnl5?=
 =?utf-8?B?a3NJWW5uaERLa1ZHbmdvMzF2T2NJbnREMGFlYUFzaUtsTElYZlhRN1RnYkhZ?=
 =?utf-8?B?TlpLZ3VCZEx5TkxrMXNEcG5xVkptYnpHN1UyVnpmZkw4ZVI2SkRoeUsvMnZP?=
 =?utf-8?B?MEFPcTd2Q0VJVWNrMW1BT3NLbFZpVlhHNDlJZVpORDJTR3dCNi85T3lDMzEx?=
 =?utf-8?B?NXJTWDQrNCtZTnBNdjFlNk4vVzlpVW9WcXJJMUtlTlV1aVhyeXFTNkRLL01R?=
 =?utf-8?Q?/KefMqG/h4yBYQFptCacLp4nc?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	7TKa53HbKp+clWf8gE+5yRVQXQ24Ww4AZ+OxjIf5G1FFj4GQUZ6qdFZbujnucoqxQJKK/OPGUcsK1x9G5ruzeRJHbB3gcCI5wRGHlFz6DxaNxxXHUMNwpARq36NjVpyaxVGRC6kVCAgY4gW5fIHUv7yCA5/M96j//XvSG2oZnaMAYiOKbMyWYXRLYRemXMnntB/4pLkMnK1nQbqWe3GkG2cAIz++0SuFx8WkBdyoO+XK2Z4Birfb9e7lke5OX1DhheEVq/1vKr1J4fRprXkT0/eGo7uTDbGHjQVVtKxMv7sAws/2oKw8H3ku2k808DgEnydZfSpqgS4ctFv9GTMKYHbL9w2AsqiBqYVon44N/pqHWmulZY9ycXN0IbEQT9mapbdNiwOF+qkqkPqJBGDfg9SN3DSIsb6gJmKVgzmmtb1Eood3AL0zCKY7Jw9/DCYTGS/ZGNDkKId+e/C3MVWaTJ5ke/MqQlAZEjwu7dTYVoBgKiipsUNHp0BmuP90mMHuhkvHmb22ok2alFrG5KZgznDoQmVYGKRtGnnlt2mIFxTK0GeQHkQbTN/A5C+pQ05N4QaSa+q7YDE6a3UiHvf/XYcjfIdRzYNkp4pvF1LjuiY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 702d0fa3-a805-4741-d856-08dc593911dd
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2024 08:34:42.9979
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HsvxryLXUhu7O+hTLUyzgyRfw2Pm+T08PPZinXk4MN8KOMtQ35T5f90WeQZIESvDkuoaRPXR342eWlHPMt/CUQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4908
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-10_03,2024-04-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 adultscore=0 malwarescore=0 bulkscore=0 suspectscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404100061
X-Proofpoint-GUID: RQVKpZfZ5Q0lxVyRjatHfpJWPWEtNvVq
X-Proofpoint-ORIG-GUID: RQVKpZfZ5Q0lxVyRjatHfpJWPWEtNvVq

On 08/04/2024 18:50, Luis Chamberlain wrote:
> I agree that when you don't set the sector size to 16k you are not forcing the
> filesystem to use 16k IOs, the metadata can still be 4k. But when you
> use a 16k sector size, the 16k IOs should be respected by the
> filesystem.
> 
> Do we break BIOs to below a min order if the sector size is also set to
> 16k?  I haven't seen that and its unclear when or how that could happen.

AFAICS, the only guarantee is to not split below LBS.

> 
> At least for NVMe we don't need to yell to a device to inform it we want
> a 16k IO issued to it to be atomic, if we read that it has the
> capability for it, it just does it. The IO verificaiton can be done with
> blkalgn [0].
> 
> Does SCSI*require*  an 16k atomic prep work, or can it be done implicitly?
> Does it need WRITE_ATOMIC_16?

physical block size is what we can implicitly write atomically. So if 
you have a 4K PBS and 512B LBS, then WRITE_ATOMIC_16 would be required 
to write 16KB atomically.

> 
> [0]https://urldefense.com/v3/__https://github.com/dagmcr/bcc/tree/blkalgn__;!!ACWV5N9M2RV99hQ!I0tfdPsEq9vdHMSC7JVmVDHCb5w6invjudW7pZW50v3mZ7dWMMf0cBtY_BQlZZmYSjLzPQDZoLO7-K6MQQ$  
> 
>> So just increasing the inode block size / FS block size does not
>> really change anything, in itself.
> If we're breaking up IOs when a min order is set for an inode, that
> would need to be looked into, but we're not seeing that.

In practice you won't see it, but I am talking about guarantees not to 
see it.

> 
>>> Do untorn writes actually exist in SCSI?  I was under the impression
>>> nobody had actually implemented them in SCSI hardware.
>> I know that some SCSI targets actually atomically write data in chunks >
>> LBS. Obviously atomic vs non-atomic performance is a moot point there, as
>> data is implicitly always atomically written.
>>
>> We actually have an mysql/innodb port of this API working on such a SCSI
>> target.
> I suspect IO verification with the above tool should prove to show the
> same if you use a filesystem with a larger sector size set too, and you
> just would not have to do any changes to userspace other than the
> filesystem creation with say mkfs.xfs params of -b size=16k -s size=16k

Ok, I see

> 
>> However I am not sure about atomic write support for other SCSI targets.
> Good to know!
> 
>>>> We saw untorn writes as not being a property of the file or even the inode
>>>> itself, but rather an attribute of the specific IO being issued from the
>>>> userspace application.
>>> The problem is that keeping track of that is expensive for buffered
>>> writes.  It's a model that only works for direct IO.  Arguably we
>>> could make it work for O_SYNC buffered IO, but that'll require some
>>> surgery.
>> To me, O_ATOMIC would be required for buffered atomic writes IO, as we want
>> a fixed-sized IO, so that would mean no mixing of atomic and non-atomic IO.
> Would using the same min and max order for the inode work instead?

Maybe, I would need to check further.

Thanks,
John


