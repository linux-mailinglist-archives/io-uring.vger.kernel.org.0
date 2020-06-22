Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1498F2039FA
	for <lists+io-uring@lfdr.de>; Mon, 22 Jun 2020 16:50:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729360AbgFVOuX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 22 Jun 2020 10:50:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729311AbgFVOuW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 22 Jun 2020 10:50:22 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C36B0C061573
        for <io-uring@vger.kernel.org>; Mon, 22 Jun 2020 07:50:22 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id b5so8240385pgm.8
        for <io-uring@vger.kernel.org>; Mon, 22 Jun 2020 07:50:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5AOQHM7pUsYJAQwyo2xHxcgmohwzw5IBS29zYyEntbA=;
        b=CrsLamBFMn/MNSzAwNn7/uYP5NV7pDWVBnKrZsZ0J9CxLZHQKPd6/tXXvjwNcFXRF0
         tu9A7/+w2fG7u94dgDdWQhPTXbSkSGjt2P5tqwimOANlYXvrMft9JWX/V3RJksQ4q2oM
         ScN5n9FJuk7sImcrcCZFYdxMV4Jx3MBrgy/h+q1V96/Ek8gEzhxd4hy3LV7Q2uKowOZY
         O5yIH10uorwj8UIqVGv/5CZBiNr9N0FVRfrRityp1h1jZNuU9SRywxZ1+DoVn/y8nvBl
         UYzCxTsNvpcp8UFswZxkGTyDHEm+PQ/bH+Lk0h8e3SwQDLK0K1kCpohdFAByMqy7q00v
         orgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5AOQHM7pUsYJAQwyo2xHxcgmohwzw5IBS29zYyEntbA=;
        b=ismurVOo2CynFDQ6V+NnKOyW4JJoPaPgnmhgE4+ZnAP0tDGRPG0khLXHLFPDEK0+DG
         i0qzIyTR/A2iY/+j46+bJyuKgm2YFXv01Pl97d3tM7XxsWM+QMJAtV5gr9ssaRwIuGKu
         K9obq9yocjQWDEnNFGxfrhFXw/ykalfC6G+lAysJ5ufWVGvTt9TILVKJLI77UFO9lkxX
         vT6Z+UKvc/vlwEjom8C9m6UFXB/m+KewzypRNQBXKNv1ct1D22273NXAuXse2IFhcVmC
         QjOLDx4kJFZ8uHHMkpmgb9OBp4lNm+c8UNfJfQytkHT/kENzXbkaJv9LncifrhUjD1Cs
         ZjMA==
X-Gm-Message-State: AOAM530EImoEPlsoCWWgc9UaThpPALLpgNu9UysEeu+VzX0HBtjNFkKH
        uPby3gMsnFa/z3ggz5t6iZpLd2xsWhM=
X-Google-Smtp-Source: ABdhPJwGAwv+N6Wi2W3PsF+2KjIn86dXqutMwflOzVAOq84PxgEvrphmw3EUrGYMrNiDMLpqh1xzrQ==
X-Received: by 2002:aa7:868f:: with SMTP id d15mr22031303pfo.166.1592837422120;
        Mon, 22 Jun 2020 07:50:22 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id i26sm14507906pfo.0.2020.06.22.07.50.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Jun 2020 07:50:21 -0700 (PDT)
Subject: Re: [RFC] io_commit_cqring __io_cqring_fill_event take up too much
 cpu
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        io-uring <io-uring@vger.kernel.org>
Cc:     Dust.li@linux.alibaba.com
References: <20200622132910.GA99461@e02h04398.eu6sqa>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <bb4b567f-4337-6c9d-62aa-fa62db2882f3@kernel.dk>
Date:   Mon, 22 Jun 2020 08:50:20 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200622132910.GA99461@e02h04398.eu6sqa>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/22/20 7:29 AM, Xuan Zhuo wrote:
> Hi Jens,
> I found a problem, and I think it is necessary to solve it. But the change
> may be relatively large, so I would like to ask you and everyone for your
> opinions. Or everyone has other ideas about this issue:
> 
> Problem description:
> ===================
> I found that in the sq thread mode, the CPU used by io_commit_cqring and
> __io_cqring_fill_event accounts for a relatively large amount. The reason is
> because a large number of calls to smp_store_release and WRITE_ONCE.
> These two functions are relatively slow, and we need to call smp_store_release
> every time we submit a cqe. This large number of calls has caused this
> problem to become very prominent.
> 
> My test environment is in qemu, using io_uring to accept a large number of
> udp packets in sq thread mode, the speed is 800000pps. I submitted 100 sqes
> to recv udp packet at the beginning of the application, and every time I
> received a cqe, I submitted another sqe. The perf top result of sq thread is
> as follows:
> 
> 
> 
> 17.97% [kernel] [k] copy_user_generic_unrolled
> 13.92% [kernel] [k] io_commit_cqring
> 11.04% [kernel] [k] __io_cqring_fill_event
> 10.33% [kernel] [k] udp_recvmsg
>   5.94% [kernel] [k] skb_release_data
>   4.31% [kernel] [k] udp_rmem_release
>   2.68% [kernel] [k] __check_object_size
>   2.24% [kernel] [k] __slab_free
>   2.22% [kernel] [k] _raw_spin_lock_bh
>   2.21% [kernel] [k] kmem_cache_free
>   2.13% [kernel] [k] free_pcppages_bulk
>   1.83% [kernel] [k] io_submit_sqes
>   1.38% [kernel] [k] page_frag_free
>   1.31% [kernel] [k] inet_recvmsg
> 
> 
> 
> It can be seen that io_commit_cqring and __io_cqring_fill_event account
> for 24.96%. This is too much. In general, the proportion of syscall may not
> be so high, so we must solve this problem.
> 
> 
> Solution:
> =================
> I consider that when the nr of an io_submit_sqes is too large, we don't call
> io_cqring_add_event directly, we can put the completed req in the queue, and
> then call __io_cqring_fill_event for each req then call once io_commit_cqring
> at the end of the io_submit_sqes function. In this way my local simple test
> looks good.

I think the solution here is to defer the cq ring filling + commit to the
caller instead of deep down the stack, I think that's a nice win in general.
To do that, we need to be able to do it after io_submit_sqes() has been
called. We can either do that inline, by passing down a list or struct
that allows the caller to place the request there instead of filling
the event, or out-of-band by having eg a percpu struct that allows the
same thing. In both cases, the actual call site would do something ala:

if (comp_list && successful_completion) {
	req->result = ret;
	list_add_tail(&req->list, comp_list);
} else {
	io_cqring_add_event(req, ret);
	if (!successful_completion)
		req_set_fail_links(req);
	io_put_req(req);
}

and then have the caller iterate the list and fill completions, if it's
non-empty on return.

I don't think this is necessarily hard, but to do it nicely it will
touch a bunch code and hence be quite a bit of churn. I do think the
reward is worth it though, as this applies to the "normal" submission
path as well, not just the SQPOLL variant.

-- 
Jens Axboe

