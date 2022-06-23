Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E71F05572F2
	for <lists+io-uring@lfdr.de>; Thu, 23 Jun 2022 08:18:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229451AbiFWGSE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 23 Jun 2022 02:18:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiFWGRt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 23 Jun 2022 02:17:49 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3240B3206B
        for <io-uring@vger.kernel.org>; Wed, 22 Jun 2022 23:17:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655965069; x=1687501069;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=9FH+n3c2wgyP6Enr4Ve2KIowUxKuYFbGhR0Fjx0OfLU=;
  b=hm/Jej9BqcKEsBtvZwbY1N8AQr/H7au1P0y5P0L/ZdzyHCFMU/Vs4mqL
   5pE7OJVHconS+xUXgZQXRr4uvtDZnbfCq0wOJJU7j1kHYwbkVpedTsPwd
   OgI2PWGl0oUaHWnXpaS/8kHCONgWCor6K01GjxlVJq4Xv5TsOwDw0/lWM
   e8i71MbVEDsV1mhqQMhfC/5hNIoJdkPe2/0pbtJv8NjpUGDvz6i6TvF0a
   JRwtS1JHvKc2lTf9FGxAVH9DAL1NL3CzIglkeOrBRnvbRtJwNyNyieatF
   Gzhd2yu/JQnpgIu/pL+btniFoNy3uaDM3U4s0AvxXsx2Z+WqGSUvSLeRT
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10386"; a="344626951"
X-IronPort-AV: E=Sophos;i="5.92,215,1650956400"; 
   d="scan'208";a="344626951"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2022 23:17:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,215,1650956400"; 
   d="scan'208";a="715705943"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by orsmga004.jf.intel.com with ESMTP; 22 Jun 2022 23:17:48 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 22 Jun 2022 23:17:48 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Wed, 22 Jun 2022 23:17:48 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.176)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Wed, 22 Jun 2022 23:17:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RDc+tC8wbdZMW+3V4OB2lJVHd+IM6LOSyjWTlpoQGNGVQVBVZ9iq83WRkAyu80TErRnpQAYn2qoVIss0D64tleQ7Pfqmdgy1ASutocxA6CJiT3gUBlEOsr7HDupr3S2gfF0HvEMu3gpHQYI5/ZJBwZs3YDNxUc5WL3wQ+JGuJ5t7KAHlfRl48iNLT7i/oGrNvJTdo+sjomWKtCMYbTxOuRZEwHZL69rDn2LBXeAl3qLKtrcE5eR+i/lhlp8YmQSwmFM+1zER5jIsLeWRamFAOn2CiI7Kwf/JA1lsQxGdVx7anzF/HT/EaSGW8DGASDi9uWqXDpoj6kKZQvY9WMY+Mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9FH+n3c2wgyP6Enr4Ve2KIowUxKuYFbGhR0Fjx0OfLU=;
 b=by9FafVcycwOkDhxm5GbhK7jL7DqXJ2+uvuMAlAZv7JHNVwP1da3lPGpGN5iqOvnkbe4EFRjSuSEvP/Hpxeh623BjuMky/C2ULRlUR0/ju10kBl4DCf7aAIK/eV6SlR7D6NXmBsIicUS3Qsxbh8RWYVt/97ZK78RrjxjBdpwz4D/oxogvkNh69Uf+SLFzNTjhFj5nG9y0lobv5KShQpIYgVOevHcLCI55A/939yk/4aI/IQQU3/E9cek5PGbgIqUVyIQJyAvwa7O1fiASCZGCjWDiwUSR9dG2QNqaBPEUqtu3Hdml0EWVOahqlvbFx/zr0pug4SNG3g/msAtjSUXeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BY5PR11MB3990.namprd11.prod.outlook.com (2603:10b6:a03:18d::31)
 by BY5PR11MB4211.namprd11.prod.outlook.com (2603:10b6:a03:1ba::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.18; Thu, 23 Jun
 2022 06:17:45 +0000
Received: from BY5PR11MB3990.namprd11.prod.outlook.com
 ([fe80::9d63:d704:2969:59d5]) by BY5PR11MB3990.namprd11.prod.outlook.com
 ([fe80::9d63:d704:2969:59d5%4]) with mapi id 15.20.5353.022; Thu, 23 Jun 2022
 06:17:39 +0000
From:   "Fang, Wilson" <wilson.fang@intel.com>
To:     "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
CC:     Jens Axboe <axboe@kernel.dk>
Subject: dma_buf support with io_uring
Thread-Topic: dma_buf support with io_uring
Thread-Index: AdiGxAx+I+R0cj8qSdyfvtX+0f5bpwABLJlQ
Date:   Thu, 23 Jun 2022 06:17:39 +0000
Message-ID: <BY5PR11MB399055971B9A3902CC3A3121EFB59@BY5PR11MB3990.namprd11.prod.outlook.com>
References: <BY5PR11MB399005DAD1BB172B7A42586AEFB59@BY5PR11MB3990.namprd11.prod.outlook.com>
In-Reply-To: <BY5PR11MB399005DAD1BB172B7A42586AEFB59@BY5PR11MB3990.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 953f99fe-2361-4805-a974-08da54e01304
x-ms-traffictypediagnostic: BY5PR11MB4211:EE_
x-microsoft-antispam-prvs: <BY5PR11MB4211B57B4B7D66649AD9C554EFB59@BY5PR11MB4211.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zh0b3XS3aEnv54lQPgfzgbQOir+sIiFYhd6EMP3WD3dK+2cZNvfheRp5ZkSX8Bxu+8c/FsobRJRAQnQkRsHfQ8gwD+4MHoanxMuS0pORaXbYCn1AdUui5jFBzU1LDrLjH5jpad7nndHTdkJlYHW5jWE/nbBiezrQjo4sfo57QDVoYytjUdybNtxltxICOYSJiOuJ/X60a7SMYEVfEfswdvASqm2mUEIyjZioLlwCnxCuPUX8P38pE+d8mxjadLLhWGGOmC7Zi8/tnnwqRbbam5fJ9VlRpUgLqt+nvD8dFlx5HkaYWCecCs1eWOQFwtsdRnI3JYo3oxLV2RQaqZx1KiAtJDOAAJbk/4BQ1zgTexzpc2LAvRmuO/Nt1qxySBA4Ltj9ZdyY6JDHaGFAV+pGT1Uy3Uphok28PfBcQtNHY594tFEWn+5vohtnmrjSPYXmE88ch3U+rJauz6ng9l1WltB5HQRcB5yoFmFu34ryvQQVxjR8dnqD5qC7cHSGXD20FGyPXbGx7Pg94MtP/bmuMgMxRrdjZYryR1IarLttoWwtNJBAJT7KQnA38GHssqWSBNa7XQhCYqBsbT3ta4hxHpVuITLUayXNgtMtsF/5gUhNk7G5KeB3hrKsd0SSoDe3xfvnTzcMH+uvNPEC7dQcwXYRbG+TUdkhuKQ40MOyG6yrhc6oKlFc2z2n+5VqJa/MxWaTJ57A7FeilEzmE4uGP8QdqyzU8VMb4lc35/W9KdbnP2taz33QNDecDa8UI4zz92Ngk1yPF5IuO+dOy2V4dA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB3990.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(346002)(39860400002)(396003)(366004)(376002)(26005)(9686003)(2940100002)(2906002)(66556008)(38070700005)(7696005)(8676002)(316002)(6916009)(86362001)(6506007)(66446008)(4326008)(76116006)(66476007)(82960400001)(66946007)(478600001)(5660300002)(64756008)(33656002)(55016003)(71200400001)(8936002)(186003)(41300700001)(83380400001)(122000001)(38100700002)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: RJuvxgGlcHM8wnHcV5e/cLVlwcw/tPzlR78fk1JmklRkdxeHjYFBeKFeCho5qU+rjc8yiLOTVFclFu6woAfLS03Gkv5y40CXbxhQ4UdPMXLUBRJcvPBzrRQn0nm2hFuEtG8gMrTf2G87li7DmFUE3OVlExZIVNEuTdR5kV0uDOn2KydLYtaSuh4h3eLbWcxqCrBCOq97PwNQG7vxlR1fcXjgy5QLNr10n6V/wM1c449CnquJWsgKikyEbJhqUXbZ27sJK1tfb4RkNDFQjfSaFcCzpd/i4MI+ZDRxHk62nrOGNEZQOusoV7wOjxyrGvzW92oTmxo619c964RoJn9yAN2Dy96Fg+POqj2L2K7D58jeahD88sQYmUdOvB5q50+e7Ny2MYZz+2q5tltekr4aeCz4hsSST0EVQb5Pfmp5doHMZybW/fL+1PQRCHb9GotV2oZoUh3SeKqP6bQsOXsA1DqcthsAe2JcEZZ7VGYrWl/PkUSgJCPeZNlCcLRwaUYy+xunUL4Nyxkj2DcEyhrXJ35uhTH6+feAW3ME0IBbJCt/sZJfhEVxiZw6IbpEKuSca9BBEMxuQs4NyUbpWIWcEcS3LffXP7tXm+lD/S87h/h9q4vbMih9q+BlvFrc+qNI4QRJ63LbMfUpnArk3zEYPAbhwhohAboLg68tElm7Ab/MnxUrncKosHpRzbr6ZdLj2UbZhzHls2O18UHHyc5I7au/unFaihXIkQMBa+e5/xOiSgJsXoYyYxz5vbzQyfDwB66xXGpbn/WnUGawrWlwvA==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB3990.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 953f99fe-2361-4805-a974-08da54e01304
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jun 2022 06:17:39.4514
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /5jtbOyXPUC48hC9yxLTylT2gfAlAjjb7lyA47FHECzCbu4Z+Qdekjq4v0CWPtQv+T30gZ9fdzWQ4JCX4gNr5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB4211
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Jens,

We are exploring a kernel native mechanism to support peer to peer data tra=
nsfer between a NVMe SSD and another device supporting dma_buf, connected o=
n the same PCIe root complex.
NVMe SSD DMA engine requires physical memory address and there is no easy w=
ay to pass non system memory address through VFS to the block device driver=
.
One of the ideas is to use the io_uring and dma_buf mechanism which is supp=
orted by the peer device of the SSD.

The flow is as below:
1. Application passes the dma_buf fd to the kernel through liburing.
2. Io_uring adds two new options IORING_OP_READ_DMA and IORING_OP_WRITE_DMA=
 to support read write operations that DMA to/from the peer device memory.
3. If the dma_buf fd is valid, io_uring attaches dma_buf and get sgl which =
contains physical memory addresses to be passed down to the block device dr=
iver.
4. NVMe SSD DMA engine DMA the data to/from the physical memory address.

The road blocker we are facing is that dma_buf_attach() and dma_buf_map_att=
achment() APIs expects the caller to provide the struct device *dev as inpu=
t parameter pointing to the device which does the DMA (in this case the blo=
ck/NVMe device that holds the source data).=20
But since io_uring operates at the VFS layer there is no straight forward w=
ay of finding the block/NVMe device object (struct device*) from the source=
 file descriptor.

Do you have any recommendations? Much appreciated!

Thanks,
Wilson
