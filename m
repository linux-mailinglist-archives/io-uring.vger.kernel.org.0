Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D3B1202B52
	for <lists+io-uring@lfdr.de>; Sun, 21 Jun 2020 17:23:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730286AbgFUPXk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 21 Jun 2020 11:23:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730269AbgFUPXk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 21 Jun 2020 11:23:40 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D96BC061794
        for <io-uring@vger.kernel.org>; Sun, 21 Jun 2020 08:23:39 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id e8so1695023pgc.5
        for <io-uring@vger.kernel.org>; Sun, 21 Jun 2020 08:23:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=jtWWwuYampsAJeKOqO07yWnUPyE2wUAYk9ISwMoGh1U=;
        b=kOWyyeGO5KbWHj8aLYWlI57x0X1nhfzv88xsB/JglsuTwBNkEtTtNf9Tf3R7kdZvGQ
         cJlEfOziOuoAcMoIIi5k/9UIgyAmfdpVriOwo5fa85py7zzM+Y9m9QsiYthBcNTX5Dz0
         l7DEXISEePaSg+/5nZj7V6gjBdR+PFwOwE33FeMpFezZkZtW9Z2GqRa02r2Ayf29N9Cu
         IHjzJXbUaxW1AcpOnBnBYMdUbE69GFKG57gYT2pOkx0JMec1lpz6Ov7t/tN2tu4WGckO
         18gaMnrlgKOfQ3wvULAYZlqTq4Dkln+Xl/tTYI40v0P1PC45suo20Iaky6Ezz8f1R4WQ
         BhCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jtWWwuYampsAJeKOqO07yWnUPyE2wUAYk9ISwMoGh1U=;
        b=KOVA7d2JOnD/b/k3v7jHXFOo3WdrX0kdyXY6G6dh3HYbXHn4eKAX3ZfaUdlRbayLIw
         egcJBEzUZtKdnYnsEEPUtPGjVRcYakIsIU63U8gjeDT0e7WOK+WbIQTssnR9jNTlaKbu
         ks358tEiGM4wtyST5OR/hG6LBA9WkOTvooj8PcNUWRhrCVnvhij4bOAu7DztmjdnzDMV
         LVK/8aiHi1DI15eh3u/jeKSw+v9+U2b806VC2ic57K7jhDsyTfg03gwPL5unreAKKTPb
         /U5vKZw9z6GrayWeHOsntln/Lhn/uwLXNzDeKE+baPBE1pqobj4bMxgZlUUJrpfb5CTg
         VOYA==
X-Gm-Message-State: AOAM530syt3dvqAKLL92LOOfxaTbS5xfFC+arSJcqNsCChcJAt2IUk95
        NFL86S015UBSQL5qAS7KQiI+c0oe8sk=
X-Google-Smtp-Source: ABdhPJyyUKIKW+m2rDRzxhk8mDhdxAcfF8QnnxuDDBAxjZEtep2ApYhXdMhbTVVqfgrHO+nZvQ0VPw==
X-Received: by 2002:a62:e305:: with SMTP id g5mr16826124pfh.115.1592753018492;
        Sun, 21 Jun 2020 08:23:38 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id n8sm9382391pgi.18.2020.06.21.08.23.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 21 Jun 2020 08:23:37 -0700 (PDT)
Subject: Re: [PATCH liburing] Fix hang in in io_uring_get_cqe() with iopoll
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <c1c4cd592333959bf2e0a4d2381372f1b40aef7b.1592735406.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <b7e1f0c9-8650-d45f-5821-6c4984bec320@kernel.dk>
Date:   Sun, 21 Jun 2020 09:23:36 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <c1c4cd592333959bf2e0a4d2381372f1b40aef7b.1592735406.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/21/20 4:30 AM, Pavel Begunkov wrote:
> Because of need_resched() check, io_uring_enter() -> io_iopoll_check()
> can return 0 even if @min_complete wasn't satisfied. If that's the
> case, __io_uring_get_cqe() sets submit=0 and wait_nr=0, disabling
> setting IORING_ENTER_GETEVENTS as well. So, it goes crazy calling
> io_uring_enter() in a loop, not actually submitting nor polling.
> 
> Set @wait_nr based on actual number of CQEs ready.
> BTW, atomic_load_acquire() in io_uring_cq_ready() can be replaced
> with a relaxed one for this particular place.

Can you preface this with an addition of __io_uring_cqe_ready() that
doesn't include the load acquire?

Also, s/io_adjut_wait_nr/io_adjust_wait_nr for the patch.

-- 
Jens Axboe

