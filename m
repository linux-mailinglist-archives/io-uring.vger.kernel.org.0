Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFDFC527854
	for <lists+io-uring@lfdr.de>; Sun, 15 May 2022 17:08:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237342AbiEOPH6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 15 May 2022 11:07:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236488AbiEOPH5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 15 May 2022 11:07:57 -0400
Received: from pv50p00im-zteg10011501.me.com (pv50p00im-zteg10011501.me.com [17.58.6.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FA463123F
        for <io-uring@vger.kernel.org>; Sun, 15 May 2022 08:07:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com;
        s=1a1hai; t=1652627276;
        bh=7kfnBr7oduNV3oGO9elY3+KmpdYoC+cs7xv4N7gYU10=;
        h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
        b=rTv73p6r1+OOpkF7W6Juc8638PlGiMTCYJ6a478qAeNX+n8SWQyp8JmN/LpwH2I7a
         WAX20pNUI+zCUy4tYiqjjLnlsyYQCxPQM2zIZc4AuXnAcyV9bRG3ujugW05ibN4aJV
         LsB04Wz0Cf2ooP5VKxt9Y7HpvZvQCT53zPoey5tgbAh8zsidHBHPhZ0MocZLvNAqXU
         IfIrNhiovEa5HdEPfsHarVVZdLsZ5LCmYgH90DzWpqSmjOyQb8U3KkeKta/zyL4iHC
         3BHZqCuMk3X524YqDGEOWE1kRg90Vy2O8QoYj3eWO9Bb3hEc49JYKvjIUjWUsAqY+b
         oJW5b7P+0FQLg==
Received: from [192.168.31.208] (pv50p00im-dlb-asmtp-mailmevip.me.com [17.56.9.10])
        by pv50p00im-zteg10011501.me.com (Postfix) with ESMTPSA id 2A05B2E00B5;
        Sun, 15 May 2022 15:07:53 +0000 (UTC)
Message-ID: <d025270d-aa1d-899b-4188-7ac627bbbdc5@icloud.com>
Date:   Sun, 15 May 2022 23:07:49 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH] io_uring: avoid iowq again trap
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
References: <f168b4f24181942f3614dd8ff648221736f572e6.1652433740.git.asml.silence@gmail.com>
 <5b4e6d37-f25d-099a-81a7-9125eb958251@icloud.com>
 <05310b9c-bfe1-3c75-f3e2-eb9d87925db0@gmail.com>
From:   Hao Xu <haoxu.linux@icloud.com>
In-Reply-To: <05310b9c-bfe1-3c75-f3e2-eb9d87925db0@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-05-15_08:2022-05-13,2022-05-15 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015 mlxscore=0
 mlxlogscore=628 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-2009150000 definitions=main-2205150083
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/15/22 22:21, Pavel Begunkov wrote:
> On 5/15/22 08:31, Hao Xu wrote:
>> On 5/13/22 18:24, Pavel Begunkov wrote:
>>> If an opcode handler semi-reliably returns -EAGAIN, io_wq_submit_work()
>>
>> Hi Pavel,
>> When would it return -EAGAIN in non-IOPOLL mode?
> 
> I didn't see it in the wild but stumbled upon while preparing some
> future patches. I hope it's not a real issue, but it's better to not
> leave a way for some driver/etc. to abuse it.
> 
> 
Gotcha, thanks.
