Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B461572D84
	for <lists+io-uring@lfdr.de>; Wed, 13 Jul 2022 07:42:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233809AbiGMFmO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 13 Jul 2022 01:42:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234049AbiGMFlz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 13 Jul 2022 01:41:55 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8616826DA
        for <io-uring@vger.kernel.org>; Tue, 12 Jul 2022 22:41:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657690873; x=1689226873;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=2qyhZPm/nyYNZH1IVFhAKVLDUgZhz5VJpCh7EZedYf4=;
  b=L6iWDTqvmlzg7nz7ZNIrLER5rAJmfzxVvPnE3b+JRNV6/buM8eEAGpzO
   Dl6CJK+12nmHwZgRk2XdyNeGJA/R3NRBNiqJa9NF3JdeYsAvxgo+A+Z7d
   66OFbgxn2Ehwe05EVLLCp0JHnlRlZM6kgl7Fm3aCMzzMLN/HrDbzBjZ6u
   93cHApr6j7lWcbobjsbJKATLVpOkG0lzrjqGh82ET9JGCA3/9X1hNSwFC
   pmSlvXsn+MzkG4IPfrHptOmWS37+ZkIvA13MBj5w5pjymb8WdT/dZ5ElV
   bBBcC0qbxtiSuRrd/9zPEt5MP1K4LT4nWu1+NERRwz2ok/UxLZYTczXHg
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10406"; a="265527116"
X-IronPort-AV: E=Sophos;i="5.92,267,1650956400"; 
   d="scan'208";a="265527116"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2022 22:41:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,267,1650956400"; 
   d="scan'208";a="841632875"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by fmsmga006.fm.intel.com with ESMTP; 12 Jul 2022 22:41:11 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 12 Jul 2022 22:41:11 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 12 Jul 2022 22:41:10 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Tue, 12 Jul 2022 22:41:10 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.173)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Tue, 12 Jul 2022 22:41:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LoMUkdUyZupV/+tAsyNSTaYj1ZJ2c3MvubJLoVqcxftWPEitiPptMk6wV4GBut7UMsmTefDt1o7bYoQ+ezHmB8aFt0l+B40o8J5DmvJfbayhcJ+Il1ZbLTNV/D+TaGo7wUfWRhKTHvxrfGnXJgJMIHNE9E9qdMi3I5/LioAg4W/i6GAO2Zu/nJFyOENNIrbHX3oUl1DFae6mTuur+UAIBCFm2jbjh4NFJo5CzELpgAzwhJtgEjZUVsbI9pYLK7MW6Sb4WefMFDj7+JoQudyuJDmc5w6t0rhAPU5lAMlurcyK90dYX3YlbQRN+SBTtjo7+dqnl6s2hd6FyayLcqkONQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2qyhZPm/nyYNZH1IVFhAKVLDUgZhz5VJpCh7EZedYf4=;
 b=jeJLbDZno3Bza1q7brHig2+1O/48ks3sAsYAM1+Vd6oeF2giYvbR/NZ1LHh7Yp7TGo1jKHxBsONH9NKJtCAq+gzoYYdoMCwUHmWLRHrSYfixHquRxHo3c2yFkVDtoYZ0t7sIk3cF88zy7cewkgrg8A0ewSfO551MNI0Qlu5eT9GnY7qwwW/7n+8xP4lcneyoTdtNeaJodeZOiMSeeQgvDYEeqyyEzt2e5NMFSDcYrCzRnRgepRK476JzQSeloIr9LH7XQ7xUJS5pcT9gWncXfz57w5tJaLjNXKKU293YOQCOE70tVlovyUp+WAkllZckfritrlnlP4aBdEHku976jA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BY5PR11MB3990.namprd11.prod.outlook.com (2603:10b6:a03:18d::31)
 by DM6PR11MB2666.namprd11.prod.outlook.com (2603:10b6:5:c9::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.20; Wed, 13 Jul
 2022 05:41:03 +0000
Received: from BY5PR11MB3990.namprd11.prod.outlook.com
 ([fe80::4d95:bf6c:fe2a:1f5]) by BY5PR11MB3990.namprd11.prod.outlook.com
 ([fe80::4d95:bf6c:fe2a:1f5%6]) with mapi id 15.20.5417.026; Wed, 13 Jul 2022
 05:41:03 +0000
From:   "Fang, Wilson" <wilson.fang@intel.com>
To:     Pavel Begunkov <asml.silence@gmail.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
CC:     Jens Axboe <axboe@kernel.dk>
Subject: RE: dma_buf support with io_uring
Thread-Topic: dma_buf support with io_uring
Thread-Index: AdiGxAx+I+R0cj8qSdyfvtX+0f5bpwABLJlQAAkJiAAD4zyl0A==
Date:   Wed, 13 Jul 2022 05:41:03 +0000
Message-ID: <BY5PR11MB39904DD49256EEBA8E04C4E6EF899@BY5PR11MB3990.namprd11.prod.outlook.com>
References: <BY5PR11MB399005DAD1BB172B7A42586AEFB59@BY5PR11MB3990.namprd11.prod.outlook.com>
 <BY5PR11MB399055971B9A3902CC3A3121EFB59@BY5PR11MB3990.namprd11.prod.outlook.com>
 <42611180-e6a0-e700-d0ac-b007d8307ea4@gmail.com>
In-Reply-To: <42611180-e6a0-e700-d0ac-b007d8307ea4@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d0790911-f3a0-44f7-49c9-08da6492468a
x-ms-traffictypediagnostic: DM6PR11MB2666:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: duJ3NjRyVQfidZeRUWw7elCE3TlHilwDOjO7ftOAupkNrdy7WgkCvC5LbTm/NPtsTk8VZzzhBDSzT7A4DKsgBtVKG/vomLPAtKLXkp6Kes9bQNy5vO3FQrEvAfqOFFNzUAWWiZD3klhOsYNExZcPU0iStUzFguSH09zFjJVa/oaTEt3XgcieArJnHLypNWlpKrLYHk0382iQyUealnZ0wDwWFMJJmeccr9ng5gDkliYuyfGwsgY9ZNFE5NZ82bo3J+FeICabFlec3BK2VsxBzowXVnkXalW0AtjPSuYWjzF13g3GebVy4ZKzXrOmElsHtvpx19NtMus6BqzXaeJfwoXZ/4KIt6QZLIuEC9Byf2kNlNXtgkGWZA/9lxb8+MeMD06scQkiglm5F/m9zqVV5kkILn5kBhPYsoqDue/GmcilCxZXnxaNSIegcuxNpdZ9QYGrQPyQk0L0GrpMM7AX3XtprOpZ/bWjF0yjo8KsIQk1D5JokmXRQqU8BMUmWpEmGZPm/v3WhLbDVoTKzqFEo9nj5vT7ByZDVKNL9toOe1rDwIbuIechhhRP/qYM1PFsGo6LMq6BY9frsUuHczpOjqzIIbSbdBI1vphTQbrDuGvI6ECdpoeJGOEZRxwTdx9bhoTWDeN9ZmvclVCh2JfYMVBNix4QHxgszaIvK9CwYcMav/bTZQkvEv8AAqCRXSdIuBU5zRKbM3lPsY5wk5y5w5h9wosqckevD7tH4cajESiEjSXhkfE6PojGXGdPQiHFpKoHuRVllIYrbdpOUoyjdCnTMR8e6oQ7uAM2wL2WoL+wytBt5HhQy25XQ9o2xCrd
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB3990.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(376002)(366004)(396003)(346002)(136003)(53546011)(316002)(7696005)(71200400001)(64756008)(41300700001)(8676002)(38100700002)(4326008)(66946007)(66476007)(66446008)(6506007)(82960400001)(83380400001)(76116006)(33656002)(66556008)(38070700005)(26005)(478600001)(55016003)(86362001)(110136005)(52536014)(186003)(122000001)(2906002)(5660300002)(8936002)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bG53SEhldmNVR0p4UnM3LzhEaVp4N084RVZrVEJ3WVMzV2N2dHAyckl6bVY2?=
 =?utf-8?B?SXZvWHBUNDNEeVcyd1dQTE0ybXJzeE9WcnlLNzAxazVWaWtmYWNBck80R2lE?=
 =?utf-8?B?VUhpRTRzZkVkbDZjbUMwUUNBVVVDYkp5TmhXajlUbTdXa2pJUkNwdHFFUWY1?=
 =?utf-8?B?c2hWNzFtbnpwT3l5azFPcjM4RjZXQVF1RENkSjFHcldaSTc5bHdWYTMvTlhq?=
 =?utf-8?B?elFDd25KNFFiakJDSGgrRkwwR01jdXYrY2d5VVI0VmdpSi9OSmJKRno1Rmsx?=
 =?utf-8?B?eUg2ZERWdUZvMnVoeFZiYjhyYnNpZldsQnU5bVdCTThLNld6ZWxlRUlSTFdH?=
 =?utf-8?B?TmRuVnEzUGc4bU94U3o5ajJSaFV1OUZFZ0RxL0ttbnFKelRlbFNPYTRPMm9K?=
 =?utf-8?B?ZEE4KzM0U2JLMkFjZFhWNEJSNkx1MzY5bUhUWGFHa09CbVNHWXRES3M3Vk1V?=
 =?utf-8?B?SlFpZjExUm5uOEZBMmQ1bXlHaTRodHhMMkZBMmdqS0dnYURGNnFBV0hvRm5v?=
 =?utf-8?B?bWJ6Vk5vQitOZjNpT1ZCc2d6VEdHdGZUMllQZ3pFUWN2ckpobTdYT2ZUNmZn?=
 =?utf-8?B?cE5ObXN5WDJYTTBZVVBkcVY5UkU4dmM0M1l3cG5KNWVPZDRnSmRGY1BuM0tK?=
 =?utf-8?B?UndIN2JBSmwwcmtxRWpabkZMSVBaZE1ZTGVyaWtSY3k5amNLNkZ4eEg5K2Iw?=
 =?utf-8?B?UExxaWlSWnhKMjdBWDFxdmFoUkUraUJsV2E4QkEwaEQ2Zkt5RGRGejFlL3B1?=
 =?utf-8?B?d2lnTXFlNHhRcUVYZUN5dTR3SWE3YVJENzV3SGdDK25CNUUxY0l4eUpzVCtr?=
 =?utf-8?B?NW5UV1FlZ1ZJQW9RWVlXeFdIZTdqdHhjOVl4Y053SmpsL2JIRmxmc1FTeFNj?=
 =?utf-8?B?b1dSOEpsNkVvbG95T004Q25HSUFXTTErakZ4OWxsWUtnblcvRGpjc0p6SXlv?=
 =?utf-8?B?d0trRFdOOXROSnN0QXNqZHEzdlNBbFpqcDlqaGxnRFJRbUdhdFFWWjVpNWI1?=
 =?utf-8?B?RnN6cmZhZjY1VnkxZW1yOVlqc0V5djFISWorMzA4QytFTytVbUZCSWxSTytD?=
 =?utf-8?B?eVFoRG0vMXA0cjV1bi9qdUxzWExZb3BMK1N4WWowVUJ6bXdSNzZLdHZrZHNk?=
 =?utf-8?B?cWlJdUlQNmpRVlUvRkoyaTVWMFhVOSt6SUljdmZLVzBpVlB1SjVBNGpFYnRP?=
 =?utf-8?B?N1lBNXFxSkFsdlF6Z0UzWlI2STFIUDdYR1prcWs1YWNMTDNVNzNuRThJUEtw?=
 =?utf-8?B?eFlPbElQeE81bS9mTkg0TEZDQmpDbEdVcjdHT2RQMEpjcHgxaUVOL0xLVkpE?=
 =?utf-8?B?YjZmR3ZlZWs4eFNVSUlFRGR1RUJyL1VjcmFwTGVzZGMvTWQzOTJMNURrZWVP?=
 =?utf-8?B?UUgyVFc3VXJUajJMZE4xczI1R3RPRWpJWE1zVFIzSlgyTFRjU2FweUwxV1Y4?=
 =?utf-8?B?djdQaU1QQWMxSFhRREtBZmVib0ZVZW00OC8zakVESy83YmcyUngzRGRaRFlp?=
 =?utf-8?B?UlVCYjVSRlpuMmRrL3hpNjc5U0pBdk9NOTV5bE1aRHo5YnpkZ0I5QzMrTmpM?=
 =?utf-8?B?aHQ5alo1NnptQnRJaVhDbnYrbVJMYStEa1phcGt2Y0xvNEF1MHJkWXNHMW9U?=
 =?utf-8?B?WHVwaUdFakhFaHZOeW1iL0p1YVBRS0tGb09UOFQyM2RqRitQa2pCUllsemFz?=
 =?utf-8?B?aWJ0Slk1ZERRUDBYeHpZUW5vYm5wUEF1elJKRkJ3ZmIxREkyTTM2RG9mTzVX?=
 =?utf-8?B?R2g4ZDgwQTBnamVIVVBsbzhaZHVUalE3dmdRN1B6VGIyUW1OOHl6OGVkc0hV?=
 =?utf-8?B?MVIrWjlheU1lczJrRXBaUlBjRUhyRG9KYzJvOFUrNVRvQUZKcjV3R2t2L2dM?=
 =?utf-8?B?Rm5ocHNQc2gzbmZmVGs2eFh3YldGdEdMd1pDM3QzcHpEbS8wQ1hLa0xMNlVI?=
 =?utf-8?B?RFREczJqSkhjSHpuajBKWXU1bzhkcDlhSmhTRVRZUWMwbENWMEhkdnBpUU5H?=
 =?utf-8?B?ZlN3K3A2dE5UQWUxTmFpaU1OWnJGeWg4bHFSK0VxRE9YUGRMR3dMN0JCUlEz?=
 =?utf-8?B?eWNiYU5ZZTVmQUU3dVFLc0h4K3hVZGJvRDRLRjNLNFZBTHNwcmwyVFh4TzRP?=
 =?utf-8?Q?x7qYWlzvXIl2xIlgjgksMclwV?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB3990.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0790911-f3a0-44f7-49c9-08da6492468a
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jul 2022 05:41:03.7661
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9KyaIBHLMouuWLB1slcSI2En3vcw2uxFnE3k7XZ73AwKgGWf51HsJmYsUbXTsivAmRYnHqVcTSMruezYVeiHRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB2666
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

VGhhbmtzLCBQYXZlbCwgZm9yIHRoZSByZWNvbW1lbmRhdGlvbiENCldlIGFyZSBzdXBlciBpbnRl
cmVzdGVkIGluIGNvbGxhYm9yYXRpbmcgb24gdGhpcyAtIHdlIGFyZSB3b3JraW5nIG9uIHRoZSBw
cm90b3R5cGUgb2YgeW91ciByZWNvbW1lbmRhdGlvbiBidXQgbW92aW5nIGEgbGl0dGxlIGJpdCBz
bG93IGR1ZSB0byB2YWNhdGlvbiBhbmQgcmVzb3VyY2VzLg0KDQpUaGFua3MsDQpXaWxzb24NCg0K
LS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCkZyb206IFBhdmVsIEJlZ3Vua292IDxhc21sLnNp
bGVuY2VAZ21haWwuY29tPiANClNlbnQ6IFRodXJzZGF5LCBKdW5lIDIzLCAyMDIyIDM6MzUgQU0N
ClRvOiBGYW5nLCBXaWxzb24gPHdpbHNvbi5mYW5nQGludGVsLmNvbT47IGlvLXVyaW5nQHZnZXIu
a2VybmVsLm9yZw0KQ2M6IEplbnMgQXhib2UgPGF4Ym9lQGtlcm5lbC5kaz4NClN1YmplY3Q6IFJl
OiBkbWFfYnVmIHN1cHBvcnQgd2l0aCBpb191cmluZw0KDQpPbiA2LzIzLzIyIDA3OjE3LCBGYW5n
LCBXaWxzb24gd3JvdGU6DQo+IEhpIEplbnMsDQo+IA0KPiBXZSBhcmUgZXhwbG9yaW5nIGEga2Vy
bmVsIG5hdGl2ZSBtZWNoYW5pc20gdG8gc3VwcG9ydCBwZWVyIHRvIHBlZXIgZGF0YSB0cmFuc2Zl
ciBiZXR3ZWVuIGEgTlZNZSBTU0QgYW5kIGFub3RoZXIgZGV2aWNlIHN1cHBvcnRpbmcgZG1hX2J1
ZiwgY29ubmVjdGVkIG9uIHRoZSBzYW1lIFBDSWUgcm9vdCBjb21wbGV4Lg0KPiBOVk1lIFNTRCBE
TUEgZW5naW5lIHJlcXVpcmVzIHBoeXNpY2FsIG1lbW9yeSBhZGRyZXNzIGFuZCB0aGVyZSBpcyBu
byBlYXN5IHdheSB0byBwYXNzIG5vbiBzeXN0ZW0gbWVtb3J5IGFkZHJlc3MgdGhyb3VnaCBWRlMg
dG8gdGhlIGJsb2NrIGRldmljZSBkcml2ZXIuDQo+IE9uZSBvZiB0aGUgaWRlYXMgaXMgdG8gdXNl
IHRoZSBpb191cmluZyBhbmQgZG1hX2J1ZiBtZWNoYW5pc20gd2hpY2ggaXMgc3VwcG9ydGVkIGJ5
IHRoZSBwZWVyIGRldmljZSBvZiB0aGUgU1NELg0KDQpJbnRlcmVzdGluZywgdGhhdCdzIHF1aXRl
IGFsaWducyB3aXRoIHdoYXQgd2UncmUgZG9pbmcsIHRoYXQgaXMgYSBtb3JlIGdlbmVyaWMgd2F5
IGZvciBwMnAgd2l0aCBzb21lIG5vbi1wMnAgb3B0aW1pc2F0aW9ucyBvbiB0aGUgd2F5Lg0KT3Vy
IGFwcHJvYWNoIHdlIHRyaWVkIGJlZm9yZSBpcyB0byBsZXQgdXNlcnNwYWNlIHRvIHJlZ2lzdGVy
IGRtYS1idWYgZmQgaW5zaWRlIGlvX3VyaW5nIGFzIGEgcmVnaXN0ZXIgYnVmZmVyLCBwcmVwYXJl
IGV2ZXJ5dGhpbmcgaW4gYWR2YW5jZSBsaWtlIGRtYWJ1ZiBhdHRhY2gsIGFuZCB0aGVuIHJ3L3Nl
bmQvZXRjLiBjYW4gdXNlIHRoYXQuDQoNCj4gVGhlIGZsb3cgaXMgYXMgYmVsb3c6DQo+IDEuIEFw
cGxpY2F0aW9uIHBhc3NlcyB0aGUgZG1hX2J1ZiBmZCB0byB0aGUga2VybmVsIHRocm91Z2ggbGli
dXJpbmcuDQo+IDIuIElvX3VyaW5nIGFkZHMgdHdvIG5ldyBvcHRpb25zIElPUklOR19PUF9SRUFE
X0RNQSBhbmQgSU9SSU5HX09QX1dSSVRFX0RNQSB0byBzdXBwb3J0IHJlYWQgd3JpdGUgb3BlcmF0
aW9ucyB0aGF0IERNQSB0by9mcm9tIHRoZSBwZWVyIGRldmljZSBtZW1vcnkuDQo+IDMuIElmIHRo
ZSBkbWFfYnVmIGZkIGlzIHZhbGlkLCBpb191cmluZyBhdHRhY2hlcyBkbWFfYnVmIGFuZCBnZXQg
c2dsIHdoaWNoIGNvbnRhaW5zIHBoeXNpY2FsIG1lbW9yeSBhZGRyZXNzZXMgdG8gYmUgcGFzc2Vk
IGRvd24gdG8gdGhlIGJsb2NrIGRldmljZSBkcml2ZXIuDQo+IDQuIE5WTWUgU1NEIERNQSBlbmdp
bmUgRE1BIHRoZSBkYXRhIHRvL2Zyb20gdGhlIHBoeXNpY2FsIG1lbW9yeSBhZGRyZXNzLg0KPiAN
Cj4gVGhlIHJvYWQgYmxvY2tlciB3ZSBhcmUgZmFjaW5nIGlzIHRoYXQgZG1hX2J1Zl9hdHRhY2go
KSBhbmQgZG1hX2J1Zl9tYXBfYXR0YWNobWVudCgpIEFQSXMgZXhwZWN0cyB0aGUgY2FsbGVyIHRv
IHByb3ZpZGUgdGhlIHN0cnVjdCBkZXZpY2UgKmRldiBhcyBpbnB1dCBwYXJhbWV0ZXIgcG9pbnRp
bmcgdG8gdGhlIGRldmljZSB3aGljaCBkb2VzIHRoZSBETUEgKGluIHRoaXMgY2FzZSB0aGUgYmxv
Y2svTlZNZSBkZXZpY2UgdGhhdCBob2xkcyB0aGUgc291cmNlIGRhdGEpLg0KPiBCdXQgc2luY2Ug
aW9fdXJpbmcgb3BlcmF0ZXMgYXQgdGhlIFZGUyBsYXllciB0aGVyZSBpcyBubyBzdHJhaWdodCBm
b3J3YXJkIHdheSBvZiBmaW5kaW5nIHRoZSBibG9jay9OVk1lIGRldmljZSBvYmplY3QgKHN0cnVj
dCBkZXZpY2UqKSBmcm9tIHRoZSBzb3VyY2UgZmlsZSBkZXNjcmlwdG9yLg0KPiANCj4gRG8geW91
IGhhdmUgYW55IHJlY29tbWVuZGF0aW9ucz8gTXVjaCBhcHByZWNpYXRlZCENCg0KRm9yIGZpbmRp
bmcgYSBkZXZpY2UgcG9pbnRlciwgd2UgYWRkZWQgYW4gb3B0aW9uYWwgZmlsZSBvcGVyYXRpb24g
Y2FsbGJhY2suIEkgdGhpbmsgdGhhdCdzIG11Y2ggYmV0dGVyIHRoYW4gcGFyc2luZyBpdCBvbiB0
aGUgaW9fdXJpbmcgc2lkZSwgZXNwZWNpYWxseSBzaW5jZSB3ZSBuZWVkIGEgZ3VhcmFudGVlIHRo
YXQgdGhlIGRldmljZSBpcyB0aGUgb25seSBvbmUgd2hpY2ggd2lsbCBiZSB0YXJnZXRlZCBhbmQg
d29uJ3QgY2hhbmdlIChlLmcuIG5ldHdvcmsgbWF5IGNob29zZSBhIGRldmljZSBkeW5hbWljYWxs
eSBiYXNlZCBvbiB0YXJnZXQgYWRkcmVzcykuDQoNCkkgdGhpbmsgd2UgaGF2ZSBzcGFjZSB0byBj
b29wZXJhdGUgaGVyZSA6KQ0KDQotLQ0KUGF2ZWwgQmVndW5rb3YNCg==
