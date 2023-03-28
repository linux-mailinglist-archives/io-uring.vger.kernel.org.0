Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1AB36CB2D2
	for <lists+io-uring@lfdr.de>; Tue, 28 Mar 2023 02:36:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbjC1Agn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Mar 2023 20:36:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbjC1Agm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Mar 2023 20:36:42 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FB472112;
        Mon, 27 Mar 2023 17:36:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679963801; x=1711499801;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=f0u6BGkR21Qun2ateXwvtKFz6UdXsg32dO8ufNbZ4pk=;
  b=AiLtwbRjycV9V8rulA0nqpoMEcFXs7Z3lNIL91LrTjx7Fs4l9XHa1Lwl
   FY8XmEBpl2BSGFpD7aWWt/iiq8bOAnyjlo5XPB68lK+IkvXwdazlYMhuH
   wvoi1WL7gpzc8j4bRgWVMNYWxB5YsChQDOVtI7ptcEw/OOJCKZubgCTEo
   Gurjf8t99+/N7nU+uk74HOr+RSE8+i9gT4sk/1jw3pIYcby8bQ7TKPv2D
   k9gglrIEGBTjg23YZeVTVuRMJTeXR1/FpVGCjdz2dXup9w0+uQA55/N92
   QG9lWFpOHO4cdXxS/eLnwjaMAtQ69XVmRBq6znDD8qFcMlLcKFvDj+UVC
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10662"; a="320083783"
X-IronPort-AV: E=Sophos;i="5.98,295,1673942400"; 
   d="scan'208";a="320083783"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2023 17:36:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10662"; a="683653734"
X-IronPort-AV: E=Sophos;i="5.98,295,1673942400"; 
   d="scan'208";a="683653734"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga002.jf.intel.com with ESMTP; 27 Mar 2023 17:36:38 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 27 Mar 2023 17:36:38 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 27 Mar 2023 17:36:38 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Mon, 27 Mar 2023 17:36:38 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Mon, 27 Mar 2023 17:36:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z93b4GBao8bRD0wy1ReG6Faelf8LvGN2luCfgiuyooh2JF4mNegHYhYtKakZJGaO25PgnOIB+aSW2aHVNWqkM/MiJDFpvL7KY3ncO+H3Ir+AXLh/lesDpSC7acQbJ1t1DmPcp42p/nA8tGm6Ru+1+P8ryPz0mdTQdLVOMhAdZBMc/0nn1FA5hZ8NDSe2C13hkiRiKnHbY4cI2vdQowFDvdE/ludEm8CR+B25tmdTjroAZ2hD1TQ0ycCsA/vM+rtt9tdDv6DdhmXzmgmIYOVXKWHqpMykAaaDiLbihGow2Z7aUTn/aj4vYuJVTusmSXHc1lnlCB3pW9KH2sz3LzDjpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dkp7U/mF3dbxlRo1xd40gEiXRBI+mqV1M+Mn3Li9ZSA=;
 b=oRMaAuxFzb4cRcFqgsAG+4PK5W9JVyGSmVs9r+803hplFfAD49dEz2FRO5v9pkc5vF5K0PURyHbFLY+hNh3uHrpHsBlfsBDwQhbkiiGicVw3aga7kRiYyVNAqE9gGeAx4QMK6Ykw22V/seJPbBPrej55QzxSMzRPpHi3KI46q3CDTZW5PKpEndYPvsld3VT2ZbL3/MwVMh9uvBSTymtuY6cTrkWoUtADbkfrlEwlEC0K1+Zlol8KPwuanpSVaWDLwV3E7f/cOfsU35QNQkzDQBtIV/kgK7kA/7g/aTGwGqf2erPxPic5KKy5JjTUsjHw0QeUqDXbMTS/4zsv4DHvVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by IA1PR11MB6267.namprd11.prod.outlook.com (2603:10b6:208:3e5::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.33; Tue, 28 Mar
 2023 00:36:35 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::ffa1:410b:20b3:6233]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::ffa1:410b:20b3:6233%6]) with mapi id 15.20.6178.041; Tue, 28 Mar 2023
 00:36:35 +0000
Date:   Mon, 27 Mar 2023 17:36:33 -0700
From:   Dan Williams <dan.j.williams@intel.com>
To:     Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        <io-uring@vger.kernel.org>, <linux-block@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@redhat.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Bernd Schubert <bschubert@ddn.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Ming Lei <ming.lei@redhat.com>
Subject: RE: [PATCH V4 00/17] io_uring/ublk: add IORING_OP_FUSED_CMD
Message-ID: <642236912a229_29cc2942c@dwillia2-xfh.jf.intel.com.notmuch>
References: <20230324135808.855245-1-ming.lei@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230324135808.855245-1-ming.lei@redhat.com>
X-ClientProxiedBy: SJ0PR13CA0139.namprd13.prod.outlook.com
 (2603:10b6:a03:2c6::24) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|IA1PR11MB6267:EE_
X-MS-Office365-Filtering-Correlation-Id: 4c5d52dd-46d9-4ac1-a687-08db2f247c4b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jhgs9Gso9iTwvZsuliwtZGTslQZKDcIBoswP1FYcBdVDC/uggzby6QBOum12wIxOjnndtKCXufnTV3lHEBJQaAA9qBEM8EqC1fM0QkOFwaxoCh9MMTH/ymESBEF+z9zsX8wJPk4t1iIFp/YoUDc8QB9pioJxl7A2KKr54LKxtv/uhOPOjV/wFxe/DMZvaDl7eb+Vcw3xAZ0MvUgp2mWxY7Tpp4qyLAGgZedaBiKeVqEk33/IsRWYLydsSihgRqUqLNGSPlXm+R3TVyhj/JSW0q6K2JekPwZBAngwnIzTjTTTHEK0M3ezo/8ddhzXdM6ADbe1/A5IhFVNbwZJqDHfBeuKRQQcbfEi4mJjm2QVzMK3D/B6WWM8ZDzTewJ4UhKynWhvs7QOvO7kkRHouT+dcLquS/4l1suUp94YESkNmHOaZsXwqoc7Z1KmoRCf0UiOc55nZx54oNsMxFk6anVZhrRwV2/E5hX2OkBPU+Sq5NlLt8WhJRz1FMJ9UGwp7QmMaHPyRzy2BT4noow4nogV+yo/FATgWpBdeeozRvF/0EM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(346002)(396003)(376002)(136003)(366004)(451199021)(83380400001)(38100700002)(186003)(2906002)(54906003)(26005)(6506007)(6512007)(9686003)(66946007)(66556008)(66476007)(82960400001)(8676002)(4326008)(5660300002)(7416002)(8936002)(86362001)(41300700001)(6486002)(966005)(316002)(110136005)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Q0M74nF20pkBMU/bLWKJLOdF/lE5x/DnmmXo31nSrubdupOypPdlj+QNOxkJ?=
 =?us-ascii?Q?JTIi09/Zs67QvF9oHrsGZSCokOxT92SQXmWPtuwU3obeOfNGWDxd6h+Kc0L7?=
 =?us-ascii?Q?PpfoYvlLj/oNpjJ5/t9DZN89PgLEkz+14Qpdl2AR/xnKuADNsMgPjJNqtXmi?=
 =?us-ascii?Q?UPCa3fTM88+pNSBTNyUpsGVNFdTi27ryoixMyCrUn11T2dJ1heuNb6sjUi7Z?=
 =?us-ascii?Q?c2CXkO7odRMpfoAw+sp7Czx72CrLgPXFrv3n4WBRH7ej40ZDe93QnSFv/r/p?=
 =?us-ascii?Q?YToJ7oK3F0+jFHP/PKTmWwDfYjtBZa7j7XsJ7/6CGZowiaJd6T6jjtPhHctQ?=
 =?us-ascii?Q?OpQJYkiu5JzOlFbodLu+SNHT/06I4kabVGH/cMyjP7ALhW7o61A1FzhEjHRd?=
 =?us-ascii?Q?Mdh/gd/+IcDeXKgQQb0CrLg/BS0gf8xo4CcS0+WUDnK/nZA9nmGsxjmRSYSo?=
 =?us-ascii?Q?ytCk2X68DdG2XOZIis0kEmrmBoQajfykwS8M2kZXAOmnmt0krRXpjZ9h1qUX?=
 =?us-ascii?Q?i3KlLhS/LlH20Ntgcm5v8llks1smcJ8gzcKlpQM/twMJ3lWPrBe9hVrtRze3?=
 =?us-ascii?Q?Wp3/n2fvWiHHVNGGExYKjrjCmcPEfHSq7hEW8Ek2tVVoZn7JN1RZ6DkR44uR?=
 =?us-ascii?Q?SPyZN/YqDi1ogyH1vpyWOWHAtY5KP/fcBirwqJotXTDPahRvseDqA3rA/xU5?=
 =?us-ascii?Q?HEhm9xT5trr6LewTByci7Bic4vzJITQ89JHoBEffMqqix5n+kVp3ggu0ZqYg?=
 =?us-ascii?Q?od5f1rohEmBjLsElT1pJEUzSqlwt6Y9Vdqo6i6oOixHxMNgVfTPUWKWGXzHV?=
 =?us-ascii?Q?oA6HQTprj3e8dor9q+IEcuvCZPouh4BtXZXQkwXPO9ooicsN1fdlsW2HkaBw?=
 =?us-ascii?Q?L9J2li80lQi+cmJ+BEC6BspE+9sp2NrlZW9Ny8h72ztWhLo6qSeuQmFUUTbW?=
 =?us-ascii?Q?tyNJYRNpbn0wz4xiI1i1In0ea3YmeuyhqfkoTCHXiehiyGAUDomGUAmE4rLc?=
 =?us-ascii?Q?4lbR4A/1NEbHsunC76sFqdqiHCEREud/hCDAL0vqvMlVFPqyzUiTx/MnR1CM?=
 =?us-ascii?Q?efEG1MSry44+CQq3npf8b4Sk25M06OlRI8rRtIvLAeLfhEk8f8M/CE39jyxP?=
 =?us-ascii?Q?S7UmkS7WtKRInZlEo6RulIrPTouUU5dded3mTeUFTKOt3ax6YfNH5Nuclsre?=
 =?us-ascii?Q?lkwoHS6SxH2T/2R+Fq9SbfjlY+IT36f+6vUo4xINsH7EiG32IdAHpYSu1F6P?=
 =?us-ascii?Q?fhruAbgZA1iR1Ek3S5e8LGla/P4DqkkBd9UzHmp7DEKe8NYlmJ0iVGc43JXi?=
 =?us-ascii?Q?f+/XzAJntIjCmcZVfxhuDzYW6BkGuAWjrKTUQVANMYZd5zidHQOqLcIuiz03?=
 =?us-ascii?Q?ZvIb60HOYnKENpWy0Kb3KqFqMKCw0DWN97g3/+++P7/6ijxcTnUxEFuM6o+F?=
 =?us-ascii?Q?/v4YOskB55ZccuYMoI0jgFHeP5WQNzeDSbbNvR8mjOwNxgjAvTurJtXqRJpR?=
 =?us-ascii?Q?scBVbyeEZ2Eiu3355U+R2Y1JOCyuWmmBBk2TpFpMZ7O0lKaoJoscnNuFa/z4?=
 =?us-ascii?Q?is1y5HNxefUUPlebxva+bu+WuUkIeeFPMkCSdAtobqLXab/vTDRNvgl73SGf?=
 =?us-ascii?Q?HA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c5d52dd-46d9-4ac1-a687-08db2f247c4b
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Mar 2023 00:36:35.5749
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Tk1DalhiLkkWObzK919wVTSUnuZkaNeXKpMh2go4wSFXUUCglWG/MybF/ZdI5A0+c9kxHWMvtAR/vwYoMklfsoYF9gbOvrGyCyOwqz5bCDE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6267
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Ming Lei wrote:
> Hello Jens,
> 
> Add IORING_OP_FUSED_CMD, it is one special URING_CMD, which has to
> be SQE128. The 1st SQE(master) is one 64byte URING_CMD, and the 2nd
> 64byte SQE(slave) is another normal 64byte OP. For any OP which needs
> to support slave OP, io_issue_defs[op].fused_slave needs to be set as 1,
> and its ->issue() can retrieve/import buffer from master request's
> fused_cmd_kbuf. The slave OP is actually submitted from kernel, part of
> this idea is from Xiaoguang's ublk ebpf patchset, but this patchset
> submits slave OP just like normal OP issued from userspace, that said,
> SQE order is kept, and batching handling is done too.

Hi Ming,

io_uring and ublk are starting to be more on my radar these days. I
wanted to take a look at this series, but could not get past the
distracting "master"/"slave" terminology in this lead-in paragraph let
alone start looking at patches.

Frankly, the description sounds more like "head"/"tail", or even
"fuse0"/"fuse1" because, for example, who is to say you might not have
larger fused ops in the future and need terminology to address
"fuse{0,1,2,3}"?

Once that's fixed up I can take a look at forwarding on to others that
might be interested in this use case.

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/process/coding-style.rst#n338

Thanks in advance for fixing that up!
