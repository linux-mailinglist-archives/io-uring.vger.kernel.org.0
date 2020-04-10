Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 932851A4A26
	for <lists+io-uring@lfdr.de>; Fri, 10 Apr 2020 21:09:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726594AbgDJTJR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Apr 2020 15:09:17 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:48572 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726142AbgDJTJR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 10 Apr 2020 15:09:17 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03AJ9DLa080650;
        Fri, 10 Apr 2020 19:09:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=zaD+PY2opnGxCXkYqTrIT1H6aVUB2KOEmDgaizzH7u0=;
 b=B+FLh7SMGqqxYZxNAy2rAq7IKlTTCVkXVzsRTGtj5jP4obrcUj5jze76xX1kaPA1g9Qb
 ShRMd/EM/2why6APXtOgDaO5Zra0HP0WPbpEmmzMejfX/o/bJN1RDKiXNwm955tPGLGK
 0CuEEk3Dni81pEKt5CL2PZidcHXio8NewPh8R2N3kh+QtZGvzuALZbNQM/fWggwTfMEv
 /ncXT/l6dx/pG+BU/ugkoQsL68GiLYkqg+BQZvMJgClMirgFKItF86QMEVm0mBqQsJkD
 jDO4Qd9hUa6hXNqsZLFBo9aEfisOE8lznnB3Xknc1puJzvlszbSEomgiAf+KNwQgGY2K GA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 309gw4kkyq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Apr 2020 19:09:14 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03AJ6xCH045685;
        Fri, 10 Apr 2020 19:09:13 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 309ag8d3rj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Apr 2020 19:09:13 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03AJ9Do1004940;
        Fri, 10 Apr 2020 19:09:13 GMT
Received: from [10.154.104.74] (/10.154.104.74)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 10 Apr 2020 12:09:12 -0700
Subject: Re: [RFC 1/1] io_uring: preserve work->mm since actual work
 processing may need it
To:     Pavel Begunkov <asml.silence@gmail.com>, axboe@kernel.dk
Cc:     io-uring@vger.kernel.org
References: <1586469817-59280-1-git-send-email-bijan.mottahedeh@oracle.com>
 <1586469817-59280-2-git-send-email-bijan.mottahedeh@oracle.com>
 <f38056cf-b240-7494-d23b-c663867451cf@gmail.com>
 <465d7f4f-e0a4-9518-7b0c-fe908e317720@oracle.com>
 <dbcf7351-aba2-a64e-ecd9-26666b30469f@gmail.com>
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
Message-ID: <e8ca3475-5372-3f99-ff95-c383d3599552@oracle.com>
Date:   Fri, 10 Apr 2020 12:09:09 -0700
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <dbcf7351-aba2-a64e-ecd9-26666b30469f@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Antivirus: Avast (VPS 200409-0, 04/09/2020), Outbound message
X-Antivirus-Status: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9587 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 malwarescore=0
 phishscore=0 mlxscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004100142
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9587 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 bulkscore=0
 phishscore=0 lowpriorityscore=0 impostorscore=0 clxscore=1015
 suspectscore=0 malwarescore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004100142
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/10/2020 10:51 AM, Pavel Begunkov wrote:
> On 10/04/2020 19:54, Bijan Mottahedeh wrote:
>>> As I see, this down_read() from the trace is
>>> down_read(&current->mm->mmap_sem), where current->mm is set by use_mm()
>>> just several lines above your change. So, what do you mean by passing? I
>>> don't see do_madvise() __explicitly__ accepting mm as an argument.
>> I think the sequence is:
>>
>> io_madvise()
>> -> do_madvise(NULL, req->work.mm, ma->addr, ma->len, ma->advice)
>>                      ^^^^^^^^^^^^
>>     -> down_read(&mm->mmap_sem)
>>
>> I added an assert in do_madvise() for a NULL mm value and hit it running the test.
>>
>>> What tree do you use? Extra patches on top?
>> I'm using next-20200409 with no patches.
> I see, it came from 676a179 ("mm: pass task and mm to do_madvise"), which isn't
> in Jen's tree.
>
> I don't think your patch will do, because it changes mm refcounting with extra
> mmdrop() in io_req_work_drop_env(). That's assuming it worked well before.
>
> Better fix then is to make it ```do_madvise(NULL, current->mm, ...)```
> as it actually was at some point in the mentioned patch (v5).
>
Ok. Jens had suggested to use req->work.mm in the patch comments so 
let's just get him to confirm:

"I think we want to use req->work.mm here - it'll be the same as
current->mm at this point, but it makes it clear that we're using a
grabbed mm."

