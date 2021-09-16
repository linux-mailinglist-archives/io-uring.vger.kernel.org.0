Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D46DF40E118
	for <lists+io-uring@lfdr.de>; Thu, 16 Sep 2021 18:28:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242274AbhIPQ1c (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Sep 2021 12:27:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241132AbhIPQZ3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Sep 2021 12:25:29 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C53A7C061146
        for <io-uring@vger.kernel.org>; Thu, 16 Sep 2021 09:10:02 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id b10so8541174ioq.9
        for <io-uring@vger.kernel.org>; Thu, 16 Sep 2021 09:10:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LNfszvXiWgDI6EDtDbmsSQhzeS38fRUrMmntryou2XE=;
        b=zhaMPc55gDXQzGvk0PYF61B2JgkYfZBdC/jCgVzBDGO1/NT5TG1DSOAxtFiojv59TS
         4xy/fZVdwJqKC9xzQUHZjLytim3uZKgAFbKNK4UE/AHi9gWtHJAdDfbfv5/KPWAvmVBP
         OvRYFvTTmfJw3DlCoMslS9aX5rPMbTflZB7HYlRtM/z2+T5gAFsEHfhQsKn5wjGomKUL
         16WuwuX6YwNXiWc9tBozeln5UEh7mEdEtcfLcRE4JzfzlBy1q4J/uouNHaZ1H+aqL/Lf
         jd6/50yDRu5TjkwFjXfmz+1Qqwq74FglJ6nUfYnlC57++B6vV4Q/Pm3pCRspWT7pIRHd
         6EvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LNfszvXiWgDI6EDtDbmsSQhzeS38fRUrMmntryou2XE=;
        b=HYan8oWRXUenuGf3iVuOWwpcM5nCYTbE79sqgBk/p3AREvl6RlH1fNV4RVjq2CTEq1
         lD753DDdmvgUT67JEHgL3WQXTcRCcPMW2TuWQ0oJ8+KdAqcOO9t6Itvys98z6oA2EsKp
         fd74qPpjZdhvtweonZU5RnR7kTKk8MDwcFEKr8tc21QNCncHxVLS6RhoUnRcxT9qheKW
         E6FL7F/oiT9/TOLPUrZb2Q9ydVMaxpefeQsZZYH2+B+rWylJmMqqTWxCnzbkHQqWtAiY
         tgn/yYV2y+NnYnq6JBLbRh1wzqBEn+LkzOYL6sywFLlMp8R6NM5bsC8/Fxzs7gs/MYBL
         hVcA==
X-Gm-Message-State: AOAM531a9eNigavVh2THy108ZLhV9yqNnsxSN7FVqWSu518RtZ6AZOJj
        ecIt7dsFBGIOKGLZExqX80etGFXPst7mdEU5YmM=
X-Google-Smtp-Source: ABdhPJwm3CCY3RzpdL9GLroEGIeWrGOhaKGzuyd4II6DMbREXBd3v+zzUiUPq08KT9a0zF2u9VOZHA==
X-Received: by 2002:a5e:df47:: with SMTP id g7mr1938941ioq.92.1631808602154;
        Thu, 16 Sep 2021 09:10:02 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id i14sm1994687iol.27.2021.09.16.09.10.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Sep 2021 09:10:01 -0700 (PDT)
Subject: Re: [PATCHSET v3 0/3] Add ability to save/restore iov_iter state
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        torvalds@linux-foundation.org
References: <20210915162937.777002-1-axboe@kernel.dk>
 <YULMf13OXvU70zV+@zeniv-ca.linux.org.uk>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <e7588d27-8dc8-a5bb-c024-05b6e7c336db@kernel.dk>
Date:   Thu, 16 Sep 2021 10:10:00 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <YULMf13OXvU70zV+@zeniv-ca.linux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/15/21 10:47 PM, Al Viro wrote:
> 	Jens, may I politely inquire why is struct io_rw playing
> these games with overloading ->rw.addr, instead of simply having
> struct io_buffer *kbuf in it?

Very simply to avoid growing the union command part of io_kiocb beyond a
cacheline. We're pretty sensitive to io_kiocb size in general, and io_rw
is already the biggest member in there.
 
> 	Another question: what the hell are the rules for
> REQ_F_BUFFER_SELECT?  The first time around io_iov_buffer_select()
> will
> 	* read iovec from ->rw.addr
> 	* replace iovec.iov_base with value derived from
> ->buf_index
> 	* cap iovec.iov_len with value derived from ->buf_index
> Next time around it will use the same base *AND* replace the
> length with the value used to cap the original.
> 	Is that deliberate?

Probably not strictly needed, but doesn't harm anything. The buffer is
being consumed (and hence removed) at completion anyway, it's not a
persistent change. Selected buffers must be re-provided by the
application as the kernel has no way of knowing when the application
would otherwise be ready for it to get reused, and that's done by
issuing a new provide buffers request for the buffers that can get
recycled.

-- 
Jens Axboe

