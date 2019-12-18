Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7AC5123B4B
	for <lists+io-uring@lfdr.de>; Wed, 18 Dec 2019 01:06:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725975AbfLRAGQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 17 Dec 2019 19:06:16 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:38356 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725940AbfLRAGQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 17 Dec 2019 19:06:16 -0500
Received: by mail-pg1-f194.google.com with SMTP id a33so207494pgm.5
        for <io-uring@vger.kernel.org>; Tue, 17 Dec 2019 16:06:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5DrwxDSyJLSSRrMHOhzQAZc2NGsZP2W7LHQ+e4cn93Q=;
        b=rw3xbsyCEeUpk7WVqCX7xGAQ8llLRz+nWUTWsTdrdWchXl3GN8L8wT3BKB4sqXVRb8
         XmaNspqdj/nqKJHziadXxKiTPa8Q/TndTSI63NZmV6ao0JpO3FMJFcdFnZ93eHvG5iMp
         hiMMMytJIDsQ/NkJ6FCGVcgOCuMQKpSlgYN3HyCJqHzGRtfg/xEnFoMO/UxYcxzCA5QL
         L3+rd1tNLk7Db6o6smuHSZtbyCqLps9x2o4/QZl2apHo6tOGIw477WUWO8aa3ufGWyZR
         1ADwbSByWFTBRHz9cMuQaPAwnMC8ipIBCLYCBjDpOeBKQirUtaKYpHmnxtb4zFRNZTph
         yG8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5DrwxDSyJLSSRrMHOhzQAZc2NGsZP2W7LHQ+e4cn93Q=;
        b=De+9nyF9iLByfhbGuBAVkxryElGDOcrrVJf7DRJ0yOo9oa0f+JzdAUA7j6cqrbBBgl
         /mCvRJZyYZzATRhScBC4H5zDG21KSGyoYGNLtrmdEGUklxmGBZ6EFMIdyxa+8kXOj6kQ
         l5C6s5CWE+9M/rY66wbnNSQWrgRCJxvMSjool3eV2MaBsby0rbGhEjpK0osZlJtTC06p
         9Gico9fFpAHLwSNy95UFeo6xaqSFUdtvqVIAY0V3r8toRKQE8H8umXxyNBs+4d6Zg659
         r8k72TAlZ2P9HyJyXBUooYv3SswMJdSn5uCYFNQscB5JmP34a/SSMF8CRXKn61gMo0h1
         DQQA==
X-Gm-Message-State: APjAAAUge8CoR5YFmkTsN4BctHmKwjpbFAU5Mt+LKj56hKZPnKLI7wz+
        J7UjkmOsVtxMEp6q01Tpn76EDDUyvlY=
X-Google-Smtp-Source: APXvYqwh5DfIgdWfK6NqcxDcNeZxl8sxbQ7a4UzDgsOYdNzO8LH1vE9txuYn7pzDdfmkmseWrDlFWQ==
X-Received: by 2002:aa7:918f:: with SMTP id x15mr432349pfa.247.1576627575413;
        Tue, 17 Dec 2019 16:06:15 -0800 (PST)
Received: from ?IPv6:2620:10d:c081:1131::13f4? ([2620:10d:c090:180::6446])
        by smtp.gmail.com with ESMTPSA id g25sm181013pfo.110.2019.12.17.16.06.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Dec 2019 16:06:14 -0800 (PST)
Subject: Re: [PATCH 3/7] io_uring: don't wait when under-submitting
To:     Jann Horn <jannh@google.com>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring <io-uring@vger.kernel.org>
References: <20191217225445.10739-1-axboe@kernel.dk>
 <20191217225445.10739-4-axboe@kernel.dk>
 <CAG48ez3kndOnUmEKRiL0SJ8=Tt_+NqZAg7ESwB9Us2xX43rnHg@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <1facf64e-a826-5b7c-391d-e29c1d7a71b0@kernel.dk>
Date:   Tue, 17 Dec 2019 17:06:13 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <CAG48ez3kndOnUmEKRiL0SJ8=Tt_+NqZAg7ESwB9Us2xX43rnHg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/17/19 4:55 PM, Jann Horn wrote:
> On Tue, Dec 17, 2019 at 11:54 PM Jens Axboe <axboe@kernel.dk> wrote:
>> There is no reliable way to submit and wait in a single syscall, as
>> io_submit_sqes() may under-consume sqes (in case of an early error).
>> Then it will wait for not-yet-submitted requests, deadlocking the user
>> in most cases.
>>
>> In such cases adjust min_complete, so it won't wait for more than
>> what have been submitted in the current io_uring_enter() call. It
>> may be less than total in-flight, but that up to a user to handle.
>>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> [...]
>>         if (flags & IORING_ENTER_GETEVENTS) {
>>                 unsigned nr_events = 0;
>>
>>                 min_complete = min(min_complete, ctx->cq_entries);
>> +               if (submitted != to_submit)
>> +                       min_complete = min(min_complete, (u32)submitted);
> 
> Hm. Let's say someone submits two requests, first an ACCEPT request
> that might stall indefinitely and then a WRITE to a file on disk that
> is expected to complete quickly; and the caller uses min_complete=1
> because they want to wait for the WRITE op. But now the submission of
> the WRITE fails, io_uring_enter() computes min_complete=min(1, 1)=1,
> and it blocks on the ACCEPT op. That would be bad, right?
> 
> If the usecase I described is valid, I think it might make more sense
> to do something like this:
> 
> u32 missing_submissions = to_submit - submitted;
> min_complete = min(min_complete, ctx->cq_entries);
> if ((flags & IORING_ENTER_GETEVENTS) && missing_submissions < min_complete) {
>   min_complete -= missing_submissions;
>   [...]
> }
> 
> In other words: If we do a partially successful submission, only wait
> as long as we know that userspace definitely wants us to wait for one
> of the pending requests; and once we can't tell whether userspace
> intended to wait longer, return to userspace and let the user decide.
> 
> Or it might make sense to just ignore IORING_ENTER_GETEVENTS
> completely in the partial submission case, in case userspace wants to
> immediately react to the failed request by writing out an error
> message to a socket or whatever. This case probably isn't
> performance-critical, right? And it would simplify things a bit.

That's a good point, and Pavel's first patch actually did that. I
didn't consider the different request type case, which might be
uncommon but definitely valid.

Probably the safest bet here is just to not wait at all if we fail
submitting all of them. This isn't a fast path, there was an error
somehow which meant we didn't submit it all. So just return the
submit count (including 0, not -EAGAIN) if we fail submitting,
and ignore IORING_ENTER_GETEVENTS for that case.

Pavel, care to submit a new one? I'll drop this one now.

-- 
Jens Axboe

