Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C6542F3E08
	for <lists+io-uring@lfdr.de>; Wed, 13 Jan 2021 01:44:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728581AbhALVuy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 12 Jan 2021 16:50:54 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:57616 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727213AbhALVux (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 12 Jan 2021 16:50:53 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10CLZFVq041738;
        Tue, 12 Jan 2021 21:50:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=DKRIcgU48TXFPdgP0FSyH7WxarDQVbz0C4SCi4Ts/aw=;
 b=JlsvXRjoB6y6mpgFM7s6kAGiJhbKBS9r8sUAdfANu/rt9RH2cC8/ZAXqWgF3FczU7bEM
 C8rBzGLnAX/ks9URATTzCDyTcsAbNK76fzooNtpA/FWl0BEBSFZBN4pyWDGNBZ9w0Hef
 k1jnXKXQcZR9KfO295B/5zgRdYBZfDT1bkCSpCGefnfqYyU/zA+IERr5sDZhtWWxzZ2z
 YIImXhZG99gA1/vpkR0hTkc5t5e99JjYD5M2jfJ2zhKV+P0ZHG4Bvz2CxfIGJGmMvUm6
 B7rDSyxPo4skgkGLdNrejna5oFlBDrDXyf9yVtogfBYYUfnXcndTZUJ8kFzRsoKAUTe8 9w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 360kvk0hrx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Jan 2021 21:50:10 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10CLZaaB191029;
        Tue, 12 Jan 2021 21:50:10 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 360ke77fu4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Jan 2021 21:50:10 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 10CLo9M0020545;
        Tue, 12 Jan 2021 21:50:09 GMT
Received: from [10.154.150.141] (/10.154.150.141)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 12 Jan 2021 13:50:09 -0800
Subject: Re: [PATCH v2 13/13] io_uring: support buffer registration sharing
To:     Pavel Begunkov <asml.silence@gmail.com>, axboe@kernel.dk,
        io-uring@vger.kernel.org
References: <1607379352-68109-1-git-send-email-bijan.mottahedeh@oracle.com>
 <1607379352-68109-14-git-send-email-bijan.mottahedeh@oracle.com>
 <ff17d576-27eb-9008-d858-e1ebb7c93dad@gmail.com>
 <2070b1b5-2931-7782-305f-c578b3b24567@oracle.com>
 <074644d5-f299-3b70-9d86-bf4ed59d9674@oracle.com>
 <4c9d62d8-efc5-1cd6-e73c-9efd3b694950@gmail.com>
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
Message-ID: <892d3884-8bae-5912-d86f-2641a1854e61@oracle.com>
Date:   Tue, 12 Jan 2021 13:50:09 -0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <4c9d62d8-efc5-1cd6-e73c-9efd3b694950@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Antivirus: Avast (VPS 210101-4, 01/01/2021), Outbound message
X-Antivirus-Status: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9862 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 mlxscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101120128
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9862 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 lowpriorityscore=0 bulkscore=0 priorityscore=1501 malwarescore=0
 clxscore=1015 impostorscore=0 spamscore=0 mlxscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101120128
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/10/2021 9:19 PM, Pavel Begunkov wrote:
>> The intended use case for buffer registration is:
>>
>> - a group of processes attach a shmem segment
>> - one process registers the buffers in the shmem segment and shares it
>> - other processes attach that registration
>>
>> For this case, it seems that there is really no need to wait for the attached processes to get rid of the their references since the shmem segment (and thus the registered buffers) will persist anyway until the last attached process goes away.  So the last unregister could quiesce all references and get rid of the shared buf_data.
>>
>> I'm not sure how useful the non-shmem use case would be anyway.
>>
>> Would it makes sense to restrict the scope of this feature?
> 
> I have to say I like that generic resources thing, makes it easier to
> extend in the future. e.g. pre-allocating dma mappings, structs like
> bios, etc.
> 
> I didn't think it through properly but it also looks that with refnodes
> it would be much easier to do sharing in the end, if not possible
> vs impossible.
> 

Do you think that an the unkillable deadlock is still an issue with your 
changes in the v5 version of io_rsrc_ref_quiesce() I just sent out?

We're calling wait_for_completion_interruptible() so I assume it should 
be interruptible.  I think we'll then skip unmapping the buffers though, 
so it's not clear to me what the right solution is for the below 
scenario you raised in the first place:

task1: uring1 = create()
task2: uring2 = create()
task1: uring3 = create(share=uring2);
task2: uring4 = create(share=uring1);

task1: io_sqe_buffers_unregister(uring1)
task2: io_sqe_buffers_unregister(uring2)
