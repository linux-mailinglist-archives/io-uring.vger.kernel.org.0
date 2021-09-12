Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 369ED407F27
	for <lists+io-uring@lfdr.de>; Sun, 12 Sep 2021 20:14:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232959AbhILSQB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 12 Sep 2021 14:16:01 -0400
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:34984 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230106AbhILSQB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 12 Sep 2021 14:16:01 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0Uo4gEkU_1631470485;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0Uo4gEkU_1631470485)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 13 Sep 2021 02:14:45 +0800
Subject: Re: [PATCH 3/3] io_uring: don't spinlock when not posting CQEs
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1631367587.git.asml.silence@gmail.com>
 <3a5f0436099b84f71fdc8c9bd9f21842581feaf9.1631367587.git.asml.silence@gmail.com>
 <1cc2816e-bf18-fbb9-b5ed-e8786babc4fc@linux.alibaba.com>
 <ddf1be22-4fce-8e50-851f-d898d1dcc502@gmail.com>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <37347a03-5475-dd2e-ab58-65adb1aad04f@linux.alibaba.com>
Date:   Mon, 13 Sep 2021 02:14:45 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <ddf1be22-4fce-8e50-851f-d898d1dcc502@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/9/12 上午5:10, Pavel Begunkov 写道:
> On 9/11/21 9:12 PM, Hao Xu wrote:
>> 在 2021/9/11 下午9:52, Pavel Begunkov 写道:
>>> When no of queued for the batch completion requests need to post an CQE,
>>> see IOSQE_CQE_SKIP_SUCCESS, avoid grabbing ->completion_lock and other
>>> commit/post.
> 
> It does what it says -- skips CQE posting on success. On failure it'd
> still generate a completion. I was thinking about IOSQE_SKIP_CQE, but
> I think it may be confusing.
I think IOSQE_CQE_SKIP_SUCCESS is clear..but we should do
req->flags & REQ_F_CQE_SKIP, rather than req->flags & IOSQE_CQE_SKIP_SUCCESS
> 
> Any other options to make it more clear?
> 

