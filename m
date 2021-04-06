Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6F85355AD4
	for <lists+io-uring@lfdr.de>; Tue,  6 Apr 2021 19:54:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234992AbhDFRy2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 6 Apr 2021 13:54:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236701AbhDFRyA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 6 Apr 2021 13:54:00 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE2A3C06174A
        for <io-uring@vger.kernel.org>; Tue,  6 Apr 2021 10:53:51 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id e7so17598641edu.10
        for <io-uring@vger.kernel.org>; Tue, 06 Apr 2021 10:53:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nR9zuBlOKava7r5pYa8mdFHZQHdQswb7WWg/eCA6f2g=;
        b=iNwwMxsY0yiT00RgHzomEkrrQ73b/LC+z1e4jT17mp9fD4DFLQGaTRzYPzYzl4o5np
         9ZdWH+I9+pZ7SY61xrlW6xXTCdwFJUhZ3NI7V8HFtdc4dZUUAzoSR1e6a978AR2vbP17
         4wHpEi7Rjj7iJKwnwppjNF0xlBlxfyNsUOyBpb27kp4kHz2UUNV9pIusO37TR5iOH9Ge
         cKaplEEibakhUZea83O/hnJNjbmB2AevUnOeCZ+n96YS0kJB3ArtSln6To0RgvBEYpQP
         PbM61dU0n/PZdLuSEQb4cl5mJzCoJmnAt2DYaUbhUcrakJl+fXX/xGiQdVP1NZDB2Ym0
         nb1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nR9zuBlOKava7r5pYa8mdFHZQHdQswb7WWg/eCA6f2g=;
        b=odOTPbfaz1yEbrhyT7RtmhrsGbBFWusUAaciSAypwkzRMCtxMdO8+2wjW+sj+178B5
         hFaxWlb3aqOpSa9WgBfy2MnFV35WGB6t5qJmZ5LkI8C0RKv7JDU2TKZRyC7v69WQQQ0k
         jiCnEG3NzFkMpOnAigBwvZMMvuK+fwvUDMosuF+NfeHBcOxyFu/2/+C9cieBj41pBvsE
         dK6qEJmbX3QdZde15Z/T/FGecJJPnRPSal+TsCSA72sAzphEwCaCJsrCL5Q6JGEAZXMZ
         pFl2ZTP/b40EwPTSbOpVCkxql3g3BGg6B3DH9x9t0ACxg3rG+Grd6DTHi4cMquAepTSS
         OJhw==
X-Gm-Message-State: AOAM533rCA7ehQEpa1d+ssvtzWPviIn2uSH+wYar90f4qMMgZLC+sRXG
        Dm2d7eOlsOTYyBp8qGMSf5urHOLF0uWpcEWce8MtT1XWcys=
X-Google-Smtp-Source: ABdhPJwq+m7uBpj4JAvTNNf0505K7N9NJpGW3/XFJ6W3SZiRos8lk4uN74qRcGrPYjH3HsWSJ3Fl6hV0YgwHe1Rzr2c=
X-Received: by 2002:a05:6402:13ce:: with SMTP id a14mr39779342edx.365.1617731630403;
 Tue, 06 Apr 2021 10:53:50 -0700 (PDT)
MIME-Version: 1.0
References: <CA+9Y6nzQ8M++uMjJV8_LbB+HwvSZOO3kzKoRO-OaMggdU+xXTA@mail.gmail.com>
In-Reply-To: <CA+9Y6nzQ8M++uMjJV8_LbB+HwvSZOO3kzKoRO-OaMggdU+xXTA@mail.gmail.com>
From:   Ryan Sharpelletti <sharpelletti@google.com>
Date:   Tue, 6 Apr 2021 13:53:39 -0400
Message-ID: <CA+9Y6nxMg8W8P1-_56N8ArwHvT2EUippzwd0y_zNJ+O5Hvbw0Q@mail.gmail.com>
Subject: Re: Potential corner case in release 5.8
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

I am following up on the above, do you know where the associated
mmdrop might be called?

Thanks,
Ryan



On Fri, Mar 5, 2021 at 2:07 PM Ryan Sharpelletti
<sharpelletti@google.com> wrote:
>
> Hi,
>
> I suspect there is a corner case for io_uring in release 5.8.
>
> Can you please explain where the associated mmdrop/kthread_unuse_mm
> calls for io_sq_thread_acquire_mm in io_init_req(...) are?
> Specifically, what would happen if there was an error after calling
> io_sq_thread_acquire_mm (for example, the -EINVAL a few lines after)?
>
> From what I can understand, it looks like the kthread_unuse_mm and
> mmput might be handled in the call to io_sq_thread_acquire_mm in
> io_sq_thread. However, I am not seeing where mmdrop might be called.
>
> Thanks,
> Ryan
