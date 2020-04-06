Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8013619F9C5
	for <lists+io-uring@lfdr.de>; Mon,  6 Apr 2020 18:07:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729103AbgDFQH1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 6 Apr 2020 12:07:27 -0400
Received: from mail-dm6nam11on2044.outbound.protection.outlook.com ([40.107.223.44]:12512
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729075AbgDFQH0 (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Mon, 6 Apr 2020 12:07:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i+TPPssuICou4asJ99Iym++kRBk9BR24hS6K3EEj2ofCsZhuLo+4/ruwhH62sopFoDaksRFBwg6zylN1YScHKjUpf1vhtai8OxWyFvU+h4Y1Pjs10x7pqWXJOmgQzs/lMbH1TqUK6P+RHwZv2dlcMvxt7SbMMI24NzGn1Tuv1zXnkpsSuqdwPteqvyqomIiHPiGidIc1lohFELDCVJ6cPzcHSNF7N6km2MH7CG+BZX/I3r5IAZPpsrRoMqNojovfXJ1UGRmEoehh0dtIRm5Q5yFvlpDd7gVsISPJUX74XJzX2FEqDUBBJFJzBbBek3wZpvO5Fx1eAkr5krrqOL3FgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KPRCsXgiEQCnrUqfgzdvarNZU7OswuG8ikb7f/mDN3w=;
 b=nS/nqqYic67ekypLzf7zaVMV80R87XHJRin43y4/mCF6IG9yup8CWav3SdcEwIp3ZhpPVZiYC8HfMoh5g/8vQBg8y1AQLojoF/X1mC3w4ojoViiHMBvefQ31R+sAWPUD2yTpnQg20PSKJhwcrXvFUgue+5xbLtqyNpeT18sLV1V6Db+Zzr984xUWV/btbvu4Z9/oPrEQUyfK3tguKSdELB4yUN2s3SiqOh1ldsyl1kgTy6aGV31JO7Si61oskFYuLY3pq5uPNGQ/xlRtz5OewiLEFcpdercstjJJ2poXmUfuDRlpUT7LbB6d/WAoutnGoDh76VBWAmyshVu2enUbaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KPRCsXgiEQCnrUqfgzdvarNZU7OswuG8ikb7f/mDN3w=;
 b=Y25sN394Xv+emUnzMORL+CLVLl0xmjZPJ7z/DT6AyN960RhyR64JiY322WiyZgrDtmhykBHdX+FchEy31CpC3Vju3ELaI646ucOVQTABOl03MFajqUEgj0h+Us0mpJIbxXA9/3IsP8LX6sIPOKMb3/eRt1K4oQo1Ly2UKuonso8=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Felix.Kuehling@amd.com; 
Received: from SN1PR12MB2414.namprd12.prod.outlook.com (2603:10b6:802:2e::31)
 by SN1PR12MB2509.namprd12.prod.outlook.com (2603:10b6:802:29::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.16; Mon, 6 Apr
 2020 16:07:22 +0000
Received: from SN1PR12MB2414.namprd12.prod.outlook.com
 ([fe80::38ef:1510:9525:f806]) by SN1PR12MB2414.namprd12.prod.outlook.com
 ([fe80::38ef:1510:9525:f806%7]) with mapi id 15.20.2878.018; Mon, 6 Apr 2020
 16:07:22 +0000
Subject: Re: [PATCH 1/6] amdgpu: a NULL ->mm does not mean a thread is a
 kthread
To:     Christoph Hellwig <hch@lst.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     Al Viro <viro@zeniv.linux.org.uk>,
        Alex Deucher <alexander.deucher@amd.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Felipe Balbi <balbi@kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org, amd-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-usb@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        linux-mm@kvack.org
References: <20200404094101.672954-1-hch@lst.de>
 <20200404094101.672954-2-hch@lst.de>
From:   Felix Kuehling <felix.kuehling@amd.com>
Message-ID: <b5eaf9dd-fc20-cf56-9efb-e6be848964bf@amd.com>
Date:   Mon, 6 Apr 2020 12:07:18 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
In-Reply-To: <20200404094101.672954-2-hch@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: YQBPR0101CA0019.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c00::32) To SN1PR12MB2414.namprd12.prod.outlook.com
 (2603:10b6:802:2e::31)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.2.100] (142.116.63.128) by YQBPR0101CA0019.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c00::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.15 via Frontend Transport; Mon, 6 Apr 2020 16:07:20 +0000
X-Originating-IP: [142.116.63.128]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8ec83d35-d9de-4ce4-b45f-08d7da4496c3
X-MS-TrafficTypeDiagnostic: SN1PR12MB2509:|SN1PR12MB2509:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB2509CFEDC2DB956DAC2152A192C20@SN1PR12MB2509.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2958;
X-Forefront-PRVS: 0365C0E14B
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2414.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(346002)(136003)(396003)(366004)(376002)(39860400002)(81166006)(316002)(86362001)(5660300002)(8676002)(16576012)(26005)(31696002)(81156014)(31686004)(186003)(16526019)(478600001)(2906002)(7416002)(956004)(52116002)(66476007)(36756003)(44832011)(110136005)(2616005)(4326008)(6486002)(54906003)(8936002)(66946007)(4744005)(66556008);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oXT4CzxYLxfRtUgiJSDkDJ5qwTdap1X/p/bOJzG9xmImd0CPuEtB2nPxQK+VbV/wk7YXgFlCwvE7HQ31PpkqyOrbNYqado2VUhvUIaRdoDjegk7xh9KdC3x7bYcai0oQGfwOX0eHKi01FpLgNINd0Sjp4f4eoEZHZoVbc6mBKHLgzS3nMM6iRlXkAOfU9QCB+m7X/cTYcSs2DeQTv3+595/E/G84v9EoYPdSxW0rhVe53E09Xm+SOBkdkTDV+y2Pwe0Z8lBf3oQ5D1k3Brlu6nCrN07t5t9KgugzgAzKcxamX2ldyUNIL/k2F1kVYzwXNLEhQdlzFelUYCIPLLmc3tRPta6R0Eho5AFnXELv793HcbeBgeXc8ABxdL4G2nX4zIOyEsw0m47JOEmV7h35tfnSRubSJvu8yOefDnnr4d0/TLZ/uzQ0WWIYuecgb3dT
X-MS-Exchange-AntiSpam-MessageData: un4gxw7F1dOsGh+k0Kc/z29dspwSHGdGXMVtKlpTx7HhJ0ndosig+lreZ3L98sKhY20baX3/Ma3inLz7rUE+Kd/bFFP2Ad22aH/WqCzTHJjfJ4EInS1HGv6iQE6gSwJZXNFZHRN9IuWuiqAb7/xoGg==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ec83d35-d9de-4ce4-b45f-08d7da4496c3
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2020 16:07:22.0322
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iERg53t9//jWQtbRLwIbJEZWuW7hv5+K7UxGSrCIHBFYj19TPWnbwtU+GqpcKee2Y/kmjNQp0ic8o2fPrKl7LA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2509
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Am 2020-04-04 um 5:40 a.m. schrieb Christoph Hellwig:
> Use the proper API instead.
>
> Fixes: 70539bd795002 ("drm/amd: Update MEC HQD loading code for KFD")
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>


> ---
>  drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
> index 13feb313e9b3..4db143c19dcc 100644
> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
> @@ -190,7 +190,7 @@ uint8_t amdgpu_amdkfd_get_xgmi_hops_count(struct kgd_dev *dst, struct kgd_dev *s
>  			pagefault_disable();				\
>  			if ((mmptr) == current->mm) {			\
>  				valid = !get_user((dst), (wptr));	\
> -			} else if (current->mm == NULL) {		\
> +			} else if (current->flags & PF_KTHREAD) {	\
>  				use_mm(mmptr);				\
>  				valid = !get_user((dst), (wptr));	\
>  				unuse_mm(mmptr);			\
