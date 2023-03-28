Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70E8A6CB32B
	for <lists+io-uring@lfdr.de>; Tue, 28 Mar 2023 03:32:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbjC1BcJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Mar 2023 21:32:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbjC1BcI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Mar 2023 21:32:08 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D872319A7;
        Mon, 27 Mar 2023 18:32:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679967126; x=1711503126;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=PVHeCcG7TcSO4dObAm8JayWGLkU8DoQCNfdvTk7/l2A=;
  b=D3q0O5Mi8g+VwKMaPgPxBLIZXH6IBrSN0m7XUxY93kO2pbj8ta/Sbi94
   PgiTsY8h4EEeMsTzz/TGwx3tE6emkzbvF2xgsJFnEWYHT7v0jrpcl8+ZR
   gJ8jVVUlnc3GOeJTTm6Bkd/aYKX2sRcxGqRVJHsMxkfOozsjG7lmZXlnr
   IzAzk5eLoMrzBDeaaLYHiJGI6oWm6AKW0jehMBebyKSJd9eg6UZVFKMP0
   +kuxQpbdpW772Z5PngVTTkPEuDCsUmJinGIoGP6O41mE5xKRKMBwHSM/H
   awzJKR9Z9OJRjW55TPi0KYzS6NaXPK4bW50x8I5aU+UBoed43kdIRjE5Q
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10662"; a="339162859"
X-IronPort-AV: E=Sophos;i="5.98,295,1673942400"; 
   d="scan'208";a="339162859"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2023 18:32:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10662"; a="677170207"
X-IronPort-AV: E=Sophos;i="5.98,295,1673942400"; 
   d="scan'208";a="677170207"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga007.jf.intel.com with ESMTP; 27 Mar 2023 18:31:43 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 27 Mar 2023 18:31:42 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Mon, 27 Mar 2023 18:31:42 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.44) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Mon, 27 Mar 2023 18:31:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TzUkKgC/SXIr95FbqDArLb+CUZKt+kV3yPn0CHUOBcKhzpc3ydfaBykDnpb1khNQVTt2SE3MMfOz0mwMIdPS4EoM7Ec8R7vKHKml13i+Qp0mfyO5XNx3BWJ0QW/kfXLQRo+UOsKAuXyUHj6FGwjh5JyAR1K80z3HaQIc7Qd/JWBSgYv1N7WRSOzFVV38VTC49mqiEzYktgeTDOJmr5oVQcUzeXnV8GhsnnmKotZFDj96IJw70baVKj30d/xJ3wyw6tDPbPl7bo09c+PVbUl7EKPOEZNSGrv1rs2yUmgKEnh9oyZ1r7Pxp2C+OBfHzmmxq3L6NF+0aah4h2OCXeccyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=whHOB0R0p2Qp/mvMNqfuIbnhJ4cqyM+xs9VGkmlSZow=;
 b=Ca0PLO7C+2ilR9OJt3zJY5XvN56mb8z9I0biNkoc47g4a0130mjnXcmO67R64QhDzH7PPtTCZxasbMuIUqU0gon1Gbz8dNzL1mSClI8avsefVlQRMCUv0mwNTaWkEZFacH+Z7u2Rcb/oc1v5XDRMEbc/RZXxTJrprvYj90TtzjWGFe8NkdeEbXSdqi7o6IlkKXDYFiP3YYD2thLOogjvROS7xgu1Abd0Puh618fMCdx/O8IlyMDMMvvNVuVyJrBPXdnGWS3GIZ7NPaW56G1Z4hk7oMLSwiXZXokUiNQ7pfuy7KVvlmI61q+ShWHp89mOnDoDsmsyNN0rkbEUTudInQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by MN0PR11MB5985.namprd11.prod.outlook.com (2603:10b6:208:370::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.32; Tue, 28 Mar
 2023 01:31:40 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::ffa1:410b:20b3:6233]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::ffa1:410b:20b3:6233%6]) with mapi id 15.20.6178.041; Tue, 28 Mar 2023
 01:31:40 +0000
Date:   Mon, 27 Mar 2023 18:31:37 -0700
From:   Dan Williams <dan.j.williams@intel.com>
To:     Ming Lei <ming.lei@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>
CC:     Jens Axboe <axboe@kernel.dk>, <io-uring@vger.kernel.org>,
        <linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@redhat.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        "Xiaoguang Wang" <xiaoguang.wang@linux.alibaba.com>,
        Bernd Schubert <bschubert@ddn.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Stefan Hajnoczi <stefanha@redhat.com>, <ming.lei@redhat.com>
Subject: Re: [PATCH V4 00/17] io_uring/ublk: add IORING_OP_FUSED_CMD
Message-ID: <6422437981a0b_21a8294d0@dwillia2-xfh.jf.intel.com.notmuch>
References: <20230324135808.855245-1-ming.lei@redhat.com>
 <642236912a229_29cc2942c@dwillia2-xfh.jf.intel.com.notmuch>
 <ZCJABlFshb0UmTMv@ovpn-8-20.pek2.redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZCJABlFshb0UmTMv@ovpn-8-20.pek2.redhat.com>
X-ClientProxiedBy: BYAPR11CA0088.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::29) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|MN0PR11MB5985:EE_
X-MS-Office365-Filtering-Correlation-Id: b2cb9fad-5a3f-4f76-85bb-08db2f2c2e17
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PV0xgjmPAIKsyEZ2HpXdcGBHLJrp0lUNQ0WPobt/XvieyalFXiPzxEhMGPLpftoZmrKQ3iGScCSmPkykJ2iWqlNkR2swsI45zcnREsQzh1qLI07gryBgmHu6p7bEBl361fntKL0hMiD4grfFab7pWhB4GlT1j91gb7NUiglYdO+PWwEN0Oc0Dstz66r0rFFmrVsSjl5oUv2dRwvoHiS/oBnnSQ+FoQvvYOAf9yR+jiyjvoAQ/WMiq1mcjvNFB9r0xT/tpAdmPOKLrXYt+ygUe7GE5jyUFstOln1fhceseQr8eDI4AkhQQxgfXEdY1lEYh4x5v/8sx/4+ES2Uf30dOLU9pIJGWPxhtf007DVqsEKTRroVWhX3tnxc4dDphrBFgCQ4FkVfsVY1hciErXNIRAKtgsTJxvwwjyiIeRgeZuSa5dnI93Q1ErFYDe9clFvnbTmJp4svmGzbOqoNUyxiz8Da1G+4tfp0SJse/X2MdZbhZa6YUfrao8q6IS8Amu53tQKNHjzgtBufUWEvhbE3LSIEPaLHRBHC7rxW/ozzma4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(346002)(396003)(366004)(39860400002)(376002)(451199021)(86362001)(2906002)(478600001)(6486002)(6666004)(83380400001)(966005)(38100700002)(54906003)(6512007)(9686003)(8676002)(110136005)(4326008)(66946007)(66556008)(66476007)(316002)(5660300002)(26005)(186003)(6506007)(82960400001)(8936002)(7416002)(41300700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zdhXoytfGyx6xlxOMowRvgiucR2K7SVljRayTaJFq44O10JmDLyFfArH2ogv?=
 =?us-ascii?Q?xDecBqbqeGAztqf0DJPCQGVIIKKX80q4SjkDl3oRC/eRJDDT/QxxRfF9Je0s?=
 =?us-ascii?Q?e0alGRaoEocXCWYBcKaBdwN1leIR1+xEa6uLi9uq7QHIuskNrDG+lkG5kEp1?=
 =?us-ascii?Q?tyXmfxRbfOjQ/RJ+ZBveNoIAarv6Vff3t/7L6/v6V8t6upLbV1L8q5rwN4Qv?=
 =?us-ascii?Q?u5vpHIWvE2mmalGHxqENM2C1F0CkCFlE4HzV8uZpfilnPvRG7r9p7NxfvSSe?=
 =?us-ascii?Q?Y2RfKkqk5znNv8QcBfmAnc8+QJQrmoo/t4FEu1twJ/QMjW09v1dFmjFedkYk?=
 =?us-ascii?Q?HtpwB05lzKzbpFNMygq7LcqN39bvRngCHMgdh3PgA04zCoNUtOO3Q9bYDBZ9?=
 =?us-ascii?Q?HZgf39uJycA6fi85/b8M7ib17fk+huQPNB4L4dIrgXIXmHnCHUoENNrONVQp?=
 =?us-ascii?Q?RoLbu1lU5PqNfjfSR7I5XpXHPLUV5lxYku28BC/Owuz5bR0XDWRo9oHRJf+J?=
 =?us-ascii?Q?1ce/cLFU8vIa9GNViboZiab4Vb7XHmtJ6vNzJU3lJHg6NXvnA8TuMQCw/N/F?=
 =?us-ascii?Q?IaU7Ay1VJ9KtiCToZzFSv5LxyuisoWKcMfHF0kaIH8JIJQRXlL9HTmZc0kBC?=
 =?us-ascii?Q?J+R1bb5FCXc5asZGfnNcqf0aPdF3kFDWPBsQd2s9iBz83bI9CgZyrRuRB3KB?=
 =?us-ascii?Q?jzHk/xDBACN8Cn12mpzxAphGImEW3OIG4xr3WNW340Wo4DeHmDOIqmwmH6z/?=
 =?us-ascii?Q?BuVq+hb2URkO/w7rRmOEQqL8ICVefMJgyCHI+Qwh0RBApKaLEMcbvAriviqD?=
 =?us-ascii?Q?YtwPOhViqOWLWNhWxhpdzEgF1Nzt4xhbQ9LKuUP0LfX9+GI07JgOvpq/KbiI?=
 =?us-ascii?Q?tqGGL2WXdNruH735dgNAssXqipJDh0NkV3pG/jw51gEEXv8YjrpYRIAEcQ+b?=
 =?us-ascii?Q?EEwX1QLI0LaMDVb/XyBRoYeOuqDGnUyyWsBgKju1A4vfw0Bq2JHayJPX1g1c?=
 =?us-ascii?Q?SSYA9+NyuEI/5KKFALkSuwe1LaFbxR/IgwuK6rnKSgjiA4sz/L8wxupvczQl?=
 =?us-ascii?Q?f4ZEykeJ/BKT34Gisj3554lasqCEJ140DYL0uVPewYt62ikGcL/ZeZKhb736?=
 =?us-ascii?Q?fyLFK8onUi8sVDNVSOJebIouQCJSwkKj2k8906ZGOnzEHmCC170ZNy2WWqLr?=
 =?us-ascii?Q?lTB9JEbnLB9HHeaUy7pQnCiaoypOIzWTFpu3C5B2RZ7HROx+NpmbUXIupziO?=
 =?us-ascii?Q?x6JDOEgBszByQ3mLJJYjGhnvt/tqTPYTxNrNuD1gBbYO67QfzIiuERB01WjI?=
 =?us-ascii?Q?Fmgh0Vfd+x7dxlYE+AvdcXMF0NdIojFUrLUNAkb57/o0kBocNtXlYjAX7fpv?=
 =?us-ascii?Q?gvFKrsvlykSXJsbbNJQrdjPuGcWM48jfgA4xyT9DDs2PMTUswlLyDajKsPTA?=
 =?us-ascii?Q?EpGpXOZMx1UMQgU3IPLg17aUn1swegHCQ/Az9nNktWn0OpxW+D4iLKNqZF/2?=
 =?us-ascii?Q?xz/LrpAdTJdIm7wV90TBkno+NqVWxSIKynaiZZ0awqsNz99eDx415nTfKqhy?=
 =?us-ascii?Q?h64pnik3H5yFa9/Fo/R0r8C5HFwDA0P+NI5EoalyCoqq9mECxO55jHxSNtE3?=
 =?us-ascii?Q?Ww=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b2cb9fad-5a3f-4f76-85bb-08db2f2c2e17
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Mar 2023 01:31:40.2511
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W2qoStsNv/Bqr0xNnrNB8Iws/kW1GmX0YraXwes9swry/sBHwARWBnayCZDh9B+6+7kIs46ceAI87xyUqCbk6+L0vqlAYSnGn6xfyCcmHfI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB5985
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Ming Lei wrote:
> Hi Dan,
> 
> On Mon, Mar 27, 2023 at 05:36:33PM -0700, Dan Williams wrote:
> > Ming Lei wrote:
> > > Hello Jens,
> > > 
> > > Add IORING_OP_FUSED_CMD, it is one special URING_CMD, which has to
> > > be SQE128. The 1st SQE(master) is one 64byte URING_CMD, and the 2nd
> > > 64byte SQE(slave) is another normal 64byte OP. For any OP which needs
> > > to support slave OP, io_issue_defs[op].fused_slave needs to be set as 1,
> > > and its ->issue() can retrieve/import buffer from master request's
> > > fused_cmd_kbuf. The slave OP is actually submitted from kernel, part of
> > > this idea is from Xiaoguang's ublk ebpf patchset, but this patchset
> > > submits slave OP just like normal OP issued from userspace, that said,
> > > SQE order is kept, and batching handling is done too.
> > 
> > Hi Ming,
> > 
> > io_uring and ublk are starting to be more on my radar these days. I
> > wanted to take a look at this series, but could not get past the
> > distracting "master"/"slave" terminology in this lead-in paragraph let
> > alone start looking at patches.
> > 
> > Frankly, the description sounds more like "head"/"tail", or even
> > "fuse0"/"fuse1" because, for example, who is to say you might not have
> 
> The term "master/slave" is from patches.

From what patches?

I did not understand this explanation either:

https://lore.kernel.org/all/ZBXjH5ipRUwtYIVF@ovpn-8-18.pek2.redhat.com/

> The master command not only provides buffer for slave request, but also requires
> slave request for serving master command, and master command is always completed
> after all slave request are done.

In terms of core kernel concepts that description aligns more with
idiomatic "parent"/"child" relationships where the child object holds a
reference on the parent.

> That is why it is named as master/slave.

That explanation did not clarify.

> Actually Jens raised the similar concern

Thanks Jens!

> ...and I hate the name too, but it is always hard to figure out
> perfect name, or any other name for reflecting the relation?
> (head/tail, fuse0/1 can't do that, IMO)

Naming is hard, and master/slave is not appropriate so this needs a new
name. The reason I mentioned "head"/"tail" is not for ring buffer
purposes but more for its similarity to pages and folios where the folio
is not unreferenced until all tail pages are unreferenced.

In short there are several options that add more clarity and avoid
running afoul of coding-style.

> > larger fused ops in the future and need terminology to address
> > "fuse{0,1,2,3}"?
> 
> Yeah, definitely, the interface can be extended in future to support
> multiple "slave" requests.

Right, so why not just name them fuse0,1...n and specify that fuse0 is
the head of a fused op?
