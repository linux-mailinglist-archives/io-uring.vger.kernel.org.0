Return-Path: <io-uring+bounces-10487-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 36E19C44960
	for <lists+io-uring@lfdr.de>; Sun, 09 Nov 2025 23:42:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 028C11889D4F
	for <lists+io-uring@lfdr.de>; Sun,  9 Nov 2025 22:42:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D274126D4F7;
	Sun,  9 Nov 2025 22:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MzX4VfDs"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4F1D255E43
	for <io-uring@vger.kernel.org>; Sun,  9 Nov 2025 22:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762728140; cv=none; b=uV0zFh9WBrU+IIhlQqedF4oR/dRol7of29/OSh8HkvnJKwaOk0fcWtZ4cg2Wc6SFqZLa7I8IKnW6MV2I0hOlZnzagRQlfyEV6+MAirF3djINJpFxdukOFZ11lYqV5f1PNVLEucRJ6URBiu5l14sgR+/LbItHTujOedRPLnzJw9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762728140; c=relaxed/simple;
	bh=qIjdEUO4UIxlK8RXL91T93B918tKVIx5tlbLeaqNZTs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ulcfb9fyFafkhfKAm+lfk7pXHUv5+beam1n+BjF2cZ1jxhO2YnU/7VJw1eS8sKf9ppNaUnQLi+MMlPK57fOtwkR85gQE2oIRWJuiZntXp5/m/G0R1M1a6MAAOzO6mUl3r1DGuYfaw0oFjMiUwgK2E+uS19lP+E4wVs3qq9tRhno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MzX4VfDs; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-640b06fa959so3992752a12.3
        for <io-uring@vger.kernel.org>; Sun, 09 Nov 2025 14:42:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1762728136; x=1763332936; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=7S1tPI9KX5FxZpbFA6GTKD9y2rwBJh6/sJGdbAgzg24=;
        b=MzX4VfDsnyjNO0R0WafNm74z/mAMlXZi2wgGt/ByHmFKH03MtFD0c1Ic1GShzg7/lE
         Q3xQgiZ4GiotpvNqKQOb6P9JzqQrehpMi8twO20QcQ+j1R4ZD2SDs5hG+y+WB1/GJn/E
         k9taFObJ48GV+2HskA2OjteraGRrbHHldHY4s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762728136; x=1763332936;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7S1tPI9KX5FxZpbFA6GTKD9y2rwBJh6/sJGdbAgzg24=;
        b=dKhvvc08GF3h31OEIpIMv94cgN1bIuf73+uxI/md+I0ryE9poG9JQCwFiwyUVhLAQB
         49CG2o87kVcHzvBx99PXmi5CqNUFjIHuOD+I6jkLk7FbsBePX/iWFR5HtZSQrtp5Hn8w
         mN5RHuojyXH2lvs/bTorIaau+UOneUGqT08VCLzeqto3g8E/EqF2kz6m+895GbsUQ6UW
         G3JMUQ0Zldwy0/Upfgvy8/dWytGzSIffC8X3mD8BwCSWmuvPQsnIROOQrINqdf4aDvHG
         GLFz9M4CgCPMdHoogBm2fE7NPowmKqkK/b6YowDOVnTu09kZqJGtb/F0y3yZkhkMWSGT
         +j5Q==
X-Forwarded-Encrypted: i=1; AJvYcCXBy4BVt/mTd4AMOBK/OQ562XIsqHwuJSbPsdM+P5fFBz+cjPtvXnac5zxisvvfM0+4V3wjn7E8TQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx4wTRR2AAliFPC9Fp5PU/uPSaSteAs8TlfKvm3e338gzZpqfIT
	OV6peSswbh0472UluzMgwkC5CanUCcseZ1nBfnypEf75unpQqxAcOc5al0yXF2yMFccCLdpTmkx
	sOGesNqk=
X-Gm-Gg: ASbGncsTns3Il5oN9L5xHmdZ9H/tHXtHjAcU9Vz5/EYS/R9dd+ZQ/nvCV8ZcqoERG99
	RTrW3vzk6+Of9K2SwDGwK1c/EMezMEk930aatvlpXZk9wzP4ZYdmEkTezeN+i9f4x63u5h+8F4y
	YcXIyu+iM9mL2Vcnk43zRQj0RzNNEPYdUngIlzqLBGDV2KuyKTdPcbWz6MKEEjeVXhsnmh0FDRw
	3LS+2ETSmE5/lNs+7OQeQYEtZpJpPttkLZdLqDFgf2ZLpfcMypOROyHGfFi+BWGAdhTyP++ZVmJ
	G773pihx4fXUXuCvwafAO040j8xkhKZhqrFLWfrER3voI69e3ZaOHA8vqRXYcYP75U1fM1M/aBE
	rtbNt+aELxsaobHAA7KKSEj7qIvCZZKgjWsC+4Ikyy8b2/hRrvCsjyWS4ZMgyO44WnGwjTiwb0J
	M0cSHn6mLMr5thJcxAlmc2RKfZcbrmzkqvPQcNO1tDEgPnqTWuDQ==
X-Google-Smtp-Source: AGHT+IHbzCKAADDfKkpnWCp7W0R5SgXgxE33Bl/pB459QORGg9JLs185/DevHrQwTcysdmh2thEHeg==
X-Received: by 2002:a17:907:3f13:b0:b39:57ab:ec18 with SMTP id a640c23a62f3a-b72e045a978mr691197566b.45.1762728136630;
        Sun, 09 Nov 2025 14:42:16 -0800 (PST)
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com. [209.85.218.53])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b72bf4fbd8csm924158566b.24.2025.11.09.14.42.14
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 09 Nov 2025 14:42:16 -0800 (PST)
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-b7291af7190so359269866b.3
        for <io-uring@vger.kernel.org>; Sun, 09 Nov 2025 14:42:14 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUw4kMyuBudCHEIzykyhnb/6snTMrG8ZvfE2L48LV8bA1DsdWl5+Nd3IvPWnlB2SCPDMHGhnGVhwA==@vger.kernel.org
X-Received: by 2002:a17:907:7246:b0:b72:5e29:5084 with SMTP id
 a640c23a62f3a-b72e02729dfmr660861066b.4.1762728134438; Sun, 09 Nov 2025
 14:42:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251109063745.2089578-1-viro@zeniv.linux.org.uk>
 <20251109063745.2089578-11-viro@zeniv.linux.org.uk> <CAHk-=wgXvEK66gjkKfUxZ+G8n50Ms65MM6Sa9Vj9cTFg7_WAkA@mail.gmail.com>
 <CAGudoHHoSVRct8_BGwax37sadci-vwx_C=nuyCGoPn4SCAEagA@mail.gmail.com>
 <CAHk-=wiaGQUU5wPmmbsccUJ4zRdtfi_7YXdnZ-ig3WyPRE_wnw@mail.gmail.com>
 <CAGudoHGCkDXsFnc30k10w-thxNZ5c0B9j26kOWsCXkOV8ueeEA@mail.gmail.com>
 <CAHk-=whxKKnh=rtO9sq0uUL76YGLB3YTb98DVBub_84_nO6txA@mail.gmail.com> <CAGudoHHA_dDXMZFh1=U=AjPsqK9PRUGq3fQ_GjOdebUBK-sn3g@mail.gmail.com>
In-Reply-To: <CAGudoHHA_dDXMZFh1=U=AjPsqK9PRUGq3fQ_GjOdebUBK-sn3g@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 9 Nov 2025 14:41:58 -0800
X-Gmail-Original-Message-ID: <CAHk-=wj5GSLaqf+rVE6u-4-rzdUK+OM_oUnPLQoqVY4J_F0uRw@mail.gmail.com>
X-Gm-Features: AWmQ_bk5CNTgXVq9Wj4DrVDvXfYphjsw9So7wK98LkhJD7EILYp-AjhoG9v3pfw
Message-ID: <CAHk-=wj5GSLaqf+rVE6u-4-rzdUK+OM_oUnPLQoqVY4J_F0uRw@mail.gmail.com>
Subject: Re: [RFC][PATCH 10/13] get rid of audit_reusename()
To: Mateusz Guzik <mjguzik@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, 
	brauner@kernel.org, jack@suse.cz, paul@paul-moore.com, axboe@kernel.dk, 
	audit@vger.kernel.org, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Sun, 9 Nov 2025 at 14:33, Mateusz Guzik <mjguzik@gmail.com> wrote:
>
> The programs which pass in these "too long" names just keep doing it,

Sure. So what?

We optimize for the common case.

Sure, there's an extra SMAP sequence for people using longer names,
but while those SMAP things are costly compared to individual
instructions, they aren't costly in the *big* picture.

They are a pipeline stall, not some kind of horrendous thing.

It would be *more* expensive to try to keep statistics than it is to
just say "long pathnames are more expensive than short ones".

                Linus

