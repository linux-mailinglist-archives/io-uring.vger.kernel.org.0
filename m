Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00CB36CB72F
	for <lists+io-uring@lfdr.de>; Tue, 28 Mar 2023 08:32:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230156AbjC1Gc0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 28 Mar 2023 02:32:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229670AbjC1GcZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 28 Mar 2023 02:32:25 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91B70E9;
        Mon, 27 Mar 2023 23:32:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679985144; x=1711521144;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=OhLdUi3AmnjcGgFOHYE/pIecRnYowLG1I1KZ17djeb4=;
  b=eXs4UzXdR+Pr10fm83tXzrKUnWbQ6qjVS2mMzWyIvhpXuS7wScYVYeAM
   bT+KfVMhXJdG9OPpiKTaNAc6R34jo29ERLgscspJSVCax/huuqpXFSaGL
   pGkIqQ+b1UexzaLsWd43j5NsFyIjOKLk7FMcmnFewsKveE8tZiJPSgdvH
   ySDlbaT5919HXlCUZw5jys72Ljy9qguznSizxd8HkTLgsJMMftSXVlaC/
   Rn/At+OrLpHpmoTctDNUHXnNhTmX5pUsly1WRdOlGvrA6m8FNxB+QH5et
   bDBv9hUT2o120LmmX34E10GqHMg3MpyRi9QfP+zcrzfQm+iQlidyRZfMO
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10662"; a="368241689"
X-IronPort-AV: E=Sophos;i="5.98,296,1673942400"; 
   d="scan'208";a="368241689"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2023 23:32:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10662"; a="929743794"
X-IronPort-AV: E=Sophos;i="5.98,296,1673942400"; 
   d="scan'208";a="929743794"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga006.fm.intel.com with ESMTP; 27 Mar 2023 23:32:24 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 27 Mar 2023 23:32:23 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 27 Mar 2023 23:32:23 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Mon, 27 Mar 2023 23:32:23 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Mon, 27 Mar 2023 23:32:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LdyPK1FrbXNEjQYseau8zFaSINyMjDvCPi2Vmt2og/OLHiHk+GyEenYzFJIqjIx/NSd6F1hdyI4Nz3i6vlDet8YSNi8tnlOy/IpOdNoGtVgMaScTlCCLDJ+YSLf+kcqfRy2zdAqZtvgJKvYY72ZT5zA8X1klDRIoLNjSS3ftuEm5gtAsVD4Z1WFkAvSTubhiMEY7kvhc6prDr/WeDdY2e5OEfp+MZ6XeHTgI0u7H7H4biMig1sys3rRVc+kjbTX73kvCDWrILURDh73bV7pua2hXjaxzEusL99mO36R38V3CjtZlgtJJI1nhx2DiccA6jlp+whsiKugNTuW5kmxsiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OhLdUi3AmnjcGgFOHYE/pIecRnYowLG1I1KZ17djeb4=;
 b=LlzcoLfOycvpfT6dyvJLrTEHYkJfeow1PH4zyrrTR+tg4m88VzkiekpI5FsD78C1JyRjKTA8dPWwexbkRNF9ZSW2C37WMyEHA7+C/cDQoNw8P9Z60LIXwznU15MvCfbUQ3znkLDoDs2gNJq4SHTXiXQxwvIX7f+SJ9HNHVDRUyBIH8L128fAfPIzmUvQRD6XnWWMlaFfn/d9/63dquMed9Ib5DXW/wVYHQPCqPG0Pyt1DzrJ3w9TstxF7by/ou2e+8QL9BA+FnA+AzA4RgYIgmeSze4FruM6Av8tMuuAzU5nXhntnalu1tKiqTPEySbJK8UHYUyIz7UZdkB59Hy/cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by SA3PR11MB7528.namprd11.prod.outlook.com (2603:10b6:806:317::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.41; Tue, 28 Mar
 2023 06:32:21 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::ffa1:410b:20b3:6233]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::ffa1:410b:20b3:6233%6]) with mapi id 15.20.6178.041; Tue, 28 Mar 2023
 06:32:20 +0000
Date:   Mon, 27 Mar 2023 23:32:18 -0700
From:   Dan Williams <dan.j.williams@intel.com>
To:     Ming Lei <ming.lei@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>
CC:     Jens Axboe <axboe@kernel.dk>, <io-uring@vger.kernel.org>,
        <linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@redhat.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Bernd Schubert <bschubert@ddn.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Stefan Hajnoczi <stefanha@redhat.com>, <ming.lei@redhat.com>
Subject: Re: [PATCH V4 00/17] io_uring/ublk: add IORING_OP_FUSED_CMD
Message-ID: <642289f22032f_21a8294f@dwillia2-xfh.jf.intel.com.notmuch>
References: <20230324135808.855245-1-ming.lei@redhat.com>
 <642236912a229_29cc2942c@dwillia2-xfh.jf.intel.com.notmuch>
 <ZCJABlFshb0UmTMv@ovpn-8-20.pek2.redhat.com>
 <6422437981a0b_21a8294d0@dwillia2-xfh.jf.intel.com.notmuch>
 <ZCJKwQLE3Fu2udmG@ovpn-8-20.pek2.redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZCJKwQLE3Fu2udmG@ovpn-8-20.pek2.redhat.com>
X-ClientProxiedBy: SJ0PR13CA0128.namprd13.prod.outlook.com
 (2603:10b6:a03:2c6::13) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|SA3PR11MB7528:EE_
X-MS-Office365-Filtering-Correlation-Id: 64241c17-5862-4031-215a-08db2f562eeb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bN/FcoRFHXGaGyUa0iTtz2V3EeVjHC/3w9rlOaUbKm3zB/rOGUwtjH6JVMnLur6JNUvWPvtd8Tgd3E76EKKN1vNh2pS0dc/2a+77Cum2LRVd1METT0eZDqXNd+7h1Ut1HvsefDxPb4yfuNKFE+R7KDp/0G3q28QixwuCot9hZlzwQV7wUDldAokj39y4GN/ghnF8izosKTb04Oqu+plK3j43h2F1DPNdQvDIMHHbAF7bSaoxO6wTuVR2jgzQ2BbJ6iseUBEMFFmoLgi0KbOxZ/M1k0qlqW/QiavPLssut2zpcoRn32SQ+F2oxifcTXfPuc2OPFDIgrhM9g2WZpvgmqkEShigPYvIoSgNzfpoSvAzgLIivbLEebMrt7aVp5Z2xFPxhFCEhp/RlLfGuSr8pN68WvxNezJcGOE+qcjjavwDc+ShFSSuu+iMyKAg2fhMn1W7Oxmot+VsWhAsTk15T5KAP5zRi9Xc2Ok/9Z3AaRB94Hm2GD0nOVdJqHx6YESPQOR/o+hHzpWZ1upMsUbbEbjV1G1gm1AV8YGlIvyEQLBYmf42kIBp24HYqU95bEJD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(396003)(136003)(39860400002)(376002)(346002)(451199021)(41300700001)(8676002)(66476007)(66556008)(4326008)(186003)(2906002)(7416002)(5660300002)(558084003)(8936002)(82960400001)(38100700002)(86362001)(66946007)(110136005)(54906003)(478600001)(316002)(6486002)(6506007)(9686003)(6512007)(26005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DZfLv2okqvIYyeVq7cAWWN3FfD/Zt3oAtgMxLJdvfLvPgm7Hr1VA+76rPGkE?=
 =?us-ascii?Q?DDN4CMm1FQXPqtiB+rtoTIJKgzvDrI9noIR5+9/hgm3uQ2PWDuMhRxnZrG0U?=
 =?us-ascii?Q?vvb65SRIvj+TjfhcDFYIeHYxlkz4B1A9LeG8M4x/LzMJpxgDg4bbQU0Hzqxf?=
 =?us-ascii?Q?+Xl/Eh+yqqq4a83QwwBjPSSiGtOj06ynjFOYkoJhwULgIWgtTJTI6S2Rspry?=
 =?us-ascii?Q?YlTD/r7Nos2zRgzjQHHbfy1s1mNMs/90tYqezmG9167ARHsjXROFFVC0KFr4?=
 =?us-ascii?Q?QFANQYXUgBC+UDUF5PREn70mxHTG/DefFjHEb0FjV4QZrzZZkbMIg1xnT4Hk?=
 =?us-ascii?Q?jVh9i+Q/+LzuX12TUudWESyAt/MptBMwh6iItGnX6cPNw8snUe4/K6Sh9u5B?=
 =?us-ascii?Q?w/0GKuXdJmavjr7uI25oyJWWpKjz4ucpy/TcBZLrc1u20aKA/ezQ/TbWzRFQ?=
 =?us-ascii?Q?dmSqIl4Hxdx4yXG6NJRX6RzowQG7/kOaNJgd6kMb7PJKaN+H7R8Sa32d2J6p?=
 =?us-ascii?Q?DeYs33Z/ZgdQXlp0A65CC+sXbOeHpBdMjEXIb9bmvyYznhn3zY/+fL1VX5Wl?=
 =?us-ascii?Q?wVWesMm6aKn9IiYRF5NaexWOiEoLleHbcZatOicvq05B3pNroz9E52hDFhp5?=
 =?us-ascii?Q?WBfLB588of81pXjJhYGnJtDA41q09Ubz4K1NKDWH7eN3J3mJe07bY02uoO5b?=
 =?us-ascii?Q?DJ+LJJ9qDsAZUk4dJUUysT7gBgHK28qwnsK0Hp1kysQSkoSS8seMnBAqjFEq?=
 =?us-ascii?Q?MFioW1vMWWKUkhF76xLfDvw+QkVmoMGhpyalwq3nvy+3COv/bI8vfOOnjYYH?=
 =?us-ascii?Q?TfHwR9vtBLDoSyB823Nag0HW2I8jX2b17AfmSOP9U9D27PGf4VxeYB/wOtBV?=
 =?us-ascii?Q?XszrOQfhQtFL1Isqp0BbFhyExQLLEFkGYeFtNzCWXBQuaAR8vQhDX7oBK8nt?=
 =?us-ascii?Q?f1uJLgBdt4RgoMPorIBp9TwjGAOBWF5JNJiaE7Q8liMSr9+Qeys/WR/aC3M0?=
 =?us-ascii?Q?oPl2uLklSdYoOHqIjUV/4EbYDLDvGFQqgqR4pJf5q8rKpGztnh+sP5pQdifX?=
 =?us-ascii?Q?tZUwq3tG375uWZOROWI3DW+E4gKwGyEFyQQi3oT9hvp2suC24u2Od+r7uIGl?=
 =?us-ascii?Q?Mx8d70t5JJIOChuBsQgZdDgfM0chZG1yHvIyFOpzL60ZbrplX1GWJJwgRUN0?=
 =?us-ascii?Q?paW7qj/P/1JKMxbfsOYkAIGXYtHoDvpXfQPeodEbIkMuFLebeV1MJy5lH3ut?=
 =?us-ascii?Q?/y/7Zuejoz0l9HQp7dEHWMaJ6jUauLiVau+xYgyrxs6/F8xrlybO0SFNC4WD?=
 =?us-ascii?Q?LMOG+2Uaswgm8Cbo2LuzTYJgHzcpW6SlV05P/upD+0S/X2mxcD2QKho0sygF?=
 =?us-ascii?Q?mC6I6Wst4aEkMpOKWgBkbLu2nGI8YZeMdSxGiQ1Ll2QdrbJB5ob3yeqfqWOP?=
 =?us-ascii?Q?w9nviVS0Arn6iX0De1HsekvurLgff8X5KfzpAs/ieiGMWXvnyitwFmlQkQrB?=
 =?us-ascii?Q?IknBoNDuNZIQXVZGChPF1zZuaWSbTjgx+hluBJzGO6FK4FfUkB9ckU7E8geT?=
 =?us-ascii?Q?n4EL6IPQJJGGephXzX/RO+dBjFjDyyDb0IfmbqFayaSfbaBF3X5N9M7Gbuvc?=
 =?us-ascii?Q?eg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 64241c17-5862-4031-215a-08db2f562eeb
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Mar 2023 06:32:20.4849
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5uVw/6cjyABwnSBQDh9fa4jfX87XJgJEFahPnqJ/D0bk1vt+ZYP84vSdC0vsA88Nf7rE+CGfi677a3/WUD6I61B5K7qvg4196tAbbKxXu58=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB7528
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Ming Lei wrote:
> Jens just suggested primary/secondary, which looks better, and I will
> use them in this thread and next version.

Sounds good, thank you.
