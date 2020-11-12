Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 666962B03A4
	for <lists+io-uring@lfdr.de>; Thu, 12 Nov 2020 12:15:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726776AbgKLLPd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 12 Nov 2020 06:15:33 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:54688 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727762AbgKLLP2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 12 Nov 2020 06:15:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605179725;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SptEithhOviQGi+h36hxN3UnzV3ONPYDL/mZWJbccfE=;
        b=UTevLzqjRMfs+T45FF3XEnTbHDFYumIaLfYTfWTGrrGSUa0waJH8/VtOivRJQS/lqscXQA
        fguUXH4ecq5t001lUfhM5Gm/XyYi2G66Ii73fCeKVCbKH9Vy++WkystgxrFYHw11Ol/lf7
        p5PibVMtrpTKV+mBeyefndAmdT8BqIM=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-538-XEmcs2K5PDO9RWE_MCVmZw-1; Thu, 12 Nov 2020 06:15:24 -0500
X-MC-Unique: XEmcs2K5PDO9RWE_MCVmZw-1
Received: by mail-wm1-f70.google.com with SMTP id y1so2015562wma.5
        for <io-uring@vger.kernel.org>; Thu, 12 Nov 2020 03:15:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SptEithhOviQGi+h36hxN3UnzV3ONPYDL/mZWJbccfE=;
        b=I+DTjXDoX/V2/emVFi5bKuBg0jUyuYIt4X7AAwIsLEmvnkjNevYePMckav3ffZNjnN
         vsC40Av+M9Z9Mh3ozj4tzH+HOut2F9lNuI1bLudI4n4O94OI37+1JhiZWS2hUYaDHaf7
         LzInIZif2l8FQ74RQRWTZeZyX4NHQIbOjD9gT835dZGc3kAEoKhMy2dWOM+uykrvkRYe
         nT3uJePS4O8j11JUT25eD1WmgZ2xa6n7Eb9Z8MF+Wh+CEtra+U4fdW4IjhNsp2DJVFxp
         7SJ0XlKS2utykcMO5P72zjyu5HsYyoAqX/2O6THulmdDJw62DNhD6DsPrJG81ujKMQMN
         9RLw==
X-Gm-Message-State: AOAM533MHGNDlGwJ3QIi8yC8FWU9OXt9hIeFjm/LKRHUbWBU2OWlmq9Z
        RAVwy4e6bTWQy1H7OtD8+/zAybAqtCOK/Y7e0XHshXIZs8O1hHBzVssVNDb1znnnVD9lLMVM0pP
        Nj3tR1HuF+tkRmZTCvp0=
X-Received: by 2002:a5d:410c:: with SMTP id l12mr15666417wrp.173.1605179722519;
        Thu, 12 Nov 2020 03:15:22 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwsSeukokvHDyfkqlcJbtCNosp/0YEWbWizVCZLji631mi1dfYr+wjqtHOGE/Rga4bwHGOFXA==
X-Received: by 2002:a5d:410c:: with SMTP id l12mr15666400wrp.173.1605179722334;
        Thu, 12 Nov 2020 03:15:22 -0800 (PST)
Received: from steredhat (host-79-47-126-226.retail.telecomitalia.it. [79.47.126.226])
        by smtp.gmail.com with ESMTPSA id f13sm989068wrq.78.2020.11.12.03.15.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 03:15:21 -0800 (PST)
Date:   Thu, 12 Nov 2020 12:15:19 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Cc:     io-uring@vger.kernel.org, axboe@kernel.dk,
        joseph.qi@linux.alibaba.com
Subject: Re: [PATCH 5.11 1/2] io_uring: initialize 'timeout' properly in
 io_sq_thread()
Message-ID: <20201112111519.ydrzwsvsbipotogr@steredhat>
References: <20201112065600.8710-1-xiaoguang.wang@linux.alibaba.com>
 <20201112065600.8710-2-xiaoguang.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20201112065600.8710-2-xiaoguang.wang@linux.alibaba.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Nov 12, 2020 at 02:55:59PM +0800, Xiaoguang Wang wrote:
>Some static checker reports below warning:
>    fs/io_uring.c:6939 io_sq_thread()
>    error: uninitialized symbol 'timeout'.
>
>Fix it.

We can also add the reporter:

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>

>
>Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
>---
> fs/io_uring.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)

LGTM:

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

>
>diff --git a/fs/io_uring.c b/fs/io_uring.c
>index c1dcb22e2b76..c9b743be5328 100644
>--- a/fs/io_uring.c
>+++ b/fs/io_uring.c
>@@ -6921,7 +6921,7 @@ static int io_sq_thread(void *data)
> 	const struct cred *old_cred = NULL;
> 	struct io_sq_data *sqd = data;
> 	struct io_ring_ctx *ctx;
>-	unsigned long timeout;
>+	unsigned long timeout = 0;
> 	DEFINE_WAIT(wait);
>
> 	task_lock(current);
>-- 
>2.17.2
>

