Return-Path: <io-uring+bounces-2446-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 38E66926F20
	for <lists+io-uring@lfdr.de>; Thu,  4 Jul 2024 07:55:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D64941F236CE
	for <lists+io-uring@lfdr.de>; Thu,  4 Jul 2024 05:55:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67F311A01AD;
	Thu,  4 Jul 2024 05:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EtlTBrcH"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F1F5748F
	for <io-uring@vger.kernel.org>; Thu,  4 Jul 2024 05:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720072534; cv=none; b=Qa5/Wk76/5+baXajzKA/o8Q6jATFfAHAXfMYCFx+d8e3TTRvhb6I98kwJ2irAh2bx9yXhLk4P/hCcqYtCn8mde/VoF9PPjrebon/KTrW0s9Zl5g9ODi3w5XkPOP8X0CgVvNnHsnjO0l8v8LuNDda0p/IL6uNz3rmOgKCrv0tgpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720072534; c=relaxed/simple;
	bh=ipEm3wESSAbTe1OELWS7F76Xb/XsCZ6OA2b7x8yAD/k=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=BXEkP6iIC76wfduHp/svNZDQnFYXt/ZG+gAWZFnDY0Y9x9XwmLvzW5OTLNDzh9xNgBM6AgEbD0MUTVPutbyQhtg6hDZWGz0No2iHkSoDT0IZsOeM3cez3xTpR7zeyCLBz3aNDD8xzetxVX0hl9RxSne1rfutQlGWjizFm2ycXxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EtlTBrcH; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720072530;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TokaimGknrl6W7X/jIUjM2jQEJkeLUj5wpywVtaJow8=;
	b=EtlTBrcHPLnjnQyVwUQ9gpmiumqTUJ/oFVmLToKy3Efct6HnaTVPxpFCW0lCwetW5yPCOy
	V1jFSW4TsjwsF1BLRiwjfrUtmBChNnBX8gFItLIE4rR0C4AT+YoaKpxyyLXdwXrqn/QcMt
	hO7ui1cITFE/ja/KsrW3vNu/qYqA5dA=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-434-kzsFOwESPVSdtUt2ugJfDg-1; Thu,
 04 Jul 2024 01:55:28 -0400
X-MC-Unique: kzsFOwESPVSdtUt2ugJfDg-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 68A9319560B3;
	Thu,  4 Jul 2024 05:55:25 +0000 (UTC)
Received: from oldenburg.str.redhat.com (unknown [10.45.224.92])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7C67530000DD;
	Thu,  4 Jul 2024 05:55:19 +0000 (UTC)
From: Florian Weimer <fweimer@redhat.com>
To: Xi Ruoyao <xry111@xry111.site>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,  Christian Brauner
 <brauner@kernel.org>,  libc-alpha@sourceware.org,  "Andreas K. Huettel"
 <dilfridge@gentoo.org>,  Arnd Bergmann <arnd@arndb.de>,  Huacai Chen
 <chenhuacai@kernel.org>,  Mateusz Guzik <mjguzik@gmail.com>,  Alexander
 Viro <viro@zeniv.linux.org.uk>,  Jan Kara <jack@suse.cz>,
  linux-kernel@vger.kernel.org,  linux-fsdevel@vger.kernel.org,
  io-uring@vger.kernel.org,  Jens Axboe <axboe@kernel.dk>,
  loongarch@lists.linux.dev
Subject: Re: [PATCH 2/2] vfs: support statx(..., NULL, AT_EMPTY_PATH, ...)
In-Reply-To: <8b6d59ffc9baa57fee0f9fa97e72121fd88cf0e4.camel@xry111.site> (Xi
	Ruoyao's message of "Thu, 04 Jul 2024 00:54:45 +0800")
References: <20240625110029.606032-1-mjguzik@gmail.com>
	<20240625110029.606032-3-mjguzik@gmail.com>
	<CAAhV-H47NiQ2c+7NynVxduJK-yGkgoEnXuXGQvGFG59XOBAqeg@mail.gmail.com>
	<e8db013bf06d2170dc48a8252c7049c6d1ee277a.camel@xry111.site>
	<CAAhV-H7iKyQBvV+J9T1ekxh9OF8h=F9zp_QMyuhFBrFXGHHmTg@mail.gmail.com>
	<30907b42d5eee6d71f40b9fc3d32ae31406fe899.camel@xry111.site>
	<1b5d0840-766b-4c3b-8579-3c2c892c4d74@app.fastmail.com>
	<CAAhV-H4Z_BCWRJoCOh4Cei3eFCn_wvFWxA7AzWfNxYtNqUwBPA@mail.gmail.com>
	<8f2d356d-9cd6-4b06-8e20-941e187cab43@app.fastmail.com>
	<20240703-bergwacht-sitzung-ef4f2e63cd70@brauner>
	<CAHk-=wi0ejJ=PCZfCmMKvsFmzvVzAYYt1K9vtwke4=arfHiAdg@mail.gmail.com>
	<8b6d59ffc9baa57fee0f9fa97e72121fd88cf0e4.camel@xry111.site>
Date: Thu, 04 Jul 2024 07:55:16 +0200
Message-ID: <877ce1ya4b.fsf@oldenburg.str.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

* Xi Ruoyao:

> Also some bad news: Glibc has this:
>
> #if (__WORDSIZE == 32 \
>      && (!defined __SYSCALL_WORDSIZE || __SYSCALL_WORDSIZE == 32)) \
>     || defined STAT_HAS_TIME32 \
>     || (!defined __NR_newfstatat && !defined __NR_fstatat64)
> # define FSTATAT_USE_STATX 1
> #else
> # define FSTATAT_USE_STATX 0
> #endif

These __NR_* constants come from the glibc headers, not the kernel
headers.  In other words, the result of the preprocessor condition does
not depend on the kernel header version.

Thanks,
Florian


