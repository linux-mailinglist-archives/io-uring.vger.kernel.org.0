Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 670F8295B33
	for <lists+io-uring@lfdr.de>; Thu, 22 Oct 2020 11:02:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2509224AbgJVJCW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 22 Oct 2020 05:02:22 -0400
Received: from mail-eopbgr760058.outbound.protection.outlook.com ([40.107.76.58]:39278
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2509157AbgJVJCR (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Thu, 22 Oct 2020 05:02:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WEOUn0u9JfE6tL0vCI3+6nG/ym+dkaw2RFS9c9WX8ybqIel0S9cFvudQWXHk6j42MfI8cyR6FmtVkjw+ylsWINC+UeO32cWekJbKt7WPpRsMmo+VFBurIcG8W/Opd8VUjkHwOArkg7Oh1XoRdvG+SUpWusVEzSbD6gBrhf9ZH5VTAfHgLTqY2IycUC/wL0nNhPDc0Bn2nVKt9oCMV28GPwsizWTlKavTW7kBITUWtbpBK2V60ebmNnmKFr3qmVcobvWJjnTqufdhW68wIuUbUl7N/fNTZmTV4Dmonr+oz59tUxjiDoGwNoPH2SHmHsK3uM1L0Shzitwv5ZToS1FwRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uk8pkplVnHuKZvsbWclz8S0909p2sLHVLhH81NFbJJI=;
 b=jB1Eb8IiZ9lXb572qh5cwMA0WpRYhLUL5nmM0I2yi1WF0gc+UwL3WJj0AU/EOF8Ad2Z9ExDAjyZihE88JOnpnNGWVvgNG9BBSnlUVjyE1pzXcXB7ZfKWbhgtAl1txkiHTbmrr78W/JCxz1bbL28yXRoKM9uHtbeguCx4EM4v4OjbpMGfar/836tNiGEVosp0CULNa3tCq2hHb6GIKO4Rg/H9X6RZI49T/Y1IoHornmy/03RwFOp+NWxFlLg8stGManpcbOYDbtNlRPHHjs5NJAjyL0zfAyQDO9qEXkwzOQd/HVIlVUUH49LwhYs6s7azVvWgdaN2G7EE3xmOtb/Gmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=windriversystems.onmicrosoft.com;
 s=selector2-windriversystems-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uk8pkplVnHuKZvsbWclz8S0909p2sLHVLhH81NFbJJI=;
 b=URuiOowBJyukzEgTtDaOPfyw8bdlSpu+wpy9Y6My+VdvE1xza10/5+Y71jcn8ebtuKdT2nycg3hpfoaUEfSWcumK28wuXqHWXH/uBTOhvPLos1z0WZwhR+pQaa3Pr+3LH9NpapRtxrrUn6xWx9RFWB1gr//nubAE7Nlx5HZ7PQg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from BYAPR11MB2632.namprd11.prod.outlook.com (2603:10b6:a02:c4::17)
 by BYAPR11MB2678.namprd11.prod.outlook.com (2603:10b6:a02:c1::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.28; Thu, 22 Oct
 2020 09:02:14 +0000
Received: from BYAPR11MB2632.namprd11.prod.outlook.com
 ([fe80::80e9:e002:eeff:4d05]) by BYAPR11MB2632.namprd11.prod.outlook.com
 ([fe80::80e9:e002:eeff:4d05%3]) with mapi id 15.20.3455.030; Thu, 22 Oct 2020
 09:02:14 +0000
To:     axboe@kernel.dk
Cc:     viro@zeniv.linux.org.uk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
From:   "Zhang,Qiang" <qiang.zhang@windriver.com>
Subject: Question on io-wq
Message-ID: <98c41fba-87fe-b08d-2c8c-da404f91ef31@windriver.com>
Date:   Thu, 22 Oct 2020 17:02:06 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [60.247.85.82]
X-ClientProxiedBy: HK2PR04CA0043.apcprd04.prod.outlook.com
 (2603:1096:202:14::11) To BYAPR11MB2632.namprd11.prod.outlook.com
 (2603:10b6:a02:c4::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [128.224.162.183] (60.247.85.82) by HK2PR04CA0043.apcprd04.prod.outlook.com (2603:1096:202:14::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend Transport; Thu, 22 Oct 2020 09:02:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 60611272-6a28-4648-e1f3-08d876692b3d
X-MS-TrafficTypeDiagnostic: BYAPR11MB2678:
X-Microsoft-Antispam-PRVS: <BYAPR11MB267819351A9B90026B9F1506FF1D0@BYAPR11MB2678.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iqDC6JIymOk9zGi8q1NM3tmERIsNF8Q8vkekF2Jth8+q+Ddn86o+f6JfTq2a8sN/YC8b1plG0h3mEcNgAKj1YA91ga5WYPze5gOByHGCu3x9Vs3Mt2yL9hk2qmAKnEYW/hRwKrk+9WgwtBbkcRDeLEBn5bupErg3oZUz+OEALE9Z936G/rHa13IEMz+FHNa7CYuMiv8yyJHf9gARLGkqUV0TsyqiyPRwwfcGNREyD0NlymTpVwhJxicN6fhh8LzLD4DbVOxriH0mIDs0qRAXRVUtjX64XoNIz9LZ8gBKquNuUJ3rSAasxtG0OgdBcK2Man2JgRnOSXqbdSZSfPtXPCKrdn8iT33TUPxNf4gZ7y8VYo0tCd9SB/qDVuOGMvhPezwdJNPrPkfD7CTuDnDX/Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB2632.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39850400004)(396003)(346002)(136003)(366004)(2616005)(8676002)(316002)(956004)(6916009)(5660300002)(4744005)(478600001)(6706004)(16576012)(6666004)(3480700007)(31686004)(66476007)(66556008)(16526019)(26005)(186003)(8936002)(36756003)(86362001)(66946007)(31696002)(52116002)(2906002)(83380400001)(6486002)(4326008)(78286007)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Zm51450Kxx7dAyrGrY0X85ptQtrzlaOeAFiM0yslfKy8ehOSdfqdpMIIXQ2CiSjA64iMXjjYtk8b4j3BcFFdiHGbzbmstNhf2LC+il0n2Se2TIUqLkOgqAwElI5LjdaIkvx3OWQDs6Sk6ADCnHdMEqrh+ScHUMueuWzQ+Lr/2ZNEnq6LquInuPDUxowBEbT9nnF8CNI46a120kfVEWsraGlufSqvlQxLOLSqfhTa8cs+pSFWuenzcce8IadxbGf4TZOB93kvJzCkl0Tdoky0wLTHRsOE+H4xVuDMSL1pmsNv1kMuAjcb050NrBL22l6r9n1LXS3CoINenDKWvsN+kvxmUh3VZKASJsEfy47v1h1nsuoG5acsJlq6hz3mTUCOp57LrmYNZ4dsS/ACxV2uXsmB2PZJmj3UonxRHN+xu22fPbStorACtrKkP8PQFWBr8YMkIbqi6Qx8i6cPkat7vyhvJ8OYpsHTjbzEh/KXi5RMi7MnpGz+NHFRS+fU7Dqn4ml/xmcfU67xC3UyxFLDodYkNIoa1aQoopfRW6H8lvrWbxBi42viiK8JmmwPK/VAUeBOqjDhT7eGRTFtgBuJNNTj8EIoSlYHIvb21xR0kj9EXvjr2FI7A6ahrhglTxKn18f2buQ8ABweN3dc+WmyQg==
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60611272-6a28-4648-e1f3-08d876692b3d
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB2632.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2020 09:02:14.3823
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xC5uFoKdSRbCsJBnEGsxfyGVJ927Ty8RTIJFSzL4KKSYZ9LZsP/s+g2X7U1uy1VHfKMezpv9uTeluyfqh9TyySxIBsXMUf8oHm5UltHZALs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2678
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


Hi Jens Axboe

There are some problem in 'io_wqe_worker' thread, when the 
'io_wqe_worker' be create and  Setting the affinity of CPUs in NUMA 
nodes, due to CPU hotplug, When the last CPU going down, the 
'io_wqe_worker' thread will run anywhere. when the CPU in the node goes 
online again, we should restore their cpu bindings?

Thanks
Qiang

