Return-Path: <io-uring+bounces-5784-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D75AA07A09
	for <lists+io-uring@lfdr.de>; Thu,  9 Jan 2025 16:01:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 538227A2082
	for <lists+io-uring@lfdr.de>; Thu,  9 Jan 2025 15:01:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC54121C178;
	Thu,  9 Jan 2025 15:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZKLqGfAl";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="OrOCCYEB"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCEED126C18;
	Thu,  9 Jan 2025 15:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736434891; cv=fail; b=hWZKv4eG2TahyuotaHXm+ApWqiBdw15rQwJrQcaAt093laNI164FRifg8YFsEpuySHJAQzB9Na7TehEEKEUBeaPI+yotPZdpw/V4G9sJUqGuzfG7Tdqt093MBl89z8TnoRWdQDy6d5ot9EqPDikewgG3E+JL7Rm3ivZrQvl7BUk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736434891; c=relaxed/simple;
	bh=Cs125wTcwp14VlqUuTe8lMGcIWzLGNNwZgw+o1absJQ=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=ULCH6ggkv+qik9W2iskN00oRVwW/cs7U40WYLZ1MW8d0m59IlWD69SQwuuVpXuX1JJ98mI3KqQ9KtHxdHYxuI/0AeBEx929Q+vVsXLGSpW6i/PsBXhKO+QYUI4zOzXd1QaVb7LtILP3o+1S8vQYsXr8rIs/21S/yjnYlXgXRS/4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ZKLqGfAl; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=OrOCCYEB; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 509CfnEU010941;
	Thu, 9 Jan 2025 15:00:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=jMUptaI9fqg5+RUs+I
	vqiL3lFR7AmqejQbFAnHpRhQc=; b=ZKLqGfAlKID2gYfwuP+LlcWuWqkWRhqfLC
	4bMhKd4WlYQVAjthTvyZqd0q7fioOBZdzjqHs/jv2ywfetWrPXV06bV9X4G/Ycfl
	wbYtAciZa6qM0+dDNx14odAb5sY+rDbk/iViTIp6ARSA5g9oWtXwya4FY6wpHzHa
	EN0aiJ6II3L6JnL1fIMMhPI3o6/ZesY2Ery53T5MKvPRXupL86Fd/A6dYZ8CtIML
	W08wSLa7uBN+faiccwo5qvsrhFJX3XnULycouwCV/SyvUagLteCJ0/ZIg2AmADCi
	QJ/0Y+2uU6lYLBQcRj1gAA22kdqSD0a3GJDtLzuxe0cWa/iCgm1A==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43xuwb95dc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 09 Jan 2025 15:00:53 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 509EQ3lm010865;
	Thu, 9 Jan 2025 15:00:52 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2042.outbound.protection.outlook.com [104.47.74.42])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 43xueb1ah4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 09 Jan 2025 15:00:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lCFpDHOQhu6xZGt6Sa3mc5WvDHjASrjznsuq3pa9/8gRdKM6+Oy4KZVZGtccD1klyRCKYI4s8NOj3rMlYqtCJQPk3q1RISpnRy0RXOtoz6iBIkBfzQf490DydD1ecW+HLd+tJUy5lJcomhb1wgaebFs/kfxyXocJpyxECvDWC+NDr6usPFLqUXwnqVD0dEgsXNRZ8NHjW8DBk7KM1OgrnCKY77Qk91Et3w3KGd+LAp0s1FEiyk+5RbF8u1SX/vCVYQZ19qR6x3bRXsC0PCOXHtrkysizcmdFRJd04JLEHuK2Yu9Ptt5zXej8v7Q9vRrlM2p/ybIe52aAo73idrKTfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jMUptaI9fqg5+RUs+IvqiL3lFR7AmqejQbFAnHpRhQc=;
 b=BMRs0/8tL8b3tWch/NJTK/7Pz9rctGrgpf95IuDWE2UOD/7YrppNXhigasORdyjo1UCOFDnODQoI2KqKFmjaxxdPDEGHRhva9ryzSach02Jm1omjqFEhffSxDUXuttDqIVzBg7b2PV/2ZUPXq/MJZuOdhitBXEBQk7l7AeZBf10R4NklOWqWiMRgTYmSrbog0+lcP3fn8KmjjBqcV1AKpq9cQp50h5Wozhz1q0Wp5Xn2e50Bzy/5F8exuPXBvsIDHmmf1lHUwftYWW5Kmmb18hbNBF6GeWJ2y3392RUvdcStbWubWJDRNBfieOzMRm3dszF9MnF4zCucKWSAiIQLRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jMUptaI9fqg5+RUs+IvqiL3lFR7AmqejQbFAnHpRhQc=;
 b=OrOCCYEBQosTxVVlFghCyGRnSbxwjYNaQBAUHfLPuEhq6USvwVdXmhomijJ2+HEcDnpL+oYdBas0Ko8OQ+Xv4KVr4i+i8oQv9xnL8WUxMcGiDrmVQOfh5BibsNN0vr637OmP1k3h778mNsH+Gk42K9EKIEr5HU0jdteeSRM6tsU=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SN7PR10MB7001.namprd10.prod.outlook.com (2603:10b6:806:345::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.10; Thu, 9 Jan
 2025 15:00:49 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.8335.012; Thu, 9 Jan 2025
 15:00:49 +0000
To: Joel Granados <joel.granados@kernel.org>
Cc: Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <linux@weissschuh.net>,
        Kees Cook
 <kees@kernel.org>, Luis Chamberlain <mcgrof@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
        linux-s390@vger.kernel.org, linux-crypto@vger.kernel.org,
        openipmi-developer@lists.sourceforge.net,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        intel-xe@lists.freedesktop.org, linux-hyperv@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-serial@vger.kernel.org,
        xen-devel@lists.xenproject.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, netfs@lists.linux.dev,
        codalist@coda.cs.cmu.edu, linux-mm@kvack.org,
        linux-nfs@vger.kernel.org, ocfs2-devel@lists.linux.dev,
        fsverity@lists.linux.dev, linux-xfs@vger.kernel.org,
        io-uring@vger.kernel.org, bpf@vger.kernel.org,
        kexec@lists.infradead.org, linux-trace-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org, apparmor@lists.ubuntu.com,
        linux-security-module@vger.kernel.org, keyrings@vger.kernel.org
Subject: Re: [PATCH] treewide: const qualify ctl_tables where applicable
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250109-jag-ctl_table_const-v1-1-622aea7230cf@kernel.org> (Joel
	Granados's message of "Thu, 09 Jan 2025 14:16:39 +0100")
Organization: Oracle Corporation
Message-ID: <yq1ed1c823x.fsf@ca-mkp.ca.oracle.com>
References: <20250109-jag-ctl_table_const-v1-1-622aea7230cf@kernel.org>
Date: Thu, 09 Jan 2025 10:00:46 -0500
Content-Type: text/plain
X-ClientProxiedBy: SJ2PR07CA0015.namprd07.prod.outlook.com
 (2603:10b6:a03:505::28) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SN7PR10MB7001:EE_
X-MS-Office365-Filtering-Correlation-Id: 57ca7bf9-9646-491b-b6df-08dd30be6736
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?1s5eliMSE67bSIt5uQKs2IcnP+0PNCj0WZFBBku5t3uvZomcBm6xiJzzqgmI?=
 =?us-ascii?Q?+XHPLdw+eszd1/QyQrJPQNTTQGoQ0r6A7EHV4YmnZxrMySwRwTMKbnLRjstN?=
 =?us-ascii?Q?jPHt9B18dW5Jc4xUXfLdJMTzatVzshMrKqA/ohaLOkvQRuMJS1QLxJyXvUeb?=
 =?us-ascii?Q?vv5bbjR698U6ikpCZ+PLDFxq5eQ7AZjJs7PdjSCX0pwbzzxDimK80RdbgWGf?=
 =?us-ascii?Q?0AroawK83y5svXx6thDxQjQgBnz4+K64uryopn61Qr46+fQoncUV5i3LKKkg?=
 =?us-ascii?Q?2dOj2x107aOMexqiLArcaMJw7RMKWKtjw8KPvref/3xYIQWalB5vv5y/sn9G?=
 =?us-ascii?Q?hvSfmB3g09Thi1y40nIwusr8OgBFBlSWfJsdvUnZn80PdR1vWrqXTbMJovp1?=
 =?us-ascii?Q?ocEfIVEqBsppyY1WVbmKSpEqYmMlxiIGDBnF8F0p5CrEnsAvXB7Zpi9GuhiH?=
 =?us-ascii?Q?OcbJRt8veDrcu84G9H9eshJunDn9D/un02cG6x8/lMF7M2vd2XL+hW3HGmjL?=
 =?us-ascii?Q?ytkwL/frvsBE/nhleo7zBNXarmoxAtTjjPvSSrMf5F4mVADVMgL30MERFK95?=
 =?us-ascii?Q?1iiHhz1qvu8Ou1hlsxWqHLO90O4fSUounpfRNbzEuRbhIQvel4J+m7ZHXb2m?=
 =?us-ascii?Q?iekRVTSZBCwbNUinUi3LYCfHeBkXjcK3dPKFVFZjUVBmC2LrOrV2nHDtOG3i?=
 =?us-ascii?Q?q2X3joQYJ/tcR9bDhRPZ5tlRikiBOT7VE3yURFC3rNNCZUEa+hOxNFvbYkrS?=
 =?us-ascii?Q?nl5WnQdvm2IM3bafp7Vo+6wNAMuCI3wZQs6j4eAGqKN0KEU0S1Dxh70d4axv?=
 =?us-ascii?Q?H4wTt1q7pr28TlIFNl0PfctPMmHJBdcJaHzBvbNTo5KVYsucjQxhxmDNUVqr?=
 =?us-ascii?Q?8StZ2Vkasxkex+OFgjsBcMUDTR8B2qFSb/MRPh3Rh1+WcbkCGcwPup6I8zpJ?=
 =?us-ascii?Q?1HjTT/a+amAxP4yi/sW4j8pWYTBx2CZIy10YJ8Tbdydy/HH8iekZVSEzxBqn?=
 =?us-ascii?Q?Jv47TpOuTl9MigO3m6ov/6gf71YaU2xnC1/mmgej/oy+twi3Uvr1RJn3ptNg?=
 =?us-ascii?Q?g2cA+a6gKL3SYY9phppNZAe/eEHK1wsx7dhMve3MOpgxGW2qmGa2yQc9AsJO?=
 =?us-ascii?Q?WvFu0MdkMAVN0hJiyMVjuhzicu583QJ58PtDQibgopUVAbCmGMakal+G1RxB?=
 =?us-ascii?Q?HviCgXT+W/c8i1o3H/BGd65sJtxQkFz+3gWKKrITHpS5j7KccnOZj41Sd+6O?=
 =?us-ascii?Q?b6V0wjDzzI1q6lMPVkHyd2rO1/CRq0b8VAvxZWU0oj1z2DJaqoWumNSbr7R6?=
 =?us-ascii?Q?i+w2GAokUpbp82H6N/M8tL4IKOntd5dzeuv1zxQP35Rv6TkvI/xFtagtT+Hc?=
 =?us-ascii?Q?IGINZ4zJUJZy40/LyzmX2agqnz3K?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?WZNn6E1Pa7bGKzLrcJDJZOlfoqcHArJ/1AObxs3buzZgzUpMr8lBMjhap0F9?=
 =?us-ascii?Q?mYMw0mCidu5gzvLAi8PBvxj0uhCHw9K3LgPDSnmUwTYcICw856X+uMf30Tho?=
 =?us-ascii?Q?3FDT/VmGo38Jwp53p8Bfm8qyxp/0LytCAwqwBlGP8VB6MT1LnVmLBLM9uRvY?=
 =?us-ascii?Q?kA3haz6zRHG5ZBQPXop+/6efFgCuyLTz9CCNFA4e0Z8WgSAgJKsQrMsQSN1j?=
 =?us-ascii?Q?qfd2Nxs2aS9uWBaVrZLtVdaco5UmKyhfMudR9asTb3S+nIh/A0o88X3cMlJ8?=
 =?us-ascii?Q?7qQlUIfjM8/WIj3VP4zsJLfxe4UKkL8OnT9BcfIS9GZwhaGqGbKbR+D3jtof?=
 =?us-ascii?Q?rp0tMONITtuY4+MGPUBAtzGYkYwW/6GaTFOibH9vZ0arw4NzmWgaOv8JtRjO?=
 =?us-ascii?Q?oM27MHfMuLwrHzGtM2pe5ezq5WyS6/bWGLo/JLtWb85ItRkBNeGKgSFNXdWj?=
 =?us-ascii?Q?K0WkUnbkLQ3erszvL93qxuLf36uMCiQIrjvziGhCA0AJYJ8O2Q4iV0QYWIWH?=
 =?us-ascii?Q?vxP7YlUjTCdESdXhxyN+z6WxZrd/O3bV77dfkk+l8RfodLl4dMIl3XCHazSZ?=
 =?us-ascii?Q?tNY19C1vkXbpHjyJagJ+Kipdphsm5Nfk029iSFbb7S+qG2POw2Z7OYg6MWLx?=
 =?us-ascii?Q?2KnKr668r8F8/DvynAy2zKi94Zfc+Ex6Ca8HiKQI55EMeIwKnauWfEmXqPEP?=
 =?us-ascii?Q?ybf1A+fy7vO52eWYrVIf/K58IT8RbOy9sXBULZpmF5XaQHLX3KE0Oz9USdQ6?=
 =?us-ascii?Q?YjQngikYaXNrgzbXf8Wsc/skw1gx+kck/Isa2JhBRBShgN8p9WZMyCn6gBw7?=
 =?us-ascii?Q?gZeqcEstNVEKVKK2fGZpkEEqQhmXBcVYFDjY0YvaM5Ceb36ussgJb9YzuNM+?=
 =?us-ascii?Q?zNMSL9o2Rf/sy+xyqe4MTCL8lykXCFbysWguFjNzmXidVzssSDfRv86/cWR+?=
 =?us-ascii?Q?yDIFJpwzweS2h7eoqDO42g0M2HJF2SC0eGjcs5wKAZB13Qj7CyhK7NED+ynV?=
 =?us-ascii?Q?9Q+gNeBoZknbT1X1wZqhrHD5nU+0VQpEhGVKoTYqYp7CRWmdcB6OoMUyXEL6?=
 =?us-ascii?Q?qcQsmxq1otuQP6/vvFXSBbEdxHvE1fIli8t4pxe4PE57V2sHk6djEeRDXxxZ?=
 =?us-ascii?Q?KE0gE0FpKS75eQDRfCZM6yiSgfEs181Te4+8TJpTQ7/2MIVZHG4DkZvtF8In?=
 =?us-ascii?Q?tJrfIrZnPLTE7hb5rdomq6StRLsCkRDPbxpgS4s63GjDXzeI8a7kF6is6GQe?=
 =?us-ascii?Q?MoFw9u2F5ger1qJ30DJuI6ISnVE17NaPINaCxiXeNqNwSfjfizMnMXBRGhwy?=
 =?us-ascii?Q?23RsyQHncvlXPZvcSYXA4FijIuCYOrky+B7oUBqSgdI9fRP84jQbXI/OJDx2?=
 =?us-ascii?Q?uz9U6vTi0uB1nHn6NCs1aOAac2w28+og4LYyE/9//S3ek+8P6IlaDGipvKYV?=
 =?us-ascii?Q?QagAbCVxdUi7LZDS+55o4HF/1TiL5nCXySk+mRU9ASBwxtuDZsf+OPpiIJeJ?=
 =?us-ascii?Q?tH2ppTFQ8SV9JH39LgIEe3yoPCXUojgQHKGRFVPAnLGqFj/Wy9p8fGHjvKCY?=
 =?us-ascii?Q?dxwuK/flWMBwLr1owtHdeGOzFj+sbzhcHME3fP5Sd5WDvk6BgqYwvUYSM3Vu?=
 =?us-ascii?Q?fw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Z2ezp0GeC+tCAty8oNhH+Bxy14WAfO6YLudztqZns732Dr0QNSgcWLPMEb56XKYzxsISMSnUx1GkxolfLHx8QwH3aPViqoqQPRniwzxVRHjbJRNQSnKucs2z/YFx9ssTzXfjE0G3Qi9taDO5X17op/ReRjMnQ2OQAduZfRc9Qqy3JDI/0eXh2ZWUSh0+GDq+BQKFROJVrTHTnW2o6xNdER+888B1/cz+pmLrD0EvYPmvjrCKQBpkGB8IZYwKuLCB4t0pzswCmFKAxhxYYTuLhER6orCrIWpsZoXZxRqwUfindm1PxU+UfzvfK2NCcRyOazoVvYNENj9yXk3leqQ6Y8l2ijF/gdhZzD/fZZQYvnAc7LEKfcXFULkUL9vbaZTMBWRUAXJuAW0gRCuvA9deA1xfXb8yzPHxOiszwK+r2qgMTA5ec9WUelk3pY8aeq3FQnHvnKk8ooLyMCpeUisQFjoKRzVWGyRWQ8J6T5YYj+xGYdFi0F9jGWX83dtphIz6bHam3CAuzy/gpWh1k+to6CNnv2uO6iwMHozr7LpA+r9oYSwJ8o1AN8jws6/8kVKYGulR99qsLzEvnjqFQNQsyA96ngiGqmo6v1xIeg2yoiU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57ca7bf9-9646-491b-b6df-08dd30be6736
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2025 15:00:49.1161
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: leHSaRakdAn44d9JTPJGGjwmkjIzP6V+HUsYDpT9nyRHh5QA3A00LFHg8x0aOHYjIzoJs/bIHXolJQXc/ZKEsw5B5oXtdGA/kAFQ3UU4rdI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB7001
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-09_06,2025-01-09_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 adultscore=0 mlxlogscore=811 suspectscore=0 mlxscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2411120000 definitions=main-2501090120
X-Proofpoint-GUID: ujTpPHVSX-fTLPpls6O5X7zV8q5ouFNE
X-Proofpoint-ORIG-GUID: ujTpPHVSX-fTLPpls6O5X7zV8q5ouFNE


Joel,

> Add the const qualifier to all the ctl_tables in the tree except the
> ones in ./net dir. The "net" sysctl code is special as it modifies the
> arrays before passing it on to the registration function.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com> # SCSI

-- 
Martin K. Petersen	Oracle Linux Engineering

