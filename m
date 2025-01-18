Return-Path: <io-uring+bounces-5999-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E1EB5A15F09
	for <lists+io-uring@lfdr.de>; Sat, 18 Jan 2025 23:33:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9CA323A7109
	for <lists+io-uring@lfdr.de>; Sat, 18 Jan 2025 22:33:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F75C13C809;
	Sat, 18 Jan 2025 22:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zohomail.com header.i=safinaskar@zohomail.com header.b="K/sGpowM"
X-Original-To: io-uring@vger.kernel.org
Received: from sender4-pp-o95.zoho.com (sender4-pp-o95.zoho.com [136.143.188.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F64A42070
	for <io-uring@vger.kernel.org>; Sat, 18 Jan 2025 22:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.95
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737239606; cv=pass; b=NEkfZsOOAVh6/kRxbmV4X6XqLDeEIJW51YHdhsCJ7AXuNZryTl86kZ84lVErp1XqJlJRTzl3A5rerBjNGNCJtoYcDv0d8I2y4PPeKrUMO8zISjxrYw3P/tCYfozc6sm8P7NobJud5iFfCvajAourIlIz/FjprjfIjThjWrsHq8g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737239606; c=relaxed/simple;
	bh=GZ2lWLEWbmG/bYGNE+wmM/SP7sK1yqGP1RiHmkkF0ds=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TGSkQDicRgBzbArlb3FiSFGMui9T/ZvyH9Rg2Z9MUkoLUaieaHtK5SarAs+HlZmxVsgKle95FM6SBEkt2dtlJzM+eiOdRduH/8SnRC2c+eFesKckIVHMdPewSjYj9kF6J6ogqYCHYAgXUVZde8uV4oOe07AEUjulLOGoAcKA83k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=zohomail.com; spf=pass smtp.mailfrom=zohomail.com; dkim=pass (1024-bit key) header.d=zohomail.com header.i=safinaskar@zohomail.com header.b=K/sGpowM; arc=pass smtp.client-ip=136.143.188.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=zohomail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zohomail.com
ARC-Seal: i=1; a=rsa-sha256; t=1737239596; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=D1GiLYqzZukCVamXj0tkEnViO/t11jYpmclywcEQMi4eykHCKi+gT7b43bBbL6gkEdb+fOsudycRX3rTGI8JN4AqxFdnc5CDqJyj/ZIosH2W+wIFfvhOWaVrbBBypCTc3ifG71iPmh8onH/5e0/Y7/7MIIGobIUKBnwIqLNv50U=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1737239596; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=GZ2lWLEWbmG/bYGNE+wmM/SP7sK1yqGP1RiHmkkF0ds=; 
	b=XcG4FAFnp7eBelTOTJqPM4ejI7PRLIQGl+0Kl38wnOmaAHFHhZDYThWn41Xnto969udL0nz32P53zmpPfrB+eP+d90uPtzB1ovb+2ew2iLPyEjMP9YtvUMra28SioqT50wVvEZwigHIOGa1b/KFAnbrjTR+SSkGUi1TKx8fQcao=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=zohomail.com;
	spf=pass  smtp.mailfrom=safinaskar@zohomail.com;
	dmarc=pass header.from=<safinaskar@zohomail.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1737239596;
	s=zm2022; d=zohomail.com; i=safinaskar@zohomail.com;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-Id:Message-Id:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Feedback-ID:Reply-To;
	bh=GZ2lWLEWbmG/bYGNE+wmM/SP7sK1yqGP1RiHmkkF0ds=;
	b=K/sGpowMAmRNeD0XsWKZS4WEhnJHv75Xy8OcxX+Li+d3D8ZDs//53FQ1irRfZ6oW
	BmkxqGCN7YUvr1hto8qWEu/pl07EkSxXBBRkeCfh+F3WLR/zGOe7xy7dLBHTowFlz6T
	VKZmPjX4jNrXXk7lw7bTHo/b69NoMQ636bqcZiYs=
Received: by mx.zohomail.com with SMTPS id 1737239593943940.6386770017513;
	Sat, 18 Jan 2025 14:33:13 -0800 (PST)
From: Askar Safin <safinaskar@zohomail.com>
To: asml.silence@gmail.com
Cc: axboe@kernel.dk,
	io-uring@vger.kernel.org,
	josh@joshtriplett.org,
	krisman@suse.de
Subject: Re: [PATCH RFC 0/9] Launching processes with io_uring
Date: Sun, 19 Jan 2025 01:33:09 +0300
Message-Id: <20250118223309.3930747-1-safinaskar@zohomail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <fd219866-b0d3-418b-aee2-f9d1815bfde0@gmail.com>
References: <fd219866-b0d3-418b-aee2-f9d1815bfde0@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Feedback-ID: rr080112272080e8040e671c1ccc03338400006211a7aeab87250ecbdcdb1a1e1e8f6e7a58a0595b3887bc40:zu08011227b8f37a3764344ea5e784068300005ace390e7aa859372561b38a36e3630f685546056aadaea20b:rf0801122bd383bde47f8df752e585e8da00005263a13939d70516c7043215a10ae5396d3ce7cb647ae91f570e466dff:ZohoMail
X-ZohoMailClient: External

Pavel Begunkov:
> At this point it raises a question why it even needs io_uring
> infra? I don't think it's really helping you. E.g. why not do it
> as a list of operation in a custom format instead of links? That
> can be run by a single io_uring request or can even be a normal
> syscall.

> Makes me wonder about a different ways of handling. E.g. why should
> it be run in the created task context (apart from final exec)? Can
> requests be run as normal by the original task, each will take the
> half created and not yet launched task as a parameter (in some form),
> modify it, and the final exec would launch it?

I totally agree. I think API should look like this:

===
// This may be PID fd or something completely different
int fd = create_task ();

task_manipulate (fd, OP_CHDIR, "/");
task_manipulate (fd, OP_CLOSE, 0);
task_manipulate (fd, OP_OPEN, "/dev/null", O_RDONLY, 0666);

task_execve (fd, "/bin/true", argv, envp);
===

We will have ability to do proper error handling.

Paper "A fork() in the road" says the same thing.
( https://www.microsoft.com/en-us/research/uploads/prod/2019/04/fork-hotos19.pdf ).

From that paper:

> While a spawnlike API is preferred for most instances of starting a new
> program, for full generality it requires a flag, parameter, or
> helper function controlling every possible aspect of process
> state. It is infeasible for a single OS API to give complete
> control over the initial state of a new process. In Unix today,
> the only fallback for advanced use-cases remains code executed
> after fork, but clean-slate designs [e.g., 40, 43] have
> demonstrated an alternative model where system calls that
> modify per-process state are not constrained to merely the
> current process, but rather can manipulate any process to
> which the caller has access. This yields the flexibility and
> orthogonality of the fork/exec model, without most of its
> drawbacks: a new process starts as an empty address space,
> and an advanced user may manipulate it in a piecemeal fashion,
> populating its address-space and kernel context prior to
> execution, without needing to clone the parent nor run code
> in the context of the child. ExOS [43] implemented fork in
> user-mode atop such a primitive. Retrofitting cross-process
> APIs into Unix seems at first glance challenging, but may
> also be productive for future research

So, yes, such APIs already exist in research operating systems.

Moreover, as well as I understand, Windows NT native API also
creates processes the same way.

Askar Safin

