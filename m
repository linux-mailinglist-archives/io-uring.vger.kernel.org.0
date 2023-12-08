Return-Path: <io-uring+bounces-262-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A791680A82A
	for <lists+io-uring@lfdr.de>; Fri,  8 Dec 2023 17:07:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D8DA51C208D9
	for <lists+io-uring@lfdr.de>; Fri,  8 Dec 2023 16:07:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5781D32C94;
	Fri,  8 Dec 2023 16:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="B5msgpLq"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A55F31989
	for <io-uring@vger.kernel.org>; Fri,  8 Dec 2023 08:07:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702051620;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tvwGSF7mtDW5h+Qo5jZDb8ifq8EUAEbChKetDBR7TJc=;
	b=B5msgpLqoaN2nBKyHrlLOko+WlL2XnLl/5Xl+G1o4kSWvzJKQw1dhoF84H9NdgWPnjfAYI
	xcA78D1TyU4XnhWqNJqyOYsroz/60w4qiH+Miu5nbBckTlJJhHPGeeh+VSwS8j+RLqICwc
	/Rcwd+v8EKbdPx3YKpJwjqUZ69a0csw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-434-SiqJtLDOO3ySIKdayPLb_w-1; Fri, 08 Dec 2023 11:06:58 -0500
X-MC-Unique: SiqJtLDOO3ySIKdayPLb_w-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 33AC685CE46;
	Fri,  8 Dec 2023 16:06:58 +0000 (UTC)
Received: from segfault.usersys.redhat.com (unknown [10.22.10.6])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EE1FF492BC6;
	Fri,  8 Dec 2023 16:06:57 +0000 (UTC)
From: Jeff Moyer <jmoyer@redhat.com>
To: Jann Horn <jannh@google.com>
Cc: Jens Axboe <axboe@kernel.dk>,  io-uring@vger.kernel.org,  Pavel Begunkov
 <asml.silence@gmail.com>
Subject: Re: [PATCH 1/1] io_uring/af_unix: disable sending io_uring over
 sockets
References: <c716c88321939156909cfa1bd8b0faaf1c804103.1701868795.git.asml.silence@gmail.com>
	<170198118655.1944107.5078206606631700639.b4-ty@kernel.dk>
	<x49sf4c91ub.fsf@segfault.usersys.redhat.com>
	<CAG48ez2R0AWjsWMh+cHepvpbYWB5te_n1PFtgCaSFQuX51m0Aw@mail.gmail.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
Date: Fri, 08 Dec 2023 11:06:57 -0500
In-Reply-To: <CAG48ez2R0AWjsWMh+cHepvpbYWB5te_n1PFtgCaSFQuX51m0Aw@mail.gmail.com>
	(Jann Horn's message of "Fri, 8 Dec 2023 16:09:41 +0100")
Message-ID: <x49lea48yqm.fsf@segfault.usersys.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9

Jann Horn <jannh@google.com> writes:

> On Fri, Dec 8, 2023 at 4:00=E2=80=AFPM Jeff Moyer <jmoyer@redhat.com> wro=
te:
>> Jens Axboe <axboe@kernel.dk> writes:
>>
>> > On Wed, 06 Dec 2023 13:26:47 +0000, Pavel Begunkov wrote:
>> >> File reference cycles have caused lots of problems for io_uring
>> >> in the past, and it still doesn't work exactly right and races with
>> >> unix_stream_read_generic(). The safest fix would be to completely
>> >> disallow sending io_uring files via sockets via SCM_RIGHT, so there
>> >> are no possible cycles invloving registered files and thus rendering
>> >> SCM accounting on the io_uring side unnecessary.
>> >>
>> >> [...]
>> >
>> > Applied, thanks!
>>
>> So, this will break existing users, right?
>
> Do you know of anyone actually sending io_uring FDs over unix domain
> sockets?

I do not.  However, it's tough to prove no software is doing this.

> That seems to me like a fairly weird thing to do.

I am often surprised by what developers choose to do.  I attribute that
to my lack of imagination.

> Thinking again about who might possibly do such a thing, the only
> usecase I can think of is CRIU; and from what I can tell, CRIU doesn't
> yet support io_uring anyway.

I'm not lobbying against turning this off, and I'm sure Pavel had
already considered the potential impact before posting.  It would be
good to include that information in the commit message, in my opinion.

Cheers,
Jeff


