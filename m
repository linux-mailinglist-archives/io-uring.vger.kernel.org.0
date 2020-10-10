Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DC5A28A235
	for <lists+io-uring@lfdr.de>; Sun, 11 Oct 2020 00:55:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730273AbgJJWzg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 10 Oct 2020 18:55:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730298AbgJJSss (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 10 Oct 2020 14:48:48 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6510EC05BD39
        for <io-uring@vger.kernel.org>; Sat, 10 Oct 2020 11:48:46 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id d6so6196492plo.13
        for <io-uring@vger.kernel.org>; Sat, 10 Oct 2020 11:48:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=HhbgTx3DySND4z0ygXYq32pnpnFqa/USa/+ULemQbhk=;
        b=1n8/ljF3lpfnDgnQc/37EukFdxMHO+DSjIgDsNcZ4EwRbYiysuUXNxwZ1xwSZzP2Yu
         WOg4UADidPKvUCorTuE57V971M0UX+00ww6pCFKh5ZdqlkTAZpUCjM6TfsIO+91hCn0I
         zXyphlgDAUzS01WKENXJBdIqmgJFwHMP2HamQz2s05iUqa/6h3gfqXaXB3/tar5X1Okq
         TZ52LT6lx59ZaM70qYxYsEK+bR3yTQlsCmcmT3UjiGqqEJx9dc4rbgq7GHkoBdbAckWw
         eDdMrKMqDYKc5SkjqJBln7cO292pZ+AgDUgbSZFPXTnHoD5bZP8lazUggk/kApa5m3x3
         Rzuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HhbgTx3DySND4z0ygXYq32pnpnFqa/USa/+ULemQbhk=;
        b=QXLZ+V5Yo50LSEVLVm8a5MVKH3H0dl1SqUn1oYchXVEUW49rfhoyBkcE+bDZBlgBA0
         neA4oIhsoSQEvt0DGPJMGfXQV0ql+GlhAIVYZn81amkwKBhuto8nQWwqwoe89WdMOJKN
         Td2QJMBXgliLyRP9uEpxw+z6xdoqIgt+d1nM+LtIVZKb9893WUiyyOGiJo7EUWCUan/3
         QyZ/0f/TQKh0BRfhHT7kro3K7tgmiIi+TjAfesJoLrq8afSGMMpDUB9C2ImIrIRvQL7H
         B0hUPDIM2sp7zhvLtBPXwjBsvCAStsIoMu6CIb6J7AAVm72HgyKtxAd/gI9e8pV4N3ci
         CvOA==
X-Gm-Message-State: AOAM530vySetfGwZlktQHfspr1Kw4xmAd0xSmDOFggG4aK0yBwTH0rKa
        EwQRDOf6rLe19lfAnuDy3mJmisykg133jrfc
X-Google-Smtp-Source: ABdhPJz8pkj+wLcCe1qzfcZUutnqhraKn7cxDOsR0uP2jGUXow9FNmdhXmSTz3u8VJP3M1dhPFJsPw==
X-Received: by 2002:a17:902:d716:b029:d3:8e2a:1b5d with SMTP id w22-20020a170902d716b02900d38e2a1b5dmr16167711ply.85.1602355725565;
        Sat, 10 Oct 2020 11:48:45 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id k127sm350964pgk.10.2020.10.10.11.48.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 10 Oct 2020 11:48:45 -0700 (PDT)
Subject: Re: [PATCH 00/12] bundled cleanups and improvements
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1602350805.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <2d48b3e5-30f3-4e03-9e91-148b9320f268@kernel.dk>
Date:   Sat, 10 Oct 2020 12:48:43 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1602350805.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/10/20 11:34 AM, Pavel Begunkov wrote:
> Only [1] considerably affects performance (as by Roman Gershman), others
> are rather cleanups.
> 
> [1-2] are on the surface cleanups following ->files changes.
> [3-5] address ->file grabbing
> [6-7] are some preparations around timeouts
> [8,9] are independent cleanups
> [10-12] toss around files_register() bits
> 
> Pavel Begunkov (12):
>   io_uring: don't io_prep_async_work() linked reqs
>   io_uring: clean up ->files grabbing
>   io_uring: kill extra check in fixed io_file_get()
>   io_uring: simplify io_file_get()
>   io_uring: improve submit_state.ios_left accounting
>   io_uring: use a separate struct for timeout_remove
>   io_uring: remove timeout.list after hrtimer cancel
>   io_uring: clean leftovers after splitting issue
>   io_uring: don't delay io_init_req() error check
>   io_uring: clean file_data access in files_register
>   io_uring: refactor *files_register()'s error paths
>   io_uring: keep a pointer ref_node in file_data
> 
>  fs/io_uring.c | 275 ++++++++++++++++++++------------------------------
>  1 file changed, 107 insertions(+), 168 deletions(-)

Thanks, nice cleanups! LGTM, and they test out fine too. Applied.

-- 
Jens Axboe

