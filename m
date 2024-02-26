Return-Path: <io-uring+bounces-747-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B74A2867ECF
	for <lists+io-uring@lfdr.de>; Mon, 26 Feb 2024 18:39:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3F9251F2C521
	for <lists+io-uring@lfdr.de>; Mon, 26 Feb 2024 17:39:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 504DB130E48;
	Mon, 26 Feb 2024 17:37:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OWIf7qT/";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="tEbS+H66"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FEB3130AFE;
	Mon, 26 Feb 2024 17:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708969054; cv=fail; b=kK8gXfkzYseAkLtkuG6RXQ8Z8AV25LWpjYSq/DnXnWF5irMgM/Oa2P8zVBCxdv0XOiRkl5MZ7dyMDg+baauJCPGvVN+w8O1MiKFzbJlb4ryyuxk91Eon4YiYHi4f1nGsggapPxzTcGCp0+3gruRO0V51wVrXDjZ31fffQBsxuRg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708969054; c=relaxed/simple;
	bh=r2t2Gb6tJ2UpHpS4SYaN/zyB1MOBuV5X4cuCULJ+l5w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Sf3Dofku6y54QaVRIYBfJlet6gb2bfT9EMGgjtmSUnBSuqVxpS+lrTtuGhI8bV3I92SjT1wlR+FsDs9hdVm7MSC3N0pKvgzVPTf68OWpEALJTxAce1tbWakkhIQaOEOm67JLPaWf8YDD1CTZ2+C0bXYucFwhW3scUCk0l/0GIiw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=OWIf7qT/; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=tEbS+H66; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41QGnHKr018491;
	Mon, 26 Feb 2024 17:36:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-11-20; bh=zqCzZ+1bbnc9VZ0wr101aGS3Ip3L/kml2Yi4LZB2clQ=;
 b=OWIf7qT/Bj7Y8SkNsEqdaBcJ8ncSsFEl6S7HP0lXm+i+/jI+kh0CygzahjiM5Je21RFu
 XqiqiWDe6ZUS37sooep8ft9guePDLb9RdAW6GNAMShsZAyvrbVt1WhMpiqL3FBqoIL34
 fGGEYtZK3GidjSaipfOI9Hwno8gaUt3hzp5c+JHbFO8kag9FmvAMYCLGDZUWfCmVYUmk
 aa8EScBWlxlKBcfUVSQOQNL44C+/P6F4fzWGYSkWuWrf2GuD7YQieE+WnkXeJJBXJzUJ
 DpipU8R1B86ePaLp+MMA3wAoRxs1eUFovKnzBX0AjDIa8p+P91P3LKeo+THZ9o5/XwDW og== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3wf8bb52fd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 26 Feb 2024 17:36:56 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 41QHHY5X009853;
	Mon, 26 Feb 2024 17:36:56 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3wf6w5wacj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 26 Feb 2024 17:36:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iwZW3c/AJpwjhWy+z4/C75vWvTJrPThuSCKDYvRR9Qddj0BXEFlXUzd3r5QH4HnB6F2zcltURPXKY9NpIbJf8KdJT+NPcJIBQjiykSUm6+nUo+ukFLxEKog2Fen0r7Zt2I8Y03SYgJwvVATBWXASaKNqVmoPVP07sFunlvEg0grpbBgdL1s+ytFmUj9HI0eHRT4EtmbBomceWnfA1n6ffwirXQXMi2juyZGLNnVn91MSZstfnVZUWIXOKfHlxfovgX1aUfnrt8bU0J6kMN3W1d18aYVPJ7cerj6p1FkG8q0ZPZcpTUajG35owJEfjzyNvlRz/biwtliy2ZM6i5bMPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zqCzZ+1bbnc9VZ0wr101aGS3Ip3L/kml2Yi4LZB2clQ=;
 b=TM7KQYKoxDqQRXkeSX3UZg9D4P5UXI7hTtxAAaU8gFjBewUpsKiVJOSZo0E1cgEL/N9O9Iv963RIYLreG318NmQrtuaSkV4NoRdln5DjGTQksGjmGp5b+lCGaHC2UnAwTp0FCkPOtPG7g6LwzZaNmapg11yafUCaU85avwzL4xKz8bvnXjbvwCZGUgnCDkc4oQ2PdSbNEusPctn9UGHhNIbEC8ePq5xcz6Mk51IKxrf+6BUXqTyNmaZTi0DFp9fjslzZ13Jzlpiu+dLXnUpBRNO885nmGblV0eIQw5p00By95DYJXFlCJA+uHGr1aihxQhQqqs5dfNjfIsrXiiP6og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zqCzZ+1bbnc9VZ0wr101aGS3Ip3L/kml2Yi4LZB2clQ=;
 b=tEbS+H66agjzYVzpND7YdMCZoJB39PQgy+db9zKpjD6CujQLJ2zcm8BM/O3tdZlJPn61ExnGNQ9kgL4X3nmv/oO/Gb0axkiLo25hEL27ZQ5gwdRkvQbkGppfdxXczUknxv68YDKAlFI4AVqVx1w/b30OsvkeyOzwsjZYxsqTq0I=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by MW4PR10MB6298.namprd10.prod.outlook.com (2603:10b6:303:1e3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.34; Mon, 26 Feb
 2024 17:36:53 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::97a0:a2a2:315e:7aff]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::97a0:a2a2:315e:7aff%3]) with mapi id 15.20.7316.034; Mon, 26 Feb 2024
 17:36:53 +0000
From: John Garry <john.g.garry@oracle.com>
To: axboe@kernel.dk, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me,
        jejb@linux.ibm.com, martin.petersen@oracle.com, djwong@kernel.org,
        viro@zeniv.linux.org.uk, brauner@kernel.org, dchinner@redhat.com,
        jack@suse.cz
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        tytso@mit.edu, jbongio@google.com, linux-scsi@vger.kernel.org,
        ojaswin@linux.ibm.com, linux-aio@kvack.org,
        linux-btrfs@vger.kernel.org, io-uring@vger.kernel.org,
        nilay@linux.ibm.com, ritesh.list@gmail.com,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v5 07/10] block: Add fops atomic write support
Date: Mon, 26 Feb 2024 17:36:09 +0000
Message-Id: <20240226173612.1478858-8-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240226173612.1478858-1-john.g.garry@oracle.com>
References: <20240226173612.1478858-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7PR10CA0003.namprd10.prod.outlook.com
 (2603:10b6:510:23d::24) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|MW4PR10MB6298:EE_
X-MS-Office365-Filtering-Correlation-Id: b386c6c3-3a08-4d2e-f100-08dc36f18599
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	Pdpw0XW0PaRRe5A3bUquw/VXLvmMKpWTGuu8wzdf3Ahmrod1vFq6uiNDB/r+KomSudDy95RRaSvauG07ojCQv4y2i1rsFdRI592csJH8dJa+IIZCkhTffuUnwqvMQ6cqJnHN+NEcAZli7Lafh4GV8O1rGAWE7TiPPRKDTfJ82O/MKs9UbiTgFVf0d0giYcUMqZn9TINTdS4mq0gsq7G+tAAuXTFpVnW0fTh6bspbiYYVUBJnUDBvZFFxvFDxi5zZMu1gUVfZgTLVzr0FWq5NDFDiRUaufoJkHe2hJKSnmWvMdln7uVquF8FIYFKMxcDw5a92pyKtYtW8Xq2FBRHUEAG/8vk6TSMnKM662JVj0HyE2JJea0/YNIFxYt3PmrN6DnbeA8BVPNXJJ8NHXBbM8kGyx8yprmwS9gJyLifyrI3H6IIYmxAFiuhePLHgeShQmle99Txe/vIP4M/Kn8MT+CFNDjzXxdrKEiymljkQGg303Wz/Kjy4gQ7pL0dhdvgaa+zJ9JD5U1QVBOSgpwZTFRhnM6cOYVTKnI1dVtCBAHigOjsIj5YRMWJpviqXsAkaDzOnACY0puPkAsVoJns5MlXjdMz1u3f0wCPobKcYulH+xQZpu6EcC67sLVtn8/ZlFewqR/RknKw82V4CnOkxYXz2g4SV6cb2q4gXyKx8lGpYFydLCOLZqg37v0bwL9ZYeMsCmO9onK0jzgIqSjk44Q==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(921011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?G6Bckomjl1VSue9K58ds8UDuGDUGerJu0Cm7KsEhtTZfakXSoUU0ljymPyAo?=
 =?us-ascii?Q?4y0yaphY2yfN+a9inTdgbdsFQqhnR0EknkoLO02LWt4C3yVA2vF9dXeCq19l?=
 =?us-ascii?Q?KCDQ6Ucr0iHWawLxIuyx+gnz5eaGVzs9YGuhyRKMEOW/8hzd253URDGvRpFN?=
 =?us-ascii?Q?oFYTG+fOuNavlJDj/YRab6baCY2VBbWBIEOb1AP81jkm16tRxN5sopRSEez2?=
 =?us-ascii?Q?63b6ihWLIsZbWgpK0RFLT+ARQvdCcWM1z+qC9RsuCJQFlRe/iRyFHuOpP9Xd?=
 =?us-ascii?Q?v7rIacq5EpQvUK3ocX14Tire/6uRWhpXzuMcHKPCa0SG6Gej0hb4XKGMPuLq?=
 =?us-ascii?Q?/E5bJ/ejP11CWoK1G3/yEtaBUB7IhIu3CHgIUp25df+PzbAlJAko7P12OQ7Z?=
 =?us-ascii?Q?sbyFAChnGbyoyAZR1o0dmVTIdkJsaUUfHaJo29ojZ5/jXoGEYS+gSObum6If?=
 =?us-ascii?Q?bWEom9qVajFtE+m06jvHIUj35+ixS7dcQlVp14RFCv0zhxMR9Un2IsKXmO11?=
 =?us-ascii?Q?moOBPfBNo7ab/2llM2OnFo5fWmULNmRcfhP1yZeabiwel5xozCAoYGdy3iM4?=
 =?us-ascii?Q?XKufLKyftRBOj4Vz9Me1Ffb+KtnmnljEnEoFTLreNPTr3vKpIHz4vq4HA/bD?=
 =?us-ascii?Q?+Y/fSD/PINMbvkhYQC8Kir5K3PF0S+AcamfNfosL3FoF79O3D1J7qLArNQuX?=
 =?us-ascii?Q?UMkiO37C+9K49XeLdklJdrYhEHuokYsHDzq0LYV2e2/axN1bSCroEVKKCfgG?=
 =?us-ascii?Q?8qGlXrebmzhXn0Hl3LEZTIXmq1sNnrXLd1WVmOSzg1VdNvjVCmUshF7tBl5G?=
 =?us-ascii?Q?4CGvuIkhwD15BsoqxPJrcd4vCm/7Ss4ELcBIzBgxrnAvYoEYt7+ak7Dbej0w?=
 =?us-ascii?Q?yWIisDpDVepfAHgJOGw6Bgg+2Yun4Cdl9bJYII3mblQX4yGjtrBXMY09BLYM?=
 =?us-ascii?Q?eYwMq8LEgnBSbnPYbG6kvaltTQe34sIy5aH4SAvyM70Mt/14nNl+0WUthVe5?=
 =?us-ascii?Q?owKPuxpid8s+/vvir+DwV9F8tavYej1X0hlvu6n3FjOR54WaUUGGwyYQTUFK?=
 =?us-ascii?Q?zlJetdwqALmJb8BBNxR3PJlthLxFnqWNFUfP8r65ELKC8Foe6Jo00AUk88ib?=
 =?us-ascii?Q?Hez8hX851m+kidSFuqFoCYkhxrOGdz5ddNYvLDaPe9mNzU7eOhTqaXilmQzk?=
 =?us-ascii?Q?HlZboehM3Dl/wFSauukyWmJdpJT7bwP3qe6TZOtXJbFzArYmOnBJjVWmZBMP?=
 =?us-ascii?Q?rnLcBdDAbtt9zq51Z1k85oHyAXsjfdd20h4/OR5ww/n3MAXpnkZApY9HaZHN?=
 =?us-ascii?Q?+r1buLOOXaffSan9xSopRA6X/cUzAUKzXn61dnz6593YQhmM/v9gr7IiD1Vj?=
 =?us-ascii?Q?wvBlsEPSdT4emDjeY/nD7MBWuU8AbcY5pgEqmmiCS1zto6+gpjvnI+gl6PDE?=
 =?us-ascii?Q?N23D2x12dOMoaUe4/gisLBWBmib3yA495i5RdQZTDHR5hwY7Lszj20gD8ZJd?=
 =?us-ascii?Q?PqNxFGMzLyn8OYhONsTvgVWtL5W8X+dMYwLGirsc1BdijNPwRWF8jsLBXDCD?=
 =?us-ascii?Q?BQdluq/nkC5KfdPfQP45rVM4C/BUg/MgoRt+3zn7jP5mmQpvbovQTn3uD05s?=
 =?us-ascii?Q?9w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	5QMyxsdah2A8w2XSw4K5BOjIVi9nckHxGC0hv+C6++DucAJUYB9Kn9GOiAf6UYDOzKQ7I8N+SiP4yG8/6DNEIP11LE7J4gaGZvCXL7d6eVWwSCsQFReyg6pk5dieI8JHZb26czBH7GiiKc8ltS1xmGBSWKcOPNBzN/C0KIHUTYt84ESvwZISp9hfLUYgBShYz8WuCEFyJVQiy8XOSohsgP8jBwvDJewM4vTS0RmyGN4VMjwhXlKn11cWDHPqDHyzTVnQahfSn0dWfFePCeIHFGZ6YaPYlNAq+ZGur+DgCUPWQeKLCVIv77koDZXAbmkMw0EPX7DQmoiyFdBCrBs0BIs2rJnQ0L9AyV3fBLdXFlmemfkrIkpnwbtYMrUDgdg6PWwaywqo5tzw0j6qooXUVi5Swr+gk3YBe8lyJS1fh1CX9brwGLvgHBi5G+cit7aXCEJvN3lPeIyPoJ5Z1ZdUlHc+CrhWnkoYfb3nsz5V45e3RucTaaEQ9WVTioGYXfQL2A6SzzxZXIgpsju6utjyylfFqQ9uJ2fkn8lY1onCHUEvAXp6V2pB+oihcdQ0MpkaiMdJfZZS6QG18w1ut8jf/SyBeO0VBGl9yQjze9gu6AY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b386c6c3-3a08-4d2e-f100-08dc36f18599
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2024 17:36:53.7584
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cRk86lElwN+8uUtT/tmWJQsEw7SnAzMEaYcs3BCtkDdtEE5V6zf7QRsnR3+PjENKbe6OgbbPhZiBguobJOR6ug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6298
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-26_11,2024-02-26_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 bulkscore=0
 spamscore=0 mlxlogscore=999 phishscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2402260134
X-Proofpoint-GUID: IPQHUXO9G5UNkW2KRXn3jgxV-Jw6EgWG
X-Proofpoint-ORIG-GUID: IPQHUXO9G5UNkW2KRXn3jgxV-Jw6EgWG

Support atomic writes by submitting a single BIO with the REQ_ATOMIC set.

It must be ensured that the atomic write adheres to its rules, like
naturally aligned offset, so call blkdev_dio_invalid() ->
blkdev_atomic_write_valid() [with renaming blkdev_dio_unaligned() to
blkdev_dio_invalid()] for this purpose.

In blkdev_direct_IO(), if the nr_pages exceeds BIO_MAX_VECS, then we cannot
produce a single BIO, so error in this case.

Finally set FMODE_CAN_ATOMIC_WRITE when the bdev can support atomic writes
and the associated file flag is for O_DIRECT.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 block/fops.c | 30 +++++++++++++++++++++++++++---
 1 file changed, 27 insertions(+), 3 deletions(-)

diff --git a/block/fops.c b/block/fops.c
index 42955b6a1f5e..3f61b00994d3 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -34,9 +34,22 @@ static blk_opf_t dio_bio_write_op(struct kiocb *iocb)
 	return opf;
 }
 
-static bool blkdev_dio_unaligned(struct block_device *bdev, loff_t pos,
-			      struct iov_iter *iter)
+static bool blkdev_atomic_write_valid(struct block_device *bdev, loff_t pos,
+				      struct iov_iter *iter)
 {
+	struct request_queue *q = bdev_get_queue(bdev);
+	unsigned int min_bytes = queue_atomic_write_unit_min_bytes(q);
+	unsigned int max_bytes = queue_atomic_write_unit_max_bytes(q);
+
+	return generic_atomic_write_valid(pos, iter, min_bytes, max_bytes);
+}
+
+static bool blkdev_dio_invalid(struct block_device *bdev, loff_t pos,
+				struct iov_iter *iter, bool is_atomic)
+{
+	if (is_atomic && !blkdev_atomic_write_valid(bdev, pos, iter))
+		return true;
+
 	return pos & (bdev_logical_block_size(bdev) - 1) ||
 		!bdev_iter_is_aligned(bdev, iter);
 }
@@ -71,6 +84,8 @@ static ssize_t __blkdev_direct_IO_simple(struct kiocb *iocb,
 	}
 	bio.bi_iter.bi_sector = pos >> SECTOR_SHIFT;
 	bio.bi_ioprio = iocb->ki_ioprio;
+	if (iocb->ki_flags & IOCB_ATOMIC)
+		bio.bi_opf |= REQ_ATOMIC;
 
 	ret = bio_iov_iter_get_pages(&bio, iter);
 	if (unlikely(ret))
@@ -340,6 +355,9 @@ static ssize_t __blkdev_direct_IO_async(struct kiocb *iocb,
 		task_io_account_write(bio->bi_iter.bi_size);
 	}
 
+	if (iocb->ki_flags & IOCB_ATOMIC)
+		bio->bi_opf |= REQ_ATOMIC;
+
 	if (iocb->ki_flags & IOCB_NOWAIT)
 		bio->bi_opf |= REQ_NOWAIT;
 
@@ -356,12 +374,13 @@ static ssize_t __blkdev_direct_IO_async(struct kiocb *iocb,
 static ssize_t blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 {
 	struct block_device *bdev = I_BDEV(iocb->ki_filp->f_mapping->host);
+	bool is_atomic = iocb->ki_flags & IOCB_ATOMIC;
 	unsigned int nr_pages;
 
 	if (!iov_iter_count(iter))
 		return 0;
 
-	if (blkdev_dio_unaligned(bdev, iocb->ki_pos, iter))
+	if (blkdev_dio_invalid(bdev, iocb->ki_pos, iter, is_atomic))
 		return -EINVAL;
 
 	nr_pages = bio_iov_vecs_to_alloc(iter, BIO_MAX_VECS + 1);
@@ -370,6 +389,8 @@ static ssize_t blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 			return __blkdev_direct_IO_simple(iocb, iter, bdev,
 							nr_pages);
 		return __blkdev_direct_IO_async(iocb, iter, bdev, nr_pages);
+	} else if (is_atomic) {
+		return -EINVAL;
 	}
 	return __blkdev_direct_IO(iocb, iter, bdev, bio_max_segs(nr_pages));
 }
@@ -615,6 +636,9 @@ static int blkdev_open(struct inode *inode, struct file *filp)
 	if (bdev_nowait(handle->bdev))
 		filp->f_mode |= FMODE_NOWAIT;
 
+	if (bdev_can_atomic_write(handle->bdev) && filp->f_flags & O_DIRECT)
+		filp->f_mode |= FMODE_CAN_ATOMIC_WRITE;
+
 	filp->f_mapping = handle->bdev->bd_inode->i_mapping;
 	filp->f_wb_err = filemap_sample_wb_err(filp->f_mapping);
 	filp->private_data = handle;
-- 
2.31.1


