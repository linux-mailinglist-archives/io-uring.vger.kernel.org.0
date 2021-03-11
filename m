Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 723A53377B4
	for <lists+io-uring@lfdr.de>; Thu, 11 Mar 2021 16:29:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234028AbhCKP3G (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 11 Mar 2021 10:29:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234121AbhCKP2i (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 11 Mar 2021 10:28:38 -0500
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1762C061574
        for <io-uring@vger.kernel.org>; Thu, 11 Mar 2021 07:28:38 -0800 (PST)
Received: by mail-il1-x12c.google.com with SMTP id d5so19255965iln.6
        for <io-uring@vger.kernel.org>; Thu, 11 Mar 2021 07:28:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=6g3fwccs+3+QhG8u3X8U8+GXZgOiVfjjodz7ZVBwh6I=;
        b=PtpkiSApuzuriynxbG+6MiKKybUzDtd8+T1YMCvq8K7E+t8AxSOpDOp20LC4XXdLWA
         f1ywEu/y8RtgnEyNXrlZaS3xtr1HQUBXfXgP1DnhNHL9cqflvi7rtHPZK2v9xfnr2kVM
         UPlixvuehOoAiT56l+pO4d1C9mC1Zmj3GjQgdYSXLEwwmk+N1bUnx4dN8zoeXYySuyfN
         xl8rVinDH69r2lnXnxdEJit+WnK+8+/qgdidoDuMP+F8TfZ/J2l5YbmSkWmWPmLJGvGU
         /HQOIzE92Ps4vzSwi8cyzpkXud18PJczwYz50Ri4q4qpOK2BbEDGBAyPPUVz3a8Mmt7U
         WRIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6g3fwccs+3+QhG8u3X8U8+GXZgOiVfjjodz7ZVBwh6I=;
        b=PDczea/INSZGrQb1vlRpGfV52icXCZUiBk5l22HnglVkFrnWarZent8k+Xic7l2/2J
         edoKrWwK7WLYEv8C5CZHZpf9T2+j3OxUgnBH597n6n0v6FY1sYDndWPTvU84MmBnYG/r
         RViT0/7T2O2CqxTiG5LWuSRXvh88vYFEr3hGrZu+lnupCyx2TQsc7+6RssEbBVZwVtAN
         Z6yHPqopg038LGLU5x7zuSr78cN0UFNkteyFIqOTAxln+PIZVP2hVGDoADUJ4dpMDyuu
         3LrWx0PqB8urS+qd1eFbcX4tOMdskQtk6UJBUJaYUFWiulIYh3i0hKqJCiNHiRJYHbSY
         SM+Q==
X-Gm-Message-State: AOAM531trpW2f997HIyYNqLzQIM5WuHWGUE8VXLePmtFRI2CP1/MZ4H4
        24TsdbrKtu3YrFq+2HyHANn/ZtpvwCI7Tw==
X-Google-Smtp-Source: ABdhPJxC0OcjxZbkfPl3h2YwzHHOmMVdeZDFHG+LiRXovf0raCpDuYjwMgTtuIbydzZ3cBqXjzDS8w==
X-Received: by 2002:a92:c149:: with SMTP id b9mr6884429ilh.133.1615476517965;
        Thu, 11 Mar 2021 07:28:37 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id t7sm1443530ilj.62.2021.03.11.07.28.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Mar 2021 07:28:36 -0800 (PST)
Subject: Re: IORING_SETUP_ATTACH_WQ (was Re: [PATCH 1/3] io_uring: fix invalid
 ctx->sq_thread_idle)
To:     Stefan Metzmacher <metze@samba.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
References: <cover.1615381765.git.asml.silence@gmail.com>
 <fd8edef7aecde8d776d703350b3f6c0ec3154ed3.1615381765.git.asml.silence@gmail.com>
 <a25f115b-830c-e0f6-6d61-ff171412ea8b@samba.org>
 <b5fe7af7-3948-67ae-e716-2d2d3d985191@gmail.com>
 <5efea46e-8dce-3d6b-99e4-9ee9a111d8a6@samba.org>
 <b994e9c6-8642-20a0-61d6-f7943e151e76@samba.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <00e35bef-e306-26fc-939f-2958d660238e@kernel.dk>
Date:   Thu, 11 Mar 2021 08:28:36 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <b994e9c6-8642-20a0-61d6-f7943e151e76@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/11/21 5:02 AM, Stefan Metzmacher wrote:
> Or we completely ignore IORING_SETUP_ATTACH_WQ (execpt the error
> cases).
> 
> Then we can implement a new IORING_SETUP_ATTACH_SQ with new semantics,
> that the existing sq_thread will be used as it and both sides now what
> it means to them. We also add a new
> IORING_REGISTER_RESTRICTIONS/IORING_RESTRICTION_ALLOW_SQ_ATTACHMENTS
> which prepares the first io_ring_ctx to allow others to attach.
> 
> Would that make sense?

I think we should retain ATTACH_WQ semantics with SQPOLL for the cases
that are possible. That would not exclude doing a more specific
ATTACH_SQ for the new case. And maybe those two cases can then be folded
down the line.

-- 
Jens Axboe

