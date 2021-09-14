Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F276340BBDD
	for <lists+io-uring@lfdr.de>; Wed, 15 Sep 2021 01:02:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235116AbhINXDs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Sep 2021 19:03:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234320AbhINXDr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Sep 2021 19:03:47 -0400
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F713C061574
        for <io-uring@vger.kernel.org>; Tue, 14 Sep 2021 16:02:29 -0700 (PDT)
Received: by mail-il1-x133.google.com with SMTP id i13so859789ilm.4
        for <io-uring@vger.kernel.org>; Tue, 14 Sep 2021 16:02:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=NoVn2VRJhuj7hpJhcSDh730crnAh82+NKxOV7442xBc=;
        b=HO/VKd6Lvn3OqPnugBW8F4vpqs+1xV3eKhJYyBgf3xQaVCfkLVkaw7z6NkaK6ZbfeW
         Cr9it+v3U2LppOWC6j1fbgl2yduijKk3VGpR94fvKnT3f87xmDFykfU171HpmsT8tbvL
         4QUZaEIwRuWfstcu2grJhrf5WkfPZB3qYF/Jryo/Ri7LpDYp+Jpj92/o2lXmuCKY4iBV
         5KgL0n4gSQq6hssCTPBXYmgCHpdRxlzarJD2uhr/AGv9HOldUZBGcOymVR0lY0mmh5NS
         IuY8lL3AxWct363aRB+m1x9bP6s1lrUsPglWPQvG5OXBagFh4rM3JBzR/bDiqBdTGQNz
         Nmww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NoVn2VRJhuj7hpJhcSDh730crnAh82+NKxOV7442xBc=;
        b=ZOVKDv5sqhruAkXlgS9jflyc9rCSZogo197FiPoNrQU/NS//WIFFW2GxIDkbu7+jl9
         AEjYk7k40/x4CW+Q8kkbYUV1e6IPVoXaIAdQSoV6leCd7OyO0pFHlGCcYN79tSY+Sldy
         Hc2UkWuV9vbJn3x5lIMUM8q85cBOzCvQcvgcHaxqQxDrfkqVcHgfy1oSUdrkfk5jj+I/
         jyPj9nnnaqSR+aaCdU8JCA4eBFdWmPKtLjr1NgUGsyXtJS2+ruwo8WXfdoyWGAr1WA2b
         otzi8XfKMdIRr7jTuvRWXM6dzqQE09f4Y8yj1Lj+HNmoz+Sd3CiHP/dO+kSy3edU4rjl
         9loA==
X-Gm-Message-State: AOAM530NgWwZ/ysPG566Bl6Xfxs/19ZsRyVoK+XAdVYwp+a5PiQhBNl6
        /YGFCElkPCtJBUPThL6nCbBOUg==
X-Google-Smtp-Source: ABdhPJyDHUrAmTioApPzLjinUFOdWExL5aAdpPfSj5AvIfpL/+FhksJj8SGmNEkfJgCJL+bCxQJM+w==
X-Received: by 2002:a92:c145:: with SMTP id b5mr13350365ilh.203.1631660548798;
        Tue, 14 Sep 2021 16:02:28 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id ay26sm5566674iob.9.2021.09.14.16.02.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Sep 2021 16:02:28 -0700 (PDT)
Subject: Re: [PATCH 2/3] io_uring: use iov_iter state save/restore helpers
From:   Jens Axboe <axboe@kernel.dk>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
References: <20210914141750.261568-1-axboe@kernel.dk>
 <20210914141750.261568-3-axboe@kernel.dk>
 <CAHk-=wh6mGm0b7AnKNRzDO07nrdpCrvHtUQ=afTH6pZ2JiBpeQ@mail.gmail.com>
 <5659d7ba-e198-9df0-c6f8-bd6511bf44a0@kernel.dk>
Message-ID: <5d947a6d-d132-6019-78fb-5e7b1bf88313@kernel.dk>
Date:   Tue, 14 Sep 2021 17:02:27 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <5659d7ba-e198-9df0-c6f8-bd6511bf44a0@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/14/21 1:37 PM, Jens Axboe wrote:
> On 9/14/21 12:45 PM, Linus Torvalds wrote:
>> On Tue, Sep 14, 2021 at 7:18 AM Jens Axboe <axboe@kernel.dk> wrote:
>>>
>>>
>>> +       iov_iter_restore(iter, state);
>>> +
>> ...
>>>                 rw->bytes_done += ret;
>>> +               iov_iter_advance(iter, ret);
>>> +               if (!iov_iter_count(iter))
>>> +                       break;
>>> +               iov_iter_save_state(iter, state);
>>
>> Ok, so now you keep iovb_iter and the state always in sync by just
>> always resetting the iter back and then walking it forward explicitly
>> - and re-saving the state.
>>
>> That seems safe, if potentially unnecessarily expensive.
> 
> Right, it's not ideal if it's a big range of IO, then it'll definitely
> be noticeable. But not too worried about it, at least not for now...
> 
>> I guess re-walking lots of iovec entries is actually very unlikely in
>> practice, so maybe this "stupid brute-force" model is the right one.
> 
> Not sure what the alternative is here. We could do something similar to
> __io_import_fixed() as we're only dealing with iter types where we can
> do that, but probably best left as a later optimization if it's deemed
> necessary.
> 
>> I do find the odd "use __state vs rw->state" to be very confusing,
>> though. Particularly in io_read(), where you do this:
>>
>> +       iov_iter_restore(iter, state);
>> +
>>         ret2 = io_setup_async_rw(req, iovec, inline_vecs, iter, true);
>>         if (ret2)
>>                 return ret2;
>>
>>         iovec = NULL;
>>         rw = req->async_data;
>> -       /* now use our persistent iterator, if we aren't already */
>> -       iter = &rw->iter;
>> +       /* now use our persistent iterator and state, if we aren't already */
>> +       if (iter != &rw->iter) {
>> +               iter = &rw->iter;
>> +               state = &rw->iter_state;
>> +       }
>>
>>         do {
>> -               io_size -= ret;
>>                 rw->bytes_done += ret;
>> +               iov_iter_advance(iter, ret);
>> +               if (!iov_iter_count(iter))
>> +                       break;
>> +               iov_iter_save_state(iter, state);
>>
>>
>> Note how it first does that iov_iter_restore() on iter/state, buit
>> then it *replaces&* the iter/state pointers, and then it does
>> iov_iter_advance() on the replacement ones.
> 
> We restore the iter so it's the same as before we did the read_iter
> call, and then setup a consistent copy of the iov/iter in case we need
> to punt this request for retry. rw->iter should have the same state as
> iter at this point, and since rw->iter is the copy we'll use going
> forward, we're advancing that one in case ret > 0.
> 
> The other case is that no persistent state is needed, and then iter
> remains the same.
> 
> I'll take a second look at this part and see if I can make it a bit more
> straight forward, or at least comment it properly.

I hacked up something that shortens the iter for the initial IO, so we
could more easily test the retry path and the state. It really is a
hack, but the idea was to issue 64K io from fio, and then the initial
attempt would be anywhere from 4K-60K truncated. That forces retry.
I ran this with both 16 segments and 8 segments, verifying that it
hits both the UIO_FASTIOV and alloc path.

I did find one issue with that, see the last hunk in the hack. We
need to increment rw->bytes_done if we don't break, or set ret to
0 if we do. Otherwise that last ret ends up being accounted twice.
But apart from that, it passes data verification runs.


diff --git a/fs/io_uring.c b/fs/io_uring.c
index dc1ff47e3221..484c86252f9d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -744,6 +744,7 @@ enum {
 	REQ_F_NOWAIT_READ_BIT,
 	REQ_F_NOWAIT_WRITE_BIT,
 	REQ_F_ISREG_BIT,
+	REQ_F_TRUNCATED_BIT,
 
 	/* not a real bit, just to check we're not overflowing the space */
 	__REQ_F_LAST_BIT,
@@ -797,6 +798,7 @@ enum {
 	REQ_F_REFCOUNT		= BIT(REQ_F_REFCOUNT_BIT),
 	/* there is a linked timeout that has to be armed */
 	REQ_F_ARM_LTIMEOUT	= BIT(REQ_F_ARM_LTIMEOUT_BIT),
+	REQ_F_TRUNCATED		= BIT(REQ_F_TRUNCATED_BIT),
 };
 
 struct async_poll {
@@ -3454,11 +3456,12 @@ static int io_read(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct iovec inline_vecs[UIO_FASTIOV], *iovec = inline_vecs;
 	struct kiocb *kiocb = &req->rw.kiocb;
-	struct iov_iter __iter, *iter = &__iter;
+	struct iov_iter __i, __iter, *iter = &__iter;
 	struct io_async_rw *rw = req->async_data;
 	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
 	struct iov_iter_state __state, *state;
 	ssize_t ret, ret2;
+	bool do_restore = false;
 
 	if (rw) {
 		iter = &rw->iter;
@@ -3492,8 +3495,25 @@ static int io_read(struct io_kiocb *req, unsigned int issue_flags)
 		return ret;
 	}
 
+	if (!(req->flags & REQ_F_TRUNCATED) && !(iov_iter_count(iter) & 4095)) {
+		int nr_vecs;
+
+		__i = *iter;
+		nr_vecs = 1 + (prandom_u32() % iter->nr_segs);
+		iter->nr_segs = nr_vecs;
+		iter->count = nr_vecs * 8192;
+		req->flags |= REQ_F_TRUNCATED;
+		do_restore = true;
+	}
+
 	ret = io_iter_do_read(req, iter);
 
+	if (ret == -EAGAIN) {
+		req->flags &= ~REQ_F_TRUNCATED;
+		*iter = __i;
+		do_restore = false;
+	}
+
 	if (ret == -EAGAIN || (req->flags & REQ_F_REISSUE)) {
 		req->flags &= ~REQ_F_REISSUE;
 		/* IOPOLL retry should happen for io-wq threads */
@@ -3513,6 +3533,9 @@ static int io_read(struct io_kiocb *req, unsigned int issue_flags)
 
 	iov_iter_restore(iter, state);
 
+	if (do_restore)
+		*iter = __i;
+
 	ret2 = io_setup_async_rw(req, iovec, inline_vecs, iter, true);
 	if (ret2)
 		return ret2;
@@ -3526,10 +3549,10 @@ static int io_read(struct io_kiocb *req, unsigned int issue_flags)
 	}
 
 	do {
-		rw->bytes_done += ret;
 		iov_iter_advance(iter, ret);
 		if (!iov_iter_count(iter))
 			break;
+		rw->bytes_done += ret;
 		iov_iter_save_state(iter, state);
 
 		/* if we can retry, do so with the callbacks armed */

-- 
Jens Axboe

