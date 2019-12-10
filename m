Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3426119C44
	for <lists+io-uring@lfdr.de>; Tue, 10 Dec 2019 23:22:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726874AbfLJWVI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 10 Dec 2019 17:21:08 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:34758 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726691AbfLJWVI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 10 Dec 2019 17:21:08 -0500
Received: by mail-pf1-f196.google.com with SMTP id n13so564625pff.1
        for <io-uring@vger.kernel.org>; Tue, 10 Dec 2019 14:21:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=RuuieeO+IxNs+Cd1LTYV3QZT0Bw2YECA/x/7+WSUub0=;
        b=VOggNhdwRAPgnhKLz1Og5bsTtvnKiGOUK47NeqH8Oht9LIGyzTN7GkNIJWvAee8oPM
         w4UXzB4ZJ0wPAWWyzXwFhlgYsfgqKxrqzEQGDgN7/dZoemA2odSgckgjLWC/E07R0CGw
         5uTMkMSLvHvcUg7ufPMmInJkas874dvl1e5rMDN0iEwD53tGEqTAlaK0b5kIM4Z2q2mJ
         guqlPi6sRzzj8eKxgT4UINJqrmlUwTkrxnNkZ2q8Yc9DbnhMFu/CKMpvn0gNriovXi0t
         YMKDvFWOLQz2Dbk4feqmvdbGl0IGucwxWR1ALZ3w2FsdZDKXu75sIEa83irDjwJs4H0f
         xH5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RuuieeO+IxNs+Cd1LTYV3QZT0Bw2YECA/x/7+WSUub0=;
        b=Qn0wGPTRx4DkKuTxeflp7WSPUA8GImw2+Nxg6SH5r47evFpulfJaa446rBkM4SFpN5
         QFDLvYM9S3XO6M0aHfPVyuEObSgm7lEjPBUDmKrRmCMtT5dviJEgZ5pTPB/zWSWlOg92
         xo7o5o8fJphSFtSznI+7H83eaFlRKJ7WEjCmJ/eovm+UNmkugEDV4NwCOhUUmBAFsQTj
         YPjZOno8HIlY35yBp4W/GrCNff5ji1LSjURqyqP/4NmzLfep8yAiSulWX9NsFzlbbXjX
         U+DROZb+YSn96ITuVFam+HCjgiwRgAIv/vRngyE9ogBVMxeZFZWYE9uE504TJs9N+wEB
         2beQ==
X-Gm-Message-State: APjAAAUpTRq0WpfgATjBGbv3baiRMVojMxhzkoccVmtcNSl2kJe4RweK
        ABbGbXN09Dcv4JhQt7EBuxZICA==
X-Google-Smtp-Source: APXvYqwH12eD85bP+0NMosGNVzDEhevTSPWev0DU5WkTGUPiUMSssWJKkS+tJkXxxqMTFkzSH6T/hw==
X-Received: by 2002:a63:c20c:: with SMTP id b12mr378150pgd.407.1576016467631;
        Tue, 10 Dec 2019 14:21:07 -0800 (PST)
Received: from ?IPv6:2620:10d:c081:1131::1215? ([2620:10d:c090:180::4a7a])
        by smtp.gmail.com with ESMTPSA id a14sm49423pfn.22.2019.12.10.14.21.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Dec 2019 14:21:06 -0800 (PST)
Subject: Re: [PATCH 07/11] io_uring: use atomic_t for refcounts
To:     Jann Horn <jannh@google.com>
Cc:     io-uring <io-uring@vger.kernel.org>, Will Deacon <will@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>
References: <20191210155742.5844-1-axboe@kernel.dk>
 <20191210155742.5844-8-axboe@kernel.dk>
 <CAG48ez3yh7zRhMyM+VhH1g9Gp81_3FMjwAyj3TB6HQYETpxHmA@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <02ba41a9-14f2-e3be-f43f-99f311c662ef@kernel.dk>
Date:   Tue, 10 Dec 2019 15:21:04 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <CAG48ez3yh7zRhMyM+VhH1g9Gp81_3FMjwAyj3TB6HQYETpxHmA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/10/19 3:04 PM, Jann Horn wrote:
> [context preserved for additional CCs]
> 
> On Tue, Dec 10, 2019 at 4:57 PM Jens Axboe <axboe@kernel.dk> wrote:
>> Recently had a regression that turned out to be because
>> CONFIG_REFCOUNT_FULL was set.
> 
> I assume "regression" here refers to a performance regression? Do you
> have more concrete numbers on this? Is one of the refcounting calls
> particularly problematic compared to the others?

Yes, a performance regression. io_uring is using io-wq now, which does
an extra get/put on the work item to make it safe against async cancel.
That get/put translates into a refcount_inc and refcount_dec per work
item, and meant that we went from 0.5% refcount CPU in the test case to
1.5%. That's a pretty substantial increase.

> I really don't like it when raw atomic_t is used for refcounting
> purposes - not only because that gets rid of the overflow checks, but
> also because it is less clear semantically.

Not a huge fan either, but... It's hard to give up 1% of extra CPU. You
could argue I could just turn off REFCOUNT_FULL, and I could. Maybe
that's what I should do. But I'd prefer to just drop the refcount on the
io_uring side and keep it on for other potential useful cases.

>> Our ref count usage is really simple,
> 
> In my opinion, for a refcount to qualify as "really simple", it must
> be possible to annotate each relevant struct member and local variable
> with the (fixed) bias it carries when alive and non-NULL. This
> refcount is more complicated than that.

:-(

-- 
Jens Axboe

