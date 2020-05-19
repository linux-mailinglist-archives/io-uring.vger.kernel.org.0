Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B2071DA443
	for <lists+io-uring@lfdr.de>; Wed, 20 May 2020 00:08:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725998AbgESWIw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 19 May 2020 18:08:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725885AbgESWIw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 19 May 2020 18:08:52 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83B37C061A0F
        for <io-uring@vger.kernel.org>; Tue, 19 May 2020 15:08:52 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id y198so546345pfb.4
        for <io-uring@vger.kernel.org>; Tue, 19 May 2020 15:08:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lCzwIoRbV3B/hFbrk4toi540Jp/BjB7SwvJd+Fkfoq4=;
        b=zT0/RR/2xy0+G/k113AsV6/mKtuEcl24T8m+MvXUK/BIfEujMW82rYThPi4zCgk0lG
         iFrJlAtUUzEdEcPqVMkIs7zwF68OMCd2WB3Wc5JUZ/RiQ7K6Ol/+zK2aAfXRtUvWJPY8
         S9ByCA8tkxbh2Dk32dFZ3/AODXJ0e3zzdJrYfC10Xk/CJJlDhFSJbjyAyZriVm3RZe3/
         BUTBbzbucI3KggDwHA3dNZyFiTXjnqw+QnPe7VsLBcV5V2VwZhCEC3JU0jBkCW2qDbCC
         wme8qg7+vtJ2Ogu3nMDFQb17G0l+5qURKzHizJyMIRbp7svY6VPhvl6X6qOb43SwUI/l
         +Syg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lCzwIoRbV3B/hFbrk4toi540Jp/BjB7SwvJd+Fkfoq4=;
        b=RdCrFF5V7hcho9V1zy2icy04ZQO3j/O74/5FN8FUROj8+fpkFaGF2utFwo97OXwzSx
         +MBOoCSCY4r0MPmkAl5rQKNAO+EwiN6TFR/BjJcwZeuZ8mbmjQSCEn17HBgZ3HhrRycd
         MR9cXeHi86WZsS7hoGwgn28RjSkZ4vG8+SUrNdM/0vkussWMWlApghy/QZVVE6MmVymB
         ts8cLsdUmWuVhLjo56A5E1a0e56TP4/Vc+1Zl6OGqP8NshrEyeUJ2dVH4lmStpzPWYXM
         Hqkvw0IvNt0HN0fvfdxKlK8vFbp8tMM+jrHK6JCui3E5MlvFmFvfYieHQd5g7mY8DLxu
         EuWw==
X-Gm-Message-State: AOAM5310eqrmfSswgCYLtYYanepttadnAgqM7Zd3NOtFkBkINQ9qOpeb
        6fQQDBR6W8GFWOkdcobrTthW94DD0L8=
X-Google-Smtp-Source: ABdhPJzc25Oru4THiuVmwn2xqQGwJ/YnOgAN0/q96lVJbMVBMFkBLP414V/efcgcFZDTZkWMdo9PUg==
X-Received: by 2002:a63:5307:: with SMTP id h7mr1243403pgb.28.1589926131534;
        Tue, 19 May 2020 15:08:51 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:14f4:acbd:a5d0:25ca? ([2605:e000:100e:8c61:14f4:acbd:a5d0:25ca])
        by smtp.gmail.com with ESMTPSA id 73sm349495pge.15.2020.05.19.15.08.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 May 2020 15:08:50 -0700 (PDT)
Subject: Re: liburing 500f9fbadef8-test test failure on top-of-tree
To:     Jeff Moyer <jmoyer@redhat.com>
Cc:     io-uring@vger.kernel.org
References: <x49d06zd1u2.fsf@segfault.boston.devel.redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <45c638c9-1ff1-efe8-7698-fb53fceb15a7@kernel.dk>
Date:   Tue, 19 May 2020 16:08:49 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <x49d06zd1u2.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/19/20 3:58 PM, Jeff Moyer wrote:
> Hi,
> 
> This test case is failing for me when run atop a dm device.  The test
> sets up a ring with IO_SETUP_IOPOLL, creates a file and opens it with
> O_DIRECT, and then issues a writev.  The writev operation is returning
> -22 (-EINVAL).  The failure comes from this check inside io_import_iov:
> 
> 	/* buffer index only valid with fixed read/write, or buffer select  */
>         if (req->rw.kiocb.private && !(req->flags & REQ_F_BUFFER_SELECT))
>                 return -EINVAL;
> 
> req->rw.kiocb.private is being used by the iomap code to store a pointer
> to the request queue.  The sequence of events is as follows:
> 
> io_write is called in the context of the system call, it calls
> call_write_iter, which returns -EAGAIN.  The I/O is punted to a
> workqueue.
> 
> The work item then tries to issue the I/O after clearing IOCB_NOWAIT,
> and for some reason fails again with -EAGAIN.
> 
> On the *third* call to io_write, the private pointer has been
> overwitten, and we trigger the above -EINVAL return.
> 
> I have no idea why we're getting EAGAIN on the first call in the
> workqueue context, so I'm not sure if that's the problem, of if we
> simply can't use the kiocb.private pointer for this purpose.  It seems
> clear that once we've called into the iomap code, we can't rely on the
> contents of kiocb.private.
> 
> Jens, what do you think?

See: https://lore.kernel.org/io-uring/1589925170-48687-1-git-send-email-bijan.mottahedeh@oracle.com/T/#m9cec13d26c0b2db03889e1b36c9bcc20f4f8244a

-- 
Jens Axboe

