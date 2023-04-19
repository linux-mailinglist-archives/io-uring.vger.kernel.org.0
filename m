Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED5C16E7E8C
	for <lists+io-uring@lfdr.de>; Wed, 19 Apr 2023 17:42:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233356AbjDSPmp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 19 Apr 2023 11:42:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233120AbjDSPmo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 19 Apr 2023 11:42:44 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2085.outbound.protection.outlook.com [40.107.94.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 621AA83CE;
        Wed, 19 Apr 2023 08:42:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Aaq8JsKryLVlmfv/F0Mj5x0wtcc+5oT+hjjUK5JJt5J0xn4nFLWjvBUxQDG2OOcwBRyl+jK3aawoQp1fvD/bV93uOtj8BbXGEo5i7ixYzKhDCP8Twn8uBFB+u67z0F+rB/1NHIp+NrDeFE+GQSr6mcYz6DEsFKKMQ5rS0HvhMDzynNZ52ZVLLEOcJl/+xiscDjPlNhWwmB0TDbXpFOyCe0cAXX+4aZSl78zq86UXC0hg2/FG6s6k6AorErIKFfJsMIoI0ffWQuZBarqbIVivnZY6Lit+SPW7zWELSu66aN90Lg8Q4e4CGhN7WL+4lSB9vb+W/U/8a6cT29iR6JW/Ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PoulpVEsjzmJHpsxn83+oAkNzpwSic+kg/uAnHOcFpI=;
 b=eRZPI4/ctg2ooRXjLJ+WM1d3faFP19eYXRbhqMV3MUSt9iW7zlKteIaIKfOex4v0H6i+ZcMEiLbk+q+PR9wbhEfd6kEjMZS8qiaiwUjbggSmPqcrA4ewaKvKzqIzqOo+gq4UPHLVE5P3niXfBx1UqtcsjJ0TDyc831jwuRE8Lr42mS69TCfG6Sb69gDZ4dfS4yc8fZHrpOVMX5LfFARw5uLewFL8dalW7ZNt4bJk19SBFKHWRnNKI+O+XyJlm6oTmRUIdF743eU9+/DpitSs27doIutCjbLLd86NGlhN2dpem7gtMa70KSe7Zp3kOuJpOCWvUwrH2x2hAXxOvqv0RA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ddn.com; dmarc=pass action=none header.from=ddn.com; dkim=pass
 header.d=ddn.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ddn.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PoulpVEsjzmJHpsxn83+oAkNzpwSic+kg/uAnHOcFpI=;
 b=H1BZT2m26g9nQ8q8rFtlot2gnEqDz3sSJEFf2TU4tKkfWenPXKD8KwG6NDYF+G+jLuJCUPORLsIACPcMpd1LUDdLBbIpvEwY0fjfMm+QqTQN+sy0p3vQfF2Xv0IvAV+3OQzVuc22ZklJ8OLg1fm1UorGnBXvyvfN5rhYEnwaWTE=
Received: from DM5PR1901MB2037.namprd19.prod.outlook.com (2603:10b6:4:aa::29)
 by DS0PR19MB7297.namprd19.prod.outlook.com (2603:10b6:8:151::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.31; Wed, 19 Apr
 2023 15:42:40 +0000
Received: from DM5PR1901MB2037.namprd19.prod.outlook.com
 ([fe80::8cb3:ef5b:f815:7d8c]) by DM5PR1901MB2037.namprd19.prod.outlook.com
 ([fe80::8cb3:ef5b:f815:7d8c%6]) with mapi id 15.20.6277.031; Wed, 19 Apr 2023
 15:42:40 +0000
From:   Bernd Schubert <bschubert@ddn.com>
To:     Ming Lei <ming.lei@redhat.com>
CC:     Jens Axboe <axboe@kernel.dk>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@redhat.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH V6 00/17] io_uring/ublk: add generic IORING_OP_FUSED_CMD
Thread-Topic: [PATCH V6 00/17] io_uring/ublk: add generic IORING_OP_FUSED_CMD
Thread-Index: AQHZYvvtPs9fEeQCFke4YxV9Vaxbbq8xlJqAgABoW4CAAIeQgIAAFxAAgABJl4A=
Date:   Wed, 19 Apr 2023 15:42:40 +0000
Message-ID: <6ed5c6f4-6abe-3eff-5a36-b1478a830c49@ddn.com>
References: <20230330113630.1388860-1-ming.lei@redhat.com>
 <78fe6617-2f5e-3e8e-d853-6dc8ffb5f82c@ddn.com>
 <ZD9JI/JlwrzXQPZ7@ovpn-8-18.pek2.redhat.com>
 <b6188050-1b12-703c-57e8-67fd27adb85c@ddn.com>
 <ZD/ONON4AzwvtlLB@ovpn-8-18.pek2.redhat.com>
In-Reply-To: <ZD/ONON4AzwvtlLB@ovpn-8-18.pek2.redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ddn.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM5PR1901MB2037:EE_|DS0PR19MB7297:EE_
x-ms-office365-filtering-correlation-id: b0a29ec7-060c-485c-21db-08db40ecb55b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Diwr+frPt40Tmn1wNfSdz+qUssRSFG0ZtoD3DbVA6Ui0b45DSHxABS3ZwFZnj0krYm7xGOJ5d+P86Oak9VMyFcm8WDWEdTGG7IHGXP7l4ehLt7Hdf9CyqIJsGpbc82EY43q9O/+ZJTTavMjeMPm8z/GuuPODonVuVapT041JTAODXn22MpSI9zsYFGvt8OQBkWd7zCBGBNg9DuYiI/ilFbWPxkIE8v9QCWIUsTzR1pjvhZOFb1hLQ4OfsTot3C00Gp//eEC0w8SpKBGihs3izaE7eZZMdzI5xx8d49T2yvADHHUcID4r6+hUUaZouKqhOqL4cgvN8+a74ZrqOgsjcCX3c8GxXeGq7GvwiLyHrziluC1nidtHSQs7CEckghPaKYIqPuecqUxo+H/2KamDaSM/2i4EampxqYkIXLjawM89V9p28hB/n0LqZbg54fj6gYhfPg0+V+jfHnTMS4dAEvN4ZI6EMoTaT3xas5SskXAX3zGcL/cF6wLI2WKUQZIkoZCQmv35+jaNL2VwkHh7rm0HdxrMFLToXTSQ8b5i3+BqUJdh8x2AWnvX+ypw75x+QgE4CR0wHdlswk+kph0/jgVl9F8avS7ZYTt05zjWWWD4F5w7H/9hpKhUJk/ju/m03rk439SH4xQtmnegP71RmHFdD3evyr0nJiYbd60gLWYh6vW9lEdqs4Fnlr0W1J4P
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1901MB2037.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(366004)(396003)(346002)(39850400004)(376002)(451199021)(38100700002)(966005)(6506007)(316002)(83380400001)(186003)(6512007)(6486002)(478600001)(54906003)(45080400002)(91956017)(2616005)(71200400001)(38070700005)(5660300002)(2906002)(66946007)(6916009)(36756003)(122000001)(76116006)(86362001)(66446008)(4326008)(64756008)(41300700001)(31696002)(8936002)(66556008)(66476007)(8676002)(7416002)(53546011)(31686004)(66899021)(41533002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Z1dzRUNJK1RPNm1DMUxaeFpzY0lVb29WdGRHYnpYUmZKa244ZUVnZkRKMFZW?=
 =?utf-8?B?QUJFOFhTRHQrT1NKTmJMNmw5ZTFlNmtYdjRUZGdTUGJpOXFuSlFtVHcrSkZE?=
 =?utf-8?B?VlovN1NUYmZZVFAxUm5HWVJWY3JEdWIzZEFmeS9tc3ZLbkRpTGw5c0NsQVlN?=
 =?utf-8?B?MW1XS1RNR1lTUnVPVmlYM1BNNnhkL0VvSWw4ekozV3NTZnI2eldnRWpHSFlj?=
 =?utf-8?B?UVJjVkNvUmpXL2JvSlVVU2Z4QnFTdkFvRUJsRUtRTlNGdndnYlJPZGJPSmNU?=
 =?utf-8?B?V2ZBelFEUXlVMnB3Z0w3MzE3VU96UGVCZ3R1QVFTQWIzOThNUytJZnJnR1J3?=
 =?utf-8?B?VFBtVFFWWkRadk80d0xuQk50SGNpTk1MYlFoY0VHa0J4UzlWS1haRnFpdXp4?=
 =?utf-8?B?dldDeTFuRWY5d29zc0hxRGdwdGk5L2dlczFMOXVRZ21QM2FaNHl0VktIWnJy?=
 =?utf-8?B?NzBPcDBEOUMwOE9zVGxOa0prS2p6aWVQbjV1SXorM1Q1N1RBaWcyQzhBN1g2?=
 =?utf-8?B?U1p3UCt6QTM3Tm5RaVR4M3hGek5aWUdRV002NkFUWTVPUnpGVUxJNTdabk1o?=
 =?utf-8?B?R0haakJmVzNOMUQ0OWJzalFuNDQ1S3hOY1o5UG1TMlZ2dElybjFWWkQ4UXdR?=
 =?utf-8?B?U3o1cmpFdDdxdjRKYWlTQVY3aGhXUFFHMHhNWGZtMDZNVWZscytNd0piTFIy?=
 =?utf-8?B?b3ZBTEVyZStaS2NRNWg3dkZIZFMxVDJIWVZrTUpYb291endoTWJ0Qy9qeHpu?=
 =?utf-8?B?N2hONEtCYUl0bWtWS0JuQ3NzOVQ4Z09nKzd4ZkV2QlZoQ1VmQWdtQ3B5dHd6?=
 =?utf-8?B?SFMraTQ1dkUxZGZ2ME1xMXR6eUVSMVBqaDJHakxyZzliRVNnNW56TVN1RWwr?=
 =?utf-8?B?T0RqZlcvWG1leEk5ZFZTSGJ4d3NXZ29EbXhvM2pNUitJbVJ5SWh3aCt2TDFZ?=
 =?utf-8?B?Nk9nTXg3eSsvNmlYRllUZjZ2VmtpVC9QYlVwUnZpcHJjZzd6elA0bjQ3enk0?=
 =?utf-8?B?anFTSnhKOEd5S3JGa3RYbzUyMEhDR1p0N2FBMFVpNDNBSmtMd0IrdGFDaC9M?=
 =?utf-8?B?MVI0a094VnB5T1NMQUdieXFxMTAyNWVrYWJWYm53djNqa3ZsVFZyYnU2bk9L?=
 =?utf-8?B?bFJvWWkySUVZUHlBL0wrMjJ6UkNxUnpoTEgzZ1YwN2NHY3NnclJWa0NSV0Na?=
 =?utf-8?B?QW9tbXVDQTc3a1VMR0J0YjhidGk1ZURqZk4rdTZ1THRaYTVNbTJzaTVEcXdr?=
 =?utf-8?B?UXhyallYOVo4OS9hZVN5aHJpQUFXaVlYS3Zhbk1RaGtjS05payt0OEttVVZH?=
 =?utf-8?B?S05XZEdCbGZ3cWJ1MW93ZDdZaUxkcTJGd2JndzFkWlhEUkxqNHBrejdkeFFw?=
 =?utf-8?B?NyswUlM1cnB5VDdqaGZqdkswdGNCdnZYekoyaDQxZnE2MTZqcWdrZERkeXRW?=
 =?utf-8?B?VmdMa3pydkc2QkNFS2djV2h0azMrMkJJY2c1WmJRaGlUdnF3Tk9FN1FGNlJl?=
 =?utf-8?B?K090a0RrUWk3UkNhRDBGOXgrMjJOekdwM1g3Qm56SFRrOWZkaE5uRTZuajlD?=
 =?utf-8?B?cE4wTG1jMGN2YjczdDZONFZUTXd5MnUxU0JPM09RdHZOUWZvN3B2UVlIV0hR?=
 =?utf-8?B?WHd0MTlEcjFMelF6WjZJVnZKcFJMay9RczI4cHpIbkU5UzdrQVRSSXJGV1NJ?=
 =?utf-8?B?NERib3hTTG8ySG02ekdTZkw4bWZ6Q0Z5Q0VjaWllbmhaRy9DanRsemF5ZnA3?=
 =?utf-8?B?NU85Uk9zSHhmZDBqNHliTGVHM2RCRmY4Sm1xVGkwL2pTaS9OU21PYllPQ1JC?=
 =?utf-8?B?OFRjT215WFNycThKbVMwZTdBQ3d6ak1jdmdLYmVOcDRSWGx1Znl1eUFtQlZp?=
 =?utf-8?B?NkxCM0k5TmVHNndSRkp2SlRrVmdSMEtPMm9Ga25QK3ZmbDU5Rkt0MnZBcWxN?=
 =?utf-8?B?WUVPVlRUQmthUjBPTk5kWk5xNjhkR2ludS9LRmE0UHJQd2ZZVmx1NGI0TFFl?=
 =?utf-8?B?Tm05c3d6ZkptcXAzTHVkSWw2bVl5WjQ0MHNTSUh1UUcrVTUxZmVVR2YvTmFj?=
 =?utf-8?B?SmkrU3E4VnN0VUZDV0lJZE5JZHlmUGNYL25KaFVMSlpUUlAwYjFIVGFFbG9z?=
 =?utf-8?B?RlkxOU9SV1NMTHFxY0kyNnl5djVET1BLUEc5M3hBeTRGekh0NEE0d3I0V20r?=
 =?utf-8?Q?2zuhBiQ8qlWWdZ7gTdqW/h4=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <92E2DEBD91EF2444A0CA91B6AF506A3C@namprd19.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: ddn.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1901MB2037.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0a29ec7-060c-485c-21db-08db40ecb55b
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Apr 2023 15:42:40.1852
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 753b6e26-6fd3-43e6-8248-3f1735d59bb4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5C6nOLo+XukOtDUSoBuIqZsnTCxA1ZknH4O3goYu/7E3YU3LIAd10/w8OjU7UgpbpbRJFtZ2Q8Vhn5DpPf3PRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR19MB7297
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

T24gNC8xOS8yMyAxMzoxOSwgTWluZyBMZWkgd3JvdGU6DQo+IE9uIFdlZCwgQXByIDE5LCAyMDIz
IGF0IDA5OjU2OjQzQU0gKzAwMDAsIEJlcm5kIFNjaHViZXJ0IHdyb3RlOg0KPj4gT24gNC8xOS8y
MyAwMzo1MSwgTWluZyBMZWkgd3JvdGU6DQo+Pj4gT24gVHVlLCBBcHIgMTgsIDIwMjMgYXQgMDc6
Mzg6MDNQTSArMDAwMCwgQmVybmQgU2NodWJlcnQgd3JvdGU6DQo+Pj4+IE9uIDMvMzAvMjMgMTM6
MzYsIE1pbmcgTGVpIHdyb3RlOg0KPj4+PiBbLi4uXQ0KPj4+Pj4gVjY6DQo+Pj4+PiAJLSByZS1k
ZXNpZ24gZnVzZWQgY29tbWFuZCwgYW5kIG1ha2UgaXQgbW9yZSBnZW5lcmljLCBtb3Zpbmcgc2hh
cmluZyBidWZmZXINCj4+Pj4+IAlhcyBvbmUgcGx1Z2luIG9mIGZ1c2VkIGNvbW1hbmQsIHNvIGlu
IGZ1dHVyZSB3ZSBjYW4gaW1wbGVtZW50IG1vcmUgcGx1Z2lucw0KPj4+Pj4gCS0gZG9jdW1lbnQg
cG90ZW50aWFsIG90aGVyIHVzZSBjYXNlcyBvZiBmdXNlZCBjb21tYW5kDQo+Pj4+PiAJLSBkcm9w
IHN1cHBvcnQgZm9yIGJ1aWx0aW4gc2Vjb25kYXJ5IHNxZSBpbiBTUUUxMjgsIHNvIGFsbCBzZWNv
bmRhcnkNCj4+Pj4+IAkgIHJlcXVlc3RzIGhhcyBzdGFuZGFsb25lIFNRRQ0KPj4+Pj4gCS0gbWFr
ZSBmdXNlZCBjb21tYW5kIGFzIG9uZSBmZWF0dXJlDQo+Pj4+PiAJLSBjbGVhbnVwICYgaW1wcm92
ZSBuYW1pbmcNCj4+Pj4NCj4+Pj4gSGkgTWluZywgZXQgYWwuLA0KPj4+Pg0KPj4+PiBJIHN0YXJ0
ZWQgdG8gd29uZGVyIGlmIGZ1c2VkIFNRRSBjb3VsZCBiZSBleHRlbmRlZCB0byBjb21iaW5lIG11
bHRpcGxlDQo+Pj4+IHN5c2NhbGxzLCBmb3IgZXhhbXBsZSBvcGVuL3JlYWQvY2xvc2UuICBXaGlj
aCB3b3VsZCBiZSBhbm90aGVyIHNvbHV0aW9uDQo+Pj4+IGZvciB0aGUgcmVhZGZpbGUgc3lzY2Fs
bCBNaWtsb3MgaGFkIHByb3Bvc2VkIHNvbWUgdGltZSBhZ28uDQo+Pj4+DQo+Pj4+IGh0dHBzOi8v
bG9yZS5rZXJuZWwub3JnL2xrbWwvQ0FKZnBlZ3VzaThCaldGekVpMDU5MjZkNFJzRVF2UG5SVy13
N015PWliQkhROE5nQ3V3QG1haWwuZ21haWwuY29tLw0KPj4+Pg0KPj4+PiBJZiBmdXNlZCBTUUVz
IGNvdWxkIGJlIGV4dGVuZGVkLCBJIHRoaW5rIGl0IHdvdWxkIGJlIHF1aXRlIGhlbHBmdWwgZm9y
DQo+Pj4+IG1hbnkgb3RoZXIgcGF0dGVybnMuIEFub3RoZXIgc2ltaWxhciBleGFtcGxlcyB3b3Vs
ZCBvcGVuL3dyaXRlL2Nsb3NlLA0KPj4+PiBidXQgaWRlYWwgd291bGQgYmUgYWxzbyB0byBhbGxv
dyB0byBoYXZlIGl0IG1vcmUgY29tcGxleCBsaWtlDQo+Pj4+ICJvcGVuL3dyaXRlL3N5bmNfZmls
ZV9yYW5nZS9jbG9zZSIgLSBvcGVuL3dyaXRlL2Nsb3NlIG1pZ2h0IGJlIHRoZQ0KPj4+PiBmYXN0
ZXN0IGFuZCBjb3VsZCBwb3NzaWJseSByZXR1cm4gYmVmb3JlIHN5bmNfZmlsZV9yYW5nZS4gVXNl
IGNhc2UgZm9yDQo+Pj4+IHRoZSBsYXR0ZXIgd291bGQgYmUgYSBmaWxlIHNlcnZlciB0aGF0IHdh
bnRzIHRvIGdpdmUgbm90aWZpY2F0aW9ucyB0bw0KPj4+PiBjbGllbnQgd2hlbiBwYWdlcyBoYXZl
IGJlZW4gd3JpdHRlbiBvdXQuDQo+Pj4NCj4+PiBUaGUgYWJvdmUgcGF0dGVybiBuZWVkbid0IGZ1
c2VkIGNvbW1hbmQsIGFuZCBpdCBjYW4gYmUgZG9uZSBieSBwbGFpbg0KPj4+IFNRRXMgY2hhaW4s
IGZvbGxvd3MgdGhlIHVzYWdlOg0KPj4+DQo+Pj4gMSkgc3VwcG9zZSB5b3UgZ2V0IG9uZSBjb21t
YW5kIGZyb20gL2Rldi9mdXNlLCB0aGVuIEZVU0UgZGFlbW9uDQo+Pj4gbmVlZHMgdG8gaGFuZGxl
IHRoZSBjb21tYW5kIGFzIG9wZW4vd3JpdGUvc3luYy9jbG9zZQ0KPj4+IDIpIGdldCBzcWUxLCBw
cmVwYXJlIGl0IGZvciBvcGVuIHN5c2NhbGwsIG1hcmsgaXQgYXMgSU9TUUVfSU9fTElOSzsNCj4+
PiAzKSBnZXQgc3FlMiwgcHJlcGFyZSBpdCBmb3Igd3JpdGUgc3lzY2FsbCwgbWFyayBpdCBhcyBJ
T1NRRV9JT19MSU5LOw0KPj4+IDQpIGdldCBzcWUzLCBwcmVwYXJlIGl0IGZvciBzeW5jIGZpbGUg
cmFuZ2Ugc3lzY2FsbCwgbWFyayBpdCBhcyBJT1NRRV9JT19MSU5LOw0KPj4+IDUpIGdldCBzcWU0
LCBwcmVwYXJlIGl0IGZvciBjbG9zZSBzeXNjYWxsDQo+Pj4gNikgaW9fdXJpbmdfZW50ZXIoKTsJ
Ly9mb3Igc3VibWl0IGFuZCBnZXQgZXZlbnRzDQo+Pg0KPj4gT2gsIEkgd2FzIG5vdCBhd2FyZSB0
aGF0IElPU1FFX0lPX0xJTksgY291bGQgcGFzcyB0aGUgcmVzdWx0IG9mIG9wZW4NCj4+IGRvd24g
dG8gdGhlIG90aGVycy4gSG1tLCB0aGUgZXhhbXBsZSBJIGZpbmQgZm9yIG9wZW4gaXMNCj4+IGlv
X3VyaW5nX3ByZXBfb3BlbmF0X2RpcmVjdCBpbiB0ZXN0X29wZW5fZml4ZWQoKS4gSXQgcHJvYmFi
bHkgZ2V0cyBvZmYNCj4+IHRvcGljIGhlcmUsIGJ1dCBvbmUgbmVlZHMgdG8gaGF2ZSByaW5nIHBy
ZXBhcmVkIHdpdGgNCj4+IGlvX3VyaW5nX3JlZ2lzdGVyX2ZpbGVzX3NwYXJzZSwgdGhlbiBtYW51
YWxseSBtYW5hZ2VzIGF2YWlsYWJsZSBpbmRleGVzDQo+PiBhbmQgY2FuIHRoZW4gbGluayBjb21t
YW5kcz8gSW50ZXJlc3RpbmchDQo+IA0KPiBZZWFoLCAgc2VlIHRlc3QvZml4ZWQtcmV1c2UuYyBv
ZiBsaWJ1cmluZw0KPiANCj4+DQo+Pj4NCj4+PiBUaGVuIGFsbCB0aGUgZm91ciBPUHMgYXJlIGRv
bmUgb25lIGJ5IG9uZSBieSBpb191cmluZyBpbnRlcm5hbA0KPj4+IG1hY2hpbmVyeSwgYW5kIHlv
dSBjYW4gY2hvb3NlIHRvIGdldCBzdWNjZXNzZnVsIENRRSBmb3IgZWFjaCBPUC4NCj4+Pg0KPj4+
IElzIHRoZSBhYm92ZSB3aGF0IHlvdSB3YW50IHRvIGRvPw0KPj4+DQo+Pj4gVGhlIGZ1c2VkIGNv
bW1hbmQgcHJvcG9zYWwgaXMgYWN0dWFsbHkgZm9yIHplcm8gY29weShidXQgbm90IGxpbWl0ZWQg
dG8gemMpLg0KPj4NCj4+IFllYWgsIEkgaGFkIGp1c3QgdGhvdWdodCB0aGF0IElPUklOR19PUF9G
VVNFRF9DTUQgY291bGQgYmUgbW9kaWZpZWQgdG8NCj4+IHN1cHBvcnQgZ2VuZXJpYyBwYXNzaW5n
LCBhcyBpdCBraW5kIG9mIGhhbmRzIGRhdGEgKGJ1ZmZlcnMpIGZyb20gb25lIHNxZQ0KPj4gdG8g
dGhlIG90aGVyLiBJLmUuIGluc3RlYWQgb2YgYnVmZmVycyBpdCB3b3VsZCBoYXZlIHBhc3NlZCB0
aGUgZmQsIGJ1dA0KPj4gaWYgdGhpcyBpcyBhbHJlYWR5IHBvc3NpYmxlIC0gbm8gbmVlZCB0byBt
YWtlIElPUklOR19PUF9GVVNFRF9DTUQgbW9yZQ0KPj4gY29tcGxleC5tYW4NCj4gDQo+IFRoZSB3
YXkgb2YgcGFzc2luZyBGRCBpbnRyb2R1Y2VzIG90aGVyIGNvc3QsIHJlYWQgb3AgcnVubmluZyBp
bnRvIGFzeW5jLA0KPiBhbmQgYWRkaW5nIGl0IGludG8gZ2xvYmFsIHRhYmxlLCB3aGljaCBpbnRy
b2R1Y2VzIHJ1bnRpbWUgY29zdC4NCg0KSG1tLCBxdWVzdGlvbiBmcm9tIG15IHNpZGUgaXMgd2h5
IGl0IG5lZWRzIHRvIGJlIGluIHRoZSBnbG9iYWwgdGFibGUsIA0Kd2hlbiBpdCBjb3VsZCBiZSBq
dXN0IHBhc3NlZCB0byB0aGUgbGlua2VkIG9yIGZ1c2VkIHNxZT8NCg0KPiANCj4gVGhhdCBpcyB0
aGUgcmVhc29uIHdoeSBmdXNlZCBjb21tYW5kIGlzIGRlc2lnbmVkIGluIHRoZSBmb2xsb3dpbmcg
d2F5Og0KPiANCj4gLSBsaW5rIGNhbiBiZSBhdm9pZGVkLCBzbyBPUHMgbmVlZG4ndCB0byBiZSBy
dW4gaW4gYXN5bmMNCj4gLSBubyBuZWVkIHRvIGFkZCBidWZmZXIgaW50byBnbG9iYWwgdGFibGUN
Cj4gDQo+IENhdXNlIGl0IGlzIHJlYWxseSBpbiBmYXN0IGlvIHBhdGguDQo+IA0KPj4NCj4+Pg0K
Pj4+IElmIHRoZSBhYm92ZSB3cml0ZSBPUCBuZWVkIHRvIHdyaXRlIHRvIGZpbGUgd2l0aCBpbi1r
ZXJuZWwgYnVmZmVyDQo+Pj4gb2YgL2Rldi9mdXNlIGRpcmVjdGx5LCB5b3UgY2FuIGdldCBvbmUg
c3FlMCBhbmQgcHJlcGFyZSBpdCBmb3IgcHJpbWFyeSBjb21tYW5kDQo+Pj4gYmVmb3JlIDEpLCBh
bmQgc2V0IHNxZTItPmFkZHIgdG8gb2ZmZXQgb2YgdGhlIGJ1ZmZlciBpbiAzKS4NCj4+Pg0KPj4+
IEhvd2V2ZXIsIGZ1c2VkIGNvbW1hbmQgaXMgdXN1YWxseSB1c2VkIGluIHRoZSBmb2xsb3dpbmcg
d2F5LCBzdWNoIGFzIEZVU0UgZGFlbW9uDQo+Pj4gZ2V0cyBvbmUgUkVBRCByZXF1ZXN0IGZyb20g
L2Rldi9mdXNlLCBGVVNFIHVzZXJzcGFjZSBjYW4gaGFuZGxlIHRoZSBSRUFEIHJlcXVlc3QNCj4+
PiBhcyBpb191cmluZyBmdXNlZCBjb21tYW5kOg0KPj4+DQo+Pj4gMSkgZ2V0IHNxZTAgYW5kIHBy
ZXBhcmUgaXQgZm9yIHByaW1hcnkgY29tbWFuZCwgaW4gd2hpY2ggeW91IG5lZWQgdG8NCj4+PiBw
cm92aWRlIGluZm8gZm9yIHJldHJpZXZpbmcga2VybmVsIGJ1ZmZlci9wYWdlcyBvZiB0aGlzIFJF
QUQgcmVxdWVzdA0KPj4+DQo+Pj4gMikgc3VwcG9zZSB0aGlzIFJFQUQgcmVxdWVzdCBuZWVkcyB0
byBiZSBoYW5kbGVkIGJ5IHRyYW5zbGF0aW5nIGl0IHRvDQo+Pj4gUkVBRHMgdG8gdHdvIGZpbGVz
L2RldmljZXMsIGNvbnNpZGVyaW5nIGl0IGFzIG9uZSBtaXJyb3I6DQo+Pj4NCj4+PiAtIGdldCBz
cWUxLCBwcmVwYXJlIGl0IGZvciByZWFkIGZyb20gZmlsZTEsIGFuZCBzZXQgc3FlLT5hZGRyIHRv
IG9mZnNldA0KPj4+ICAgICBvZiB0aGUgYnVmZmVyIGluIDEpLCBzZXQgc3FlLT5sZW4gYXMgbGVu
Z3RoIGZvciByZWFkOyB0aGlzIFJFQUQgT1ANCj4+PiAgICAgdXNlcyB0aGUga2VybmVsIGJ1ZmZl
ciBpbiAxKSBkaXJlY3RseQ0KPj4+DQo+Pj4gLSBnZXQgc3FlMiwgcHJlcGFyZSBpdCBmb3IgcmVh
ZCBmcm9tIGZpbGUyLCBhbmQgc2V0IHNxZS0+YWRkciB0byBvZmZzZXQNCj4+PiAgICAgb2YgYnVm
ZmVyIGluIDEpLCBzZXQgc3FlLT5sZW4gYXMgbGVuZ3RoIGZvciByZWFkOyAgdGhpcyBSRUFEIE9Q
DQo+Pj4gICAgIHVzZXMgdGhlIGtlcm5lbCBidWZmZXIgaW4gMSkgZGlyZWN0bHkNCj4+Pg0KPj4+
IDMpIHN1Ym1pdCB0aGUgdGhyZWUgc3FlIGJ5IGlvX3VyaW5nX2VudGVyKCkNCj4+Pg0KPj4+IHNx
ZTEgYW5kIHNxZTIgY2FuIGJlIHN1Ym1pdHRlZCBjb25jdXJyZW50bHkgb3IgYmUgaXNzdWVkIG9u
ZSBieSBvbmUNCj4+PiBpbiBvcmRlciwgZnVzZWQgY29tbWFuZCBzdXBwb3J0cyBib3RoLCBhbmQg
ZGVwZW5kcyBvbiB1c2VyIHJlcXVpcmVtZW50Lg0KPj4+IEJ1dCBpb191cmluZyBsaW5rZWQgT1Bz
IGlzIHVzdWFsbHkgc2xvd2VyLg0KPj4+DQo+Pj4gQWxzbyBmaWxlMS9maWxlMiBuZWVkcyB0byBi
ZSBvcGVuZWQgYmVmb3JlaGFuZCBpbiB0aGlzIGV4YW1wbGUsIGFuZCBGRCBpcw0KPj4+IHBhc3Nl
ZCB0byBzcWUxL3NxZTIsIGFub3RoZXIgY2hvaWNlIGlzIHRvIHVzZSBmaXhlZCBGaWxlOyBBbHNv
IHlvdSBjYW4NCj4+PiBhZGQgdGhlIG9wZW4vY2xvc2UoKSBPUHMgaW50byBhYm92ZSBzdGVwcywg
d2hpY2ggbmVlZCB0aGVzZSBvcGVuL2Nsb3NlL1JFQUQNCj4+PiB0byBiZSBsaW5rZWQgaW4gb3Jk
ZXIsIHVzdWFsbHkgc2xvd2VyIHRuYW4gbm9uLWxpbmtlZCBPUHMuDQo+Pg0KPj4NCj4+IFllcyB0
aGFua3MsIEknbSBnb2luZyB0byBwcmVwYXJlIHRoaXMgaW4gYW4gYnJhbmNoLCBvdGhlcndpc2Ug
Y3VycmVudA0KPj4gZnVzZS11cmluZyB3b3VsZCBoYXZlIGEgWkMgcmVncmVzc2lvbiAoYWx0aG91
Z2ggbXkgdGFyZ2V0IGRkbiBwcm9qZWN0cw0KPj4gY2Fubm90IG1ha2UgdXNlIG9mIGl0LCBhcyB3
ZSBuZWVkIGFjY2VzcyB0byB0aGUgYnVmZmVyIGZvciBjaGVja3N1bXMsIGV0YykuDQo+IA0KPiBz
dG9yYWdlIGhhcyBzaW1pbGFyIHVzZSBjYXNlIHRvbywgc3VjaCBhcyBlbmNyeXB0LCBudm1lIHRj
cCBkYXRhIGRpZ2VzdCwNCj4gLi4uLCBpZiB0aGUgY2hlY2tzdW0vZW5jcnlwdCBhcHByb2FjaCBp
cyBzdGFuZGFyZCwgbWF5YmUgb25lIG5ldyBPUCBvcg0KPiBzeXNjYWxsIGNhbiBiZSBhZGRlZCBm
b3IgZG9pbmcgdGhhdCBvbiBrZXJuZWwgYnVmZmVyIGRpcmVjdGx5Lg0KDQpJIHZlcnkgbXVjaCBz
ZWUgdGhlIHVzZSBjYXNlIGZvciBGVVNFRF9DTUQgZm9yIG92ZXJsYXkgb3Igc2ltcGxlIG5ldHdv
cmsgDQpzb2NrZXRzLiBOb3cgaW4gdGhlIEhQQyB3b3JsZCBvbmUgdHlwaWNhbGx5IHVzZXMgSUIg
IFJETUEgYW5kIGlmIHRoYXQgDQpmYWlscyBmb3Igc29tZSByZWFzb25zIChsaWtlIGNvbm5lY3Rp
b24gZG93biksIHRjcCBvciBvdGhlciBpbnRlcmZhY2VzIA0KYXMgZmFsbGJhY2suIEFuZCB0aGVy
ZSBpcyBzZW5kaW5nIHRoZSByaWdodCBwYXJ0IG9mIHRoZSBidWZmZXIgdG8gdGhlIA0KcmlnaHQg
c2VydmVyIGFuZCBlcmFzdXJlIGNvZGluZyBpbnZvbHZlZCAtIGl0IGdldHMgY29tcGxleCBhbmQg
SSBkb24ndCANCnRoaW5rIHRoZXJlIGlzIGEgd2F5IGZvciB1cyB3aXRob3V0IGEgYnVmZmVyIGNv
cHkuDQoNClRoYW5rcywNCkJlcm5kDQo=
