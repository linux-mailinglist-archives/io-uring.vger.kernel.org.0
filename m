Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 163F3550C9A
	for <lists+io-uring@lfdr.de>; Sun, 19 Jun 2022 20:51:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229902AbiFSSvV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 19 Jun 2022 14:51:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236367AbiFSStt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 19 Jun 2022 14:49:49 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 573D5A194
        for <io-uring@vger.kernel.org>; Sun, 19 Jun 2022 11:49:48 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id p6-20020a05600c1d8600b0039c630b8d96so5738606wms.1
        for <io-uring@vger.kernel.org>; Sun, 19 Jun 2022 11:49:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=WPg2MMEkQbcJZeLQnAsm+bl1sGhpEXny0yMNFejTcOI=;
        b=MWc0S9K3rDebEcRB92c2o+QoGCEwE0iNL7LR2LlvtwspPEkaQqK0f2newEmSwliDw4
         Hv+z7GKIQGp9VlBftC4gBHwi/o8uftRn+nfgVBO+5cHkjzQAiuiudDXxmrv+nXH0nsgR
         ylNOW/WXkEFqVmrSgWmZpDLwzivBDem6amQh2q63EQNK8dqGO+Gr+SSRwz07D8D/fAyk
         6bqMBnwJPTjDNxKuHWIQ8tPQ39uGjis0uD8UUYJ6ZYubeEweiRy8vYWBzQbjVwTJ+Lb+
         UjtkZFedUrdn/TcjFJ2PYcsiNjPjmimVBtCs3u79NkDZ+WuL5wCVznrcL/CmzAMhu4vK
         DuBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=WPg2MMEkQbcJZeLQnAsm+bl1sGhpEXny0yMNFejTcOI=;
        b=IXEEUve1NYO08+5u2PRIf1FGElKted53UJ0rK+r05FC0Euxp2nc7AQVgoAxhEvIkXG
         7dCaKVHbuviTn8Q4ihIm7waT9TFoXEKdENw/vXmc85dyVGyFGtgaXi2reUu5YZtJ1Yca
         /uMw9rPfNnY3hytvSL8Mmjz9Swd6jR/NLXNN9kMoGRZZ3F+nbyW1J3c0j0zfySTT5e6n
         LKdb4N98LtcYLRs+9NeOzfPtmE5gXdxUaTfC7Cjd+xckmmYbQ49oLXca9MI5T+Mw1vzc
         JPS5T66njGr4mnJRXIR2VLl2OBN9SitlgNf8U4L2uA3ASZLTvfexXMrtfKDIzTBrprZs
         01/g==
X-Gm-Message-State: AOAM531+zU4dVYV/6AYHN5dFe6RxGfly/CxhxC8dICBAXgwUTkdEsSEE
        mTP2v07pFRY8qPBfZdOf7F0=
X-Google-Smtp-Source: ABdhPJwEJuDuDFVEfgrf7cQhfltKtftZ4AYcrHy6AUonFRQ4edLXPKaGTZnEShmNqeYAKg4CL8nH9w==
X-Received: by 2002:a05:600c:10cf:b0:39c:8270:7b86 with SMTP id l15-20020a05600c10cf00b0039c82707b86mr31752014wmd.180.1655664586829;
        Sun, 19 Jun 2022 11:49:46 -0700 (PDT)
Received: from [192.168.8.198] (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id n16-20020a5d4850000000b0021b829d111csm6763270wrs.112.2022.06.19.11.49.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Jun 2022 11:49:46 -0700 (PDT)
Message-ID: <c379905c-ceba-d8f7-a656-1c415b736a1e@gmail.com>
Date:   Sun, 19 Jun 2022 19:49:05 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH for-next 4/7] io_uring: hide eventfd assumptions in evenfd
 paths
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>
References: <cover.1655637157.git.asml.silence@gmail.com>
 <8ac7fbe5ad880990ef498fa09f8de70390836f97.1655637157.git.asml.silence@gmail.com>
 <93f51361-c198-0286-b0ea-3b30f684f633@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <93f51361-c198-0286-b0ea-3b30f684f633@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/19/22 19:18, Jens Axboe wrote:
> On Sun, Jun 19, 2022 at 5:26 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>
>> Some io_uring-eventfd users assume that there won't be spurious wakeups.
>> That assumption has to be honoured by all io_cqring_ev_posted() callers,
>> which is inconvenient and from time to time leads to problems but should
>> be maintained to not break the userspace.
>>
>> Instead of making the callers to track whether a CQE was posted or not,
>> hide it inside io_eventfd_signal(). It saves ->cached_cq_tail it saw
>> last time and triggers the eventfd only when ->cached_cq_tail changed
>> since then.
> 
> This one is causing frequent errors with poll-cancel.t:
> 
> axboe@m1pro-kvm ~/g/liburing (master)> test/poll-cancel.t
> axboe@m1pro-kvm ~/g/liburing (master)> test/poll-cancel.t
> Timed out!
> axboe@m1pro-kvm ~/g/liburing (master) [1]> test/poll-cancel.t
> Timed out!
> axboe@m1pro-kvm ~/g/liburing (master) [1]> test/poll-cancel.t
> Timed out!
> 
> I've dropped this one, and 6-7/7 as they then also throw a bunch of
> rejects.

I mentioned it in the cover letter, extra wake ups slowing task
exit cancellations down, which make it to timeout (increasing
alarm time helps). The problem is in cancellation, in particular
because for some reason it spins on the cancellation (including
timeout and poll remove all).

I'll look into it, but it's rather "discovered by accident"
rather than caused by the patch.

-- 
Pavel Begunkov
