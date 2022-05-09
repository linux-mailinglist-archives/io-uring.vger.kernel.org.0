Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCFA751FCD0
	for <lists+io-uring@lfdr.de>; Mon,  9 May 2022 14:29:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234463AbiEIMcx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 May 2022 08:32:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234456AbiEIMcx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 May 2022 08:32:53 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA2652734E6
        for <io-uring@vger.kernel.org>; Mon,  9 May 2022 05:28:59 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id v10so11894081pgl.11
        for <io-uring@vger.kernel.org>; Mon, 09 May 2022 05:28:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=6f7S6GSUWmLkS6chuh5SXaYO9IwSIyRTt7NQ16ROyHA=;
        b=uts5XyHx9j9AJrpNeQugcRXKvpZTZ+ilfGOuxVSOzbRjTcAU9WbdZjp9f61BOe2XsK
         tRJ18v7GEgnAYFvMaOC6EOQWLbbK4YgPX5edyIfrYvONfm0HidfOsVi0oiuGvF1RLK+x
         T6DL7uWOo0sA9wvTZUBkHrMPGVKMShjb40C8RPmiMemyjgaEW7U9PgMbl7uDe/uJwcvf
         Nlyw7T0VbXaUTjf4QX/fsXHqRsogsqJo9wnO8pD6pNTq8aXOZuqOLC4ZiPx+Mkp8rmED
         Ifzz929Yb44W7jgYQ0MrnoIThdxBUpxbpd4PUQ2GZnyapCir3jaV9VENIhiXW/NKsU9o
         cyAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=6f7S6GSUWmLkS6chuh5SXaYO9IwSIyRTt7NQ16ROyHA=;
        b=L1/TwdL74H/mItSYbFx/GdXsKqoiV2fj75io+i5ooqP4NiCwemlMzQQrXm+87oJe4j
         OllT2c9d9PfD3s0SwvyBqKFyeuDFObOcJNVat87lnnMK5/U4WkDNuIHOdnui2OntWTMv
         vur9alC+NcZ8MuVI6oGvyJYz0NldY22qk+av68n1Xu6xH4m94mUDtBzb31sUXHVe/y1D
         A2GIA+s+wbJrB6m5aCcZNztWAMmhCCiEXtRlyFOqFak+v2wHeOL6wW9HYRKMH2F0dJ5t
         AVLdt/rVinBtCyvHlzKVM8ERTHIgBZR43y0aHk6ZcKua/DwXxkg1noxAfNvGnPoKj1GC
         3x9A==
X-Gm-Message-State: AOAM533KB93fPVrJtZrEwIlDx+mOJByorWZXDkZAcNqQOBriWGlwERzn
        gp0YiHVsXsuIhnnZEoqhUnsH6INN3sa2RH7Z
X-Google-Smtp-Source: ABdhPJyBZALQ0AH7u6x6AEM7Vo6ymEgq9OkMw0pRgpSmRe9a5HSwAvm9lAz/zTxvn4JBwrwGb/6OWA==
X-Received: by 2002:a63:5917:0:b0:39c:c450:3143 with SMTP id n23-20020a635917000000b0039cc4503143mr12936455pgb.531.1652099339363;
        Mon, 09 May 2022 05:28:59 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id b141-20020a621b93000000b0050dc7628176sm8463336pfb.80.2022.05.09.05.28.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 May 2022 05:28:58 -0700 (PDT)
Message-ID: <2c63a534-d728-205a-9812-d12eb62c6d75@kernel.dk>
Date:   Mon, 9 May 2022 06:28:57 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH 03/16] io_uring: make io_buffer_select() return the user
 address directly
Content-Language: en-US
To:     Dylan Yudaken <dylany@fb.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
Cc:     "asml.silence@gmail.com" <asml.silence@gmail.com>
References: <20220501205653.15775-1-axboe@kernel.dk>
 <20220501205653.15775-4-axboe@kernel.dk>
 <6d2c33ba9d8da5dba90f3708f0527f360c18c74c.camel@fb.com>
 <e5f792aaca511e477ceb25115c30b6b53abf5063.camel@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <e5f792aaca511e477ceb25115c30b6b53abf5063.camel@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/9/22 6:12 AM, Dylan Yudaken wrote:
> On Mon, 2022-05-09 at 12:06 +0000, Dylan Yudaken wrote:
>> On Sun, 2022-05-01 at 14:56 -0600, Jens Axboe wrote:
>>> There's no point in having callers provide a kbuf, we're just
>>> returning
>>> the address anyway.
>>>
>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>> ---
>>>  fs/io_uring.c | 42 ++++++++++++++++++------------------------
>>>  1 file changed, 18 insertions(+), 24 deletions(-)
>>>
>>
>> ...
>>
>>> @@ -6013,10 +6006,11 @@ static int io_recv(struct io_kiocb *req,
>>> unsigned int issue_flags)
>>>                 return -ENOTSOCK;
>>>  
>>>         if (req->flags & REQ_F_BUFFER_SELECT) {
>>> -               kbuf = io_buffer_select(req, &sr->len, sr->bgid,
>>> issue_flags);
>>> -               if (IS_ERR(kbuf))
>>> -                       return PTR_ERR(kbuf);
>>> -               buf = u64_to_user_ptr(kbuf->addr);
>>> +               void __user *buf;
>>
>> this now shadows the outer buf, and so does not work at all as the buf
>> value is lost.
>> A bit surprised this did not show up in any tests.
>>
>>> +
>>> +               buf = io_buffer_select(req, &sr->len, sr->bgid,
>>> issue_flags);
>>> +               if (IS_ERR(buf))
>>> +                       return PTR_ERR(buf);
>>>         }
>>>  
>>>         ret = import_single_range(READ, buf, sr->len, &iov,
>>> &msg.msg_iter);
>>
> 
> The following seems to fix it for me. I can submit it separately if you
> like.

I think you want something like this:


diff --git a/fs/io_uring.c b/fs/io_uring.c
index 19dd3ba92486..2b87c89d2375 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5599,7 +5599,6 @@ static int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_sr_msg *sr = &req->sr_msg;
 	struct msghdr msg;
-	void __user *buf = sr->buf;
 	struct socket *sock;
 	struct iovec iov;
 	unsigned flags;
@@ -5620,9 +5619,10 @@ static int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 		buf = io_buffer_select(req, &sr->len, sr->bgid, issue_flags);
 		if (IS_ERR(buf))
 			return PTR_ERR(buf);
+		sr->buf = buf;
 	}
 
-	ret = import_single_range(READ, buf, sr->len, &iov, &msg.msg_iter);
+	ret = import_single_range(READ, sr->buf, sr->len, &iov, &msg.msg_iter);
 	if (unlikely(ret))
 		goto out_free;
 

-- 
Jens Axboe

