Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F35A1485BAE
	for <lists+io-uring@lfdr.de>; Wed,  5 Jan 2022 23:31:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245073AbiAEWbQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 5 Jan 2022 17:31:16 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:7472 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S245066AbiAEWbH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 5 Jan 2022 17:31:07 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 205KwCAN030000;
        Wed, 5 Jan 2022 14:31:04 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=Yie08RZeGC6LCvVeXqBjQmA1t85F3OnwArhyMx5OSRE=;
 b=DrVHsCsKi0mTtJzwqTKrt5rbUTQ0b9TPA4V1k/lTtC73bCTJQ13mDxi7TZkGfG2p6hE5
 sUiqJh5Q0ZAkeLtzuvvtETw7mYvwDgWonDmex05keRc3RY2bocQioUZYNPovJcMtFaJR
 pxEwJ+m5LFCTSc0h76I8uL75lBEnqNkuZ9A= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3dd15ne7kb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 05 Jan 2022 14:31:04 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 5 Jan 2022 14:31:03 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=adM7dI+rSY6M+4EfcFDifOoBgI9MoyUBssLdOR8BUBxBdSzD/on0TyjviMP71ULTcRl3dTxUCErS7NPGJ3SE27mf95lOh+YaLs9+2y0wnDaeMY9hO/oWRnzGgVDL18DYza+q7+/wyqrIU5LRP1akgCNuh9+NnHolDuE5eDZryGLG0Ep4ErT2LQWK5SsVeqmpR/V+T/LJkTnjGCuvV3ccPRleb+9aT8uMsuaIg1UV0cabZynjtM5jN3eH1BzObpODgU6/PICiKohaQFSJJs7IopePy/X2Fd+dqzsYx6eb8VDJL5yVb4RQd5avlrp9bQ5LCDTmfxQTbtkXrV9n8ZHMgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Yie08RZeGC6LCvVeXqBjQmA1t85F3OnwArhyMx5OSRE=;
 b=DBA5MvxLvbDvH9PZ+mVy7LCuJobEsNdV1GPV8sCjNSooNlsndDFedfWoeUZDGYtLxcr7H9VqlZ+YXGZQB8SphVQSJgkzYy3A5XKbbUr0/7oKsc2fuLtLYCRdFfgoVxhcUmsyxK5KuzkNASbwBPXqlOKKTEgUTEkeiVGQcOA1nyUGqmj33/txyMDpkIgI6sweZWXHXdtwmRsPEFZOIHJdnWhEi3bKR63stZfdaad/5hXdnP/50ocNnCOZ2EMBY9RxeUoXpJXG7MXWUw6mdwhH60rM2rqdqrnkwZ28GKgWU3KSmNLW2gxmd4FupvpberXjGZETASEfrRMZYDPp3hEOAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from MW4PR15MB4410.namprd15.prod.outlook.com (2603:10b6:303:bf::10)
 by MW3PR15MB3881.namprd15.prod.outlook.com (2603:10b6:303:4a::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.14; Wed, 5 Jan
 2022 22:30:56 +0000
Received: from MW4PR15MB4410.namprd15.prod.outlook.com
 ([fe80::98a2:5a86:4a54:acd1]) by MW4PR15MB4410.namprd15.prod.outlook.com
 ([fe80::98a2:5a86:4a54:acd1%4]) with mapi id 15.20.4867.009; Wed, 5 Jan 2022
 22:30:56 +0000
Message-ID: <ffa5b244-0745-b413-542b-f36406e545d7@fb.com>
Date:   Wed, 5 Jan 2022 14:30:53 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.1
Subject: Re: [PATCH v11 2/4] fs: split off do_getxattr from getxattr
Content-Language: en-US
To:     Christian Brauner <christian.brauner@ubuntu.com>
CC:     <io-uring@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <kernel-team@fb.com>, <torvalds@linux-foundation.org>
References: <20220104190936.3085647-1-shr@fb.com>
 <20220104190936.3085647-3-shr@fb.com>
 <20220105132249.p3jwgshoe7lhpna3@wittgenstein>
From:   Stefan Roesch <shr@fb.com>
In-Reply-To: <20220105132249.p3jwgshoe7lhpna3@wittgenstein>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR20CA0026.namprd20.prod.outlook.com
 (2603:10b6:300:ed::12) To MW4PR15MB4410.namprd15.prod.outlook.com
 (2603:10b6:303:bf::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6d19de2d-fb3c-4fa9-7c5a-08d9d09b0a59
X-MS-TrafficTypeDiagnostic: MW3PR15MB3881:EE_
X-Microsoft-Antispam-PRVS: <MW3PR15MB38810C0F7B97D6723A264ACED84B9@MW3PR15MB3881.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Gl3ky0JFys9HCzQNflG3E6N7Z2RI+AUQWatmSdM2TXVAdu0tdNCNT6DjYCzaODOv9//PGX5eJM98oLfdx7QRacdRMEPBBycm3S3/z0v6skEuygfPFIXn6J4AoITIrlWoZvKSH5hTpbbq6sv3Ao4IFYuLPJbIXDBsr0fxG3ZP2oLCYmxGLhw/RVLelKJlwDSycKNAxJcQui1OCXclZV0ZIcfrrOXRJtFLdFhw9DqJDnpBbjy+3lWZO8R/Tu+DJG/zz32nbcJwHjn/PlpJxuhWeXtyk3LUBzTgXTF0dmbixf6DCSgOsSVwvEBgIJlkUe8BD1a0dNr3fSZqOxW3vo9snavQO9DAR8AtP+/BU1EKVkoodBGIuec9wzY5AVK5qU0pgiuidG3CiMXJLzlWVTIko6WGPEGjNNXHYYagSC9bhGL1UE9DTThzLf+5MlPB4aFGue61jxVtybKQ6byPRE2Vupb5+gCIMOuMRaUvJiNw39K9NJBAf35aMoiOXGC//+g/p2BYGJuQMlj/EUEGdJ6zVhCaLzxp1TXkpmMZbJlcb+pjzjUcqX7JP4bdhz7/RsCuXw1fCkHtf4CNxfYT29s5dPsP/cF3KZEI0qT2RI8Uc9xdBGpKOcTubkZPzYS13z63c30trXXbOU2EIxGapPVyasyBsh1aGrNASUuiDWgq8kPBX6MotPZjfENlYAPyoCIR77H88uV6JoqgahqMB1yBzkoAcB/fdyWx6io7QmZI32g=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR15MB4410.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6512007)(83380400001)(38100700002)(6666004)(53546011)(186003)(6506007)(86362001)(36756003)(4326008)(316002)(2616005)(5660300002)(31696002)(8936002)(66946007)(508600001)(66556008)(2906002)(8676002)(6916009)(66476007)(6486002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eVUyaFF6Y2lTSGFxdFFaZktsaEduR1N1d3p0WlF4MmFnWFo1Qi9MTnp2MWx1?=
 =?utf-8?B?c0NhZXd6LzBGZFE2TU9DdjhESXdYMmlQZ1FSdHIzdHJBL3JFOWJNTlEyV2JZ?=
 =?utf-8?B?dkxJZHcrVHhwNmg2dXZQVTFGcXdidi93TS9xWTBnSXdpZHNpbERNRU10L0NT?=
 =?utf-8?B?NmxKS1YxeFRiZFgzYjZhbFVQeVdSY0tpTFR5clJ2OC90TFRTbGRsZTNYdTA2?=
 =?utf-8?B?OWxvb3BjKytNa1BZOG1xZXBrcTFlLzJ2RTQ0eDVWMHIxME5xN2lsNnBuVXRn?=
 =?utf-8?B?N0QwSDhGaGtBZWhYVFlSN0QxMXBadjczS0VvRjNNTlIwUlRia3ZHQ25PTXhN?=
 =?utf-8?B?WlJvWmpxeEkwQ1BiUFJWa2JlTjVWQ0gyWWtjTUFCcHBFdmVXWTkycjI4MDVv?=
 =?utf-8?B?N3BIaEVpLzlpdFJCOUo4MzYrenpsZVMvcThQZE9UQTdnWGh5ZXJhV29ucTR4?=
 =?utf-8?B?dU1vS0s1aFhhbHM3T2hXeEdmazhMNUtCZ1M0cS9VeDZ6VXdaSnA5VG5tTUJ0?=
 =?utf-8?B?NE11VTR1VGcxc2R4RzljS3FsYkRmNlZPSzNYK1hGeld2TG92V0oyR2llVTJu?=
 =?utf-8?B?eDlKK3FneG1GbTFBQit0TnRHWDZOT2dWdkUzbE5HTENyUnJaZ291VkNkcjlM?=
 =?utf-8?B?NXNGSC9xYUJvR0pyMzBQZlRwTldLTkRLUkUzZURqL2Via2xlWkJZUENtM29q?=
 =?utf-8?B?NCtBNTMwMlVSa1RLR2VZUWlhVGlqUGIxaWRlVTZJV0JJMlJlRDdwMGdtZnB5?=
 =?utf-8?B?bkw1Rmd4b2tKOVgxTE1DWjVJTnRNTnp4ZGVuRFdkY3AwYXE1dUY2OWR2OWUy?=
 =?utf-8?B?d2Q4UElSZC9IMGJoS2psazVqSmJKWWtPeDZiYnRMV0RBRHUrbjdiKzA1dWN5?=
 =?utf-8?B?djhZWEIxS2ZNZ1VPWUJZZGJ0YXFuUVJ5dmNlWDNqK2lROHpHSG9UNzNySVBC?=
 =?utf-8?B?bDVjelphSmVIc3hUUkcyak9qbUpyUEttT0owUWR2YUUzSE1ZbUJPdmFhY0xQ?=
 =?utf-8?B?cmhaK1Y4TFRCbkprMVhPQVQvSHBzREwxZ0owdmRVT0tIRm1zM21ZQjdvOEZz?=
 =?utf-8?B?dzhVWGNrQzUrbUFLenRZMWVRSGZhelpPM2pFM3NCM1dZYkhsR2pySjFaNm14?=
 =?utf-8?B?My8wUWJ3aCs1MkxFVThKaElVa1FaN01pYnZLVEdZVjV2TzM5MStLbTYrdGtm?=
 =?utf-8?B?UE1RNGxpSFZ4WW8zaHFKR2REUithTW01WGpqbzVOeTRKRWYrWjljTUpNcko2?=
 =?utf-8?B?b3E0TmxkeWhXQ0ROakdpalUvd1QyTnkyVm9FakNyY2RsYkhURW9zbld6VHZm?=
 =?utf-8?B?Y2Eva204bzR1R3JsTTJES0NqaGZDVEZmRVJlYXNVTWF0TmZZWWpRekcxbVBM?=
 =?utf-8?B?U05zSkpSVVdvejZ3c3o0UGJvcWYrd0J3RUdUT2R0WFpod0xVN2wrMi85WERv?=
 =?utf-8?B?UE0xS0laY1R5WkRpWEpHY2craWpvNnRUQng0bmJZSXF3SjZEM0dhT2NmOWgy?=
 =?utf-8?B?RHk0TEJ3VVVwNURUZ08rclcxc216a3NEWHUrbXVPQnhsWGRMaS9YV0poZ3NG?=
 =?utf-8?B?Q1VCbWpqV3pJT0pKOFRIWXA2eDQ5L1FYYm5OMnRYM2ZvZFRuejhURHBHMkNS?=
 =?utf-8?B?TmkvVW5CVjZlUGgrd0RHNVUyblpCUUZKdzNpc1VCOTZ2ZHhNQ2ZvQXEyOGpu?=
 =?utf-8?B?MDMvRktaSXhoL2x0RnJZb3dUQzk0ekdES1BsQ1FoSUJpNGNhTDlNTW4wZCtF?=
 =?utf-8?B?eklORCthaHhXNWR0akxPaEpoL0pUMU95dG52WWlDWFpJelpHeGk1aWxFaGZR?=
 =?utf-8?B?UHJwbCtVbjVtNDVxUk0reU15VGJNTjZlenZYelJTM1k4S0RSWW5VeE5tdUpn?=
 =?utf-8?B?aHppNVhHa1gzZEk1WjYvb2dHNnIyYjcwWisrWGdwb1ZMUGZEdHZra29IaFp3?=
 =?utf-8?B?OHd6SDhVTlZyQm1QRmRvYldxdlByZ09reEhtUExUYm5SaGEvdE5CQU8rYXZW?=
 =?utf-8?B?ajZqVklBMFpJS01lK1o2RFdFTFhjWkVaVGxHb3hqVXpKRURmRHFsdWRxT0hT?=
 =?utf-8?B?TnBtV2I2VHhZVmtleUJUbGRMYXBhNUJmcXR1UVBiY25wS1VVQTF1Mk1jai9v?=
 =?utf-8?Q?T1Dd4la2zdj44vyBWgMXLbBHG?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d19de2d-fb3c-4fa9-7c5a-08d9d09b0a59
X-MS-Exchange-CrossTenant-AuthSource: MW4PR15MB4410.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2022 22:30:56.4123
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7QwtjVB2t5spcVOKNbOE4PvzusKZX4jlrAfd0jHt0Gilp5tQnElWs0jN9vaaT/7+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3881
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: xoO4oJFTLqQ1JIdpilb7uEO1IqCOs-2E
X-Proofpoint-GUID: xoO4oJFTLqQ1JIdpilb7uEO1IqCOs-2E
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-05_08,2022-01-04_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 suspectscore=0
 spamscore=0 clxscore=1015 adultscore=0 impostorscore=0 bulkscore=0
 lowpriorityscore=0 priorityscore=1501 mlxlogscore=999 mlxscore=0
 phishscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2201050142
X-FB-Internal: deliver
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 1/5/22 5:22 AM, Christian Brauner wrote:
> On Tue, Jan 04, 2022 at 11:09:34AM -0800, Stefan Roesch wrote:
>> This splits off do_getxattr function from the getxattr
>> function. This will allow io_uring to call it from its
>> io worker.
>>
>> Signed-off-by: Stefan Roesch <shr@fb.com>
>> Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
>> ---
>>  fs/internal.h |  7 +++++++
>>  fs/xattr.c    | 32 ++++++++++++++++++++------------
>>  2 files changed, 27 insertions(+), 12 deletions(-)
>>
>> diff --git a/fs/internal.h b/fs/internal.h
>> index 00c98b0cd634..942b2005a2be 100644
>> --- a/fs/internal.h
>> +++ b/fs/internal.h
>> @@ -220,6 +220,13 @@ struct xattr_ctx {
>>  	unsigned int flags;
>>  };
>>  
>> +
>> +ssize_t do_getxattr(struct user_namespace *mnt_userns,
>> +		    struct dentry *d,
>> +		    const char *kname,
>> +		    void __user *value,
>> +		    size_t size);
>> +
>>  int setxattr_copy(const char __user *name, struct xattr_ctx *ctx);
>>  int do_setxattr(struct user_namespace *mnt_userns, struct dentry *dentry,
>>  		struct xattr_ctx *ctx);
>> diff --git a/fs/xattr.c b/fs/xattr.c
>> index dec7ac3e0e89..7f2b805ed56c 100644
>> --- a/fs/xattr.c
>> +++ b/fs/xattr.c
>> @@ -675,19 +675,12 @@ SYSCALL_DEFINE5(fsetxattr, int, fd, const char __user *, name,
>>  /*
>>   * Extended attribute GET operations
>>   */
>> -static ssize_t
>> -getxattr(struct user_namespace *mnt_userns, struct dentry *d,
>> -	 const char __user *name, void __user *value, size_t size)
>> +ssize_t
>> +do_getxattr(struct user_namespace *mnt_userns, struct dentry *d,
>> +	const char *kname, void __user *value, size_t size)
>>  {
>> -	ssize_t error;
>>  	void *kvalue = NULL;
>> -	char kname[XATTR_NAME_MAX + 1];
>> -
>> -	error = strncpy_from_user(kname, name, sizeof(kname));
>> -	if (error == 0 || error == sizeof(kname))
>> -		error = -ERANGE;
>> -	if (error < 0)
>> -		return error;
>> +	ssize_t error;
>>  
>>  	if (size) {
>>  		if (size > XATTR_SIZE_MAX)
>> @@ -711,10 +704,25 @@ getxattr(struct user_namespace *mnt_userns, struct dentry *d,
>>  	}
>>  
>>  	kvfree(kvalue);
>> -
>>  	return error;
>>  }
>>  
>> +static ssize_t
>> +getxattr(struct user_namespace *mnt_userns, struct dentry *d,
>> +	 const char __user *name, void __user *value, size_t size)
>> +{
>> +	ssize_t error;
>> +	struct xattr_name kname;
>> +
>> +	error = strncpy_from_user(kname.name, name, sizeof(kname.name));
>> +	if (error == 0 || error == sizeof(kname.name))
>> +		error = -ERANGE;
>> +	if (error < 0)
>> +		return error;
>> +
>> +	return do_getxattr(mnt_userns, d, kname.name, value, size);
>> +}
> 
> Fwiw, this could have the same signature as do_setxattr(). So sm along
> the lines of (completely untested):
> 

Christian, I made changes similar to the ones you recommended.
However I needed to introduce a union in the xattr_ctx structure.
For the setxattr function we require a const pointer and for getxattr
function we only require a pointer.

In addition it also needs changes in io_uring.c to pass in the context.

v12 has these changes.

> Subject: [PATCH] UNTESTED
> 
> ---
>  fs/internal.h |  8 ++------
>  fs/xattr.c    | 36 ++++++++++++++++++++++--------------
>  2 files changed, 24 insertions(+), 20 deletions(-)
> 
> diff --git a/fs/internal.h b/fs/internal.h
> index 942b2005a2be..d2332496724b 100644
> --- a/fs/internal.h
> +++ b/fs/internal.h
> @@ -220,12 +220,8 @@ struct xattr_ctx {
>  	unsigned int flags;
>  };
>  
> -
> -ssize_t do_getxattr(struct user_namespace *mnt_userns,
> -		    struct dentry *d,
> -		    const char *kname,
> -		    void __user *value,
> -		    size_t size);
> +ssize_t do_getxattr(struct user_namespace *mnt_userns, struct dentry *dentry,
> +		    struct xattr_ctx *ctx);
>  
>  int setxattr_copy(const char __user *name, struct xattr_ctx *ctx);
>  int do_setxattr(struct user_namespace *mnt_userns, struct dentry *dentry,
> diff --git a/fs/xattr.c b/fs/xattr.c
> index 7f2b805ed56c..52bcfe149a9f 100644
> --- a/fs/xattr.c
> +++ b/fs/xattr.c
> @@ -675,35 +675,34 @@ SYSCALL_DEFINE5(fsetxattr, int, fd, const char __user *, name,
>  /*
>   * Extended attribute GET operations
>   */
> -ssize_t
> -do_getxattr(struct user_namespace *mnt_userns, struct dentry *d,
> -	const char *kname, void __user *value, size_t size)
> +ssize_t do_getxattr(struct user_namespace *mnt_userns, struct dentry *dentry,
> +		    struct xattr_ctx *ctx)
> +
>  {
> -	void *kvalue = NULL;
>  	ssize_t error;
> +	char *kname = ctx->kname.name;
>  
> -	if (size) {
> -		if (size > XATTR_SIZE_MAX)
> -			size = XATTR_SIZE_MAX;
> -		kvalue = kvzalloc(size, GFP_KERNEL);
> -		if (!kvalue)
> +	if (ctx->size) {
> +		if (ctx->size > XATTR_SIZE_MAX)
> +			ctx->size = XATTR_SIZE_MAX;
> +		ctx->kvalue = kvzalloc(ctx->size, GFP_KERNEL);
> +		if (!ctx->kvalue)
>  			return -ENOMEM;
>  	}
>  
> -	error = vfs_getxattr(mnt_userns, d, kname, kvalue, size);
> +	error = vfs_getxattr(mnt_userns, d, kname, ctx->kvalue, ctx->size);
>  	if (error > 0) {
>  		if ((strcmp(kname, XATTR_NAME_POSIX_ACL_ACCESS) == 0) ||
>  		    (strcmp(kname, XATTR_NAME_POSIX_ACL_DEFAULT) == 0))
>  			posix_acl_fix_xattr_to_user(mnt_userns, kvalue, error);
> -		if (size && copy_to_user(value, kvalue, error))
> +		if (ctx->size && copy_to_user(value, kvalue, error))
>  			error = -EFAULT;
> -	} else if (error == -ERANGE && size >= XATTR_SIZE_MAX) {
> +	} else if (error == -ERANGE && ctx->size >= XATTR_SIZE_MAX) {
>  		/* The file system tried to returned a value bigger
>  		   than XATTR_SIZE_MAX bytes. Not possible. */
>  		error = -E2BIG;
>  	}
>  
> -	kvfree(kvalue);
>  	return error;
>  }
>  
> @@ -713,6 +712,12 @@ getxattr(struct user_namespace *mnt_userns, struct dentry *d,
>  {
>  	ssize_t error;
>  	struct xattr_name kname;
> +	struct xattr_ctx ctx = {
> +		.value    = value,
> +		.kvalue   = NULL,
> +		.size     = size,
> +		.kname    = &kname,
> +	};
>  
>  	error = strncpy_from_user(kname.name, name, sizeof(kname.name));
>  	if (error == 0 || error == sizeof(kname.name))
> @@ -720,7 +725,10 @@ getxattr(struct user_namespace *mnt_userns, struct dentry *d,
>  	if (error < 0)
>  		return error;
>  
> -	return do_getxattr(mnt_userns, d, kname.name, value, size);
> +	error = do_getxattr(mnt_userns, d, &ctx);
> +
> +	kvfree(ctx.kvalue);
> +	return error;
>  }
>  
>  static ssize_t path_getxattr(const char __user *pathname,
