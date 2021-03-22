Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D9DB344855
	for <lists+io-uring@lfdr.de>; Mon, 22 Mar 2021 15:58:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230286AbhCVO5o (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 22 Mar 2021 10:57:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231366AbhCVO5M (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 22 Mar 2021 10:57:12 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F540C061574
        for <io-uring@vger.kernel.org>; Mon, 22 Mar 2021 07:57:11 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id v4so17357959wrp.13
        for <io-uring@vger.kernel.org>; Mon, 22 Mar 2021 07:57:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2jxSe4jqbWZo+DjnR09r9zSnUVs7irZ5I9IDfAkA1jY=;
        b=eEbUyxujRiD5KVwA8CHxxK8HWf2v+yVh7N0+2HmybDo1c3yxLKgCU2yhZuN3SaqVgX
         BpX83baMAnuJfh7oOtp83rW2heTt9lzA9/vwmcIJiNLM0R8GJdNa4wleFyK5SQGGjFOr
         bzY/jIsH8KrbwjWNYRfnJdjZycjliZ1WSpXQvepmKztF6s8+drGN4DNJIuVh/yJmtGa7
         JS+DZFG1UK/ZnRpr6DiIxY914AXhNTtndPTVr0XgVxCGaJ+QGdge8LuGs4E+XmCv2JRc
         LALfPA2HmYvRWTPrHw379OHFg6rBUCHjuXImxxC/n2moapQsu/04KEHiH+CKepU0eQkO
         elFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2jxSe4jqbWZo+DjnR09r9zSnUVs7irZ5I9IDfAkA1jY=;
        b=ccPEnJBCZlRZuSxK7vtGhBKx2o/QmdFTV6aOxUwf8yfdUfSBQ1K+pXTG19pCRx2gWR
         Ih2aWVTPtWhOakEsfFvl83hLHJzFa4QqYmtEmxIAOped95yc1VmPGBZt02+f7iHZ+vTi
         tveqneSFYhYHb57czdQEtW5tgm8NHeXNyX+EA1ea16gcDttOkQBtFoHlYaf/im45schu
         ETEZ6PYO/cDdPeq0mvBEdz0F9s/XZ7lHEEg3zZ2wftxY2ipxgMEKYxUPO91upEwUvES4
         MM0m4LDf0+awVvOgaGTvNKYRqg5QMtoAzcu6tFxHtuFHEV9TOKiit0mp+5HtAFBOKwAM
         Q5Vw==
X-Gm-Message-State: AOAM530RIMjD8xK4Gg1JM2+Os5wQ54/w4LIljOeyz6pdxpfIjDlGqsXN
        6B/aKpuU+u4U2u1Ii1NkLQLxqaraHuAfig==
X-Google-Smtp-Source: ABdhPJxF7P/1kTYHkiWhu+ScfwlphLEXXpSQGLdqargfOBZZWTY1akRS0GVc69uGppnR2OM0yUd5mA==
X-Received: by 2002:a5d:4fd0:: with SMTP id h16mr18250397wrw.178.1616425029579;
        Mon, 22 Mar 2021 07:57:09 -0700 (PDT)
Received: from [192.168.8.179] ([85.255.234.182])
        by smtp.gmail.com with ESMTPSA id u9sm16288426wmc.38.2021.03.22.07.57.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Mar 2021 07:57:09 -0700 (PDT)
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1616378197.git.asml.silence@gmail.com>
 <ff3273b5111fdb10eea0e3d4f81f620fb58c5a5b.1616378197.git.asml.silence@gmail.com>
 <e8da4108-21a1-62b4-5556-bc9208e930f3@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH 03/11] io_uring: optimise out task_work checks on enter
Message-ID: <75e9acac-7fb7-747c-9832-3abcd0dfdfd9@gmail.com>
Date:   Mon, 22 Mar 2021 14:53:08 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <e8da4108-21a1-62b4-5556-bc9208e930f3@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 22/03/2021 13:45, Jens Axboe wrote:
> On 3/21/21 7:58 PM, Pavel Begunkov wrote:
>> io_run_task_work() does some extra work for safety, that isn't actually
>> needed in many cases, particularly when it's known that current is not
>> exiting and in the TASK_RUNNING state, like in the beginning of a
>> syscall.
> 
> Is this really worth it?

Not alone, but ifs tend to pile up, and I may argue that PF_EXITING in
the beginning of a syscall may be confusing. Are you afraid it will get
out of sync with time?

-- 
Pavel Begunkov
