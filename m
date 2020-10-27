Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14ED029A2EC
	for <lists+io-uring@lfdr.de>; Tue, 27 Oct 2020 04:06:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436964AbgJ0DGi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 26 Oct 2020 23:06:38 -0400
Received: from mail-bn8nam12on2077.outbound.protection.outlook.com ([40.107.237.77]:50017
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2436963AbgJ0DGi (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Mon, 26 Oct 2020 23:06:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=czEbd45o97W3nYBwMku7JsJ6uTgapmInV7WTqyBPgPoRoA4x7lW9L/f5cbNYX7pgH1Bl4DJ7MxMTapyhOTg3Ow1Fys35fP6bJjLX8IwZj10lAJBo7KHWRx3TL5qdzeJ/fuG9shCgPgTrj+ltwo+xfO7ROXaO7WbjcafeS10XcH038oqOwUQVKodmCszQX692nlL+g4s/NrGXPBoBg5feYh8Ik7ZuaPjxq2ces7k2FYsEZZUjrZxyXZPAO6041hELqS+cLKHNPzbF1i7Y+5i10zBsqyfglKDbofxZ/UFvGNkX7pCvgmRfYvig+Gyyt/CepXhIM41kEG8uBvsvU/5NsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z5WOUT3Hm1iMp/6QzZWhDZYx3C8/qWxktS3s7pbIne4=;
 b=UHcGIlH+fG0hCmOeeLcQCEnXUxAT8lsNNx82aeKfS96ocVZzD3Bwj3IqhSAjUk/BF+xjeOfUT1PWWU8U2mIpkNf/HVuNnyvlJL2rx4ygcBq5MSniSCZ5sM2YghUseK8jHYZxYorespAGjznrLOp8/Uxi9lNsa+Hi0Cf6ii3AgOmTg5XXrg287GiX8RyU/wftUfhB+SZuLH3mUfEvXn4nOiUPcbM6MrNC2WIWsdG/wDrgrTwlWMlNyvzP+aHcnK0tTRugzQzTeb2l0RwqaikX6ncuNHkPbPabowMGIgqoGLQxfh3FoQgGBuwiSfQZLOuR0WmGd3JuB6LlkrjwSxN53w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=windriversystems.onmicrosoft.com;
 s=selector2-windriversystems-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z5WOUT3Hm1iMp/6QzZWhDZYx3C8/qWxktS3s7pbIne4=;
 b=UfzoFCCeEEZtFPMXWHZvIFNbT6kbf4AjvaFhq3Ynkjm44AdX6FgaF9aHL3V2SBk+dkG2NgB/aPgUhaHPA1Vtc4s5URGslpDQMysm8OrN9lb4AUUKje8cV9JsC+uPKf7I24WvTC19wIY0+41FlkDo7YQStO5ztMabB6lPt3CkN6k=
Authentication-Results: kernel.dk; dkim=none (message not signed)
 header.d=none;kernel.dk; dmarc=none action=none header.from=windriver.com;
Received: from BYAPR11MB2632.namprd11.prod.outlook.com (2603:10b6:a02:c4::17)
 by SJ0PR11MB4814.namprd11.prod.outlook.com (2603:10b6:a03:2d8::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Tue, 27 Oct
 2020 03:06:35 +0000
Received: from BYAPR11MB2632.namprd11.prod.outlook.com
 ([fe80::80e9:e002:eeff:4d05]) by BYAPR11MB2632.namprd11.prod.outlook.com
 ([fe80::80e9:e002:eeff:4d05%3]) with mapi id 15.20.3455.030; Tue, 27 Oct 2020
 03:06:34 +0000
From:   qiang.zhang@windriver.com
To:     axboe@kernel.dk
Cc:     io-uring@vger.kernel.org
Subject: [PATCH] io-wq: set task TASK_INTERRUPTIBLE state before schedule_timeout
Date:   Tue, 27 Oct 2020 11:06:22 +0800
Message-Id: <20201027030622.16290-1-qiang.zhang@windriver.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [60.247.85.82]
X-ClientProxiedBy: HKAPR03CA0005.apcprd03.prod.outlook.com
 (2603:1096:203:c8::10) To BYAPR11MB2632.namprd11.prod.outlook.com
 (2603:10b6:a02:c4::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pek-qzhang2-d1.wrs.com (60.247.85.82) by HKAPR03CA0005.apcprd03.prod.outlook.com (2603:1096:203:c8::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.9 via Frontend Transport; Tue, 27 Oct 2020 03:06:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 82577eaf-9a49-44af-9570-08d87a254fcb
X-MS-TrafficTypeDiagnostic: SJ0PR11MB4814:
X-Microsoft-Antispam-PRVS: <SJ0PR11MB48149B987A7FEEC3386A0962FF160@SJ0PR11MB4814.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VjYw+G6MCiG1yXK62c4qUGGAFeHe70/xV6Btd9zqpGJytaFTYy9oJTdMcMM/jEaJX72I0UszmWvY12E9862u/Fc+cgShEwvL0lQmR22B8nOqs8z/4wQFh2Phrk2tprCFW+MgLXxaONfbodcntP8wfFKUJIDD9voppMZuesCA/e7eFRonANpo5KkU6zvP5ywwD/+yY9g8qE9yuDaiePMbGy+G9E2U4RNx6dnJnPr/AeFvP5HFacAQ4A95RIPZ46XtH6iFfA9+aK9oDhLXkqe6MmPpYaqqJOLIW1pPzVF7yKvccpNGrLjCe4QFKoWejWsT
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB2632.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(136003)(366004)(396003)(376002)(346002)(6506007)(6512007)(8936002)(9686003)(478600001)(956004)(66476007)(2616005)(66946007)(6666004)(4326008)(66556008)(26005)(36756003)(316002)(4744005)(186003)(52116002)(16526019)(83380400001)(5660300002)(2906002)(8676002)(6916009)(6486002)(86362001)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: cmB/xCA9F/9iuk1lKQ/eAu4wOAbK5+UnUp4B3TS7+wxeqEO6hSVVT20NBYc8ylv95jnFDWsx1Fk+ShQyi8WMXa22K2bFzAutTypID/X3tCE/cwCSvKRMJ+REl3rXvoTprk/hjLv+7Vunhr9sJ8JhvYWaKcfU+dtQJZ4VAno9L6Ft2yGQ9VThVYRI3zo8lMI/Hb1wrpnSPb6t+QapajQt76xiQN27kB2PmEXWYnztsCD1VHgxnQsTBQ7YBrLbtpF6sGznkVlLdnviyO6pSGDZ3BpjO91vMOquGbJEtRk+U9obXn/1rOewBhDgW1sFmeZyPTSYtdG9y2nXNUWmhn+vkQJkbqIH+B0L5plWAZJ/h2ucj2Jd4nw1tFeRcshpx4fTcDP42WzGvI09SA8XT+mgPtnw4PnFT2VmdPZpbNKGw3AQ9yXqx/TYueSfhUCf32TalUX5l8NIpiPboWAGLplt7Kmc19KzQvgOtICNMRV7Q3Awtqthd/AoIAFTl4y3ESZKhZcJwllCBAHhJwzHn0Jri76/cwor0oi9L5w9bJPu2HnXXvSf+pmyFjUzkH61yc1O5GXr+0IyUhpOyD9/UOJCBT9/jJD3txosMwV9CkaTIMATwBaUJ06g1V47Bp9KxUck2LNE0ue2VwTHK6oiboot/Q==
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82577eaf-9a49-44af-9570-08d87a254fcb
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB2632.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2020 03:06:34.8313
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9IgSY5s1J/IYxW+OvE27mcAFHY2ZU66QfbixA+TZL0jX2JXsE28JeSIwbSZhgw1ug/mrPBkuRQGLcSIjiKkoheClJTmAUWbp3a0Hi1WooSI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4814
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

