Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C005537218
	for <lists+io-uring@lfdr.de>; Sun, 29 May 2022 20:07:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230046AbiE2SHg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 29 May 2022 14:07:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230027AbiE2SHe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 29 May 2022 14:07:34 -0400
Received: from pv50p00im-tydg10021701.me.com (pv50p00im-tydg10021701.me.com [17.58.6.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54006663FF
        for <io-uring@vger.kernel.org>; Sun, 29 May 2022 11:07:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com;
        s=1a1hai; t=1653847652;
        bh=n43kbcMaucYZxGZI5lJvca46q8wGqHWtLQqepxKYGJE=;
        h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
        b=Y/+E+K+D/dE8Ex3ZagZ1iDJZdLHQVLKJ76RU0peB5m3HdWx1r1jTP3DX8Oo8faBRA
         qqWEdSqT8JpovT4QtF44lHmHJB1W1r53fFYln61//Wwrka8vf5b5Sl7nGg6LX431m3
         4wckeEn0TIFLhijjSDS17QVoYWw2bI8fqj+Em6YCqTLjDKddn0NUM5oJAKg/om1SgY
         YnzQzf6cVtdXWRvHZzFS5F4x8HuaBQch+1T2U0F2q+HjA1QX5IEwGIncN0M+2MlHtd
         f6XiRL6BwNaj0pwYMe4QiXwpQYxkTSyp6YvFL9aPT1dm2FA919h9NmXWvnklRsUXyY
         xKBAeEZp/cSTg==
Received: from [192.168.31.207] (pv50p00im-dlb-asmtp-mailmevip.me.com [17.56.9.10])
        by pv50p00im-tydg10021701.me.com (Postfix) with ESMTPSA id 2C05F3A0CD2;
        Sun, 29 May 2022 18:07:30 +0000 (UTC)
Message-ID: <2c7bf862-5d94-892c-4026-97e85ba78593@icloud.com>
Date:   Mon, 30 May 2022 02:07:26 +0800
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
 definitions=2022-05-29_04:2022-05-27,2022-05-29 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015 mlxscore=0
 mlxlogscore=581 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-2009150000 definitions=main-2205290105
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
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

Just Theoretically for now, I'll do some tests tomorrow. This is
actually RFC, forgot to change the subject.

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

Sure, if the test number make sense, I'll send v2. I'll test the
hlist_bl list as well(the comment of it says it is much slower than
normal spin_lock, but we may not care the efficiency of poll
cancellation very much?).

> 
> Hmm?
> 

