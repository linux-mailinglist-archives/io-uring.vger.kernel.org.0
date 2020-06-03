Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54CB61ED2AC
	for <lists+io-uring@lfdr.de>; Wed,  3 Jun 2020 16:55:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726046AbgFCOzn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 3 Jun 2020 10:55:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725985AbgFCOzn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 3 Jun 2020 10:55:43 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1C42C08C5C0;
        Wed,  3 Jun 2020 07:55:42 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id k26so2406873wmi.4;
        Wed, 03 Jun 2020 07:55:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:references:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GmSNSg3YXvvUzlfhKudE+w98HhJvZWAxIZMMgzoIw9U=;
        b=ltpV/5FxWNRh7EZYO/1DcV+Yl1LSmCheEXrf5TzJu+KuLgK4t29/tyzoelxppeDjEf
         q+Eg2kPgsHcdslW2KD4qa71hhBMiQ3FAkHixeywcrW+AgdEsJNPIg9hDBPBTHJm35bDq
         EGjFOvSiQklY3NncbDbTHMnT6HxR1X2G4KUFlnvHZHOiP+mFVtifiJAAwACCvOxCTzUf
         FGk9FVhuF+PrinbPKudRBALNiokhFboMpyGupeCT/QMGBs92uNKQyxh0jUaxeTI75QYv
         Vt6Nf4KuyAvGzDi73sU5NlEFYlMhma/mKSsgAiCPd+NoSC6hvsjzAx0mcIiBp74TRkgM
         6ZgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GmSNSg3YXvvUzlfhKudE+w98HhJvZWAxIZMMgzoIw9U=;
        b=IYNURTbiCfiRLZWNC74xDe86LjQ5LwoM7RuC3EcopnUSGSa1sAdyHd0iXJQTyYmV69
         uxOjQOqPFfufa7fWaPMuxspq8WbM2LSsZqBZipG9C7+N7IjFh0Jqb/FpiEYLB71tnqhE
         exujw9af74xVsUYXWx5vgSurVBuvKPIXoUPkA71FFxcP5C+QHykaca+ssP3aGyCcGloD
         Y8bZEElHZPqcmUgY5GSlGrYediwN62+pfv9ilS16a4YEvaewIp+DQ2VAJZt/TerwEuye
         rhZCGH9vU5H15Rv6M9vOisnPNBSLXlK6/iteL1D0fGZOY8hExNOTgTl2mOt1XVDAbfR4
         Wqdw==
X-Gm-Message-State: AOAM531ZBRNpg/8UNAHF3kAh5YcAbMq+QEawhmwGHIE6Ce26tV2bPIM4
        wRFTNy0MYVkiPLA42PZlfyJfXfLl
X-Google-Smtp-Source: ABdhPJwavCCFm1jZ5ZnavYiEcIXHrkJ58oKMTONm75gc/AeMWKfqi/bS3WQxyk9Geh1UUNUSmcPzig==
X-Received: by 2002:a7b:c5d4:: with SMTP id n20mr9622295wmk.106.1591196141383;
        Wed, 03 Jun 2020 07:55:41 -0700 (PDT)
Received: from [192.168.43.154] ([5.100.193.151])
        by smtp.gmail.com with ESMTPSA id c143sm4494857wmd.1.2020.06.03.07.55.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Jun 2020 07:55:40 -0700 (PDT)
Subject: Re: [PATCH v2 0/4] forbid fix {SQ,IO}POLL
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1591190471.git.asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <fa8f2884-771c-78e0-5169-126fa9566610@gmail.com>
Date:   Wed, 3 Jun 2020 17:54:23 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <cover.1591190471.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Something went wrong, don't mind it

On 03/06/2020 16:29, Pavel Begunkov wrote:
> The first one adds checks {SQPOLL,IOPOLL}. IOPOLL check can be
> moved in the common path later, or rethinked entirely, e.g.
> not io_iopoll_req_issued()'ed for unsupported opcodes.
> 
> 3 others are just cleanups on top.
> 
> 
> v2: add IOPOLL to the whole bunch of opcodes in [1/4].
>     dirty and effective.
> 
> Pavel Begunkov (4):
>   io_uring: fix {SQ,IO}POLL with unsupported opcodes
>   io_uring: do build_open_how() only once
>   io_uring: deduplicate io_openat{,2}_prep()
>   io_uring: move send/recv IOPOLL check into prep
> 
>  fs/io_uring.c | 94 ++++++++++++++++++++++++++-------------------------
>  1 file changed, 48 insertions(+), 46 deletions(-)
> 

-- 
Pavel Begunkov
