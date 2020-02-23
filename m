Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D5B116974C
	for <lists+io-uring@lfdr.de>; Sun, 23 Feb 2020 12:03:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726308AbgBWLDo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 23 Feb 2020 06:03:44 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:50314 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726023AbgBWLDo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 23 Feb 2020 06:03:44 -0500
Received: by mail-wm1-f67.google.com with SMTP id a5so6173180wmb.0
        for <io-uring@vger.kernel.org>; Sun, 23 Feb 2020 03:03:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ViWrWyNpxKMmGUsBeG04qJznruXK5ZqY284dn3t9h6A=;
        b=aSq4WjCOedaT45NS90Gco1sRRPbZYGUYuTpw2oimgULx++hYPI1vZLlakjDXUzAltv
         uOCB4jDa4UPfwQ+lcfeUeXNjqKotBV/eYV6TNXlAZ6lkkmV4jYNkBFCkx9J4MpoIP3V8
         aymQZVP49SlAUjwwT/17Bse4zS5lYHlW7/Dc91bMFG7NKQtGt8378S9VJDERd0fykluj
         M+ASJ55hBWBBmGyeJJnMbMVFZsFUhjk8L4kPOqbK2zm6s+K62SOlVdymzHgM6mI6bCLc
         3gI/Kt5LcCftGX+Sz2AuiFgfPV4ZGX6xzWgjEvjBt4eAsxb5GG4WaA9ZUTI2V9HhsTl9
         myGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=ViWrWyNpxKMmGUsBeG04qJznruXK5ZqY284dn3t9h6A=;
        b=XPXsjkXuP8eB07OZdN4spYQBERv3F2jvnFDvQskP+JUGQ3IBiZW0iRaeezLWNcOhbt
         8CroJaRb+UBrnv9wXq5SpwrmiDdoX11CilX2Gr4j8mVQ/pOWX9lRodrYYshYuSi1YF8v
         PMz1OW57szV8rT8wueKqH75piBo8V9PiFvc4uMELDbMkTQumpnc7qaN80SXqR1PJiL2d
         P9cs/bGPUsxgIGOeEW+IXgkcHBIE3vVTf3IdFvxWvmiEnpe2g2GE4shYCPomICKEpUMh
         w+Cn7vXdPw0Hnm98UoJIM5YKTxpz5DNKlYq0Za+EykHlJNB154yH4mRfZDcWLZygdx1x
         GIcw==
X-Gm-Message-State: APjAAAVhNP+mmvyMyqDvsEJLLJMJZZTGTN3UvKKpvqcF5/lcFQf0anV/
        cCr5YfIvKcOe1Y6zcK499s4=
X-Google-Smtp-Source: APXvYqy4IHSemj8OAObt+jW+9gY43EuC96pkLtoqXk95ZGM5Bd9lhZ7bWnczYYflK4W07hYYNOo6Tw==
X-Received: by 2002:a7b:c851:: with SMTP id c17mr15437067wml.71.1582455821360;
        Sun, 23 Feb 2020 03:03:41 -0800 (PST)
Received: from [192.168.43.74] ([109.126.147.33])
        by smtp.gmail.com with ESMTPSA id v14sm7564182wrm.30.2020.02.23.03.03.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 23 Feb 2020 03:03:40 -0800 (PST)
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
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
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH 7/9] io_uring: add per-task callback handler
Message-ID: <fcfcf572-f808-6b3a-f9eb-379657babba5@gmail.com>
Date:   Sun, 23 Feb 2020 14:02:54 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <231dc76e-697f-d8dd-46cb-53776bdc920d@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 23/02/2020 09:26, Jens Axboe wrote:
> On 2/22/20 11:00 PM, Jens Axboe wrote:
>> On 2/21/20 12:10 PM, Jens Axboe wrote:
>>>> Got it. Then, it may happen in the future after returning from
>>>> __io_arm_poll_handler() and io_uring_enter(). And by that time io_submit_sqes()
>>>> should have already restored creds (i.e. personality stuff) on the way back.
>>>> This might be a problem.
>>>
>>> Not sure I follow, can you elaborate? Just to be sure, the requests that
>>> go through the poll handler will go through __io_queue_sqe() again. Oh I
>>> guess your point is that that is one level below where we normally
>>> assign the creds.
>>
>> Fixed this one.

Looking at

io_async_task_func() {
	...
	/* ensure req->work.creds is valid for __io_queue_sqe() */
	req->work.creds = apoll->work.creds;
}

It copies creds, but doesn't touch the rest req->work fields. And if you have
one, you most probably got all of them in *grab_env(). Are you sure it doesn't
leak, e.g. mmgrab()'ed mm?


>>
>>>> BTW, Is it by design, that all requests of a link use personality creds
>>>> specified in the head's sqe?
>>>
>>> No, I think that's more by accident. We should make sure they use the
>>> specified creds, regardless of the issue time. Care to clean that up?
>>> Would probably help get it right for the poll case, too.
>>
>> Took a look at this, and I think you're wrong. Every iteration of
>> io_submit_sqe() will lookup the right creds, and assign them to the
>> current task in case we're going to issue it. In the case of a link
>> where we already have the head, then we grab the current work
>> environment. This means assigning req->work.creds from
>> get_current_cred(), if not set, and these are the credentials we looked
>> up already.

Yeah, I've spotted that there something wrong, but never looked up properly.

> 
> What does look wrong is that we don't restore the right credentials for
> queuing the head, so basically the opposite problem. Something like the
> below should fix that.
> index de650df9ac53..59024e4757d6 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -4705,11 +4705,18 @@ static void __io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>  {
>  	struct io_kiocb *linked_timeout;
>  	struct io_kiocb *nxt = NULL;
> +	const struct cred *old_creds = NULL;
>  	int ret;
>  
>  again:
>  	linked_timeout = io_prep_linked_timeout(req);
>  
> +	if (req->work.creds && req->work.creds != get_current_cred()) {

get_current_cred() gets a ref.
See my attempt below, it fixes miscount, and should work better for cases
changing back to initial creds (i.e. personality 0)

Anyway, creds handling is too scattered across the code, and this do a lot of
useless refcounting and bouncing. It's better to find it a better place in the
near future.

> +		if (old_creds)
> +			revert_creds(old_creds);
> +		old_creds = override_creds(req->work.creds);
> +	}
> +
>  	ret = io_issue_sqe(req, sqe, &nxt, true);
>  
>  	/*
> @@ -4759,6 +4766,8 @@ static void __io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>  			goto punt;
>  		goto again;
>  	}
> +	if (old_creds)
> +		revert_creds(old_creds);
>  }
>  
>  static void io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe)
> 

diff --git a/fs/io_uring.c b/fs/io_uring.c
index de650df9ac53..dc06298abb37 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4705,11 +4705,21 @@ static void __io_queue_sqe(struct io_kiocb *req, const
struct io_uring_sqe *sqe)
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
@@ -4759,6 +4769,8 @@ static void __io_queue_sqe(struct io_kiocb *req, const
struct io_uring_sqe *sqe)
 			goto punt;
 		goto again;
 	}
+	if (old_creds)
+		revert_creds(old_creds);
 }

 static void io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe)

-- 
Pavel Begunkov
