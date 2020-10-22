Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4269D296415
	for <lists+io-uring@lfdr.de>; Thu, 22 Oct 2020 19:52:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S368354AbgJVRwh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 22 Oct 2020 13:52:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33872 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S368353AbgJVRwh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 22 Oct 2020 13:52:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603389155;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=B38cdsCA6j2pG8/siEMaNeU7S5Xwhw+lvST8nlcR5Es=;
        b=ZzuIEr/Wl58ytd8Mth2YHw/pgtInp9r+YwjztIzPpW+e+3HLb9TiSuPZ6T/Sc+7dx0Q24v
        xh5kg6vrXdn7duqGemI7hIfrOLrMdLIh37KwOu4SjhKwynsAiy6p61/ZGV+eIgBrkw3601
        OW6g/tt+vmGXY5ZgK5rM5XkWXXXSS/I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-305-Kn2l5idqOoO0dang8YhjyQ-1; Thu, 22 Oct 2020 13:52:33 -0400
X-MC-Unique: Kn2l5idqOoO0dang8YhjyQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3E982804B6A;
        Thu, 22 Oct 2020 17:52:32 +0000 (UTC)
Received: from segfault.boston.devel.redhat.com (segfault.boston.devel.redhat.com [10.19.60.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E297F60C04;
        Thu, 22 Oct 2020 17:52:31 +0000 (UTC)
From:   Jeff Moyer <jmoyer@redhat.com>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: Re: [PATCH v2] io_uring: remove req cancel in ->flush()
References: <6cffe73a8a44084289ac792e7b152e01498ea1ef.1603380957.git.asml.silence@gmail.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
Date:   Thu, 22 Oct 2020 13:52:30 -0400
In-Reply-To: <6cffe73a8a44084289ac792e7b152e01498ea1ef.1603380957.git.asml.silence@gmail.com>
        (Pavel Begunkov's message of "Thu, 22 Oct 2020 16:38:27 +0100")
Message-ID: <x491rhq6tcx.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Pavel Begunkov <asml.silence@gmail.com> writes:

> Every close(io_uring) causes cancellation of all inflight requests
> carrying ->files. That's not nice but was neccessary up until recently.
> Now task->files removal is handled in the core code, so that part of
> flush can be removed.

I don't understand the motivation for this patch.  Why would an
application close the io_uring fd with outstanding requests?

-Jeff

>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
> v2: move exiting checks into io_uring_attempt_task_drop() (Jens)
>     remove not needed __io_uring_attempt_task_drop()
>
>  fs/io_uring.c | 28 +++++-----------------------
>  1 file changed, 5 insertions(+), 23 deletions(-)
>
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 754363ff3ad6..29170bbdd708 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -8668,19 +8668,11 @@ static void io_uring_del_task_file(struct file *file)
>  		fput(file);
>  }
>  
> -static void __io_uring_attempt_task_drop(struct file *file)
> -{
> -	struct file *old = xa_load(&current->io_uring->xa, (unsigned long)file);
> -
> -	if (old == file)
> -		io_uring_del_task_file(file);
> -}
> -
>  /*
>   * Drop task note for this file if we're the only ones that hold it after
>   * pending fput()
>   */
> -static void io_uring_attempt_task_drop(struct file *file, bool exiting)
> +static void io_uring_attempt_task_drop(struct file *file)
>  {
>  	if (!current->io_uring)
>  		return;
> @@ -8688,10 +8680,9 @@ static void io_uring_attempt_task_drop(struct file *file, bool exiting)
>  	 * fput() is pending, will be 2 if the only other ref is our potential
>  	 * task file note. If the task is exiting, drop regardless of count.
>  	 */
> -	if (!exiting && atomic_long_read(&file->f_count) != 2)
> -		return;
> -
> -	__io_uring_attempt_task_drop(file);
> +	if (fatal_signal_pending(current) || (current->flags & PF_EXITING) ||
> +	    atomic_long_read(&file->f_count) == 2)
> +		io_uring_del_task_file(file);
>  }
>  
>  void __io_uring_files_cancel(struct files_struct *files)
> @@ -8749,16 +8740,7 @@ void __io_uring_task_cancel(void)
>  
>  static int io_uring_flush(struct file *file, void *data)
>  {
> -	struct io_ring_ctx *ctx = file->private_data;
> -
> -	/*
> -	 * If the task is going away, cancel work it may have pending
> -	 */
> -	if (fatal_signal_pending(current) || (current->flags & PF_EXITING))
> -		data = NULL;
> -
> -	io_uring_cancel_task_requests(ctx, data);
> -	io_uring_attempt_task_drop(file, !data);
> +	io_uring_attempt_task_drop(file);
>  	return 0;
>  }

