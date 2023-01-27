Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A16CF67F1F1
	for <lists+io-uring@lfdr.de>; Sat, 28 Jan 2023 00:03:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbjA0XDt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 27 Jan 2023 18:03:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230039AbjA0XDs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 27 Jan 2023 18:03:48 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C525166DE
        for <io-uring@vger.kernel.org>; Fri, 27 Jan 2023 15:03:47 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id z31so4283770pfw.4
        for <io-uring@vger.kernel.org>; Fri, 27 Jan 2023 15:03:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=m2SRkdfehVqUlVEbPV1ol/qzmcbiChj1eXWjlHXA1fM=;
        b=RCilDMKNLv1stf+fIIjMCzYLcvf/WlFkjQXUgux+S6hzeIOXM13Krg3W0kAA0FPb0F
         qRecEq29yCB4KLtXpOfWEeZ1opG1+j+QZ4ADT+5yQRN4qEe/Ff3qm2Ei0ZNFrXCpT/xq
         T/31Uxye9+1PIs4/tfy7NQheNbPVohCb5umlPm8bZ09HvIBt/89llZ9r7iYm/qLJNP5s
         BFFvKB1ZRgo+PsmBsRbrkrrZMs+zJFt9HpGMnrtFIAo8vZKNQlmeulpSirtS8ecjHKGF
         YIrxlVFeKyrWos5yjRaYP26xPvpqRJTqYL2sL1rFPQhKbVUt0mNgtbZxZSoUURJNC0Jp
         yvsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=m2SRkdfehVqUlVEbPV1ol/qzmcbiChj1eXWjlHXA1fM=;
        b=s16Pp9RmIUmIBWZCLQv+adUirmU57Z6Oa5wAQElUyiuzPy/JZ2qZEY7Gjg4xIBUHv7
         6VpNZ0gWIv/CWSHiMLVT++oklZy0sXstHOnGS4gYwbn1WX21hhEoaOj9ZgM+dXxRXGG+
         dlD0Tpbbvzp8+jaTBygyjB8v2D+4WSNrnz8JeTJJKmZmBT0uaI//jRr/pu4mbFjjNmeN
         s1TARq1TaN3JbIKVVpGuzBWocPbU03mqaHkNj9KG+ZdA/juobSPhY6IiLEQmwoaSllX6
         1y98W/otwv3r5KHgoP3+4ly+6ii/EZe60C81R5auba4VZO5Y1Ix5+8tAWUdExfyvZ42C
         ot0Q==
X-Gm-Message-State: AFqh2kpSsLSOpqSksWqMUM1mPTw4wFxwKgaR3EbaWa3XM7oScR1oRWeB
        GLNUhRLlwjw9IqPWhuRr3Ftajw==
X-Google-Smtp-Source: AMrXdXvyKThCnqjfhJIN0WxduTFibCfFlLqpnch3TBi9KvIRWTrTmraSgNE+8+meE778qDikDdlC2w==
X-Received: by 2002:a05:6a00:189a:b0:58d:e33b:d588 with SMTP id x26-20020a056a00189a00b0058de33bd588mr8670778pfh.2.1674860627043;
        Fri, 27 Jan 2023 15:03:47 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id j11-20020aa7928b000000b0058bb8943c9asm3085751pfa.161.2023.01.27.15.03.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Jan 2023 15:03:46 -0800 (PST)
Message-ID: <68b599bb-2329-3125-1859-cf529fbeea00@kernel.dk>
Date:   Fri, 27 Jan 2023 16:03:45 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v1 1/2] io_uring,audit: audit IORING_OP_FADVISE but not
 IORING_OP_MADVISE
Content-Language: en-US
To:     Richard Guy Briggs <rgb@redhat.com>
Cc:     Paul Moore <paul@paul-moore.com>,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, io-uring@vger.kernel.org,
        Eric Paris <eparis@parisplace.org>,
        Steve Grubb <sgrubb@redhat.com>, Stefan Roesch <shr@fb.com>,
        Christian Brauner <brauner@kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>
References: <cover.1674682056.git.rgb@redhat.com>
 <68eb0c2dd50bca1af91203669f7f1f8312331f38.1674682056.git.rgb@redhat.com>
 <CAHC9VhSZNGs+SQU7WCD+ObMcwv-=1ZkBts8oHn40qWsQ=n0pXA@mail.gmail.com>
 <6d3f76ae-9f86-a96e-d540-cfd45475e288@kernel.dk>
 <Y9RYFHucRL5TrsDh@madcap2.tricolour.ca>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <Y9RYFHucRL5TrsDh@madcap2.tricolour.ca>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/27/23 4:02 PM, Richard Guy Briggs wrote:
> On 2023-01-27 15:45, Jens Axboe wrote:
>> On 1/27/23 3:35?PM, Paul Moore wrote:
>>> On Fri, Jan 27, 2023 at 12:24 PM Richard Guy Briggs <rgb@redhat.com> wrote:
>>>>
>>>> Since FADVISE can truncate files and MADVISE operates on memory, reverse
>>>> the audit_skip tags.
>>>>
>>>> Fixes: 5bd2182d58e9 ("audit,io_uring,io-wq: add some basic audit support to io_uring")
>>>> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
>>>> ---
>>>>  io_uring/opdef.c | 2 +-
>>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> diff --git a/io_uring/opdef.c b/io_uring/opdef.c
>>>> index 3aa0d65c50e3..a2bf53b4a38a 100644
>>>> --- a/io_uring/opdef.c
>>>> +++ b/io_uring/opdef.c
>>>> @@ -306,12 +306,12 @@ const struct io_op_def io_op_defs[] = {
>>>>         },
>>>>         [IORING_OP_FADVISE] = {
>>>>                 .needs_file             = 1,
>>>> -               .audit_skip             = 1,
>>>>                 .name                   = "FADVISE",
>>>>                 .prep                   = io_fadvise_prep,
>>>>                 .issue                  = io_fadvise,
>>>>         },
>>>
>>> I've never used posix_fadvise() or the associated fadvise64*()
>>> syscalls, but from quickly reading the manpages and the
>>> generic_fadvise() function in the kernel I'm missing where the fadvise
>>> family of functions could be used to truncate a file, can you show me
>>> where this happens?  The closest I can see is the manipulation of the
>>> page cache, but that shouldn't actually modify the file ... right?
>>
>> Yeah, honestly not sure where that came from. Maybe it's being mixed up
>> with fallocate? All fadvise (or madvise, for that matter) does is
>> provide hints on the caching or access pattern. On second thought, both
>> of these should be able to set audit_skip as far as I can tell.
> 
> That was one suspicion I had.  If this is the case, I'd agree both could
> be skipped.

I'd be surprised if Steve didn't mix them up. Once he responds, can you
send a v2 with the correction?

-- 
Jens Axboe


