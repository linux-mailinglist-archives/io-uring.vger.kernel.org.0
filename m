Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49DEB32C5A7
	for <lists+io-uring@lfdr.de>; Thu,  4 Mar 2021 02:00:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359438AbhCDAYA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 3 Mar 2021 19:24:00 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:18205 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1839535AbhCCIE4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 3 Mar 2021 03:04:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1614758694; x=1646294694;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=KtNX4zQxYBes9VR9MMxq/a7vCn2DDEDYHlrWJ8n381Q=;
  b=Zd5tgFMBXMPSRYGVCD8wlgCc7aEMSqyeCHpIfil0MpXvETGKadDO+VuJ
   PaV4L6vIi5642SV//iFOvpjod/rF9aESPg4p5N1V7M5sd/tZDQusLDJsa
   snlCMr2ARl+7WL5Hp0KBlTVTj/UDLjrSaCX5CJ4fFkTTv/VklUKI31iEf
   fPU9OX2uzaWClJdT3kiglf+x4LKn3QhBsNSoEFySiP0JUE5+1y1ORYotJ
   b04wHg/sDfiZsVv7itFtXaga9Hpo8nNLM+cQzvTTWGxLbNzYF1jU1fDTd
   Ci1eYml5iKLEIT1AxoBdy2w6arfRirCzuHi7xcsbEQ3NplSdTbfof6/wv
   A==;
IronPort-SDR: HMOhM1N+kzQrtV0pbcMGeGE4HbHWPSQ8RGqA3LeCeUBGAbflBTtWGWfJJ43CHxnX3HC/iGNCAZ
 Id/I1phC60Y29yXMyMLkvWBQJtCMNk9HbmQgdPB8Ra15b5IJ4EzU/vukYnV0XfZk/461fBgwQ1
 ZZoIjDHzUrgvHZf7K4i6goiJ6qTb4GIF00Cl6gPajXK2rCjQMo7RVAZTLpH+s05Ei2xYLPONXc
 TReahe4PXEfWuRyt7liZvHn1GMgjixVuehYaPXVfmx5jcJ/0C1zswWsO9A58zFD4mrMdjQRVz1
 0bw=
X-IronPort-AV: E=Sophos;i="5.81,219,1610380800"; 
   d="scan'208";a="165713554"
Received: from mail-bn8nam12lp2170.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.170])
  by ob1.hgst.iphmx.com with ESMTP; 03 Mar 2021 15:37:42 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MpYoJjjSOECVS3TeC05HvIZKC9S10MeA4plmkWWltp35Gw1UV2AVIpkUJhIGXwE/PoYzazNs3vylBZIKxxstG1m78N2WoYQ4fWUi4mLjeu08mkjo5X/k9a9Je3ei48/1fRDGI3tMPf48whFMS40H13W0U8ppTnf4704hUgZJAVgcfY8nnpndrJaAlx0Ick9VSsG3yPdB4zwO3MjINWa0Q+fiqUezlacN9eIgz6SJAlLMJhUfpIeWCaD7llJIQfTzy8RJuiW2WiOewn9mQ9QJAJtVg2TDCyeSPW4WQAV500Rcqr7qSbqC2Cgr6g83kvpExQAkheCIgluD6hCymLNwZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1va4IOhXonFcEGmj7w2egSFXwWVUbcGqOus5axpYVNA=;
 b=lP0JVxuZPtDsJlNWzKTgTAqtj6czAik2s3aAZogzrsLnryDAM48XJceE7L6FtXDup6Js43kDqWFFirVzdX31jOG27Pqr32T1HeX2kxm5Llal6bLeH1axcxPTwsApB6yUHNEbrMF5VzSJ+XmcIFx22ZrG7bfekxFsat9OH+NLE9BP/YrpI9fs9BiADi6ocC3Mg71h55fnZAhubUBIwQZ81qi4xgJ/Hx63SEMyYV7bBE/9oqGMQzVHiKfY6DCypb6HKsOp+9l0vUFWAz2XhjZ9f5xw3iYx1hOhdkHMNfmNW07MsQF4pocfJPr/STSwLsTXV7bubDY3FdKge3ksP2fg6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1va4IOhXonFcEGmj7w2egSFXwWVUbcGqOus5axpYVNA=;
 b=bLAvy8fqWFeMWpSr6S5jg3ScN7bRBswkblV1fWapVDIEeCz4Jbv43QC2BJ1Uvk14v8ijtPNSvC7ASUpL/2ds9zBSzZ1LTGy86JjFpMasP+KuyTnMQ/k8CO49n1aF0qAcv6I9PNVt9e8aF2X+BONdCHlAXrIyd8AH3KCGJtS9zR4=
Received: from BYAPR04MB4965.namprd04.prod.outlook.com (2603:10b6:a03:4d::25)
 by BYAPR04MB4870.namprd04.prod.outlook.com (2603:10b6:a03:4a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17; Wed, 3 Mar
 2021 07:37:41 +0000
Received: from BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::c897:a1f8:197a:706b]) by BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::c897:a1f8:197a:706b%5]) with mapi id 15.20.3890.029; Wed, 3 Mar 2021
 07:37:41 +0000
From:   Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To:     Kanchan Joshi <joshi.k@samsung.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>, "hch@lst.de" <hch@lst.de>,
        "kbusch@kernel.org" <kbusch@kernel.org>
CC:     "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "anuj20.g@samsung.com" <anuj20.g@samsung.com>,
        "javier.gonz@samsung.com" <javier.gonz@samsung.com>
Subject: Re: [RFC 3/3] nvme: wire up support for async passthrough
Thread-Topic: [RFC 3/3] nvme: wire up support for async passthrough
Thread-Index: AQHXD/4Dj/1BYoXHfUas1RoZk+MM2w==
Date:   Wed, 3 Mar 2021 07:37:41 +0000
Message-ID: <BYAPR04MB496576429799E7E0C29ED6CB86989@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <20210302160734.99610-1-joshi.k@samsung.com>
 <CGME20210302161010epcas5p4da13d3f866ff4ed45c04fb82929d1c83@epcas5p4.samsung.com>
 <20210302160734.99610-4-joshi.k@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: db8073f1-525a-4809-8104-08d8de173a52
x-ms-traffictypediagnostic: BYAPR04MB4870:
x-microsoft-antispam-prvs: <BYAPR04MB487030E9CBD8DF936C365E0C86989@BYAPR04MB4870.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nK1v8u4bC1xDm/Qv7RuS2omXJaP4dMKgwsiyz7W9WOg+FVhA1KU5iabCnwfsCRGneS/slcVgcbDSelPoKpeFh0seIbk7mdBg4XxVDjjpDNIWDJEdOeZGhUQ+GwCfl+A1HnJBPa7s4ikX1A8ePdAvNkdKcHXAXqWwC6tFbehshd0HjdmoyFUPEnPtMkMoCdRJO4W136LHkzZLmm3D0ZPkJOhD24Yk6YIquILr1GrvvTzZtVvQRwZF/Mdhkg83fHOsWoXIigl4enKrkc4mAUzsVJ8oenXE4zoE/yZ1FgKlsel8wnISb/n8zoDNVyukSA0KEulzGNCsBLI+zy7H49EG2hX3OgkrxBP7/u9qsSUaEHZNMU/J7hehBH4UudvPP/qC5ELuZeTKGfKsdg7NH3beEMWyc4N2lPnjACOjzSFrPIfdeTCOG288zqUPdZm5K/LmpyR2H+9XYodDfWCzZNxJ+/0y6GjDHHv8HgTG+New6t5893U6EH1f5mYNn/AUf9leBJLVHKnidUs+pakpdR1UMw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR04MB4965.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(136003)(39860400002)(376002)(366004)(5660300002)(4326008)(66556008)(66476007)(66946007)(66446008)(8936002)(83380400001)(33656002)(64756008)(4744005)(478600001)(2906002)(186003)(26005)(86362001)(71200400001)(54906003)(6506007)(7696005)(8676002)(53546011)(9686003)(316002)(52536014)(55016002)(76116006)(110136005)(91956017);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?K8UZatwJBHRlvt6Vnu6MZQrgCoDTaFAHG6JmLNOPEZ5Jr8weEcvRcVBzIYbQ?=
 =?us-ascii?Q?Ck+tGk8Ofi8FF9yoj/M0Wfk7j5HdVCndtWXVlB2GwR0Sw/uqccYXGM3EbJkI?=
 =?us-ascii?Q?x6RfevIqVazJauQMsEM0DdXuPObszqdJMyfO5xR2eIv/FJuZZhPbwjxkYZ39?=
 =?us-ascii?Q?brILr6qIbwS6yOvq8H7E7mkMYVSP5iA3cSxXte+fG+8QcEdyTDJ3/fHs4CVU?=
 =?us-ascii?Q?JoDfjwXLKwNQo2nYGgxFeSP4qAbKPK1bqXamRHraahIDx6W2G3xuiqhyJjMr?=
 =?us-ascii?Q?unnRlCtAwnYIAWWa4bRQgJUAXd1MLHK/3IHFc4FumZMgef9FOi0jelGqCoOS?=
 =?us-ascii?Q?+ab22BO3MmLgPum2+Yn8wmbIvdqYDh2MIK2JY5hD6l22LfbMu2v7Uj6lqbCZ?=
 =?us-ascii?Q?Xn1zr9bSWa6+YdaHMz4H8Fem1Y5dAokOp1rqUpsKCRKwhAKROLaCtm5qIZkR?=
 =?us-ascii?Q?s0jSRk/pzkiW2fg4iNZu8XxmQLIKEgYQc95DvTRgd9HQuCMSK0eLve+dXzN+?=
 =?us-ascii?Q?sQYBgJuZAqs5c+7YbFVch8wHwrt2FRmUMdBJXEg0+nOAjO03XDem7kZwCafM?=
 =?us-ascii?Q?0IJarYLVsRRQeXuCZ0hW03VOeRrdP7kRTVMQr6xy0mZfS8bY+IMpcBL8vJcb?=
 =?us-ascii?Q?o7pWwnofMd9ID5qWD6IZTaBe+EejJM012uxASKi3CwoKK0tEiqOKTdm4NYDs?=
 =?us-ascii?Q?xNANZ/W25eub+3t5ep7wusQIvKyNKXFIqR88oZaJN9tOEm3uBSUYfd/yNLzr?=
 =?us-ascii?Q?hRsZANv+mU7cMfXGadPxSY3lzCScaeeqsjJqs4OmKGXOm90H0oXiujtbSSVF?=
 =?us-ascii?Q?okPmCsbUCsO4ZzLotWiBGq7kSIqD6SPlgNl6g99XmttJnyRVRHLnfEe27lo4?=
 =?us-ascii?Q?36yZrtEEK8lfB3R1yC/vJq4FDTTfOLLeRmxCw2o7wz4ODMoFR+X/GkzYHREr?=
 =?us-ascii?Q?z31muA2paQORCg/jsoIb5/5V6nz/pB0XK/GZFFQnI+biZm1ljQonZzFLpXdx?=
 =?us-ascii?Q?ha0EeYUGIqqrvsEQwjjr4rwkOSDzWDDI8meE+KFVFfqWMocMeE5a2GG55fPj?=
 =?us-ascii?Q?rpqbcu9s5MZEzaCDDyeo1R8sXIlt5T6vgT+vW5pYDnK66JH2hIjv1f4DYePp?=
 =?us-ascii?Q?djkjwJ1slMQUS4ljtZ+K9PbPc2d+zvUGL8nENpE3xMnfrPNIL2RlGpmRyxKM?=
 =?us-ascii?Q?jP5k6r4gBt1+jvjEpcrKOb7EQd4MF+BAKxINVvhFYOtoXe70VAz3ki5koNJL?=
 =?us-ascii?Q?JijrhIBYDqOp8G0szk6t3ZZ12VzS1Bad1tHcL8KaV7mNmqo6dmOZGvxaV7yd?=
 =?us-ascii?Q?5jMzExwPkji5nUXhbmcUYQuP?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR04MB4965.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db8073f1-525a-4809-8104-08d8de173a52
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Mar 2021 07:37:41.5365
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: E++vM27AXCiR3qdZr0ECkwj5mAaw3Dohnb5Er8zHTtryX+DsFdrkmvQVX+1ueW7duphWLsyGvsrJ/JhH9EunL8U5X9drRAx0wW+e9q2lst8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB4870
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/2/21 23:22, Kanchan Joshi wrote:=0A=
> +/*=0A=
> + * Convert integer values from ioctl structures to user pointers, silent=
ly=0A=
> + * ignoring the upper bits in the compat case to match behaviour of 32-b=
it=0A=
> + * kernels.=0A=
> + */=0A=
> +static void __user *nvme_to_user_ptr(uintptr_t ptrval)=0A=
> +{=0A=
> +	if (in_compat_syscall())=0A=
> +		ptrval =3D (compat_uptr_t)ptrval;=0A=
> +	return (void __user *)ptrval;=0A=
> +}=0A=
> +/*=0A=
=0A=
Newline is missing from before above comment.=0A=
=0A=
> + * This is carved within the block_uring_cmd, to avoid dynamic allocatio=
n.=0A=
> + * Care should be taken not to grow this beyond what is available.=0A=
> + */=0A=
=0A=
