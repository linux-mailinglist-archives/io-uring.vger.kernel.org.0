Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73A32459CC6
	for <lists+io-uring@lfdr.de>; Tue, 23 Nov 2021 08:30:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234063AbhKWHdx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Nov 2021 02:33:53 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:29428 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233890AbhKWHdx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Nov 2021 02:33:53 -0500
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AN6oiL0013439;
        Tue, 23 Nov 2021 07:30:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=YccPD5L8Xvw9PEgLzU6WTak+A1qGg1/pyVqPgCJQkcw=;
 b=TYKN2TJwMNoyFLTTs+xMVHSBLOU22ZQITyYH4gG1iXlQBudh7AKlRPLW7rIXfSxNqp5t
 KNze31o/NZtEAhmt4VAeD/+jgO0E7u4sKpa4qXEcdH1yZv9NGy3MBMuhoyCL5UThXnwn
 0tt7i2OCF9FCiIHuXwrlYnafxndaOfw/Bu6cMsv9YrPrCz3ld9KMlvK9spLByT0Wzhu5
 lp/+TJEbK59yIIoB18zClgW81OmZQDDT9G7xg7r6M+1/qCpYifFpVgx94pTojpHupu52
 2zWsgeUwOvw3LJzBIVufut85b8M71SUlAKTgA70ki+zQavPiF8QfyRmcm2seSDP/d3LJ FQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cg305789y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Nov 2021 07:30:43 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AN7POVc178161;
        Tue, 23 Nov 2021 07:30:39 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
        by userp3020.oracle.com with ESMTP id 3cfasrybpj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Nov 2021 07:30:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V/EC6MK3LkzZzaVq+Ve2kPkWMA4axh9BFy1veVKZ8AODnHoljDnbVSlIYGVn923u45L6G4X5rJpZmMP1ayO/X/IzkNUTFYEH4EJ0GkFlXcCyM84cc9+xO4THG0yhtJ76XwaaP6kHFzzz/I8HZ9oggVyC/vuVe8rEt6dOWYS5peWjD6AY0udIpH0MmASNZ3fX8qVgvVEIOpzay7l4vdRzjw9IYaRMqXdbJNyK+6GSONKL2OaHA30OI/QJJEFlU4Yb8UbHp2ITOZA/YuFUAJgpTAQBwoe+jQmPvG52IQIyG6cMvGtmnN+r4pdsW8lVPfacwEBjWmsIHQr3Xq67EEw6IQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YccPD5L8Xvw9PEgLzU6WTak+A1qGg1/pyVqPgCJQkcw=;
 b=cQnUD64+rujoUL3249mjFzxN8zgWtsur9/XDWY8bmnpkVqNOMXG7dlNN4Ai+Kh7XKD2WQfKYRTuEuwqJQFNoaurzvDaz5FNGRt8smnHOQGkcAI1LP1FXAgnGJt7wcEyUl+hYOfQYUDCE5Ru6kqnhQSwf3D+xcJj+jVe7lFwNq0axOc5yIw+eVv2m/JctbBGa/p15+yMQA/9q/ZGj4oOZngz3MvRiJ9k6EVs+CXOULnKEwrPtsHz/+ryHpBLDforwQeJs6UfM/Ndip7K1u4EMH4UMuatbHYKJ0S40DeesNvUM2SAUG3giY5+3iBTfxaftuClXHwig+fs/vkSWZ8e5KQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YccPD5L8Xvw9PEgLzU6WTak+A1qGg1/pyVqPgCJQkcw=;
 b=mVsmc8na5kWVkLeZ41wb5jy71EUCH5nVoG/o/FvCsdpQhp0+ObAg03JXjAlSxUDlgx3R7lhAb24OxW2WjwltSEBEW+/dhjEndt6eE/zVVQtNIMKZoe9OjzzHN6/VgPUCFzeMBqcmW5qpnB+Qhl5nBnWIkSTA0abe81bKI/j3wIM=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR10MB1566.namprd10.prod.outlook.com
 (2603:10b6:300:27::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.21; Tue, 23 Nov
 2021 07:30:37 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::495f:a05d:ba7a:682]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::495f:a05d:ba7a:682%6]) with mapi id 15.20.4713.026; Tue, 23 Nov 2021
 07:30:37 +0000
Date:   Tue, 23 Nov 2021 10:30:17 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 3/4] io_uring: clean __io_import_iovec()
Message-ID: <20211123073017.GD10517@kadam>
References: <cover.1637524285.git.asml.silence@gmail.com>
 <5c6ed369ad95075dab345df679f8677b8fe66656.1637524285.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5c6ed369ad95075dab345df679f8677b8fe66656.1637524285.git.asml.silence@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNXP275CA0047.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:18::35)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kadam (102.222.70.114) by JNXP275CA0047.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:18::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19 via Frontend Transport; Tue, 23 Nov 2021 07:30:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9b670cce-52bc-4855-3c50-08d9ae5324af
X-MS-TrafficTypeDiagnostic: MWHPR10MB1566:
X-Microsoft-Antispam-PRVS: <MWHPR10MB15667401D968566F4F11706D8E609@MWHPR10MB1566.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l+Pjh1eAxAulDxOTIcoQIcBOFg+jC9gPtxTUB4eVAI1t/8v98CftNWMpBkTQqT20lxNS2Pts1wsYkqqNaXuNIS/Fr1EPqwAVirklwAYpfu+hx5ZC6GClYKEMT518NirKjzpGcV9Ol3ny9cQCuioCATiEc3gvFQukcvrMltYAzd/pvavkj1YJfQj7XmjOnUXLDbZp8qhBDVw2WSLZBKhsOLjBJQQZcFG+syIhDvFda06y+ZwqHJwn0zc01yebhmwP9DjZFb+tEpP9DnRzOMHHgo+ewcIhcm0yrPeek3HfZ3CXqooZK3ox8LWqlGWiGcy+9ze5xWlj6ewRNpyNc7w39fCF6mKXXLmf+wDtxrI6c9eDJ7qhSXJ7WCXM5BZ+u0K8TaVZVPaODlFUfl8GK0Db/pRmNHiE1NcRO6mlgudtl+a4yX/ixLCW5CQJcTAIUo9VN7D0qgTblpjCqcwC6aCj/0LaBL76Y8JeVqW14lezP6yxaPr7b5Zy2PQd65xLrELbaeuk7geeCQx8Qzd6fhmw0e/FucWLeN0kM9xNvoZ70kIzE6jrXXSi/jXMvJEtBFGCI/pYTAYD11cajB3pHJ3W4vpIPHVlwZHj/Z2do3ap2WhFotjJXQo2lkkvYeB1ArWpGRsqEL7IRoxqkYg4zg5G21efdHyMoJQI6/fNXNHOuIM64nL1UH7HQcuYv3mols/rURGQF5daiQqHEMwhhAw5biFLKZ7Ug7GAEtcDKDmwa8i/PxKe39TAFFTgwLN+9R70zg0RvhKoW57W3ps8b+34YHZl7zkoSa8f0hImj5xETa4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(186003)(2906002)(6666004)(6916009)(66946007)(966005)(8676002)(66476007)(8936002)(26005)(66556008)(956004)(44832011)(83380400001)(33656002)(1076003)(86362001)(316002)(52116002)(9576002)(6496006)(5660300002)(508600001)(38100700002)(38350700002)(9686003)(55016003)(33716001)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lVuICI7kZsspv4Xc1Fffi2kj8vNih17SV669BfidDqBCBi0DWxJ/4RJK8ohF?=
 =?us-ascii?Q?v4+13RhbvOL/bATNWI+eQ6n7nsRBawVaYJfYpWlE31ZuKS/t7Lma9QgRYL0v?=
 =?us-ascii?Q?Nf1JXXbHtPuAofhGArcwWjIOI37Hh5dPHZEvQd5JQOkEUxn8j91z71+hxbU/?=
 =?us-ascii?Q?Owgr4eiji5AMhli7Tt/wG2Pfc11C46bp4Tg/XYeD/ISma8A4lS+eTN9NiDSq?=
 =?us-ascii?Q?SP0l8uUrZUITnbsQa8A1vzw9S0qtik6orqLa6zEnrHF0kR0MY6pUeLFh+G1Q?=
 =?us-ascii?Q?EEvqoylWgncfC5Aa/9ZMhTOqxKEVl/4uqE3xCFo89lMPXNyolURgQ33We9fG?=
 =?us-ascii?Q?5KNcWex3KCTc0vIYz4NLOHVSyaJuL/ou06yT/GE+Nw35KVrf9kOW1BUCeTIR?=
 =?us-ascii?Q?7BviQDroY0Kmpn3hdDlXysj0jaX+4DAk5eAjPIuMz/8KMxeoG/VQLzH595mA?=
 =?us-ascii?Q?FQ2Vp9PQUbQ292C9d1b+PxKEV/bzjKHy51Ce7V7JPRSFpYzUSqyYve/X/YmX?=
 =?us-ascii?Q?8miwGz1ojaV/uVB46yPIRxUYFg/l8bqP5nn6Ke5O/lfeuJcn9bd9014n+gnV?=
 =?us-ascii?Q?fLMezTRtDJmKW282+G1B84bI/WSh9pU5QVRP0pUNQicUv9a1ULcXYMIviewV?=
 =?us-ascii?Q?DU5a7PL61gLC5E13ZTaD2VO6yykFxxLVPYq1vqUCqrcmeEn7xckF0ZIP0Jeq?=
 =?us-ascii?Q?xwHbUoXkhb7SIofIjBrIRRYWCMydMKmQbu6qPzRtSkcY/TIxqNmBaNmfJ6td?=
 =?us-ascii?Q?LcaDPvhdze5D++BVusXI4UqYayDcCSOZ1zowsngNQUdz1glT25VgtwHG8VCG?=
 =?us-ascii?Q?OfY7iAZ+ufKORT5i9/5p/j3U4v49YCxPl50D9JrHuYlpjGZ7gwGXBIWmo4HX?=
 =?us-ascii?Q?BWT3NUUyMbiiTYRuF4zhRvcWvjE/AbEH+4fFFB0rugLWhjmIplaT9W4Ul5jT?=
 =?us-ascii?Q?ty8KH6oEqheNBwIw9175r3k3peEEvExEozLeVC6PDaLBiKJdCPWuMoG7yR6S?=
 =?us-ascii?Q?c732d4ORJu3e45mrzXwS5cKuF7Iti/4TCkX7opTmlEhHzfCggeqwBKGrqsRd?=
 =?us-ascii?Q?ZJQuFNqsAnxyVafpJfk1FH0Bmszf15/BHPOrY+mgWQTbHDhxlr8OVc477fwl?=
 =?us-ascii?Q?bbGL74DomhbEHJDhfN6t3MJQABPPsLm7lUY9KI9s6VdcgYApikzrnneGMUBP?=
 =?us-ascii?Q?IGbayq/8+pH5wtPQLK5n3Jkxo/1CEINTSxrY8/fbHSBDtRezY/8ptnrgJZX+?=
 =?us-ascii?Q?vFKZSVRgtuIpM/AFPiHNCBFiiDaSyZYdVd8RmcXZlh0toXB6KRZVZI1pJfCD?=
 =?us-ascii?Q?3N4JM5A/eJhHcAF6xuIf/auDz2CyeYLTntKGoFjtCqsVag/n1CfJR8uJ+jrV?=
 =?us-ascii?Q?EQZ2zQJWabbpxzqV7DQhGVAEQxa3q9H3Iv4OT/U6YefLr5wTbk3zHh52f1bX?=
 =?us-ascii?Q?CRB27mlBTTULeTEL3FxYk93zzsy6pDgkiTZ29j7J6hjoRm9DSDuhVtE7G2MS?=
 =?us-ascii?Q?tCH6M+3Ki7LgSbQQ7fkcM0ZtWAAQ7B67AIuxuerrSmmK+ZL1xQJQbPgIcPu9?=
 =?us-ascii?Q?tPaC3QNot0R+39CG0KQzYu7B3Ppk1RjFnf/Ohaq+ujgNr8n84kE8wD0XauNn?=
 =?us-ascii?Q?cWUl00YBuoE9u+q7cjteRyywC4nqvWrKEMnrTNiY6R66jTQ5i6/gU76c0Ka4?=
 =?us-ascii?Q?KKTio+z5T+fVUyezfCy+/gaRNjg=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b670cce-52bc-4855-3c50-08d9ae5324af
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2021 07:30:37.5305
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BXrv3netKU0c5VJVxHbT5ibXhRFD3XX/GXhkynCFfvd0CJduJp05Vcv5hE0WHXJJQ58hVOYTFLPmUqTtW5fY3Py6xRejkgP0CT89gfcsr8A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1566
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10176 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 phishscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111230037
X-Proofpoint-GUID: pEh4ES_C_mY7K2YEK0fuMyJIyS9cN-d7
X-Proofpoint-ORIG-GUID: pEh4ES_C_mY7K2YEK0fuMyJIyS9cN-d7
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Nov 23, 2021 at 12:07:48AM +0000, Pavel Begunkov wrote:
> Apparently, implicit 0 to NULL conversion with ERR_PTR is not
> recommended and makes some tooling like Smatch to complain. Handle it
> explicitly, compilers are perfectly capable to optimise it out.
> 
> Link: https://lore.kernel.org/all/20211108134937.GA2863@kili/ 
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>

I like that this this code is now really explicit that the NULL returns
are intentional.  I had figured that out from the git log already.

Passing zero to ERR_PTR() is valid.  Linus complained about this Smatch
warning.  But I'm not going to delete the check because probably around
70% (complete guess) of the cases in new code are bugs.  In older
kernels the Smatch warnings tend to be 100% false positives because we
fix the real bugs.  Also the kbuild-bot hits a bunch of error pointer
false positives for cross compile builds but I don't have a cross
compile system set up so I haven't debugged that.  :/  It has something
to do with pointers being treated as signed on those arches.

But what I really like to see is documentation explaining when a
function is going to return NULL vs an error pointer.

regards,
dan carpenter

