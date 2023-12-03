Return-Path: <io-uring+bounces-207-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5729F802452
	for <lists+io-uring@lfdr.de>; Sun,  3 Dec 2023 14:47:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8DE9A280EBD
	for <lists+io-uring@lfdr.de>; Sun,  3 Dec 2023 13:47:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A222125D5;
	Sun,  3 Dec 2023 13:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aAL9etim"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17802FC
	for <io-uring@vger.kernel.org>; Sun,  3 Dec 2023 05:47:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701611239;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=G6n4gkU3N/v7q0hGMcejn7WVq9Ifmgc/fzDPpTHt67c=;
	b=aAL9etimFsfQyEb/BUP0wsYf4vV39dCGCh83e8N8yogDyJhVt6+AbwZWf9uPsh3YP6VIAG
	Z7pHVM4XiqtzfkdxIA9CvUN+oXRuHYpVQuq/C6bPSlOpJ5WbUUMeZHgN5e4qgV3u+WhZRw
	M5a2wm6qZ6V5J1SUceJrNTqmrNcJiqc=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-617-D6NomQRIM4udpeJ_0kqM3g-1; Sun,
 03 Dec 2023 08:47:13 -0500
X-MC-Unique: D6NomQRIM4udpeJ_0kqM3g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6FDE72810D54;
	Sun,  3 Dec 2023 13:47:13 +0000 (UTC)
Received: from fedora (unknown [10.72.120.3])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AAD772026D4C;
	Sun,  3 Dec 2023 13:47:08 +0000 (UTC)
Date: Sun, 3 Dec 2023 21:47:03 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org, joshi.k@samsung.com,
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
	Paul Moore <paul@paul-moore.com>
Subject: Re: [PATCH v2 2/3] io_uring/cmd: inline io_uring_cmd_do_in_task_lazy
Message-ID: <ZWyG19/yZxT1Anqd@fedora>
References: <cover.1701391955.git.asml.silence@gmail.com>
 <2ec9fb31dd192d1c5cf26d0a2dec5657d88a8e48.1701391955.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2ec9fb31dd192d1c5cf26d0a2dec5657d88a8e48.1701391955.git.asml.silence@gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4

On Fri, Dec 01, 2023 at 12:57:36AM +0000, Pavel Begunkov wrote:
> Now as we can easily include io_uring_types.h, move IOU_F_TWQ_LAZY_WAKE
> and inline io_uring_cmd_do_in_task_lazy().
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>

Reviewed-by: Ming Lei <ming.lei@redhat.com>

Thanks,
Ming


