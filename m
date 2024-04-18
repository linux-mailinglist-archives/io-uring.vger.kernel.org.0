Return-Path: <io-uring+bounces-1584-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1573F8AA100
	for <lists+io-uring@lfdr.de>; Thu, 18 Apr 2024 19:24:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C0E77285F78
	for <lists+io-uring@lfdr.de>; Thu, 18 Apr 2024 17:24:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B098E171092;
	Thu, 18 Apr 2024 17:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="B2MJr1BW";
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="mRCGCpFQ"
X-Original-To: io-uring@vger.kernel.org
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABE8915E20F
	for <io-uring@vger.kernel.org>; Thu, 18 Apr 2024 17:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=68.232.153.233
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713461080; cv=fail; b=MJio1AVyKK46wHyOfJvxbhbVH5TIyuYe2FAEQviGd0XtHeIwezRRjOYWJtSlJqp/38NPd/6lPgv9avkyI0YlpuVIrzC01i7QOwwc8uSsd+jNQH+3d1Ljv9pPpgYYqs8dK87fqRN5qnLKNTV0/vxNKXC06r7jryBrtOMZaRnPm4c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713461080; c=relaxed/simple;
	bh=vKEtk++QwduCGKSY/e0uMoZMrW5nT677dhASNd0+Ehk=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=GNjOHVRLicL1okxXd+Ay+Q4AGjDUBXM6/RzNKGOOd1N74LbuJxOAFVQ3wEVCDZb+gHYljdX+zEVDNnr2OsIMfQVlFyK0GbKD7iHhOqSeohO4AjTa5QbfO/XiZbWfDZXjB1N0ESiEedE/m52+8BP0AgmrKD2T7jlV6s90UCU+CwM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com; spf=pass smtp.mailfrom=microchip.com; dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b=B2MJr1BW; dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b=mRCGCpFQ; arc=fail smtp.client-ip=68.232.153.233
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1713461078; x=1744997078;
  h=from:to:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=vKEtk++QwduCGKSY/e0uMoZMrW5nT677dhASNd0+Ehk=;
  b=B2MJr1BWG6alqRon0HvfD7K31FdHNjotZf4443Rf15kCA0FDr9HkyTtC
   s0dFajKzSal4eia1WmBrqun3XDEaLifLcU5/2mSeU/aoVDSQaru0U4eMu
   eMp1cagtmVNN2GXGblF+nfuYG9bVSq01X2HzND8qiiCBPMCvNtST9JGsk
   Z3CAwK6Tofkwpbh0pinlXM4pHXOwngodOE6Whmnn5l4CJUJQDCs/hC6WO
   WT4p6O1+4pFsaKg2oWeth4nUeI2o3PwNLxOk0MkzPe4SiXidmU68lk1LW
   v1YHZeg5/xoB7HbiTZA7jK2H8B3ptwY3KgRyAA4441bpVY8htEHKQY7fx
   w==;
X-CSE-ConnectionGUID: BgV7Vaw4RQ6vIKQu8KPLpA==
X-CSE-MsgGUID: 3KMDKn6OTliS3H4SP+iBhA==
X-IronPort-AV: E=Sophos;i="6.07,212,1708412400"; 
   d="scan'208";a="23656422"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 18 Apr 2024 10:24:37 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 18 Apr 2024 10:24:21 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (10.10.215.250)
 by email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 18 Apr 2024 10:24:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b/06MOUDWFqtfWbqRfwqiLrF1NgJ/p0rqb8Vh4dteebPgBEH0shopuJBxWVNFtkHF/VyIhlO5uS1mOoBM9ycAzjpQV5KS1Z/8HBQTM4q+oBJocW6I/nAe4UAHIHP9vfRbdOLfle7NbKsGzqJ6Tb28ZDUJ21ZAxr450FsUqy/Nh/GB4fP1zpCxtA586NlnT2AA3KJeGAm9p1tzZ7gcEQ16+ZK9kaGWn2eK+aHUrom2Eg5oQE80lTT77x2NQYtoVHjvFpn1xbm9GSFw0ubVK145XrNCCQrntsEOG/bxDh5IZJMRnj1sO7XH//60NfgAgaZjA2Q/DxH5VkXnt2onC6Tfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5OUVGeaLkF69GtZFNNiKidJa247Y+PWdlmN/qQ/xLMk=;
 b=i0JslWektM7eEQuvc8AHtbskjVbZD6XcEUNmRTQCX3mqzqIWz0NWtx5GS4FrxGf/8TqvLWjH4ZQO47gRDVXSxxr9nzz3XaQQGHi6FKuH8dJEeKU94Mf9kqFPqA+FkmWA6zLVEqFHPLmrDyf74evKJ9Z2t87w2vr/1jrMuypWezNWhRYvOWwLMWhWpWrsUDNqUpZ8vFkZghSq7fl++TAgKP99cFm3FuMGqcwb0lquglg7LXWGVOHUSOV4dzK+19ORytlC+IpUnk5+Z5ZycWMulGImUP1x/npfK/OCJo6ZPLCad+EzpEAjDrYrIGWh0Ay2tjYbPomRSLUeqg4I60SQwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microchip.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5OUVGeaLkF69GtZFNNiKidJa247Y+PWdlmN/qQ/xLMk=;
 b=mRCGCpFQ6QgyrBWlRlM01YYWWVfycufwx1Q2PUD6MaxHqVURYX0v+5+nb0CfIZP5M3PN4IhySk5X61hA9qvJa/qjULEXgnl+XcFntQ2ZUdSJXZB+1vmFEmfu6xY1q5ddUkvXgWxuqz0pQi309ohWbZGahP4JV5cmDFgyayYh1o3vodTkfyvmD0sVZP7Lkj4fFQ0dWpJ5yeL1CgEEyTwuLd4mVKHVjgi3HNt9FFYlsLIhHYZR73Cb0EwXbS6nJ3e1NilkH+1L+TVV3fh+/IKu0vViLPjlf79kJ4nBtRLusd4Z55QxGBD4CIhiwWhajrwoym3+vxqixuv/DydgSgivAQ==
Received: from DM8PR11MB5717.namprd11.prod.outlook.com (2603:10b6:8:30::9) by
 DM6PR11MB4611.namprd11.prod.outlook.com (2603:10b6:5:2a5::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7472.31; Thu, 18 Apr 2024 17:24:16 +0000
Received: from DM8PR11MB5717.namprd11.prod.outlook.com
 ([fe80::7c41:8e7d:960:c82a]) by DM8PR11MB5717.namprd11.prod.outlook.com
 ([fe80::7c41:8e7d:960:c82a%5]) with mapi id 15.20.7472.027; Thu, 18 Apr 2024
 17:24:15 +0000
From: <Doug.Coatney@microchip.com>
To: <io-uring@vger.kernel.org>
Subject: VU NVMe commadns with io_uring? NVME_URING_CMD_IO
Thread-Topic: VU NVMe commadns with io_uring? NVME_URING_CMD_IO
Thread-Index: AdqRtNy83lG+DxLASMmd4HKHRVBhng==
Date: Thu, 18 Apr 2024 17:24:15 +0000
Message-ID: <DM8PR11MB5717EA70F88545314961D862810E2@DM8PR11MB5717.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR11MB5717:EE_|DM6PR11MB4611:EE_
x-ms-office365-filtering-correlation-id: 1ad933ee-8c4b-4702-bfa1-08dc5fcc5f77
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: s2EC6/CV3Xy+IfHHc8Y9522sJ94f2h/qRYKjwamTBOZ87AOgOyDw17uDu0bqmPBzo/zduyZjeSFU9eviruG4Kvo00eviDFpBbkOwwPx7wKFA9mmkY5UHxi4yNMqq3T8xzuQokJyNvULbVc6WaV9flwgqhLVUDItBxJF7+ZLs7PZhIGwHZ40Dx1913zYGOTgw3OvwgidI7ezBzS/7xOBIW5V7dIWT74MpcDfdmdAenQ26PV3QpbOa7EPNaM0TcP1u3wRmam3OWyagYIhiGI/Xvvmyyx1wqmkOVix+NY7rSgZE4sLO36e7Q5JUi/9j0rd/2x8u4fRLknShC4kfaiwd/T4gPGqv+puO53jueLpJUg2gAsJEh3oyZ2JaftH1hbWR/sHFSRjoyHL6zhh99cFOaCSj86TWnLMd1FtcXQ8U9BAIZILkCo1QPRpevar7BPSIkxrH5Ebjuw8TZd0mogWgXh2qawqbtkn1GqOQCWTt59/wqwDsYlozRpn3LttQ5VgEueMLXNNG2y0naConSYNYK388Pv/Ub7uctQXYrdBwtS8pJ4+6bF8glChhdeFSVVUZ1A7xj+VW4jezLyEqdObFcVDXq9lO43Iqx4xBM9eZJ2rATjfoWeGZAPRXbOWyKH/LjI9IbbIzzd7XBD9lirsIi5bTozHADMvHYsCentPR5dbaliQE68qAUyXLIoCFZ/2hailc+tFMS1xAuh+1amLsrEdPez/bAmA/UBHdfAEa+Fs=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5717.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?99vwPm4nO16yiaG/EmQPMt8VFYhnd7RctHWQKqmqOatIsl0hMVPwOYdio8?=
 =?iso-8859-1?Q?IO4vbUPUDSbfUP78ow6l5HRubVGTPHkrRrGjpwLxxk2PiKKGmT75ol/FDN?=
 =?iso-8859-1?Q?fEs25HmyZqzKVGGWxLGSzqlp7EhlmOQuhuHOZPJFRicRmi1drsGcFkuSv3?=
 =?iso-8859-1?Q?l3HPnOI5fQAo5lUj0vi674Eysoq69dzkTL+WzA0KEPuNxg3cLezUhgWhZv?=
 =?iso-8859-1?Q?dLJaUQbFUrkYHBskOt6luaU+UEKZy2JzbnaZi9jLjh3ISnt//HnDPBfSob?=
 =?iso-8859-1?Q?8tWHGh0M0gckMi9C143g1kXsz0mxAH+/4tSZAVBb0xnIbiFhAkRhYP7Knm?=
 =?iso-8859-1?Q?AEDu6I91cNPHMWrvIHhx6eLo9tmAFYmG2jv00XXhor4MjcpYL6syYVmwju?=
 =?iso-8859-1?Q?0SIwRO+AANa6LDe+LV5sx5Iafelz+daeE6qlEXJ3TC+egsKDsAaILROfu7?=
 =?iso-8859-1?Q?dm5siZOdHaNHYovqbEpPmYVE6Jqh9Gsy5wXjpDfMqXPJrCcsZ0L3TMGLg6?=
 =?iso-8859-1?Q?SOCLj+x6IDtx3MsxcV3x6kmBYjneObYz7KOFoob5XTD6+5DyUMJi1K5hJl?=
 =?iso-8859-1?Q?f9nAc6QSIRjou92fIlgg68JxiEeWz643Kx4oA++uqc7OBMRI3DJfRewOVU?=
 =?iso-8859-1?Q?rE+3kF7uXDWMJeO5NloVSBYkgz7J/a+iipgynRDBfuSker8W9O3K3zdPZ4?=
 =?iso-8859-1?Q?4W7bgJ7yE0x5EoVU1/cjs+gaGpgaG69D+RHmoOaCw2FHsCuJtpZSTtFBBJ?=
 =?iso-8859-1?Q?WNRRC9HYMJgAZP43Tok+BR6nf1iqaspjkww5zIvhb4aoevBEpAX+wqJHqy?=
 =?iso-8859-1?Q?c/ZJ8r4jYa8x+8YMVQbYzlhvHRc/pNvr/YhVW8ggEsOBCZ8qnra2PjWCEf?=
 =?iso-8859-1?Q?AHChpleYcoBQDmKWKCToyWdZTT4IZ3ywMLffUmDjvdGFp6kvfCWNFVtwVy?=
 =?iso-8859-1?Q?pnd0IsaZPAsqVDUdLO+7SkR6Zol8HfsLtpKUSx19MpabeEGezzGCCBmzEs?=
 =?iso-8859-1?Q?ncE6tUBC3hBuHP/D/YGG2FCyiPyjjcUHXj2Rp+MAX3YZ7VejaT8cQfXxmo?=
 =?iso-8859-1?Q?fX8lKWXCYeExkEY6oIDJ2FOOfF/dnN5YaZXXX4ukFdoQRdIAbszYsKZ9+Y?=
 =?iso-8859-1?Q?52nU75jnzQeDvPyuQD4GLoCkZLqw6Gi2O3iBdSwVNlFfGsHd0strXf1gbP?=
 =?iso-8859-1?Q?ZmSI/ySZLc4Thfv6qhcY3X3NgW8AGoSuyElFcnahBJarvXPLrdhNW/S1G4?=
 =?iso-8859-1?Q?rASzVYX8U0Rr0pzvPa3ONBD5vOMklhD7bE6QY7T+enXk16JFK4IWreG0JA?=
 =?iso-8859-1?Q?zBIyWRCoStI88PzLkavhP4tS16qmSKyH3QDhMYqmpk7ovsLJxe89yEYYGF?=
 =?iso-8859-1?Q?FCK4lWP/JwIkiGNVGwoehN7jlNIaEww3D7SckAyPUcqBSm0iPbYcuHHuYi?=
 =?iso-8859-1?Q?ZSBG74IamRZtBB8LWT0XuTWPCnAA8n/L745rONj1SWhgxctKWgt0LejyVK?=
 =?iso-8859-1?Q?yDEkZdTvxBdvNrljRWFwEc+c4NpZiYDWUsAbhnsI1V9M3iELzfqI9bzo5c?=
 =?iso-8859-1?Q?scCQku6ls3q294D2iLNY6z226D7klDW95/Zv3EHbVhbjMg4CYnh4zFD6AP?=
 =?iso-8859-1?Q?qcmiXC4YdESgFi0GNzURtmso3guv2TKHN9?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR11MB5717.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ad933ee-8c4b-4702-bfa1-08dc5fcc5f77
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Apr 2024 17:24:15.9001
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Y3qERPaj3TiUOwU6P+hOxmLupT7SVt/1bGBVp0Jq1neMaqDLZCv2PH89OKGu+u4xBWVUD3U6dJJ989skLX45xomg3yIAhLFwjIrvE15r5CU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4611

HI Folks!

Trying to send down some vendor unique NVMe commands with io_uring and fixe=
d buffers via NVME_URING_CMD_IO.=20

I have no issues sending standard NVMe read/write requests, but we are work=
ing on some VU commands which have
buffer and length in different command payload offsets. So I'm trying to fi=
nd where io_uring populates the NVMe cmd=20
payload for a "write" (outbound) or "read" inbound request.=20

This percolates into drivers/nvme/host/ioctl.c: nvme_uring_cmd_io() as expe=
cted where io_uring_cmd points to the=20
expected cmd payload and a local struct nvme_command is created to be encod=
ed into a user request via=20
nvme_alloc_user_request() call.=20

Within the nvme_alloc_user_request() call nvme_init_request() is called whi=
ch performs a=20
memcpy(nvme_req(req)->cmd,cmd, sizeof(*cmd));  which is basically copying t=
he local=20
struct nvme_command to the request structure. The issue though is the buffe=
r and length=20
are not populated in the cmd payload at this time.=20

Instead this happens somewhere else at I/O processing time which I haven't =
found yet.=20
I'm trying to track that location down and was wondering if I'm on the righ=
t path here or not.=20
Any suggestions on where this update occurs would be incredibly useful. Als=
o we're hoping=20
to have multiple fixed buffers for a specific command specified within the =
cmd payload=20
In order to provide for extended key data on the commands. Essentially prov=
iding KV support=20
for store/retrieve of keys larger than what can fit in the command payload.=
=20

We're on a path to use fixed buffers and to be able to map them on demand f=
or the VU=20
commands, but inserting them into the command payload is the missing point =
at present.=20

Also are there any future plans to support VU commands within io_uring? Try=
ing to get the=20
infrastructure in place to allow that now. The long term goal would be to s=
upport a KV=20
command set effectively in io_uring, but in the meantime provide it via the=
 passthru capability.=20

Thanks!
Doug


Doug Coatney
Associate Technical Fellow
Data Center Solutions Engineering
=A0
MICROCHIP
408.888.0105 Mobile Phone
doug.coatney@microchip.com
=A0=A0
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0





