Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25F802F71B1
	for <lists+io-uring@lfdr.de>; Fri, 15 Jan 2021 05:47:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728000AbhAOEq3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 14 Jan 2021 23:46:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726019AbhAOEq2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 14 Jan 2021 23:46:28 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC03CC061575
        for <io-uring@vger.kernel.org>; Thu, 14 Jan 2021 20:45:47 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id w5so7931683wrm.11
        for <io-uring@vger.kernel.org>; Thu, 14 Jan 2021 20:45:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GcOw3u1r/FUZoHK/B7jeC1xQaZi7DaC/UohQm/HomZs=;
        b=Roc9W6efOMgQfmilPFqs/D1KsxVJa4jYDUEZsMxywSb3dMhWeSLwYPjPwRMqqivrwV
         pg8RuHUvkGu8lRQYyiIj6vUbaU+LJDHAb2mHEAeLd5f8OiNyt09kw5NNA6N+Hn5cbNAE
         SWB8RmeFw9iainRotfbd464acxyBo0cFwIczkp+H1qrkTAiFl5OCsSL0H6Kyn4hxGHM1
         dvIbwCCFZddCPQ+qSVCWpurjmtvQlLOsFResQEUseZOSufk/vKM+ZNZWrwZUW72k5M1l
         ezI3rdB3aYoPMS57lstK2SYDU4MRS7d3XnOwZrhnaRWowV2jSLBxtlG8dcB8/XND6hCF
         oR1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GcOw3u1r/FUZoHK/B7jeC1xQaZi7DaC/UohQm/HomZs=;
        b=sJ+U0hU4IhDqXQh0KqSmqCfg9MMIoVMcHg8JMr79LCLhpSJZ2XX6fUYKve1iM6TfDX
         b30FhXHgIOewS+jLM/ZwYLc6+FK8hbXiqux1LoBPw2JNSbWxZk4Z7tIyjJ8snvikYucF
         5/s7D++wvYe3U8FjbGsUI6QGcZn7D2jEGBncqWF0Xv1id+tqAkB2xEvKoDG/bwIkeJoY
         ydZn1JXh76MxfGs3yk0za7gka20WxuBgpbw00S8dmVBYbmu2/fnCE9fK1gR3xXizH4Ad
         okuFeGCVHBakht7g0TwOI6EgnjDM0QcOAm/GXnjiiEbeCvQwbsvK/F7gdC/FnqzvbisZ
         tltw==
X-Gm-Message-State: AOAM53230MZqxeHzqUqxy35+uh486g4JwuRiX+7cEQYicd9GB8bpFZUB
        l45bw7FRG4HJDlSAlN850NLvXlxUVTyslQ==
X-Google-Smtp-Source: ABdhPJyo8Jkm2fEy2L/izDN84e45ZfkAl6Ld8yI/9O39CKFS3e195VIe5rYFxxhtJxy0ap/5QONkrQ==
X-Received: by 2002:adf:fdd1:: with SMTP id i17mr10924719wrs.173.1610685946284;
        Thu, 14 Jan 2021 20:45:46 -0800 (PST)
Received: from [192.168.8.122] ([85.255.233.192])
        by smtp.gmail.com with ESMTPSA id q7sm12711361wrx.62.2021.01.14.20.45.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Jan 2021 20:45:45 -0800 (PST)
Subject: Re: [PATCH v5 00/13] io_uring: buffer registration enhancements
To:     Bijan Mottahedeh <bijan.mottahedeh@oracle.com>, axboe@kernel.dk,
        io-uring@vger.kernel.org
References: <1610487193-21374-1-git-send-email-bijan.mottahedeh@oracle.com>
 <86a8ae2e-78b4-6d8c-1aea-5f169de5aabc@gmail.com>
 <e071e7e5-207b-9595-1de7-82f702864198@oracle.com>
 <50be90bb-1ccf-0266-ff32-f6b72958fdb9@oracle.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <edaf32c5-c73c-3eb2-3c65-ac8a2fc0309b@gmail.com>
Date:   Fri, 15 Jan 2021 04:42:11 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <50be90bb-1ccf-0266-ff32-f6b72958fdb9@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 14/01/2021 22:54, Bijan Mottahedeh wrote:
> On 1/14/2021 2:44 PM, Bijan Mottahedeh wrote:
>> On 1/14/2021 1:20 PM, Pavel Begunkov wrote:
>>> On 12/01/2021 21:33, Bijan Mottahedeh wrote:
>>>> v5:
>>>>
>>>> - call io_get_fixed_rsrc_ref for buffers
>>>> - make percpu_ref_release names consistent
>>>> - rebase on for-5.12/io_uring
>>>
>>> To reduce the burden I'll take the generalisation patches from that,
>>> review and resend to Jens with small changes leaving your "from:".
>>> I hope you don't mind, that should be faster.
>>>
>>> I'll remove your signed-off and will need it back by you replying
>>> on this coming resend.
>>
>> Sure, thanks.
> 
> Do you have any other concerns about the buffer sharing patch itself that I can address?

Not yet, I'll go over it this week

-- 
Pavel Begunkov
