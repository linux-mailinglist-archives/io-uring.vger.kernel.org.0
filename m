Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D9931DB75A
	for <lists+io-uring@lfdr.de>; Wed, 20 May 2020 16:47:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbgETOrj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 20 May 2020 10:47:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726840AbgETOrj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 20 May 2020 10:47:39 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70EE0C05BD43
        for <io-uring@vger.kernel.org>; Wed, 20 May 2020 07:47:39 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id x10so1425020plr.4
        for <io-uring@vger.kernel.org>; Wed, 20 May 2020 07:47:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=kArQ+7y4L6frg88ICtlSJa9zVlyeVvUtuDGqusIcsBk=;
        b=WnNmS2VBKjBI77hVvKte2NJr2utSHOxsd68MFTv7UPPkqqjByh4JvmD+jk+s79+RN2
         bPgfEc19G9eaqjZe3NK8v4whqk0JP3eKYu8zdFCguqv3sV7ZehXtS8NyQTltFjx1Mlac
         CQUVxU6sLNo6k90DkqRPu4DU1V/CKLjkyaWvRhzYd4Hdq+jIygmgR/Bh6pC/uyWu3kdk
         x9f/ehyF4kFW7/6ffqCVlxU6TI2zyv+OpKq2Zl3WCpW5BVB6+/rsE8Uo8ChJ0cZtfNMA
         tO+zASgkMfIUOc5JURKjuLT8EilupPcd0QCNLmMlp72oodOzoH2d0M36VohaTisvvvPm
         STZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kArQ+7y4L6frg88ICtlSJa9zVlyeVvUtuDGqusIcsBk=;
        b=Tnwj1R6bYkv3av5LVUvyvAgTUtMvEKIjhoajW2rSRzyWduj7rG8XcK5AuXlZKAR9JK
         9gLi3pLUjcuhALKQfTp+00fyoombLa3UIk1dVQmVm4DiC+H+ZrkCfd3ktqlilN/ZI2ZX
         Ftz9mQbU1e1l14OsUMcXLQGdCfgyofqKHRpj0vJpxqOplaabQ6u8k0eBYvPmAT3dQS6M
         iLXw26aZHIAUOsOs3x8AbAK5U78XE6xz671hSAokQh6xDIruNj03rEe4YUgTmw3n94/n
         yoChFN8CjeqI4YRAHJPqOJnRlzglnqrctJHGZTdnoXq3R1/FmV5JNATPz9EkPDv8R8qO
         qNIg==
X-Gm-Message-State: AOAM5325ZExNTIgweETvSlHxnfx7vjgoszqQgK4EwxE6NFSi2Xd/6Odf
        29XwqDpAGdLVZh8c3d6xCsijGY0/Dq8=
X-Google-Smtp-Source: ABdhPJxNP8jNR/AeDMvtQX+mgoEcBr8O0kpb7Aq9uRE7lSIIlhtfMvDn1adZ2FD9SnGCkGedpejq5Q==
X-Received: by 2002:a17:902:8ec5:: with SMTP id x5mr4948289plo.149.1589986058525;
        Wed, 20 May 2020 07:47:38 -0700 (PDT)
Received: from [192.168.86.156] (cpe-75-85-219-51.dc.res.rr.com. [75.85.219.51])
        by smtp.gmail.com with ESMTPSA id q201sm2398914pfq.40.2020.05.20.07.47.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 May 2020 07:47:37 -0700 (PDT)
Subject: Re: io_uring vs CPU hotplug, was Re: [PATCH 5/9] blk-mq: don't set
 data->ctx and data->hctx in blk_mq_alloc_request_hctx
To:     Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>
Cc:     linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        linux-block@vger.kernel.org, John Garry <john.garry@huawei.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.com>, io-uring@vger.kernel.org
References: <20200518093155.GB35380@T590>
 <87imgty15d.fsf@nanos.tec.linutronix.de> <20200518115454.GA46364@T590>
 <20200518131634.GA645@lst.de> <20200518141107.GA50374@T590>
 <20200518165619.GA17465@lst.de> <20200519015420.GA70957@T590>
 <20200519153000.GB22286@lst.de> <20200520011823.GA415158@T590>
 <20200520030424.GI416136@T590> <20200520080357.GA4197@lst.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <8f893bb8-66a9-d311-ebd8-d5ccd8302a0d@kernel.dk>
Date:   Wed, 20 May 2020 08:45:23 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200520080357.GA4197@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/20/20 2:03 AM, Christoph Hellwig wrote:
> On Wed, May 20, 2020 at 11:04:24AM +0800, Ming Lei wrote:
>> On Wed, May 20, 2020 at 09:18:23AM +0800, Ming Lei wrote:
>>> On Tue, May 19, 2020 at 05:30:00PM +0200, Christoph Hellwig wrote:
>>>> On Tue, May 19, 2020 at 09:54:20AM +0800, Ming Lei wrote:
>>>>> As Thomas clarified, workqueue hasn't such issue any more, and only other
>>>>> per CPU kthreads can run until the CPU clears the online bit.
>>>>>
>>>>> So the question is if IO can be submitted from such kernel context?
>>>>
>>>> What other per-CPU kthreads even exist?
>>>
>>> I don't know, so expose to wider audiences.
>>
>> One user is io uring with IORING_SETUP_SQPOLL & IORING_SETUP_SQ_AFF, see
>> io_sq_offload_start(), and it is a IO submission kthread.
> 
> As far as I can tell that code is buggy, as it still needs to migrate
> the thread away when the cpu is offlined.  This isn't a per-cpu kthread
> in the sene of having one for each CPU.
> 
> Jens?

It just uses kthread_create_on_cpu(), nothing home grown. Pretty sure
they just break affinity if that CPU goes offline.

-- 
Jens Axboe

