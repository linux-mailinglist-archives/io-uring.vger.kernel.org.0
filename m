Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA5F215F672
	for <lists+io-uring@lfdr.de>; Fri, 14 Feb 2020 20:10:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388028AbgBNTJ4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 14 Feb 2020 14:09:56 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:46659 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387603AbgBNTJz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 14 Feb 2020 14:09:55 -0500
Received: by mail-io1-f67.google.com with SMTP id t26so11669422ioi.13
        for <io-uring@vger.kernel.org>; Fri, 14 Feb 2020 11:09:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3nQft3zNgFt5uQU8oAfUWTsZHLYmMf56s+RYaheimZE=;
        b=MyO7QGdH+798UZjnAMYOkuj8AFhvD2grF/mlXVN0vybPurAJxYZ3oL+IKZCAWZdcy+
         6FvlmOcxSEeyW8GYOiu92uMLIpGO5GXj3ROj/POgPywHF+Dt2fQxlx1GIav6E7x8zu1c
         CTgCm8fggVi5/kFqoAyeAhSdRpnkaQluMrEathIPxVTtnDPqtth+G/BB5JjQt+WUNXJ9
         jTURq56vwZzGFlpQN6IhytUiG3E2ru0w7HUvwsQRSSwxhzmPCj1Kew74eBYQZNib9FRM
         aCVMOfr4k5v9e+J+g08mdNKZWQHugVJLIgsInifA26Ph3dd5Xl2RBoil6Z1ALotLGyjj
         NqYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3nQft3zNgFt5uQU8oAfUWTsZHLYmMf56s+RYaheimZE=;
        b=fpKUvkfmEms8ESlWnIEuomqggTd0+ZdLy0S7R6l1xH4D2K1mOFIvDHEdAwkONRvVhj
         x+Ke1fmW54k6+62/3Wu1dZNoSH6P959bQ81/uYzSRnl0z62bif6YzfWOMrbB+W4b1l7n
         FHSft6OA9Erj3iGvJic5LEQqjDCvZWIQZdqeZrSLNU+quwQufOySvXHG9ebuwBD46qcZ
         G59F5kWjiGVOC0WJUlIXwwwaYYEikDb+ynNgihi1RcowbQTLMoe3eVsGZS8Nc/hTKyCj
         e7MAQv9G62ZSn84JRPupmr60SwnwKCGvnKK+izLZWO1jlFF1HInpIvmmEglMrsrGHDK6
         eQtg==
X-Gm-Message-State: APjAAAUJ8cZ7sTwtfYYS0kLdNdPo6aYIdKJrebFYnxEN7eQCNlgEGfb/
        a/12+KeoArVbHJfS2Qy62rRcFA==
X-Google-Smtp-Source: APXvYqxw24vmx09MidR6SM+oAC5IbyGhplcGKEG/Y6qBp3Q33Biv24Xoj209dgWP5oW04FL2GGkyzA==
X-Received: by 2002:a02:cab0:: with SMTP id e16mr3903013jap.6.1581707393584;
        Fri, 14 Feb 2020 11:09:53 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id z21sm1692252ioj.21.2020.02.14.11.09.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Feb 2020 11:09:53 -0800 (PST)
Subject: Re: [PATCH v5 1/7] mm: pass task and mm to do_madvise
To:     Minchan Kim <minchan@kernel.org>
Cc:     Jann Horn <jannh@google.com>, io-uring <io-uring@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        Linux API <linux-api@vger.kernel.org>,
        Oleksandr Natalenko <oleksandr@redhat.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Tim Murray <timmurray@google.com>,
        Daniel Colascione <dancol@google.com>,
        Sandeep Patil <sspatil@google.com>,
        Sonny Rao <sonnyrao@google.com>,
        Brian Geffon <bgeffon@google.com>,
        Michal Hocko <mhocko@suse.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Shakeel Butt <shakeelb@google.com>,
        John Dias <joaodias@google.com>,
        Joel Fernandes <joel@joelfernandes.org>, sj38.park@gmail.com,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>
References: <20200214170520.160271-1-minchan@kernel.org>
 <20200214170520.160271-2-minchan@kernel.org>
 <CAG48ez3S5+EasZ1ZWcMQYZQQ5zJOBtY-_C7oz6DMfG4Gcyig1g@mail.gmail.com>
 <68044a15-6a31-e432-3105-f2f1af9f4b74@kernel.dk>
 <20200214184514.GA165785@google.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <93aadcc6-3ef5-4ea0-be6b-23c06862002e@kernel.dk>
Date:   Fri, 14 Feb 2020 12:09:50 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200214184514.GA165785@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/14/20 11:45 AM, Minchan Kim wrote:
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 63beda9bafc5..1c7e9cd6c8ce 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -2736,7 +2736,7 @@ static int io_madvise(struct io_kiocb *req, struct io_kiocb **nxt,
>  	if (force_nonblock)
>  		return -EAGAIN;
>  
> -	ret = do_madvise(ma->addr, ma->len, ma->advice);
> +	ret = do_madvise(NULL, current->mm, ma->addr, ma->len, ma->advice);
>  	if (ret < 0)
>  		req_set_fail_links(req);
>  	io_cqring_add_event(req, ret);

I think we want to use req->work.mm here - it'll be the same as
current->mm at this point, but it makes it clear that we're using a
grabbed mm.

-- 
Jens Axboe

