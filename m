Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2185184DF7
	for <lists+io-uring@lfdr.de>; Fri, 13 Mar 2020 18:50:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726526AbgCMRur (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 13 Mar 2020 13:50:47 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:58172 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726550AbgCMRur (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 13 Mar 2020 13:50:47 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02DHiMY9024970;
        Fri, 13 Mar 2020 10:50:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=to : cc : from : subject
 : message-id : date : content-type : content-transfer-encoding :
 mime-version; s=facebook; bh=iRcpjrzDc3v/vN2xSmBuyAkBjtFRg1Y6d8Vl4t8tbAk=;
 b=XoexBphlBJVDug7ij5J7BicjVBFYKXXrtnwNpMmNHjAgKX6B+KddQeuwMl4vZlqTRQGs
 okDeBWruyurgLKaJqldWH3stm/UJIaclH0pt0E2Aiq7fUHnbf9Um/U/UgTpNBioNsWuP
 5OtnvDL0rcKce2VfSVRLrXSjTKljeL8EdOw= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2yqt7fneta-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 13 Mar 2020 10:50:45 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Fri, 13 Mar 2020 10:50:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QHqWCZBSSeKX1stCcPbBtOn4JyE04enkr6kiE/XnlQuOzN6gGFVXVTeb7SbjS9EU9c03zM5OXq0oXof0A4UUaYUaV9y059xSvIUFuY8ZXja0PNmvTEiG1ITgumPlqXzrfV5Lnow734H1+wrT724/Tkjbpr6aFQelS3vE8HIG3PM2yzLaubgxwAaMmg9RlZFY8JvbuJJeM7KT6tsQPifR1BJ+Zl4d6XgPOCHnxg7jyRuA3IArfwPdX20pI0t9ej3vbKxgedXaYhU2XF1iPSdEpbpo+OPafaFZX4mWeL74gMKIj3s64q/YNX+kp6qU6LyZYATfgb8LmIrHFARmVtRqvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iRcpjrzDc3v/vN2xSmBuyAkBjtFRg1Y6d8Vl4t8tbAk=;
 b=aJ+hDRM29cb2+C8hNhpEU9PSUmP4UU9ZkP8cBHYrGZzCAfhgS5sNSrEnS0haygGPtF0ue/6CStelfu2yx2+vGiCqgGWTaWuGQrVZdfD/uCNqcNwLRYdql1sgsvj9cig5QpbxA4Vn4eWcFMys5GbT+8MvSKGTVMVmtL4FzjW4TTF0EBlPB27XempzbQ9coXSBItRcDnGt47R2hFREEXNvRYdQkpSQp/EgcSG86Jz9ucW+o+MjwvY2KpzBrt11S+ZkFLGpHhUWrxVhk//Dk6qgiZWogqsyxWpYPgOkjAnqRAMXLp86pFz0KRRy5YMx0M5Z0GvAi+9c7uX24zbzQgcTyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iRcpjrzDc3v/vN2xSmBuyAkBjtFRg1Y6d8Vl4t8tbAk=;
 b=csBHYAZl2YfkUwNryEswtagAXRpWFN85x4mmPMlJVEhe1JuM0P/UFvDet9utBkxPzPX/vcGroE4uNbRd1sJvxwKdW+gp5CoL9Fx22UVrFaXTI4v+bVTYRwUVRWKmKQDALDrtdxa725bGgI9WeEh+9xw4m34mbPL0VEIpbFQ61yQ=
Received: from BYAPR15MB2790.namprd15.prod.outlook.com (2603:10b6:a03:15a::31)
 by BYAPR15MB3032.namprd15.prod.outlook.com (2603:10b6:a03:ff::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.18; Fri, 13 Mar
 2020 17:50:44 +0000
Received: from BYAPR15MB2790.namprd15.prod.outlook.com
 ([fe80::4c56:ea:2fa5:88f5]) by BYAPR15MB2790.namprd15.prod.outlook.com
 ([fe80::4c56:ea:2fa5:88f5%2]) with mapi id 15.20.2814.007; Fri, 13 Mar 2020
 17:50:44 +0000
To:     Linus Torvalds <torvalds@linux-foundation.org>
CC:     io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
From:   Jens Axboe <axboe@fb.com>
Subject: [GIT PULL] io_uring fixes for 5.6-rc
Message-ID: <00e5ab7d-f0ad-bc94-204a-d2b7fb88f594@fb.com>
Date:   Fri, 13 Mar 2020 11:50:42 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR05CA0073.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::14) To BYAPR15MB2790.namprd15.prod.outlook.com
 (2603:10b6:a03:15a::31)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.188] (66.219.217.145) by BYAPR05CA0073.namprd05.prod.outlook.com (2603:10b6:a03:e0::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.6 via Frontend Transport; Fri, 13 Mar 2020 17:50:43 +0000
X-Originating-IP: [66.219.217.145]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e7630b94-8de4-4c5c-12ee-08d7c7770da1
X-MS-TrafficTypeDiagnostic: BYAPR15MB3032:
X-Microsoft-Antispam-PRVS: <BYAPR15MB3032887B7D1A9B598FF63CA9C0FA0@BYAPR15MB3032.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-Forefront-PRVS: 034119E4F6
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(376002)(346002)(136003)(396003)(39860400002)(366004)(199004)(16576012)(316002)(4326008)(2616005)(81166006)(81156014)(8676002)(956004)(478600001)(4744005)(54906003)(5660300002)(8936002)(52116002)(31696002)(6486002)(31686004)(66556008)(36756003)(66476007)(66946007)(186003)(86362001)(16526019)(2906002)(6916009)(26005);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3032;H:BYAPR15MB2790.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: O7u0Ye4Wwb5/9sIpiOzZYO12tbJlnfqr6TzyRi+yCDpx+Wk5IHl/pEGSX+8Rw8SfASJORAReFr0NZS8APOlvD5nRx699e3jF95T0yrZRKR8+fhfjqjr6qX0LKf//RH4Pd4/dVZxKN55kGjV9lXDiEq2RfG2IDXG/btpz6p4PvVGOOfl0/mmySVTiAK2aV30lm0IWU6DRHSZ7T6CGS7f/Lnfc8L1OWP9WKcCdP0qNTMcnrGXBfJfPxSmNMcMXIyKqzhCoYwOlfvyeLY5yBtT/SqaUSQcgevWLJHFBys6NudLNoIwJkCQtCUDQWmP7e4R/9d49gQM2H1mLrBfY9QAIQF92dZ71N5pRz2DnQLXsGlq/Z9FIBRJffRolyMEOUG5OHbkcHk5AeHr7Jh6APgk74/w1fzun2AVx6RF85FPUgt7F1DzYLkDGEl3wwBbgf7wi
X-MS-Exchange-AntiSpam-MessageData: aW3AorgV9IFNjyzlyURwz342Y9aBmC1wkhp4VAXqIMoCixfuu3M49/z6aXshPGSIcOSNruRIq7dVopg2C4ec1b+3DJEw5L73XNma8XsQyPtVcVVqi8VIiLruHJBeZnxW/KB3R+Ywi99MvdA9mRs9xA==
X-MS-Exchange-CrossTenant-Network-Message-Id: e7630b94-8de4-4c5c-12ee-08d7c7770da1
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2020 17:50:44.1839
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R7PHDbdCH2MmSofXgoIwgzcbpm4JcwgwtLaVFw4aZWOwg35QjfZ9xlB+CIYiI1LW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3032
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-13_06:2020-03-12,2020-03-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=705
 clxscore=1011 malwarescore=0 adultscore=0 suspectscore=0
 priorityscore=1501 bulkscore=0 phishscore=0 impostorscore=0 spamscore=0
 mlxscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2003130087
X-FB-Internal: deliver
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Linus,

Just a single fix here, improving the RCU callback ordering from last
week. After a bit more perusing by Paul, he poked a hole in the
original.

Please pull!


  git://git.kernel.dk/linux-block.git tags/io_uring-5.6-2020-03-13


----------------------------------------------------------------
Jens Axboe (1):
      io_uring: ensure RCU callback ordering with rcu_barrier()

 fs/io_uring.c | 29 +++++++++++++----------------
 1 file changed, 13 insertions(+), 16 deletions(-)

-- 
Jens Axboe

