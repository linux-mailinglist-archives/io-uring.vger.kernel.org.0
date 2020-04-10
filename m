Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF2931A48B1
	for <lists+io-uring@lfdr.de>; Fri, 10 Apr 2020 18:54:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726177AbgDJQyw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Apr 2020 12:54:52 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:46442 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726173AbgDJQyw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 10 Apr 2020 12:54:52 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03AGhDiK010326;
        Fri, 10 Apr 2020 16:54:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=X+7KUl6caBIB17/TA4xmSZdxVON73KzznPVMZ48Xgts=;
 b=s6na+EsECdFznTxkifkuG8AUAsDKZEMA3Fc78sX7z0DAptAOGGFjnXdl6BnorYCaqX67
 Zv5C1cXmr/I6d1L9lynG6ark6CaoOZWft0QcI11z+6+F/wVREroBe5c/JYEHHftYjdd6
 P8D1cCkLguvvdH3EYjWTlK8AraAhD/Vru0Kx3qHICxcFNkCTtmI/Qpql8OfQsMVT0VND
 hZvd46feI3Xrt3VP/5ZgZRxgkX/b3lTsUv45tamnLsvfmwZy9t2jZnePy+Nl5uxWxd97
 um1A04WHzKYTPIAm/g+bwWXY5VYU473nfxYSX9lzUySnT7ihwmunFv5Ml7wVVczinZC9 YA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 309gw4k4q3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Apr 2020 16:54:49 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03AGhUL1088947;
        Fri, 10 Apr 2020 16:54:49 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 3091m7wt50-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Apr 2020 16:54:49 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03AGslcr026601;
        Fri, 10 Apr 2020 16:54:48 GMT
Received: from [10.154.104.74] (/10.154.104.74)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 10 Apr 2020 09:54:47 -0700
Subject: Re: [RFC 1/1] io_uring: preserve work->mm since actual work
 processing may need it
To:     Pavel Begunkov <asml.silence@gmail.com>, axboe@kernel.dk
Cc:     io-uring@vger.kernel.org
References: <1586469817-59280-1-git-send-email-bijan.mottahedeh@oracle.com>
 <1586469817-59280-2-git-send-email-bijan.mottahedeh@oracle.com>
 <f38056cf-b240-7494-d23b-c663867451cf@gmail.com>
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
Message-ID: <465d7f4f-e0a4-9518-7b0c-fe908e317720@oracle.com>
Date:   Fri, 10 Apr 2020 09:54:44 -0700
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <f38056cf-b240-7494-d23b-c663867451cf@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Antivirus: Avast (VPS 200409-0, 04/09/2020), Outbound message
X-Antivirus-Status: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9587 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 phishscore=0 spamscore=0 adultscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004100139
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9587 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 bulkscore=0
 phishscore=0 lowpriorityscore=0 impostorscore=0 clxscore=1011
 suspectscore=0 malwarescore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004100139
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


> As I see, this down_read() from the trace is
> down_read(&current->mm->mmap_sem), where current->mm is set by use_mm()
> just several lines above your change. So, what do you mean by passing? I
> don't see do_madvise() __explicitly__ accepting mm as an argument.

I think the sequence is:

io_madvise()
-> do_madvise(NULL, req->work.mm, ma->addr, ma->len, ma->advice)
                     ^^^^^^^^^^^^
    -> down_read(&mm->mmap_sem)

I added an assert in do_madvise() for a NULL mm value and hit it running 
the test.

> What tree do you use? Extra patches on top?

I'm using next-20200409 with no patches.
