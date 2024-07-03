Return-Path: <io-uring+bounces-2425-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 74E9F92662C
	for <lists+io-uring@lfdr.de>; Wed,  3 Jul 2024 18:32:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2FEDC2830EA
	for <lists+io-uring@lfdr.de>; Wed,  3 Jul 2024 16:32:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3ED241822D8;
	Wed,  3 Jul 2024 16:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bs+wDda4"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CA59180A73
	for <io-uring@vger.kernel.org>; Wed,  3 Jul 2024 16:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720024321; cv=none; b=oRjfIA33lcRYUEVL+BNNb0frmXc1t86ET0jlIUkJrc3FqCWjuE0zsWl2QbkKQ93ucDRGW9euQ1Ge1N5psXzL9n7I7J3DCcDgGwf2mrb+A4qC2BXVJnk6+jtkCN8M38xVLvpooTwxdJluJGMVj4j9/tQHyd8HaK14idbbfxwgPCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720024321; c=relaxed/simple;
	bh=aX/dntK47yBZoBKXBogHtsXyVUj/EEsdEqcWuVR2MNY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=H9RaOecy94uXdyKZAyLcnlznH5bw7m25XICLWq7SGUtgxToLV7OVHASUpKDcAsB/de1mYk9xNX/4nWwck3T7IrD6cheWzZRm5Uo67Cst3KB299eX7rgfEjxYEvLvFhnGCSVvJzXdv5h4Dgj1RzixdZTTv+Uft7/AZlx11kgOU6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bs+wDda4; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-58b0dddab8cso4415216a12.0
        for <io-uring@vger.kernel.org>; Wed, 03 Jul 2024 09:31:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1720024318; x=1720629118; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=iyado1sFM+cGedSAqHu7B/wZSU2t+kg2eHyPGnCfXa8=;
        b=bs+wDda48syzyChkks6dx2nG/8wmx1+r30qz4JTQM6yEum559qqWXCpo32lGEL2KmU
         bRcA9Ds1Arxl7QZTpO58M43tshRVek2Mb6WOCrQ1x0CPXxIQ3dnAnAXaXmgP27pz906J
         kIeOsJ3DcXx9JrP54t7do7syEgvA+2ydh4QfM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720024318; x=1720629118;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iyado1sFM+cGedSAqHu7B/wZSU2t+kg2eHyPGnCfXa8=;
        b=nbK5YWYlLGBI3kY2BDXJyX6t2HIBIKsCV+kPm39qxPc/vCf/t825nIANgaL+S2Dzf7
         7AwPeB9H2yyoD4ZPk/OL+uYSEEpbHEwcZBX1MyLPGz02fHBi6cz9+m1fZSk1gusrIgsq
         kQNtUFPfkuvEJ5P5L5TvxL0L8srYj2TqNJ6aqAsqT7jSls/f7kYZ0xjBH9HLw/4HGVrG
         NqTbHsMaqZ4FeLZQ1d1nwBYDZJcQzy7YJjZ7eX7O6VQF9efDoWdavCdif2g8xdN9UtQJ
         L1bb8OxSWAw7nM0oDEPaqorWXjKcWEOzBJAZ8P/n3K6Izq/plrkl7xzSbOTC7k6mfDKi
         oNFw==
X-Forwarded-Encrypted: i=1; AJvYcCVGmvyTdqPnU+xXRWFerAQVPvhu3GZS3Gg6Rud0qaw8eFVG+jyaPNt/cixCyDT3As7gxkdLuNWdWgiWOkgktjN+w3tg3SAFsGQ=
X-Gm-Message-State: AOJu0YzI/knfx4bxKpH8YcuIeh3oSBx0f/vmwlGEZnEu1tik3ZFBmlC+
	df6CTCsNuuFUdtOX0GAq9Jxq24mgMfL1Q1z8FIXeg+FQgM81BSxPX8spDPtIXnRBXYJTEO6kEpD
	oysYAQQ==
X-Google-Smtp-Source: AGHT+IG0gGsgOPrgyIDlpss8U5bgXD8JMvFq2x9P0CV9H5O/klpHpUlNy05AMVIDbZ1rS0jfuyztTA==
X-Received: by 2002:a05:6402:518e:b0:58d:5562:2c36 with SMTP id 4fb4d7f45d1cf-58d55622cc2mr1042533a12.0.1720024317797;
        Wed, 03 Jul 2024 09:31:57 -0700 (PDT)
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com. [209.85.218.42])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-58612c835dfsm7217049a12.20.2024.07.03.09.31.56
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Jul 2024 09:31:56 -0700 (PDT)
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-a7523f0870cso460296766b.3
        for <io-uring@vger.kernel.org>; Wed, 03 Jul 2024 09:31:56 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWhxYEs4pRXoUl9+7Mp7GoNo8NOcRtCo2j5MKemiNCucF6IQAS5biQXXILj0FGFhPty4N5OzcJpgheilwrYEgbYPPPZSDOQV0Q=
X-Received: by 2002:a17:907:368a:b0:a75:3f38:e0a4 with SMTP id
 a640c23a62f3a-a753f38e1a0mr459327066b.47.1720024316186; Wed, 03 Jul 2024
 09:31:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240625110029.606032-1-mjguzik@gmail.com> <20240625110029.606032-3-mjguzik@gmail.com>
 <CAAhV-H47NiQ2c+7NynVxduJK-yGkgoEnXuXGQvGFG59XOBAqeg@mail.gmail.com>
 <e8db013bf06d2170dc48a8252c7049c6d1ee277a.camel@xry111.site>
 <CAAhV-H7iKyQBvV+J9T1ekxh9OF8h=F9zp_QMyuhFBrFXGHHmTg@mail.gmail.com>
 <30907b42d5eee6d71f40b9fc3d32ae31406fe899.camel@xry111.site>
 <1b5d0840-766b-4c3b-8579-3c2c892c4d74@app.fastmail.com> <CAAhV-H4Z_BCWRJoCOh4Cei3eFCn_wvFWxA7AzWfNxYtNqUwBPA@mail.gmail.com>
 <8f2d356d-9cd6-4b06-8e20-941e187cab43@app.fastmail.com> <20240703-bergwacht-sitzung-ef4f2e63cd70@brauner>
In-Reply-To: <20240703-bergwacht-sitzung-ef4f2e63cd70@brauner>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 3 Jul 2024 09:31:35 -0700
X-Gmail-Original-Message-ID: <CAHk-=wi0ejJ=PCZfCmMKvsFmzvVzAYYt1K9vtwke4=arfHiAdg@mail.gmail.com>
Message-ID: <CAHk-=wi0ejJ=PCZfCmMKvsFmzvVzAYYt1K9vtwke4=arfHiAdg@mail.gmail.com>
Subject: Re: [PATCH 2/2] vfs: support statx(..., NULL, AT_EMPTY_PATH, ...)
To: Christian Brauner <brauner@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Huacai Chen <chenhuacai@kernel.org>, Xi Ruoyao <xry111@xry111.site>, 
	Mateusz Guzik <mjguzik@gmail.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, loongarch@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

On Wed, 3 Jul 2024 at 01:46, Christian Brauner <brauner@kernel.org> wrote:
>
> We've now added AT_EMPTY_PATH support with NULL names because we want to
> allow that generically. But I clearly remember that this was requested
> to make statx() work with these sandboxes. So the kernel has done its
> part. Now it's for the sandbox to allow statx() with NULL paths and
> AT_EMPTY_PATH but certainly not for the kernel to start reenabling old
> system calls.

Those old system calls are still used.

Just enable them.

statx isn't the promised land. Existing applications matter. And there
is absolutely nothing wrong with plain old 'stat' (well, we call it
"newstat" in the kernel for historical reasons) on 64-bit
architectures.

Honestly, 'statx' is disgusting. I don't understand why anybody pushes
that thing that nobody actually uses or cares about.

                Linus

