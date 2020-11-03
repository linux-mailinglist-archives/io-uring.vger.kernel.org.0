Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 955EF2A376E
	for <lists+io-uring@lfdr.de>; Tue,  3 Nov 2020 01:05:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbgKCAFQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 2 Nov 2020 19:05:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725940AbgKCAFP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 2 Nov 2020 19:05:15 -0500
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B576DC0617A6
        for <io-uring@vger.kernel.org>; Mon,  2 Nov 2020 16:05:15 -0800 (PST)
Received: by mail-pl1-x642.google.com with SMTP id p4so355813plr.1
        for <io-uring@vger.kernel.org>; Mon, 02 Nov 2020 16:05:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=WqTcq2Sl1Okb5WyOll5Od3oCS0bSFSJqINlRVnAtE1s=;
        b=NTzajZ/2iSkdNw9XCIBdem86jhsFo/m+8IVLR9pRTp3Joz/TNv1e4LQdA7AY4DFTLM
         yCcGmRVkN6BScQVDJ7vmlTJTIaE38Xp628Nn9KU6DZ51VUtX7FoxhbFyjYukrVdRAQxq
         qwO9K8eQijujfBvHZn4R3jwMfFPJCXAZ7VTXXKT+WjH0uh8ljL7G7PWnCYC/vBVuwtMz
         uqIM15I1wH67esg+x2G3ZPUX/VQwZAlsdocH2FP9mthetGZzFabKCFLMzoLc2ozi6I5s
         Dv4dzf52lv1hgP1yhbh/WPXVcNp+cy62L0H6vvkp+hY3BBPNSl7lkDekAEcpxykRzLMI
         hisw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WqTcq2Sl1Okb5WyOll5Od3oCS0bSFSJqINlRVnAtE1s=;
        b=iHC7ZLYSqPwEcFJUwbSvLIGmdmxn4OmCdZrHtY0wbAh3P1g9KZoSizCBpIrINajW3F
         GJxSr5GkmXhecGc4WkYRE4DulVP9ScBd0Rl0NFXSCBwUOGbd/PmNYkTGpkD8oP9epawP
         FQb3UQIz4d9+6dfGcxzWR6gIpCA04GlF+QDTrmvjqDWydbRcGOxaKX/AbRQ+w4vDbWmB
         LYH51jQZ9MSEhWF9ZrZxpxNsLhoAg7l81f9CF5Lb9ksRlxp6p/AZ6HxTdaQCAe6itxUH
         kbI+8rh9ZTeCQs956NHUXS8bNg6O6CVul4St+UyBWJLj8wzaZukIu7tV696ETlwGY7pg
         ycpw==
X-Gm-Message-State: AOAM5306nHDSBNieaqvdVAOX2D15lPbbnTljsCcFhOrLosQf3qlEOaPX
        BO5giMhwpzY0ZG0MhrOHxN1m2YTjs5sqzQ==
X-Google-Smtp-Source: ABdhPJxyyNOurQn7J5orrC1Zkq8cS6J/wnvy6bsRELr9+bQAQPHwhbjXpKwtkRhgoXGljC6TNH93FQ==
X-Received: by 2002:a17:902:8e8b:b029:d2:4276:1df0 with SMTP id bg11-20020a1709028e8bb02900d242761df0mr22699246plb.62.1604361914716;
        Mon, 02 Nov 2020 16:05:14 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id q12sm3610883pfc.84.2020.11.02.16.05.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Nov 2020 16:05:13 -0800 (PST)
Subject: Re: relative openat dirfd reference on submit
To:     Vito Caputo <vcaputo@pengaru.com>, io-uring@vger.kernel.org
References: <20201102205259.qsbp6yea3zfrqwuk@shells.gnugeneration.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <d57e6cb2-9a2c-86a4-7d64-05816b3eab54@kernel.dk>
Date:   Mon, 2 Nov 2020 17:05:12 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201102205259.qsbp6yea3zfrqwuk@shells.gnugeneration.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/2/20 1:52 PM, Vito Caputo wrote:
> Hello list,
> 
> I've been tinkering a bit with some async continuation passing style
> IO-oriented code employing liburing.  This exposed a kind of awkward
> behavior I suspect could be better from an ergonomics perspective.
> 
> Imagine a bunch of OPENAT SQEs have been prepared, and they're all
> relative to a common dirfd.  Once io_uring_submit() has consumed all
> these SQEs across the syscall boundary, logically it seems the dirfd
> should be safe to close, since these dirfd-dependent operations have
> all been submitted to the kernel.
> 
> But when I attempted this, the subsequent OPENAT CQE results were all
> -EBADFD errors.  It appeared the submit didn't add any references to
> the dependent dirfd.
> 
> To work around this, I resorted to stowing the dirfd and maintaining a
> shared refcount in the closures associated with these SQEs and
> executed on their CQEs.  This effectively forced replicating the
> batched relationship implicit in the shared parent dirfd, where I
> otherwise had zero need to.  Just so I could defer closing the dirfd
> until once all these closures had run on their respective CQE arrivals
> and the refcount for the batch had reached zero.
> 
> It doesn't seem right.  If I ensure sufficient queue depth and
> explicitly flush all the dependent SQEs beforehand
> w/io_uring_submit(), it seems like I should be able to immediately
> close(dirfd) and have the close be automagically deferred until the
> last dependent CQE removes its reference from the kernel side.

We pass the 'dfd' straight on, and only the async part acts on it.
Which is why it needs to be kept open. But I wonder if we can get
around it by just pinning the fd for the duration. Since you didn't
include a test case, can you try with this patch applied? Totally
untested...

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 1f555e3c44cd..b3a647dd206b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3769,6 +3769,9 @@ static int __io_openat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe
 		req->open.how.flags |= O_LARGEFILE;
 
 	req->open.dfd = READ_ONCE(sqe->fd);
+	if (req->open.dfd != -1 && req->open.dfd != AT_FDCWD)
+		req->file = fget(req->open.dfd);
+
 	fname = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	req->open.filename = getname(fname);
 	if (IS_ERR(req->open.filename)) {
@@ -3841,6 +3844,8 @@ static int io_openat2(struct io_kiocb *req, bool force_nonblock)
 	}
 err:
 	putname(req->open.filename);
+	if (req->file)
+		fput(req->file);
 	req->flags &= ~REQ_F_NEED_CLEANUP;
 	if (ret < 0)
 		req_set_fail_links(req);
@@ -5876,6 +5881,8 @@ static void __io_clean_op(struct io_kiocb *req)
 		case IORING_OP_OPENAT2:
 			if (req->open.filename)
 				putname(req->open.filename);
+			if (req->file)
+				fput(req->file);
 			break;
 		}
 		req->flags &= ~REQ_F_NEED_CLEANUP;

-- 
Jens Axboe

