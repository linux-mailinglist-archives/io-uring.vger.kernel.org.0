Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54CF725AD9A
	for <lists+io-uring@lfdr.de>; Wed,  2 Sep 2020 16:45:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727999AbgIBOps (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 2 Sep 2020 10:45:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727991AbgIBOpg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 2 Sep 2020 10:45:36 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8710DC061245
        for <io-uring@vger.kernel.org>; Wed,  2 Sep 2020 07:45:36 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id d19so2641736pgl.10
        for <io-uring@vger.kernel.org>; Wed, 02 Sep 2020 07:45:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qUFB6sdFId+xh6KE7poHATdizrBAwfxGfBUsu2g39fg=;
        b=BFyjXhmzP56Hxz6T1iOAA7h04SEsQtkcVcbnfRYFR751zh/fCWy53YgaCLaBy0LVlA
         MMg7GTMKzk0f3T6ElzwQWSlNybRq6l/lCeCp0SssN/1gEtEpQHxvS+arllY9qbygkVBi
         ViLAwS8I3rZSrrpJ4bpIOVqSrX9ZfsG28LztKeuj5UkrMSNj9RWtkY20ZFZ1soc+GX7V
         yMIYpIdAjdTp8ZZX4GHDTtkQ7bd50cDFKghZ+bPxHz872qBSzH7vAcIQIBA0USvcPlTd
         mgXWaxAwBLlPClNbpHtJnZJxNiscvRiMHM+H8VaQ2ZVRd1jPL+vsb2//zMWb/Obw63ab
         +47A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qUFB6sdFId+xh6KE7poHATdizrBAwfxGfBUsu2g39fg=;
        b=bfV29JktQ3LeQPqPYNRBmwA9PzTGRF+g4NrvD1Om4cXxGWWTgGUJbegQBzB/HKGlOy
         tfhXIZI1EMH9PuOmSsdcAAFQtlx8+7pGsT69PtR5IoiEVnzVZG2HXTIOQz6pTqPBpg30
         eF9voCTBHxJcq4wuUnUl2Nqav4TTKlFL/QGRbT1CiKzcSc840cqtP+79Oj/+QrdkEGzI
         Ddnqqurq66XqKONecflWbguODnBo19h9RHR/xK6rbn8FuHGFlp40ZmCmP4hxOTuVrEbr
         vYGG7kM95nkN4A7IE9iZ8W6CnJWBHF1CZEREVtgsuJ4xWr4Y8D9yOpRzcxNyDV53uFQq
         oy/A==
X-Gm-Message-State: AOAM530KmmXMJdDEzmmJlxDfQ+dUoDpBGSx/G6tL7WF7eSXMDqogH3v6
        U6KVJYmJSWR2IqZgBo5C4GwqVw==
X-Google-Smtp-Source: ABdhPJy+Wop0+LBjdoJ9ZqvnxlIENAh2JPN+wGBUg9o+yiXxQt8eBgQgbrX8iZJ0gIv0MTU/0oJ6ZA==
X-Received: by 2002:a62:1d05:: with SMTP id d5mr3400529pfd.63.1599057935911;
        Wed, 02 Sep 2020 07:45:35 -0700 (PDT)
Received: from ?IPv6:2620:10d:c085:21d6::11a1? ([2620:10d:c090:400::5:1653])
        by smtp.gmail.com with ESMTPSA id t15sm6161425pfl.175.2020.09.02.07.45.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Sep 2020 07:45:35 -0700 (PDT)
Subject: Re: IORING_OP_READ and O_NONBLOCK behaviour
To:     Norman Maurer <norman.maurer@googlemail.com>,
        io-uring@vger.kernel.org
Cc:     Josef <josef.grieb@gmail.com>
References: <28EF4A51-2B6D-4857-A9E8-2E28E530EFA6@googlemail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <05c1b12c-5fb8-c7f5-c678-65249da5a6b1@kernel.dk>
Date:   Wed, 2 Sep 2020 08:45:34 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <28EF4A51-2B6D-4857-A9E8-2E28E530EFA6@googlemail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/2/20 4:09 AM, Norman Maurer wrote:
> Hi there,
> 
> We are currently working on integrating io_uring into netty and found
> some “suprising” behaviour which seems like a bug to me.
> 
> When a socket is marked as non blocking (accepted with O_NONBLOCK flag
> set) and there is no data to be read IORING_OP_READ should complete
> directly with EAGAIN or EWOULDBLOCK. This is not the case and it
> basically blocks forever until there is some data to read. Is this
> expected ?
> 
> This seems to be somehow related to a bug that was fixed for
> IO_URING_ACCEPT with non blocking sockets:
>
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?h=v5.8&id=e697deed834de15d2322d0619d51893022c90ea2

I agree with you that this is a bug, in general it's useful (and
expected) that we'd return -EAGAIN for that case. I'll take a look.

-- 
Jens Axboe

