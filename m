Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C01C4E5237
	for <lists+io-uring@lfdr.de>; Wed, 23 Mar 2022 13:33:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234980AbiCWMed (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Mar 2022 08:34:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231716AbiCWMec (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Mar 2022 08:34:32 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14442B1E
        for <io-uring@vger.kernel.org>; Wed, 23 Mar 2022 05:33:02 -0700 (PDT)
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22NBvRER000677;
        Wed, 23 Mar 2022 12:33:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : date :
 message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version : subject; s=pp1;
 bh=a6BbIpZPVTzO426L27r055kUsi/uOJEqtexBvgGkcgE=;
 b=j0P8cqmkYBf5XxToyQkN2nHc3lmFIBNRved2hLAYz6zlmWWmBLm5zjXtah0wCOODm1T+
 ZHQLZy4zqc7+43Nl+b7xy2TFeVYl4Y7YDWxBhEHjc4oEwK50g1GZyv7woICzvmFKIcs8
 ypPpzB0IHoefRdrhcKm3RT7lHsSusqiKiTes/19QDtXQTqUG+c8UpuCM++YE9AQNOJDe
 n8rVp56/pwMVDNG4Nr6Tv+2KzrFCK0ja/ybtoeP8/KKPPipSGT6RgQ12EnpBeKK9rni9
 i5ATfYEFLdRcsu3LhpQBh20N5aYmGWUS+0s/cKSegwZPLBiKCznrYrhJpupwGvtQAYM1 Og== 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2170.outbound.protection.outlook.com [104.47.58.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f000ymwtp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Mar 2022 12:33:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G/KobKgGN2/EICkVWuTWHHpmhK24wCRv9XOpQOigETDSA9FjU44JodUPeiYYFUc0aZVJNJggtrR1BxofMj8e5OXsie7z1brEZTlfU/bUqCi1vag9twLyRtq04B8yf6GPeb80yo+hbwUci+0ClsbTdAklM1aUk5lze2BJKrFvwcvngmN7hQ/hUcwF4wKsRVvjiiLxpS6lIQI0vD+vycKFm8zEEN8ckdQwzd7KNQyP12Vs5gLyVCQ3utQSRVruqcwWabGot+w48R4bVrDNiAc/PrShvzUYyQp8qN/hI0cJ/SqFNYhjPnDMb+j6r1QE40QwngB0CJESGcEnOv3Pevtxog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a6BbIpZPVTzO426L27r055kUsi/uOJEqtexBvgGkcgE=;
 b=ESbmko6fARpwHtpG8gEPfD/0TVblcWcWtPEI1Ww3hK/XVOS9I98tduk/H+dLFDL03NaTYPKidA15zKI8NkiGJjWrMI32E6USwi9WaS5sASzAR1zv8x3NbD8r1zT2xhgUXXSg8olBrNhx9pGiBvFXrKH3sNwsVQ+enBZgyt5aGNp9kutFjS2wygIXw9B7wFPelkCxjnDa2zFDjZyl519bUHi6NBkaB1Sx1n0ZNOthiTuC/3qqKlo35Xo9HjugpTEXtr/9frFACkjxo6G2qNm1DtvA/V6zjGQpPPPZDG2IlNV4zBO0q0YetFUoshSpFGIl9mHxC/DATKKJXW8zUIZiQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=il.ibm.com; dmarc=pass action=none header.from=il.ibm.com;
 dkim=pass header.d=il.ibm.com; arc=none
Received: from DM6PR15MB2603.namprd15.prod.outlook.com (2603:10b6:5:1b0::10)
 by PH0PR15MB5142.namprd15.prod.outlook.com (2603:10b6:510:12b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.17; Wed, 23 Mar
 2022 12:32:59 +0000
Received: from DM6PR15MB2603.namprd15.prod.outlook.com
 ([fe80::2047:9a5b:3129:a252]) by DM6PR15MB2603.namprd15.prod.outlook.com
 ([fe80::2047:9a5b:3129:a252%5]) with mapi id 15.20.5102.017; Wed, 23 Mar 2022
 12:32:58 +0000
From:   Constantine Gavrilov <CONSTG@il.ibm.com>
To:     Jens Axboe <axboe@kernel.dk>
CC:     "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
Thread-Topic: [EXTERNAL] Re: io_uring_enter() with opcode IORING_OP_RECV
 ignores MSG_WAITALL in msg_flags
Thread-Index: AQHYPp+rWpmg9Ozk+UOXmXHWCXGN8azM4x6AgAAAsEU=
Date:   Wed, 23 Mar 2022 12:32:58 +0000
Message-ID: <DM6PR15MB2603FB4275378379A6010323FA189@DM6PR15MB2603.namprd15.prod.outlook.com>
References: <BYAPR15MB260078EC747F0F0183D1BB1BFA189@BYAPR15MB2600.namprd15.prod.outlook.com>
 <7e6f6467-6ac2-3926-9d7b-09f52f751481@kernel.dk>
In-Reply-To: <7e6f6467-6ac2-3926-9d7b-09f52f751481@kernel.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f3ff4009-b8f5-4db0-ee28-08da0cc943a9
x-ms-traffictypediagnostic: PH0PR15MB5142:EE_
x-microsoft-antispam-prvs: <PH0PR15MB514284134B3FAFF4ED8E57C8FA189@PH0PR15MB5142.namprd15.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RDIuRsiRgwAyPS0u5ac8nNwgEuDjlcTlzJdU2PCBJ5+xnZ3ZSL3rAiYr9rB+E2HDijw6lZwmSpH5Y9jCAyC0g5pJ0yuQdOvqevGpTlsFsQV16vNeeh4b7CHBiNFQ0J0BDy50uBOMBbaoYG/fkorAynAZEFuC+763epiXy+nv3F7WiS07NEzS42d70IEeMwjmM1qGAVWaPrlk4//ijON/heCcS4ryoOU7xDoipit1OUu8toKoO3HtOe8QrRSIk30xcokKFksduFm81Ys4WiZv4pP5ZPppD2W/9lN1wMwANzdEBygGcG4dDVNZKo0nqluz/MVgXCVKQSjsH+xEVTbL5kmFNUBrarX3U1dYiQYmklN9p5obfNPQpm63FUGFtiTln6qAZ0ufJrBg2KHQwvQkni9NaOLYikDVbvcruJTwITPdwiu2pUA47XUPvJCErwh6HN2OP8KM8OuH4s+lTHjy5H9d3s67b6Chx71o1dMEClwuvZ0Kue86pQYhoZPUTwND78I8zeoF1uYoqNLy7xX8eEBU9ptNVXGqazOc/DmzI1Odvd8O3hyHe0CzTlVKlnbJeUjCcZ3qqwzuI9R1gN1BLjGziaAqDoYN62jHY0vDeyUFqlQyMgwyLLxzV1CNWMSPtynKiajuTGS0XweunqV9okZu+n5FcVF8CGH2+zd/4VbDIWjpdZqSE4ustqkbl6KpCtbbbJir/tlNSzS13RO0ug==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR15MB2603.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(52536014)(33656002)(38100700002)(122000001)(5660300002)(55016003)(86362001)(7696005)(316002)(9686003)(53546011)(6916009)(6506007)(71200400001)(66446008)(91956017)(508600001)(38070700005)(186003)(66476007)(66556008)(66946007)(8936002)(4326008)(83380400001)(2906002)(8676002)(76116006)(64756008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?kfB/J9DrxY38LD7GjZnN83tur6XTx/0oA7fyAZkXm3ED0doxQNqkRf+5AN?=
 =?iso-8859-1?Q?GyH5skeS1Y2P82BjTCsfYZ2fMdydHBZoQjw2zXwsYtOPlECQ72vEbgnkzm?=
 =?iso-8859-1?Q?I+Pj6mS4iuQUtSkrHvCdMQuS8qj8/76wvWHQrWc0fE8/TYxkL01tHUGSVa?=
 =?iso-8859-1?Q?Z+VRGjWrDk264BpKxQkhi2BWDbrGU0/POugDN+iZZHHX2IAuXyEnhb5bWJ?=
 =?iso-8859-1?Q?N6j9DojySfeYMlBvHEszxBwDx232fLn/tcjzT+hG5DkoAsiFupIRbkYezi?=
 =?iso-8859-1?Q?PkPUj5oPVS3+Y8bulVhmB1eOW1FJ1pLGgRJD20jseoQBQAy5L8FKZaExWB?=
 =?iso-8859-1?Q?6heE8aAtT+ExiNb1g/g5uULA3K2S8fA0jhLliYQ4Pm+jOWf6u544aDMCei?=
 =?iso-8859-1?Q?qeo6D4j9hYVUqkG/RQ/qEcMbzvWHEhKtgMrTOoNSO7vOta/86mrV7cGRDz?=
 =?iso-8859-1?Q?TkzWD6WAqy8839ZLAVwFg4RXRtOkawVWO4L99I4xsXqw6Uz+y43e5cotEy?=
 =?iso-8859-1?Q?4eFhTDhgBRPzDd0FDE/KcTPKibwMdzA5LV3LMUNPz+JykBLk3ISI2y65pa?=
 =?iso-8859-1?Q?0Eh8HvJB8OElFpw8bOaYvIPDkE7Hq2VScitrwb2kHhU/reH3h2opfWhkH2?=
 =?iso-8859-1?Q?zRiiTKr0qXIGg0kstFODXsSi7zleQ/8vyMEsDy5AmsDyOes/YCOb1lfxQV?=
 =?iso-8859-1?Q?TEqi3p1PWaxBOKiioVOYmNWdHKVPqFgaU/MYkrLUJpjTWfGGq73eLYZnN4?=
 =?iso-8859-1?Q?lc/5r5AMpEFVlPOBOFMFQ7m29SSpfCugx1tTyLfzWOkPYxJclsvCSidCEN?=
 =?iso-8859-1?Q?7wMSNdv7xEudJglH6VJG0i+MGK3tb1LxoPbiufRSaAznsb82MsbaQYFTak?=
 =?iso-8859-1?Q?OZ8FewpvGi9KRYFfAr4iuy4b4SGrjPCUGwS8iGdXg07oAuwYj2fs5q3vCl?=
 =?iso-8859-1?Q?qk3BxvS+4EMMQC5XVAuE6Q26YkP90H0NwVfuTKAiqercQu6hHV3/98ngvt?=
 =?iso-8859-1?Q?RDLw6md5IrEezvpqBlKdG05RrDsQv66ACCGl/E9aGFNhuQ2Wn2WZ5mB1z4?=
 =?iso-8859-1?Q?MLN2c9THFHJ2K8mPa0E36Zqlr9HvF/pfq8DSh4T/MkltkAyAuKKprCYK0g?=
 =?iso-8859-1?Q?y6Sv/IUo73avXdbXtPjsES7AnyeKcPoSinxj09qs6SoKRa7T+OjmHhvYnv?=
 =?iso-8859-1?Q?lLgh91qu4NuiCklUEwAkS2E62k3CuvfmSJQoXOwSnBwrS7eNYY+I5uYVae?=
 =?iso-8859-1?Q?zX30RU0WUCEun4sOIuWljhwcQKl98D185/Hseb4Lh69XLICsbl7A3+22sc?=
 =?iso-8859-1?Q?30TetV92Zu2KwZJoNSFqAMDeRsBb94+768BxJhlm4PhS/CZzkMBL++Na1h?=
 =?iso-8859-1?Q?hFN9L/LIAnTStvByRKpzB0NX/drdKrIQPYxfuRIkleJFVMQ8ootpFtW6/m?=
 =?iso-8859-1?Q?YMVHHCMpi20yvI0dvxDYK2IBaQwgXMJ2/sIkuRSpmH59lDhWxmA7Yz874/?=
 =?iso-8859-1?Q?2CQzez4IyzGs4r8KGJBKebjKER6FtWRkPsqSC6Ws3B2oVLZ0NU79OFbT6a?=
 =?iso-8859-1?Q?JgFNeQFKK5+p9mG91ZRCNl+HdoHh?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: il.ibm.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR15MB2603.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3ff4009-b8f5-4db0-ee28-08da0cc943a9
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Mar 2022 12:32:58.8891
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xjtzP9xqYL4F9dK26d/thjpCgSz8mRyVQKgRXghL/agqmfoaI6aUXOdUQ5H28F8S8yhDQVGLQSvIoP+w43OmNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR15MB5142
X-Proofpoint-ORIG-GUID: AKnu0vSr2VdvTVysFvLbN67HZXWTwyaX
X-Proofpoint-GUID: AKnu0vSr2VdvTVysFvLbN67HZXWTwyaX
Subject: RE: io_uring_enter() with opcode IORING_OP_RECV ignores MSG_WAITALL in
 msg_flags
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-23_07,2022-03-22_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 spamscore=0 priorityscore=1501 malwarescore=0 phishscore=0 suspectscore=0
 impostorscore=0 clxscore=1011 mlxlogscore=999 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203230072
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Yes, I have a real test case. I cannot share it vebratim, but with a little=
 effort I believe I can come with a simple code of client/server.=0A=
=0A=
It seems the issue shall be directly seen from the implementation, but if i=
t is not so, I will provide a sample code.=0A=
=0A=
Forgot to mention=A0that the issue is seen of Fedora kernel version 5.16.12=
-200.fc35.x86_64.=0A=
=0A=
--=0A=
----------------------------------------=0A=
Constantine Gavrilov=0A=
Storage Architect=0A=
Master Inventor=0A=
Tel-Aviv IBM Storage Lab=0A=
1 Azrieli Center, Tel-Aviv=0A=
----------------------------------------=0A=
=0A=
=0A=
From: Jens Axboe <axboe@kernel.dk>=0A=
Sent: Wednesday, March 23, 2022 14:19=0A=
To: Constantine Gavrilov <CONSTG@il.ibm.com>; linux-kernel@vger.kernel.org =
<linux-kernel@vger.kernel.org>=0A=
Cc: io-uring <io-uring@vger.kernel.org>=0A=
Subject: [EXTERNAL] Re: io_uring_enter() with opcode IORING_OP_RECV ignores=
 MSG_WAITALL in msg_flags =0A=
=A0=0A=
On 3/23/22 4:31 AM, Constantine Gavrilov wrote:=0A=
> I get partial receives on TCP socket, even though I specify=0A=
> MSG_WAITALL with IORING_OP_RECV opcode. Looking at tcpdump in=0A=
> wireshark, I see entire reassambled packet (+4k), so it is not a=0A=
> disconnect. The MTU is smaller than 4k.=0A=
> =0A=
> From the mailing list history, looks like this was discussed before=0A=
> and it seems the fix was supposed to be in. Can someone clarify the=0A=
> expected behavior?=0A=
> =0A=
> I do not think rsvmsg() has this issue.=0A=
=0A=
Do you have a test case? I added the io-uring list, that's the=0A=
appropriate forum for this kind of discussion.=0A=
=0A=
-- =0A=
Jens Axboe=0A=
