Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6B212E02E9
	for <lists+io-uring@lfdr.de>; Tue, 22 Dec 2020 00:29:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725782AbgLUX2w (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 21 Dec 2020 18:28:52 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:35735 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725780AbgLUX2v (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 21 Dec 2020 18:28:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1608593331; x=1640129331;
  h=from:to:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=3c0m+8LTeyI3ocV3w6MVX1TmoSbqKMYsJ2fcTtTDjUY=;
  b=ljdR1LO4yvH2DtFXe36Xw7sBfM/sM8eaCKaosRNU8FsT8CXT/FizOyuJ
   AW7Anc9nj5i1uswfEp2H338nZWrBcspGpeoQJ2nLg4g1qQRrKlkUXLD/M
   z0xrNoQPnyzUyXb1o4AXelTcae6u67I6RuhC2ZUfej69oUuqwY0HHHqDN
   7qWKToWiYCulxpjHQOOlwqZcFO85grnJ4fJNnEpn8KUIIu5tWhrEtlEQk
   xWkYVk2N2YvpxoLyzKB6wTxOakAFNPDwjevBZhP25wCtY0Rd9tLWR/crB
   jVxE9BZhiLx/2bLpKnOqSl7nHNMwmMy7Tvi6YZ6lO9sR58jlilFpyyhq4
   w==;
IronPort-SDR: GbPQBRDss9eUhwFdIOab2lI2gSfq7dEWGNDYHHPnQpeu/WvWpKhyc/QOS3KY0vnQl7HMDyWjmM
 JY3CWN57LE6k6AuIV8GleTNsCaLdEVWLQO4bufvbqVKK8o1Yg/W82EBVO2+qg2F4uW9Sh7BccL
 yH+2haG3ccxBYBF8EJ7Ae9vCgzs/bg2koLwI9vkpwbX6HtR5nzjyZyEE1YwxoAyTQx8irQKeFY
 qaem/VXswLbCjDeOyYzHqCZ1axPxo5ZgpFFvRkk6IMkp9jw1L45Yka3v7oF/JLM68RHCk+++A9
 kRE=
X-IronPort-AV: E=Sophos;i="5.78,437,1599494400"; 
   d="scan'208";a="265944630"
Received: from mail-bn8nam12lp2171.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.171])
  by ob1.hgst.iphmx.com with ESMTP; 22 Dec 2020 07:27:45 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jNYt8wrikg7YlAco7Xgr5pAiqB24G9TeoxI3+DCbicX7At45noe4iMqSYGzJXWO4O+s2F0fkqVmn9OYCJggDGL/YcA0z8fjj99bMjnsKEi82oLfhz3WpXBlCdrQQAP2zcSZ8LzcOIf4bVEAd9Kdi6WwXMQ/Fj8pvaJNjMGBZ6MZzAuGw62upTLPEYbcRFiEkwUrTHMtVyP84C9zn4a3W0JhvDGp+4CEW0GvHCeJUTcxIV77jHwyrJKz6vf+uu0QrspctdbXU/ndbnULL6XK+WZcFbbTBkhV5XjmBJclsBIbClfozT1yRCwAVPpUxvpmlccIK+dgBT4BSbyaJOOtc0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=znFBL1GAPH68+9spfvzgBaB/vD8j1G7vQXxEMF/TvQE=;
 b=MUpqQM5XgNBef6hl93x1z+JD56aicPydrV2aLRFW4H4R7Dhscp4yy1LczsUg7V3D62aRfkGSgy59G7ll8pAqxMSLvyt1B3bRmdOXVCYHY2rGsD3auDWFSUMoxPcOXk/p1Tx+VHeEqwI+/o/7ZjRTmaHBzd1y8gHZ+K2I2DRSlv2VuKR7mEXwDu5qGuxxHhWu5TDjFp41/6nbJAq3BtxjVYIewm5eCpewZBNzngpfEtFAfeiG9atccI4YW5x9OKCWcu37YTl3UzaXoMnTXlnMJrlofAB9O9iKnwfy2LzpwmJ/5DOzQ1SeV8/Y2UIsRD26EiECW6U5x9YnK+X5X/zE0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=znFBL1GAPH68+9spfvzgBaB/vD8j1G7vQXxEMF/TvQE=;
 b=axXds0zDQepFPIQQX2xJu2o+NtYScacQVgXxL8jtpu++6jFhwTOorUNqPpc3RFZRIWWeEzRMDuRq20F6zaZ/625tBbKJAsivmh9A4pfxVYHlHYzCNN7tj5KLHdMzG+cU9TLxsqbvFro9fkyB4BWtC+EHzyxQmkA8vKsH5g3MFCo=
Received: from BYAPR04MB4965.namprd04.prod.outlook.com (2603:10b6:a03:4d::25)
 by SJ0PR04MB7567.namprd04.prod.outlook.com (2603:10b6:a03:32d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.29; Mon, 21 Dec
 2020 23:27:43 +0000
Received: from BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::716c:4e0c:c6d1:298a]) by BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::716c:4e0c:c6d1:298a%7]) with mapi id 15.20.3676.033; Mon, 21 Dec 2020
 23:27:43 +0000
From:   Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
Subject: Re: [PATCH 1/2] io_uring: fix ignoring xa_store errors
Thread-Topic: [PATCH 1/2] io_uring: fix ignoring xa_store errors
Thread-Index: AQHW18i/RyX8piVwoEqmwmgD81wjdg==
Date:   Mon, 21 Dec 2020 23:27:43 +0000
Message-ID: <BYAPR04MB49652ED4F50AE907F923583486C00@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <cover.1608575562.git.asml.silence@gmail.com>
 <7ba58ef02c309cc19bca4f5832686fe6a049d868.1608575562.git.asml.silence@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f1697204-10d9-4233-23ff-08d8a6080450
x-ms-traffictypediagnostic: SJ0PR04MB7567:
x-microsoft-antispam-prvs: <SJ0PR04MB75678E99FC8B602391EEE4A586C00@SJ0PR04MB7567.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2150;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: crIsUqcpdCO/9yp9Yj3s3idY1YkS/HTBfOkME2iNVc2Az2lbjDm+Sgz+1qyX8NMryWe2nvK2IHNX7k1Anj9OuaB2+bheq3hDy+WynJvB6IwEZYUiZfTTUH7JwMukxKvFlCUFaInTFDzMTwCs/bqZqxYpdp7wYCKInYUwCkPO+UrHGnjAJhoBYpPKTieg5DPtJ0QHTmH64vArpyVXLZT+1xKle8E/8/bMze5eXJgJd6dFb1JKqSTnk3D+CILtS3D1hXdv0ViKHDwmlHUnKSkQTmWvoP12Xw1B3f7pI0HpJjCs1txC8pHytlXmpRk8Kzx0jWMZ9NcW8AT/t0JsWKWhGmxqVgTOqFTDaw90dDQa80/nmBtstP2qsOoycye7DxRpsqk6P6pv7JvdD9bjRwMIpg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR04MB4965.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(396003)(136003)(39860400002)(366004)(66946007)(9686003)(66556008)(55016002)(76116006)(64756008)(7696005)(66446008)(33656002)(2906002)(66476007)(110136005)(316002)(71200400001)(4744005)(53546011)(478600001)(186003)(52536014)(26005)(5660300002)(8936002)(86362001)(6506007)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?5iZ7XX/GQnMjxpFfRPYDqSM2CMrK8l0Z9qeM9psP3Unk6mTPDv52I7NhIc7l?=
 =?us-ascii?Q?M5NcTAL3irBFkgpFmJo0CChVFwsYLVF5fwBeRvIaxrbwHHeN8soskm5t2X9J?=
 =?us-ascii?Q?Yemqzsm4sUQnFsVI8HM6WC3jwE3zz3OBvvQJiJnPpaSSVn3OWpumP49QaIcW?=
 =?us-ascii?Q?0WW8qiHOjdA5qdIXbB1mXZPJvDHciIQ0uNvagY782liqNjCLjgz5BvXw98F0?=
 =?us-ascii?Q?ikPdvlsnT3mxK3/3Yz0PAwN3McE3ys/1pSc+bSifi76gqaudDzJRdTuh67Kk?=
 =?us-ascii?Q?m43dFfpnyVsrykytjj/Q6JW8Bk6DSMcd3SQE2QzsG4XxbQLe+KtgQgdL8uH7?=
 =?us-ascii?Q?15CFkF3zZrowYdOgP3aKgJ5ROsjrk4hy0gvzkR+BdQJQP26QFuUR1BDSA4CP?=
 =?us-ascii?Q?iKmNBt9JpzQXW/2qldParGz6C/vLQolq8vrYkWs1NIXs3JlSafWZP1mat4R5?=
 =?us-ascii?Q?nkry8mAdcTEBHHku8g6JYclXKaOouGKLtMWnP/U1kh63Y3bmu4kcSsd2VB/0?=
 =?us-ascii?Q?pMDQWmjcQCkUsm8HwM35MefjoYGdzirpC/+Ko8kFk1iPEt5ePH65nQRP/zam?=
 =?us-ascii?Q?dAOI+RWxmgy7eoIRwc/rGcn9Vz+C3feKldAtaE4YYFKaUYH+Ah9FOaiRl8XJ?=
 =?us-ascii?Q?RDQu0c3FTgGDjm6YAE/8j027RKgcUHKKp/Dr2ndS25rzBVy32S4ZD4Jmr6iw?=
 =?us-ascii?Q?75EPzrzIFFirjFXYX3DHOu0wJMspYfwmF3i6DkHij5bKf/qnEi83MMMHJNOh?=
 =?us-ascii?Q?8j1l2KC6jShX5Y7GpWIVtmj2Xg3KzPMmnXZPdqgH7H07rsOf63/UUQ0WJ51Y?=
 =?us-ascii?Q?MZOyLt6FFfBeyCqcAo7ocAShvEzn0j6tlGf6QzVBW5yDARMMQoH9bCQtBcnv?=
 =?us-ascii?Q?+IY2UdPst8QXtyiQTWzz9Fg2fXe5hmbzhW77G4h45wdRHp5VdTqXzZl1CEqL?=
 =?us-ascii?Q?G5WdMJ43TmuaAi9mgYcWzEnSvAvW/vKgyefYFh0aETH1fgIIDlMQWmNFxmi1?=
 =?us-ascii?Q?90Al?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR04MB4965.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1697204-10d9-4233-23ff-08d8a6080450
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Dec 2020 23:27:43.3576
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WNM+WH0k13HPw2nXhZn84OvDkavdfRoTZfuwRmYGLLL373XzVd2Mx3RMwZfOHXZ1QinNJ2npScNkuF3HOrHQyYj+7r6A0QdbTXtW2qeFFH8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7567
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/21/20 10:40, Pavel Begunkov wrote:=0A=
> @@ -8866,7 +8865,12 @@ static int io_uring_add_task_file(struct io_ring_c=
tx *ctx, struct file *file)=0A=
>  =0A=
>  		if (!old) {=0A=
>  			get_file(file);=0A=
> -			xa_store(&tctx->xa, (unsigned long)file, file, GFP_KERNEL);=0A=
> +			ret =3D xa_err(xa_store(&tctx->xa, (unsigned long)file,=0A=
> +						file, GFP_KERNEL));=0A=
> +			if (ret) {=0A=
> +				fput(file);=0A=
> +				return ret;=0A=
> +			}=0A=
>  		}=0A=
>  		tctx->last =3D file;=0A=
>  	}=0A=
Looks good.=0A=
=0A=
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>=0A=
=0A=
