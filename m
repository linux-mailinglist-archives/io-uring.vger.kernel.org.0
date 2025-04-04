Return-Path: <io-uring+bounces-7387-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A0CE3A7B550
	for <lists+io-uring@lfdr.de>; Fri,  4 Apr 2025 03:09:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A07CB7A5D3E
	for <lists+io-uring@lfdr.de>; Fri,  4 Apr 2025 01:08:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EC4563CB;
	Fri,  4 Apr 2025 01:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="Ok53p5cU"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qv1-f98.google.com (mail-qv1-f98.google.com [209.85.219.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 029D8748D
	for <io-uring@vger.kernel.org>; Fri,  4 Apr 2025 01:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743728983; cv=none; b=rTzJWRgBKmYsRxjEpdHDSpkAHnYQCOH6YMGcUuzNervx/CcKaOci9wCQVf65C0J0a+wJkuetsic2a/PYW6vsRQR/NHeFPSILT9w3+RpPpckNZPyIyya1Zb2cQy4LxhlUSDEkP5seFk5aPsAOvuk8YMSbV0v1BWbFR4FF20J63ok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743728983; c=relaxed/simple;
	bh=29lT6XM9PTfZ4QzSmdqHkLSRtATT0hhp6i8w7wwJdS4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FKI4yJdwl7i+h1ZYS82jOeP0hVzHNUpr0WOa+RGfN5lVAD3Wm6NRBaAAsYB68nkFBa35kycjL4Qd0BuJUrYsGvM7KP2UaqMXEooH+7D6U77KIlM5LLjBJg9tX+2FnQAtxCg4hB9gK/XIihILnojhdFC9Wt3k19JduYk0DNdpXPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=Ok53p5cU; arc=none smtp.client-ip=209.85.219.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-qv1-f98.google.com with SMTP id 6a1803df08f44-6e8ffa00555so13503366d6.0
        for <io-uring@vger.kernel.org>; Thu, 03 Apr 2025 18:09:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1743728979; x=1744333779; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jwQEWgYNpeA/XdQZYs4KZSISRZNjHiSXarPqse8C4Lo=;
        b=Ok53p5cUkWo8cU1moT01qVu8snJJ5mjp7gly+uVYK652Gz4hj3XzaY8EaOS4soXNBd
         tFJle0JsSh1Fgc6bUhz3ngWUBhhaorvdnfzI6RDWQ0ldxFPmdUpssxGuxoO7ChvmIfae
         8/lCexvd+fkJoS+8bp8kWvIeTytSSNXqTA271rvZPAlqeUj5DfmxolMRz1RhjRxpqGI+
         w5ewCGsPn7BztHyYcbxTFBXiSWMqw4If76evALuzMQk9uxg7lMVOKN5aPMCct+aHXb7O
         1siKM84Xy6a+FzXKE7zqohp/Z5pjMmQroY4auhQHmGspipLML1urj9iyf0LV2wg2Jq0i
         yLaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743728979; x=1744333779;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jwQEWgYNpeA/XdQZYs4KZSISRZNjHiSXarPqse8C4Lo=;
        b=n5OrTm5qzPT6g49mPJZ3UdLZUT7SH7a6h4Sk+ICbusXFEpljOR2dMZHrYxS7mI7l8P
         ts8h5G9ExHUbMTjZsUyRdo9b0XSIjpdsp17Bla+RjCV2mo5tDo7CFlKzIfxPMMqpIYQ9
         +UuEm1zjs3eN4SMxMZgpdYQGSNlyPFGujAjuPAaQQjpsHg/a9cbvnulic7Ob7B08Amgj
         jO+3tGh3KssJFEuYaVAjRfRg3BU8WbcxaKZOdn8W3nGlaaCy+0V7lhfZoQTOeil8zhzj
         eAvDIPsRlPsPRgne4Z6HtSHoBz5fBtMn1g0TirLr42qLA6vW5zRUZPlBzps8xGNnsHaX
         7p0A==
X-Forwarded-Encrypted: i=1; AJvYcCXIXcn3geW2wJvwwNoH+a42ZW135yYNRTTJcSmjAh1ALH6RemzNmFRy51LNWBW+5Gr18Jx6rJoi5Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YwEH5ef7QHAhLE9lWmkBiKGv4EyLmcdRs5ar8rOAFsyTyufYTos
	7gtgAgFX7uyLKvHTmseeL2r2tkrURzfBZ41Zx6pU7zyhpKR+6YJ7IENppdq/t5cS7KcBqMYUL/g
	RAARAa4v8+QVBxHaHjE4WqKD5WsK/keCdFenicxOLJts5aSDS
X-Gm-Gg: ASbGncsQrKXID/Mb25COGa60Q2BxDgF7YOnyE11vDz1AR1zruZR21QKvPln1yK1O/Z2
	+XF6viZaGIdiTIMc6wNxPnLyRBwiyxOY6uqwUDck7DJ0X4/h+titl+Ajo97bVhoqXxqvPkMCSPy
	hJlVPL/xQ6p0TozC2V5njWuUmsu2ZaM/WjUCUIcgXfGMWJ7zb/NDqI1rH8XHGifGZD1NAw0H83g
	zW1RPfTx9Pp4s4ZN66couRnyN/I8dBYcMdAzZPCs+f0JpSRJmRB9/LtFcygCwTQgOGJg3pwPiYm
	FmsBtAeQLQZUmIeuPblMV9yHNDb9+Td/3qY=
X-Google-Smtp-Source: AGHT+IFbaP0mwBaR8q8i3zD2ZnPyJe0r1qMugaz1L2sPKth/VzHKfAqr2DbO/d4t7VG2fNT5giS7BAelJDKT
X-Received: by 2002:a05:6214:409:b0:6e8:f3c3:9809 with SMTP id 6a1803df08f44-6f01e7268d0mr26670476d6.20.1743728978718;
        Thu, 03 Apr 2025 18:09:38 -0700 (PDT)
Received: from c7-smtp-2023.dev.purestorage.com ([2620:125:9017:12:36:3:5:0])
        by smtp-relay.gmail.com with ESMTPS id 6a1803df08f44-6ef0f00ec55sm4209416d6.17.2025.04.03.18.09.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Apr 2025 18:09:38 -0700 (PDT)
X-Relaying-Domain: purestorage.com
Received: from dev-ushankar.dev.purestorage.com (dev-ushankar.dev.purestorage.com [10.7.70.36])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id 844D6340166;
	Thu,  3 Apr 2025 19:09:37 -0600 (MDT)
Received: by dev-ushankar.dev.purestorage.com (Postfix, from userid 1557716368)
	id 791DFE40506; Thu,  3 Apr 2025 19:09:37 -0600 (MDT)
Date: Thu, 3 Apr 2025 19:09:37 -0600
From: Uday Shankar <ushankar@purestorage.com>
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
	linux-block@vger.kernel.org,
	Pavel Begunkov <asml.silence@gmail.com>,
	Caleb Sander Mateos <csander@purestorage.com>
Subject: Re: [PATCH] selftests: ublk: fix test_stripe_04
Message-ID: <Z+8xUR/Ocbmorisk@dev-ushankar.dev.purestorage.com>
References: <20250404001849.1443064-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250404001849.1443064-1-ming.lei@redhat.com>

On Fri, Apr 04, 2025 at 08:18:49AM +0800, Ming Lei wrote:
> Commit 57ed58c13256 ("selftests: ublk: enable zero copy for stripe target")
> added test entry of test_stripe_04, but forgot to add the test script.
> 
> So fix the test by adding the script file.
> 
> Reported-by: Uday Shankar <ushankar@purestorage.com>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>

Reviewed-by: Uday Shankar <ushankar@purestorage.com>

Thanks for the quick fix!

> ---
>  .../testing/selftests/ublk/test_stripe_04.sh  | 24 +++++++++++++++++++
>  1 file changed, 24 insertions(+)
>  create mode 100755 tools/testing/selftests/ublk/test_stripe_04.sh
> 
> diff --git a/tools/testing/selftests/ublk/test_stripe_04.sh b/tools/testing/selftests/ublk/test_stripe_04.sh
> new file mode 100755
> index 000000000000..1f2b642381d1
> --- /dev/null
> +++ b/tools/testing/selftests/ublk/test_stripe_04.sh
> @@ -0,0 +1,24 @@
> +#!/bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +
> +. "$(cd "$(dirname "$0")" && pwd)"/test_common.sh
> +
> +TID="stripe_04"
> +ERR_CODE=0
> +
> +_prep_test "stripe" "mkfs & mount & umount on zero copy"
> +
> +backfile_0=$(_create_backfile 256M)
> +backfile_1=$(_create_backfile 256M)
> +dev_id=$(_add_ublk_dev -t stripe -z -q 2 "$backfile_0" "$backfile_1")
> +_check_add_dev $TID $? "$backfile_0" "$backfile_1"
> +
> +_mkfs_mount_test /dev/ublkb"${dev_id}"
> +ERR_CODE=$?
> +
> +_cleanup_test "stripe"
> +
> +_remove_backfile "$backfile_0"
> +_remove_backfile "$backfile_1"
> +
> +_show_result $TID $ERR_CODE
> -- 
> 2.47.1
> 

