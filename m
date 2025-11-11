Return-Path: <io-uring+bounces-10518-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F74DC4E952
	for <lists+io-uring@lfdr.de>; Tue, 11 Nov 2025 15:50:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 515B84FB3B7
	for <lists+io-uring@lfdr.de>; Tue, 11 Nov 2025 14:44:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA7FA303CAE;
	Tue, 11 Nov 2025 14:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="hjxI1RFj"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D0A02F7AA4
	for <io-uring@vger.kernel.org>; Tue, 11 Nov 2025 14:41:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762872090; cv=none; b=nW/y/ayxX4sxjAKrr1sYqeOiGFF4PeaQ44PAlA2shzXg9k8UbT1+mukhCvW8+vj5TDLcdAM79xRzZucGw07aqXwcfyMdhKS21KEbleAwFeol4/e2ZKUrnQU01ia1xo7Mf5io/GQO5MWXYv8DnfaGJfbAD0S1CyufE+uZ91MG9OI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762872090; c=relaxed/simple;
	bh=KSxZLglOxeS+T2/tlk7iOWOgFgF+QB8I9cVugzlebVI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qPkgBbSHhIvwyzWRMzbMpSYiQJTFBBgE9YQOYqZYFm6NyO5XzY31rD3DsgY/1h0ddX51xhBT+ntd4UoIkcsGarZbPrIMa8ebMf4gl242kI6kL6vIaWdle/tiqQyHziarAfiAQbWEbqSAohswiCjPERaHbriJL6I9kWgqcIbJml4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=hjxI1RFj; arc=none smtp.client-ip=209.85.166.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f43.google.com with SMTP id ca18e2360f4ac-948614ceac0so230938639f.0
        for <io-uring@vger.kernel.org>; Tue, 11 Nov 2025 06:41:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1762872086; x=1763476886; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LHq/vGiBYX19IyAjvpsj0s82ScpRukDdLxz2HyIHoFY=;
        b=hjxI1RFjk2o0gLtNesbkZPWIteNI1zXP3oSxD3r1To+j8a0ykk4vwKn5XUQS50xfYq
         zjJprVUNDuCLbQ6fRKHE0SP3yBYXMvUoi0Pe2l/69KLMHTh6xra5w+h/gTjYXl5tj2th
         TL8l4GAsroQ46W1vS4gNVr2preXtRpg+a5KrUx85y26VjYh+NypoZAXyLJ0XbnxlZYbj
         0nps8bbn2XkR6/1ZjHL8bomE2lOm+dHJqPj70VZfupWhrmUj31+2nil9/h7JFBo5zwSS
         cSuBhzlTqslcHBA5A45yaqlpzZC+DCiynQM304FE7XX3s6mcuPteShTUna7vp6YtIiQY
         QPrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762872086; x=1763476886;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LHq/vGiBYX19IyAjvpsj0s82ScpRukDdLxz2HyIHoFY=;
        b=jK4sSGBvoo2WOhSxVLsE8HhZrQTM+bTwj5oe4O9SY1E5CKd/dYKaHtguyUh60IWi+2
         nykQ2JS4ZPkre3BcwQn9sHMB775OjRMDbV4Zf3Cj1A+4O9UNRARmNdkqYYnFfmx5POcS
         P9BtK8Ee6j5dHBiFYdYQWQNlpTFLyYanBfQgkkR/FNpCq6gdRCqDYgtTyK3gM5nO5/gr
         puSpxXevAlvy78kr20NZxWknD9xZXfNnkZufJEAeq+6vOjHnQNRn+d/rtmRYAlHEpB8B
         46uu40E1DVqBW9PpgD6os7FfCR+K47b8bhOmuzCwUAISHWzq7ZyEHQC6gKsh9MM17qY8
         kLiQ==
X-Forwarded-Encrypted: i=1; AJvYcCVHCn0YtpqUxZ5Bb4pw2R+tdN4d+x5tFDVGdrpIG6VtiWvW2fEbYOffjk7UTshmg0ZIBQ+Wk/+Dcw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwfjxMKlLyJ24ZOvZJQvfEuWUUB3tw5oh5vX7TBJ71O7ffnbq4s
	SgJoXyqppSogs12JtvauNjvMfXAy+wFFEUq3ygKry9cI5fa+cZtoFCWuOt0b9V2lxMQ=
X-Gm-Gg: ASbGncuWL+VKuCNXZQoiU3BJKpFDkeyHUU/hvnrGE+0/6EwI2la8yTAGz2FBdjXX3gt
	4uHajM1Fz1BwzgmeY7IziZwx4s+d1t1cvcjhREhlG6NMHupt6ziOJlfmvYgf7N3a9NMd4NaFiXe
	iVtCvI35VOcjS1H+HS3uI+v0lLRoq4mYUosfcTyBsnSFhxEmIFChmCqlfJym6wwrJBnSLNfiq1O
	yhW0G40qkjk5AKyImrONhu+H3o4khRpJbwoZtfVIJ7HiKSdXb16u/21tQEecqWbmGIuUR/lwF1V
	YilTRuvLg+SZzIhxM8DHsjtkhmXrjowqd5sqg64kzNqFD+X0aATXWEQLwroZoIi0RkndZ6uliNa
	zUOStZiIi+1BnQLugerjBiziZXzbT9VyX46UAgfk+dKzDTnZ7DSEUhQ7JsgL8qjYqJWfCkxUrhg
	==
X-Google-Smtp-Source: AGHT+IF9qtXDJkW7aPNIhYGjEhbbO2h9PE5MLJY4LFYe3Ab10AJRovJe55m7m89B0ZJ6/+08nI7FPg==
X-Received: by 2002:a05:6602:6087:b0:887:638a:29b5 with SMTP id ca18e2360f4ac-9489602c03cmr1526890739f.9.1762872086130;
        Tue, 11 Nov 2025 06:41:26 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5b746806d41sm6259258173.20.2025.11.11.06.41.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Nov 2025 06:41:25 -0800 (PST)
Message-ID: <257804ed-438e-4085-a8c2-ac107fe4c73d@kernel.dk>
Date: Tue, 11 Nov 2025 07:41:24 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC][PATCH 11/13] allow incomplete imports of filenames
To: Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org
Cc: torvalds@linux-foundation.org, brauner@kernel.org, jack@suse.cz,
 mjguzik@gmail.com, paul@paul-moore.com, audit@vger.kernel.org,
 io-uring@vger.kernel.org
References: <20251109063745.2089578-1-viro@zeniv.linux.org.uk>
 <20251109063745.2089578-12-viro@zeniv.linux.org.uk>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20251109063745.2089578-12-viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/8/25 11:37 PM, Al Viro wrote:
> There are two filename-related problems in io_uring and its
> interplay with audit.
> 
> Filenames are imported when request is submitted and used when
> it is processed.  Unfortunately, the latter may very well
> happen in a different thread.  In that case the reference to
> filename is put into the wrong audit_context - that of submitting
> thread, not the processing one.  Audit logics is called by
> the latter, and it really wants to be able to find the names
> in audit_context current (== processing) thread.
> 
> Another related problem is the headache with refcounts -
> normally all references to given struct filename are visible
> only to one thread (the one that uses that struct filename).
> io_uring violates that - an extra reference is stashed in
> audit_context of submitter.  It gets dropped when submitter
> returns to userland, which can happen simultaneously with
> processing thread deciding to drop the reference it got.
> 
> We paper over that by making refcount atomic, but that means
> pointless headache for everyone.
> 
> Solution: the notion of partially imported filenames.  Namely,
> already copied from userland, but *not* exposed to audit yet.
> 
> io_uring can create that in submitter thread, and complete the
> import (obtaining the usual reference to struct filename) in
> processing thread.
> 
> Object: struct delayed_filename.
> 
> Primitives for working with it:
> 
> delayed_getname(&delayed_filename, user_string) - copies the name
> from userland, returning 0 and stashing the address of (still incomplete)
> struct filename in delayed_filename on success and returning -E... on
> error.
> 
> delayed_getname_uflags(&delayed_filename, user_string, atflags) - similar,
> in the same relation to delayed_getname() as getname_uflags() is to getname()
> 
> complete_getname(&delayed_getname) - completes the import of filename stashed
> in delayed_getname and returns struct filename to caller, emptying delayed_getname.

dismiss_delayed_filename()

> diff --git a/io_uring/openclose.c b/io_uring/openclose.c
> index bfeb91b31bba..6bc14f626923 100644
> --- a/io_uring/openclose.c
> +++ b/io_uring/openclose.c
> @@ -121,6 +118,7 @@ int io_openat2(struct io_kiocb *req, unsigned int issue_flags)
>  	struct file *file;
>  	bool resolve_nonblock, nonblock_set;
>  	bool fixed = !!open->file_slot;
> +	struct filename *name __free(putname) = complete_getname(&open->filename);
>  	int ret;
>  
>  	ret = build_open_flags(&open->how, &op);

I don't think this will work as-is - the prep has been done on the
request, but we could be retrying io_openat2(). That will happen if this
function returns -EAGAIN. That will then end up with a cleared out
filename for the second (blocking) invocation.

-- 
Jens Axboe

