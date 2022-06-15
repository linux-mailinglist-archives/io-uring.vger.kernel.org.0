Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64EEF54CC92
	for <lists+io-uring@lfdr.de>; Wed, 15 Jun 2022 17:20:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349227AbiFOPUF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Jun 2022 11:20:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244854AbiFOPUE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Jun 2022 11:20:04 -0400
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE40C24956
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 08:20:02 -0700 (PDT)
Message-ID: <163d86d7-e9f3-0935-3589-453591bb2570@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1655306401;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+lBisP1CQpi+oVDL/IKt83hP3XIdA3WAnPkfnaRLSGc=;
        b=akFL8HQiFIN0XB/EDglKGEs7RDRbBOtpEy3fuLzz6b0tRPEeWPAu2qlEyXXsuPbn8xKA5S
        7YyL4IPU0w5+Xy4La6rOoXt1lggkAO0uqvXFtFHFc0JeR92dpwMJy2rdhgcGIRUopB+ltQ
        mafwW+ZZh6sYVnsnssjCTyBGBI5eQfQ=
Date:   Wed, 15 Jun 2022 23:19:47 +0800
MIME-Version: 1.0
Subject: Re: [PATCH for-next v2 25/25] io_uring: mutex locked poll hashing
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
References: <cover.1655213915.git.asml.silence@gmail.com>
 <b3250f21371e91e43ff488bc695240630cb21667.1655213915.git.asml.silence@gmail.com>
 <419df2b2-8b62-15f8-fc26-251b1337a59a@linux.dev>
 <bff22d5f-239e-d388-d44e-a26fb69af38d@gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Hao Xu <hao.xu@linux.dev>
In-Reply-To: <bff22d5f-239e-d388-d44e-a26fb69af38d@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/15/22 21:55, Pavel Begunkov wrote:
> On 6/15/22 13:53, Hao Xu wrote:
>> On 6/14/22 22:37, Pavel Begunkov wrote:
>>> Currently we do two extra spin lock/unlock pairs to add a poll/apoll
>>> request to the cancellation hash table and remove it from there.
>>>
>>> On the submission side we often already hold ->uring_lock and tw
>>> completion is likely to hold it as well. Add a second cancellation hash
>>> table protected by ->uring_lock. In concerns for latency because of a
>>> need to have the mutex locked on the completion side, use the new table
>>> only in following cases:
>>>
>>> 1) IORING_SETUP_SINGLE_ISSUER: only one task grabs uring_lock, so there
>>>     is no contention and so the main tw hander will always end up
>>>     grabbing it before calling into callbacks.
>>
>> This statement seems not true, the io-worker may grab the uring lock,
>> and that's why the [1] place I marked below is needed, right? Or do I
>> miss something?
> 
> Ok, "almost always ends up ...". The thing is io-wq is discouraged
> taking the lock and if it does can do only briefly and without any
> blocking/waiting. So yeah, it might be not taken at [1] but it's
> rather unlikely.
> 

Agree, What I meant to say is the code at [1] deserve a comment for it
since I have a feeling that new developers into io_uring may struggle to
figure it out with commit message saying like this.
