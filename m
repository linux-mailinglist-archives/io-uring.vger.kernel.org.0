Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CA8577652E
	for <lists+io-uring@lfdr.de>; Wed,  9 Aug 2023 18:33:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229669AbjHIQdk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Aug 2023 12:33:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbjHIQdj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Aug 2023 12:33:39 -0400
Received: from mx0a-003b2802.pphosted.com (mx0a-003b2802.pphosted.com [205.220.168.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3CF71B2
        for <io-uring@vger.kernel.org>; Wed,  9 Aug 2023 09:33:38 -0700 (PDT)
Received: from pps.filterd (m0278966.ppops.net [127.0.0.1])
        by mx0a-003b2802.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 379GEht5016243;
        Wed, 9 Aug 2023 10:33:32 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=micron.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=sddH1AL9LxGVvFaKuW27sk3WVDC6Kz6HgbbXQ7RMDxU=;
 b=Q/ng5RwWuOVxTnU53PIUIZJiFcjAwxrySWBZYIDPvFAidv6EU1byACfbCGDOohYh5iHs
 OQSPTfFs2/aP15nXpkKpjfR76dcpaG7nPv+xhDFukx5qHoVcwTXIzsfhfWcTq3J70+CM
 xEbX5WMxH5XP0sHOKl6itUAdgCenIgaHbCp7VL7XvZ4/M6xX94O34wjxpk00zIArRFgC
 m0LMyW+nFhdShWdMF1H3CZG9ROfKYp1XvlbgcsTOICdjwhj+OcHehWbACE4sVarB3Owm
 CL+ZDL3T0umNYstq55Tt9fFY6CjJq9h2Nn+KiAdoNc/kYMGI88Ue98w2/8JL43suiDCX /g== 
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2171.outbound.protection.outlook.com [104.47.56.171])
        by mx0a-003b2802.pphosted.com (PPS) with ESMTPS id 3s9k1cs78b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Aug 2023 10:33:32 -0600
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FW94LFsuyoPU3UZ6bB9M+9tvTFvSl2+dRswml6ySFWR7Fyn/FkV8r/+yW8QHLFGRv+r90jky2ND0MySu+1IyaClUejNEk+t515JPmBIs82NBMp/GtVm4sKWz/FqTtzMqUUEhUkDaH6IRUrucBKhzcF7eSqtg4xzxG573/ed4y8VUhjH0rjnGzDb6a0sr1/fZTYHsSvDEK80XDfFXj8YxnjOomid/I8PE08wGKpgdDW8tpFPqEfryfmHHhCXLX6WVGk41LVR0PzUNBSFodCWAnRBmFO7y/HP12NhTBaah+7UhKOc819xnqISvsF5/pQ8S4c6s3ePQr1OJF8iumeowYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sddH1AL9LxGVvFaKuW27sk3WVDC6Kz6HgbbXQ7RMDxU=;
 b=DSj9aHxlV1nQk1yV8UUwWLs6LPuoxYklcIgBzgSfvxodC/Bg+Z6i16+SKjMLlGUiphhk34aBLVw0VUYtlgCOqp8epC8AUJLszdAPUIMLoZQUZ1gRJ2YTPiQoKqQGxdqSQ+rfq5EGfAIW8nowQLU11QuXHfNuf8oeoW6uJ3aNzBuD+6ddAzwfE7U5g1eIAl6Ge6eDbhS8q3ilDiBC/50ZUe96Tdr1q7adLBw4A6vJMtCLiIc5M+izVUNKZ0N2XNp5jC6oDZsr077+C/FqJQyDEAVLKOtaWq61+XBowqzdh/7hD/3prWE28lPbRFfLL+v2Y8NnFsK+s+VHOhl5Wxhocw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=micron.com; dmarc=pass action=none header.from=micron.com;
 dkim=pass header.d=micron.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=micron.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sddH1AL9LxGVvFaKuW27sk3WVDC6Kz6HgbbXQ7RMDxU=;
 b=deRLoJjF9OKTwM3VPQK6+bwcYsWN9Kr0+V9HhdrcYMRq/tAJrr9pwia6YDEhMjY60g3SLiaWVJETR4R4w4VyGCuthMDte2ABiRPVffraOJMYApCko80T+Dwxc4rx4TDblZPhKhXfGlI8tEI4WK0wbsOnwUPIh02f3hbw5GoVyBhwZvdxscpHghnFwiCnKcRoiXis4w8y8WVfb0v3dBUSeLzX/iYHqWH93vFch2aZuURIAcfRfNXVzjRBj1jg99A0CPQlovFsFN82UhmYJqCieYp6EKYNAbSnloGUFRiwKdqhZzjrZTwitpxLnTOIQSifYOGiZE7tldwjAa3LgETLXA==
Received: from SJ0PR08MB6494.namprd08.prod.outlook.com (2603:10b6:a03:2d9::14)
 by SJ0PR08MB6734.namprd08.prod.outlook.com (2603:10b6:a03:2ad::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.28; Wed, 9 Aug
 2023 16:33:28 +0000
Received: from SJ0PR08MB6494.namprd08.prod.outlook.com
 ([fe80::355d:a74a:5fc8:8b3]) by SJ0PR08MB6494.namprd08.prod.outlook.com
 ([fe80::355d:a74a:5fc8:8b3%6]) with mapi id 15.20.6652.026; Wed, 9 Aug 2023
 16:33:28 +0000
From:   Pierre Labat <plabat@micron.com>
To:     Jens Axboe <axboe@kernel.dk>, Jeff Moyer <jmoyer@redhat.com>
CC:     "'io-uring@vger.kernel.org'" <io-uring@vger.kernel.org>
Subject: RE: [EXT] Re: FYI, fsnotify contention with aio and io_uring.
Thread-Topic: [EXT] Re: FYI, fsnotify contention with aio and io_uring.
Thread-Index: AdnG+3NTgdyJzbysQdOcb9jFxiDj+QCbxOsqADWgZoAAJlCnoA==
Date:   Wed, 9 Aug 2023 16:33:28 +0000
Message-ID: <SJ0PR08MB649422919BA3E86C48E83340AB12A@SJ0PR08MB6494.namprd08.prod.outlook.com>
References: <SJ0PR08MB6494F5A32B7C60A5AD8B33C2AB09A@SJ0PR08MB6494.namprd08.prod.outlook.com>
 <x49pm3y4nq5.fsf@segfault.boston.devel.redhat.com>
 <65911cc1-5b3f-ff5f-fe07-2f5c7a9c3533@kernel.dk>
In-Reply-To: <65911cc1-5b3f-ff5f-fe07-2f5c7a9c3533@kernel.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_37874100-6000-43b6-a204-2d77792600b9_ActionId=19c09be4-29d0-43b3-a342-32c71599c6aa;MSIP_Label_37874100-6000-43b6-a204-2d77792600b9_ContentBits=0;MSIP_Label_37874100-6000-43b6-a204-2d77792600b9_Enabled=true;MSIP_Label_37874100-6000-43b6-a204-2d77792600b9_Method=Standard;MSIP_Label_37874100-6000-43b6-a204-2d77792600b9_Name=Confidential;MSIP_Label_37874100-6000-43b6-a204-2d77792600b9_SetDate=2023-08-09T15:58:09Z;MSIP_Label_37874100-6000-43b6-a204-2d77792600b9_SiteId=f38a5ecd-2813-4862-b11b-ac1d563c806f;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR08MB6494:EE_|SJ0PR08MB6734:EE_
x-ms-office365-filtering-correlation-id: b3547b01-6571-40ac-0ead-08db98f65cb8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5ISi/e0MuMTZlDdlztE+HWyCnxcue2DS2JzEtdwqOdsnmebN3YR/I9ckg7KfMxYDk3Tyay+zeXmHarFhyQUdrG1mtm9qQpXYtVPOauTdJjm8L53CHrKM/jlOj/m7JFmOYJVkOFWj3uG5TQmK1+SLvGFO6McEaBIx+nAY2w9m5DIot63YuATpTTP1hijOQuRHizvjZBgJYuNiE6QjlRPvT1/6lEmROU9cjx2s3HwCOsGvp9X6J5WOQS2avErVXy5SgDkQ4HOPIgcJ7rcKxQJe7rRHzRkMeYmiNcNUTTQ5NB9uBb+rt0/d7nphloR9oaXyc2HwJBc7FPj0m0/4lAR6nzb13w+J408iu6ANswVq/tp57VXfSIdMbVELc604wO100jVjSulIV3X94rtIiBB8yM2AvvcQq7frTJi8D/ECcQRH1Lj/4cLycXQ8IJIxc6D7V14hwf/yyNwo1LJnAVPH4O+JJXMR941GQr4z+f3vJzqVSi5wlac7i329m/FFoPiBbVxxMNyohlRhxK+NjxEAGmzNdOMmjAYQzwxh/egfgpqCt/vl6/r0yM/7W04Rhzy/2w1+2UwXoi6g9fD8PbPWReK1MTBgQvnN9VCZULJP+d6y5vTozrj+7U6f+WjB0jfg
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR08MB6494.namprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(376002)(346002)(366004)(396003)(136003)(186006)(451199021)(1800799006)(83380400001)(478600001)(122000001)(9686003)(6506007)(26005)(55016003)(53546011)(33656002)(66946007)(8936002)(41300700001)(316002)(8676002)(76116006)(2906002)(66556008)(66476007)(64756008)(66446008)(4326008)(71200400001)(7696005)(110136005)(38100700002)(5660300002)(86362001)(38070700005)(52536014);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-7?B?RVdHdE1YTVk3cm51ckF2U2F2M21qWVlpN0liOHFyNURJdjl5c1VMTWlvMnBj?=
 =?utf-7?B?U2xlUjJuMHd2azNvNHV3Uk9xb29CSTJFY0ZMZDRXMjZ4bHlGczN6TmVKbExN?=
 =?utf-7?B?cGQ5djRmWTQ3SjB4UXI4U0pBL20vODRPdFZaY3EzeEI1Z042RTNTKy1CUk8z?=
 =?utf-7?B?NEZySHVDcW1wMDIydTVuQUNXZnlQbld6SHg4TU9Tcy9HY2l0LzFlcmVXLzQ4?=
 =?utf-7?B?bFNhRkZTTjNoQnZ0dTEvTzEyMy9XMmszVFA2SlBpNGpMV0tjY002elpLck94?=
 =?utf-7?B?bDVQd3YwRDBMNkFJR1h4SlkzMUcwUVhtY2tabFprUURjWFFLak5OQ1g3WFRy?=
 =?utf-7?B?UzJOcUFaL2E1amFQQm8yaS9BalZMZkhraEJFcUYwenJXLzU3UExLbS9jVUlj?=
 =?utf-7?B?VHZhOHg4cGQ5S3phZVRQZzUzL0g3clBLWDdYc2haSVVEcE5uOEJXVDBRQjI5?=
 =?utf-7?B?ZkVKVk5SQ1liL2J2VkE3UDB4Zno2ZUE3MkNMdDZDWnNsdm04Z25pMTB5RTQz?=
 =?utf-7?B?ME9TbE50elJYTEpscFlOREdDWUZrT3NOeFlkSjY0Y3E5Ky1selVhREhjemRp?=
 =?utf-7?B?d2pPRmhGWXpEUk9aV2lWOTNURnJNeUxTbUd1cEZ3dzdyTkVPeGVQaWhOM01h?=
 =?utf-7?B?Rm8rLUoySDA4NTNEelhUR3RCcHdvS1hHby9GaUtkTWhaYWZVVnpIcUFmRzhi?=
 =?utf-7?B?QlM3TElRaW5ic2prM1JiY09UbWViOCstRDlpczRraWc0WnpRRGVxL1ZydVll?=
 =?utf-7?B?NzRpd1RDdmh1RU1LaHlBNU9pMDJXSHgzSlFWc0tWV0xkYWhleGRSWVFxNTVz?=
 =?utf-7?B?b3dPbkpJUkFtQkZuSGxLckFUN1BWV3dPMFFlNFB4ODZzZmV2Y3hLVTBPSmlC?=
 =?utf-7?B?MVUyTElvZDhjbTA0U1NKMDdUcGJDclNtMjI5aThiMGNjRlYvbVhNc1VDQW9V?=
 =?utf-7?B?cGptNXpGMHBzdkczcWs0Uk5RR3UzSG5rNDdUdmVlNWliVk8vUUVSdlZ1bWRw?=
 =?utf-7?B?YVdJcHBMRlFjZElwTmczZVgrLTl5Z1JPWjFuNkxMYjBuNUJFN1ZlSHlSakpr?=
 =?utf-7?B?V0pTWlNiMXgzV3lPUk5iVHBlM1BOQ1NYUUpUM2luN2ZvOFlxZ0FsVzlPWWVu?=
 =?utf-7?B?d3pFeUdLc0c1VystYVVuVWNUaVEzSFdZQzdFaHdMKy0yNjM2cUxSdHJtZy8x?=
 =?utf-7?B?Vmw2OTF2TVNLODJDbEpFNmd2UHkzNHJqMUFNR2liRXdWTGdQUlAxNERsbi83?=
 =?utf-7?B?TnlSUU04NUVzMGR3S1hPQ1QrLTFYRTZ5dm5pU2VTcHVOZlAwVmUxTEd0cXZ2?=
 =?utf-7?B?S25UTFM4MDA1Z1BKQkZXemRYeGlhNXZybHREVkd4RVhqTUlQOE1QV3VMRnNV?=
 =?utf-7?B?bktkdnhHTVB3NDNRMGlBSGdZQk5CSmIveXQyajJSRFRkSTJzOXpJUEZrS3RJ?=
 =?utf-7?B?czJDb3I4YU9ZZlZJUjJYN1d5Ukk1c3NoS0hTVzkwY1JlMGpFS29BU1BWWDZr?=
 =?utf-7?B?dWE1MUZ1TncvaVNIMmJLYjlzck5LeXFVUmlrRHN4bzZrWDlkazBNSGJ1SGJu?=
 =?utf-7?B?dHcxa2d5S09iMHZXVFhjUGVaaTZzKy1Qak9mRm1QVmdlbFdmYWx5RDVVeTli?=
 =?utf-7?B?VWdjWXhjTXRnU1dGUldCNmJDKy1nKy1mbXExMW5VOTZFQmsxRUhiQVVhRFlh?=
 =?utf-7?B?QlQvYnU5enYxT3VmZzRSSFUyMDBGSFpURGk4cTlRalVIZmxKa2U1bkpjU093?=
 =?utf-7?B?ZjJGc0pLak0wVXFpTHVvRUJQbVdBdS9FbXViSGUya2RkKy10NDFsZURmQy9D?=
 =?utf-7?B?ZGhkZnJQRU5ObmVHMlRMNlMzU3dHbkh4eEs1dWU1QjZrNzFsTSstT0Y2a05q?=
 =?utf-7?B?Uzh0R2pwQ0hGKy1sSVo5RDdFazRmRmo5U1JreGIxdVlRZzY3aDZvN0t0QTJS?=
 =?utf-7?B?SE9FUDYzbG1JUkJhamdKalpqMWR4cWkxUDc2amJ1eTJ2UWIwSmx0TEV3b2pU?=
 =?utf-7?B?ZHRqQ1VmU3NtWVZPeFVyUHpBTGpnSkZwU3kvL1VoKy01WTVMbW9rRmx4dVFu?=
 =?utf-7?B?ZFZnRXd5ZkJCVURKRWJScDRhNzc5Q2QwUWNKOUVoc241SzVScW1pckZCRXox?=
 =?utf-7?B?R0VKY0hxWTloaDIzOXRoeFNkNCtBRDAt?=
Content-Type: text/plain; charset="utf-7"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: micron.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR08MB6494.namprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3547b01-6571-40ac-0ead-08db98f65cb8
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Aug 2023 16:33:28.7577
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f38a5ecd-2813-4862-b11b-ac1d563c806f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pIot3yWe3IXBI9JlIhz9Q3R4Pah6WwRlGQetS5Q5+P5coZOpzeuWBhZX4Pmap4spEAEJi/oWL1iQposYMAkjfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR08MB6734
X-Proofpoint-GUID: Ev7h15HictuU7aTssghUUKmnU65yFoJN
X-Proofpoint-ORIG-GUID: Ev7h15HictuU7aTssghUUKmnU65yFoJN
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Micron Confidential

Hi Jeff and Jens,

About +ACI-FAN+AF8-MODIFY fsnotify watch set on /dev+ACI-.

Was using Fedora34 distro (with 6.3.9 kernel), and fio. Without any particu=
lar/specific setting.
I tried to see what could watch /dev but failed at that.
I used the inotify-info tool, but that display watchers using the inotify i=
nterface. And nothing was watching /dev via inotify.
Need to figure out how to do the same but for the fanotify interface.
I'll look at it again and let you know.

Regards,

Pierre



Micron Confidential
+AD4- -----Original Message-----
+AD4- From: Jens Axboe +ADw-axboe+AEA-kernel.dk+AD4-
+AD4- Sent: Tuesday, August 8, 2023 2:41 PM
+AD4- To: Jeff Moyer +ADw-jmoyer+AEA-redhat.com+AD4AOw- Pierre Labat +ADw-p=
labat+AEA-micron.com+AD4-
+AD4- Cc: 'io-uring+AEA-vger.kernel.org' +ADw-io-uring+AEA-vger.kernel.org+=
AD4-
+AD4- Subject: +AFs-EXT+AF0- Re: FYI, fsnotify contention with aio and io+A=
F8-uring.
+AD4-
+AD4- CAUTION: EXTERNAL EMAIL. Do not click links or open attachments unles=
s you
+AD4- recognize the sender and were expecting this message.
+AD4-
+AD4-
+AD4- On 8/7/23 2:11?PM, Jeff Moyer wrote:
+AD4- +AD4- Hi, Pierre,
+AD4- +AD4-
+AD4- +AD4- Pierre Labat +ADw-plabat+AEA-micron.com+AD4- writes:
+AD4- +AD4-
+AD4- +AD4APg- Hi,
+AD4- +AD4APg-
+AD4- +AD4APg- This is FYI, may be you already knows about that, but in cas=
e you
+AD4- don't....
+AD4- +AD4APg-
+AD4- +AD4APg- I was pushing the limit of the number of nvme read IOPS, the=
 FIO +-
+AD4- +AD4APg- the Linux OS can handle. For that, I have something special =
under the
+AD4- +AD4APg- Linux nvme driver. As a consequence I am not limited by what=
ever the
+AD4- +AD4APg- NVME SSD max IOPS or IO latency would be.
+AD4- +AD4APg-
+AD4- +AD4APg- As I cranked the number of system cores and FIO jobs doing d=
irect 4k
+AD4- +AD4APg- random read on /dev/nvme0n1, I hit a wall. The IOPS scaling =
slows
+AD4- +AD4APg- (less than linear) and around 15 FIO jobs on 15 core threads=
, the
+AD4- +AD4APg- overall IOPS, in fact, goes down as I add more FIO jobs. For=
 example
+AD4- +AD4APg- on a system with 24 cores/48 threads, when I goes beyond 15 =
FIO jobs,
+AD4- +AD4APg- the overall IOPS starts to go down.
+AD4- +AD4APg-
+AD4- +AD4APg- This happens the same for io+AF8-uring and aio. Was using ke=
rnel version
+AD4- 6.3.9. Using one namespace (/dev/nvme0n1).
+AD4- +AD4-
+AD4- +AD4- +AFs-snip+AF0-
+AD4- +AD4-
+AD4- +AD4APg- As you can see 76+ACU- of the cpu on the box is sucked up by
+AD4- +AD4APg- lockref+AF8-get+AF8-not+AF8-zero() and lockref+AF8-put+AF8-r=
eturn().  Looking at the
+AD4- +AD4APg- code, there is contention when IO+AF8-uring call fsnotify+AF=
8-access().
+AD4- +AD4-
+AD4- +AD4- Is there a FAN+AF8-MODIFY fsnotify watch set on /dev?  If so, i=
t might be
+AD4- +AD4- a good idea to find out what set it and why.
+AD4-
+AD4- This would be my guess too, some distros do seem to do that. The
+AD4- notification bits scale horribly, nobody should use it for anything h=
igh
+AD4- performance...
+AD4-
+AD4- --
+AD4- Jens Axboe

