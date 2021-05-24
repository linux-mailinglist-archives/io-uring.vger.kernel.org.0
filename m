Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9CCF38E1BD
	for <lists+io-uring@lfdr.de>; Mon, 24 May 2021 09:33:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232306AbhEXHe6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 May 2021 03:34:58 -0400
Received: from mx0a-0064b401.pphosted.com ([205.220.166.238]:2510 "EHLO
        mx0a-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232254AbhEXHe5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 May 2021 03:34:57 -0400
X-Greylist: delayed 883 seconds by postgrey-1.27 at vger.kernel.org; Mon, 24 May 2021 03:34:57 EDT
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14O7Ihg4022386;
        Mon, 24 May 2021 00:18:43 -0700
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
        by mx0a-0064b401.pphosted.com with ESMTP id 38qrtb0c74-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 May 2021 00:18:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XlgAtBMt4YsGC1eI62As7KgsXnt8kj+OrcmW0+n5QFNyNM3jcs+o7enORxNb0g/oGDf0kR/ldNtdz3pkz73psDrQk6nPh4PeSBeeAoPa5IFI1JUBPi1WpRXxyHDpfsrpXCExStS8RtZNzHol+bI434y3wwZ40ltypQvs5A2BtAGcsfzcccMzba4Z5cLL4c6uhnP/pfsLmIlKTthoTw0u+M3281lbab2PxwNCweeB6fhxEE5YWRz5Nk7lnXiAjJBpjECNOAmDfg+VzUMo6Q4NqzOC8PW7uVW20WFy2vF6QHM9v8d1jDTAJ6LpC5zdvBK/dxVpd0KyvzvIeZAxfaObvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IfLEPTGwkU3Lz5AX3Re9AyIO3/jCdYDow8z6JB6rsiU=;
 b=iVId6nzQgzLPzOCsahXoA76dpElKrAae2MKvkj89RpTg50tMXSu4MnlgrWvXSiN7K2sTMMDLTT78VkDGPtC33LKYYqOFn7Ntlw4bu/Mr3jC3S9wNTZzinn0jBoLPHsKOSWqiKTXmlPHZEotCix8WShm+PdJ0DSJh6ug3+zNu509vM+oCM2Bf7qfkvsdOlMsH5F9vyu3ZGI5PBbr/DfvuvH8zn930baeGpXfwFJnwGryEy/RMoG4bn31wKavJ1EuFMe3uc4dXSB0TmnFngwaQDaLDD0+D24Ba2K0Loxwb1BCSOaTRNwMBOxKrnW21xZ52VFSAOQQ94e5UT563yPUKaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=windriversystems.onmicrosoft.com;
 s=selector2-windriversystems-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IfLEPTGwkU3Lz5AX3Re9AyIO3/jCdYDow8z6JB6rsiU=;
 b=N9G9gXkU2moHEfgVRG16tmZtOsQliXSaC/Z6KdcmNG3w1yoIYYvahQcj7xYrYl5aRyGT1BlWDxV6tFVLXBm79UFsgx144s3hEQifQ/kn8ziAJe9lGVpQCj75J3YTFubPxXUqo98CQAwiSJBxI3/c08FDszcjFjyJCJHUK/j3IOU=
Authentication-Results: kernel.dk; dkim=none (message not signed)
 header.d=none;kernel.dk; dmarc=none action=none header.from=windriver.com;
Received: from DM6PR11MB4202.namprd11.prod.outlook.com (2603:10b6:5:1df::16)
 by DM5PR11MB1964.namprd11.prod.outlook.com (2603:10b6:3:111::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.26; Mon, 24 May
 2021 07:18:38 +0000
Received: from DM6PR11MB4202.namprd11.prod.outlook.com
 ([fe80::3590:5f5:9e9e:ed18]) by DM6PR11MB4202.namprd11.prod.outlook.com
 ([fe80::3590:5f5:9e9e:ed18%7]) with mapi id 15.20.4150.027; Mon, 24 May 2021
 07:18:38 +0000
From:   qiang.zhang@windriver.com
To:     axboe@kernel.dk, asml.silence@gmail.com,
        syzbot+6cb11ade52aa17095297@syzkaller.appspotmail.com
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] io-wq: Fix UAF when wakeup wqe in hash waitqueue
Date:   Mon, 24 May 2021 15:18:44 +0800
Message-Id: <20210524071844.24085-1-qiang.zhang@windriver.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [60.247.85.82]
X-ClientProxiedBy: HK2PR03CA0058.apcprd03.prod.outlook.com
 (2603:1096:202:17::28) To DM6PR11MB4202.namprd11.prod.outlook.com
 (2603:10b6:5:1df::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pek-qzhang2-d1.wrs.com (60.247.85.82) by HK2PR03CA0058.apcprd03.prod.outlook.com (2603:1096:202:17::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.14 via Frontend Transport; Mon, 24 May 2021 07:18:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 57b5b494-f8e7-4a06-29ab-08d91e842657
X-MS-TrafficTypeDiagnostic: DM5PR11MB1964:
X-Microsoft-Antispam-PRVS: <DM5PR11MB1964E2082477E4B73FEB5F87FF269@DM5PR11MB1964.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Z196QRzlD8ijVixD82ZB9jcFOyKos2Cr/NdrBBh+HOt7XUZljcBlxHbez/avWgU7M8MeVhHz1S5jub5vauG8kDzEAUEOVTwEgVleXIztf6uHy0/0XRpIcm1eq47nGxcfbZgGlLCcDaDHp9cSBj5BHg93pXhTuOZBzdi2pODr/9CLhbFt9iVT8D/gdcDcMcxOQnN++6znTuWDBhcZQoEV46cOTEi9zuhJEUORHJv/nSdaBhgm+zwRsPN6ozIxl0s5RWw7PIvOZ/Z9BwGbygC0//sEIFav6KU4cvcOLk1+Znc8RqFWmOAXLQwMz0FXNpMvLto3nJzK5GqNPcvzkAvjiyrUKhE0YM5xvCQSetWc/bglKhZUPSUve45fUAKCfYzJ0TpDt3kmFckcJgsDkjeEsgTsfHzsBSVCB6bGsLIH0JPYvwxPVH9sh6bJRIgJghUr30zLYztHifMMe/JA+gpe1tJxZ1DvE1m9GpPnlnu2eT5/ef72m0z1wOJVYWeLZ1Qzoo3eH28FeGRoXr3yXUBfycJQcCF8KTiQjBPZpM6aenzUqPX953mBjHoPwqb1wIGqoJvWO1LooIKB72Uxz/W6PANXTznPo4Hap7yFKfgl8128sLikT9oB0G0WoQNQDskmSfyPJ6Mx1aWtYW2Qt+q6hg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4202.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39830400003)(396003)(376002)(136003)(346002)(366004)(316002)(8936002)(36756003)(6512007)(83380400001)(4326008)(38100700002)(38350700002)(6486002)(5660300002)(8676002)(9686003)(6666004)(1076003)(956004)(86362001)(26005)(16526019)(52116002)(66556008)(478600001)(6506007)(186003)(2906002)(66476007)(66946007)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?IOZ07hg3v+/JtPQGjAauEf/r4gFLSMmQuXDAcQIzzbmXezayRT6re7pURXB2?=
 =?us-ascii?Q?EdxTT/4u5bnT5NUXBotwVKW8Eaoc6oElhdZiUe9tKgrbMaKRsIWrytRA325o?=
 =?us-ascii?Q?1KGNgrnP1lUYa4pA69ms1T5pIHm6atL6GYxtAe5E23aUj/OA26tQgSmbW7xO?=
 =?us-ascii?Q?JE09EtZWda95t7J9AUCc8IMLkzSJ6f1Mf4wY9dFJHaBCDkLumSNJJ3MYhZYw?=
 =?us-ascii?Q?T6AnF3FvIFPuLfuP4590XzvdnSlQIMDqyCTqC7ecTYyNyTHOfCL4D0UGPZ5U?=
 =?us-ascii?Q?y84KJoCig7UFZb2h3xNGXrLS5oePkoZR6UpG5f55Jk5RUuciST7zWaQ8bKtq?=
 =?us-ascii?Q?PQQJFTOPB0S/HZtdrApD2AEdb02AVnS7mMmnRCSfrZSEd+DH10i4LEnWPrjT?=
 =?us-ascii?Q?7ojn18E8SuOEs0RJN/4nT6kGgtrRvQx7KC/+6xDACbMSuUBishdoY2EcP7U+?=
 =?us-ascii?Q?SR+yXuT7WVUIcLAn/DRWwdVwCWZdru3fXkes9z4dDUuPAW8s061RLBV3lIqw?=
 =?us-ascii?Q?Oe3pZyIosPxPpm/BKBNkLDQf9SPua8Hu0e+0d2+J2PKrcrr8qKdVqwF+9Q3w?=
 =?us-ascii?Q?YY8l2tNF3IjLnovgiYgNy3m0jQZT+ePDjzUAyin3rqhFKnsAR3YRRsDZo0DE?=
 =?us-ascii?Q?YevieJJ6FPqw/sWgc/3BIrQGBxpbkDII4Ca4/X17a7OLJw4Wrpd7NoVooOuv?=
 =?us-ascii?Q?ZzD9NU+j7P0khw6SyxZ1beoQAA5xFd1RDRSI+bGpVXW3qIm/NFWoBb+g84lt?=
 =?us-ascii?Q?VRcuO6XBh1qhU/K3Mv04B0ssktHHGz5yJe0x6GMRDb9a7ADmiX5kVgg6Aq+J?=
 =?us-ascii?Q?qO6M8xbtS6ZvfGzN2EFCdyCSAGcxkgWobgRwNgeT5+QT/bGUNCCoASY7EB47?=
 =?us-ascii?Q?5OhjXejhvQyHYoF+fqFrZVExnjJihFIW3LZYCf0O2Di/q1bZRioDxuEvnhDI?=
 =?us-ascii?Q?EMb1q0a3Rtu5BogJsSaU/BQdc36q7kLgMmxOZk4Qf7QEFmMPJiBB5TkEqanZ?=
 =?us-ascii?Q?MFYBah+TjxQOZSuatfu2txXI2k3t/x2XL4HZfqBfzorbdqbhLhrLRTPat6UJ?=
 =?us-ascii?Q?qMdHa41I9TqB5LyazqP2GFJHhDO8BgCoJKAvhphj1IM9tnItZIbo4fkDS//9?=
 =?us-ascii?Q?zI3z1i8DocB2HqCoeSBaQa8WNE6CTaGWVV2LnnNjnsA8E8CGMO4dG+Qqf5RL?=
 =?us-ascii?Q?Jf83Y7JLZuQv1q8WXKqsgKatBsrwtI5/Oy+v57Pvfyrk9UOBHG2MKPnO+YBe?=
 =?us-ascii?Q?Z9+QTlGf4iz4WVrIfavsd7RfL3keW3mb83uhndYpKFTTlRf4Y9m5GtRq72Zj?=
 =?us-ascii?Q?WU63NAahyC1X09peDjnd7/XA?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57b5b494-f8e7-4a06-29ab-08d91e842657
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4202.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2021 07:18:37.9477
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ge2O4WKB0rQEOfBaRZNDjqZYCj2RBuzYXU44735WLE3iPab+xAlVSRLiRVEXNaMv9KEu3Ik9WTDQ+X8jnVNZhMz22Xu2ZUsHIK8x8LqCNEc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1964
X-Proofpoint-GUID: sW7dXDK8oDLL5yv8MuNjMRPseRC2sc-W
X-Proofpoint-ORIG-GUID: sW7dXDK8oDLL5yv8MuNjMRPseRC2sc-W
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-24_04:2021-05-20,2021-05-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 lowpriorityscore=0 spamscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 impostorscore=0 adultscore=0 malwarescore=0
 bulkscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105240057
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Zqiang <qiang.zhang@windriver.com>

The syzbot report a UAF when iou-wrk accessing wqe of the hash
waitqueue. in the case of sharing a hash waitqueue between two
io-wq, when one of the io-wq is destroyed, all iou-wrk in this
io-wq are awakened, all wqe belonging to this io-wq are removed
from hash waitqueue, after that, all iou-wrk belonging to this
io-wq begin running, suppose following scenarios, wqe[0] and wqe[1]
belong to this io-wq, and these work has same hash value.

    CPU0	                                             CPU1
iou-wrk0(wqe[0])                                         iou-wrk1(wqe[1])

while test_bit IO_WQ_BIT_EXIT			while test_bit IO_WQ_BIT_EXIT
                                                   io_worker_handle_work
 schedule_timeout (sleep be break by wakeup         io_get_next_work
  and the IO_WQ_BIT_EXIT be set)                      set_bit hash

test_bit IO_WQ_BIT_EXIT (return true)
 wqe->work_list (is not empty)
  io_get_next_work
   io_wq_is_hashed
    test_and_set_bit hash (is true)		    (hash!=-1U&&!next_hashed) true
   (there is no work other than hash work)
    io_wait_on_hash                                 clear_bit hash
     spin_lock					     wq_has_sleeper (is false)
     list_empty(&wqe->wait.entry) (is true)
     __add_wait_queue				    (hash->wait is empty,not wakeup
						    and IO_WQ_BIT_EXIT has been set,
      ........					    the wqe->work_list is empty exit
   (there is no work other than hash work	    while loop)
	io_get_next_work will return NULL)
   return NULL					    (the wqe->work_list is empty
 						    the io_worker_handle_work is not
                                                    called)
io_worker_exit                                         io_worker_exit

In the above scenario, wqe may be mistakenly removing
opportunities from the queue, this leads to when the wqe is
released, it still in hash waitqueue. when a iou-wrk belonging
to another io-wq access hash waitqueue will trigger UAF,
To avoid this phenomenon, after all iou-wrk thread belonging to the
io-wq exit, remove wqe from the hash waiqueue, at this time,
there will be no operation to queue the wqe.

Reported-by: syzbot+6cb11ade52aa17095297@syzkaller.appspotmail.com
Signed-off-by: Zqiang <qiang.zhang@windriver.com>
---
 fs/io-wq.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 5361a9b4b47b..911a1274aabd 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -1003,13 +1003,16 @@ static void io_wq_exit_workers(struct io_wq *wq)
 		struct io_wqe *wqe = wq->wqes[node];
 
 		io_wq_for_each_worker(wqe, io_wq_worker_wake, NULL);
-		spin_lock_irq(&wq->hash->wait.lock);
-		list_del_init(&wq->wqes[node]->wait.entry);
-		spin_unlock_irq(&wq->hash->wait.lock);
 	}
 	rcu_read_unlock();
 	io_worker_ref_put(wq);
 	wait_for_completion(&wq->worker_done);
+
+	for_each_node(node) {
+		spin_lock_irq(&wq->hash->wait.lock);
+		list_del_init(&wq->wqes[node]->wait.entry);
+		spin_unlock_irq(&wq->hash->wait.lock);
+	}
 	put_task_struct(wq->task);
 	wq->task = NULL;
 }
-- 
2.17.1

