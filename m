Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0058E168F66
	for <lists+io-uring@lfdr.de>; Sat, 22 Feb 2020 15:45:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727230AbgBVOpi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 22 Feb 2020 09:45:38 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:37251 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727184AbgBVOpi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 22 Feb 2020 09:45:38 -0500
Received: by mail-pj1-f67.google.com with SMTP id m13so2080540pjb.2
        for <io-uring@vger.kernel.org>; Sat, 22 Feb 2020 06:45:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bvlrE7mWHtJvOwY/9wUETVaBfqQZK2R48j//QYH+3Eo=;
        b=SRXJBQLYD3zAGQjK2wN1l3u/rV+MrTmrVi76TPNZYdAVaBIUg1CNGLMgAJYVJqCGGq
         i9WfHlLzl3A1mZs7Ta+l5J2X/QA4PhBy+mI9GG3QfMFtz4ri5B77xcq5u//Loq7yv9PU
         bZCdg8Lwcxf4m8ZiY0epRJJMjAT3OeZbnutuqHYWLWiPePq0dMGimEDZxUErZt/YHLgn
         MlDPNNdJ4lhheW8iQp/CgE7xziZnADXW3sgAs3kFU1SZ13YwyH3lc9MwAeMcfR63RQVs
         oQ/xheA0ldhEG4DdVA8rwg1Aif64Cqhinl3YGbBXnvDL+y5nY51YLubNrEtV68ZMkdEv
         dU5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bvlrE7mWHtJvOwY/9wUETVaBfqQZK2R48j//QYH+3Eo=;
        b=gFCB3plocsfbVd2FkFsS+R2QFNbeGN5YHM5/UvrKW4apJhMi/586KdKFeeM4zeByAP
         swl1ZgH6wkc7yRYlQ2NzgMji2Uxu3rHGpUE/33QDVT8z6gGVzouPjHee2BzGnTzavJb+
         z7Lsy13Ir0W+oEfceCvqw4XFO9EA2mo4PZrXK/vzRFvFTWLV8s+eeVQrVV2QF1h5BcjA
         JNvFmb99kpYnozPAXuv4Gz32yEWRi9Juc8Lynx5O4Hc6Yszk72FdA2ZMtSGEF5v0QNHD
         eQgYDW2w9iafV6OJRmcq6u6n3I4xPDnz1qmVNz5DCKh9CseaMvXTkvk1y/K9dmaxn3vm
         yvUQ==
X-Gm-Message-State: APjAAAUCQvEl7CLYrdUDZL4zPKM6B/cFibYCnZfvoqNQ85gf1F04y/CD
        fBbedigar6V+Xrd+F5i3ug/HIVzz5Cw=
X-Google-Smtp-Source: APXvYqxet5NhMk/UJifQxUfsdqyNC+nv8U3GjAPsLkH1E6cXvNXqOAZTKeQEvrB9uD50wn3VmA4u3A==
X-Received: by 2002:a17:90a:da04:: with SMTP id e4mr8991620pjv.26.1582382736154;
        Sat, 22 Feb 2020 06:45:36 -0800 (PST)
Received: from ?IPv6:2605:e000:100e:8c61:d487:5bdf:4186:2ae1? ([2605:e000:100e:8c61:d487:5bdf:4186:2ae1])
        by smtp.gmail.com with ESMTPSA id z10sm6166902pgz.88.2020.02.22.06.45.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 22 Feb 2020 06:45:35 -0800 (PST)
Subject: Re: [PATCH] io_uring: fix __io_iopoll_check deadlock in io_sq_thread
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     joseph.qi@linux.alibaba.com
References: <20200222064605.2571-1-xiaoguang.wang@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <39a04e2c-eb6d-de5b-a070-d8891fae341f@kernel.dk>
Date:   Sat, 22 Feb 2020 06:45:33 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200222064605.2571-1-xiaoguang.wang@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/21/20 11:46 PM, Xiaoguang Wang wrote:
> Since commit a3a0e43fd770 ("io_uring: don't enter poll loop if we have
> CQEs pending"), if we already events pending, we won't enter poll loop.
> In case SETUP_IOPOLL and SETUP_SQPOLL are both enabled, if app has
> been terminated and don't reap pengding events which are already in cq
> ring, and there are some reqs in poll_list, io_sq_thread will enter
> __io_iopoll_check(), and find pending events, then return, this loop
> will never have a chance to exit.
> 
> I have seem this issue in fio stress tests, to fix this issue, let
> io_sq_thread call io_iopoll_getevents() with argument 'min' being zero,
> and remove __io_iopoll_check().

Thanks, nice and clean fix. Applied for 5.6.

-- 
Jens Axboe

