Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D856257066
	for <lists+io-uring@lfdr.de>; Sun, 30 Aug 2020 22:10:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726178AbgH3UK6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 30 Aug 2020 16:10:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726150AbgH3UK5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 30 Aug 2020 16:10:57 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41F81C061573
        for <io-uring@vger.kernel.org>; Sun, 30 Aug 2020 13:10:57 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id g207so3409660pfb.1
        for <io-uring@vger.kernel.org>; Sun, 30 Aug 2020 13:10:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=/mf/xTENVgzeeE9X1Kna1x9q5Xog1CX79yxDMa5UBek=;
        b=Zyzrv9LveODqw+Yvdtroy26g/8liArbDt7h8AbbHWc0Xl2gPyRZnEFElbOsUOLpy1D
         7OBbLFenlXLhdHt/QIzm4nlvqrhMsBwa+dgUbQXx31rkZD1/fx7Aoo4BxDhr6WLHzBoy
         W8wxhohvqlrpuzoTAaHMlboTFmauXCCI1WRrViJeMFDSfzZ0J6Zwtt/1fdci6Xsc6Zjw
         207x6B5e8837ZxROTSrsdzgU0oZCYG0a4ZcLZS9vgpyZMDNkikBSqeVrZGbROPeJN1cc
         iZ4IB9ABHYXkvdcuwZtIAR3ABFu1Hp6/ls/mNTbf9eP9T2ZRWOFpH7jJ3+7KybS8MdPn
         bCdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/mf/xTENVgzeeE9X1Kna1x9q5Xog1CX79yxDMa5UBek=;
        b=qjde7SOicWLhIUu3ZlW5fCOaM2rCdPxfPzYGknUEtOpLaGKs6hHFwu2eWhgFhh+wC2
         gbvazNLnxWmFgg7y61VIaCI4ztjbjJ+plIWPmkT/XQpKnklT5KcjS5I9jCC7rxjxE2J+
         Pf/KSdH9Dzc2utatdw0R2mSHD5PIOL0qfeiFB7weBKfX/Fmowj0WFG9T7m3ienKQtaRH
         xn+1KSEk/cObfQpZz7QI+7JPRAWq2v3Yy1aaTkOn/t41pbpmeaQXvHvVpUFsxqIBYEoO
         pWBhIhLtdSKIoBFAUq9GdkS7ZHkurW8D2Q7gTh42Vj/K7uxLqAdF6QiI9qO4je1sBuaN
         N8sA==
X-Gm-Message-State: AOAM532iApESSnK3twlPyUJHdkCL5+vRgqMrRCp4FrrZRgNBIqyRg3p6
        trWctGlLaj9e9/JXG5RZtAP9YuSdJyGOz3iY
X-Google-Smtp-Source: ABdhPJyyfZLPKQNPBq1iiwjeaRjvjB6TxE39M5i/3np3JvRHg4aHFdzRtoqJXmmXoCYn9FGUo+q6IQ==
X-Received: by 2002:a63:cc16:: with SMTP id x22mr5751953pgf.414.1598818252550;
        Sun, 30 Aug 2020 13:10:52 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id v17sm5536700pfn.24.2020.08.30.13.10.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 30 Aug 2020 13:10:52 -0700 (PDT)
Subject: Re: Unclear documentation about IORING_OP_READ
To:     Shuveb Hussain <shuveb@gmail.com>, io-uring@vger.kernel.org
References: <CAF=AFaLzf=B28CXt0qJ0z7wXfRosqLPYQYtC-DrVogA0J_5AKw@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <81700e99-21cb-c338-f1f7-8019b2cb6928@kernel.dk>
Date:   Sun, 30 Aug 2020 14:10:50 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAF=AFaLzf=B28CXt0qJ0z7wXfRosqLPYQYtC-DrVogA0J_5AKw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/29/20 9:32 PM, Shuveb Hussain wrote:
> Jens,
> 
> I'm coming up the the man page for io_uring(7) and I noticed that the
> existing man page or other available documentation does not make it
> clear about offset (off in the SQE) being a mandatory parameter for
> the following operations:
> IORING_OP_READ
> IORING_OP_WRITE
> IORING_OP_READV
> IORING_OP_WRITEV
> 
> Regular UNIX developers will expect subsequent read/write operations
> on the same file descriptor to remember the file offset for files that
> continue to be open. Is this the intended behavior or is it just that
> it is not documented? If it is the latter, I'll clearly call it out in
> the documentation.

This is intended behavior, you should consider the READV to be just
like preadv2() in that it takes the offset/iov/flags, and ditto on
the write side. READ is basically what a pread2 would be, if it
existed.

That said, you can use off == -1 if IORING_FEAT_RW_CUR_POS is set
in the feature flags upon ring creation, and that'll use (and updated)
the current file offset. This works for any non-stream/pipe file
type.

-- 
Jens Axboe

