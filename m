Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B1D724B9B5
	for <lists+io-uring@lfdr.de>; Thu, 20 Aug 2020 13:54:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728886AbgHTLxl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Aug 2020 07:53:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730741AbgHTLuM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Aug 2020 07:50:12 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5C34C061385
        for <io-uring@vger.kernel.org>; Thu, 20 Aug 2020 04:50:11 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id m71so913475pfd.1
        for <io-uring@vger.kernel.org>; Thu, 20 Aug 2020 04:50:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=wN9yD8Izb3F9v1/c96q/T+0tgPQlWpGyN8voBB25wqk=;
        b=eskScTRtz24s4hURAzqfOVff0kAJv1HXO26wJHttv/rlMwQPt4NuSHTG7rop56MPy9
         PFvy4d/WR11iPrMdErndQmgYzwzY4qfNY/l+FNUrWm6RDGWzSdHrhaIOCd1YXr22wOcn
         ueb2gfq92epj1Gdl6H9eQVoT7zGcksOxxsc+onN2TqL5VSM+VoLrnjz5xAN0Ca6/d5gX
         ws/p7NEo2IEnO6G6fEm9LjUQB99S4fFUcmigv9d74pjCaZO9HsHRflQbCe2No4HOBk+r
         CkRe/U0SNKlsXLkbUSqITOoOk2WfBUtm6jI+wt/oyVCrCmqHyDiCOlonkyaFdi8zZTsr
         h9iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wN9yD8Izb3F9v1/c96q/T+0tgPQlWpGyN8voBB25wqk=;
        b=s0UotQCyfjNy0x6r+C7h6B292kOLkDw+E28DqQDuqBF8LxKatKU7waRVmgbJlve6bR
         Gw6GmS/4l+GUQpGT3MQqF3W0So1rIKgHha+2+UP6QOLrNyLTNK8oUde7lCm8ra8nmWL+
         OSbYlNCrHEfqMLMh0V4CS6pHdaiOoZKOWjAe384Ke9FjZH4G5/xjzv+0zwoysKiP2bUl
         /b5Kype6uftFfB73MAL1aK+WfvzaULGwQH5fSc1zqkTBWLrYJt6wXQBXbslqicr/S2xQ
         KSpMajhBIO0uDslLyRgF9DaYekJRn9GEwjEyRYGmVzqbvUnZ2Vc8lNSrOoN03Vsum/0l
         v9Yg==
X-Gm-Message-State: AOAM531dFURWI1z5QwGLTQWb1UevW/bwzDcHWQBmHl2+SXhVfkG6KjD2
        eWeNqQ2xHAOrvcegmlbTFHbvrCGnVqSGDlYg7Wg=
X-Google-Smtp-Source: ABdhPJzJDwkoIurccEhfPsNBjgJs4FfYFecRb3ils8wgY3H0TJTuC486f3D+hI5Pxbp968NwqGBT0g==
X-Received: by 2002:a62:cf85:: with SMTP id b127mr1964951pfg.89.1597924211112;
        Thu, 20 Aug 2020 04:50:11 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id x8sm2779206pfp.101.2020.08.20.04.50.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Aug 2020 04:50:10 -0700 (PDT)
Subject: Re: [PATCH for-5.9] io_uring: fix racy req->flags modification
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <396ddf7deab36b73b6f24ae28b1e2fd1a2f468fb.1597912300.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <a1cf51de-ad48-f2cf-1afd-896b519d901f@kernel.dk>
Date:   Thu, 20 Aug 2020 05:50:08 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <396ddf7deab36b73b6f24ae28b1e2fd1a2f468fb.1597912300.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/20/20 1:33 AM, Pavel Begunkov wrote:
> Setting and clearing REQ_F_OVERFLOW in io_uring_cancel_files() and
> io_cqring_overflow_flush() are racy, because they might be called
> asynchronously.
> 
> REQ_F_OVERFLOW flag in only needed for files cancellation, so if it can
> be guaranteed that requests _currently_ marked inflight can't be
> overflown, the problem will be solved with removing the flag
> altogether.
> 
> That's how the patch works, it removes inflight status of a request
> in io_cqring_fill_event() whenever it should be thrown into CQ-overflow
> list. That's Ok to do, because no opcode specific handling can be done
> after io_cqring_fill_event(), the same assumption as with "struct
> io_completion" patches.
> And it already have a good place for such cleanups, which is
> io_clean_op(). A nice side effect of this is removing this inflight
> check from the hot path.
> 
> note on synchronisation: now __io_cqring_fill_event() may be taking two
> spinlocks simultaneously, completion_lock and inflight_lock. It's fine,
> because we never do that in reverse order, and CQ-overflow of inflight
> requests shouldn't happen often.

Thakns, this is a nice cleanup too.

-- 
Jens Axboe

