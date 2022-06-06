Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A763A53EBB1
	for <lists+io-uring@lfdr.de>; Mon,  6 Jun 2022 19:09:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239029AbiFFNjg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 6 Jun 2022 09:39:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239020AbiFFNjc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 6 Jun 2022 09:39:32 -0400
Received: from pv50p00im-zteg10011401.me.com (pv50p00im-zteg10011401.me.com [17.58.6.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FCB624850B
        for <io-uring@vger.kernel.org>; Mon,  6 Jun 2022 06:39:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com;
        s=1a1hai; t=1654522768;
        bh=A/lEWKxU7EKY3MbUv2B472uL1RE0jJBEq77I4H/HmVg=;
        h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
        b=dV52/3EYKbFoRauG1XJVnRiEPNr7L47bGe9EcPfyW/Q/kMLCTqGNqtIcIPrS18mzy
         HQiyPerFOQVToYNH8Go+1bDgf4zs00vBcUfdyIYTfpBi90nN51nzR4FN1yoT3XNl8O
         ykZOoWOQGCYOmgfOUw0hN+7/rQY42ewkJZJ4gi+ylEI/8AgG+qcCYoTfOZETjW9/BU
         GPCfYKR/VB9UnjX6Y2TlnRsxPjF635BGzuL+K/sZzDIIXqDxCNyThda8xHW7RpMyqF
         Lyyoh5iTz2u20te7JxQEVzbT0c5VvVZGj/ZqDR+tJFHO5LYlKfINn+BpW3pAzbsz52
         K2VCptOkNBqPA==
Received: from [10.97.63.88] (pv50p00im-dlb-asmtp-mailmevip.me.com [17.56.9.10])
        by pv50p00im-zteg10011401.me.com (Postfix) with ESMTPSA id 1D1B4DC048F;
        Mon,  6 Jun 2022 13:39:26 +0000 (UTC)
Message-ID: <0ef367d3-8727-6cc7-d3f6-65476342e31b@icloud.com>
Date:   Mon, 6 Jun 2022 21:39:22 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH v2 0/3] cancel_hash per entry lock
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
References: <20220606065716.270879-1-haoxu.linux@icloud.com>
 <da7624f0-ed08-eb94-621e-ed3e0751dfed@icloud.com>
 <0316d33e-4d72-7afb-ba9a-127e3427a228@gmail.com>
From:   Hao Xu <haoxu.linux@icloud.com>
In-Reply-To: <0316d33e-4d72-7afb-ba9a-127e3427a228@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.874
 definitions=2022-06-06_04:2022-06-02,2022-06-06 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015 mlxscore=0
 mlxlogscore=976 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-2009150000 definitions=main-2206060062
X-Spam-Status: No, score=-5.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/6/22 20:02, Pavel Begunkov wrote:
> On 6/6/22 08:06, Hao Xu wrote:
>> On 6/6/22 14:57, Hao Xu wrote:
>>> From: Hao Xu <howeyxu@tencent.com>
>>>
>>> Make per entry lock for cancel_hash array, this reduces usage of
>>> completion_lock and contension between cancel_hash entries.
>>>
>>> v1->v2:
>>>   - Add per entry lock for poll/apoll task work code which was missed
>>>     in v1
>>>   - add an member in io_kiocb to track req's indice in cancel_hash
>>
>> Tried to test it with many poll_add IOSQQE_ASYNC requests but turned out
>> that there is little conpletion_lock contention, so no visible change in
>> data. But I still think this may be good for cancel_hash access in some
>> real cases where completion lock matters.
> 
> Conceptually I don't mind it, but let me ask in what
> circumstances you expect it to make a difference? And

I suppose there are cases where a bunch of users trying to access
cancel_hash[] at the same time when people use multiple threads to
submit sqes or they use IOSQE_ASYNC. And these io-workers or task works
run parallel on different CPUs.

> what can we do to get favourable numbers? For instance,
> how many CPUs io-wq was using?

It is not easy to construct manually since it is related with task
scheduling, like if we just issue many IOSQE_ASYNC polls in an
idle machine with many CPUs, there won't be much contention because of
different thread start time(thus they access cancel_hash at different
time
> 

