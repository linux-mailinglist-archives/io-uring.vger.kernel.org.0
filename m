Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E837320A795
	for <lists+io-uring@lfdr.de>; Thu, 25 Jun 2020 23:37:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407271AbgFYVhb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Jun 2020 17:37:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403961AbgFYVha (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Jun 2020 17:37:30 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DE5EC08C5C1
        for <io-uring@vger.kernel.org>; Thu, 25 Jun 2020 14:37:30 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id d66so3653244pfd.6
        for <io-uring@vger.kernel.org>; Thu, 25 Jun 2020 14:37:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=NKpz+ygF/rgH/Rv5L0zxbGKkYxmjzocITSI++fZ5xL0=;
        b=OMrSy6fdc94XZSeVnW9lv3sPJB0QyLnIYiqWAFqUpT2YLnpWY5N8rmG2UcRcCIYznl
         yMb3u7Wj5u2mqtOlnRaeH5DrCCUHwhda0mgnNyaGbXDqoE+yp98a9ZsX+BV0W2G9VHcE
         cX+/XaPTOVNR/681n0gepEqxCVUe7lF0ElrZ5An7Yuh0OouCgGIvL7Icxjr7uuxLGl4Q
         vNjITRuPmtFWVPqVg+U9K0xE72xT4jb0oew/SQL6ufDvtMoPdqHqhfb92BHFdI6F+TZF
         3cTNz6DRDztFoqELwFZvnh2viRWpebGtNcmlKl+LVdC6+QYzaAkzri2wO/jf03Hopq8P
         Ebyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NKpz+ygF/rgH/Rv5L0zxbGKkYxmjzocITSI++fZ5xL0=;
        b=MV3YVWlAiiFXCQzj4SoJAsWyS9CNB/1OTsOPlBvb83VxAq4Z0zXgEJKxtAOYa72NKy
         fvxoNfo3bc/yTXC0/8l2q/4OAISKCd34cqs2CQ+F0C6eULi9+f+rPunhz9foR7F8xv6x
         idSo70bLjdK0RJSTQj8zyqPlk38sB66bROHinjCWzswm1E5OSvtDXO8e1BbOnzF77zLp
         muUG1fiMYubJS90umtRqNmt99t3nOvFQuQ0dnlEIP7DHdJmqri3zJlDgJ09B+/Y3DRPF
         uunbPtrJmOue4V/CkT+59SU1K5PuQzyEjWbd9dtSfaeC0cxzY9HSolK5DSS5R/ZqUdtw
         cIjw==
X-Gm-Message-State: AOAM533ms7LSd0F8F8NDEoySfAmbgQVPYzy0+uZqYIjV3HwQFwbMBGOR
        3xDzHSDTOUh2E9uaZ1VOxujGZbU+ia9rtw==
X-Google-Smtp-Source: ABdhPJxS9pBBrKUdIHzDnFrdMJY0hhTjc2SCZig9LklwN8R/8L6z4Medgl7jYo4jl1+FVaqI3frT3A==
X-Received: by 2002:a63:a84d:: with SMTP id i13mr26983331pgp.342.1593121049448;
        Thu, 25 Jun 2020 14:37:29 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id h3sm254926pjz.23.2020.06.25.14.37.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Jun 2020 14:37:28 -0700 (PDT)
Subject: Re: [PATCH] io_uring: use task_work for links if possible
To:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
References: <421c3b22-2619-a9a2-a76e-ed8251c7264c@kernel.dk>
 <e9fe5b4d-4058-dda7-eed4-2c577825aca4@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <68603efe-8cb4-b431-fc07-652342237a23@kernel.dk>
Date:   Thu, 25 Jun 2020 15:37:27 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <e9fe5b4d-4058-dda7-eed4-2c577825aca4@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

> 
On 6/25/20 2:28 PM, Pavel Begunkov wrote:
> On 25/06/2020 21:27, Jens Axboe wrote:
>> Currently links are always done in an async fashion, unless we
>> catch them inline after we successfully complete a request without
>> having to resort to blocking. This isn't necessarily the most efficient
>> approach, it'd be more ideal if we could just use the task_work handling
>> for this.
> 
> Well, you beat me on this. As mentioned, I was going to rebase it after
> lending iopoll fixes. Nice numbers! A small comment below, but LGTM.
> I'll review more formally on a fresh head.

I thought you were doing this for the retry -EAGAIN based stuff, didn't
know you had plans on links! If so, I would have left it alone. This was
just a quick idea and execution this morning.

> Could you push it to a branch? My other patches would conflict.

Yep, I'll push it out now.

>> +static void __io_req_task_submit(struct io_kiocb *req)
>> +{
>> +	struct io_ring_ctx *ctx = req->ctx;
>> +
>> +	__set_current_state(TASK_RUNNING);
>> +	if (!io_sq_thread_acquire_mm(ctx, req)) {
> 
> My last patch replaced it with "__" version. Is it merge problems
> or intended as this?

I'll make sure it applies on for-5.9/io_uring, and then I'll sort out
any merge issues by pulling in io_uring-5.8 to there, if we need to.

-- 
Jens Axboe

