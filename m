Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D17A72E0103
	for <lists+io-uring@lfdr.de>; Mon, 21 Dec 2020 20:31:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726555AbgLUTaR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 21 Dec 2020 14:30:17 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:34938 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726330AbgLUTaR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 21 Dec 2020 14:30:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608578930;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DqGCALe//LHb1AnlutRHnAB2IrphEkKHBcp1ImnyyF4=;
        b=RZhTfhttZXpdwaNsdA9atkAMCjhU5SzuLPmldB6xB1BmeljtQa2xoEYsFHU1pU4wRA9DHn
        0mY4mosMvQ581SJTzPmigVJIpdlAEdDrXxlnOhlNTjnxAaxFxe+0adxHskwiFFfGKpbwsZ
        LP6d5UizlT//pRD5atllMYKbCQdhsSc=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-432-cowhJQ1tMgGXbkNijosC3w-1; Mon, 21 Dec 2020 14:28:49 -0500
X-MC-Unique: cowhJQ1tMgGXbkNijosC3w-1
Received: by mail-qv1-f70.google.com with SMTP id cc1so8778032qvb.3
        for <io-uring@vger.kernel.org>; Mon, 21 Dec 2020 11:28:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DqGCALe//LHb1AnlutRHnAB2IrphEkKHBcp1ImnyyF4=;
        b=NxW/P5ljm6DMSXmluWUhBT6oHbtyVCXRPDITMCjITcfITBkR2+2gCUSLMhsL1t0Id+
         MuDzdQxdLuYrLXNAGhDMQ84J/qlY6coAdUz2IKb+sD90PVMFPm3n5lza+qXdGpD4gRXy
         NbWQvxJjIu3+EXgqRdWEh9u/lOculZjU00Up1MWlM0tk/eTO2Q+iowSIoIeDvjPCtP6j
         +9ORHrCJSn1KlYS/GBANhExqfwkxEAi9B4ckvU4e8G+wIfQCR4CTibWcVWnY8plOm4NL
         dylJUCw+OhbuilQTrHOfk+d7VE9M0lejwWQffUXFr7gj0MXPzCej32Va3D0xymL2iiV9
         DFJw==
X-Gm-Message-State: AOAM531QXkD91avH3RP76RvLBhSsFoaQRgxbSz4l8hOC6qOiLZn15Wm+
        pguZf/Hs8g+68Nb1kLShYskeJeOrnd+6CG18qIJGOwM43lUlTEK6pB5ox3srFOS2L3r/1DNfwzQ
        VtxH+/meCDFVBEIdnmMA=
X-Received: by 2002:aed:29c2:: with SMTP id o60mr17763195qtd.253.1608578928366;
        Mon, 21 Dec 2020 11:28:48 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwsn1SLArBtFHb9e3jSB2ALMQZgUo1VQqvjtU1VmAZ7dXXrd9aB6Q7I+oD5sckuDOibu7ebRw==
X-Received: by 2002:aed:29c2:: with SMTP id o60mr17763169qtd.253.1608578928083;
        Mon, 21 Dec 2020 11:28:48 -0800 (PST)
Received: from xz-x1 ([142.126.83.202])
        by smtp.gmail.com with ESMTPSA id e38sm4967128qtb.30.2020.12.21.11.28.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Dec 2020 11:28:47 -0800 (PST)
Date:   Mon, 21 Dec 2020 14:28:46 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     linux-fsdevel@vger.kernel.org, Nadav Amit <namit@vmware.com>,
        Jens Axboe <axboe@kernel.dk>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [RFC PATCH 03/13] selftests/vm/userfaultfd: wake after copy
 failure
Message-ID: <20201221192846.GH6640@xz-x1>
References: <20201129004548.1619714-1-namit@vmware.com>
 <20201129004548.1619714-4-namit@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201129004548.1619714-4-namit@vmware.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sat, Nov 28, 2020 at 04:45:38PM -0800, Nadav Amit wrote:
> From: Nadav Amit <namit@vmware.com>
> 
> When userfaultfd copy-ioctl fails since the PTE already exists, an
> -EEXIST error is returned and the faulting thread is not woken. The
> current userfaultfd test does not wake the faulting thread in such case.
> The assumption is presumably that another thread set the PTE through
> copy/wp ioctl and would wake the faulting thread or that alternatively
> the fault handler would realize there is no need to "must_wait" and
> continue. This is not necessarily true.
> 
> There is an assumption that the "must_wait" tests in handle_userfault()
> are sufficient to provide definitive answer whether the offending PTE is
> populated or not. However, userfaultfd_must_wait() test is lockless.
> Consequently, concurrent calls to ptep_modify_prot_start(), for
> instance, can clear the PTE and can cause userfaultfd_must_wait()
> to wrongly assume it is not populated and a wait is needed.

Yes userfaultfd_must_wait() is lockless, however my understanding is that we'll
enqueue before reading the page table, which seems to me that we'll always get
notified even the race happens.  Should apply to either UFFDIO_WRITEPROTECT or
UFFDIO_COPY, iiuc, as long as we follow the order of (1) modify pgtable (2)
wake sleeping threads.  Then it also means that when must_wait() returned true,
it should always get waked up when fault resolved.

Taking UFFDIO_COPY as example, even if UFFDIO_COPY happen right before
must_wait() calls:

       worker thread                       uffd thread
       -------------                       -----------

   handle_userfault
    spin_lock(fault_pending_wqh)
    enqueue()
    set_current_state(INTERRUPTIBLE)
    spin_unlock(fault_pending_wqh)
    must_wait()
      lockless walk page table
                                           UFFDIO_COPY
                                             fill in the hole
                                             wake up threads
                                               (this will wake up worker thread too?)
    schedule()
      (which may return immediately?)

While here fault_pending_wqh is lock protected. I just feel like there's some
other reason to cause the thread to stall.  Or did I miss something?

Thanks,

-- 
Peter Xu

