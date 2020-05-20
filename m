Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A2051DC005
	for <lists+io-uring@lfdr.de>; Wed, 20 May 2020 22:18:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727067AbgETUSk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 20 May 2020 16:18:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726940AbgETUSj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 20 May 2020 16:18:39 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36B17C05BD43
        for <io-uring@vger.kernel.org>; Wed, 20 May 2020 13:18:39 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id s69so1829099pjb.4
        for <io-uring@vger.kernel.org>; Wed, 20 May 2020 13:18:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GD7wbiQVI9rDR+L0sEdN/nHd36x0k4vATNQrzzfPzoU=;
        b=NZ05gz8s6GydpM6eOuzSznetqGRW9eW/02dAMxNfEUCAM4R+pMFoXINk7ro5zVCii9
         jjfDfQggtDRPOnsgnmOwbScCf7gWYW18dSNk7I2YE2Ow/un4uL71VpEsOYWOQLlUU3lV
         xNwHfwD85yMZZpH43YizXLDKZaVzttOu0Yp4IXNdNVxaxk4eFnmWmSGXydslh/oebnfg
         QEb6xgcB518MMvYDug8FuRQ3JAh34QHBEGJizbuoY6Sj4A4nr/MGGkM0Skdw8iqTmD3K
         cxVwr/XsRe5yVRkEr0v1SQgB4XYpJQNJhqmCw1ya1EAFWgkHmuLkjhgU1mgssMgb/k9O
         3wew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GD7wbiQVI9rDR+L0sEdN/nHd36x0k4vATNQrzzfPzoU=;
        b=FvwswVHKy/DWYfEA/f+GY8CitmFji0PMokFGNzDYdN1Acb3Zmy0IZILxGPXj0xXJqS
         WiKaScsT6+oghX0c2tyDpDb0T5akmTQlUGXowMVYNAB1bPvX6SWGYy2CMjtTsSbdKl11
         VnXEppVmsaFCuA6syMeHuKKSG5XPjgGU0bHoV+uQ0h5bGVXx5fJvwph4G6RBf9lWjr8J
         14pjFttAF5Rwa3WU5FXir3C4pItlQQlr4BHi+y6QRuMS3MNnIuaR/Cz4OLc62PzditKk
         6DkQzE+EdXMxtSU1U21wtZ0hgw29HnxXb7OU9hUj3WxRgtp9Dk31lhs2MbKg0dyFUH9J
         0lDQ==
X-Gm-Message-State: AOAM533VL6w1PpyQtGyAcApCtuaN/x55RfqO+PMQeJrRWCmWs+7gz7Bo
        f/dMpODh8pbDNKMHuzljLdvUKMURVgs=
X-Google-Smtp-Source: ABdhPJxusZNKzaTGl4uzCNSAer9ynGVb3v2uIj/wxTVjbrHKoqcG7zisYx84mtxQ+xz2+LlHEXh4oQ==
X-Received: by 2002:a17:90a:648c:: with SMTP id h12mr7504923pjj.229.1590005918384;
        Wed, 20 May 2020 13:18:38 -0700 (PDT)
Received: from [192.168.86.156] (cpe-75-85-219-51.dc.res.rr.com. [75.85.219.51])
        by smtp.gmail.com with ESMTPSA id h4sm2675419pfo.3.2020.05.20.13.18.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 May 2020 13:18:37 -0700 (PDT)
Subject: Re: io_uring vs CPU hotplug, was Re: [PATCH 5/9] blk-mq: don't set
 data->ctx and data->hctx in blk_mq_alloc_request_hctx
To:     Thomas Gleixner <tglx@linutronix.de>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        John Garry <john.garry@huawei.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.com>, io-uring@vger.kernel.org
References: <20200518093155.GB35380@T590>
 <87imgty15d.fsf@nanos.tec.linutronix.de> <20200518115454.GA46364@T590>
 <20200518131634.GA645@lst.de> <20200518141107.GA50374@T590>
 <20200518165619.GA17465@lst.de> <20200519015420.GA70957@T590>
 <20200519153000.GB22286@lst.de> <20200520011823.GA415158@T590>
 <20200520030424.GI416136@T590> <20200520080357.GA4197@lst.de>
 <8f893bb8-66a9-d311-ebd8-d5ccd8302a0d@kernel.dk>
 <448d3660-0d83-889b-001f-a09ea53fa117@kernel.dk>
 <87tv0av1gu.fsf@nanos.tec.linutronix.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <2a12a7aa-c339-1e51-de0d-9bc6ced14c64@kernel.dk>
Date:   Wed, 20 May 2020 14:18:36 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <87tv0av1gu.fsf@nanos.tec.linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/20/20 1:41 PM, Thomas Gleixner wrote:
> Jens Axboe <axboe@kernel.dk> writes:
>> On 5/20/20 8:45 AM, Jens Axboe wrote:
>>> It just uses kthread_create_on_cpu(), nothing home grown. Pretty sure
>>> they just break affinity if that CPU goes offline.
>>
>> Just checked, and it works fine for me. If I create an SQPOLL ring with
>> SQ_AFF set and bound to CPU 3, if CPU 3 goes offline, then the kthread
>> just appears unbound but runs just fine. When CPU 3 comes online again,
>> the mask appears correct.
> 
> When exactly during the unplug operation is it unbound?

When the CPU has been fully offlined. I check the affinity mask, it
reports 0. But it's still being scheduled, and it's processing work.
Here's an example, PID 420 is the thread in question:

[root@archlinux cpu3]# taskset -p 420
pid 420's current affinity mask: 8
[root@archlinux cpu3]# echo 0 > online 
[root@archlinux cpu3]# taskset -p 420
pid 420's current affinity mask: 0
[root@archlinux cpu3]# echo 1 > online 
[root@archlinux cpu3]# taskset -p 420
pid 420's current affinity mask: 8

So as far as I can tell, it's working fine for me with the goals
I have for that kthread.

-- 
Jens Axboe

