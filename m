Return-Path: <io-uring+bounces-12072-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ELVrBmU0hWlf+AMAu9opvQ
	(envelope-from <io-uring+bounces-12072-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 06 Feb 2026 01:23:01 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 90D1EF896C
	for <lists+io-uring@lfdr.de>; Fri, 06 Feb 2026 01:23:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 00B4930058E3
	for <lists+io-uring@lfdr.de>; Fri,  6 Feb 2026 00:23:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BEAE1DE8BB;
	Fri,  6 Feb 2026 00:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b="HAFALnox"
X-Original-To: io-uring@vger.kernel.org
Received: from outbound-ip191b.ess.barracuda.com (outbound-ip191b.ess.barracuda.com [209.222.82.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2874378F3E
	for <io-uring@vger.kernel.org>; Fri,  6 Feb 2026 00:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=209.222.82.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770337377; cv=fail; b=dYE12nu/W5NdHiSA/CY103lAUXUhQzr8IGs/hE9l/9q1DDO4E8xqyTTs39R9uda80CZLbe6PYJLlc3d0JTzF3psgsdff0n0mOaZgPYD5rs9TmgKLPH3EofVjSuyhqAa/L61xNrTt7gtzqrupedcawY93Cx/5RfI2NKtMXdm9jKM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770337377; c=relaxed/simple;
	bh=ly4zsEtTXYBp+CCfaHYOUcEsKxBUk7UhanIwxW92EPM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=PC3ITPepuODckHEncDaNRIxaiLgqzMXidi0yA/E/A6F5s77xZk68iTiZmD+EIhB5zxhs+FxC/ua7kdRsYktviJ0ECxS3OOpJERABZuv7HPSYzQyEOQ3IUs7QGn/lUC9nDDEzsMJ70dCJt5EtYu2CnFHP9DGEqj5BNaAuqFMDKNA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com; spf=pass smtp.mailfrom=ddn.com; dkim=pass (1024-bit key) header.d=ddn.com header.i=@ddn.com header.b=HAFALnox; arc=fail smtp.client-ip=209.222.82.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ddn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ddn.com
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11020114.outbound.protection.outlook.com [52.101.193.114]) by mx-outbound-ea18-75.us-east-2b.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Fri, 06 Feb 2026 00:22:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZILVnPQ3qYomeYQ1+NOPhaOK1oIC2snHTKQnOEks2ATgCFDdcW4oNJqpwv5P7jZzayTBtoOo5xhe6YWicvj7rVEnkvcfJoqRB9TekLit/lfhns8tHywWnAViwDU+9N68bYiqKJ2UiyIx6vGDuyXszn2GDCtHSpxjGOR6p2Rweg4umrPuI/IhhZoP/SLvIBjgZkQq4eGNxEdPItYEEXRwP4VvFZuqAk91gaj/HZ38rquRCAwr7hXniGJ20NPv4UfYgPc+jOY+5SUDd9teVxi5EvH2EG7W29VE9cEZJpLNrGPS/qTN4sY6rEti/xEYi1c4TX0EqDYDCFUOhZ7bNlnAkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MIE7q22yp0RxkB8xbAi2QpdN9Z1Dema6IzjLmd9WxYo=;
 b=UboV2YrqIxNDlmt10trsDdifftMWieK4Whk/ELJPXdLFfcfqQnO17e+0YJssqvLwl7a4jA5ehK9ZZfuUgVkwuLQ5hIXBTVzp4POgQ+Kn4skFyzxyNxVP9+VOPPXVz46fCohq9o2tA2AFBAAO4dk9Iy+1hxBqquOavjCbSrkLRo+/6fJW5rTfaFkR/ILhOAbQ1P9wckEHEML2eYLHsP2QrCvcdkopV/9SbwQPegX1pCbSeDxKNpwFDAslq2G1eyf7nx5V3njNFwvhDd3GwU+3JDv4PUJqrl+Gm0t6fCpzdKtGsaqMnHnwE8V0WRgy2D/g3sIQ5QdD6htXDj3mjYKjKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ddn.com; dmarc=pass action=none header.from=ddn.com; dkim=pass
 header.d=ddn.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MIE7q22yp0RxkB8xbAi2QpdN9Z1Dema6IzjLmd9WxYo=;
 b=HAFALnoxkrDY0WYztVsn64fU4KWVKFXdeUYTAkxWCTGNHJ9s1Q9Zdu1MopsJ/hfIe0WAD9B1LatM/dFLondhGOENngnFHygdh+YZ60Rsz7zy59s1eQ7queANvNgM4M4hiwufG+S+VKFxd7DbCeIhkyQZ5GUNB606QYp+5XYmLq4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ddn.com;
Received: from CH2PR19MB3864.namprd19.prod.outlook.com (2603:10b6:610:93::21)
 by CH9PR19MB9708.namprd19.prod.outlook.com (2603:10b6:610:2e1::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.13; Thu, 5 Feb
 2026 20:49:44 +0000
Received: from CH2PR19MB3864.namprd19.prod.outlook.com
 ([fe80::c2de:bba2:8877:3704]) by CH2PR19MB3864.namprd19.prod.outlook.com
 ([fe80::c2de:bba2:8877:3704%6]) with mapi id 15.20.9587.013; Thu, 5 Feb 2026
 20:49:44 +0000
Message-ID: <ffe1a340-4759-441b-b04d-2ae7732bbd35@ddn.com>
Date: Thu, 5 Feb 2026 21:49:39 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 19/25] fuse: add io-uring kernel-managed buffer ring
To: Joanne Koong <joannelkoong@gmail.com>, Bernd Schubert <bernd@bsbernd.com>
Cc: miklos@szeredi.hu, axboe@kernel.dk, asml.silence@gmail.com,
 io-uring@vger.kernel.org, csander@purestorage.com, xiaobing.li@samsung.com,
 linux-fsdevel@vger.kernel.org
References: <20251223003522.3055912-1-joannelkoong@gmail.com>
 <20251223003522.3055912-20-joannelkoong@gmail.com>
 <4e406b1f-723b-4dc7-8e50-1a5ef6ea11b3@bsbernd.com>
 <CAJnrk1YDa6=ygmaNhtoDudGdLKmWsP52+_aYNz3E_VNzQUVsDg@mail.gmail.com>
From: Bernd Schubert <bschubert@ddn.com>
Content-Language: en-US, de-DE, fr
In-Reply-To: <CAJnrk1YDa6=ygmaNhtoDudGdLKmWsP52+_aYNz3E_VNzQUVsDg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PAZP264CA0232.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:238::8) To CH2PR19MB3864.namprd19.prod.outlook.com
 (2603:10b6:610:93::21)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PR19MB3864:EE_|CH9PR19MB9708:EE_
X-MS-Office365-Filtering-Correlation-Id: f0f08eb2-477a-4358-f993-08de64f817a0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|10070799003|1800799024|376014|366016|19092799006|7053199007;
X-Microsoft-Antispam-Message-Info:
 =?utf-8?B?S05tdjdpNlNQcnZDSGozeUNORmdtbllkTGNreWJvMDd4WUZjZWEyaG9kNmhK?=
 =?utf-8?B?NStKTDM1L0dWVUlwWFNhM1ZoMGhoNklWVE0zUk9McjVPVzJLaEplRUVYV1Nm?=
 =?utf-8?B?d1A4eXk3MmF5S3hPWC83SGpHWE81KzdNUGQ1MnRSSHl4SUxxdmU0TDhxc2xq?=
 =?utf-8?B?c0E1QTdQcWtkYTdocmIxS3U5OVdJcUVUOGNmN0s0ZjU2dVBjZ2JlQ3dtZXRq?=
 =?utf-8?B?M0UwbmREaHdFblRVNDZ6UHlSWmNVby9aY3BhZ2Q0WmN5d2k2djM1dWNSeWxk?=
 =?utf-8?B?YTJTalpKQlcxdTYzQmZkWnhHYW5GQVVWYi9qQStMQXBtRUZrUVQ0NGtzUmF4?=
 =?utf-8?B?OHlvaHZKRFVhdDEyS3YyNkZrVWpNYVY1V1J6VkZ1WXV6aHpvUXdLOS9rL3pT?=
 =?utf-8?B?VGZod1pzSlVyRytBMmo2aTFDQ3FYSXZzcjBLVEM4N1EzU1JpelJQc1NoN3lR?=
 =?utf-8?B?cWtnQTEwR3lDUE1zNE1kN2pWMkUzUXg0WVJUMDJNem9QM3VlcUU4Q1NjdzIv?=
 =?utf-8?B?bnlBam04MmdBbGRxOVZVNTJmVGxkRno3L2tjS2lUdWZndTRKSTAxMDVJZ3JO?=
 =?utf-8?B?WnhQRGg3VG51Rzh1YXMwVTlkdWlQV08yRXhGTHdQWkZleWRTL25paml5Wk9Z?=
 =?utf-8?B?U04yY1o2RG1Yb2NmdXhOOWhPUnlpd3FhbUxKMmtuUldlWWVrUXI5M3g2dGhI?=
 =?utf-8?B?eDZxdzluR2NDeXZsT2dZNzFqUjlxc09lQ21MaVlRenY3QjAxVGFaUFhiL3Fn?=
 =?utf-8?B?L1RZdkduU3JIeVRCUVRVaXg2TzAxK2x3VFNUUnAydEhLaHg2U1NkSXo2T1Mw?=
 =?utf-8?B?Z2FEMzdWaW5rNDh3TlJsdHArMStnejJ1NXd4UnBLT0pBZUdUK1hEL2UyK2lW?=
 =?utf-8?B?aGg2a2ZHNmtSYmh1RnRiRG96V2pLUnRoODR6SGtCMHEwdXUweFYyQjBiOHhr?=
 =?utf-8?B?QUNxcFZpMUpsWG1OTkFqbWpxdmFSYkpxNjBRa0JYQTVSb3RzUjA5MEZyQ3Bp?=
 =?utf-8?B?dmYxVzhQaWhGNmFISjdUazdTSEExR2NiazVXMGNVenJOdmZtdlFiZDVNa2ZC?=
 =?utf-8?B?UTZkNGdOdXI0MmxpOHJUVEpxbVd4aVhncVVUWGoxOFgxNzlwT2w3d01Hb3BM?=
 =?utf-8?B?a2FTVmFnZ2RqRjJYMWpncDhsTGlnSk5BRzU2UWN0UWtsaFQzenNZQnZoQ2JK?=
 =?utf-8?B?TkFzeDdaN3pHSm1YMmdDOFpLc1JkNmNheXlPYXltOUhna2ZSemJ0UTFKcnR1?=
 =?utf-8?B?R0xUY29uMVJJOG5Vb0VpWWRpakJ4SGZjck5zVHc1bU02ZDVKMU8wbmMvbEdy?=
 =?utf-8?B?Q0tqVllTRzZsNTd6bk1WTnUxTTEwRjZ0dHBwaFdtYjBlZ1pPVWdhM1pZM29J?=
 =?utf-8?B?WHpPM21mb1ZQaGU5U1NSVXcxMHJpaXFBZGVic3kxUVBCUStIQ1FNeEtGT1Bh?=
 =?utf-8?B?T09RNnl3eTZ2ME5Tb2VHdGZIcWRyOWdGSFhTL2ZpRXJRVUEwaVNkcEx1VmdR?=
 =?utf-8?B?dlYxUXBNQThLOUpPQnJzS1lFTjM2Tk5rcmdZbXl4OWdzVjQ5bTJRK2d0aEtl?=
 =?utf-8?B?L3luNlRrdEdoV0tqVmJIZ2VsVzYrbmx1b0dmdXFtNGVUNmxxUnhzVlAxNWZi?=
 =?utf-8?B?bEpQaE5kRzgyQ08vc092WHNUWGVjZXU4L1lSM0VzakVLQ3ZPYmVMSDZUQjhX?=
 =?utf-8?B?Y2VDeGdqNis2U0VJbnZ6Tjc1anV5dERGQ1doS1doRWdreFlQQWJ2UlBEM2sy?=
 =?utf-8?B?cVcwK0VJRlo5U3lNTjZUMEt1ZUtuQURzZ1Nlbzl0U29yZlVSRXRZZUpWa0Vv?=
 =?utf-8?B?ZDBvQUQ5djg4TnNnTFNPZlQ1Nzg2SGdselhUS0xlRHg4SDBTVXNWVFpQN1Bp?=
 =?utf-8?B?WkhqQWhsN0VRTFY5SmtsbGd2cisyQUhRNlEzd3l0M2VqalcxdE5nUmZOb25z?=
 =?utf-8?B?Vnp0aldpOCtqdGtWYm9hMCt2dmhWOEdOZkR5SkRiamRQQnhla3dzNC9KdFpy?=
 =?utf-8?B?MUI3K2tlK3Z0d3NESnl2YWFDbnNwbVBVVXo3bzd5S1ZrRFBkZS80Wm1CL2hj?=
 =?utf-8?B?Ujhjc0V3QUkzcEpWVklNZUh0SkVkWHV1M1c3UWdlMnBzMlNmb0RaTFJ5cE9j?=
 =?utf-8?Q?N9RY=3D?=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR19MB3864.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(1800799024)(376014)(366016)(19092799006)(7053199007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
 =?utf-8?B?QmRQQkxzbFpTOVMwY2I3TWNudFVocTM0WEtCMGh5aVlWSkpwVWdTZHV6V0gw?=
 =?utf-8?B?b1V6ZWdWbWltRTNOZXpQeitURDdJMFFCL0ZiNzdQeUJGL1hleUtCT3BmbG9p?=
 =?utf-8?B?WEhiakRodlJ0N0VHU0VpZld3Y0JUbHVMUWNYRlZNVnpEdDlBQ0k4KzY0VGdL?=
 =?utf-8?B?UXlna1ozVnE4aDdxRDRDUmtSelJjNFVVdDU5WCtlNXFQU2Y0Y2x4MlVlaVNh?=
 =?utf-8?B?L2I5aG1mRGtCOU1jUlNsd0tFZGFSZ1JObnc0WGVPZEU0enVBeWc5OUlHWmVk?=
 =?utf-8?B?aTdMeXhDQlMvQ2hwTDI3eE1QTkFnaHJhZjVhU1B1Q3ovQS93SnJSdWMvMUQx?=
 =?utf-8?B?NkRjL1NmK1FYL1I3S0tnTmlDMDJaaE8wdTFhV2c3RkFaaElnL1o1YVZFaGlE?=
 =?utf-8?B?SVZRVk1iOGhVMFB3ZElxM1lpcktwWWdqSVBmbVJBUlE4cTdUeGRibXMvQVVB?=
 =?utf-8?B?eExtdW5TZjZPN2pJUEVGSHp3dnVqQTFCbkUrcllXMm9PMTFmSmFhbTRkcmZH?=
 =?utf-8?B?NkJrM0FoeFFQWU8wcWZDWEJlb3V4QllIbnovQ1RQRmVwTTBreWhPWHVHYVUw?=
 =?utf-8?B?QWRndjFCdEp4ZjAvcDg0VDJIeisrSnhBSVdPYWo4Umg2K3JZQ0NIVUN3ekRj?=
 =?utf-8?B?aHRuSnE4a0hTMW5LTGtmYngvMUt0TjJGUThtbmFGQ1NMZkR6SWIzNGx5V2tE?=
 =?utf-8?B?WUhsWEh2dmtPa2xDY09hKzNiMXduSTQ4TUdSVUlCdytVbmpacHNZaWhieXZN?=
 =?utf-8?B?OWt4a25ZK0tIMnVNTjJOMHlEOWxpQkU5MFJ5SnpDZWIvQyswQVp2RFMyTWQx?=
 =?utf-8?B?RENUWC9mSGV4SGl6cXJHQUQwUExCNkdzQnRaSTR2MnZBSmdkdSs4SStFVjU4?=
 =?utf-8?B?NXl6Slh1T3VJcWNCbWNyU0NKMWd4OWRPU2ZpVkY0UkFjZFlDWUozVy8vNFBw?=
 =?utf-8?B?WXVKUFVtd2NnYjVVcVFxWFNvWG9COW4wL2c3emc3ZnpqNVluYUdiNVBZL2Vv?=
 =?utf-8?B?K0NNaHlsb0VIbkRRTXNQRk52SXF2RTd5T2lRUGk3bzVmbDYweGE5TkVFNndh?=
 =?utf-8?B?Um5Xa1BuVFBzSFU5WndLeFRoME90Vm9iYnJqRzNSU3NNOE1IYU01M1Y4cDV4?=
 =?utf-8?B?SGRnSkZ5c1VINWhGYkJBQ283RDRVMFhDaVR5UFdmdFUrWVN6L0krZW1lZ1V1?=
 =?utf-8?B?ZFczUERYb2xJNUpHSGROY3BQTFUrRU4xQlJLZ0d1aTVMbnFPWlloTEl4dEFa?=
 =?utf-8?B?dGJzZXQxc1JuMXcxQUdCWkYzaXFMZVg5TzVhREtINHJ3cW1TdW0rVmJBSW1V?=
 =?utf-8?B?dWlhN2pTVzRyLy83V0gzN2pNL0wzUWJKYlNXMEczYWFzMFBzWFNqby9wOU5k?=
 =?utf-8?B?RFBaYlhzd0IvQXZCSGtOK0h2b3ZWZmd3VXY3L0ZCcTdkRCtpT3UwRFlxU280?=
 =?utf-8?B?dzRQeE1Cbkl6NlFMa2hjWGlRK2hBd1pha1dlZTNDYnE0THVId1FZUnRNNTJD?=
 =?utf-8?B?UkRsRmZXaGlsck41V0QxSnpuT3hwclZCK01WSjV6aldSUU9iMTJ5aEoyWS9u?=
 =?utf-8?B?NlZzazd3dlZUUWEzdHRkTEVFejhsZk9rUkd1RGxSMEdaenkrKzBRVGNKUito?=
 =?utf-8?B?QVpWUUYzNXRiTTNLUnpOam9RZXE3cWxRYjl1aXZ3OVN5bkVhVVpUTDlnNkdm?=
 =?utf-8?B?dkp5YU9nYmVrUWg5ZlRvL2Y0ai9rYUhDdG95L3BOczJ1Y1ZhNXlXSnhTZHMr?=
 =?utf-8?B?ZERmZUNkQXM5YStOVWdlZG5hRHUvNldZOGZBYjN1OWVDQ2hnb0s0Z0hoMEp4?=
 =?utf-8?B?TDRaaGQ3b2hsdnRBNjkyeVZoKzFoNlNpU2xSUldpcnNtV1I2SjZ2ZTBqY09M?=
 =?utf-8?B?WGYrNWl4UkIvREx6S0NvTWVDY281Tm5kd2dRdnkvR3dCR0R4dEE3NVZCNGdy?=
 =?utf-8?B?UVRaUFVOalpGcjZGd21SckxYcHpTNS9VaktGL2NTQWR6UUxqRWsrUVpvTi9l?=
 =?utf-8?B?LzlpUERubyttS1hpelZQN1BDY2pteUViWFpxMlNZQVgzdU1Bek4xZEdCUVRB?=
 =?utf-8?B?dnNwN2dUbnkvU0lOa1F0NjFPb0g0WmwwUnRGakMyTkxuaXZ4ejhVRXd2ek9h?=
 =?utf-8?B?VVR3ZmYvNkl3QlJCVjZMWjJ3bUdlSDVxd3AxTFpSb2ZFSGw2cFRVQU0xY0ZX?=
 =?utf-8?B?alpjb0JXR0FHSkxwSGpDSGpyUUtiQUhmUXFOZzcyT2JjYWhzWWJXcERvdXcz?=
 =?utf-8?B?b0xYOHdXWEFjRUZScVRySFM0VzRIZWx4WWpmWW1tNFAxKzdFMVNtdVArQUFS?=
 =?utf-8?B?OGIyL1NNdkg3eXpzOGNVT242b2JTOFFDMVdNMGg2cUlMTW42VWFNVkJFSmJt?=
 =?utf-8?Q?nlTU5A77xcqpmguZSufNqIMkHUsnA+iqLXUMFRbLYQ2w5?=
X-MS-Exchange-AntiSpam-MessageData-1: xpWNvZtbAD669w==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
 laX+G/Z8h6RP6QO+4+CNWODwLWF7EzRjqNVRaAMyogeXB44xJIAvDd/idUqkpmrIRHfvIh1dXwE5LKFGXxyMRfxulwShv8OUdONzHcBknd6XsM+1y2fEvl6bx+uVts76eoK2St3HblqKRraQz6OR7rrgqUrl7glS13iEDdv3LJieBGrRXSIK9QbjtsCmAUdwKb1daj6kzKT4w+UsVsLvJuwpDjTTUMmPLNizGiIsnoS57v4yhQYxLS94MK5Yn9ltDrJcPPZoZQWI5uqWQ+ZFgsEIelbYZ006pP6bstr2yBVlIlNqTey7iqcYQvLb6mB7xmSyMK3kCLmYtIgek0HO92isOl1tWx+Pw6wulJEyKoX4gz6r5dbgNL3gvE0RBocZobokicnhTb2KfQ+e/i11EGmXl+XYoEC/12ykvmnAyK9+VgrqxgkqtEtuk/+MScnqUcdXrlX4rO9Y/lxHRlfwWJMVpoE2Lta166gVxnFDKNIa4nubN6XeT5YlezMWFgppbQ3u+B/1uU7DCZIBRLZ9EgFrTjMGtZhQg1lntCntUR74nJZ80cWAFjRZ3yuV9O+HZITZJyRJNMcv1Igm6tb7wytYaq5HpGQNoFDSx62AICDTVO+c0zsZW3rzy7HCg0gyYg6pOCD1UebsQTzr9Aa4wg==
X-MS-Exchange-CrossTenant-Network-Message-Id: f0f08eb2-477a-4358-f993-08de64f817a0
X-MS-Exchange-CrossTenant-AuthSource: CH2PR19MB3864.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2026 20:49:44.6593
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W0t6YvRweMqQvbR0HEySv/ZdObP0ug+W0GMRwSQl1wMeTdjcVLDyGpwux2UZW+SCQtXqi0NbDBy/WWbGkkSqcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH9PR19MB9708
X-OriginatorOrg: ddn.com
X-BESS-ID: 1770337375-104683-781-57161-1
X-BESS-VER: 2019.3_20260203.1731
X-BESS-Apparent-Source-IP: 52.101.193.114
X-BESS-Parts: H4sIAAAAAAACA4uuVkqtKFGyUioBkjpK+cVKViYG5hZAVgZQ0NLAwNTcKNEoxd
	QsOdnSyNLI3CIp1czIMMnQwDQtLdVUqTYWAFyy/yBBAAAA
X-BESS-Outbound-Spam-Score: 1.09
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.270931 [from 
	cloudscan21-25.us-east-2b.ess.aws.cudaops.com]
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------
	1.08 DATE_IN_PAST_03_06_2   META:  
	0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
	0.00 BSF_SC0_MISMATCH_TO    META: Envelope rcpt doesn't match header 
	0.01 DATE_IN_PAST_03_06     HEADER: Date: is 3 to 6 hours before Received: date 
X-BESS-Outbound-Spam-Status: SCORE=1.09 using account:ESS124931 scores of KILL_LEVEL=7.0 tests=DATE_IN_PAST_03_06_2, BSF_BESS_OUTBOUND, BSF_SC0_MISMATCH_TO, DATE_IN_PAST_03_06
X-BESS-BRTS-Status:1
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.34 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[ddn.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[ddn.com:s=selector2];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[gmail.com,bsbernd.com];
	TAGGED_FROM(0.00)[bounces-12072-lists,io-uring=lfdr.de];
	FREEMAIL_CC(0.00)[szeredi.hu,kernel.dk,gmail.com,vger.kernel.org,purestorage.com,samsung.com];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[bschubert@ddn.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[ddn.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[9];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,ddn.com:mid,ddn.com:dkim]
X-Rspamd-Queue-Id: 90D1EF896C
X-Rspamd-Action: no action



On 2/5/26 21:24, Joanne Koong wrote:
> On Tue, Feb 3, 2026 at 3:58 PM Bernd Schubert <bernd@bsbernd.com> wrote:
>>
>>
>>
>> On 12/23/25 01:35, Joanne Koong wrote:
>>> Add io-uring kernel-managed buffer ring capability for fuse daemons
>>> communicating through the io-uring interface.
>>>
>>> This has two benefits:
>>> a) eliminates the overhead of pinning/unpinning user pages and
>>> translating virtual addresses for every server-kernel interaction
>>>
>>> b) reduces the amount of memory needed for the buffers per queue and
>>> allows buffers to be reused across entries. Incremental buffer
>>> consumption, when added, will allow a buffer to be used across multiple
>>> requests.
>>>
>>> Buffer ring usage is set on a per-queue basis. In order to use this, the
>>> daemon needs to have preregistered a kernel-managed buffer ring and a
>>> fixed buffer at index 0 that will hold all the headers, and set the
>>> "use_bufring" field during registration. The kernel-managed buffer ring
>>> will be pinned for the lifetime of the connection.
>>>
>>> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
>>> ---
>>>  fs/fuse/dev_uring.c       | 423 ++++++++++++++++++++++++++++++++------
>>>  fs/fuse/dev_uring_i.h     |  30 ++-
>>>  include/uapi/linux/fuse.h |  15 +-
>>>  3 files changed, 399 insertions(+), 69 deletions(-)
>>>
>>> diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
>>> @@ -824,21 +1040,29 @@ static void fuse_uring_add_req_to_ring_ent(struct fuse_ring_ent *ent,
>>>  }
>>>
>>>  /* Fetch the next fuse request if available */
>>> -static struct fuse_req *fuse_uring_ent_assign_req(struct fuse_ring_ent *ent)
>>> +static struct fuse_req *fuse_uring_ent_assign_req(struct fuse_ring_ent *ent,
>>> +                                               unsigned int issue_flags)
>>>       __must_hold(&queue->lock)
>>>  {
>>>       struct fuse_req *req;
>>>       struct fuse_ring_queue *queue = ent->queue;
>>>       struct list_head *req_queue = &queue->fuse_req_queue;
>>> +     int err;
>>>
>>>       lockdep_assert_held(&queue->lock);
>>>
>>>       /* get and assign the next entry while it is still holding the lock */
>>>       req = list_first_entry_or_null(req_queue, struct fuse_req, list);
>>> -     if (req)
>>> -             fuse_uring_add_req_to_ring_ent(ent, req);
>>> +     if (req) {
>>> +             err = fuse_uring_next_req_update_buffer(ent, req, issue_flags);
>>> +             if (!err) {
>>> +                     fuse_uring_add_req_to_ring_ent(ent, req);
>>> +                     return req;
>>> +             }
>>
>> Hmm, who/what is going to handle the request if this fails? Let's say we
>> have just one ring entry per queue and now it fails here - this ring
>> entry will go into FRRS_AVAILABLE and nothing will pull from the queue
>> anymore. I guess it _should_ not happen, some protection would be good.
>> In order to handle it, at least one other ent needs to be in flight.
> 
> If the queue only has one ring ent and this fails, the request gets
> reassigned to the ent whenever ->send_req() is next triggered. I don't
> think this is a new edge case introduced by kmbufs; in the existing
> code, fuse_uring_commit_fetch() -> fuse_uring_get_next_fuse_req() ->
> fuse_uring_send_next_to_ring() -> fuse_uring_prepare_send() could fail
> if any of the copying fails, in which case we end up in the same
> position of the ent getting assigned the next request whenever
> ->send_req() is next triggered.

I don't manage to check right now (need to solve another imbalance with
reduced rings right now), but every failed copy is *supposed* to end up
in a request failure. Why should it block, if the copy failed?
It would be a bug if it does not right now and should be solved.

Regarding your copy, I don't think waiting for for the next ->send_req()
is an option, it might be never.
One solution might be a single entry in any of the queues or in a
separate queue that doesn't have buf-rings - i.e. it can go slowly, but
it must not block. Some wake-up task retry might also work, but would be
timeout based.


Thanks,
Bernd


