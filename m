Return-Path: <io-uring+bounces-831-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 78E2D873245
	for <lists+io-uring@lfdr.de>; Wed,  6 Mar 2024 10:16:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2FB7628AA65
	for <lists+io-uring@lfdr.de>; Wed,  6 Mar 2024 09:16:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB8095DF1A;
	Wed,  6 Mar 2024 09:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MT5owcNK";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="nF2mSqwi"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51BCC5C8EB;
	Wed,  6 Mar 2024 09:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709716569; cv=fail; b=kET5KJ9lbC62pURlOpC5Kd7VH4xqP3LW5Souw94bjExKw+39bbDI3bxcyoILsyfbN9UA9O4+E42Oipel7rAU9LJSTgfnpA3R6iUMkXZ+AQog1acFUEHgs5bi9HM1VmYCBQBBHTSRYh7doj980MeJ/e76TEADTRh1wrKFjnGRwp4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709716569; c=relaxed/simple;
	bh=AC7s8bseI/zq8aBbu098h6o3zmSVhr8zVd0bnB0MIco=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=qiq9wHaXaWOGb8Sx3s0D8WfFiSyv2v7ES09NMgkL31rMWcRjxQfZCSZ8ivIVsLVAlsTGawo5699k3B5mT9571GLDpcKju3K6TEfyETfpUMH0h/KNzw08+ymep1A0OHyphmk/CQJALCrXdZCjezQgV7bzplJlEZgvSOAjGdBCCjs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=MT5owcNK; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=nF2mSqwi; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 4261ECHE027636;
	Wed, 6 Mar 2024 09:06:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=EwV82vKzbsAhGhF1myvwkhJf+Ss/oCAQ2BE/lCmCRQo=;
 b=MT5owcNKbiykRzBJc3tjAFVTs85c+NBS9ofUUD/uSY0NhgJ+ncdzXXjjWThi+CWd0AMm
 PU2sPhR8Z4PKF0KWwOO7/PnJrhSgJLnDJlkUVnhFgaFr1yCnXY6/bCV6Fpcj/lqS4xFL
 nFSCMN5CT+13WK2A8AC5apBkkXButnd6tU0WLMUL95qTu5A01n6Am/6lcCNg20Ut3crw
 ZO2z5vWqd+xhZZK+Y44To0QNPekierW/PhXwY9+61s0oiwKSDV2sbGXjZNng7UJt5Y3l
 5HUGbWJuMa8AQUB7VlIPmp+FLuIb6qOzYhMwKa8gaUKgnDUBfJTehykT64kDFjMgsl3Z 5w== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3wktw48ch8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 06 Mar 2024 09:06:04 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 4268ckTn040825;
	Wed, 6 Mar 2024 09:06:03 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3wktjf0ept-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 06 Mar 2024 09:06:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bbd/j59VW+5rqJ5ZbqgA6ejdz7sjlqGXzHHeK/v8qnmJ18f5Hm4vrOnvVhuGT3yJP+JQeMEH1BPj5LdxisDLp+jyGtdYIA0DYTouTr2ChG2P2biDeMTvOnj0uPsOluMCqMzcr8KwewE4D+Rfuo0np1EaqZFNhoxU9BhbpfHip5jC/U2YdoO4GMcBHbRuzBpqILHCCG5oJ+yno+GnANQBa3copm9D6PPnz0hdgi8dpbT281B6C9LN+olJD6x/nEtO+/rdHNJzSfuWYvabTZYkv3nQU+jXBTu4Sd+U2RR/fU3IouICXGc6vzPIq8S8bxRrgkYBLHF4xbp9UIFu8lAF4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EwV82vKzbsAhGhF1myvwkhJf+Ss/oCAQ2BE/lCmCRQo=;
 b=Gs4ZTZrlLLK9vGrxalNEUezvM41+ps7fSagXPuwJKsIgsy3GEesiwl9ext4+nU7heOxlK9CZ0lyGYYcwD2P8tk+KpCXEcP8FcfffbJP88JQZ+dcStyogH1aYE/sMhk29cayaPrUB3U9LnnRe+BrxhAy8O1lSAQFstOTqOfRNjFiE0xycPmbjjAEZahngtH35wdiBuEsEdYRlZzuYoFR7rttPxt/ivtBA69a4Xp0roJ/fh/YrqvPPAWlkaE85fLkKV740qxBFdEI7sUtUwxqd4CGC0V8TTFiwVF7y/IG/v4MpNQbMEtHVT4xmbLhLsvC+qNcALevZuR3xu4puOa5Q+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EwV82vKzbsAhGhF1myvwkhJf+Ss/oCAQ2BE/lCmCRQo=;
 b=nF2mSqwikw95P8kmRmyxI7xcB/wl+xQOq2ISsTO9tS5973jauw+eBRBG8gBGqbXXNzSH9zKFNXMOr1i47OP1Q3r5C6wWD5MmRFOa9UM8xjIuRo0CC9in8r/d3SWHt5Dgw/ZINar660QbN+m1Amb762jZV1gfm8mbqdoOfhWxJA8=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CH0PR10MB7535.namprd10.prod.outlook.com (2603:10b6:610:187::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7339.39; Wed, 6 Mar
 2024 09:06:01 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ae68:7d51:133f:324]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ae68:7d51:133f:324%4]) with mapi id 15.20.7362.019; Wed, 6 Mar 2024
 09:06:01 +0000
Message-ID: <47d264c2-bc97-4313-bce0-737557312106@oracle.com>
Date: Wed, 6 Mar 2024 09:05:55 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 00/10] block atomic writes
To: Matthew Wilcox <willy@infradead.org>
Cc: axboe@kernel.dk, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me,
        jejb@linux.ibm.com, martin.petersen@oracle.com, djwong@kernel.org,
        viro@zeniv.linux.org.uk, brauner@kernel.org, dchinner@redhat.com,
        jack@suse.cz, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-fsdevel@vger.kernel.org, tytso@mit.edu, jbongio@google.com,
        linux-scsi@vger.kernel.org, ojaswin@linux.ibm.com, linux-aio@kvack.org,
        linux-btrfs@vger.kernel.org, io-uring@vger.kernel.org,
        nilay@linux.ibm.com, ritesh.list@gmail.com
References: <20240226173612.1478858-1-john.g.garry@oracle.com>
 <ZeembVG-ygFal6Eb@casper.infradead.org>
Content-Language: en-US
From: John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <ZeembVG-ygFal6Eb@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO3P123CA0019.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:388::15) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CH0PR10MB7535:EE_
X-MS-Office365-Filtering-Correlation-Id: 8b0f1dd1-ed52-4cd0-a6fe-08dc3dbca51c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	T9q/BLUFo2HIJ3boF6enuNFNosW+UV9xxhtsgP36iYXt03YzVgGTN8rULrP/7hfG8CZeBXJ+jnWtWZumaT0kxsCucBaMZb66wrscLYoIVOWaqKPxpmXWW4DGfuKuz5cNNgsZX4iw5dPP7OfFAZcRaEOyVdZ+FzsK+Kw8h5QFvB46fNaofbkTktBpPoJZnmNCBBEotISlZ0Kmddeq0Lw6iPuIP9mOHEjcR0UR1d78B5f0S12Rx2S5hZF3l/lq3YX32JA4E17SYEyM/t9t85h32gLFZu0YSOrcycYMPaFRt6F9EiIiQv1emFxOrHH4GS6ZLSw437J68Lc9e5NjGEpHeQklDzpCAvBDV28q5BnqyPj9d0zFIp2b5s6jlPyvLfEemiLPOcWrRoXAcJLAg1ETPUxPCeltdQRSvOAWYwGmPSZK2WvIdRPm7Fpfbe7934X/v7O81XMh2EJiL0wjibjKzwDQvSqnmojKUy4jJRW12vLeId9FyHQr6EVe0lcMrCOKgnU5vj908kfPO7MKxSpssDXxDMuSZwFymPyHz7ejO/TqnjiSdeDcWf8gRUo1fqoYgRtK998ZJXTBU/fOHLJ5ghn726uR0DgBXs7WWXMt8XxsdT92nIcQkVWq9Luefbjei9H+CGCsylXWEL52OmhpE6f0NYu0DcnMbPl6b3Vg3ng=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?Yk5xeXB3TnFML1VReVFzMzhZZVNWTmtwcnZBYkY2ZzVBYXJmeGF3THFpR1lT?=
 =?utf-8?B?Mm9HeUxwcDRpR21lcXpnMXdRQUZRdFJKVmxVTllvaERYTmFXQ3hMQmNJZmh0?=
 =?utf-8?B?U2lZc2Z3U0JpOWd5UE5GVlc0Qml1aTVtaUE3Yi92MnM0UXM0dDJqWkk0b0VZ?=
 =?utf-8?B?TkFTN0VrSWc5a0NBSWNKSDJLbForejN1RkJyK0FqSjNQQ1l2VTJXWDNkcFZz?=
 =?utf-8?B?cldGd3k1Qm00cnNNVG1NNTNocDdjMnhpN0FGaGlaeHc0OCtObXMrVGc3am5E?=
 =?utf-8?B?THY2R2FIYjQvR3RDQUVRdFFXSkkwNU5VZVBUUjRtTncxV1F0c2pLTTFsWVVO?=
 =?utf-8?B?YWdONGpIc3dIVkM5SmUycXdxQWFwclc0N3BSTkNxOGFnWHhSZjBLdWZGTW05?=
 =?utf-8?B?ZGpFUmErUjQ2NzB4ZDlxaGlJUWlibUtKQ3RXMGc5bnQ1OVdlcWo3K3pmaGUr?=
 =?utf-8?B?TEhrcy9DcDVNTHJjMmVKZVp4QXlaQTZIVHZ0bXFReDVlczRQRk5jckNKVFpN?=
 =?utf-8?B?dlpyOWZ0WFJVR2xBYlZPVUs1TzN1ZjJwQ0QrcFpwaFRsWTJ3QzJzdDdTVWtP?=
 =?utf-8?B?dStQdmNEMGkvVWFzM3FKZ25IbkNaUlU0VERuQ283S2tVWDR1MFhnZlEyQjE2?=
 =?utf-8?B?a0RwY05meXphcGIxQ0I1ZWlnN1ZIaW1pTHNDdWNDRy9GcXl1Mm43cVpidm1D?=
 =?utf-8?B?Rm5Icy9Kd1R4YU9jNzE2RHBRelE3bnFFZ2ZlbnlOSTl6K09paUtrTCtaVzlt?=
 =?utf-8?B?VldjaVFITkpjS3VSbDdTLzN5eUJpV2FVMkRDeWpNczVJS2hNY21LbVZJLzdH?=
 =?utf-8?B?M2d6Q3FiL3hNVjNKdUw5NE1vNUdlWnZHNGlBSGdNTzRpZDhrUHk0K0pYMGMw?=
 =?utf-8?B?WWlGbjUzNzBOaGNtLzZuUnNEMmJnY3IzcCtkTmFrQkxPeDhwTHRXUDdyc3lt?=
 =?utf-8?B?WEU0TlY2OWxBRGErMFlOM0xhd25YdEdXak4rRlg0bEVURmQ1NFN2TisrblBq?=
 =?utf-8?B?OWI4UVJjemlRZVpRVDhKclMyWjFULzBqM0w4N29FQmNaN2U2WWMwOUh3SmVR?=
 =?utf-8?B?dnI0b1RLWXltVTc1bWhsUUk5WmRtRGJOMGFPRW5YbE8zZ3Y3T2ZweCtFemIw?=
 =?utf-8?B?blcwa1ZDcmhPcTg3Mkh6d2R4bjZIaFBoNWFzQ3FJZWoxSzB4aFdqVWxyTVBF?=
 =?utf-8?B?ai9QVWtaUjdMa2Z1MUZ4aFVNcU4vcm1TSVNlYTFxZFFySldZemVIZ3ZxdEFJ?=
 =?utf-8?B?Y2hqWWJ5dkN2dlZxWXJaUXRoUDZCVEFzS3F3bk5uZHRnN0VRVVRrR0hSZjdt?=
 =?utf-8?B?c2NLcEgxOUk4U3J4U0hLeG5pL3VTWTFhUUJDdVlVSk5WN254SUVpWE5NOFA3?=
 =?utf-8?B?ZmNwOWZFTlVKRnl5MmpXZlJvUVcvcmdFNFg0KzRndXlxcGVqTTBLODQ3a1Vx?=
 =?utf-8?B?RW9wN2M1M2ZlZ0NsQjd3UWsvRUd2dDJrZU9NL1BhRi9nVjRvamdTUWtqRXFp?=
 =?utf-8?B?TzY5NWJRem5mS1hjak92M1Blc0VxZm1NVnJmSGRQZnZPT2JRMklodGQrYkx0?=
 =?utf-8?B?R2E3eVlzRWNQTXZtOE5senlWZzNOMWM4dVdITnZkQnV0T2VOZGR1T0VhUHFx?=
 =?utf-8?B?d0ZaNDdHZGlpdTZBZUpmVWZ2aFFuVFk5YUtlREM3RHR3YWZzaFZEcmtsZmVP?=
 =?utf-8?B?M1dDSWFLdXg1NHRtSkFlanFpenllZkZrOW9HNCt5dDJlTWwzbHlrUFNsY2lS?=
 =?utf-8?B?ejdrZTlaNERGb2J1NmZsblM2cXplNEVGNkZGL3N1ZG5PSmdJTUNJNklGdE5h?=
 =?utf-8?B?VTZJSk1ab2xWY1VwY0dWV1pNZ1dtay83V3JTdGc5Y0VFS2k2aVZzTHNrNWFV?=
 =?utf-8?B?M0dtZFFLYkR3YTlPR0laSVoyK0lHUElKSWtmODhhNkFPWkM0REc4ci9MeHlS?=
 =?utf-8?B?NDk2NXZ5SHpyTTdwckZPOWZhS0lqdDY3THZ0WEtMY3hUczZybXZRalJPeWhO?=
 =?utf-8?B?UHVSOUNWMW0wSCtzdnV0aGVObkRBTGtmSVcreUM3cGhzeWdTUkdpdm82K2ky?=
 =?utf-8?B?S3BwTkV6VU5oMHBwY3F4eXRkY0dpbzE0ZDliVkhjaFc1ODkvSDRYYmlrUExL?=
 =?utf-8?B?aHp4RTBhalNSV1ZVaXJ6SHFSajdDaDc3cFU2cHpkTGhGRWJaKzBXREFhMTJk?=
 =?utf-8?B?UHc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	gi0Duaej+reInOOWKPFDJwz1/dGT6wT67UmFD2I2MVyYF5E9JBExkRjbjw1LoCE1rVzBEaul/FuK6o7+4AkWc5LylebV/nCcLFDO9rY3iUrRuedPRAzAJ0ykgRoTOWKPEhq43U68hTanqFeVnr2EF+I2PbjQ7HHnqmAq+WiGraUFpAYMyKRp6PFPPcaDiM9ca47DDf7I4EVdI0iFX89c+bRtGfwSoEtNrPo0MNXUyaMPBuguyDITIXDMfxN9iGyDQYFrsrtmhYXNspz7syUWFRfUM+ULnZDiS2KfCQLV1luh/b4qQbcx1+Fe3wQNwRUWuMt5c/nCwnA4mJ1Aq9006W1JL9UUP2hvwC+LBed6kp4xHwQo9GRGt/04GMdgqQas5qm0DecwjjoLamoGM3axXtyR2wS8qqcJrkKE8E7dQdN+B+D/kF+DG7jo8xLlIVIq0t2XfGAkgoxdk+P8fZTrV04+WLZWaKseThdAwJtXKioHKjrGhXrXQU8EpmDe9e/9ico/5yWJm6ZWSaCRyJVbH/rpAYiR9nLYxmK4iU/l0yFbi4f1ecC1uogcxdBnTbiysQIqpxY8TpdNww0eJ9XXWRXLnflrDj0/yS3LrqJpmVM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b0f1dd1-ed52-4cd0-a6fe-08dc3dbca51c
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2024 09:06:01.5335
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WZengsZalc3F6NEVNX3o413pOcRg/Z71uaK6nfgTcBc4FDN6oaGVCz4pBOO5wnsONGbRmebBWHmQ0/V1FaO1Vg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB7535
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-06_04,2024-03-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 adultscore=0 phishscore=0 spamscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2403060071
X-Proofpoint-ORIG-GUID: PRoDzoCJsEyr8tsjjGxG8rn2LGpD2SBi
X-Proofpoint-GUID: PRoDzoCJsEyr8tsjjGxG8rn2LGpD2SBi

On 05/03/2024 23:10, Matthew Wilcox wrote:
> On Mon, Feb 26, 2024 at 05:36:02PM +0000, John Garry wrote:
>> This series introduces a proposal to implementing atomic writes in the
>> kernel for torn-write protection.
> 
> The API as documented will be unnecessarily complicated to implement
> for buffered writes, I believe.  What I would prefer is a chattr (or, I
> guess, setxattr these days) that sets the tearing boundary for the file.
> The page cache can absorb writes of arbitrary size and alignment, but
> will be able to guarantee that (if the storage supports it), the only
> write tearing will happen on the specified boundary.

In the "block atomic writes for XFS" series which I sent on Monday, we 
do use setxattr to set the extent alignment for an inode. It is not a 
tearing boundary, but just rather effectively sets the max atomic write 
size for the inode. This extent size must be a power-of-2. From this we 
can support atomic write sizes of [FS block size, extent size] for 
direct IO.

For bdev file operations atomic write support in this series for direct 
IO, atomic write size is limited by the HW support only.

> 
> We _can_ support arbitrary power-of-two write sizes to the page cache,
> but if the requirement is no tearing inside a single write, then we
> will have to do a lot of work to make that true.  It isn't clear to me
> that anybody is asking for this; the databases I'm aware of are willing
> to submit 128kB writes and accept that there may be tearing at 16kB
> boundaries (or whatever).

In this case, I would expect the DB to submit 8x separate 16KB writes. 
However if we advertise a range of supported sizes, userspace is 
entitled to use that, i.e. they could submit a single 128kB write, if 
supported.

As for supporting buffered atomic writes, the very simplest solution for 
regular FS files is to fix the atomic write min and max size at the 
extent size, above. Indeed, that might solve most or even all usecases. 
This is effectively same as your idea to set a boundary size, except 
that userspace must submit individual 16KB writes for the above example. 
As for bdev file operations, extent sizes is not a thing, so that is 
still a problem.

Having said all this, from discussion "[LSF/MM/BPF TOPIC] untorn 
buffered writes", I was hearing that can use a high-order for RWF_ATOMIC 
data and it would be just a matter of implementing support in the page 
cache, like dealing with already-present overlapping smaller folios - is 
implementing this now the concern?

Thanks,
John






