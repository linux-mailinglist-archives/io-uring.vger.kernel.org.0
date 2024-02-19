Return-Path: <io-uring+bounces-636-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FDC385A45C
	for <lists+io-uring@lfdr.de>; Mon, 19 Feb 2024 14:09:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CFB4C28107D
	for <lists+io-uring@lfdr.de>; Mon, 19 Feb 2024 13:08:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 916C836103;
	Mon, 19 Feb 2024 13:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fx7848Vw";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="C8x9j6MX"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B4FE31A94;
	Mon, 19 Feb 2024 13:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708348123; cv=fail; b=r9cl1iQTkhILKkevjwyehF+U9SKieV5aN6VMMHLvqDSx62okypqabfNu+sxhG80RT+TVRJ9oGCSe6MgpIO5qnWMoFoGRjznM9dksPRUvVnQEjuzTw+XiZi03Vax+P61v3GVKFV4ipfou8s8kXkBBlR9JzmHwwtV8ExPHtXZ7D/E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708348123; c=relaxed/simple;
	bh=TWj/AIbv8VeEVWyLtH2EDO6eNgQJZgqKsRh8MiswlKU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ePo/Cn7xGiyA0tCQauF7ero2otkVEPtLC98UBrcTpypGa8Xd7bKNmkG7vN/6+ADRLRH3hfz3YLWPB3C3NBnj482lkdIvojMFQxtgbA5IDBiQeFqG+Qc3sfUanfaCESvcQpe8VwDBLbiQf9Q+E8AH8WePqlqkGHEqR9nOCldYnJ4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=fx7848Vw; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=C8x9j6MX; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41J8OETY003549;
	Mon, 19 Feb 2024 13:01:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=XaWjXB/Q6lWPj1ZH5kRfXhvTWCk+LHaZjQ4ijbv1mtA=;
 b=fx7848Vw5vWl8As/lrrQPd6w2tN7JXuzRlIrsFBZ4nZGzr0FhlVhBpxKhIFjhO50sqi+
 AjGqKSaNVWO6xLnN+H0m27+U5BrCgWCTDitc7yEmPR4SQ8fNCFDvV5tjjs9e1ftNwAhZ
 fPv9MIq4yZiEQ3wsSgdxeXbALfNOzLBTMWyvn0TBGKxov5K6GCJby6oxnqOvFCYejbfK
 YnPYWtgtVTGIgZyHq1wSx4183fuZKW3ip1mmITlpo1SR6+9um/TBWysDhN9v3JvDoCA/
 7krtc0QE14b3EMKcn+48WIZHE3K/KO+bhxGQ72EDJ+TsTw5CwC6fjT+sYpE7+lSP1faS DA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3wamucv417-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 19 Feb 2024 13:01:57 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 41JCPCaw021143;
	Mon, 19 Feb 2024 13:01:56 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3wak860wh1-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 19 Feb 2024 13:01:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HZ0uQn7YJ/VmNg98cCOhCsMo2uI2fLqDwLAdemRgHj2xGbg5GPUCWqR3tW/bybB736e1+RPWLV4AOSbYrc6BPfuG3ZPlnzlAVuPpRwRBSIzfwXRhXISe8HsVXnsyL++Uii6krkw7HID5Rc0LeJTu0TVvAO/WRAhEJvvuhQ8/12im4AkHBR0MiQYyebgwJ0pD9b5/Iuk2U6TkJfw2C4RQBkKnPX1E6OJp4WrUJJdukEvqW7DA2H5uYKwFyjXshTQDs2PPZydFzSPiFU4BG4gik2cgzw4CsA+rvotv26UbNrXQAbwe4nRXzh9CsfmiNFbZdIDbc7UrenhURMCUwiSYfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XaWjXB/Q6lWPj1ZH5kRfXhvTWCk+LHaZjQ4ijbv1mtA=;
 b=SKdLQ4VeDU3riH9hjhhZ1sIcTpWGIpTNutjUGAxTrsMJAOK3RjWhkYw2VVv43mALy4wazQ3X+ALkV8oywUo9C4OP4MDfigJdyfMGxtqw5dr8WpsVUCM/wP61PuopnpG1syjbIjQQ3y1bmfwfOVLyxJ1S42tb7TMUvotTt2xzQo60dyQIaeWau3IWZXD1o0hJc7qAbl6cyzSrlAyjyGVnISvbnYdbnPntkmjLiEYlXDP7ln8GKDBl4FedEZrTU1xHHjX3DWT9Zxvi4mFEDVThs3p/urNQRq1IpKhVaLk1C8+V0D0PwitW6CYB9wIL90H2/oH9dSScyC9+8MaWzCN8kQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XaWjXB/Q6lWPj1ZH5kRfXhvTWCk+LHaZjQ4ijbv1mtA=;
 b=C8x9j6MXKLSdArCdBQxgj16AHoz99inw/48DDgfM6nLJ4mKgeA//7g5FFx3vu6MOxscseb6TUX1l6E2XEcZojR8A/pW9JNH3TpWsWwYz/m0TbQQGdHzrxTi46J5Sg9p0NbiiM2HfO6WkCpB6XcL2j9kfuhzKK7E5SlzWTYBUC9w=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DS0PR10MB6894.namprd10.prod.outlook.com (2603:10b6:8:134::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.38; Mon, 19 Feb
 2024 13:01:53 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::56f9:2210:db18:61c4]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::56f9:2210:db18:61c4%4]) with mapi id 15.20.7292.036; Mon, 19 Feb 2024
 13:01:53 +0000
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
        Alan Adamson <alan.adamson@oracle.com>,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v4 10/11] nvme: Atomic write support
Date: Mon, 19 Feb 2024 13:01:08 +0000
Message-Id: <20240219130109.341523-11-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240219130109.341523-1-john.g.garry@oracle.com>
References: <20240219130109.341523-1-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR03CA0214.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::9) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DS0PR10MB6894:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c194827-0caf-4d03-c894-08dc314af18a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	p38mDDE8Nzwen9eUKqJV5rlZw6bGf9GMa8fVJZlvjhVR6MnJpfktKklgKXJ2OfaglGoo2iVFDaSfyy8y7LvvyBGB6xSNdWRKGkeULuLTrVprJLtiw++q/+fcnWcIPtgjbod/qlNKMRJs2DPA6JYUl73SI8rvaqnp5z2glJRvDvJztTGMi2WBKM86nq6WbbpAjI0BkdXTfTERN8saKcSlnb1IPsX1Xr6me0r3KtokTAxgNkqIx6UgTtUiji+Vgjc2vPx+Ro4/64OX05FmRbhFDhvYM7/sHSwmmC67x2QQBDu8Ginl7wmrvaxTfiqJaODOecjm9fBmH3CNxPqqCadBgJGU7iY1rO+XESfT0d+H57y8CK/vd/rnsrACoudsdfSfsORaqqe4GL7bSo37+NCwkZXwktH2pEUSvSq/it8WCNhkftCA5k078zZdo+zzFUxsD6cj9sbVNbcdP7e0e3C5AK85Nt4Y0T2oCR/yF//pYLlh8xcwa9PcZNU6w/1liOpE6XSIDPZBkhG2vA+HU8aykyiloeQ98WQIQ4plQpnWBrYLpGoah4Ae17lRwXqwbAvnVYrE+q0IYRgDo3o9quXBbOtAS9SAYtr/62pm7plj+04=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(921011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?OEdUUFcySW11UE5QYzVEenNoWHVrTVdsS3ZjWUtpMlNTNVY2TkZEUGxOK3FD?=
 =?utf-8?B?TjQ5UHdXcEQ1VmNUbnV6VFg1VVJONkE3dk95RnhPSldzTzcvbS9FS2FnNnI2?=
 =?utf-8?B?UUJjNytDSUg4Mlk5Slhkeks4TmtRenRiYjJ4ZDg0c2xYbXRDUkJhRk94TUdV?=
 =?utf-8?B?a2VYYXVRWmtIN1p0TW5nQXZGMGJScTZYZjMxSmdYTUFrRzRpSG81OVBFSzF2?=
 =?utf-8?B?WWJyTVAxYWpYSGdtTVRWc2hlOVg0TXA4azlDc2RadXhqWVFJY0tIdW4yOXZn?=
 =?utf-8?B?SnJDYmcwT1pZaUJZTXdjeTh3dGltWTRnMEoyRjBIT3kvU0pQMGs4cUdWSFFT?=
 =?utf-8?B?WU5IQXk0NzhUTkR3WHpST1AyWlB5MDREMHhiUFphMGZicEtFaWZSUFlGUHJu?=
 =?utf-8?B?WSthbVdONFF0ZnoxRW1IREQwMDVYdlVIa05oT0tTNW1lak12V3ZDdy9HWmVu?=
 =?utf-8?B?azhIeDNBNmZSQSszT1E0QXVUY3BnV0lYb2tJclBqd1N0TUsvT2t2SXBhV2ky?=
 =?utf-8?B?Y0lJZWJLT0pBVENsS0lDeTQyRFFxbVZkalR6bVo5cmMvS2ZLZmdZMDUreWxt?=
 =?utf-8?B?eW16aEp4S21id29UbEYrNE5ReFE4QlBQcGVRK0RMVDFqTXVjTC9rcVRzYXFD?=
 =?utf-8?B?NVJaVVAxNXhSTkpzc3d5ZC9nRG0rMmhsWXpPcXJDMWNuSmhUeDJ5aFlYa210?=
 =?utf-8?B?bmxlN3AxWktmRU9tNHN5NllnZzJIM2pXN1RQQjZPNWJoUlBFSVlzTEdvVmtW?=
 =?utf-8?B?MHpHVGZSOFN5enRleGhad0pQTEZCRmhzNk8xWndobnFZMUdlYW9iZ05UK2dE?=
 =?utf-8?B?ZEJNVVZDMFJ1bTlERHBic2E3czhrRWg2UnNjWERGNFp2Wnl6OWhuS1REM280?=
 =?utf-8?B?MnRaNnBFc3BQRDFkZ1U0TUdlUXFHSVIyR01tdmRUM0s0OGJqS05DS21RZW9B?=
 =?utf-8?B?UVJBU3dKNVhPOUNmWUliRmZBa2FsY1pxclE4SzhzVHMwbU8wcnpJa3k0Tm5j?=
 =?utf-8?B?NXhyOGszU1YraEJjRUpXY3VCbzNrOG9tY0puMkRUZmVRNDBsYXBiZFZqRGli?=
 =?utf-8?B?UmJYLzVsTlJjbzJma29nTmxVRGhSZTJUK2pTTFJxMHdlajVsZi9nSENjdmoy?=
 =?utf-8?B?endVZGo4Ly9qYllveDVXM05Bd29DTW9UTnBONDhsMTdmcFR5T05VK3N3a2VQ?=
 =?utf-8?B?TTN3V2puaTJySEZvNG13cVo0SkRQYWcvUVFIRzVPeXN0TFhYajhJdW1DZWdH?=
 =?utf-8?B?MW9nNk5OSGc3aTFhSUVhdTI1c0gzMFhhNkVvV2R4Y0ZJY2Y5UkR3YkloVUhR?=
 =?utf-8?B?dkswbWtaMFdDUjVFVDJQeFRPQmRTRzFlNWJ5dHRIS04zYktpbDExN0prT2Z3?=
 =?utf-8?B?TzArQzFEc2RIa0JKU0VHekVyMkRvcTRobkUxeVc3ZXV3Y2ZvZWJaL1cwaVdj?=
 =?utf-8?B?clB2SVVSUnFJVWpBNGVCT09ZcVVZQ1dvMDBuTVFJSGVMb3FYejdaaVlFc3l4?=
 =?utf-8?B?Ui9LTmoyK05CRFZ5a2dkbncrZ2hzelpiNjk5VGEvbVR0MmdDRytLSkJXNWli?=
 =?utf-8?B?Si9WSGZxL3VrbFRVVG9tSjFMeFhybHhFYlJQem5aNFJzalo1R2VOMGFhSE5o?=
 =?utf-8?B?TzBYV1dTeXJlMTAzZ3luWS9QVnk3OHl6Uk11dHlGSTBiM1NWM0JVYVVRaHNa?=
 =?utf-8?B?bmhWY0pBZ3hRMy93OFROaDNGTnhaUHU3VzFzdGZXRUUrRjlZQWpKWmtVZ0x5?=
 =?utf-8?B?WWtjbE1WcmxjWTZ3WGYvNkhrY0xSVWVjQUtqQW9qeGxCay94dzQzUStkVk5h?=
 =?utf-8?B?bHFPQ0xtWXZtV2dJUkRDSTVwUy9wM2QxVkFhdXJZc3hOZ2dOdW1kOWs5Zy9R?=
 =?utf-8?B?ZldQcTBkQUtGaTlyUHUzNFpyZi9mbzZxT01TQkxncXM4SWFZdEs5UDN3U1lz?=
 =?utf-8?B?WkRPdTNlUGNuYkwrZlh3eXlVOUlrWEw0Q0Y2bmxaNm8zWTIwTHFqV3Rrcjds?=
 =?utf-8?B?ZTBmWFpGTnA2VFZHZWJ4QnV1b2U3Q0plSVNoa2QvMEV5R2wwbzAycDEzMmJW?=
 =?utf-8?B?NzVZT3EvNy8zR05nTXRVdGwraGNMMXRKcEJNT1MxRDVINitXdlJmR0phdld2?=
 =?utf-8?B?cnpQS1ZZUXA3RjA5cUpUUTkvS0FIUk1HdWpDNjR1MXg1ZllucmN5bGtOeXpt?=
 =?utf-8?B?ZWc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	Gz25UDnced2NY8eVv0u8YhndeQ1PnS8FDfOQjqRTWFPFb2/Qo7ErF9u83zft1PYXsWlIiefBTHb/1oIVGEGOCzMr1IAcKxu4+0rWa4Xhrdu0NS5b7I2eE7ZgW/65aFMuBvrzMU5aTx9vx94xemLtHqAKZtmq88XyDlVp77MY3RS8hSFvRtH/JOpSDzfEiJruZYM683+hHj/NVSXEAbVIEU02g6ipi9iGAe9NjO4XAf5ST4nNlZ1CknG+KWy3TTNpXPh8p/l+c7lJE982J3wSEofH3PuaSBz9FL4RVw88x8BlIIu8i8knB0y5bLt0U0w/QVXnoWR6dIaNKCadT8Jcpc4jEdWpjHzY2uVb+C01Pf6ysPC3ZKzjAh4b+AuS42Yic+/z2UnMvfmNpAaqPTV+Rg8BZxLvcPiu2lVWnGaj46QLzhSsqQmKZEemJZjOXBWOeZpap2XNUuglpkbxc0VS+PWKbzXAGpsg8UJFVnYAMtOk7jiV2uc/oQcIZFm8bIshUAztTyRX8CA5dwcLhf+kaGgbNtNxI0iO4Zl628ubUWmpKQ+6Zccr8xhi9rB78ndX8Mc8lJuvUHO4CBvAdIveXgFbwMcD+7cj/2TwEkruURs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c194827-0caf-4d03-c894-08dc314af18a
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2024 13:01:53.1056
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ymwugMPTvjLhfE9Hb9wEH88zNtYAFTNLwHwTdzNTqDR/UCsaeb8SVgFpTe1ve9T4PDGqQpuGQ1ZMiaUhL9t5BQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6894
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-19_09,2024-02-19_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 adultscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 phishscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2402190096
X-Proofpoint-GUID: Hv0kdf_VOlarZLMdvUhkS8u50MHdhve3
X-Proofpoint-ORIG-GUID: Hv0kdf_VOlarZLMdvUhkS8u50MHdhve3

From: Alan Adamson <alan.adamson@oracle.com>

Add support to set block layer request_queue atomic write limits. The
limits will be derived from either the namespace or controller atomic
parameters.

NVMe atomic-related parameters are grouped into "normal" and "power-fail"
(or PF) class of parameter. For atomic write support, only PF parameters
are of interest. The "normal" parameters are concerned with racing reads
and writes (which also applies to PF). See NVM Command Set Specification
Revision 1.0d section 2.1.4 for reference.

Whether to use per namespace or controller atomic parameters is decided by
NSFEAT bit 1 - see Figure 97: Identify – Identify Namespace Data Structure,
#NVM Command Set.

NVMe namespaces may define an atomic boundary, whereby no atomic guarantees
are provided for a write which straddles this per-lba space boundary. The
block layer merging policy is such that no merges may occur in which the
resultant request would straddle such a boundary.

Unlike SCSI, NVMe specifies no granularity or alignment rules. In addition,
again unlike SCSI, there is no dedicated atomic write command - a write
which adheres to the atomic size limit and boundary is implicitly atomic.

If NSFEAT bit 1 is set, the following parameters are of interest:
- NAWUPF (Namespace Atomic Write Unit Power Fail)
- NABSPF (Namespace Atomic Boundary Size Power Fail)
- NABO (Namespace Atomic Boundary Offset)

and we set request_queue limits as follows:
- atomic_write_unit_max = rounddown_pow_of_two(NAWUPF)
- atomic_write_max_bytes = NAWUPF
- atomic_write_boundary = NABSPF

If in the unlikely scenario that NABO is non-zero, then atomic writes will
not be supported at all as dealing with this adds extra complexity. This
policy may change in future.

In all cases, atomic_write_unit_min is set to the logical block size.

If NSFEAT bit 1 is unset, the following parameter is of interest:
- AWUPF (Atomic Write Unit Power Fail)

and we set request_queue limits as follows:
- atomic_write_unit_max = rounddown_pow_of_two(AWUPF)
- atomic_write_max_bytes = AWUPF
- atomic_write_boundary = 0

The block layer requires that the atomic_write_boundary value is a
power-of-2. However, it is really only required that atomic_write_boundary
be a multiple of atomic_write_unit_max. As such, if NABSPF were not a
power-of-2, atomic_write_unit_max could be reduced such that it was
divisible into NABSPF. However, this complexity will not be yet supported.

A helper function, nvme_valid_atomic_write(), is also added for the
submission path to verify that a request has been submitted to the driver
will actually be executed atomically.

Note on NABSPF:
There seems to be some vagueness in the spec as to whether NABSPF applies
for NSFEAT bit 1 being unset. Figure 97 does not explicitly mention NABSPF
and how it is affected by bit 1. However Figure 4 does tell to check Figure
97 for info about per-namespace parameters, which NABSPF is, so it is
implied. However currently nvme_update_disk_info() does check namespace
parameter NABO regardless of this bit.

Signed-off-by: Alan Adamson <alan.adamson@oracle.com>
#jpg: total rewrite
Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/nvme/host/core.c | 67 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 67 insertions(+)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 0a96362912ce..c5bc663c8582 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -934,6 +934,31 @@ static inline blk_status_t nvme_setup_write_zeroes(struct nvme_ns *ns,
 	return BLK_STS_OK;
 }
 
+__maybe_unused
+static bool nvme_valid_atomic_write(struct request *req)
+{
+	struct request_queue *q = req->q;
+	u32 boundary_bytes = queue_atomic_write_boundary_bytes(q);
+
+	if (blk_rq_bytes(req) > queue_atomic_write_unit_max_bytes(q))
+		return false;
+
+	if (boundary_bytes) {
+		u64 mask = boundary_bytes - 1, imask = ~mask;
+		u64 start = blk_rq_pos(req) << SECTOR_SHIFT;
+		u64 end = start + blk_rq_bytes(req) - 1;
+
+		/* If greater then must be crossing a boundary */
+		if (blk_rq_bytes(req) > boundary_bytes)
+			return false;
+
+		if ((start & imask) != (end & imask))
+			return false;
+	}
+
+	return true;
+}
+
 static inline blk_status_t nvme_setup_rw(struct nvme_ns *ns,
 		struct request *req, struct nvme_command *cmnd,
 		enum nvme_opcode op)
@@ -1960,6 +1985,45 @@ static void nvme_set_queue_limits(struct nvme_ctrl *ctrl,
 	blk_queue_write_cache(q, vwc, vwc);
 }
 
+static void nvme_update_atomic_write_disk_info(struct nvme_ctrl *ctrl,
+		 struct gendisk *disk, struct nvme_id_ns *id, u32 bs,
+		 u32 atomic_bs)
+{
+	unsigned int unit_min = 0, unit_max = 0, boundary = 0, max_bytes = 0;
+	struct request_queue *q = disk->queue;
+
+	if (id->nsfeat & NVME_NS_FEAT_ATOMICS && id->nawupf) {
+		if (le16_to_cpu(id->nabspf))
+			boundary = (le16_to_cpu(id->nabspf) + 1) * bs;
+
+		/*
+		 * The boundary size just needs to be a multiple of unit_max
+		 * (and not necessarily a power-of-2), so this could be relaxed
+		 * in the block layer in future.
+		 * Furthermore, if needed, unit_max could be reduced so that the
+		 * boundary size was compliant.
+		 */
+		if (!boundary || is_power_of_2(boundary)) {
+			max_bytes = atomic_bs;
+			unit_min = bs;
+			unit_max = rounddown_pow_of_two(atomic_bs);
+		} else {
+			dev_notice(ctrl->device, "Unsupported atomic write boundary (%d)\n",
+				boundary);
+			boundary = 0;
+		}
+	} else if (ctrl->subsys->awupf) {
+		max_bytes = atomic_bs;
+		unit_min = bs;
+		unit_max = rounddown_pow_of_two(atomic_bs);
+	}
+
+	blk_queue_atomic_write_max_bytes(q, max_bytes);
+	blk_queue_atomic_write_unit_min_sectors(q, unit_min >> SECTOR_SHIFT);
+	blk_queue_atomic_write_unit_max_sectors(q, unit_max >> SECTOR_SHIFT);
+	blk_queue_atomic_write_boundary_bytes(q, boundary);
+}
+
 static void nvme_update_disk_info(struct nvme_ctrl *ctrl, struct gendisk *disk,
 		struct nvme_ns_head *head, struct nvme_id_ns *id)
 {
@@ -1990,6 +2054,9 @@ static void nvme_update_disk_info(struct nvme_ctrl *ctrl, struct gendisk *disk,
 			atomic_bs = (1 + le16_to_cpu(id->nawupf)) * bs;
 		else
 			atomic_bs = (1 + ctrl->subsys->awupf) * bs;
+
+		nvme_update_atomic_write_disk_info(ctrl, disk, id, bs,
+						atomic_bs);
 	}
 
 	if (id->nsfeat & NVME_NS_FEAT_IO_OPT) {
-- 
2.31.1


