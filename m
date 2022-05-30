Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4BD45380B5
	for <lists+io-uring@lfdr.de>; Mon, 30 May 2022 16:24:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238280AbiE3Nsd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 30 May 2022 09:48:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239079AbiE3Nqm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 30 May 2022 09:46:42 -0400
Received: from pv50p00im-zteg10011501.me.com (pv50p00im-zteg10011501.me.com [17.58.6.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39CB8A30A0
        for <io-uring@vger.kernel.org>; Mon, 30 May 2022 06:34:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com;
        s=1a1hai; t=1653917631;
        bh=stG/LnUVSksEUbzQ4j6UyAlo79AIzMkAkymqeIUAoCE=;
        h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
        b=0Dfbe9wwD9aevpV7py6iKzIbSJRcD5j3iHl7mV9OdtWRExahWcMpn2Z7dCVVaBRvf
         zg56KxuXGP4y80FcODpCifhkQmQs2820EFENr9RNrnZkG5iaNATmpxQ6+mxqo29zgB
         m6yVwgj0YzLDNJkbgAD6mtV3aEDoIsBd0OLn2kIs0VloynwO6AllJYSGfrnvPZ/5EE
         gLHpqeA2z9zD0sW0Cazpx5ZalH2Q/7JScNhhrDQNnEv22+GN1FIOT0KOZeiGk/qvFn
         ul0TwV+63m6mFgMIR5V1Zt+srXqwIQwGp+88g3nrL40/2CedII0NyFXFft4VWNmmM0
         Ybx7gApvbEoYg==
Received: from [192.168.31.207] (pv50p00im-dlb-asmtp-mailmevip.me.com [17.56.9.10])
        by pv50p00im-zteg10011501.me.com (Postfix) with ESMTPSA id 75FE32E0492;
        Mon, 30 May 2022 13:33:49 +0000 (UTC)
Message-ID: <e1245070-2365-4a2e-f717-ecc27ebeccb1@icloud.com>
Date:   Mon, 30 May 2022 21:33:34 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 2/2] io_uring: switch cancel_hash to use per list spinlock
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>
References: <20220529162000.32489-1-haoxu.linux@icloud.com>
 <20220529162000.32489-3-haoxu.linux@icloud.com>
 <37c50986-8a47-5eb4-d416-cbbfd54497b0@kernel.dk>
From:   Hao Xu <haoxu.linux@icloud.com>
In-Reply-To: <37c50986-8a47-5eb4-d416-cbbfd54497b0@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-30_05:2022-05-30,2022-05-30 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015 mlxscore=0
 mlxlogscore=466 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-2009150000 definitions=main-2205300071
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/30/22 00:25, Jens Axboe wrote:
> On 5/29/22 10:20 AM, Hao Xu wrote:
>> From: Hao Xu <howeyxu@tencent.com>
>>
>> From: Hao Xu <howeyxu@tencent.com>
>>
>> Use per list lock for cancel_hash, this removes some completion lock
>> invocation and remove contension between different cancel_hash entries
> 
> Interesting, do you have any numbers on this?
> 
> Also, I'd make a hash bucket struct:
> 
> struct io_hash_bucket {
> 	spinlock_t lock;
> 	struct hlist_head list;
> };
> 
> rather than two separate structs, that'll have nicer memory locality too
> and should further improve it. Could be done as a prep patch with the
> old locking in place, making the end patch doing the per-bucket lock
> simpler as well.
> 
> Hmm?
> 

I've done a v2 here, also a test which issues async poll densely to
make high frequency cancel_hash[] visits. But I won't have a real box
with big number of cpu processors which is suitable for testing until
tomorrow, so I'd test it tomorrow.

https://github.com/HowHsu/linux/commits/for-5.20/io_uring_hash_lock

https://github.com/HowHsu/liburing/commit/b9fb4d20a5dfe7c7bd62fe36c37aea3b261d4499
