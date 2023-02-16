Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0715698FE5
	for <lists+io-uring@lfdr.de>; Thu, 16 Feb 2023 10:35:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229836AbjBPJfu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Feb 2023 04:35:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbjBPJft (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Feb 2023 04:35:49 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 322C830B35;
        Thu, 16 Feb 2023 01:35:48 -0800 (PST)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31G8Iqe1002114;
        Thu, 16 Feb 2023 01:35:48 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=SL/T2E9zoHvblX+NvmN0qtWInTjNQ2z4u5TCpooVc6Y=;
 b=mfzTXiU1EePuXgBhtm3YoiY8zNk2bfwTzTOwezNVkqQ/xLZaLv/nO9mfS/zC3NWG1n4h
 NUD4wm+MITKY4auKJpqEwBhaj7uee4Iwun8AKCDcJ+jTQPvKIuIdVUNF4E0qPk2NJ3/2
 Bjz6WqDWQPY3CjsIrdLWSe3AmBrGAdXScsdVqY8eiM35NNTmpkbq+WeLfPoM4/Qi9ryh
 C+eSXCbQqIgc5UhcEGghWxXLMyXl/JvSq1g64F75aCCT3EmGr+XcMqRlYK6MS0gJLRQC
 R/ZojfGE1nLVlt4M+ZFWxZXcoQlY7HddIXg4fhW37LkD3e5D/ANRwcqglhsWmH0Cc5J7 Ag== 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3nrwhgf68x-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Feb 2023 01:35:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TnjKAwENRP7ph+RDkCkiSMKfSg40P5hYk47EHw0Pq9rML7FnnC74++kLM5lBWaNstQxMZhFi7toxzrn3tih3UmU9EGiIIdgTwMXUon8f6qilKd4aAwrcp1PPkv4OwLufvn9u7hM5z5ikreaIK9V7Of/kQ9PxKoDJTZIcIqgKXj2gBWF8k4hrUhih1XNxRP2xfZwUozo+YWu+yVo0Bi4eiry4Eo4o3+LWXUJ7tnJcWhBCbBmIngL5yJhHxu1qeJee/fkoKN6SOKV6eHOY70K8tvSQOYiVolYP3WaDkurqgxYVEqzCVz6vJBOQnFAe0rPF9i9VBIA++ReA4Wm6GwiAAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SL/T2E9zoHvblX+NvmN0qtWInTjNQ2z4u5TCpooVc6Y=;
 b=kWWe1LX5Fd69fcR2EkFnzqRP01PbxE8oWwSUE7vTPxCM0FH9o//e3Xz6PWe68Lq6QvdThcrjjf8gy9HWRIGGYAwiLXsTOo8cepmdo5LaXNMwbp+XsJx9olBt5U7pypUeIcqcP0DljMFKCra8osihIKQDEUlLdpGSv2kjttptf2oULJfiV9QQ/CKKb9nmsSeRZCvJy3fY8jrgGgNPz1xz2K1QUkPkC/71H99Hwz1c3wIoFqrdmDrzcFfWv3mcT4RE/qFlpiHvC16qEI3aC8j6hNDlAhLy1g0Hw66dVxwD8aqPCCdRZefwlMQHOhPm7AXElEz/Krk/jelTw0p4UfmFng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SA1PR15MB4854.namprd15.prod.outlook.com (2603:10b6:806:1e1::19)
 by MW4PR15MB4665.namprd15.prod.outlook.com (2603:10b6:303:10a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Thu, 16 Feb
 2023 09:35:44 +0000
Received: from SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::fb33:6145:8feb:8054]) by SA1PR15MB4854.namprd15.prod.outlook.com
 ([fe80::fb33:6145:8feb:8054%2]) with mapi id 15.20.6111.013; Thu, 16 Feb 2023
 09:35:44 +0000
From:   Dylan Yudaken <dylany@meta.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "asml.silence@gmail.com" <asml.silence@gmail.com>,
        "josh@joshtriplett.org" <josh@joshtriplett.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
Subject: Re: [PATCHv2] io_uring: Support calling io_uring_register with a
 registered ring fd
Thread-Topic: [PATCHv2] io_uring: Support calling io_uring_register with a
 registered ring fd
Thread-Index: AQHZQNZlbGg7EnGO+k6Pl64fuX2v6q7RUlaA
Date:   Thu, 16 Feb 2023 09:35:44 +0000
Message-ID: <be9f297f68ee3149f67f781fd291b657cfe4166b.camel@meta.com>
References: <f2396369e638284586b069dbddffb8c992afba95.1676419314.git.josh@joshtriplett.org>
In-Reply-To: <f2396369e638284586b069dbddffb8c992afba95.1676419314.git.josh@joshtriplett.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB4854:EE_|MW4PR15MB4665:EE_
x-ms-office365-filtering-correlation-id: a4867bb4-ffae-43f4-2a69-08db10012d4b
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AwC5iu9XcdJG+zTTGoqHi03e5ya1P8PQRRfwnngcKDXulND8L8TPL9Q45rgP8bO73T5UEdb/PwZk6uQCf+eKXrwK/flxA+q6FI1geakOFMQ79RFjYKige1JVDzJ6ROX0vwc4lv0IKvW2d/iCXKOOEQZ/BZ7VMs7101JpOgCdectMNdyl3+iSj+Cw5lcfYVeq5V54QifcK7U9a228/L+9HoXHZedjbNXnnucVNmKH1Afn1wQ6/KAPhp4nTxQx0iBIYjNTczmzd7LzLnpFQXXunpcHtutckH8DJGRt9JD84JBYW5MBBHNHt1J23Z1d/uQpd08Bh6nO4mfYJiljgbEzgT2cJSXHP/18xF9gVJGJfZVYMZEP0stCkiZEh9wvkzr047ljCmmZGLf3KrsuYknRUD6Fmxw1aR1CLX9ySKtmOaRybjFIO9xHJdFVCHlYZ/5MOQyA7qSYW6ZOx9m4n2b2yNC48g2C4wpNbVLcSm0ob4fiQ9nu34NcZjn/Gy0JU9ZmwuFl8ik4GKl2n3cbUJ7guDULdeJ5Cd1mTXToSfBgOY4avunM0JdaUgwmVQ9L+SLYs1/mfZ6AZIyzZw44/datBwgNqEdJSN+3XqFKzBFSLBLlFKT2HkA6Ry+XdpMz3Xi/ZMeCRd3r89W5LWag/96d15fkzwHC3/sMIzKkmD85XIK00CkZGYasNZojNAgogyj9tz4gtBjsndBLiP6D3lxReQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB4854.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(366004)(39860400002)(346002)(136003)(376002)(451199018)(86362001)(38070700005)(122000001)(38100700002)(6486002)(36756003)(478600001)(71200400001)(6512007)(2616005)(186003)(6506007)(66476007)(64756008)(8676002)(66446008)(66946007)(4326008)(76116006)(2906002)(91956017)(5660300002)(8936002)(66556008)(41300700001)(316002)(54906003)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dWxuTTEyY2ZzU29rekRjcUFkR3FRd0QzendRN3JUQlRNOUxaWG1weklXSWdB?=
 =?utf-8?B?dzBTd0djNEhVZXFIWjE1SWZpenoxQmlnUEZ1RmgvQS9pVGVYQk5xbXZrVHRL?=
 =?utf-8?B?bng2RE15cGExbmxXcnZMZkZ3KzRvSVlQdEsyb0FSQ3BBMXhUaVVQSkQ1QXBR?=
 =?utf-8?B?UTB1YkVMd1NiWkxOeUdyY2QvOWdYRTlTZllFL1JjZ3c1WXFRbDQyUWVBSnUy?=
 =?utf-8?B?MUtjaTJkWGpWbkpKN1poNzhaMUtpVnJJZ0dFbVJpaXdxbEZ3TmdMV1liaVhz?=
 =?utf-8?B?bmVxTnNrUysyaG52aUlKN2tGVHRIVUNvT2ppbkNDNnV6S3A2STBxcGo4ak55?=
 =?utf-8?B?c2ZWOHFiOUp4T2pzNi9MS25YbngxZWJjUkRXRzkxMm9mUDR3UGRSVlB1TlRX?=
 =?utf-8?B?ano0ZGh3SmhkLzZLSTVYYU1rUzlYMW9pZllVMDgwNkpibmJ6WWpQR0prZUJJ?=
 =?utf-8?B?aWwrSnl3MloycTVpUEU5OU92bkZwbzBjNnltenYzTzdiaU9jN0NFUXAvQmN3?=
 =?utf-8?B?TUFnZlU3eHVxcHBiVHRrT0VseE0rRXhRbUV3WDA1VUowN05XTHE2c1dNdTFu?=
 =?utf-8?B?M3RiMDIxQWNWZGJYemoxZVhUb0dxOEF2KzhabUVJdVFjQm5NOG5ySEdpZUdZ?=
 =?utf-8?B?RVFQNEtvMk9jV1NaemZRKzkzMThyZW1BbUhCaFptNkFzQWFSN2RUUWhoVkNs?=
 =?utf-8?B?YTBjeE5ZeDIrVTlEWkJCbnNPUGRaQUdYVEtjdGV2NmJIWmhlOWMvMUp1TS9v?=
 =?utf-8?B?V1JzaXEwb1FFa0dJZ2FidEFRSnhBV2ZYdnN6enArUmVvRTU3aUUrMTErRW9u?=
 =?utf-8?B?U3ZaME8xOWQxK0ZzYUttdEgrWkhKL1ZoWndzek9nMlAvOVo3VzdaVHk4NGJL?=
 =?utf-8?B?aHpYa2VLVVcwQldYTzNYc1FlSWRucU5WcDBCVkpMYmsvS3JhNy9ZZUdmOXpW?=
 =?utf-8?B?YWdpazdJdjNzQVZYNVlGMGNJQ0daQWFBZjM3YWp2YVFmRUdUWEhBZFhTUjNX?=
 =?utf-8?B?S3BjRk9iYmhZOEwxNDlLVkdHTXRYWTJKWWhQNHpmVENpSldJODI3K2M3aWNt?=
 =?utf-8?B?Q3lUTkZrbm5mUDZsZWR1M0diSU5Qd0tXckdBSkxlQW52UkdkZDArOWswM0Vs?=
 =?utf-8?B?RUw0Y2wzZkZRdzFIV3FwdHNPYlA1NVpFeFo1S1lkeGVJcmhPVC9ZNUJFa0JL?=
 =?utf-8?B?Qy9BMUg5NW9RampwZVlzNVhLcUdQU2svbXBWeHJ4dUhXTmJKcDVVbTBtb2lj?=
 =?utf-8?B?dkJlT3U3d2Z4VjFsWmtEdFZxSit3Sk95K3FhYTRBMlE2S1ZSWTluZU1oZS9V?=
 =?utf-8?B?Y1pRUkg1cklySWpUNVpvd2xDQWlLVDBlY3VmYmthQ1N4Z2dRTjhpRjFZY3la?=
 =?utf-8?B?TEZ1VEtyNzJwdXJLR29QR0djNEhMRFpOZ09aWE5DZGlZLzdyYmdSS09IRmxH?=
 =?utf-8?B?TFduMUFiUi92a0JoZlRlb0o5TUhVQWhiZ2I4bGN2RXRLNGc2ck9OTGpGVjZT?=
 =?utf-8?B?TEFjTktsLytORjZRdm42SmRSSFFvRnVVZm1RMWRZWjdscGVyWkt0cjFzVkF6?=
 =?utf-8?B?Ry9DMjZ3SzM4aUtCUnYzdTRSWG0veU0wU3QxeHhNOThoUnYzMWxvZGpHeHFv?=
 =?utf-8?B?TXA3N3lwUU9zeVpkQjNVZkpvOGVOVU52UjU2K2JzWVNQNzZMVnhLb0lMQ2ZG?=
 =?utf-8?B?blFkYnBtQUNFK1ZRVGZmQUMzdXlMSmRGaDJCS1VJRVBIbGVLQnQ5MlJ2V3RP?=
 =?utf-8?B?K2lHcUpGdUxlTnV3L2ZkRGNJQVprZTFEZWM1T2pvOUtCTEZ5RzV3R0lodFBX?=
 =?utf-8?B?dkhXZmk5R3l1bXhsT0VDK0FycXp6QW8wTENPdnNsRUNEa3NpaWZaZTIwT2Fa?=
 =?utf-8?B?RlBCNkd0Titic1ZJVS9aaHI4UDlhL1lReFgrWUJtKzNCUW1oS3JWQithMGxw?=
 =?utf-8?B?QVd5S3pCeTZlY2ZSSWo2d3F2cTd4eTFEWSs3M2RVckFmRExYdVBpWHJGemxl?=
 =?utf-8?B?enZ4RmlDZnVQdjZXaEFKRmp0ejdyVGdYcjNieHUwd2V5a0NnNWJFWHRadWJE?=
 =?utf-8?B?MVlaTmZETmZsdjdCZm95TUcrV0ZXT3BaN1dEbWhmV2hRUEtzZWxWT1lGaWhi?=
 =?utf-8?B?Qis4TVRweW5jSzlhaml1UTg2S283NWFaZVorcnU0dDVpQVkxSVZ3RC91YTFQ?=
 =?utf-8?Q?954f91bLdySAog6dIRV2fps=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A6E056DDF56BE44192BE56280A3429D4@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB4854.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4867bb4-ffae-43f4-2a69-08db10012d4b
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Feb 2023 09:35:44.3657
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aLXOECtEjr2u+C0rsZtiLSDvG9G0DM/DJzshW25omYUgIVlS+F5/hGh4M2W2AjQK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR15MB4665
X-Proofpoint-GUID: SdcF-IdIdVlzuduJSexSNWEjDYt_9nCL
X-Proofpoint-ORIG-GUID: SdcF-IdIdVlzuduJSexSNWEjDYt_9nCL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-16_07,2023-02-15_01,2023-02-09_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

T24gVHVlLCAyMDIzLTAyLTE0IGF0IDE2OjQyIC0wODAwLCBKb3NoIFRyaXBsZXR0IHdyb3RlOgo+
IEBAIC00MTc3LDE3ICs0MTc3LDM3IEBAIFNZU0NBTExfREVGSU5FNChpb191cmluZ19yZWdpc3Rl
ciwgdW5zaWduZWQKPiBpbnQsIGZkLCB1bnNpZ25lZCBpbnQsIG9wY29kZSwKPiDCoMKgwqDCoMKg
wqDCoMKgc3RydWN0IGlvX3JpbmdfY3R4ICpjdHg7Cj4gwqDCoMKgwqDCoMKgwqDCoGxvbmcgcmV0
ID0gLUVCQURGOwo+IMKgwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgZmQgZjsKPiArwqDCoMKgwqDCoMKg
wqBib29sIHVzZV9yZWdpc3RlcmVkX3Jpbmc7Cj4gKwo+ICvCoMKgwqDCoMKgwqDCoHVzZV9yZWdp
c3RlcmVkX3JpbmcgPSAhIShvcGNvZGUgJgo+IElPUklOR19SRUdJU1RFUl9VU0VfUkVHSVNURVJF
RF9SSU5HKTsKPiArwqDCoMKgwqDCoMKgwqBvcGNvZGUgJj0gfklPUklOR19SRUdJU1RFUl9VU0Vf
UkVHSVNURVJFRF9SSU5HOwo+IMKgCj4gwqDCoMKgwqDCoMKgwqDCoGlmIChvcGNvZGUgPj0gSU9S
SU5HX1JFR0lTVEVSX0xBU1QpCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqByZXR1
cm4gLUVJTlZBTDsKPiDCoAo+IC3CoMKgwqDCoMKgwqDCoGYgPSBmZGdldChmZCk7Cj4gLcKgwqDC
oMKgwqDCoMKgaWYgKCFmLmZpbGUpCj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJl
dHVybiAtRUJBREY7Cj4gK8KgwqDCoMKgwqDCoMKgaWYgKHVzZV9yZWdpc3RlcmVkX3JpbmcpIHsK
PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgLyoKPiArwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgICogUmluZyBmZCBoYXMgYmVlbiByZWdpc3RlcmVkIHZpYQo+IElPUklOR19S
RUdJU1RFUl9SSU5HX0ZEUywgd2UKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgICog
bmVlZCBvbmx5IGRlcmVmZXJlbmNlIG91ciB0YXNrIHByaXZhdGUgYXJyYXkgdG8KPiBmaW5kIGl0
Lgo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgKi8KPiArwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgc3RydWN0IGlvX3VyaW5nX3Rhc2sgKnRjdHggPSBjdXJyZW50LT5pb191
cmluZzsKPiDCoAo+IC3CoMKgwqDCoMKgwqDCoHJldCA9IC1FT1BOT1RTVVBQOwo+IC3CoMKgwqDC
oMKgwqDCoGlmICghaW9faXNfdXJpbmdfZm9wcyhmLmZpbGUpKQo+IC3CoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqBnb3RvIG91dF9mcHV0Owo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqBpZiAodW5saWtlbHkoIXRjdHggfHwgZmQgPj0gSU9fUklOR0ZEX1JFR19NQVgpKQo+ICvC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcmV0dXJuIC1FSU5W
QUw7Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGZkID0gYXJyYXlfaW5kZXhfbm9z
cGVjKGZkLCBJT19SSU5HRkRfUkVHX01BWCk7Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoGYuZmlsZSA9IHRjdHgtPnJlZ2lzdGVyZWRfcmluZ3NbZmRdOwo+ICvCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqBmLmZsYWdzID0gMDsKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgaWYgKHVubGlrZWx5KCFmLmZpbGUpKQo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgcmV0dXJuIC1FQkFERjsKPiArwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgb3Bjb2RlICY9IH5JT1JJTkdfUkVHSVNURVJfVVNFX1JFR0lTVEVSRURfUklO
RzsKCl4gdGhpcyBsaW5lIGxvb2tzIGR1cGxpY2F0ZWQgYXQgdGhlIHRvcCBvZiB0aGUgZnVuY3Rp
b24/CgoKQWxzbyAtIGlzIHRoZXJlIGEgbGlidXJpbmcgcmVncmVzc2lvbiB0ZXN0IGZvciB0aGlz
Pwo=
