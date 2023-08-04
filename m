Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BCA177076B
	for <lists+io-uring@lfdr.de>; Fri,  4 Aug 2023 20:02:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229455AbjHDSCJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 4 Aug 2023 14:02:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjHDSCH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 4 Aug 2023 14:02:07 -0400
X-Greylist: delayed 873 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 04 Aug 2023 11:02:06 PDT
Received: from mx0b-003b2802.pphosted.com (mx0b-003b2802.pphosted.com [205.220.180.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18FAF122
        for <io-uring@vger.kernel.org>; Fri,  4 Aug 2023 11:02:05 -0700 (PDT)
Received: from pps.filterd (m0278972.ppops.net [127.0.0.1])
        by mx0a-003b2802.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 374GvV51015187
        for <io-uring@vger.kernel.org>; Fri, 4 Aug 2023 17:47:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=micron.com; h=from : to : subject :
 date : message-id : content-type : content-transfer-encoding :
 mime-version; s=pp1; bh=WaX33OrP02Xyb2yQ7lue10hd6/7QqSTMWd2J+uXMPmQ=;
 b=hQXCPxeiTLjRr6Ljij5r3hkfqLSBtTdDssXg54md72dMUz1jgpQwKqSM0L1jmp6HUopn
 1UAnIXShu6xQqQoD1DlK5eXGewfThblGYaPfuD2ycgCPCMXG4ZhXI6MpNcfK9p/BKpSW
 /Bzkw5756qZ4VvfItPbitdGHnGD9qCTD0ZNvKNxya0yiieR10HwpzkB/x4OJrH1yxm0J
 5AVgPYswhCIrvehwm0fcSurqgOOOyPevRjHIQT2ZfsMU+zu4mEIhAlDmXfrDo0LJhWdP
 oPfSpQ7TyOSaW3s6k06r1XHrOSk7G1RbIhmEqTqluN712iaKLK27N3EBhrOw0Ov2/Mho fw== 
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2047.outbound.protection.outlook.com [104.47.56.47])
        by mx0a-003b2802.pphosted.com (PPS) with ESMTPS id 3s8kn8223b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <io-uring@vger.kernel.org>; Fri, 04 Aug 2023 17:47:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JZpMIVHxfyTABxzStkBUocgtrJ/g1QA0PHf7Eex1/yc6Pyv9VR7tT8cGZWgjXbQNTz6gFFCSI2R0MdbadFPiyCm6W/x+sQAKDIjBvOh+9799IOjzmu4DGoG+L5V8UwGIHdFrNiH6dj9DGTf590jekwNlpEtYfTBOnkjhNiCFPA9gQVveAW7dQny7TpTeCu8Tw+Dx0OeChtRvfUqm7qvq60Ik5bVTRAoeHwr0anSVNEb9y7c5ZV273zVchXotM9jro2M11XoQUruTxINFiARWjchCWBFkVXIia1rsgRIA9OiwK2Hvx0NC8Gdmp6nn9V/SmRF2rL+tFUg7QR1Fqyil7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WaX33OrP02Xyb2yQ7lue10hd6/7QqSTMWd2J+uXMPmQ=;
 b=T+PV5U4yno4FvInEwv4Kn56oWGVrUUl/VS0Cly8fiJ6/WSPj7yivjVgwkOlFf53ta54VF7p0Yk5dnQGrd30PqDDxNt4XDObZak6RDO+orURxlfhDenhpCfYsTt8k5jnf765+7LLkwDrB7PtqjgkAUDZ8ZB+8D4Xcqus35tQveg5Rg33TqvCE1RBOWJQosTtmaarbDufc1CN1Z0jtIih/WoSOp8OuACwkahv97A1lquqduTocLZzwjcbKKVmI0If3OsE+sw8ZRA80eZ7MQzDASCQphwwmgQndfBY9rKcb1IKPIvcEiXz7f13XbyIxIEUaDEd0se850vv5LT4tecstLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=micron.com; dmarc=pass action=none header.from=micron.com;
 dkim=pass header.d=micron.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=micron.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WaX33OrP02Xyb2yQ7lue10hd6/7QqSTMWd2J+uXMPmQ=;
 b=T+FIbwZJX3PQNJxQMz5A6y9IHryM5uL+XAkNy56PbdEDACWXaDdxNPXKn4HtpJR3WPfiV6/oUHhiMHyovDKFLyW2zvzx1nOjMQrWyA8Bz6k6ror/AX8QLdb70Wh01Uc3Jv+v9I2bEa9SWN3YyPPDGkc7RWG9LZEi1/mp+d9sT9xOLHJ5W2T6nwro94yunYoQoz+QjcsL0gmnYS/vOg0WtVq/tMtneQZqOd5djvklzpfhQsoH8LY2IJSu3K/sIqFhdhord0njAOMLw6paiCnjyYe7txrcqGgmaBpvi1d3V+MJRvxayNeYLvUBzl1wEIeD7RZR9bJhTNSgnzZYCtJ7iA==
Received: from SJ0PR08MB6494.namprd08.prod.outlook.com (2603:10b6:a03:2d9::14)
 by CO1PR08MB6803.namprd08.prod.outlook.com (2603:10b6:303:9b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.21; Fri, 4 Aug
 2023 17:47:25 +0000
Received: from SJ0PR08MB6494.namprd08.prod.outlook.com
 ([fe80::34cd:9f53:6c28:603e]) by SJ0PR08MB6494.namprd08.prod.outlook.com
 ([fe80::34cd:9f53:6c28:603e%6]) with mapi id 15.20.6631.045; Fri, 4 Aug 2023
 17:47:25 +0000
From:   Pierre Labat <plabat@micron.com>
To:     "'io-uring@vger.kernel.org'" <io-uring@vger.kernel.org>
Subject: FYI, fsnotify contention with aio and io_uring.
Thread-Topic: FYI, fsnotify contention with aio and io_uring.
Thread-Index: AdnG+3NTgdyJzbysQdOcb9jFxiDj+Q==
Date:   Fri, 4 Aug 2023 17:47:25 +0000
Message-ID: <SJ0PR08MB6494F5A32B7C60A5AD8B33C2AB09A@SJ0PR08MB6494.namprd08.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_6fdea275-d6f3-438f-b8d8-013cab2023d3_ActionId=e49d2bce-7ab5-4a48-b4f6-1173f4750051;MSIP_Label_6fdea275-d6f3-438f-b8d8-013cab2023d3_ContentBits=0;MSIP_Label_6fdea275-d6f3-438f-b8d8-013cab2023d3_Enabled=true;MSIP_Label_6fdea275-d6f3-438f-b8d8-013cab2023d3_Method=Privileged;MSIP_Label_6fdea275-d6f3-438f-b8d8-013cab2023d3_Name=Public;MSIP_Label_6fdea275-d6f3-438f-b8d8-013cab2023d3_SetDate=2023-08-04T17:47:01Z;MSIP_Label_6fdea275-d6f3-438f-b8d8-013cab2023d3_SiteId=f38a5ecd-2813-4862-b11b-ac1d563c806f;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR08MB6494:EE_|CO1PR08MB6803:EE_
x-ms-office365-filtering-correlation-id: 2a53367b-95d3-45ee-86ab-08db9512dcf1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gtvOQGzTBBNN1fOGKyxeAyJFmmXHpke3JzdMvebGulZvlg8X9HLgCsKbk+KW2M0mRi+ycCeHiE2Ah1w1cIEEqx1hy48lTADOAJZKCMN+314WIvFt7kZKAhE1HXuhAKPg9t169YsADmYlDbQkGquEnO3ayiMj1jtWZx0wn1YWnpNq+/PV2ok4P8nhc3BvTKpnoGMTH/i/y72jJX8HkxBZiQYINsWcqhcdfFVSBh9ONhChKp+cFjip8nbUX0Tgw/QBmplg6zGmMCZnc/XwFveUpnmuiLOF1Ar128g+MWd/jTsaaFQFW3MecwC61OWb4TzH9Lu2u7EqIZRG9Q8eSZnv/qcZC8V+JdIUmKyVq9hqeuuZhs8s/9ahArwMJQuDM7rGR/R8Wk0TkM/gZAs69wmaij9DzltOQT5PdtDTIN1ONxqjnnBJA0zjWsx2tTegjv7CUmd3bgiVPcKa/BSAyrzkI0gAN7Uaq2zGg9XA0xxRjhbvFbdRELyrm2gNf6nLef+lgJcnK38MrPh6J3MNpCsHp4SHP+KdcR1qqJKNxeBcfJ4/Hb1mB7WqcO+6iZwJRC1HvNFFbZguurn+jZU1cPkmrQjJ5EuiFe7bEwYWGyFREJF9PoXA453WT5tEx/IXiNNM6KB0mCmRd4DZ34wIHN4k2Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR08MB6494.namprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(136003)(366004)(396003)(39860400002)(186006)(451199021)(1800799003)(52536014)(66476007)(66946007)(66446008)(66556008)(64756008)(6916009)(76116006)(2906002)(122000001)(38100700002)(38070700005)(6506007)(83380400001)(55016003)(86362001)(9686003)(26005)(478600001)(7696005)(71200400001)(33656002)(8676002)(8936002)(5660300002)(41300700001)(316002)(491001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?dG75wLIWVkqaW5f89On0wIXg/oHQkX+tnbVtUF+u8ly3fpH2KGFnUzJANKWZ?=
 =?us-ascii?Q?pd507xtdZbUrCwf0z5k56jRtn7NIf0mVe6cIL664xdcmi6RJ7x8XJ+Y1OY0r?=
 =?us-ascii?Q?D1sXpcRNz7dWfHd/W6Qn7ngv/S3A8V4Y53zfWQGWdt8gbeOnwzeYsDw1Vwcy?=
 =?us-ascii?Q?gcaewX0KskheghfJdlJuScKEuufsndsYKuchhgNpHcx15FDjUYSvkAH13DEa?=
 =?us-ascii?Q?mBgovy0JY0cnv8znJ0k+eNeZdapU8WR/H2eZt2Qx0F8Dbx4mj7Y1LLklvzpO?=
 =?us-ascii?Q?eumb5U7qvhw8eEJHcOGGRPYrw2JsYQPXd3lly1xoxllk9XGIzGasVjYxhFSD?=
 =?us-ascii?Q?ck9Yu11hRD+LBtUZHCS3jMOdMFehc3XZVBe4tJuBew2XYZa35kVBsWtW0YGO?=
 =?us-ascii?Q?apVe5vSERhWvrnA9H8HFxG2Qe+XUNl+ds3K3K/X9EzAqfWdURj1qHisC9f65?=
 =?us-ascii?Q?r9Nj0jC9JlGzMXC1wCKN4Enc1bLiPLxWy2V4KQLIx1odQdZuSPSFg03MEgF9?=
 =?us-ascii?Q?O2QRk+UW/9GvtM2dIr96CvzJ7SO/f4WODQmtel4ZupvoS1LEW8HWvKKcskw6?=
 =?us-ascii?Q?KmQ8Qk2+d0vL95TamnJWOu4TKOPuEfg6GyQXG20iyCmmNL34mpNGGQ7b1iVf?=
 =?us-ascii?Q?4TCZWl8EudJ5x8cmhwBupuzMo8Q4rGG/G5+tjb5/hc1U7l4kMpPgc6ID2awm?=
 =?us-ascii?Q?RUpZJlEdFlVj6sR9D5smB4qk17J5qZ8a9rgHJ8u9avNtCAMQ6dG6gfuBdSrl?=
 =?us-ascii?Q?MgtCAdgWNxAbfmSdx5KZSr21YM6YCTTygyPWVbGht9G9JdR5mgBknUIbPI5Y?=
 =?us-ascii?Q?aM9IlXrRpK6HmIUa0d4WHzQRsqxBzNWDi5NUi560+OUOnr98ufifkN9Thjzi?=
 =?us-ascii?Q?GWCO6qvAmZwjwUcirOH9pTZEaQVy78q+zw8VAkxu0aWBws9dJlOpbAdwAO/y?=
 =?us-ascii?Q?5wLH6h9cKGl3RgilkMdQ61olcMxx0OYi9D0lephaUWei+vPFn1RT2192pWW7?=
 =?us-ascii?Q?o3H3tu8BK0MNVFUnrj+7yOoCeRThfGL7Y6VAaYolI9YKO0fZEv/M9G33usmV?=
 =?us-ascii?Q?Hk1h3AuhiakcSr0hkWari/RNNoGR1E2qATAIz8CQEJS8CEADVp5tcH7YiFls?=
 =?us-ascii?Q?ywMzr1AqiTc/aSzrRQLirAcbhinkwe4Shohhre/8YNE8DB4Ob9Fz/f9M1UFB?=
 =?us-ascii?Q?IMhQ+NYvEpwuCrHhrHRMxV3Pfz4LdUZcUfl6lFEDfTbrYNGsMqNh4V5QJ0Bo?=
 =?us-ascii?Q?DxLniBIOAzt7ApAVmSoxQ2I8FzYdx991IJvvxMt1mN0oBb5JPpCeGk9aQ05Z?=
 =?us-ascii?Q?A+eWOZJp1yvTR/3c3BbmswIW5yPoQlOd1hkedZG1ruJmrcUOl/Rxd0fmNyYA?=
 =?us-ascii?Q?N+z5ekCt+pBpS/+eqI5V+ke7Nb9cWy7cKwPodxbVjk63UPFHuTX0DOypluHL?=
 =?us-ascii?Q?iymHllCZB/gjWpOT9/9FgiqtSrx1Szb/4XdHjCiGTY2+SKjlUo9pYHY6+9dO?=
 =?us-ascii?Q?vpChe9I3Yj1rjUIZda+227Ia7iEsTvLtTGaXAjYayZZznpw9FWMvkz6+iyUO?=
 =?us-ascii?Q?m5uUpXwTQkinkZ4i8AM=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: micron.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR08MB6494.namprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a53367b-95d3-45ee-86ab-08db9512dcf1
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Aug 2023 17:47:25.1630
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f38a5ecd-2813-4862-b11b-ac1d563c806f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Jzmmz63j2AXV4TrMfOUDmaogMD761OMFJQBnQnrN6hPZAwCTqgVljPqOSjmwrrkpQhNlYyIVr6I72DvgyxC1RA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR08MB6803
X-Proofpoint-ORIG-GUID: fSIXnTa7O7Pa424MQfliDkG8RosG2BcH
X-Proofpoint-GUID: fSIXnTa7O7Pa424MQfliDkG8RosG2BcH
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

This is FYI, may be you already knows about that, but in case you don't....

I was pushing the limit of the number of nvme read IOPS,  the  FIO + the Li=
nux OS can handle. For that, I have something special under the Linux nvme =
driver. As a consequence I am not limited by whatever the NVME SSD max IOPS=
 or IO latency would be.

As I cranked the number of system cores and FIO jobs doing direct 4k random=
 read on /dev/nvme0n1, I hit a wall. The IOPS scaling slows (less than line=
ar) and around 15 FIO jobs on 15 core threads, the overall IOPS, in fact, g=
oes down as I add more FIO jobs. For example on a system with 24 cores/48 t=
hreads, when I goes beyond 15 FIO jobs, the overall IOPS starts to go down.

This happens the same for io_uring and aio. Was using kernel version 6.3.9.=
 Using one namespace (/dev/nvme0n1).

Did some profiling to know why. On a 24 cores/48 threads with FIO 48 jobs, =
I got for the io_uring case:


# To display the perf.data header info, please use --header/--header-only o=
ptions.
#
#
# Total Lost Samples: 0
#
# Samples: 1M of event 'cycles'
# Event count (approx.): 1858618550304
#
# Overhead  Command          Shared Object                 Symbol          =
                          =20
# ........  ...............  ............................  ................=
...........................
#
    39.46%  fio              [kernel.vmlinux]              [k] lockref_get_=
not_zero
            |
            ---lockref_get_not_zero
               dget_parent
               __fsnotify_parent
               io_read
               io_issue_sqe
               io_submit_sqes
               __do_sys_io_uring_enter
               do_syscall_64
               entry_SYSCALL_64
               syscall
.
.
.
    36.03%  fio              [kernel.vmlinux]              [k] lockref_put_=
return
            |
            ---lockref_put_return
               dput
               __fsnotify_parent
               io_read
               io_issue_sqe
               io_submit_sqes
               __do_sys_io_uring_enter
               do_syscall_64
               entry_SYSCALL_64
               syscall
.
.


As you can see 76% of the cpu on the box is sucked up by lockref_get_not_ze=
ro() and lockref_put_return().
Looking at the code, there is contention when IO_uring call fsnotify_access=
().
The filesystem code fsnotify_access() ends up calling dget_parent() and lat=
er dput() to take a reference on the parent directory (that would be /dev/ =
in our case), and later release the reference.
This is done (get+put) for each IO.=20

The dget increments a unique/same counter (for the /dev/ directory)  and dp=
ut decrements this same counter.

As a consequence we have 24 cores/48 threads fighting to get the same count=
er in their cache to modify it. At a rate of M of iops. That is disastrous.

To work around that problem, and continue my scalability testing, I acked i=
o_uring and aio to set the flag FMODE_NONOTIFY in the struct file->f_mode o=
f the file on which IOs are done.
Doing that forces fsnotify to do nothing. The iops immediately went up more=
 than 4X and the fsnotify trashing disappeared.=20

May be it would be a good idea to add an option to FIO to disable fsnotify =
on the file[s] on which IOs are issued?
Or to take a reference on the file parent directory only once when fio star=
ts?

Regards,

Pierre

