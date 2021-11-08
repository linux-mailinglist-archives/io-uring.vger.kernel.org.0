Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7E624498B0
	for <lists+io-uring@lfdr.de>; Mon,  8 Nov 2021 16:45:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235528AbhKHPsD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 8 Nov 2021 10:48:03 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:32794 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236429AbhKHPsD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 8 Nov 2021 10:48:03 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A8FF7ab015676;
        Mon, 8 Nov 2021 15:45:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=zWLRAFolnN2JRJ9s2DCsfv/qwJzFJjVNz90O7EjaQYo=;
 b=QbfeChCxkI1ULEJNh5uOm4diAL0dwv/I0H99EzGjUfwMK9M5LDANkhbQPN6Z64tXb3AT
 oQdIGgLfBwCIXzL5VIc8CAj7PuefuI6wn6E2N3jPrtYBKKvXBvvLGaS0LFg6UpXd3HwB
 p24YL0MJ8tWbAlKBGNVy7GRuCR22f8SGDKuvFpKm3E197VZgI+ZXTuxK1hgRtGsXFvus
 LexoO/xeWGi/2fD+AzC5YZ/caR4aWuGTWwYjN0BjnV5ZYPrdRjuQpTYa1EJDIgb9r5Ex
 FOe7nr0VAQvp3oT/0lC9/Uok3ROBQV6txZAeIc7dE9Ed0nCd50vu5NYvs7KzQ/KDd7t0 4A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3c6uh4bpy6-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 08 Nov 2021 15:45:17 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1A8FKKqF002874;
        Mon, 8 Nov 2021 15:30:39 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2104.outbound.protection.outlook.com [104.47.70.104])
        by aserp3020.oracle.com with ESMTP id 3c5hh24s6j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 08 Nov 2021 15:30:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XWb9uvls1wBp3muX5KkGUrMJuK/ERCwlCticGs6MALniOsB//BKJgelNAK6Kz9wO0AqFMVwp4NAxOyiAo3cQqWCYMbtueqhAeqZ5yGZa5cTy6gdx80henhhPdk9t07XKC9LHc8T62tWSVKExMqDByjKsE+siNL2tiwKXm+0v8PhhajTX+SE5d4z1j9dBZkUI+oYxY3dAKMBUZDImJI2JKyi9jn0w6IwSgUDq8fFZIYPtEM69NLAvFlnFj8xtJjUeop3X2y9tVdIYCv62942NptHCKRv5Wdb+85C0Y6R2TYf/iDoJwdGDC1junIjedRy4/1BfNrVIYJtWVy+QM9yEBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zWLRAFolnN2JRJ9s2DCsfv/qwJzFJjVNz90O7EjaQYo=;
 b=JyrcaW9EKTHtKmSyBxZaK51lLLolR/c6UVU2Xc//prP+O929IEsXHmv9/7qw6KkQPprGD7WQqcDa1E2kUR+4T8KfnQFypdCFqfsucig1s7u7iaQKr1UxnYp231QEWrqQ4ERb08hRnb0EiQExR4E5yNZqAxf5Zye5syJ/Gj9xYNyZt6gxDwvZdsqw4abjztT5CnzPk1uPQyGjlX7ivJKDxzSv5v91EwAmXMkdpMWA4mmq83FuEkQ0n5jcvyAIB4SdI9V8E1/AmcbbRWY0QeOcLE+lnIUkYbkmA+bzAlahBoeP/4fdCbp51UYWFcn8Hj0CUv/di1XcjEiAa/dcYpI38g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zWLRAFolnN2JRJ9s2DCsfv/qwJzFJjVNz90O7EjaQYo=;
 b=cS1LhrHRtLi8Km5DFCvTGkFy38S6fQbjTpodU6GCxz/vIjlleUuhQZWdaH8nursfAnQLrYAixfYDyMCAi0uzrNoN3B4pCGlkzpHZsMqPcYZwfs+dFJPcND2tG7DrjmkDmwvQKtDo88hcmPmPyyrHNBMxDl9UzAcWWvb6qFA1vco=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by CO1PR10MB4434.namprd10.prod.outlook.com
 (2603:10b6:303:9a::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11; Mon, 8 Nov
 2021 15:30:37 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9%5]) with mapi id 15.20.4669.016; Mon, 8 Nov 2021
 15:30:37 +0000
Date:   Mon, 8 Nov 2021 18:30:17 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org
Subject: Re: [bug report] io_uring: return iovec from __io_import_iovec
Message-ID: <20211108153017.GF2026@kadam>
References: <20211108134937.GA2863@kili>
 <d49a7d24-7cea-0b4a-b577-3fac16ddc5fb@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d49a7d24-7cea-0b4a-b577-3fac16ddc5fb@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNXP275CA0036.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:18::24)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kadam (102.222.70.114) by JNXP275CA0036.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:18::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11 via Frontend Transport; Mon, 8 Nov 2021 15:30:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 680c086f-4d8c-4f82-3938-08d9a2ccb691
X-MS-TrafficTypeDiagnostic: CO1PR10MB4434:
X-Microsoft-Antispam-PRVS: <CO1PR10MB44346E20D7A55CBDAD824E9F8E919@CO1PR10MB4434.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2733;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qw/LOHbOLn2BQAQBddT4+HfJGYXcCXmYY0d50KIUiOo3kCXrYMYeE4aicILf+04gRZAwnqNk+iky0kniJSge3bbucZiH42CFDKuaS7Ias+BxSZqy9xfVEK+X3ViIPMepQnyB0X30zB40ExKW7pNJfi7MsXl2T8LiJUisc8Q4r17no+lkR2zqvwKDhE8dH1hTyFL5Sxxb7TXVofDhF/ejH0SYFgSFzQBI5/MeABcP8NlGV0KGGzptj6fVUgsyCVEyKsAfB6kVrche58uBx8q/6JbIY/rxLMh2qw5XWwa/8VUgz3yRlJixoQ/EE0JqsNUTRxydm31xc2u5ZBIZ/X6fTAVngt0mN1M0cCtrBdAM1m9LymeZ1kYL6TeI3FmwJOoQGy9qbk9qx6xt/BZvD5iWr6fqfqZtItgXFZasIuXhsvscTvifOVMt3BLajSP/9+WXIYaenDQzhYr2xZO5bfGG1SP5bLYpwT5vluHsXnpddTl2R7XulK3GfNb2rSPacZ7qYSGVIUfgf4nS8oFNWyW8DmWeESAoEQKbWp9tSgRfuEOkQO0+beKD07LvW/ad9SxcslMBCP3a6hOcmPJXZ8XyuKhAeG5g1uGztkY6gBQxnojRKBEE+57FH5sIc1nN8QMX1IQI5GnuSFuBwZesI/i99UkdcBMOptr1MnZReKGIac7pyWBKGRdQ/9M4CAZnrkADkcs2hWCj1hQajwyfDhb51Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8676002)(2906002)(52116002)(6496006)(38350700002)(38100700002)(508600001)(8936002)(4326008)(9686003)(316002)(6916009)(1076003)(956004)(4744005)(53546011)(33656002)(33716001)(66946007)(9576002)(186003)(5660300002)(44832011)(26005)(66476007)(66556008)(6666004)(86362001)(83380400001)(55016002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yKa027Feg/h2zmxdXzCM/7lhw7JGbvLcHU/A+1/7Lf44c31D5IuriapFLOE7?=
 =?us-ascii?Q?feUbBmumNdo901kCTKmPBVBjb1nKrTCz2kKNFpPOAKczbyQJIV1jaAS+p1JY?=
 =?us-ascii?Q?HtNciNbCwiQuLgCTifZ89WMlI4IjVKpiBW3IMM0tfuk9GOsG4884RZuTy+b/?=
 =?us-ascii?Q?TdYNDdDmQo9i1T3+QAx+bjcHAMgMoilva1/iiLEFJZj5Qa04QkSppSFu8dvY?=
 =?us-ascii?Q?8KFX9rQdDNNZ0yPTk+R4TWfWFg1Ur2ceXpuzn8KXNaGu0y7V5CpFTVovlA8D?=
 =?us-ascii?Q?baSB6yCZH7ZZhHNuoM5BaeL9wRZy7MNcuc4zteje0E90hfrGNz1oqWTrYdf9?=
 =?us-ascii?Q?L5cM+u8Fu+/NXGcqKji2ZADaRtS0EgOTwV5TWgV4k4b5zqIGjWi+z8YvgbCA?=
 =?us-ascii?Q?f9pwYB3bJueugFHN3ybN6Tqtcbi+Eqsj26sgqMp9IHxzxZ8fpEXSqhUU7BFc?=
 =?us-ascii?Q?T/78keWr00A8uTd93fzpOWo0Vr+XpD4O773u5GxpRo1MpWd3Hz9GVUAxz3yK?=
 =?us-ascii?Q?1wY2Xz7aCFLqsevQ4ilVzPzYCINvgB0eUEKm3ozkIqedPhbdjjwvZGLcDN8Z?=
 =?us-ascii?Q?7zmdtSQ5SaFAMse/VDF902gy+qJKodm90guad6AUzr9pIpi8Cc5kcs4XycoR?=
 =?us-ascii?Q?E+dFBcy/q5w+z/RTsl+wSgmbedCZVugjYXspF0BnDSErOIVtsawz3+ImHHbx?=
 =?us-ascii?Q?Otf+3mYE26gaD3N6JvbpefnBXOAtEmhc3p+qtekDF4l2PeF9N+o46TZjzijO?=
 =?us-ascii?Q?uywdMp14+WwU4EWvf3yAeHE87yqT1aJF/TxSMMDrtZ7xMPaahe4EhDa+U9Lz?=
 =?us-ascii?Q?H9/KQykDY8/87v2Uryt/aHlC8VoESPBm5++WVWkmXCtreN3y1TH4X+PaWgG/?=
 =?us-ascii?Q?XRo+QoYfR4X0th76KFGjFBuuphuXR0dfDbIyVqwmDoJ5KPbABfYitA+yX1aT?=
 =?us-ascii?Q?fmDIZvQPCB71Ywc4SlsPhCQ6/pzA4uOfHLZDKiI/Bx4vjZgWMw0//CGXFTDW?=
 =?us-ascii?Q?eVr+FYbPv6QrYR/AjMQZiHINEExDIfVzfH0zjK627hrVuFaznBdFZgXaGmFM?=
 =?us-ascii?Q?vIS9THtd2PQmeT694xxy9lVpeGc9Lsz9MwlT9ssi9P2EVqQ2Ayrzd9R6MF6j?=
 =?us-ascii?Q?bPj5BB//D532yFWBIejYzI9etG7DuPMyMm7o0ns7f3/6riZxcoV+j1r4INHp?=
 =?us-ascii?Q?Ogqu37mmnWJ0dTgE66fRm0x0F3cwEj8cFntvTL5+fhBVMe6YyzGX28VH7SlM?=
 =?us-ascii?Q?75wn7xW7MhxJGmhhT2EtBYElSxJ4BK8GLtOLgHjud9oiszkTNRo9BQ4m04O6?=
 =?us-ascii?Q?kJNHxzmzNd/N0AZN5yQrfVY3DSxZ4U8oTtW+mF/6RKkkZoZZ/ww3XowVSM1c?=
 =?us-ascii?Q?nIDi8fQWJrRCd3X+yidEfVG3fj7pMPGTZmhr6Mry5IRW6X6egC9QDkxcZr0O?=
 =?us-ascii?Q?tg+nhmBItqiLF5htO/FAQILDWYBUV9LJy6OY8a7chjxXf3qQLBThsCPXv5mO?=
 =?us-ascii?Q?9+U2EgJasc+d3k8hNLBhbppKRJI75oxAauDTxSDaMiukzoSaWBbb6NQrHw4j?=
 =?us-ascii?Q?MKITMw+EahQOBoU+/AUF7b59VVt4VCEq+O+L9jLsEIo1V5Grs4zIwtid5syG?=
 =?us-ascii?Q?kGWYyAzXy+F+FNGRKzR0GfxSraJ2ZaNx+H92dmC29EK0nW7Ts6Qhhv5FUCno?=
 =?us-ascii?Q?QMRFm0rAVVxQRe5kyImlKwLJ42A=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 680c086f-4d8c-4f82-3938-08d9a2ccb691
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2021 15:30:37.0743
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SEfrZuGmqqjUba1PY1mTQeBSW9hamBhntNDEL4reoM2xn02SK8vPjT5omA92s92JEFDRcwufSnb0iV25DixfcddEIkcJZKGhdR4IqfGyYB0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4434
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10162 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 spamscore=0 adultscore=0 suspectscore=0 mlxlogscore=735
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111080095
X-Proofpoint-ORIG-GUID: pzvvt_2aSonChBiguiiJkG7JA74LJaHf
X-Proofpoint-GUID: pzvvt_2aSonChBiguiiJkG7JA74LJaHf
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Nov 08, 2021 at 03:19:21PM +0000, Pavel Begunkov wrote:
> On 11/8/21 13:49, Dan Carpenter wrote:
> > Hello Pavel Begunkov,
> > 
> > The patch caa8fe6e86fd: "io_uring: return iovec from
> > __io_import_iovec" from Oct 15, 2021, leads to the following Smatch
> > static checker warning:
> > 
> > 	fs/io_uring.c:3218 __io_import_iovec()
> > 	warn: passing zero to 'ERR_PTR'
> > 
> [...]
> >      3188
> >      3189         BUILD_BUG_ON(ERR_PTR(0) != NULL);
> > 
> > This is super paranoid.  :P
> 
> A bit, but gives an idea about assumptions
> 
> >      3209                 ret = import_single_range(rw, buf, sqe_len, s->fast_iov, iter);
> >      3210                 return ERR_PTR(ret);
> 
> if (ret)
> 	return ERR_PTR(ret);
> return NULL;
> 
> How about this? I have some hope in compilers, should be
> optimised out

The code is fine, but it's hard to know when it's going to return NULL
vs a valid pointer.  It just needs a comment.

regards,
dan carpenter

