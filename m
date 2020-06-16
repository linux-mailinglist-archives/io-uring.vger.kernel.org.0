Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33DCD1FBD15
	for <lists+io-uring@lfdr.de>; Tue, 16 Jun 2020 19:34:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728271AbgFPRds (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 16 Jun 2020 13:33:48 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:40518 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729148AbgFPRds (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 16 Jun 2020 13:33:48 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05GHX42F013160;
        Tue, 16 Jun 2020 17:33:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=4STBUEmGtGL/d+DtHMlq0SQPPVJbzmE/HTPmxZGSrV8=;
 b=bPRCCs17aCAg/xfHIfttNYGLGq1jwbSLCMoE6QDBVuJZJkqCkHMHCMm9/23PpcalM0gy
 ktkJ7SqrIxr1KXNoXfbsi8UfvivDFfUs+mX7E5KXBV1a9G+slSMcHm2QR9qSNeG31qjQ
 wvONgScq3JzB35haqdcYWhRUlpp0cvOwZdSfj58SzDFw7opOhpGsSA0PAol0R3s0KKhQ
 WdNj2ubf7Ew4jszEvDVQ+11fJK7XxFDCYw0/y9PVDjOjXEzdhtODpnaq3O8jw4dX4ghP
 8LOeymfi8byUv//ru5pqYKzTqdHZAbLfHF5wjuC0p69zPin/v93GJl+HNCPRWxtzEKBa fA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 31p6e8060t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 16 Jun 2020 17:33:44 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05GHN637195698;
        Tue, 16 Jun 2020 17:31:44 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 31p6s7j1nq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Jun 2020 17:31:44 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 05GHVhrh015777;
        Tue, 16 Jun 2020 17:31:43 GMT
Received: from [10.154.162.1] (/10.154.162.1)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 16 Jun 2020 10:31:43 -0700
Subject: Re: Does need memory barrier to synchronize req->result with
 req->iopoll_completed
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>
References: <dc28ff4f-37cf-03cb-039e-f93fefef8b96@linux.alibaba.com>
 <fdbe0ddc-7fa8-f7df-2e49-bfcea00673d0@kernel.dk>
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
Message-ID: <0c0ec588-9fc7-1f97-7e52-80d368f8146d@oracle.com>
Date:   Tue, 16 Jun 2020 10:31:40 -0700
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <fdbe0ddc-7fa8-f7df-2e49-bfcea00673d0@kernel.dk>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Antivirus: Avast (VPS 200616-6, 06/16/2020), Outbound message
X-Antivirus-Status: Clean
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9654 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 suspectscore=2 mlxlogscore=999 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006160123
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9654 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0
 impostorscore=0 bulkscore=0 clxscore=1015 malwarescore=0 suspectscore=2
 mlxscore=0 phishscore=0 mlxlogscore=999 lowpriorityscore=0
 cotscore=-2147483648 priorityscore=1501 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006160124
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/14/2020 8:36 AM, Jens Axboe wrote:
> On 6/14/20 8:10 AM, Xiaoguang Wang wrote:
>> hi,
>>
>> I have taken some further thoughts about previous IPOLL race fix patch,
>> if io_complete_rw_iopoll() is called in interrupt context, "req->result = res"
>> and "WRITE_ONCE(req->iopoll_completed, 1);" are independent store operations.
>> So in io_do_iopoll(), if iopoll_completed is ture, can we make sure that
>> req->result has already been perceived by the cpu executing io_do_iopoll()?
> Good point, I think if we do something like the below, we should be
> totally safe against an IRQ completion. Since we batch the completions,
> we can get by with just a single smp_rmb() on the completion side.
>
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 155f3d830ddb..74c2a4709b63 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -1736,6 +1736,9 @@ static void io_iopoll_complete(struct io_ring_ctx *ctx, unsigned int *nr_events,
>   	struct req_batch rb;
>   	struct io_kiocb *req;
>   
> +	/* order with ->result store in io_complete_rw_iopoll() */
> +	smp_rmb();
> +
>   	rb.to_free = rb.need_iter = 0;
>   	while (!list_empty(done)) {
>   		int cflags = 0;
> @@ -1976,6 +1979,8 @@ static void io_complete_rw_iopoll(struct kiocb *kiocb, long res, long res2)
>   	if (res != req->result)
>   		req_set_fail_links(req);
>   	req->result = res;
> +	/* order with io_poll_complete() checking ->result */
> +	smp_wmb();
>   	if (res != -EAGAIN)
>   		WRITE_ONCE(req->iopoll_completed, 1);
>   }
>
I'm just trying to understand how the above smp_rmb() works. When 
io_complete_rw_iopoll() is called, all requests on the done list have 
already had ->iopoll_completed checked, and given the smp_wmb(),we know 
the two writes were ordered, so what does the smp_rmb() achieve here 
exactly? What ordering does it perform?

Thanks.

--bijan

