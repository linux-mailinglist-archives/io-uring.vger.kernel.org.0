Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 591202C5880
	for <lists+io-uring@lfdr.de>; Thu, 26 Nov 2020 16:51:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730602AbgKZPuo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 26 Nov 2020 10:50:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730181AbgKZPuo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 26 Nov 2020 10:50:44 -0500
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C925AC0613D4
        for <io-uring@vger.kernel.org>; Thu, 26 Nov 2020 07:50:42 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id b10so560681pfo.4
        for <io-uring@vger.kernel.org>; Thu, 26 Nov 2020 07:50:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=OD2EMTPaGGm/mYAb215ZYSuofHWvtFuOQ+vzgwQAqfM=;
        b=WwzcKF4Ai0j9+UEYvuQWxux+zjUUuKU+zy8uWYlt63SMAzfpUpMRSrfNfAwsT0l70u
         SDC26csOUZUQDzj2e2Q0v7X3/9iohwD+Dr8Xg/3v5sgNNOFuNqbbGM3WbKRKVNR9wyK7
         puNazy9ySOIOCrMoasy4/WCBrzhaXtU02OiRJ/Z0FGSNrA2+6jdxH/iZp5pQPZyc6Fi9
         tRR7+LBIFviN1BbTY/cD/MFxS+eyIojQGHLcgcMUZlYEA+GIaCSE6q/mJCGsGYymh2cb
         LkG3T3EamWb2juy2uqGwYMYQJ4ys1afFMohR/kYDebVLWB8AJdCn2bL0MSHVQwufrIQ/
         P9zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OD2EMTPaGGm/mYAb215ZYSuofHWvtFuOQ+vzgwQAqfM=;
        b=PPgti1cHttvP8Rys+XJxFyGg95VYLOvh6h7c8cMyk6+PJdwH4dBpTvwnYrRU78o7DO
         KXwLyvapZMYh6l6pKCW0r6H36AWXnGfxqyiJPnIGxrUnhgpQN+HDguf/a0tSySNbWcFo
         uYj/Ix4DsCyXSf16VA6wT3IXJiHAHKclLGD9djrdBgJEcP+YHQdo3xDOn6f9aeczlc4u
         +LfayKuZmCJ0pZcDkAPRPLvcEEhBjQTDQ3yQ0ydY7yWox0i30Q3/qQ7McmMQQ5K/2+4I
         7c3rRJqNHmWw/zuFvfj90adbY1KsAZ6/SsX0mMNxjdjQ+e33Fry44nfK02yG+PG6bdwQ
         wlHw==
X-Gm-Message-State: AOAM530JrslsN+Y+Z0+4lIUt8kZ8BMjuTRAVA0nOJks1vqFSOGDUOgK+
        f84D06nRuD7w0TX/Q9LfEaqAa7+sm+/4rg==
X-Google-Smtp-Source: ABdhPJyDmHV+kZ/4Q/4RAU8WBXf1FeF1uUhgPwZnqCzBhOCx7OuZH+48Grb2L1bS9tFnDrL8g6qYYg==
X-Received: by 2002:a62:8608:0:b029:18b:a8e:ee9 with SMTP id x8-20020a6286080000b029018b0a8e0ee9mr3137533pfd.65.1606405842014;
        Thu, 26 Nov 2020 07:50:42 -0800 (PST)
Received: from ?IPv6:2605:e000:100e:8c61:386d:cd15:142f:9ec0? ([2605:e000:100e:8c61:386d:cd15:142f:9ec0])
        by smtp.gmail.com with ESMTPSA id z5sm4952038pgv.53.2020.11.26.07.50.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Nov 2020 07:50:41 -0800 (PST)
Subject: Re: [PATCH 5.10] io_uring: fix files grab/cancel race
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <687c411007d0ec6a2be092ddc0274046898e43b5.1606329549.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <d9e0e4f1-372a-7bba-760d-c2a1f1272b03@kernel.dk>
Date:   Thu, 26 Nov 2020 08:50:42 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <687c411007d0ec6a2be092ddc0274046898e43b5.1606329549.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/25/20 11:41 AM, Pavel Begunkov wrote:
> When one task is in io_uring_cancel_files() and another is doing
> io_prep_async_work() a race may happen. That's because after accounting
> a request inflight in first call to io_grab_identity() it still may fail
> and go to io_identity_cow(), which migh briefly keep dangling
> work.identity and not only.
> 
> Grab files last, so io_prep_async_work() won't fail if it did get into
> ->inflight_list.
> 
> note: the bug shouldn't exist after making io_uring_cancel_files() not
> poking into other tasks' requests.

Applied, thanks.

-- 
Jens Axboe

