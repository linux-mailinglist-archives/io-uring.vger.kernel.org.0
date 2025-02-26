Return-Path: <io-uring+bounces-6776-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B56BDA459C4
	for <lists+io-uring@lfdr.de>; Wed, 26 Feb 2025 10:16:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CFC393A5A45
	for <lists+io-uring@lfdr.de>; Wed, 26 Feb 2025 09:16:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6CDF226D05;
	Wed, 26 Feb 2025 09:16:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="U2PeGDMQ"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F3AD1E5B85
	for <io-uring@vger.kernel.org>; Wed, 26 Feb 2025 09:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740561363; cv=none; b=GPnuc4gYZeKJGUt1YOitnGjVT+yuSemZKYjHlEz1fwUsuZR8JycgozI10XVndHsYQmWoV9OfyV1DxvLb/i3PKlIDCdUf6G7aSa1gWw52/obfhBBT4hI5bhJq/C9XMczJdAY8RS7XgJwKOoKdH79aaVd54CYlsIUU3XPk0JQMgLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740561363; c=relaxed/simple;
	bh=CDKpoa6JYhdNvryR/KXhQpYi2Cao8mIK0AzdB0jv3no=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p5hOKxYiOqk/IFPW5XJgIvEUIj9Y9ykFwLvz/FOIPaKHQWNkOb2/LwbuMhS/KjJYa7WBznFcWVQk1ZIwH2ELawPBbZehhY6sj65tO6Wgu/TyVISSKt8Mbt6TT1FOnH03Vf/YtgYAstOBYvQQzlG7Rmq0aFLWMBYPD635p5GRNAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=U2PeGDMQ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740561360;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XojtBCcr5w0szdy1IeAG4QZH1lkn1vekvukihxM9RAk=;
	b=U2PeGDMQjjKi5fa1WTKnjS8VSZ0AlvvyWhUnDBVbVKuvmc9j0XvyrhkOfj7c9tWX2AbDG1
	7GXZjpbql1zyDsobsyb+P+F/JZuaxTit+ZMy0ohOZ/1fxq4apSAzDdS2SJLsWFOoctA42A
	Pllf4nR8pTbCSfjuQb5SESQ+IrpuqVI=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-63-d5N_Dd6iMXi-VpZZyq1Rgg-1; Wed,
 26 Feb 2025 04:15:56 -0500
X-MC-Unique: d5N_Dd6iMXi-VpZZyq1Rgg-1
X-Mimecast-MFC-AGG-ID: d5N_Dd6iMXi-VpZZyq1Rgg_1740561355
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 011B4196E078;
	Wed, 26 Feb 2025 09:15:55 +0000 (UTC)
Received: from fedora (unknown [10.72.120.27])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E71EB300018D;
	Wed, 26 Feb 2025 09:15:49 +0000 (UTC)
Date: Wed, 26 Feb 2025 17:15:43 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ublk: complete command synchronously on error
Message-ID: <Z77bv8CNoPiwaf1o@fedora>
References: <20250225212456.2902549-1-csander@purestorage.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250225212456.2902549-1-csander@purestorage.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Tue, Feb 25, 2025 at 02:24:55PM -0700, Caleb Sander Mateos wrote:
> In case of an error, ublk's ->uring_cmd() functions currently return
> -EIOCBQUEUED and immediately call io_uring_cmd_done(). -EIOCBQUEUED and
> io_uring_cmd_done() are intended for asynchronous completions. For
> synchronous completions, the ->uring_cmd() function can just return the
> negative return code directly. This skips io_uring_cmd_del_cancelable(),
> and deferring the completion to task work. So return the error code
> directly from __ublk_ch_uring_cmd() and ublk_ctrl_uring_cmd().
> 
> Update ublk_ch_uring_cmd_cb(), which currently ignores the return value
> from __ublk_ch_uring_cmd(), to call io_uring_cmd_done() for synchronous
> completions.
> 
> Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>

Reviewed-by: Ming Lei <ming.lei@redhat.com>

Thanks,
Ming


