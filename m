Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78E933EC4BE
	for <lists+io-uring@lfdr.de>; Sat, 14 Aug 2021 21:32:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229499AbhHNTcz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 14 Aug 2021 15:32:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbhHNTcz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 14 Aug 2021 15:32:55 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93EBEC061764
        for <io-uring@vger.kernel.org>; Sat, 14 Aug 2021 12:32:26 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id b13so17912500wrs.3
        for <io-uring@vger.kernel.org>; Sat, 14 Aug 2021 12:32:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:subject:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=vCzeQkJ8Oacu7IKxUVczhyKgo7nJ+vfKp3dhG6HxDOA=;
        b=rxvifbR1I0Ekx9qJ4M26CrSa5hJIcrrYf5xdjlJzAjm4HLYFqkNN0tRG1YLtiW24nl
         5jj9ZLXod3u3VzD6QxnCFxrVMZZBJRE0wBwpaBVOe9VrewUNmKb/ElY23ker2oilpvq2
         ls9Sl7AWvVcl9yw9jScJZZbEVZ6Si0YSS69lY19uYIpsbCNPwn4Ba8NbmVXnyUx61UM9
         vbqhHtNhZNmMLirLar9bj5hJ6DTsdOY5C0RPO7pGP7pgTiUEXka8TkOQqQUFYHkXCqHx
         LfviFJ8uhWnikQHEkXhcYSZwnePUzM2hHV+1Kvw/rh6Zj5cWj28uBcvECQ3fH6YuiiF1
         HJ8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vCzeQkJ8Oacu7IKxUVczhyKgo7nJ+vfKp3dhG6HxDOA=;
        b=gZqVzc+Wa6AWi/5gvVGaro3PlJh2TEnVJ3c9d1x1XItw237C97rxUz3k+WYTaeOCHy
         FSmYlFXJAXbyDjgCyrpXlzZ5A8Sl+6tTnmt0RTh0F5EZeh/cOSd6wEY7tq9qtwKO3ZVo
         cqnyg39NWWAc89uq8bjgBA0UhBmiMJDrbl0o5a0dQhxk0Epc08mCJzwmNcCFJLSEfOlx
         SyadxczACBokASYv1CLLdr3qg9tvdyGEQsIomtQ5kPfQFdrmnE3sHwBPmnzvpXxBdYQl
         lELAKHbsv9D29jkKTpNCt0Jnk/gB3UQfPFS+Rfr4PByWeBytJsoSfEJl+hxG5mKoLRgq
         nntg==
X-Gm-Message-State: AOAM530ZVCHVm2l6KQIn2BTZYMWC4Q+WtWDGY/ljrxQXW6Dbq0OZoNjU
        DEaeRa3/O9I5XuZ+oU2beXx0w0kEynQ=
X-Google-Smtp-Source: ABdhPJyLoLX2YwW6MrvSquKzjmZE8Sak14VYQVraz0jP0WokND7wtyMsw7uzhVNz44Duokb1j4qL0Q==
X-Received: by 2002:adf:bb85:: with SMTP id q5mr9529292wrg.186.1628969545076;
        Sat, 14 Aug 2021 12:32:25 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.133.97])
        by smtp.gmail.com with ESMTPSA id f17sm5672190wrt.49.2021.08.14.12.32.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 14 Aug 2021 12:32:24 -0700 (PDT)
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1628957788.git.asml.silence@gmail.com>
 <3243f06098128ce6587b3fbfdddeb1f63e21f418.1628957788.git.asml.silence@gmail.com>
 <cbd8801a-49b3-f74d-68a7-cb629497aecd@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH 1/5] io_uring: optimise iowq refcounting
Message-ID: <3cc5ed43-d3ba-a3a9-8bf2-13fb5a81bcf8@gmail.com>
Date:   Sat, 14 Aug 2021 20:31:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <cbd8801a-49b3-f74d-68a7-cb629497aecd@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/14/21 8:13 PM, Jens Axboe wrote:
> On 8/14/21 10:26 AM, Pavel Begunkov wrote:
>> If a requests is forwarded into io-wq, there is a good chance it hasn't
>> been refcounted yet and we can save one req_ref_get() by setting the
>> refcount number to the right value directly.
> 
> Not sure this really matters, but can't hurt either. But...

The refcount patches made this one atomic worse, and I just prefer
to not regress, even if slightly

>> @@ -1115,14 +1115,19 @@ static inline void req_ref_get(struct io_kiocb *req)
>>  	atomic_inc(&req->refs);
>>  }
>>  
>> -static inline void io_req_refcount(struct io_kiocb *req)
>> +static inline void __io_req_refcount(struct io_kiocb *req, int nr)
>>  {
>>  	if (!(req->flags & REQ_F_REFCOUNT)) {
>>  		req->flags |= REQ_F_REFCOUNT;
>> -		atomic_set(&req->refs, 1);
>> +		atomic_set(&req->refs, nr);
>>  	}
>>  }
>>  
>> +static inline void io_req_refcount(struct io_kiocb *req)
>> +{
>> +	__io_req_refcount(req, 1);
>> +}
>> +
> 
> I really think these should be io_req_set_refcount() or something like
> that, making it clear that we're actively setting/manipulating the ref
> count.

Agree. A separate patch, maybe?

-- 
Pavel Begunkov
