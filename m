Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47C74144A43
	for <lists+io-uring@lfdr.de>; Wed, 22 Jan 2020 04:17:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729095AbgAVDQ4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 21 Jan 2020 22:16:56 -0500
Received: from mail-pl1-f180.google.com ([209.85.214.180]:46955 "EHLO
        mail-pl1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728779AbgAVDQ4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 21 Jan 2020 22:16:56 -0500
Received: by mail-pl1-f180.google.com with SMTP id y8so2278227pll.13
        for <io-uring@vger.kernel.org>; Tue, 21 Jan 2020 19:16:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=zjpIhvPq7GcPit9iD+VfJdyXCxpEsMd2Gmspf8EPqD0=;
        b=0TWZO9DiRSWIDTm1U3KpH2TDnjP4IGqS9h23gmbdxv/daFIxJ1Eb0cFht5lMbavNJo
         srUcDUThox7CKA+2JsLdWeoEWcM5qDDsq2k/9n5TUOStqtJQhJ/9o/X/34+hwVoz8k81
         uBFf1JYd+WPYxfLHkaZnC9y8KdENRV2mizSdWB+2X4KnypVKuW8WElplbenRd3fYBbms
         Wlu5Qgfq2fPMR8jrQA8lj1glO9NZbeS5RNzGp2GVMoCKVSF8hbcFtLQSR/A49RfnTT3M
         JfO9+BGhKRNDc2s86+fz6L5C3iQz52vE6Ru2lsE625Z8kGoDfeuKOwrsmersZuLiw/ND
         UFcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zjpIhvPq7GcPit9iD+VfJdyXCxpEsMd2Gmspf8EPqD0=;
        b=RFbeS1EAV7SjPJ/2aG31A2T8tpcFo2XlLqJO2WKolf8QRlVIQl/LEnEbZheGTY1FuY
         8Uu1en5Hr/Ilcx3ftU/Y1u8F5l58ymlukAMhGHvs4mB4bil+/Wx1b1woDUG4Om8i2V5i
         8VLpNTglqotlYnEQ8+lhfQdKZEv8ANCuvvW/EkLu+8YZy3J+5VyxxbqwSRuov1n4jrS4
         1XkzUXloqq5wmSvLzN9NTToeJG4pYpzZ6DNYMdRYxIKL9kGCzILL6sezFy8JvI14NF3m
         ah9y0gRqHZvQl5m0YzRMaVByyieMxkb7IC3ZxKvZfjGpBhYpe3XkxgJuyQh+9eYMDhCb
         4CuA==
X-Gm-Message-State: APjAAAWkC84D2wXgRAsrR+jGGmylh8iltwuipZjVgWbOc9MPn7gKosL1
        dy0pjNS+JH0ScYiNhIjh3Ib9EcLarq0=
X-Google-Smtp-Source: APXvYqwOWUyWzWe2fdGP+fih1//u9FZV48pifCDehPe4ceThp+3GZ1hOxcYRyt0vLzIQnzElbH9j6A==
X-Received: by 2002:a17:902:547:: with SMTP id 65mr8320085plf.50.1579663015483;
        Tue, 21 Jan 2020 19:16:55 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id 70sm12798199pgf.90.2020.01.21.19.16.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jan 2020 19:16:55 -0800 (PST)
Subject: Re: Waiting for requests completions from multiple threads
To:     Dmitry Sychov <dmitry.sychov@gmail.com>, io-uring@vger.kernel.org
References: <CADPKF+ew9UEcpmo-pwiVqiLS5SK2ZHd0ApOqhqG1+BfgBaK5MQ@mail.gmail.com>
 <1f98dcc3-165e-2318-7569-e380b5959de7@kernel.dk>
 <CADPKF+e3vzmfhYmGn1MSyjknMWQwCyi9NjWnzL23ADxAvbSNRw@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <77680e62-881d-5130-2d32-fc3cf5b9e065@kernel.dk>
Date:   Tue, 21 Jan 2020 20:16:53 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <CADPKF+e3vzmfhYmGn1MSyjknMWQwCyi9NjWnzL23ADxAvbSNRw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/21/20 8:09 PM, Dmitry Sychov wrote:
> Thank you for quick reply! Yes I understand that I need a sort of
> serializable-level isolation
> when accessing the rings - I hope this could be done with a simple
> atomic cmp-add after optimistic write ring update.

That's not a bad idea, that could definitely work, and would be more
efficient than just grabbing a lock.

Could also be made to work quite nicely with restartable sequences. I'd
love to see liburing grow support for smarter sharing of a ring, that's
really where that belongs.

> Correct me if I'am wrong, but from my understanding the kernel can
> start to pick up newly written Uring jobs
> without waiting for the "io_uring_enter" user level call and that's
> why we need a write barrier(so that
> the ring state is always valid for the kernel), else "io_uring_enter"
> could serve as a write barrier itself as well...

By uring jobs, you mean SQEs, or submission queue entries? The kernel
only picks up what you ask it to, it won't randomly just grab entries
from the SQ ring unless you do an io_uring_enter() and tell it to
consume N entries. The exception is if you setup the ring with
IORING_SETUP_SQPOLL, in which case the kernel will maintain a submission
thread. For that case, yes, the kernel can pickup an entry as soon as
the SQ tail is updated by the application.

-- 
Jens Axboe

