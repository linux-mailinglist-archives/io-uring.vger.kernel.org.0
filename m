Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E94A02B55CE
	for <lists+io-uring@lfdr.de>; Tue, 17 Nov 2020 01:42:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731382AbgKQAlz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 16 Nov 2020 19:41:55 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:35238 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726523AbgKQAlz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 16 Nov 2020 19:41:55 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AH0eVLp004477;
        Tue, 17 Nov 2020 00:41:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=K3HyZs7xjSYaisAcdpljHpDf3V2J9RpfkU9Ib+kWuok=;
 b=n9vbxNAIUQnZAk/SltN38NzXWXJk6r3Fzo7/aEy5choIX6S0kgTOL6Dn3YfcltjLimQK
 XT4yimiXbJSgpyj7bPBtSkZskYt5PT9LlwyA2TGzLb8r1sZzXOrrh8hQLW7KCcgf0PAa
 kDv0BWy9zgh3xWjcjh99nc+w27eJonn8+LKhSMe4GjyXSPYgDYLFDe7FOTaAU5W2L8xA
 uhPuSiMJbFLkuQ47xFepz7vu0bOOcKwJaA6a4d3l97hAvpA+1aMas9XrdMjPATD23C/h
 3HFkWoXdV0/bxgZgcRPqVEklqtaJhVtgz83BkQjO9Ka6VmuWFb5hgej7qS+789zd1psq uQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 34t4rar531-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 17 Nov 2020 00:41:52 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AH0fYal097308;
        Tue, 17 Nov 2020 00:41:52 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 34uspspp9k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Nov 2020 00:41:51 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0AH0fnQO017941;
        Tue, 17 Nov 2020 00:41:49 GMT
Received: from [10.154.175.238] (/10.154.175.238)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 16 Nov 2020 16:41:49 -0800
Subject: Re: [PATCH 4/8] io_uring: implement fixed buffers registration
 similar to fixed files
To:     Pavel Begunkov <asml.silence@gmail.com>, axboe@kernel.dk
Cc:     io-uring@vger.kernel.org
References: <1605222042-44558-1-git-send-email-bijan.mottahedeh@oracle.com>
 <1605222042-44558-5-git-send-email-bijan.mottahedeh@oracle.com>
 <1e23c177-2be8-4046-c1ea-7ab263132bb5@gmail.com>
 <5ab203e3-8394-2dae-b48c-b30a1e16cc5d@oracle.com>
 <ff99c7df-de77-3663-e607-f547806565c0@gmail.com>
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
Message-ID: <2d035ac6-9f28-1002-df77-a872a8f50750@oracle.com>
Date:   Mon, 16 Nov 2020 16:41:47 -0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <ff99c7df-de77-3663-e607-f547806565c0@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Antivirus: Avast (VPS 201006-2, 10/06/2020), Outbound message
X-Antivirus-Status: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9807 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 bulkscore=0 suspectscore=2 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011170004
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9807 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1015
 malwarescore=0 impostorscore=0 lowpriorityscore=0 priorityscore=1501
 mlxlogscore=999 adultscore=0 phishscore=0 suspectscore=2 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011170004
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


>>>> Apply fixed_rsrc functionality for fixed buffers support.
>>>
>>> I don't get it, requests with fixed files take a ref to a node (see
>>> fixed_file_refs) and put it on free, but I don't see anything similar
>>> here. Did you work around it somehow?
>>
>> No that's my oversight.  I think I wrongfully assumed that io_import_*fixed() would take care of that.
>>
>> Should I basically do something similar to io_file_get()/io_put_file()?
> 
> If done in a dumb way, that'd mean extra pair of percpu get/put
> and +8B in io_kiocb. Frankly, I don't like that idea.
> 
> However, if you don't split paths and make fixed_file_ref_node to
> supports all types of resources at the same time, it should be
> bearable. I.e. register removals of both types to a single node,
> and use ->fixed_file_refs for all request's resources.
> So you don't grow io_kiocb and do maximum one percpu_ref_get/put()
> pair per request.

So something like promoting fixed_file_ref_node to fixed_rsrc_ref_node, 
and ref counting all fixed resources for a given request together?

> 
> I'll send a small patch preparing grounds, because there is actually
> another nasty thing from past that needs to be reworked.

Ok, I'll wait for your patch then.

>> Are you ok with the rest of the patches or should I address anything else?
> 
> io_import_fixed() currently can be called twice, and that would give
> you 2 different bvecs. Hence after removing full quisce io_read()
> retrying short reads will probably be able to partially read into 2
> different buffers. That really have to be fixed.

Will you address that in your patch?

>>>>    static ssize_t io_import_fixed(struct io_kiocb *req, int rw,
>>>>                       struct iov_iter *iter)
>>>>    {
>>>> @@ -2959,10 +2982,15 @@ static ssize_t io_import_fixed(struct io_kiocb *req, int rw,
>>>>        size_t offset;
>>>>        u64 buf_addr;
>>>>    +    /* attempt to use fixed buffers without having provided iovecs */
>>>> +    if (unlikely(!ctx->buf_data))
>>>> +        return -EFAULT;
> 
> I removed it for files,
> because (ctx->buf_data) IFF (ctx->nr_user_bufs == 0),
> so the following ctx->nr_user_bufs check is enough.

Ok, will remove the check for buffers.

