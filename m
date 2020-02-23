Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF6CE16994F
	for <lists+io-uring@lfdr.de>; Sun, 23 Feb 2020 19:06:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726302AbgBWSG0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 23 Feb 2020 13:06:26 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:43024 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726208AbgBWSG0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 23 Feb 2020 13:06:26 -0500
Received: by mail-pg1-f196.google.com with SMTP id u12so3822805pgb.10
        for <io-uring@vger.kernel.org>; Sun, 23 Feb 2020 10:06:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4Yq1SypRVbTy/ne+x/qyQoFqejxOSu0DFI2lqiJDfNA=;
        b=yc2lrOmFrCPfiujvp9LSVwuzGhD7EF6blMJZ8UXOJbpfhHaZkgG8ybcbY27lBopCqV
         5hWW8ONAhkPg29CArx8xWNCmA4L9KUZELAz1Oo51vyOwquPm7BNJomSl3j9lE6ZrXFKH
         OESxCz+44snL60Eqk5S2VmL28ctBoNEEfGw1WfMUFGZ20NxUlT0lDSRZtW1LTim6iwsk
         3008RmsVz5CmOsUjCn0URcQfq33rd87vMPsPv1k2NdzndnaxNYQQMyINHrT5xJePGhXG
         JqKRlFmUYy0Ae2feUXXWiPzshJ3/5Cs8Gp7WC4Umh3elZd4d5kJyJ7gme19SoqyhVa0H
         21WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4Yq1SypRVbTy/ne+x/qyQoFqejxOSu0DFI2lqiJDfNA=;
        b=QAkJ03TmZQJ+wx6lkLvmvRtjxphnNCYlRTXz+ySg7sDjxJN4l8e78RqI0p8punSh5W
         2p2cBQnPc5X3jBs6H/boVvOBoYqvYJZTO3qiejcLynRXosk6LXEUgda7TDXNfSsHeEQa
         hWbmDkswqW6oGNyFJWePy8OSyehab/KkO/zRsBFTsd2VyvVOBlfrOeaxA2EceHjoEMMo
         2yvgXRoWwMkbgHpjHjW9XjtOFIJnCGd3+qgq4aWZOaba1BFxgmv8XYMX8dqQ/tvC05Wq
         gNpC0/r/8N87VCBJGxdVjQvjl16/3bF5Gln+ZSBT/AheAjLF2tyvWq+agdb91n5E8nOs
         hKlw==
X-Gm-Message-State: APjAAAXL1ykfwvwhN8UpNuxcnlFBD4MKVccQYpIkbuRKxJ2MRGSrmwEc
        sueqLQMebSmGxAz9q4vDvy7O8y4ZyZY=
X-Google-Smtp-Source: APXvYqy7zwsF0X5o2VG9X7ClYmm7rLRHtWyq7CKKDJ0aXpdkUic3DPwWIPZ0uPBEnGdj8J8Q+evBzw==
X-Received: by 2002:a63:8f1a:: with SMTP id n26mr30198253pgd.355.1582481185367;
        Sun, 23 Feb 2020 10:06:25 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id b10sm9460768pjo.32.2020.02.23.10.06.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 23 Feb 2020 10:06:24 -0800 (PST)
Subject: Re: [PATCH 7/9] io_uring: add per-task callback handler
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     glauber@scylladb.com, peterz@infradead.org,
        Jann Horn <jannh@google.com>
References: <20200220203151.18709-1-axboe@kernel.dk>
 <20200220203151.18709-8-axboe@kernel.dk>
 <862fb96f-cebe-dfd8-0042-3284985d8704@gmail.com>
 <3c9a3fca-a780-6d04-65cb-c08ef382a2eb@kernel.dk>
 <a5258ad9-ab20-8068-2cb8-848756cf568d@gmail.com>
 <2d869361-18d0-a0fa-cc53-970078d8b826@kernel.dk>
 <08564f4e-8dd1-d656-a22a-325cc1c3e38f@kernel.dk>
 <231dc76e-697f-d8dd-46cb-53776bdc920d@kernel.dk>
 <fcfcf572-f808-6b3a-f9eb-379657babba5@gmail.com>
 <18d38bb6-70e2-24ce-a668-d279b8e3ce4c@kernel.dk>
 <3d4aa255-f333-573c-e806-a3e79a28f3c6@kernel.dk>
 <48e81bbf-89c7-f84d-cefc-86d26baeae07@kernel.dk>
 <3e51d59a-f856-0491-1e51-faed95b3af20@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <32a97ee9-2c16-807d-678d-c0b26a07f8c1@kernel.dk>
Date:   Sun, 23 Feb 2020 11:06:23 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <3e51d59a-f856-0491-1e51-faed95b3af20@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/23/20 11:04 AM, Pavel Begunkov wrote:
> On 23/02/2020 18:07, Jens Axboe wrote:
>> On 2/23/20 7:58 AM, Jens Axboe wrote:
>>> On 2/23/20 7:49 AM, Jens Axboe wrote:
>>>>> Anyway, creds handling is too scattered across the code, and this do a
>>>>> lot of useless refcounting and bouncing. It's better to find it a
>>>>> better place in the near future.
>>>>
>>>> I think a good cleanup on top of this would be to move the personality
>>>> lookup to io_req_defer_prep(), and kill it from io_submit_sqe(). Now
>>>> __io_issue_sqe() does the right thing, and it'll just fall out nicely
>>>> with that as far as I can tell.
>>>>
>>>> Care to send a patch for that?
>>>
>>> Since we also need it for non-deferral, how about just leaving the
>>> lookup in there and removing the assignment? That means we only do that
>>> juggling in one spot, which makes more sense. I think this should just
>>> be folded into the previous patch.
>>
>> Tested, we need a ref grab on the creds when assigning since we're
>> dropped at the other end.
> 
> Nice, this looks much better.

Glad you agree, here's the final folded in:


commit 6494e0bd77a5b339e0585c65792e1f829f2a4812
Author: Jens Axboe <axboe@kernel.dk>
Date:   Sat Feb 22 23:22:19 2020 -0700

    io_uring: handle multiple personalities in link chains
    
    If we have a chain of requests and they don't all use the same
    credentials, then the head of the chain will be issued with the
    credentails of the tail of the chain.
    
    Ensure __io_queue_sqe() overrides the credentials, if they are different.
    
    Once we do that, we can clean up the creds handling as well, by only
    having io_submit_sqe() do the lookup of a personality. It doesn't need
    to assign it, since __io_queue_sqe() now always does the right thing.
    
    Fixes: 75c6a03904e0 ("io_uring: support using a registered personality for commands")
    Reported-by: Pavel Begunkov <asml.silence@gmail.com>
    Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index de650df9ac53..7d0be264527d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4705,11 +4705,21 @@ static void __io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_kiocb *linked_timeout;
 	struct io_kiocb *nxt = NULL;
+	const struct cred *old_creds = NULL;
 	int ret;
 
 again:
 	linked_timeout = io_prep_linked_timeout(req);
 
+	if (req->work.creds && req->work.creds != current_cred()) {
+		if (old_creds)
+			revert_creds(old_creds);
+		if (old_creds == req->work.creds)
+			old_creds = NULL; /* restored original creds */
+		else
+			old_creds = override_creds(req->work.creds);
+	}
+
 	ret = io_issue_sqe(req, sqe, &nxt, true);
 
 	/*
@@ -4759,6 +4769,8 @@ static void __io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 			goto punt;
 		goto again;
 	}
+	if (old_creds)
+		revert_creds(old_creds);
 }
 
 static void io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe)
@@ -4803,7 +4815,6 @@ static inline void io_queue_link_head(struct io_kiocb *req)
 static bool io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			  struct io_submit_state *state, struct io_kiocb **link)
 {
-	const struct cred *old_creds = NULL;
 	struct io_ring_ctx *ctx = req->ctx;
 	unsigned int sqe_flags;
 	int ret, id;
@@ -4818,14 +4829,12 @@ static bool io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 
 	id = READ_ONCE(sqe->personality);
 	if (id) {
-		const struct cred *personality_creds;
-
-		personality_creds = idr_find(&ctx->personality_idr, id);
-		if (unlikely(!personality_creds)) {
+		req->work.creds = idr_find(&ctx->personality_idr, id);
+		if (unlikely(!req->work.creds)) {
 			ret = -EINVAL;
 			goto err_req;
 		}
-		old_creds = override_creds(personality_creds);
+		get_cred(req->work.creds);
 	}
 
 	/* same numerical values with corresponding REQ_F_*, safe to copy */
@@ -4837,8 +4846,6 @@ static bool io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 err_req:
 		io_cqring_add_event(req, ret);
 		io_double_put_req(req);
-		if (old_creds)
-			revert_creds(old_creds);
 		return false;
 	}
 
@@ -4899,8 +4906,6 @@ static bool io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 		}
 	}
 
-	if (old_creds)
-		revert_creds(old_creds);
 	return true;
 }
 

-- 
Jens Axboe

