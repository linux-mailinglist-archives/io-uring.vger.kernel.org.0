Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E66CC29408E
	for <lists+io-uring@lfdr.de>; Tue, 20 Oct 2020 18:32:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394700AbgJTQca (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 20 Oct 2020 12:32:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394634AbgJTQc3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 20 Oct 2020 12:32:29 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53FF3C0613CE
        for <io-uring@vger.kernel.org>; Tue, 20 Oct 2020 09:32:27 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id y12so2946617wrp.6
        for <io-uring@vger.kernel.org>; Tue, 20 Oct 2020 09:32:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=saZ+VpA8/T5K5OIZTukX5Ar9cXG6WHILjaqAIFg6pho=;
        b=UKEahRq+R36lZQ8FEtwEk2lWr2gaA4fNo3qlAmLeOrEqE8k7chp6OtoHzJH5ksreaJ
         Nh7cW2Ili1AAwlpAp/eOwSh+QjEzVoNfcFv5MwrXdTHWGrkW7+l6TJQUPmKys90KHHF/
         YIL+O30Rbco1qECmuzvN5yRAbBj6UYuMcRLIceJ+o+yZnEd8L2IRXRnAj7xBjOSH0xkF
         9/uViviM1WXuSX4sxQr/vVMq38IaR6J0fwHEWf50jfodv177OYjFqYZKctswQ+r/m/bT
         4ELTNPty9vnRhoXU5di5ga4IdFFcdEXXKYEKd7Rx6szYXAtaKIyYY9/ucD6MyStP4P95
         eGDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=saZ+VpA8/T5K5OIZTukX5Ar9cXG6WHILjaqAIFg6pho=;
        b=MD15LNYZW07cLUimLO1Wb+UK2vfYVPr6SbeLna42cMYzzpwj/TkNu+mxbzULCSJVEq
         p1LKRPuMNBvzRdc5v0I8cYnA2e7Ng3lwNz6EV8eQReIh2HRyIlzifQwp0IPi7HCE7yY5
         0l7VXNP4tMxnIFsddJaeVmaiVMmESo1AMx//tzqKzgvjv58NHUsWkTE+kLF2mSNpLVNE
         rzo1ZNU008P9xnaVx3Ftwy8aeNM7XaA42BCuwoZDUqpSTeZOWRk0SjX7JG0G8HYHWCCJ
         EBX/UQArljzY/uLgVxl+Xq7v7W3YgRTkBsbRxxZtW+gITUFkV3F+eDumTqv/iPKkkB6Z
         B5Gw==
X-Gm-Message-State: AOAM531cMPkyVGcdQ8Jm55LGgtkNqdqucD8KKptymGFmvF3WaO9kxhQQ
        QTp3cLshaSJZApJUgDaY3hsU49IPK1MtMQ==
X-Google-Smtp-Source: ABdhPJzSWoUs+xrYzb5rz5mp2dd+dEU96BNgIHpGEwN3oOIeFkqHg+4EiRlPCylGeyeHzfpewgHlcA==
X-Received: by 2002:adf:f482:: with SMTP id l2mr4435280wro.26.1603211545803;
        Tue, 20 Oct 2020 09:32:25 -0700 (PDT)
Received: from [192.168.1.182] (host109-152-100-164.range109-152.btcentralplus.com. [109.152.100.164])
        by smtp.gmail.com with ESMTPSA id w11sm3768192wrs.26.2020.10.20.09.32.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Oct 2020 09:32:25 -0700 (PDT)
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <21aca47e03c82a06e4ea1140b328a86d04d1f422.1603122023.git.asml.silence@gmail.com>
 <ca4c9b80-78de-eae2-55cf-8d7c3f09ca80@kernel.dk>
 <1799a7cf-7443-7eff-37b1-b3bf3f352968@gmail.com>
 <d55aa3c1-7eb4-b3a4-4a34-41d566d5c559@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH for-5.10] io_uring: remove req cancel in ->flush()
Message-ID: <523e6ffa-49f9-e48b-369c-14cae0783b79@gmail.com>
Date:   Tue, 20 Oct 2020 17:29:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <d55aa3c1-7eb4-b3a4-4a34-41d566d5c559@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 20/10/2020 15:09, Jens Axboe wrote:
> On 10/19/20 5:40 PM, Pavel Begunkov wrote:
>> On 19/10/2020 21:08, Jens Axboe wrote:
>>> On 10/19/20 9:45 AM, Pavel Begunkov wrote:
>>>> Every close(io_uring) causes cancellation of all inflight requests
>>>> carrying ->files. That's not nice but was neccessary up until recently.
>>>> Now task->files removal is handled in the core code, so that part of
>>>> flush can be removed.
>>>
>>> Why not just keep the !data for task_drop? Would make the diff take
>>> away just the hunk we're interested in. Even adding a comment would be
>>> better, imho.
>>
>> That would look cleaner, but I just left what already was there. TBH,
>> I don't even entirely understand why exiting=!data. Looking up how
>> exit_files() works, it passes down non-NULL files to
>> put_files_struct() -> ... filp_close() -> f_op->flush().
>>
>> I'm curious how does this filp_close(file, files=NULL) happens?
> 
> It doesn't, we just clear it internall to match all requests, not just
> files backed ones.

Then my "bool exiting = !data;" at the start doesn't make sense since
passed in @data is always non-NULL.

> 
>> Moreover, if that's exit_files() which is interesting, then first
>> it calls io_uring_cancel_task_requests(), which should remove all
>> struct file from tctx->xa. I haven't tested it though.
> 
> Yep, further cleanups are certainly possible there.
> 
> I've queued this up, thanks.
> 

-- 
Pavel Begunkov
