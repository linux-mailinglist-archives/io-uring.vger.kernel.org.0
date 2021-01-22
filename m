Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A945E2FF964
	for <lists+io-uring@lfdr.de>; Fri, 22 Jan 2021 01:25:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726179AbhAVAXx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 Jan 2021 19:23:53 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:34246 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725831AbhAVAXq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 Jan 2021 19:23:46 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10M0AJgF163969;
        Fri, 22 Jan 2021 00:23:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-type : mime-version; s=corp-2020-01-29;
 bh=ykdTVY4LbxWydSll2VzgPSfr6s+PucWYOwUBa1NrRak=;
 b=R9jCcyNuy7Csk6mzXP5eZa3j9SBmt9ieQY0GPSJthX9R1exi3F7Cmy39oHnfdJcUXYlz
 0CTSFvti40xnVzw4OkZRDxsPTxkTsaUfJsqB11lcZ4waYbYSVbdmp4XE87ZYgJRYMlYt
 +NYSYYyEH13jjV5hJQ5dzy+vhBGy5PEByOxIT5v9/WWIDb8VuBCumbf8JEZy05MU88u/
 hlEbSQuDuI42yihtK6V/5mP5nE0iCAkPByScc2yrr+Qhngx7MrtT2r9TNz4Z1In6ng3J
 Joe9JygR4gnoP1D+rYb17ewDPjTv7nZNyf1GGzM2fucpYbu+jcy0dJAh7qizfC8dQoxN dA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 3668qn1vu3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Jan 2021 00:23:02 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10M0AsGZ127842;
        Fri, 22 Jan 2021 00:23:01 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by userp3020.oracle.com with ESMTP id 3668r016pr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Jan 2021 00:23:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ErbTRMYFn+Qvj2AhAcFpcm2vuPmmE8sNhdcd4E+HbeK0RnVsqs3w7rJ6aHgWKmjE5oIjd3fGXW3YOF5Nn3y3tTRApMo5ykse/6bPVyTveXmYGxNozENFtA2jAkWjxucdjTIom6mK95Tf/L9giqzW5oosdtIAVku+hEntN6nnlE6kLLJVNQmaEbLkmAEZu2X1rpk4/ykJAt9yC0oKE9NGtyeQv2HAKgej075G0oEGrz4pmIdq6D32QFN4zuBEKe2U7++k19qudXxxehs2iSCU7CkkAaEhrKhDSIlI9TC7Tntiu8LIN+eRqwe0G2TEglBzKXM5uE1DPNokL/ZmlE13pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ykdTVY4LbxWydSll2VzgPSfr6s+PucWYOwUBa1NrRak=;
 b=R4K5z2+roGy1LGxbrrj02m16sOtdB9p++AphFYMXH8aQ50PqGqzEZ7Sich7KmMLjYgznMlstHD7bDjs88Y9xprfO3+RLYWE08ZBwROpF01SSsFuWuHaDwydFP7gDHXei62yeIPCqGO0Xabj5ilUiHqem+g6m6ZerP1aEecldeq4Wx5KwLRstw3LB/4RXv5JfJmNK+b2/k/9/OwTNC0mPafZRG+IR8aBfpaz3xmEfzcxPGDB7jiIw5XUUAKrYfFHJ9hBsQK7QsoYVXT1AJ0KIigHUg4KHeLlt8srWZ+6LBQmNm2qSki7sdy7EHb7siV+uTGAPTVNxbIGTerNiHWYxMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ykdTVY4LbxWydSll2VzgPSfr6s+PucWYOwUBa1NrRak=;
 b=XMzsqKUgvVghufMnch/rU0mRL2Kw4ey2JsCmbogwSJiA8ODzdQHXIU+0RA4aKEktY4tc6XZwS0xstmltPyPJr6SSl1qHbuIZSuVxJrkyu+1MHzojqz8qwTR0vNlz4XOChrqZWfX684q6BULBDsUe3vqcldCLWmMnkIPISS3VbNM=
Authentication-Results: kernel.dk; dkim=none (message not signed)
 header.d=none;kernel.dk; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3606.namprd10.prod.outlook.com (2603:10b6:a03:11b::27)
 by SJ0PR10MB4496.namprd10.prod.outlook.com (2603:10b6:a03:2d5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11; Fri, 22 Jan
 2021 00:22:59 +0000
Received: from BYAPR10MB3606.namprd10.prod.outlook.com
 ([fe80::359f:18a0:4d25:9978]) by BYAPR10MB3606.namprd10.prod.outlook.com
 ([fe80::359f:18a0:4d25:9978%6]) with mapi id 15.20.3784.013; Fri, 22 Jan 2021
 00:22:59 +0000
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     axboe@kernel.dk, asml.silence@gmail.com, io-uring@vger.kernel.org
Subject: [PATCH v6 0/5] io_uring: buffer registration enhancements
Date:   Thu, 21 Jan 2021 16:22:51 -0800
Message-Id: <1611274976-44074-1-git-send-email-bijan.mottahedeh@oracle.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-Originating-IP: [138.3.200.3]
X-ClientProxiedBy: DM3PR03CA0015.namprd03.prod.outlook.com
 (2603:10b6:0:50::25) To BYAPR10MB3606.namprd10.prod.outlook.com
 (2603:10b6:a03:11b::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-ldom147.us.oracle.com (138.3.200.3) by DM3PR03CA0015.namprd03.prod.outlook.com (2603:10b6:0:50::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12 via Frontend Transport; Fri, 22 Jan 2021 00:22:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a788ab87-57d5-4088-3350-08d8be6bdf3b
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4496:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB44967026CC32AB749C1C60B5E4A09@SJ0PR10MB4496.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: J0l9bxNh92YvQLfc6yl6iVCHuUIJt28Ckpqm60FeN1r+b3Tz9yWCa2dYd+1RGPaJR310KpdN8uzxFQvoqpcM170uj1ZwLkJXbqVNPAhTpc1oDQdBpktzs682qhRDY3GF/hA3ZNHhG0gC52cgTgDHCYAVvgoULycSgqDHUhzByoxjXuUO51LT0AulLp1JVBimbpOPsI0Jx+OiecOQMtqy71l/YFB/qAUPwAOWyuipTWTU+ttCkYRzRdN02kXHgUezCmTGXnPu/TkjX4pzF8zL7voOInHFSZe4dbXZM6DzPUb2GiSAe/9kcxQ390iaFWxGCn+yl3EUBQlcfSmsr7r+nryS7sN48A9sEXZvD7d1BKrBSlHzNXZEYHKod7JQGd18gpZFlwtbBZ/ZXNApGq7HQJKtWbF4gdvjFCLcxdOuYnVQlNXLL2Vu3v5DZqyRO2g6QrUxdLr+YzyBnN4WnnptNTO/Vx1ZWZu6pP8BZanxhpjYmx/BskQsLnvFkLrnQzqYqK5ZTQjJsglHKvIdzmttTA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3606.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(396003)(366004)(39860400002)(136003)(6666004)(478600001)(44832011)(36756003)(186003)(86362001)(2616005)(16526019)(6486002)(316002)(956004)(2906002)(52116002)(66556008)(7696005)(5660300002)(83380400001)(26005)(8936002)(66476007)(8676002)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?+oJxPhu/bqcji++xqK5/SHqbTDisSFMgwpOa967MpWGUG1XWfR7wDrOYycml?=
 =?us-ascii?Q?zUazzYDrkcp2IgnVA06Qvbv0fu46YLAYdw2FHPIqBc3rSCgWzjlBk0RN4SZw?=
 =?us-ascii?Q?tODzluxSqCLXnbD1tCyWldf2boeh911S3RehZVGmg9S9Rpw/byOhGxSTiM0V?=
 =?us-ascii?Q?8cKTMk6Ow4o9uhBPNznuVyFTBTji7a4f02cHBgDhuOYXCBXXNSnvnP8RDxG3?=
 =?us-ascii?Q?lXUKys0vK3phOWIEBRdiLcZkl0qMRSpxIX6plNd5c1xCNQYYJURo9hOOWFUx?=
 =?us-ascii?Q?Ddl1EjNKWd1iGwbu9qQDsNzcYkH93M24tzDtkOe2CauJCqSSs4xCwfoAfNGf?=
 =?us-ascii?Q?39ltQp44oBHNXDBxJ7P7OAS+ZDbTV/8ZaC5LK5ClMXRsebxH9/H3mYXNDRJX?=
 =?us-ascii?Q?cMCDBFPskGdMXN2MQ+ND34MzFUk38QYfW7+6ykghHEWvEDROHQBuCPHpiR4D?=
 =?us-ascii?Q?E+xA64T2BatXrGKAKy9PZXPNTn+m982KtddaSLee6bRsUQ9WlA+HfwZYlnB4?=
 =?us-ascii?Q?9mL9JwRg7yktA1eqWwos4dxe4Y1LpJc4+9vwh3EWmbxJfOzvSa8VR6+hVccw?=
 =?us-ascii?Q?XTOFF56OCNFf4k+r47UznnNw5hQSScmNsDS6NNN1CmD/oCFB77kqz6Sb7983?=
 =?us-ascii?Q?MdEKa+N8FlcJljrvypMRxSYACen2VFfYc1pkw6gVf6rha3+iqny7Jraw02iq?=
 =?us-ascii?Q?SlqpVWknpKQL3CEdR0FEowWtLhPeWVnQZQofrPtxFtpnMkILmgAOBDXC+WME?=
 =?us-ascii?Q?FWPK3H6QU5ldBwj0CEfKQE72dLB498nlEwLeNCRjEgNr13tbPP0uPzenFkSB?=
 =?us-ascii?Q?FpYMWo64Ub6sc5VTj3rXdTRv6ZkCQEn6fdHKvcPpTpmRabvMqmlctUr5eCVp?=
 =?us-ascii?Q?nKq2JwlEEEw/fFOvLRY1UAG9DkEetnC+OEhOYvYFs+O6kslZBqGbC900VZTP?=
 =?us-ascii?Q?nWX1htBd7jZOvqiJoeUI3siy0fNO6DW90NvqGLo19LE=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a788ab87-57d5-4088-3350-08d8be6bdf3b
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3606.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2021 00:22:59.0651
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KP+UUmtaGxPC40D+YyDG0fvizAWTwUgFRmyqQea034f1xSsd7OjwfAgoxPbJbZLky4QpDkSHCrK+goDW/Dqz+qTQp+qGuwNo26Z7Gb3hThg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4496
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9871 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 adultscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=804 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101210119
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9871 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 priorityscore=1501
 adultscore=0 impostorscore=0 mlxlogscore=971 spamscore=0 suspectscore=0
 phishscore=0 clxscore=1015 bulkscore=0 mlxscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101210119
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

v6:

- address v5 comments
- rebase on Pavel's rsrc generalization changes
- see also TBD section below

v5:

- call io_get_fixed_rsrc_ref for buffers
- make percpu_ref_release names consistent
- rebase on for-5.12/io_uring
- see also TBD section below

v4:

- address v3 comments (TBD REGISTER_BUFFERS)
- rebase

v3:

- batch file->rsrc renames into a signle patch when possible
- fix other review changes from v2
- fix checkpatch warnings

v2:

- drop readv/writev with fixed buffers patch
- handle ref_nodes both both files/buffers with a single ref_list
- make file/buffer handling more unified

This patchset implements a set of enhancements to buffer registration
consistent with existing file registration functionality:

- buffer registration updates		IORING_REGISTER_BUFFERS_UPDATE
					IORING_OP_BUFFERS_UPDATE

- buffer registration sharing		IORING_SETUP_SHARE_BUF
					IORING_SETUP_ATTACH_BUF

Patch 1 calls io_get_fixed_rsrc_ref() for buffers as well as files.

Patch 2 applies fixed_rsrc functionality for fixed buffers support.

Patch 3 generalize files_update functionality to rsrc_update.

Patch 4 implements buffer registration update, and introduces
IORING_REGISTER_BUFFERS_UPDATE and IORING_OP_BUFFERS_UPDATE, consistent
with file registration update.

Patch 5 implements buffer sharing among multiple rings; it works as follows:

- A new ring, A,  is setup. Since no buffers have been registered, the
  registered buffer state is an empty set, Z. That's different from the
  NULL state in current implementation.

- Ring B is setup, attaching to Ring A. It's also attaching to it's
  buffer registrations, now we have two references to the same empty
  set, Z.

- Ring A registers buffers into set Z, which is no longer empty.

- Ring B sees this immediately, since it's already sharing that set.

Testing

I have used liburing file-{register,update} tests as models for
buffer-{register,update,share}, tests and they run ok. Liburing test/self
fails but seems unrelated to these changes.

TBD

- Need a patch from Pavel to address a race between fixed IO from async
context and buffer unregister, or force buffer registration ops to do
full quiesce.

Bijan Mottahedeh (5):
  io_uring: call io_get_fixed_rsrc_ref for buffers
  io_uring: implement fixed buffers registration similar to fixed files
  io_uring: generalize files_update functionlity to rsrc_update
  io_uring: support buffer registration updates
  io_uring: support buffer registration sharing

 fs/io_uring.c                 | 448 +++++++++++++++++++++++++++++++++++++-----
 include/uapi/linux/io_uring.h |   4 +
 2 files changed, 403 insertions(+), 49 deletions(-)

-- 
1.8.3.1

