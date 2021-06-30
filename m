Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34F963B8A15
	for <lists+io-uring@lfdr.de>; Wed, 30 Jun 2021 23:20:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233799AbhF3VWg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 30 Jun 2021 17:22:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbhF3VWg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 30 Jun 2021 17:22:36 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9552BC061756
        for <io-uring@vger.kernel.org>; Wed, 30 Jun 2021 14:20:05 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id p10-20020a05600c430ab02901df57d735f7so5403664wme.3
        for <io-uring@vger.kernel.org>; Wed, 30 Jun 2021 14:20:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=2a2+UPWPscNfwHHGfujCkxvCiBZOZxPdETae7h6hg20=;
        b=LFYV0cJujqkOuQ20pCLB5j3JkLqOKdMoKzviTiFvQqdRvQvJK/EOIGtK/134t3I+sV
         TUDASFk+vYMYKEeQcy7N2YY6QNDlUYJ4baNkBAmYrMsbJGoYjwe5shpqItql6IIRFIGB
         /KtL5kJWTdZPqUSsCj48ntRr+WkZ/h2imsGtsNut74lBQROHa7RL4eav5N7G1kec1dSL
         c23YyhP17Fn9PSAIk7dTNpUR1W5gtccImKShH0+/ULv4hwj8Yyn+dsQ4VC5mB8iMERp3
         f2vnYn4QbLucLXt1dM5pabzW+F1JTnRM3CizJ3uebNTuh2vO7jg8V+zjUMjlZgQzkHBN
         zcaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2a2+UPWPscNfwHHGfujCkxvCiBZOZxPdETae7h6hg20=;
        b=ixpS3IlZOAid71286YDPX9x/AUBicqppg33369/bklMA7IiI8UcGeXSpu7ABB64sTM
         rF3PNdv2fl/cjbEA7xMIEsYIDoC2iB+xZ3xSt9f4qAwaHu+O5AQGsiO5rwLM25DZrcZ0
         xn9NxbcIRtD7hUkpCDW/qykLcmnc2hxTNCFq94PpGqHcZ9QQtir3nNpapxK+2hw/6kjK
         xH+VNqNwjKC19sQoW+6MMkur2XIS9W1qmi+SMtT2icKaMLwqX/7fKYuNHd40H9fE3S9N
         EufOIsVYJ1OqBbxMZDgZUECoUbx7Rl0RQ/bFzSU4OkerjUUfqmnSk2R+eS61InrHFJg2
         nZ7Q==
X-Gm-Message-State: AOAM530w1WbqQB4r8/DOFHOlZ+bCpmcuu+GB4ircynzoxOdM2VCVrO8H
        Qqregg0YxXcsB35iEx8axfKZZRbDYAwHvtT+
X-Google-Smtp-Source: ABdhPJy7H25qqd83xY0Js72jfGUeVkLKqCATIO42eqSSXimI/aEZhIkqhbaOXzkmYKUju+3goxFNHQ==
X-Received: by 2002:a1c:4c14:: with SMTP id z20mr12495725wmf.146.1625088004105;
        Wed, 30 Jun 2021 14:20:04 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.233.185])
        by smtp.gmail.com with ESMTPSA id n12sm14712113wrs.12.2021.06.30.14.20.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Jun 2021 14:20:03 -0700 (PDT)
Subject: Re: [PATCH 3/3] io_uring: tweak io_req_task_work_add
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1625086418.git.asml.silence@gmail.com>
 <24b575ea075ae923992e9ce86b61e8b51629fd29.1625086418.git.asml.silence@gmail.com>
 <70c425a8-73dd-e15a-5a10-8ea640cdc7cd@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <d7f587b1-67bb-fc67-1174-91d2c8706b42@gmail.com>
Date:   Wed, 30 Jun 2021 22:19:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <70c425a8-73dd-e15a-5a10-8ea640cdc7cd@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/30/21 10:17 PM, Jens Axboe wrote:
> On 6/30/21 2:54 PM, Pavel Begunkov wrote:
>> Whenever possible we don't want to fallback a request. task_work_add()
>> will be fine if the task is exiting, so don't check for PF_EXITING,
>> there is anyway only a relatively small gap between setting the flag
>> and doing the final task_work_run().
>>
>> Also add likely for the hot path.
> 
> I'm not a huge fan of likely/unlikely, and in particular constructs like:
> 
>> -	if (test_bit(0, &tctx->task_state) ||
>> +	if (likely(test_bit(0, &tctx->task_state)) ||
>>  	    test_and_set_bit(0, &tctx->task_state))
>>  		return 0;
> 
> where the state is combined. In any case, it should be a separate
> change. If there's an "Also" paragraph in a patch, then that's also
> usually a good clue that that particular change should've been
> separate :-)

Not sure what's wrong with likely above, but how about drop
this one then?

-- 
Pavel Begunkov
