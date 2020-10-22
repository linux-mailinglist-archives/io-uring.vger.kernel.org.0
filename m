Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97F06295B48
	for <lists+io-uring@lfdr.de>; Thu, 22 Oct 2020 11:03:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2509987AbgJVJDP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 22 Oct 2020 05:03:15 -0400
Received: from mail-eopbgr760084.outbound.protection.outlook.com ([40.107.76.84]:27009
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2509967AbgJVJDP (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Thu, 22 Oct 2020 05:03:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=windriversystems.onmicrosoft.com;
 s=selector2-windriversystems-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UcEetLjRJwcMa2Oai6uQyseA1fpbuyXj+lwEUzSGvJ4=;
 b=nXhvmgng2rnwzvOklSiVgedOt+CUvMAhPZjayZUN28g9H5gO1hNfFXd/WyTRmkZieirOZrH2XL6Bnon/Mtbg/HAew7PaJ2oOTTZJwGh2f7nhm5xSbY5q9QpxzwsJbbDBgdmvPwAzwjmdKwWfhrvC5PX97nrwW7Q1vPauh+Fm1Rs=
Received: from BYAPR11MB2632.namprd11.prod.outlook.com (2603:10b6:a02:c4::17)
 by BYAPR11MB2678.namprd11.prod.outlook.com (2603:10b6:a02:c1::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.28; Thu, 22 Oct
 2020 09:03:12 +0000
Received: from BYAPR11MB2632.namprd11.prod.outlook.com
 ([fe80::80e9:e002:eeff:4d05]) by BYAPR11MB2632.namprd11.prod.outlook.com
 ([fe80::80e9:e002:eeff:4d05%3]) with mapi id 15.20.3455.030; Thu, 22 Oct 2020
 09:03:12 +0000
From:   "Zhang, Qiang" <Qiang.Zhang@windriver.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Question on io-wq
Thread-Topic: Question on io-wq
Thread-Index: AQHWqFIprdH4K1i8TUuaHf90sKfvTA==
Date:   Thu, 22 Oct 2020 09:03:12 +0000
Message-ID: <a92e474ab41f4c40866eeb5bd78fe81fBYAPR11MB263250FAD0FBE598982C5E5BFF1D0@BYAPR11MB2632.namprd11.prod.outlook.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-clientproxiedby: HK2PR04CA0043.apcprd04.prod.outlook.com
 (2603:1096:202:14::11) To BYAPR11MB2632.namprd11.prod.outlook.com
 (2603:10b6:a02:c4::17)
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
x-originating-ip: [60.247.85.82]
x-ms-office365-filtering-correlation-id: 9e4bad73-c8be-4d1e-43e5-08d876694e0d
x-ms-traffictypediagnostic: BYAPR11MB2678:
x-ms-oob-tlc-oobclassifiers: OLM:8273;OLM:8273;
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB2632.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39850400004)(396003)(346002)(136003)(366004)(55016002)(8676002)(316002)(5660300002)(4744005)(478600001)(3480700007)(66476007)(66556008)(54906003)(6506007)(26005)(186003)(8936002)(86362001)(66946007)(64756008)(66446008)(2906002)(83380400001)(91956017)(9686003)(6862004)(76116006)(71200400001)(4326008)(7696005)(65966003)(43740500002);DIR:OUT;SFP:1101;
x-microsoft-antispam: BCL:0;
x-ms-exchange-antispam-messagedata: hANwrJ7JD55ei9pW+mJuc25/3FzP4SaT7wyvQpF71PsSLO6LFEjxi0jYoO9n3R+//+VEXO4UbtQahv7L5jdk1nRyvO0dyj75VgK0BzOQbdOHBpMRPCuUvXoNQhfBXz6F2UlTuM5oZWwXjhClT8mu7BXMOiPBJ4qrvGvGhIqfylbb4/S5NtwsHkF+pGS45FlIJDxPnFc6OX+fSxclefVDePSVpDxpvMGLDjhYLZz+tuJBAyK9qYRMAMOXYxJI8F/hs0OZBW/9lNK4LhQhtZr4297VqtIIe316c2mKBH316+EVCVh+Zr+XDYPC+7c+eMm1HX/eRWp2iYnFTFzjH/KfVYCX1s/ExOsHIyoH6EfTVrWyLbvbQf1XKYFHSRyqD4upZD+31u/yFccQguAJhJsm1R6pxvkktupwLEvAkggwJfGVmd/0b55gzxXCnslG0b2b6zmG3+vxgPOdw3EoigvZbpgTMfy1enhOXpliCnZBsfl0FMjlIkDC/NmOMAKMlLRaGYZZWq4WURBaDO9rWdpjKoG4Xn92QiP6ZvmL+bVkOP3+v+gNLlOxVuosewp4z/Ldqh+zLdu7LUCiZ3YmxF9MMnjtn1rvza1twy9GEjPPAXbLU399KE6nTAO0g5hr7PGzaBa6E9Bs+bEGXCQjivaU7A==
x-ms-exchange-crosstenant-network-message-id: 60611272-6a28-4648-e1f3-08d876692b3d
x-ms-exchange-crosstenant-originalarrivaltime: 22 Oct 2020 09:02:14.3823 (UTC)
x-ms-exchange-crosstenant-fromentityheader: Hosted
x-ms-exchange-crosstenant-id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
x-ms-exchange-crosstenant-mailboxtype: HOSTED
x-ms-exchange-crosstenant-userprincipalname: xC5uFoKdSRbCsJBnEGsxfyGVJ927Ty8RTIJFSzL4KKSYZ9LZsP/s+g2X7U1uy1VHfKMezpv9uTeluyfqh9TyySxIBsXMUf8oHm5UltHZALs=
x-ms-exchange-transport-crosstenantheadersstamped: BYAPR11MB2678
dkim-signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=windriversystems.onmicrosoft.com;
 s=selector2-windriversystems-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uk8pkplVnHuKZvsbWclz8S0909p2sLHVLhH81NFbJJI=;
 b=URuiOowBJyukzEgTtDaOPfyw8bdlSpu+wpy9Y6My+VdvE1xza10/5+Y71jcn8ebtuKdT2nycg3hpfoaUEfSWcumK28wuXqHWXH/uBTOhvPLos1z0WZwhR+pQaa3Pr+3LH9NpapRtxrrUn6xWx9RFWB1gr//nubAE7Nlx5HZ7PQg=
arc-seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WEOUn0u9JfE6tL0vCI3+6nG/ym+dkaw2RFS9c9WX8ybqIel0S9cFvudQWXHk6j42MfI8cyR6FmtVkjw+ylsWINC+UeO32cWekJbKt7WPpRsMmo+VFBurIcG8W/Opd8VUjkHwOArkg7Oh1XoRdvG+SUpWusVEzSbD6gBrhf9ZH5VTAfHgLTqY2IycUC/wL0nNhPDc0Bn2nVKt9oCMV28GPwsizWTlKavTW7kBITUWtbpBK2V60ebmNnmKFr3qmVcobvWJjnTqufdhW68wIuUbUl7N/fNTZmTV4Dmonr+oz59tUxjiDoGwNoPH2SHmHsK3uM1L0Shzitwv5ZToS1FwRQ==
arc-message-signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uk8pkplVnHuKZvsbWclz8S0909p2sLHVLhH81NFbJJI=;
 b=jB1Eb8IiZ9lXb572qh5cwMA0WpRYhLUL5nmM0I2yi1WF0gc+UwL3WJj0AU/EOF8Ad2Z9ExDAjyZihE88JOnpnNGWVvgNG9BBSnlUVjyE1pzXcXB7ZfKWbhgtAl1txkiHTbmrr78W/JCxz1bbL28yXRoKM9uHtbeguCx4EM4v4OjbpMGfar/836tNiGEVosp0CULNa3tCq2hHb6GIKO4Rg/H9X6RZI49T/Y1IoHornmy/03RwFOp+NWxFlLg8stGManpcbOYDbtNlRPHHjs5NJAjyL0zfAyQDO9qEXkwzOQd/HVIlVUUH49LwhYs6s7azVvWgdaN2G7EE3xmOtb/Gmg==
arc-authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
x-microsoft-antispam-prvs: <BYAPR11MB267893EBD79F809393E94EECFF1D0@BYAPR11MB2678.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: fmj4/SvqAAiBTTuyVCvROmFEuDep5/TAfx9bkhYTBK6T0cVBDRxWK33xUcMfzrBCM8/AfP5f/ioXw/F6Qix83deNnuTm6e+NeQxmXyhtToqf/jelrLgoIQ94afEpWEr9RE3j1lSYUMuXcyhFP6fZ118DUlpkd1tFTZ5bdFux2c3pqIRSfKd6l/8aXybo0a14Jr08btSYLqJV4hFmfq5np3pl6MXCJFTdDAn+DkxJbXY0P/1KiJpNg5VMDvbDvOjnvDSe0KA8jFCKvwFh2UBM7tgiYCRQ9M8IkCyKIAH/706UcKKGDcB+niuFaZlTBW4q7H3jV/meB0+zLZtgJJ1Nc09hR6XtGyJYobNkuIYOWK/VGouLlGBLVtJSzfWcQp4jtR85Mg6gCJZUY/h/zsHoGA==
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-crosstenant-authsource: BYAPR11MB2632.namprd11.prod.outlook.com
x-ms-exchange-crosstenant-authas: Internal
x-ms-office365-filtering-correlation-id-prvs: 60611272-6a28-4648-e1f3-08d876692b3d
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="gb2312"
Content-ID: <C2D28A443B08454CA10043C8BBDA19B2@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB2632.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e4bad73-c8be-4d1e-43e5-08d876694e0d
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Oct 2020 09:03:12.4781
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lLDRqOk6wnyBCpaTtJOZMTI+m8oA0wztU7x2p5MTp77zTktVQTEyuo+ZpwFe971QCY8/AGH7aUctQxscNu0WPGT8HKZP5r10W+fOHMz7SmI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2678
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

CkhpIEplbnMgQXhib2UKClRoZXJlIGFyZSBzb21lIHByb2JsZW0gaW4gJ2lvX3dxZV93b3JrZXIn
IHRocmVhZCwgd2hlbiB0aGUgCidpb193cWVfd29ya2VyJyBiZSBjcmVhdGUgYW5kICBTZXR0aW5n
IHRoZSBhZmZpbml0eSBvZiBDUFVzIGluIE5VTUEgCm5vZGVzLCBkdWUgdG8gQ1BVIGhvdHBsdWcs
IFdoZW4gdGhlIGxhc3QgQ1BVIGdvaW5nIGRvd24sIHRoZSAKJ2lvX3dxZV93b3JrZXInIHRocmVh
ZCB3aWxsIHJ1biBhbnl3aGVyZS4gd2hlbiB0aGUgQ1BVIGluIHRoZSBub2RlIGdvZXMgCm9ubGlu
ZSBhZ2Fpbiwgd2Ugc2hvdWxkIHJlc3RvcmUgdGhlaXIgY3B1IGJpbmRpbmdzPwoKVGhhbmtzClFp
YW5nCgo=
