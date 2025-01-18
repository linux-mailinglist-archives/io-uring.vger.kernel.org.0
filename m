Return-Path: <io-uring+bounces-5997-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E7A31A15D87
	for <lists+io-uring@lfdr.de>; Sat, 18 Jan 2025 16:02:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 38A633A827E
	for <lists+io-uring@lfdr.de>; Sat, 18 Jan 2025 15:02:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4AB4E172BB9;
	Sat, 18 Jan 2025 15:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="26AaB3l4"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f46.google.com (mail-io1-f46.google.com [209.85.166.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 105E517B421
	for <io-uring@vger.kernel.org>; Sat, 18 Jan 2025 15:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737212562; cv=none; b=Ek8rAy63DJXd7j8Ea2suGyxnLwnj1ZUEQgiplqJ5ASpMHV5sMgtG2wx3uH4PzwOcqcciG+YWo1WxAhRNyNWsjJzT4jeSDmmJ2xfDHGLCqTS0lhQfDUBn+Bi68njTuZ0iCpGw6mk67aAN4I34DEDlUJbyo+zonCsNLhkDrDeVR/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737212562; c=relaxed/simple;
	bh=Ob0eexNFxLX/uszBPzKcXPy9tHfgF2F+/a4DmhBo8No=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=H4yyTNKLb8tV+1Scs32MBgOWWMoqfeMNgqJhKWKbbN+Olayh+X/poiaV+QvKWyynvwtWNYvbOumAlHmgcbMWA8hT0uMo3Qq1LbUZYEL9hChFP2iDKc6fG/4gdQorVeDMtzCWYB97qb4Rgd4Y/UpaP3ahhB7s/wAzbgHnr8adIGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=26AaB3l4; arc=none smtp.client-ip=209.85.166.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f46.google.com with SMTP id ca18e2360f4ac-844d7f81dd1so108186639f.2
        for <io-uring@vger.kernel.org>; Sat, 18 Jan 2025 07:02:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1737212557; x=1737817357; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jCVGHiLOIHwhwiWmLRg6KlEVGdmx+jR4E4pD9bsH/Tg=;
        b=26AaB3l4sYkacZZO5/54SdNLpzBr9aD7zvUZGfXBqJZRJJSXLOI4TSpioQkMWsY5Ad
         muL83DZ2v/TPN1rLpf8gUWHCugww/G0fVmDOP8MuGi0IOlO5QODOIIclpbDvmSdnU6bB
         EXTciJ9XmvFtBgqSB9SsKvkUyi83nb961sCib05o210/Q3rgzlUt+lCwbzBAzFd1k+X8
         5rOAXMvBRW0M0W4Colse6ODb+Huud+QiE8G+GwXEpwuYG2YVDcX6YvixbqDyMjzQW5Hl
         R8mloeiYKXfvG+QS8izOnsULMuTSNyp83cEmwClXlqvlVdCe/MCppxXpm2ljsNM0Uooy
         ZNDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737212557; x=1737817357;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jCVGHiLOIHwhwiWmLRg6KlEVGdmx+jR4E4pD9bsH/Tg=;
        b=rNZmwUfNVHdCaZZTxSvfvGZAKg8PpbeueXS/oq6IiPfcBE2hDvmp1O2Mc4x81tBxkj
         ueAKfB66M1d6cmSWEOXU5yI5gCGLhM7iGk2SVM3MV6f+8mEABZSyRNXQlvpnqkqkL0Q6
         fGLDhZwY/XCoBSoqWC9rCcYjzscV4X6NC/AG1mlzsicuXe8gZiExY7tUufTYNfmxdk0g
         s+bxrHGjd6+xE9TC/WvuELhMTgNTDyAKftJagK0COC6OeE85Qi6OSiQ1rhtL5MN2qjTj
         VDHnamwWJKB40XUs7+lZiiHBginsYG0M8d4yX1+2RFyIO+X8VGwiOX1EL6zHORUgebev
         mduA==
X-Forwarded-Encrypted: i=1; AJvYcCUVUtE8f4uO8s51fIiEVGyjrcw417M274IsH6Cs4laMm4EkM1uylwjER9wqif/i66wqMXejgcNsPg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxhJz1ZEbflp70b32BNwEZn0bKTZmycdeTmfvyPEsaEml3mCZRq
	n0oIER8b26BMjsTMsfD0mefkvm3dCV9HWq6naRxP5TACvVaFPL/fnnFEzpXkO1k=
X-Gm-Gg: ASbGncvkhvsrjb20Th1BPClBeNy2FMNAfVshTdl39nc63wzXXWmMb/2wnGItPAvNFUQ
	fyoBoynpi+13g+1FURdspov+ZH5c32YsgKYZdY07AQPbjb+kNNjx6QhTxB6MTKuuPtoDu3ijOR0
	CXpPc7OphbeXxp46du5fQJMYEjs9MAbFM9i+JoP2K1KYy32yIzf8iQnzqG7rT0kJzVEnxhwsfyl
	XvBVjvvU9QEgt910XxD/AJwg6ORLJD6pJB8m6Z1Bff2SaLkElfXD21KzEPTTnspQsw=
X-Google-Smtp-Source: AGHT+IG/G0F20vBCgcLgBLyQAt7AU7VvDlOWtwu1/dj16Rm+I+2RhznMyoeFB7hsHm/nGzUTg9R8/g==
X-Received: by 2002:a05:6602:2b8a:b0:84c:b404:f21f with SMTP id ca18e2360f4ac-851b65226c5mr501759839f.13.1737212556699;
        Sat, 18 Jan 2025 07:02:36 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-851b01f2c82sm120287739f.20.2025.01.18.07.02.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Jan 2025 07:02:35 -0800 (PST)
Message-ID: <cf13b64b-29fb-47b9-ae2d-1dcedd8cc415@kernel.dk>
Date: Sat, 18 Jan 2025 08:02:34 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC][PATCH] fix io_uring_show_fdinfo() misuse of ->d_iname
To: Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org
Cc: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
 Linus Torvalds <torvalds@linux-foundation.org>
References: <20250118025717.GU1977892@ZenIV>
From: Jens Axboe <axboe@kernel.dk>
Content-Language: en-US
In-Reply-To: <20250118025717.GU1977892@ZenIV>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/17/25 7:57 PM, Al Viro wrote:
> 	The output of io_uring_show_fdinfo() is crazy - for
> each slot of io_uring file_table it produces either
> INDEX: <none>
> or
> INDEX: NAME
> where INDEX runs through all numbers from 0 to ctx->file_table.data.nr-1
> and NAME is usually the last component of pathname of file in slot
> #INDEX.  Usually == if it's no longer than 39 bytes.  If it's longer,
> you get junk.  Oh, and if it contains newlines, you get several lines and
> no way to tell that it has happened, them's the breaks.  If it's happens
> to be /home/luser/<none>, well, what you see is indistinguishable from what
> you'd get if it hadn't been there...
> 
> According to Jens, it's *not* cast in stone, so we should be able to
> change that to something saner.  I see two options:
> 
> 1) replace NAME with actual pathname of the damn file, quoted to reasonable
> extent.
> 
> 2) same, and skip the INDEX: <none> lines.  It's not as if they contained
> any useful information - the size of table is printed right before that,
> so you'd get
> 
> ...
> UserFiles:	16
>     0: foo
>    11: bar
> UserBufs:	....
> 
> instead of
> 
> ...
> UserFiles:	16
>     0: foo
>     1: <none>
>     2: <none>
>     3: <none>
>     4: <none>
>     5: <none>
>     6: <none>
>     7: <none>
>     8: <none>
>     9: <none>
>    10: <none>
>    11:	bar
>    12: <none>
>    13: <none>
>    14: <none>
>    15: <none>
> UserBufs:	....
> 
> IMO the former is more useful for any debugging purposes.
> 
> The patch is trivial either way - (1) is
> ------------------------
> diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
> index b214e5a407b5..1017249ae610 100644
> --- a/io_uring/fdinfo.c
> +++ b/io_uring/fdinfo.c
> @@ -211,10 +211,12 @@ __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *file)
>  
>  		if (ctx->file_table.data.nodes[i])
>  			f = io_slot_file(ctx->file_table.data.nodes[i]);
> +		seq_printf(m, "%5u: ", i);
>  		if (f)
> -			seq_printf(m, "%5u: %s\n", i, file_dentry(f)->d_iname);
> +			seq_file_path(m, f, " \t\n\\<");
>  		else
> -			seq_printf(m, "%5u: <none>\n", i);
> +			seq_puts(m, "<none>");
> +		seq_puts(m, "\n");
>  	}
>  	seq_printf(m, "UserBufs:\t%u\n", ctx->buf_table.nr);
>  	for (i = 0; has_lock && i < ctx->buf_table.nr; i++) {
> ------------------------
> and (2) -
> ------------------------
> diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
> index b214e5a407b5..f60d0a9d505e 100644
> --- a/io_uring/fdinfo.c
> +++ b/io_uring/fdinfo.c
> @@ -211,10 +211,11 @@ __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *file)
>  
>  		if (ctx->file_table.data.nodes[i])
>  			f = io_slot_file(ctx->file_table.data.nodes[i]);
> -		if (f)
> -			seq_printf(m, "%5u: %s\n", i, file_dentry(f)->d_iname);
> -		else
> -			seq_printf(m, "%5u: <none>\n", i);
> +		if (f) {
> +			seq_printf(m, "%5u: ", i);
> +			seq_file_path(m, f, " \t\n\\");
> +			seq_puts(m, "\n");
> +		}
>  	}
>  	seq_printf(m, "UserBufs:\t%u\n", ctx->buf_table.nr);
>  	for (i = 0; has_lock && i < ctx->buf_table.nr; i++) {
> ------------------------
> 
> Preferences?  The difference in seq_printf() argument is due to the need
> to quote < in filenames if we need to distinguish them from <none>;
> whitespace and \ needs to be quoted in either case.

I like #2, there's no reason to dump the empty nodes. Thanks Al!

-- 
Jens Axboe

