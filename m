Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F81160F211
	for <lists+io-uring@lfdr.de>; Thu, 27 Oct 2022 10:18:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234581AbiJ0ISo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 27 Oct 2022 04:18:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234616AbiJ0ISn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 27 Oct 2022 04:18:43 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B788140E77
        for <io-uring@vger.kernel.org>; Thu, 27 Oct 2022 01:18:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=From:Cc:To:Date:Message-ID;
        bh=5pRIr/CEGrd301dx2fv2rhY+NkoU1ynkrYBBkgsUcnc=; b=Tv7uruQnsf5NKGOOUJuZGUEMrp
        UlmLqA8MMo1MpRIPaLZyhLc+7nmKIs1vmRLF0clev1jWaiVOkTxv25/4izS0XDGmR7gJZ5+JHOwoX
        p818QEtPyJ1DFaYF/K9qZcCXUHZ7aAVH8OZ3HZp6lnsS0MeHiJHiE9OO4YxTytQLjUSyXsYNLNhQk
        RYByFUDujJiRljinOO/g7oVLUjqevSi5Loz8is4cvSbuOGNiQi0R2JAkkAgOcb2xhAAnUMu5mPYwg
        m21ukcScARCH2yC8LXO/h2nKHxDLpOnjWfvfoJk4CGuS8WL6VBlrBzzsF7ZV3YLPzZwVIzUIEN2fe
        dwR1fRlhEIak49URG0M4jMz1qeyJHSAAlcQvddSDvjq1oNoNYGu0pqYgioq4MF3D7TqXYCR5v1d+/
        W3FNoKqF5ZjiDQ6pICYE3BQrViV/RD0GTH9ZYbp9nkJFVu+w0zXsDPatjtWcWSQv3oNhYzWyJV4/H
        3ccjFStsjSSq79bbp9L+f5Wh;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1ony62-0060BK-Qw; Thu, 27 Oct 2022 08:18:38 +0000
Message-ID: <3a437318-3c94-4e5e-1cb4-c6108625d165@samba.org>
Date:   Thu, 27 Oct 2022 10:18:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: Problems replacing epoll with io_uring in tevent
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Samba Technical <samba-technical@lists.samba.org>
References: <c01f72ac-b2f1-0b1c-6757-26769ee071e2@samba.org>
 <949fdb8e-bd12-03dc-05c6-c972f26ec0ec@samba.org>
 <270f3b9a-8fa6-68bf-7c57-277f107167c9@kernel.dk>
 <063b631b-19a7-fb24-23e7-65cbcc141554@gmail.com>
Content-Language: en-US
From:   Stefan Metzmacher <metze@samba.org>
In-Reply-To: <063b631b-19a7-fb24-23e7-65cbcc141554@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Pavel,

>>> I'm currently trying to prototype for an IORING_POLL_CANCEL_ON_CLOSE
>>> flag that can be passed to POLL_ADD. With that we'll register
>>> the request in &req->file->f_uring_poll (similar to the file->f_ep list for epoll)
>>> Then we only get a real reference to the file during the call to
>>> vfs_poll() otherwise we drop the fget/fput reference and rely on
>>> an io_uring_poll_release_file() (similar to eventpoll_release_file())
>>> to cancel our registered poll request.
>>
>> Yes, this is a bit tricky as we hold the file ref across the operation. I'd
>> be interested in seeing your approach to this, and also how it would
>> interact with registered files...
> 
> Not sure I mentioned before but shutdown(2) / IORING_OP_SHUTDOWN
> usually helps. Is there anything keeping you from doing that?

The thing is that the tevent backend has no control over what
callers do and there's no way to audit all high level samba code,
everything needs to work exactly as it does with the poll and epoll backends.

Only high level code that actively/directly uses io_uring features could cope
with io_uring specific behavior.

As a side note I recently work on bug related to half closed tcp sockets,
see https://bugzilla.samba.org/show_bug.cgi?id=15202
It seems that shutdown() (even with SHUT_RDWR) behaves differently
for tcp sockets compared to a (final) close().

> Do you only poll sockets or pipes as well?

Anything that's supported by poll needs to work.

>>> The key flag is IORING_SETUP_DEFER_TASKRUN. On a different system than above
>>> I'm getting the following numbers:
>>> - epoll:                                    Got 114450.16 pipe events/sec
>>> - poll:                                     Got 105872.52 pipe events/sec
>>> - samba_io_uring_ev-without-defer_taskrun': Got  95564.22 pipe events/sec
>>> - samba_io_uring_ev-with-defer_taskrun':    Got 122853.85 pipe events/sec
>>
>> Any chance you can do a run with just IORING_SETUP_COOP_TASKRUN set? I'm
>> curious how big of an impact the IPI elimination is, where it slots in
>> compared to the defer taskrun and the default settings.
> 
> And if it doesn't take too much time to test, it would also be interesting
> to see if there is any impact from IORING_SETUP_SINGLE_ISSUER alone,
> without TASKRUN flags.

See the other mail to Jens.

metze

