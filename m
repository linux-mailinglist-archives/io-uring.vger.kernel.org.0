Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 522131A0159
	for <lists+io-uring@lfdr.de>; Tue,  7 Apr 2020 00:59:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726277AbgDFW7V (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 6 Apr 2020 18:59:21 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:8727 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726230AbgDFW7V (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 6 Apr 2020 18:59:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1586213961; x=1617749961;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=olkP+6a0wdniulgdKQVNWlqZKShXXYnuE9HbN9dRYNU=;
  b=NQprIZDoAyFoNl15Nvhfvmro3vMoSxXuIwefns6ml1Xc2ZmCBcY4RF8i
   p51BR2olr9hBuapJGFVztQVnEDFfyQima5X8onQHjk2/wULMkmh+dD29g
   p1bnd3ZhZUefQSxpp84V4MpPOuwGgEs3MBqdj9RdvyqEbcc6WMYWtoqtJ
   bPJ2L/KrTyHKV26De95iwokx1JdFvLPzo+eep38twwos3bFGkWx1JoCn9
   LF7k56A5tonhoqzH+4bw7QidojTmSJ4miX3CU4y6wdTUyuyWJjTAFh5Oz
   PX0bp5qOqVzYwbaxyCCCv3EqyG9hU28STANjMvy1bbcYjAWyhYx4L19jc
   g==;
IronPort-SDR: 1nMviI9IHFC6scJnr8Gz+kw73tKTNZ1Y9Ht/WnfPmGimHC9+/cNmDGA3ta0pKPoK/dN+JY0cgX
 f5EIMHEMvw+NWa8RNPWLY0Avtqxi4Kx1eWyUkP3Os3qk7VEvCSDDGfmhq1EFbwALTQsPg/K+nh
 YR6BKPnOAJMC2ZP0ZEFbWJWPVAM2UeouTUC424gGjKcifS8zNEOCtAXfjFbdVU8otcWDbwMOxi
 h9KLyI0QUBO8MmqvuuzGNPyv1aqOxjvZB7t/Qv08BPX5YIFmbxaG3WLCW71HJHxag4QizBx2EV
 Pkw=
X-IronPort-AV: E=Sophos;i="5.72,352,1580745600"; 
   d="scan'208";a="136173732"
Received: from mail-cys01nam02lp2058.outbound.protection.outlook.com (HELO NAM02-CY1-obe.outbound.protection.outlook.com) ([104.47.37.58])
  by ob1.hgst.iphmx.com with ESMTP; 07 Apr 2020 06:59:20 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YNzW/vjM5IWV1Zd9Pv9/25//1FeHT7IltSkiIvaZe4mGfmt3rO6uz8YZaudhn4zM1rKpK5zgIg9EurUmVC5el6As0DOc1qJga0/bi95VmrrX18Gk0VDFoay/SgGZXTiAOd2Fb4dl1XRZkC8b6XumRndqsZLlXv9K5PCHDbyaAqtdCl4eQiNGEyv/kLclVy+s2/FxuUHb3KPz6wQAInXago/oULnhayoE1gUhbe+1r2OSCDSRCM/zjRR2Pv28AiWDFYme11aBa85c6nq1R0dTEzMHcKK8W6ROhq92Ck+wkwHWrLrXQ6s0SS7UYT3FMdPgJLLrQKJ6uE2vdwTgCtFOdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=olkP+6a0wdniulgdKQVNWlqZKShXXYnuE9HbN9dRYNU=;
 b=DzvCnOjnFzUjmyniMVPHoOiSHOZCLVpv3lf45Ad1bO18u9q6+qZ4yUia3NwvobKHDH5o5uHJSGJOZAa+MWe5i0FcjRdbyzEdQ2T5Y4RV8v+E/BYzxh45z6zyrjPCUGpgC30WSlLFCHZlgVeBvmBzZnt5j/Hh0m8SH/uUktC1LKDtbcEcAGRVzsfQpKnk2Xz85bj24iUjCVMMrJXMtVw/R/28eU7TKCVeSYyXIhigMPLVbyQjjMikIJOCyc79llMDwRpvBBMmnpzodia2FPNZ7tsw3lyV+m6dlbj9FRt2DU21dPOrXcaeLQbyQSX8SbzMSGTErWD7xcg6sPNx9xvjOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=olkP+6a0wdniulgdKQVNWlqZKShXXYnuE9HbN9dRYNU=;
 b=HTmHTArhqNn+6Z5ZVZclj9weGN7htuIqtQjQK1e+F2FSLWTNIitMbdM5DUMeq65+XziDoWN/wcFAodDoyv+7Q/IN7qjpH9QgQSxZXUFqGU6AM8iG8Kojmtv/BPXtkFI9ocqfdMbaG30PuiN7KPOeCBgNb+Nsd1GM5tX4Kzv80dQ=
Received: from BYAPR04MB4965.namprd04.prod.outlook.com (2603:10b6:a03:4d::25)
 by BYAPR04MB5335.namprd04.prod.outlook.com (2603:10b6:a03:ca::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.20; Mon, 6 Apr
 2020 22:59:18 +0000
Received: from BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::d826:82b2:764f:9733]) by BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::d826:82b2:764f:9733%7]) with mapi id 15.20.2878.018; Mon, 6 Apr 2020
 22:59:18 +0000
From:   Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To:     Colin King <colin.king@canonical.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
CC:     "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] io_uring: remove redundant variable pointer nxt and
 io_wq_assign_next call
Thread-Topic: [PATCH] io_uring: remove redundant variable pointer nxt and
 io_wq_assign_next call
Thread-Index: AQHWDGZeKYMyN+Xeh0S7OVpfwOQ1+w==
Date:   Mon, 6 Apr 2020 22:59:18 +0000
Message-ID: <BYAPR04MB4965E6F6CCDA94AAD2EA1DDB86C20@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <20200406225439.654486-1-colin.king@canonical.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chaitanya.Kulkarni@wdc.com; 
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 054947ca-656a-4494-289b-08d7da7e22ed
x-ms-traffictypediagnostic: BYAPR04MB5335:
x-microsoft-antispam-prvs: <BYAPR04MB533556BDB3378FF621BFD2E486C20@BYAPR04MB5335.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:175;
x-forefront-prvs: 0365C0E14B
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR04MB4965.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(4636009)(366004)(376002)(136003)(39850400004)(396003)(346002)(26005)(7696005)(4744005)(186003)(52536014)(9686003)(55016002)(5660300002)(66476007)(8936002)(71200400001)(6506007)(81156014)(8676002)(53546011)(64756008)(478600001)(66446008)(81166006)(86362001)(66556008)(110136005)(33656002)(2906002)(4326008)(316002)(54906003)(76116006)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NwXgbykESUfWruQJ0mdN2Ew8M4io2d7ymFs7sAwAy1uDaIljXD9ZR8Y/78V/eG37fk3eKb4hEtAtOEQHgw2UhER7tu3tkDYusP2jmUcpER2xXsoWbbyCSnYGSqH7UdgZAy54b/ESWXu+23qblJRmEDZoc75azoAuOKBxIEUUPi07zl3gtRE8HmAXOnnicVcy0U4QqUoe8nvqzdRt/6XcG44Nt+cHoT3jXykfx8psr8rHFFqrbKHWxyMgxKu7NuLB05VKj9K5U93sfpotfuUjp3rmJ1qIn/ZF3wu8+HEG5pmcopkKiDUAAgQ19/y1PEyd+5kJWIerjtcSiupisv4MVoNdOnn04oFbo2aA+O6pNBtjlJMghpXobOoEARvSLcscZ0Vf7Gb5+c22wvS+YRs2F9WG0vkIK/4JezWD/tS9Irgs9ABfoUPE4S0xZe4z9FsH
x-ms-exchange-antispam-messagedata: UzjD2XTMSfwnhGpbBzzpk0zxILOxLLZdKTWypJH2xQboa4eiGdEQuFkZT4X7mYg0OAbLP9DjU+eqaaRpKmdA4DygLY8orpS2PM+XI40tZrjKXXgj7FBfHBdrj7JF1JMVTMQu9qfrJxG8o876/vjnTA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 054947ca-656a-4494-289b-08d7da7e22ed
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Apr 2020 22:59:18.1917
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QCcXwD2XCHfV5hnrCCiduJ7xBizfX+Epvl/pB4GsD/e8qCrUu/DLWIXns/auo+WG4K3Toc9MWR0aZP1fra9lYpxgfEHEVX2B6/P7qqqhytM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB5335
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 04/06/2020 03:54 PM, Colin King wrote:=0A=
> From: Colin Ian King<colin.king@canonical.com>=0A=
>=0A=
> An earlier commit "io_uring: remove @nxt from handlers" removed the=0A=
> setting of pointer nxt and now it is always null, hence the non-null=0A=
> check and call to io_wq_assign_next is redundant and can be removed.=0A=
>=0A=
> Addresses-Coverity: ("'Constant' variable guard")=0A=
> Signed-off-by: Colin Ian King<colin.king@canonical.com>=0A=
=0A=
Looks good.=0A=
=0A=
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>=0A=
