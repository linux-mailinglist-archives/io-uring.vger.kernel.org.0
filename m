Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7C031EF8B7
	for <lists+io-uring@lfdr.de>; Fri,  5 Jun 2020 15:13:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726927AbgFENNK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 5 Jun 2020 09:13:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726889AbgFENNG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 5 Jun 2020 09:13:06 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72780C08C5C2
        for <io-uring@vger.kernel.org>; Fri,  5 Jun 2020 06:13:05 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id a127so4878027pfa.12
        for <io-uring@vger.kernel.org>; Fri, 05 Jun 2020 06:13:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=X+J8uRngAU1rnr8bTs7AVuq3kDiRY1NcO7spUpC6amI=;
        b=MtG814c6/YmxZaJoSjd2YXnyms4AhpD/Xew985zjuGRR1KBtFHTfY6cHMCUHGLPGy+
         Lic8dg9uN4y+h6PYrkPI42dDfyd5djXylBhYi/u7urDgMtyELYc9EXNEXwYoC/1F1S6L
         qqxWXGoxnQ1pan460yieG17+/dEkddMeGIYcvN4oXpsfDzzcP8RQNxuaff22WRYdWXaL
         I1a4Iug9cFfuTD2LjcB0QA+UDuIfWp9emkCxw6jb2kvhYJZEmCiXaQJJ/QrbOzo4gM/Y
         9YYHSYadPygrbnMp2LvJraUvYLAz6mXchrH5xdYBbk470vS9T+rGczFMQ+q6U1C03n80
         pFdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=X+J8uRngAU1rnr8bTs7AVuq3kDiRY1NcO7spUpC6amI=;
        b=PJfY9sY5Li/slIrQoeC2E0QnYhDO4G/dbfpjPexHSdWu5msJRVg5mvHmQEAdVR+nND
         EkpG3NQCT4eb00HtSYzq0/Hd+pyRDzZeg+Ld9ZxhpdtkFQmVrErwdkZEXIVpmKpdjg/x
         xpoqK6iyX7mljRuVMww5uRQ87DSXzCRwsv/2u4qxgFuOuF7CnSTgW2Fil+UxuaHX5sxX
         2I7n7Di9vlY8ork9l4c5LdDt2pu6958PxdFgb9QBVSb4lenv8DS0fMMNE+sTeOVV3/97
         RM8l6pB5arH/vgvVDNfNVSRUMBuBKKyOPScVsBXLBY7aUD9QthJONGhUuBHm+jUpIlv7
         mSNw==
X-Gm-Message-State: AOAM531depYExVG6d4t3sZW0l8JM6J552zYyE3j4BS1DbIzWrfg4QTbJ
        oyDzAt+Tg9BpxKXDHtpuWAsTSyZ6PRRSVA==
X-Google-Smtp-Source: ABdhPJyaUTj8mo1VF7FIrGKkM2aWIwej5prNA7yNWkRQ7fkStuoTeDYzkWgEmTfevAkxF7h8OnDAFA==
X-Received: by 2002:a63:6dc8:: with SMTP id i191mr9060706pgc.414.1591362784467;
        Fri, 05 Jun 2020 06:13:04 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id z144sm8050240pfc.195.2020.06.05.06.13.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Jun 2020 06:13:03 -0700 (PDT)
Subject: Re: support suspend/resume SQPOLL on inflight io-uring instance
To:     =?UTF-8?B?6ZmI5LqR5pif?= <chen.yack@gmail.com>
Cc:     io-uring@vger.kernel.org
References: <CAP6wFtSZ1LOWsb=nXwnPGdcAWvpvwdHo_SUuMpnAcqbBdtfFRA@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <c62ed58e-3224-0241-6f0e-5177b35dc0de@kernel.dk>
Date:   Fri, 5 Jun 2020 07:13:02 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <CAP6wFtSZ1LOWsb=nXwnPGdcAWvpvwdHo_SUuMpnAcqbBdtfFRA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/4/20 9:38 PM, 陈云星 wrote:
> io-uring instance can be set flag : IO_URING_SETUP_SQPOLL to enable
> kernel thread polling SQ. but some application have random io
> behavior, for example:
>      a). a burst read/write for a while,
>      b). then many scatter small io operations.
> 
> during a) period, use sqpoll will be beneficial to performance.
> but during b) period, use sqpoll will waste cpu time for empty busy poll.
> 
> If we can have a method to tell kernel start/stop poll sq when we
> need, it is good for both of a) and b):
>      in a) period, io_uring_enter tell kernel. start to poll
>      after a) , io_uring_enter tell kernel stop polling and.

We already have the start side of it, that's io_uring_enter() which should
be done when IORING_SQ_NEED_WAKEUP is set. I do like your suggestion of
making it go to sleep on demand instead of always waiting for the grace
period.

We recently added IORING_CQ_EVENTFD_DISABLED, and we can use the same
area for this as well. Eg add IORING_CQ_SQPOLL_SLEEP or something like
that, and have the sq thread look for it. If set, it'll stop busy looping
and go to sleep.

-- 
Jens Axboe

