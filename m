Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAC607C7865
	for <lists+io-uring@lfdr.de>; Thu, 12 Oct 2023 23:12:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442861AbjJLVM0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 12 Oct 2023 17:12:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442372AbjJLVMY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 12 Oct 2023 17:12:24 -0400
Received: from DM6FTOPR00CU001.outbound.protection.outlook.com (mail-centralusazon11020017.outbound.protection.outlook.com [52.101.61.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BECF3BB;
        Thu, 12 Oct 2023 14:12:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ly3XRmwJhJkQkiQhpLGykYq3nU+69sgF/yZbHFFWvSZz1qZ8Qi+20BUMGb4SFMOz4mw+phnoKhA9szbay1jDcRFWcwuM29Dlfw2Njd7StznkCkglHRvaU3QuYjQmOEnfXS1bEwT7SK/MFaUnBlr96Y099fUmJ0HgssSc2xQAaFSpYGYbdSTAJ9EumlKivKPQUEQCdhLbDkvQKJ0UCGWCc9ltSCdMFNP90GIZqKoyIhj5BctXbHctRq/8V4+BAwBVg2K3uS0PxylLbS4Ubdhja72s+EXGiPitMMI63RgmCDWqJmdiR3hda82xmsxhGSDZCreonXaa65lqw5qf0mLFMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0dIJ9qY6nqAlWDUWjAeggis+IhnNGsSwPtRb3glWxqE=;
 b=Chy3Pcw2OFmJEcr9joe9hTDeTh+l26yOxVxGh6IMSqpn6JeefNFT8eC4NUTcSokeQfdH0tY0qUc6XUslKDBlV3wzgyN+UApgcBM/IkApV1IduUwVLOU5rY3uFSKN3PlY78xuJWRfvcX4ieKmS0SvBr5yWV5foa2p37m4donVNDajFIpgvQ5B90NODaRcE+Tz/Z3VVufS63tqVga+Zo33sdTJzlrFL1ddRKpo76/kePVU2uFxvVdJylSjGLorjxbipTHnS37iQAOUwcYJRF9jpP+ozunxTFb63FwQFGRcr9o9Nq6VHO8AxL23ZQAMeWvXeCotIvcv2HNw5Oh60/gNAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0dIJ9qY6nqAlWDUWjAeggis+IhnNGsSwPtRb3glWxqE=;
 b=honllblg2pgOnfjCdVLXSmRXmVtvNKOWozOb08kEtBeP+2c99UK9QsBXHYucvwFROHs1DvuzL4oVXEvtrxsYVq2V7j8BkDjQY5qCpA0deMKxXKT1XvKTr7bd+t5+DVySwZg/WzZ0Ym9G5wtH5/RDn6sVa2VmsKBkkTnOX/AzbO4=
Received: from MW2PR2101MB1033.namprd21.prod.outlook.com (2603:10b6:302:4::32)
 by BL1PR21MB3281.namprd21.prod.outlook.com (2603:10b6:208:399::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.14; Thu, 12 Oct
 2023 21:12:17 +0000
Received: from MW2PR2101MB1033.namprd21.prod.outlook.com
 ([fe80::4b06:fbc4:1ab1:f615]) by MW2PR2101MB1033.namprd21.prod.outlook.com
 ([fe80::4b06:fbc4:1ab1:f615%6]) with mapi id 15.20.6907.013; Thu, 12 Oct 2023
 21:12:17 +0000
From:   Dan Clash <Dan.Clash@microsoft.com>
To:     Jens Axboe <axboe@kernel.dk>, Paul Moore <paul@paul-moore.com>
CC:     "audit@vger.kernel.org" <audit@vger.kernel.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "brauner@kernel.org" <brauner@kernel.org>,
        Dan Clash <daclash@linux.microsoft.com>
Subject: Re: [EXTERNAL] Re: audit: io_uring openat triggers audit reference
 count underflow in worker thread
Thread-Topic: [EXTERNAL] Re: audit: io_uring openat triggers audit reference
 count underflow in worker thread
Thread-Index: AQHZ+JAylfbNgEMpYU+qEdC5BlzyarA9m/2AgACyf4CAACH1gIACSc/NgADBEgCABTGmpQ==
Date:   Thu, 12 Oct 2023 21:12:17 +0000
Message-ID: <MW2PR2101MB103342BED5785C37F5F078B3F1D3A@MW2PR2101MB1033.namprd21.prod.outlook.com>
References: <MW2PR2101MB1033FFF044A258F84AEAA584F1C9A@MW2PR2101MB1033.namprd21.prod.outlook.com>
 <ab758860-e51e-409c-8353-6205fbe515dc@kernel.dk>
 <e0307260-c438-41d9-97ec-563e9932a60e@kernel.dk>
 <CAHC9VhQ0z4wuH7R=KRcUTyZuRs7adYTiH5JjohJSz4d2-Jd9EQ@mail.gmail.com>
 <MW2PR2101MB1033E52DD9307F9EF15F1E85F1CEA@MW2PR2101MB1033.namprd21.prod.outlook.com>
 <23109a06-0f1e-4baf-973b-d0a3d208ea65@kernel.dk>
In-Reply-To: <23109a06-0f1e-4baf-973b-d0a3d208ea65@kernel.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-10-12T21:12:15.605Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW2PR2101MB1033:EE_|BL1PR21MB3281:EE_
x-ms-office365-filtering-correlation-id: 9379eefc-af2b-432f-c068-08dbcb67e9f7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gYAQSuW78QoC4BhWZ8G2Wa8c5WRG6oUz8CZoqVFr5+4rEXs6+tv2MsZdYECibxrM6j/fWZqnbrmbjmWzn4/2FKYLPwlwd2pgDLXbPQefKWHoJhErDB/FjASlPuhsY9ofm25+zMoy8oNnGRBQkfQzs6eoqbLKwmEzxa4BitkBYF7i9DrJnVSpMpZAG14ILBvL/mHpQI2uX0iO0JdCdQBAuFdndLd5vl0X2A7TJ7RUTXVbXLxay7QvtWsf7OzBj6NZ8csDIxitX5t33Ul5RUi1kNQqIjpwsrAUMcS4wRzkpD2/35WgLZDiiqx8Pufoib+neJDNf4Qrqfo6sBzsbV2gy8xUa2S5gyRHtVpDqPgm5BdYejX2kwQUdctv1F7I+xOpU8s6ArRNacVtyQJ1yLO82R/Je8jQMguXkZyaktOvSH4OV8m/wGquWIoZjGdcIcHy3G8skfaS1QIa3HYY194obM5ehjtSZCr0/iUKzELKabzSi30nbqgBzmaV/JPYNGAK6EI2bUfqt755fu0tYIlPkU+Icj9iajk/KxvibyyCTWqgY4APIMLTsSgtDGEqbBOJmz05wf6JI36E+dG9fcyFHidPv2oR8glfeUBdT1tLMh3sqPFSFOapjQKtSD1lOmDbnQUlHsxr+voQTkUcaBFTBtLsISuiDWOoSNTbEHNDTXM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR2101MB1033.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(39860400002)(136003)(396003)(376002)(366004)(230922051799003)(451199024)(64100799003)(186009)(1800799009)(55016003)(8990500004)(107886003)(26005)(122000001)(38100700002)(66946007)(66476007)(66556008)(76116006)(66446008)(91956017)(110136005)(316002)(64756008)(54906003)(5660300002)(41300700001)(4326008)(52536014)(8676002)(6506007)(8936002)(71200400001)(7696005)(9686003)(2906002)(10290500003)(478600001)(82950400001)(82960400001)(86362001)(33656002)(558084003)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?+hFjJZMpCWFLKnqZayA/9v0N+QtDLekk+jiwX4PBeMHfo0u0SkmJW5pQkJ?=
 =?iso-8859-1?Q?fP8cDTaZt9aV35cutQJ5fi2A28xsAyvvRFEgUBlo4X8q1zf1OSU3/Typx3?=
 =?iso-8859-1?Q?x3ntMy82Vr8VpcDxQ/MRylxJEWmw3I35UaWuNqkTDzK6soeWKwAFXAXHZB?=
 =?iso-8859-1?Q?u8S/RrqD/TKFb/a9SLCLoIOq31HjlTIncUieCMQ8cVkYYpv2SbMTUhsejz?=
 =?iso-8859-1?Q?wSU4SKUmoUAz8FkT5CS1LuVIk5lVz4OgUyTp/4M/BTp5HwcP76zMumIX9a?=
 =?iso-8859-1?Q?J+dTzFdmVIqVMhmzrHAUiaUb3g80W3UK5L6wHX6hzkeJOlzWsrX1fwHc4F?=
 =?iso-8859-1?Q?PHwwfazxGXkFO1OneHHxhYfQGpa7+azqUrseFOurkvi8le6LtgwMik1TS4?=
 =?iso-8859-1?Q?Q+e4FVBKWkDwnDx4id+gqA2kjRRFjD+/300bNjHqm+zhBKTgWh4hVNiMaX?=
 =?iso-8859-1?Q?ilSlPOcndqr78dKnNWOacmhSW+azdrL4jOsDwc4c5CV6GNIdAru9M8SHZV?=
 =?iso-8859-1?Q?V+Wx4PhxnRRkIgaxN5RR0vq0OrgQQq08lWVcn/io88qhB4RC/iHz7e+o82?=
 =?iso-8859-1?Q?SZeyQZzg+EXObJms2ZcRiY7htMcByFv22Tfe0LAAWuYvk6u2uKQvapYhwu?=
 =?iso-8859-1?Q?Gr5oir02WwKxfRX7J6uL46dgSZ33WqcN1RNVSto2gPMziQBcLqSyxLnSx1?=
 =?iso-8859-1?Q?V2divR++GrhD574J7hcvqWINDVXp2uZ88+x2MO0HX9v8OcJe50i4q5Zz7j?=
 =?iso-8859-1?Q?6VaroTALmaTAwGHp3Tgil2GmYGN+Wwb+IM6XKjSrjGRo6ToVt59ImaJ8iz?=
 =?iso-8859-1?Q?SYnjlwyVzuwALDoUQS6+VvZjggn5qeF3YrXMAQFg/HmwS8Vm8eJxWHzL2G?=
 =?iso-8859-1?Q?VBwiUN9GfuUFoc99bqLRt3M4IhrEw4IcQLa9UmfcrxV+MdbbM6tgUYw8SQ?=
 =?iso-8859-1?Q?bSWpwxLGp+Qa4kzzCKkE0OfPk7uL7B8MMFG2oLbLv4QYyVbeIaiRA+7ysa?=
 =?iso-8859-1?Q?utCWGOXnbpoU9SddD0f+Syu9JseyCQMesWaP54Mg9K4WHH78onmXMrkm0/?=
 =?iso-8859-1?Q?SJBCPU3qdR8ycGBn+9RBmjjBEG6nOHz0N5M1R/rpl673vhvauYTllgSJOz?=
 =?iso-8859-1?Q?278JNlBnkTVYf29ZmyPt39FlIvDR21JM/OFxC7m/QIydwgkSDsCErAa+Lb?=
 =?iso-8859-1?Q?asff+u97b2Af4IUruK9AEWNxqSY4BtFsz+D07h49kwNvfggSsezhvjowOZ?=
 =?iso-8859-1?Q?/zsNTSYUdgl8zwl/RR9G4TTTz0FBJum9vuOKEqz5Wezkvmgg2ciut1fYgG?=
 =?iso-8859-1?Q?cnB74QbYLXf7Pn7TaHMSVCIEhFPCVVdDpOyxugwtQHWE0QobBlTRMEGsSu?=
 =?iso-8859-1?Q?kKBsI0+ymcmahtQ1LYqQbFQN7lNL+0WgrhsRNluh7I0QDzQmcICDvIFu3R?=
 =?iso-8859-1?Q?FKT/BxsQMk759BFuJIKMuwEa35V+pIQv5g9gCV30vyH5LCUXu8RHwirXeS?=
 =?iso-8859-1?Q?XhMSVeTW4Qx9usQfRmjtWsIbe8GFF1ldlDOudJ7CFfcx6c81O9iAjxy9e1?=
 =?iso-8859-1?Q?SUV4G5KvjdSh1V6ndRyXe8htCcc75RbP1RYWkQDfo/NDEUTyLAQKeRiWD8?=
 =?iso-8859-1?Q?L/zq2r17zy17pObTDMTUPFT8WyszFAjg62?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR2101MB1033.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9379eefc-af2b-432f-c068-08dbcb67e9f7
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Oct 2023 21:12:17.0337
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XXmc8TvsKP5Fjx9M6nvLeMsFpezE1fed2gX73zl63lEIUmEXWwAGK2qWGh8nnq0Mkt8rpl4IxO5a0gW4H7JfxA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR21MB3281
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The patch will be sent from my alternate email address daclash@linux.micros=
oft.com.=0A=
Paul and Jens, thank you for your guidance so far.=0A=
=0A=
Dan=0A=
=0A=
=0A=
=0A=
