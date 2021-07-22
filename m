Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D15C3D308A
	for <lists+io-uring@lfdr.de>; Fri, 23 Jul 2021 01:43:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232024AbhGVXC0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 22 Jul 2021 19:02:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232676AbhGVXCY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 22 Jul 2021 19:02:24 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE3B8C061575
        for <io-uring@vger.kernel.org>; Thu, 22 Jul 2021 16:42:57 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id gx2so8281914pjb.5
        for <io-uring@vger.kernel.org>; Thu, 22 Jul 2021 16:42:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bkuHWBGkKEe0/2yCu3CYpAcsngktc49mg9N4X5eshww=;
        b=bi/mem5UEK8uuA+WAZ3f37/Ej4WBRo78trRBGEM1yZdL/fdiKw84SB/i26ZqhBeJql
         0OBsVSDvVdvN2OOBSWYOSR3TMCpqZ3KnSpV3nbFD5WPQeKAd8f1tuGXpES9C8gs4yyD1
         zo9K4HQcZEbZdZ/JwE/W6b3HBfGJYQYii+Gwjl8vuZtt8F6kLgf0Sw1iJh4lpWtha0Q7
         6oExucVtB1CPMpH/iMPRQBLm8CwGUiKJEHKe3zC/+0c2rjQJbUa/jqQQrJkJdE169n5Q
         Z8sUgNI0p93p9LZTzKE4m4a6FhcUDJ3Wv8aSO0HSQb5KGTHLWRseDGcwDxkGLpZQaKSY
         eOEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bkuHWBGkKEe0/2yCu3CYpAcsngktc49mg9N4X5eshww=;
        b=fJjfQmIxL3tp6ZXIi0mqKchurkT09wI+w2OkLAEP9QAfhw8xG/Rjp10YWJZYUOpdME
         EzPbe5+DQE27O3JmnWTX+0xUUOw45ZONSgk5PbwzS6HJE9GQOjFR3UW4YsvJ5vRn9dNG
         s5dxmkieqejrilV4ComXlqE6QmNsymw6i+OygSqSHJAJYTgIMkN5X4VMKg3dr2Y/Xxie
         6h+04ZJMe7bq7oYG9G4WXHU+DgKdJPXMhCp9VIJpiH3pK8dR38K3MxUlLMZGUs4MW1iy
         7RrvY2awiruudPZIXJ/doZCKJJkRY5Jl3JFT45rGsY33TVF0/ADA1RUOwP8wca05PGig
         RPvQ==
X-Gm-Message-State: AOAM530N04srQnyn3/J+inbRyKMPEtf+2O9+LUOO3fLYasObWirg+AyJ
        CDavghDsmoVwUsr05fGqD2jYig==
X-Google-Smtp-Source: ABdhPJxKpS1tFgoUnKVV34+0WI7GszJldxT7QKj4Ob5J/Z9ejlybBlXIKfSyYBJ3287AejdsrOLlpw==
X-Received: by 2002:a63:1d18:: with SMTP id d24mr2295691pgd.69.1626997377261;
        Thu, 22 Jul 2021 16:42:57 -0700 (PDT)
Received: from [192.168.1.187] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id a13sm32977826pfl.92.2021.07.22.16.42.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Jul 2021 16:42:56 -0700 (PDT)
Subject: Re: [PATCH 3/3] io_uring: refactor io_sq_offload_create()
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
References: <cover.1618916549.git.asml.silence@gmail.com>
 <939776f90de8d2cdd0414e1baa29c8ec0926b561.1618916549.git.asml.silence@gmail.com>
 <YPnqM0fY3nM5RdRI@zeniv-ca.linux.org.uk>
 <57758edf-d064-d37e-e544-e0c72299823d@kernel.dk>
 <YPn/m56w86xAlbIm@zeniv-ca.linux.org.uk>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <a85df247-137f-721c-6056-a5c340eed90e@kernel.dk>
Date:   Thu, 22 Jul 2021 17:42:55 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <YPn/m56w86xAlbIm@zeniv-ca.linux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/22/21 5:30 PM, Al Viro wrote:
> On Thu, Jul 22, 2021 at 05:06:24PM -0600, Jens Axboe wrote:
> 
>> But yes, that is not great and obviously a bug, and we'll of course get
>> it fixed up asap.
> 
> Another fun question: in do_exit() you have
>         io_uring_files_cancel(tsk->files);
> 
> with
> 
> static inline void io_uring_files_cancel(struct files_struct *files)
> {
>         if (current->io_uring)
> 		__io_uring_cancel(files);
> }
> 
> and
> 
> void __io_uring_cancel(struct files_struct *files)
> {
>         io_uring_cancel_generic(!files, NULL);
> }
> 
> What the hell is that about?  What are you trying to check there?
> 
> All assignments to ->files:
> init/init_task.c:116:   .files          = &init_files,
> 	Not NULL.
> fs/file.c:433:          tsk->files = NULL;
> 	exit_files(), sets to NULL
> fs/file.c:741:          me->files = cur_fds;
> 	__close_range(), if the value has been changed at all, the new one
> 	came from if (fds) swap(cur_fds, fds), so it can't become NULL here.
> kernel/fork.c:1482:     tsk->files = newf;
> 	copy_files(), immediately preceded by verifying newf != NULL
> kernel/fork.c:3044:                     current->files = new_fd;
> 	ksys_unshare(), under if (new_fd)
> kernel/fork.c:3097:     task->files = copy;
> 	unshare_files(), with if (error || !copy) return error;
> 	slightly upstream.
> 
> IOW, task->files can be NULL *ONLY* after exit_files().  There are two callers
> of that; one is for stillborns in copy_process(), another - in do_exit(),
> well past that call of io_uring_files_cancel().  And around that call we have
> 
>         if (unlikely(tsk->flags & PF_EXITING)) {
> 		pr_alert("Fixing recursive fault but reboot is needed!\n");
> 		futex_exit_recursive(tsk);
> 		set_current_state(TASK_UNINTERRUPTIBLE);
> 		schedule();
> 	}
>         io_uring_files_cancel(tsk->files);
> 	exit_signals(tsk);  /* sets PF_EXITING */
> 
> So how can we possibly get there with tsk->files == NULL and what does it
> have to do with files, anyway?

It's not the clearest, but the files check is just to distinguish between
exec vs normal cancel. For exec, we pass in files == NULL. It's not
related to task->files being NULL or not, we explicitly pass NULL for
exec.

-- 
Jens Axboe

