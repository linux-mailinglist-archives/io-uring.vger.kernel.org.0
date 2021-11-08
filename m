Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 051C3448093
	for <lists+io-uring@lfdr.de>; Mon,  8 Nov 2021 14:50:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240097AbhKHNwg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 8 Nov 2021 08:52:36 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:52390 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238814AbhKHNwg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 8 Nov 2021 08:52:36 -0500
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A8D0d8w008796;
        Mon, 8 Nov 2021 13:49:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=i3pi22l8iJePjFaFknTDtVJ9TRx97g6w/18uN/tdHiI=;
 b=0uYyg2njJVD8W7oMlN/ndB9PibGCLX7Lbu+LTs4M8J4mxlPBxRgjgcT5RNULUKlrMed4
 fuPGP3AtJw3N5gglt6H8BTAhPR4J5M2Rpjnn/KR56rgOEtUXkXdO3l7lN1gPb+iniXzn
 kgH0jwSnU7eu5uYQZSYyKrVOB9VhcrGtywHzZqs7tBAVsF5Ug5S870kEHuG5ZBMkDX54
 ZW8xwNkkjwYYKZqMjaN2/C36WWG6kLfLfLMHQNJcHkSBtoHW2yqYHsq4sR8xhUgeTNl/
 RXLnDhg1587Hah+CYswScFbnE1fhYoOT/9MVCBwMs+JWWqFBWLDR9HfSbAA8AAEjosye ww== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3c6vkqtyf1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 08 Nov 2021 13:49:50 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1A8DjvcV001745;
        Mon, 8 Nov 2021 13:49:49 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        by aserp3030.oracle.com with ESMTP id 3c5frcamnq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 08 Nov 2021 13:49:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CEsUMG2pqug58H7r5AFplI10sXKjC7LMyghTEXaKIQBOxp4Mm6x2xRWKCY+dX3vVySZQU7x6MbPsUqoWz7jSmcltixT2dtxz3+G3VIKHaQ88EgrTHHJ57/2wJY4D9u+0V+pEdvLBhonoDpWogQTsCXvi3Kb42GtUL7Cc0rLRqPm86wgAeGJK5/wsYM6qtM9EXsXKC38eamsTUHPFWkDjanVwvKLN8bcq0OXMSr7H3Pzy/BYHESF/Mel6gtCR8LM+79jwGA0Q1rjBdSpOB/rVa7uF96F4CZEbdER5A5W2hA4NTU3ldUilpC3ys5UFiGUKbFEGEOA1n0em/ietKMbWBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i3pi22l8iJePjFaFknTDtVJ9TRx97g6w/18uN/tdHiI=;
 b=LadcszNIwKZmCnZncmCEypZV2wI3g1oVDn1gRuQ+2aBnU6yuaqQ5EOFSiGaPj+f01AFMPIcs0QxRXINQ4WZrVti0BOdbv4CoHr4/SWkbt5aPcotaDyntKapmPv2ZKxmdKLrFDlrmtd7Pu/6/MhSnjVV3bi/WW1Wp1QeW0ynw3V1uBi1Xw+O4AklUOcpxSaJfN0xwcaGJJXoIhARufPkjtHbqlLiQLt9udAieJNuMbnwSOLuWAWR9tc/eucW/nCRd7a69CK/Pa2jkf7Ov4g1RuiQiwSszn2lqMQ5K795aUpRgYSbu9DjuFFq+AwI244Fnl365+gV02IBGQ84bO3ikjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i3pi22l8iJePjFaFknTDtVJ9TRx97g6w/18uN/tdHiI=;
 b=iTYfnq3AW7hesF7Rrh0BA1Wv2NFBjNfb8C61WDzmfjJfW9fda0RhBUsJxew39/NMv53XnpQW2nXWfwzLuGFNYDcHyu6isJKX5OsRQDsTL3VxXHSsFM2E1IKtDXcwrXDU+NlwBhardKQCDVjZdqckOACdEeS8WVj8+Zk1msT2Zeo=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR10MB1615.namprd10.prod.outlook.com
 (2603:10b6:301:7::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.15; Mon, 8 Nov
 2021 13:49:47 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9%5]) with mapi id 15.20.4669.016; Mon, 8 Nov 2021
 13:49:47 +0000
Date:   Mon, 8 Nov 2021 16:49:37 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     asml.silence@gmail.com
Cc:     io-uring@vger.kernel.org
Subject: [bug report] io_uring: return iovec from __io_import_iovec
Message-ID: <20211108134937.GA2863@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: AM5PR0701CA0072.eurprd07.prod.outlook.com
 (2603:10a6:203:2::34) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kili (102.222.70.114) by AM5PR0701CA0072.eurprd07.prod.outlook.com (2603:10a6:203:2::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.5 via Frontend Transport; Mon, 8 Nov 2021 13:49:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a4302ec2-fff6-4475-c4a8-08d9a2bea084
X-MS-TrafficTypeDiagnostic: MWHPR10MB1615:
X-Microsoft-Antispam-PRVS: <MWHPR10MB16155E92A0B1D1DF0C00EDCF8E919@MWHPR10MB1615.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:118;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XIetaOc13MmLz2U6gp4xanyh8rxtbAMjShd1gZYAv1pL4VcU+3/2zjVCkLGwB4he1JI0/IDzVmMx3o9fb0bmgvtcr5nT2225XqKPn84kz4mSpEac4pmNpE4LdwVdF07/BTn8DO2QXLBRspYpNd/Hdu/YUhxyewSRbK/WDfS7tudxqNSxDRVyGmSGxoDxLbReOIYzBtvDK2gD86Fyeln7NTn2ndWaJymqvkngHzT4GIKwGOBH56VfVIqK4/eUSefqRzpoZXbPW/nSwXxhXjjX/1cJFBQoybxE468rIpnxQrF0CGcLc4T2sRGbmEopacg99jz3d2dVISeujbuoagWjxqM4odBwjCeWzpk2Sl/fY7UwUmaLt9ZY9RfuQkr/jSzQrGJ6t2L6Pta3TIiG7/XjXqTig5Fa+D9aWD/Fj0A03hiR2Hp06xuDFVyOnNckCxk5FIwDalYS038oWYJfehWcnPH7mwdgSnmpSmXnSO1ehHbWijEBzgoI2TKO+ZH9fbxYCZ5gJy7ssy6L3ljaI8N2pRONpJFIVSREJ/KLgOOdXFGlBHhc2p1D5rXD3iIxjeuVY1Q7uygP4r5SFeEcDP+uFmKGBwuzsTPjvuJQbgjSrfa0vgQeXlCFQOvAY9wAQw8uifYY7PjJNekXetmVW7P4ZISKPmK0E7cuNi8zfpTtNodE8kZLzlejA1PUQBZ0DPv1C/ZtU/JVJtkZIxYvKMd81A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6496006)(8676002)(8936002)(6666004)(5660300002)(9576002)(52116002)(55016002)(508600001)(6916009)(66476007)(66946007)(1076003)(66556008)(26005)(186003)(44832011)(4326008)(9686003)(86362001)(956004)(38100700002)(2906002)(316002)(38350700002)(33716001)(33656002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pp7enLIZKjvZBTOfY5iH6nwAU+mGDJn50y2MhTyVepEWjYGUWiQnBUrGb4cY?=
 =?us-ascii?Q?64vahuy6xKbfo0htAoIASaGLGEdmhO6llEjTbNSfY45oLB3T68/RuAUufhJE?=
 =?us-ascii?Q?+9isToEGR0oJYnauyGpAkhg6RwPjhgntav6cieIg9WOLBQr8qCnNA4scIzbH?=
 =?us-ascii?Q?P/nxBB+eobzq0kTvbI/AB/Ak8u5fRguz6xGpepDrcy1aJyLt6ZPnIpzv/Wn4?=
 =?us-ascii?Q?70Q+4te+Lx9j4xp6Kh7j76ivUnsVh/ebUl5CIq0cnElkK2VEJaNnLSBM2PAc?=
 =?us-ascii?Q?lXpIAGUb+ZVyCAiJ50Bp1V145GdPzHm09QrKk6vO/+kDOpkdeARO6YLuTH8M?=
 =?us-ascii?Q?6Fh5tmnUaLsXRNiHQnoQkjnk8UEPDTltwhbXUOJ5DadSPSzqMTIX9EXBB7d/?=
 =?us-ascii?Q?ou03Cj8hd+RwwhlBXvUVs7PslIV9j2BXwQ6gcy13iJTUu0S53Po8/m3CUSvz?=
 =?us-ascii?Q?Ui68sbzHb+xin5hlXU9Z16ilpQ96umz0cRwOBOR0vRUzmwnS65l69Qdowxv5?=
 =?us-ascii?Q?hFehdTTc0rPbWh/lKocrqYEH3d3kzkwz9cXJ2focy9e3ZOdhahvLFFOIT4uU?=
 =?us-ascii?Q?X+J0Lry+HI6hIPxEhgCZZLTWxtoHLGgBVzx/SCEXA/8k6HEpxXBtYpGEivVP?=
 =?us-ascii?Q?RA0boL1PpKE5ztGgdUAL0EwHmh67PStiL+29+JnSP4V4J0idGM7lvamZAt+7?=
 =?us-ascii?Q?RUgDj3pP4nCvxk42K6rl5ZXakwIkv41VAtca3RJvfP8ZKfTqmoKksDITnOFC?=
 =?us-ascii?Q?Z/OXsl3KgcLmPdr6cMTaVFRvOlVOVD06cIsVhAh51Mn9wd4ZmaZ1xOottu47?=
 =?us-ascii?Q?a727Pv26s5hkDlIiedoiMJlrikT9VmWXdzHTtqitFyP6B7s0XSsOGaUBvGkJ?=
 =?us-ascii?Q?t4viCXMkk8EhgnWbra5lB7H9yFqCTwIgBy/o5qg+wLpEGQgHTOGh3FUyz6aj?=
 =?us-ascii?Q?WnTX1yvDCmFEDnNhldg78n88DWCnhIL2JMnFr7g52SCFLIST81WF+sFZvGF2?=
 =?us-ascii?Q?AOQetvVYYr/TOonJVBFW0qNCpp1HU6SEp1tUNIw0mLFOu6mb7pOYIKhEFcva?=
 =?us-ascii?Q?4QVxxHf36sCYpcOZ6pv/WLA5k7sWaCeEcTwDnTGMgLRDEkMnFv3YpjASBk+1?=
 =?us-ascii?Q?RFb/e4lYl+USPA1X0WTjhnPf1A9w1ABm6J6cea9tC3+BxIRQn7rLF7mOtcZE?=
 =?us-ascii?Q?u/yxeGZzoCtIzMPGsbx/ethSNVyP+hjIGbktcEw3lY88/BHivMTPYrrOP7FW?=
 =?us-ascii?Q?SyI33fITuYfaQ5CT6jh1ipNRJYDqVyVYkt4JnIO+7rHcHoVcDL3nqxjj6C+Q?=
 =?us-ascii?Q?aENJ0M/jZnx7Jz7cUy837n2fH5s4sOaFZmUcBrzyzABEgkxMAlMxNrNC8mm+?=
 =?us-ascii?Q?Li45K0jDvE+YlGh9WmErT2IOEidIRlppbQGsEwrTnEZSfrC4G2h89DulAngi?=
 =?us-ascii?Q?3odXJ8AnAQC9p3pzvXkiUgrwn28fQn8Sx966iY+ZDdqlOw2gFGioXAF74Cyi?=
 =?us-ascii?Q?ewSKWOzYl95UWm3KISKZStpbAuRxL2gkU9J1Z2xdFAU6hflAGaaoISr5QS/u?=
 =?us-ascii?Q?RIvISMW+MKFaO8CfS4KLOpNnCwxAKmIRstkjtCevXQ7JdVBvwSKIErBMedAO?=
 =?us-ascii?Q?nsQIea3mLdNt+fpNRQwEpa7dAm3qbkHq6RZEShIwA0IVR68z5WOrgUVEeW9h?=
 =?us-ascii?Q?+Glu3Z1i1FRZ69uzbZRo+O9/x1I=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4302ec2-fff6-4475-c4a8-08d9a2bea084
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2021 13:49:47.3875
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oUeq/zPTIOUmNTM4Wg5AUi1HHzFp1Q8bwouDOCmzyoFquuMWWzCDRo8B7+HXBXRaDdWFmnUSIVsyqylcGaJJJ6c6Rn2WRbrTCLfRrFuCCGw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1615
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10161 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=804 mlxscore=0
 suspectscore=0 bulkscore=0 spamscore=0 phishscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111080085
X-Proofpoint-GUID: p7gIaHQkfUwD_f29y8YOaTlT2bRhIBHQ
X-Proofpoint-ORIG-GUID: p7gIaHQkfUwD_f29y8YOaTlT2bRhIBHQ
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello Pavel Begunkov,

The patch caa8fe6e86fd: "io_uring: return iovec from
__io_import_iovec" from Oct 15, 2021, leads to the following Smatch
static checker warning:

	fs/io_uring.c:3218 __io_import_iovec()
	warn: passing zero to 'ERR_PTR'

fs/io_uring.c
    3178 static struct iovec *__io_import_iovec(int rw, struct io_kiocb *req,
    3179                                        struct io_rw_state *s,
    3180                                        unsigned int issue_flags)
    3181 {
    3182         struct iov_iter *iter = &s->iter;
    3183         u8 opcode = req->opcode;
    3184         struct iovec *iovec;
    3185         void __user *buf;
    3186         size_t sqe_len;
    3187         ssize_t ret;
    3188 
    3189         BUILD_BUG_ON(ERR_PTR(0) != NULL);

This is super paranoid.  :P

    3190 
    3191         if (opcode == IORING_OP_READ_FIXED || opcode == IORING_OP_WRITE_FIXED)
    3192                 return ERR_PTR(io_import_fixed(req, rw, iter));
    3193 
    3194         /* buffer index only valid with fixed read/write, or buffer select  */
    3195         if (unlikely(req->buf_index && !(req->flags & REQ_F_BUFFER_SELECT)))
    3196                 return ERR_PTR(-EINVAL);
    3197 
    3198         buf = u64_to_user_ptr(req->rw.addr);
    3199         sqe_len = req->rw.len;
    3200 
    3201         if (opcode == IORING_OP_READ || opcode == IORING_OP_WRITE) {
    3202                 if (req->flags & REQ_F_BUFFER_SELECT) {
    3203                         buf = io_rw_buffer_select(req, &sqe_len, issue_flags);
    3204                         if (IS_ERR(buf))
    3205                                 return ERR_CAST(buf);
    3206                         req->rw.len = sqe_len;
    3207                 }
    3208 
    3209                 ret = import_single_range(rw, buf, sqe_len, s->fast_iov, iter);
    3210                 return ERR_PTR(ret);

This return and

    3211         }
    3212 
    3213         iovec = s->fast_iov;
    3214         if (req->flags & REQ_F_BUFFER_SELECT) {
    3215                 ret = io_iov_buffer_select(req, iovec, issue_flags);
    3216                 if (!ret)
    3217                         iov_iter_init(iter, rw, iovec, 1, iovec->iov_len);
--> 3218                 return ERR_PTR(ret);

this return return NULL on success and it's intentional, but there is
no documentation so you have to fall back to `git log -p` to understand
what's going on...  :/

    3219         }
    3220 
    3221         ret = __import_iovec(rw, buf, sqe_len, UIO_FASTIOV, &iovec, iter,
    3222                               req->ctx->compat);
    3223         if (unlikely(ret < 0))
    3224                 return ERR_PTR(ret);
    3225         return iovec;
    3226 }

regards,
dan carpenter
