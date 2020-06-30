Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A610920F75D
	for <lists+io-uring@lfdr.de>; Tue, 30 Jun 2020 16:38:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389014AbgF3Oi2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 30 Jun 2020 10:38:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731288AbgF3Oi1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 30 Jun 2020 10:38:27 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEC50C061755
        for <io-uring@vger.kernel.org>; Tue, 30 Jun 2020 07:38:26 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id a1so20887699ejg.12
        for <io-uring@vger.kernel.org>; Tue, 30 Jun 2020 07:38:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=SYE28NPJleCQ9h3BxDS59qCgqxrfh+Kqebo57smsTQ8=;
        b=OCguqQ8l6cfvjnAXFDYxK46zX8J0vxVUvQXOkLByk6wutEpZGcnZXEek6/mhW4WeeH
         9UlL5LEaVaTyzbW24LNjezNPV57uP7jzPJT/HBRzF1we8CM0XH+j49M/OLv+S6+/WlFI
         HO1spaqqjzkFEEw1CVx65zs0A+948aRUe+zw3G3crBvC7+FnJsHepzQQ5AElQ4p3x5H5
         opbtgnAjwn6sjTTpfRy8jyVB4IpEIUVvv+gsmJq7rIsuTKUKiiWwn7PY6yGoz23K1Pz9
         OWcsJ3BC6tBSxaGwKFb/bUCEOKLK4EWFQ6expq4BGVlh4OPXXtug3OxB866BgXd39GRt
         kH7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SYE28NPJleCQ9h3BxDS59qCgqxrfh+Kqebo57smsTQ8=;
        b=WeoLuxJifLg+W+CYmE8Aax3NAZiiHbnKbHAWTiHwEwlQ5tXH3ZmhZKVAqLncd3oK63
         WRqCPA7bIEg8nuxpUDeUyoTj7DWgB8o0T5tiHbuf9Lb644F4x/vvpUCeOJ/ySISAPa3G
         4kV9jRmX0Jyajf9TBYDinNzMH92893Bf++unRnJj2L4x6A7awO6UBCiSRvMTlMGyC2Dc
         yC+ryIJ+p2wyUdRNtPJ0HJFnmDl09iyS7NnsXePwfTgRlUvdQKLAhADOVv5AgUqAmNIT
         M2zRVUZH4rkttQERl1pkc28iI553YdbeMcrD+aihfADV/7xxniK3CmF12sqjccQ/BX6z
         ikEg==
X-Gm-Message-State: AOAM532zjCVoTMFTzNn3RnbP5JbHuhzUg2JdA7lC7Mslrd9337Pp53TH
        wkj39l5x/Md3MVN6Wfz/YmbAuDA0
X-Google-Smtp-Source: ABdhPJz10Tzh280XHRa/BTyr2OtJ2hOUo6GsSfZEMQ7kchGUkwWdAExztokraPEn9Of7f9RGTHE4wA==
X-Received: by 2002:a17:907:72cf:: with SMTP id du15mr18052929ejc.151.1593527905298;
        Tue, 30 Jun 2020 07:38:25 -0700 (PDT)
Received: from [192.168.43.125] ([5.100.193.85])
        by smtp.gmail.com with ESMTPSA id c7sm3011092edt.35.2020.06.30.07.38.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Jun 2020 07:38:24 -0700 (PDT)
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1593519186.git.asml.silence@gmail.com>
 <75e5bc4f60d751239afa5d7bf2ec9b49308651ac.1593519186.git.asml.silence@gmail.com>
 <65675178-365d-c859-426b-c0811a2647a3@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH 2/8] io_uring: fix commit_cqring() locking in iopoll
Message-ID: <6c499cf3-418d-2edf-d308-2bb5a8d1d007@gmail.com>
Date:   Tue, 30 Jun 2020 17:36:48 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <65675178-365d-c859-426b-c0811a2647a3@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 30/06/2020 17:04, Jens Axboe wrote:
> On 6/30/20 6:20 AM, Pavel Begunkov wrote:
>> Don't call io_commit_cqring() without holding the completion spinlock
>> in io_iopoll_complete(), it can race, e.g. with async request failing.
> 
> Can you be more specific?

io_iopoll_complete()
	-> io_req_free_batch()
		-> io_queue_next()
			-> io_req_task_queue()
				-> task_work_add()

if this task_work_add() fails, it will be redirected to io-wq manager task
to do io_req_task_cancel() -> commit_cqring().


And probably something similar will happen if a request currently in io-wq
is retried with
io_rw_should_retry() -> io_async_buf_func() -> task_work_add()


I'll resend patch/series later with a better description. 

-- 
Pavel Begunkov
