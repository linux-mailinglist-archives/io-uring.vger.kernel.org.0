Return-Path: <io-uring+bounces-4606-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E6BA19C3E7D
	for <lists+io-uring@lfdr.de>; Mon, 11 Nov 2024 13:35:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6CB8EB209D4
	for <lists+io-uring@lfdr.de>; Mon, 11 Nov 2024 12:35:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0620119D080;
	Mon, 11 Nov 2024 12:35:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DdQpohZ3"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4228B14D70E
	for <io-uring@vger.kernel.org>; Mon, 11 Nov 2024 12:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731328532; cv=none; b=SiRgfmT3UbK2Jlj8A1lEWSMkIkR6xgND4Jz6MVC3gVXrX8sNobtXASH/zpGo0asi9srq5LI1F/SB2y+otJFX4myZBzZf4fTQP9KpdYcLRGwx8dfjoLqR/V88QDO9+Znp9mtqak8Xj/CocfWRj/ffsHMdDaCWaO1gqcf1gEttfQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731328532; c=relaxed/simple;
	bh=O/Pd0MtD0eJiwbPuzLhvxnxopeoCFeBWmTgyugx7VjQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=t8dYTS4NISbUrAiu8X3Hv6uS/25uYtvipp/bBI9r1eNCGsYQOP/nMQoQUiVTXDGDNmLoFo/vKN0Ywo0cZE1A+lRnyGarErIVMYG/YUwpiKUH/Fk+SFhuJyZl9+I1wTlLm7szA3GP/Hy1xgaZAkMPoDo999OfLQK6cBknsDodSfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DdQpohZ3; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-5cec7cde922so6186643a12.3
        for <io-uring@vger.kernel.org>; Mon, 11 Nov 2024 04:35:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731328529; x=1731933329; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=O/Pd0MtD0eJiwbPuzLhvxnxopeoCFeBWmTgyugx7VjQ=;
        b=DdQpohZ39CsGhu0SJrVcoB6gz/rVYEn8SwDvA1WfzmkY4OckkB3YK1KIRfKeVvS2JP
         VOb7nJXD0mv6+zmH9d2fQ9ZSBMpdcGY9QqajquLTG5eJKiVEdPZEfY8UD6NJfy2EMrWE
         7IKWSJgu8uFYXdhPUuiYNM9ATKJCK1R8tzOKwHKB78CmQdwl7CB+Cr95sCsJj6zWjCZi
         Y16/3tAAvM00Rc+rrkMcfekuamWkvExHr5O0K8n5d+oCiu1zQInh474YYycKKWQU/ZcU
         aads9Io2UsbUHAzT5UribROVtn1N37Zfxoe03Ke8ipptSJaTQvD//gsPXm4hX2DCEnJm
         vkvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731328529; x=1731933329;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=O/Pd0MtD0eJiwbPuzLhvxnxopeoCFeBWmTgyugx7VjQ=;
        b=VX/BZoYTek4j3qMRFYHLFqTBUJD3Xp1YZhygtd7JK8pnPP+9APOzTYHHSSvUQv4DDK
         QY7bUibxA2B4smcBjH0RUZ9wq0wv+jo9XWlHoFXzEcgTpEm2JXS6Av6Ji/haKPg1IIkW
         6zlVU2HhL++VOteHa7vE5HSyoi1BchpW5Rie3pfhtV2A0C0i5JAxwcX+bMK2+9ai0nsD
         AUXLOZWOVdaGjEPeibmZU5W4NKshfR4nwk0TldW9a6bRrJlWYeqPajawyy9EkOc3xR99
         PJQnClvQPNFeAyhurpAnQ6mfWTcc1biGQeoEC4jOIj8AObEesbkjiMnZLMHnBJdUagXa
         NCzA==
X-Forwarded-Encrypted: i=1; AJvYcCU/FL9T+kb8JRjTn3LZopQRhmi+bynafLQgbVssrIsuzxkjWfcOG3IAbByczmFtZUCrkcusHwOeRQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy6Iexnzv6IEiK2cwnmvh2AuUZ/Y/1BqQVzN756UE3QqdtYTnzr
	TzAuRm+NIQdLM8XF9iM+C+0b4RmbcrwF1Tni5YljPs1aHEswfZqhBxTfcJZVv62bTZ1by8z5w7k
	Iwsi0RQkoYcv0YHz+rF+F1V8wJA==
X-Google-Smtp-Source: AGHT+IEYivphO01EtNCpsBywP+Y2vOGn9lq7ObyAbkdE+MSkpwa0IoLatvWfD49QReZSirvrU0w5RA8w3HvVec8vJx0=
X-Received: by 2002:a05:6402:5113:b0:5cf:a20:527b with SMTP id
 4fb4d7f45d1cf-5cf0a45ec5amr11068164a12.28.1731328529303; Mon, 11 Nov 2024
 04:35:29 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241111101318.1387557-1-ming.lei@redhat.com>
In-Reply-To: <20241111101318.1387557-1-ming.lei@redhat.com>
From: Anuj gupta <anuj1072538@gmail.com>
Date: Mon, 11 Nov 2024 18:04:52 +0530
Message-ID: <CACzX3Av5sjUUX5Hz6n3Q-afZ14yFcA0g8Z=--tSuAyh2Sd_+Sw@mail.gmail.com>
Subject: Re: [PATCH] io_uring/uring_cmd: fix buffer index retrieval
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org, 
	Pavel Begunkov <asml.silence@gmail.com>, Guangwu Zhang <guazhang@redhat.com>, 
	Jeff Moyer <jmoyer@redhat.com>
Content-Type: text/plain; charset="UTF-8"

Looks good:
Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>

