Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF27E67C166
	for <lists+io-uring@lfdr.de>; Thu, 26 Jan 2023 01:22:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235651AbjAZAWP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 25 Jan 2023 19:22:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbjAZAWO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 25 Jan 2023 19:22:14 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31C2F62D0C;
        Wed, 25 Jan 2023 16:22:12 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30PM3mDL006761;
        Thu, 26 Jan 2023 00:22:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=PbFZswrlN7qKi5FcvUOZPqeIMLDZix2uxtBL9DIXX28=;
 b=m+86aHrkefgZ+sSMD1OeemT5ebDjQAZVZQ/jtcyY1QQyeTpqZ1WmqMS1LCtksOIJKN95
 RFzYAiioaxUjWfvLn/4rljHdlPMSoRG8y+XQxmcuCfLvtj3HcQMRbH8WXAgnz8wYREhJ
 JW1zHptqjXYRFc55rG/QK0m2DV5qK9Pf4ktJXyMCi59R91N7Y0ItSnjIhVxHJTHSIa54
 C/mq+9Y0D1OmNuByX05j7/K8eGEu1mCxNbuPhwGGnszXvhxxH7S9Q3VRxxKasMi6BY8C
 aA8eM0UBznb5++EJOpjbtxbR4JMp9wZS8r6WhKbPqoq2GK8P7DrFGLm7kxmQ1u+Ysigq 8Q== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n883c9ewf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 Jan 2023 00:22:09 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30PNs0Zn034154;
        Thu, 26 Jan 2023 00:22:08 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2176.outbound.protection.outlook.com [104.47.73.176])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3n86g7aatr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 Jan 2023 00:22:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d9jMpti3kWFxRGNBASBCzVFdZO2/cEYA3ugiKI4y/pHi7Yfj6dqQga/yDOR6Q+MryNLK1ZHdW+QbrhuWWQrWT1rTsFj/AxRM9ZDKc5xcqHJs9rrjdsq1V/LBEEd3qC7bWkIGZfPtV3COEOWMO3e7o1vjEd+QpOR+AHJuwzdcX0O7GcCIdOvPemVUj5PJeXYf8SCTe59wkbwejFZtmJwWgIlUNaLugKWOAEc67WAbGAfF/TgOsQm9qQJFyDNOq5GMoWg1cXxgDgBopTpFE7NR7UOaiQx6n+qGB9JhvYtTr3He9PvdoB5oMXdXsZHAyKtz9MuqraKFlpMhTD86VJGqig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PbFZswrlN7qKi5FcvUOZPqeIMLDZix2uxtBL9DIXX28=;
 b=cMVgo9RqTt7QBWfsLjx587hp2/nWV7Ezi/Kq9ccYmFWQ+/dODAgFVZQPRC/+Z5P7joTL6wFtvjygZEb+CrAf+z2wWNFVn4XSwMS3upqySQ9ig0kNJdQA9ctKmLNWlHuRcPNidGxKLrg5H68NzNPTFyH93R8dQRmY074DxJxrR90qVF9kUFJinycQTTZ/Q03PZVApBVx8YfaDcqFHa31cOfNEjaWHeRq1g+J9IkWiEm/DCdH/LRRl5NH2orw8zTnfXiwQBAouVZAuQD7d2hTYz/q0OIGJtdTujwxXQ9no0TaThFlGwdvQTY4CrJvvkTVpsSxaCv+J8+2nOMgdWv4EWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PbFZswrlN7qKi5FcvUOZPqeIMLDZix2uxtBL9DIXX28=;
 b=ZmveHZ4Lma828CeCisYJA5lxP8EDcUW4IDiAR54lMD6z74RtiWiuLIbF1u1DdbXaj6xuNDQhMqVZlnlv5b2bmUupRnIF9M1CVaZ37HhzedJRCaUvXhjiokJ3kkUYOQ7bG0jtBWPCMseV6IrJEItvY8kWOtm8q9tSRZWAcqji0N0=
Received: from DM5PR10MB1419.namprd10.prod.outlook.com (2603:10b6:3:8::16) by
 DM4PR10MB7526.namprd10.prod.outlook.com (2603:10b6:8:17f::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.20; Thu, 26 Jan 2023 00:22:06 +0000
Received: from DM5PR10MB1419.namprd10.prod.outlook.com
 ([fe80::d40b:5b2b:4c3d:539f]) by DM5PR10MB1419.namprd10.prod.outlook.com
 ([fe80::d40b:5b2b:4c3d:539f%11]) with mapi id 15.20.6043.020; Thu, 26 Jan
 2023 00:22:06 +0000
From:   Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
To:     Jens Axboe <axboe@kernel.dk>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
CC:     "asml.silence@gmail.com" <asml.silence@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Phoronix pts fio io_uring test regression report on upstream v6.1
 and v5.15
Thread-Topic: Phoronix pts fio io_uring test regression report on upstream
 v6.1 and v5.15
Thread-Index: AQHZLIV4mOt/DdJ4vU+NNe3w1KZyBa6v2J4i
Date:   Thu, 26 Jan 2023 00:22:06 +0000
Message-ID: <DM5PR10MB14190335EEB0AEF2B48DF6BAF1CE9@DM5PR10MB1419.namprd10.prod.outlook.com>
References: <20230119213655.2528828-1-saeed.mirzamohammadi@oracle.com>
 <af6f6d3d-b6ea-be46-d907-73fa4aea7b80@kernel.dk>
In-Reply-To: <af6f6d3d-b6ea-be46-d907-73fa4aea7b80@kernel.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM5PR10MB1419:EE_|DM4PR10MB7526:EE_
x-ms-office365-filtering-correlation-id: d3c9cf9b-e5e3-4ac2-271b-08daff335af8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mUbjhXUR5TE8cLz7ELhJDy03PBklvH2mxFk4rE7Og00W4B9HUxqOaouFfDSk8IdN4LjsqL6G9WziVPqPeHVYs32UdwyGjpSywta+73dxyPRI8CkhLBpn96jr/T61TVZnGGh+xKy2PgxP9aaYBMiwMzGyuwgZq7L81doJ5kwJkG2NxhKHbDe/EFFI/s73Joh5KuylPx5Y7ppPRM/Atr3C9+UMRgT8xrBqLuvQ4RIA77KV+v20vJdugsUOIy23J8vZU2ZIPdnIFZT8JdTQL2+e7eal9wixcbMNOzazgS4SgypZG6HWQK+HhJ+dRdqTFU2D+jrZw5W03w3QZCD6qBb6DCsyfugZH7xNoopxYrbTXDJeWcR7hCu02sJV1ebsqfozA51d2oRxrFGZe2gnAGfBK9Kgz1kxYU4tuCnF9cxJBqpJYfgdVdqqkZsmnQmnUXjhTFYuQPb/ASxPm+burOo7zpY8l7GZzi3DkT/wyRzJWQLd4wEydFIZCS8R+sG0L5YhNoOnS4WfhZqqHhBE719TUGjU7yowJISWzphhe8hJ/6ZtvDn5uNlOfmYzddKGr+lINE+6aY5llJce41yduKKZIg0RqrzC0anOkEt0SoSartxk6d9BQhOEarCejRjl9/OXf/vjM3ye7rleuT9NltH8YtTCixZwOIGQ0EiPTscwi4GTx32zz6/4OJBFokCYs+7utzzuvqRgfPG6sVfUrahV/9a2OOGqoDkoeLR5WLr8txjKFnXPJACnUNGDLbJJU2a5IpmBhs5Dv6AEqMYGaRTIfA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1419.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(136003)(376002)(39860400002)(366004)(346002)(451199018)(966005)(7696005)(71200400001)(478600001)(6506007)(53546011)(91956017)(186003)(86362001)(9686003)(38070700005)(110136005)(33656002)(54906003)(316002)(4326008)(55016003)(5660300002)(52536014)(66446008)(66556008)(8676002)(66476007)(76116006)(64756008)(66946007)(83380400001)(38100700002)(41300700001)(122000001)(44832011)(8936002)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?Y9OF2iucYJh6MKuQSw1n1Pu+GYMO/NqDmjdPIpuBFiK2l7o5Jb+0ArjQlF?=
 =?iso-8859-1?Q?XdLJkZKYs/sMFbZlbyu3UAA35ehIP0F4jA/m8ca3selw4OgV8NUojpR1re?=
 =?iso-8859-1?Q?WIJZEHh2OMzo2DQlM5grAgzRuaAG5IcGLbs/ZKtJT5Es3c0DRSXrm+l/0R?=
 =?iso-8859-1?Q?1Q+gdnxjLadcKBt+NhO/7IgDB/mpJH1zjKSjLIarH1epc5CY9cDySdwFK/?=
 =?iso-8859-1?Q?GKgDG5W/6/PsyR1g8D+EdvLzKGl+nuS6kF5kLtYI6vRXHPlKCErJvZCori?=
 =?iso-8859-1?Q?rNT+D6CppV6zhQLiF9IQP3WTy4yTomLfu7FPdUYIPTRTCVdK5IT4plxLO9?=
 =?iso-8859-1?Q?ygNKjAnZ30pmxOBW+phHgTPgiKrR1cnbkMz68ldVfNSvrshDoQJoxIRArs?=
 =?iso-8859-1?Q?7RPXYf5bYlX+7qV+FWgiUAjujKj6RrUOAsWqSGkFMKSq5zDA6IY88n1pPE?=
 =?iso-8859-1?Q?mTc17mdpMiX6OA6MscgDgd8c9awIAC0C/AUZwSqKCyalXsFhkYVCxe19+h?=
 =?iso-8859-1?Q?xLnRMeRNy1QURwboX6KXfN0k0Y5V6bI2LG4e88b2vOSU9t65CcIvVbSiqt?=
 =?iso-8859-1?Q?lCPkHo73/C4N7ZQdphjhkwoj/6YN7ZTKnOtUH8IJSo/eB4T7jhcIguoNWb?=
 =?iso-8859-1?Q?dw9ja58PdVliGYLKlNRVVBELjUDIhSYn6QYbqJ1oXMzOVU2Wt2OqgpySfK?=
 =?iso-8859-1?Q?Lbom3yeV6dHT7Iu/NfIE0ss5ytW6ZWbSFR2fybWNefBau0k6Itl0hldsLW?=
 =?iso-8859-1?Q?Z2A+7AU4M7dUTl/+xKGl3A6zJ8PLJzKpYKdXtDw4Ceevyw8KLYgi4Zqjpg?=
 =?iso-8859-1?Q?TAWwotBxszTMN+foUc55gLFFz45Ustz/Cso+R/PstSAR6jWWlWibd9iROC?=
 =?iso-8859-1?Q?uU5sKAy8h5sh3jb2LYgJVPLUB8mRIZAjMTEf8Gwr6ocKbUWJI8K4zcZ7bc?=
 =?iso-8859-1?Q?SaRFObDsibah+JAIx82cnpnsbPPt9xJLQ9//X5qQ4BuLYIHjr+lk9bP42N?=
 =?iso-8859-1?Q?S7qPah8OMxUNYk0vdbj1RG+BsUbdRpFc1iREub5bTWEPaqh9TPyeU6Yf19?=
 =?iso-8859-1?Q?dkp3yMf2713JrHYLNLB9bNnA5cpzrznPnFfkUYZYGzpUIgjJOuFonwdCXl?=
 =?iso-8859-1?Q?Qden+hFQcLslmD3krtjJ2PxH81c7fWYu5rMSDwSha/5/BT24xPNdRVN5Ia?=
 =?iso-8859-1?Q?CeOzNEbff4VrPev/5fgZDsXPg5a2KCpDJ38Dt0D7UZhGWfO8WtbE6Mt3KO?=
 =?iso-8859-1?Q?jGyFV7/QLJc5jqILSttnVEn8a74vXcGNqQ0El/AswyYmdTLZFOWfFDGonY?=
 =?iso-8859-1?Q?rasUIZi0xfo8r5Jl8ManqR6qFaHPK0iughMTYea4Sk7aY0IUC52/yGQ27p?=
 =?iso-8859-1?Q?k3zIHhIOEffptFr11zcjYN1gvEPjxI/ImYpFdJZaY7SvfqZmJkUW8zBdGr?=
 =?iso-8859-1?Q?Rp1CB/GJ/C0mzG0XYBeMmdoqcSYu5rMzJv7HOtE4ZpExP8NvsngPhn8X+d?=
 =?iso-8859-1?Q?n1769/nGYlttulRtuQhTwyHfllaPsEirHF9Vu/PwktKKljClWiqft+BoVD?=
 =?iso-8859-1?Q?V9rCMu6aCSLRkE5ZqZhwP6Va1Q3T8Od+w5AUW1dYXl0btzkIx3/540i6mf?=
 =?iso-8859-1?Q?mkoeUWGaWKqwW1FVPw0F3cTXXFVWXyMWEg6bY0QQWzWJ1xiqvlcnELZSKw?=
 =?iso-8859-1?Q?NkKubQLX3Rvz/h20f0Q+2zXl+VFxiz3AGHvZ9+GO?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: rxnNawJVkhMu9Gsq4yLdJugvMOkNp2iQfGlSjRwepD0PFyQ8JMBmtRcg7Z0CkAMa5rW0IRYfa8257pDe8kR3DmMxfcV49XZYiXMP96q8DHNFsPwCa14Slf5uWkvlg6m7XSc/TA0QHsd2jvLzZiwMMkSF4oJcgkX5Y+MJ4bqFIC2Zr/pfpvwSHrOLVDn8pBmKJtP6oNjhLbCW2cVrtTQZIWY05BtD+/G5bAprNgjkXzkwusTxsLyOsf4tbgGtRAwygkmxmLiUq5LIo9vnUbcL+G4XkNNgaEikZ7Hlag64doJrjMli78ViD725zIr1pa6YRnlH5hYMqGpgUi+W+floujSKFq0Qw7oA1verEoAY3UuwkR74iG5o0iXTgx9jz1N4LU/xW62c8bIIW9t3RzqguxSpSeB7hc2k9RnES/dNEIgcr0AFenjX+Iid0MO119b3/AdbGRb10P1TPdv6pAK0wEtp4DylhWQYJe+8cSbg+vlxa/9sZvM15jlt7JL1wrNwUZa66MONjdrGWw5uC/KaOXdckGr2wZE4VQLUb5AaAyJ2sIa6NBRkjYKGoBVOavt5ISoYgHlTNIPULIIF+cwMx3oiVBeXfIGDAgPjsIxo3Z850f0wvuYehl9OhLW+VHsUDPAVuoaNC/rA8k01Cq+rIUAJrCXj9NHrmWonNAM3tbUAO+aAte7brtSkKjBk2d7A4j7RqOVDWBChwNFxoeoJa/WgXnOTBGNDv5JfL+oR7zzRp7AuVWiLCrVREHVwwVgElZotJmSKqKliHi8HVPM35RaXCWFKbuOJnTOCsxZB0Nl5QqANlbhy5PXfVYpc2ka+
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1419.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3c9cf9b-e5e3-4ac2-271b-08daff335af8
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jan 2023 00:22:06.0348
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MXgD99Z+YIfVfcnsgCzb7Q5kGEVa8a1joDcnzXkBdUuLwupwx0noE+ZMNDWu8VABS5PfmF0tPAdLPne2MbjXWrr9J6rJltzWuAeloLFY83M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB7526
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-25_14,2023-01-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 adultscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301260000
X-Proofpoint-ORIG-GUID: 84JBZ6KGSl2EKTVvGp6qtf13v1EBlmdO
X-Proofpoint-GUID: 84JBZ6KGSl2EKTVvGp6qtf13v1EBlmdO
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Jens,=0A=
=0A=
I applied your patch (with a minor conflict in xfs_file_open() since FMODE_=
BUF_WASYNC isn't in v5.15) and did the same series of tests on the v5.15 ke=
rnel. All the io_uring benchmarks regressed 20-45% after it. I haven't test=
ed on v6.1 yet.=0A=
=0A=
Thanks,=0A=
Saeed=0A=
________________________________________=0A=
From: Jens Axboe <axboe@kernel.dk>=0A=
Sent: Thursday, January 19, 2023 8:12 PM=0A=
To: Saeed Mirzamohammadi; io-uring@vger.kernel.org=0A=
Cc: asml.silence@gmail.com; linux-kernel@vger.kernel.org=0A=
Subject: Re: Phoronix pts fio io_uring test regression report on upstream v=
6.1 and v5.15=0A=
=0A=
On 1/19/23 2:36?PM, Saeed Mirzamohammadi wrote:=0A=
> Hello,=0A=
>=0A=
> I'm reporting a performance regression after the commit below on=0A=
> phoronix pts/fio test and with the config that is added in the end of=0A=
> this email:=0A=
>=0A=
> Link: https://urldefense.com/v3/__https://lore.kernel.org/all/20210913131=
123.597544850@linuxfoundation.org/__;!!ACWV5N9M2RV99hQ!KM7c30r4OiqvkxVW44cy=
Wb3rZr85i28yKto8WAAcj8OgWAOp-ebzcrHuggGw96ivMFCARikAEWwjhUBYFqujONc$=0A=
>=0A=
> commit 7b3188e7ed54102a5dcc73d07727f41fb528f7c8=0A=
> Author: Jens Axboe axboe@kernel.dk=0A=
> Date:   Mon Aug 30 19:37:41 2021 -0600=0A=
>=0A=
>     io_uring: IORING_OP_WRITE needs hash_reg_file set=0A=
>=0A=
> We observed regression on the latest v6.1.y and v5.15.y upstream=0A=
> kernels (Haven't tested other stable kernels). We noticed that=0A=
> performance regression improved 45% after the revert of the commit=0A=
> above.=0A=
>=0A=
> All of the benchmarks below have experienced around ~45% regression.=0A=
> phoronix-pts-fio-1.15.0-RandomWrite-EngineIO_uring-BufferedNo-DirectYes-B=
lockSize4KB-MB-s_xfs=0A=
> phoronix-pts-fio-1.15.0-SequentialWrite-EngineIO_uring-BufferedNo-DirectY=
es-BlockSize4KB-MB-s_xfs=0A=
> phoronix-pts-fio-1.15.0-SequentialWrite-EngineIO_uring-BufferedYes-Direct=
No-BlockSize4KB-MB-s_xfs=0A=
>=0A=
> We tend to see this regression on 4KB BlockSize tests.=0A=
>=0A=
> We tried out changing force_async but that has no effect on the=0A=
> result. Also, backported a modified version of the patch mentioned=0A=
> here (https://urldefense.com/v3/__https://lkml.org/lkml/2022/7/20/854__;!=
!ACWV5N9M2RV99hQ!KM7c30r4OiqvkxVW44cyWb3rZr85i28yKto8WAAcj8OgWAOp-ebzcrHugg=
Gw96ivMFCARikAEWwjhUBYbOxQftI$ ) but that didn't affect=0A=
> performance.=0A=
>=0A=
> Do you have any suggestions on any fixes or what else we can try to=0A=
> narrow down the issue?=0A=
=0A=
This is really mostly by design - the previous approach of not hashing=0A=
buffered writes on regular files would cause a lot of inode lock=0A=
contention due to lots of threads hammering on that.=0A=
=0A=
That said, for XFS, we don't need to serialize on O_DIRECT writes. Don't=0A=
think we currently have a way to detect this as it isn't really=0A=
advertised. Something like the below might work, with the caveat that=0A=
this is totally untested.=0A=
=0A=
=0A=
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c=0A=
index 595a5bcf46b9..85fdc6f2efa4 100644=0A=
--- a/fs/xfs/xfs_file.c=0A=
+++ b/fs/xfs/xfs_file.c=0A=
@@ -1171,7 +1171,8 @@ xfs_file_open(=0A=
 {=0A=
        if (xfs_is_shutdown(XFS_M(inode->i_sb)))=0A=
                return -EIO;=0A=
-       file->f_mode |=3D FMODE_NOWAIT | FMODE_BUF_RASYNC | FMODE_BUF_WASYN=
C;=0A=
+       file->f_mode |=3D FMODE_NOWAIT | FMODE_BUF_RASYNC | FMODE_BUF_WASYN=
C |=0A=
+                       FMODE_ODIRECT_PARALLEL;=0A=
        return generic_file_open(inode, file);=0A=
 }=0A=
=0A=
diff --git a/include/linux/fs.h b/include/linux/fs.h=0A=
index c1769a2c5d70..8541b9e53c2d 100644=0A=
--- a/include/linux/fs.h=0A=
+++ b/include/linux/fs.h=0A=
@@ -166,6 +166,9 @@ typedef int (dio_iodone_t)(struct kiocb *iocb, loff_t o=
ffset,=0A=
 /* File supports DIRECT IO */=0A=
 #define        FMODE_CAN_ODIRECT       ((__force fmode_t)0x400000)=0A=
=0A=
+/* File supports parallel O_DIRECT writes */=0A=
+#define        FMODE_ODIRECT_PARALLEL  ((__force fmode_t)0x800000)=0A=
+=0A=
 /* File was opened by fanotify and shouldn't generate fanotify events */=
=0A=
 #define FMODE_NONOTIFY         ((__force fmode_t)0x4000000)=0A=
=0A=
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c=0A=
index e680685e8a00..1409f6f69b13 100644=0A=
--- a/io_uring/io_uring.c=0A=
+++ b/io_uring/io_uring.c=0A=
@@ -424,7 +424,12 @@ static void io_prep_async_work(struct io_kiocb *req)=
=0A=
                req->flags |=3D io_file_get_flags(req->file) << REQ_F_SUPPO=
RT_NOWAIT_BIT;=0A=
=0A=
        if (req->flags & REQ_F_ISREG) {=0A=
-               if (def->hash_reg_file || (ctx->flags & IORING_SETUP_IOPOLL=
))=0A=
+               bool should_hash =3D def->hash_reg_file;=0A=
+=0A=
+               if (should_hash && (req->file->f_flags & O_DIRECT) &&=0A=
+                   (req->file->f_mode & FMODE_ODIRECT_PARALLEL))=0A=
+                       should_hash =3D false;=0A=
+               if (should_hash || (ctx->flags & IORING_SETUP_IOPOLL))=0A=
                        io_wq_hash_work(&req->work, file_inode(req->file));=
=0A=
        } else if (!req->file || !S_ISBLK(file_inode(req->file)->i_mode)) {=
=0A=
                if (def->unbound_nonreg_file)=0A=
=0A=
--=0A=
Jens Axboe=0A=
=0A=
