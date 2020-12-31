Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BF572E8143
	for <lists+io-uring@lfdr.de>; Thu, 31 Dec 2020 17:44:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727147AbgLaQoi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 31 Dec 2020 11:44:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727146AbgLaQoh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 31 Dec 2020 11:44:37 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7384C061573
        for <io-uring@vger.kernel.org>; Thu, 31 Dec 2020 08:43:56 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id e25so7629833wme.0
        for <io-uring@vger.kernel.org>; Thu, 31 Dec 2020 08:43:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PVQeLYR3P6TdDBlr/Ia+dv2k7rWYEp1E5Czp4zuDSPY=;
        b=pMKdXg1HnAuQI2su4eKsfQtBbBDHaC/1Pl1eMjEUcLjs4MoPLqo0cAqMQEps/1g8IS
         cDlIesLiTiriWWsJTA5TEbi6YuorVboTm23gKlbHeAOe513vay5HyTewK6dTuczOQmCs
         rlQ1TOziBjPaX7hJrbQ4ZXmDsaUIVGoeetZ6iSuJgxzp1UL0bT2OI18S5oTXHz7PWA2t
         Njf7rCS5kCYesAOim234K+7YGM2zyDOJ613E0L979sCigk8hTZqxWQs68CSZ34JXHnhv
         JBORbdkAFuezxyWgRLcKs9ZjmcpxALFGvl3iZof09f04B1pAEN+W0ReNxoN8hqudZ29u
         KmOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PVQeLYR3P6TdDBlr/Ia+dv2k7rWYEp1E5Czp4zuDSPY=;
        b=aUB+HVDwuRKrOBn5GSwuFRfilIWfqnLgNdSkUlQgATQ+C49ZVYRP8U/C/mbGo3jjtA
         xcmNfM1OvYJ6YRy7ewEE0D+om/yomVHJjePLXNFwOGkZUOBHyVm3EHTRyDEofMvuwNoF
         uEz9SZLaBPZRDgZloQ793+ghXJTWRcZskkj379p34VLFCuAod4Fl8ieLK47UqVor2pkf
         ScA37XnRtS2t+Q/D9DaSu5OMKZA8uZDjamUM/X1Kjg31rqM5+v61s8C0GgZWgbRw6J5s
         55u5nGc2G+kUQm/i1SR0Ew/RzZB15D1tDIr2U+fKQPpCZ3SDsSztvO5ueTSwor+RI6Ds
         ahXg==
X-Gm-Message-State: AOAM532D54lzVq3epVS0tz3F/5dIVZ1goudQLfXo2ZTwqgEL+VQ0yVjV
        J2XGfSU+Z1+CyHahKzf76pp7v2C9J7SUnw==
X-Google-Smtp-Source: ABdhPJxM+XIKNPxAsw+TsO3bzcg5Q/7SH0ECNaEjoSsmqZzWBIXHVmqUHtm4Ja5WlO+UUxiQnQHbsg==
X-Received: by 2002:a1c:9609:: with SMTP id y9mr12353322wmd.75.1609433034962;
        Thu, 31 Dec 2020 08:43:54 -0800 (PST)
Received: from [192.168.8.177] ([85.255.236.0])
        by smtp.gmail.com with ESMTPSA id r13sm71446755wrt.10.2020.12.31.08.43.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 31 Dec 2020 08:43:54 -0800 (PST)
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1609361865.git.asml.silence@gmail.com>
 <04cd27ad-3e28-c0ca-0f09-e26db35e01c6@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH 0/4] address some hangs
Message-ID: <7badb636-14a2-df64-9679-0d0c3427d6b1@gmail.com>
Date:   Thu, 31 Dec 2020 16:40:26 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <04cd27ad-3e28-c0ca-0f09-e26db35e01c6@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 31/12/2020 15:07, Jens Axboe wrote:
> On 12/30/20 2:34 PM, Pavel Begunkov wrote:
>> 1/4 and 2/4 are for hangs during files unregister.
>>
>> The other two fix not running task works during cancellation.
>> Instead of patching task_work it moves io_uring_files_cancel()
>> before PF_EXITING, should be less intrusive. Was there a
>> particular reasong for doing that in exit_files()?
>>
>> Pavel Begunkov (4):
>>   io_uring: add a helper for setting a ref node
>>   io_uring: fix io_sqe_files_unregister() hangs
>>   kernel/io_uring: cancel io_uring before task works
>>   io_uring: cancel requests enqueued as task_work's
>>
>>  fs/file.c     |  2 --
>>  fs/io_uring.c | 54 ++++++++++++++++++++++++++++++++++-----------------
>>  kernel/exit.c |  2 ++
>>  3 files changed, 38 insertions(+), 20 deletions(-)
> 
> Applied 1-3, as they look good. Can you resend 4/4 with the return
> added?

1-3 should fix the problems, so let's put off 4 for later and not
for current.

-- 
Pavel Begunkov
