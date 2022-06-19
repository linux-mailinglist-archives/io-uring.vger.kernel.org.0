Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8700550C9F
	for <lists+io-uring@lfdr.de>; Sun, 19 Jun 2022 20:59:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233641AbiFSS72 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 19 Jun 2022 14:59:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234474AbiFSS66 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 19 Jun 2022 14:58:58 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC086BC8F
        for <io-uring@vger.kernel.org>; Sun, 19 Jun 2022 11:58:56 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id h34-20020a17090a29a500b001eb01527d9eso7503503pjd.3
        for <io-uring@vger.kernel.org>; Sun, 19 Jun 2022 11:58:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=aWCqrfYranALXbVCw/1CxkzhJEAtmpOsa3ySSbedCFw=;
        b=PVZqVg41ilcKaeM4K69r/rlpS7H2Mr/O/X9sHpGb7YIyHLwUMd7xDidMTbzR51ZAuT
         a9Qjs+X/TmKEmqOsSV0cI3P44o07+qZ/kty9sSCabY9LlRnRlMxggszk8jHggQ5klMtc
         7yABp/pYg5NOeg2GjVS2HTZLaqa1HK70CnmO/qYsVfLM8osBbGk/ZKg3iuUuM74ccHNc
         JTzkH1olKzqTk+cjhofsq6N5pwpPNUGHkkJaiZiA9ynPVX0V2a2hxLx1cnQOsX/Gi9JI
         DeD7ZI7wkTGwvg5VmDgtIDSTmrfvPCnqBI2Jp7Nll6KO2/URef5f0ZrVbOQnotjvAB9N
         7e+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=aWCqrfYranALXbVCw/1CxkzhJEAtmpOsa3ySSbedCFw=;
        b=NI7u84sZYs9ppBlrEdUM83FvHdUlq7U75pDiiWdP/C88fEbF6DRVXMBbbVZeSB1PEk
         llj74cRSKbNOh6K6J9AudUF076hcnTT57PF+ivk8Nbo4yX997UdTJTmfGqu6WlSDpfhd
         LDHGIO/GrziKfhlr/6+6T8ymIqrPAZGkgxMakIR0JP4FBWbL8drN4ZbrfNVYv97bq6X8
         lyJGfNeyG6SWc0OJFpfFeKdXLQ3qVxh0st+mfpcbe2t6950hGtM9c2LRJO1IYRnxm70N
         fKYJyGtbEeASM1AVa6rZklI7NEQl4uVDTbSumau5UKK5HQmk2uTGOqw2/L6VHwBvjgut
         UtVA==
X-Gm-Message-State: AJIora/tjyUFrd7ab/VBnXP/x1L6i+ptbHRv5wTxYrNWYSpgr+5Q7MXE
        xpHAXlx8XppOWGr/NNiVJ0jkUZ4eufQCEw==
X-Google-Smtp-Source: AGRyM1ts24wzxz/dUHRxDAX2Tge7tvHWwU06gy67ra39U6U4rCcnuNK7bqrbK1GZbV2Mo8ngKRqpDg==
X-Received: by 2002:a17:902:7b8b:b0:168:a7d0:ddf3 with SMTP id w11-20020a1709027b8b00b00168a7d0ddf3mr20842070pll.118.1655665135987;
        Sun, 19 Jun 2022 11:58:55 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 201-20020a6217d2000000b0050e006279bfsm7580441pfx.137.2022.06.19.11.58.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Jun 2022 11:58:55 -0700 (PDT)
Message-ID: <74c4e532-d999-c2f3-bb01-87dbb02b4cb1@kernel.dk>
Date:   Sun, 19 Jun 2022 12:58:54 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH for-next 4/7] io_uring: hide eventfd assumptions in evenfd
 paths
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring <io-uring@vger.kernel.org>
References: <cover.1655637157.git.asml.silence@gmail.com>
 <8ac7fbe5ad880990ef498fa09f8de70390836f97.1655637157.git.asml.silence@gmail.com>
 <93f51361-c198-0286-b0ea-3b30f684f633@kernel.dk>
 <c379905c-ceba-d8f7-a656-1c415b736a1e@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <c379905c-ceba-d8f7-a656-1c415b736a1e@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/19/22 12:49 PM, Pavel Begunkov wrote:
> On 6/19/22 19:18, Jens Axboe wrote:
>> On Sun, Jun 19, 2022 at 5:26 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>>
>>> Some io_uring-eventfd users assume that there won't be spurious wakeups.
>>> That assumption has to be honoured by all io_cqring_ev_posted() callers,
>>> which is inconvenient and from time to time leads to problems but should
>>> be maintained to not break the userspace.
>>>
>>> Instead of making the callers to track whether a CQE was posted or not,
>>> hide it inside io_eventfd_signal(). It saves ->cached_cq_tail it saw
>>> last time and triggers the eventfd only when ->cached_cq_tail changed
>>> since then.
>>
>> This one is causing frequent errors with poll-cancel.t:
>>
>> axboe@m1pro-kvm ~/g/liburing (master)> test/poll-cancel.t
>> axboe@m1pro-kvm ~/g/liburing (master)> test/poll-cancel.t
>> Timed out!
>> axboe@m1pro-kvm ~/g/liburing (master) [1]> test/poll-cancel.t
>> Timed out!
>> axboe@m1pro-kvm ~/g/liburing (master) [1]> test/poll-cancel.t
>> Timed out!
>>
>> I've dropped this one, and 6-7/7 as they then also throw a bunch of
>> rejects.
> 
> I mentioned it in the cover letter, extra wake ups slowing task
> exit cancellations down, which make it to timeout (increasing
> alarm time helps). The problem is in cancellation, in particular
> because for some reason it spins on the cancellation (including
> timeout and poll remove all).

But that's not really usable at all. Before the patch, the test case
takes 1-2ms, predictably. After the patch, I see lots of 10.0s runs.
That's clearly not going to work.

-- 
Jens Axboe

