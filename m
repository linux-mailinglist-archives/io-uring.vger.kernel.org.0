Return-Path: <io-uring+bounces-6000-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5874DA1600C
	for <lists+io-uring@lfdr.de>; Sun, 19 Jan 2025 04:03:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DACBD1654AE
	for <lists+io-uring@lfdr.de>; Sun, 19 Jan 2025 03:03:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81D9629CE7;
	Sun, 19 Jan 2025 03:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gQO/tjRr"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C03AD2905
	for <io-uring@vger.kernel.org>; Sun, 19 Jan 2025 03:03:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737255832; cv=none; b=c1Ys0wcgMfrJu6HcuSe2NzdMAP9/WAeDfdEYDE5vO9yum8s7mlRb+rCZqsC2jkIpu+PK9aIXx8XykiB9v1XiEnuzMnTfhAj313fGNE06JtemxxhsSNgTJDpJIaVdGr6pkFkRMJnk6zAMvXG/VNLiRjjtgzLFCYqGTf3R6/zS4Ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737255832; c=relaxed/simple;
	bh=aNAgBmQvkiT1bM21lsS6OomE0PXkpnnH/Hgic5Iwan0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mFQIcrvJJwJNTYiZ/AEbjzHIRYb0702AfIdUYfd+xKjLuCOVVWrK1Yx164jljo29W8R5iBD/OMpzR+8A/xmkxu5nmS97OgP5F+YDQjQ9dc5yf+M2hTYyAJcRXImJ61l3FWATTyJ/GjSjMDq2RXHGcRUZ3jYuuEzE0hKvoFSVbtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gQO/tjRr; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-43618283d48so22873445e9.1
        for <io-uring@vger.kernel.org>; Sat, 18 Jan 2025 19:03:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737255829; x=1737860629; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8SdP6NLOZn6nl/ADnRQB+o+Dfiiaia3p9u9ejKATsBc=;
        b=gQO/tjRrpyvVcJFuWdbS0INEe9cjL3z63HlpWU7lRJIAytPtMWvy5/ua2+6WkhCBHK
         CHq1k313DrDMgAjTzOwzyLurPYjNPlmWVfXPiRc/JWUoW+FS8hYQWxNykC91i51SA+/v
         filjXg+brOPEgrV6RDfEKtaqB4IjOu6z+fr4GUr6WfMnJK9k+z1JknE6z+QiXchdwMAz
         iUusuPEDDaMn4DYckG3LIv4sZSYFK8s3CBOv7Ph0HRWoz25a577BOJWiEzpB7qH/ldMe
         sZo+/qhADOVAIm1H/htiaL/138/2qOPzrSl/sH+EOZb+r5lfgjsSzq4KqDN3AuknBJoa
         Hu7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737255829; x=1737860629;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8SdP6NLOZn6nl/ADnRQB+o+Dfiiaia3p9u9ejKATsBc=;
        b=dHraDcH4J4mpcNlyawf38XAMzjcNeMVJzKHVpUHts6++5O2CkVdgBZk7ZPGt2+Ew7I
         KphJUbvosQQK5vPgJ6aebPzyyr73+mcUC76ZaylgjS5ftGNsVUpwsnPWws0KqRdQdYn6
         eet9/hdMM6zdVJU+X0zG2BJwfNfvOiVbx/Dc3IM9EawOL0L01OclUKM6qH/XPJu+Lhtd
         UPqwtAeD5rbQBB8KTfC6L9u0iyzvWCn8p0G0pyaQnCXhgkvSyZ5YFXWVhSMlAVvsb6FE
         cIB95Z4m9N4R1CUW52o/nLrMOJ8JJGrQTY7+7dbbcur6E1BocJcqO0cIJXbUflrOpGnc
         b3dw==
X-Forwarded-Encrypted: i=1; AJvYcCXGn1qXkRzma3xgqJjOXxnhavu9tPIQYmWzqLj3oFRPCAjjDWQEGtGWisHN/yHwn4MFd46sfv3izQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy7S1mn1Ya0WIxj+TKr1pvWzVvsEIwC1DiTVE1SLQTE8oSH06QN
	gB3YN1sJ6hPFkRL+zZtWEokCuXL9GM7kwOlafel9+bDn4sGyxRiF
X-Gm-Gg: ASbGncur/LbbrvvazKPVxWaMczsrz3uEgLQ8DA81qelg+F818MXLa5PvW7/8aCddDIJ
	M85qKQisupNRpvwknVY+w/q+4XaH5GjxhzlkAPFbE/HbxpoR4u046m2Hr+NyMoUUgYN1kjA62gP
	8SYJPCoF5IrNe8Qp9GtwTMRzS3MeO6w0hYayhm3LaFCxyzSWkBqQwymptAVWoOI9RsIEHjq+qks
	7WdWLlpZLz7l1/HmJQy8Se3tqMyD/5W9iukLV2S8W5/Z5QeTyhX4EzX/8iTwz6Qh6axc2SKqntO
	Nw==
X-Google-Smtp-Source: AGHT+IG42aJj4MrKRvg0CWlLuj8wjkpjk/26kssFv19NLb/V0SNSYfEgfpQS1m4zvMXvfg1kcoRotw==
X-Received: by 2002:adf:ab0f:0:b0:38b:d7c3:3768 with SMTP id ffacd0b85a97d-38bf5663661mr4462883f8f.12.1737255828829;
        Sat, 18 Jan 2025 19:03:48 -0800 (PST)
Received: from [192.168.8.100] ([85.255.237.67])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38bf3275501sm6691761f8f.65.2025.01.18.19.03.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Jan 2025 19:03:48 -0800 (PST)
Message-ID: <9ee30fc7-0329-4a69-b686-3131ce323c97@gmail.com>
Date: Sun, 19 Jan 2025 03:04:30 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 0/9] Launching processes with io_uring
To: Askar Safin <safinaskar@zohomail.com>
Cc: axboe@kernel.dk, io-uring@vger.kernel.org, josh@joshtriplett.org,
 krisman@suse.de
References: <fd219866-b0d3-418b-aee2-f9d1815bfde0@gmail.com>
 <20250118223309.3930747-1-safinaskar@zohomail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20250118223309.3930747-1-safinaskar@zohomail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/18/25 22:33, Askar Safin wrote:
> Pavel Begunkov:
>> At this point it raises a question why it even needs io_uring
>> infra? I don't think it's really helping you. E.g. why not do it
>> as a list of operation in a custom format instead of links? That
>> can be run by a single io_uring request or can even be a normal
>> syscall.
> 
>> Makes me wonder about a different ways of handling. E.g. why should
>> it be run in the created task context (apart from final exec)? Can
>> requests be run as normal by the original task, each will take the
>> half created and not yet launched task as a parameter (in some form),
>> modify it, and the final exec would launch it?
> 
> I totally agree. I think API should look like this:
> 
> ===
> // This may be PID fd or something completely different
> int fd = create_task ();
> 
> task_manipulate (fd, OP_CHDIR, "/");
> task_manipulate (fd, OP_CLOSE, 0);
> task_manipulate (fd, OP_OPEN, "/dev/null", O_RDONLY, 0666);
> 
> task_execve (fd, "/bin/true", argv, envp);
> ===

That's one way of doing it. The api would be nice, it'd fit into
io_uring without extra tricks, and wouldn't even hard io_uring.
Though that could take a good amount of plumbing.

I also wonder, if copying the page table is a performance problem, why
CLONE_VM + exec is not an option? It's flexible, sounds like
posix_spawn does exactly that under the hood, and people tried it
and managed to outperform posix_spawn.

-- 
Pavel Begunkov


