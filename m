Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1AD82A103F
	for <lists+io-uring@lfdr.de>; Fri, 30 Oct 2020 22:32:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727732AbgJ3Vco (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 30 Oct 2020 17:32:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727727AbgJ3Vcn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 30 Oct 2020 17:32:43 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4561C0613CF
        for <io-uring@vger.kernel.org>; Fri, 30 Oct 2020 14:32:41 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id 10so6429225pfp.5
        for <io-uring@vger.kernel.org>; Fri, 30 Oct 2020 14:32:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=Sl7ERMm8i8og8Jr53b0A03HqSH47dUr4WfvyWVVRA3Q=;
        b=DLNI6bKQdY/0XX8EpIcRVODDCnxfr1y6jN/0e1tz4dA+eLrHWbDcBmpgHZrqWYc7QP
         DYG5IM+oxMCFmeeVX7kJjTlmDZ4mA/HnThQSyWh8N1yxBBMroHApnqKN8S6UCiMDa4tV
         G4AMoi334J1puSU3/3qS+SdUO9NczWY/Lzfq24EZs5np8Ysx3yLiWrk8dmxynY30NsWY
         VViMR0cwb/YosezOj2fkYIgQkn5HLGV/Gn7Lj9AoiN/aniVKmWHHuphB36JXKCznwOyN
         vLMPoNhkuXelQwDkDNCGd0uBVHThoIVfwHjPL5d6ycmebNDlwJITVaqj7iKtO7M7Ivsj
         IVew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Sl7ERMm8i8og8Jr53b0A03HqSH47dUr4WfvyWVVRA3Q=;
        b=So+9s17cP5k0YsiqyitEMOKDivmydDIicnolSbnij2G2/GEne8Npon6MN3m3H+2IL/
         ou7jlTxPORbgcRevQMMs9xJGeCkNcpqV36qklEzl3Oqv6afoABEjMELQDn6uwVjNsXPz
         AKlSEyingkzMfkfZ2neFSZO2DZfrNSaEqIwjyy+RzJIsmRdNy+dSGXhnJgG4bdRrmC4Z
         UwvumpgOcUGfLOKFQ3hlWUjRIgSrzLR8hJEFBdEEg7BPgZXgka07eNWOGQwXBB3kLiZW
         reK+uDgKvnApRq41bQzESUvVNL9K2bJva9i0Eclqbf6JB5Erc0T4NfWNtszDX3Ici3Wr
         V/zQ==
X-Gm-Message-State: AOAM531jmIzhJfC9IzTwYqhdSFHJwits3al48rFjttSsKJZO2QYArnEv
        oqQU1x0lIDy5oUMwZRRi06c3JQXKMI+HQQ==
X-Google-Smtp-Source: ABdhPJw0tX/chDda+lCL39AuY8E2K9/zVEV826rxfhq/xLTPEHPDAYCn+E8EQo3ghA1Oj/0k0pLxtA==
X-Received: by 2002:a17:90a:c48:: with SMTP id u8mr5126249pje.121.1604093560862;
        Fri, 30 Oct 2020 14:32:40 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id e196sm6773889pfh.128.2020.10.30.14.32.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Oct 2020 14:32:40 -0700 (PDT)
Subject: Re: [PATCH v2 0/4] singly linked list for chains
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1603840701.git.asml.silence@gmail.com>
 <31af9b88-cc16-f789-767b-30489c33935f@kernel.dk>
 <c9cc657b-fb1f-b40b-dc79-0be12362773c@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <eda4f344-a5a5-106e-9f63-45ebc3681450@kernel.dk>
Date:   Fri, 30 Oct 2020 15:32:39 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <c9cc657b-fb1f-b40b-dc79-0be12362773c@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/30/20 6:46 AM, Pavel Begunkov wrote:
> On 28/10/2020 14:18, Jens Axboe wrote:
>> On 10/27/20 5:25 PM, Pavel Begunkov wrote:
>>> v2: split the meat patch.
>>>
>>> I did not re-benchmark it, but as stated before: 5030 vs 5160 KIOPS by a
>>> naive (consistent) nop benchmark that submits 32 linked nops and then
>>> submits them in a loop. Worth trying with some better hardware.
>>
>> Applied for 5.11 - I'll give it a spin here too and see if I find any
>> improvements. But a smaller io_kiocb is always a win.
> 
> Might be a good time for a generic single list. There are at least 3
> places I remember: bio, io-wq, io_uring

Yes, kind of weird that we don't have one. There's the normal doubly
linked one, and then there's the single head for hash tables. But I
could not find anything good for io-wq, which is why I rolled my own.
Would be nice to turn it into a generic one and reuse it everywhere (and
I bet it would grow more users).

The lockless lists (llist) is singular, but overkill if you already have
locking you're under.

-- 
Jens Axboe

