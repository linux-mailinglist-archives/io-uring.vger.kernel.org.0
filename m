Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04A5F45654A
	for <lists+io-uring@lfdr.de>; Thu, 18 Nov 2021 23:02:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231176AbhKRWFa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 18 Nov 2021 17:05:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbhKRWFa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 18 Nov 2021 17:05:30 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D7CAC061574;
        Thu, 18 Nov 2021 14:02:29 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id g28so6710492pgg.3;
        Thu, 18 Nov 2021 14:02:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8fh25Uj6YoBvqabkRqtjeDWkpKjWk2JP2GTPGCVb4fw=;
        b=ddSjjAwKtkJ5FN0JMAPArzeYHb8DoBJo54IAiteYJVVOz1gPw92lhRM3IwDvvfub4c
         8eNobr+J17FSrQo1JAnACftnyQzw1tfOUDzeMY152J+fKowx13UCZc1QFTzj9dGQsSQI
         Hfoo38oWz+tx2j58HLzGBIRLvPqNAvhXxXFW//qttykdMr5sKz23xozcTe+69e4qwL1P
         Aqfxa6AF+pkIfrYhUfSEmmTgR+WO+YPYzFuoWcg0OlIQ6vBbpXuRR1dF+n/DJc2dYVPJ
         DhYglKkB2PPssdpPR3HgGG4R0ZsTN7ADEe+O8v22autDHeVUJOVfhDmwMhAbAfiS0S3g
         9JBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8fh25Uj6YoBvqabkRqtjeDWkpKjWk2JP2GTPGCVb4fw=;
        b=mnG7RGiqUkaXrdrjfVP/FHyKvbGXotXqivQLQuNfxDkquh3UoIdBMaz93BY+tC2CAY
         7H2OrxX1k3UphfrVUYBPR7l+q/tdQDTZ/P7n1VoyrMSRoqUl3ojRPU/MzoOmKpnfDlEO
         o5H664fDSqqXyJ03+6NKd7e3ISfZ4mmErh7XJfUta7SMhywlKZAkpVNlGOfczQjIF0aA
         uU75kp4fUSjrSMmKctXtNTKZ1ZDxxpofpHLLdBEwoP98PIppKn9k/Yql2SaQwycwcMq6
         5SYOZ3iDfjlN+PGvgheG/B6GEGDu5xI4mjHodjgGgGCCKcLkHZsfTyqH2ZLaiQtW3X5E
         trlg==
X-Gm-Message-State: AOAM531ggxln1SOFZ1OHI/Mf1wp2+Rmq4FPNd9cEf+Gtk+QHiWi6LKP0
        lhrggqZg274CqjYoVDvcVtd5iljCus0=
X-Google-Smtp-Source: ABdhPJwSxHjZbxBxsDpQ3Yv8kgFa69flZgG3R8Q2pPP2B89P9cbEqO8gbVUygG5a0cKU1S3+FRKO9w==
X-Received: by 2002:a63:6c44:: with SMTP id h65mr13775544pgc.423.1637272949121;
        Thu, 18 Nov 2021 14:02:29 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:500::1:6926])
        by smtp.gmail.com with ESMTPSA id h6sm587662pfi.174.2021.11.18.14.02.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 14:02:28 -0800 (PST)
Date:   Thu, 18 Nov 2021 14:02:26 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Pavel Emelyanov <ovzxemul@gmail.com>,
        Alexander Mihalicyn <alexander@mihalicyn.com>,
        Andrei Vagin <avagin@gmail.com>, criu@openvz.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH bpf-next v1 1/8] io_uring: Implement eBPF iterator for
 registered buffers
Message-ID: <20211118220226.ritjbjeh5s4yw7hl@ast-mbp.dhcp.thefacebook.com>
References: <20211116054237.100814-1-memxor@gmail.com>
 <20211116054237.100814-2-memxor@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211116054237.100814-2-memxor@gmail.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Nov 16, 2021 at 11:12:30AM +0530, Kumar Kartikeya Dwivedi wrote:
> This change adds eBPF iterator for buffers registered in io_uring ctx.
> It gives access to the ctx, the index of the registered buffer, and a
> pointer to the io_uring_ubuf itself. This allows the iterator to save
> info related to buffers added to an io_uring instance, that isn't easy
> to export using the fdinfo interface (like exact struct page composing
> the registered buffer).
> 
> The primary usecase this is enabling is checkpoint/restore support.
> 
> Note that we need to use mutex_trylock when the file is read from, in
> seq_start functions, as the order of lock taken is opposite of what it
> would be when io_uring operation reads the same file.  We take
> seq_file->lock, then ctx->uring_lock, while io_uring would first take
> ctx->uring_lock and then seq_file->lock for the same ctx.
> 
> This can lead to a deadlock scenario described below:
> 
>       CPU 0				CPU 1
> 
>       vfs_read
>       mutex_lock(&seq_file->lock)	io_read
> 					mutex_lock(&ctx->uring_lock)
>       mutex_lock(&ctx->uring_lock) # switched to mutex_trylock
> 					mutex_lock(&seq_file->lock)
> 
> The trylock also protects the case where io_uring tries to read from
> iterator attached to itself (same ctx), where the order of locks would
> be:
>  io_uring_enter
>   mutex_lock(&ctx->uring_lock) <-----------.
>   io_read				    \
>    seq_read				     \
>     mutex_lock(&seq_file->lock)		     /
>     mutex_lock(&ctx->uring_lock) # deadlock-`
> 
> In both these cases (recursive read and contended uring_lock), -EDEADLK
> is returned to userspace.
> 
> In the future, this iterator will be extended to directly support
> iteration of bvec Flexible Array Member, so that when there is no
> corresponding VMA that maps to the registered buffer (e.g. if VMA is
> destroyed after pinning pages), we are able to reconstruct the
> registration on restore by dumping the page contents and then replaying
> them into a temporary mapping used for registration later. All this is
> out of scope for the current series however, but builds upon this
> iterator.

From BPF infra perspective these new iterators fit very well and
I don't see any issues maintaining this interface while kernel keeps
changing, but this commit log and shallowness of the selftests
makes me question feasibility of this approach in particular with io_uring.
Is it even possible to scan all internal bits of io_uring and reconstruct
it later? The bpf iter is only the read part. Don't you need the write part
for CRIU ? Even for reads only... io_uring has complex inner state.
Like bpf itself which cannot be realistically CRIU-ed.
I don't think we can merge this in pieces. We need to wait until there is
full working CRIU framework that uses these new iterators.
