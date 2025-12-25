Return-Path: <io-uring+bounces-11310-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 7431BCDDE15
	for <lists+io-uring@lfdr.de>; Thu, 25 Dec 2025 16:18:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E33A43011FB2
	for <lists+io-uring@lfdr.de>; Thu, 25 Dec 2025 15:18:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B4C032ABFA;
	Thu, 25 Dec 2025 15:18:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cgCAOeS8"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0B70502BE
	for <io-uring@vger.kernel.org>; Thu, 25 Dec 2025 15:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766675899; cv=none; b=gH5sG8LgFt1EXuruwDVzovo24myUMR6LonO3Sth/++l/yH5lruFUUTLT5dgW5wM1+qVhfXnfrxb3RFsGYwOB8Shw19Je/E7EDUGVjX1f1WJlp+J4kQxjlIAfIF/UUpDhjRYH2zAAchuzHExL6MP/jhOOoDt4GVzmiurV9oofPWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766675899; c=relaxed/simple;
	bh=MbMBUpR7B2x4JyBu84ec/Nl4m/QIwV9QVVSShfb9dMk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r5N7RuAwlI+EcolK6rYDXAr0akPXI8zjy1PMHnkjbdDgBSp5wqreAIay1YAXh9xsvpuuV3BGx6P8rZuZMsU2/9haO+SQqe87kRBUECM4Eg5P5mei7wVBszeIE57JoLJdM4bP5muoVBL/m8eNC1o+iRjAX95HNAk+g77lSh7XaLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cgCAOeS8; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-34e90f7b49cso5030001a91.3
        for <io-uring@vger.kernel.org>; Thu, 25 Dec 2025 07:18:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766675897; x=1767280697; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Qs6BJX7+RWUbYyZjj+cOPleo4iCRlFe1YsbACYZyhFI=;
        b=cgCAOeS8Yvk+9LCKE/fHmRulgnlQzJIUyW0juEgc3OseKtBjGdBOSNyCXbkOC7COCt
         Is33sTVt5+DDeP3u4VMRsm2qWaBgQAjIIusab5yL91HohBt4r9wTkAw4XJMQwRktM9jw
         ukEeNSY/DqEsP50+iVRoWfWSb+1WfqlM+ogrLAar6LTqMICAjYXqsVxnNpN6EL/ljSTE
         F0pm3q7kY6+xDulaoaeEx3rrJRtFh18F3eJfqTsLGVfmhfRRep8gp5ueYU5XUHCIpvp3
         JIRn0z5/dCf3wMGoUaQlFbFsROQJNlhPpK6uILb+9ZWyevuqJSEpDVk8JU1wKmXhi06l
         xO1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766675897; x=1767280697;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Qs6BJX7+RWUbYyZjj+cOPleo4iCRlFe1YsbACYZyhFI=;
        b=v0Z/74qpiBLXd16XrCH7HUuv3DEg4EaaS7BaVZMYw/lb5silpiUk1qqecEUfrba8wP
         7rPzLiMT+LPVthT4vWOVvg9gQOiHwuIs5DI4weC8rG6U3wD/1Q2rYPevPTplk3M+A6Qf
         Ann0XJeMyExNI1eBGmDBomxE9LFS+9MzFjFI8iwi6Zp3IUK6Ye1HV0e9L1jgu/Um6BpW
         qvGZ7t7TZg+ePZYNjr3uW6lEPGu1jc5asFmUN2j8wWMpbvvtS7g1L+8x0BMuJeTGFZ0S
         S4RYA0FtNpqp6dzLdeasptJm3HirtPjt9WzDqONTZ2y0a8Y2k3CDyHUnxF33dQqalZeg
         02IQ==
X-Gm-Message-State: AOJu0YwBE4tTy/4o7xSCZyqF78Br2C70gPNwNf+hW8eoV1eizPCcegc+
	64CETSNsb0V1OzUtK9aHXQ4ofYRqhJ+7nRkc6Tn9fIRIczePDqFwXnrd
X-Gm-Gg: AY/fxX46N7ObCzgxtIYP2JWd/B/m9bw5+B5tqlVSyJ2xS3O2zhld+p3mEyIX9cuCKn/
	nXSaTt1/cVBdTV5EkCYdHVCX4Kdm5pq6FgmtiAGdl4DmSUNMKwGi5RAJEWPCaPwf3QOF3OxpJnZ
	f8yMBAcAecjaC/VTJH5BQN6HDx4D5upLstRv3mH/X96t+DohPEV8DCs1HHk/XSuxPodE9VoEUjY
	xwJaJe6wVk6e71RUZ1wb6ZMR9CKf0tO7TeE8mVTso9EBFUFOCBvX2rteb4dSlcuY3cwzMRG9sAN
	Jbr+ZSXzDXHmRH+kNBAwLg5yErJ4lfDrPQmqXVmk+XiDraWTqiJ7gkdvaZ0efrJGhcNTgr0EBHN
	uWZpJY2EKsLeLwggYR9OhqrZQarssM9XPi7/J6TZ9XzYZikCpX/huY19IZP/N/6zloww6NGxsvZ
	dnvjy2PNY7Qyw=
X-Google-Smtp-Source: AGHT+IFyYhem34TIt5JkWzwnSB53xq94ui6A4MQrPDy5SuIyfwhYp7CBOvr+9/vlj+sQXcZsrKKlUw==
X-Received: by 2002:a17:90a:c888:b0:340:be44:dd0b with SMTP id 98e67ed59e1d1-34e921f582amr15972331a91.34.1766675896814;
        Thu, 25 Dec 2025 07:18:16 -0800 (PST)
Received: from inspiron ([111.125.235.126])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34e772ac06fsm9337558a91.11.2025.12.25.07.18.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Dec 2025 07:18:16 -0800 (PST)
Date: Thu, 25 Dec 2025 20:48:08 +0530
From: Prithvi <activprithvi@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, brauner@kernel.org, jack@suse.cz,
	viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kernel-mentees@lists.linux.dev,
	skhan@linuxfoundation.org, david.hunter.linux@gmail.com,
	khalid@kernel.org,
	syzbot+00e61c43eb5e4740438f@syzkaller.appspotmail.com,
	stable@vger.kernel.org
Subject: Re: [PATCH v2] io_uring: fix filename leak in __io_openat_prep()
Message-ID: <20251225151808.lvpfdwqvcej4vxgm@inspiron>
References: <20251225072829.44646-1-activprithvi@gmail.com>
 <176667533028.68806.11770987520631890583.b4-ty@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <176667533028.68806.11770987520631890583.b4-ty@kernel.dk>

On Thu, Dec 25, 2025 at 08:08:50AM -0700, Jens Axboe wrote:
> 
> On Thu, 25 Dec 2025 12:58:29 +0530, Prithvi Tambewagh wrote:
> >  __io_openat_prep() allocates a struct filename using getname(). However,
> > for the condition of the file being installed in the fixed file table as
> > well as having O_CLOEXEC flag set, the function returns early. At that
> > point, the request doesn't have REQ_F_NEED_CLEANUP flag set. Due to this,
> > the memory for the newly allocated struct filename is not cleaned up,
> > causing a memory leak.
> > 
> > [...]
> 
> Applied, thanks!
> 
> [1/1] io_uring: fix filename leak in __io_openat_prep()
>       commit: b14fad555302a2104948feaff70503b64c80ac01
> 
> Best regards,
> -- 
> Jens Axboe
> 
> 
> 

Thank you!

Best Regards,
Prithvi

