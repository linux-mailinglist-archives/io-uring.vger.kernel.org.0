Return-Path: <io-uring+bounces-840-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8DCED873B53
	for <lists+io-uring@lfdr.de>; Wed,  6 Mar 2024 16:57:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3A070B2513E
	for <lists+io-uring@lfdr.de>; Wed,  6 Mar 2024 15:57:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96155135415;
	Wed,  6 Mar 2024 15:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GPuYWovt"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D132D135A4C
	for <io-uring@vger.kernel.org>; Wed,  6 Mar 2024 15:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709740575; cv=none; b=n4qylc3xxgRdl5cM+07rikFZ83B3G600KtgpDlWGMruQHZWtOiCVedaa/rKjxFXTP28kiQqsxcxwGMqtfkiCViFZz/jW0JtGn2B+dW6kq2kA/n75B7WAavmQch3KbPJ/TFaBVHJTgokps1O651KaTgEep8oFnP5Jgvmz7eVW2mc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709740575; c=relaxed/simple;
	bh=363MuCTCv4q/VdXDhLYTvp7w/yhygSV3dpWAGY09G+U=;
	h=From:To:Cc:Subject:References:Date:In-Reply-To:Message-ID:
	 MIME-Version:Content-Type; b=LfQrCynvqqg/R1uirbYd5kSNe4WRCn1P/fwkTP7xgSR5oJmxz8xgJ7bJ4rGSxNvPGXaE60IfV1sQXnbNnpfij55aBIz7Zioer+kctoAYME7Gh0LCEIpGZzlXeNvazpNDsE7yDovWESiCFQtzjVm53wbCzRXRJyY+UCkyJFrqgTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GPuYWovt; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709740572;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4zTPmAm3eQm6rtvxPO+MxDLWAxixWTigSeqciicaa5w=;
	b=GPuYWovt59Ca5SNVSDqz+G9pqZyhAhXECSmH4oCaaLJS5v4jRXD/QVmjsamnGDH1jInrjb
	6eVjA8QgDbZ6brGQZDq0TK8+ibv2Ke8NcjFzp+Rlc6giVAIVsuJ+itiwoad+CKIyuL0ZZF
	d+Z1k3TRcRWc57f/vTh9jX76FmAguww=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-570-gBQ2nPNsNNaofl-ZjjIFwg-1; Wed,
 06 Mar 2024 10:56:09 -0500
X-MC-Unique: gBQ2nPNsNNaofl-ZjjIFwg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1433B2804803;
	Wed,  6 Mar 2024 15:56:09 +0000 (UTC)
Received: from segfault.usersys.redhat.com (unknown [10.22.10.44])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D992840C6CB5;
	Wed,  6 Mar 2024 15:56:08 +0000 (UTC)
From: Jeff Moyer <jmoyer@redhat.com>
To: Zorro Lang <zlang@kernel.org>
Cc: fstests@vger.kernel.org,  io-uring@vger.kernel.org
Subject: Re: [PATCH 1/3] fsstress: check io_uring_queue_init errno properly
References: <20240306091935.4090399-1-zlang@kernel.org>
	<20240306091935.4090399-2-zlang@kernel.org>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
Date: Wed, 06 Mar 2024 10:56:08 -0500
In-Reply-To: <20240306091935.4090399-2-zlang@kernel.org> (Zorro Lang's message
	of "Wed, 6 Mar 2024 17:19:33 +0800")
Message-ID: <x49edcnuzfr.fsf@segfault.usersys.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2

Zorro Lang <zlang@kernel.org> writes:

> As the manual of io_uring_queue_init says "io_uring_queue_init(3)
> returns 0 on success and -errno on failure". We should check if the
> return value is -ENOSYS, not the errno.
>
> Fixes: d15b1721f284 ("ltp/fsstress: don't fail on io_uring ENOSYS")
> Signed-off-by: Zorro Lang <zlang@kernel.org>
> ---
>  ltp/fsstress.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/ltp/fsstress.c b/ltp/fsstress.c
> index 63c75767..482395c4 100644
> --- a/ltp/fsstress.c
> +++ b/ltp/fsstress.c
> @@ -763,8 +763,8 @@ int main(int argc, char **argv)
>  #ifdef URING
>  			have_io_uring = true;
>  			/* If ENOSYS, just ignore uring, other errors are fatal. */
> -			if (io_uring_queue_init(URING_ENTRIES, &ring, 0)) {
> -				if (errno == ENOSYS) {
> +			if ((c = io_uring_queue_init(URING_ENTRIES, &ring, 0)) != 0) {
> +				if (c == -ENOSYS) {
>  					have_io_uring = false;
>  				} else {
>  					fprintf(stderr, "io_uring_queue_init failed\n");

Reviewed-by: Jeff Moyer <jmoyer@redhat.com>


