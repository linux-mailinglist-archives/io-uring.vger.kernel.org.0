Return-Path: <io-uring+bounces-9092-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D34CB2D28A
	for <lists+io-uring@lfdr.de>; Wed, 20 Aug 2025 05:23:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BC9C31C23E8B
	for <lists+io-uring@lfdr.de>; Wed, 20 Aug 2025 03:23:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B596113B58D;
	Wed, 20 Aug 2025 03:23:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="S3kjoaLg";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Yg+7qMbw"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D769353349;
	Wed, 20 Aug 2025 03:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755660206; cv=fail; b=mCDU6q8n+poW6RxxhBcAPJFYPmFAnHk0BO45tWIuixlUOrmnHSq09ddX7kYzLgqt5WnCA+tiUPk8bNVEi/ZAVVkLob04Y5DFUIWy4KI8J9LKVAccQxsN4c1VLXdUCqJmZrTqvd9gX4Hvhprv2f/Jat/n4acH3XdKXmoSPANrb98=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755660206; c=relaxed/simple;
	bh=Gm2bvrW8mUA7UftqsKqvqfdw/Xdlu6sN7kBzw7vViH4=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=QShzBuaiPSGBQoRkSZS5zDji8mWw5YOaGSdKhUvedBhW5x8ZlyPOedOjclDJUw6OmsqQAEC9JQvry857ofnC3obAPpFmh349T5EAa5mBI+qjf2cTsj3mLsJCrYCu2IbWvQ8dnAzQW6ZBtRCVOda30LumRMuPUhKjS/5eGC3csv8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=S3kjoaLg; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Yg+7qMbw; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57JLE2GV008324;
	Wed, 20 Aug 2025 03:23:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=KFvhEzw/O7JXtl5BST
	2UFkH/116EP3p235VtHvNxVwc=; b=S3kjoaLgoGuM5e9qq+t5RVk4Gb3ZiSxeak
	nOqytrN5g/pjfOz2+rKNa5mCC9uAOA9Wpll8mN1v/8u8u/t5Movhpfgxt2M8Vout
	bORh2rBtwnh5yVy89DY1++/aTx2hAA7e1WDaqacs/uketqRKT4MMCZGwDbi07sMz
	Mf606fx+PUGQkE9NTLi9OA+qcF0Cnv+ApKW6vdPJs+DPLf7YPsKXIinOFPA84Fvg
	0XN51aJ8ABctp8RUOk9c4+0jphsGWTEjPV6ibZXlzRwFae5sdOEoQqlaT0jBahpk
	aretu3EWD5Op3i/kZtIwb/2vPb0k3sDZwNXJm7oY6tevmIUGzZxA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48n0ts8c2k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 Aug 2025 03:23:14 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57K31uvA001751;
	Wed, 20 Aug 2025 03:23:13 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02on2064.outbound.protection.outlook.com [40.107.95.64])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48my3ynqk5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 Aug 2025 03:23:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oECkEb0ZifrkZWPwl/F2vEHvJTPPGK9PDmLPv2ubc6bxXn0sary6iDYjPHbHk7oywcYZNwkQ97Y6ItuP1PDPhoaXF1AO40PNZPlAc1l9KitvnClq8GJYbmTLHLhxub41jQZ8zfU7ntAheIXUAOlqA0IDUgqRbTwV6PuymQKmEZHAzQJc8k25o49MVTbbrhq27/b0C1XFrGeR2VyF2M+n0D19YewPmN63CuqShidUxT5h0QCQhj6Ct7Ndx1XF1O6CxKNv70PW5uD5zvwtRyEnMoCLotbLjjjGfMc4PKNA5NATSXZMebP8XcgJPul7mmt2W5yMswOIH5UthZzJHMbF/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KFvhEzw/O7JXtl5BST2UFkH/116EP3p235VtHvNxVwc=;
 b=gAQw6HORVjLWwA9GBTl0O+qXLph2/HR2/5fYZ8bUsvBJVt+E9kU+wSWrGa1OpVlekdyrBJhBsuL5rnWFvrQsKWGAddG7e/DcvFxVZ5Q7rswAIiBqwJnDIB4JUsF9sYhpDqDJ4CexjxVCrz+3b/mA0D2Q9Bvr3P0mvHsxEkNb0eR7Hvge1BU+8kaDq7bsHbVF1urnarXbrfynBfgfV91HXqaF6iHQxww4+NkqlWneT7ppYypqAu58JYuxbYzjW6YPDDUuSgreBVkebLtL6DfDnAMpNqKE6EdO6S5xG6ZuvQgLdU05hZaU7Kxz5Istmny2xc1OCS4EsKbXyajRJNHM7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KFvhEzw/O7JXtl5BST2UFkH/116EP3p235VtHvNxVwc=;
 b=Yg+7qMbwjlUHe8gWx96etYC72nLJRPifZ0f7ATp76Ji5wQ0ygHAdpI87gzyTHqVuRk9lSL5Mu4v3NPjLuDYmOTGzQtvRldujMYp9ItqzG53lrAUHNJYWsnaTqE7tXdEJxibgM8sEfEoj1IFrDp6cuDLfr4glDUt6cF+gg4TBxlk=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CH3PR10MB7930.namprd10.prod.outlook.com (2603:10b6:610:1c5::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.13; Wed, 20 Aug
 2025 03:23:09 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9031.014; Wed, 20 Aug 2025
 03:23:09 +0000
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
        Anuj
 Gupta <anuj20.g@samsung.com>,
        Kanchan Joshi <joshi.k@samsung.com>, linux-block@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH 2/2] block: don't silently ignore metadata for sync
 read/write
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250819082517.2038819-3-hch@lst.de> (Christoph Hellwig's
	message of "Tue, 19 Aug 2025 10:25:01 +0200")
Organization: Oracle Corporation
Message-ID: <yq1zfbuu16g.fsf@ca-mkp.ca.oracle.com>
References: <20250819082517.2038819-1-hch@lst.de>
	<20250819082517.2038819-3-hch@lst.de>
Date: Tue, 19 Aug 2025 23:23:07 -0400
Content-Type: text/plain
X-ClientProxiedBy: MN0PR05CA0012.namprd05.prod.outlook.com
 (2603:10b6:208:52c::35) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CH3PR10MB7930:EE_
X-MS-Office365-Filtering-Correlation-Id: 4ff7e97d-b598-41db-ece2-08dddf98e2ef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?x2WjwClIEtCBB5nMchd55wIUI57Vo9k3/yCPmbCUGqucwZSaKP3rC5NRvYh2?=
 =?us-ascii?Q?hU1JzOW1dtJQ5XS7BaBjMPsH62R9iQPaNZZCqZWzfi8MWAO3ycTZQvGSzMAG?=
 =?us-ascii?Q?Ozr5IJV4AkMCHocwxCSzsHqNc0ZhPW52iDBpHDYWXSjodyJFxvWO50Jm0lx2?=
 =?us-ascii?Q?L2U0ckFil3D2K5x3IMtAR9mW6pa2+mahh5DhTqBWojUJDIf7BlLx52CXipS6?=
 =?us-ascii?Q?A9gQIkm4qyVn70q83xWgm6lzkQlQYSj3DYWDzhCKqV0nVdqyemjZzHSr3x8Y?=
 =?us-ascii?Q?VgHSknS6J5Psy/vypW+Gj/moLkeE5IRsqSdnJBOtM8PDyV/6ilAiig9vHaS0?=
 =?us-ascii?Q?5rTm98HRCP3GSrODuzVnSpYU9SVgfphQ0Y5v9G7cb22RccXdDUpM0332Zyaw?=
 =?us-ascii?Q?Qjx9eTFjLoNSptEMvegQMzE2lPvsJ4Oqid0aKdH9WY5YfzEJBXONz6//tGvT?=
 =?us-ascii?Q?GnUKwWZgYmNwui9QhF8FUw7CsWWxvhFlL7hHfK/G1m4NMXLS9KeJL+gQTZ22?=
 =?us-ascii?Q?hf9x46Yl40UTxq4mt8zT22OgQarJ0ivJoPUt5JKAiYFA9JdaFIPu9UVpePo+?=
 =?us-ascii?Q?Ko3z1XlfJ5z+lEkgH/8mnkjQ20r6/wmIKBG1o8CzyF9U1iSLHBS9YiY06RQT?=
 =?us-ascii?Q?rIF8gjvYb17hu26qGE0QprD/ZqoSwiH1fWQzp8anPkzRpADtbxgs5adz5vcb?=
 =?us-ascii?Q?fx7+80Bc8wvRjyqE4x9vOO2nAv+Mr6CplSVDxU2p1i1qnip95DQhFxwiiow8?=
 =?us-ascii?Q?v+CnqKEqosd+FmV5c9pS8wPwhU/OZ5OSkv/2nbNCNI+4arI7nY1MHjt2D3UD?=
 =?us-ascii?Q?wvQgEx111+jbG579XOaTko1725z7nmzUxahUfAqTyco30ONnEGWjaIgaOuVx?=
 =?us-ascii?Q?Bp0cuYdzPayIrDQVNPCfq4e6Lr5JEmfAz/DIuoimIGVELGIA/S6ioj41F53Y?=
 =?us-ascii?Q?dXdgNcXpnW1tfNxoQxwCFRm1wxBHQ3VIKoAmw5tZWmFpGKEDu0jZgz6BJw+K?=
 =?us-ascii?Q?rwhaGLOFIX2qJWKpwPmrrLnbPFMmjraQyYE5x0ob3ZDICj8jK5JA5a6pIszY?=
 =?us-ascii?Q?9NqzEv3Cp5zyVvRNYQD7eupt4eVvqeHiYiE5MjfZ7+zFI8S3V14pBkschJzG?=
 =?us-ascii?Q?tl61mGVAqyFsr65uhHLMJ4qr163QF5GnFd2UQHie3qxcN2fb9O1vxaj06Iih?=
 =?us-ascii?Q?ae7upeptnc+Zkx7brXDReCuRNPah0SyjKGOAgYwvPbNYB8y823VbSeVej2qO?=
 =?us-ascii?Q?Z2cXyKHgbYNXmi9cFlLTSPkcF9y1ckemAZURSJxm/BueNseK8gqA+a+zFBKN?=
 =?us-ascii?Q?tALo7jXsybW5Hgz4cfaRBZN9ltr1aaUOPEJIfa19TFTW+DEcVi0sX7HOTYzJ?=
 =?us-ascii?Q?nCOd4lrBUgZCGHrY6NRBY5vjXjFZQSV4XIfgM+fRM9TfN4s/eKhTxp0QwHie?=
 =?us-ascii?Q?QoDfkx90kZs=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?D8WKa27VdIpj7XKtnxa4x/7MAKFcVXakaOin2w+5Qfkhz/iS5GZMliu8IpyB?=
 =?us-ascii?Q?6Cwiwoj/lTYYuTP9LtY6/xYwjeBiZJfQ0TArJz8KZi4Bm6anjr0vG/uqVU4D?=
 =?us-ascii?Q?GyMsyN7Nl/BDbSy9pr35A+7m/ZK/GVwNNKNXY8e+bNw27RrehapnkLn9XVmo?=
 =?us-ascii?Q?+5f/JLSRn7ikXvcyT7nhizRXhshhyif6TODkzqLBbB60wV/MZPl4xA7tlkgp?=
 =?us-ascii?Q?iiolvw/O1bYiwLgVYx0M3P5TVMGITLWP+wMf7Y+j6j96qXAMSyJCjiIaOQZZ?=
 =?us-ascii?Q?gZ41BBgQ+c1oyqfDfBVvrE1ZAWgKt1godfK9L3Ekwwypj1c3lyceu3K0coty?=
 =?us-ascii?Q?ciEejzyYiblxl5rHsn9VXsTzxXmmyJqGtYzXSUO/M3HxGiEfVAvmO00BIwk0?=
 =?us-ascii?Q?uaohlrgWGrHxSpQy2QOx/2lCyjU3B8aNQMDBJS936Z9iLRlQhNZVYmLpDegG?=
 =?us-ascii?Q?/ViuuwtBwOuiT2Hk7/ow6r0Oz8y+rLHCTjVnXUVR3xsjWvdRZEIzXiKBVNlH?=
 =?us-ascii?Q?8kmrNKFWvT3MLrZz1PAMuFIiIOf+gJQBisVB8raV6OCnMZGsHcqvWzOMaaFw?=
 =?us-ascii?Q?++SIAWeFJfAcJsIsTpMxKjj9dFb1Ocuw1rgPPGuh3XfEDt5uQG2FogwQwtNr?=
 =?us-ascii?Q?9dfP5Hedu20w5/rY2xmjSkWcw7m9s0P3neB7kL7NnAWMciSouzkp01aSjREj?=
 =?us-ascii?Q?chzQeM9/rO7+lXXFRzJjc9sW8uywZ/3+yWrjS30/cT2uctTyz/uHPAUXPs8U?=
 =?us-ascii?Q?WPWahTrOCkPzVOslJeimUWpcmfuG46t0QppKAcX/qeJfw+OSGKkj7Fw7V0AW?=
 =?us-ascii?Q?qIJcFc6JY5frDzgeW3ZGpvzftqz5viV3D+3AbXN6nZ2qVdGLIdCkqVzqq2pp?=
 =?us-ascii?Q?jXfVaSrTwHeGnoALLOBIsqiif7bLVhinfV/YSXVfXvCY9pojNeXkmaX0D/vK?=
 =?us-ascii?Q?hJDS1qGwfuAC6jaSddTsTTLHvPg//2NTW4mVXOdDy3MclGG0kaKSJF6lVN+r?=
 =?us-ascii?Q?UPMTgFaqBS2aPVHGNCvXD7+bE19cay7gE12by35Xmi8K/Ha8XTFmb3vrPFEK?=
 =?us-ascii?Q?pIwBziaLYHWwWsaIJD2lMq1BcUvnNM3XjgwHek7pT5XPMKmFxn/dLiRKaJa2?=
 =?us-ascii?Q?AW2L07CJ+ZDW0VVS8TXaiTxdMuc3cxd+dh6QM/GxjZ9FPQLXtMn21ADPoriO?=
 =?us-ascii?Q?Xkdb4igzb3ue+YygUM4obtTPVDDlBRFxRmi3wh/vXPbd9jZqeVaP8esZeKT6?=
 =?us-ascii?Q?1k83UkAFzJlI6gKmrxDvgQIVX9VTGGZbWsO/9cXmHK7qCuJz0LQmO3DQSDGn?=
 =?us-ascii?Q?MYHOkaAtKiKKbk+E9vlKmvWrO0XtkXV+q4L031Mvnwj+ww0GFFzbVoVrSQRk?=
 =?us-ascii?Q?1ou6U1V/Tvi25xUbujXQkDJsk5PPb9IuKu59n7z1NRVMra3ENuWwl8rSxDHE?=
 =?us-ascii?Q?fBXbooKwnYjXVz9Tk5mlls2wed6GHauXWhMcVdsdd4ByurXb/IwDFgajBSxq?=
 =?us-ascii?Q?LZdMVoTSZllKuo1AIhQn/oaa4Da9czb+aPiVWb1WZ5hQk12BjAPvkVvjZrom?=
 =?us-ascii?Q?BnYKSa7atKrYuJAriIDDEAkiAL4OKJjv96lz9PZevxx5Xd0rFOsdcoL3f8/l?=
 =?us-ascii?Q?cw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	BXvgWT1MsLQlZZJ7jZIHFO/fUFqoX3yiwxgLG8Z9v99YLSIhde1HzaWP7BcEbldObwTBmA5RYMITUlicx6sR9Ph2E1IzF61Of6xV5KDqRq16ZoowRqgrOmq1bsEz7hca8AQhaHr2pAXKlRDGgvTXT5mbGTQh1GWow17IXbmQB37Ylm2zyOHG02KuJTjjtrVLBQm96dVaqejlDlnpdA/CCFmSK2qGqgFVeBL0/I7TA/36t9UD9QabuYgfvnY63vGlnlN6vsbcWKIixhREbZZmxf7kVJ4liMbI/pkyEOrEM8qzwXUDzhomDfTta/P1Yb110Mwp98BG1QJwZaqsOohZTlRr4ldUwMiPfI8zuDLGSKuF0O6j6tEmljD3THUvfOmlGTreCCvgVToGwzVihnGowK5jETbTWCHFA4TLUTiLjNZAPxqeREsVJqdgMRVMbdaJHttAuyPJQAP0TIZdFh+La5KoXTAk4DTcIwiXEGtOjjcPUaTC2i41yN4m/3GvOxxYC2GHMM1uzwyZL3nRcb58YEoDhRZNIIpxKJWFcAVfrny1ynC4Ph1m4/gP5EpbiTaUmmKlqc0Co2pcUHULID9+a8LVFMSU4K0ycgogOdx2B2M=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ff7e97d-b598-41db-ece2-08dddf98e2ef
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2025 03:23:09.2949
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J3gx0/4cTDLoZdUOZcxPWVEp9VDcADT3jdSCvksA24EavIu6ge9Ik0Iue4LbKvML5BurGtHbYKGaF/tLH6308doEfbFOsU9mbEH304dR08k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7930
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-20_01,2025-08-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=936
 malwarescore=0 suspectscore=0 spamscore=0 phishscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2508200026
X-Proofpoint-GUID: 0Lrw3BQu15bjre-k3Qjvf4hg0KDEaWQd
X-Proofpoint-ORIG-GUID: 0Lrw3BQu15bjre-k3Qjvf4hg0KDEaWQd
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE5MDE5NyBTYWx0ZWRfX4Z52ZurnfXjz
 InDwmjP5ikrSIjXvDfX6eHblHpYTFVrlPtHNOdhvBRXnVHhKGh91auwBrJ0PhIW1pXpHvqNGc1u
 J8GcG/loDkx3dLkDTD63Ez9RwbycUOVuR0izZyotMPWh1jaV116vwqXnFF6yqBUAxsN8zp1qhUO
 sqZTVJ29w4aYbidh78ylSrzCq3xzEL0MJTuOgpSz/tdgafJkNG8EAf6j+YUuCJxaD515C0TAV4L
 9jSrK7/H/vwqBCSGdE1w99/d2jpaE54Iw5PmS0lqA83xlInFRJkUWzCOshLNz1FpbjszzwY+yAX
 hGmYvREtT1iy9f2ITCpatzvluD8VFDClyZJWVLpdrr99rvBhDhbH+BWnQFxNnjnxfYINC7BbVBg
 AaI786qeylNlI8ai2dbSa3MC6ruvi+Pg50DI/h6wjjMm7xd6elk=
X-Authority-Analysis: v=2.4 cv=HKOa1otv c=1 sm=1 tr=0 ts=68a53fa2 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=2OwXVqhp2XgA:10
 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=SrAW1rc-LsZ4TaB6Lf0A:9 cc=ntf
 awl=host:12069


Christoph,

> The block fops don't try to handle metadata for synchronous requests,
> probably because the completion handler looks at dio->iocb which is
> not valid for synchronous requests.
>
> But silently ignoring metadata (or warning in case of
> __blkdev_direct_IO_simple) is a really bad idea as that can cause
> silent data corruption if a user ever shows up.

Looks fine.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen

