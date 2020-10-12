Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99E8828C4B8
	for <lists+io-uring@lfdr.de>; Tue, 13 Oct 2020 00:22:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388330AbgJLWWq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 12 Oct 2020 18:22:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388361AbgJLWWq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 12 Oct 2020 18:22:46 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70520C0613D2
        for <io-uring@vger.kernel.org>; Mon, 12 Oct 2020 15:22:46 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id o3so5810651pgr.11
        for <io-uring@vger.kernel.org>; Mon, 12 Oct 2020 15:22:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gl1wZDqAxaYZd8S43T6I2fzm7ZzWPEatgmNIP61bEis=;
        b=SruRuJtz9eqQRdqjZhVUD9Ug4GrVlPyfIEhDuxm/OkhojNimw4JD88CgDPeBG2/LcR
         WYJXyT5oLGOpwOAnCULV1tt1Pc8aLjlSbMUuUJMlC0m6N8zl5tBYMpLcJfp8XZSaQ/6J
         iGWEmnkoxLxzAwnRkqVxLmA7kv3qzfE2DlUjBLR+1+sVE/4RVspEdMbqJMrkWE2rsflY
         lKk4fMxphri90os1daI6KGZHXeoiSGEdQeGAKsFnxHSU1IfUtsWO3zWpWxlipqb64Co4
         iuKJYejEIDAS5T+y0DXurx7FosYNCHFtTpO2Kj7qMturAb2pgGUNztKa/xxJ4QUR4F4P
         rqGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gl1wZDqAxaYZd8S43T6I2fzm7ZzWPEatgmNIP61bEis=;
        b=UkH/gOkC+4vRyGxsriJSdIJz6Lr+pZX06PH+qEXjWL89bGbNX0XCmmyosbxI4bRSMB
         aPlrqCAi/TlcSf4DLBRwwarkOpNmTfGnOh3TC6Oy432fp5MrXSLSDWPpDHWKbmk/O9xX
         I3YWE9eTWibIgp0h4cmPwrg5jhSyoAPN2olfEZSbEBPV5jTEVkxxAvOuzyJ5+87AIGTJ
         8nBOQU4/Xd5scd37Ycx1Tn8ive+2jetZKOvBg2dIxnk90UDDukzpfWMWw9j3WIpIgXah
         3fsYKXw2q5RZb8c0BGRXqvGnewSsS+fCN4ua1aex+pSbie/OyN1Zf0PGgbaKk7i0yjzu
         3UvQ==
X-Gm-Message-State: AOAM532PFyrNuEIDKLAy7AvHQQAY51LNu8icyh/Vw5VWNww+Nlnswm3C
        kT6JZMsIV3BVPFlCXkm5Ykqm3w==
X-Google-Smtp-Source: ABdhPJxTgv3VLKgDqDOQKstqYgjB7FcBJmRmWpSqqXizuP3YSBcdNbdUmXIHguPJQBnjKxTrwEW2RA==
X-Received: by 2002:a17:90a:191b:: with SMTP id 27mr22021857pjg.115.1602541365733;
        Mon, 12 Oct 2020 15:22:45 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id t15sm18288876pjy.33.2020.10.12.15.22.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Oct 2020 15:22:44 -0700 (PDT)
Subject: Re: Loophole in async page I/O
From:   Jens Axboe <axboe@kernel.dk>
To:     Matthew Wilcox <willy@infradead.org>, io-uring@vger.kernel.org
Cc:     Johannes Weiner <hannes@cmpxchg.org>,
        Hao_Xu <haoxu@linux.alibaba.com>
References: <20201012211355.GC20115@casper.infradead.org>
 <14d97ab3-edf7-c72a-51eb-d335e2768b65@kernel.dk>
Message-ID: <0a2918fc-b2e4-bea0-c7e1-265a3da65fc9@kernel.dk>
Date:   Mon, 12 Oct 2020 16:22:43 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <14d97ab3-edf7-c72a-51eb-d335e2768b65@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/12/20 4:08 PM, Jens Axboe wrote:
> On 10/12/20 3:13 PM, Matthew Wilcox wrote:
>> This one's pretty unlikely, but there's a case in buffered reads where
>> an IOCB_WAITQ read can end up sleeping.
>>
>> generic_file_buffered_read():
>>                 page = find_get_page(mapping, index);
>> ...
>>                 if (!PageUptodate(page)) {
>> ...
>>                         if (iocb->ki_flags & IOCB_WAITQ) {
>> ...
>>                                 error = wait_on_page_locked_async(page,
>>                                                                 iocb->ki_waitq);
>> wait_on_page_locked_async():
>>         if (!PageLocked(page))
>>                 return 0;
>> (back to generic_file_buffered_read):
>>                         if (!mapping->a_ops->is_partially_uptodate(page,
>>                                                         offset, iter->count))
>>                                 goto page_not_up_to_date_locked;
>>
>> page_not_up_to_date_locked:
>>                 if (iocb->ki_flags & (IOCB_NOIO | IOCB_NOWAIT)) {
>>                         unlock_page(page);
>>                         put_page(page);
>>                         goto would_block;
>>                 }
>> ...
>>                 error = mapping->a_ops->readpage(filp, page);
>> (will unlock page on I/O completion)
>>                 if (!PageUptodate(page)) {
>>                         error = lock_page_killable(page);
>>
>> So if we have IOCB_WAITQ set but IOCB_NOWAIT clear, we'll call ->readpage()
>> and wait for the I/O to complete.  I can't quite figure out if this is
>> intentional -- I think not; if I understand the semantics right, we
>> should be returning -EIOCBQUEUED and punting to an I/O thread to
>> kick off the I/O and wait.
>>
>> I think the right fix is to return -EIOCBQUEUED from
>> wait_on_page_locked_async() if the page isn't locked.  ie this:
>>
>> @@ -1258,7 +1258,7 @@ static int wait_on_page_locked_async(struct page *page,
>>                                      struct wait_page_queue *wait)
>>  {
>>         if (!PageLocked(page))
>> -               return 0;
>> +               return -EIOCBQUEUED;
>>         return __wait_on_page_locked_async(compound_head(page), wait, false);
>>  }
>>  
>> But as I said, I'm not sure what the semantics are supposed to be.
> 
> If NOWAIT isn't set, then the issue attempt is from the helper thread
> already, and IOCB_WAITQ shouldn't be set either (the latter doesn't
> matter for this discussion). So it's totally fine and expected to block
> at that point.
> 
> Hmm actually, I believe that:
> 
> commit c8d317aa1887b40b188ec3aaa6e9e524333caed1
> Author: Hao Xu <haoxu@linux.alibaba.com>
> Date:   Tue Sep 29 20:00:45 2020 +0800
> 
>     io_uring: fix async buffered reads when readahead is disabled
> 
> maybe messed up that case, so we could block off the retry-path. I'll
> take a closer look, looks like that can be the case if read-ahead is
> disabled.
> 
> In general, we can only return -EIOCBQUEUED if the IO has been started
> or is in progress already. That means we can safely rely on being told
> when it's unlocked/done. If we need to block, we should be returning
> -EAGAIN, which would punt to a worker thread.

Something like the below might be a better solution - just always use
the read-ahead to generate the IO, for the requested range. That won't
issue any IO beyond what we asked for. And ensure we don't clear NOWAIT
on the io_uring side for retry.

Totally untested... Just trying to get the idea across. We might need
some low cap on req_count in case the range is large. Hao Xu, can you
try with this? Thinking of your read-ahead disabled slowdown as well,
this could very well be the reason why.


diff --git a/fs/io_uring.c b/fs/io_uring.c
index aae0ef2ec34d..9a2dfe132665 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3107,7 +3107,6 @@ static bool io_rw_should_retry(struct io_kiocb *req)
 	wait->wait.flags = 0;
 	INIT_LIST_HEAD(&wait->wait.entry);
 	kiocb->ki_flags |= IOCB_WAITQ;
-	kiocb->ki_flags &= ~IOCB_NOWAIT;
 	kiocb->ki_waitq = wait;
 
 	io_get_req_task(req);
diff --git a/mm/readahead.c b/mm/readahead.c
index 3c9a8dd7c56c..693af86d171d 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -568,15 +568,16 @@ void page_cache_sync_readahead(struct address_space *mapping,
 			       struct file_ra_state *ra, struct file *filp,
 			       pgoff_t index, unsigned long req_count)
 {
-	/* no read-ahead */
-	if (!ra->ra_pages)
-		return;
-
 	if (blk_cgroup_congested())
 		return;
 
-	/* be dumb */
-	if (filp && (filp->f_mode & FMODE_RANDOM)) {
+	/*
+	 * Even if read-ahead is disabled, issue this request as read-ahead
+	 * as we'll need it to satisfy the requested range. The forced
+	 * read-ahead will do the right thing and limit the read to just the
+	 * requested range.
+	 */
+	if (!ra->ra_pages || (filp && (filp->f_mode & FMODE_RANDOM))) {
 		force_page_cache_readahead(mapping, filp, index, req_count);
 		return;
 	}

-- 
Jens Axboe

