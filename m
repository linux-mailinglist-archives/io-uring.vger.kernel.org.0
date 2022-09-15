Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C33B75B9ED1
	for <lists+io-uring@lfdr.de>; Thu, 15 Sep 2022 17:31:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229921AbiIOPbD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 15 Sep 2022 11:31:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230142AbiIOPbB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 15 Sep 2022 11:31:01 -0400
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (mail-tyzapc01hn2242.outbound.protection.outlook.com [52.100.223.242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD7664CA12
        for <io-uring@vger.kernel.org>; Thu, 15 Sep 2022 08:30:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WuAUb28q0XYPNG60vV5cstdHs+/6vPLWQmW5keStW4hgIzwkj52wMlgrPnaUS0WTXgKYbFGfmDw85NPCbyAo5G7h0m8hF/vwTQkGXXKXd0YMpFMv8S6jXri17qUpIznl87my675bGvQgkgK9InVlCUUBwZ7ZE1Ut6LML77DXtCiVALmPqEQqAbKpaUwMfi/sld0jBU4nnf4qq5WwsV04YQPLxCYMPNPX7IzgPd/rywDuBOtPD6DXsjmyokTNfBj3P8FysFa/9+vdE1nclCJV6P0AyTgleqB4U5Qfu2uu7zHIM0R5A3BmwACWO93GTz8e9CLToiT7Ar5zt2yB7x0wKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Bs10Md+15nMnyayKLyd22Uv+/ZH79IcFcpzuzGLq1Fg=;
 b=nhyu85UeRBKMSDaGc1dakjvR9riFPzudoy4nBWFUvZKXuBC05PT4RcZTuzqKcXfDpZu40ouapHfk4lOlHj59TfgQKtziEu9ifP+23XBwnzoTkQLmBJoNcbhA1wDKZcsVKKU3N4GhPbaBhkIcogQ1xUp6OQQTBptW5GHZQ7Dm9ShCfHZ3ETE23tCRMn60hFh3d20nRRzv+7WaBRAvphDpfcmskE0KCAdgP9ZxxhZ2wVjuCtYdj5q55+uUqRlMTL6u+uBX/EOM1VdT6ltw4mGjaLvO7gY43vU9bzG2TreWfi8+OhMkYHo7og52+LAiHhezKsApK9gKNvj00BadTgesSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 195.181.163.1) smtp.rcpttodomain=naver.com smtp.mailfrom=t4.cims.jp;
 dmarc=bestguesspass action=none header.from=t4.cims.jp; dkim=none (message
 not signed); arc=none (0)
Received: from SL2P216CA0139.KORP216.PROD.OUTLOOK.COM (2603:1096:101:1::18) by
 KL1PR0401MB6243.apcprd04.prod.outlook.com (2603:1096:820:c3::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.14; Thu, 15 Sep
 2022 15:30:57 +0000
Received: from PSAAPC01FT035.eop-APC01.prod.protection.outlook.com
 (2603:1096:101:1:cafe::c2) by SL2P216CA0139.outlook.office365.com
 (2603:1096:101:1::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.15 via Frontend
 Transport; Thu, 15 Sep 2022 15:30:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 195.181.163.1)
 smtp.mailfrom=t4.cims.jp; dkim=none (message not signed)
 header.d=none;dmarc=bestguesspass action=none header.from=t4.cims.jp;
Received-SPF: Pass (protection.outlook.com: domain of t4.cims.jp designates
 195.181.163.1 as permitted sender) receiver=protection.outlook.com;
 client-ip=195.181.163.1; helo=User; pr=M
Received: from mail.prasarana.com.my (58.26.8.159) by
 PSAAPC01FT035.mail.protection.outlook.com (10.13.38.90) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5632.12 via Frontend Transport; Thu, 15 Sep 2022 15:30:56 +0000
Received: from MRL-EXH-02.prasarana.com.my (10.128.66.101) by
 MRL-EXH-02.prasarana.com.my (10.128.66.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Thu, 15 Sep 2022 23:30:33 +0800
Received: from User (195.181.163.1) by MRL-EXH-02.prasarana.com.my
 (10.128.66.101) with Microsoft SMTP Server id 15.1.2176.14 via Frontend
 Transport; Thu, 15 Sep 2022 23:30:02 +0800
Reply-To: <rhashimi202222@kakao.com>
From:   Consultant Swift Capital Loans Ltd <info@t4.cims.jp>
Subject: I hope you are doing well, and business is great!
Date:   Thu, 15 Sep 2022 23:30:43 +0800
MIME-Version: 1.0
Content-Type: text/plain; charset="Windows-1251"
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2600.0000
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2600.0000
Message-ID: <47cf8db0-3adb-48a6-a5b3-22818e7ffa53@MRL-EXH-02.prasarana.com.my>
To:     Undisclosed recipients:;
X-EOPAttributedMessage: 0
X-MS-Exchange-SkipListedInternetSender: ip=[195.181.163.1];domain=User
X-MS-Exchange-ExternalOriginalInternetSender: ip=[195.181.163.1];domain=User
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PSAAPC01FT035:EE_|KL1PR0401MB6243:EE_
X-MS-Office365-Filtering-Correlation-Id: e1954723-59ef-42de-9693-08da972f4909
X-MS-Exchange-AtpMessageProperties: SA|SL
X-MS-Exchange-SenderADCheck: 0
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: =?windows-1251?Q?31jr+czFZdvUSaGBzts3n8JH/dOaMgDqQnuaZ/X3vin5KMOvSOnLjw9v?=
 =?windows-1251?Q?5+J0tYFsYFV+bmQcrorWZ8hXE//jg6nyiFU0SFp/5pyykgzMwhDy0fM2?=
 =?windows-1251?Q?1aN7QEYsPHLcUsmXqZ9pqnb+ENgvgWV32AmCY5PvvdGOerPHbki7PaZw?=
 =?windows-1251?Q?6v/hVl1OpDTUBRDDOJl7t7N6vc/zkACqJIObkLag6c/hbDPcmJrHYFCW?=
 =?windows-1251?Q?u9FEHRZX7IYwPxNZIcgCtY71RMdDUeElO4Whd/2UGoR4aUXopk3p5ssU?=
 =?windows-1251?Q?Umsea9cHeOcxBUmS4JzeCn7V8zj45wz2Fv2nSD+LxUVnSkt6G1hE8I3K?=
 =?windows-1251?Q?Bk4rjEn7d95prqQGioJBw1MaOhaCWz0DXZ1ZiD+QZcCs3OAL5IIZeMiq?=
 =?windows-1251?Q?t4+j9YmWuFL0oOaEBETV833TcKoqYSlbHpsN7Ng/pWWAEFf9b3FNCnDS?=
 =?windows-1251?Q?xNzle20SfwrRP7UqoxTKI3MpQDyMxwlGhgMvc4JuCRb9SBDhgD2KG/3U?=
 =?windows-1251?Q?4fN7kkI5JbLaiLHgYFI0BHOiswAXIGEbAgBhqW+j9TuClps0CHsudPGP?=
 =?windows-1251?Q?uJZ+T2+SRZe7RKcMlLReq5D3nxZZi3dHAvS5rXUq3nfpXqtedILR4T+w?=
 =?windows-1251?Q?hYMh+YQkuSgpWFAVtdu407ymLCe6t5hLJjzcKFfkPxrTRhk01o+LcIG5?=
 =?windows-1251?Q?Yi3taLHtVpO89utqs/TjpxhYDi6kQhtmzpkW2Tj5H3AWMgEVsVdsjK0x?=
 =?windows-1251?Q?iKLSWe0CpwXicmb8nmaYV2jVSNVQ/gKhmUAXsA2JF5gH4LHwrqmmszT6?=
 =?windows-1251?Q?zL9BgcsbhA8WMZoioqf8IoXHkt6RYR24Ti20PtiKkcq67DDTVSCP4aHc?=
 =?windows-1251?Q?yWsOznVesDPpfqkoZCcPtS1RMQFkVOCWBALqhY7NrwtbW9lw520x6CeK?=
 =?windows-1251?Q?+LSjeQcYuyOkoEVSbWNXGN8dTaQy2E+cHtr08sxJM9s7nlXrCxxylsh6?=
 =?windows-1251?Q?1l/czpZjRDNH56XIaPj6E8aqE2aVY1NKAplbXHQgm1WIsDZdPpv67pUt?=
 =?windows-1251?Q?3h2zB+ZV2FrMX6Id9IC8JRn3yr8T9MOu/QklUsmIqVIE3UW6JbK/1MQg?=
 =?windows-1251?Q?9Ph5VoI6j0S3L6OLw3JXQ9O56eUIFD5OYyHc2buzR/MBGOcHUO0bhy9+?=
 =?windows-1251?Q?bDDNq8nI3zwkzmWMeCtC2Lklq+EJYhBTaRV3fzDXUVbhT/BbCcJLLZkw?=
 =?windows-1251?Q?gmRb21KSkJ0R5uXydqacrMojjNXAaEOTNUch7c+IsKatn/WiEBO+lmKJ?=
 =?windows-1251?Q?yt8WkSUv8e3ORkADJvk+VE8WD/f2lTpYLEwYOsxISGWkB792?=
X-Forefront-Antispam-Report: CIP:58.26.8.159;CTRY:US;LANG:en;SCL:5;SRV:;IPV:NLI;SFV:SPM;H:User;PTR:datapacket.com;CAT:OSPM;SFS:(13230022)(4636009)(346002)(396003)(136003)(376002)(39860400002)(451199015)(40470700004)(35950700001)(31686004)(7406005)(81166007)(7416002)(8676002)(70206006)(70586007)(7366002)(32650700002)(4744005)(8936002)(956004)(82310400005)(2906002)(66899012)(40480700001)(82740400003)(5660300002)(9686003)(336012)(41300700001)(26005)(498600001)(156005)(40460700003)(32850700003)(316002)(36906005)(109986005)(31696002)(86362001)(6666004)(2700400008);DIR:OUT;SFP:1501;
X-OriginatorOrg: myprasarana.onmicrosoft.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2022 15:30:56.9406
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e1954723-59ef-42de-9693-08da972f4909
X-MS-Exchange-CrossTenant-Id: 3cbb2ff2-27fb-4993-aecf-bf16995e64c0
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3cbb2ff2-27fb-4993-aecf-bf16995e64c0;Ip=[58.26.8.159];Helo=[mail.prasarana.com.my]
X-MS-Exchange-CrossTenant-AuthSource: PSAAPC01FT035.eop-APC01.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR0401MB6243
X-Spam-Status: Yes, score=6.9 required=5.0 tests=AXB_XMAILER_MIMEOLE_OL_024C2,
        AXB_X_FF_SEZ_S,BAYES_60,FORGED_MUA_OUTLOOK,FSL_CTYPE_WIN1251,
        FSL_NEW_HELO_USER,HEADER_FROM_DIFFERENT_DOMAINS,NSL_RCVD_FROM_USER,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [52.100.223.242 listed in list.dnswl.org]
        *  1.5 BAYES_60 BODY: Bayes spam probability is 60 to 80%
        *      [score: 0.7562]
        *  0.0 NSL_RCVD_FROM_USER Received from User
        *  0.0 FSL_CTYPE_WIN1251 Content-Type only seen in 419 spam
        *  3.2 AXB_X_FF_SEZ_S Forefront sez this is spam
        * -0.0 SPF_PASS SPF: sender matches SPF record
        * -0.0 RCVD_IN_MSPIKE_H2 RBL: Average reputation (+2)
        *      [52.100.223.242 listed in wl.mailspike.net]
        * -0.0 SPF_HELO_PASS SPF: HELO matches SPF record
        *  0.2 HEADER_FROM_DIFFERENT_DOMAINS From and EnvelopeFrom 2nd level
        *      mail domains are different
        *  0.0 AXB_XMAILER_MIMEOLE_OL_024C2 Yet another X header trait
        *  0.0 FSL_NEW_HELO_USER Spam's using Helo and User
        *  1.9 FORGED_MUA_OUTLOOK Forged mail pretending to be from MS Outlook
X-Spam-Level: ******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

I hope you are doing well, and business is great!
However, if you need working capital to further grow and expand your business, we may be a perfect fit for you. I am Ms. Kaori Ichikawa Swift Capital Loans Ltd Consultant, Our loans are NOT based on your personal credit, and NO collateral is required.

We are a Direct Lender who can approve your loan today, and fund as Early as Tomorrow.

Once your reply I will send you the official website to complete your application

Waiting for your reply.

Regards
Ms. Kaori Ichikawa
Consultant Swift Capital Loans Ltd
