Return-Path: <io-uring+bounces-1128-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B4EC187F4F1
	for <lists+io-uring@lfdr.de>; Tue, 19 Mar 2024 02:29:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7030B28242A
	for <lists+io-uring@lfdr.de>; Tue, 19 Mar 2024 01:29:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 642394428;
	Tue, 19 Mar 2024 01:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MwqvTHdi"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85F124C90
	for <io-uring@vger.kernel.org>; Tue, 19 Mar 2024 01:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710811766; cv=none; b=pxJ5dpIhvBk/GG8ZL+5mC64XkZ83VpGvGSl2ACyfd+qVWTCe8EX16N4Rb1J03iZ5cBEvW9wkyeluBonBpygORpS3gILh3LLH27V8nlHuvLaHAMhd7RI2hk3Pzb2h7h/E9JpGu5vouXFe7VzGEoXxfTR7fVxm7yXsHaz9+vmlh30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710811766; c=relaxed/simple;
	bh=RwvI02TlHaR74n7m6uzDSr1uuzDPPX0Mv/XnOnrDd9Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n4QMWNMVzOyFot2FXqXCQQPNEG/Um6WuiQ8xXfgCVVQ1dfQ66HheGo+7Aapes+G7EfhBJ9P199iVPgCYZCngFE1/lIzkRR7fiAxw/TIItiEs3GAHenexgP1ULg8sN2Ij/79+ye6IdANwIP2ESkTFX0mBS+WD1IXbXvE6f1BJQ1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MwqvTHdi; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710811763;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UOaLbKdTxqs6DhphwMrPQp4J7UgDoJxNkWKHjl0dqSU=;
	b=MwqvTHdi9a3Z2FKO8ZdCk6JdnkXJ0gOmWg749DE/9Blu9Sb467Z3YCZWzvWRgXphdQb0OS
	kU3hXiygN9OyLWrq+n38iwmEUA1su7+jietsz30ZVzXq+nohQWCz0OsHOYCxc1DFSW89Z1
	TEGLedR1jMlMCVpQaFiF2kDzh4xC2e0=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-298-7iiAI85zNRaBIt-SyGl6lg-1; Mon,
 18 Mar 2024 21:29:19 -0400
X-MC-Unique: 7iiAI85zNRaBIt-SyGl6lg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 911571C01B21;
	Tue, 19 Mar 2024 01:29:19 +0000 (UTC)
Received: from fedora (unknown [10.72.116.95])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F1AF7111E5;
	Tue, 19 Mar 2024 01:29:15 +0000 (UTC)
Date: Tue, 19 Mar 2024 09:29:07 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org, linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>, Kanchan Joshi <joshi.k@samsung.com>
Subject: Re: [PATCH v3 01/13] io_uring/cmd: move
 io_uring_try_cancel_uring_cmd()
Message-ID: <ZfjqY8biuFwHrLFR@fedora>
References: <cover.1710799188.git.asml.silence@gmail.com>
 <43a3937af4933655f0fd9362c381802f804f43de.1710799188.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <43a3937af4933655f0fd9362c381802f804f43de.1710799188.git.asml.silence@gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5

On Mon, Mar 18, 2024 at 10:00:23PM +0000, Pavel Begunkov wrote:
> io_uring_try_cancel_uring_cmd() is a part of the cmd handling so let's
> move it closer to all cmd bits into uring_cmd.c
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>

Reviewed-by: Ming Lei <ming.lei@redhat.com>


Thanks
Ming


