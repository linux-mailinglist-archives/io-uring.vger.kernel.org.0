Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AA25482028
	for <lists+io-uring@lfdr.de>; Thu, 30 Dec 2021 21:02:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236053AbhL3UCE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Dec 2021 15:02:04 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:4926 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234114AbhL3UCB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Dec 2021 15:02:01 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1BUJfrcB008032;
        Thu, 30 Dec 2021 12:01:58 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=mKLrEqjrSSpF+rGM9vClWo96xxfDAs7ueZ/z5nIwtJA=;
 b=T65iDAEyDbqWTP8DmIkV1ZlvIANXPEEzPhL20+u/mzpQHmYdq3VYj5lgrvBFsvPQfzH4
 jrrlFVZ5vUPZ6HtiIPew5NlVnBlsszxJINdZRpYRGVHxfWNvh0lgiql7nmDc4LpIyvIv
 yYop8xEhZA3IgJov9uLrpbSPb5aPnUYxk64= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3d9hubspk3-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 30 Dec 2021 12:01:58 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 30 Dec 2021 12:01:55 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KDI1lk+qGCRlvVe9J4QWDC15k4v6gbyYoy6MjNQcR09FzAs7vy2dUf3O8yY6vkIEiFuCNdiRMqzx2WEpHqPFaNZZy5GsiSKWixYP3IYl9TOzJk7tRfzvycKVQ/kQsvzVjrqRQIPxFU4vjTeHhOGKYvJfMfSW6zdxmVtet+9yZFQee0cX1slVyUph/R8z3Oe/dBX10zFQeLDxBE7BSLkLuNKMTFRcuEoJikIFemI/oFtAx6PF23+Q9YiThu6k8vIpTMrnNaP+vivnBvUbKLqK/qo5VHRwc4OFkv+TkEfwQRc4p4V7sJQ88A1pUwtGIb6nilIs56qVgrPxByBH7sSYBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mKLrEqjrSSpF+rGM9vClWo96xxfDAs7ueZ/z5nIwtJA=;
 b=X/e0hxzqbSnL1F+tNI1TTTFNgVTgFTTb7Kr3liOLFJUGnWJWIOp4G42mWG3AY6XW84romIReL86Fo6HOb7kaDl4xcyUnvWq8AjTOGhHW7Uc0mNsOfla1GhDNKO3iSl1MnlrRQ3hdJODCJam67FGE7b4o3cIXLPuqZ4q00lawGfKUTQYnlZVRkgR/PkPi6CBWxP2M+pqzbNQ1PlEJOzhSVmhUg0fP2odhotvdaisPpys4PAnWh5EgoMlV3UYrFS3kKOYTTDTtM2fuiUyAtxmwLiKqn7vAvJC0Rt4NUq6wtV1v6acOm3Biw1t/AX9J66ojGR/AagDmZR/rJEZDXuin0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from PH0PR15MB4413.namprd15.prod.outlook.com (2603:10b6:510:9f::16)
 by PH0PR15MB4877.namprd15.prod.outlook.com (2603:10b6:510:c0::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.19; Thu, 30 Dec
 2021 20:01:54 +0000
Received: from PH0PR15MB4413.namprd15.prod.outlook.com
 ([fe80::31b6:7571:66da:5cab]) by PH0PR15MB4413.namprd15.prod.outlook.com
 ([fe80::31b6:7571:66da:5cab%7]) with mapi id 15.20.4823.023; Thu, 30 Dec 2021
 20:01:54 +0000
Message-ID: <8ca47c75-1ec0-a76f-8902-e363f7b272e2@fb.com>
Date:   Thu, 30 Dec 2021 12:01:51 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.1
Subject: Re: [PATCH v10 5/5] io_uring: add fgetxattr and getxattr support
Content-Language: en-US
To:     Al Viro <viro@zeniv.linux.org.uk>
CC:     <io-uring@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <kernel-team@fb.com>, <torvalds@linux-foundation.org>,
        <christian.brauner@ubuntu.com>
References: <20211229203002.4110839-1-shr@fb.com>
 <20211229203002.4110839-6-shr@fb.com>
 <Yc0OT3C+pSqLOZym@zeniv-ca.linux.org.uk>
From:   Stefan Roesch <shr@fb.com>
In-Reply-To: <Yc0OT3C+pSqLOZym@zeniv-ca.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0196.namprd03.prod.outlook.com
 (2603:10b6:303:b8::21) To PH0PR15MB4413.namprd15.prod.outlook.com
 (2603:10b6:510:9f::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a4738d64-1c99-4d98-2937-08d9cbcf39f6
X-MS-TrafficTypeDiagnostic: PH0PR15MB4877:EE_
X-Microsoft-Antispam-PRVS: <PH0PR15MB48778D8E43BF34141BAB7285D8459@PH0PR15MB4877.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:245;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G5pRrdqcRIkIFyplCo3pnuECXr/f9weCic7WYgoN3mCbHZuxK/+ynyYmN4ooS2ZRkZ6CEEhvCvUk77a22PXxTIVRht++eBPITsHkmbwByrMkP7EjjyxDVxxc0DOeHQqPN2DoG+cQKpypymZE7dsFAqnQMjh/drv4dpz3Tzc7RjMysv0JuxSqQoVEe1YsDRVmos9k7spe6EuX1opeIKoFRPW/Gmy0ixO/NIIW5C2M444sC6A24EjUnkpwTC2HDW5CsxwMEd4uFAyNsDzTEBh/rM6AxCHm/CfIVBOHqO8r1RGrPZ/c/UQsLj6G3OgWDazU0sZ+Qzu3Tgmz3vK//drnD6dKBD6z+bBwTN+P0tnMJUQjqpL42FrubnxsgGLXurvqmdDVyuzd9KEEgHL8BuE9L9YDJWRMCWVkALlPBEgVujxNu3ZdPtXCgPwTKMEB8/V4eNHsAFCjne5xydRZrNGH7GWK5zL3viTvOGlZIn/cwLFLod0hdpwRmtKXXDF76r9Knz+oXVdBzNgTGXU8TPiD8RKkHwZQRH5bHZYdJpmqBQzT5T5yVeaYt8W/+i9clRpxR0pFftG9Ygnm9rah6azMDrTCQHp4tl+/KeAEQjiIgXHSE7N60tf42COSZhcdkeVxqC5OZwFdByJk10dPQgXtCxqKIsP4PGnzqgzvxxcABh0kkbZxbMQxw2Ae6zK+rJW/noMTGubkJSiy+LIFlt28Hu64WnTVGJSktqnLMYvzBFpEty/Sc0PSZCrOIQZKTHfYQMsCM7RiMo6Y7PPl1byqLg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR15MB4413.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(31696002)(86362001)(66476007)(508600001)(53546011)(2616005)(6486002)(83380400001)(4326008)(66946007)(6666004)(186003)(36756003)(5660300002)(6506007)(8676002)(66556008)(316002)(31686004)(6916009)(6512007)(8936002)(38100700002)(2906002)(31884004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?L1RZOHQxZXVqYVBNNGg1TUhnRkZDeDUzNXgrdWYybEFKYlNESTc4eVVGWnRo?=
 =?utf-8?B?ODd1V1JIKysxajFVb1FGNjNFcUhjM0xOTStlenpva1VKMS9yelZPbjVwU1U5?=
 =?utf-8?B?bWQrd0hPb2lCalRnL2Y5YlJUcVRxWWRieTZHMjBGTmlrNGdNcWtKcU5MMlFv?=
 =?utf-8?B?aHJlem9qSE1KWlZZWVkvcGRxcktieEsxdG9JTmpsT1lnTjhMUENrMGVvVDRh?=
 =?utf-8?B?SkFIQWxJWmR4b1A0Nm5YSzRDVDdya3JPUUZhL0g3bzlWaVMzMEZkbWYyZWZY?=
 =?utf-8?B?c0RrMjRHRDlKcGtIczBJUjNRVnpDR3pnbW5FbFozalY2TmllSkUyVzhqUUJL?=
 =?utf-8?B?LzUwKzAwTWlHSXV0MHpBTXBnTkpYNEVZZHZOMHhNY0RzWnFBWklrVyswWUZI?=
 =?utf-8?B?L1pVMlpFTXlBYUtvOFBWQm1BUHZ1L3l3NGQzbldJdE51L3QrZlI0NTNFbUR1?=
 =?utf-8?B?WWlNS2xrOUxQd1B1Y2dkMGVRTjRDRWNES25CRy9NUzZPeXN5WjhnQXMrLzFP?=
 =?utf-8?B?aTVsRmNpTHZ5QU9CTTFta3NsWmFMK1NSN1hYYm5YQ3pmZkhGN0VpN0ZqbWRw?=
 =?utf-8?B?ZFJTY2w1bGdYcy9SQ1JycTFTUXBUa2RqTVBEa3hZQWhYS00zTEo1cUluR24x?=
 =?utf-8?B?K0tiOVJMd3RzTzl2ZEZiV1ZoaVVWcXE4R2liUk9xcW8vOHdHbVdYZlFZcklG?=
 =?utf-8?B?RzRUQTMza0d1UjVHY3BmSnRPaHNkOUNmbmxGdUVVTmw3clp3cVdwNHB6RHJY?=
 =?utf-8?B?VWZ6N3VnNDhzZ1NHTXNHeS93TlBBSWEyRFEvMDJTalZSYUNrdkJkS0pIVVJl?=
 =?utf-8?B?VDZHVUtXcGhUVFJYcnowcmNPWDE0YW0xNEhqRDNVK2g0RzVObXQva2wvcVo2?=
 =?utf-8?B?dkd0VjFGM3NuNzdEUEpycDQ2Tk5iNTk1ZDBLbDIwa1ZNTzNXV1FiSlkvV01H?=
 =?utf-8?B?eUNWcDBOWmU4TWRhOVhnVDdKMmpPa0NsWEdJWWlEalRGSzVrWk5YSGNxNGdl?=
 =?utf-8?B?Z1JSN0JLOTd2dkpMaGcwZ3N1cmVTZU9EeGtZRGtyUkpOWWYxQis0dmdFK2RK?=
 =?utf-8?B?ZURqaHRTNmpPNjlIODdwa0daK1hReTc2MVJWUjc1QzlmbnJmNDRPK25FV2hY?=
 =?utf-8?B?aUJCQWZBQ3pTaGt3VXFGU2VYTW1YRFgvZVVRQjNQQXFpSjlrc29uVVNtWS91?=
 =?utf-8?B?eklTUFRLU3Q1MzJtQnZlLzg2aFRmQk5IQzBHY1dDeHNPcGhKYzIzb0FGTUpv?=
 =?utf-8?B?Rm5KY09HTXNKcVgrUVJmNHhKVjg4bmNzWDVBSnRpVGhVa3podnl4ODhTZUZB?=
 =?utf-8?B?cFY3WXdTM3VISUM1MmdqVkl2a2JrV2N5clpyWUJJME1kNDlWR1FzT0ZiUzlG?=
 =?utf-8?B?TXFwTFNDL1F1cmFPbkVYMmFzYloxcVpJZDd2VGlxMEc5NFMrTzExTXNUTi9D?=
 =?utf-8?B?enJBYlkrei9abkR1QVF2dHh3NzBHVXRJZ3FZNVNqa0x1OE9NOGZqeHk0N0VP?=
 =?utf-8?B?YkZrV1cxVnZ2aXZvZVBONjdheXVNNWFMSjBla1NlVkFWWGZXSitPVlZTem9G?=
 =?utf-8?B?WVFrb0pDZHRqQnlVWmtZeGt2aE85ck9ob3QrMXJIbC9wQmpTQmQ4MW5IMU4w?=
 =?utf-8?B?cEg4aDM1VjZQcXJSQUZhWkp5Q2Jwa2wrbUZKd2t6LzJzWlNyYjNTRExoTVAr?=
 =?utf-8?B?dHRxNnBWN1VacmZ2K3dOd2lDOEZDL2p0ZkxVMUZ5OUl3NmJLZzF4ZndRdTgr?=
 =?utf-8?B?QzlLTHVwZmsvdmFCTUU2aDJPRUc1VlZGQzM2STNVVWlmZGJkckFHN204VEla?=
 =?utf-8?B?MGkyOUhsNndvdkFmZXJSOEFRM0djdDFMNUk3QlpIZTU4QXZtODV6YitHVVhu?=
 =?utf-8?B?aEcxT1ZsOVc4L2xIU0RYcThKMEVOVjZlR21JemdlblZSUUthMkZqZC9yZlNG?=
 =?utf-8?B?bjdnQzRBY2c1NnQxNWM5TEUxeDJMaWRvUjdoeTd2T2FmOHkxaUhUK2F4SE9y?=
 =?utf-8?B?WjM2aWc5Um5WVVVTcHhQbnNMVWFFTHBTdnpTY2N0WkRpMmdHbG5TRURPSzV1?=
 =?utf-8?B?Q1hJMlczSGxWaUNQSTUwTzF1ZmRuZEN1QUZPQkQwcFU0WGt2Z0ZOVEFqSngw?=
 =?utf-8?Q?j7dUCO9Uo7H1MhuUcLZ9LUtEE?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a4738d64-1c99-4d98-2937-08d9cbcf39f6
X-MS-Exchange-CrossTenant-AuthSource: PH0PR15MB4413.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Dec 2021 20:01:54.2300
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vnIEuUpfrltgWdpxOXW22Q/EaHrQwjLZjDf5A8jH2DN0TiDfv4hZQ9nxfydtyO9R
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR15MB4877
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: 8F0SzTQNr8t0Wd6JmyQl8x-OeQu4FsIC
X-Proofpoint-GUID: 8F0SzTQNr8t0Wd6JmyQl8x-OeQu4FsIC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-30_08,2021-12-30_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 bulkscore=0
 lowpriorityscore=0 mlxlogscore=999 spamscore=0 phishscore=0 mlxscore=0
 suspectscore=0 priorityscore=1501 adultscore=0 impostorscore=0
 clxscore=1015 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2112300114
X-FB-Internal: deliver
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 12/29/21 5:41 PM, Al Viro wrote:
> On Wed, Dec 29, 2021 at 12:30:02PM -0800, Stefan Roesch wrote:
> 
>> +static int io_getxattr(struct io_kiocb *req, unsigned int issue_flags)
>> +{
>> +	struct io_xattr *ix = &req->xattr;
>> +	unsigned int lookup_flags = LOOKUP_FOLLOW;
>> +	struct path path;
>> +	int ret;
>> +
>> +	if (issue_flags & IO_URING_F_NONBLOCK)
>> +		return -EAGAIN;
>> +
>> +retry:
>> +	ret = do_user_path_at_empty(AT_FDCWD, ix->filename, lookup_flags, &path);
>> +	if (!ret) {
>> +		ret = do_getxattr(mnt_user_ns(path.mnt),
>> +				path.dentry,
>> +				ix->ctx.kname->name,
>> +				(void __user *)ix->ctx.value,
>> +				ix->ctx.size);
>> +
>> +		path_put(&path);
>> +		if (retry_estale(ret, lookup_flags)) {
>> +			lookup_flags |= LOOKUP_REVAL;
>> +			goto retry;
>> +		}
>> +	}
>> +	putname(ix->filename);
>> +
>> +	__io_getxattr_finish(req, ret);
>> +	return 0;
>> +}
> 
> Looking at that one...  Is there any reason to have that loop (from retry: to
> putname() call) outside of fs/xattr.c?  Come to think of that, why bother
> polluting your struct io_xattr with ->filename?
> 
> Note, BTW, that we already have this:
> static ssize_t path_getxattr(const char __user *pathname,
>                              const char __user *name, void __user *value,
> 			     size_t size, unsigned int lookup_flags)
> {
> 	struct path path;
> 	ssize_t error;
> retry:
> 	error = user_path_at(AT_FDCWD, pathname, lookup_flags, &path);
> 	if (error)
> 		return error;
> 	error = getxattr(mnt_user_ns(path.mnt), path.dentry, name, value, size);
> 	path_put(&path);
> 	if (retry_estale(error, lookup_flags)) {
> 		lookup_flags |= LOOKUP_REVAL;
> 		goto retry;
> 	}
> 	return error;
> }
> in there.  The only potential benefit here would be to avoid repeated getname
> in case of having hit -ESTALE and going to repeat the entire fucking pathwalk
> with maximal paranoia, asking the server(s) involved to revalidate on every
> step, etc.
> 
> If we end up going there, who the hell *cares* about the costs of less than
> a page worth of copy_from_user()?  We are already on a very slow path as it
> is, so what's the point?

I think Jens already answered this why we capture the parameters during the prep
step. From Jens:

"

- The prep of it, this happens inline from the system call where the
  request, or requests, are submitted. The prep phase should ensure that
  argument structs are stable. Hence a caller can prep a request and
  have memory on stack, as long as it submits before it becomes invalid.
  An example of that are iovecs for readv/writev. The caller does not
  need to have them stable for the duration of the request, just across
  submit. That's the io_${cmd}_prep() helpers.

- The execution of it. May be separate from prep and from an async
  worker. Where the lower layers don't support a nonblocking attempt,
  they are always done async. The statx stuff is an example of that.

Hence prep needs to copy from userland on the prep side always for the
statx family, as execution will happen out-of-line from the submission.

"

Otherwise we need to copy the path value the user passed in, storing a filename struct
seems to be the better choice.
