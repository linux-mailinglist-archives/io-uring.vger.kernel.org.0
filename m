Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 532DF2E80C9
	for <lists+io-uring@lfdr.de>; Thu, 31 Dec 2020 16:08:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726485AbgLaPHx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 31 Dec 2020 10:07:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726314AbgLaPHx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 31 Dec 2020 10:07:53 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB19BC061799
        for <io-uring@vger.kernel.org>; Thu, 31 Dec 2020 07:07:12 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id z21so13204672pgj.4
        for <io-uring@vger.kernel.org>; Thu, 31 Dec 2020 07:07:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=CnG8CVEyTF1enfQSkSJqro8DYIZ5KOjd9oTa37l8884=;
        b=O6zXkNrsEPemuThz4DWmgKL2Hj0G6nCf009iRQ/1X6LsGsIWlalKCac9k8SL2WyZGj
         jlUhe5WHdkHCyZ2d9AS3dknIpIEmOqZY5XBTj5ij/0IDSlYgB/G+GeOwqUZUaWRi3wuN
         ot3FJO3PVL2pa+f4sIjD9JCr51wNKYOIykNV5EoUDoFEPwbD3FXHCtYGQUBDUP55l88K
         oc9u89XuUsSnloUHAUCrwGd/omaH6i4jLz4bDmheoQboKLzn5Er44A0RWdGuH2ZHfDEX
         Tq8ZjKuxiMfhk3p33cZH1owwb4r8FRlgJrotvG6TULqV66h9wIqC//G6iqti7cNDlTiy
         /peg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CnG8CVEyTF1enfQSkSJqro8DYIZ5KOjd9oTa37l8884=;
        b=GifJzOkQaV3tIAozBi+Q5bmy+MVedpkkDl0vBlkgn3N0wZ1lCuKfEviIeHHc/ssK20
         NPfzM+MzQoypMG3ff3TCtS2MRVolGHlCKTxXuRTvRTN5Y2X7zP1k4+h1I+02L707Gvpc
         zQentO2XGxLk5BWMvO8u3kteT7tqWSBhjv1OxSN4NrQpe0WBEAtTYj+4/yRhirc5GQEI
         5jHvNO/7faWcaCD/bvG+qyxF/Yg2kXbV4ZZZyAACXkJMEkn1CXnhHRnAF8Rt3VX6zlFa
         zrIk6q3Avt3DdL4Iop63XFLbfLxZFKKfmHOm52SX21uJVjtJ5zZqUp2gNHpvqkNPiqGx
         Liog==
X-Gm-Message-State: AOAM532vSR9Twujy+EA11hB5/vP9YeROcdu/6lV/+sJCCFKCtZw6P16F
        bWq8sRqSuO5ztSeDx1s88vG+mzUZXPo9RQ==
X-Google-Smtp-Source: ABdhPJyZmhStxoJucdWmc5WYn+Fh7sIDfq/fFSUd224TSMA9Jwgi6yxDWptMLNEiWiJCD/srLrtl+w==
X-Received: by 2002:a63:1519:: with SMTP id v25mr55771785pgl.217.1609427232196;
        Thu, 31 Dec 2020 07:07:12 -0800 (PST)
Received: from ?IPv6:2603:8001:2900:d1ce:198f:c3ce:c557:4355? (2603-8001-2900-d1ce-198f-c3ce-c557-4355.res6.spectrum.com. [2603:8001:2900:d1ce:198f:c3ce:c557:4355])
        by smtp.gmail.com with ESMTPSA id 123sm26935510pgf.38.2020.12.31.07.07.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 31 Dec 2020 07:07:11 -0800 (PST)
Subject: Re: [PATCH 0/4] address some hangs
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1609361865.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <04cd27ad-3e28-c0ca-0f09-e26db35e01c6@kernel.dk>
Date:   Thu, 31 Dec 2020 08:07:13 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1609361865.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/30/20 2:34 PM, Pavel Begunkov wrote:
> 1/4 and 2/4 are for hangs during files unregister.
> 
> The other two fix not running task works during cancellation.
> Instead of patching task_work it moves io_uring_files_cancel()
> before PF_EXITING, should be less intrusive. Was there a
> particular reasong for doing that in exit_files()?
> 
> Pavel Begunkov (4):
>   io_uring: add a helper for setting a ref node
>   io_uring: fix io_sqe_files_unregister() hangs
>   kernel/io_uring: cancel io_uring before task works
>   io_uring: cancel requests enqueued as task_work's
> 
>  fs/file.c     |  2 --
>  fs/io_uring.c | 54 ++++++++++++++++++++++++++++++++++-----------------
>  kernel/exit.c |  2 ++
>  3 files changed, 38 insertions(+), 20 deletions(-)

Applied 1-3, as they look good. Can you resend 4/4 with the return
added?

-- 
Jens Axboe

