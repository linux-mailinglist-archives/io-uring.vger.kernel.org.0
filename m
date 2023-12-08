Return-Path: <io-uring+bounces-260-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 93FE480A661
	for <lists+io-uring@lfdr.de>; Fri,  8 Dec 2023 16:00:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C4F7A1C20CAE
	for <lists+io-uring@lfdr.de>; Fri,  8 Dec 2023 15:00:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58431200C0;
	Fri,  8 Dec 2023 15:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BcfYOFc6"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70DA2F1
	for <io-uring@vger.kernel.org>; Fri,  8 Dec 2023 07:00:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702047600;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2Hp7gcvljkfE2QgZvPolQy2D9gEW33mcBsJdqUjp8eo=;
	b=BcfYOFc6ZWup5eZG3owwWvgpDArwip0jyuWBJUWB0caSFrSWcpeMObHKD28/zfXzdk99ka
	olxAE7bTVJAYqREWhMe2Sx96D8iG3HmNuV5FZMb9bNdMsbQz8+n8tobmUT2oBTy61sVY1Q
	gMk37jAq02NF+Z+h7J4Uek8337vcmRI=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-311-gVZxZjtqOtCJENK6UM5PFA-1; Fri,
 08 Dec 2023 09:59:57 -0500
X-MC-Unique: gVZxZjtqOtCJENK6UM5PFA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2A4B51C060D7;
	Fri,  8 Dec 2023 14:59:57 +0000 (UTC)
Received: from segfault.usersys.redhat.com (unknown [10.22.10.6])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E2A992166B35;
	Fri,  8 Dec 2023 14:59:56 +0000 (UTC)
From: Jeff Moyer <jmoyer@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org,  Pavel Begunkov <asml.silence@gmail.com>,
  jannh@google.com
Subject: Re: [PATCH 1/1] io_uring/af_unix: disable sending io_uring over
 sockets
References: <c716c88321939156909cfa1bd8b0faaf1c804103.1701868795.git.asml.silence@gmail.com>
	<170198118655.1944107.5078206606631700639.b4-ty@kernel.dk>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
Date: Fri, 08 Dec 2023 09:59:56 -0500
In-Reply-To: <170198118655.1944107.5078206606631700639.b4-ty@kernel.dk> (Jens
	Axboe's message of "Thu, 07 Dec 2023 13:33:06 -0700")
Message-ID: <x49sf4c91ub.fsf@segfault.usersys.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6

Jens Axboe <axboe@kernel.dk> writes:

> On Wed, 06 Dec 2023 13:26:47 +0000, Pavel Begunkov wrote:
>> File reference cycles have caused lots of problems for io_uring
>> in the past, and it still doesn't work exactly right and races with
>> unix_stream_read_generic(). The safest fix would be to completely
>> disallow sending io_uring files via sockets via SCM_RIGHT, so there
>> are no possible cycles invloving registered files and thus rendering
>> SCM accounting on the io_uring side unnecessary.
>> 
>> [...]
>
> Applied, thanks!

So, this will break existing users, right?

-Jeff


