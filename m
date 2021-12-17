Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6ECE4478ED8
	for <lists+io-uring@lfdr.de>; Fri, 17 Dec 2021 16:02:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237660AbhLQPCG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 17 Dec 2021 10:02:06 -0500
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:35709 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237648AbhLQPCG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 17 Dec 2021 10:02:06 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---0V-vSPBM_1639753323;
Received: from 192.168.31.207(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0V-vSPBM_1639753323)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 17 Dec 2021 23:02:04 +0800
Subject: Re: [PATCH for-next 0/7] reworking io_uring's poll and internal poll
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1639605189.git.asml.silence@gmail.com>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <ca8515c2-649d-21d9-f646-50ed37eabc32@linux.alibaba.com>
Date:   Fri, 17 Dec 2021 23:02:01 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <cover.1639605189.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


ÔÚ 2021/12/16 ÉÏÎç6:08, Pavel Begunkov Ð´µÀ:
> That's mostly a bug fixing set, some of the problems are listed in 5/7.
> The main part is 5/7, which is bulky but at this point it's hard (if
> possible) to do anything without breaking a dozen of things on the
> way, so I consider it necessary evil.
> It also addresses one of two problems brought up by Eric Biggers
> for aio, specifically poll rewait. There is no poll-free support yet.
>
> As a side effect it also changes performance characteristics, adding
> extra atomics but removing io_kiocb referencing, improving rewait, etc.
> There are also drafts on optimising locking needed for hashing, those
> will go later.
Great, seems now we can have per node bit lock for hash list.
>
> Performance measurements is a TODO, but the main goal lies in
> correctness and maintainability.
>
> Pavel Begunkov (7):
>    io_uring: remove double poll on poll update
>    io_uring: refactor poll update
>    io_uring: move common poll bits
>    io_uring: kill poll linking optimisation
>    io_uring: poll rework
>    io_uring: single shot poll removal optimisation
>    io_uring: use completion batching for poll rem/upd
>
>   fs/io_uring.c | 649 ++++++++++++++++++++++----------------------------
>   1 file changed, 287 insertions(+), 362 deletions(-)
>
