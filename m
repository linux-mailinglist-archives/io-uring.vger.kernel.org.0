Return-Path: <io-uring+bounces-2285-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 55FE790F3B3
	for <lists+io-uring@lfdr.de>; Wed, 19 Jun 2024 18:08:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C66D82810C3
	for <lists+io-uring@lfdr.de>; Wed, 19 Jun 2024 16:08:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F063945009;
	Wed, 19 Jun 2024 16:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LR60ILkA";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="IwwbkP0W"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E5FEA29;
	Wed, 19 Jun 2024 16:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718813324; cv=fail; b=edk0snHFAitSh42hSogov6BRDrc2ADEk9gYNqpLNIs/j+UrzAIU6gM3sbd2R/rnEpuyZStcC5LJnC8asBNOzbVricRNLyJURPq93yowuc71e9gtavV7H2GCcdljASTWQBOj7WBTUCC77cIbI9bDWzSWaoOe2iVPeLhx6U/0HGTs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718813324; c=relaxed/simple;
	bh=Y69D1f0l2FZAn7qN47BMQ3ReyCzcF6wmwK47fNloPuk=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=ureFAez5Lu1chtHssWdvdYlMMsbVUZhIANoug/hGmgiGf1AcMud1oBayYVWNUPOX/tKaQHNpyhq5EV8uIFxil8pcr/GCAruV0RgMoCGIsEjO0zwhvO4clReIiSGWH8Swhp39Xp9d3dsXhG1smAOE37/GYLf1Ml6Fq0iZ03ktrFM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=LR60ILkA; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=IwwbkP0W; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45JFBSCJ009176;
	Wed, 19 Jun 2024 16:08:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=hlaRwrfECDq2ec
	5s6O6sz8PQj5ZQ0My5P1l9t7LwBkw=; b=LR60ILkAOiHgghlyKwH74kNubMfpvd
	hOJfEwyWBnQUuLXV0PHN+AONivbj7zH4LonLTOK1WRgbbHP9Mqrr7Kf8QQ+n9EOw
	hkkrpEzLQIqszJn35gCMfcUIs06lGLeHT+r++7usa81prQQpeRAwizyvWc+7JZUa
	B9DDhGFYEuGRy0NS2Sco0oqr34XQKkIV82DGRTWePtRVOeAAYSIiAGjFP9Urddh4
	ZCPSrclJGMMh2Ghx/lypBSkgz9EvpJ4GvI7f1ueFUE/MDS55Al2qCVil768lAJCO
	GbJzmny6ZOgid/pffIwPlWjTXD3fqQIkuqIdOumdBYMPbh+nPECbLkoQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3yuj9ghmec-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 19 Jun 2024 16:08:01 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45JEC6Gv035062;
	Wed, 19 Jun 2024 16:08:01 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2171.outbound.protection.outlook.com [104.47.58.171])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ys1dg18y0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 19 Jun 2024 16:08:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kyrD1FIgfOYW5tcjjlehzjUnJcpZ6pJn77jSAQGkFzHRp7AH66K5Lp0y3VLqsfvKTHR2m2buXKk67nxqtTxjPMMdCcFS9vAFemEM+3SmSYJrYiiCe/dgwO55XwonUj+P2LOF9yu6OaPLJlgcQExbo322b9A76DEEhfOHA87SXLqm3O+QQOpAGb+/wAw58fJZ3UjbqkpjJeK0ZlhXcV+3Fu6f0ldJ5AnRp9Lw2QNxQRwuNaXyfpW9b84kKH5DimWRgfdjXyIXEFnHaxbCYFdl5TIuBRxB6wLSQCqoDbGemCeZnckG66ZxGk4jaNqzGoMXjftWRdOoNy+PPUMC4P6KkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hlaRwrfECDq2ec5s6O6sz8PQj5ZQ0My5P1l9t7LwBkw=;
 b=X2nevUqX/ZyVb7D3fgqNf9KDhbmU0mw9/q+ypvl4NuZI7rrIv8FC0chtjTFODqRkJ4ahLJ+9bd56n5ByHQfey7VvjBSoCnxf+TtBNt1vTMv5XyNi+xtFetXvWc9oIkMHH44Fyj1pJQDd2H448Wuuwt1tkl0wxeSI14cKLeFnLXilWYIMNPXHcQfHdClkiiIYgjJ3o8u7XKoTOpgyemIqcbqlAzxp6EdSVjzm4B3BwG78yXgl12MqiTo+53X9Ds47sQkFsWbk8utLRHq/4kmOPb+/UlGyfwOUFmG0Wt7csY/NmUcrn0E9wPEDDB1ntmhzjlUm1mzxwq6VLOnqhMAmEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hlaRwrfECDq2ec5s6O6sz8PQj5ZQ0My5P1l9t7LwBkw=;
 b=IwwbkP0W5LqVlUPZfPx50+wQmDbERdZps18Q97LYDtkIefeCu1KoJK1VK2tDg1a2jSMQ2rjkkzy/Gdu5eYLmT7mnkYDEoFeIkM5U1ARh3n6iqwx6+/9WqcWkXL+ybT41z6SfEVNPVm8bVTEsaxqeTAveTeEQcRPECoRLFwcbQPI=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH7PR10MB5813.namprd10.prod.outlook.com (2603:10b6:510:132::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.31; Wed, 19 Jun
 2024 16:07:58 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7698.019; Wed, 19 Jun 2024
 16:07:58 +0000
To: Christoph Hellwig <hch@lst.de>
Cc: John Garry <john.g.garry@oracle.com>, Keith Busch <kbusch@kernel.org>,
        axboe@kernel.dk, sagi@grimberg.me, jejb@linux.ibm.com,
        martin.petersen@oracle.com, viro@zeniv.linux.org.uk,
        brauner@kernel.org, dchinner@redhat.com, jack@suse.cz,
        djwong@kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-fsdevel@vger.kernel.org, tytso@mit.edu, jbongio@google.com,
        linux-scsi@vger.kernel.org, ojaswin@linux.ibm.com, linux-aio@kvack.org,
        linux-btrfs@vger.kernel.org, io-uring@vger.kernel.org,
        nilay@linux.ibm.com, ritesh.list@gmail.com, willy@infradead.org,
        agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com,
        dm-devel@lists.linux.dev, hare@suse.de,
        Himanshu Madhani
 <himanshu.madhani@oracle.com>
Subject: Re: [PATCH v8 05/10] block: Add core atomic write support
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240619080218.GA4437@lst.de> (Christoph Hellwig's message of
	"Wed, 19 Jun 2024 10:02:18 +0200")
Organization: Oracle Corporation
Message-ID: <yq1v824or0e.fsf@ca-mkp.ca.oracle.com>
References: <20240610104329.3555488-1-john.g.garry@oracle.com>
	<20240610104329.3555488-6-john.g.garry@oracle.com>
	<ZnCGwYomCC9kKIBY@kbusch-mbp.dhcp.thefacebook.com>
	<20240618065112.GB29009@lst.de>
	<91e9bbe3-75cf-4874-9d64-0785f7ea21d9@oracle.com>
	<ZnHDCYiRA9EvuLTc@kbusch-mbp.dhcp.thefacebook.com>
	<24b58c63-95c9-43d4-a5cb-78754c94cbfb@oracle.com>
	<20240619080218.GA4437@lst.de>
Date: Wed, 19 Jun 2024 12:07:56 -0400
Content-Type: text/plain
X-ClientProxiedBy: MN2PR17CA0028.namprd17.prod.outlook.com
 (2603:10b6:208:15e::41) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|PH7PR10MB5813:EE_
X-MS-Office365-Filtering-Correlation-Id: 13bfea69-0ea3-4483-7409-08dc9079fcd7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|7416011|366013|376011|1800799021;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?cbu/Z1zhSlfpvYqL0VDghhoKV7uLZ7uHiXFb7tE8+qnbH4dL8ASDyG0PuNsd?=
 =?us-ascii?Q?XL/zKbSe6VCQWSJX+AX3eEGRrK/z+RWiWtIzszCFmdYvviKfSlDBdalmmtdf?=
 =?us-ascii?Q?1Z81VJLwwZrWnS52cbGyTkVBsWG8FU2vOLc56QBfhAFQ0Y7T2Raj3ME++1IJ?=
 =?us-ascii?Q?U8nQwr+AhpNsKTFBhrPFsqXJIKj4rnoV1U+CiI0KLu9ejmGAP5WyzsUum/Q1?=
 =?us-ascii?Q?lfoUYU3Lq+uWx4faYZnd7zGtzYGOC5h1cs1kGD2t+5Oc49TGSz+LquMcGKW+?=
 =?us-ascii?Q?M9vQfrMTSFuDzAYCYT5yipGanXsry00oqQPyEifvZJWV9DU1hNHSJmaRml/o?=
 =?us-ascii?Q?5fGv4f1Kt57tWPrpSliAhSm2wLo3YxjnIejNf7Lzksv2JO0CepE1FdeezX54?=
 =?us-ascii?Q?zUWxgKjuLTNsOPjUhjTJUJNGeLbON361KR7u4tq3sfy/xC1TejkmZtAlLaSj?=
 =?us-ascii?Q?neEBnk0dIksuQReiVdZ+77mZBkadby9E+qbD+fYTZQzoxJHlD/Yax4xRbwv8?=
 =?us-ascii?Q?kwPJc6KD55J8YPJc7WRNzVoW8xKtgr4oz1twKwLr9gMXklYGkpEHyJzAPGjf?=
 =?us-ascii?Q?s238XztmyG+/0yHU3r8RSy5pffUUsP1OIiHGdW1sSbjjOzP8pu3S52l0l3Cj?=
 =?us-ascii?Q?cq7NFKsFbcqzFc5A4I4qmPpUDmhh9nDU/ME9bVtSEOoa/uRgqfs8v0qAipFt?=
 =?us-ascii?Q?GpuJIMmsEAeuN+jtEipT4cTSHpSZQ8AxAV+/9+FLW7uf5Z2gEyT/rp6t7zZK?=
 =?us-ascii?Q?riHwoXvOP4zenOtsPseqmjlA4vJf0MuFheVxQwPA2pAWxjTpx7Vmt9HS1WL4?=
 =?us-ascii?Q?7Y8m9XDdc6qP0RCvxIYfWnoCa6hR0at5pGfXYjXBFLb/4JMvID2aK/eKQ5Xj?=
 =?us-ascii?Q?GOERX/m6Z4pwHtaNbwKhve4jp6FVQ1N/WXCVdW8mmpCKLGwrcQ5PYETgk9xD?=
 =?us-ascii?Q?1yxyMnxQls+wXkuDm76yfs0TiCDXbcFtkWU7+w8afejC8Gw78sl9ANFrH1kq?=
 =?us-ascii?Q?itmyQlmvYZucxAL5mkFYRf3scUqcgHvtFxZLBos4ywA5KfELrYL0WTN8xA6D?=
 =?us-ascii?Q?wFKGmClEDSvyj5wK35cyaW1tRHK/CWtRN6i8+nuiTg/Hgw5vXBIVYbKvtT4C?=
 =?us-ascii?Q?/kSqK9Fsn6hDojXAwjZhVe6RlspYz88jiDtOSle2lDmfG+X3m/eS5kP3IZli?=
 =?us-ascii?Q?BJRTgiUZPXwXGv2dxpo3zo31cuM1SRXVSVCdYNIaURjJFlJH5jFxOlQYE/to?=
 =?us-ascii?Q?UqPgBTjva0tb9Ffej6/FW/puWazftY42AdGse9BOUJjf5Ny3qREbBTX1djPW?=
 =?us-ascii?Q?1ipNClzL/+v5m3lWhb/jhxlx?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(7416011)(366013)(376011)(1800799021);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?nn9/yQ4JTtPcN08F3RenhG4n8S8I0X6FNDYmFRVtdWbECiUOSbcn1VCZN2zy?=
 =?us-ascii?Q?ZWdKuLRxQqki0y5LdCbBfcHfV82koOMlOHWtvs8lZ001Pc9W4eiL6BSzRWjV?=
 =?us-ascii?Q?Co+ye7V8v+/CFAIdwTWHgixKV70StVsl9A3lkuQiorGtao1+T+l6ddgBCs9l?=
 =?us-ascii?Q?tpFKPUHO302wGvSfk7924ThXozldyTpIE8+DcY7kIGhAJXPDi3qvv3koaj0w?=
 =?us-ascii?Q?0EFlGHestQplntLCK4iRyr5Dqv7MQlJdd7VUol/SlJpjRxDncbFXNPmx9jai?=
 =?us-ascii?Q?9gIidaYGnxNkWdDa/2t9AhtmZHv4cqYz8pU1SAbFHolbSH7XZo5GVYQXldm5?=
 =?us-ascii?Q?Rk1KNoDP2Ea2pYkGnwsggZth+gHq6tTrIInb/y7y+fddrURo0xzumrXznYI1?=
 =?us-ascii?Q?k+b6p6gt+t2OISG5dS79Cc0OrZtHrtIe3AjmOErIEYDcQiXBdxa+INdsWqls?=
 =?us-ascii?Q?mfiO0gRackwNffm1sMRcrBllkgTpwvk9Aw35zZonRNu6t0Sxtan9MKeP4RVj?=
 =?us-ascii?Q?EI0t7RZP7iFy1b3tya610cp2HxHEpd+t5N7LwTRnCKniSidiRVouqSeNDfzM?=
 =?us-ascii?Q?NPdGoHP5WPYMxwBWfdAHwfcbskE4aOvrkX/bIzvye4lt1qVFnGjUk95gHpGO?=
 =?us-ascii?Q?BqKYG4i/MM8z8AVuiya6idb6uw5oCrv71Mqbd9qJTCXzbs2ojHYC7cbser7n?=
 =?us-ascii?Q?wTyqpu2H98YotMXxyazuDfq+eeTSydhEJGETNYCeoWyjFWmM1a/qCInOpQLw?=
 =?us-ascii?Q?5bwy8JIlCH1vgbcA0ldAT4mMhZWd1WKHV2rqmM+/R6kURSYzJlfVysUGfffu?=
 =?us-ascii?Q?Mo9J9RpaWKv7xTC6idWGRQ+7N/VDzF8Dc8xGQyf7yYkVGy9Kdgqd6vwiML8g?=
 =?us-ascii?Q?+7no6bOD8GY4DpdliGs1XNGVAMMSECjfbsdpvA/SGFl6s+pFm364styewjHC?=
 =?us-ascii?Q?XaFDoTH1zpeT5axZW93cc4VFzGyjLmpTtKlG1bOvKf2Z5fJpukq6uJjdHWlO?=
 =?us-ascii?Q?oxzdKkAi904ej9zggAFCTSwM/eOe4v0Zfw2SdHm8DNpp1KscJLCh/T/02v0a?=
 =?us-ascii?Q?2SCqDokX1ZB0sK0kZSObm9d6mQbGHCK1YatlR2FND0l96V5eQUTmsozxfpB3?=
 =?us-ascii?Q?AKlGCeMdiltWOyo0hF1s2+mC27YoL6yz2wbXY0QMX6TbDDubgMh9DAf6o8XW?=
 =?us-ascii?Q?En6/q2fBKKxx2Q9C31E0PJsMBBB6yIKVFwWM9c9OHlXtDHVwJC0UEAUXAo/u?=
 =?us-ascii?Q?pXIdGCddlHQJ5XsHJV8MuVBdoZyjtmilkNweZjAcRH0OCQ+uotOA5gUJI9CJ?=
 =?us-ascii?Q?sNdlVar28VOBPWVzv6Y8E2VekYUHRHsmcJNjDrdSgEZGI899GJlKQPy1PtiM?=
 =?us-ascii?Q?unwRsY3caTUFdPVGFDyhHLxuOrdDZE4BfvFQozqKsSl0pnoSI3UH1GhB8L4t?=
 =?us-ascii?Q?gCEgVBrI5BojYUWCpgtAI+auDwtH1gs6DGfU2UMYUA5JXu560dYRabg7Ec+2?=
 =?us-ascii?Q?veOdQE9s8V6RUuvdYYrAoQinGbIE+bXK0vw3VtaTcUrlyIfF29TeJs6tQ2HL?=
 =?us-ascii?Q?rIEHOlRF9NeoilAYGTlN8bt3dL2b5FdvKYMRYXcVhbD6ZZDOnoYuDYS5PZe3?=
 =?us-ascii?Q?kA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	/MIMDyO5oRTJz94X92z8pnALKzG9pevJEsWQS55lOi05VE0lhvAJE7vNLgjxloXxftavxDYnVtwEDc2mV7bhTT4xl3DU8945gfBfMC8HzX6/JQtHE/U7s7doa89F/hlHSdB8P1de7Hj9DwOzXvwpJypPdvZh9pTWH20wGgjV5LhiKJnyiM4BxFSyaYbaDnYUitCteDjXnwL7H2npJDZZF84ENW3hiUuwCfMaIs3JxtI4Peb2buiRUP07c6ZCyRzWgcXdTBqk1F9pS9uPQdX9Pi63/W+7fg4DfyKJsUct6I1KuDrwPgTfKpgwyCKG+VMGTl+BY9U0wF1qnaOa8tYjQ0MTnc5akeS+6JXIUzraWmIiz68Pu3cN1TNSSS+7nbCwty7E8qTzQWqA4OaMn9ghNrwmNHRcgqMm1cYao7Q4zB820gOUNz4EXYIGUpt0ZNuDjFMRryipSb2ulot4he7RWGHI2tMG2/igLGkXPR0y/P8fCtQ/EJPoI8D4inCk9pTAc8N24K397xlV6mvtw51pMx4LMIqh6iD2eghLGLrmutp0wSXIeQnFM+F+BTQqdEhUMO/1UiJxiKZ/BphOxj0PBhyYN+VEvOZIBoj7HtEKbqo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13bfea69-0ea3-4483-7409-08dc9079fcd7
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2024 16:07:58.8854
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9WcCXRnuX5kATtzdVsyQAjhCdA42WgwMs/QX+HBnYHqHVrBOiSa8gWeSg82w70Wvo4LTY26FdczHcXcLz1Ersk70pZ+5LEsZhQcf5IDbWDs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB5813
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-19_02,2024-06-19_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 mlxlogscore=970 adultscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2406190121
X-Proofpoint-GUID: MzYBLmOmED3itMe25x-3yrUheCRHTCoO
X-Proofpoint-ORIG-GUID: MzYBLmOmED3itMe25x-3yrUheCRHTCoO


Christoph,

> I'd be tempted to simply not support the case where NOIOB is not a
> multiple of the atomic write boundary for now and disable atomic
> writes with a big fat warning (and a good comment in the soure code).
> If users show up with a device that hits this and want to use atomic
> writes we can resolved it.

I agree.

-- 
Martin K. Petersen	Oracle Linux Engineering

