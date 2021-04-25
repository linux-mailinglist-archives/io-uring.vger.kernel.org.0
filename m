Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68FE836A85E
	for <lists+io-uring@lfdr.de>; Sun, 25 Apr 2021 18:28:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230332AbhDYQ3V (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 25 Apr 2021 12:29:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230329AbhDYQ3V (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 25 Apr 2021 12:29:21 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2E5EC061574
        for <io-uring@vger.kernel.org>; Sun, 25 Apr 2021 09:28:39 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id h11so6350837pfn.0
        for <io-uring@vger.kernel.org>; Sun, 25 Apr 2021 09:28:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=pZEmhYE3eQdeY9BO2VzqpO96ltdpOoetlUpIGSEzlgk=;
        b=Ml5rksRaPiLUo+M/jCNv9SOqssPz24zxGGBa6sc6JfZcI7LVNVmQvov8OlfDrQ4mQd
         QURTMkAhrs+1wRiLI98q4/Z/ccAmn2nYPAwJ93ix/dyiLkVzqgQQxQ82wl3vZmVhRrSK
         RITGjVWob5hi0ml7+M4OkUMrZYI/EQyFLTEpWCz15FYX3XvEDzUb/SBveJZf5nZnvxTB
         c70yDnvEes3rdNwPsj1xRCYN52yu+kuSfhAbsc0pIT97ryczkhLlOtx1f+gK+fQCnRtG
         KLUzEr+vSGALSTWeejA7bErI4YQU/NvkgXSWCG9lUIBtzzWQj6NNLp+xGZmYo1SRLQqk
         MkhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pZEmhYE3eQdeY9BO2VzqpO96ltdpOoetlUpIGSEzlgk=;
        b=AeAKbf9oVm2AjVjV+xF7yvudvFjAgz3thFpgBGJjXr+WorvruCFEBI+goDWEhQqmZI
         /zzeo1Yvifx69aZriFD01MogRFmE8ceBvFVGGj9xLhG50bwscdQP+yleaurd/5WGso0E
         lOClUjPIUAo6eAdSJ+CL/7iBigzMn5VBpomNRFCtMNbB9+gEF1s3a7RE+Gb0nrktkCM2
         k+dplqpDBKxhya2qVWU5vDTk6oad3C5SlGzhi/Wcv3E191LUWKj8diec8j9TM9eKlvP/
         L98AF7IXsRIOao0g5qUTWfqQijFZJNGK2P+52AEY1158xSl2oG7WteYUFT5kZIg3BMGZ
         FYXw==
X-Gm-Message-State: AOAM5311AX53ZHXMZ5YYQ54WZkgtTvFDAohjI3IkB9yCGWTiMnDT5/Fh
        h5c8mbogvtZagk4mjcrpYdkguPiR8Tdnqg==
X-Google-Smtp-Source: ABdhPJzayy8Wtf857WjAtuSYfj2fhND9T8qP6hr8khhh300XT5mi1jHQLUS98VCH46yLuk2juX9ImA==
X-Received: by 2002:a63:2445:: with SMTP id k66mr13045243pgk.62.1619368119021;
        Sun, 25 Apr 2021 09:28:39 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id n85sm9563607pfd.170.2021.04.25.09.28.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 25 Apr 2021 09:28:38 -0700 (PDT)
Subject: Re: [PATCH v3 0/6] Complete setup before calling wake_up_new_task()
To:     Stefan Metzmacher <metze@samba.org>, io-uring@vger.kernel.org
References: <cover.1619306115.git.metze@samba.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <9ba4228d-d346-766d-de5c-7d7d2bab92fa@kernel.dk>
Date:   Sun, 25 Apr 2021 10:28:39 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1619306115.git.metze@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/24/21 5:26 PM, Stefan Metzmacher wrote:
> Hi,
> 
> now that we have an explicit wake_up_new_task() in order to start the
> result from create_io_thread(), we should set things up before calling
> wake_up_new_task().
> 
> Changes in v3:
>  - rebased on for-5.13/io_uring.
>  - I dropped this:
>   fs/proc: hide PF_IO_WORKER in get_task_cmdline()
>  - I added:
>   set_task_comm() overflow checks

Looks good to me, a few comments:

1) I agree with Pavel that the WARN on overflow is kinda silly,
   it doesn't matter that much. So I'd rather drop those for now.

2) Would really love it to see some decent commit messages, quite
   a few of them are empty. In general some reasoning is nice in
   the commit message, when you don't have the context available.

Do you want to do a v4 with 5-6/6 dropped for now, and 3-4 having
some reasoning? I can also just apply as-is and write some commit
message myself, let me know. I'll add 1-2 for now.

-- 
Jens Axboe

