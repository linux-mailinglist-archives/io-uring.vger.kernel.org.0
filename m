Return-Path: <io-uring+bounces-1129-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BED487F4FA
	for <lists+io-uring@lfdr.de>; Tue, 19 Mar 2024 02:34:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EC14928254D
	for <lists+io-uring@lfdr.de>; Tue, 19 Mar 2024 01:34:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 050956214E;
	Tue, 19 Mar 2024 01:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OUX2Qq3s"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C97D4C90
	for <io-uring@vger.kernel.org>; Tue, 19 Mar 2024 01:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710812060; cv=none; b=H3PyN1JI2eGJv8aCcY1CKPwWE25V9ecd4ecSxTY+JqbqcACPWXEPFWUap6PpxrHfaFqDdyf1TNkzLj8dz2oIJPLFExr/tBCzxBKcDa+/z3PDi+GU96uEXkUnw78j+NboA0MjxdDt+d0yQ173HxLXDolpxVAcQoLe65e52fZ6q+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710812060; c=relaxed/simple;
	bh=8V9k8lXgPNAHSwbbO7zcFZqhQO3pjZt+ju7YG7abVnU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c/tFq65NM/ZGL86f2iK6QE6zAogwuiVIn7kNrj9aCgtWi37l6ZAJe2uDO7V6VBHmi/wpww+dr66q3dIiBXspOztKTGxdQkkFjPu4Ab211RsC77Y9EWjI85k64nnah1BK18nMz9migloGLaqDlNEjPx/FPD32x+2ZxVUrfJjsYf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OUX2Qq3s; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710812054;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CiL47lsaFfqKLmgurxyE3/xGahJ90wedsyL49MP/HU0=;
	b=OUX2Qq3sr9FnG3CpftXY9MMuUdi5u4Qj506cfFT7Fw5++skoeOjjZm9XO7PS570NUmM9A+
	p/UlPq5wZHIFW7rNoA+X3S/Dq94KJDp9le31RdrWhhTs//kik1BarhiLQffzu4xQig5R6a
	PEhiPHJ1NKlPzZZ0O395dpCKfnp5DW4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-76-_39Uz9zIM-a-5qKfTjq6xQ-1; Mon, 18 Mar 2024 21:34:08 -0400
X-MC-Unique: _39Uz9zIM-a-5qKfTjq6xQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 04D03185A781;
	Tue, 19 Mar 2024 01:34:08 +0000 (UTC)
Received: from fedora (unknown [10.72.116.95])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DCF08492BC8;
	Tue, 19 Mar 2024 01:34:04 +0000 (UTC)
Date: Tue, 19 Mar 2024 09:33:56 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org, linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>, Kanchan Joshi <joshi.k@samsung.com>
Subject: Re: [PATCH v3 02/13] io_uring/cmd: kill one issue_flags to tw
 conversion
Message-ID: <ZfjrhIRnSD0ksbeh@fedora>
References: <cover.1710799188.git.asml.silence@gmail.com>
 <c53fa3df749752bd058cf6f824a90704822d6bcc.1710799188.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c53fa3df749752bd058cf6f824a90704822d6bcc.1710799188.git.asml.silence@gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9

On Mon, Mar 18, 2024 at 10:00:24PM +0000, Pavel Begunkov wrote:
> io_uring cmd converts struct io_tw_state to issue_flags and later back
> to io_tw_state, it's awfully ill-fated, not to mention that intermediate
> issue_flags state is not correct.
> 
> Get rid of the last conversion, drag through tw everything that came
> with IO_URING_F_UNLOCKED, and replace io_req_complete_defer() with a
> direct call to io_req_complete_defer(), at least for the time being.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>

Reviewed-by: Ming Lei <ming.lei@redhat.com>

Thanks,
Ming


