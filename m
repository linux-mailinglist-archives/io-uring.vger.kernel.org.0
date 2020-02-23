Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7954716983B
	for <lists+io-uring@lfdr.de>; Sun, 23 Feb 2020 16:07:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726678AbgBWPHQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 23 Feb 2020 10:07:16 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:40581 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726534AbgBWPHQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 23 Feb 2020 10:07:16 -0500
Received: by mail-pj1-f67.google.com with SMTP id 12so2943692pjb.5
        for <io-uring@vger.kernel.org>; Sun, 23 Feb 2020 07:07:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+JOBQ1EeGHW83rdemZ7F7+Nma3eI9NLk5O47f96P7yI=;
        b=GMyDjvBSIYHRjsrGqA0d3zOsla0GGa0bUGHZpBMG09yNM6/pFxtEr9f4glQyyvpMUM
         yZxRzxGaFldxya/P6hZGHgrTc4djEg0RE6OJh7ML+5yYNwXmBNI+cLYRwNeDXcmT9F3k
         5PkImY3q8lTEDLZKbvAU7GW+6wk86LpWzlh/aaDlipMRsRLLPANCNhAUiR9ANRo/Onh2
         ogGrRaiwTMJnzDqDy0eRYPe6fVAdePN1UM4yjQ1fl181OlmgXtoVReISwF6itrvhCsPN
         ez15ym1HBb29EzQadGXPNVIS1st/0WUwFCoi28pQrxjBTjojctvLZfuJhkdBIwvSiaTs
         JcVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+JOBQ1EeGHW83rdemZ7F7+Nma3eI9NLk5O47f96P7yI=;
        b=DU1pWdSDIwpWMvwqocC9UXg37XZhrvR1dKqMx2flIbjGdECsjyojqQsRi95374ist6
         WO5BqSHRtd3ZPU+2syYvEj9gYEP2wRD+qrzITT/OMunk4ODQC11dhQW3PrebQ+U8a79m
         P0jqCVZR7P94bXycd9+iWABqNy07BJiQbbpd/uDoFMlhXLBC3/suXcvzjTQf8Pu1PBzm
         NPz9fKlROehMhOmutSuGZ95cpidUVAwTVbkxyMiL24KnVYM7/rUq9vrJNo/yPO+szA10
         ErJZ9Gpt1+P9U//8KnxHOmeTNChrZaqoBBQ3895B3jdoM1qMgpKQavS+9iz5s7Hoi6pr
         NVYw==
X-Gm-Message-State: APjAAAVmowK/mWao/GZwdrn0KhqVIZMUsJ4KdOsBbdLzFIVGg86YyWgr
        gqGZkw7kpagcrq9kPFV3wKPSmg==
X-Google-Smtp-Source: APXvYqxtexf9yafUvn9HU93o70N0FlSFiJIc425/xwpQjze+I1GFoaUfooIRu5d5lxGZoREpRAyz7Q==
X-Received: by 2002:a17:902:7046:: with SMTP id h6mr42972992plt.231.1582470434435;
        Sun, 23 Feb 2020 07:07:14 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id k29sm9575562pfh.77.2020.02.23.07.07.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 23 Feb 2020 07:07:13 -0800 (PST)
Subject: Re: [PATCH 7/9] io_uring: add per-task callback handler
From:   Jens Axboe <axboe@kernel.dk>
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
Message-ID: <48e81bbf-89c7-f84d-cefc-86d26baeae07@kernel.dk>
Date:   Sun, 23 Feb 2020 08:07:10 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <3d4aa255-f333-573c-e806-a3e79a28f3c6@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/23/20 7:58 AM, Jens Axboe wrote:
> On 2/23/20 7:49 AM, Jens Axboe wrote:
>>> Anyway, creds handling is too scattered across the code, and this do a
>>> lot of useless refcounting and bouncing. It's better to find it a
>>> better place in the near future.
>>
>> I think a good cleanup on top of this would be to move the personality
>> lookup to io_req_defer_prep(), and kill it from io_submit_sqe(). Now
>> __io_issue_sqe() does the right thing, and it'll just fall out nicely
>> with that as far as I can tell.
>>
>> Care to send a patch for that?
> 
> Since we also need it for non-deferral, how about just leaving the
> lookup in there and removing the assignment? That means we only do that
> juggling in one spot, which makes more sense. I think this should just
> be folded into the previous patch.

Tested, we need a ref grab on the creds when assigning since we're
dropped at the other end.


diff --git a/fs/io_uring.c b/fs/io_uring.c
index cead1a0602b4..d83f113f22fd 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4923,7 +4923,6 @@ static inline void io_queue_link_head(struct io_kiocb *req)
 static bool io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			  struct io_submit_state *state, struct io_kiocb **link)
 {
-	const struct cred *old_creds = NULL;
 	struct io_ring_ctx *ctx = req->ctx;
 	unsigned int sqe_flags;
 	int ret, id;
@@ -4938,14 +4937,12 @@ static bool io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 
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
@@ -4957,8 +4954,6 @@ static bool io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 err_req:
 		io_cqring_add_event(req, ret);
 		io_double_put_req(req);
-		if (old_creds)
-			revert_creds(old_creds);
 		return false;
 	}
 
@@ -5019,8 +5014,6 @@ static bool io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 		}
 	}
 
-	if (old_creds)
-		revert_creds(old_creds);
 	return true;
 }
 

-- 
Jens Axboe

