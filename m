Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D41E7BD203
	for <lists+io-uring@lfdr.de>; Mon,  9 Oct 2023 04:38:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345024AbjJICiv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 8 Oct 2023 22:38:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345019AbjJICiu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 8 Oct 2023 22:38:50 -0400
Received: from DM6FTOPR00CU001.outbound.protection.outlook.com (mail-centralusazon11020026.outbound.protection.outlook.com [52.101.61.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46620A4;
        Sun,  8 Oct 2023 19:38:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WCHvJMchzZZOAeLeqDE7rlLUfmcu3bmEWHE3aRY4eQEx3NAyVlF42v00QrdXqNDbeBKaX84mMCwirQCgAxOLU/qlp53s90x+i07wBcax1RDuKHguScCc69W/ayjdwmwVTFHbYPp5zM/Zufhi8ToACHODHqj/YiQoa+HzDsXrLnunx5FyRu+6Lmbb1iU3fYt80LaNl0k3eK//Mn5+0Dv78JA0qt+eB7gK/klMZJrGr8dwRqKBh5YDcYsDXNJEi9EwuUlN/+8+0iXncehWIMqVUosGMsh3kgK65XWtH90mE0teAC+DENcgmC2CaHPMbRI45RjYrRjK1CC2CQUDh5GjnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z4eMNErAA0in4Y0HIxJgSKbt/bn/UZVDbSFDzsNH5vk=;
 b=JqcReFRLW9ChPBpmC+24p9dA18SeXAcDKULyp0ZG/4uDhMsa/BHWJ7V9TtnVostOacoLQ73L4X1Tga18mCMr7RT1JzYD1vo/EnHAFiJvMknofQGkEZ66p9qfQec14jNCAFky3ghG/IqRRiFrFHEttLqBTL4iLqU5tsg5TXgXV961MCGVKWDKj4kFgD/vQu8OFLfn3rW76ydq9Cr38g36ZOdlHYlkPL1n3v6S+SiKdwoWliHtZHlez+1xraE6rchtW3Dh/UHu7HHiWtVmugR+QwYIgiGESN5mBxy0u0RouoONEpJgkjTaSFXJfkv8rqRHADcvY/lZTMaQ3iUbMJU1JA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z4eMNErAA0in4Y0HIxJgSKbt/bn/UZVDbSFDzsNH5vk=;
 b=jDMa/sOl4bauo3JmQ4DdfkrJUS8bUORLxpGkG+vMbYPiI2LuA7ycFB/ySDzJ/uOPnYphDOJGfKRQmHw4cSLzob4mL9lnrhk0qV5KAhMTnVOPbTkZlC95mm2ujOGUXJlYmpe566SYQY6wgRS031jGvjZXiPF3UdDAPSP1g3yY5JM=
Received: from BL0PR2101MB1026.namprd21.prod.outlook.com
 (2603:10b6:207:30::21) by DS7PR21MB3077.namprd21.prod.outlook.com
 (2603:10b6:8:71::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.2; Mon, 9 Oct
 2023 02:38:44 +0000
Received: from BL0PR2101MB1026.namprd21.prod.outlook.com
 ([fe80::406:9bff:66c7:b01c]) by BL0PR2101MB1026.namprd21.prod.outlook.com
 ([fe80::406:9bff:66c7:b01c%3]) with mapi id 15.20.6907.003; Mon, 9 Oct 2023
 02:38:43 +0000
From:   Dan Clash <Dan.Clash@microsoft.com>
To:     Paul Moore <paul@paul-moore.com>, Jens Axboe <axboe@kernel.dk>
CC:     "audit@vger.kernel.org" <audit@vger.kernel.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "brauner@kernel.org" <brauner@kernel.org>
Subject: Re: [EXTERNAL] Re: audit: io_uring openat triggers audit reference
 count underflow in worker thread
Thread-Topic: [EXTERNAL] Re: audit: io_uring openat triggers audit reference
 count underflow in worker thread
Thread-Index: AQHZ+JAylfbNgEMpYU+qEdC5BlzyarA9m/2AgACyf4CAACH1gIACSc/N
Date:   Mon, 9 Oct 2023 02:38:43 +0000
Message-ID: <MW2PR2101MB1033E52DD9307F9EF15F1E85F1CEA@MW2PR2101MB1033.namprd21.prod.outlook.com>
References: <MW2PR2101MB1033FFF044A258F84AEAA584F1C9A@MW2PR2101MB1033.namprd21.prod.outlook.com>
 <ab758860-e51e-409c-8353-6205fbe515dc@kernel.dk>
 <e0307260-c438-41d9-97ec-563e9932a60e@kernel.dk>
 <CAHC9VhQ0z4wuH7R=KRcUTyZuRs7adYTiH5JjohJSz4d2-Jd9EQ@mail.gmail.com>
In-Reply-To: <CAHC9VhQ0z4wuH7R=KRcUTyZuRs7adYTiH5JjohJSz4d2-Jd9EQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-10-09T02:38:39.163Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL0PR2101MB1026:EE_|DS7PR21MB3077:EE_
x-ms-office365-filtering-correlation-id: 31002af5-1bb2-41d3-dd00-08dbc870daef
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DwZhhruk2BfdLXuKyUXMtB3uC4MaN1Nlk39BGszE2pQoeChQPjrG4iRQirOPvyeDemNk1YjDn+uMoN9QpfUcpqkWOr8ChdTXFxkCqf9OvcaTbVXKyZbvpxw7CPvsgEj6D1lsXs1CcSvbP2bpbKgb97mVCgIk/5Lp9Lsde4ykFw80piDO+zmePlSLxfcp2XrIKNgX6ZY42P3smmtMlhhnIWTV78BZmDmZyyS3ylrB05wJ2FZwcl6FHRwNi34clSgU8c06srCbyqL4ao01DK70nGi/cFo+Fk1femZdDTZVxj2z5KupMgPsm9aD8o3TEFArDXmhZ/kEXsesivajzDQA+sEdAw3u+XDA+UPayboxc4yZmZ1pk15q174r7DVFMQcYUXaGHoLfKF5I4AZVJdM0Id8/0hsR/0CX2NK0uFo8Ifus8gCyBT6/HsbY7apMDTXlxxqNZeZFPjsx1GSJk5sUGDkS2TNWSVxcpSe6Gy6pF9OVmlUNhvYLMjrwDQSrGm5BX8yx4eWpT47EP/9bvKzGEHxam7VHnDyoRbdv5c0O96HDsc5L73pqCeFNVUXEo+Sa4EsBQOlAMAMuLLlsaaUWzwY5CGykilsvoAFleAzaghHplDRVHOCyJqgx2A+IYJ31dOdoSQpIykiNw97h00KM+A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR2101MB1026.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(136003)(39860400002)(396003)(346002)(376002)(230922051799003)(1800799009)(451199024)(64100799003)(186009)(122000001)(38100700002)(38070700005)(82960400001)(86362001)(33656002)(2906002)(9686003)(6512007)(6486002)(478600001)(82950400001)(4744005)(10290500003)(41300700001)(52536014)(8936002)(5660300002)(4326008)(8676002)(71200400001)(83380400001)(8990500004)(6506007)(66476007)(64756008)(66446008)(54906003)(76116006)(66946007)(110136005)(66556008)(316002)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?WZ3uvGrei/bRKp9XZ3TzddDJc4oQK+kf2TegvA9JwKfWlYD1+FCOZfIE9Y?=
 =?iso-8859-1?Q?R0HogfHxyBQPFU5QRtcEiXI/dsBbkhOZW6liARgaV3ZIctK3OfjcktNTnR?=
 =?iso-8859-1?Q?yP+bXh63rFyVF2jM946zMt1zIsgkP/oEHJ9PmbUpE66beTiBmZSR/+o3EK?=
 =?iso-8859-1?Q?ChqMDV1AI0chbP4m+ch6UHupBvb5ht5R6rbftyl3sjBPz9vS7EVP2hrUF5?=
 =?iso-8859-1?Q?Mc51Jh5PNLA2zKiuCm+MduoYEaeU27XdEfvIvLv28JzHv+bpDzYpWo2G1U?=
 =?iso-8859-1?Q?Z2xUgZRiTMV3hf7ii6pMncaqv7FUCzAoe6Isf/eirBT6Npf1hTldfErtwD?=
 =?iso-8859-1?Q?oP6jwxOdOEQXO2Khrr+IJpFZqTZRy+RioApOQaXRVMd88wm3T6bIgrvaDL?=
 =?iso-8859-1?Q?+m9Fp1sJMR2X4TAAzPz/gw1y00Yt4iOjP7Fese0SZg2e4ceCi5FrFlVBAG?=
 =?iso-8859-1?Q?3F7Xeek69wDF1MhL0iKa7FZ9WK/bqZ1XWW4Z90JeI5cZUbYcdsaFLwtydt?=
 =?iso-8859-1?Q?Dd7hwutzV3h/tW95TVYyQ/p8VWqjP4tquz3l3UyZB6pbOQidwed37OANeY?=
 =?iso-8859-1?Q?uuKmFIqHOhGv6Iu2QYrUSatBjFj4IHY8i5R/m8N4dLiXxd2QVQXQpwcdVJ?=
 =?iso-8859-1?Q?BmEWhLO8W6msh3vXq3pq310lbiq5ax0fKh4yl3kLUKLNLtY5WR0V4/gJTW?=
 =?iso-8859-1?Q?O+EzmfeLx8obDKjojX/AVfPdLmriqFTwp22Og2EMTlnEb0IhP5fhfA3HmX?=
 =?iso-8859-1?Q?4UvG5HaCBReK1JRksmEQ6Dm0DCQ7pYJYCzraYuR64ZmEhrJNHpiCJzPp5p?=
 =?iso-8859-1?Q?+9PpvwrMFeSZ5o9IGrgbmx9ximbd5YNJC5SW0wOtnmVMl6bI7y7CRbaTGs?=
 =?iso-8859-1?Q?dwhHXxNbiwUYd8sNoNBf2RY74A7qiJPOzp016VMJ9WLSBrLJbloEFq9skH?=
 =?iso-8859-1?Q?Mr3Q3Qfy6QNUcrJ1BadyKaM5qu77HzI6DzRX6xYSaK0IkGoi5hH87N0N4d?=
 =?iso-8859-1?Q?7oBVRj7nL9GwDaCyGljI5rhnm8sffLhg59e7/ATdYpqsD66wayAG7GQwD7?=
 =?iso-8859-1?Q?Zm4KvPLW5WgY1FHLFiPz72j0md8ZhOsRO3LxW/arHSJfuFAF+YQR67Cnzk?=
 =?iso-8859-1?Q?8Swnb8JtO/2OcYBTvUug0sGf1aqARAA5KHCcmSsXYStt1iQLurD5DUJrjc?=
 =?iso-8859-1?Q?9iSgSS/ZVet/pKFXsKuKJ4Mym8KCi9LcBILFVKJxN2gwsLnws/mzPAQMy6?=
 =?iso-8859-1?Q?D4/lBK3KNHCHKid6bcrtOmqlyOunMQI2cLX7/BOHEsIr/3EeKzKVL84mCV?=
 =?iso-8859-1?Q?jtrNZGg+APR8p5wT9fkRif0rN5Ozwae2LRDYAmX1CdtYvCJRU8bUgIBFOQ?=
 =?iso-8859-1?Q?PQUKU0NgdIq4CNCh47HbSq286dwe6r+ds6uBccVutShK6/iU0SOjuPH6vc?=
 =?iso-8859-1?Q?Rh7rbU6gKOjdJooRG8rRKH/8MUxk3VLOEb3N527YvNwCCJ+OVtt87Ii+SZ?=
 =?iso-8859-1?Q?t84inNgMdexkMeMPiHaPRs1n9J2f6sLwnr+bIJDv5Pden8U3zBopDnDQto?=
 =?iso-8859-1?Q?q7jl8l2AIyErQbsgbCJ9YN2P/6gxxHEG6KCQNs/q9kgnoSaFk209S4LLVM?=
 =?iso-8859-1?Q?5jsihaFwzftsxj/RsFWoZWKrNDILCMdUMN?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR2101MB1026.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31002af5-1bb2-41d3-dd00-08dbc870daef
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Oct 2023 02:38:43.7517
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wNzzkHRxjubf+zKhG4Qby9+JHv3haH720z3GeBrm8roT379VTth50hPmaJHdGOInfOQ9vKC4+m5qG3LM4bcFzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR21MB3077
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

I retested with the following change as a sanity check:=0A=
=0A=
-       BUG_ON(name->refcnt <=3D 0);=0A=
+       BUG_ON(atomic_read(&name->refcnt) <=3D 0);=0A=
=0A=
checkpatch.pl suggests using WARN_ON_ONCE rather than BUG.=0A=
=0A=
devvm ~ $ ~/linux/scripts/checkpatch.pl --patch ~/io_uring_audit_hang_atomi=
c.patch =0A=
WARNING: Do not crash the kernel unless it is absolutely unavoidable=0A=
  --use WARN_ON_ONCE() plus recovery code (if feasible) instead of BUG() or=
 variants=0A=
#28: FILE: fs/namei.c:262:=0A=
+       BUG_ON(atomic_read(&name->refcnt) <=3D 0);=0A=
...=0A=
=0A=
refcount_t uses WARN_ON_ONCE.=0A=
=0A=
I can think of three choices:=0A=
=0A=
1. Use atomic_t and remove the BUG line.=0A=
2. Use refcount_t and remove the BUG line. =0A=
3. Use atomic_t and partially implement the warn behavior of refcount_t.=0A=
=0A=
Choice 1 and 2 seem better than choice 3.=0A=
=0A=
=0A=
