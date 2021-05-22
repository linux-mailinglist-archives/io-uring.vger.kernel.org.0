Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EE7138D28B
	for <lists+io-uring@lfdr.de>; Sat, 22 May 2021 02:23:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230190AbhEVAZN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 May 2021 20:25:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230268AbhEVAZF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 May 2021 20:25:05 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B000C061357;
        Fri, 21 May 2021 17:22:48 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id a4so22625861wrr.2;
        Fri, 21 May 2021 17:22:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:subject:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=gyzVl8OaygknyiQ92wI9NqUUnUzVTtSj7pAG6enmPyo=;
        b=h9+5dlZVZNErqj/VlQoU6FFADlMgqz1rcXrf+FRcGqRuWu6/+GSmFfJGzQ6UjZPasQ
         EI6OuFqiQZQgzqfNxjJJgx9yfPugxzr+7ry7XjEXAbqF6Nyt+oaUmo+pvs6sA7HNk3le
         v+j+HoV7anBhT0OQjfS1we4WTMQq6BnhMNAI3o6DZCNCS9uiYHUAhLYIkJroa2TsH1U5
         a1NB/CPiMyK/jA/IW1lsqCHSGOfzD0zibwaictf/lHaPY64rUPpK4kfZTMVIFzXlFra1
         JKxjgsoecROHhoTykwAdiHkJmmVd62kS24ZeLbepeB/r75wypmXI5iVKgliCKPIz5RWC
         NCxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gyzVl8OaygknyiQ92wI9NqUUnUzVTtSj7pAG6enmPyo=;
        b=ahQJiUHRlDNSEUKiILnJvFip3Q1S2c2GYqVQtJh89eKGIF7f1IeInzwEqRoEP8mhjj
         iz0Q14V8BmeTvIjFQn7TfwtvWYASq86hIg+IvPnG/+Sl86yjtnxS5T2jwcr4GuHurpqJ
         3W2QAHFfLtpG9HVsnspIPMrbxRRab6MvOQh9sdFNeTxFPhxcSQ7BxmkhPvwF2jUftkUJ
         fZCcHmycTgfw0fmk9RYS9VcVOLlql0+Aur/xM16ZJSYM7boxUJk6kDNwwalZ/dy4kTeq
         yBc2w82DYMG1TsPRqrdyb2AKr0f08X89dCnWxBYCDCdBo1J70Wx/tqUA7lZmVK/YXCxy
         5FaQ==
X-Gm-Message-State: AOAM530xMyuQRO0KBo/LFIiKXl4DNght7sWAcUBIHeFULlRgTlx/7/5R
        26vGJ1kZ7PG9toDPRkXsqHM=
X-Google-Smtp-Source: ABdhPJxaXbjmt4xOHYAJ+WucB6UB7YwedwnqpF4Vvt+zZvoVOd6AMuq4GF3A5xjCoLHvNNbU9LIObw==
X-Received: by 2002:adf:a519:: with SMTP id i25mr11858230wrb.312.1621642966773;
        Fri, 21 May 2021 17:22:46 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.236.182])
        by smtp.gmail.com with ESMTPSA id s199sm1032010wme.43.2021.05.21.17.22.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 May 2021 17:22:46 -0700 (PDT)
To:     Paul Moore <paul@paul-moore.com>,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        linux-audit@redhat.com, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>
References: <162163367115.8379.8459012634106035341.stgit@sifl>
 <162163379461.8379.9691291608621179559.stgit@sifl>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [RFC PATCH 2/9] audit,io_uring,io-wq: add some basic audit
 support to io_uring
Message-ID: <f07bd213-6656-7516-9099-c6ecf4174519@gmail.com>
Date:   Sat, 22 May 2021 01:22:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <162163379461.8379.9691291608621179559.stgit@sifl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/21/21 10:49 PM, Paul Moore wrote:
> WARNING - This is a work in progress and should not be merged
> anywhere important.  It is almost surely not complete, and while it
> probably compiles it likely hasn't been booted and will do terrible
> things.  You have been warned.
> 
> This patch adds basic auditing to io_uring operations, regardless of
> their context.  This is accomplished by allocating audit_context
> structures for the io-wq worker and io_uring SQPOLL kernel threads
> as well as explicitly auditing the io_uring operations in
> io_issue_sqe().  The io_uring operations are audited using a new
> AUDIT_URINGOP record, an example is shown below:
> 
>   % <TODO - insert AUDIT_URINGOP record example>
> 
> Thanks to Richard Guy Briggs for review and feedback.
> 
> Signed-off-by: Paul Moore <paul@paul-moore.com>
> ---
[...]
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index e481ac8a757a..e9941d1ad8fd 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -78,6 +78,7 @@
>  #include <linux/task_work.h>
>  #include <linux/pagemap.h>
>  #include <linux/io_uring.h>
> +#include <linux/audit.h>
>  
>  #define CREATE_TRACE_POINTS
>  #include <trace/events/io_uring.h>
> @@ -6105,6 +6106,9 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
>  	if (req->work.creds && req->work.creds != current_cred())
>  		creds = override_creds(req->work.creds);
>  
> +	if (req->opcode < IORING_OP_LAST)

always true at this point

> +		audit_uring_entry(req->opcode);

So, it adds two if's with memory loads (i.e. current->audit_context)
per request in one of the hottest functions here... No way, nack

Maybe, if it's dynamically compiled into like kprobes if it's
_really_ used.

> +
>  	switch (req->opcode) {
>  	case IORING_OP_NOP:
>  		ret = io_nop(req, issue_flags);
> @@ -6211,6 +6215,9 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
>  		break;
>  	}
>  
> +	if (req->opcode < IORING_OP_LAST)
> +		audit_uring_exit(!ret, ret);
> +
>  	if (creds)
>  		revert_creds(creds);

-- 
Pavel Begunkov
