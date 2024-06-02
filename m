Return-Path: <io-uring+bounces-2066-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 14ECB8D75F9
	for <lists+io-uring@lfdr.de>; Sun,  2 Jun 2024 16:12:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BEBE3281C67
	for <lists+io-uring@lfdr.de>; Sun,  2 Jun 2024 14:12:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04C0343AAE;
	Sun,  2 Jun 2024 14:10:51 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5615443AA2;
	Sun,  2 Jun 2024 14:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717337450; cv=fail; b=PLEbzwS+Q1v/DCLQlyDaOQV6R+av6Mfsa1YoLYY5VLo4LagvU0WQv1I0DaiOeoYJD9+wbasY1m88o31Jr/FB/OaQ0gkOmI0SCMzok8RIr8Q22W+9GwIvmAvebbMDzfjnwRny75rjWk95EG3cMyiMFYSGG3NCZbY/LEseDLw6uO4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717337450; c=relaxed/simple;
	bh=sYzv2/7CLjhTxrPCvjggytRPAhhChubeQp/fn06W5vk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=HxHIjH9WuJoVCt1rO1n9uqEiardsxpBsaayOVr2RwG77rvTaDVC81GzUwGUdBmsXH+h/yUhIJWjYWi67cCodCccT6gFSGA3I1euHrVX+b39KUC/HzHL91i+b37R58jgG1Xfu0bb4b6/xijJTiNNYtHfeRFVhscmo8gAEru3eMCc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 4526dJic025050;
	Sun, 2 Jun 2024 14:09:44 GMT
DKIM-Signature: =?UTF-8?Q?v=3D1;_a=3Drsa-sha256;_c=3Drelaxed/relaxed;_d=3Doracle.com;_h?=
 =?UTF-8?Q?=3Dcc:content-transfer-encoding:content-type:date:from:in-reply?=
 =?UTF-8?Q?-to:message-id:mime-version:references:subject:to;_s=3Dcorp-202?=
 =?UTF-8?Q?3-11-20;_bh=3Dshf0PkL9/9+tX8AihW0X6p7w8J03sVGQV65DSX6gEZI=3D;_b?=
 =?UTF-8?Q?=3DJ552+MdzbCZUZK8+GmBobDlqajZJMkq8wz7Zw7i1HZfbDR448iLB6qXsaqpb?=
 =?UTF-8?Q?8sCIRHH9_zJeOKcJedjGZqG7uFGk0U2dYv91rgEsHk8pSYsAw6ng/y2BNjGQULk?=
 =?UTF-8?Q?jz7nZL4an6QP2P_E11v7H0OuzUa9wwx+zPMOETo+T14HGoyaki/bbD7nnidYxEx?=
 =?UTF-8?Q?25fWkPLZXlfn3YXByW1P_Jz/edJPEtjqk32qXVx8y34IKIHwYRfiT6NHCN3TJl0?=
 =?UTF-8?Q?rSqI+xEvBDOLGcZV1mmfVxf1FH_irzjPpfuuNvG8FKi9eKfs6NctVCr/gAnlBaJ?=
 =?UTF-8?Q?aaodr7nU2A2Y+hfOtAqq3JG2nrrkLqhB_zQ=3D=3D_?=
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3yfv059d9k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 02 Jun 2024 14:09:44 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 452CUmeN021076;
	Sun, 2 Jun 2024 14:09:44 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ygrt699g4-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 02 Jun 2024 14:09:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gsNL3p/qjJ/ZY8kxCXC26DmzxQ+x6sBwxZeda+wMTkGW4oAK654sij8TwCucIo7GfHyOoc8ctlL0lV+KMWeTvjMu1YpIqWadBnzUtICobEtXTIvRRQscEms1x8aHBML43Lo2tt+aIjckr/zjHfUg/JF/lG0Ty1xNvPXNyAHLJjkK4CHtntoYA4KtOkEE9XiAE36iqs2WyivFuChNAaY2KtTa69ITNtUgzGM7T7LWgqmXp2r98Vzzlikmu0n2IC5wD9TSlDK3v9cF91UvAqafpa61KXaMLMCy1jBb5xc/xwuBZCobGC25kMfAL2fLgpra6Lpkmk5ppE2TJcOP/zvvvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=shf0PkL9/9+tX8AihW0X6p7w8J03sVGQV65DSX6gEZI=;
 b=mrIPK4XaCHroaonE3pddl3DEQUj/OOk7sKkIof23QSSt3in3qiyJFYvmr/0hTaVFHLEsAKUMB4FJFS3olNUcTOW3ZasGquu0sN5maAes2CPZbmB4XwzurLu5ywaw573zbZzpnDCdZi+uatazS8kWxVYfmx0I3JKb2PT/ra070GgjZPmjuruTZtJcCHNseo9IpfnTeF4TRh7W6XGOZ6bJ92sNO0huLueGM68fobTpAWBv6t5SvsrH58Ti1oGY8Wx8g/QcgVigwAViv5vLWX/dq7N/VyegnYybjM1Ub+MNgpA3RiwKohMHSNNhKsdkI2hUYurtyYXcvDJIF+8CThqScw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=shf0PkL9/9+tX8AihW0X6p7w8J03sVGQV65DSX6gEZI=;
 b=CN/EiB1jnvUrDJkE3oLLLpibELLdtbaXcl4YhUwcbQy4ijFyQzgdn/90UuFbXjGLCMvAb0mUnqiaVMgxO+J6xQq3DHv1ncrYR83VYaBqUGxR+88J2+WqqldTQa+vCqHHOT20eSxU39dPDa47oKC6YybBVOYcn1VRi7z0YlFEcZI=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DS0PR10MB8078.namprd10.prod.outlook.com (2603:10b6:8:1fd::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.25; Sun, 2 Jun
 2024 14:09:41 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%5]) with mapi id 15.20.7633.018; Sun, 2 Jun 2024
 14:09:41 +0000
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
        nilay@linux.ibm.com, ritesh.list@gmail.com, willy@infradead.org,
        John Garry <john.g.garry@oracle.com>,
        Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH v7 1/9] block: Pass blk_queue_get_max_sectors() a request pointer
Date: Sun,  2 Jun 2024 14:09:04 +0000
Message-Id: <20240602140912.970947-2-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240602140912.970947-1-john.g.garry@oracle.com>
References: <20240602140912.970947-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR03CA0011.namprd03.prod.outlook.com
 (2603:10b6:208:23a::16) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DS0PR10MB8078:EE_
X-MS-Office365-Filtering-Correlation-Id: 12608b5c-3d3f-469b-1c62-08dc830da59c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: 
	BCL:0;ARA:13230031|366007|7416005|1800799015|376005|921011;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?/YLMP6mVh2qbm3Af/mGaVRlZjTCfi8bTr9oeuZ+EHIHCLtq0ICqAyow66yHb?=
 =?us-ascii?Q?UVjVsS9aTuYfsvQ+V7yWPSqndhIa2XcH1thfU5VTr07HG2MGpfJ80BoBar4H?=
 =?us-ascii?Q?YZkEqtU0aacdVQtMHHmJyjpQBvsalFf92FH2+Sl/Yi/G/kYxLd5v9EqupwdI?=
 =?us-ascii?Q?rnJeX4rIx4p7d5BcYtlz918edKPNXH0EF1HzTh1lbEK7G+1MFAez06V4PRbh?=
 =?us-ascii?Q?qM9s5Z9WZkwYxeqzOD91uub4KPCBuuAl0IQMyzdckT9O+cJbC5hQp0tDGMoE?=
 =?us-ascii?Q?MIWjAcsLC0V3KFNdosCl6rfF15ujUd290phIMNpVikqwrP8WOxCwPZ+TtYe5?=
 =?us-ascii?Q?9TIGU4/vEQOdvttH0AY09XJj7hnZSfI6BYyihh7Wn8qO2t5Ot8WAFStnCsuV?=
 =?us-ascii?Q?9+os90FQK26FgWWlqvlumDdo1yGZWOpYBZCKf+dGpBCUSiM9gB3dDFhHiukK?=
 =?us-ascii?Q?MWU6SkZ1MKM1Mqsdptj5ec6sCIuM8x3gWOfs+d7aYyWnB7ax//jPIEGRPvv0?=
 =?us-ascii?Q?uGmnarO7yv/fuIwsa9AyugS+PRJUCpXiBK2o+d++isi/1yqQQIvyyspnLZvK?=
 =?us-ascii?Q?Bhnwi+ZJbjS/xBwGSEvS8Y50nleIuH0RKMAYZYpNFjueZ5Vz2wYpKm77Lilw?=
 =?us-ascii?Q?JBNXcCk0SNk8KPBcrszIEtk+GJfNrQyMj42Vre6DN5FO8s6Wqpyywufbtsc0?=
 =?us-ascii?Q?ntYkJWXlqeDYjXKODyzHG7ZtME4kXMcMRMQneUPFN700bLm6AgPbV07UMI2V?=
 =?us-ascii?Q?tVIQghPOXRdSfey4n75eN7fNhxe0ZO6FXgicc4n7T1T3cZiw5iGn/Y/4DA2p?=
 =?us-ascii?Q?FV75wiFXdwGFdrJlAqIAG1ubGma8fXgIB8nUl8mpTF9G3mQ3jNfhgypuS4tp?=
 =?us-ascii?Q?efn1zM6jAnueRZs2ei0jVv0dn9rPYCjoLVqEvEIhwbvGSb0+/uYqgNFfGjJv?=
 =?us-ascii?Q?Bh+GvhZiNnmAeb2NvBwzvBKWJ7vA3JjRpiCdIjG388rRPID/b2rW3T5lA6Ui?=
 =?us-ascii?Q?+xsuANitYR1Kvj2DYGDoB4uC4FOlOCK3rHbFlkAQCTPiNpe53Fw1siduYXFZ?=
 =?us-ascii?Q?evU8qdB872cWmfdCLctJYaO73CyBT0jBcVXrU+CpPPrAZ8ZViI+YpgNolEuH?=
 =?us-ascii?Q?LUohtv/ial6hdU5BM/q+yN5eeBLMd6KyYveUtCVC1YMHAce6hlkUa/QITS/2?=
 =?us-ascii?Q?OVIfh63qyAC8VG+0vLOsbV4j8YPFNEdRDvrcFbonRj6+R/CSR04zzRSKNBbs?=
 =?us-ascii?Q?tum6D4edI0COwXQCWRzzvOU0vmr613OYcxOs4y1U30xi2nc9+1DJti9Ug0Wj?=
 =?us-ascii?Q?KScemLnWlhZG67/bp9ZRhBxR?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(7416005)(1800799015)(376005)(921011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?6s+t24iazTHLWrhWusf4VTKG2TIXrgyYBuULTKnlSTBgKn1PxUjsGFa74J+/?=
 =?us-ascii?Q?PihjxxAICotsyl7E8IqCYcNW2rjdtHI511ksSTcnk6YJcDmO6a84cW5jOlMP?=
 =?us-ascii?Q?eaWbPR4PTeQoNJEeviuKeRLY8tbEKrFyzNNr0s856qlnRwocaTe6LD9tB4Rx?=
 =?us-ascii?Q?C8XjdqT+Ji0ZBw0dmRRixGgSw9POHZTgUMyVZBSo+9lZB1SSCGPKqUyqKuaV?=
 =?us-ascii?Q?HFK9GF2G1xxlFiT2DhCOx1KFWmxbDxzSCPPyCsPkQbGWcXronoVj7Fqg0Bg1?=
 =?us-ascii?Q?ek78+xgIKPQQbkA02Srn5r3bUN2MZ84f22+GfJa/xcxrKUaAZ8dFJYLmpq4v?=
 =?us-ascii?Q?gulV8WX6iNwXMsTJe+0iJNSfjRlGyRPgRn+K5wHMagPJK5KwLgkv3oicTBQv?=
 =?us-ascii?Q?rDVolvFS+4KGKsSIyiywQxT24CxHdz+fNd8WbmQKIPeBt36dhZ4T8xHgSSFg?=
 =?us-ascii?Q?QYpIRL8uv2ksH8HYpXjAvZnG5G0ESJk5TjXjf9AZMGkgnykXv7bMNt4ju5O0?=
 =?us-ascii?Q?89DMi9NTrg3mFxMjEkrI77/cEQO7JJRAzKkpfSLDm0aCrhmSYLBt8UODP+Th?=
 =?us-ascii?Q?CkZMFa00Fye1KUfzthgXSdCi78uSnvpgCTy54jEkZHV+j/iXumLtX6Uriu6W?=
 =?us-ascii?Q?RLXcKKz3GaNAVkArWDx934vqurfShWFGAqVVlvh5wZTySkY7If4u0PihnVBv?=
 =?us-ascii?Q?cIHpq6qOxxWDZXkc1dqXgjfJjpD8ch6D1ztSfKeUBQUQxVB8GJzu5iQcNsPk?=
 =?us-ascii?Q?ugqq2N/HfoYCMJZjEWp6lKdnGUHhCe0A0/KfMD/Y+/CZ103vQRjOpX6ZyL5e?=
 =?us-ascii?Q?1PEXOACBYpOyA510dBBl4jZnd2NL63/YxeY8UlAb2Ht8jg/jXo1GpSWYRilK?=
 =?us-ascii?Q?hRWcmQHkybRzPTv0Gk7qHfHXVrTQeRkCEXHI/bs4qTdPStj5kjLGlYSPKJfq?=
 =?us-ascii?Q?hxaLPT+LdYDpdi+RbsnGIb4n5x0dB4+oE7l6REoBnJrEZ0uNQIuYX+32c6J0?=
 =?us-ascii?Q?bkWe3NkY9R3SJLz7OY8zNszdUKUfzVqo0taBNYLs7WyfcSiTFq/EFM+U0LiB?=
 =?us-ascii?Q?053SAvTozMFx3bL7dg08TBVD8u8LFtcTZ9kddUp8OFrHJ0Kjc6+MC9j9HNiq?=
 =?us-ascii?Q?CVyuiGpCWGRDcGhgLcbJqqKgCUKE/m9UYn15CTAUIvRGKAGc4qNcO9Re0Ju2?=
 =?us-ascii?Q?D27oFAba+zZTrLSf6jqTk2aL9WgP0B4+pVxGn8bqnqCoytmQNWpw7UGckFmg?=
 =?us-ascii?Q?4/OW+ZZcBP0+MRyqZytdcjC+nfeS/6c+reTFQBCHaTPY1l4pX3sMetH9UuSo?=
 =?us-ascii?Q?5di/aH8Kkkp7NSDs9w6F1q+OeWijr+euMfBrifJKPEKwULzTzxvi0n9aPxXn?=
 =?us-ascii?Q?xAF3uKlJZmPS0tB4Yw7dlUPgE27/QZItOa2scHY4ynpnCCTFGxj9Lg/RqZJv?=
 =?us-ascii?Q?9Re8nOdTMMERACBOkXSnKxqeuD979Xbg71lQ48rqC4FlxltLuqkqrNlfrdjQ?=
 =?us-ascii?Q?oRxxTzF/XyxTIHjHo6iZhsDYDdja0niTdEdYGG3SjKoydp3cEBJCaWqPM+22?=
 =?us-ascii?Q?Eq28RIOY6zkNRXvkVoUne6CnbIb1sausWFtSBSkC+wKD/NkgZFDMY98RbTld?=
 =?us-ascii?Q?Nw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	OtQzp90l6P/Xx8C28Dj86FtQQ1qrbWh+kOvXQwixkOzSnEvQnTUGkJGxy4x3tS5axMIPIaex8rgRRiWMw/nT8j+AlrzhH2WXHX5Zx4NyFS9Y9Ki99TaSAzlMQ3ceMd5mf1Rs+In05sHFNIzuD1ITRODx6awpgjs7q4sEnN/s7cK3hygdlhcKk/5Ra0pGhxZV/VIkkHP/AfDtqU2XJEmQ4+dNplxHr8zTwLMKO5BRo5Gc/W77z/t7577JoBncrl5Xz9vJ0Yw4L8JUKtmkoyNWIiBmt8edVDBg1yVg3GnIlasop8AGDyg/6Dc/SZcnHMUyoP+U95j3SUfDAKz11suyUJB3+cptR/kc04pfQ+gk33W6TsKHFoa8q7yzhvFWil/px+jfTIAEQscexBWW6134KZ8jqnFcEe3AQnKmNy2GnmPFK4ywBMJw8++sYbv0oUgK0bYLKH5+2UQIZ9TmQ2SW6tlx0sAGZEr0jJ5gLstG61aNolU1Mv/xd5wIcaePH594OW+UJWrvhlf8jKP1uwI1olZ/Hb2rOXUbKBEyCCrrfdiAZ5VJ8orQZAv19zOtJlpdp4IdiQ0kSVTnqG8RI8rTAsMMhPFoOEzeBPRjgcL69TM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12608b5c-3d3f-469b-1c62-08dc830da59c
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2024 14:09:41.6924
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jy9M7cz//TSrE0/gVpvYDaDk7rW4ofu6RYB/kw7jO9lu13TQKIjXycbqWCrElk4+yXwQ+BsQCP3Rx+RSeTgZ7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB8078
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-06-02_08,2024-05-30_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 spamscore=0
 adultscore=0 suspectscore=0 malwarescore=0 mlxscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2406020122
X-Proofpoint-GUID: tNLQpRcavaH4ke_hQFDmm3k50oEcTbBV
X-Proofpoint-ORIG-GUID: tNLQpRcavaH4ke_hQFDmm3k50oEcTbBV

Currently blk_queue_get_max_sectors() is passed a enum req_op. In future
the value returned from blk_queue_get_max_sectors() may depend on certain
request flags, so pass a request pointer.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 block/blk-merge.c | 3 ++-
 block/blk-mq.c    | 2 +-
 block/blk.h       | 6 ++++--
 3 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index 8534c35e0497..8957e08e020c 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -593,7 +593,8 @@ static inline unsigned int blk_rq_get_max_sectors(struct request *rq,
 	if (blk_rq_is_passthrough(rq))
 		return q->limits.max_hw_sectors;
 
-	max_sectors = blk_queue_get_max_sectors(q, req_op(rq));
+	max_sectors = blk_queue_get_max_sectors(rq);
+
 	if (!q->limits.chunk_sectors ||
 	    req_op(rq) == REQ_OP_DISCARD ||
 	    req_op(rq) == REQ_OP_SECURE_ERASE)
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 3b4df8e5ac9e..e690b9c6afb7 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3041,7 +3041,7 @@ void blk_mq_submit_bio(struct bio *bio)
 blk_status_t blk_insert_cloned_request(struct request *rq)
 {
 	struct request_queue *q = rq->q;
-	unsigned int max_sectors = blk_queue_get_max_sectors(q, req_op(rq));
+	unsigned int max_sectors = blk_queue_get_max_sectors(rq);
 	unsigned int max_segments = blk_rq_get_max_segments(rq);
 	blk_status_t ret;
 
diff --git a/block/blk.h b/block/blk.h
index 189bc25beb50..75c1683fc320 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -181,9 +181,11 @@ static inline unsigned int blk_rq_get_max_segments(struct request *rq)
 	return queue_max_segments(rq->q);
 }
 
-static inline unsigned int blk_queue_get_max_sectors(struct request_queue *q,
-						     enum req_op op)
+static inline unsigned int blk_queue_get_max_sectors(struct request *rq)
 {
+	struct request_queue *q = rq->q;
+	enum req_op op = req_op(rq);
+
 	if (unlikely(op == REQ_OP_DISCARD || op == REQ_OP_SECURE_ERASE))
 		return min(q->limits.max_discard_sectors,
 			   UINT_MAX >> SECTOR_SHIFT);
-- 
2.31.1


