Return-Path: <io-uring+bounces-2149-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C00C901FA9
	for <lists+io-uring@lfdr.de>; Mon, 10 Jun 2024 12:46:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1D6131F25CBC
	for <lists+io-uring@lfdr.de>; Mon, 10 Jun 2024 10:46:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37C3B811EB;
	Mon, 10 Jun 2024 10:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="K+CKzg43";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Kc0q8vTQ"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C0067D40D;
	Mon, 10 Jun 2024 10:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718016286; cv=fail; b=Uz0preQDM3xq1ham0kcxBPVrUIj3/GfvsxlLdK2Kztc1xGINgGWipST4ISIF/4o+omNOcxocdM8jvZ9tnP/T3ImXaU47yY1KXvTMX8tHCOWepRuH5gMKqrbPUJRRd3Czm3+ZMXf/5561GdjC6vmc/BAZGnenwqTbQ6ByWbXbfVY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718016286; c=relaxed/simple;
	bh=MdlkzjsYYYVVarowseJ4XMT1HSaq6/kgtFq4jemo1c0=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=JP/h21DNotrQb1W2tqk5NhZhLl50MUrhrE0F4yXmYDOp8VO3fmWOsOn+rkYKGapTvcjGC//dJSwMNHtNcSR7qRnPZdt9VAjfatQ42eyBV/Rqp026zoslKklUxuuD6QaN6GEM9SyxWu5tbe3cLaAnClzJiQMEDbxLvDz0yX+DHmE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=K+CKzg43; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Kc0q8vTQ; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45A4BPlT004388;
	Mon, 10 Jun 2024 10:43:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:content-type
	:content-transfer-encoding:mime-version; s=corp-2023-11-20; bh=h
	aMsZt7phP0+HV3yXxVNdQ7a0RsV577Lj/5dXSip4Us=; b=K+CKzg43a3Mhnc52u
	0WD6UqmRdIQjSA96bH8hrH8Guglmg+Q9WENIQS7bj+xFDMSoU6RwxyrfGirEI+X/
	EzNA/erFijnM1CzuVpsgUr3qCj5kQolYnUkyHRlsoTNuSmtrZBCMdX9V3JBQ8fMW
	Dal1RMsJtfJwiLy8upz/4tKBW4WXdIl/Y29xwGxxq0+5T9iRh+A17I0VfPemWHHl
	Tdfoch5Vt3VVqWoIjOeqznv20ntBhcXYGO3dEeD53+ESeGmlH1VlpTQpzXG+ihTV
	kWIJ9grZFzQSf8EGjrzXnli+5j5pRABiDyKL1a9dVhpR/MGhRidiT6JaQQ62OZ4n
	FytOw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ymh1929du-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Jun 2024 10:43:52 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45AA6Tpg036558;
	Mon, 10 Jun 2024 10:43:51 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3yncdukce8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Jun 2024 10:43:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cTQkvdG6PF9wVLdPs5dF5xlKCpNSb+ZdwBTHvsGtSTb3u7B4lozUL50zgmMNuvvbE1TKk/k6fG5pYrmVWFxfhI8T4CFo1Aw0AKANLhnCYM7mOASd0TSIJK9+10sl8AEh6EZxXnW7eWP61uyMZ2O9fOhyfkR04SPeBcBA4kM/Y4t44wttZDP4Qo1+3I4bOCIlxUO2PGUzoZCB7sWTjai/exS18Iu945nfBB3sHeSXG3BbqfHERgSF7Vb/N/85RsaGR+rOiU6I6G4ZLal3QUFb3MJ4UtEZX9SZ14ePmiCAhHOnc6OfXDWsb1pqZe2Yy+ow5x8gXt7wAecoIFnBOyIhtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=haMsZt7phP0+HV3yXxVNdQ7a0RsV577Lj/5dXSip4Us=;
 b=JPwQSvTF5/EuJ5OF0txSS0WGDyirtpXfY7V7AHrYU3UsK8E61r6Wp+G+nN3vfKQaswCpXPL8WJBsXtQuS9LLzlqhFhpTdOsBja34X6H0HM7glfGfGLDV5YWnMSxd7k0D6F6jCPaYf8qgOaFffgBTDVN9B8796UM30SvyDPidFtU3681NrjA3sRoRo+uMnIynhG4YNxG8a3+MShrVVwEoVdc1B2BmBuVmpyothl72CpxZp4Hs7e65eVsppHVBdo7CERYIhY6YjNN8XP859clyc3kOlTtTT/0+o3fQmB2RrgGJ5PGIfqcVxuu4zxZihd+4d0BVM+5Gl06OMoyHcMUlaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=haMsZt7phP0+HV3yXxVNdQ7a0RsV577Lj/5dXSip4Us=;
 b=Kc0q8vTQXT5yGDJh8GXmkq7PZNljrNw0Wonhnl4Ofy4kRwjgoiBOy2u/QtiSj23+QdGRo33bDhmYxNouMxJyDVzosgFlX5jxaggQVA2NlKL+5fnws6VHWJdwF1V3L/wZ4gDYrgjf/L5R+GbKI1UAc6brTkanX4IbmTa7lt4g0XI=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SJ0PR10MB5613.namprd10.prod.outlook.com (2603:10b6:a03:3d0::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.31; Mon, 10 Jun
 2024 10:43:49 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%6]) with mapi id 15.20.7633.036; Mon, 10 Jun 2024
 10:43:49 +0000
From: John Garry <john.g.garry@oracle.com>
To: axboe@kernel.dk, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        viro@zeniv.linux.org.uk, brauner@kernel.org, dchinner@redhat.com,
        jack@suse.cz
Cc: djwong@kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-fsdevel@vger.kernel.org, tytso@mit.edu, jbongio@google.com,
        linux-scsi@vger.kernel.org, ojaswin@linux.ibm.com, linux-aio@kvack.org,
        linux-btrfs@vger.kernel.org, io-uring@vger.kernel.org,
        nilay@linux.ibm.com, ritesh.list@gmail.com, willy@infradead.org,
        agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com,
        dm-devel@lists.linux.dev, hare@suse.de,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v8 00/10] block atomic writes
Date: Mon, 10 Jun 2024 10:43:19 +0000
Message-Id: <20240610104329.3555488-1-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MN2PR13CA0008.namprd13.prod.outlook.com
 (2603:10b6:208:160::21) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SJ0PR10MB5613:EE_
X-MS-Office365-Filtering-Correlation-Id: 3b610952-dc7e-45bd-3a1c-08dc893a362f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: 
	BCL:0;ARA:13230031|7416005|376005|1800799015|366007|921011;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?ZWMvM1VsVkI1V2szN0ZhVG02RUtrRExyY1Fkb3VsZlNzYVk4QmZYVS9SQWt0?=
 =?utf-8?B?czh3aHhRYzcrTXhGOFh5RmdtblJ6eXR2NUs2V1FGNWlyZGI2M1J1cW5jTlBI?=
 =?utf-8?B?YUt0Z0JmNWN5QnphK0s5cjVCSmRJUHlZSDB3d1V3UEltY3VsaDc1a3Nicm16?=
 =?utf-8?B?ZE1DcFI3bGZQUVVvMlRsL0dCR2xCMGcvQzE4SDE3azZ2cHhoZ2tzV1JCTWU2?=
 =?utf-8?B?Z2dpcHRlRjFZVTEzY20rb1Z1UlhVZlBXM3VuQVhyM3RiZ1NqbUFXMGd1KzNt?=
 =?utf-8?B?cWVIWWIzZHlIWDYxV2dYcXFJWUVEaXRZaEpGU2wwdzhNM3A1R3NRMFI3My84?=
 =?utf-8?B?UjJRYVZTamtjV0NndzZUT0pDZTVzL1ZSSEU3NEpwMFdLWWZsOE9TUSt6Ykxi?=
 =?utf-8?B?RzEyaXFFVnRzWS9HVExYdE5tQ0MvSTdxbDR0WHpvZ3kza1hncGorbEF0Z0VP?=
 =?utf-8?B?bmR5OVdBcmlpam5LQ3ZHelhlQzFaSEhiYjU2OFByRnVzYzJFaEgrQWpWR2JM?=
 =?utf-8?B?KzBidHlYK0UwSkZKOXNXK251ODFXMk1pZFBrZXNKNkdYVlhCNG53akt3NFll?=
 =?utf-8?B?TGREU0JNSDgxK3EzTUgrZlEzSCtwby9lQnlyMGFkVGJXWFV2RXhKdU9Mb2xO?=
 =?utf-8?B?L1NrUW81RWZOUUoxdzdQdkRyQjJweDBwUTNoQXgzbjdLSk9CZDAvaEtDeHRF?=
 =?utf-8?B?OE5PeXNwNEwwNlNPeWoxZ1h0MjVxMVVMR3g5a2N5UFl0UWxaQXJESTlidmVY?=
 =?utf-8?B?bW9KVDI2NVNnNmV6U1Exdm12SXE1T0NlZXpQQWlPSXJGUWNCMmFwbVkwMVFW?=
 =?utf-8?B?eE1jSnpzZTlYNzFFWmtMQUVRZzJWeElmRlgzSGlQUDNwQkMwYkdqWXgzODR3?=
 =?utf-8?B?MVd2OHRZT1hjREdta0lZM2F1NUh6cFVIUS9aQ0YvWHB6aUpVMThQTml1aFFE?=
 =?utf-8?B?TzdMUWhQazdSdm9TMVFKbzJVNUpsKzBSU0hidDNLbHZaRjVobzlpdDhvZTNl?=
 =?utf-8?B?dnFSK0hXVlI3RzNCMVM1ajRQN3g1V3N3OVZhWmJZY0dkMEF3QTdkbloyeFBI?=
 =?utf-8?B?VEVjaXBlL1JuWHlCMW9VdncwTUcrUW1uQUZIQ1dQSXB2bEZrYmxleWRmSk9E?=
 =?utf-8?B?aXcxaW1WMnBHS0xoVlNCY3Q1MkFOK3Z2RjN1dWZvQ3pOSEwyRHR4N2t5ekhK?=
 =?utf-8?B?Uk51N3RiOS9EUTRFSnFURWVNbldOLzMwN1dYTG5pOG5meGJsS2Nlcm5WNDhm?=
 =?utf-8?B?V2MxOUdrdmN4Qk1wYW9RU0ozVkFVK1NQcWc4aVlSQzVFcm02cmpndkJmSUxT?=
 =?utf-8?B?L1VyV2tjaTl0em5IamJKTmpwTldHSllVRlE4bGh5S1prODFrRjk0eWZRMDdL?=
 =?utf-8?B?c1RLSnpQaVZ3MkI2cjJMeGkxYjY1anB2Rm93a1dzUnZHcFBVUlBHWjQ2ODVY?=
 =?utf-8?B?RzZJR3FEK2tsNnIrbDIzdmlBQ0NzNkg1YkpHU2kwWnhRZmcwY2dKYTU0SHZO?=
 =?utf-8?B?RjcrTUZIbEdPOG1WWlpUNHRQZG1YNXBrSHBXcGRINnF3b1RVVy9CTXlZckYv?=
 =?utf-8?B?dW8wR1ZGc3lyWkgxTzJobDJCOFRkeEYvM0dnZTIrd0lvWlBLTzFQelhpU3Jk?=
 =?utf-8?B?ODRuNzljVmM1K3RmMS93eXlLSEtDRERkQ2k4cGp6R2U4S1JXd3lsa0k3eGFa?=
 =?utf-8?B?WWlMWXJNaE43UXgyamlCdDArN1RHSFFNTitqcjdRaFZ2VytzL2w0K3lSS2tr?=
 =?utf-8?Q?OYiZfcl8c4fcRtZ9Vk6OCFizPk0vRsS34TUu/J5?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(376005)(1800799015)(366007)(921011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?bmJzY2k4VHJVWE9NdWJlM2FWbVZxdGR2eDdYWDJiaGNwZVBZdWkxMVcxZ2lj?=
 =?utf-8?B?TGcyZmtuSUd0VlNqcDRSYkNlRmprdWtyUzZkcVpkMVhFVEtDMFZlQWMrODlI?=
 =?utf-8?B?NCsvUytVdDhpRG4zTFFvS0hjWko4YkFsT0hEMHQ4WTB3WG56NUdPU1YwWlAy?=
 =?utf-8?B?L2hJWndtSHI5cU9UM3FVQzFMRVJLemROZ0t3RW05dTlrdjZ2Um9JWnhjcTFX?=
 =?utf-8?B?T3IyLzZ1b2V5V0xZY1F1RjFXcFMwV0xFdms4TS8yaWtnd282WGtCWlVvTnds?=
 =?utf-8?B?VVk5cmlHNDBUUnZwTllVU0lVbTZEOHQxRlNTS3Ntd21UN0d0anF2QWR6ZGRB?=
 =?utf-8?B?T0pWNFdaSS9YRW14MWV5Z0N6SmcxS2FncEp4bGxIdWRZUTEyU2ZBRWI4WG5l?=
 =?utf-8?B?d21VYVFGUXF1bEozUWh1OVVLV1JzbStNWkhKNytRRW5CV2FvT242bS9FWTRR?=
 =?utf-8?B?djdGcHo3VGxZeDMxZ2xlYXJaU1pacExQL3J1NFBBZDNmcE9NR2ZEWUFuMVd4?=
 =?utf-8?B?TElsYlZrNUUwUm92a08xSmdEeThQeENtYW1BRXRrbzliV1FjTE9lZ1hvcjd6?=
 =?utf-8?B?OHQ1ejFLUzViSGRSUzRra0ZVeDFqdksyY0diMXI5bGFiV2pTUWkxZGNyTWo4?=
 =?utf-8?B?eXVnRGI3bDFnaGRIcjZRc3hFdDJEZlV6SlZ1Qitna1RRZlh6K1dWRHk5KzhC?=
 =?utf-8?B?UFBUdW9GZDVEeHlGc2hTS1UrUUs3d2swRDl6cFh4QzJSZ01JWUE2bGZxUUZo?=
 =?utf-8?B?V3pEZWFiRm4wbVdad1pHZUh2QWZWSTdHLzc5cDltVE9vbGRXeGJXQnFmN3ls?=
 =?utf-8?B?cmFJcVVxUXZ3OG1yMUpwbHF5R1IvL1pkUUs4dldLelNmU2lmK2FyU1hHQ0lG?=
 =?utf-8?B?L2YrcnNGdjdvRi9Fdm5ESGVEY3d0V0s1cE4xSHp5ZWxqYlNBMEk5MUU4UFNU?=
 =?utf-8?B?ZUMxUFVpZEFPMk5jckMxVTZyclpka1dLUXVJT3dHOXhRS2F3Qm9XblhxdEJy?=
 =?utf-8?B?d3M4QkdlUFBrL0xTVG13bjR5N2c2bjMwMFMxeitudk53WDJVbWhVaDFLdit1?=
 =?utf-8?B?NkRZWDBxeEhuMVV2V2RueW1uWElEQkt3YmZHaTlKamhIWlVRMEZENVdGTUNG?=
 =?utf-8?B?Q1IrbXlnRXFkVkQ1MzNSN1FEd1JMQ3RtL2x1QUROTlVmZXlMazU0NGdYTEFt?=
 =?utf-8?B?OTJRL0JvVnBuUzRMTDBJamZoY1UraFVaVVpzMUlkYkpTaXpJNDJzT0FEd25u?=
 =?utf-8?B?dEd4ZngzcGEyaEIyMFZmOC9pVHlYMWNCM1c4WUI0QzhRVTZYU3JNNE0zb3I0?=
 =?utf-8?B?MWNvVFNadHhyN2twSDhqdm1SaFFkQXFSVngrbU1SeXRjMlAraTlTZDJzWUpi?=
 =?utf-8?B?NWhhdG1jc0RuSXFCQU40YVM0LzJOSnZhWmRyWXROc045ZlpMUXZZSVUxa3l1?=
 =?utf-8?B?eVFzclRyc2I3dUcvY2J3bzlObDA3WG1YNmd6U1pMUFRCVVNDU21aK0ZGekNN?=
 =?utf-8?B?Ris1S0dBdklOZ2h0YjIwa1I1YytHVlRsNG9OcENWZDEyYUtJOGROemV3amxq?=
 =?utf-8?B?MWwrQUIzUW1kZ1BEbW9HTkthUnpUZzlPQjlrWHkvTUdJKy92SWhYUTViMXJT?=
 =?utf-8?B?RUdtR0pnSEtra0FtWjNMNVV6TXJiZVIxcnh0K2NNVUtGNXdFODFWZDN2bzlX?=
 =?utf-8?B?VWZVSWpaalI5d05LY1BwWTRpbU1paHdkTklTZzZnZzlvNDk3YzNJSzRGaWJU?=
 =?utf-8?B?UTJuMFQrcHp0TzZxazZuc1NDZ0l3Q01DSU1Vbk1BdTlTUnR4RTFIR1h5ejNJ?=
 =?utf-8?B?VGpnYW1Qd2tRcHpOOXI2a3FSUE9oa3pBeHBnRkMwbEw2ZWZEWFdCZWJPaGcy?=
 =?utf-8?B?VEZSbHBoQkdPQlpOcC9TaGRCNzJUTFU4eVU0c3Z2dldmaXZ3bkI4U3FDcU40?=
 =?utf-8?B?VUpBOTU5anIxVjdQdnJRZms3RTB3QXpwRnJyU0ZoN2VrYVA3V1pXS2VTaU5Q?=
 =?utf-8?B?ZHdBK3BwalI3cXFrRjJFakpIb25DdUZOMStYdGR5WjdmTXY4d0VJckdYUk9r?=
 =?utf-8?B?Wmh2cCtjOUVVdDNYdXZyMGtsVjJRTzk4TTU0MkwrN3EwTDU5cCs5Vk1BS1N1?=
 =?utf-8?B?bXdhS3p5UFpwZmFnWHFIWWcyMVpJV1VsTE05am5JNjlRZnFvYzY1TTVSSHpI?=
 =?utf-8?B?cWc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	GNh/g8YQJB7nOT2OftcCyvSQh3DXaiJQ25WzgAAoH0y28wzV4deWcB165DjFFt2/X4HHcaTFJv1I9cageOqPmI41TgpRFhvzD882o2GFrnWgfGdleJFM7rO5DyfTHT0aVtulbMRDPN/snj5bkj7sbPaJi20CMm9SqDJ0+8AzFktAcf5atFn1Ane90RzzkTJ2wO42BislWixQzPmgNAkpn/S9X9sryX4MxCxMMptkYeo1AQ6S4tE7X8OV0VcjRIYKvQNnFRcaxrmiMWpp3B2YbdtyEEgZLc7kKlvb7BavInlC+NLmk1xOkTwOK9yS2YXpqwmHvFcqpxKfgSOOkMR9NeujwySNyQqwBp2/XijlhyWbVoM3KpDsoGvGEQY9Qia0IcRkWLxfVp1xxQ6OkoLRcKFva+SWkgt6IRlPDDS0KozpUpsN2/tuosz8RJ4NjzhcCGxudVgImkAEsa+vBno9rwjytpKMfLaCU/FuT2INfkY0/UQvhsUhcHAIs3PMBjD3xP1cppfckPD0ZMZ24cXovLtkgL5GTi5Q59LgyhLNr4LP7X8F5/EfKYjpn+a32ToOh9/lQgByZ3RNLZBW1cL96wHiQNF2zGFXIZFddjzqUuE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b610952-dc7e-45bd-3a1c-08dc893a362f
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2024 10:43:49.1048
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CXxmyMusOFmeEokIHE45N7ovW18ONgdBhNCnglkf2IcPzjKkYRS6inpgSeSt3HQNI6rnXbyVkS33Q2IWJp12LA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5613
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-10_02,2024-06-10_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 adultscore=0
 mlxscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2406100081
X-Proofpoint-GUID: HAGR-xYpV1LLUq9784itxfs-bHaYAIh3
X-Proofpoint-ORIG-GUID: HAGR-xYpV1LLUq9784itxfs-bHaYAIh3

This series introduces a proposal to implementing atomic writes in the
kernel for torn-write protection.

This series takes the approach of adding a new "atomic" flag to each of
pwritev2() and iocb->ki_flags - RWF_ATOMIC and IOCB_ATOMIC, respectively.
When set, these indicate that we want the write issued "atomically".

Only direct IO is supported and for block devices here. For this, atomic
write HW is required, like SCSI ATOMIC WRITE (16).

XFS FS support has previously been posted at:
https://lore.kernel.org/linux-xfs/20240607143919.2622319-1-john.g.garry@oracle.com/T/#t

Updated man pages have been posted at:
https://lore.kernel.org/lkml/20240124112731.28579-1-john.g.garry@oracle.com/T/#m520dca97a9748de352b5a723d3155a4bb1e46456

The goal here is to provide an interface that allows applications use
application-specific block sizes larger than logical block size
reported by the storage device or larger than filesystem block size as
reported by stat().

With this new interface, application blocks will never be torn or
fractured when written. For a power fail, for each individual application
block, all or none of the data to be written. A racing atomic write and
read will mean that the read sees all the old data or all the new data,
but never a mix of old and new.

Three new fields are added to struct statx - atomic_write_unit_min,
atomic_write_unit_max, and atomic_write_segments_max. For each atomic
individual write, the total length of a write must be a between
atomic_write_unit_min and atomic_write_unit_max, inclusive, and a
power-of-2. The write must also be at a natural offset in the file
wrt the write length. For pwritev2, iovcnt is limited by
atomic_write_segments_max.

There has been some discussion on untorn buffered writes support at:
https://lore.kernel.org/linux-fsdevel/20240601093325.GC247052@mit.edu/T/#t

That conversation continues.

SCSI sd.c and scsi_debug and NVMe kernel support is added.

This series is based on Jens' block-6.10 + [0]
[0] https://lore.kernel.org/linux-scsi/20240531122356.GA24343@lst.de/T/#m34e797fa96df5ad7d1781fca38e14b6132d0aabe

Patches can be found at:
https://github.com/johnpgarry/linux/commits/atomic-writes-v6.10-v8

Changes since v7:
- Generalize block chunk_sectors support (Hannes)
- Relocate and reorder args for generic_atomic_write_valid (Christoph)
- Drop rq_straddles_atomic_write_boundary()

Changes since v6:
- Rebase
- Fix bdev_can_atomic_write() sector calculation
- Update block sysfs comment on atomic write boundary (Randy)
- Add Luis' RB tag for patch #1 (thanks)

Alan Adamson (1):
  nvme: Atomic write support

John Garry (6):
  block: Pass blk_queue_get_max_sectors() a request pointer
  block: Generalize chunk_sectors support as boundary support
  block: Add core atomic write support
  block: Add fops atomic write support
  scsi: sd: Atomic write support
  scsi: scsi_debug: Atomic write support

Prasad Singamsetty (3):
  fs: Initial atomic write support
  fs: Add initial atomic write support info to statx
  block: Add atomic write support for statx

 Documentation/ABI/stable/sysfs-block |  53 +++
 block/bdev.c                         |  36 +-
 block/blk-core.c                     |  19 +
 block/blk-merge.c                    |  67 ++-
 block/blk-mq.c                       |   2 +-
 block/blk-settings.c                 |  75 ++++
 block/blk-sysfs.c                    |  33 ++
 block/blk.h                          |   9 +-
 block/fops.c                         |  20 +-
 drivers/md/dm.c                      |   2 +-
 drivers/nvme/host/core.c             |  49 +++
 drivers/scsi/scsi_debug.c            | 588 +++++++++++++++++++++------
 drivers/scsi/scsi_trace.c            |  22 +
 drivers/scsi/sd.c                    |  93 ++++-
 drivers/scsi/sd.h                    |   8 +
 fs/aio.c                             |   8 +-
 fs/btrfs/ioctl.c                     |   2 +-
 fs/read_write.c                      |  18 +-
 fs/stat.c                            |  50 ++-
 include/linux/blk_types.h            |   8 +-
 include/linux/blkdev.h               |  74 +++-
 include/linux/fs.h                   |  20 +-
 include/linux/stat.h                 |   3 +
 include/scsi/scsi_proto.h            |   1 +
 include/trace/events/scsi.h          |   1 +
 include/uapi/linux/fs.h              |   5 +-
 include/uapi/linux/stat.h            |  12 +-
 io_uring/rw.c                        |   9 +-
 28 files changed, 1095 insertions(+), 192 deletions(-)

-- 
2.31.1


