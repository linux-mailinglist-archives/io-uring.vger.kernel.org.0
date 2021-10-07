Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E17A242539D
	for <lists+io-uring@lfdr.de>; Thu,  7 Oct 2021 15:02:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240917AbhJGNEr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 7 Oct 2021 09:04:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233100AbhJGNEq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 7 Oct 2021 09:04:46 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 089BEC061746
        for <io-uring@vger.kernel.org>; Thu,  7 Oct 2021 06:02:53 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id d13-20020a17090ad3cd00b0019e746f7bd4so6897869pjw.0
        for <io-uring@vger.kernel.org>; Thu, 07 Oct 2021 06:02:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amikom.ac.id; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ouFaHI6//srmoDbkVCMDU8OlICFoFSlEbD0ixAQIk0U=;
        b=EQUBKCnBDgJ8EelR7z7a/7kcUOuzBfKv4wmeFTZpF8ZkUAYf3HWSA92Js1yI0doxcm
         iqt7G1rcUTXU6qeGJ8H/L3VqRjV+i6lUPxCPhdeaWnIGmLWwJQdZkwNpaOaWcv512ksL
         /N6gZE9ORrocxvV8ok5/W4fwNR2fyh+/uVT48/gP3rY9Ig9RtOs41/8UgAVdY3mCx691
         vbrq44ZNBeyZyitQArmoK0a9TVWF6GBqIO/fgK+sAQ1jISzl9vxZg2z+S1gtJheuYfWm
         cjENMIWpX52jn986E2Uxsb8NY2uuDjiPw/K21fy27BIxV46I8TLNv99s8GlcbkRHcOfz
         9ErQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ouFaHI6//srmoDbkVCMDU8OlICFoFSlEbD0ixAQIk0U=;
        b=LFw5vjbT5tT2Tw1nr+KZ9c/mGuU83ILkfpW+RCkAzI2zWPt5o1cJvjlf8BcDlzHapZ
         QZyQ58OkGZPFE/1GvqTgbRt7WaYIB+WZMgThx6O/s5RufDOOhS18Gc5zd+o1I024lmHA
         2LeFKUn7ZyuhBG1Ey46dUu+qXk1nArYa7C2bedYysOHIYl2LAWelBCTYWTkIpfwfI+c8
         LDvxInt0uPyEo2Jfc+GC6LUuTIf/KsEZemr+P/clwRI639YZfzqFbpysSDGolS8YJrk1
         +hdWn8yvRGnNJUSvUiFWaz9WxRzJq4xux1OVGq5eOsZhM2tJsRRZpuO0EX7ufW0dLDrm
         yhyA==
X-Gm-Message-State: AOAM530Q8rFIXtv/xUmpds3/iauxxtlLCNL1VQeQZ3RwcXceWmNMdGix
        kbjPMbbvV5STwnfmIBCc5x333A==
X-Google-Smtp-Source: ABdhPJwCC2hyZYoWFa4PkstocUXD/t0mGQzBMmwusMyQgA4MdQpEFMrFg9zFCHr1BjUUiABywouaaA==
X-Received: by 2002:a17:90b:350c:: with SMTP id ls12mr4777401pjb.36.1633611772481;
        Thu, 07 Oct 2021 06:02:52 -0700 (PDT)
Received: from integral.. ([182.2.71.117])
        by smtp.gmail.com with ESMTPSA id k14sm24948433pga.65.2021.10.07.06.02.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 06:02:51 -0700 (PDT)
From:   Ammar Faizi <ammar.faizi@students.amikom.ac.id>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>
Cc:     Bedirhan KURT <windowz414@gnuweeb.org>,
        Louvian Lyndal <louvianlyndal@gmail.com>
Subject: Re: [PATCH v2 RFC liburing 4/5] Add no libc build support
Date:   Thu,  7 Oct 2021 20:01:01 +0700
Message-Id: <20211007130101.1339216-1-ammar.faizi@students.amikom.ac.id>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <3ca99c4b-1aa6-b10e-340c-f2d860c39b57@kernel.dk>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Oct 7, 2021 at 7:27 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 10/7/21 12:31 AM, Ammar Faizi wrote:
> > Create `src/nolibc.c` to substitute libc functions like `memset()`,
> > `malloc()` and `free()`. Only build this file when we build liburing
> > without libc.
> >
> > Wrap libc functions with `static inline` functions, defined in
> > `src/lib.h`, currently we have:
> >  1) `get_page_size`
> >  2) `uring_memset`
> >  3) `uring_malloc`
> >  4) `uring_free`
> >
> > Add conditional preprocessor in `src/{syscall,lib}.h` to use arch
> > dependent and nolibc functions when we build liburing without libc.
> >
> > Extra notes for tests:
> >  1) Functions in `src/syscall.c` require libc to work.
> >  2) Tests require functions in `src/syscall.c`.
> >
> > So we build `src/syscall.c` manually from test's Makefile.
> >
> > The Makefile in `src/` dir still builds `src/syscall.c` when we
> > compile liburing with libc.
>
> Why are we jumping through hoops on the naming? You add a uring_memset()
> that the lib is supposed to use, then that calls memset() with libc or
> __uring_memset() if we're building without libc. Why not just have the
> nolibc build provide memset() and avoids this churn? Not just in terms
> of the immediate patch, that matters less. But longer term where
> inevitably a memset() or similar will be added to the existing code
> base.
>

Ah, good point. The syscall wrappers gave me this bad suggestion. I know
we have a rationale to wrap syscalls because we need to eliminate `errno`
being used in C files. But we don't actually need extra wrappers for
`memset()`, `malloc()` and `free()`.

I agree that we can just provide `memset()`, `malloc()` and `free()` for
the nolibc build without having extra wrappers like that.

I will address this and send the rest as a PATCHSET.

-- 
Ammar Faizi
