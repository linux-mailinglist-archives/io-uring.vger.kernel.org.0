Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92EDF2F7A76
	for <lists+io-uring@lfdr.de>; Fri, 15 Jan 2021 13:50:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387975AbhAOMty (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 15 Jan 2021 07:49:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731676AbhAOMtr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 15 Jan 2021 07:49:47 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 968C5C0613C1;
        Fri, 15 Jan 2021 04:49:06 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id q18so9179551wrn.1;
        Fri, 15 Jan 2021 04:49:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=BZmP1N8NHiWo0hMS7ibtEyx/S5S9oAI6P5STenSLxNc=;
        b=LRN60KTGuZVnKBXm/GlsReHZIrHL2iVu1AdTOThCfB9UZomLUZ7ZfM016HntNPtxLX
         IQJ3gda1A+xeHGY6n5AzmpMBikB4LlqFbtZuyYnFuhdiDrT+Rqw9l9Crh5wfi/VVVHQu
         Db/am016psjgGkBns4axCwMjv21N15cpDUmWwboAqMir9HzIbR5+pYhL6jccKa4jdJNh
         rLZ/Sq9z1NW/SItPNKV3LLLMaQmUBFB3JSU2ZpFSqpBJT4e16LkRWekhiBLp/PnTEqC5
         ZfEkf8QkFmXwW8FdBHzOUuyra7VzDKsPbcVoUaGwcgDlfTYrhSDM4ROsh7YXaANRgLpQ
         7OGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=BZmP1N8NHiWo0hMS7ibtEyx/S5S9oAI6P5STenSLxNc=;
        b=nc/2kNxojBphrRdFgr9Ne2RIpuqcjVvKnDsFzzXduFSa603ohVXfRKuH8w8+SNPeqV
         iG+5nenvqjMoTpV/kqU1pSWc0dCtlmHAAnHCfBapaWp916vRvZ40SQESlVTH8rA0jBHE
         E038g6CC46UOhPg61dFDfVZJlPUVNqD/RMWYOqJ/xC5VYghrCnObtlr7XVS6puYXYKuL
         4Mcl69Fb+ku10Vp0f+d9731Nl6S6+WueeRm5iybHg3mmyy802aUF3eAO+xIwvgjr8Hq+
         yG9GDBuMTbjcacFfAKaA7m+PtSKuzA1sbwMHux4E9OENY2AOK/RljAEC6sl8CQBWpVC9
         ihKQ==
X-Gm-Message-State: AOAM533izzHialTtKHOtKpw+WwYy3SE00I0MyScacEpJZA3s+vf547lO
        MO+UEaZm0D20tMkZSnG1+EiACBY3gEwehg==
X-Google-Smtp-Source: ABdhPJwBC2zkxcKMTi9n7gLDlixHm09B2RCCiM51uCvIyXc69vjIovoEKWSaZYHIzUmurFLswSLbMw==
X-Received: by 2002:adf:c444:: with SMTP id a4mr9509258wrg.164.1610714945428;
        Fri, 15 Jan 2021 04:49:05 -0800 (PST)
Received: from [192.168.8.123] ([85.255.233.192])
        by smtp.gmail.com with ESMTPSA id z6sm15061897wrw.58.2021.01.15.04.49.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Jan 2021 04:49:04 -0800 (PST)
Subject: Re: general protection fault in io_disable_sqo_submit
To:     Hillf Danton <hdanton@sina.com>
Cc:     syzbot <syzbot+ab412638aeb652ded540@syzkaller.appspotmail.com>,
        axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <000000000000006c2105b8c5b9b9@google.com>
 <20210114074017.1753-1-hdanton@sina.com>
 <20210115093331.209-1-hdanton@sina.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <a32cf443-3261-53ce-aeba-b49e93e6f9d8@gmail.com>
Date:   Fri, 15 Jan 2021 12:45:29 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20210115093331.209-1-hdanton@sina.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 15/01/2021 09:33, Hillf Danton wrote:
>> Thanks, but it was fixed the day before
>>
> It helps much if you can add a link to the fix next time.

https://git.kernel.dk/cgit/linux-block/commit/?h=io_uring-5.11&id=b4411616c26f26c4017b8fa4d3538b1a02028733
https://git.kernel.dk/cgit/linux-block/commit/?h=io_uring-5.11&id=06585c497b55045ec21aa8128e340f6a6587351c

sure, for this report and the other report 

> 
> Apart from that, I do not think it is a complete fix yet - it only
> fixes what Reported-by: syzbot+9c9c35374c0ecac06516@syzkaller.appspotmail.com
> though correct, but the one-line fix is unable to cover this report,
> as per the Call Trace in both reports.
> 
> Feel free to double check if what you trimmed fixes both reports.

I believe they do (when considered together).

-- 
Pavel Begunkov
