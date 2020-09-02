Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A20025AF41
	for <lists+io-uring@lfdr.de>; Wed,  2 Sep 2020 17:36:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728367AbgIBPgI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 2 Sep 2020 11:36:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726900AbgIBPgD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 2 Sep 2020 11:36:03 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F2B6C061244
        for <io-uring@vger.kernel.org>; Wed,  2 Sep 2020 08:36:03 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id g128so6193238iof.11
        for <io-uring@vger.kernel.org>; Wed, 02 Sep 2020 08:36:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5SiJkDTvrg0EBLh7O7bOPg9ws9kqrz6xmC+X1mWvzig=;
        b=OyCdiKNCszpAAtjujWbJHkpjr4k6aECTr9xvLdhH+ckDRV6WOsbxYrX71Hnej7fsZO
         WbipY/qU/iikgwJTyjRjr1l5eKw6+JJ9OKt8s13r1S1NzPfjBc4aYbOhPF2Hz+VHx8p/
         rbh++JE8MPRTNF951AbFMhcKNBEFrZxOfItEof1MVC4tpIs+YBRIXcPSzUio/AOepdEX
         Ugg8dC4QEOh1x+OR9LkyzD71dzX8xPuhR1XuN1x3oFb7hkFoEtPI8W7fS3oTaOcz8b2M
         XaMRErdFhUCpeOeKOgx2wkJVhTs+qQ/zwugHKXTE1g7Sv4SPE4yfjPtIYxengPTv7kvb
         kX+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5SiJkDTvrg0EBLh7O7bOPg9ws9kqrz6xmC+X1mWvzig=;
        b=qNY/aNzmpx1ZIjGAEffE8fTr7aDvUdx9WaGyQauMs2i54uzZQl0CW1WFeV8e0T67yu
         3mx6gXGsFtLvQS32VtkvP9neCcb7LHmixJI8KdLHOUBnZ+PqfKiJ69FWhDAtzJa5VyW7
         datqxmRO2g0Te8lIF6RtAfdTnxr9w78BUTWIR6KYCPHQ4gEwmecOC1LZjZNyrhT0SdEb
         EpXpjz7YKKBAZd5fXPPDmHowevcscj0MRlxUUqlD0FzOiCao0/QvroaV2Y267oE0XtCV
         sXUMKGLbdGRVP4VlA8rG2qZz6x4iCcPdFYMKQufncjkS3kE1qRmB3zvjlLUv7dYrh3Rc
         twwQ==
X-Gm-Message-State: AOAM533Kqw8ccDS9BM9WlN7NvqNqYuLGuyZm7rr4YYhVGKLTzhvEExOQ
        J1PJ0Ry9/NccEKUOgkoJVR9JDw==
X-Google-Smtp-Source: ABdhPJyG76bxlkVe82XllCwsOH4lR3rFcwdLhkHwCRZIZJezLg6pef5t4gOMomeRNo71uKgClVjoqg==
X-Received: by 2002:a02:c919:: with SMTP id t25mr3889777jao.38.1599060955560;
        Wed, 02 Sep 2020 08:35:55 -0700 (PDT)
Received: from [192.168.1.57] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id t3sm2315723ilq.56.2020.09.02.08.35.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Sep 2020 08:35:55 -0700 (PDT)
Subject: Re: IORING_OP_READ and O_NONBLOCK behaviour
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Norman Maurer <norman.maurer@googlemail.com>,
        io-uring@vger.kernel.org
Cc:     Josef <josef.grieb@gmail.com>
References: <28EF4A51-2B6D-4857-A9E8-2E28E530EFA6@googlemail.com>
 <05c1b12c-5fb8-c7f5-c678-65249da5a6b1@kernel.dk>
 <72c31af6-2c85-4105-65fb-87a860a65a78@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <06ee57db-7fcc-140a-a9de-e6e67a68b56e@kernel.dk>
Date:   Wed, 2 Sep 2020 09:35:54 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <72c31af6-2c85-4105-65fb-87a860a65a78@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/2/20 9:26 AM, Pavel Begunkov wrote:
> On 02/09/2020 17:45, Jens Axboe wrote:
>> On 9/2/20 4:09 AM, Norman Maurer wrote:
>>> Hi there,
>>>
>>> We are currently working on integrating io_uring into netty and found
>>> some “suprising” behaviour which seems like a bug to me.
>>>
>>> When a socket is marked as non blocking (accepted with O_NONBLOCK flag
>>> set) and there is no data to be read IORING_OP_READ should complete
>>> directly with EAGAIN or EWOULDBLOCK. This is not the case and it
>>> basically blocks forever until there is some data to read. Is this
>>> expected ?
>>>
>>> This seems to be somehow related to a bug that was fixed for
>>> IO_URING_ACCEPT with non blocking sockets:
>>>
>>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?h=v5.8&id=e697deed834de15d2322d0619d51893022c90ea2
>>
>> I agree with you that this is a bug, in general it's useful (and
>> expected) that we'd return -EAGAIN for that case. I'll take a look.
>>
> 
> That's I mentioned that doing retries for nonblock requests in
> io_wq_submit_work() doesn't look consistent. I think killing it
> off may help.

Right, we should not retry those _in general_, the exception is regular
files or block devices to handle IOPOLL retry where we do need it. The
below is what I came up with for this one. Might not hurt to make this
more explicit for 5.10.


commit c78e0f02c3861b5b176b2f79552677b3604deb76
Author: Jens Axboe <axboe@kernel.dk>
Date:   Wed Sep 2 09:30:31 2020 -0600

    io_uring: no read-retry on -EAGAIN error and O_NONBLOCK marked file
    
    Actually two things that need fixing up here:
    
    - The io_rw_reissue() -EAGAIN retry is explicit to block devices and
      regular files, so don't ever attempt to do that on other types of
      files.
    
    - If we hit -EAGAIN on a nonblock marked file, don't arm poll handler for
      it. It should just complete with -EAGAIN.
    
    Cc: stable@vger.kernel.org
    Reported-by: Norman Maurer <norman.maurer@googlemail.com>
    Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index b1ccd7072d93..dc27cd5b8ad6 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2300,8 +2300,11 @@ static bool io_resubmit_prep(struct io_kiocb *req, int error)
 static bool io_rw_reissue(struct io_kiocb *req, long res)
 {
 #ifdef CONFIG_BLOCK
+	umode_t mode = file_inode(req->file)->i_mode;
 	int ret;
 
+	if (!S_ISBLK(mode) && !S_ISREG(mode))
+		return false;
 	if ((res != -EAGAIN && res != -EOPNOTSUPP) || io_wq_current_is_worker())
 		return false;
 
@@ -3146,6 +3149,9 @@ static int io_read(struct io_kiocb *req, bool force_nonblock,
 		/* IOPOLL retry should happen for io-wq threads */
 		if (!force_nonblock && !(req->ctx->flags & IORING_SETUP_IOPOLL))
 			goto done;
+		/* no retry on NONBLOCK marked file */
+		if (kiocb->ki_flags & IOCB_NOWAIT)
+			goto done;
 		/* some cases will consume bytes even on error returns */
 		iov_iter_revert(iter, iov_count - iov_iter_count(iter));
 		ret = io_setup_async_rw(req, iovec, inline_vecs, iter, false);

-- 
Jens Axboe

