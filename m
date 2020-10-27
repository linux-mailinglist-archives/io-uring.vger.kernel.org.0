Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2A2D29A2F2
	for <lists+io-uring@lfdr.de>; Tue, 27 Oct 2020 04:09:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437463AbgJ0DJ1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 26 Oct 2020 23:09:27 -0400
Received: from mail-mw2nam10on2089.outbound.protection.outlook.com ([40.107.94.89]:47659
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2437444AbgJ0DJ1 (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Mon, 26 Oct 2020 23:09:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Uis3dAoLZh695sOApqJg34Dc5A7koVOLY291Tzc7xbATaPUeu6seQZYd2vn05srVHWV1x3HmpW2rXSb2yu+7vBNFe2FDj6FUwbdlIPN+tLPTWPR7Qo7qBAdahFKrLzZKIo3wo2BnwMG+d4azwlP7SxnPce3Dw+cnthBOp+n24bKJtCL31ypS4tJWnbQnvMY//jX5CsYUM7wI/kQ99FT2vhXuS7rDYpOqZAPkF69rEDxdi+xcY8VX6zzRNAoBRHJDDtjPMCj0F678ewMj69yrPYk5B+nGKYMvt1bOubnmkTfuayX79kF9B64pJ8ySCFv49QrdEqaqfuWjHlO1qDSB+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z5WOUT3Hm1iMp/6QzZWhDZYx3C8/qWxktS3s7pbIne4=;
 b=Bf3sIHvassIPZn7zRljz8cyt0DKJcLRcvPE4NW8/d0mu6KrGm6f5A0XF660kr5QFiHTClKIxCbuEJuP7491FU8opa7hHULuC4IB1wWw9uDVx/lSk5KZf3eqzFNMuIPmkyfsAUh0LCgyp28Ertrs2mmC0iNA/kizxDwxrk2KLK61wo7s/5dbbKwoDqeN2CC/8VrjjJ9J5QzVKNtVUiFpXHXUhPIljoMOKGyxaU/Dzlzrx8eUslPZ7xVZ1d24ZrSyflcaCfEqKuqOBf+4FWmf/yGEQllV6B7A5DWy6clrgfJbfB2Q8h6QoPOKgbWGE5Ece1IYY3ss2O60PR//A9DMyfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=windriversystems.onmicrosoft.com;
 s=selector2-windriversystems-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z5WOUT3Hm1iMp/6QzZWhDZYx3C8/qWxktS3s7pbIne4=;
 b=EBhrjHcfgzUUCmdtg81ON44EhYWPQ+35UMU5Fuq7EhWDEtiqkZC37aqhhWlBBWWtRyO4lSIooQEhzCE1L2tM576dfxMa9CBYilxSznltDPx0lEMkXgKELzt4K6a/z2ppB4L23OO5kZQBQMpxaJvpFbAkkh1defiRG0YBw3uNcxY=
Authentication-Results: kernel.dk; dkim=none (message not signed)
 header.d=none;kernel.dk; dmarc=none action=none header.from=windriver.com;
Received: from BYAPR11MB2632.namprd11.prod.outlook.com (2603:10b6:a02:c4::17)
 by BY5PR11MB3973.namprd11.prod.outlook.com (2603:10b6:a03:185::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.20; Tue, 27 Oct
 2020 03:09:24 +0000
Received: from BYAPR11MB2632.namprd11.prod.outlook.com
 ([fe80::80e9:e002:eeff:4d05]) by BYAPR11MB2632.namprd11.prod.outlook.com
 ([fe80::80e9:e002:eeff:4d05%3]) with mapi id 15.20.3455.030; Tue, 27 Oct 2020
 03:09:24 +0000
From:   qiang.zhang@windriver.com
To:     axboe@kernel.dk
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] io-wq: set task TASK_INTERRUPTIBLE state before schedule_timeout
Date:   Tue, 27 Oct 2020 11:09:11 +0800
Message-Id: <20201027030911.16596-1-qiang.zhang@windriver.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [60.247.85.82]
X-ClientProxiedBy: HK2PR04CA0070.apcprd04.prod.outlook.com
 (2603:1096:202:15::14) To BYAPR11MB2632.namprd11.prod.outlook.com
 (2603:10b6:a02:c4::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pek-qzhang2-d1.wrs.com (60.247.85.82) by HK2PR04CA0070.apcprd04.prod.outlook.com (2603:1096:202:15::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.19 via Frontend Transport; Tue, 27 Oct 2020 03:09:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9dcb918f-2fb0-4b99-eaad-08d87a25b4fb
X-MS-TrafficTypeDiagnostic: BY5PR11MB3973:
X-Microsoft-Antispam-PRVS: <BY5PR11MB39737D12EEACC8A5A4B75E74FF160@BY5PR11MB3973.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XUF29NquT81ixAKkBELEccTgeLDWjdGvPiat50HVQZWH35bQFNv7a2vKU94uQMiRNsGe6bMgm16RW61vIWDUNU2ky2K1eaMFV8asHb6UL6gnGzRkolla2D9MCL9cybTYch9UdIbpjZksnaNtmRdst+1bUjmZJ92JC/sDb89fXDJJ+b1pLGB5iHNgNkg5D0pG2tbmRenBwhU7H+5O0OfaOtrnP8oZHnLph7rjOHbNtwepK+RxCk7nqL7Ajs1glIUmE1zAklyujPiZYFNLemmGRdaPMfoNyFvZvgwlEEkqyDRKpSMJ9pvkXyeqlWQLUqli
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB2632.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(376002)(366004)(136003)(39850400004)(26005)(9686003)(6512007)(66946007)(83380400001)(6666004)(6506007)(186003)(16526019)(2616005)(956004)(52116002)(4326008)(478600001)(8936002)(316002)(66556008)(66476007)(1076003)(86362001)(5660300002)(36756003)(6916009)(2906002)(8676002)(6486002)(4744005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Dh4pf7edcnFshWkhmpeE1igc++syL8DpV1MaTvbYpoGKWLWa3ed/YBoYkN2WN5sB8WnXy3d09LSd2Eiw96wQaZ+rxy4VnuLrNVfFI8Nq9b+0uJB6KeqKTCCbaqAmnXSK3M2tz4AWuJqcW4WhqqJQ0G18Ff1swjv8sCe8WRnaCHOA6jiWilJwO0Vva5H15McV2bbPpHFSneZQq9lMWAynjKhTkWbYho0PWtzLQKewYfNYQibdHY0bhJt4ZbSIAp3efNccPoGHF+jfLOsW4lWR0qry+5u8qGybxsepY/V/FZw3HsnHve9Gt28s21BbXcbAND3U+/ombMBqr1tcu3jYg1plrc4dR/DZfF6eG4cOmJw0tVlA9o9Ur4icSK/VZvO3nCLlcZxoZMk//nRx7EJv8QN0vQ4EF1hAaWnr+ASKlnp/lCZ/B5aM/CJgRZMH30i2VDtoQZaBxE/R49Ta55QNkZpnstpOIOqGgRlgMeZoghX9B/47On1Jzx7rBeIRArp4/veZ0Avboqhmu3oiCqe/bzFg7DSURn4U3vakhU0cUIlmkWQY62jjN7Wr3E+kQa948fwn5sohE+u7sUxausdZIv9m9Mf1dBPg0M4HcTuCfDy33rrEFlEZoCms0TpZm/v4dCHcGigw39KuKgo26zTeaQ==
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9dcb918f-2fb0-4b99-eaad-08d87a25b4fb
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB2632.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2020 03:09:24.5020
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ygPFS2x71n9rr3/6kM9fs5S3HJ/HaAg8+FYX3itdyrohBYCZAF2fdfIkCjOf5LWzKxpFybf/XYeGARQjDg+ajkUtgwQcH3Op0127B2ZarAw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB3973
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Zqiang <qiang.zhang@windriver.com>

In 'io_wqe_worker' thread, if the work which in 'wqe->work_list' be
finished, the 'wqe->work_list' is empty, and after that the
'__io_worker_idle' func return false, the task state is TASK_RUNNING,
need to be set TASK_INTERRUPTIBLE before call schedule_timeout func.

Signed-off-by: Zqiang <qiang.zhang@windriver.com>
---
 fs/io-wq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 02894df7656d..5f0626935b64 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -618,7 +618,7 @@ static int io_wqe_worker(void *data)
 		raw_spin_unlock_irq(&wqe->lock);
 		if (signal_pending(current))
 			flush_signals(current);
-		if (schedule_timeout(WORKER_IDLE_TIMEOUT))
+		if (schedule_timeout_interruptible(WORKER_IDLE_TIMEOUT))
 			continue;
 		/* timed out, exit unless we're the fixed worker */
 		if (test_bit(IO_WQ_BIT_EXIT, &wq->state) ||
-- 
2.17.1

