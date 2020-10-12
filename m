Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3CAD28C4E2
	for <lists+io-uring@lfdr.de>; Tue, 13 Oct 2020 00:42:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390507AbgJLWmo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 12 Oct 2020 18:42:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390499AbgJLWmn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 12 Oct 2020 18:42:43 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A064C0613D0
        for <io-uring@vger.kernel.org>; Mon, 12 Oct 2020 15:42:42 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id o9so9507211plx.10
        for <io-uring@vger.kernel.org>; Mon, 12 Oct 2020 15:42:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4F8/J83rPh614f3jTfjcz9hGkLM9dyf0k5zsjXkwnSI=;
        b=cW0JnNYk8n1r0hrclniUa6dCLgVK3l1VRiv0XWLquMqiti6gm8D5GHsTvcuIugRa/P
         1Uef0qYARCZDYS7A9a0us+8opXR+ghkg6jbtTOkr82i3W2daoAF7jRVm3iwAiNjLwt9q
         YncnOZy3GZJ4AN5FKZzcDLP1xQSg2WncXFdiMymVVWp7KO2qcNu6KrD9IftzasMDDiZs
         VJpjOeHAKf+rlrxDtYLThAKseYeve54pANPmTIZMt3h4I25A3wiy/iwEbAAQCck0jQMl
         fuxD6uLdI5KdMIciMzyAGnhcOcmFAEwSZewtn/6Nku4Sgi+VrqyTIjXll6DMqBituJWK
         vRpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4F8/J83rPh614f3jTfjcz9hGkLM9dyf0k5zsjXkwnSI=;
        b=ZML6ENoK8NCQMbvI20QNKa4kdbDoQyO8lJkH6J2CDY8Bh2LJJJIwd178e3BxEc7ZlE
         JeVTKT3unNsZes+i7q9H7DeYOeK312YuhVIN/ktsje911+66wOfosMYOK/6Y/3caxGdh
         vCF/iYcW4RcnZP3L8OPZMbxk1qHZEieR76jDdmRWv+p4PG4nLQsDlXpmkp8IGrDI2wj1
         SQYdvLxKkqIHAYtvofgCNQay44bUR2eP+pEoQsctLITC+0zOBZtnQnUXpffPqA/ca5TP
         PrKu2k9iKJS6pl+VG6jBv1ij1RGNxJ7hhSI2dzPQER2Mv88Jw1CzAEMHz4mSD3s7Hvkm
         Y7ow==
X-Gm-Message-State: AOAM532kN06rPfz9aH+zjwp+nyN/urrhFODtnLzAxMqUT/GspCFKvy2G
        ozqqUSqWFTJtaSDoEU3baSa6/w==
X-Google-Smtp-Source: ABdhPJxqhbZk6j1WgbcsGyWklMAxnmlaSDm2exkUW1GPuniFwX8gpcy5IK7KQ2bNuNC4cycVsT3s4Q==
X-Received: by 2002:a17:902:7b91:b029:d4:da66:ef6e with SMTP id w17-20020a1709027b91b02900d4da66ef6emr7701957pll.10.1602542561685;
        Mon, 12 Oct 2020 15:42:41 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id w6sm16570793pfj.137.2020.10.12.15.42.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Oct 2020 15:42:41 -0700 (PDT)
Subject: Re: Loophole in async page I/O
From:   Jens Axboe <axboe@kernel.dk>
To:     Matthew Wilcox <willy@infradead.org>, io-uring@vger.kernel.org
Cc:     Johannes Weiner <hannes@cmpxchg.org>,
        Hao_Xu <haoxu@linux.alibaba.com>,
        Andrew Morton <akpm@linux-foundation.org>
References: <20201012211355.GC20115@casper.infradead.org>
 <14d97ab3-edf7-c72a-51eb-d335e2768b65@kernel.dk>
 <0a2918fc-b2e4-bea0-c7e1-265a3da65fc9@kernel.dk>
Message-ID: <22881662-a503-1706-77e2-8f71bf41fe49@kernel.dk>
Date:   Mon, 12 Oct 2020 16:42:39 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <0a2918fc-b2e4-bea0-c7e1-265a3da65fc9@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/12/20 4:22 PM, Jens Axboe wrote:
> On 10/12/20 4:08 PM, Jens Axboe wrote:
>> On 10/12/20 3:13 PM, Matthew Wilcox wrote:
>>> This one's pretty unlikely, but there's a case in buffered reads where
>>> an IOCB_WAITQ read can end up sleeping.
>>>
>>> generic_file_buffered_read():
>>>                 page = find_get_page(mapping, index);
>>> ...
>>>                 if (!PageUptodate(page)) {
>>> ...
>>>                         if (iocb->ki_flags & IOCB_WAITQ) {
>>> ...
>>>                                 error = wait_on_page_locked_async(page,
>>>                                                                 iocb->ki_waitq);
>>> wait_on_page_locked_async():
>>>         if (!PageLocked(page))
>>>                 return 0;
>>> (back to generic_file_buffered_read):
>>>                         if (!mapping->a_ops->is_partially_uptodate(page,
>>>                                                         offset, iter->count))
>>>                                 goto page_not_up_to_date_locked;
>>>
>>> page_not_up_to_date_locked:
>>>                 if (iocb->ki_flags & (IOCB_NOIO | IOCB_NOWAIT)) {
>>>                         unlock_page(page);
>>>                         put_page(page);
>>>                         goto would_block;
>>>                 }
>>> ...
>>>                 error = mapping->a_ops->readpage(filp, page);
>>> (will unlock page on I/O completion)
>>>                 if (!PageUptodate(page)) {
>>>                         error = lock_page_killable(page);
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
>>>                                      struct wait_page_queue *wait)
>>>  {
>>>         if (!PageLocked(page))
>>> -               return 0;
>>> +               return -EIOCBQUEUED;
>>>         return __wait_on_page_locked_async(compound_head(page), wait, false);
>>>  }
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
>>     io_uring: fix async buffered reads when readahead is disabled
>>
>> maybe messed up that case, so we could block off the retry-path. I'll
>> take a closer look, looks like that can be the case if read-ahead is
>> disabled.
>>
>> In general, we can only return -EIOCBQUEUED if the IO has been started
>> or is in progress already. That means we can safely rely on being told
>> when it's unlocked/done. If we need to block, we should be returning
>> -EAGAIN, which would punt to a worker thread.
> 
> Something like the below might be a better solution - just always use
> the read-ahead to generate the IO, for the requested range. That won't
> issue any IO beyond what we asked for. And ensure we don't clear NOWAIT
> on the io_uring side for retry.
> 
> Totally untested... Just trying to get the idea across. We might need
> some low cap on req_count in case the range is large. Hao Xu, can you
> try with this? Thinking of your read-ahead disabled slowdown as well,
> this could very well be the reason why.

Here's one that caps us at 1 page, if read-ahead is disabled or we're
congested. Should still be fine in terms of being async, and it allows
us to use the same path for this instead of special casing it.

I ran some quick testing on this, and it seems to Work For Me. I'll do
some more targeted testing.

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
index 3c9a8dd7c56c..d0f556612fd6 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -568,15 +568,20 @@ void page_cache_sync_readahead(struct address_space *mapping,
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
+	 * Even if read-ahead is disabled, issue this request as read-ahead
+	 * as we'll need it to satisfy the requested range. The forced
+	 * read-ahead will do the right thing and limit the read to just the
+	 * requested range, which we'll set to 1 page for this case.
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
Jens Axboe

