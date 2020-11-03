Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9967D2A37E6
	for <lists+io-uring@lfdr.de>; Tue,  3 Nov 2020 01:35:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727521AbgKCAfE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 2 Nov 2020 19:35:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727489AbgKCAfB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 2 Nov 2020 19:35:01 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73073C0617A6
        for <io-uring@vger.kernel.org>; Mon,  2 Nov 2020 16:35:00 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id w65so12693441pfd.3
        for <io-uring@vger.kernel.org>; Mon, 02 Nov 2020 16:35:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=kFgGFAUiwT8P9+gdU/OMuHbnPbjCdusjVkL0FjTkbRQ=;
        b=hYq68ehR6KpObmYSouqmvp/R339kKanNkDvV6KMKKRv2ScwNLx1IT1vzgLt0v0dNyB
         GSCs76UU0uY/PQtUrLPLVmPiJQqJd6C1fgMPljHXvkYc4c00XXQB9YM+6slDpC6cu1JI
         +HxfxJ7DNu/dqZvs8ciQ9JGWi89Hv1gqL+k/XqFI97MfprS2xXa0G/4rr9kFgbSu6TYH
         tgAhLNyrJOho1fYvSw+v/zev/CG1g8ZWD/VPCEMiFpZkJhYpbjyzILZ20APuHu6Nvwzo
         KOfqspNSUnmAmyU3ZT7F+hbSlfiSfATbFQg/560CsJjRzBGyM2PVCRFdfA6JialQ3Nx2
         n0rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kFgGFAUiwT8P9+gdU/OMuHbnPbjCdusjVkL0FjTkbRQ=;
        b=PTCAgjQn0r0RGzot/47YxQOmnrOqgB38xM3ap+PqdIQNP4BWQgUCpT1gOoeq832SKc
         wWkLNd0m4PahgO+pNw6oEYZ3nWMOvRUHoZtukLwezlpEZgoPSEVPfeIvX/Frq45lI4eg
         f36FeE/03Nmkj5lDgFTsh6FSaU0cNzMAPOzLn862yiZwyqOvVTEGXVCp36GxVaFQFwAb
         VnthSEjD4gXLLS5dLt+zwDENu/Q7lGyu9JP8cZQKv+EIf/YKl5Z1AFBnx5VEEzLM20s2
         ZVmyWywwX76wfjZphV+nK+iE5ATJIFMvSH91LGSwhGywRTPauXb0EL+OfrZyhKvZ5ubD
         wV6w==
X-Gm-Message-State: AOAM532yBeO7aECZNa+rKSn2ljInlsEWU2zUksjI/w9BDXlaezY6H62F
        xMBM495Xkgj/Uuoe4gGiE2NJ2qROqYO37Q==
X-Google-Smtp-Source: ABdhPJxxUf1OmJNR5KmAwv+OWZLPvD7+V/5B92t9KVDrYIljt4HoEdsPD2jMoAvlgsf1TeE4dcyPLw==
X-Received: by 2002:a17:90a:c209:: with SMTP id e9mr870799pjt.87.1604363699670;
        Mon, 02 Nov 2020 16:34:59 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id o70sm14527151pfg.214.2020.11.02.16.34.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Nov 2020 16:34:58 -0800 (PST)
Subject: Re: relative openat dirfd reference on submit
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Vito Caputo <vcaputo@pengaru.com>, io-uring@vger.kernel.org
References: <20201102205259.qsbp6yea3zfrqwuk@shells.gnugeneration.com>
 <d57e6cb2-9a2c-86a4-7d64-05816b3eab54@kernel.dk>
 <0532ec03-1dd2-a6ce-2a58-9e45d66435b5@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <c7130e35-6340-5e0b-f0d9-3c8465d0eaf9@kernel.dk>
Date:   Mon, 2 Nov 2020 17:34:57 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <0532ec03-1dd2-a6ce-2a58-9e45d66435b5@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/2/20 5:17 PM, Pavel Begunkov wrote:
> On 03/11/2020 00:05, Jens Axboe wrote:
>> On 11/2/20 1:52 PM, Vito Caputo wrote:
>>> Hello list,
>>>
>>> I've been tinkering a bit with some async continuation passing style
>>> IO-oriented code employing liburing.  This exposed a kind of awkward
>>> behavior I suspect could be better from an ergonomics perspective.
>>>
>>> Imagine a bunch of OPENAT SQEs have been prepared, and they're all
>>> relative to a common dirfd.  Once io_uring_submit() has consumed all
>>> these SQEs across the syscall boundary, logically it seems the dirfd
>>> should be safe to close, since these dirfd-dependent operations have
>>> all been submitted to the kernel.
>>>
>>> But when I attempted this, the subsequent OPENAT CQE results were all
>>> -EBADFD errors.  It appeared the submit didn't add any references to
>>> the dependent dirfd.
>>>
>>> To work around this, I resorted to stowing the dirfd and maintaining a
>>> shared refcount in the closures associated with these SQEs and
>>> executed on their CQEs.  This effectively forced replicating the
>>> batched relationship implicit in the shared parent dirfd, where I
>>> otherwise had zero need to.  Just so I could defer closing the dirfd
>>> until once all these closures had run on their respective CQE arrivals
>>> and the refcount for the batch had reached zero.
>>>
>>> It doesn't seem right.  If I ensure sufficient queue depth and
>>> explicitly flush all the dependent SQEs beforehand
>>> w/io_uring_submit(), it seems like I should be able to immediately
>>> close(dirfd) and have the close be automagically deferred until the
>>> last dependent CQE removes its reference from the kernel side.
>>
>> We pass the 'dfd' straight on, and only the async part acts on it.
>> Which is why it needs to be kept open. But I wonder if we can get
>> around it by just pinning the fd for the duration. Since you didn't
>> include a test case, can you try with this patch applied? Totally
>> untested...
> 
> afaik this doesn't pin an fd in a file table, so the app closes and
> dfd right after submit and then do_filp_open() tries to look up
> closed dfd. Doesn't seem to work, and we need to pass that struct
> file to do_filp_open().

Yeah, I just double checked, and it's just referenced, but close() will
still make it NULL in the file table. So won't work... We'll have to
live with it for now, I'm afraid.

-- 
Jens Axboe

