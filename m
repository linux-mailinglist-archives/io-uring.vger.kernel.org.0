Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 021F91A694B
	for <lists+io-uring@lfdr.de>; Mon, 13 Apr 2020 17:59:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731184AbgDMP7u (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Apr 2020 11:59:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731168AbgDMP7t (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Apr 2020 11:59:49 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D9DEC0A3BDC
        for <io-uring@vger.kernel.org>; Mon, 13 Apr 2020 08:59:49 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id kx8so3946812pjb.5
        for <io-uring@vger.kernel.org>; Mon, 13 Apr 2020 08:59:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nBFhPzIXBSJrJJdoQyx4L5yfqa4IzBpM/NoCB7krEng=;
        b=xWUFcy13dQjL5/Tc9nUBROsGDCevCSMnRzWVMAeQR8gDvtTK5PU68Imfvz7NY+UGip
         6zfZiDVplWRf8SrV3dvqKCho2yB+pVnHSmLZ8mMefjAN41oDh0sn8OPJGtC3s3/LqGjv
         /8/LAURLJSNHNDpoq419Q6wBnaoviFC8B1zTQ0IKIwXQHduqbiyRun0kde2F78LVb8TW
         RRvnUsPBQJ1HoxhsDdBdpl9XEYpFxg3t0toWdje3hlXbj1oAnwr8QyoZc/+m61PgC0iK
         iBMps3tv5Rv62kmmncto6D4i+zXnvedttBn3dE0/PwOsiSWfT2He6tdBXa8NXn48Iw08
         93zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nBFhPzIXBSJrJJdoQyx4L5yfqa4IzBpM/NoCB7krEng=;
        b=d1Uiixoq8egrDgwlbIy9m5/QBWUOP02rHlFii8J+3b2182ApgKNnekSk8ktaVfDJCq
         GDbFrS9hwaq/RwBt11QL3VlEC/LB2QkZ2fgweDi/TBYnoHTTt4YpYaOd7BhMG3sAt6Dz
         YQyzkIoXp6Q0DoOhVAZg/tq1TiBg5gCHXBior4F2l3Ob8EcFUPTVNq+L5tnCHqQfWRE8
         bX384ve5Ulx93Yhi6WBCQwj6DlBOna2vYdMg7TiG1pifgqB3u0eFwRwrp9jYo7PykrZK
         qoyTIjUl2r0eaER7U+5OFrMLdMKofxbNZteV3nfOGhsfg3IjY8E8bc1tZPGtOqRNNunQ
         /ouw==
X-Gm-Message-State: AGi0PuZkcz01vraxfXbiD3IMKGnqLI+N+Ig61Baz5yFevcmFk6e016VV
        HBL0XJk1/mcogXTOoSkhKck0sw==
X-Google-Smtp-Source: APiQypLkoKPgybzDuTZWsqiyx9DzJ/Z4lyhiEmvQKVYf8tdTVu+3O3igtT1eunnVoJ6potxV4H1cmA==
X-Received: by 2002:a17:90a:57:: with SMTP id 23mr19438971pjb.168.1586793588426;
        Mon, 13 Apr 2020 08:59:48 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id x7sm6836164pjg.26.2020.04.13.08.59.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Apr 2020 08:59:47 -0700 (PDT)
Subject: Re: [LIBURING PATCH] sq_ring_needs_enter: check whether there are
 sqes when SQPOLL is not enabled
To:     Hrvoje Zeba <zeba.hrvoje@gmail.com>
Cc:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org, joseph.qi@linux.alibaba.com
References: <20200413071940.5156-1-xiaoguang.wang@linux.alibaba.com>
 <949512f3-9739-5514-2daa-1ee224d85b90@kernel.dk>
 <CAEsUgYh9QHgfo2RfnAupOVu+BO5rDnQjU+78SnBTuiHtECHpqQ@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <0fba5ff2-5efe-06f5-704b-e8e08346374b@kernel.dk>
Date:   Mon, 13 Apr 2020 09:59:46 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <CAEsUgYh9QHgfo2RfnAupOVu+BO5rDnQjU+78SnBTuiHtECHpqQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/13/20 9:46 AM, Hrvoje Zeba wrote:
> On Mon, Apr 13, 2020 at 11:29 AM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 4/13/20 1:19 AM, Xiaoguang Wang wrote:
>>> Indeed I'm not sure this patch is necessary, robust applications
>>> should not call io_uring_submit when there are not sqes to submmit.
>>> But still try to add this check, I have seen some applications which
>>> call io_uring_submit(), but there are not sqes to submit.
>>
>> Hmm, not sure it's worth complicating the submit path for that case.
>> A high performant application should not call io_uring_submit() if
>> it didn't queue anything new. Is this a common case you've seen?
>>
> 
> My code calls io_uring_submit() even if there are no sqes to submit to
> avoid spinning if there's nothing to do:
> 
> ...
> uint32_t sleep = (gt::user_contexts_waiting() > 0) ? 0 : 1;
> auto res = io_uring_submit_and_wait(&m_io_uring, sleep);

If you're calling with wait, then an sqe will be submitted with a
timeout operation. So that use case is fine. Or waiting in general.
But calling with {0,0} for {submit,wait} would be kind of silly.

-- 
Jens Axboe

