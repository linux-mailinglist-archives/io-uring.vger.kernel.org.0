Return-Path: <io-uring+bounces-841-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 56359873B5D
	for <lists+io-uring@lfdr.de>; Wed,  6 Mar 2024 16:58:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D958A288122
	for <lists+io-uring@lfdr.de>; Wed,  6 Mar 2024 15:58:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 312395DF3C;
	Wed,  6 Mar 2024 15:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="d5sCzTXO"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94848137914
	for <io-uring@vger.kernel.org>; Wed,  6 Mar 2024 15:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709740634; cv=none; b=DHONYV3lszcQYyp20VFfzedDWg1RCtxcjMtZm170ztFXZty4W/AZTDLn4j69dPc28597tMosXk+03gHWZ0Z6dv+haR4Gve3k/HWZkOVnik3s3wup8DJhjV4IpozGBtfQ0oq7huoHbkw8NMde3pw45i0PP/vF9EW5SmPqqR5b2nU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709740634; c=relaxed/simple;
	bh=AL8vTSnXLt4IGpMVHaBA4vBpZopWqBrqVcPDZeqahRs=;
	h=From:To:Cc:Subject:References:Date:In-Reply-To:Message-ID:
	 MIME-Version:Content-Type; b=SwPd3znWJT6vylt3gPre3RE9uVaUW0ozeBYL7PIAhv28XyhPvD4NrqBhMMURP6QVQhmso9YNr6bvlNIX+VnE7mSJ5rNPo0toP7tWkvEx/pnN9TC+dp8vdO+j/CQUZLq0czPQEgk+C3fuSR/CdALXDyFMvvdZ0pWXGs9YsRirY8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=d5sCzTXO; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709740630;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0N93XVbJI5R2zzyhqgdjxio2vvEPajw0kGYYTW4HY2o=;
	b=d5sCzTXOBIyF/qN1HM7dmG2O/MNa4jvOm7u8q69+O6ZlL0XBWWp/dfMVLj48ijyso61IA0
	Duy9dspPQnG0InNgsSL/Bk/pEajV398yN3e8DDIXzgF0yNG/buOPwL6+y4D57nG/PsnUog
	9Ic7UPDkE7Hc/aIObEc/5HuJra3bhys=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-362-4WbMzTJyO_Kv794jV5g1AQ-1; Wed, 06 Mar 2024 10:57:08 -0500
X-MC-Unique: 4WbMzTJyO_Kv794jV5g1AQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9BAE8101A526;
	Wed,  6 Mar 2024 15:57:08 +0000 (UTC)
Received: from segfault.usersys.redhat.com (unknown [10.22.10.44])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6E30DC017A0;
	Wed,  6 Mar 2024 15:57:08 +0000 (UTC)
From: Jeff Moyer <jmoyer@redhat.com>
To: Zorro Lang <zlang@kernel.org>
Cc: fstests@vger.kernel.org,  io-uring@vger.kernel.org
Subject: Re: [PATCH 2/3] fsstress: bypass io_uring testing if
 io_uring_queue_init returns EPERM
References: <20240306091935.4090399-1-zlang@kernel.org>
	<20240306091935.4090399-3-zlang@kernel.org>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
Date: Wed, 06 Mar 2024 10:57:08 -0500
In-Reply-To: <20240306091935.4090399-3-zlang@kernel.org> (Zorro Lang's message
	of "Wed, 6 Mar 2024 17:19:34 +0800")
Message-ID: <x49a5nbuze3.fsf@segfault.usersys.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8

Zorro Lang <zlang@kernel.org> writes:

> I found the io_uring testing still fails as:
>   io_uring_queue_init failed
> even if kernel supports io_uring feature.
>
> That because of the /proc/sys/kernel/io_uring_disabled isn't 0.
>
> Different value means:
>   0 All processes can create io_uring instances as normal.
>   1 io_uring creation is disabled (io_uring_setup() will fail with
>     -EPERM) for unprivileged processes not in the io_uring_group
>     group. Existing io_uring instances can still be used.  See the
>     documentation for io_uring_group for more information.
>   2 io_uring creation is disabled for all processes. io_uring_setup()
>     always fails with -EPERM. Existing io_uring instances can still
>     be used.
>
> So besides the CONFIG_IO_URING kernel config, there's another switch
> can on or off the io_uring supporting. And the "2" or "1" might be
> the default on some systems.
>
> On this situation the io_uring_queue_init returns -EPERM, so I change
> the fsstress to ignore io_uring testing if io_uring_queue_init returns
> -ENOSYS or -EPERM. And print different verbose message for debug.
>
> Signed-off-by: Zorro Lang <zlang@kernel.org>
> ---
>  ltp/fsstress.c | 15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)
>
> diff --git a/ltp/fsstress.c b/ltp/fsstress.c
> index 482395c4..9c75f27b 100644
> --- a/ltp/fsstress.c
> +++ b/ltp/fsstress.c
> @@ -762,12 +762,23 @@ int main(int argc, char **argv)
>  #endif
>  #ifdef URING
>  			have_io_uring = true;
> -			/* If ENOSYS, just ignore uring, other errors are fatal. */
> +			/*
> +			 * If ENOSYS, just ignore uring, due to kernel doesn't support it.
> +			 * If EPERM, might due to sysctl kernel.io_uring_disabled isn't 0,
> +			 *           or some selinux policies, etc.
> +			 * Other errors are fatal.
> +			 */
>  			if ((c = io_uring_queue_init(URING_ENTRIES, &ring, 0)) != 0) {
>  				if (c == -ENOSYS) {
>  					have_io_uring = false;
> +					if (verbose)
> +						printf("io_uring isn't supported by kernel\n");
> +				} else if (c == -EPERM) {
> +					have_io_uring = false;
> +					if (verbose)
> +						printf("io_uring isn't allowed, check io_uring_disabled sysctl or selinux policy\n");
>  				} else {
> -					fprintf(stderr, "io_uring_queue_init failed\n");
> +					fprintf(stderr, "io_uring_queue_init failed, errno=%d\n", c);

I think you want to use -c here, right?

Other than that:

Reviewed-by: Jeff Moyer <jmoyer@redhat.com>


