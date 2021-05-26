Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9E35391DFB
	for <lists+io-uring@lfdr.de>; Wed, 26 May 2021 19:22:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234364AbhEZRYD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 26 May 2021 13:24:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234715AbhEZRXt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 26 May 2021 13:23:49 -0400
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B198AC061763
        for <io-uring@vger.kernel.org>; Wed, 26 May 2021 10:22:17 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id z1so1628872ils.0
        for <io-uring@vger.kernel.org>; Wed, 26 May 2021 10:22:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2OhppeIspUDCdDqTlenJ6aztMdU67TtMNZxD3yeg400=;
        b=dyd853IHw273IeiG2uqfnTqRkPVyWHq5JcW2VXwCIvV+1DaSqFqjfPrCTLG3FL0d4w
         415nNgjSm0mvKIx9c+cgRohXhL6yOkH08muFt/QmULyvhpf1y6h9EXr9H+QSEvPzZtWJ
         hvUz08Dv4/8FwLxukH4PI5gmPHOCOjqiaumvgb+Eq/2ZmmVZQnMaFg6R1RGt2avy7gdr
         KSxYid7vN+mVenTGYZzcaVIEAvA28SZxrbLXS1EFDARdWGOYDApUPt8pefet0TC+J80q
         4j4t2fRYH/ldBlUorDyTQLwG0aPwttoWRArOcs6GVj152WX5lYOwRVluIyk/FYr4pvP5
         Zg3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2OhppeIspUDCdDqTlenJ6aztMdU67TtMNZxD3yeg400=;
        b=l3WR7X/A1MmdMMFILWla16bmCi+xZCGXgd6YzZu/tbjSE/xMz0kOD3WLk7/VbMl2ph
         CxMKGc7xsu2tq9tM/auTVkoSlcYgxCdDPCg95Jm7JkN+0MzkHKF2l1TWdRMcllAFxCQk
         aedxtJ284gnvuDNDl9xW+FeiO9i3w4sqtGXTxbiWfOQpYFdZJNHXUNSE61TDzAEDJWLu
         9fq9jViGO/6uilT+VN/AdHNgqv8dl6fr0zhfp94zA1I0nK2bQcRKjVj40f5LJotoMvEG
         xV3AkCWr50JPBcYKAWYy0yVh9gzRw34/zWu3L2LjKKoXjFccf+GAKk7/lr6Tz/PpIqxj
         /9kA==
X-Gm-Message-State: AOAM532cK45CZGyMS+dLBlW40IRIt+rTDJskNjXQhkePJ061UTteNWlF
        dQA4Jfg3MX/2AVcQhhVrEAYypg==
X-Google-Smtp-Source: ABdhPJxPLz3YY9EUDMQFtFn/VcophkNmNE0tWvvBLvKnHP1NR0b0HejoaWXYugArW/GqD1kJy2w6DA==
X-Received: by 2002:a05:6e02:ea8:: with SMTP id u8mr26501483ilj.67.1622049736979;
        Wed, 26 May 2021 10:22:16 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id a11sm6820114ioq.12.2021.05.26.10.22.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 May 2021 10:22:16 -0700 (PDT)
Subject: Re: [RFC PATCH 2/9] audit,io_uring,io-wq: add some basic audit
 support to io_uring
To:     Richard Guy Briggs <rgb@redhat.com>,
        Stefan Metzmacher <metze@samba.org>
Cc:     Paul Moore <paul@paul-moore.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        selinux@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-audit@redhat.com, Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>
References: <162163379461.8379.9691291608621179559.stgit@sifl>
 <f07bd213-6656-7516-9099-c6ecf4174519@gmail.com>
 <CAHC9VhRjzWxweB8d8fypUx11CX6tRBnxSWbXH+5qM1virE509A@mail.gmail.com>
 <162219f9-7844-0c78-388f-9b5c06557d06@gmail.com>
 <CAHC9VhSJuddB+6GPS1+mgcuKahrR3UZA=1iO8obFzfRE7_E0gA@mail.gmail.com>
 <8943629d-3c69-3529-ca79-d7f8e2c60c16@kernel.dk>
 <CAHC9VhTYBsh4JHhqV0Uyz=H5cEYQw48xOo=CUdXV0gDvyifPOQ@mail.gmail.com>
 <0a668302-b170-31ce-1651-ddf45f63d02a@gmail.com>
 <CAHC9VhTAvcB0A2dpv1Xn7sa+Kh1n+e-dJr_8wSSRaxS4D0f9Sw@mail.gmail.com>
 <18823c99-7d65-0e6f-d508-a487f1b4b9e7@samba.org>
 <20210526154905.GJ447005@madcap2.tricolour.ca>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <aaa98bcc-0515-f0e4-f15f-058ef0eb61e7@kernel.dk>
Date:   Wed, 26 May 2021 11:22:15 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210526154905.GJ447005@madcap2.tricolour.ca>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/26/21 9:49 AM, Richard Guy Briggs wrote:
>> So why is there anything special needed for io_uring (now that the
>> native worker threads are used)?
> 
> Because syscall has been bypassed by a memory-mapped work queue.

I don't follow this one at all, that's just the delivery mechanism if
you choose to use SQPOLL. If you do, then a thread sibling of the
original task does the actual system call. There's no magic involved
there, and the tasks are related.

So care to expand on that?

>> Is there really any io_uring opcode that bypasses the security checks the corresponding native syscall
>> would do? If so, I think that should just be fixed...
> 
> This is by design to speed it up.  This is what Paul's iouring entry and
> exit hooks do.

As far as I can tell, we're doing double logging at that point, if the
syscall helper does the audit as well. We'll get something logging the
io_uring opcode (eg IORING_OP_OPENAT2), then log again when we call the
fs helper. That's _assuming_ that we always hit the logging part when we
call into the vfs, but that's something that can be updated to be true
and kept an eye on for future additions.

Why is the double logging useful? It only tells you that the invocation
was via io_uring as the delivery mechanism rather than the usual system
call, but the effect is the same - the file is opened, for example.

I feel like I'm missing something here, or the other side is. Or both!

-- 
Jens Axboe

