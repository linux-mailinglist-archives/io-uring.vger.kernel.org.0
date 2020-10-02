Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEF3A281B5C
	for <lists+io-uring@lfdr.de>; Fri,  2 Oct 2020 21:10:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387692AbgJBTKn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 2 Oct 2020 15:10:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726215AbgJBTKn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 2 Oct 2020 15:10:43 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 333B3C0613D0;
        Fri,  2 Oct 2020 12:10:43 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1601665840;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eJktxSNhWJM/BgeMFlAldxUGknWBDzKoGcVcbfFdWEU=;
        b=UO32msFoUsnCGcCU/nloBL/pLMHuNB23dbBu2ZIdqhsgz9R9A47l+q5WEy5Wb5i5jVkG/t
        tyIp+WV6ug3qNcoGQqihonvjKn1XL3j/7WK9/0n3+yxMQuRwcYTuDBzCwBOO8kmM+7Q9Vp
        KNkeJos/TCphe8Lx/DxqHll/LW0UdwymfyzgzcCVpfAZJRzMl3ZY+k+mzVjr0txX7lHzsM
        gPPQl2Ohob8X6I7oCEmllAvLmo1CYaURiXlcF8Y9HmO1ceRGr6Ku27AV68XPLGjj/KsMgs
        2yGmUh8SVcU8aEM07fXjecPGvRlQpwG7ki2y87i6EEjuRGmJhwe882dwOEH4fA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1601665840;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eJktxSNhWJM/BgeMFlAldxUGknWBDzKoGcVcbfFdWEU=;
        b=kyckBGqyHRgAFJ5nX3wgecTnJO8ACh6+1GODnqeRu6rUz0IBTSZYtE6DSkEdH4UCm/ne+m
        8CJrryjS68tFs6Cg==
To:     Jens Axboe <axboe@kernel.dk>, Oleg Nesterov <oleg@redhat.com>
Cc:     linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        peterz@infradead.org
Subject: Re: [PATCH 3/3] task_work: use TIF_TASKWORK if available
In-Reply-To: <4c9dbcc4-cae7-c7ad-8066-31d49239750a@kernel.dk>
References: <20201001194208.1153522-1-axboe@kernel.dk> <20201001194208.1153522-4-axboe@kernel.dk> <20201002151415.GA29066@redhat.com> <871rigejb8.fsf@nanos.tec.linutronix.de> <4c9dbcc4-cae7-c7ad-8066-31d49239750a@kernel.dk>
Date:   Fri, 02 Oct 2020 21:10:40 +0200
Message-ID: <87y2kocukv.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Oct 02 2020 at 09:52, Jens Axboe wrote:
> On 10/2/20 9:31 AM, Thomas Gleixner wrote:
>>> This way task_work_run() doesn't need to clear TIF_NOTIFY_SIGNAL and it can
>>> have more users.
>> 
>> I think it's fundamentaly wrong that we have several places and several
>> flags which handle task_work_run() instead of having exactly one place
>> and one flag.
>
> I don't disagree with that. I know it's not happening in this series, but
> if we to the TIF_NOTIFY_SIGNAL route and get all archs supporting that,
> then we can kill the signal and notify resume part of running task_work.
> And that leaves us with exactly one place that runs it.
>
> So we can potentially improve the current situation in that regard.

I'll think about it over the weekend.
