Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28F573E16E2
	for <lists+io-uring@lfdr.de>; Thu,  5 Aug 2021 16:25:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236413AbhHEO0J (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 5 Aug 2021 10:26:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241996AbhHEOYM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 5 Aug 2021 10:24:12 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA688C061765
        for <io-uring@vger.kernel.org>; Thu,  5 Aug 2021 07:23:57 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id s22-20020a17090a1c16b0290177caeba067so15245939pjs.0
        for <io-uring@vger.kernel.org>; Thu, 05 Aug 2021 07:23:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=858+JgFEq54p+jEekDQ8e9YcK1VD4v20N1yyQTMouF0=;
        b=ED9Y6asNk8rbdkrsJdY1LT56f4E/XJOVUiS24yLeu2OtyeYJm9cCKL0Xq0P2097MoQ
         U8XesZEimy5kwjDe3kUBORrtFlPRxSDtuHBNzvolPaDWcb28DbWgufL1NX4AYSwdLZ1S
         wUnt+G8wS1QApbNW2Sr+oVxUVA2TjY+8bWAcdA7dY8r/vY7fweROuWbxuJGpM3sop77B
         8qa0yNR1uW/QkUtGxw6Sznmhl3woRtrA2/9gzRQoN/8NtiEVkDf3LfFvqPWtSpRcpMWM
         EwA8MwBPXIeiytYQAuweXoMC7afsLFqKTfk/ZeJJA8m8sjiAaMLfilh/8afbRzdW3Ld7
         s1bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=858+JgFEq54p+jEekDQ8e9YcK1VD4v20N1yyQTMouF0=;
        b=Mb+LXA5XIzChx9y55DtZQK6J2HhhuvYUyMxi/CwT/PuG+nZ+AJXYa6bQSNjWW1WhP+
         GddQlJAq8/ZecMiyL3q7ouIxuG31C0bJ9td+BtDJU6HnYXscSZnql1CXpN9QimlzZwsn
         6S0C4w9GB2Z80GyQXJKzNmRcwJFl4T7pd04XHjVEQgP/gG4qVCCIOovS3PGl6V1b8SW7
         eGy6LoEYCoC/NvAfxgv3RALCWo0w+0yffP5ZH8P9WjtQww2mdXJnITNKgr+Y2bzJMBE8
         pC7sTc5nVSMsJnmE7WTH/HgVZhhofAeRHbV6QE7OcOdYRnvPkNl0Tyk/GJCRzhQ9g5KQ
         5JkA==
X-Gm-Message-State: AOAM531kzl+dJCCIG+uZv2IqE2lAXnf96wCSM89iGlJE7s6XJ4jAdcGX
        tExSKp01rC5ES3cqc8HhxbbZ7Q==
X-Google-Smtp-Source: ABdhPJzeDHlmidAkeiSnDe0dQ29DXG4azflM/ABpLsgOkqhSjBLoqRLXhr1NiGRmyb/i5EgfvcqW6Q==
X-Received: by 2002:a17:90b:3e84:: with SMTP id rj4mr5052127pjb.66.1628173437270;
        Thu, 05 Aug 2021 07:23:57 -0700 (PDT)
Received: from [192.168.1.116] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id jz24sm6205224pjb.9.2021.08.05.07.23.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Aug 2021 07:23:56 -0700 (PDT)
Subject: Re: [PATCH 1/3] io-wq: clean code of task state setting
To:     Hao Xu <haoxu@linux.alibaba.com>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20210805100538.127891-1-haoxu@linux.alibaba.com>
 <20210805100538.127891-2-haoxu@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <cb24ad6d-cbab-a424-db7a-6a5e1f2feb74@kernel.dk>
Date:   Thu, 5 Aug 2021 08:23:55 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210805100538.127891-2-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/5/21 4:05 AM, Hao Xu wrote:
> We don't need to set task state to TASK_INTERRUPTIBLE at the beginning
> of while() in io_wqe_worker(), which causes state resetting to
> TASK_RUNNING in other place. Move it to above schedule_timeout() and
> remove redundant task state settings.

Not sure that is safe - the reason why the state is manipulated is to
guard from races where we do:

A				B
if (!work_available)
				Work inserted
schedule();

As long as setting the task runnable is part of the work being inserted,
then the above race is fine, as the schedule() turns into a no-op.

-- 
Jens Axboe

