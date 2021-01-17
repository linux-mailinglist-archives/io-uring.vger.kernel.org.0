Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AA112F9505
	for <lists+io-uring@lfdr.de>; Sun, 17 Jan 2021 21:09:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730199AbhAQUJX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 17 Jan 2021 15:09:23 -0500
Received: from a4-2.smtp-out.eu-west-1.amazonses.com ([54.240.4.2]:32839 "EHLO
        a4-2.smtp-out.eu-west-1.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730202AbhAQUJF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 17 Jan 2021 15:09:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=pqvuhxtqt36lwjpmqkszlz7wxaih4qwj; d=urbackup.org; t=1610914061;
        h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:In-Reply-To:Content-Type:Content-Transfer-Encoding;
        bh=S7chfnnq95JkpyqJwRv8nVXrqmK8ye1gx3x1Qmvprxk=;
        b=fO/MHoTZRvLeaikjP+qC2SZ4V9GxhRrqTvgbFFr15QiE3OhWaqdiFoTy97rdUO3c
        j6Qi/XiEo5MJz4Va8k69d0cJTx5n0ODWd8OJ+7T7gtqNFQ73WEOlER0vzC3YVCxz8yE
        phidDP11rEv42qpTZlQBFRt5wbh8TJKnmta2MjG8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=shh3fegwg5fppqsuzphvschd53n6ihuv; d=amazonses.com; t=1610914061;
        h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:In-Reply-To:Content-Type:Content-Transfer-Encoding:Feedback-ID;
        bh=S7chfnnq95JkpyqJwRv8nVXrqmK8ye1gx3x1Qmvprxk=;
        b=PPPvbC+ZRv0YQzu3GG265WDGkWHxW4YB+Bo55aQD/9tCiM2LWMU5a2ltHrcUCfL7
        Q+KNMVcAWkk8qwSyD8Z9fLNkg+KD0q6+kkN46/x2FV8QOkduPFdJJvyiSzAcL1SuZsc
        SiRTodAlAgFfAC82Ww+tmOfvii1H03Bdd2+6UZMM=
Subject: Re: Fixed buffers have out-dated content
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>
Cc:     Martin Raiber <martin@urbackup.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
References: <01020176e45e6c4d-c15dc1e2-6a6a-407c-a32d-24be51a1b3f8-000000@eu-west-1.amazonses.com>
 <8ba549a0-7724-a42f-bd11-3605ef0bd034@kernel.dk>
 <01020176e8159fa5-3f556133-fda7-451b-af78-94c712df611e-000000@eu-west-1.amazonses.com>
 <b56ed553-096c-b51a-49e3-da4e8eda8d43@gmail.com>
 <01020176ed350725-cc3c8fa7-7771-46c9-8fa9-af433acb2453-000000@eu-west-1.amazonses.com>
 <0102017702e086ca-cdb34993-86ad-4ec6-bea5-b6a5ad055a62-000000@eu-west-1.amazonses.com>
 <61566b44-fe88-03b0-fd94-70acfc82c093@kernel.dk>
 <CAHk-=wh3Agdy3h+rsx5HTOWt6dS-jN9THBqNhk=mWG4KnCK0tw@mail.gmail.com>
 <CAHk-=wiGEFZf-+YXcUVDj_mutwG6qWZzKUKZ-5yQ5UWgLGrBNQ@mail.gmail.com>
From:   Martin Raiber <martin@urbackup.org>
Message-ID: <0102017711f5dc95-8153416f-4641-4495-9103-82c2744e0d69-000000@eu-west-1.amazonses.com>
Date:   Sun, 17 Jan 2021 20:07:41 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <CAHk-=wiGEFZf-+YXcUVDj_mutwG6qWZzKUKZ-5yQ5UWgLGrBNQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-SES-Outgoing: 2021.01.17-54.240.4.2
Feedback-ID: 1.eu-west-1.zKMZH6MF2g3oUhhjaE2f3oQ8IBjABPbvixQzV8APwT0=:AmazonSES
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 17.01.2021 00:34 Linus Torvalds wrote:
> On Sat, Jan 16, 2021 at 3:05 PM Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>> I'll go think about this.
>>
>> Martin, since you can apparently trigger the problem easily, hopefully
>> you're willing to try a couple of patches?
> Hmm. It might end up being as simple as the attached patch.
>
> I'm not super-happy with this situation (that whole nasty security
> issue had some horrible cascading problems), and this only really
> fixes _pinned_ pages.
>
> In particular, somebody doing a plain get_user_pages() for writing can
> still hit issues (admittedly that's true in general, but the vm
> changes made it much more obviously true).
>
> But for the case of io_uring buffers, this looks like the obvious simple fix.
>
> I don't have a load to test this with, so I'll come back to ask Martin
> to do so...
>
>                   Linus

Thanks! With the patch (skip swapping pinned pages) the problem doesn't 
occur anymore, so it seems to fix it.

