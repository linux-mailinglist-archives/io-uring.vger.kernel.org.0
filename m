Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 610C728D34D
	for <lists+io-uring@lfdr.de>; Tue, 13 Oct 2020 19:50:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726552AbgJMRuX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 13 Oct 2020 13:50:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725899AbgJMRuX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 13 Oct 2020 13:50:23 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DDBDC0613D0
        for <io-uring@vger.kernel.org>; Tue, 13 Oct 2020 10:50:22 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id v12so224728ply.12
        for <io-uring@vger.kernel.org>; Tue, 13 Oct 2020 10:50:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language;
        bh=WKHTFom3+AuxBHLSI/PTu/TJ1vtYg8tOnphJUldRqMM=;
        b=uflWbxLSK8oOrO9AS30BEFAcGxu+pnjd6GXhvrSW/gm8hb3uQ1b2cP+X0ArgcYWhgB
         3mkeXkQCIOju5IvV+wY+ScYHzr3FAXdlYPT2UysrmB07ZLr5zp4b45HdM9MCMCHyreQa
         3N1j7hmKiwBckrKRgRjGXyXUciEcwhDwshJpxUs204eyIYA7NoVySjTROJ99L3DtKAdQ
         a3MtsadMnXjM4hCFOQf7mFrbuVLJoMaQhi32R01h/GFrVCokOtizDiwDhyx42z3+B5HV
         kSbn3WrY8sqOg9P55NCmEm6TQTh/yH7QYhCbY19IkT1tcDEiHL/y/dWhF4XHhT1LyPJN
         DkdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language;
        bh=WKHTFom3+AuxBHLSI/PTu/TJ1vtYg8tOnphJUldRqMM=;
        b=Da8u3F9LnLeh9FP0Fj606lfZyc7OXYfWatba7wX9S1G9+iLtK7fCsPiUDHL+gEOH8Q
         hdGPJIZW648h5WUCCNVa5EeSmNLDNPBkyn/NYJGut4i6nDR+lVhseHPm/9h5fyy9Fe9h
         VOviUn11uzSqUbsjP5PMmEBI+v11D1aXlRG0HvaQeOCygwtpu7dg1bY5hXR7v0taoZwA
         61qwupvFN4z3OT5ASh0AR7o8A05TzJNnN2K8qh2YUPHWTx4j/cLBr0xEf47hr2l4L5js
         obe4Nv6xs15GTI7K4hE6EeDQVLE5xhWMfQqDUiO20djxHOK5NoTLxZ6tQNTSch3kb6A9
         aL9w==
X-Gm-Message-State: AOAM531nMCABo+IjaWlc97sJae78wgZ2kZ60C5zk6X2ZLFYnoSI4il3t
        zAHQ8fkNCfstg1qyStADUEp61w==
X-Google-Smtp-Source: ABdhPJwWuNIzLskLpqDOjua2jCWgd9XTpG9ZyS40pNbh98o4Sj+MR3YAays8WmxeXjHEgf+jeIVVVQ==
X-Received: by 2002:a17:902:dc86:b029:d3:d3cb:7748 with SMTP id n6-20020a170902dc86b02900d3d3cb7748mr684119pld.22.1602611421439;
        Tue, 13 Oct 2020 10:50:21 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id r19sm529859pjo.23.2020.10.13.10.50.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Oct 2020 10:50:20 -0700 (PDT)
Subject: Re: Loophole in async page I/O
To:     Hao_Xu <haoxu@linux.alibaba.com>,
        Matthew Wilcox <willy@infradead.org>, io-uring@vger.kernel.org
Cc:     Johannes Weiner <hannes@cmpxchg.org>
References: <20201012211355.GC20115@casper.infradead.org>
 <14d97ab3-edf7-c72a-51eb-d335e2768b65@kernel.dk>
 <61743c36-ff6a-fce6-a3c4-55ec1c3f1cfa@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <3ed1c24b-9670-ddf1-fc69-e15296adafd9@kernel.dk>
Date:   Tue, 13 Oct 2020 11:50:19 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <61743c36-ff6a-fce6-a3c4-55ec1c3f1cfa@linux.alibaba.com>
Content-Type: multipart/mixed;
 boundary="------------F049294734165EC6121AAAC7"
Content-Language: en-US
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is a multi-part message in MIME format.
--------------F049294734165EC6121AAAC7
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

On 10/12/20 11:31 PM, Hao_Xu wrote:
> 在 2020/10/13 上午6:08, Jens Axboe 写道:
>> On 10/12/20 3:13 PM, Matthew Wilcox wrote:
>>> This one's pretty unlikely, but there's a case in buffered reads where
>>> an IOCB_WAITQ read can end up sleeping.
>>>
>>> generic_file_buffered_read():
>>>                  page = find_get_page(mapping, index);
>>> ...
>>>                  if (!PageUptodate(page)) {
>>> ...
>>>                          if (iocb->ki_flags & IOCB_WAITQ) {
>>> ...
>>>                                  error = wait_on_page_locked_async(page,
>>>                                                                  iocb->ki_waitq);
>>> wait_on_page_locked_async():
>>>          if (!PageLocked(page))
>>>                  return 0;
>>> (back to generic_file_buffered_read):
>>>                          if (!mapping->a_ops->is_partially_uptodate(page,
>>>                                                          offset, iter->count))
>>>                                  goto page_not_up_to_date_locked;
>>>
>>> page_not_up_to_date_locked:
>>>                  if (iocb->ki_flags & (IOCB_NOIO | IOCB_NOWAIT)) {
>>>                          unlock_page(page);
>>>                          put_page(page);
>>>                          goto would_block;
>>>                  }
>>> ...
>>>                  error = mapping->a_ops->readpage(filp, page);
>>> (will unlock page on I/O completion)
>>>                  if (!PageUptodate(page)) {
>>>                          error = lock_page_killable(page);
>>>
>>> So if we have IOCB_WAITQ set but IOCB_NOWAIT clear, we'll call ->readpage()
>>> and wait for the I/O to complete.  I can't quite figure out if this is
>>> intentional -- I think not; if I understand the semantics right, we
>>> should be returning -EIOCBQUEUED and punting to an I/O thread to
>>> kick off the I/O and wait.
>>>
>>> I think the right fix is to return -EIOCBQUEUED from
>>> wait_on_page_locked_async() if the page isn't locked.  ie this:
>>>
>>> @@ -1258,7 +1258,7 @@ static int wait_on_page_locked_async(struct page *page,
>>>                                       struct wait_page_queue *wait)
>>>   {
>>>          if (!PageLocked(page))
>>> -               return 0;
>>> +               return -EIOCBQUEUED;
>>>          return __wait_on_page_locked_async(compound_head(page), wait, false);
>>>   }
>>>   
>>> But as I said, I'm not sure what the semantics are supposed to be.
>>
>> If NOWAIT isn't set, then the issue attempt is from the helper thread
>> already, and IOCB_WAITQ shouldn't be set either (the latter doesn't
>> matter for this discussion). So it's totally fine and expected to block
>> at that point.
>>
>> Hmm actually, I believe that:
>>
>> commit c8d317aa1887b40b188ec3aaa6e9e524333caed1
>> Author: Hao Xu <haoxu@linux.alibaba.com>
>> Date:   Tue Sep 29 20:00:45 2020 +0800
>>
>>      io_uring: fix async buffered reads when readahead is disabled
>>
>> maybe messed up that case, so we could block off the retry-path. I'll
>> take a closer look, looks like that can be the case if read-ahead is
>> disabled.
>>
>> In general, we can only return -EIOCBQUEUED if the IO has been started
>> or is in progress already. That means we can safely rely on being told
>> when it's unlocked/done. If we need to block, we should be returning
>> -EAGAIN, which would punt to a worker thread.
>>
> Hi Jens,
> My undertanding of io_uring buffered reads process after the commit 
> c8d317aa1887b40b188ec3aaa6e9e524333caed1 has been merged is:
> the first io_uring IO try is with IOCB_NOWAIT, the second retry in the 
> same context is with IOCB_WAITQ but without IOCB_NOWAIT.
> so in Matthew's case, lock_page_async() will be called after calling 
> mapping->a_ops->readpage(), So it won't end up sleeping.
> Actually this case is what happens when readahead is disabled or somehow 
> skipped for reasons like blk_cgroup_congested() returns true. And this 
> case is my commit c8d317aa1887b40b188e for.

Well, try the patches. I agree it's not going to sleep with the previous
fix, but we're definitely driving a lower utilization by not utilizing
read-ahead even if disabled.

Re-run your previous tests with these two applied and see what you get.

-- 
Jens Axboe


--------------F049294734165EC6121AAAC7
Content-Type: text/x-patch; charset=UTF-8;
 name="0002-io_uring-don-t-clear-IOCB_NOWAIT-for-async-buffered-.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0002-io_uring-don-t-clear-IOCB_NOWAIT-for-async-buffered-.pa";
 filename*1="tch"

From 19185e0ea3a91a1d8b9c7e013a32f96bf006052a Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Mon, 12 Oct 2020 16:48:57 -0600
Subject: [PATCH 2/2] io_uring: don't clear IOCB_NOWAIT for async buffered
 retry

If we do, and read-ahead is disabled, we can be blocking on the page to
finish before making progress. This defeats the purpose of async IO.
Now that we know that read-ahead will most likely trigger the IO, we can
make progress even for ra_pages == 0 without punting to io-wq to satisfy
the IO in a blocking fashion.

Fixes: c8d317aa1887 ("io_uring: fix async buffered reads when readahead is disabled")
Reported-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index c043d889a2eb..be70f3e38fb2 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3248,7 +3248,6 @@ static bool io_rw_should_retry(struct io_kiocb *req)
 	wait->wait.flags = 0;
 	INIT_LIST_HEAD(&wait->wait.entry);
 	kiocb->ki_flags |= IOCB_WAITQ;
-	kiocb->ki_flags &= ~IOCB_NOWAIT;
 	kiocb->ki_waitq = wait;
 	return true;
 }
-- 
2.28.0


--------------F049294734165EC6121AAAC7
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-readahead-use-limited-read-ahead-to-satisfy-read.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-readahead-use-limited-read-ahead-to-satisfy-read.patch"

From 10b8c31e8085a85d5a71c7e271387c2edbcf7b96 Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Mon, 12 Oct 2020 16:44:23 -0600
Subject: [PATCH 1/2] readahead: use limited read-ahead to satisfy read

Willy reports that there's a case where async buffered reads will be
blocking, and that's due to not using read-ahead to generate the reads
when read-ahead is disabled. io_uring relies on read-ahead triggering
the reads, if not, it needs to fallback to threaded helpers.

For the case where read-ahead is disabled on the file, or if the cgroup
is congested, ensure that we can at least do 1 page of read-ahead to
make progress on the read in an async fashion. This could potentially be
larger, but it's not needed in terms of functionality, so let's error on
the side of caution as larger counts of pages may run into reclaim
issues (particularly if we're congested).

Reported-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 mm/readahead.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/mm/readahead.c b/mm/readahead.c
index 3c9a8dd7c56c..e5975f4e0ee5 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -568,15 +568,21 @@ void page_cache_sync_readahead(struct address_space *mapping,
 			       struct file_ra_state *ra, struct file *filp,
 			       pgoff_t index, unsigned long req_count)
 {
-	/* no read-ahead */
-	if (!ra->ra_pages)
-		return;
+	bool do_forced_ra = filp && (filp->f_mode & FMODE_RANDOM);
 
-	if (blk_cgroup_congested())
-		return;
+	/*
+	 * Even if read-ahead is disabled, start this request as read-ahead.
+	 * This makes regular read-ahead disabled use the same path as normal
+	 * reads, instead of having to punt to ->readpage() manually. We limit
+	 * ourselves to 1 page for this case, to avoid causing problems if
+	 * we're congested or tight on memory.
+	 */
+	if (!ra->ra_pages || blk_cgroup_congested()) {
+		req_count = 1;
+		do_forced_ra = true;
+	}
 
-	/* be dumb */
-	if (filp && (filp->f_mode & FMODE_RANDOM)) {
+	if (do_forced_ra) {
 		force_page_cache_readahead(mapping, filp, index, req_count);
 		return;
 	}
-- 
2.28.0


--------------F049294734165EC6121AAAC7--
