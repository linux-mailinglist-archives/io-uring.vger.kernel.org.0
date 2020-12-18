Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AFB52DE652
	for <lists+io-uring@lfdr.de>; Fri, 18 Dec 2020 16:16:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726277AbgLRPQN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 18 Dec 2020 10:16:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726212AbgLRPQM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 18 Dec 2020 10:16:12 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B03E6C0617A7
        for <io-uring@vger.kernel.org>; Fri, 18 Dec 2020 07:15:32 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id lj6so1462718pjb.0
        for <io-uring@vger.kernel.org>; Fri, 18 Dec 2020 07:15:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YZ1IcxiNKpaLMxQN9FlOWEaqjiPRkOVSz79JzXYKRd4=;
        b=PUPjLsp7lH8tp/GWquQw+hS37V+9sTmIYcHWEp2pN+fxCIqjy8I0I+5wQRVaku+PQm
         0FjNKCMaxXmOjSwER5DW7MeXLZxDkG0yjKgrKZV2hiS5QtP6osXc6M/04JD82Mb0VbRf
         ++OqsT+liyw7tDLFx/Vl8Sm12Kz1qrUgxn2QknhjdOyDlR4i9JSI6uH1Wgh1CP7OCfcj
         xC/Y76Ck/w7MH+bKZtJJfenqqEMzPzoku3WYvoWqadqbqiJUmvUg1qKP63x9dar1EiEo
         9GR38CJF45f6b5yk7VT++3OK8eVGYxZBDQd7l0C1iTvY6zvixU+Vb+xQ3V9Sle+23Alt
         4CSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YZ1IcxiNKpaLMxQN9FlOWEaqjiPRkOVSz79JzXYKRd4=;
        b=XOYFp/6Z9Y4jctrb3kUY1Cuht+VP4gQiZyfNvIqbSZUtE6iJOTX+nyo17HmKoH7WJL
         RTdBwsAT6svtp+VPrphdAqR5ULXyVyUqT3IBdMdyCvhkASyDB7HN08qRmJTGzhd3q8OP
         Azif0nM/eD8K/HawKoeYouqzuzMnJH+AjJUUV804SeDB4dZE9KM7g6uAh/9sa+Wfb4rt
         /8pVJ8jXfmB1MdXtLeyZY+xJgl7JrlH31duMvvanqHcckPZybr2fotsrLXlZImVSbC9+
         RIhXezP9eafyBbYWLsOIKHelYgsKwjKAHycIl/oRKzCVsPj3ixg9JZ1A4OeQ8MH+1pQW
         r8bg==
X-Gm-Message-State: AOAM532+QI+CNdE5h+fsTziNknCd7TaDa++du7LLLDNL5vdpibSZLhRq
        lTyU0vO9mj/kIK5OWT5BNkizBg==
X-Google-Smtp-Source: ABdhPJy7CbTcXsAh9WYlpj+sSzXmBfa3OHwXBBk8F2a2+66dd7suxEoQ2cXH3i7vCBS97orNDDjaEg==
X-Received: by 2002:a17:90b:4acc:: with SMTP id mh12mr4886209pjb.54.1608304532136;
        Fri, 18 Dec 2020 07:15:32 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id 197sm9462156pgg.43.2020.12.18.07.15.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Dec 2020 07:15:31 -0800 (PST)
Subject: Re: [PATCH] io_uring: fix io_wqe->work_list corruption
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com, joseph.qi@linux.alibaba.com
References: <20201218072648.9649-1-xiaoguang.wang@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <e7e54052-73ea-4f57-7c13-5bcc65008041@kernel.dk>
Date:   Fri, 18 Dec 2020 08:15:30 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201218072648.9649-1-xiaoguang.wang@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/18/20 12:26 AM, Xiaoguang Wang wrote:
> For the first time a req punted to io-wq, we'll initialize io_wq_work's
> list to be NULL, then insert req to io_wqe->work_list. If this req is not
> inserted into tail of io_wqe->work_list, this req's io_wq_work list will
> point to another req's io_wq_work. For splitted bio case, this req maybe
> inserted to io_wqe->work_list repeatedly, once we insert it to tail of
> io_wqe->work_list for the second time, now io_wq_work->list->next will be
> invalid pointer, which then result in many strang error, panic, kernel
> soft-lockup, rcu stall, etc.
> 
> In my vm, kernel doest not have commit cc29e1bf0d63f7 ("block: disable
> iopoll for split bio"), below fio job can reproduce this bug steadily:
> [global]
> name=iouring-sqpoll-iopoll-1
> ioengine=io_uring
> iodepth=128
> numjobs=1
> thread
> rw=randread
> direct=1
> registerfiles=1
> hipri=1
> bs=4m
> size=100M
> runtime=120
> time_based
> group_reporting
> randrepeat=0
> 
> [device]
> directory=/home/feiman.wxg/mntpoint/  # an ext4 mount point
> 
> If we have commit cc29e1bf0d63f7 ("block: disable iopoll for split bio"),
> there will no splitted bio case for polled io, but I think we still to need
> to fix this list corruption, it also should maybe go to stable branchs.
> 
> To fix this corruption, if a req is inserted into tail of io_wqe->work_list,
> initialize req->io_wq_work->list->next to bu NULL.

Applied, and marked for stable.

-- 
Jens Axboe

