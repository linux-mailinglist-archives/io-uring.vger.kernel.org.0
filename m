Return-Path: <io-uring+bounces-429-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 66EEB832DA4
	for <lists+io-uring@lfdr.de>; Fri, 19 Jan 2024 18:02:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1C43D1F21456
	for <lists+io-uring@lfdr.de>; Fri, 19 Jan 2024 17:02:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52DB155789;
	Fri, 19 Jan 2024 17:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="HBf7eP3t"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7535555E43
	for <io-uring@vger.kernel.org>; Fri, 19 Jan 2024 17:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705683764; cv=none; b=itOUjyRNnmuRXP9wjEtGpzHY5APoeb1mHa6bqEoVxAT88gL3JBYv9vCHZ+8hbQxAC7mxeuaAiBfypqQc6oj3SMFrM2ZjiOSC3J8okpIaxuP7877zHJzQCdZM1J93Dgm/+M/oV4qxFkfhy/a2EHJ+r1P7zUnEWQYoP3QOHdzl+RE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705683764; c=relaxed/simple;
	bh=xLfDybBGvZ/wKBeKI8cl4xLG/gOrXK1GSUNdwAwpcdo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dZVofznQUiX2y8NT1TYuVeSAxSEJh/VYjXyQisYfERcuklCkU3pGvvuL5luerfs4nY3tXiosrG5ArbwCesckGms1bLdEJuvzvyZevcxHEHj1aTr2FyOXE4lGqjMb2xxRl+vRKNRHWsbfjyRz8mSFN+VEAlQMVYxQGuqsXfZu5lc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=HBf7eP3t; arc=none smtp.client-ip=209.85.166.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-7beeeb1ba87so14353939f.0
        for <io-uring@vger.kernel.org>; Fri, 19 Jan 2024 09:02:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1705683761; x=1706288561; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6JljGSATeaOcD28K+1GSGlGsLNzROnsVmQtzeHNlm9U=;
        b=HBf7eP3tefHvLBr5woCHbL71DHi39jtF8mDUYULMtNmV2+QqFNYfPGjhRomxoQ6l14
         Cku6Cv6Oj/TkRfhqSFJip0gCKTyTXoAnkvA3ghzaPajwNfZLxh/je3jSQ5wBP47jnYr3
         SK/tnsA2ytA+roE/oS8qAxAH5SIa5hf8rJn841vN0cQjSRWgi0hFqZsDxb75fP3JlbED
         cOUSEvkvdOgFbQB1++s7jXkdZDF7pBUtFSo0pWY3rcjcBkXD7y36rAue9CfnWvosotsr
         PFjHzWjvp0cld1J1HlJYcn5kmonMlfoMcgrryG7PkoaMPsP1sT6+MLZ31o/ns67/u2oP
         VUlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705683761; x=1706288561;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6JljGSATeaOcD28K+1GSGlGsLNzROnsVmQtzeHNlm9U=;
        b=r6pyf0vRdBBGTaNokP5t6rpRTwBn+aWbl0XKtcdpNFngVKFS4bRiNSyjW79/oTcdpZ
         wvviDPEe92oMmByUKX3BAP0BsH891OE1YssUKTxnuP6PMPUGygVDJzDr4RvMIvOT5DhT
         icF/4763Cn9hDgJIIVto1ZctkD6xSCNjqKMtwxkaQ/tIQfBynr56rkY1XJPYO04r6l/P
         JSeslqqova8wNJza8lE+qxTe9URRdhDYQesPIbV+11NqyueJMHtPEe0lhs+jqxU5pafd
         Ko9uog2jkeH9k1ucOYX8SFAwaeYPRnKq19eWaMuW5FvchY/EBjspS5CkVMgUBON64oqO
         91cQ==
X-Gm-Message-State: AOJu0YzXMwjelXT1PmqJ9G00zhWjc1itkG8vrYnbFcpAZ4n9aWPzD+0M
	4XN+sDINns+GlDA70o3lufoTd0+4ZiDMyAEk44lxXuV7Qc+pvh0IWiZnmdWHkjk=
X-Google-Smtp-Source: AGHT+IFVAOe/BGbKx5XVUd67ixTXJBKfruf5+PxHWnW6KXZoTLrM0yv9iEVEMzoy9f1Gb8jxEj8nBw==
X-Received: by 2002:a5d:8e0b:0:b0:7bf:4758:2a12 with SMTP id e11-20020a5d8e0b000000b007bf47582a12mr20437iod.0.1705683761551;
        Fri, 19 Jan 2024 09:02:41 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id h16-20020a056602155000b007bc45c52f55sm4494164iow.13.2024.01.19.09.02.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Jan 2024 09:02:41 -0800 (PST)
Message-ID: <80b76dac-6406-48c5-aa31-87a2595a023f@kernel.dk>
Date: Fri, 19 Jan 2024 10:02:40 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: IORING_OP_FIXED_FD_INSTALL and audit/LSM interactions
Content-Language: en-US
To: Paul Moore <paul@paul-moore.com>, Christian Brauner <brauner@kernel.org>
Cc: io-uring@vger.kernel.org, linux-security-module@vger.kernel.org,
 audit@vger.kernel.org, selinux@vger.kernel.org
References: <CAHC9VhRBkW4bH0K_-PeQ5HA=5yMHSimFboiQgG9iDcwYVZcSFQ@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAHC9VhRBkW4bH0K_-PeQ5HA=5yMHSimFboiQgG9iDcwYVZcSFQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/19/24 9:33 AM, Paul Moore wrote:
> Hello all,
> 
> I just noticed the recent addition of IORING_OP_FIXED_FD_INSTALL and I
> see that it is currently written to skip the io_uring auditing.
> Assuming I'm understanding the patch correctly, and I'll admit that
> I've only looked at it for a short time today, my gut feeling is that
> we want to audit the FIXED_FD_INSTALL opcode as it could make a
> previously io_uring-only fd generally accessible to userspace.

We can certainly remove the audit skip, it was mostly done as we're
calling into the security parts anyway later on. But it's not like doing
the extra audit here would cause any concerns on the io_uring front.

> I'm also trying to determine how worried we should be about
> io_install_fixed_fd() potentially happening with the current task's
> credentials overridden by the io_uring's personality.  Given that this
> io_uring operation inserts a fd into the current process, I believe
> that we should be checking to see if the current task's credentials,
> and not the io_uring's credentials/personality, are allowed to receive
> the fd in receive_fd()/security_file_receive().  I don't see an
> obvious way to filter/block credential overrides on a per-opcode
> basis, but if we don't want to add a mask for io_kiocb::flags in
> io_issue_defs (or something similar), perhaps we can forcibly mask out
> REQ_F_CREDS in io_install_fixed_fd_prep()?  I'm very interested to
> hear what others think about this.
> 
> Of course if I'm reading the commit or misunderstanding the
> IORING_OP_FIXED_FD_INSTALL operation, corrections are welcome :)

I think if there are concerns for that, the easiest solution would be to
just fail IORING_OP_FIXED_INSTALL if REQ_F_CREDS is set. I don't really
see a good way to have the security side know about the old creds, as
the task itself is running with the assigned creds.

-- 
Jens Axboe


