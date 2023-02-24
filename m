Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C3B86A2274
	for <lists+io-uring@lfdr.de>; Fri, 24 Feb 2023 20:42:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229496AbjBXTm1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Feb 2023 14:42:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbjBXTmZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Feb 2023 14:42:25 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2E376BF67
        for <io-uring@vger.kernel.org>; Fri, 24 Feb 2023 11:42:00 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id y10so85260pfi.8
        for <io-uring@vger.kernel.org>; Fri, 24 Feb 2023 11:42:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ijgekmVB2QKb1HH14nlyibdFD+y7KoE1WivpnqCwi0o=;
        b=8W3znN4bYEVoTCQAc/uMRjujf4tKqTj3EiBKNI+wfWaRm5qjLPlR0oMqeMdxW6vJZ8
         YPM2RYXqduJdfmV7SdABPZI34jixxdMHFaqyVMNSEUkI0/vrgtZdPKEfG82rna1g/yXI
         /tuAKri4OjZbgUNMadfZBFB8MF1SZIJkhXXa4KaReZ+4KHcSHotIgTj4zor+TmQttfCE
         PTbi+mTrVJ2b7pSXNeFQ8AugjzDv5N4KzlC+COpe4qpZp4WtLsxLS/LlyqlZNREVuAzM
         2UdkYAmvNFlC6eu0Z5kyIVrP7meUvQGCNJabd3Ruu78/h3EoDTiL5KFd81W3ChA0Cv0M
         BFOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ijgekmVB2QKb1HH14nlyibdFD+y7KoE1WivpnqCwi0o=;
        b=0nrVbwMGSibE0eh0MqzPOPbZi3uqIkdwenIEPrcrW0XKRJrt6ly97wJ/l49lYbNkOv
         w5pzYKTGL4Pvi+v57kh9JXVVGIEEc8m8WJWA9x5VKkQ2Ic7xE14ZtvF+skI3wzokE4Oa
         lHpQQ+CSYw2dws3/TIZfrdZov991oiWQ+Zhey2ZsPxyw1VjUrKP/dK6zF1qjt7DoOX/t
         S1pnAMvSW96DzOi979FNUV/H6ykjoH5CVmnGISgR70rz6dVpQF+oiyen0N8Jt+LHuaOv
         giwDBRBB19LqhyDVr4uph6w2ImEkCEQ01K1G6D3t8hqCXNWdH5dcahN44ChtIycCI7Oj
         x0Cw==
X-Gm-Message-State: AO0yUKWoBuaam7zDPQr2hVIhNIxCJOgwKaht8H3NGdjhNv4dfHb9eJwk
        RcXYN1lnjZ7ZVidZRdb7H0emTQ==
X-Google-Smtp-Source: AK7set9SRI3aeT+VUPA2REv2kUyLXrOxdOlZ0hD6wdvvODIaDy0UKOPSOUXEdhe1KeSRw51fnxcjmw==
X-Received: by 2002:aa7:9841:0:b0:5e2:3086:f977 with SMTP id n1-20020aa79841000000b005e23086f977mr3868360pfq.2.1677267720030;
        Fri, 24 Feb 2023 11:42:00 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id k10-20020aa7820a000000b005d791692727sm5044111pfi.191.2023.02.24.11.41.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Feb 2023 11:41:59 -0800 (PST)
Message-ID: <6673f9e6-fa00-b929-02c1-5e0f293dfa0a@kernel.dk>
Date:   Fri, 24 Feb 2023 12:41:58 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [PATCH v3 1/2] io_uring: Move from hlist to io_wq_work_node
Content-Language: en-US
To:     Gabriel Krisman Bertazi <krisman@suse.de>
Cc:     Breno Leitao <leitao@debian.org>, asml.silence@gmail.com,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        gustavold@meta.com, leit@meta.com, kasan-dev@googlegroups.com
References: <20230223164353.2839177-1-leitao@debian.org>
 <20230223164353.2839177-2-leitao@debian.org> <87wn48ryri.fsf@suse.de>
 <8404f520-2ef7-b556-08f6-5829a2225647@kernel.dk> <87mt52syls.fsf@suse.de>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <87mt52syls.fsf@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/24/23 11:32?AM, Gabriel Krisman Bertazi wrote:
> Jens Axboe <axboe@kernel.dk> writes:
> 
>> On 2/23/23 12:02?PM, Gabriel Krisman Bertazi wrote:
>>> Breno Leitao <leitao@debian.org> writes:
>>>
>>>> Having cache entries linked using the hlist format brings no benefit, and
>>>> also requires an unnecessary extra pointer address per cache entry.
>>>>
>>>> Use the internal io_wq_work_node single-linked list for the internal
>>>> alloc caches (async_msghdr and async_poll)
>>>>
>>>> This is required to be able to use KASAN on cache entries, since we do
>>>> not need to touch unused (and poisoned) cache entries when adding more
>>>> entries to the list.
>>>>
>>>
>>> Looking at this patch, I wonder if it could go in the opposite direction
>>> instead, and drop io_wq_work_node entirely in favor of list_head. :)
>>>
>>> Do we gain anything other than avoiding the backpointer with a custom
>>> linked implementation, instead of using the interface available in
>>> list.h, that developers know how to use and has other features like
>>> poisoning and extra debug checks?
>>
>> list_head is twice as big, that's the main motivation. This impacts
>> memory usage (obviously), but also caches when adding/removing
>> entries.
> 
> Right. But this is true all around the kernel.  Many (Most?)  places
> that use list_head don't even need to touch list_head->prev.  And
> list_head is usually embedded in larger structures where the cost of
> the extra pointer is insignificant.  I suspect the memory
> footprint shouldn't really be the problem.

I may be in the minority here in caring deeply about even little details
in terms of memory foot print and how many cachelines we touch... Eg if
we can embed 8 bytes rather than 16, then why not? Particularly for
cases where we may have a lot of these structures.

But it's of course always a tradeoff.

> This specific patch is extending io_wq_work_node to io_cache_entry,
> where the increased size will not matter.  In fact, for the cached
> structures, the cache layout and memory footprint don't even seem to
> change, as io_cache_entry is already in a union larger than itself, that
> is not crossing cachelines, (io_async_msghdr, async_poll).

True, for the caching case, the member size doesn't matter. At least
immediately. Sometimes things are shuffled around and optimized further,
and then you may need to find 8 bytes to avoid bloating the struct.

> The other structures currently embedding struct io_work_node are
> io_kiocb (216 bytes long, per request) and io_ring_ctx (1472 bytes long,
> per ring). so it is not like we are saving a lot of memory with a single
> linked list. A more compact cache line still makes sense, though, but I
> think the only case (if any) where there might be any gain is io_kiocb?

Yeah, the ring is already pretty big. It is still handled in cachelines
for the bits that matter, so nice to keep them as small for the
sections. Maybe bumping it will waste an extra cacheline. Or, more
commonly, later additions now end up bumping into the next cacheline
rather than still fitting.

> I don't severely oppose this patch, of course. But I think it'd be worth
> killing io_uring/slist.h entirely in the future instead of adding more
> users.  I intend to give that approach a try, if there's a way to keep
> the size of io_kiocb.

At least it's consistent within io_uring, which also means something.
I'd be fine with taking a look at such a patch, but let's please keep it
outside the scope of this change.

-- 
Jens Axboe

