Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39C4818C499
	for <lists+io-uring@lfdr.de>; Fri, 20 Mar 2020 02:23:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727235AbgCTBXH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 19 Mar 2020 21:23:07 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:35192 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727049AbgCTBXH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 19 Mar 2020 21:23:07 -0400
Received: by mail-pg1-f194.google.com with SMTP id 7so2248894pgr.2
        for <io-uring@vger.kernel.org>; Thu, 19 Mar 2020 18:23:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=sY0jlucWtr2KpqhKL8t483Rz+Yzzasp8fEJbBIxJRXY=;
        b=mQZZM8Msvr6A+mleatB5Rt/2f5+whZXOlyH/i/FNDsPTGNHl0gbAw8WAf/+jpjGJHt
         1JTyIa4kbIrdWQhH/kSdzrxMnq/4rMwH4kV9KxWyZwB+XNYvwXZK96t8XZ8y5B5Oh2Be
         ML3ZtbLTyxjznXORKBRtFjqeFmhphrC7q7Nh7xWXik8LX6G6xbvIzSbLG1UpEWKI9jhB
         oQnR18s2ljJIiGpGlgYLQw3r0n+7dGI/EP0FxDeNDEkvmjR5+4sghjKpLQ9tIR0IYLiS
         uE9q8YlZ4iUOZuXJS30WUGerm55Oyc33mowV1EgPjVsfc4chyf7w0be7fnMCORNjQjRV
         XqLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sY0jlucWtr2KpqhKL8t483Rz+Yzzasp8fEJbBIxJRXY=;
        b=YcwB4uQvELEHr+md+GdInzMYt7BJqSDI8Hqk2vgS0UNRfPLamJOlWoHUPG3zWJ5xRj
         wOMcHXk4kNPqLlHZe6Im2Fa2siTkPgWviZT+x9l1FiwynCVTqfNB4YM0a6T9qe6yHuxE
         qc+dL1DFDSgBKV8Ae3P969qAthBGymQOsNyBDZPysxGU5JEDIUEOIMLYwPuYoki9RobZ
         m30CTQDDGJmq45l7LxEZQG/4ENVcQCWfrrlcPepqqcz3ldmDJThnOMTFyErtUlC+aNyk
         dX5iKdo/JeM0tqIuyr1CCHt4fQ7HFAJP9MMkgjfigxuN1ljPYzYkRpyuf8tRmC3y27rb
         JFEw==
X-Gm-Message-State: ANhLgQ3spL8pbuliqApePJ4XRiS5YSOyYOH7t39VZmmGyKMtNbLE2lKI
        fWYEn+teWXeGtCMPFt/u6QMsq/6E1KSA1g==
X-Google-Smtp-Source: ADFU+vvgtOVPnlNIjtBE1bDMmQSYttT94c/WAHqsSPgXljlICXDQp9nGpyGUJZQwbAdMgacQlxaSLA==
X-Received: by 2002:a62:5296:: with SMTP id g144mr6951758pfb.29.1584667385608;
        Thu, 19 Mar 2020 18:23:05 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id i2sm2930063pjs.21.2020.03.19.18.23.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Mar 2020 18:23:04 -0700 (PDT)
Subject: Re: openat ignores changes to RLIMIT_NOFILE?
To:     Dmitry Kadashev <dkadashev@gmail.com>, io-uring@vger.kernel.org
References: <CAOKbgA7cgN=+zNVH9Jv1UHXC1qoWAgnPqZPPJuNaLUzzXOwwSg@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <67f104f9-b239-4d68-2f90-01a2d5e30388@kernel.dk>
Date:   Thu, 19 Mar 2020 19:23:02 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <CAOKbgA7cgN=+zNVH9Jv1UHXC1qoWAgnPqZPPJuNaLUzzXOwwSg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/19/20 6:12 AM, Dmitry Kadashev wrote:
> Hi,
> 
> It seems that openat calls issued via io_uring ignore changes to
> RLIMIT_NOFILE. Maybe a wrong limit is checked. A short reproducer is
> attached, it sets RLIMIT_NOFILE to a very low value and the sync
> openat() call fails with "Too many open files", but io_uring one
> succeeds. The resulting FD is completely usable, I've tried writing to
> it successfully.
> 
> To be clear, originally I've encountered another side of this problem:
> we increase the limit in our code, and io_uring's openat started to
> fail after a while under load, while the sync calls executed on a
> thread pool were working as expected. It's just easier to demo with
> small limit.
> 
> Kernel 5.6-rc2, 5.6-rc6.
> 
> Hope it's the right place to report an issue like this.

Can you try the below patch?


diff --git a/fs/file.c b/fs/file.c
index a364e1a9b7e8..c8a4e4c86e55 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -540,9 +540,14 @@ static int alloc_fd(unsigned start, unsigned flags)
 	return __alloc_fd(current->files, start, rlimit(RLIMIT_NOFILE), flags);
 }
 
+int __get_unused_fd_flags(unsigned flags, unsigned long nofile)
+{
+	return __alloc_fd(current->files, 0, nofile, flags);
+}
+
 int get_unused_fd_flags(unsigned flags)
 {
-	return __alloc_fd(current->files, 0, rlimit(RLIMIT_NOFILE), flags);
+	return __get_unused_fd_flags(flags, rlimit(RLIMIT_NOFILE));
 }
 EXPORT_SYMBOL(get_unused_fd_flags);
 
diff --git a/fs/io_uring.c b/fs/io_uring.c
index c06082bb039a..be5705ff33b4 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -398,6 +398,7 @@ struct io_open {
 	struct filename			*filename;
 	struct statx __user		*buffer;
 	struct open_how			how;
+	unsigned long			nofile;
 };
 
 struct io_files_update {
@@ -2578,6 +2579,7 @@ static int io_openat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return ret;
 	}
 
+	req->open.nofile = rlimit(RLIMIT_NOFILE);
 	req->flags |= REQ_F_NEED_CLEANUP;
 	return 0;
 }
@@ -2619,6 +2621,7 @@ static int io_openat2_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return ret;
 	}
 
+	req->open.nofile = rlimit(RLIMIT_NOFILE);
 	req->flags |= REQ_F_NEED_CLEANUP;
 	return 0;
 }
@@ -2637,7 +2640,7 @@ static int io_openat2(struct io_kiocb *req, struct io_kiocb **nxt,
 	if (ret)
 		goto err;
 
-	ret = get_unused_fd_flags(req->open.how.flags);
+	ret = __get_unused_fd_flags(req->open.how.flags, req->open.nofile);
 	if (ret < 0)
 		goto err;
 
diff --git a/include/linux/file.h b/include/linux/file.h
index c6c7b24ea9f7..142d102f285e 100644
--- a/include/linux/file.h
+++ b/include/linux/file.h
@@ -85,6 +85,7 @@ extern int f_dupfd(unsigned int from, struct file *file, unsigned flags);
 extern int replace_fd(unsigned fd, struct file *file, unsigned flags);
 extern void set_close_on_exec(unsigned int fd, int flag);
 extern bool get_close_on_exec(unsigned int fd);
+extern int __get_unused_fd_flags(unsigned flags, unsigned long nofile);
 extern int get_unused_fd_flags(unsigned flags);
 extern void put_unused_fd(unsigned int fd);
 
-- 
Jens Axboe

