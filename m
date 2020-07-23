Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAF1A22B31B
	for <lists+io-uring@lfdr.de>; Thu, 23 Jul 2020 18:04:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726649AbgGWQEA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 23 Jul 2020 12:04:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726621AbgGWQD7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 23 Jul 2020 12:03:59 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0447C0619DC
        for <io-uring@vger.kernel.org>; Thu, 23 Jul 2020 09:03:59 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id mn17so3363446pjb.4
        for <io-uring@vger.kernel.org>; Thu, 23 Jul 2020 09:03:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=B+LtgEcknVr2F3HrFuGabeOVdaXAoRXsGEU3STXHAPg=;
        b=EIVG7U+wmwe4ut93G/gS+//OZwd98mUs3anGz1CYBjItzzb3u6RF9Mkbm9h9MUdsF7
         96TTCYC8wr8gIUg7zA5qX+y7xtt8JhTbCFx4s2Q+kko6A8lgZ8y3BP7sDjwR6BNPWE7y
         sYBIrehTngyiRYeQVbH0aKrvEDXAPhilHvxB7oLK9aekWRr2Q3X9e+uQSbYI5V5TWbdq
         6fknVQwOtZCFaNK2yLcKdLw+gSEGw4DOhfuICVSRkDUtr9V3wVI7Kkg4mEXzsRIkVm5l
         OZfXiXl83ZEFsiUyQ2oiaW0SCF0JdaNscIqjh4Fy0koj+Kl0TfimIztFdziPDvsgRYii
         uxaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=B+LtgEcknVr2F3HrFuGabeOVdaXAoRXsGEU3STXHAPg=;
        b=QDzfcfkKZi74tDfhJIEFwNwAvH8ppUW3FV7gEkU4HAXST9ndAs+Y4ZXR18BoxRXZo7
         rbB5F6XX54ZIA4yWndzFJasr9eU+hd9PyLo7FzWDJg/RwuDfil68vaHKYciMS7Z9mD2L
         caof6Ze0HDa703/e5QOAjfgCob/qs1IesqZ8BFnlGV6wK+gteB5Iq3uw98db15cMcAso
         4vwwlRHIH+MP8pA3OFWT8Ctw3wgJG1gGN/lzXgzfmHXYbdNKRUZcLZ1QKbPdEClZ9zrX
         2nouVqAZnHQ/RaTQHGuJo6L7xiLT6kHVjbhoOhszV9djmy8BmpMsHGxLEmj5OkO54koj
         +OxA==
X-Gm-Message-State: AOAM531fZdUFQqFie+Ak+4QSF3DV8ebIjAHUZEnUBUyntZQ1kwpStttO
        CWB42yrfIaILnBdsUCTZOZP9RPhq1ttClg==
X-Google-Smtp-Source: ABdhPJydyVZ+G8yB0rmUo0iGD5N41uZzcNauJup/xEZlGWDtJk1uWncZaLCUaIXhuGzO5gyDDi4Ejg==
X-Received: by 2002:a17:90a:f007:: with SMTP id bt7mr1057069pjb.214.1595520238666;
        Thu, 23 Jul 2020 09:03:58 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id m20sm3470720pgn.62.2020.07.23.09.03.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jul 2020 09:03:58 -0700 (PDT)
Subject: Re: [PATCH] io_uring: clear IORING_SQ_NEED_WAKEUP after executing
 task works
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     joseph.qi@linux.alibaba.com
References: <20200723125724.1938-1-xiaoguang.wang@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <5077c8f2-7991-6304-0c25-98598a93921f@kernel.dk>
Date:   Thu, 23 Jul 2020 10:03:56 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200723125724.1938-1-xiaoguang.wang@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/23/20 6:57 AM, Xiaoguang Wang wrote:
> In io_sq_thread(), if there are task works to handle, current codes
> will skip schedule() and go on polling sq again, but forget to clear
> IORING_SQ_NEED_WAKEUP flag, fix this issue. Also add two helpers to
> set and clear IORING_SQ_NEED_WAKEUP flag,

Was pondering if we should make the new helpers conditional ala:

static inline void io_ring_set_wakeup_flag(struct io_ring_ctx *ctx)
{
	/* Tell userspace we may need a wakeup call */
	if (!(ctx->rings->sq_flags & IORING_SQ_NEED_WAKEUP)) {
		spin_lock_irq(&ctx->completion_lock);
		ctx->rings->sq_flags |= IORING_SQ_NEED_WAKEUP;
		spin_unlock_irq(&ctx->completion_lock);
	}
}

static inline void io_ring_clear_wakeup_flag(struct io_ring_ctx *ctx)
{
	if (ctx->rings->sq_flags & IORING_SQ_NEED_WAKEUP) {
		spin_lock_irq(&ctx->completion_lock);
		ctx->rings->sq_flags &= ~IORING_SQ_NEED_WAKEUP;
		spin_unlock_irq(&ctx->completion_lock);
	}
}

but don't see any need after looking closer. So patch looks fine to me,
thanks.

-- 
Jens Axboe

