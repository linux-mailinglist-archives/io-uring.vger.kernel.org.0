Return-Path: <io-uring+bounces-221-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 67CD5803E44
	for <lists+io-uring@lfdr.de>; Mon,  4 Dec 2023 20:22:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EAEFBB20A09
	for <lists+io-uring@lfdr.de>; Mon,  4 Dec 2023 19:22:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1586F2EB0E;
	Mon,  4 Dec 2023 19:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PQwS3QTp"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30A0AE6
	for <io-uring@vger.kernel.org>; Mon,  4 Dec 2023 11:22:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701717749;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CuE3wvKVXZ5LaoLyCftMFlpvjjYLnjdW2HQklzJBS80=;
	b=PQwS3QTpMRWLdUPK2hWMarIWh+zQTmNBTGVy5WIAw6ktRzXf+XaqLZ+Vz1j6K+xym6UOBr
	LVig1kdeeyF+2Bby55QbPHOPkpAkoqdciavEniJiWuBMSDB/lTlu0MR9pJxDEUFrSB9XUm
	5TzTVU4u5i9xaUrbuhybKSVPsoBNrr4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-567-fjyfe8TTMMa5a8OWjU-AOQ-1; Mon, 04 Dec 2023 14:22:24 -0500
X-MC-Unique: fjyfe8TTMMa5a8OWjU-AOQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A1D41811E7D;
	Mon,  4 Dec 2023 19:22:23 +0000 (UTC)
Received: from segfault.usersys.redhat.com (unknown [10.22.10.39])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BF464492BFC;
	Mon,  4 Dec 2023 19:22:22 +0000 (UTC)
From: Jeff Moyer <jmoyer@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Keith Busch <kbusch@meta.com>,  linux-nvme@lists.infradead.org,
  io-uring@vger.kernel.org,  hch@lst.de,  sagi@grimberg.me,
  asml.silence@gmail.com,  Keith Busch <kbusch@kernel.org>,
  linux-security-module@vger.kernel.org
Subject: Re: [PATCH 1/2] iouring: one capable call per iouring instance
References: <20231204175342.3418422-1-kbusch@meta.com>
	<x49zfypstdx.fsf@segfault.usersys.redhat.com>
	<9c1ee0ee-ccae-4013-83f4-92a2af7bdf42@kernel.dk>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
Date: Mon, 04 Dec 2023 14:22:22 -0500
In-Reply-To: <9c1ee0ee-ccae-4013-83f4-92a2af7bdf42@kernel.dk> (Jens Axboe's
	message of "Mon, 4 Dec 2023 12:01:38 -0700")
Message-ID: <x49sf4hsrgx.fsf@segfault.usersys.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10

Jens Axboe <axboe@kernel.dk> writes:

> On 12/4/23 11:40 AM, Jeff Moyer wrote:
>> Finally, as Jens mentioned, I would expect dropping priviliges to, you
>> know, drop privileges.  I don't think a commit message is going to be
>> enough documentation for a change like this.
>
> Only thing I can think of here is to cache the state in
> task->io_uring->something, and then ensure those are invalidated
> whenever caps change.

I looked through the capable() code, and there is no way that I could
find to be notified of changes.

> It's one of those cases where that's probably only done once, but we
> do need to be able to catch it. Not convinced that caching it at ring
> creation is sane enough, even if it is kind of like opening devices
> before privs are dropped where you could not otherwise re-open them
> later on.

Agreed.

-Jeff


